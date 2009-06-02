Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbZFBUuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbZFBUuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZFBUuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:50:04 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:46764 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZFBUuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:50:02 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3] gpio: driver for PrimeCell PL061 GPIO controller
Date: Tue,  2 Jun 2009 23:48:10 +0300
Message-Id: <1243975690-12073-1-git-send-email-baruch@tkos.co.il>
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
Changes in v3:
	- amba driver instead of a platform driver
	- Move include/linux/gpio/pl061.h => include/linux/amba/pl061.h

Changes in v2:
	- Address Andrew Morton's comments
	- Pass checkpatch.pl
	- Add changelog comment

 drivers/gpio/Kconfig       |    5 +
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/pl061.c       |  346 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/amba/pl061.h |   18 +++
 4 files changed, 370 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pl061.c
 create mode 100644 include/linux/amba/pl061.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index edb0253..30d7948 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -67,6 +67,11 @@ config GPIO_SYSFS
 
 comment "Memory mapped GPIO expanders:"
 
+config GPIO_PL061
+	bool "PrimeCell PL061 GPIO support"
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
index 0000000..6839997
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
+#define PL061_GPIO_NR	8
+
+struct pl061_gpio {
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
+	struct work_struct	gpio_free_work;
+	DECLARE_BITMAP(gpios_to_free, PL061_GPIO_NR);
+};
+
+static u32 (*pl061_pending_irq)(int irq);
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
+static void pl061_irq_shutdown(unsigned irq)
+{
+	struct pl061_gpio *chip = get_irq_chip_data(irq);
+	int offset = irq_to_gpio(irq) - chip->gc.base;
+
+	pl061_irq_disable(irq);
+	set_bit(offset, chip->gpios_to_free);
+	schedule_work(&chip->gpio_free_work);
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
+	int ret;
+
+	ret = gpio_request(irq_to_gpio(irq), "IRQ");
+	if (ret < 0) {
+		pr_warning("%s: warning: gpio_request(%d) returned %d\n",
+				__func__, irq_to_gpio(irq), ret);
+		return 0;
+	}
+
+	gpio_direction_input(irq_to_gpio(irq));
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
+	.shutdown	= pl061_irq_shutdown,
+	.set_type	= pl061_irq_type,
+};
+
+static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	desc->chip->ack(irq);
+	while (1) {
+		unsigned long pending;
+		int gpio;
+
+		pending = pl061_pending_irq(irq);
+		if (pending == 0)
+			break;
+
+		for_each_bit(gpio, &pending, BITS_PER_LONG)
+			generic_handle_irq(gpio_to_irq(gpio));
+	}
+	desc->chip->unmask(irq);
+}
+
+static void pl061_gpio_free(struct work_struct *work)
+{
+	struct pl061_gpio *chip = container_of(work, struct pl061_gpio,
+			gpio_free_work);
+	int offset;
+
+	for_each_bit(offset, chip->gpios_to_free, PL061_GPIO_NR) {
+		int gpio = offset + chip->gc.base;
+
+		if (test_and_clear_bit(offset, chip->gpios_to_free))
+			gpio_free(gpio);
+	}
+}
+
+static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
+{
+	struct pl061_platform_data *pdata;
+	struct pl061_gpio *chip;
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
+	if (request_mem_region(dev->res.start, SZ_4K, "pl061") == NULL) {
+		ret = -EBUSY;
+		goto free_mem;
+	}
+
+	chip->base = ioremap(dev->res.start, SZ_4K);
+	if (chip->base == NULL) {
+		ret = -ENOMEM;
+		goto release_region;
+	}
+
+	spin_lock_init(&chip->lock);
+	spin_lock_init(&chip->irq_lock);
+
+	INIT_WORK(&chip->gpio_free_work, pl061_gpio_free);
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
+	pl061_pending_irq = pdata->pending_irqs;
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
+	release_mem_region(dev->res.start, SZ_4K);
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
index 0000000..9e18fa3
--- /dev/null
+++ b/include/linux/amba/pl061.h
@@ -0,0 +1,18 @@
+/* platform data for the PL061 GPIO driver */
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
+struct pl061_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+	u32		(*pending_irqs)(int irq);
+	u8		directions;	/* startup directions, 1: out, 0: in */
+	u8		values;		/* startup values */
+};
-- 
1.6.3.1

