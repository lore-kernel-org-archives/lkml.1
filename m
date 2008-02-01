Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbYBAT1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbYBAT1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYBAT1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:27:41 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:45584 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753646AbYBAT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:27:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=pmJEdvA/zECyuhyS7ZLLrroaIUM+Csb51W53Q1+s5PKJ8UQeloqkK553nUXGNewNK8Ozj2J/+wb4q1/D7Bp3BfAkFLedJD4wmI4QDFyQv3k2ULbX29kx86yMC6M3oL5OC8eFr3AeQpDPZg7js9Tx+SGJgJAsV165iuIljTaVYtA=  ;
X-YMail-OSG: ryscck0VM1mBpPvjy2bxsLKOYgoHdkCik2YxwfOy7l5HLe49OLML_kIr3WnfOZTk9uaFeIgxmA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-git + mm-gpiolib 1/3] gpio: rename pca9539 driver
Date: Fri, 1 Feb 2008 11:21:53 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, eric miao <eric.y.miao@gmail.com>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802011121.53903.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

First part of an extension to let the pca9539 driver support more
chips, starting with pca9534, pca9535, pca9536, pca9537, and pca9538.

This renames the files and modifies the Makefile.
    
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/Makefile       |    2 
 drivers/gpio/pca9539.c      |  271 --------------------------------------------
 drivers/gpio/pca953x.c      |  271 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca9539.h |   18 --
 include/linux/i2c/pca953x.h |   18 ++
 5 files changed, 290 insertions(+), 290 deletions(-)

--- g26.orig/drivers/gpio/Makefile	2008-01-30 11:51:33.000000000 -0800
+++ g26/drivers/gpio/Makefile	2008-01-31 14:30:51.000000000 -0800
@@ -5,5 +5,5 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
 
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
-obj-$(CONFIG_GPIO_PCA9539)	+= pca9539.o
+obj-$(CONFIG_GPIO_PCA9539)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
--- g26.orig/drivers/gpio/pca9539.c	2008-01-30 11:51:33.000000000 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,271 +0,0 @@
-/*
- *  pca9539.c - 16-bit I/O port with interrupt and reset
- *
- *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
- *  Copyright (C) 2007 Marvell International Ltd.
- *
- *  Derived from drivers/i2c/chips/pca9539.c
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/i2c/pca9539.h>
-
-#include <asm/gpio.h>
-
-
-#define NR_PCA9539_GPIOS	16
-
-#define PCA9539_INPUT		0
-#define PCA9539_OUTPUT		2
-#define PCA9539_INVERT		4
-#define PCA9539_DIRECTION	6
-
-struct pca9539_chip {
-	unsigned gpio_start;
-	uint16_t reg_output;
-	uint16_t reg_direction;
-
-	struct i2c_client *client;
-	struct gpio_chip gpio_chip;
-};
-
-/* NOTE:  we can't currently rely on fault codes to come from SMBus
- * calls, so we map all errors to EIO here and return zero otherwise.
- */
-static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
-{
-	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
-		return -EIO;
-	else
-		return 0;
-}
-
-static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
-{
-	int ret;
-
-	ret = i2c_smbus_read_word_data(chip->client, reg);
-	if (ret < 0) {
-		dev_err(&chip->client->dev, "failed reading register\n");
-		return -EIO;
-	}
-
-	*val = (uint16_t)ret;
-	return 0;
-}
-
-static int pca9539_gpio_direction_input(struct gpio_chip *gc, unsigned off)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	reg_val = chip->reg_direction | (1u << off);
-	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
-	if (ret)
-		return ret;
-
-	chip->reg_direction = reg_val;
-	return 0;
-}
-
-static int pca9539_gpio_direction_output(struct gpio_chip *gc,
-		unsigned off, int val)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	/* set output level */
-	if (val)
-		reg_val = chip->reg_output | (1u << off);
-	else
-		reg_val = chip->reg_output & ~(1u << off);
-
-	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
-	if (ret)
-		return ret;
-
-	chip->reg_output = reg_val;
-
-	/* then direction */
-	reg_val = chip->reg_direction & ~(1u << off);
-	ret = pca9539_write_reg(chip, PCA9539_DIRECTION, reg_val);
-	if (ret)
-		return ret;
-
-	chip->reg_direction = reg_val;
-	return 0;
-}
-
-static int pca9539_gpio_get_value(struct gpio_chip *gc, unsigned off)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	ret = pca9539_read_reg(chip, PCA9539_INPUT, &reg_val);
-	if (ret < 0) {
-		/* NOTE:  diagnostic already emitted; that's all we should
-		 * do unless gpio_*_value_cansleep() calls become different
-		 * from their nonsleeping siblings (and report faults).
-		 */
-		return 0;
-	}
-
-	return (reg_val & (1u << off)) ? 1 : 0;
-}
-
-static void pca9539_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
-{
-	struct pca9539_chip *chip;
-	uint16_t reg_val;
-	int ret;
-
-	chip = container_of(gc, struct pca9539_chip, gpio_chip);
-
-	if (val)
-		reg_val = chip->reg_output | (1u << off);
-	else
-		reg_val = chip->reg_output & ~(1u << off);
-
-	ret = pca9539_write_reg(chip, PCA9539_OUTPUT, reg_val);
-	if (ret)
-		return;
-
-	chip->reg_output = reg_val;
-}
-
-static int pca9539_init_gpio(struct pca9539_chip *chip)
-{
-	struct gpio_chip *gc;
-
-	gc = &chip->gpio_chip;
-
-	gc->direction_input  = pca9539_gpio_direction_input;
-	gc->direction_output = pca9539_gpio_direction_output;
-	gc->get = pca9539_gpio_get_value;
-	gc->set = pca9539_gpio_set_value;
-
-	gc->base = chip->gpio_start;
-	gc->ngpio = NR_PCA9539_GPIOS;
-	gc->label = "pca9539";
-
-	return gpiochip_add(gc);
-}
-
-static int __devinit pca9539_probe(struct i2c_client *client)
-{
-	struct pca9539_platform_data *pdata;
-	struct pca9539_chip *chip;
-	int ret;
-
-	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
-
-	chip = kzalloc(sizeof(struct pca9539_chip), GFP_KERNEL);
-	if (chip == NULL)
-		return -ENOMEM;
-
-	chip->client = client;
-
-	chip->gpio_start = pdata->gpio_base;
-
-	/* initialize cached registers from their original values.
-	 * we can't share this chip with another i2c master.
-	 */
-	ret = pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
-	if (ret)
-		goto out_failed;
-
-	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
-	if (ret)
-		goto out_failed;
-
-	/* set platform specific polarity inversion */
-	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
-	if (ret)
-		goto out_failed;
-
-	ret = pca9539_init_gpio(chip);
-	if (ret)
-		goto out_failed;
-
-	if (pdata->setup) {
-		ret = pdata->setup(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0)
-			dev_warn(&client->dev, "setup failed, %d\n", ret);
-	}
-
-	i2c_set_clientdata(client, chip);
-	return 0;
-
-out_failed:
-	kfree(chip);
-	return ret;
-}
-
-static int pca9539_remove(struct i2c_client *client)
-{
-	struct pca9539_platform_data *pdata = client->dev.platform_data;
-	struct pca9539_chip *chip = i2c_get_clientdata(client);
-	int ret = 0;
-
-	if (pdata->teardown) {
-		ret = pdata->teardown(client, chip->gpio_chip.base,
-				chip->gpio_chip.ngpio, pdata->context);
-		if (ret < 0) {
-			dev_err(&client->dev, "%s failed, %d\n",
-					"teardown", ret);
-			return ret;
-		}
-	}
-
-	ret = gpiochip_remove(&chip->gpio_chip);
-	if (ret) {
-		dev_err(&client->dev, "%s failed, %d\n",
-				"gpiochip_remove()", ret);
-		return ret;
-	}
-
-	kfree(chip);
-	return 0;
-}
-
-static struct i2c_driver pca9539_driver = {
-	.driver = {
-		.name	= "pca9539",
-	},
-	.probe		= pca9539_probe,
-	.remove		= pca9539_remove,
-};
-
-static int __init pca9539_init(void)
-{
-	return i2c_add_driver(&pca9539_driver);
-}
-module_init(pca9539_init);
-
-static void __exit pca9539_exit(void)
-{
-	i2c_del_driver(&pca9539_driver);
-}
-module_exit(pca9539_exit);
-
-MODULE_AUTHOR("eric miao <eric.miao@marvell.com>");
-MODULE_DESCRIPTION("GPIO expander driver for PCA9539");
-MODULE_LICENSE("GPL");
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ g26/drivers/gpio/pca953x.c	2008-01-31 14:30:51.000000000 -0800
@@ -0,0 +1,271 @@
+/*
+ *  pca9539.c - 16-bit I/O port with interrupt and reset
+ *
+ *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
+ *  Copyright (C) 2007 Marvell International Ltd.
+ *
+ *  Derived from drivers/i2c/chips/pca9539.c
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca953x.h>
+
+#include <asm/gpio.h>
+
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
+/* NOTE:  we can't currently rely on fault codes to come from SMBus
+ * calls, so we map all errors to EIO here and return zero otherwise.
+ */
+static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
+{
+	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
+		return -EIO;
+	else
+		return 0;
+}
+
+static int pca9539_read_reg(struct pca9539_chip *chip, int reg, uint16_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed reading register\n");
+		return -EIO;
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
+	if (ret < 0) {
+		/* NOTE:  diagnostic already emitted; that's all we should
+		 * do unless gpio_*_value_cansleep() calls become different
+		 * from their nonsleeping siblings (and report faults).
+		 */
+		return 0;
+	}
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
+	/* initialize cached registers from their original values.
+	 * we can't share this chip with another i2c master.
+	 */
+	ret = pca9539_read_reg(chip, PCA9539_OUTPUT, &chip->reg_output);
+	if (ret)
+		goto out_failed;
+
+	ret = pca9539_read_reg(chip, PCA9539_DIRECTION, &chip->reg_direction);
+	if (ret)
+		goto out_failed;
+
+	/* set platform specific polarity inversion */
+	ret = pca9539_write_reg(chip, PCA9539_INVERT, pdata->invert);
+	if (ret)
+		goto out_failed;
+
+	ret = pca9539_init_gpio(chip);
+	if (ret)
+		goto out_failed;
+
+	if (pdata->setup) {
+		ret = pdata->setup(client, chip->gpio_chip.base,
+				chip->gpio_chip.ngpio, pdata->context);
+		if (ret < 0)
+			dev_warn(&client->dev, "setup failed, %d\n", ret);
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
+		if (ret < 0) {
+			dev_err(&client->dev, "%s failed, %d\n",
+					"teardown", ret);
+			return ret;
+		}
+	}
+
+	ret = gpiochip_remove(&chip->gpio_chip);
+	if (ret) {
+		dev_err(&client->dev, "%s failed, %d\n",
+				"gpiochip_remove()", ret);
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
+module_init(pca9539_init);
+
+static void __exit pca9539_exit(void)
+{
+	i2c_del_driver(&pca9539_driver);
+}
+module_exit(pca9539_exit);
+
+MODULE_AUTHOR("eric miao <eric.miao@marvell.com>");
+MODULE_DESCRIPTION("GPIO expander driver for PCA9539");
+MODULE_LICENSE("GPL");
--- g26.orig/include/linux/i2c/pca9539.h	2008-01-30 11:51:33.000000000 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,18 +0,0 @@
-/* platform data for the PCA9539 16-bit I/O expander driver */
-
-struct pca9539_platform_data {
-	/* number of the first GPIO */
-	unsigned	gpio_base;
-
-	/* initial polarity inversion setting */
-	uint16_t	invert;
-
-	void		*context;	/* param to setup/teardown */
-
-	int		(*setup)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
-				void *context);
-	int		(*teardown)(struct i2c_client *client,
-				unsigned gpio, unsigned ngpio,
-				void *context);
-};
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ g26/include/linux/i2c/pca953x.h	2008-01-31 14:30:51.000000000 -0800
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
