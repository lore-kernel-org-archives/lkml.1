Return-Path: <linux-kernel-owner+w=401wt.eu-S965982AbXDIVne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965982AbXDIVne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965996AbXDIVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:43:23 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:32198 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965995AbXDIVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:30:04 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 12/14] ARM: OMAP: N770: add missing LCD, LCD controller, touchscreen device registration
Date: Mon,  9 Apr 2007 17:28:37 -0400
Message-Id: <1176154176346-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761541721823-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com> <1176154139299-git-send-email-tony@atomide.com> <117615414325-git-send-email-tony@atomide.com> <1176154146826-git-send-email-tony@atomide.com> <11761541501423-git-send-email-tony@atomide.com> <1176154157419-git-send-email-tony@atomide.com> <117615416178-git-send-email-tony@atomide.com> <11761541643961-git-send-email-tony@atomide.com> <1176154169578-git-send-email-tony@atomide.com> <11761541721823-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

These were left out from the board file when merging these drivers,
add them here.

Call GPIO init from the board file as well, since the platform device init
code uses the GPIO API.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-nokia770.c |   88 ++++++++++++++++++++++++++++++++++
 1 files changed, 88 insertions(+), 0 deletions(-)

--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -33,9 +33,14 @@
 #include <asm/arch/dsp_common.h>
 #include <asm/arch/aic23.h>
 #include <asm/arch/gpio.h>
+#include <asm/arch/omapfb.h>
+#include <asm/arch/hwa742.h>
+#include <asm/arch/lcd_mipid.h>
 
 #include "../plat-omap/dsp/dsp_common.h"
 
+#define ADS7846_PENDOWN_GPIO	15
+
 static void __init omap_nokia770_init_irq(void)
 {
 	/* On Nokia 770, the SleepX signal is masked with an
@@ -96,6 +101,41 @@ static struct platform_device *nokia770_devices[] __initdata = {
 	&nokia770_kp_device,
 };
 
+static void mipid_shutdown(struct mipid_platform_data *pdata)
+{
+	if (pdata->nreset_gpio != -1) {
+		printk(KERN_INFO "shutdown LCD\n");
+		omap_set_gpio_dataout(pdata->nreset_gpio, 0);
+		msleep(120);
+	}
+}
+
+static struct mipid_platform_data nokia770_mipid_platform_data = {
+	.shutdown = mipid_shutdown,
+};
+
+static void mipid_dev_init(void)
+{
+	const struct omap_lcd_config *conf;
+
+	conf = omap_get_config(OMAP_TAG_LCD, struct omap_lcd_config);
+	if (conf != NULL) {
+		nokia770_mipid_platform_data.nreset_gpio = conf->nreset_gpio;
+		nokia770_mipid_platform_data.data_lines = conf->data_lines;
+	}
+}
+
+static void ads7846_dev_init(void)
+{
+	if (omap_request_gpio(ADS7846_PENDOWN_GPIO) < 0)
+		printk(KERN_ERR "can't get ads7846 pen down GPIO\n");
+}
+
+static int ads7846_get_pendown_state(void)
+{
+	return !omap_get_gpio_datain(ADS7846_PENDOWN_GPIO);
+}
+
 static struct ads7846_platform_data nokia770_ads7846_platform_data __initdata = {
 	.x_max		= 0x0fff,
 	.y_max		= 0x0fff,
@@ -103,6 +143,8 @@ static struct ads7846_platform_data nokia770_ads7846_platform_data __initdata =
 	.pressure_max	= 255,
 	.debounce_max	= 10,
 	.debounce_tol	= 3,
+	.debounce_rep	= 1,
+	.get_pendown_state	= ads7846_get_pendown_state,
 };
 
 static struct spi_board_info nokia770_spi_board_info[] __initdata = {
@@ -111,6 +153,7 @@ static struct spi_board_info nokia770_spi_board_info[] __initdata = {
 		.bus_num        = 2,
 		.chip_select    = 3,
 		.max_speed_hz   = 12000000,
+		.platform_data	= &nokia770_mipid_platform_data,
 	},
 	[1] = {
 		.modalias       = "ads7846",
@@ -122,6 +165,47 @@ static struct spi_board_info nokia770_spi_board_info[] __initdata = {
 	},
 };
 
+static struct {
+	struct clk *sys_ck;
+} hwa742;
+
+static int hwa742_get_clocks(void)
+{
+	hwa742.sys_ck = clk_get(NULL, "bclk");
+	if (IS_ERR(hwa742.sys_ck)) {
+		printk(KERN_ERR "can't get HWA742 clock\n");
+		return PTR_ERR(hwa742.sys_ck);
+	}
+	return 0;
+}
+
+static unsigned long hwa742_get_clock_rate(struct device *dev)
+{
+	return clk_get_rate(hwa742.sys_ck);
+}
+
+static void hwa742_power_up(struct device *dev)
+{
+	clk_enable(hwa742.sys_ck);
+}
+
+static void hwa742_power_down(struct device *dev)
+{
+	clk_disable(hwa742.sys_ck);
+}
+
+static struct hwa742_platform_data nokia770_hwa742_platform_data = {
+	.get_clock_rate	= hwa742_get_clock_rate,
+	.power_up	= hwa742_power_up,
+	.power_down	= hwa742_power_down,
+	.te_connected	= 1,
+};
+
+static void hwa742_dev_init(void)
+{
+	hwa742_get_clocks();
+	omapfb_set_ctrl_platform_data(&nokia770_hwa742_platform_data);
+}
 
 /* assume no Mini-AB port */
 
@@ -287,8 +371,12 @@ static void __init omap_nokia770_init(void)
 				ARRAY_SIZE(nokia770_spi_board_info));
 	omap_board_config = nokia770_config;
 	omap_board_config_size = ARRAY_SIZE(nokia770_config);
+	omap_gpio_init();
 	omap_serial_init();
 	omap_dsp_init();
+	hwa742_dev_init();
+	ads7846_dev_init();
+	mipid_dev_init();
 }
 
 static void __init omap_nokia770_map_io(void)
-- 
1.4.4.2

