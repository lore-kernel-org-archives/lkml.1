Return-Path: <linux-kernel-owner+w=401wt.eu-S1030266AbXDIVax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbXDIVax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030250AbXDIVaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:30:30 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:32253 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965997AbXDIVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:30:07 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 13/14] ARM: OMAP: TSC2101: add platform init / registration to board files
Date: Mon,  9 Apr 2007 17:28:38 -0400
Message-Id: <1176154179661-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176154176346-git-send-email-tony@atomide.com>
References: <1176154119123-git-send-email-tony@atomide.com> <11761541231278-git-send-email-tony@atomide.com> <11761541282179-git-send-email-tony@atomide.com> <1176154139299-git-send-email-tony@atomide.com> <117615414325-git-send-email-tony@atomide.com> <1176154146826-git-send-email-tony@atomide.com> <11761541501423-git-send-email-tony@atomide.com> <1176154157419-git-send-email-tony@atomide.com> <117615416178-git-send-email-tony@atomide.com> <11761541643961-git-send-email-tony@atomide.com> <1176154169578-git-send-email-tony@atomide.com> <11761541721823-git-send-email-tony@atomide.com> <1176154176346-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

H2 / H3 boards use this chip, update their board files.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h2.c |   77 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap1/board-h3.c |   88 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+), 0 deletions(-)

--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -28,6 +28,9 @@
 #include <linux/mtd/partitions.h>
 #include <linux/input.h>
 #include <linux/workqueue.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/tsc2101.h>
+#include <linux/clk.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
@@ -297,6 +300,78 @@ static struct platform_device h2_lcd_device = {
 	.id		= -1,
 };
 
+struct {
+	struct clk	*mclk;
+	int		initialized;
+} h2_tsc2101;
+
+#define TSC2101_MUX_MCLK_ON	R10_1610_MCLK_ON
+#define TSC2101_MUX_MCLK_OFF	R10_1610_MCLK_OFF
+
+static int h2_tsc2101_init(struct spi_device *spi)
+{
+	int r;
+
+	if (h2_tsc2101.initialized) {
+		printk(KERN_ERR "tsc2101: already initialized\n");
+		return -ENODEV;
+	}
+
+	/* Get the MCLK */
+	h2_tsc2101.mclk = clk_get(&spi->dev, "mclk");
+	if (IS_ERR(h2_tsc2101.mclk)) {
+		dev_err(&spi->dev, "unable to get the clock MCLK\n");
+		return PTR_ERR(h2_tsc2101.mclk);
+	}
+	if ((r = clk_set_rate(h2_tsc2101.mclk, 12000000)) < 0) {
+		dev_err(&spi->dev, "unable to set rate to the MCLK\n");
+		goto err;
+	}
+
+	omap_cfg_reg(TSC2101_MUX_MCLK_OFF);
+	omap_cfg_reg(N15_1610_UWIRE_CS1);
+
+	return 0;
+err:
+	clk_put(h2_tsc2101.mclk);
+	return r;
+}
+
+static void h2_tsc2101_cleanup(struct spi_device *spi)
+{
+	clk_put(h2_tsc2101.mclk);
+	omap_cfg_reg(TSC2101_MUX_MCLK_OFF);
+}
+
+static void h2_tsc2101_enable_mclk(struct spi_device *spi)
+{
+	omap_cfg_reg(TSC2101_MUX_MCLK_ON);
+	clk_enable(h2_tsc2101.mclk);
+}
+
+static void h2_tsc2101_disable_mclk(struct spi_device *spi)
+{
+	clk_disable(h2_tsc2101.mclk);
+	omap_cfg_reg(R10_1610_MCLK_OFF);
+}
+
+static struct tsc2101_platform_data h2_tsc2101_platform_data = {
+	.init		= h2_tsc2101_init,
+	.cleanup	= h2_tsc2101_cleanup,
+	.enable_mclk	= h2_tsc2101_enable_mclk,
+	.disable_mclk	= h2_tsc2101_disable_mclk,
+};
+
+static struct spi_board_info h2_spi_board_info[] __initdata = {
+	[0] = {
+		.modalias	= "tsc2101",
+		.bus_num	= 2,
+		.chip_select	= 1,
+		.max_speed_hz	= 16000000,
+		.platform_data	= &h2_tsc2101_platform_data,
+	},
+};
+
 static struct omap_mcbsp_reg_cfg mcbsp_regs = {
 	.spcr2 = FREE | FRST | GRST | XRST | XINTM(3),
 	.spcr1 = RINTM(3) | RRST,
@@ -443,6 +518,8 @@ static void __init h2_init(void)
 #endif
 
 	platform_add_devices(h2_devices, ARRAY_SIZE(h2_devices));
+	spi_register_board_info(h2_spi_board_info,
+				ARRAY_SIZE(h2_spi_board_info));
 	omap_board_config = h2_config;
 	omap_board_config_size = ARRAY_SIZE(h2_config);
 	omap_serial_init();
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -25,6 +25,9 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/input.h>
+#include <linux/clk.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/tsc2101.h>
 
 #include <asm/setup.h>
 #include <asm/page.h>
@@ -371,6 +374,89 @@ static struct platform_device h3_lcd_device = {
 	.id		= -1,
 };
 
+struct {
+	struct clk	*mclk;
+	int		initialized;
+} h3_tsc2101;
+
+#define TSC2101_MUX_MCLK_ON	V5_1710_MCLK_ON
+#define TSC2101_MUX_MCLK_OFF	V5_1710_MCLK_OFF
+
+static int h3_tsc2101_init(struct spi_device *spi)
+{
+	u8 io_exp_val;
+	int r;
+
+	if (h3_tsc2101.initialized) {
+		printk(KERN_ERR "tsc2101: already initialized\n");
+		return -ENODEV;
+	}
+
+	/* Get the MCLK */
+	h3_tsc2101.mclk = clk_get(&spi->dev, "mclk");
+	if (IS_ERR(h3_tsc2101.mclk)) {
+		dev_err(&spi->dev, "unable to get the clock MCLK\n");
+		return PTR_ERR(h3_tsc2101.mclk);
+	}
+	if ((r = clk_set_rate(h3_tsc2101.mclk, 12000000)) < 0) {
+		dev_err(&spi->dev, "unable to set rate to the MCLK\n");
+		goto err;
+	}
+
+	if ((r = read_gpio_expa(&io_exp_val, 0x24))) {
+		dev_err(&spi->dev, "error reading from I/O EXPANDER\n");
+		goto err;
+	}
+	io_exp_val |= 0x8;
+	if ((r = write_gpio_expa(io_exp_val, 0x24))) {
+		dev_err(&spi->dev, "error writing to I/O EXPANDER\n");
+		goto err;
+	}
+
+	omap_cfg_reg(N14_1610_UWIRE_CS0);
+	omap_cfg_reg(TSC2101_MUX_MCLK_OFF);
+
+	return 0;
+err:
+	clk_put(h3_tsc2101.mclk);
+	return r;
+}
+
+static void h3_tsc2101_cleanup(struct spi_device *spi)
+{
+	clk_put(h3_tsc2101.mclk);
+	omap_cfg_reg(TSC2101_MUX_MCLK_OFF);
+}
+
+static void h3_tsc2101_enable_mclk(struct spi_device *spi)
+{
+	omap_cfg_reg(TSC2101_MUX_MCLK_ON);
+	clk_enable(h3_tsc2101.mclk);
+}
+
+static void h3_tsc2101_disable_mclk(struct spi_device *spi)
+{
+	clk_disable(h3_tsc2101.mclk);
+	omap_cfg_reg(R10_1610_MCLK_OFF);
+}
+
+static struct tsc2101_platform_data h3_tsc2101_platform_data = {
+	.init		= h3_tsc2101_init,
+	.cleanup	= h3_tsc2101_cleanup,
+	.enable_mclk	= h3_tsc2101_enable_mclk,
+	.disable_mclk	= h3_tsc2101_disable_mclk,
+};
+
+static struct spi_board_info h3_spi_board_info[] __initdata = {
+	[0] = {
+		.modalias	= "tsc2101",
+		.bus_num	= 2,
+		.chip_select	= 0,
+		.max_speed_hz	= 16000000,
+		.platform_data	= &h3_tsc2101_platform_data,
+	},
+};
+
 static struct omap_mcbsp_reg_cfg mcbsp_regs = {
 	.spcr2 = FREE | FRST | GRST | XRST | XINTM(3),
 	.spcr1 = RINTM(3) | RRST,
@@ -484,6 +570,8 @@ static void __init h3_init(void)
 	omap_cfg_reg(V2_1710_GPIO10);
 
 	platform_add_devices(devices, ARRAY_SIZE(devices));
+	spi_register_board_info(h3_spi_board_info,
+				ARRAY_SIZE(h3_spi_board_info));
 	omap_board_config = h3_config;
 	omap_board_config_size = ARRAY_SIZE(h3_config);
 	omap_serial_init();
-- 
1.4.4.2

