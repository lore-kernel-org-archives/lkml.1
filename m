Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbZEEPDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbZEEPDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZEEPDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:03:24 -0400
Received: from mx1.emlix.com ([193.175.82.87]:50813 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbZEEPDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:03:22 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Johannes Weiner <jw@emlix.com>
Subject: [PATCH v2 2/2] xtensa: support s6000 gpio irqs and alternate function selection
Date: Tue,  5 May 2009 17:03:22 +0200
Message-Id: <1241535802-17516-2-git-send-email-dg@emlix.com>
In-Reply-To: <1241535802-17516-1-git-send-email-dg@emlix.com>
References: <1237816990-29108-1-git-send-email-dg@emlix.com>
 <1241535802-17516-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement an irq chip to handle interrupts via gpio.  The GPIO chip
initialization function now takes a bitmask denoting pins that should
be configured for their alternate function.

changes compared to v1:
- fixed bug on edge interrupt configuration
- accommodated to function name change
- moved definition of VARIANT_NR_IRQS to this patch
- renamed __XTENSA_S6000_IRQ_H to _XTENSA_S6000_IRQ_H as requested

Signed-off-by: Daniel Glöckner <dg@emlix.com>
Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/include/asm/gpio.h                    |    8 +-
 arch/xtensa/platforms/s6105/setup.c               |    2 +-
 arch/xtensa/variants/s6000/gpio.c                 |  163 ++++++++++++++++++++-
 arch/xtensa/variants/s6000/include/variant/gpio.h |    2 +-
 arch/xtensa/variants/s6000/include/variant/irq.h  |    5 +-
 5 files changed, 171 insertions(+), 9 deletions(-)

diff --git a/arch/xtensa/include/asm/gpio.h b/arch/xtensa/include/asm/gpio.h
index 0763b07..a8c9fc4 100644
--- a/arch/xtensa/include/asm/gpio.h
+++ b/arch/xtensa/include/asm/gpio.h
@@ -38,14 +38,14 @@ static inline int gpio_cansleep(unsigned int gpio)
 	return __gpio_cansleep(gpio);
 }
 
-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
+/*
+ * Not implemented, yet.
+ */
 static inline int irq_to_gpio(unsigned int irq)
 {
 	return -EINVAL;
diff --git a/arch/xtensa/platforms/s6105/setup.c b/arch/xtensa/platforms/s6105/setup.c
index 855ddea..95fa23c 100644
--- a/arch/xtensa/platforms/s6105/setup.c
+++ b/arch/xtensa/platforms/s6105/setup.c
@@ -49,7 +49,7 @@ void __init platform_setup(char **cmdline)
 
 void __init platform_init(bp_tag_t *first)
 {
-	s6_gpio_init();
+	s6_gpio_init(0);
 	gpio_request(GPIO_LED1_NGREEN, "led1_green");
 	gpio_request(GPIO_LED1_RED, "led1_red");
 	gpio_direction_output(GPIO_LED1_NGREEN, 1);
diff --git a/arch/xtensa/variants/s6000/gpio.c b/arch/xtensa/variants/s6000/gpio.c
index 79317fd..380a70f 100644
--- a/arch/xtensa/variants/s6000/gpio.c
+++ b/arch/xtensa/variants/s6000/gpio.c
@@ -4,15 +4,20 @@
  * Copyright (c) 2009 emlix GmbH
  * Authors:	Oskar Schirmer <os@emlix.com>
  *		Johannes Weiner <jw@emlix.com>
+ *		Daniel Gloeckner <dg@emlix.com>
  */
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/gpio.h>
 
 #include <variant/hardware.h>
 
+#define IRQ_BASE XTENSA_NR_IRQS
+
 #define S6_GPIO_DATA		0x000
 #define S6_GPIO_IS		0x404
 #define S6_GPIO_IBE		0x408
@@ -52,19 +57,175 @@ static void set(struct gpio_chip *chip, unsigned int off, int val)
 	writeb(val ? ~0 : 0, S6_REG_GPIO + S6_GPIO_DATA + S6_GPIO_OFFSET(off));
 }
 
+static int to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset < 8)
+		return offset + IRQ_BASE;
+	return -EINVAL;
+}
+
 static struct gpio_chip gpiochip = {
 	.owner = THIS_MODULE,
 	.direction_input = direction_input,
 	.get = get,
 	.direction_output = direction_output,
 	.set = set,
+	.to_irq = to_irq,
 	.base = 0,
 	.ngpio = 24,
 	.can_sleep = 0, /* no blocking io needed */
 	.exported = 0, /* no exporting to userspace */
 };
 
-int s6_gpio_init(void)
+int s6_gpio_init(u32 afsel)
 {
+	writeb(afsel, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_AFSEL);
+	writeb(afsel >> 8, S6_REG_GPIO + S6_GPIO_BANK(1) + S6_GPIO_AFSEL);
+	writeb(afsel >> 16, S6_REG_GPIO + S6_GPIO_BANK(2) + S6_GPIO_AFSEL);
 	return gpiochip_add(&gpiochip);
 }
+
+static void ack(unsigned int irq)
+{
+	writeb(1 << (irq - IRQ_BASE), S6_REG_GPIO + S6_GPIO_IC);
+}
+
+static void mask(unsigned int irq)
+{
+	u8 r = readb(S6_REG_GPIO + S6_GPIO_IE);
+	r &= ~(1 << (irq - IRQ_BASE));
+	writeb(r, S6_REG_GPIO + S6_GPIO_IE);
+}
+
+static void unmask(unsigned int irq)
+{
+	u8 m = readb(S6_REG_GPIO + S6_GPIO_IE);
+	m |= 1 << (irq - IRQ_BASE);
+	writeb(m, S6_REG_GPIO + S6_GPIO_IE);
+}
+
+static int set_type(unsigned int irq, unsigned int type)
+{
+	const u8 m = 1 << (irq - IRQ_BASE);
+	irq_flow_handler_t handler;
+	struct irq_desc *desc;
+	u8 reg;
+
+	if (type == IRQ_TYPE_PROBE) {
+		if ((readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_AFSEL) & m)
+		    || (readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IE) & m)
+		    || readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_DIR
+			      + S6_GPIO_MASK(irq - IRQ_BASE)))
+			return 0;
+		type = IRQ_TYPE_EDGE_BOTH;
+	}
+
+	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IS);
+	if (type & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH)) {
+		reg |= m;
+		handler = handle_level_irq;
+	} else {
+		reg &= ~m;
+		handler = handle_edge_irq;
+	}
+	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IS);
+	desc = irq_to_desc(irq);
+	desc->handle_irq = handler;
+
+	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IEV);
+	if (type & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_EDGE_RISING))
+		reg |= m;
+	else
+		reg &= ~m;
+	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IEV);
+
+	reg = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IBE);
+	if ((type & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
+		reg |= m;
+	else
+		reg &= ~m;
+	writeb(reg, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IBE);
+	return 0;
+}
+
+static struct irq_chip gpioirqs = {
+	.name = "GPIO",
+	.ack = ack,
+	.mask = mask,
+	.unmask = unmask,
+	.set_type = set_type,
+};
+
+static u8 demux_masks[4];
+
+static void demux_irqs(unsigned int irq, struct irq_desc *desc)
+{
+	u8 *mask = get_irq_desc_data(desc);
+	u8 pending;
+	int cirq;
+
+	desc->chip->mask(irq);
+	desc->chip->ack(irq);
+	pending = readb(S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_MIS) & *mask;
+	cirq = IRQ_BASE - 1;
+	while (pending) {
+		int n = ffs(pending);
+		cirq += n;
+		pending >>= n;
+		generic_handle_irq(cirq);
+	}
+	desc->chip->unmask(irq);
+}
+
+extern const signed char *platform_irq_mappings[XTENSA_NR_IRQS];
+
+void __init variant_init_irq(void)
+{
+	int irq, n;
+	writeb(0, S6_REG_GPIO + S6_GPIO_BANK(0) + S6_GPIO_IE);
+	for (irq = n = 0; irq < XTENSA_NR_IRQS; irq++) {
+		const signed char *mapping = platform_irq_mappings[irq];
+		int alone = 1;
+		u8 mask;
+		if (!mapping)
+			continue;
+		for(mask = 0; *mapping != -1; mapping++)
+			switch (*mapping) {
+			case S6_INTC_GPIO(0):
+				mask |= 1 << 0;
+				break;
+			case S6_INTC_GPIO(1):
+				mask |= 1 << 1;
+				break;
+			case S6_INTC_GPIO(2):
+				mask |= 1 << 2;
+				break;
+			case S6_INTC_GPIO(3):
+				mask |= 0x1f << 3;
+				break;
+			default:
+				alone = 0;
+			}
+		if (mask) {
+			int cirq, i;
+			if (!alone) {
+				printk(KERN_ERR "chained irq chips can't share"
+					" parent irq %i\n", irq);
+				continue;
+			}
+			demux_masks[n] = mask;
+			cirq = IRQ_BASE - 1;
+			do {
+				i = ffs(mask);
+				cirq += i;
+				mask >>= i;
+				set_irq_chip(cirq, &gpioirqs);
+				set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
+			} while (mask);
+			set_irq_data(irq, demux_masks + n);
+			set_irq_chained_handler(irq, demux_irqs);
+			if (++n == ARRAY_SIZE(demux_masks))
+				break;
+		}
+	}
+}
diff --git a/arch/xtensa/variants/s6000/include/variant/gpio.h b/arch/xtensa/variants/s6000/include/variant/gpio.h
index 8327f62..8484ab0 100644
--- a/arch/xtensa/variants/s6000/include/variant/gpio.h
+++ b/arch/xtensa/variants/s6000/include/variant/gpio.h
@@ -1,6 +1,6 @@
 #ifndef _XTENSA_VARIANT_S6000_GPIO_H
 #define _XTENSA_VARIANT_S6000_GPIO_H
 
-extern int s6_gpio_init(void);
+extern int s6_gpio_init(u32 afsel);
 
 #endif /* _XTENSA_VARIANT_S6000_GPIO_H */
diff --git a/arch/xtensa/variants/s6000/include/variant/irq.h b/arch/xtensa/variants/s6000/include/variant/irq.h
index bcd496d..1a69d33 100644
--- a/arch/xtensa/variants/s6000/include/variant/irq.h
+++ b/arch/xtensa/variants/s6000/include/variant/irq.h
@@ -1,7 +1,8 @@
-#ifndef __XTENSA_S6000_IRQ_H
-#define __XTENSA_S6000_IRQ_H
+#ifndef _XTENSA_S6000_IRQ_H
+#define _XTENSA_S6000_IRQ_H
 
 #define NO_IRQ		(-1)
+#define VARIANT_NR_IRQS 8 /* GPIO interrupts */
 
 #define VARIANT_HAS_IRQ_ENABLE
 extern void variant_irq_enable(unsigned int irq);
-- 
1.6.1.3

