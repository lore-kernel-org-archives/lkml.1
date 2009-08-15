Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZHOLdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZHOLdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZHOLdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:33:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:56645 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbZHOLdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=vwcEjP6Lqjk3pRa9OCyJQCkWPiHf1WUz+d41y0vgVb6RZnoCmf9GBXqONF69oBx8Nc
         s6QtObEa/dpoSMOAtVDjDhl5cmnCTcUJEEUSJE8ZGechjoJvpabPiMvJmzTYlR1b8vrQ
         D2jzTtr0DZ18D25PrPRRdFJWgXb8UscDM+kXY=
Message-ID: <4A869D1D.6040901@gmail.com>
Date: Sat, 15 Aug 2009 19:33:49 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/9] ARM: modify w90p910.c and add header file
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

To change w90p910.c and add nuc910 header file.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/nuc910.h  |   28 +++++
 arch/arm/mach-w90x900/w90p910.c |  220 +++++++++++----------------------------
 2 files changed, 87 insertions(+), 161 deletions(-)
 create mode 100644 arch/arm/mach-w90x900/nuc910.h

diff --git a/arch/arm/mach-w90x900/nuc910.h b/arch/arm/mach-w90x900/nuc910.h
new file mode 100644
index 0000000..1774fe1
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc910.h
@@ -0,0 +1,28 @@
+/*
+ * arch/arm/mach-w90x900/nuc910.h
+ *
+ * Copyright (c) 2008 Nuvoton corporation
+ *
+ * Header file for NUC900 CPU support
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+struct map_desc;
+struct sys_timer;
+
+/* core initialisation functions */
+
+extern void w90x900_init_irq(void);
+extern struct sys_timer w90x900_timer;
+
+/* extern file from nuc910.c */
+
+extern void nuc910_board_init(void);
+extern void nuc910_init_clocks(void);
+extern void nuc910_map_io(void);
diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/w90p910.c
index d33723b..fc94af1 100644
--- a/arch/arm/mach-w90x900/w90p910.c
+++ b/arch/arm/mach-w90x900/w90p910.c
@@ -3,11 +3,11 @@
  *
  * Based on linux/arch/arm/plat-s3c24xx/s3c244x.c by Ben Dooks
  *
- * Copyright (c) 2008 Nuvoton technology corporation.
+ * Copyright (c) 2009 Nuvoton corporation.
  *
  * Wan ZongShun <mcuos.com@gmail.com>
  *
- * W90P910 cpu support
+ * NUC910 cpu support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -39,186 +39,84 @@
 #include "cpu.h"
 #include "clock.h"
 
-/* Initial IO mappings */
+/* RTC controller*/
 
-static struct map_desc w90p910_iodesc[] __initdata = {
-	IODESC_ENT(IRQ),
-	IODESC_ENT(GCR),
-	IODESC_ENT(UART),
-	IODESC_ENT(TIMER),
-	IODESC_ENT(EBI),
-	IODESC_ENT(USBEHCIHOST),
-	IODESC_ENT(USBOHCIHOST),
-	IODESC_ENT(ADC),
-	IODESC_ENT(RTC),
-	IODESC_ENT(KPI),
-	IODESC_ENT(USBDEV),
-	/*IODESC_ENT(LCD),*/
+static struct resource nuc910_rtc_resource[] = {
+	[0] = {
+		.start = W90X900_PA_RTC,
+		.end   = W90X900_PA_RTC + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_RTC,
+		.end   = IRQ_RTC,
+		.flags = IORESOURCE_IRQ,
+	},
 };
 
-/* Initial clock declarations. */
-static DEFINE_CLK(lcd, 0);
-static DEFINE_CLK(audio, 1);
-static DEFINE_CLK(fmi, 4);
-static DEFINE_SUBCLK(ms, 0);
-static DEFINE_SUBCLK(sd, 1);
-static DEFINE_CLK(dmac, 5);
-static DEFINE_CLK(atapi, 6);
-static DEFINE_CLK(emc, 7);
-static DEFINE_SUBCLK(rmii, 2);
-static DEFINE_CLK(usbd, 8);
-static DEFINE_CLK(usbh, 9);
-static DEFINE_CLK(g2d, 10);;
-static DEFINE_CLK(pwm, 18);
-static DEFINE_CLK(ps2, 24);
-static DEFINE_CLK(kpi, 25);
-static DEFINE_CLK(wdt, 26);
-static DEFINE_CLK(gdma, 27);
-static DEFINE_CLK(adc, 28);
-static DEFINE_CLK(usi, 29);
-static DEFINE_CLK(ext, 0);
-
-static struct clk_lookup w90p910_clkregs[] = {
-	DEF_CLKLOOK(&clk_lcd, "w90p910-lcd", NULL),
-	DEF_CLKLOOK(&clk_audio, "w90p910-audio", NULL),
-	DEF_CLKLOOK(&clk_fmi, "w90p910-fmi", NULL),
-	DEF_CLKLOOK(&clk_ms, "w90p910-fmi", "MS"),
-	DEF_CLKLOOK(&clk_sd, "w90p910-fmi", "SD"),
-	DEF_CLKLOOK(&clk_dmac, "w90p910-dmac", NULL),
-	DEF_CLKLOOK(&clk_atapi, "w90p910-atapi", NULL),
-	DEF_CLKLOOK(&clk_emc, "w90p910-emc", NULL),
-	DEF_CLKLOOK(&clk_rmii, "w90p910-emc", "RMII"),
-	DEF_CLKLOOK(&clk_usbd, "w90p910-usbd", NULL),
-	DEF_CLKLOOK(&clk_usbh, "w90p910-usbh", NULL),
-	DEF_CLKLOOK(&clk_g2d, "w90p910-g2d", NULL),
-	DEF_CLKLOOK(&clk_pwm, "w90p910-pwm", NULL),
-	DEF_CLKLOOK(&clk_ps2, "w90p910-ps2", NULL),
-	DEF_CLKLOOK(&clk_kpi, "w90p910-kpi", NULL),
-	DEF_CLKLOOK(&clk_wdt, "w90p910-wdt", NULL),
-	DEF_CLKLOOK(&clk_gdma, "w90p910-gdma", NULL),
-	DEF_CLKLOOK(&clk_adc, "w90p910-adc", NULL),
-	DEF_CLKLOOK(&clk_usi, "w90p910-spi", NULL),
-	DEF_CLKLOOK(&clk_ext, NULL, "ext"),
+static struct platform_device nuc910_device_rtc = {
+	.name		= "nuc910-rtc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc910_rtc_resource),
+	.resource	= nuc910_rtc_resource,
 };
 
-/* Initial serial platform data */
-
-struct plat_serial8250_port w90p910_uart_data[] = {
-	W90X900_8250PORT(UART0),
-};
+/*TouchScreen controller*/
 
-struct platform_device w90p910_serial_device = {
-	.name			= "serial8250",
-	.id			= PLAT8250_DEV_PLATFORM,
-	.dev			= {
-		.platform_data	= w90p910_uart_data,
+static struct resource nuc910_ts_resource[] = {
+	[0] = {
+		.start = W90X900_PA_ADC,
+		.end   = W90X900_PA_ADC + W90X900_SZ_ADC-1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_ADC,
+		.end   = IRQ_ADC,
+		.flags = IORESOURCE_IRQ,
 	},
 };
 
-/*Init W90P910 evb io*/
-
-void __init w90p910_map_io(struct map_desc *mach_desc, int mach_size)
-{
-	unsigned long idcode = 0x0;
-
-	iotable_init(w90p910_iodesc, ARRAY_SIZE(w90p910_iodesc));
-
-	idcode = __raw_readl(W90X900PDID);
-	if (idcode != W90P910_CPUID)
-		printk(KERN_ERR "CPU type 0x%08lx is not W90P910\n", idcode);
-}
-
-/*Set W90P910 cpu frequence*/
-static int __init w90p910_set_clkval(unsigned int cpufreq)
-{
-	unsigned int pllclk, ahbclk, apbclk, val;
-
-	pllclk = 0;
-	ahbclk = 0;
-	apbclk = 0;
-
-	switch (cpufreq) {
-	case 66:
-		pllclk = PLL_66MHZ;
-		ahbclk = AHB_CPUCLK_1_1;
-		apbclk = APB_AHB_1_2;
-		break;
-
-	case 100:
-		pllclk = PLL_100MHZ;
-		ahbclk = AHB_CPUCLK_1_1;
-		apbclk = APB_AHB_1_2;
-		break;
-
-	case 120:
-		pllclk = PLL_120MHZ;
-		ahbclk = AHB_CPUCLK_1_2;
-		apbclk = APB_AHB_1_2;
-		break;
-
-	case 166:
-		pllclk = PLL_166MHZ;
-		ahbclk = AHB_CPUCLK_1_2;
-		apbclk = APB_AHB_1_2;
-		break;
-
-	case 200:
-		pllclk = PLL_200MHZ;
-		ahbclk = AHB_CPUCLK_1_2;
-		apbclk = APB_AHB_1_2;
-		break;
-	}
-
-	__raw_writel(pllclk, REG_PLLCON0);
-
-	val = __raw_readl(REG_CLKDIV);
-	val &= ~(0x03 << 24 | 0x03 << 26);
-	val |= (ahbclk << 24 | apbclk << 26);
-	__raw_writel(val, REG_CLKDIV);
-
-	return 	0;
-}
-static int __init w90p910_set_cpufreq(char *str)
-{
-	unsigned long cpufreq, val;
-
-	if (!*str)
-		return 0;
-
-	strict_strtoul(str, 0, &cpufreq);
+static struct platform_device nuc910_device_ts = {
+	.name		= "nuc910-ts",
+	.id		= -1,
+	.resource	= nuc910_ts_resource,
+	.num_resources	= ARRAY_SIZE(nuc910_ts_resource),
+};
 
-	w90p910_clock_source(NULL, "ext");
+/* define specific CPU platform device */
 
-	w90p910_set_clkval(cpufreq);
+static struct platform_device *nuc910_dev[] __initdata = {
+	&nuc910_device_ts,
+	&nuc910_device_rtc,
+};
 
-	mdelay(1);
+/* define specific CPU platform io map */
 
-	val = __raw_readl(REG_CKSKEW);
-	val &= ~0xff;
-	val |= DEFAULTSKEW;
-	__raw_writel(val, REG_CKSKEW);
+static struct map_desc nuc910evb_iodesc[] __initdata = {
+	IODESC_ENT(USBEHCIHOST),
+	IODESC_ENT(USBOHCIHOST),
+	IODESC_ENT(KPI),
+	IODESC_ENT(USBDEV),
+	IODESC_ENT(ADC),
+};
 
-	w90p910_clock_source(NULL, "pll0");
+/*Init NUC910 evb io*/
 
-	return 1;
+void __init nuc910_map_io(void)
+{
+	nuc900_map_io(nuc910evb_iodesc, ARRAY_SIZE(nuc910evb_iodesc));
 }
 
-__setup("cpufreq=", w90p910_set_cpufreq);
-
-/*Init W90P910 clock*/
+/*Init NUC910 clock*/
 
-void __init w90p910_init_clocks(void)
+void __init nuc910_init_clocks(void)
 {
-	clks_register(w90p910_clkregs, ARRAY_SIZE(w90p910_clkregs));
+	nuc900_init_clocks();
 }
 
-static int __init w90p910_init_cpu(void)
-{
-	return 0;
-}
+/*Init NUC910 board info*/
 
-static int __init w90x900_arch_init(void)
+void __init nuc910_board_init(void)
 {
-	return w90p910_init_cpu();
+	nuc900_board_init(nuc910_dev, ARRAY_SIZE(nuc910_dev));
 }
-arch_initcall(w90x900_arch_init);
-- 
1.5.6.3

