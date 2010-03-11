Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0CKIne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 03:43:34 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65230 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0CKIn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 03:43:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=acL2D5T8eIQ1/K5qnQmROYIiMdEwk3wTjeu6ay3hg6QrkCXpTLzpT6C/OpkIweeDsD
         RafHBv0qOVABYtR1IZ/Cup/BVg4Yw+5BrMHBnGVonTYSSQ8ifwx0K4QthUIvspzaDwDj
         Cc3NDVbx9CdfKXHBNFqPML5zzNVg+yt4zsD54=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 11 Mar 2010 09:42:13 +0100
Subject: [PATCH 3/4 v2] GPIO: add support for RDC321x GPIO controller
MIME-Version: 1.0
X-TUID: 06adf23d1b77b354
X-Length: 9114
Organization: OpenWrt
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003110942.13093.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new GPIO driver for the RDC321x SoC GPIO controller.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index fee678f..dd10eb8 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -275,6 +275,14 @@ config GPIO_TIMBERDALE
 	---help---
 	Add support for the GPIO IP in the timberdale FPGA.
 
+config GPIO_RDC321X
+	tristate "RDC R-321x GPIO support"
+	depends on PCI && GPIOLIB
+	select MFD_RDC321X
+	help
+	  Support for the RDC R321x SoC GPIOs over southbridge
+	  PCI configuration space.
+
 comment "SPI GPIO expanders:"
 
 config GPIO_MAX7301
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 10f3f8d..d3226d3 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -27,4 +27,5 @@ obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
 obj-$(CONFIG_GPIO_WM831X)	+= wm831x-gpio.o
 obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
 obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
-obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
\ No newline at end of file
+obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
+obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
new file mode 100644
index 0000000..545d333
--- /dev/null
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -0,0 +1,237 @@
+/*
+ * RDC321x GPIO driver
+ *
+ * Copyright (C) 2008, Volker Weiss <dev@tintuc.de>
+ * Copyright (C) 2007-2010 Florian Fainelli <florian@openwrt.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+#include <linux/mfd/rdc321x.h>
+
+struct rdc321x_gpio {
+	spinlock_t		lock;
+	u32 			data_reg[2];
+	int			reg1_ctrl_base;
+	int			reg1_data_base;
+	int			reg2_ctrl_base;
+	int			reg2_data_base;
+	struct gpio_chip	chip;
+};
+
+/* read GPIO pin */
+static int rdc_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
+{
+	struct rdc321x_gpio *gpch =
+				container_of(chip, struct rdc321x_gpio, chip);
+	u32 value = 0;
+	int reg;
+
+	reg = gpio < 32 ? gpch->reg1_data_base : gpch->reg2_data_base;
+
+	spin_lock(&gpch->lock);
+	rdc321x_pci_write(reg, gpch->data_reg[gpio < 32 ? 0 : 1]);
+	rdc321x_pci_read(reg, &value);
+	spin_unlock(&gpch->lock);
+
+	return (1 << (gpio & 0x1f)) & value ? 1 : 0;
+}
+
+static void rdc_gpio_set_value_impl(struct gpio_chip *chip,
+				unsigned gpio, int value)
+{
+	struct rdc321x_gpio *gpch =
+				container_of(chip, struct rdc321x_gpio, chip);
+	int reg = (gpio < 32) ? 0 : 1;
+
+	if (value)
+		gpch->data_reg[reg] |= 1 << (gpio & 0x1f);
+	else
+		gpch->data_reg[reg] &= ~(1 << (gpio & 0x1f));
+
+	rdc321x_pci_write(reg ? gpch->reg1_data_base : gpch->reg2_data_base,
+			       gpch->data_reg[reg]);
+}
+
+/* set GPIO pin to value */
+static void rdc_gpio_set_value(struct gpio_chip *chip,
+				unsigned gpio, int value)
+{
+	struct rdc321x_gpio *gpch =
+				container_of(chip, struct rdc321x_gpio, chip);
+	spin_lock(&gpch->lock);
+	rdc_gpio_set_value_impl(chip, gpio, value);
+	spin_unlock(&gpch->lock);
+}
+
+static int rdc_gpio_config(struct gpio_chip *chip,
+				unsigned gpio, int value)
+{
+	struct rdc321x_gpio *gpch =
+			container_of(chip, struct rdc321x_gpio, chip);
+	int err;
+	u32 reg;
+
+	spin_lock(&gpch->lock);
+	err = rdc321x_pci_read(gpio < 32 ?
+			gpch->reg1_ctrl_base : gpch->reg2_ctrl_base, &reg);
+	if (err)
+		goto unlock;
+
+	reg |= 1 << (gpio & 0x1f);
+
+	err = rdc321x_pci_write(gpio < 32 ?
+			gpch->reg1_ctrl_base : gpch->reg2_ctrl_base, reg);
+	if (err)
+		goto unlock;
+
+	rdc_gpio_set_value_impl(chip, gpio, value);
+
+unlock:
+	spin_unlock(&gpch->lock);
+
+	return err;
+}
+
+/* configure GPIO pin as input */
+static int rdc_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	return rdc_gpio_config(chip, gpio, 1);
+}
+
+/*
+ * Cache the initial value of both GPIO data registers
+ */
+static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
+{
+	int err;
+	struct resource *r;
+	struct rdc321x_gpio *rdc321x_gpio_dev;
+	struct rdc321x_gpio_pdata *pdata;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "no platform data supplied\n");
+		return -ENODEV;
+	}
+
+	rdc321x_gpio_dev = kzalloc(sizeof(struct rdc321x_gpio), GFP_KERNEL);
+	if (!rdc321x_gpio_dev) {
+		dev_err(&pdev->dev, "failed to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg1");
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get gpio-reg1 resource\n");
+		err = -ENODEV;
+		goto out_free;
+	}
+
+	rdc321x_gpio_dev->reg1_ctrl_base = r->start;
+	rdc321x_gpio_dev->reg1_data_base = r->start + 0x4;
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gpio-reg2");
+	if (!r) {
+		dev_err(&pdev->dev, "failed to get gpio-reg2 resource\n");
+		err = -ENODEV;
+		goto out_free;
+	}
+
+	rdc321x_gpio_dev->reg2_ctrl_base = r->start;
+	rdc321x_gpio_dev->reg2_data_base = r->start + 0x4;
+
+	rdc321x_gpio_dev->chip.label = "rdc321x-gpio";
+	rdc321x_gpio_dev->chip.direction_input = rdc_gpio_direction_input;
+	rdc321x_gpio_dev->chip.direction_output = rdc_gpio_config;
+	rdc321x_gpio_dev->chip.get = rdc_gpio_get_value;
+	rdc321x_gpio_dev->chip.set = rdc_gpio_set_value;
+	rdc321x_gpio_dev->chip.base = 0;
+	rdc321x_gpio_dev->chip.ngpio = pdata->max_gpios;
+
+	platform_set_drvdata(pdev, rdc321x_gpio_dev);
+
+	/* This might not be, what others (BIOS, bootloader, etc.)
+	   wrote to these registers before, but it's a good guess. Still
+	   better than just using 0xffffffff. */
+	err = rdc321x_pci_read(rdc321x_gpio_dev->reg1_data_base,
+					&rdc321x_gpio_dev->data_reg[0]);
+	if (err)
+		goto out_drvdata;
+
+	err = rdc321x_pci_read(rdc321x_gpio_dev->reg2_data_base,
+					&rdc321x_gpio_dev->data_reg[1]);
+	if (err)
+		goto out_drvdata;
+
+	spin_lock_init(&rdc321x_gpio_dev->lock);
+
+	printk(KERN_INFO "rdc321x-gpio: registering %d GPIOs\n",
+					rdc321x_gpio_dev->chip.ngpio);
+	return gpiochip_add(&rdc321x_gpio_dev->chip);
+
+out_drvdata:
+	platform_set_drvdata(pdev, NULL);
+out_free:
+	kfree(rdc321x_gpio_dev);
+	return err;
+}
+
+static int __devexit rdc321x_gpio_remove(struct platform_device *pdev)
+{
+	int ret;
+	struct rdc321x_gpio *rdc321x_gpio_dev = platform_get_drvdata(pdev);
+
+	ret = gpiochip_remove(&rdc321x_gpio_dev->chip);
+	if (ret)
+		dev_err(&pdev->dev, "failed to unregister chip\n");
+
+	kfree(rdc321x_gpio_dev);
+	platform_set_drvdata(pdev, NULL);
+
+	return ret;
+}
+
+static struct platform_driver rdc321x_gpio_driver = {
+	.driver.name	= "rdc321x-gpio",
+	.driver.owner	= THIS_MODULE,
+	.probe		= rdc321x_gpio_probe,
+	.remove		= __devexit_p(rdc321x_gpio_remove),
+};
+
+static int __init rdc321x_gpio_init(void)
+{
+	return platform_driver_register(&rdc321x_gpio_driver);
+}
+
+static void __exit rdc321x_gpio_exit(void)
+{
+	platform_driver_unregister(&rdc321x_gpio_driver);
+}
+
+module_init(rdc321x_gpio_init);
+module_exit(rdc321x_gpio_exit);
+
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION("RDC321x GPIO driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rdc321x-gpio");
