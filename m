Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZFCHnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZFCHnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFCHm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:42:59 -0400
Received: from proxy2.bredband.net ([195.54.101.72]:59432 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403AbZFCHm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:42:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFANvGJUpV5HbzPGdsb2JhbACBT5Y7AQEBAbdYhAsF
X-IronPort-AV: E=Sophos;i="4.41,297,1241388000"; 
   d="scan'208";a="498663341"
Message-ID: <4A262981.90203@mocean-labs.com>
Date: Wed, 03 Jun 2009 09:42:57 +0200
From: =?UTF-8?B?UmljaGFyZCBSwprDtmpmb3Jz?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: =?UTF-8?B?J1JpY2hhcmQgUsKaw7ZqZm9ycyc=?= 
	<richard.rojfors.ext@mocean-labs.com>
Subject: [PATCH] gpio: Added MC33880 driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Supplied is a GPIO driver for the Freescale MC33880 High/Low side switch

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
---
Index: linux-2.6.30-rc7/drivers/gpio/mc33880.c
===================================================================
--- linux-2.6.30-rc7/drivers/gpio/mc33880.c	(revision 0)
+++ linux-2.6.30-rc7/drivers/gpio/mc33880.c	(revision 864)
@@ -0,0 +1,196 @@
+/*
+ * mc33880.c MC33880 high-side/low-side switch GPIO driver
+ * Copyright (c) 2009 Intel Corporation
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
+ * Freescale MC33880 high-side/low-side switch
+ */
+
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/mc33880.h>
+#include <linux/gpio.h>
+
+#define DRIVER_NAME "mc33880"
+
+/*
+ * Pin configurations, see MAX7301 datasheet page 6
+ */
+#define PIN_CONFIG_MASK 0x03
+#define PIN_CONFIG_IN_PULLUP 0x03
+#define PIN_CONFIG_IN_WO_PULLUP 0x02
+#define PIN_CONFIG_OUT 0x01
+
+#define PIN_NUMBER 8
+
+
+/*
+ * Some registers must be read back to modify.
+ * To save time we cache them here in memory
+ */
+struct mc33880 {
+	struct mutex	lock;	/* protect from simultanous accesses */
+	u8		port_config;
+	struct gpio_chip chip;
+	struct spi_device *spi;
+};
+
+static int mc33880_write_config(struct mc33880 *mc)
+{
+	return spi_write(mc->spi, &mc->port_config, sizeof(mc->port_config));
+}
+
+
+static int __mc33880_set(struct mc33880 *mc, unsigned offset, int value)
+{
+	if (value)
+		mc->port_config |= 1 << offset;
+	else
+		mc->port_config &= ~(1 << offset);
+
+	return mc33880_write_config(mc);
+}
+
+
+static void mc33880_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mc33880 *mc = container_of(chip, struct mc33880, chip);
+
+	mutex_lock(&mc->lock);
+
+	__mc33880_set(mc, offset, value);
+
+	mutex_unlock(&mc->lock);
+}
+
+static int __devinit mc33880_probe(struct spi_device *spi)
+{
+	struct mc33880 *mc;
+	struct mc33880_platform_data *pdata;
+	int ret;
+
+	pdata = spi->dev.platform_data;
+	if (!pdata || !pdata->base) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * bits_per_word cannot be configured in platform data
+	 */
+	spi->bits_per_word = 8;
+
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	mc = kzalloc(sizeof(struct mc33880), GFP_KERNEL);
+	if (!mc)
+		return -ENOMEM;
+
+	mutex_init(&mc->lock);
+
+	dev_set_drvdata(&spi->dev, mc);
+
+	mc->spi = spi;
+
+	mc->chip.label = DRIVER_NAME,
+	mc->chip.set = mc33880_set;
+	mc->chip.base = pdata->base;
+	mc->chip.ngpio = PIN_NUMBER;
+	mc->chip.can_sleep = 1;
+	mc->chip.dev = &spi->dev;
+	mc->chip.owner = THIS_MODULE;
+
+	mc->port_config = 0x00;
+	/* write twice, because during initialisation the first setting
+	 * is just for testing SPI communication, and the second is the
+	 * "real" configuration
+	 */
+	ret = mc33880_write_config(mc);
+	mc->port_config = 0x00;
+	if (!ret)
+		ret = mc33880_write_config(mc);
+
+	if (ret) {
+		printk(KERN_ERR "Failed writing to " DRIVER_NAME ": %d\n", ret);
+		goto exit_destroy;
+	}
+
+	ret = gpiochip_add(&mc->chip);
+	if (ret)
+		goto exit_destroy;
+
+	return ret;
+
+exit_destroy:
+	dev_set_drvdata(&spi->dev, NULL);
+	mutex_destroy(&mc->lock);
+	kfree(mc);
+	return ret;
+}
+
+static int mc33880_remove(struct spi_device *spi)
+{
+	struct mc33880 *mc;
+	int ret;
+
+	mc = dev_get_drvdata(&spi->dev);
+	if (mc == NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(&spi->dev, NULL);
+
+	ret = gpiochip_remove(&mc->chip);
+	if (!ret) {
+		mutex_destroy(&mc->lock);
+		kfree(mc);
+	} else
+		dev_err(&spi->dev, "Failed to remove the GPIO controller: %d\n",
+			ret);
+
+	return ret;
+}
+
+static struct spi_driver mc33880_driver = {
+	.driver = {
+		.name		= DRIVER_NAME,
+		.owner		= THIS_MODULE,
+	},
+	.probe		= mc33880_probe,
+	.remove		= __devexit_p(mc33880_remove),
+};
+
+static int __init mc33880_init(void)
+{
+	return spi_register_driver(&mc33880_driver);
+}
+/* register after spi postcore initcall and before
+ * subsys initcalls that may rely on these GPIOs
+ */
+subsys_initcall(mc33880_init);
+
+static void __exit mc33880_exit(void)
+{
+	spi_unregister_driver(&mc33880_driver);
+}
+module_exit(mc33880_exit);
+
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_LICENSE("GPL v2");
+
Index: linux-2.6.30-rc7/drivers/gpio/Kconfig
===================================================================
--- linux-2.6.30-rc7/drivers/gpio/Kconfig	(revision 861)
+++ linux-2.6.30-rc7/drivers/gpio/Kconfig	(working copy)
@@ -176,4 +176,11 @@
 	  SPI driver for Microchip MCP23S08 I/O expander.  This provides
 	  a GPIO interface supporting inputs and outputs.

+config GPIO_MC33880
+	tristate "Freescale MC33880 high-side/low-side switch"
+	depends on SPI_MASTER
+	help
+	  SPI driver for Freescale MC33880 high-side/low-side switch.
+	  This provides GPIO interface supporting inputs and outputs.
+
 endif
Index: linux-2.6.30-rc7/drivers/gpio/Makefile
===================================================================
--- linux-2.6.30-rc7/drivers/gpio/Makefile	(revision 861)
+++ linux-2.6.30-rc7/drivers/gpio/Makefile	(working copy)
@@ -12,3 +12,5 @@
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
+obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
+
