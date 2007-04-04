Return-Path: <linux-kernel-owner+w=401wt.eu-S2993021AbXDDS1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993021AbXDDS1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934063AbXDDSLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:11:19 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:38350 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934060AbXDDSLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:11:13 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 52/90] ARM: OMAP: cleanup apollon board
Date: Wed,  4 Apr 2007 14:05:31 -0400
Message-Id: <11757101101180-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101072553-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com>
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

diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index 3bb49c1..5e1cada 100644
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

