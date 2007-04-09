Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbXDIVhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbXDIVhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbXDIVen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:34:43 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:35218 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXDIVe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:34:29 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3/7] ARM: OMAP: Sync H4 board init with linux-omap
Date: Mon,  9 Apr 2007 17:33:58 -0400
Message-Id: <11761544523253-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761544492069-git-send-email-tony@atomide.com>
References: <11761544421667-git-send-email-tony@atomide.com> <11761544452798-git-send-email-tony@atomide.com> <11761544492069-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch syncs H4 board init with linux-omap tree.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-h4.c        |  180 +++++++++++++++++++++++++++++++--
 10 files changed, 380 insertions(+), 176 deletions(-)

--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -19,6 +19,8 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 #include <linux/input.h>
+#include <linux/err.h>
+#include <linux/clk.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
@@ -36,10 +38,14 @@
 #include <asm/arch/keypad.h>
 #include <asm/arch/menelaus.h>
 #include <asm/arch/dma.h>
+#include <asm/arch/gpmc.h>
 #include "prcm-regs.h"
 
 #include <asm/io.h>
 
+#define H4_FLASH_CS	0
+#define H4_SMC91X_CS	1
+
 static unsigned int row_gpios[6] = { 88, 89, 124, 11, 6, 96 };
 static unsigned int col_gpios[7] = { 90, 91, 100, 36, 12, 97, 98 };
 
@@ -116,8 +122,6 @@ static struct flash_platform_data h4_flash_data = {
 };
 
 static struct resource h4_flash_resource = {
-	.start		= H4_CS0_BASE,
-	.end		= H4_CS0_BASE + SZ_64M - 1,
 	.flags		= IORESOURCE_MEM,
 };
 
@@ -133,6 +137,7 @@ static struct platform_device h4_flash_device = {
 
 /* Select between the IrDA and aGPS module
  */
+#if defined(CONFIG_OMAP_IR) || defined(CONFIG_OMAP_IR_MODULE)
 static int h4_select_irda(struct device *dev, int state)
 {
 	unsigned char expa;
@@ -192,6 +197,10 @@ static int h4_transceiver_mode(struct device *dev, int mode)
 
 	return 0;
 }
+#else
+static int h4_select_irda(struct device *dev, int state) { return 0; }
+static int h4_transceiver_mode(struct device *dev, int mode) { return 0; }
+#endif
 
 static struct omap_irda_config h4_irda_data = {
 	.transceiver_cap	= IR_SIRMODE | IR_MIRMODE | IR_FIRMODE,
@@ -253,16 +262,80 @@ static struct platform_device *h4_devices[] __initdata = {
 	&h4_lcd_device,
 };
 
+/* 2420 Sysboot setup (2430 is different) */
+static u32 get_sysboot_value(void)
+{
+	return (omap_readl(OMAP242X_CONTROL_STATUS) & 0xFFF);
+}
+
+/* FIXME: This function should be moved to some other file, gpmc.c? */
+
+/* H4-2420's always used muxed mode, H4-2422's always use non-muxed
+ *
+ * Note: OMAP-GIT doesn't correctly do is_cpu_omap2422 and is_cpu_omap2423
+ *  correctly.  The macro needs to look at production_id not just hawkeye.
+ */
+static u32 is_gpmc_muxed(void)
+{
+	u32 mux;
+	mux = get_sysboot_value();
+	if ((mux & 0xF) == 0xd)
+		return 1;	/* NAND config (could be either) */
+	if (mux & 0x2)		/* if mux'ed */
+		return 1;
+	else
+		return 0;
+}
+
 static inline void __init h4_init_debug(void)
 {
+	int eth_cs;
+	unsigned long cs_mem_base;
+	unsigned int muxed, rate;
+	struct clk *l3ck;
+
+	eth_cs	= H4_SMC91X_CS;
+
+	l3ck = clk_get(NULL, "core_l3_ck");
+	if (IS_ERR(l3ck))
+		rate = 100000000;
+	else
+		rate = clk_get_rate(l3ck);
+
+	if (is_gpmc_muxed())
+		muxed = 0x200;
+	else
+		muxed = 0;
+
 	/* Make sure CS1 timings are correct */
-	GPMC_CONFIG1_1 = 0x00011200;
-	GPMC_CONFIG2_1 = 0x001f1f01;
-	GPMC_CONFIG3_1 = 0x00080803;
-	GPMC_CONFIG4_1 = 0x1c091c09;
-	GPMC_CONFIG5_1 = 0x041f1f1f;
-	GPMC_CONFIG6_1 = 0x000004c4;
-	GPMC_CONFIG7_1 = 0x00000f40 | (0x08000000 >> 24);
+	gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG1,
+			  0x00011000 | muxed);
+
+	if (rate >= 160000000) {
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f01);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080803);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1c0b1c0a);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x041f1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000004C4);
+	} else if (rate >= 130000000) {
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f00);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080802);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1C091C09);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x041f1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000004C4);
+	} else {/* rate = 100000000 */
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG2, 0x001f1f00);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG3, 0x00080802);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG4, 0x1C091C09);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG5, 0x031A1F1F);
+		gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG6, 0x000003C2);
+	}
+
+	if (gpmc_cs_request(eth_cs, SZ_16M, &cs_mem_base) < 0) {
+		printk(KERN_ERR "Failed to request GPMC mem for smc91x\n");
+		return;
+	}
+
 	udelay(100);
 
 	omap_cfg_reg(M15_24XX_GPIO92);
@@ -270,11 +343,24 @@ static inline void __init h4_init_debug(void)
 		gpmc_cs_free(eth_cs);
 }
 
+static void __init h4_init_flash(void)
+{
+	unsigned long base;
+
+	if (gpmc_cs_request(H4_FLASH_CS, SZ_64M, &base) < 0) {
+		printk("Can't request GPMC CS for flash\n");
+		return;
+	}
+	h4_flash_resource.start	= base;
+	h4_flash_resource.end	= base + SZ_64M - 1;
+}
+
 static void __init omap_h4_init_irq(void)
 {
 	omap2_init_common_hw();
 	omap_init_irq();
 	omap_gpio_init();
+	h4_init_flash();
 }
 
 static struct omap_uart_config h4_uart_config __initdata = {
@@ -336,9 +422,75 @@ static struct omap_board_config_kernel h4_config[] = {
 	{ OMAP_TAG_UART,	&h4_uart_config },
 	{ OMAP_TAG_MMC,		&h4_mmc_config },
 	{ OMAP_TAG_LCD,		&h4_lcd_config },
-	{ OMAP_TAG_USB,	&h4_usb_config },
+	{ OMAP_TAG_USB,		&h4_usb_config },
 };
 
+#ifdef	CONFIG_MACH_OMAP_H4_TUSB
+
+#include <linux/usb/musb.h>
+
+static struct musb_hdrc_platform_data tusb_data = {
+	.mode		= MUSB_OTG,
+	.min_power	= 25,	/* x2 = 50 mA drawn from VBUS as peripheral */
+
+	/* 1.8V supplied by Menelaus, other voltages supplied by VBAT;
+	 * so no switching.
+	 */
+};
+
+static void __init tusb_evm_setup(void)
+{
+	static char	announce[] __initdata =
+				KERN_INFO "TUSB 6010 EVM\n";
+	int		irq;
+	unsigned	dmachan = 0;
+
+	/* There are at least 32 different combinations of boards that
+	 * are loosely called "H4", with a 2420 ... different OMAP chip
+	 * revisions (with pin mux changes for DMAREQ, GPMC errata, etc),
+	 * modifications of the CPU board, mainboard, EVM, TUSB etc.
+	 * Plus omap2422, omap2423, etc.
+	 *
+	 * So you might need to tweak this setup to make the TUSB EVM
+	 * behave on your particular setup ...
+	 */
+
+	/* Already set up:  GPMC AD[0..15], CLK, nOE, nWE, nADV_ALE */
+	omap_cfg_reg(E2_GPMC_NCS2);
+	omap_cfg_reg(L2_GPMC_NCS7);
+	omap_cfg_reg(M1_GPMC_WAIT2);
+
+	switch ((system_rev >> 8) & 0x0f) {
+	case 0:		/* ES 1.0 */
+	case 1:		/* ES 2.0 */
+		/* Assume early board revision without optional ES2.0
+		 * rework to swap J15 & AA10 so DMAREQ0 works
+		 */
+		omap_cfg_reg(AA10_242X_GPIO13);
+		irq = 13;
+		// omap_cfg_reg(J15_24XX_DMAREQ0);
+		break;
+	default:
+		/* Later Menelaus boards can support all 6 DMA request
+		 * lines, at the price of boot flash A23-A26.
+		 */
+		omap_cfg_reg(J15_24XX_GPIO99);
+		irq = 99;
+		omap_cfg_reg(AA10_242X_DMAREQ0);
+		omap_cfg_reg(AA6_242X_DMAREQ1);
+		dmachan = (1 << 1) | (1 << 0);
+		break;
+	}
+
+	if (tusb6010_setup_interface(&tusb_data,
+			TUSB6010_REFCLK_24, /* waitpin */ 2,
+			/* async cs */ 2, /* sync cs */ 7,
+			irq, dmachan) == 0)
+		printk(announce);
+}
+
+#endif
+
 static void __init omap_h4_init(void)
 {
 	/*
@@ -371,6 +523,14 @@ static void __init omap_h4_init(void)
 	omap_board_config = h4_config;
 	omap_board_config_size = ARRAY_SIZE(h4_config);
 	omap_serial_init();
+
+	/* smc91x, debug leds, ps/2, extra uarts */
+	h4_init_debug();
+
+#ifdef	CONFIG_MACH_OMAP_H4_TUSB
+	tusb_evm_setup();
+#endif
+
 }
 
 static void __init omap_h4_map_io(void)
-- 
1.4.4.2

