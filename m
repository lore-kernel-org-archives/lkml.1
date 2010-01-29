Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052Ab0A2SVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab0A2SVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:21:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169Ab0A2SVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:21:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47030 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752088Ab0A2SUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:20:39 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: Add initial WM8994 support
Date: Fri, 29 Jan 2010 18:20:29 +0000
Message-Id: <1264789230-8398-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264789230-8398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1264789230-8398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8994 is a highly integrated ultra low power audio hub CODEC.
Since it includes on-board regulators and GPIOs it is represented
as a multi-function device, though the overwhelming majority of
the functionality is provided by the ASoC CODEC driver.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig              |   12 +
 drivers/mfd/Makefile             |    1 +
 drivers/mfd/wm8994-core.c        |  537 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8994/core.h  |   54 ++++
 include/linux/mfd/wm8994/gpio.h  |   72 +++++
 include/linux/mfd/wm8994/pdata.h |   97 +++++++
 6 files changed, 773 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wm8994-core.c
 create mode 100644 include/linux/mfd/wm8994/core.h
 create mode 100644 include/linux/mfd/wm8994/gpio.h
 create mode 100644 include/linux/mfd/wm8994/pdata.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3cecce8..5bce647 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -295,6 +295,18 @@ config MFD_WM8350_I2C
 	  I2C as the control interface.  Additional options must be
 	  selected to enable support for the functionality of the chip.
 
+config MFD_WM8994
+	tristate "Support Wolfson Microelectronics WM8994"
+	select MFD_CORE
+	depends on I2C
+	help
+	  The WM8994 is a highly integrated hi-fi CODEC designed for
+	  smartphone applicatiosn.  As well as audio functionality it
+	  has on board GPIO and regulator functionality which is
+	  supported via the relevant subsystems.  This driver provides
+	  core support for the WM8994, in order to use the actual
+	  functionaltiy of the device other drivers must be enabled.
+
 config MFD_PCF50633
 	tristate "Support for NXP PCF50633"
 	depends on I2C
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index a9c8396..1fda810 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -25,6 +25,7 @@ wm8350-objs			:= wm8350-core.o wm8350-regmap.o wm8350-gpio.o
 wm8350-objs			+= wm8350-irq.o
 obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
 obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
+obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o
 
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
new file mode 100644
index 0000000..299c1af
--- /dev/null
+++ b/drivers/mfd/wm8994-core.c
@@ -0,0 +1,537 @@
+/*
+ * wm8994-core.c  --  Device access for Wolfson WM8994
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/regulator/consumer.h>
+#include <linux/regulator/machine.h>
+
+#include <linux/mfd/wm8994/core.h>
+#include <linux/mfd/wm8994/pdata.h>
+#include <linux/mfd/wm8994/registers.h>
+
+static int wm8994_read(struct wm8994 *wm8994, unsigned short reg,
+		       int bytes, void *dest)
+{
+	int ret, i;
+	u16 *buf = dest;
+
+	BUG_ON(bytes % 2);
+	BUG_ON(bytes <= 0);
+
+	ret = wm8994->read_dev(wm8994, reg, bytes, dest);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < bytes / 2; i++) {
+		buf[i] = be16_to_cpu(buf[i]);
+
+		dev_vdbg(wm8994->dev, "Read %04x from R%d(0x%x)\n",
+			 buf[i], reg + i, reg + i);
+	}
+
+	return 0;
+}
+
+/**
+ * wm8994_reg_read: Read a single WM8994 register.
+ *
+ * @wm8994: Device to read from.
+ * @reg: Register to read.
+ */
+int wm8994_reg_read(struct wm8994 *wm8994, unsigned short reg)
+{
+	unsigned short val;
+	int ret;
+
+	mutex_lock(&wm8994->io_lock);
+
+	ret = wm8994_read(wm8994, reg, 2, &val);
+
+	mutex_unlock(&wm8994->io_lock);
+
+	if (ret < 0)
+		return ret;
+	else
+		return val;
+}
+EXPORT_SYMBOL_GPL(wm8994_reg_read);
+
+/**
+ * wm8994_bulk_read: Read multiple WM8994 registers
+ *
+ * @wm8994: Device to read from
+ * @reg: First register
+ * @count: Number of registers
+ * @buf: Buffer to fill.
+ */
+int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
+		     int count, u16 *buf)
+{
+	int ret;
+
+	mutex_lock(&wm8994->io_lock);
+
+	ret = wm8994_read(wm8994, reg, count * 2, buf);
+
+	mutex_unlock(&wm8994->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8994_bulk_read);
+
+static int wm8994_write(struct wm8994 *wm8994, unsigned short reg,
+			int bytes, void *src)
+{
+	u16 *buf = src;
+	int i;
+
+	BUG_ON(bytes % 2);
+	BUG_ON(bytes <= 0);
+
+	for (i = 0; i < bytes / 2; i++) {
+		dev_vdbg(wm8994->dev, "Write %04x to R%d(0x%x)\n",
+			 buf[i], reg + i, reg + i);
+
+		buf[i] = cpu_to_be16(buf[i]);
+	}
+
+	return wm8994->write_dev(wm8994, reg, bytes, src);
+}
+
+/**
+ * wm8994_reg_write: Write a single WM8994 register.
+ *
+ * @wm8994: Device to write to.
+ * @reg: Register to write to.
+ * @val: Value to write.
+ */
+int wm8994_reg_write(struct wm8994 *wm8994, unsigned short reg,
+		     unsigned short val)
+{
+	int ret;
+
+	mutex_lock(&wm8994->io_lock);
+
+	ret = wm8994_write(wm8994, reg, 2, &val);
+
+	mutex_unlock(&wm8994->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8994_reg_write);
+
+/**
+ * wm8994_set_bits: Set the value of a bitfield in a WM8994 register
+ *
+ * @wm8994: Device to write to.
+ * @reg: Register to write to.
+ * @mask: Mask of bits to set.
+ * @val: Value to set (unshifted)
+ */
+int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
+		    unsigned short mask, unsigned short val)
+{
+	int ret;
+	u16 r;
+
+	mutex_lock(&wm8994->io_lock);
+
+	ret = wm8994_read(wm8994, reg, 2, &r);
+	if (ret < 0)
+		goto out;
+
+	r &= ~mask;
+	r |= val;
+
+	ret = wm8994_write(wm8994, reg, 2, &r);
+
+out:
+	mutex_unlock(&wm8994->io_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wm8994_set_bits);
+
+static struct mfd_cell wm8994_regulator_devs[] = {
+	{ .name = "wm8994-ldo", .id = 1 },
+	{ .name = "wm8994-ldo", .id = 2 },
+};
+
+static struct mfd_cell wm8994_devs[] = {
+	{ .name = "wm8994-codec" },
+	{ .name = "wm8994-gpio" },
+};
+
+/*
+ * Supplies for the main bulk of CODEC; the LDO supplies are ignored
+ * and should be handled via the standard regulator API supply
+ * management.
+ */
+static const char *wm8994_main_supplies[] = {
+	"DBVDD",
+	"DCVDD",
+	"AVDD1",
+	"AVDD2",
+	"CPVDD",
+	"SPKVDD1",
+	"SPKVDD2",
+};
+
+#ifdef CONFIG_PM
+static int wm8994_device_suspend(struct device *dev)
+{
+	struct wm8994 *wm8994 = dev_get_drvdata(dev);
+	int ret;
+
+	/* GPIO configuration state is saved here since we may be configuring
+	 * the GPIO alternate functions even if we're not using the gpiolib
+	 * driver for them.
+	 */
+	ret = wm8994_read(wm8994, WM8994_GPIO_1, WM8994_NUM_GPIO_REGS * 2,
+			  &wm8994->gpio_regs);
+	if (ret < 0)
+		dev_err(dev, "Failed to save GPIO registers: %d\n", ret);
+
+	/* For similar reasons we also stash the regulator states */
+	ret = wm8994_read(wm8994, WM8994_LDO_1, WM8994_NUM_LDO_REGS * 2,
+			  &wm8994->ldo_regs);
+	if (ret < 0)
+		dev_err(dev, "Failed to save LDO registers: %d\n", ret);
+
+	ret = regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
+				     wm8994->supplies);
+	if (ret != 0) {
+		dev_err(dev, "Failed to disable supplies: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int wm8994_device_resume(struct device *dev)
+{
+	struct wm8994 *wm8994 = dev_get_drvdata(dev);
+	int ret;
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
+				    wm8994->supplies);
+	if (ret != 0) {
+		dev_err(dev, "Failed to enable supplies: %d\n", ret);
+		return ret;
+	}
+
+	ret = wm8994_write(wm8994, WM8994_LDO_1, WM8994_NUM_LDO_REGS * 2,
+			   &wm8994->ldo_regs);
+	if (ret < 0)
+		dev_err(dev, "Failed to restore LDO registers: %d\n", ret);
+
+	ret = wm8994_write(wm8994, WM8994_GPIO_1, WM8994_NUM_GPIO_REGS * 2,
+			   &wm8994->gpio_regs);
+	if (ret < 0)
+		dev_err(dev, "Failed to restore GPIO registers: %d\n", ret);
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_REGULATOR
+static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
+{
+	struct wm8994_ldo_pdata *ldo_pdata;
+
+	if (!pdata)
+		return 0;
+
+	ldo_pdata = &pdata->ldo[ldo];
+
+	if (!ldo_pdata->init_data)
+		return 0;
+
+	return ldo_pdata->init_data->num_consumer_supplies != 0;
+}
+#else
+static int wm8994_ldo_in_use(struct wm8994_pdata *pdata, int ldo)
+{
+	return 0;
+}
+#endif
+
+/*
+ * Instantiate the generic non-control parts of the device.
+ */
+static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
+{
+	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
+	int ret, i;
+
+	mutex_init(&wm8994->io_lock);
+	dev_set_drvdata(wm8994->dev, wm8994);
+
+	/* Add the on-chip regulators first for bootstrapping */
+	ret = mfd_add_devices(wm8994->dev, -1,
+			      wm8994_regulator_devs,
+			      ARRAY_SIZE(wm8994_regulator_devs),
+			      NULL, 0);
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
+		goto err;
+	}
+
+	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
+				   ARRAY_SIZE(wm8994_main_supplies),
+				   GFP_KERNEL);
+	if (!wm8994->supplies)
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
+		wm8994->supplies[i].supply = wm8994_main_supplies[i];
+
+	ret = regulator_bulk_get(wm8994->dev, ARRAY_SIZE(wm8994_main_supplies),
+				 wm8994->supplies);
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
+		goto err_get;
+	}
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(wm8994_main_supplies),
+				    wm8994->supplies);
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to enable supplies: %d\n", ret);
+		goto err_supplies;
+	}
+
+	ret = wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET);
+	if (ret < 0) {
+		dev_err(wm8994->dev, "Failed to read ID register\n");
+		goto err_enable;
+	}
+	if (ret != 0x8994) {
+		dev_err(wm8994->dev, "Device is not a WM8994, ID is %x\n",
+			ret);
+		ret = -EINVAL;
+		goto err_enable;
+	}
+
+	ret = wm8994_reg_read(wm8994, WM8994_CHIP_REVISION);
+	if (ret < 0) {
+		dev_err(wm8994->dev, "Failed to read revision register: %d\n",
+			ret);
+		goto err_enable;
+	}
+
+	switch (ret) {
+	case 0:
+	case 1:
+		dev_warn(wm8994->dev, "revision %c not fully supported\n",
+			'A' + ret);
+		break;
+	default:
+		dev_info(wm8994->dev, "revision %c\n", 'A' + ret);
+		break;
+	}
+
+
+	if (pdata) {
+		wm8994->gpio_base = pdata->gpio_base;
+
+		/* GPIO configuration is only applied if it's non-zero */
+		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
+			if (pdata->gpio_defaults[i]) {
+				wm8994_set_bits(wm8994, WM8994_GPIO_1 + i,
+						0xffff,
+						pdata->gpio_defaults[i]);
+			}
+		}
+	}
+
+	/* In some system designs where the regulators are not in use,
+	 * we can achieve a small reduction in leakage currents by
+	 * floating LDO outputs.  This bit makes no difference if the
+	 * LDOs are enabled, it only affects cases where the LDOs were
+	 * in operation and are then disabled.
+	 */
+	for (i = 0; i < WM8994_NUM_LDO_REGS; i++) {
+		if (wm8994_ldo_in_use(pdata, i))
+			wm8994_set_bits(wm8994, WM8994_LDO_1 + i,
+					WM8994_LDO1_DISCH, WM8994_LDO1_DISCH);
+		else
+			wm8994_set_bits(wm8994, WM8994_LDO_1 + i,
+					WM8994_LDO1_DISCH, 0);
+	}
+
+	ret = mfd_add_devices(wm8994->dev, -1,
+			      wm8994_devs, ARRAY_SIZE(wm8994_devs),
+			      NULL, 0);
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
+		goto err_enable;
+	}
+
+	return 0;
+
+err_enable:
+	regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
+			       wm8994->supplies);
+err_get:
+	regulator_bulk_free(ARRAY_SIZE(wm8994_main_supplies), wm8994->supplies);
+err_supplies:
+	kfree(wm8994->supplies);
+err:
+	mfd_remove_devices(wm8994->dev);
+	kfree(wm8994);
+	return ret;
+}
+
+static void wm8994_device_exit(struct wm8994 *wm8994)
+{
+	mfd_remove_devices(wm8994->dev);
+	regulator_bulk_disable(ARRAY_SIZE(wm8994_main_supplies),
+			       wm8994->supplies);
+	regulator_bulk_free(ARRAY_SIZE(wm8994_main_supplies), wm8994->supplies);
+	kfree(wm8994->supplies);
+	kfree(wm8994);
+}
+
+static int wm8994_i2c_read_device(struct wm8994 *wm8994, unsigned short reg,
+				  int bytes, void *dest)
+{
+	struct i2c_client *i2c = wm8994->control_data;
+	int ret;
+	u16 r = cpu_to_be16(reg);
+
+	ret = i2c_master_send(i2c, (unsigned char *)&r, 2);
+	if (ret < 0)
+		return ret;
+	if (ret != 2)
+		return -EIO;
+
+	ret = i2c_master_recv(i2c, dest, bytes);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes)
+		return -EIO;
+	return 0;
+}
+
+/* Currently we allocate the write buffer on the stack; this is OK for
+ * small writes - if we need to do large writes this will need to be
+ * revised.
+ */
+static int wm8994_i2c_write_device(struct wm8994 *wm8994, unsigned short reg,
+				   int bytes, void *src)
+{
+	struct i2c_client *i2c = wm8994->control_data;
+	unsigned char msg[bytes + 2];
+	int ret;
+
+	reg = cpu_to_be16(reg);
+	memcpy(&msg[0], &reg, 2);
+	memcpy(&msg[2], src, bytes);
+
+	ret = i2c_master_send(i2c, msg, bytes + 2);
+	if (ret < 0)
+		return ret;
+	if (ret < bytes + 2)
+		return -EIO;
+
+	return 0;
+}
+
+static int wm8994_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct wm8994 *wm8994;
+
+	wm8994 = kzalloc(sizeof(struct wm8994), GFP_KERNEL);
+	if (wm8994 == NULL) {
+		kfree(i2c);
+		return -ENOMEM;
+	}
+
+	i2c_set_clientdata(i2c, wm8994);
+	wm8994->dev = &i2c->dev;
+	wm8994->control_data = i2c;
+	wm8994->read_dev = wm8994_i2c_read_device;
+	wm8994->write_dev = wm8994_i2c_write_device;
+
+	return wm8994_device_init(wm8994, id->driver_data, i2c->irq);
+}
+
+static int wm8994_i2c_remove(struct i2c_client *i2c)
+{
+	struct wm8994 *wm8994 = i2c_get_clientdata(i2c);
+
+	wm8994_device_exit(wm8994);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int wm8994_i2c_suspend(struct i2c_client *i2c, pm_message_t state)
+{
+	return wm8994_device_suspend(&i2c->dev);
+}
+
+static int wm8994_i2c_resume(struct i2c_client *i2c)
+{
+	return wm8994_device_resume(&i2c->dev);
+}
+#else
+#define wm8994_i2c_suspend NULL
+#define wm8994_i2c_resume NULL
+#endif
+
+static const struct i2c_device_id wm8994_i2c_id[] = {
+	{ "wm8994", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, wm8994_i2c_id);
+
+static struct i2c_driver wm8994_i2c_driver = {
+	.driver = {
+		   .name = "wm8994",
+		   .owner = THIS_MODULE,
+	},
+	.probe = wm8994_i2c_probe,
+	.remove = wm8994_i2c_remove,
+	.suspend = wm8994_i2c_suspend,
+	.resume = wm8994_i2c_resume,
+	.id_table = wm8994_i2c_id,
+};
+
+static int __init wm8994_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&wm8994_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register wm8994 I2C driver: %d\n", ret);
+
+	return ret;
+}
+module_init(wm8994_i2c_init);
+
+static void __exit wm8994_i2c_exit(void)
+{
+	i2c_del_driver(&wm8994_i2c_driver);
+}
+module_exit(wm8994_i2c_exit);
+
+MODULE_DESCRIPTION("Core support for the WM8994 audio CODEC");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
new file mode 100644
index 0000000..b06ff28
--- /dev/null
+++ b/include/linux/mfd/wm8994/core.h
@@ -0,0 +1,54 @@
+/*
+ * include/linux/mfd/wm8994/core.h -- Core interface for WM8994
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM8994_CORE_H__
+#define __MFD_WM8994_CORE_H__
+
+struct regulator_dev;
+struct regulator_bulk_data;
+
+#define WM8994_NUM_GPIO_REGS 11
+#define WM8994_NUM_LDO_REGS 2
+
+struct wm8994 {
+	struct mutex io_lock;
+
+	struct device *dev;
+	int (*read_dev)(struct wm8994 *wm8994, unsigned short reg,
+			int bytes, void *dest);
+	int (*write_dev)(struct wm8994 *wm8994, unsigned short reg,
+			 int bytes, void *src);
+
+	void *control_data;
+
+	int gpio_base;
+
+	/* Used over suspend/resume */
+	u16 ldo_regs[WM8994_NUM_LDO_REGS];
+	u16 gpio_regs[WM8994_NUM_GPIO_REGS];
+
+	struct regulator_dev *dbvdd;
+	struct regulator_bulk_data *supplies;
+};
+
+/* Device I/O API */
+int wm8994_reg_read(struct wm8994 *wm8994, unsigned short reg);
+int wm8994_reg_write(struct wm8994 *wm8994, unsigned short reg,
+		 unsigned short val);
+int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
+		    unsigned short mask, unsigned short val);
+int wm8994_bulk_read(struct wm8994 *wm8994, unsigned short reg,
+		     int count, u16 *buf);
+
+#endif
diff --git a/include/linux/mfd/wm8994/gpio.h b/include/linux/mfd/wm8994/gpio.h
new file mode 100644
index 0000000..b4d4c22
--- /dev/null
+++ b/include/linux/mfd/wm8994/gpio.h
@@ -0,0 +1,72 @@
+/*
+ * include/linux/mfd/wm8994/gpio.h - GPIO configuration for WM8994
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM8994_GPIO_H__
+#define __MFD_WM8994_GPIO_H__
+
+#define WM8994_GPIO_MAX 11
+
+#define WM8994_GP_FN_PIN_SPECIFIC    0
+#define WM8994_GP_FN_GPIO            1
+#define WM8994_GP_FN_SDOUT           2
+#define WM8994_GP_FN_IRQ             3
+#define WM8994_GP_FN_TEMPERATURE     4
+#define WM8994_GP_FN_MICBIAS1_DET    5
+#define WM8994_GP_FN_MICBIAS1_SHORT  6
+#define WM8994_GP_FN_MICBIAS2_DET    7
+#define WM8994_GP_FN_MICBIAS2_SHORT  8
+#define WM8994_GP_FN_FLL1_LOCK       9
+#define WM8994_GP_FN_FLL2_LOCK      10
+#define WM8994_GP_FN_SRC1_LOCK      11
+#define WM8994_GP_FN_SRC2_LOCK      12
+#define WM8994_GP_FN_DRC1_ACT       13
+#define WM8994_GP_FN_DRC2_ACT       14
+#define WM8994_GP_FN_DRC3_ACT       15
+#define WM8994_GP_FN_WSEQ_STATUS    16
+#define WM8994_GP_FN_FIFO_ERROR     17
+#define WM8994_GP_FN_OPCLK          18
+
+#define WM8994_GPN_DIR                          0x8000  /* GPN_DIR */
+#define WM8994_GPN_DIR_MASK                     0x8000  /* GPN_DIR */
+#define WM8994_GPN_DIR_SHIFT                        15  /* GPN_DIR */
+#define WM8994_GPN_DIR_WIDTH                         1  /* GPN_DIR */
+#define WM8994_GPN_PU                           0x4000  /* GPN_PU */
+#define WM8994_GPN_PU_MASK                      0x4000  /* GPN_PU */
+#define WM8994_GPN_PU_SHIFT                         14  /* GPN_PU */
+#define WM8994_GPN_PU_WIDTH                          1  /* GPN_PU */
+#define WM8994_GPN_PD                           0x2000  /* GPN_PD */
+#define WM8994_GPN_PD_MASK                      0x2000  /* GPN_PD */
+#define WM8994_GPN_PD_SHIFT                         13  /* GPN_PD */
+#define WM8994_GPN_PD_WIDTH                          1  /* GPN_PD */
+#define WM8994_GPN_POL                          0x0400  /* GPN_POL */
+#define WM8994_GPN_POL_MASK                     0x0400  /* GPN_POL */
+#define WM8994_GPN_POL_SHIFT                        10  /* GPN_POL */
+#define WM8994_GPN_POL_WIDTH                         1  /* GPN_POL */
+#define WM8994_GPN_OP_CFG                       0x0200  /* GPN_OP_CFG */
+#define WM8994_GPN_OP_CFG_MASK                  0x0200  /* GPN_OP_CFG */
+#define WM8994_GPN_OP_CFG_SHIFT                      9  /* GPN_OP_CFG */
+#define WM8994_GPN_OP_CFG_WIDTH                      1  /* GPN_OP_CFG */
+#define WM8994_GPN_DB                           0x0100  /* GPN_DB */
+#define WM8994_GPN_DB_MASK                      0x0100  /* GPN_DB */
+#define WM8994_GPN_DB_SHIFT                          8  /* GPN_DB */
+#define WM8994_GPN_DB_WIDTH                          1  /* GPN_DB */
+#define WM8994_GPN_LVL                          0x0040  /* GPN_LVL */
+#define WM8994_GPN_LVL_MASK                     0x0040  /* GPN_LVL */
+#define WM8994_GPN_LVL_SHIFT                         6  /* GPN_LVL */
+#define WM8994_GPN_LVL_WIDTH                         1  /* GPN_LVL */
+#define WM8994_GPN_FN_MASK                      0x001F  /* GPN_FN - [4:0] */
+#define WM8994_GPN_FN_SHIFT                          0  /* GPN_FN - [4:0] */
+#define WM8994_GPN_FN_WIDTH                          5  /* GPN_FN - [4:0] */
+
+#endif
diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
new file mode 100644
index 0000000..70d6a86
--- /dev/null
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -0,0 +1,97 @@
+/*
+ * include/linux/mfd/wm8994/pdata.h -- Platform data for WM8994
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM8994_PDATA_H__
+#define __MFD_WM8994_PDATA_H__
+
+#define WM8994_NUM_LDO   2
+#define WM8994_NUM_GPIO 11
+
+struct wm8994_ldo_pdata {
+	/** GPIOs to enable regulator, 0 or less if not available */
+	int enable;
+
+	const char *supply;
+	struct regulator_init_data *init_data;
+};
+
+#define WM8994_CONFIGURE_GPIO 0x8000
+
+#define WM8994_DRC_REGS 5
+#define WM8994_EQ_REGS  19
+
+/**
+ * DRC configurations are specified with a label and a set of register
+ * values to write (the enable bits will be ignored).  At runtime an
+ * enumerated control will be presented for each DRC block allowing
+ * the user to choose the configration to use.
+ *
+ * Configurations may be generated by hand or by using the DRC control
+ * panel provided by the WISCE - see  http://www.wolfsonmicro.com/wisce/
+ * for details.
+ */
+struct wm8994_drc_cfg {
+        const char *name;
+        u16 regs[WM8994_DRC_REGS];
+};
+
+/**
+ * ReTune Mobile configurations are specified with a label, sample
+ * rate and set of values to write (the enable bits will be ignored).
+ *
+ * Configurations are expected to be generated using the ReTune Mobile
+ * control panel in WISCE - see http://www.wolfsonmicro.com/wisce/
+ */
+struct wm8994_retune_mobile_cfg {
+        const char *name;
+        unsigned int rate;
+        u16 regs[WM8994_EQ_REGS];
+};
+
+struct wm8994_pdata {
+	int gpio_base;
+
+	/**
+	 * Default values for GPIOs if non-zero, WM8994_CONFIGURE_GPIO
+	 * can be used for all zero values.
+	 */
+	int gpio_defaults[WM8994_NUM_GPIO];
+
+	struct wm8994_ldo_pdata ldo[WM8994_NUM_LDO];
+
+
+        int num_drc_cfgs;
+        struct wm8994_drc_cfg *drc_cfgs;
+
+        int num_retune_mobile_cfgs;
+        struct wm8994_retune_mobile_cfg *retune_mobile_cfgs;
+
+        /* LINEOUT can be differential or single ended */
+        unsigned int lineout1_diff:1;
+        unsigned int lineout2_diff:1;
+
+        /* Common mode feedback */
+        unsigned int lineout1fb:1;
+        unsigned int lineout2fb:1;
+
+        /* Microphone biases: 0=0.9*AVDD1 1=0.65*AVVD1 */
+        unsigned int micbias1_lvl:1;
+        unsigned int micbias2_lvl:1;
+
+        /* Jack detect threashold levels, see datasheet for values */
+        unsigned int jd_scthr:2;
+        unsigned int jd_thr:2;
+};
+
+#endif
-- 
1.6.6

