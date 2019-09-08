//
//  ViewController.m
//  flutterTest
//
//  Created by zhouyang on 2019/9/8.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.btn];
}

- (void)btnClick:(UIButton *)sender {
    [self openCustomPage:@"/"];
}

-(void)openCustomPage:(NSString *)router {
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] init];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    flutterViewController.view.backgroundColor = [UIColor whiteColor];
    flutterViewController.splashScreenView = nil;
    [flutterViewController setInitialRoute:router];
    
    [self setChannelPlatform:flutterViewController];
    [self.navigationController pushViewController:flutterViewController animated:YES];
}

- (void)setChannelPlatform:(FlutterViewController *)vc {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"banlv_channel" binaryMessenger:vc];
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"router.open"]) {
            [self routerOpen:call result:result];
        }else if ([call.method isEqualToString:@"floor_home_page_data"]) {
            NSData *floorData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"floorData" ofType:@"json"]];
            NSArray *floors = [NSJSONSerialization JSONObjectWithData:floorData options:kNilOptions error:nil];
            NSDictionary *dic = @{@"code": @(200), @"data": floors};
            result([self jsonToString:dic]);
        }else if ([call.method isEqualToString:@"album_detail_list"]) {
            NSData *trackData = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tracks" ofType:@"json"]];
            NSArray *tracks = [NSJSONSerialization JSONObjectWithData:trackData options:kNilOptions error:nil];
            NSDictionary *dic = @{@"code": @(200), @"data": tracks};
            result([self jsonToString:dic]);
        }
    }];
}

- (void)routerOpen:(FlutterMethodCall *)call result:(FlutterResult)result {
    
    NSDictionary *param = call.arguments;
    FlutterViewController *flutterViewController = [[FlutterViewController alloc] init];
    [self setChannelPlatform:flutterViewController];
    [GeneratedPluginRegistrant registerWithRegistry:flutterViewController];
    flutterViewController.view.backgroundColor = [UIColor whiteColor];
    flutterViewController.splashScreenView = nil;
    [flutterViewController setInitialRoute:param[@"urlScheme"]];
    [flutterViewController setTitle:param[@"title"]];
    [self.navigationController pushViewController:flutterViewController animated:YES];
}

- (NSString*)jsonToString:(NSDictionary *)dic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:0];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark --
-(UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
        [_btn setTitle:@"pushFlutter" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end
