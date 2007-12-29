Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbXL2EGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbXL2EGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXL2EEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:04:44 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21926 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754924AbXL2EEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:04:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=2VN/xuyVJOI+x1cjRgX8jNLFCOEeM2Fy/yGlLkKhJ2doMwGTOQrTI3J2QYWs7Vyl1uU3sCUl4KUyL+FBXWEDoJKkJdJjIs1GtrQfHEArZ1o/hyEBT4zagoHBndYPY+ht6xyQs2Ujn7VGleG6H1ORPGjlW5vGQXEcKOfHFrJqUKo=  ;
X-YMail-OSG: lWRwjyIVM1nE.IF8F99hOGy0XRSB5A_U_HdHJKrso3wQPXiqzjdsyZFrEDA0hqXPW.5J.IbqpQ--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc6-mm 5/9] gpiolib: pxa platform support
Date: Fri, 28 Dec 2007 19:57:29 -0800
User-Agent: KMail/1.9.6
Cc: eric miao <eric.y.miao@gmail.com>, Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
References: <200712281927.32575.david-b@pacbell.net>
In-Reply-To: <200712281927.32575.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281957.29571.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Zabel <philipp.zabel@gmail.com>

This adds gpiolib support for the PXA architecture:
  - move all GPIO API functions from generic.c into gpio.c
  - convert the gpio_get/set_value macros into inline functions

This makes it easier to hook up GPIOs provided by external chips like
ASICs and CPLDs, as used on various product and developer boards.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/Kconfig                    |    1 
 arch/arm/mach-pxa/Makefile          |    2 
 arch/arm/mach-pxa/generic.c         |   93 ----------------
 arch/arm/mach-pxa/generic.h         |    1 
 arch/arm/mach-pxa/gpio.c            |  197 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-pxa/irq.c             |    2 
 include/asm-arm/arch-pxa/gpio.h     |   48 +++-----
 include/asm-arm/arch-pxa/pxa-regs.h |   13 ++
 8 files changed, 235 insertions(+), 122 deletions(-)
 create mode 100644 arch/arm/mach-pxa/gpio.c

--- at91.orig/arch/arm/Kconfig
+++ at91/arch/arm/Kconfig
@@ -345,6 +345,7 @@ config ARCH_PXA
 	select GENERIC_GPIO
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
+	select GPIO_LIB
 	help
 	  Support for Intel/Marvell's PXA2xx/PXA3xx processor line.
 
--- at91.orig/arch/arm/mach-pxa/Makefile
+++ at91/arch/arm/mach-pxa/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support (must be linked before board specific support)
-obj-y				+= clock.o generic.o irq.o dma.o time.o
+obj-y				+= clock.o generic.o gpio.o irq.o dma.o time.o
 obj-$(CONFIG_PXA25x)		+= pxa25x.o
 obj-$(CONFIG_PXA27x)		+= pxa27x.o
 obj-$(CONFIG_PXA3xx)		+= pxa3xx.o mfp.o
--- at91.orig/arch/arm/mach-pxa/generic.c
+++ at91/arch/arm/mach-pxa/generic.c
@@ -32,7 +32,6 @@
 #include <asm/mach/map.h>
 
 #include <asm/arch/pxa-regs.h>
-#include <asm/arch/gpio.h>
 #include <asm/arch/udc.h>
 #include <asm/arch/pxafb.h>
 #include <asm/arch/mmc.h>
@@ -73,97 +72,6 @@ unsigned int get_memclk_frequency_10khz(
 EXPORT_SYMBOL(get_memclk_frequency_10khz);
 
 /*
- * Handy function to set GPIO alternate functions
- */
-int pxa_last_gpio;
-
-int pxa_gpio_mode(int gpio_mode)
-{
-	unsigned long flags;
-	int gpio = gpio_mode & GPIO_MD_MASK_NR;
-	int fn = (gpio_mode & GPIO_MD_MASK_FN) >> 8;
-	int gafr;
-
-	if (gpio > pxa_last_gpio)
-		return -EINVAL;
-
-	local_irq_save(flags);
-	if (gpio_mode & GPIO_DFLT_LOW)
-		GPCR(gpio) = GPIO_bit(gpio);
-	else if (gpio_mode & GPIO_DFLT_HIGH)
-		GPSR(gpio) = GPIO_bit(gpio);
-	if (gpio_mode & GPIO_MD_MASK_DIR)
-		GPDR(gpio) |= GPIO_bit(gpio);
-	else
-		GPDR(gpio) &= ~GPIO_bit(gpio);
-	gafr = GAFR(gpio) & ~(0x3 << (((gpio) & 0xf)*2));
-	GAFR(gpio) = gafr |  (fn  << (((gpio) & 0xf)*2));
-	local_irq_restore(flags);
-
-	return 0;
-}
-
-EXPORT_SYMBOL(pxa_gpio_mode);
-
-int gpio_direction_input(unsigned gpio)
-{
-	unsigned long flags;
-	u32 mask;
-
-	if (gpio > pxa_last_gpio)
-		return -EINVAL;
-
-	mask = GPIO_bit(gpio);
-	local_irq_save(flags);
-	GPDR(gpio) &= ~mask;
-	local_irq_restore(flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_input);
-
-int gpio_direction_output(unsigned gpio, int value)
-{
-	unsigned long flags;
-	u32 mask;
-
-	if (gpio > pxa_last_gpio)
-		return -EINVAL;
-
-	mask = GPIO_bit(gpio);
-	local_irq_save(flags);
-	if (value)
-		GPSR(gpio) = mask;
-	else
-		GPCR(gpio) = mask;
-	GPDR(gpio) |= mask;
-	local_irq_restore(flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_output);
-
-/*
- * Return GPIO level
- */
-int pxa_gpio_get_value(unsigned gpio)
-{
-	return __gpio_get_value(gpio);
-}
-
-EXPORT_SYMBOL(pxa_gpio_get_value);
-
-/*
- * Set output GPIO level
- */
-void pxa_gpio_set_value(unsigned gpio, int value)
-{
-	__gpio_set_value(gpio, value);
-}
-
-EXPORT_SYMBOL(pxa_gpio_set_value);
-
-/*
  * Routine to safely enable or disable a clock in the CKEN
  */
 void __pxa_set_cken(int clock, int enable)
@@ -178,7 +86,6 @@ void __pxa_set_cken(int clock, int enabl
 
 	local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL(__pxa_set_cken);
 
 /*
--- at91.orig/arch/arm/mach-pxa/generic.h
+++ at91/arch/arm/mach-pxa/generic.h
@@ -16,6 +16,7 @@ extern void __init pxa_init_irq_low(void
 extern void __init pxa_init_irq_high(void);
 extern void __init pxa_init_irq_gpio(int gpio_nr);
 extern void __init pxa_init_irq_set_wake(int (*set_wake)(unsigned int, unsigned int));
+extern void __init pxa_init_gpio(int gpio_nr);
 extern void __init pxa25x_init_irq(void);
 extern void __init pxa27x_init_irq(void);
 extern void __init pxa3xx_init_irq(void);
--- /dev/null
+++ at91/arch/arm/mach-pxa/gpio.c
@@ -0,0 +1,197 @@
+/*
+ *  linux/arch/arm/mach-pxa/gpio.c
+ *
+ *  Generic PXA GPIO handling
+ *
+ *  Author:	Nicolas Pitre
+ *  Created:	Jun 15, 2001
+ *  Copyright:	MontaVista Software Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+
+#include <asm/gpio.h>
+#include <asm/hardware.h>
+#include <asm/io.h>
+#include <asm/arch/pxa-regs.h>
+
+#include "generic.h"
+
+
+struct pxa_gpio_chip {
+	struct gpio_chip chip;
+	void __iomem     *regbase;
+};
+
+int pxa_last_gpio;
+
+/*
+ * Configure pins for GPIO or other functions
+ */
+int pxa_gpio_mode(int gpio_mode)
+{
+	unsigned long flags;
+	int gpio = gpio_mode & GPIO_MD_MASK_NR;
+	int fn = (gpio_mode & GPIO_MD_MASK_FN) >> 8;
+	int gafr;
+
+	if (gpio > pxa_last_gpio)
+		return -EINVAL;
+
+	local_irq_save(flags);
+	if (gpio_mode & GPIO_DFLT_LOW)
+		GPCR(gpio) = GPIO_bit(gpio);
+	else if (gpio_mode & GPIO_DFLT_HIGH)
+		GPSR(gpio) = GPIO_bit(gpio);
+	if (gpio_mode & GPIO_MD_MASK_DIR)
+		GPDR(gpio) |= GPIO_bit(gpio);
+	else
+		GPDR(gpio) &= ~GPIO_bit(gpio);
+	gafr = GAFR(gpio) & ~(0x3 << (((gpio) & 0xf)*2));
+	GAFR(gpio) = gafr |  (fn  << (((gpio) & 0xf)*2));
+	local_irq_restore(flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(pxa_gpio_mode);
+
+static int pxa_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long        flags;
+	u32                  mask = 1 << offset;
+	u32                  value;
+	struct pxa_gpio_chip *pxa;
+	void __iomem         *gpdr;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+	gpdr = pxa->regbase + GPDR_OFFSET;
+	local_irq_save(flags);
+	value = __raw_readl(gpdr);
+	value &= ~mask;
+	__raw_writel(value, gpdr);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+static int pxa_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	unsigned long        flags;
+	u32                  mask = 1 << offset;
+	u32                  tmp;
+	struct pxa_gpio_chip *pxa;
+	void __iomem         *gpdr;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+	__raw_writel(mask,
+			pxa->regbase + (value ? GPSR_OFFSET : GPCR_OFFSET));
+	gpdr = pxa->regbase + GPDR_OFFSET;
+	local_irq_save(flags);
+	tmp = __raw_readl(gpdr);
+	tmp |= mask;
+	__raw_writel(tmp, gpdr);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+/*
+ * Return GPIO level
+ */
+static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	u32                  mask = 1 << offset;
+	struct pxa_gpio_chip *pxa;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+	return __raw_readl(pxa->regbase + GPLR_OFFSET) & mask;
+}
+
+/*
+ * Set output GPIO level
+ */
+static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	u32                  mask = 1 << offset;
+	struct pxa_gpio_chip *pxa;
+
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	if (value)
+		__raw_writel(mask, pxa->regbase + GPSR_OFFSET);
+	else
+		__raw_writel(mask, pxa->regbase + GPCR_OFFSET);
+}
+
+static struct pxa_gpio_chip pxa_gpio_chip[] = {
+	[0] = {
+		.regbase = GPIO0_BASE,
+		.chip = {
+			.label            = "gpio-0",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 0,
+			.ngpio            = 32,
+		},
+	},
+	[1] = {
+		.regbase = GPIO1_BASE,
+		.chip = {
+			.label            = "gpio-1",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 32,
+			.ngpio            = 32,
+		},
+	},
+	[2] = {
+		.regbase = GPIO2_BASE,
+		.chip = {
+			.label            = "gpio-2",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 64,
+			.ngpio            = 32, /* 21 for PXA25x */
+		},
+	},
+#if defined(CONFIG_PXA27x) || defined(CONFIG_PXA3xx)
+	[3] = {
+		.regbase = GPIO3_BASE,
+		.chip = {
+			.label            = "gpio-3",
+			.direction_input  = pxa_gpio_direction_input,
+			.direction_output = pxa_gpio_direction_output,
+			.get              = pxa_gpio_get,
+			.set              = pxa_gpio_set,
+			.base             = 96,
+			.ngpio            = 32,
+		},
+	},
+#endif
+};
+
+void __init pxa_init_gpio(int gpio_nr)
+{
+	int i;
+
+	/* add a GPIO chip for each register bank.
+	 * the last PXA25x register only contains 21 GPIOs
+	 */
+	for (i = 0; i < gpio_nr; i += 32) {
+		if (i+32 > gpio_nr)
+			pxa_gpio_chip[i/32].chip.ngpio = gpio_nr - i;
+		gpiochip_add(&pxa_gpio_chip[i/32].chip);
+	}
+}
--- at91.orig/arch/arm/mach-pxa/irq.c
+++ at91/arch/arm/mach-pxa/irq.c
@@ -310,6 +310,8 @@ void __init pxa_init_irq_gpio(int gpio_n
 	/* Install handler for GPIO>=2 edge detect interrupts */
 	set_irq_chip(IRQ_GPIO_2_x, &pxa_internal_chip_low);
 	set_irq_chained_handler(IRQ_GPIO_2_x, pxa_gpio_demux_handler);
+
+	pxa_init_gpio(gpio_nr);
 }
 
 void __init pxa_init_irq_set_wake(int (*set_wake)(unsigned int, unsigned int))
--- at91.orig/include/asm-arm/arch-pxa/gpio.h
+++ at91/include/asm-arm/arch-pxa/gpio.h
@@ -28,43 +28,35 @@
 #include <asm/irq.h>
 #include <asm/hardware.h>
 
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return 0;
-}
+#include <asm-generic/gpio.h>
 
-static inline void gpio_free(unsigned gpio)
-{
-	return;
-}
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+/* NOTE: some PXAs have fewer on-chip GPIOs (like PXA255, with 85).
+ * Those cases currently cause holes in the GPIO number space.
+ */
+#define NR_BUILTIN_GPIO 128
 
-static inline int __gpio_get_value(unsigned gpio)
+static inline int gpio_get_value(unsigned gpio)
 {
-	return GPLR(gpio) & GPIO_bit(gpio);
+	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO))
+		return GPLR(gpio) & GPIO_bit(gpio);
+	else
+		return __gpio_get_value(gpio);
 }
 
-#define gpio_get_value(gpio)			\
-	(__builtin_constant_p(gpio) ?		\
-	 __gpio_get_value(gpio) :		\
-	 pxa_gpio_get_value(gpio))
-
-static inline void __gpio_set_value(unsigned gpio, int value)
+static inline void gpio_set_value(unsigned gpio, int value)
 {
-	if (value)
-		GPSR(gpio) = GPIO_bit(gpio);
-	else
-		GPCR(gpio) = GPIO_bit(gpio);
+	if (__builtin_constant_p(gpio) && (gpio < NR_BUILTIN_GPIO)) {
+		if (value)
+			GPSR(gpio) = GPIO_bit(gpio);
+		else
+			GPCR(gpio) = GPIO_bit(gpio);
+	} else {
+		__gpio_set_value(gpio, value);
+	}
 }
 
-#define gpio_set_value(gpio,value)		\
-	(__builtin_constant_p(gpio) ?		\
-	 __gpio_set_value(gpio, value) :	\
-	 pxa_gpio_set_value(gpio, value))
-
-#include <asm-generic/gpio.h>			/* cansleep wrappers */
+#define gpio_cansleep __gpio_cansleep
 
 #define gpio_to_irq(gpio)	IRQ_GPIO(gpio)
 #define irq_to_gpio(irq)	IRQ_TO_GPIO(irq)
--- at91.orig/include/asm-arm/arch-pxa/pxa-regs.h
+++ at91/include/asm-arm/arch-pxa/pxa-regs.h
@@ -1131,6 +1131,19 @@
  * General Purpose I/O
  */
 
+#define GPIO0_BASE	((void __iomem *)io_p2v(0x40E00000))
+#define GPIO1_BASE	((void __iomem *)io_p2v(0x40E00004))
+#define GPIO2_BASE	((void __iomem *)io_p2v(0x40E00008))
+#define GPIO3_BASE	((void __iomem *)io_p2v(0x40E00100))
+
+#define GPLR_OFFSET	0x00
+#define GPDR_OFFSET	0x0C
+#define GPSR_OFFSET	0x18
+#define GPCR_OFFSET	0x24
+#define GRER_OFFSET	0x30
+#define GFER_OFFSET	0x3C
+#define GEDR_OFFSET	0x48
+
 #define GPLR0		__REG(0x40E00000)  /* GPIO Pin-Level Register GPIO<31:0> */
 #define GPLR1		__REG(0x40E00004)  /* GPIO Pin-Level Register GPIO<63:32> */
 #define GPLR2		__REG(0x40E00008)  /* GPIO Pin-Level Register GPIO<80:64> */
