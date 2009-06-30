Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZF3FOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZF3FOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZF3FOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:14:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:2709 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZF3FOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,314,1243839600"; 
   d="scan'208,223";a="426407651"
Date: Tue, 30 Jun 2009 13:07:54 +0800
From: Alek Du <alek.du@intel.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio
 driver
Message-ID: <20090630130754.726036ad@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 18d915ac81fd441938225dcaa389b597af483a4f Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Tue, 30 Jun 2009 12:13:27 +0800
Subject: [PATCH] gpio: add Intel Moorestown Platform Langwell chip gpio driver

The Langwell chip has a 64-pin gpio block, which is exposed as a PCI device.
We use it to control outside peripheral as well as to do IRQ demuxing. The
gpio block uses MSI to request level type interrupt to IOAPIC.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/Kconfig  |    6 +
 drivers/gpio/Makefile |    1 +
 drivers/gpio/lnw.c    |  360 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 367 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/lnw.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3582c39..c9675de 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -167,6 +167,12 @@ config GPIO_BT8XX
 
 	  If unsure, say N.
 
+config GPIO_LANGWELL
+	tristate "Intel Moorestown Platform Langwell GPIO support"
+	depends on PCI
+	help
+	  Say Y here to support Intel Moorestown platform GPIO.
+
 comment "SPI GPIO expanders:"
 
 config GPIO_MAX7301
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index ef90203..d8ee188 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
+obj-$(CONFIG_GPIO_LANGWELL)	+= lnw.o
diff --git a/drivers/gpio/lnw.c b/drivers/gpio/lnw.c
new file mode 100644
index 0000000..d437fe0
--- /dev/null
+++ b/drivers/gpio/lnw.c
@@ -0,0 +1,360 @@
+/* lnw.c Moorestown platform Langwell chip GPIO driver
+ * Copyright (c) 2008 - 2009,  Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* Supports:
+ * Moorestown platform Langwell chip.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/stddef.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+#ifdef CONFIG_DEBUG_GPIO
+#define GDEBUG(format, arg...) printk(KERN_DEBUG format, ## arg)
+#else
+#define GDEBUG(format, arg...)
+#endif
+
+#define GPIO_bit(gpio) (1 << ((gpio) & 0x1f))
+
+struct lnw_gpio_register {
+	u32	GPLR0;
+	u32	GPLR1;
+	u32	GPDR0;
+	u32	GPDR1;
+	u32	GPSR0;
+	u32	GPSR1;
+	u32	GPCR0;
+	u32	GPCR1;
+	u32	GRER0;
+	u32	GRER1;
+	u32	GFER0;
+	u32	GFER1;
+	u32	GEDR0;
+	u32	GEDR1;
+	u32	GAFR0_L;
+	u32	GAFR0_U;
+	u32	GAFR1_L;
+	u32	GAFR1_U;
+};
+
+struct lnw_gpio {
+	struct gpio_chip		chip;
+	struct lnw_gpio_register 	*reg_base;
+	spinlock_t			lock;
+	unsigned			irq_base;
+};
+
+static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	u8 reg = offset / 32;
+	void __iomem *gplr;
+
+	gplr = (void __iomem *)(&lnw->reg_base->GPLR0 + reg);
+	return readl(gplr) & GPIO_bit(offset);
+}
+
+static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	u8 reg = offset / 32;
+	void __iomem *gpsr, *gpcr;
+
+	if (value) {
+		gpsr = (void __iomem *)(&lnw->reg_base->GPSR0 + reg);
+		writel(GPIO_bit(offset), gpsr);
+	} else {
+		gpcr = (void __iomem *)(&lnw->reg_base->GPCR0 + reg);
+		writel(GPIO_bit(offset), gpcr);
+	}
+}
+
+static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	u8 reg = offset / 32;
+	u32 value;
+	unsigned long flags;
+	void __iomem *gpdr;
+
+	gpdr = (void __iomem *)(&lnw->reg_base->GPDR0 + reg);
+	spin_lock_irqsave(&lnw->lock, flags);
+	value = readl(gpdr);
+	value &= ~GPIO_bit(offset);
+	writel(value, gpdr);
+	spin_unlock_irqrestore(&lnw->lock, flags);
+	return 0;
+}
+
+static int lnw_gpio_direction_output(struct gpio_chip *chip,
+			unsigned offset, int value)
+{
+	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	u8 reg = offset / 32;
+	unsigned long flags;
+	void __iomem *gpdr;
+
+	lnw_gpio_set(chip, offset, value);
+	gpdr = (void __iomem *)(&lnw->reg_base->GPDR0 + reg);
+	spin_lock_irqsave(&lnw->lock, flags);
+	value = readl(gpdr);
+	value |= GPIO_bit(offset);;
+	writel(value, gpdr);
+	spin_unlock_irqrestore(&lnw->lock, flags);
+	return 0;
+}
+
+static void lnw_gpio_alt_func(struct gpio_chip *chip,
+			unsigned offset, int value)
+{
+	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	u8 reg = offset / 16;
+	u32 mask = 3 << ((offset % 16) * 2);
+	unsigned long flags;
+	void __iomem *gafr;
+
+	value = (value & 3) << ((offset % 16) * 2);
+	gafr = (void __iomem *)(&lnw->reg_base->GAFR0_L + reg);
+	spin_lock_irqsave(&lnw->lock, flags);
+	writel((readl(gafr) & ~mask) | value, gafr);
+	spin_unlock_irqrestore(&lnw->lock, flags);
+}
+
+static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	return lnw->irq_base + offset;
+}
+
+static int lnw_irq_type(unsigned irq, unsigned type)
+{
+	struct lnw_gpio *lnw = get_irq_chip_data(irq);
+	u32 gpio = irq - lnw->irq_base;
+	u8 reg = gpio / 32;
+	unsigned long flags;
+	u32 value;
+	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER0 + reg);
+	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER0 + reg);
+
+	if (gpio < 0 || gpio > lnw->chip.ngpio)
+		return -EINVAL;
+	lnw_gpio_alt_func(&lnw->chip, gpio, 0);
+	spin_lock_irqsave(&lnw->lock, flags);
+	if (type & IRQ_TYPE_EDGE_RISING)
+		value = readl(grer) | GPIO_bit(gpio);
+	else
+		value = readl(grer) & (~GPIO_bit(gpio));
+	writel(value, grer);
+
+	if (type & IRQ_TYPE_EDGE_FALLING)
+		value = readl(gfer) | GPIO_bit(gpio);
+	else
+		value = readl(gfer) & (~GPIO_bit(gpio));
+	writel(value, gfer);
+	spin_unlock_irqrestore(&lnw->lock, flags);
+
+	return 0;
+};
+
+static void lnw_irq_unmask(unsigned irq)
+{
+	struct lnw_gpio *lnw = get_irq_chip_data(irq);
+	u32 gpio = irq - lnw->irq_base;
+	u8 reg = gpio / 32;
+	void __iomem *gedr;
+
+	gedr = (void __iomem *)(&lnw->reg_base->GEDR0 + reg);
+	writel(GPIO_bit(gpio), gedr);
+};
+
+static struct irq_chip lnw_irqchip = {
+	.name		= "LNW-GPIO",
+	.unmask		= lnw_irq_unmask,
+	.set_type	= lnw_irq_type,
+};
+
+struct lnw_driver_data {
+	unsigned	gpio_base;
+	unsigned	gpio_nr;
+} lnw_driver_datas[] __devinitdata = {
+	{ .gpio_base = 0, .gpio_nr = 64 },
+	{ 0 }
+};
+
+static struct pci_device_id lnw_gpio_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f),
+	  .driver_data = (unsigned long)&lnw_driver_datas[0] },
+	{ 0, }
+};
+
+static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct lnw_gpio *lnw = (struct lnw_gpio *)get_irq_data(irq);
+	u32 reg, gpio;
+	void __iomem *gedr;
+	u32 gedr_v;
+
+	/* check GPIO controller to check which pin triggered the interrupt */
+	for (reg = 0; reg < lnw->chip.ngpio / 32; reg++) {
+		gedr = (void __iomem *)(&lnw->reg_base->GEDR0 + reg);
+		gedr_v = readl(gedr);
+		if (!gedr_v)
+			continue;
+		for (gpio = reg*32; gpio < reg*32+32; gpio++) {
+			gedr_v = readl(gedr);
+			if (gedr_v & GPIO_bit(gpio)) {
+				GDEBUG("pin %d triggered\n", gpio);
+				generic_handle_irq(lnw->irq_base + gpio);
+			}
+		}
+		/* clear the edge detect status bit */
+		writel(gedr_v, gedr);
+	}
+	desc->chip->eoi(irq);
+}
+
+static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
+			const struct pci_device_id *id)
+{
+	void *base;
+	int i;
+	resource_size_t start, len;
+	struct lnw_gpio *lnw;
+	u32 irq_base;
+	struct lnw_driver_data *ddata =
+			(struct lnw_driver_data *)id->driver_data;
+	int retval = 0;
+
+	retval = pci_enable_device(pdev);
+	if (retval)
+		goto done;
+
+	retval = pci_request_regions(pdev, "lnwgpio");
+	if (retval) {
+		dev_err(&pdev->dev, "error requesting resources\n");
+		goto err2;
+	}
+	start = pci_resource_start(pdev, 1);
+	len = pci_resource_len(pdev, 1);
+	base = ioremap_nocache(start, len);
+	if (!base) {
+		dev_err(&pdev->dev, "error mapping bar1\n");
+		goto err3;
+	}
+	irq_base = *(u32 *)base;
+	iounmap(base);/* we needn't it anymore */
+
+	start = pci_resource_start(pdev, 0);
+	len = pci_resource_len(pdev, 0);
+	base = ioremap_nocache(start, len);
+	if (!base) {
+		dev_err(&pdev->dev, "error mapping bar0\n");
+		retval = -EFAULT;
+		goto err3;
+	}
+
+	lnw = kzalloc(sizeof(struct lnw_gpio), GFP_KERNEL);
+	if (!lnw) {
+		dev_err(&pdev->dev, "can not allocate lnw_gpio chip data\n");
+		retval = -ENOMEM;
+		goto err4;
+	}
+	lnw->reg_base = base;
+	lnw->irq_base = irq_base;
+	lnw->chip.label = dev_name(&pdev->dev);
+	lnw->chip.direction_input = lnw_gpio_direction_input;
+	lnw->chip.direction_output = lnw_gpio_direction_output;
+	lnw->chip.get = lnw_gpio_get;
+	lnw->chip.set = lnw_gpio_set;
+	lnw->chip.to_irq = lnw_gpio_to_irq;
+	lnw->chip.base = ddata->gpio_base;
+	lnw->chip.ngpio = ddata->gpio_nr;
+	lnw->chip.can_sleep = 0;
+	pci_set_drvdata(pdev, lnw);
+	retval = gpiochip_add(&lnw->chip);
+	if (retval) {
+		dev_err(&pdev->dev, "lnw gpiochip_add error %d\n", retval);
+		goto err5;
+	}
+	set_irq_data(pdev->irq, lnw);
+	set_irq_chained_handler(pdev->irq, lnw_irq_handler);
+	for (i = 0; i < lnw->chip.ngpio; i++) {
+		set_irq_chip_and_handler_name(i + lnw->irq_base, &lnw_irqchip,
+					handle_edge_irq, "demux");
+		set_irq_chip_data(i + lnw->irq_base, lnw);
+	}
+
+	spin_lock_init(&lnw->lock);
+	goto done;
+err5:
+	kfree(lnw);
+err4:
+	iounmap(base);
+err3:
+	pci_release_regions(pdev);
+err2:
+	pci_disable_device(pdev);
+done:
+	return retval;
+}
+
+static void __devexit lnw_gpio_remove(struct pci_dev *pdev)
+{
+	struct lnw_gpio *lnw = (struct lnw_gpio *)pci_get_drvdata(pdev);
+
+	if (gpiochip_remove(&lnw->chip)) {
+		dev_err(&pdev->dev, "lnw gpio driver remove error\n");
+		return;
+	}
+	pci_disable_device(pdev);
+	set_irq_chained_handler(pdev->irq, NULL);
+	pci_release_regions(pdev);
+	iounmap(lnw->reg_base);
+	pci_set_drvdata(pdev, NULL);
+	kfree(lnw);
+}
+
+static struct pci_driver lnw_gpio_driver = {
+	.name		= "Langwell GPIO driver",
+	.id_table	= lnw_gpio_ids,
+	.probe		= lnw_gpio_probe,
+	.remove		= lnw_gpio_remove,
+};
+
+static int __init lnw_gpio_init(void)
+{
+	return pci_register_driver(&lnw_gpio_driver);
+}
+
+static void __exit lnw_gpio_exit(void)
+{
+	pci_unregister_driver(&lnw_gpio_driver);
+}
+
+MODULE_AUTHOR("Alek Du <alek.du@intel.com>");
+MODULE_DESCRIPTION("Intel Moorestown Platform Langwell chip GPIO driver");
+MODULE_LICENSE("GPL v2");
+
+module_init(lnw_gpio_init);
+module_exit(lnw_gpio_exit);
-- 
1.6.0.4
