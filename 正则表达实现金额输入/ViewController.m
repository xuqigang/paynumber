//
//  ViewController.m
//  正则表达实现金额输入
//
//  Created by Apple on 2017/1/6.
//  Copyright © 2017年 徐其岗. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
//屏幕尺寸
#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIFont(x) [UIFont systemFontOfSize:x]
#define SCALE [[UIScreen mainScreen] bounds].size.width / 375

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * centerTitle;

@property (nonatomic, strong) UITextField * totalPriceTextField; //总价格
@property (nonatomic, assign) NSInteger payWay; //支付方式

@property (nonatomic, strong) UIButton * yuEpayButton;
@property (nonatomic, strong) UIButton * weichatpayButton;
@property (nonatomic, strong) UIButton * alipayButton;
@property (nonatomic, strong) UIButton * oldButton;

@property (nonatomic, strong) UIButton * enterPayButton; //确定支付
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"支付方式";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
    
    NSLog(@"修改了一些东西");
}
#pragma mark---------控件设置---------
- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = YES;
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH , 568);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
                                                   
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xededed);
        [_scrollView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.width.equalTo(SCREENWIDTH);
            make.height.equalTo(8);
            
        }];
        
        UILabel * orderLabel = [[UILabel alloc] init];
        orderLabel.textColor = UIColorFromRGB(0x4a4a4a);
        orderLabel.font = UIFont(18);
        orderLabel.textAlignment = NSTextAlignmentLeft;
        orderLabel.numberOfLines = 0;
        orderLabel.text = @"充值:";
        
        [_scrollView addSubview:orderLabel];
        [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lineView.bottom).offset(20);
            make.left.equalTo(50 * SCALE);
            make.width.equalTo(45);
            make.height.equalTo(18);
        }];
        
        [_scrollView addSubview:self.totalPriceTextField];
        [self.totalPriceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(orderLabel.top);
            make.left.equalTo(orderLabel.right).offset(5);
            make.width.equalTo(SCREENWIDTH - 2 * 50 * SCALE - 5 - 45);
            make.height.equalTo(18);
            
        }];
        
        UIView * lineView11 = [[UIView alloc] init];
        lineView11.backgroundColor = UIColorFromRGB(0xededed);
        [_scrollView addSubview:lineView11];
        [lineView11 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.totalPriceTextField.bottom).offset(5);
            make.left.equalTo(self.totalPriceTextField.left);
            make.right.equalTo(self.totalPriceTextField.right);
            make.height.equalTo(1);
        }];
        
        
        UIView * lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = UIColorFromRGB(0xededed);
        [_scrollView addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(orderLabel.bottom).offset(20);
            make.centerX.equalTo(0);
            make.width.equalTo(SCREENWIDTH);
            make.height.equalTo(8);
        }];
        
        
        UILabel * payWayLabel = [[UILabel alloc] init];
        payWayLabel.textColor = UIColorFromRGB(0x4a4a4a);
        payWayLabel.font = UIFont(18);
        payWayLabel.textAlignment = NSTextAlignmentLeft;
        payWayLabel.numberOfLines = 0;
        payWayLabel.text = @"支付方式";
        
        [_scrollView addSubview:payWayLabel];
        [payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lineView1.bottom).offset(20);
            make.left.equalTo(50 * SCALE);
            make.width.equalTo(75);
            make.height.equalTo(18);
            
        }];
        
        self.yuEpayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.yuEpayButton.tag = 1;
        self.yuEpayButton.selected = YES;
        self.oldButton = self.yuEpayButton;
        
        [_scrollView layoutIfNeeded];
        UIView * yuEview = [self getPayWayView:@"icon_yue" title:@"余额支付" button:self.yuEpayButton];
        
        [_scrollView addSubview:yuEview];
        [yuEview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(payWayLabel.bottom).offset(30);
            
            make.centerX.equalTo(0);
            make.width.equalTo(SCREENWIDTH - 2 * 55 *SCALE);
            make.height.equalTo(34);
            
        }];
        [yuEview layoutIfNeeded];
        NSLog(@"yueview = %@",yuEview);
        
        self.weichatpayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.weichatpayButton.tag = 2;
        
        UIView * weichatView = [self getPayWayView:@"icon_wx" title:@"微信支付" button:self.weichatpayButton];
        [_scrollView layoutIfNeeded];
        [_scrollView addSubview:weichatView];
        [weichatView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(yuEview.bottom).offset(12);
            make.centerX.equalTo(0);
            make.width.equalTo(SCREENWIDTH - 2 * 55 *SCALE);
            make.height.equalTo(34);
            
        }];
        [weichatView layoutIfNeeded];
        self.alipayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.alipayButton.tag = 3;
        
        UIView * alipayView = [self getPayWayView:@"icon_alipay" title:@"支付宝支付" button:self.alipayButton];
        [_scrollView layoutIfNeeded];
        [_scrollView addSubview:alipayView];
        [alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weichatView.bottom).offset(12);
            make.centerX.equalTo(0);
            make.width.equalTo(SCREENWIDTH - 2 * 55 *SCALE);
            make.height.equalTo(34);
            
        }];
        
        [_scrollView addSubview:self.enterPayButton];
        [self.enterPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alipayView.bottom).offset(28);
            make.centerX.equalTo(0);
            make.width.equalTo(SCREENWIDTH - 2 * 37 * SCALE);
            make.height.equalTo(41);
        }];
    }
    return _scrollView;
}

- (UITextField *) totalPriceTextField
{
    if (!_totalPriceTextField) {
        
        _totalPriceTextField = [[UITextField alloc] init];
        _totalPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _totalPriceTextField.placeholder = @"请填写充值金额";
        _totalPriceTextField.font = UIFont(14);
        _totalPriceTextField.delegate = self;
    }
    return _totalPriceTextField;
}

- (UIView *) getPayWayView:(NSString *) imageName title:(NSString *) title button:(UIButton *) button
{
    UIView * backgoundView = [[UIView alloc] init];
    backgoundView.userInteractionEnabled = YES;
    //    backgoundView.backgroundColor = [UIColor blueColor];
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    [backgoundView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.top.equalTo(0);
        make.width.equalTo(34);
        
    }];
    UILabel * payWayLabel = [[UILabel alloc] init];
    payWayLabel.textColor = UIColorFromRGB(0x4a4a4a);
    payWayLabel.font = UIFont(17);
    payWayLabel.textAlignment = NSTextAlignmentLeft;
    payWayLabel.numberOfLines = 0;
    payWayLabel.text = title;
    
    [backgoundView addSubview:payWayLabel];
    [payWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imageView.right).offset(20);
        make.width.equalTo(90);
        make.height.equalTo(17);
        make.centerY.equalTo(0);
        
    }];
    
    [button setImage:[UIImage imageNamed:@"dx_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"dx_normal"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"dx_normal"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"dx_select"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(payWayClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgoundView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.top.equalTo(0);
        make.width.equalTo(34);
        make.right.equalTo(0);
        
    }];
    return backgoundView;
}
- (UILabel *) centerTitle
{
    if (!_centerTitle) {
        
        _centerTitle = [[UILabel alloc] init];
        _centerTitle.textAlignment = NSTextAlignmentCenter;
        _centerTitle.textColor = UIColorFromRGB(0x2dcded);
        _centerTitle.font = [UIFont boldSystemFontOfSize:18];
        _centerTitle.text = @"标题";
        
    }
    return _centerTitle;
}
- (UIButton *) enterPayButton
{
    if (!_enterPayButton) {
        _enterPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterPayButton.tag = 0;
        [_enterPayButton setTitle:@"确定支付" forState:UIControlStateNormal];
        [_enterPayButton setTitle:@"确定支付" forState:UIControlStateSelected];
        [_enterPayButton setTitle:@"确定支付" forState:UIControlStateSelected|UIControlStateHighlighted];
        _enterPayButton.layer.cornerRadius = 20;
        _enterPayButton.backgroundColor = UIColorFromRGB(0x2dcded);
        _enterPayButton.titleLabel.font = UIFont(16);
        [_enterPayButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_enterPayButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        [_enterPayButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected|UIControlStateHighlighted];
        
        [_enterPayButton addTarget:self action:@selector(enterPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterPayButton;
}

#pragma mark-----------点击事件------------
- (void) payWayClick:(UIButton *) button
{
    if (self.oldButton) {
        self.oldButton.selected = NO;
        
    }
    button.selected = YES;
    self.oldButton = button;
    
}
- (void) enterPayButtonClick:(UIButton *) button
{
    NSLog(@"确认支付点击");
    //获取订单状态
}

#pragma mark------------UITextFieldDelegate---------------
//限制只能输入金额的正则表达式
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //匹配以0开头的数字
    NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
    //匹配两位小数、整数
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] ? YES : NO;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
