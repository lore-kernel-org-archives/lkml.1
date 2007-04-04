Return-Path: <linux-kernel-owner+w=401wt.eu-S2993001AbXDDSPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993001AbXDDSPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422695AbXDDSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:14:39 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39848 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934103AbXDDSNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:50 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 78/90] ARM: OMAP: TSC2101: add platform init / registration to board files
Date: Wed,  4 Apr 2007 14:05:57 -0400
Message-Id: <11757101831883-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101803962-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
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

diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index d97ff63..4438390 100644
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
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 4167f34..5ff9037 100644
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

