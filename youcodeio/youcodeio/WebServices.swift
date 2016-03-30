//
//  WebServices.swift
//  youcodeio
//
//  Created by Steven WATREMEZ on 30/03/16.
//  Copyright © 2016 Steven WATREMEZ. All rights reserved.
//

import Foundation
import PromiseKit

typealias JSONDict = [String:AnyObject]
typealias JSONArray = [JSONDict]


struct WebServices {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL = NSURL(string: "https://youcode-backend.cleverapps.io/channels") // FIXME : use base URL with concat

    mutating func downloadJSONFromURl(completion: (JSONDict?) -> ()) {
        if let unwrappedQueryURL = queryURL {
            let request = NSURLRequest(URL: unwrappedQueryURL)
        
            let dataTask = session.dataTaskWithRequest(request) {
                (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
                
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                switch (httpResponse.statusCode) {
                case 200:
                    // 2: Create JSON object with data
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(receivedData, options: NSJSONReadingOptions.AllowFragments)
                            as? JSONDict
                        
                        // 3: Pass the json back to the completion handler
                        completion(jsonDictionary)
                    } catch {
                        print("error parsing json data")
                    }
                default:
                    print("GET request got response \(httpResponse.statusCode)")
                }
            }
            dataTask.resume()
        }
    }
}