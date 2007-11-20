Return-Path: <linux-kernel-owner+w=401wt.eu-S1764011AbXKTUwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764011AbXKTUwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760902AbXKTUwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:52:33 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:38499 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760770AbXKTUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:52:32 -0500
Subject: [patch] 4/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-D5mov0wbQZvySymjlKQT"
Date: Tue, 20 Nov 2007 20:49:19 +0000
Message-Id: <1195591759.2329.65.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D5mov0wbQZvySymjlKQT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi guys.

This patchset contains support for three toshiba multifunction devices.

This patch adds platform support for the TMIO devices used by the various
e-series platforms.

It depends on the previous patch in this series.

--=-D5mov0wbQZvySymjlKQT
Content-Disposition: attachment; filename*0=0004-add-eseries-platform-support-for-the-TMIO-multifunct.pat; filename*1=ch
Content-Type: application/mbox; name=0004-add-eseries-platform-support-for-the-TMIO-multifunct.patch
Content-Transfer-Encoding: 7bit

>From 0c3e77cd4ddfc1220370083e42373c071d0bb848 Mon Sep 17 00:00:00 2001
From: Ian Molton <spyro@f2s.com>
Date: Tue, 20 Nov 2007 19:58:45 +0000
Subject: [PATCH] add eseries platform support for the TMIO multifunction devices used.

---
 arch/arm/mach-pxa/Makefile        |   10 ++--
 arch/arm/mach-pxa/e330_tc6387xb.c |   88 ++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/e400_t7l66xb.c  |   96 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/e740_t7l66xb.c  |   93 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/e750_tc6393xb.c |   99 +++++++++++++++++++++++++++++++++++++
 5 files changed, 381 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-pxa/e330_tc6387xb.c
 create mode 100644 arch/arm/mach-pxa/e400_t7l66xb.c
 create mode 100644 arch/arm/mach-pxa/e740_t7l66xb.c
 create mode 100644 arch/arm/mach-pxa/e750_tc6393xb.c

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index c78022f..5b8b9ac 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -30,11 +30,11 @@ ifeq ($(CONFIG_MACH_ZYLONITE),y)
 endif
 
 obj-$(CONFIG_ARCH_PXA_ESERIES)	+= eseries.o
-obj-$(CONFIG_MACH_E330)		+= e330_lcd.o
-obj-$(CONFIG_MACH_E740)		+= e740_lcd.o
-obj-$(CONFIG_MACH_E750)		+= e750_lcd.o
-obj-$(CONFIG_MACH_E400)		+= e400_lcd.o
-obj-$(CONFIG_MACH_E800)		+= e800_lcd.o
+obj-$(CONFIG_MACH_E330)		+= e330_lcd.o e330_tc6387xb.o
+obj-$(CONFIG_MACH_E740)		+= e740_lcd.o e740_t7l66xb.o
+obj-$(CONFIG_MACH_E750)		+= e750_lcd.o e750_tc6393xb.o
+obj-$(CONFIG_MACH_E400)		+= e400_lcd.o e400_t7l66xb.o
+obj-$(CONFIG_MACH_E800)		+= e800_lcd.o e750_tc6393xb.o
 
 obj-$(CONFIG_MACH_ARMCORE)      += cm-x270.o
 
diff --git a/arch/arm/mach-pxa/e330_tc6387xb.c b/arch/arm/mach-pxa/e330_tc6387xb.c
new file mode 100644
index 0000000..515228b
--- /dev/null
+++ b/arch/arm/mach-pxa/e330_tc6387xb.c
@@ -0,0 +1,88 @@
+/* platform specific code to drive the TC6387XB chip on the e330. */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+#include <asm/mach-types.h>
+#include <asm/arch/hardware.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/irq.h>
+
+#include <asm/arch/eseries-irq.h>
+#include <asm/arch/eseries-gpio.h>
+
+#include <linux/tc6387xb.h>
+
+static struct resource e330_tc6387xb_resources[] = {
+	[0] = {
+		.start  = PXA_CS4_PHYS,
+		.end    = PXA_CS4_PHYS + 0x1fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_GPIO(5),
+		.end    = IRQ_GPIO(5),
+		.flags  = IORESOURCE_IRQ,
+	},
+
+};
+
+//FIXME - who should really be setting up the clock? bootloader or kernel ?
+static void e330_tc6387xb_hwinit(void) {
+	GPCR(45) = GPIO_bit(45); // #SUSPEND low
+	GPCR(19) = GPIO_bit(19); // #PCLR low (reset)
+	// 33MHz is supplied from an Xtal on the e330 (I think)
+	pxa_gpio_mode(GPIO12_32KHz_MD);
+	mdelay(10);
+	GPSR(45) = GPIO_bit(45); // #SUSPEND high
+	mdelay(10);
+	GPSR(19) = GPIO_bit(19); // #PCLR high
+	mdelay(10);
+}
+
+static void e330_tc6387xb_suspend(void) {
+	GPCR(45) = GPIO_bit(45); // #SUSPEND low
+	mdelay(10);
+//	GPCR(19) = GPIO_bit(19); // #PCLR low
+}
+
+static void e330_tc6387xb_resume(void) {
+	GPSR(45) = GPIO_bit(45); // #SUSPEND high
+        mdelay(10);
+}
+
+static struct tc6387xb_platform_data e330_tc6387xb_info = {
+	.hw_init                = &e330_tc6387xb_hwinit,
+	.suspend                = &e330_tc6387xb_suspend,
+	.resume                 = &e330_tc6387xb_resume,
+};
+
+static struct platform_device e330_tc6387xb_device = {
+	.name           = "tc6387xb",
+	.id             = -1,
+	.dev            = {
+		.platform_data = &e330_tc6387xb_info, 
+	},
+	.num_resources = ARRAY_SIZE(e330_tc6387xb_resources),
+	.resource      = e330_tc6387xb_resources,
+}; 
+
+static int __init e330_tc6387xb_init(void)
+{
+	if(!machine_is_e330())
+		return -ENODEV;
+
+	platform_device_register(&e330_tc6387xb_device);
+	return 0;
+}
+
+module_init(e330_tc6387xb_init);
+
+MODULE_AUTHOR("Ian Molton <spyro@f2s.com>");
+MODULE_DESCRIPTION("e330 tc6387xb device support");
+MODULE_LICENSE("GPLv2");
+
+
diff --git a/arch/arm/mach-pxa/e400_t7l66xb.c b/arch/arm/mach-pxa/e400_t7l66xb.c
new file mode 100644
index 0000000..bdf21b7
--- /dev/null
+++ b/arch/arm/mach-pxa/e400_t7l66xb.c
@@ -0,0 +1,96 @@
+/* platform specific code to drive the T7L66XB chip on the e400. */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+#include <asm/mach-types.h>
+#include <asm/arch/hardware.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/irq.h>
+
+#include <asm/arch/eseries-irq.h>
+#include <asm/arch/eseries-gpio.h>
+
+#include <linux/t7l66xb.h>
+
+//FIXME - set properly when known
+#define GPIO_E400_TMIO_IRQ GPIO_ESERIES_TMIO_IRQ
+
+static struct resource e400_t7l66xb_resources[] = {
+	[0] = {
+		.start  = PXA_CS4_PHYS,
+		.end    = PXA_CS4_PHYS + 0x1fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_GPIO(GPIO_E400_TMIO_IRQ),
+		.end    = IRQ_GPIO(GPIO_E400_TMIO_IRQ),
+		.flags  = IORESOURCE_IRQ,
+	},
+
+};
+
+//FIXME - who should really be setting up the clock? bootloader or kernel ?
+static void e400_t7l66xb_hwinit(void) {
+	return;
+	GPCR(19) = GPIO_bit(19); // #SUSPEND low
+	GPCR(7) = GPIO_bit(7); // #PCLR low (reset)
+	pxa_gpio_mode(GPIO7_48MHz_MD);
+	pxa_gpio_mode(GPIO12_32KHz_MD);
+	mdelay(10);
+	GPSR(19) = GPIO_bit(19); // #SUSPEND high
+	mdelay(10);
+	GPSR(7) = GPIO_bit(7); // #PCLR high
+	mdelay(10);
+}
+
+static void e400_t7l66xb_suspend(void) {
+	return;
+	GPCR(19) = GPIO_bit(19); // #SUSPEND low
+	mdelay(10);
+	GPCR(7) = GPIO_bit(7); // #PCLR low
+	
+	/* kill clock */
+//	pxa_gpio_mode(GPIO7_48MHz_MD|GPIO_OUT);
+//	GPSR0 = GPIO_bit(GPIO7_48MHz);
+}
+
+static void e400_t7l66xb_resume(void) {
+	e400_t7l66xb_hwinit();
+}
+
+static struct t7l66xb_platform_data e400_t7l66xb_info = {
+	.irq_base 		= IRQ_BOARD_START,
+	.hw_init                = &e400_t7l66xb_hwinit,
+	.suspend                = &e400_t7l66xb_suspend,
+	.resume                 = &e400_t7l66xb_resume,
+};
+
+static struct platform_device e400_t7l66xb_device = {
+	.name           = "t7l66xb",
+	.id             = -1,
+	.dev            = {
+		.platform_data = &e400_t7l66xb_info, 
+	},
+	.num_resources = ARRAY_SIZE(e400_t7l66xb_resources),
+	.resource      = e400_t7l66xb_resources,
+}; 
+
+static int __init e400_t7l66xb_init(void)
+{
+	if(!machine_is_e400())
+		return -ENODEV;
+
+	platform_device_register(&e400_t7l66xb_device);
+	return 0;
+}
+
+module_init(e400_t7l66xb_init);
+
+MODULE_AUTHOR("Ian Molton <spyro@f2s.com>");
+MODULE_DESCRIPTION("e400 t7l66xb device support");
+MODULE_LICENSE("GPLv2");
+
diff --git a/arch/arm/mach-pxa/e740_t7l66xb.c b/arch/arm/mach-pxa/e740_t7l66xb.c
new file mode 100644
index 0000000..6b62697
--- /dev/null
+++ b/arch/arm/mach-pxa/e740_t7l66xb.c
@@ -0,0 +1,93 @@
+/* platform specific code to drive the T7L66XB chip on the e740. */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+
+#include <asm/mach-types.h>
+#include <asm/arch/hardware.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/irq.h>
+
+#include <asm/arch/eseries-irq.h>
+#include <asm/arch/eseries-gpio.h>
+
+#include <linux/t7l66xb.h>
+
+static struct resource e740_t7l66xb_resources[] = {
+	[0] = {
+		.start  = PXA_CS4_PHYS,
+		.end    = PXA_CS4_PHYS + 0x1fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_GPIO(GPIO_ESERIES_TMIO_IRQ),
+		.end    = IRQ_GPIO(GPIO_ESERIES_TMIO_IRQ),
+		.flags  = IORESOURCE_IRQ,
+	},
+
+};
+
+//FIXME - who should really be setting up the clock? bootloader or kernel ?
+static void e740_t7l66xb_hwinit(void) {
+
+	GPCR(19) = GPIO_bit(19); // #SUSPEND low
+	GPCR(7) = GPIO_bit(7); // #PCLR low (reset)
+	pxa_gpio_mode(GPIO7_48MHz_MD);
+	pxa_gpio_mode(GPIO12_32KHz_MD);
+	mdelay(10);
+	GPSR(19) = GPIO_bit(19); // #SUSPEND high
+	mdelay(10);
+	GPSR(7) = GPIO_bit(7); // #PCLR high
+	mdelay(10);
+}
+
+static void e740_t7l66xb_suspend(void) {
+	GPCR(19) = GPIO_bit(19); // #SUSPEND low
+	mdelay(10);
+	GPCR(7) = GPIO_bit(7); // #PCLR low
+	
+	/* kill clock */
+//	pxa_gpio_mode(GPIO7_48MHz_MD|GPIO_OUT);
+//	GPSR0 = GPIO_bit(GPIO7_48MHz);
+}
+
+static void e740_t7l66xb_resume(void) {
+	e740_t7l66xb_hwinit();
+}
+
+static struct t7l66xb_platform_data e740_t7l66xb_info = {
+	.irq_base 		= IRQ_BOARD_START,
+	.hw_init                = &e740_t7l66xb_hwinit,
+	.suspend                = &e740_t7l66xb_suspend,
+	.resume                 = &e740_t7l66xb_resume,
+};
+
+static struct platform_device e740_t7l66xb_device = {
+	.name           = "t7l66xb",
+	.id             = -1,
+	.dev            = {
+		.platform_data = &e740_t7l66xb_info, 
+	},
+	.num_resources = ARRAY_SIZE(e740_t7l66xb_resources),
+	.resource      = e740_t7l66xb_resources,
+}; 
+
+static int __init e740_t7l66xb_init(void)
+{
+	if(!machine_is_e740())
+		return -ENODEV;
+
+	platform_device_register(&e740_t7l66xb_device);
+	return 0;
+}
+
+module_init(e740_t7l66xb_init);
+
+MODULE_AUTHOR("Ian Molton <spyro@f2s.com>");
+MODULE_DESCRIPTION("e740 t7l66xb device support");
+MODULE_LICENSE("GPLv2");
+
+
diff --git a/arch/arm/mach-pxa/e750_tc6393xb.c b/arch/arm/mach-pxa/e750_tc6393xb.c
new file mode 100644
index 0000000..c786fe0
--- /dev/null
+++ b/arch/arm/mach-pxa/e750_tc6393xb.c
@@ -0,0 +1,99 @@
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+
+#include <asm/mach-types.h>
+#include <asm/arch/hardware.h>
+#include <asm/arch/pxa-regs.h>
+#include <asm/irq.h>
+
+#include <asm/arch/eseries-irq.h>
+#include <asm/arch/eseries-gpio.h>
+
+#include <linux/tc6393.h>
+
+static struct resource e750_tc6393xb_resources[] = {
+	[0] = {
+		.start  = PXA_CS4_PHYS,
+		.end    = PXA_CS4_PHYS + 0x1fffff,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_GPIO(GPIO_ESERIES_TMIO_IRQ),
+		.end    = IRQ_GPIO(GPIO_ESERIES_TMIO_IRQ),
+		.flags  = IORESOURCE_IRQ,
+	},
+
+};
+
+//FIXME - who should really be setting up the clock? bootloader or kernel ?
+static void e750_tc6393xb_hwinit(void) {
+	pxa_gpio_mode(GPIO11_3_6MHz_MD);
+
+	GPCR(45) = GPIO_bit(45); // #SUSPEND low
+	GPCR(19) = GPIO_bit(19); // #PCLR low (reset)
+	mdelay(1);
+	GPSR(45) = GPIO_bit(45); // #SUSPEND high
+	mdelay(10);              //FIXME - pronbably 1000x too long
+	GPSR(19) = GPIO_bit(19); // #PCLR high
+}
+
+static void e750_tc6393xb_suspend(void) {
+	GPSR(45) = GPIO_bit(45); // #SUSPEND high
+	mdelay(10);
+	GPSR(19) = GPIO_bit(19); // #PCLR high
+	
+	pxa_gpio_mode(GPIO11_3_6MHz_MD|GPIO_OUT);
+	GPSR0 = GPIO_bit(GPIO11_3_6MHz);
+}
+
+/*
+MCR : 80aa
+CCR: 1310
+PLL2CR: 0c01
+PLL1CR1: f743
+PLL1CR2: 00f2
+SYS_DCR: 1033
+*/
+
+static struct tc6393xb_platform_data e750_tc6393xb_info = {
+	.irq_base 		= IRQ_BOARD_START,
+	.sys_pll2cr             = 0x0cc1,
+	.sys_ccr                = 0x1310,
+	.sys_mcr                = 0x80aa,
+	.sys_gper		= 0,
+	.sys_gpodsr1            = 0,
+	.sys_gpooecr1           = 0,
+	.hw_init                = &e750_tc6393xb_hwinit,
+	.suspend                = &e750_tc6393xb_suspend,
+};
+
+static struct platform_device e750_tc6393xb_device = {
+	.name           = "tc6393xb",
+	.id             = -1,
+	.dev            = {
+		.platform_data = &e750_tc6393xb_info, 
+	},
+	.num_resources = ARRAY_SIZE(e750_tc6393xb_resources),
+	.resource      = e750_tc6393xb_resources,
+}; 
+
+static int __init e750_tc6393xb_init(void)
+{
+	if(!(machine_is_e750() || machine_is_e800()))
+		return -ENODEV;
+
+	platform_device_register(&e750_tc6393xb_device);
+	return 0;
+}
+
+module_init(e750_tc6393xb_init);
+
+MODULE_AUTHOR("Ian Molton <spyro@f2s.com>");
+MODULE_DESCRIPTION("e740 tc6393 device support");
+MODULE_LICENSE("GPLv2");
+
+
-- 
1.5.3.5.737.gdee1b


--=-D5mov0wbQZvySymjlKQT--

