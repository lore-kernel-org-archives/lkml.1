Return-Path: <linux-kernel-owner+w=401wt.eu-S934105AbXDDSNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbXDDSNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934100AbXDDSNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:41 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39556 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934090AbXDDSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:23 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 72/90] ARM: OMAP: N770: add missing LCD, LCD controller, touchscreen device registration
Date: Wed,  4 Apr 2007 14:05:51 -0400
Message-Id: <11757101661984-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101613869-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
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

diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 8ea0cef..acb2331 100644
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

