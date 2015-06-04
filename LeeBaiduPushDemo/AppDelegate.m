//
//  AppDelegate.m
//  LeeBaiduPushDemo
//
//  Created by Keanu Reeves on 15-6-4.
//  Copyright (c) 2015年 yuanjilee. All rights reserved.
//

#import "AppDelegate.h"
#import "BPush.h"

#define APP_KEY @"在百度云平台申请到的app_key"

@interface AppDelegate () <BPushDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // IOS8 新系统需要使用新的代码
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                       categories:nil]];
        [application registerForRemoteNotifications];
    }else{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert
         | UIRemoteNotificationTypeBadge
         | UIRemoteNotificationTypeSound];
    }
    
    [BPush registerChannel:launchOptions apiKey:APP_KEY pushMode:BPushModeDevelopment isDebug:YES];
    [BPush setDelegate:self];
    //    [BPush bindChannel];
    
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

//注册失败调用
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [BPush handleNotification:userInfo];
    NSLog(@"userinfo = %@",userInfo);
}


//回调方法
- (void)onMethod:(NSString *)method response:(NSDictionary *)data
{
    NSLog(@"response = %@\n%@",method,data);
    
    //这里可以处理跟后台的绑定操作
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end