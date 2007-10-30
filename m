Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXJ3B4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXJ3B4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXJ3BzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:55:21 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:39846 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752689AbXJ3BzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:55:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=OwgpXz5lNkl0NbhXbrR78siBk1YdJNA5Sr+gq/Cz1umzevvbTVXeZ25J5nyB157j4CjrhqWRIo9MQyJ3HnjJlQlbQyeh3s2422kK+DJP8hSMsJsEdFGFQRM+SPdzIAvZw8qGqpwTBSL8o9jyofMrHElcuV90DR0SntgZ6ArAsZg=  ;
X-YMail-OSG: 7.hxSHUVM1nFkL5fMOyj2lpWMpiYikhMHPcAYaT61H8nBOqUsp7n7F4y9qHwVJ_I3X3jg9VQGA--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 3/4] DaVinci platform uses new GPIOLIB
Date: Mon, 29 Oct 2007 18:53:28 -0700
User-Agent: KMail/1.9.6
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <andrew@sanpeople.com>, Tony Lindgren <tony@atomide.com>,
       Jean Delvare <khali@linux-fr.org>, "eric miao" <eric.y.miao@gmail.com>,
       Kevin Hilman <khilman@mvista.com>, Paul Mundt <lethal@linux-sh.org>,
       Ben Dooks <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net>
In-Reply-To: <200710291809.29936.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710291853.29234.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch DaVinci over to using the new GPIO library, so it can access
GPIO expanders and other non-SOC GPIOs using the same calls.
---
This is an example conversion, against the current DaVinci tree
(it probably won't apply against mainline).  The header changes
mostly by what it wraps, and allowing a broader range of GPIOs.
The implementation code is a it simpler, since it no longer needs
to map GPIO numbers to register banks by itself.  It's fairly
representative of what most platform conversions would look like,
except that many platforms won't actually inline access to any
of the SOC-native GPIO signals.

 arch/arm/Kconfig                    |    2 
 arch/arm/mach-davinci/gpio.c        |  137 +++++++++++++++++++-----------------
 include/asm-arm/arch-davinci/gpio.h |   63 +++++++---------
 3 files changed, 105 insertions(+), 97 deletions(-)

--- a/arch/arm/Kconfig	2007-10-27 08:50:31.000000000 -0700
+++ b/arch/arm/Kconfig	2007-10-27 08:50:31.000000000 -0700
@@ -396,9 +396,11 @@ config ARCH_DAVINCI
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
+	select GPIO_LIB
 	help
 	  Support for TI's DaVinci platform.
 
+
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
--- a/arch/arm/mach-davinci/gpio.c	2007-10-27 08:50:22.000000000 -0700
+++ b/arch/arm/mach-davinci/gpio.c	2007-10-27 13:57:01.000000000 -0700
@@ -1,7 +1,7 @@
 /*
  * TI DaVinci GPIO Support
  *
- * Copyright (c) 2006 David Brownell
+ * Copyright (c) 2006-2007 David Brownell
  * Copyright (c) 2007, MontaVista Software, Inc. <source@mvista.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -26,47 +26,45 @@
 
 #include <asm/mach/irq.h>
 
-static DEFINE_SPINLOCK(gpio_lock);
-static DECLARE_BITMAP(gpio_in_use, DAVINCI_N_GPIO);
-
-int gpio_request(unsigned gpio, const char *tag)
-{
-	if (gpio >= DAVINCI_N_GPIO)
-		return -EINVAL;
 
-	if (test_and_set_bit(gpio, gpio_in_use))
-		return -EBUSY;
+static DEFINE_SPINLOCK(gpio_lock);
 
-	return 0;
-}
-EXPORT_SYMBOL(gpio_request);
+struct davinci_gpio {
+	struct gpio_chip	chip;
+	struct gpio_controller	*__iomem regs;
+};
 
-void gpio_free(unsigned gpio)
-{
-	if (gpio >= DAVINCI_N_GPIO)
-		return;
+static struct davinci_gpio chips[DIV_ROUND_UP(DAVINCI_N_GPIO, 32)];
 
-	clear_bit(gpio, gpio_in_use);
-}
-EXPORT_SYMBOL(gpio_free);
 
 /* create a non-inlined version */
-static struct gpio_controller *__iomem gpio2controller(unsigned gpio)
+static struct gpio_controller *__iomem __init gpio2controller(unsigned gpio)
 {
 	return __gpio_to_controller(gpio);
 }
 
+
+/*--------------------------------------------------------------------------*/
+
 /*
- * Assuming the pin is muxed as a gpio output, set its output value.
+ * board setup code *MUST* set PINMUX0 and PINMUX1 as
+ * needed, and enable the GPIO clock.
  */
-void __gpio_set(unsigned gpio, int value)
+
+static int davinci_direction_in(struct gpio_chip *chip, unsigned offset)
 {
-	struct gpio_controller *__iomem g = gpio2controller(gpio);
+	struct davinci_gpio *d = container_of(chip, struct davinci_gpio, chip);
+	struct gpio_controller *__iomem g = d->regs;
+	u32 temp;
 
-	__raw_writel(__gpio_mask(gpio), value ? &g->set_data : &g->clr_data);
-}
-EXPORT_SYMBOL(__gpio_set);
+	spin_lock(&gpio_lock);
+	temp = __raw_readl(&g->dir);
+	temp |= (1 << offset);
+	__raw_writel(temp, &g->dir);
+	spin_unlock(&gpio_lock);
 
+	return 0;
+}
 
 /*
  * Read the pin's value (works even if it's set up as output);
@@ -75,61 +73,74 @@ EXPORT_SYMBOL(__gpio_set);
  * Note that changes are synched to the GPIO clock, so reading values back
  * right after you've set them may give old values.
  */
-int __gpio_get(unsigned gpio)
+static int davinci_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	struct gpio_controller	*__iomem g = gpio2controller(gpio);
+	struct davinci_gpio *d = container_of(chip, struct davinci_gpio, chip);
+	struct gpio_controller *__iomem g = d->regs;
 
-	return !!(__gpio_mask(gpio) & __raw_readl(&g->in_data));
+	return !!((1 << offset) & __raw_readl(&g->in_data));
 }
-EXPORT_SYMBOL(__gpio_get);
-
 
-/*--------------------------------------------------------------------------*/
-
-/*
- * board setup code *MUST* set PINMUX0 and PINMUX1 as
- * needed, and enable the GPIO clock.
- */
-
-int gpio_direction_input(unsigned gpio)
+static int
+davinci_direction_out(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct gpio_controller	*__iomem g = gpio2controller(gpio);
-	u32			temp;
-	u32			mask;
-
-	if (!g)
-		return -EINVAL;
+	struct davinci_gpio *d = container_of(chip, struct davinci_gpio, chip);
+	struct gpio_controller *__iomem g = d->regs;
+	u32 temp;
+	u32 mask = 1 << offset;
 
 	spin_lock(&gpio_lock);
-	mask = __gpio_mask(gpio);
 	temp = __raw_readl(&g->dir);
-	temp |= mask;
+	temp &= ~mask;
+	__raw_writel(mask, value ? &g->set_data : &g->clr_data);
 	__raw_writel(temp, &g->dir);
 	spin_unlock(&gpio_lock);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned gpio, int value)
+/*
+ * Assuming the pin is muxed as a gpio output, set its output value.
+ */
+static void
+davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct gpio_controller *__iomem g = gpio2controller(gpio);
-	u32 temp;
-	u32 mask;
+	struct davinci_gpio *d = container_of(chip, struct davinci_gpio, chip);
+	struct gpio_controller *__iomem g = d->regs;
 
-	if (!g)
-		return -EINVAL;
+	__raw_writel((1 << offset), value ? &g->set_data : &g->clr_data);
+}
+
+static int __init davinci_gpio_setup(void)
+{
+	int i, base;
+
+	for (i = 0, base = 0;
+			i < ARRAY_SIZE(chips);
+			i++, base += 32) {
+		chips[i].chip.label = "DaVinci";
+
+		chips[i].chip.direction_input = davinci_direction_in;
+		chips[i].chip.get = davinci_gpio_get;
+		chips[i].chip.direction_output = davinci_direction_out;
+		chips[i].chip.set = davinci_gpio_set;
+
+		chips[i].chip.base = base;
+		chips[i].chip.ngpio = DAVINCI_N_GPIO - base;
+		if (chips[i].chip.ngpio > 32)
+			chips[i].chip.ngpio = 32;
+
+		chips[i].regs = gpio2controller(base);
+
+		gpiochip_add(&chips[i].chip);
+	}
 
-	spin_lock(&gpio_lock);
-	mask = __gpio_mask(gpio);
-	temp = __raw_readl(&g->dir);
-	temp &= ~mask;
-	__raw_writel(mask, value ? &g->set_data : &g->clr_data);
-	__raw_writel(temp, &g->dir);
-	spin_unlock(&gpio_lock);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_direction_output);
 
+/* REVISIT we may want to set up GPIOs even earlier ... */
+pure_initcall(davinci_gpio_setup);
+
+/*--------------------------------------------------------------------------*/
 /*
  * We expect irqs will normally be set up as input pins, but they can also be
  * used as output pins ... which is convenient for testing.
--- a/include/asm-arm/arch-davinci/gpio.h	2007-10-27 08:50:31.000000000 -0700
+++ b/include/asm-arm/arch-davinci/gpio.h	2007-10-27 08:50:31.000000000 -0700
@@ -15,6 +15,7 @@
 
 #include <linux/io.h>
 #include <asm/hardware.h>
+#include <asm-generic/gpio.h>
 
 /*
  * basic gpio routines
@@ -27,13 +28,16 @@
  * need to pay attention to PINMUX0 and PINMUX1 to be sure those pins are
  * used as gpios, not with other peripherals.
  *
- * GPIOs are numbered 0..(DAVINCI_N_GPIO-1).  For documentation, and maybe
- * for later updates, code should write GPIO(N) or:
+ * On-chip GPIOs are numbered 0..(DAVINCI_N_GPIO-1).  For documentation,
+ * and maybe for later updates, code should write GPIO(N) or:
  *  - GPIOV18(N) for 1.8V pins, N in 0..53; same as GPIO(0)..GPIO(53)
  *  - GPIOV33(N) for 3.3V pins, N in 0..17; same as GPIO(54)..GPIO(70)
  *
  * For GPIO IRQs use gpio_to_irq(GPIO(N)) or gpio_to_irq(GPIOV33(N)) etc
  * for now, that's != GPIO(N)
+ *
+ * GPIOs can also be on external chips, numbered after the ones built-in
+ * to the DaVinci chip.  For now, they won't be usable as IRQ sources.
  */
 #define	GPIO(X)		(X)		/* 0 <= X <= 70 */
 #define	GPIOV18(X)	(X)		/* 1.8V i/o; 0 <= X <= 53 */
@@ -83,25 +87,17 @@ static inline u32 __gpio_mask(unsigned g
 }
 
 /* The get/set/clear functions will inline when called with constant
- * parameters, for low-overhead bitbanging.  Illegal constant parameters
- * cause link-time errors.
+ * parameters referencing built-in GPIOs, for low-overhead bitbanging.
  *
- * Otherwise, calls with variable parameters use outlined functions.
+ * Otherwise, calls with variable parameters or referencing external
+ * GPIOs (e.g. on GPIO expander chips) use outlined functions.
  */
-extern int __error_inval_gpio(void);
-
-extern void __gpio_set(unsigned gpio, int value);
-extern int __gpio_get(unsigned gpio);
-
 static inline void gpio_set_value(unsigned gpio, int value)
 {
-	if (__builtin_constant_p(value)) {
+	if (__builtin_constant_p(value) && gpio < DAVINCI_N_GPIO) {
 		struct gpio_controller	*__iomem g;
 		u32			mask;
 
-		if (gpio >= DAVINCI_N_GPIO)
-			__error_inval_gpio();
-
 		g = __gpio_to_controller(gpio);
 		mask = __gpio_mask(gpio);
 		if (value)
@@ -111,48 +107,47 @@ static inline void gpio_set_value(unsign
 		return;
 	}
 
-	__gpio_set(gpio, value);
+	__gpio_set_value(gpio, value);
 }
 
 /* Returns zero or nonzero; works for gpios configured as inputs OR
- * as outputs.
+ * as outputs, at least for built-in GPIOs.
  *
- * NOTE: changes in reported values are synchronized to the GPIO clock.
- * This is most easily seen after calling gpio_set_value() and then immediatly
- * gpio_get_value(), where the gpio_get_value() would return the old value
- * until the GPIO clock ticks and the new value gets latched.
+ * NOTE: for built-in GPIOs, changes in reported values are synchronized
+ * to the GPIO clock.  This is easily seen after calling gpio_set_value()
+ * and then immediately gpio_get_value(), where the gpio_get_value() will
+ * return the old value until the GPIO clock ticks and the new value gets
+ * latched.
  */
-
 static inline int gpio_get_value(unsigned gpio)
 {
 	struct gpio_controller	*__iomem g;
 
-	if (!__builtin_constant_p(gpio))
-		return __gpio_get(gpio);
-
-	if (gpio >= DAVINCI_N_GPIO)
-		return __error_inval_gpio();
+	if (!__builtin_constant_p(gpio) || gpio >= DAVINCI_N_GPIO)
+		return __gpio_get_value(gpio);
 
 	g = __gpio_to_controller(gpio);
 	return !!(__gpio_mask(gpio) & __raw_readl(&g->in_data));
 }
 
-/* powerup default direction is IN */
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
-
-#include <asm-generic/gpio.h>	/* cansleep wrappers */
-
-extern int gpio_request(unsigned gpio, const char *tag);
-extern void gpio_free(unsigned gpio);
+static inline int gpio_cansleep(unsigned gpio)
+{
+	if (__builtin_constant_p(gpio) && gpio < DAVINCI_N_GPIO)
+		return 0;
+	else
+		return __gpio_cansleep(gpio);
+}
 
 static inline int gpio_to_irq(unsigned gpio)
 {
+	if (gpio >= DAVINCI_N_GPIO)
+		return -EINVAL;
 	return DAVINCI_N_AINTC_IRQ + gpio;
 }
 
 static inline int irq_to_gpio(unsigned irq)
 {
+	/* caller guarantees gpio_to_irq() succeeded */
 	return irq - DAVINCI_N_AINTC_IRQ;
 }
 
