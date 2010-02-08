Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab0BHGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:25:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab0BHGZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:25:25 -0500
Date: Mon, 8 Feb 2010 17:25:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vaibhav Hiremath <hvaibhav@ti.com>, Tony Lindgren <tony@atomide.com>,
       <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the omap_dss2 tree with the omap tree
Message-Id: <20100208172521.abb500b4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-am3517evm.c between commit
13560d875d67c06239c82a6148c1b87075701fe9 ("AM3517: Enable basic I2C
Support") from the omap tree and commit
56a3d0235cd50d14d7bd4d45e55d192aa0e78cac ("OMAP: AM3517: Enable DSS2 for
AM3517EVM board") from the omap_dss2 tree.

Juts overlapping additions.   I fixed it up (see below) and can carry the
fix as necessary.

P.S. Tomi, this omap_dss2 commit only has your Acked-by not Signed-off-by.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-am3517evm.c
index a166bcc,54af5f8..0000000
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@@ -33,15 -33,147 +34,156 @@@
  
  #include "mux.h"
  
+ #define LCD_PANEL_PWR		176
+ #define LCD_PANEL_BKLIGHT_PWR	182
+ #define LCD_PANEL_PWM		181
+ 
+ static int lcd_enabled;
+ static int dvi_enabled;
+ 
+ static void __init am3517_evm_display_init(void)
+ {
+ 	int r;
+ 
+ 	omap_mux_init_gpio(LCD_PANEL_PWR, OMAP_PIN_INPUT_PULLUP);
+ 	omap_mux_init_gpio(LCD_PANEL_BKLIGHT_PWR, OMAP_PIN_INPUT_PULLDOWN);
+ 	omap_mux_init_gpio(LCD_PANEL_PWM, OMAP_PIN_INPUT_PULLDOWN);
+ 	/*
+ 	 * Enable GPIO 182 = LCD Backlight Power
+ 	 */
+ 	r = gpio_request(LCD_PANEL_BKLIGHT_PWR, "lcd_backlight_pwr");
+ 	if (r) {
+ 		printk(KERN_ERR "failed to get lcd_backlight_pwr\n");
+ 		return;
+ 	}
+ 	gpio_direction_output(LCD_PANEL_BKLIGHT_PWR, 1);
+ 	/*
+ 	 * Enable GPIO 181 = LCD Panel PWM
+ 	 */
+ 	r = gpio_request(LCD_PANEL_PWM, "lcd_pwm");
+ 	if (r) {
+ 		printk(KERN_ERR "failed to get lcd_pwm\n");
+ 		goto err_1;
+ 	}
+ 	gpio_direction_output(LCD_PANEL_PWM, 1);
+ 	/*
+ 	 * Enable GPIO 176 = LCD Panel Power enable pin
+ 	 */
+ 	r = gpio_request(LCD_PANEL_PWR, "lcd_panel_pwr");
+ 	if (r) {
+ 		printk(KERN_ERR "failed to get lcd_panel_pwr\n");
+ 		goto err_2;
+ 	}
+ 	gpio_direction_output(LCD_PANEL_PWR, 1);
+ 
+ 	printk(KERN_INFO "Display initialized successfully\n");
+ 	return;
+ 
+ err_2:
+ 	gpio_free(LCD_PANEL_PWM);
+ err_1:
+ 	gpio_free(LCD_PANEL_BKLIGHT_PWR);
+ }
+ 
+ static int am3517_evm_panel_enable_lcd(struct omap_dss_device *dssdev)
+ {
+ 	if (dvi_enabled) {
+ 		printk(KERN_ERR "cannot enable LCD, DVI is enabled\n");
+ 		return -EINVAL;
+ 	}
+ 	gpio_set_value(LCD_PANEL_PWR, 1);
+ 	lcd_enabled = 1;
+ 
+ 	return 0;
+ }
+ 
+ static void am3517_evm_panel_disable_lcd(struct omap_dss_device *dssdev)
+ {
+ 	gpio_set_value(LCD_PANEL_PWR, 0);
+ 	lcd_enabled = 0;
+ }
+ 
+ static struct omap_dss_device am3517_evm_lcd_device = {
+ 	.type			= OMAP_DISPLAY_TYPE_DPI,
+ 	.name			= "lcd",
+ 	.driver_name		= "sharp_lq_panel",
+ 	.phy.dpi.data_lines 	= 16,
+ 	.platform_enable	= am3517_evm_panel_enable_lcd,
+ 	.platform_disable	= am3517_evm_panel_disable_lcd,
+ };
+ 
+ static int am3517_evm_panel_enable_tv(struct omap_dss_device *dssdev)
+ {
+ 	return 0;
+ }
+ 
+ static void am3517_evm_panel_disable_tv(struct omap_dss_device *dssdev)
+ {
+ }
+ 
+ static struct omap_dss_device am3517_evm_tv_device = {
+ 	.type 			= OMAP_DISPLAY_TYPE_VENC,
+ 	.name 			= "tv",
+ 	.driver_name		= "venc",
+ 	.phy.venc.type		= OMAP_DSS_VENC_TYPE_SVIDEO,
+ 	.platform_enable	= am3517_evm_panel_enable_tv,
+ 	.platform_disable	= am3517_evm_panel_disable_tv,
+ };
+ 
+ static int am3517_evm_panel_enable_dvi(struct omap_dss_device *dssdev)
+ {
+ 	if (lcd_enabled) {
+ 		printk(KERN_ERR "cannot enable DVI, LCD is enabled\n");
+ 		return -EINVAL;
+ 	}
+ 	dvi_enabled = 1;
+ 
+ 	return 0;
+ }
+ 
+ static void am3517_evm_panel_disable_dvi(struct omap_dss_device *dssdev)
+ {
+ 	dvi_enabled = 0;
+ }
+ 
+ static struct omap_dss_device am3517_evm_dvi_device = {
+ 	.type			= OMAP_DISPLAY_TYPE_DPI,
+ 	.name			= "dvi",
+ 	.driver_name		= "generic_panel",
+ 	.phy.dpi.data_lines	= 24,
+ 	.platform_enable	= am3517_evm_panel_enable_dvi,
+ 	.platform_disable	= am3517_evm_panel_disable_dvi,
+ };
+ 
+ static struct omap_dss_device *am3517_evm_dss_devices[] = {
+ 	&am3517_evm_lcd_device,
+ 	&am3517_evm_tv_device,
+ 	&am3517_evm_dvi_device,
+ };
+ 
+ static struct omap_dss_board_info am3517_evm_dss_data = {
+ 	.num_devices	= ARRAY_SIZE(am3517_evm_dss_devices),
+ 	.devices	= am3517_evm_dss_devices,
+ 	.default_device	= &am3517_evm_lcd_device,
+ };
+ 
+ struct platform_device am3517_evm_dss_device = {
+ 	.name		= "omapdss",
+ 	.id		= -1,
+ 	.dev		= {
+ 		.platform_data	= &am3517_evm_dss_data,
+ 	},
+ };
+ 
 +static int __init am3517_evm_i2c_init(void)
 +{
 +	omap_register_i2c_bus(1, 400, NULL, 0);
 +	omap_register_i2c_bus(2, 400, NULL, 0);
 +	omap_register_i2c_bus(3, 400, NULL, 0);
 +
 +	return 0;
 +}
 +
  /*
   * Board initialization
   */
