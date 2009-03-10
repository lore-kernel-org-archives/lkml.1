Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZCJNFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZCJNFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZCJNDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:03:40 -0400
Received: from cmpxchg.org ([85.214.51.133]:38768 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbZCJNDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:03:39 -0400
Message-Id: <20090310120631.899999346@emlix.com>
References: <20090310115643.653120649@emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 12:56:49 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 6/8] xtensa: s6000 gpio driver
Content-Disposition: inline; filename=0005.5-xtensa-s6000-gpio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oskar Schirmer <os@emlix.com>

Implement the s6000 gpio controller as a chip for the generic gpio
lib.

Signed-off-by: Oskar Schirmer <os@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/Kconfig                 |    4 ++
 arch/xtensa/include/asm/gpio.h      |   56 ++++++++++++++++++++++++++++
 arch/xtensa/variants/s6000/Makefile |    2 -
 arch/xtensa/variants/s6000/gpio.c   |   71 ++++++++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 1 deletion(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -32,6 +32,9 @@ config GENERIC_HWEIGHT
 config GENERIC_HARDIRQS
 	def_bool y
 
+config GENERIC_GPIO
+	def_bool y
+
 config ARCH_HAS_ILOG2_U32
 	def_bool n
 
@@ -73,6 +76,7 @@ config XTENSA_VARIANT_DC232B
 config XTENSA_VARIANT_S6000
 	bool "s6000 - Stretch software configurable processor"
 	select VARIANT_IRQ_SWITCH
+	select ARCH_REQUIRE_GPIOLIB
 endchoice
 
 config XTENSA_UNALIGNED_USER
--- /dev/null
+++ b/arch/xtensa/include/asm/gpio.h
@@ -0,0 +1,56 @@
+/*
+ * Generic GPIO API implementation for xtensa.
+ *
+ * Stolen from x86, which is derived from the generic GPIO API for powerpc:
+ *
+ * Copyright (c) 2007-2008  MontaVista Software, Inc.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _ASM_XTENSA_GPIO_H
+#define _ASM_XTENSA_GPIO_H
+
+#include <asm-generic/gpio.h>
+
+#ifdef CONFIG_GPIOLIB
+
+/*
+ * Just call gpiolib.
+ */
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
+
+/*
+ * Not implemented, yet.
+ */
+static inline int gpio_to_irq(unsigned int gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned int irq)
+{
+	return -EINVAL;
+}
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif /* _ASM_XTENSA_GPIO_H */
--- a/arch/xtensa/variants/s6000/Makefile
+++ b/arch/xtensa/variants/s6000/Makefile
@@ -1,3 +1,3 @@
 # s6000 Makefile
 
-obj-y		+= irq.o
+obj-y		+= irq.o gpio.o
--- /dev/null
+++ b/arch/xtensa/variants/s6000/gpio.c
@@ -0,0 +1,71 @@
+/*
+ * s6000 gpio driver
+ *
+ * Copyright (c) 2009 emlix GmbH
+ * Authors:	Oskar Schirmer <os@emlix.com>
+ *		Johannes Weiner <jw@emlix.com>
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#include <variant/hardware.h>
+
+#define S6_GPIO_DATA		0x000
+#define S6_GPIO_IS		0x404
+#define S6_GPIO_IBE		0x408
+#define S6_GPIO_IEV		0x40C
+#define S6_GPIO_IE		0x410
+#define S6_GPIO_RIS		0x414
+#define S6_GPIO_MIS		0x418
+#define S6_GPIO_IC		0x41C
+#define S6_GPIO_AFSEL		0x420
+#define S6_GPIO_DIR		0x800
+#define S6_GPIO_BANK(nr)	((nr) * 0x1000)
+#define S6_GPIO_MASK(nr)	(4 << (nr))
+#define S6_GPIO_OFFSET(nr) \
+		(S6_GPIO_BANK((nr) >> 3) + S6_GPIO_MASK((nr) & 7))
+
+static int direction_input(struct gpio_chip *chip, unsigned int off)
+{
+	writeb(0, S6_REG_GPIO + S6_GPIO_DIR + S6_GPIO_OFFSET(off));
+	return 0;
+}
+
+static int get(struct gpio_chip *chip, unsigned int off)
+{
+	return readb(S6_REG_GPIO + S6_GPIO_DATA + S6_GPIO_OFFSET(off));
+}
+
+static int direction_output(struct gpio_chip *chip, unsigned int off, int val)
+{
+	unsigned rel = S6_GPIO_OFFSET(off);
+	writeb(~0, S6_REG_GPIO + S6_GPIO_DIR + rel);
+	writeb(val ? ~0 : 0, S6_REG_GPIO + S6_GPIO_DATA + rel);
+	return 0;
+}
+
+static void set(struct gpio_chip *chip, unsigned int off, int val)
+{
+	writeb(val ? ~0 : 0, S6_REG_GPIO + S6_GPIO_DATA + S6_GPIO_OFFSET(off));
+}
+
+static struct gpio_chip gpiochip = {
+	.owner = THIS_MODULE,
+	.direction_input = direction_input,
+	.get = get,
+	.direction_output = direction_output,
+	.set = set,
+	.base = 0,
+	.ngpio = 24,
+	.can_sleep = 0, /* no blocking io needed */
+	.exported = 0, /* no exporting to userspace */
+};
+
+static int gpio_init(void)
+{
+	return gpiochip_add(&gpiochip);
+}
+device_initcall(gpio_init);

-- 

