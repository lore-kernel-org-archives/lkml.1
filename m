Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbZFKIao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbZFKIao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758663AbZFKIaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:30:30 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:41759 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836AbZFKIa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:30:27 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v5] gpio: driver for PrimeCell PL061 GPIO controller
Date: Thu, 11 Jun 2009 11:29:36 +0300
Message-Id: <1244708976-22122-1-git-send-email-baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for the ARM PrimeCell PL061 GPIO AMBA peripheral. The driver
is implemented using the gpiolib framework.

This driver also includes support for the use of the PL061 as an interrupt
controller (secondary).

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
Changes in v5:
	- Use resource_size() as suggested by Linus Walleij
	- Add a comment about the list member of pl061_gpio

Changes in v4:
	- Depend on CONFIG_ARM_AMBA
	- Do not request the gpio for IRQ automatically, just warn if it's not 
	  requested
	- Remove SZ_4K
	- Iterate through a linked list find the source of interrupt when 
	  multiple PL061s are connected to the same IRQ trigger
	- Move hardware register defines into the .c file

Changes in v3:
	- amba driver instead of a platform driver
	- Move include/linux/gpio/pl061.h => include/linux/amba/pl061.h

Changes in v2:
	- Address Andrew Morton's comments
	- Pass checkpatch.pl
	- Add changelog comment

 drivers/gpio/Kconfig       |    6 +
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/pl061.c       |  346 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/amba/pl061.h |   17 ++
 4 files changed, 370 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pl061.c
 create mode 100644 include/linux/amba/pl061.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index edb0253..585376f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -67,6 +67,12 @@ config GPIO_SYSFS
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_PL061
+	bool "PrimeCell PL061 GPIO support"
+	depends on ARM_AMBA
+	help
+	  Say yes here to support the PrimeCell PL061 GPIO device
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 49ac64e..ef90203 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
+obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
new file mode 100644
index 0000000..7dfe5b7
--- /dev/null
+++ b/drivers/gpio/pl061.c
@@ -0,0 +1,346 @@
+/*
+ *  linux/drivers/gpio/pl061.c
+ *
+ *  Copyright (C) 2008, 2009 Provigent Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Driver for the ARM PrimeCell(tm) General Purpose Input/Output (PL061)
+ *
+ * Data sheet: ARM DDI 0190B, September 2000
+ */
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/bitops.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/device.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/pl061.h>
+
+#define GPIODIR 0x400
+#define GPIOIS  0x404
+#define GPIOIBE 0x408
+#define GPIOIEV 0x40C
+#define GPIOIE  0x410
+#define GPIORIS 0x414
+#define GPIOMIS 0x418
+#define GPIOIC  0x41C
+
+#define PL061_GPIO_NR	8
+
+struct pl061_gpio {
+	/* We use a list of pl061_gpio structs for each trigger IRQ in the main
+	 * interrupts controller of the system. We need this to support systems
+	 * in which more that one PL061s are connected to the same IRQ. The ISR
+	 * interates through this list to find the source of the interrupt.
+	 */
+	struct list_head	list;
+
+	/* Each of the two spinlocks protects a different set of hardware
+	 * regiters and data structurs. This decouples the code of the IRQ from
+	 * the GPIO code. This also makes the case of a GPIO routine call from
+	 * the IRQ code simpler.
+	 */
+	spinlock_t		lock;		/* GPIO registers */
+	spinlock_t		irq_lock;	/* IRQ registers */
+
+	void __iomem		*base;
+	struct gpio_chip	gc;
+};
+
+static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+	unsigned long flags;
+	unsigned char gpiodir;
+
+	if (offset >= gc->ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	gpiodir = readb(chip->base + GPIODIR);
+	gpiodir &= ~(1 << offset);
+	writeb(gpiodir, chip->base + GPIODIR);
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static int pl061_direction_output(struct gpio_chip *gc, unsigned offset,
+		int value)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+	unsigned long flags;
+	unsigned char gpiodir;
+
+	if (offset >= gc->ngpio)
+		return -EINVAL;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
+	gpiodir = readb(chip->base + GPIODIR);
+	gpiodir |= 1 << offset;
+	writeb(gpiodir, chip->base + GPIODIR);
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static int pl061_get_value(struct gpio_chip *gc, unsigned offset)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	return !!readb(chip->base + (1 << (offset + 2)));
+}
+
+static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
+}
+
+/*
+ * PL061 GPIO IRQ
+ */
+static void pl061_irq_disable(unsigned irq)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq_to_gpio(irq) - chip->gc.base;
+	unsigned long flags;
+	u8 gpioie;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+	gpioie = readb(chip->base + GPIOIE);
+	gpioie &= ~(1 << offset);
+	writeb(gpioie, chip->base + GPIOIE);
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+}
+
+static void pl061_irq_enable(unsigned irq)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq_to_gpio(irq) - chip->gc.base;
+	unsigned long flags;
+	u8 gpioie;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+	gpioie = readb(chip->base + GPIOIE);
+	gpioie |= 1 << offset;
+	writeb(gpioie, chip->base + GPIOIE);
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+}
+
+static unsigned int pl061_irq_startup(unsigned irq)
+{
+	if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
+		pr_warning("%s: warning: GPIO%d has not been requested\n",
+				__func__, irq_to_gpio(irq));
+
+	pl061_irq_enable(irq);
+
+	return 0;
+}
+
+static int pl061_irq_type(unsigned irq, unsigned trigger)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq_to_gpio(irq) - chip->gc.base;
+	unsigned long flags;
+	u8 gpiois, gpioibe, gpioiev;
+
+	if (irq_to_gpio(irq) < 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(&chip->irq_lock, flags);
+
+	gpioiev = readb(chip->base + GPIOIEV);
+
+	gpiois = readb(chip->base + GPIOIS);
+	if (trigger & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+		gpiois |= 1 << offset;
+		if (trigger & IRQ_TYPE_LEVEL_HIGH)
+			gpioiev |= 1 << offset;
+		else
+			gpioiev &= ~(1 << offset);
+	} else
+		gpiois &= ~(1 << offset);
+	writeb(gpiois, chip->base + GPIOIS);
+
+	gpioibe = readb(chip->base + GPIOIBE);
+	if ((trigger & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
+		gpioibe |= 1 << offset;
+	else {
+		gpioibe &= ~(1 << offset);
+		if (trigger & IRQ_TYPE_EDGE_RISING)
+			gpioiev |= 1 << offset;
+		else
+			gpioiev &= ~(1 << offset);
+	}
+	writeb(gpioibe, chip->base + GPIOIBE);
+
+	writeb(gpioiev, chip->base + GPIOIEV);
+
+	spin_unlock_irqrestore(&chip->irq_lock, flags);
+
+	return 0;
+}
+
+static struct irq_chip pl061_irqchip = {
+	.name		= "GPIO",
+	.startup	= pl061_irq_startup,
+	.enable		= pl061_irq_enable,
+	.disable	= pl061_irq_disable,
+	.set_type	= pl061_irq_type,
+};
+
+static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct list_head *chip_list = get_irq_chip_data(irq);
+	struct list_head *ptr;
+	struct pl061_gpio *chip;
+
+	desc->chip->ack(irq);
+	list_for_each(ptr, chip_list) {
+		unsigned long pending;
+		int gpio;
+
+		chip = list_entry(ptr, struct pl061_gpio, list);
+		pending = readb(chip->base + GPIOMIS);
+		writeb(pending, chip->base + GPIOIC);
+
+		if (pending == 0)
+			continue;
+
+		for_each_bit(gpio, &pending, PL061_GPIO_NR)
+			generic_handle_irq(gpio_to_irq(gpio));
+	}
+	desc->chip->unmask(irq);
+}
+
+static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
+{
+	struct pl061_platform_data *pdata;
+	struct pl061_gpio *chip;
+	struct list_head *chip_list;
+	int ret, irq, i;
+
+	pdata = dev->dev.platform_data;
+	if (pdata == NULL)
+		return -ENODEV;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	if (!request_mem_region(dev->res.start,
+				resource_size(&dev->res), "pl061")) {
+		ret = -EBUSY;
+		goto free_mem;
+	}
+
+	chip->base = ioremap(dev->res.start, resource_size(&dev->res));
+	if (chip->base == NULL) {
+		ret = -ENOMEM;
+		goto release_region;
+	}
+
+	spin_lock_init(&chip->lock);
+	spin_lock_init(&chip->irq_lock);
+	INIT_LIST_HEAD(&chip->list);
+
+	chip->gc.direction_input = pl061_direction_input;
+	chip->gc.direction_output = pl061_direction_output;
+	chip->gc.get = pl061_get_value;
+	chip->gc.set = pl061_set_value;
+	chip->gc.base = pdata->gpio_base;
+	chip->gc.ngpio = PL061_GPIO_NR;
+	chip->gc.label = dev_name(&dev->dev);
+	chip->gc.dev = &dev->dev;
+	chip->gc.owner = THIS_MODULE;
+
+	ret = gpiochip_add(&chip->gc);
+	if (ret)
+		goto iounmap;
+
+	/*
+	 * irq_chip support
+	 */
+	writeb(0, chip->base + GPIOIE); /* disable irqs */
+	irq = dev->irq[0];
+	if (irq < 0) {
+		ret = -ENODEV;
+		goto iounmap;
+	}
+	set_irq_chained_handler(irq, pl061_irq_handler);
+	if (!pdata->is_irq_initialized || !pdata->is_irq_initialized(irq)) {
+		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
+		if (chip_list == NULL) {
+			ret = -ENOMEM;
+			goto iounmap;
+		}
+		INIT_LIST_HEAD(chip_list);
+		set_irq_chip_data(irq, chip_list);
+	} else
+		chip_list = get_irq_chip_data(irq);
+	list_add(&chip->list, chip_list);
+
+	for (i = 0; i < PL061_GPIO_NR; i++) {
+		if (pdata->directions & (1 << i))
+			pl061_direction_output(&chip->gc, i,
+					pdata->values & (1 << i));
+		else
+			pl061_direction_input(&chip->gc, i);
+
+		set_irq_chip(gpio_to_irq(i+pdata->gpio_base), &pl061_irqchip);
+		set_irq_handler(gpio_to_irq(i+pdata->gpio_base),
+				handle_simple_irq);
+		set_irq_flags(gpio_to_irq(i+pdata->gpio_base), IRQF_VALID);
+		set_irq_chip_data(gpio_to_irq(i+pdata->gpio_base), chip);
+	}
+
+	return 0;
+
+iounmap:
+	iounmap(chip->base);
+release_region:
+	release_mem_region(dev->res.start, resource_size(&dev->res));
+free_mem:
+	kfree(chip);
+
+	return ret;
+}
+
+static struct amba_id pl061_ids[] __initdata = {
+	{
+		.id	= 0x00041061,
+		.mask	= 0x000fffff,
+	},
+	{ 0, 0 },
+};
+
+static struct amba_driver pl061_gpio_driver = {
+	.drv = {
+		.name	= "pl061_gpio",
+	},
+	.id_table	= pl061_ids,
+	.probe		= pl061_probe,
+};
+
+static int __init pl061_gpio_init(void)
+{
+	return amba_driver_register(&pl061_gpio_driver);
+}
+subsys_initcall(pl061_gpio_init);
+
+MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
+MODULE_DESCRIPTION("PL061 GPIO driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/amba/pl061.h b/include/linux/amba/pl061.h
new file mode 100644
index 0000000..90de39e
--- /dev/null
+++ b/include/linux/amba/pl061.h
@@ -0,0 +1,17 @@
+/* platform data for the PL061 GPIO driver */
+
+struct pl061_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+
+	u8		directions;	/* startup directions, 1: out, 0: in */
+	u8		values;		/* startup values */
+
+	/* This callback may be used when you have more than one PL061
+	 * connected to the same IRQ trigger. This callback must return 0 on
+	 * the first time it is called for each irq, and 1 on any other call.
+	 * In case you are not unfortunate enough to have this setup, this
+	 * pointer must be set to NULL.
+	 */
+	int		(*is_irq_initialized)(int irq);
+};
-- 
1.6.3.1

