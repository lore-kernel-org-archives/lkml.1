Return-Path: <linux-kernel-owner+w=401wt.eu-S965752AbXDIVCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965752AbXDIVCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965756AbXDIVCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:02:12 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:11978 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965752AbXDIVCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:02:10 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Syed Mohammed Khasim <x0khasim@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/10] ARM: OMAP: plat-omap changes for 2430 SDP
Date: Mon,  9 Apr 2007 17:01:08 -0400
Message-Id: <11761525101796-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761525051719-git-send-email-tony@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com> <11761525051719-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Syed Mohammed Khasim <x0khasim@ti.com>

This patch adds minimal OMAP2430 support to plat-omap files to
get the kernel booting on 2430SDP.

Signed-off-by: Syed Mohammed Khasim <x0khasim@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/devices.c |    6 +++-
 arch/arm/plat-omap/dmtimer.c |    2 +
 arch/arm/plat-omap/gpio.c    |   76 ++++++++++++++++++++++++++++++++++-------
 arch/arm/plat-omap/mcbsp.c   |   15 +++++---
 4 files changed, 80 insertions(+), 19 deletions(-)

--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@ -429,6 +429,10 @@ static inline void omap_init_rng(void) {}
  */
 static int __init omap_init_devices(void)
 {
+/*
+ * Need to enable relevant once for 2430 SDP
+ */
+#ifndef CONFIG_MACH_OMAP_2430SDP
 	/* please keep these calls, and their implementations above,
 	 * in alphabetical order so they're easier to sort through.
 	 */
@@ -438,7 +442,7 @@ static int __init omap_init_devices(void)
 	omap_init_uwire();
 	omap_init_wdt();
 	omap_init_rng();
-
+#endif
 	return 0;
 }
 arch_initcall(omap_init_devices);
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -506,6 +506,8 @@ int omap_dm_timer_init(void)
 		BUG_ON(dm_source_clocks[i] == NULL);
 	}
 #endif
+	if (cpu_is_omap243x())
+		dm_timers[0].phys_base = 0x49018000;
 
 	for (i = 0; i < dm_timer_count; i++) {
 #ifdef CONFIG_ARCH_OMAP2
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -85,10 +85,17 @@
 /*
  * omap24xx specific GPIO registers
  */
-#define OMAP24XX_GPIO1_BASE		(void __iomem *)0x48018000
-#define OMAP24XX_GPIO2_BASE		(void __iomem *)0x4801a000
-#define OMAP24XX_GPIO3_BASE		(void __iomem *)0x4801c000
-#define OMAP24XX_GPIO4_BASE		(void __iomem *)0x4801e000
+#define OMAP242X_GPIO1_BASE		(void __iomem *)0x48018000
+#define OMAP242X_GPIO2_BASE		(void __iomem *)0x4801a000
+#define OMAP242X_GPIO3_BASE		(void __iomem *)0x4801c000
+#define OMAP242X_GPIO4_BASE		(void __iomem *)0x4801e000
+
+#define OMAP243X_GPIO1_BASE		(void __iomem *)0x4900C000
+#define OMAP243X_GPIO2_BASE		(void __iomem *)0x4900E000
+#define OMAP243X_GPIO3_BASE		(void __iomem *)0x49010000
+#define OMAP243X_GPIO4_BASE		(void __iomem *)0x49012000
+#define OMAP243X_GPIO5_BASE		(void __iomem *)0x480B6000
+
 #define OMAP24XX_GPIO_REVISION		0x0000
 #define OMAP24XX_GPIO_SYSCONFIG		0x0010
 #define OMAP24XX_GPIO_SYSSTATUS		0x0014
@@ -168,12 +175,22 @@ static struct gpio_bank gpio_bank_730[7] = {
 #endif
 
 #ifdef CONFIG_ARCH_OMAP24XX
-static struct gpio_bank gpio_bank_24xx[4] = {
-	{ OMAP24XX_GPIO1_BASE, INT_24XX_GPIO_BANK1, IH_GPIO_BASE,	METHOD_GPIO_24XX },
-	{ OMAP24XX_GPIO2_BASE, INT_24XX_GPIO_BANK2, IH_GPIO_BASE + 32,	METHOD_GPIO_24XX },
-	{ OMAP24XX_GPIO3_BASE, INT_24XX_GPIO_BANK3, IH_GPIO_BASE + 64,	METHOD_GPIO_24XX },
-	{ OMAP24XX_GPIO4_BASE, INT_24XX_GPIO_BANK4, IH_GPIO_BASE + 96,	METHOD_GPIO_24XX },
+
+static struct gpio_bank gpio_bank_242x[4] = {
+	{ OMAP242X_GPIO1_BASE, INT_24XX_GPIO_BANK1, IH_GPIO_BASE,	METHOD_GPIO_24XX },
+	{ OMAP242X_GPIO2_BASE, INT_24XX_GPIO_BANK2, IH_GPIO_BASE + 32,	METHOD_GPIO_24XX },
+	{ OMAP242X_GPIO3_BASE, INT_24XX_GPIO_BANK3, IH_GPIO_BASE + 64,	METHOD_GPIO_24XX },
+	{ OMAP242X_GPIO4_BASE, INT_24XX_GPIO_BANK4, IH_GPIO_BASE + 96,	METHOD_GPIO_24XX },
 };
+
+static struct gpio_bank gpio_bank_243x[5] = {
+	{ OMAP243X_GPIO1_BASE, INT_24XX_GPIO_BANK1, IH_GPIO_BASE,	METHOD_GPIO_24XX },
+	{ OMAP243X_GPIO2_BASE, INT_24XX_GPIO_BANK2, IH_GPIO_BASE + 32,	METHOD_GPIO_24XX },
+	{ OMAP243X_GPIO3_BASE, INT_24XX_GPIO_BANK3, IH_GPIO_BASE + 64,	METHOD_GPIO_24XX },
+	{ OMAP243X_GPIO4_BASE, INT_24XX_GPIO_BANK4, IH_GPIO_BASE + 96,	METHOD_GPIO_24XX },
+	{ OMAP243X_GPIO5_BASE, INT_24XX_GPIO_BANK5, IH_GPIO_BASE + 128, METHOD_GPIO_24XX },
+};
+
 #endif
 
 static struct gpio_bank *gpio_bank;
@@ -1113,6 +1130,11 @@ static int initialized;
 static struct clk * gpio_ick;
 static struct clk * gpio_fck;
 
+#ifdef CONFIG_ARCH_OMAP2430
+static struct clk * gpio5_ick;
+static struct clk * gpio5_fck;
+#endif
+
 static int __init _omap_gpio_init(void)
 {
 	int i;
@@ -1138,7 +1160,25 @@ static int __init _omap_gpio_init(void)
 			printk("Could not get gpios_fck\n");
 		else
 			clk_enable(gpio_fck);
-	}
+
+		/*
+		 * On 2430 GPIO 5 uses CORE L4 ICLK
+		 */
+#ifdef CONFIG_ARCH_OMAP2430
+		if (cpu_is_omap2430()) {
+			gpio5_ick = clk_get(NULL, "gpio5_ick");
+			if (IS_ERR(gpio5_ick))
+				printk("Could not get gpio5_ick\n");
+			else
+				clk_enable(gpio5_ick);
+			gpio5_fck = clk_get(NULL, "gpio5_fck");
+			if (IS_ERR(gpio5_fck))
+				printk("Could not get gpio5_fck\n");
+			else
+				clk_enable(gpio5_fck);
+		}
+#endif
+}
 
 #ifdef CONFIG_ARCH_OMAP15XX
 	if (cpu_is_omap15xx()) {
@@ -1165,14 +1205,24 @@ static int __init _omap_gpio_init(void)
 		gpio_bank = gpio_bank_730;
 	}
 #endif
+
 #ifdef CONFIG_ARCH_OMAP24XX
-	if (cpu_is_omap24xx()) {
+	if (cpu_is_omap242x()) {
 		int rev;
 
 		gpio_bank_count = 4;
-		gpio_bank = gpio_bank_24xx;
+		gpio_bank = gpio_bank_242x;
+		rev = omap_readl(gpio_bank[0].base + OMAP24XX_GPIO_REVISION);
+		printk(KERN_INFO "OMAP242x GPIO hardware version %d.%d\n",
+			(rev >> 4) & 0x0f, rev & 0x0f);
+	}
+	if (cpu_is_omap243x()) {
+		int rev;
+
+		gpio_bank_count = 5;
+		gpio_bank = gpio_bank_243x;
 		rev = omap_readl(gpio_bank[0].base + OMAP24XX_GPIO_REVISION);
-		printk(KERN_INFO "OMAP24xx GPIO hardware version %d.%d\n",
+		printk(KERN_INFO "OMAP243x GPIO hardware version %d.%d\n",
 			(rev >> 4) & 0x0f, rev & 0x0f);
 	}
 #endif
--- a/arch/arm/plat-omap/mcbsp.c
+++ b/arch/arm/plat-omap/mcbsp.c
@@ -225,11 +225,16 @@ static void omap_mcbsp_dsp_free(void)
 #ifdef CONFIG_ARCH_OMAP2
 static void omap2_mcbsp2_mux_setup(void)
 {
-	omap_cfg_reg(Y15_24XX_MCBSP2_CLKX);
-	omap_cfg_reg(R14_24XX_MCBSP2_FSX);
-	omap_cfg_reg(W15_24XX_MCBSP2_DR);
-	omap_cfg_reg(V15_24XX_MCBSP2_DX);
-	omap_cfg_reg(V14_24XX_GPIO117);
+	if (cpu_is_omap2420()) {
+		omap_cfg_reg(Y15_24XX_MCBSP2_CLKX);
+		omap_cfg_reg(R14_24XX_MCBSP2_FSX);
+		omap_cfg_reg(W15_24XX_MCBSP2_DR);
+		omap_cfg_reg(V15_24XX_MCBSP2_DX);
+		omap_cfg_reg(V14_24XX_GPIO117);
+	}
+	/*
+	 * Need to add MUX settings for OMAP 2430 SDP
+	 */
 }
 #endif
 
-- 
1.4.4.2

