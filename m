Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXLJJj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXLJJj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXLJJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:39:18 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:40017 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbXLJJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=I9TC9xEHrwm/paYy4MbBM/LUZGgMuBQjtiK9eQqP6AQ/EhR6TcRD/uIb4n5JHhkfLvaIEO7Mji3CXnL1AZw9ErJAeglvSbkhNH8FyJibQinqkGvlaWnbj0wriY23FYKvo+G6RGTaepUt8iHCqyaMldQ738amU4bswMLes+6Z/F8=
Message-ID: <f17812d70712100139q31c95d6er12105ebbe94b3909@mail.gmail.com>
Date: Mon, 10 Dec 2007 17:39:09 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       i2c@lm-sensors.org
Subject: [PATCH 2.6.24-rc4-mm 1/2] gpiolib: basic support for 16-bit PCA9539 GPIO expander
Cc: "David Brownell" <david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. use 16-bit register access to simplify the logic, cache OUTPUT
   and DIRECTION registers for fast access

2. platform code is required to setup
   a) the numbering of GPIO for PCA9539 (base and number)
   c) pass "pca9539_platform_data" within "i2c_board_info"

Signed-off-by: eric miao <eric.miao@marvell.com>
Acked-by: Ben Gardner <bgardner@wabtec.com>
---
 drivers/gpio/Kconfig        |   10 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/pca9539.c      |  248 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca9539.h |   18 +++
 4 files changed, 277 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pca9539.c
 create mode 100644 include/linux/i2c/pca9539.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index dd9e697..6528fce 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -32,6 +32,16 @@ config GPIO_PCF857X
 	  This driver provides an in-kernel interface to those GPIOs using
 	  platform-neutral GPIO calls.

+config GPIO_PCA9539
+	tristate "Philips PCA9539 16-bit I/O port"
+	depends on I2C
+	help
+	  If you say yes here you get support for the Philips PCA9539
+	  16-bit I/O port.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called pca9539.
+
 comment "SPI GPIO expanders:"

 config GPIO_MCP23S08
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 575bb57..5f32943 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -2,3 +2,4 @@

 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
+obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
diff --git a/drivers/gpio/pca9539.c b/drivers/gpio/pca9539.c
new file mode 100644
index 0000000..0a3ae6a
--- /dev/null
+++ b/drivers/gpio/pca9539.c
@@ -0,0 +1,248 @@
+/*
+    pca9539.c - 16-bit I/O port with interrupt and reset
+
+    Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+    Copyright (C) 2007 Marvell Internation Ltd.
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; version 2 of the License.
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca9539.h>
+
+#include <asm/gpio.h>
+
+#define NR_PCA9539_GPIOS	16
+
+#define PCA9539_INPUT		0
+#define PCA9539_OUTPUT		2
+#define PCA9539_INVERT		4
+#define PCA9539_DIRECTION	6
+
+struct pca9539_chip {
+	unsigned gpio_start;
+	uint16_t reg_output;
+	uint16_t reg_direction;
+
+	struct i2c_client *client;
+	struct gpio_chip gpio_chip;
+};
+
+static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
+{
+	return i2c_smbus_write_word_data(chip->client, reg, val);
+}
+
+static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: failed to read\n", __FUNCTION__);
+		return ret;
+	}
+
+	*val = (uint16_t)ret;
+	return 0;
+}
+
+static int pca9539_gpio_direction_input(struct gpio_chip *gc, unsigned off)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	reg_val = chip->reg_direction | (1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca9539_gpio_direction_output(struct gpio_chip *gc,
+		unsigned off, int val)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	/* set output level */
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_output = reg_val;
+
+	/* then direction */
+	reg_val = chip->reg_direction & ~(1u << off);
+	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
+	if (ret)
+		return ret;
+
+	chip->reg_direction = reg_val;
+	return 0;
+}
+
+static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
+	if (ret < 0)
+		return ret;
+
+	return (reg_val & (1u << off)) ? 1 : 0;
+}
+
+static void pca9539_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
+{
+	struct pca9539_chip *chip;
+	uint16_t reg_val;
+	int ret;
+
+	chip = container_of(gc, struct pca9539_chip, gpio_chip);
+
+	if (val)
+		reg_val = chip->reg_output | (1u << off);
+	else
+		reg_val = chip->reg_output & ~(1u << off);
+
+	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
+	if (ret)
+		return;
+
+	chip->reg_output = reg_val;
+}
+
+static int pca9539_init_gpio(struct pca9539_chip *chip)
+{
+	struct gpio_chip *gc;
+
+	gc = &chip->gpio_chip;
+
+	gc->direction_input  = pca9539_gpio_direction_input;
+	gc->direction_output = pca9539_gpio_direction_output;
+	gc->get = pca9539_gpio_get_value;
+	gc->set = pca9539_gpio_set_value;
+
+	gc->base = chip->gpio_start;
+	gc->ngpio = NR_PCA9539_GPIOS;
+	gc->label = "pca9539";
+
+	return gpiochip_add(gc);
+}
+
+static int __devinit pca9539_probe(struct i2c_client *client)
+{
+	struct pca9539_platform_data *pdata;
+	struct pca9539_chip *chip;
+	int ret;
+
+	pdata = client->dev.platform_data;
+	if (pdata == NULL)
+		return -ENODEV;
+
+	chip = kzalloc(sizeof(struct pca9539_chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->client = client;
+
+	chip->gpio_start = pdata->gpio_base;
+
+	/* initialize registers */
+	chip->reg_output = 0xffff;
+	chip->reg_direction = 0xffff;
+
+	pca9539_write_reg(chip, PCA9539_OUTPUT, chip->reg_output);
+	pca9539_write_reg(chip, PCA9539_DIRECTION, chip->reg_direction);
+
+	/* set platform specific polarity inversion */
+	pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+
+	ret = pca9539_init_gpio(chip);
+	if (ret)
+		goto out_failed;
+
+	if (pdata->setup) {
+		ret = pdata->setup(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_dbg(&client->dev, "setup failed, %d\n", ret);
+	}
+
+	i2c_set_clientdata(client, chip);
+	return 0;
+
+out_failed:
+	kfree(chip);
+	return ret;
+}
+
+static int pca9539_remove(struct i2c_client *client)
+{
+	struct pca9539_platform_data *pdata = client->dev.platform_data;
+	struct pca9539_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	if (pdata->teardown) {
+		ret = pdata->teardown(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_dbg(&client->dev, "teardown failed, %d\n", ret);
+	}
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (ret) {
+		dev_err(&client->dev, "failed remove gpio_chip\n");
+		return ret;
+	}
+
+	kfree(chip);
+	return 0;
+}
+
+static struct i2c_driver pca9539_driver = {
+	.driver = {
+		.name	= "pca9539",
+	},
+	.probe		= pca9539_probe,
+	.remove		= pca9539_remove,
+};
+
+static int __init pca9539_init(void)
+{
+	return i2c_add_driver(&pca9539_driver);
+}
+
+static void __exit pca9539_exit(void)
+{
+	i2c_del_driver(&pca9539_driver);
+}
+
+MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
+MODULE_DESCRIPTION("PCA9539 driver");
+MODULE_LICENSE("GPL");
+
+module_init(pca9539_init);
+module_exit(pca9539_exit);
diff --git a/include/linux/i2c/pca9539.h b/include/linux/i2c/pca9539.h
new file mode 100644
index 0000000..611d84a
--- /dev/null
+++ b/include/linux/i2c/pca9539.h
@@ -0,0 +1,18 @@
+/* platform data for the PCA9539 16-bit I/O expander driver */
+
+struct pca9539_platform_data {
+	/* number of the first GPIO */
+	unsigned	gpio_base;
+
+	/* initial polarity inversion setting */
+	uint16_t	invert;
+
+	void		*context;	/* param to setup/teardown */
+
+	int		(*setup)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+	int		(*teardown)(struct i2c_client *client,
+				unsigned gpio, unsigned ngpio,
+				void *context);
+};
-- 
1.5.2.5.GIT
