//
//  ContentView.swift
//  CoreML Project
//
//  Created by python on 17/11/23.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    let images = ["1","2","3","4"]
    @State private var currentIndex = 0
    
    let model = try! MobileNetV2(configuration: MLModelConfiguration())
    var body: some View {
        VStack{
            Image(images[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            HStack{
                Button("Previous"){
                    currentIndex -= 1
                }
                .buttonStyle(.bordered)
                .disabled(currentIndex == 0)
                
                Button("Next"){
                    currentIndex += 1
                }
                .buttonStyle(.bordered)
                .disabled(currentIndex == images.count - 1)
            }
            Button("Predict"){
                
                guard let uiImage = UIImage(named: images[currentIndex]) else {
                    return
                }
                
                let resizedImage = uiImage.resize(to: CGSize(width: 224, height: 224))
                
                guard let buffer = resizedImage.toCVPixelBuffer() else { return }
                
                do{
                    let prediction = try model.prediction(image: buffer)
                    print(prediction.classLabel)
                }
                catch{
                    print(error.localizedDescription)
                }
                
            }
            .buttonStyle(.borderedProminent)
            
            List(1...10, id: \.self){index in
                Text("Prediction \(index)")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
