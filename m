Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZHRLEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZHRLEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 07:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZHRLEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 07:04:36 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:52511 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZHRLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 07:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rFLzi7F2xKddyggtVkqLs3GLlVIO0VRzj6XzSblMSDSRj3C4Fnq1PydotfRUYV2rKt
         abXgmWTfTwk1Vg+XuEUEFz67TgAKAkcmuyEGTZbO9lmPW1wb8yFeUH8rlMotxjDSs6Qi
         o8eTrbD1YaxYyLCV4h68Z/dscK902kEvIdfmo=
Message-ID: <4A8A8ABB.6050201@gmail.com>
Date: Tue, 18 Aug 2009 19:04:27 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2] ARM: Add common files of platform definition and cpu implementing
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

According to your advice, I wrapped up the adding 'cpu.c'
and 'dev.c' patches to the previous patch fixing the w90p910.

At the same time, I renamed all 'w90x900' to 'nuc900' in every
c file of w90x900 platform.

The previous nine patches were integrated into three, one
is to add the common files and modify some marks of w90p910 
platform, another is to add nuc950 platform files, the other
is to add nuc960 platform files. I will submit them by three
patches.

Thanks a lot for your help. 

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/Makefile                 |    8 +-
 arch/arm/mach-w90x900/clksel.c                 |   12 +-
 arch/arm/mach-w90x900/clock.c                  |    4 +-
 arch/arm/mach-w90x900/clock.h                  |    8 +-
 arch/arm/mach-w90x900/{w90p910.c => cpu.c}     |  122 ++++----
 arch/arm/mach-w90x900/cpu.h                    |   50 ++--
 arch/arm/mach-w90x900/dev.c                    |  389 ++++++++++++++++++++++
 arch/arm/mach-w90x900/gpio.c                   |   78 +++---
 arch/arm/mach-w90x900/irq.c                    |   30 +-
 arch/arm/mach-w90x900/mach-nuc910evb.c         |   44 +++
 arch/arm/mach-w90x900/mach-w90p910evb.c        |  407 ------------------------
 arch/arm/mach-w90x900/{mfp-w90p910.c => mfp.c} |   38 ++--
 arch/arm/mach-w90x900/nuc910.c                 |   60 ++++
 arch/arm/mach-w90x900/nuc910.h                 |   28 ++
 arch/arm/mach-w90x900/time.c                   |   70 ++--
 15 files changed, 725 insertions(+), 623 deletions(-)
 rename arch/arm/mach-w90x900/{w90p910.c => cpu.c} (53%)
 create mode 100644 arch/arm/mach-w90x900/dev.c
 create mode 100644 arch/arm/mach-w90x900/mach-nuc910evb.c
 delete mode 100644 arch/arm/mach-w90x900/mach-w90p910evb.c
 rename arch/arm/mach-w90x900/{mfp-w90p910.c => mfp.c} (77%)
 create mode 100644 arch/arm/mach-w90x900/nuc910.c
 create mode 100644 arch/arm/mach-w90x900/nuc910.h

diff --git a/arch/arm/mach-w90x900/Makefile b/arch/arm/mach-w90x900/Makefile
index 3ccd625..e38aa32 100644
--- a/arch/arm/mach-w90x900/Makefile
+++ b/arch/arm/mach-w90x900/Makefile
@@ -4,12 +4,12 @@
 
 # Object file lists.
 
-obj-y				:= irq.o time.o mfp-w90p910.o gpio.o clock.o
-obj-y				+= clksel.o
+obj-y				:= irq.o time.o mfp.o gpio.o clock.o
+obj-y				+= clksel.o dev.o cpu.o
 # W90X900 CPU support files
 
-obj-$(CONFIG_CPU_W90P910)	+= w90p910.o
+obj-$(CONFIG_CPU_W90P910)	+= nuc910.o
 
 # machine support
 
-obj-$(CONFIG_MACH_W90P910EVB)	+= mach-w90p910evb.o
+obj-$(CONFIG_MACH_W90P910EVB)	+= mach-nuc910evb.o
diff --git a/arch/arm/mach-w90x900/clksel.c b/arch/arm/mach-w90x900/clksel.c
index 5a77eb9..3de4a52 100644
--- a/arch/arm/mach-w90x900/clksel.c
+++ b/arch/arm/mach-w90x900/clksel.c
@@ -42,13 +42,13 @@ static void clock_source_select(const char *dev_id, unsigned int clkval)
 
 	clksel = __raw_readl(REG_CLKSEL);
 
-	if (strcmp(dev_id, "w90p910-ms") == 0)
+	if (strcmp(dev_id, "nuc900-ms") == 0)
 		offset = MSOFFSET;
-	else if (strcmp(dev_id, "w90p910-atapi") == 0)
+	else if (strcmp(dev_id, "nuc900-atapi") == 0)
 		offset = ATAOFFSET;
-	else if (strcmp(dev_id, "w90p910-lcd") == 0)
+	else if (strcmp(dev_id, "nuc900-lcd") == 0)
 		offset = LCDOFFSET;
-	else if (strcmp(dev_id, "w90p910-audio") == 0)
+	else if (strcmp(dev_id, "nuc900-audio") == 0)
 		offset = AUDOFFSET;
 	else
 		offset = CPUOFFSET;
@@ -59,7 +59,7 @@ static void clock_source_select(const char *dev_id, unsigned int clkval)
 	__raw_writel(clksel, REG_CLKSEL);
 }
 
-void w90p910_clock_source(struct device *dev, unsigned char *src)
+void nuc900_clock_source(struct device *dev, unsigned char *src)
 {
 	unsigned int clkval;
 	const char *dev_id;
@@ -87,5 +87,5 @@ void w90p910_clock_source(struct device *dev, unsigned char *src)
 
 	mutex_unlock(&clksel_sem);
 }
-EXPORT_SYMBOL(w90p910_clock_source);
+EXPORT_SYMBOL(nuc900_clock_source);
 
diff --git a/arch/arm/mach-w90x900/clock.c b/arch/arm/mach-w90x900/clock.c
index 70b6710..b785994 100644
--- a/arch/arm/mach-w90x900/clock.c
+++ b/arch/arm/mach-w90x900/clock.c
@@ -61,7 +61,7 @@ unsigned long clk_get_rate(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_rate);
 
-void w90x900_clk_enable(struct clk *clk, int enable)
+void nuc900_clk_enable(struct clk *clk, int enable)
 {
 	unsigned int clocks = clk->cken;
 	unsigned long clken;
@@ -76,7 +76,7 @@ void w90x900_clk_enable(struct clk *clk, int enable)
 	__raw_writel(clken, W90X900_VA_CLKPWR);
 }
 
-void w90x900_subclk_enable(struct clk *clk, int enable)
+void nuc900_subclk_enable(struct clk *clk, int enable)
 {
 	unsigned int clocks = clk->cken;
 	unsigned long clken;
diff --git a/arch/arm/mach-w90x900/clock.h b/arch/arm/mach-w90x900/clock.h
index d2f0e50..f5816a0 100644
--- a/arch/arm/mach-w90x900/clock.h
+++ b/arch/arm/mach-w90x900/clock.h
@@ -12,8 +12,8 @@
 
 #include <asm/clkdev.h>
 
-void w90x900_clk_enable(struct clk *clk, int enable);
-void w90x900_subclk_enable(struct clk *clk, int enable);
+void nuc900_clk_enable(struct clk *clk, int enable);
+void nuc900_subclk_enable(struct clk *clk, int enable);
 void clks_register(struct clk_lookup *clks, size_t num);
 
 struct clk {
@@ -24,13 +24,13 @@ struct clk {
 
 #define DEFINE_CLK(_name, _ctrlbit)			\
 struct clk clk_##_name = {				\
-		.enable	= w90x900_clk_enable,		\
+		.enable	= nuc900_clk_enable,		\
 		.cken	= (1 << _ctrlbit),		\
 	}
 
 #define DEFINE_SUBCLK(_name, _ctrlbit)			\
 struct clk clk_##_name = {				\
-		.enable	= w90x900_subclk_enable,	\
+		.enable	= nuc900_subclk_enable,	\
 		.cken	= (1 << _ctrlbit),		\
 	}
 
diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/cpu.c
similarity index 53%
rename from arch/arm/mach-w90x900/w90p910.c
rename to arch/arm/mach-w90x900/cpu.c
index d33723b..921cef9 100644
--- a/arch/arm/mach-w90x900/w90p910.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -1,13 +1,11 @@
 /*
- * linux/arch/arm/mach-w90x900/w90p910.c
+ * linux/arch/arm/mach-w90x900/cpu.c
  *
- * Based on linux/arch/arm/plat-s3c24xx/s3c244x.c by Ben Dooks
- *
- * Copyright (c) 2008 Nuvoton technology corporation.
+ * Copyright (c) 2009 Nuvoton corporation.
  *
  * Wan ZongShun <mcuos.com@gmail.com>
  *
- * W90P910 cpu support
+ * NUC900 series cpu common support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,19 +39,12 @@
 
 /* Initial IO mappings */
 
-static struct map_desc w90p910_iodesc[] __initdata = {
+static struct map_desc nuc900_iodesc[] __initdata = {
 	IODESC_ENT(IRQ),
 	IODESC_ENT(GCR),
 	IODESC_ENT(UART),
 	IODESC_ENT(TIMER),
 	IODESC_ENT(EBI),
-	IODESC_ENT(USBEHCIHOST),
-	IODESC_ENT(USBOHCIHOST),
-	IODESC_ENT(ADC),
-	IODESC_ENT(RTC),
-	IODESC_ENT(KPI),
-	IODESC_ENT(USBDEV),
-	/*IODESC_ENT(LCD),*/
 };
 
 /* Initial clock declarations. */
@@ -78,58 +69,45 @@ static DEFINE_CLK(adc, 28);
 static DEFINE_CLK(usi, 29);
 static DEFINE_CLK(ext, 0);
 
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
+static struct clk_lookup nuc900_clkregs[] = {
+	DEF_CLKLOOK(&clk_lcd, "nuc900-lcd", NULL),
+	DEF_CLKLOOK(&clk_audio, "nuc900-audio", NULL),
+	DEF_CLKLOOK(&clk_fmi, "nuc900-fmi", NULL),
+	DEF_CLKLOOK(&clk_ms, "nuc900-fmi", "MS"),
+	DEF_CLKLOOK(&clk_sd, "nuc900-fmi", "SD"),
+	DEF_CLKLOOK(&clk_dmac, "nuc900-dmac", NULL),
+	DEF_CLKLOOK(&clk_atapi, "nuc900-atapi", NULL),
+	DEF_CLKLOOK(&clk_emc, "nuc900-emc", NULL),
+	DEF_CLKLOOK(&clk_rmii, "nuc900-emc", "RMII"),
+	DEF_CLKLOOK(&clk_usbd, "nuc900-usbd", NULL),
+	DEF_CLKLOOK(&clk_usbh, "nuc900-usbh", NULL),
+	DEF_CLKLOOK(&clk_g2d, "nuc900-g2d", NULL),
+	DEF_CLKLOOK(&clk_pwm, "nuc900-pwm", NULL),
+	DEF_CLKLOOK(&clk_ps2, "nuc900-ps2", NULL),
+	DEF_CLKLOOK(&clk_kpi, "nuc900-kpi", NULL),
+	DEF_CLKLOOK(&clk_wdt, "nuc900-wdt", NULL),
+	DEF_CLKLOOK(&clk_gdma, "nuc900-gdma", NULL),
+	DEF_CLKLOOK(&clk_adc, "nuc900-adc", NULL),
+	DEF_CLKLOOK(&clk_usi, "nuc900-spi", NULL),
 	DEF_CLKLOOK(&clk_ext, NULL, "ext"),
 };
 
 /* Initial serial platform data */
 
-struct plat_serial8250_port w90p910_uart_data[] = {
-	W90X900_8250PORT(UART0),
+struct plat_serial8250_port nuc900_uart_data[] = {
+	NUC900_8250PORT(UART0),
 };
 
-struct platform_device w90p910_serial_device = {
+struct platform_device nuc900_serial_device = {
 	.name			= "serial8250",
 	.id			= PLAT8250_DEV_PLATFORM,
 	.dev			= {
-		.platform_data	= w90p910_uart_data,
+		.platform_data	= nuc900_uart_data,
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
+/*Set NUC900 series cpu frequence*/
+static int __init nuc900_set_clkval(unsigned int cpufreq)
 {
 	unsigned int pllclk, ahbclk, apbclk, val;
 
@@ -178,7 +156,7 @@ static int __init w90p910_set_clkval(unsigned int cpufreq)
 
 	return 	0;
 }
-static int __init w90p910_set_cpufreq(char *str)
+static int __init nuc900_set_cpufreq(char *str)
 {
 	unsigned long cpufreq, val;
 
@@ -187,9 +165,9 @@ static int __init w90p910_set_cpufreq(char *str)
 
 	strict_strtoul(str, 0, &cpufreq);
 
-	w90p910_clock_source(NULL, "ext");
+	nuc900_clock_source(NULL, "ext");
 
-	w90p910_set_clkval(cpufreq);
+	nuc900_set_clkval(cpufreq);
 
 	mdelay(1);
 
@@ -198,27 +176,37 @@ static int __init w90p910_set_cpufreq(char *str)
 	val |= DEFAULTSKEW;
 	__raw_writel(val, REG_CKSKEW);
 
-	w90p910_clock_source(NULL, "pll0");
+	nuc900_clock_source(NULL, "pll0");
 
 	return 1;
 }
 
-__setup("cpufreq=", w90p910_set_cpufreq);
+__setup("cpufreq=", nuc900_set_cpufreq);
 
-/*Init W90P910 clock*/
+/*Init NUC900 evb io*/
 
-void __init w90p910_init_clocks(void)
+void __init nuc900_map_io(struct map_desc *mach_desc, int mach_size)
 {
-	clks_register(w90p910_clkregs, ARRAY_SIZE(w90p910_clkregs));
-}
+	unsigned long idcode = 0x0;
 
-static int __init w90p910_init_cpu(void)
-{
-	return 0;
+	iotable_init(mach_desc, mach_size);
+	iotable_init(nuc900_iodesc, ARRAY_SIZE(nuc900_iodesc));
+
+	idcode = __raw_readl(NUC900PDID);
+	if (idcode == NUC910_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC910\n", idcode);
+	else if (idcode == NUC920_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC920\n", idcode);
+	else if (idcode == NUC950_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC950\n", idcode);
+	else if (idcode == NUC960_CPUID)
+		printk(KERN_INFO "CPU type 0x%08lx is NUC960\n", idcode);
 }
 
-static int __init w90x900_arch_init(void)
+/*Init NUC900 clock*/
+
+void __init nuc900_init_clocks(void)
 {
-	return w90p910_init_cpu();
+	clks_register(nuc900_clkregs, ARRAY_SIZE(nuc900_clkregs));
 }
-arch_initcall(w90x900_arch_init);
+
diff --git a/arch/arm/mach-w90x900/cpu.h b/arch/arm/mach-w90x900/cpu.h
index ddde959..4d58ba1 100644
--- a/arch/arm/mach-w90x900/cpu.h
+++ b/arch/arm/mach-w90x900/cpu.h
@@ -6,7 +6,7 @@
  * Copyright (c) 2008 Nuvoton technology corporation
  * All rights reserved.
  *
- * Header file for W90X900 CPU support
+ * Header file for NUC900 CPU support
  *
  * Wan ZongShun <mcuos.com@gmail.com>
  *
@@ -24,30 +24,7 @@
        .type    = MT_DEVICE,                           \
 }
 
-/*Cpu identifier register*/
-
-#define W90X900PDID	W90X900_VA_GCR
-#define W90P910_CPUID	0x02900910
-#define W90P920_CPUID	0x02900920
-#define W90P950_CPUID	0x02900950
-#define W90N960_CPUID	0x02900960
-
-struct w90x900_uartcfg;
-struct map_desc;
-struct sys_timer;
-
-/* core initialisation functions */
-
-extern void w90x900_init_irq(void);
-extern void w90p910_init_io(struct map_desc *mach_desc, int size);
-extern void w90p910_init_uarts(struct w90x900_uartcfg *cfg, int no);
-extern void w90p910_init_clocks(void);
-extern void w90p910_map_io(struct map_desc *mach_desc, int size);
-extern struct platform_device w90p910_serial_device;
-extern struct sys_timer w90x900_timer;
-extern void w90p910_clock_source(struct device *dev, unsigned char *src);
-
-#define W90X900_8250PORT(name)					\
+#define NUC900_8250PORT(name)					\
 {								\
 	.membase	= name##_BA,				\
 	.mapbase	= name##_PA,				\
@@ -57,3 +34,26 @@ extern void w90p910_clock_source(struct device *dev, unsigned char *src);
 	.iotype		= UPIO_MEM,				\
 	.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST,	\
 }
+
+/*Cpu identifier register*/
+
+#define NUC900PDID	W90X900_VA_GCR
+#define NUC910_CPUID	0x02900910
+#define NUC920_CPUID	0x02900920
+#define NUC950_CPUID	0x02900950
+#define NUC960_CPUID	0x02900960
+
+/* extern file from cpu.c */
+
+extern void nuc900_clock_source(struct device *dev, unsigned char *src);
+extern void nuc900_init_clocks(void);
+extern void nuc900_map_io(struct map_desc *mach_desc, int mach_size);
+extern void nuc900_board_init(struct platform_device **device, int size);
+
+/* for either public between 910 and 920, or between 920 and 950 */
+
+extern struct platform_device nuc900_serial_device;
+extern struct platform_device nuc900_device_fmi;
+extern struct platform_device nuc900_device_kpi;
+extern struct platform_device nuc900_device_rtc;
+extern struct platform_device nuc900_device_ts;
diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
new file mode 100644
index 0000000..2a6f98d
--- /dev/null
+++ b/arch/arm/mach-w90x900/dev.c
@@ -0,0 +1,389 @@
+/*
+ * linux/arch/arm/mach-w90x900/dev.c
+ *
+ * Copyright (C) 2009 Nuvoton corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+
+#include <linux/mtd/physmap.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach-types.h>
+
+#include <mach/regs-serial.h>
+#include <mach/map.h>
+
+#include "cpu.h"
+
+/*NUC900 evb norflash driver data */
+
+#define NUC900_FLASH_BASE	0xA0000000
+#define NUC900_FLASH_SIZE	0x400000
+#define SPIOFFSET		0x200
+#define SPIOREG_SIZE		0x100
+
+static struct mtd_partition nuc900_flash_partitions[] = {
+	{
+		.name	=	"NOR Partition 1 for kernel (960K)",
+		.size	=	0xF0000,
+		.offset	=	0x10000,
+	},
+	{
+		.name	=	"NOR Partition 2 for image (1M)",
+		.size	=	0x100000,
+		.offset	=	0x100000,
+	},
+	{
+		.name	=	"NOR Partition 3 for user (2M)",
+		.size	=	0x200000,
+		.offset	=	0x00200000,
+	}
+};
+
+static struct physmap_flash_data nuc900_flash_data = {
+	.width		=	2,
+	.parts		=	nuc900_flash_partitions,
+	.nr_parts	=	ARRAY_SIZE(nuc900_flash_partitions),
+};
+
+static struct resource nuc900_flash_resources[] = {
+	{
+		.start	=	NUC900_FLASH_BASE,
+		.end	=	NUC900_FLASH_BASE + NUC900_FLASH_SIZE - 1,
+		.flags	=	IORESOURCE_MEM,
+	}
+};
+
+static struct platform_device nuc900_flash_device = {
+	.name		=	"physmap-flash",
+	.id		=	0,
+	.dev		= {
+				.platform_data = &nuc900_flash_data,
+			},
+	.resource	=	nuc900_flash_resources,
+	.num_resources	=	ARRAY_SIZE(nuc900_flash_resources),
+};
+
+/* USB EHCI Host Controller */
+
+static struct resource nuc900_usb_ehci_resource[] = {
+	[0] = {
+		.start = W90X900_PA_USBEHCIHOST,
+		.end   = W90X900_PA_USBEHCIHOST + W90X900_SZ_USBEHCIHOST - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_USBH,
+		.end   = IRQ_USBH,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_usb_ehci_dmamask = 0xffffffffUL;
+
+static struct platform_device nuc900_device_usb_ehci = {
+	.name		  = "nuc900-ehci",
+	.id		  = -1,
+	.num_resources	  = ARRAY_SIZE(nuc900_usb_ehci_resource),
+	.resource	  = nuc900_usb_ehci_resource,
+	.dev              = {
+		.dma_mask = &nuc900_device_usb_ehci_dmamask,
+		.coherent_dma_mask = 0xffffffffUL
+	}
+};
+
+/* USB OHCI Host Controller */
+
+static struct resource nuc900_usb_ohci_resource[] = {
+	[0] = {
+		.start = W90X900_PA_USBOHCIHOST,
+		.end   = W90X900_PA_USBOHCIHOST + W90X900_SZ_USBOHCIHOST - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_USBH,
+		.end   = IRQ_USBH,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_usb_ohci_dmamask = 0xffffffffUL;
+static struct platform_device nuc900_device_usb_ohci = {
+	.name		  = "nuc900-ohci",
+	.id		  = -1,
+	.num_resources	  = ARRAY_SIZE(nuc900_usb_ohci_resource),
+	.resource	  = nuc900_usb_ohci_resource,
+	.dev              = {
+		.dma_mask = &nuc900_device_usb_ohci_dmamask,
+		.coherent_dma_mask = 0xffffffffUL
+	}
+};
+
+/* USB Device (Gadget)*/
+
+static struct resource nuc900_usbgadget_resource[] = {
+	[0] = {
+		.start = W90X900_PA_USBDEV,
+		.end   = W90X900_PA_USBDEV + W90X900_SZ_USBDEV - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_USBD,
+		.end   = IRQ_USBD,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_usbgadget = {
+	.name		= "nuc900-usbgadget",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_usbgadget_resource),
+	.resource	= nuc900_usbgadget_resource,
+};
+
+/* MAC device */
+
+static struct resource nuc900_emc_resource[] = {
+	[0] = {
+		.start = W90X900_PA_EMC,
+		.end   = W90X900_PA_EMC + W90X900_SZ_EMC - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_EMCTX,
+		.end   = IRQ_EMCTX,
+		.flags = IORESOURCE_IRQ,
+	},
+	[2] = {
+		.start = IRQ_EMCRX,
+		.end   = IRQ_EMCRX,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static u64 nuc900_device_emc_dmamask = 0xffffffffUL;
+static struct platform_device nuc900_device_emc = {
+	.name		= "nuc900-emc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_emc_resource),
+	.resource	= nuc900_emc_resource,
+	.dev              = {
+		.dma_mask = &nuc900_device_emc_dmamask,
+		.coherent_dma_mask = 0xffffffffUL
+	}
+};
+
+/* SPI device */
+
+static struct resource nuc900_spi_resource[] = {
+	[0] = {
+		.start = W90X900_PA_I2C + SPIOFFSET,
+		.end   = W90X900_PA_I2C + SPIOFFSET + SPIOREG_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_SSP,
+		.end   = IRQ_SSP,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_spi = {
+	.name		= "nuc900-spi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_spi_resource),
+	.resource	= nuc900_spi_resource,
+};
+
+/* spi device, spi flash info */
+
+static struct mtd_partition nuc900_spi_flash_partitions[] = {
+	{
+		.name = "bootloader(spi)",
+		.size = 0x0100000,
+		.offset = 0,
+	},
+};
+
+static struct flash_platform_data nuc900_spi_flash_data = {
+	.name = "m25p80",
+	.parts =  nuc900_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(nuc900_spi_flash_partitions),
+	.type = "w25x16",
+};
+
+static struct spi_board_info nuc900_spi_board_info[] __initdata = {
+	{
+		.modalias = "m25p80",
+		.max_speed_hz = 20000000,
+		.bus_num = 0,
+		.chip_select = 1,
+		.platform_data = &nuc900_spi_flash_data,
+		.mode = SPI_MODE_0,
+	},
+};
+
+/* WDT Device */
+
+static struct resource nuc900_wdt_resource[] = {
+	[0] = {
+		.start = W90X900_PA_TIMER,
+		.end   = W90X900_PA_TIMER + W90X900_SZ_TIMER - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_WDT,
+		.end   = IRQ_WDT,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device nuc900_device_wdt = {
+	.name		= "nuc900-wdt",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_wdt_resource),
+	.resource	= nuc900_wdt_resource,
+};
+
+/*
+ * public device definition between 910 and 920, or 910
+ * and 950 or 950 and 960...,their dev platform register
+ * should be in specific file such as nuc950, nuc960 c
+ * files rather than the public dev.c file here. so the
+ * corresponding platform_device definition should not be
+ * static.
+*/
+
+/* RTC controller*/
+
+static struct resource nuc900_rtc_resource[] = {
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
+};
+
+struct platform_device nuc900_device_rtc = {
+	.name		= "nuc900-rtc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_rtc_resource),
+	.resource	= nuc900_rtc_resource,
+};
+
+/*TouchScreen controller*/
+
+static struct resource nuc900_ts_resource[] = {
+	[0] = {
+		.start = W90X900_PA_ADC,
+		.end   = W90X900_PA_ADC + W90X900_SZ_ADC-1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_ADC,
+		.end   = IRQ_ADC,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device nuc900_device_ts = {
+	.name		= "nuc900-ts",
+	.id		= -1,
+	.resource	= nuc900_ts_resource,
+	.num_resources	= ARRAY_SIZE(nuc900_ts_resource),
+};
+
+/* FMI Device */
+
+static struct resource nuc900_fmi_resource[] = {
+	[0] = {
+		.start = W90X900_PA_FMI,
+		.end   = W90X900_PA_FMI + W90X900_SZ_FMI - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_FMI,
+		.end   = IRQ_FMI,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+struct platform_device nuc900_device_fmi = {
+	.name		= "nuc900-fmi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_fmi_resource),
+	.resource	= nuc900_fmi_resource,
+};
+
+/* KPI controller*/
+
+static struct resource nuc900_kpi_resource[] = {
+	[0] = {
+		.start = W90X900_PA_KPI,
+		.end   = W90X900_PA_KPI + W90X900_SZ_KPI - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_KPI,
+		.end   = IRQ_KPI,
+		.flags = IORESOURCE_IRQ,
+	}
+
+};
+
+struct platform_device nuc900_device_kpi = {
+	.name		= "nuc900-kpi",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(nuc900_kpi_resource),
+	.resource	= nuc900_kpi_resource,
+};
+
+/*Here should be your evb resourse,such as LCD*/
+
+static struct platform_device *nuc900_public_dev[] __initdata = {
+	&nuc900_serial_device,
+	&nuc900_flash_device,
+	&nuc900_device_usb_ehci,
+	&nuc900_device_usb_ohci,
+	&nuc900_device_usbgadget,
+	&nuc900_device_emc,
+	&nuc900_device_spi,
+	&nuc900_device_wdt,
+};
+
+/* Provide adding specific CPU platform devices API */
+
+void __init nuc900_board_init(struct platform_device **device, int size)
+{
+	platform_add_devices(device, size);
+	platform_add_devices(nuc900_public_dev, ARRAY_SIZE(nuc900_public_dev));
+	spi_register_board_info(nuc900_spi_board_info,
+					ARRAY_SIZE(nuc900_spi_board_info));
+}
+
diff --git a/arch/arm/mach-w90x900/gpio.c b/arch/arm/mach-w90x900/gpio.c
index c72e0df..ba05aec 100644
--- a/arch/arm/mach-w90x900/gpio.c
+++ b/arch/arm/mach-w90x900/gpio.c
@@ -1,7 +1,7 @@
 /*
- * linux/arch/arm/mach-w90p910/gpio.c
+ * linux/arch/arm/mach-w90x900/gpio.c
  *
- * Generic w90p910 GPIO handling
+ * Generic nuc900 GPIO handling
  *
  *  Wan ZongShun <mcuos.com@gmail.com>
  *
@@ -30,31 +30,31 @@
 #define GPIO_IN			(0x0C)
 #define GROUPINERV		(0x10)
 #define GPIO_GPIO(Nb)		(0x00000001 << (Nb))
-#define to_w90p910_gpio_chip(c) container_of(c, struct w90p910_gpio_chip, chip)
+#define to_nuc900_gpio_chip(c) container_of(c, struct nuc900_gpio_chip, chip)
 
-#define W90P910_GPIO_CHIP(name, base_gpio, nr_gpio)			\
+#define NUC900_GPIO_CHIP(name, base_gpio, nr_gpio)			\
 	{								\
 		.chip = {						\
 			.label		  = name,			\
-			.direction_input  = w90p910_dir_input,		\
-			.direction_output = w90p910_dir_output,		\
-			.get		  = w90p910_gpio_get,		\
-			.set		  = w90p910_gpio_set,		\
+			.direction_input  = nuc900_dir_input,		\
+			.direction_output = nuc900_dir_output,		\
+			.get		  = nuc900_gpio_get,		\
+			.set		  = nuc900_gpio_set,		\
 			.base		  = base_gpio,			\
 			.ngpio		  = nr_gpio,			\
 		}							\
 	}
 
-struct w90p910_gpio_chip {
+struct nuc900_gpio_chip {
 	struct gpio_chip	chip;
 	void __iomem		*regbase;	/* Base of group register*/
 	spinlock_t 		gpio_lock;
 };
 
-static int w90p910_gpio_get(struct gpio_chip *chip, unsigned offset)
+static int nuc900_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	struct w90p910_gpio_chip *w90p910_gpio = to_w90p910_gpio_chip(chip);
-	void __iomem *pio = w90p910_gpio->regbase + GPIO_IN;
+	struct nuc900_gpio_chip *nuc900_gpio = to_nuc900_gpio_chip(chip);
+	void __iomem *pio = nuc900_gpio->regbase + GPIO_IN;
 	unsigned int regval;
 
 	regval = __raw_readl(pio);
@@ -63,14 +63,14 @@ static int w90p910_gpio_get(struct gpio_chip *chip, unsigned offset)
 	return (regval != 0);
 }
 
-static void w90p910_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+static void nuc900_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 {
-	struct w90p910_gpio_chip *w90p910_gpio = to_w90p910_gpio_chip(chip);
-	void __iomem *pio = w90p910_gpio->regbase + GPIO_OUT;
+	struct nuc900_gpio_chip *nuc900_gpio = to_nuc900_gpio_chip(chip);
+	void __iomem *pio = nuc900_gpio->regbase + GPIO_OUT;
 	unsigned int regval;
 	unsigned long flags;
 
-	spin_lock_irqsave(&w90p910_gpio->gpio_lock, flags);
+	spin_lock_irqsave(&nuc900_gpio->gpio_lock, flags);
 
 	regval = __raw_readl(pio);
 
@@ -81,36 +81,36 @@ static void w90p910_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 
 	__raw_writel(regval, pio);
 
-	spin_unlock_irqrestore(&w90p910_gpio->gpio_lock, flags);
+	spin_unlock_irqrestore(&nuc900_gpio->gpio_lock, flags);
 }
 
-static int w90p910_dir_input(struct gpio_chip *chip, unsigned offset)
+static int nuc900_dir_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct w90p910_gpio_chip *w90p910_gpio = to_w90p910_gpio_chip(chip);
-	void __iomem *pio = w90p910_gpio->regbase + GPIO_DIR;
+	struct nuc900_gpio_chip *nuc900_gpio = to_nuc900_gpio_chip(chip);
+	void __iomem *pio = nuc900_gpio->regbase + GPIO_DIR;
 	unsigned int regval;
 	unsigned long flags;
 
-	spin_lock_irqsave(&w90p910_gpio->gpio_lock, flags);
+	spin_lock_irqsave(&nuc900_gpio->gpio_lock, flags);
 
 	regval = __raw_readl(pio);
 	regval &= ~GPIO_GPIO(offset);
 	__raw_writel(regval, pio);
 
-	spin_unlock_irqrestore(&w90p910_gpio->gpio_lock, flags);
+	spin_unlock_irqrestore(&nuc900_gpio->gpio_lock, flags);
 
 	return 0;
 }
 
-static int w90p910_dir_output(struct gpio_chip *chip, unsigned offset, int val)
+static int nuc900_dir_output(struct gpio_chip *chip, unsigned offset, int val)
 {
-	struct w90p910_gpio_chip *w90p910_gpio = to_w90p910_gpio_chip(chip);
-	void __iomem *outreg = w90p910_gpio->regbase + GPIO_OUT;
-	void __iomem *pio = w90p910_gpio->regbase + GPIO_DIR;
+	struct nuc900_gpio_chip *nuc900_gpio = to_nuc900_gpio_chip(chip);
+	void __iomem *outreg = nuc900_gpio->regbase + GPIO_OUT;
+	void __iomem *pio = nuc900_gpio->regbase + GPIO_DIR;
 	unsigned int regval;
 	unsigned long flags;
 
-	spin_lock_irqsave(&w90p910_gpio->gpio_lock, flags);
+	spin_lock_irqsave(&nuc900_gpio->gpio_lock, flags);
 
 	regval = __raw_readl(pio);
 	regval |= GPIO_GPIO(offset);
@@ -125,28 +125,28 @@ static int w90p910_dir_output(struct gpio_chip *chip, unsigned offset, int val)
 
 	__raw_writel(regval, outreg);
 
-	spin_unlock_irqrestore(&w90p910_gpio->gpio_lock, flags);
+	spin_unlock_irqrestore(&nuc900_gpio->gpio_lock, flags);
 
 	return 0;
 }
 
-static struct w90p910_gpio_chip w90p910_gpio[] = {
-	W90P910_GPIO_CHIP("GROUPC", 0, 16),
-	W90P910_GPIO_CHIP("GROUPD", 16, 10),
-	W90P910_GPIO_CHIP("GROUPE", 26, 14),
-	W90P910_GPIO_CHIP("GROUPF", 40, 10),
-	W90P910_GPIO_CHIP("GROUPG", 50, 17),
-	W90P910_GPIO_CHIP("GROUPH", 67, 8),
-	W90P910_GPIO_CHIP("GROUPI", 75, 17),
+static struct nuc900_gpio_chip nuc900_gpio[] = {
+	NUC900_GPIO_CHIP("GROUPC", 0, 16),
+	NUC900_GPIO_CHIP("GROUPD", 16, 10),
+	NUC900_GPIO_CHIP("GROUPE", 26, 14),
+	NUC900_GPIO_CHIP("GROUPF", 40, 10),
+	NUC900_GPIO_CHIP("GROUPG", 50, 17),
+	NUC900_GPIO_CHIP("GROUPH", 67, 8),
+	NUC900_GPIO_CHIP("GROUPI", 75, 17),
 };
 
-void __init w90p910_init_gpio(int nr_group)
+void __init nuc900_init_gpio(int nr_group)
 {
 	unsigned	i;
-	struct w90p910_gpio_chip *gpio_chip;
+	struct nuc900_gpio_chip *gpio_chip;
 
 	for (i = 0; i < nr_group; i++) {
-		gpio_chip = &w90p910_gpio[i];
+		gpio_chip = &nuc900_gpio[i];
 		spin_lock_init(&gpio_chip->gpio_lock);
 		gpio_chip->regbase = GPIO_BASE + i * GROUPINERV;
 		gpiochip_add(&gpio_chip->chip);
diff --git a/arch/arm/mach-w90x900/irq.c b/arch/arm/mach-w90x900/irq.c
index a296c9b..0ce9d8e 100644
--- a/arch/arm/mach-w90x900/irq.c
+++ b/arch/arm/mach-w90x900/irq.c
@@ -36,13 +36,13 @@ struct group_irq {
 
 static DEFINE_SPINLOCK(groupirq_lock);
 
-#define DEFINE_GROUP(_name, _ctrlbit, _num)			\
-struct group_irq group_##_name = {				\
-		.enable		= w90x900_group_enable,		\
-		.gpen		= ((2 ^ _num) - 1) << _ctrlbit,	\
+#define DEFINE_GROUP(_name, _ctrlbit, _num)				\
+struct group_irq group_##_name = {					\
+		.enable		= nuc900_group_enable,			\
+		.gpen		= ((1 << _num) - 1) << _ctrlbit,	\
 	}
 
-static void w90x900_group_enable(struct group_irq *gpirq, int enable);
+static void nuc900_group_enable(struct group_irq *gpirq, int enable);
 
 static DEFINE_GROUP(nirq0, 0, 4);
 static DEFINE_GROUP(nirq1, 4, 4);
@@ -77,7 +77,7 @@ static void group_irq_disable(struct group_irq *group_irq)
 	spin_unlock_irqrestore(&groupirq_lock, flags);
 }
 
-static void w90x900_group_enable(struct group_irq *gpirq, int enable)
+static void nuc900_group_enable(struct group_irq *gpirq, int enable)
 {
 	unsigned int groupen = gpirq->gpen;
 	unsigned long regval;
@@ -92,7 +92,7 @@ static void w90x900_group_enable(struct group_irq *gpirq, int enable)
 	__raw_writel(regval, REG_AIC_GEN);
 }
 
-static void w90x900_irq_mask(unsigned int irq)
+static void nuc900_irq_mask(unsigned int irq)
 {
 	struct group_irq *group_irq;
 
@@ -143,12 +143,12 @@ static void w90x900_irq_mask(unsigned int irq)
  * to REG_AIC_EOSCR for ACK
  */
 
-static void w90x900_irq_ack(unsigned int irq)
+static void nuc900_irq_ack(unsigned int irq)
 {
 	__raw_writel(0x01, REG_AIC_EOSCR);
 }
 
-static void w90x900_irq_unmask(unsigned int irq)
+static void nuc900_irq_unmask(unsigned int irq)
 {
 	struct group_irq *group_irq;
 
@@ -194,20 +194,20 @@ static void w90x900_irq_unmask(unsigned int irq)
 		group_irq_enable(group_irq);
 }
 
-static struct irq_chip w90x900_irq_chip = {
-	.ack	   = w90x900_irq_ack,
-	.mask	   = w90x900_irq_mask,
-	.unmask	   = w90x900_irq_unmask,
+static struct irq_chip nuc900_irq_chip = {
+	.ack	   = nuc900_irq_ack,
+	.mask	   = nuc900_irq_mask,
+	.unmask	   = nuc900_irq_unmask,
 };
 
-void __init w90x900_init_irq(void)
+void __init nuc900_init_irq(void)
 {
 	int irqno;
 
 	__raw_writel(0xFFFFFFFE, REG_AIC_MDCR);
 
 	for (irqno = IRQ_WDT; irqno <= IRQ_ADC; irqno++) {
-		set_irq_chip(irqno, &w90x900_irq_chip);
+		set_irq_chip(irqno, &nuc900_irq_chip);
 		set_irq_handler(irqno, handle_level_irq);
 		set_irq_flags(irqno, IRQF_VALID);
 	}
diff --git a/arch/arm/mach-w90x900/mach-nuc910evb.c b/arch/arm/mach-w90x900/mach-nuc910evb.c
new file mode 100644
index 0000000..ec05bda
--- /dev/null
+++ b/arch/arm/mach-w90x900/mach-nuc910evb.c
@@ -0,0 +1,44 @@
+/*
+ * linux/arch/arm/mach-w90x900/mach-nuc910evb.c
+ *
+ * Based on mach-s3c2410/mach-smdk2410.c by Jonas Dietsche
+ *
+ * Copyright (C) 2008 Nuvoton technology corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach-types.h>
+#include <mach/map.h>
+
+#include "nuc910.h"
+
+static void __init nuc910evb_map_io(void)
+{
+	nuc910_map_io();
+	nuc910_init_clocks();
+}
+
+static void __init nuc910evb_init(void)
+{
+	nuc910_board_init();
+}
+
+MACHINE_START(W90P910EVB, "W90P910EVB")
+	/* Maintainer: Wan ZongShun */
+	.phys_io	= W90X900_PA_UART,
+	.io_pg_offst	= (((u32)W90X900_VA_UART) >> 18) & 0xfffc,
+	.boot_params	= 0,
+	.map_io		= nuc910evb_map_io,
+	.init_irq	= nuc900_init_irq,
+	.init_machine	= nuc910evb_init,
+	.timer		= &nuc900_timer,
+MACHINE_END
diff --git a/arch/arm/mach-w90x900/mach-w90p910evb.c b/arch/arm/mach-w90x900/mach-w90p910evb.c
deleted file mode 100644
index 117578a..0000000
--- a/arch/arm/mach-w90x900/mach-w90p910evb.c
+++ /dev/null
@@ -1,407 +0,0 @@
-/*
- * linux/arch/arm/mach-w90x900/mach-w90p910evb.c
- *
- * Based on mach-s3c2410/mach-smdk2410.c by Jonas Dietsche
- *
- * Copyright (C) 2008 Nuvoton technology corporation.
- *
- * Wan ZongShun <mcuos.com@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation;version 2 of the License.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/interrupt.h>
-#include <linux/list.h>
-#include <linux/timer.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-
-#include <linux/mtd/physmap.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-
-#include <linux/spi/spi.h>
-#include <linux/spi/flash.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/irq.h>
-#include <asm/mach-types.h>
-
-#include <mach/regs-serial.h>
-#include <mach/map.h>
-
-#include "cpu.h"
-/*w90p910 evb norflash driver data */
-
-#define W90P910_FLASH_BASE	0xA0000000
-#define W90P910_FLASH_SIZE	0x400000
-#define SPIOFFSET		0x200
-#define SPIOREG_SIZE		0x100
-
-static struct mtd_partition w90p910_flash_partitions[] = {
-	{
-		.name	=	"NOR Partition 1 for kernel (960K)",
-		.size	=	0xF0000,
-		.offset	=	0x10000,
-	},
-	{
-		.name	=	"NOR Partition 2 for image (1M)",
-		.size	=	0x100000,
-		.offset	=	0x100000,
-	},
-	{
-		.name	=	"NOR Partition 3 for user (2M)",
-		.size	=	0x200000,
-		.offset	=	0x00200000,
-	}
-};
-
-static struct physmap_flash_data w90p910_flash_data = {
-	.width		=	2,
-	.parts		=	w90p910_flash_partitions,
-	.nr_parts	=	ARRAY_SIZE(w90p910_flash_partitions),
-};
-
-static struct resource w90p910_flash_resources[] = {
-	{
-		.start	=	W90P910_FLASH_BASE,
-		.end	=	W90P910_FLASH_BASE + W90P910_FLASH_SIZE - 1,
-		.flags	=	IORESOURCE_MEM,
-	}
-};
-
-static struct platform_device w90p910_flash_device = {
-	.name		=	"physmap-flash",
-	.id		=	0,
-	.dev		= {
-				.platform_data = &w90p910_flash_data,
-			},
-	.resource	=	w90p910_flash_resources,
-	.num_resources	=	ARRAY_SIZE(w90p910_flash_resources),
-};
-
-/* USB EHCI Host Controller */
-
-static struct resource w90x900_usb_ehci_resource[] = {
-	[0] = {
-		.start = W90X900_PA_USBEHCIHOST,
-		.end   = W90X900_PA_USBEHCIHOST + W90X900_SZ_USBEHCIHOST - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_USBH,
-		.end   = IRQ_USBH,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static u64 w90x900_device_usb_ehci_dmamask = 0xffffffffUL;
-
-struct platform_device w90x900_device_usb_ehci = {
-	.name		  = "w90x900-ehci",
-	.id		  = -1,
-	.num_resources	  = ARRAY_SIZE(w90x900_usb_ehci_resource),
-	.resource	  = w90x900_usb_ehci_resource,
-	.dev              = {
-		.dma_mask = &w90x900_device_usb_ehci_dmamask,
-		.coherent_dma_mask = 0xffffffffUL
-	}
-};
-EXPORT_SYMBOL(w90x900_device_usb_ehci);
-
-/* USB OHCI Host Controller */
-
-static struct resource w90x900_usb_ohci_resource[] = {
-	[0] = {
-		.start = W90X900_PA_USBOHCIHOST,
-		.end   = W90X900_PA_USBOHCIHOST + W90X900_SZ_USBOHCIHOST - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_USBH,
-		.end   = IRQ_USBH,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static u64 w90x900_device_usb_ohci_dmamask = 0xffffffffUL;
-struct platform_device w90x900_device_usb_ohci = {
-	.name		  = "w90x900-ohci",
-	.id		  = -1,
-	.num_resources	  = ARRAY_SIZE(w90x900_usb_ohci_resource),
-	.resource	  = w90x900_usb_ohci_resource,
-	.dev              = {
-		.dma_mask = &w90x900_device_usb_ohci_dmamask,
-		.coherent_dma_mask = 0xffffffffUL
-	}
-};
-EXPORT_SYMBOL(w90x900_device_usb_ohci);
-
-/*TouchScreen controller*/
-
-static struct resource w90x900_ts_resource[] = {
-	[0] = {
-		.start = W90X900_PA_ADC,
-		.end   = W90X900_PA_ADC + W90X900_SZ_ADC-1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_ADC,
-		.end   = IRQ_ADC,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device w90x900_device_ts = {
-	.name		= "w90x900-ts",
-	.id		= -1,
-	.resource	= w90x900_ts_resource,
-	.num_resources	= ARRAY_SIZE(w90x900_ts_resource),
-};
-EXPORT_SYMBOL(w90x900_device_ts);
-
-/* RTC controller*/
-
-static struct resource w90x900_rtc_resource[] = {
-	[0] = {
-		.start = W90X900_PA_RTC,
-		.end   = W90X900_PA_RTC + 0xff,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_RTC,
-		.end   = IRQ_RTC,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device w90x900_device_rtc = {
-	.name		= "w90x900-rtc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_rtc_resource),
-	.resource	= w90x900_rtc_resource,
-};
-EXPORT_SYMBOL(w90x900_device_rtc);
-
-/* KPI controller*/
-
-static struct resource w90x900_kpi_resource[] = {
-	[0] = {
-		.start = W90X900_PA_KPI,
-		.end   = W90X900_PA_KPI + W90X900_SZ_KPI - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_KPI,
-		.end   = IRQ_KPI,
-		.flags = IORESOURCE_IRQ,
-	}
-
-};
-
-struct platform_device w90x900_device_kpi = {
-	.name		= "w90x900-kpi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_kpi_resource),
-	.resource	= w90x900_kpi_resource,
-};
-EXPORT_SYMBOL(w90x900_device_kpi);
-
-/* USB Device (Gadget)*/
-
-static struct resource w90x900_usbgadget_resource[] = {
-	[0] = {
-		.start = W90X900_PA_USBDEV,
-		.end   = W90X900_PA_USBDEV + W90X900_SZ_USBDEV - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_USBD,
-		.end   = IRQ_USBD,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-struct platform_device w90x900_device_usbgadget = {
-	.name		= "w90x900-usbgadget",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_usbgadget_resource),
-	.resource	= w90x900_usbgadget_resource,
-};
-EXPORT_SYMBOL(w90x900_device_usbgadget);
-
-/* FMI Device */
-
-static struct resource w90p910_fmi_resource[] = {
-	[0] = {
-		.start = W90X900_PA_FMI,
-		.end   = W90X900_PA_FMI + W90X900_SZ_FMI - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_FMI,
-		.end   = IRQ_FMI,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device w90p910_device_fmi = {
-	.name		= "w90p910-fmi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90p910_fmi_resource),
-	.resource	= w90p910_fmi_resource,
-};
-
-/* MAC device */
-
-static struct resource w90x900_emc_resource[] = {
-	[0] = {
-		.start = W90X900_PA_EMC,
-		.end   = W90X900_PA_EMC + W90X900_SZ_EMC - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_EMCTX,
-		.end   = IRQ_EMCTX,
-		.flags = IORESOURCE_IRQ,
-	},
-	[2] = {
-		.start = IRQ_EMCRX,
-		.end   = IRQ_EMCRX,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static u64 w90x900_device_emc_dmamask = 0xffffffffUL;
-static struct platform_device w90p910_device_emc = {
-	.name		= "w90p910-emc",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90x900_emc_resource),
-	.resource	= w90x900_emc_resource,
-	.dev              = {
-		.dma_mask = &w90x900_device_emc_dmamask,
-		.coherent_dma_mask = 0xffffffffUL
-	}
-};
-
-/* SPI device */
-
-static struct resource w90p910_spi_resource[] = {
-	[0] = {
-		.start = W90X900_PA_I2C + SPIOFFSET,
-		.end   = W90X900_PA_I2C + SPIOFFSET + SPIOREG_SIZE - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_SSP,
-		.end   = IRQ_SSP,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device w90p910_device_spi = {
-	.name		= "w90p910-spi",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90p910_spi_resource),
-	.resource	= w90p910_spi_resource,
-};
-
-/* spi device, spi flash info */
-
-static struct mtd_partition w90p910_spi_flash_partitions[] = {
-	{
-		.name = "bootloader(spi)",
-		.size = 0x0100000,
-		.offset = 0,
-	},
-};
-
-static struct flash_platform_data w90p910_spi_flash_data = {
-	.name = "m25p80",
-	.parts =  w90p910_spi_flash_partitions,
-	.nr_parts = ARRAY_SIZE(w90p910_spi_flash_partitions),
-	.type = "w25x16",
-};
-
-static struct spi_board_info w90p910_spi_board_info[] __initdata = {
-	{
-		.modalias = "m25p80",
-		.max_speed_hz = 20000000,
-		.bus_num = 0,
-		.chip_select = 1,
-		.platform_data = &w90p910_spi_flash_data,
-		.mode = SPI_MODE_0,
-	},
-};
-
-/* WDT Device */
-
-static struct resource w90p910_wdt_resource[] = {
-	[0] = {
-		.start = W90X900_PA_TIMER,
-		.end   = W90X900_PA_TIMER + W90X900_SZ_TIMER - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_WDT,
-		.end   = IRQ_WDT,
-		.flags = IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device w90p910_device_wdt = {
-	.name		= "w90p910-wdt",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(w90p910_wdt_resource),
-	.resource	= w90p910_wdt_resource,
-};
-
-static struct map_desc w90p910_iodesc[] __initdata = {
-};
-
-/*Here should be your evb resourse,such as LCD*/
-
-static struct platform_device *w90p910evb_dev[] __initdata = {
-	&w90p910_serial_device,
-	&w90p910_flash_device,
-	&w90x900_device_usb_ehci,
-	&w90x900_device_usb_ohci,
-	&w90x900_device_ts,
-	&w90x900_device_rtc,
-	&w90x900_device_kpi,
-	&w90x900_device_usbgadget,
-	&w90p910_device_fmi,
-	&w90p910_device_emc,
-	&w90p910_device_spi,
-	&w90p910_device_wdt,
-};
-
-static void __init w90p910evb_map_io(void)
-{
-	w90p910_map_io(w90p910_iodesc, ARRAY_SIZE(w90p910_iodesc));
-	w90p910_init_clocks();
-}
-
-static void __init w90p910evb_init(void)
-{
-	platform_add_devices(w90p910evb_dev, ARRAY_SIZE(w90p910evb_dev));
-	spi_register_board_info(w90p910_spi_board_info,
-					ARRAY_SIZE(w90p910_spi_board_info));
-}
-
-MACHINE_START(W90P910EVB, "W90P910EVB")
-	/* Maintainer: Wan ZongShun */
-	.phys_io	= W90X900_PA_UART,
-	.io_pg_offst	= (((u32)W90X900_VA_UART) >> 18) & 0xfffc,
-	.boot_params	= 0,
-	.map_io		= w90p910evb_map_io,
-	.init_irq	= w90x900_init_irq,
-	.init_machine	= w90p910evb_init,
-	.timer		= &w90x900_timer,
-MACHINE_END
diff --git a/arch/arm/mach-w90x900/mfp-w90p910.c b/arch/arm/mach-w90x900/mfp.c
similarity index 77%
rename from arch/arm/mach-w90x900/mfp-w90p910.c
rename to arch/arm/mach-w90x900/mfp.c
index 4533098..a47dc9a 100644
--- a/arch/arm/mach-w90x900/mfp-w90p910.c
+++ b/arch/arm/mach-w90x900/mfp.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-w90x900/mfp-w90p910.c
+ * linux/arch/arm/mach-w90x900/mfp.c
  *
  * Copyright (c) 2008 Nuvoton technology corporation
  *
@@ -55,7 +55,7 @@ void mfp_set_groupf(struct device *dev)
 
 	mfpen = __raw_readl(REG_MFSEL);
 
-	if (strcmp(dev_id, "w90p910-emc") == 0)
+	if (strcmp(dev_id, "nuc900-emc") == 0)
 		mfpen |= GPSELF;/*enable mac*/
 	else
 		mfpen &= ~GPSELF;/*GPIOF[9:0]*/
@@ -79,16 +79,16 @@ void mfp_set_groupc(struct device *dev)
 
 	mfpen = __raw_readl(REG_MFSEL);
 
-	if (strcmp(dev_id, "w90p910-lcd") == 0)
+	if (strcmp(dev_id, "nuc900-lcd") == 0)
 		mfpen |= GPSELC;/*enable lcd*/
-	else if (strcmp(dev_id, "w90p910-kpi") == 0) {
-			mfpen &= (~GPSELC);/*enable kpi*/
-			mfpen |= ENKPI;
-		} else if (strcmp(dev_id, "w90p910-nand") == 0) {
-				mfpen &= (~GPSELC);/*enable nand*/
-				mfpen |= ENNAND;
-			} else
-				mfpen &= (~GPSELC);/*GPIOC[14:0]*/
+	else if (strcmp(dev_id, "nuc900-kpi") == 0) {
+		mfpen &= (~GPSELC);/*enable kpi*/
+		mfpen |= ENKPI;
+	} else if (strcmp(dev_id, "nuc900-nand") == 0) {
+		mfpen &= (~GPSELC);/*enable nand*/
+		mfpen |= ENNAND;
+	} else
+		mfpen &= (~GPSELC);/*GPIOC[14:0]*/
 
 	__raw_writel(mfpen, REG_MFSEL);
 
@@ -111,12 +111,12 @@ void mfp_set_groupi(struct device *dev)
 
 	mfpen &= ~GPSELEI1;/*default gpio16*/
 
-	if (strcmp(dev_id, "w90p910-wdog") == 0)
+	if (strcmp(dev_id, "nuc900-wdog") == 0)
 		mfpen |= GPSELEI1;/*enable wdog*/
-		else if (strcmp(dev_id, "w90p910-atapi") == 0)
-			mfpen |= GPSELEI0;/*enable atapi*/
-			else if (strcmp(dev_id, "w90p910-keypad") == 0)
-				mfpen &= ~GPSELEI0;/*enable keypad*/
+	else if (strcmp(dev_id, "nuc900-atapi") == 0)
+		mfpen |= GPSELEI0;/*enable atapi*/
+	else if (strcmp(dev_id, "nuc900-keypad") == 0)
+		mfpen &= ~GPSELEI0;/*enable keypad*/
 
 	__raw_writel(mfpen, REG_MFSEL);
 
@@ -137,13 +137,13 @@ void mfp_set_groupg(struct device *dev)
 
 	mfpen = __raw_readl(REG_MFSEL);
 
-	if (strcmp(dev_id, "w90p910-spi") == 0) {
+	if (strcmp(dev_id, "nuc900-spi") == 0) {
 		mfpen &= ~(GPIOG0TO1 | GPIOG2TO3);
 		mfpen |= ENSPI;/*enable spi*/
-	} else if (strcmp(dev_id, "w90p910-i2c0") == 0) {
+	} else if (strcmp(dev_id, "nuc900-i2c0") == 0) {
 		mfpen &= ~(GPIOG0TO1);
 		mfpen |= ENI2C0;/*enable i2c0*/
-	} else if (strcmp(dev_id, "w90p910-i2c1") == 0) {
+	} else if (strcmp(dev_id, "nuc900-i2c1") == 0) {
 		mfpen &= ~(GPIOG2TO3);
 		mfpen |= ENI2C1;/*enable i2c1*/
 	} else {
diff --git a/arch/arm/mach-w90x900/nuc910.c b/arch/arm/mach-w90x900/nuc910.c
new file mode 100644
index 0000000..656f03b
--- /dev/null
+++ b/arch/arm/mach-w90x900/nuc910.c
@@ -0,0 +1,60 @@
+/*
+ * linux/arch/arm/mach-w90x900/nuc910.c
+ *
+ * Based on linux/arch/arm/plat-s3c24xx/s3c244x.c by Ben Dooks
+ *
+ * Copyright (c) 2009 Nuvoton corporation.
+ *
+ * Wan ZongShun <mcuos.com@gmail.com>
+ *
+ * NUC910 cpu support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation;version 2 of the License.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <asm/mach/map.h>
+#include <mach/hardware.h>
+#include "cpu.h"
+#include "clock.h"
+
+/* define specific CPU platform device */
+
+static struct platform_device *nuc910_dev[] __initdata = {
+	&nuc900_device_ts,
+	&nuc900_device_rtc,
+};
+
+/* define specific CPU platform io map */
+
+static struct map_desc nuc910evb_iodesc[] __initdata = {
+	IODESC_ENT(USBEHCIHOST),
+	IODESC_ENT(USBOHCIHOST),
+	IODESC_ENT(KPI),
+	IODESC_ENT(USBDEV),
+	IODESC_ENT(ADC),
+};
+
+/*Init NUC910 evb io*/
+
+void __init nuc910_map_io(void)
+{
+	nuc900_map_io(nuc910evb_iodesc, ARRAY_SIZE(nuc910evb_iodesc));
+}
+
+/*Init NUC910 clock*/
+
+void __init nuc910_init_clocks(void)
+{
+	nuc900_init_clocks();
+}
+
+/*Init NUC910 board info*/
+
+void __init nuc910_board_init(void)
+{
+	nuc900_board_init(nuc910_dev, ARRAY_SIZE(nuc910_dev));
+}
diff --git a/arch/arm/mach-w90x900/nuc910.h b/arch/arm/mach-w90x900/nuc910.h
new file mode 100644
index 0000000..83e9ba5
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
+extern void nuc900_init_irq(void);
+extern struct sys_timer nuc900_timer;
+
+/* extern file from nuc910.c */
+
+extern void nuc910_board_init(void);
+extern void nuc910_init_clocks(void);
+extern void nuc910_map_io(void);
diff --git a/arch/arm/mach-w90x900/time.c b/arch/arm/mach-w90x900/time.c
index 5e06770..4128af8 100644
--- a/arch/arm/mach-w90x900/time.c
+++ b/arch/arm/mach-w90x900/time.c
@@ -44,7 +44,7 @@
 
 unsigned int timer0_load;
 
-static void w90p910_clockevent_setmode(enum clock_event_mode mode,
+static void nuc900_clockevent_setmode(enum clock_event_mode mode,
 		struct clock_event_device *clk)
 {
 	unsigned int val;
@@ -71,7 +71,7 @@ static void w90p910_clockevent_setmode(enum clock_event_mode mode,
 	__raw_writel(val, REG_TCSR0);
 }
 
-static int w90p910_clockevent_setnextevent(unsigned long evt,
+static int nuc900_clockevent_setnextevent(unsigned long evt,
 		struct clock_event_device *clk)
 {
 	unsigned int val;
@@ -85,20 +85,20 @@ static int w90p910_clockevent_setnextevent(unsigned long evt,
 	return 0;
 }
 
-static struct clock_event_device w90p910_clockevent_device = {
-	.name		= "w90p910-timer0",
+static struct clock_event_device nuc900_clockevent_device = {
+	.name		= "nuc900-timer0",
 	.shift		= 32,
 	.features	= CLOCK_EVT_MODE_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= w90p910_clockevent_setmode,
-	.set_next_event	= w90p910_clockevent_setnextevent,
+	.set_mode	= nuc900_clockevent_setmode,
+	.set_next_event	= nuc900_clockevent_setnextevent,
 	.rating		= 300,
 };
 
 /*IRQ handler for the timer*/
 
-static irqreturn_t w90p910_timer0_interrupt(int irq, void *dev_id)
+static irqreturn_t nuc900_timer0_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = &w90p910_clockevent_device;
+	struct clock_event_device *evt = &nuc900_clockevent_device;
 
 	__raw_writel(0x01, REG_TISR); /* clear TIF0 */
 
@@ -106,40 +106,40 @@ static irqreturn_t w90p910_timer0_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static struct irqaction w90p910_timer0_irq = {
-	.name		= "w90p910-timer0",
+static struct irqaction nuc900_timer0_irq = {
+	.name		= "nuc900-timer0",
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.handler	= w90p910_timer0_interrupt,
+	.handler	= nuc900_timer0_interrupt,
 };
 
-static void __init w90p910_clockevents_init(unsigned int rate)
+static void __init nuc900_clockevents_init(unsigned int rate)
 {
-	w90p910_clockevent_device.mult = div_sc(rate, NSEC_PER_SEC,
-					w90p910_clockevent_device.shift);
-	w90p910_clockevent_device.max_delta_ns = clockevent_delta2ns(0xffffffff,
-					&w90p910_clockevent_device);
-	w90p910_clockevent_device.min_delta_ns = clockevent_delta2ns(0xf,
-					&w90p910_clockevent_device);
-	w90p910_clockevent_device.cpumask = cpumask_of(0);
-
-	clockevents_register_device(&w90p910_clockevent_device);
+	nuc900_clockevent_device.mult = div_sc(rate, NSEC_PER_SEC,
+					nuc900_clockevent_device.shift);
+	nuc900_clockevent_device.max_delta_ns = clockevent_delta2ns(0xffffffff,
+					&nuc900_clockevent_device);
+	nuc900_clockevent_device.min_delta_ns = clockevent_delta2ns(0xf,
+					&nuc900_clockevent_device);
+	nuc900_clockevent_device.cpumask = cpumask_of(0);
+
+	clockevents_register_device(&nuc900_clockevent_device);
 }
 
-static cycle_t w90p910_get_cycles(struct clocksource *cs)
+static cycle_t nuc900_get_cycles(struct clocksource *cs)
 {
 	return ~__raw_readl(REG_TDR1);
 }
 
-static struct clocksource clocksource_w90p910 = {
-	.name	= "w90p910-timer1",
+static struct clocksource clocksource_nuc900 = {
+	.name	= "nuc900-timer1",
 	.rating	= 200,
-	.read	= w90p910_get_cycles,
+	.read	= nuc900_get_cycles,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.shift	= 20,
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-static void __init w90p910_clocksource_init(unsigned int rate)
+static void __init nuc900_clocksource_init(unsigned int rate)
 {
 	unsigned int val;
 
@@ -149,12 +149,12 @@ static void __init w90p910_clocksource_init(unsigned int rate)
 	val |= (COUNTEN | PERIOD);
 	__raw_writel(val, REG_TCSR1);
 
-	clocksource_w90p910.mult =
-		clocksource_khz2mult((rate / 1000), clocksource_w90p910.shift);
-	clocksource_register(&clocksource_w90p910);
+	clocksource_nuc900.mult =
+		clocksource_khz2mult((rate / 1000), clocksource_nuc900.shift);
+	clocksource_register(&clocksource_nuc900);
 }
 
-static void __init w90p910_timer_init(void)
+static void __init nuc900_timer_init(void)
 {
 	struct clk *ck_ext = clk_get(NULL, "ext");
 	unsigned int	rate;
@@ -171,12 +171,12 @@ static void __init w90p910_timer_init(void)
 	__raw_writel(RESETINT, REG_TISR);
 	timer0_load = (rate / TICKS_PER_SEC);
 
-	setup_irq(IRQ_TIMER0, &w90p910_timer0_irq);
+	setup_irq(IRQ_TIMER0, &nuc900_timer0_irq);
 
-	w90p910_clocksource_init(rate);
-	w90p910_clockevents_init(rate);
+	nuc900_clocksource_init(rate);
+	nuc900_clockevents_init(rate);
 }
 
-struct sys_timer w90x900_timer = {
-	.init		= w90p910_timer_init,
+struct sys_timer nuc900_timer = {
+	.init		= nuc900_timer_init,
 };
-- 
1.5.6.3
