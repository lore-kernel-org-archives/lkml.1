Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbXDIVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbXDIVek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXDIVek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:34:40 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:35290 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXDIVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:34:36 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4/7] ARM: OMAP: cleanup apollon board
Date: Mon,  9 Apr 2007 17:33:59 -0400
Message-Id: <11761544544019-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761544523253-git-send-email-tony@atomide.com>
References: <11761544421667-git-send-email-tony@atomide.com> <11761544452798-git-send-email-tony@atomide.com> <11761544492069-git-send-email-tony@atomide.com> <11761544523253-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

- Add etherent gpmc handling
- Remove unused mux setting
- Add MMC switch pin comments

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-apollon.c |   50 ++++++++++++++++++++++++++--------
 1 files changed, 38 insertions(+), 12 deletions(-)

--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -27,6 +27,8 @@
 #include <linux/delay.h>
 #include <linux/leds.h>
 #include <linux/irq.h>
+#include <linux/err.h>
+#include <linux/clk.h>
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
@@ -187,16 +189,42 @@ static struct platform_device *apollon_devices[] __initdata = {
 static inline void __init apollon_init_smc91x(void)
 {
 	unsigned long base;
+	unsigned int rate;
+	struct clk *l3ck;
+	int eth_cs;
+
+	l3ck = clk_get(NULL, "core_l3_ck");
+	if (IS_ERR(l3ck))
+		rate = 100000000;
+	else
+		rate = clk_get_rate(l3ck);
+
+	eth_cs = APOLLON_ETH_CS;
 
 	/* Make sure CS1 timings are correct */
-	GPMC_CONFIG1_1 = 0x00011203;
-	GPMC_CONFIG2_1 = 0x001f1f01;
-	GPMC_CONFIG3_1 = 0x00080803;
-	GPMC_CONFIG4_1 = 0x1c091c09;
-	GPMC_CONFIG5_1 = 0x041f1f1f;
-	GPMC_CONFIG6_1 = 0x000004c4;
-
-	if (gpmc_cs_request(APOLLON_ETH_CS, SZ_16M, &base) < 0) {
+	gpmc_cs_write_reg(eth_cs, GPMC_CS_CONFIG1, 0x00011200);
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
+	if (gpmc_cs_request(eth_cs, SZ_16M, &base) < 0) {
 		printk(KERN_ERR "Failed to request GPMC CS for smc91x\n");
 		return;
 	}
@@ -208,7 +236,7 @@ static inline void __init apollon_init_smc91x(void)
 	if (omap_request_gpio(APOLLON_ETHR_GPIO_IRQ) < 0) {
 		printk(KERN_ERR "Failed to request GPIO%d for smc91x IRQ\n",
 			APOLLON_ETHR_GPIO_IRQ);
-		gpmc_cs_free(APOLLON_ETH_CS);
+		gpmc_cs_free(eth_cs);
 		return;
 	}
 	omap_set_gpio_direction(APOLLON_ETHR_GPIO_IRQ, 1);
@@ -232,6 +260,7 @@ static struct omap_mmc_config apollon_mmc_config __initdata = {
 		.wire4		= 1,
 		.wp_pin		= -1,
 		.power_pin	= -1,
+	/* Note: If you want to detect card feature, please assign 37 */
 		.switch_pin	= -1,
 	},
 };
@@ -336,9 +365,6 @@ static void __init omap_apollon_init(void)
 	apollon_flash_init();
 	apollon_usb_init();
 
-	/* REVISIT: where's the correct place */
-	omap_cfg_reg(W19_24XX_SYS_NIRQ);
-
 	/* Use Interal loop-back in MMC/SDIO Module Input Clock selection */
 	CONTROL_DEVCONF |= (1 << 24);
 
-- 
1.4.4.2

