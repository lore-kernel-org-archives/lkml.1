Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbYEKRnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbYEKRnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYEKRn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:43:28 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49997 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbYEKRnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:43:22 -0400
Message-Id: <20080511174423.764454071@sortiz.org>
References: <20080511173653.869192035@sortiz.org>
User-Agent: quilt/0.46-1
Date: Sun, 11 May 2008 19:36:54 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@openedhand.com>
Subject: [PATCH -mm 1/5] asic3: gpiolib support
Content-Disposition: inline; filename=asic3-gpiolib.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASIC3 is, among other things, a GPIO extender. We should thus have it
supporting the current gpiolib API.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/asic3.c       |  224 +++++++++++++++++++++++++++++++---------------
 include/linux/mfd/asic3.h |   24 ++--
 2 files changed, 164 insertions(+), 84 deletions(-)

Index: linux-2.6-htc-asic3/drivers/mfd/asic3.c
===================================================================
--- linux-2.6-htc-asic3.orig/drivers/mfd/asic3.c	2008-05-07 16:12:29.000000000 +0200
+++ linux-2.6-htc-asic3/drivers/mfd/asic3.c	2008-05-11 17:30:04.000000000 +0200
@@ -9,7 +9,7 @@
  *
  * Copyright 2001 Compaq Computer Corporation.
  * Copyright 2004-2005 Phil Blundell
- * Copyright 2007 OpenedHand Ltd.
+ * Copyright 2007-2008 OpenedHand Ltd.
  *
  * Authors: Phil Blundell <pb@handhelds.org>,
  *	    Samuel Ortiz <sameo@openedhand.com>
@@ -19,12 +19,26 @@
 #include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/irq.h>
+#include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 
 #include <linux/mfd/asic3.h>
 
+struct asic3 {
+	void __iomem *mapping;
+	unsigned int bus_shift;
+	unsigned int irq_nr;
+	unsigned int irq_base;
+	spinlock_t lock;
+	u16 irq_bothedge[4];
+	struct gpio_chip gpio;
+	struct device *dev;
+};
+
+static int asic3_gpio_get(struct gpio_chip *chip, unsigned offset);
+
 static inline void asic3_write_register(struct asic3 *asic,
 				 unsigned int reg, u32 value)
 {
@@ -251,7 +265,7 @@ static int asic3_gpio_irq_type(unsigned 
 		edge &= ~bit;
 	} else if (type == IRQT_BOTHEDGE) {
 		trigger |= bit;
-		if (asic3_gpio_get_value(asic, irq - asic->irq_base))
+		if (asic3_gpio_get(&asic->gpio, irq - asic->irq_base))
 			edge &= ~bit;
 		else
 			edge |= bit;
@@ -350,6 +364,107 @@ static void asic3_irq_remove(struct plat
 }
 
 /* GPIOs */
+static int asic3_gpio_direction(struct gpio_chip *chip,
+				unsigned offset, int out)
+{
+	u32 mask = ASIC3_GPIO_TO_MASK(offset), out_reg;
+	unsigned int gpio_base;
+	unsigned long flags;
+	struct asic3 *asic;
+
+	asic = container_of(chip, struct asic3, gpio);
+	gpio_base = ASIC3_GPIO_TO_BASE(offset);
+
+	if (gpio_base > ASIC3_GPIO_D_Base) {
+		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
+		       gpio_base, offset);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&asic->lock, flags);
+
+	out_reg = asic3_read_register(asic, gpio_base + ASIC3_GPIO_Direction);
+
+	/* Input is 0, Output is 1 */
+	if (out)
+		out_reg |= mask;
+	else
+		out_reg &= ~mask;
+
+	asic3_write_register(asic, gpio_base + ASIC3_GPIO_Direction, out_reg);
+
+	spin_unlock_irqrestore(&asic->lock, flags);
+
+	return 0;
+
+}
+
+static int asic3_gpio_direction_input(struct gpio_chip *chip,
+				      unsigned offset)
+{
+	return asic3_gpio_direction(chip, offset, 0);
+}
+
+static int asic3_gpio_direction_output(struct gpio_chip *chip,
+				       unsigned offset, int value)
+{
+	return asic3_gpio_direction(chip, offset, 1);
+}
+
+static int asic3_gpio_get(struct gpio_chip *chip,
+			  unsigned offset)
+{
+	unsigned int gpio_base;
+	u32 mask = ASIC3_GPIO_TO_MASK(offset);
+	struct asic3 *asic;
+
+	asic = container_of(chip, struct asic3, gpio);
+	gpio_base = ASIC3_GPIO_TO_BASE(offset);
+
+	if (gpio_base > ASIC3_GPIO_D_Base) {
+		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
+		       gpio_base, offset);
+		return -EINVAL;
+	}
+
+	return asic3_read_register(asic, gpio_base + ASIC3_GPIO_Status) & mask;
+}
+
+static void asic3_gpio_set(struct gpio_chip *chip,
+			   unsigned offset, int value)
+{
+	u32 mask, out_reg;
+	unsigned int gpio_base;
+	unsigned long flags;
+	struct asic3 *asic;
+
+	asic = container_of(chip, struct asic3, gpio);
+	gpio_base = ASIC3_GPIO_TO_BASE(offset);
+
+	if (gpio_base > ASIC3_GPIO_D_Base) {
+		printk(KERN_ERR "Invalid base (0x%x) for gpio %d\n",
+		       gpio_base, offset);
+		return;
+	}
+
+	mask = ASIC3_GPIO_TO_MASK(offset);
+
+	spin_lock_irqsave(&asic->lock, flags);
+
+	out_reg = asic3_read_register(asic, gpio_base + ASIC3_GPIO_Out);
+
+	if (value)
+		out_reg |= mask;
+	else
+		out_reg &= ~mask;
+
+	asic3_write_register(asic, gpio_base + ASIC3_GPIO_Out, out_reg);
+
+	spin_unlock_irqrestore(&asic->lock, flags);
+
+	return;
+}
+
 static inline u32 asic3_get_gpio(struct asic3 *asic, unsigned int base,
 				 unsigned int function)
 {
@@ -368,15 +483,6 @@ static void asic3_set_gpio(struct asic3 
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-#define asic3_get_gpio_a(asic, fn) \
-	asic3_get_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##fn)
-#define asic3_get_gpio_b(asic, fn) \
-	asic3_get_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##fn)
-#define asic3_get_gpio_c(asic, fn) \
-	asic3_get_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##fn)
-#define asic3_get_gpio_d(asic, fn) \
-	asic3_get_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##fn)
-
 #define asic3_set_gpio_a(asic, fn, bits, val) \
 	asic3_set_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##fn, bits, val)
 #define asic3_set_gpio_b(asic, fn, bits, val) \
@@ -394,54 +500,6 @@ static void asic3_set_gpio(struct asic3 
 	     asic3_set_gpio_d((asic), fn, (bits), (pdata)->gpio_d.field); \
 	} while (0)
 
-int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
-{
-	u32 mask = ASIC3_GPIO_bit(gpio);
-
-	switch (gpio >> 4) {
-	case ASIC3_GPIO_BANK_A:
-		return asic3_get_gpio_a(asic, Status) & mask;
-	case ASIC3_GPIO_BANK_B:
-		return asic3_get_gpio_b(asic, Status) & mask;
-	case ASIC3_GPIO_BANK_C:
-		return asic3_get_gpio_c(asic, Status) & mask;
-	case ASIC3_GPIO_BANK_D:
-		return asic3_get_gpio_d(asic, Status) & mask;
-	default:
-		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __func__, gpio);
-		return -EINVAL;
-	}
-}
-EXPORT_SYMBOL(asic3_gpio_get_value);
-
-void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val)
-{
-	u32 mask = ASIC3_GPIO_bit(gpio);
-	u32 bitval = 0;
-	if (val)
-		bitval = mask;
-
-	switch (gpio >> 4) {
-	case ASIC3_GPIO_BANK_A:
-		asic3_set_gpio_a(asic, Out, mask, bitval);
-		return;
-	case ASIC3_GPIO_BANK_B:
-		asic3_set_gpio_b(asic, Out, mask, bitval);
-		return;
-	case ASIC3_GPIO_BANK_C:
-		asic3_set_gpio_c(asic, Out, mask, bitval);
-		return;
-	case ASIC3_GPIO_BANK_D:
-		asic3_set_gpio_d(asic, Out, mask, bitval);
-		return;
-	default:
-		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __func__, gpio);
-		return;
-	}
-}
-EXPORT_SYMBOL(asic3_gpio_set_value);
 
 static int asic3_gpio_probe(struct platform_device *pdev)
 {
@@ -472,12 +530,14 @@ static int asic3_gpio_probe(struct platf
 				     alt_function);
 	}
 
-	return 0;
+	return gpiochip_add(&asic->gpio);
 }
 
-static void asic3_gpio_remove(struct platform_device *pdev)
+static int asic3_gpio_remove(struct platform_device *pdev)
 {
-	return;
+	struct asic3 *asic = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&asic->gpio);
 }
 
 
@@ -488,11 +548,13 @@ static int asic3_probe(struct platform_d
 	struct asic3 *asic;
 	struct resource *mem;
 	unsigned long clksel;
-	int ret;
+	int ret = 0;
 
 	asic = kzalloc(sizeof(struct asic3), GFP_KERNEL);
-	if (!asic)
+	if (asic == NULL) {
+		printk(KERN_ERR "kzalloc failed\n");
 		return -ENOMEM;
+	}
 
 	spin_lock_init(&asic->lock);
 	platform_set_drvdata(pdev, asic);
@@ -502,14 +564,15 @@ static int asic3_probe(struct platform_d
 	if (!mem) {
 		ret = -ENOMEM;
 		printk(KERN_ERR "asic3: no MEM resource\n");
-		goto err_out_1;
+		goto out_free;
 	}
 
+
 	asic->mapping = ioremap(mem->start, PAGE_SIZE);
 	if (!asic->mapping) {
 		ret = -ENOMEM;
 		printk(KERN_ERR "asic3: couldn't ioremap\n");
-		goto err_out_1;
+		goto out_free;
 	}
 
 	asic->irq_base = pdata->irq_base;
@@ -525,9 +588,21 @@ static int asic3_probe(struct platform_d
 	ret = asic3_irq_probe(pdev);
 	if (ret < 0) {
 		printk(KERN_ERR "asic3: couldn't probe IRQs\n");
-		goto err_out_2;
+		goto out_unmap;
+	}
+
+	asic->gpio.base = pdata->gpio_base;
+	asic->gpio.ngpio = ASIC3_NUM_GPIOS;
+	asic->gpio.get = asic3_gpio_get;
+	asic->gpio.set = asic3_gpio_set;
+	asic->gpio.direction_input = asic3_gpio_direction_input;
+	asic->gpio.direction_output = asic3_gpio_direction_output;
+
+	ret = asic3_gpio_probe(pdev);
+	if (ret < 0) {
+		printk(KERN_ERR "GPIO probe failed\n");
+		goto out_irq;
 	}
-	asic3_gpio_probe(pdev);
 
 	if (pdata->children) {
 		int i;
@@ -541,9 +616,13 @@ static int asic3_probe(struct platform_d
 
 	return 0;
 
- err_out_2:
+ out_irq:
+	asic3_irq_remove(pdev);
+
+ out_unmap:
 	iounmap(asic->mapping);
- err_out_1:
+
+ out_free:
 	kfree(asic);
 
 	return ret;
@@ -551,9 +630,12 @@ static int asic3_probe(struct platform_d
 
 static int asic3_remove(struct platform_device *pdev)
 {
+	int ret;
 	struct asic3 *asic = platform_get_drvdata(pdev);
 
-	asic3_gpio_remove(pdev);
+	ret = asic3_gpio_remove(pdev);
+	if (ret < 0)
+		return ret;
 	asic3_irq_remove(pdev);
 
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), 0);
Index: linux-2.6-htc-asic3/include/linux/mfd/asic3.h
===================================================================
--- linux-2.6-htc-asic3.orig/include/linux/mfd/asic3.h	2008-05-07 16:12:40.000000000 +0200
+++ linux-2.6-htc-asic3/include/linux/mfd/asic3.h	2008-05-11 17:34:42.000000000 +0200
@@ -16,16 +16,6 @@
 
 #include <linux/types.h>
 
-struct asic3 {
-	void __iomem *mapping;
-	unsigned int bus_shift;
-	unsigned int irq_nr;
-	unsigned int irq_base;
-	spinlock_t lock;
-	u16 irq_bothedge[4];
-	struct device *dev;
-};
-
 struct asic3_platform_data {
 	struct {
 		u32 dir;
@@ -41,18 +31,19 @@ struct asic3_platform_data {
 
 	unsigned int irq_base;
 
+	unsigned int gpio_base;
+
 	struct platform_device **children;
 	unsigned int n_children;
 };
 
-int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio);
-void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val);
-
 #define ASIC3_NUM_GPIO_BANKS	4
 #define ASIC3_GPIOS_PER_BANK	16
 #define ASIC3_NUM_GPIOS		64
 #define ASIC3_NR_IRQS		ASIC3_NUM_GPIOS + 6
 
+#define ASIC3_TO_GPIO(gpio) (NR_BUILTIN_GPIO + (gpio))
+
 #define ASIC3_GPIO_BANK_A	0
 #define ASIC3_GPIO_BANK_B	1
 #define ASIC3_GPIO_BANK_C	2
@@ -73,6 +64,13 @@ void asic3_gpio_set_value(struct asic3 *
 #define ASIC3_GPIO_C_Base      0x0200
 #define ASIC3_GPIO_D_Base      0x0300
 
+#define ASIC3_GPIO_TO_BANK(gpio) ((gpio) >> 4)
+#define ASIC3_GPIO_TO_BIT(gpio)  ((gpio) - \
+				  (ASIC3_GPIOS_PER_BANK * ((gpio) >> 4)))
+#define ASIC3_GPIO_TO_MASK(gpio) (1 << ASIC3_GPIO_TO_BIT(gpio))
+#define ASIC3_GPIO_TO_BASE(gpio) (ASIC3_GPIO_A_Base + (((gpio) >> 4) * 0x0100))
+#define ASIC3_BANK_TO_BASE(bank) (ASIC3_GPIO_A_Base + ((bank) * 0x100))
+
 #define ASIC3_GPIO_Mask          0x00    /* R/W 0:don't mask */
 #define ASIC3_GPIO_Direction     0x04    /* R/W 0:input */
 #define ASIC3_GPIO_Out           0x08    /* R/W 0:output low */

-- 
