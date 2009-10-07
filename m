Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbZJGGaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbZJGGaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZJGG37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:29:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41923 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbZJGG35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:29:57 -0400
Date: Wed, 07 Oct 2009 15:18:30 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 6/6] haptic: ISA1200 haptic device support
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091007061830.GA7606@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 07 Oct 2009 06:18:36.0942 (UTC)
 FILETIME=[0141C2E0:01CA4716]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C based ISA1200 haptic driver support.
This chip supports both internal and external.
But only external configuration are implemented.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/haptic/Kconfig      |    6 +
 drivers/haptic/Makefile     |    1 +
 drivers/haptic/isa1200.c    |  429 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/isa1200.h |  103 +++++++++++
 4 files changed, 539 insertions(+), 0 deletions(-)
 create mode 100644 drivers/haptic/isa1200.c
 create mode 100644 include/linux/i2c/isa1200.h

diff --git a/drivers/haptic/Kconfig b/drivers/haptic/Kconfig
index 1e9849c..30ae507 100644
--- a/drivers/haptic/Kconfig
+++ b/drivers/haptic/Kconfig
@@ -20,4 +20,10 @@ config HAPTIC_SAMSUNG_PWM
 	  This options enables support for haptic connected to GPIO lines
 	  controlled by a PWM timer on SAMSUNG CPUs.
 
+config HAPTIC_ISA1200
+	tristate "ISA1200 haptic support"
+	depends on HAPTIC_CLASS && I2C
+	help
+	  The ISA1200 is a high performance enhanced haptic driver.
+
 endif	# HAPTIC
diff --git a/drivers/haptic/Makefile b/drivers/haptic/Makefile
index c691f7d..3eca352 100644
--- a/drivers/haptic/Makefile
+++ b/drivers/haptic/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_HAPTIC_CLASS)		+= haptic-class.o
 
 # Drivers
 obj-$(CONFIG_HAPTIC_SAMSUNG_PWM)	+= haptic-samsung-pwm.o
+obj-$(CONFIG_HAPTIC_ISA1200)		+= isa1200.o
diff --git a/drivers/haptic/isa1200.c b/drivers/haptic/isa1200.c
new file mode 100644
index 0000000..51c4ea4
--- /dev/null
+++ b/drivers/haptic/isa1200.c
@@ -0,0 +1,429 @@
+/*
+ *  isa1200.c - Haptic Motor
+ *
+ *  Copyright (C) 2009 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/haptic.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/pwm.h>
+#include <linux/ctype.h>
+#include <linux/workqueue.h>
+#include <linux/i2c/isa1200.h>
+#include "haptic.h"
+
+struct isa1200_chip {
+	struct i2c_client *client;
+	struct pwm_device *pwm;
+	struct haptic_classdev cdev;
+	struct work_struct work;
+	struct timer_list timer;
+
+	unsigned int	len;		/* LDO enable */
+	unsigned int	hen;		/* Haptic enable */
+
+	int enable;
+	int powered;
+
+	int level;
+	int level_max;
+
+	int ldo_level;
+};
+
+static inline struct isa1200_chip *cdev_to_isa1200_chip(
+		struct haptic_classdev *haptic_cdev)
+{
+	return container_of(haptic_cdev, struct isa1200_chip, cdev);
+}
+
+static int isa1200_chip_set_pwm_cycle(struct isa1200_chip *haptic)
+{
+	int duty = PWM_HAPTIC_PERIOD * haptic->level / 100;
+	return pwm_config(haptic->pwm, duty, PWM_HAPTIC_PERIOD);
+}
+
+static int isa1200_read_reg(struct i2c_client *client, int reg)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static int isa1200_write_reg(struct i2c_client *client, int reg, u8 value)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, value);
+	if (ret < 0)
+		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
+
+	return ret;
+}
+
+static void isa1200_chip_power_on(struct isa1200_chip *haptic)
+{
+	if (haptic->powered)
+		return;
+	haptic->powered = 1;
+	/* Use smart mode enable control */
+	pwm_enable(haptic->pwm);
+}
+
+static void isa1200_chip_power_off(struct isa1200_chip *haptic)
+{
+	if (!haptic->powered)
+		return;
+	haptic->powered = 0;
+	/* Use smart mode enable control */
+	pwm_disable(haptic->pwm);
+}
+
+static void isa1200_chip_work(struct work_struct *work)
+{
+	struct isa1200_chip *haptic;
+	int r;
+
+	haptic = container_of(work, struct isa1200_chip, work);
+	if (haptic->enable) {
+		r = isa1200_chip_set_pwm_cycle(haptic);
+		if (r) {
+			dev_dbg(haptic->cdev.dev, "set_pwm_cycle failed\n");
+			return;
+		}
+		isa1200_chip_power_on(haptic);
+	} else {
+		isa1200_chip_power_off(haptic);
+	}
+}
+
+static void isa1200_chip_timer(unsigned long data)
+{
+	struct isa1200_chip *haptic = (struct isa1200_chip *)data;
+
+	haptic->enable = 0;
+	isa1200_chip_power_off(haptic);
+}
+
+static void isa1200_chip_set(struct haptic_classdev *haptic_cdev,
+				enum haptic_value value)
+{
+	struct isa1200_chip *haptic =
+		cdev_to_isa1200_chip(haptic_cdev);
+
+	switch (value) {
+	case HAPTIC_OFF:
+		haptic->enable = 0;
+		break;
+	case HAPTIC_HALF:
+	case HAPTIC_FULL:
+	default:
+		haptic->enable = 1;
+		break;
+	}
+
+	schedule_work(&haptic->work);
+}
+
+static enum haptic_value isa1200_chip_get(struct haptic_classdev *haptic_cdev)
+{
+	struct isa1200_chip *haptic =
+		cdev_to_isa1200_chip(haptic_cdev);
+
+	if (haptic->enable)
+		return HAPTIC_FULL;
+
+	return HAPTIC_OFF;
+}
+
+#define ATTR_DEF_SHOW(name) \
+static ssize_t isa1200_chip_show_##name(struct device *dev, \
+		struct device_attribute *attr, char *buf) \
+{ \
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev); \
+	struct isa1200_chip *haptic = cdev_to_isa1200_chip(haptic_cdev); \
+ \
+	return sprintf(buf, "%u\n", haptic->name) + 1; \
+}
+
+#define ATTR_DEF_STORE(name) \
+static ssize_t isa1200_chip_store_##name(struct device *dev, \
+		struct device_attribute *attr, \
+		const char *buf, size_t size) \
+{ \
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev); \
+	struct isa1200_chip *haptic = cdev_to_isa1200_chip(haptic_cdev); \
+	ssize_t ret = -EINVAL; \
+	unsigned long val; \
+ \
+	ret = strict_strtoul(buf, 10, &val); \
+	if (ret == 0) { \
+		ret = size; \
+		haptic->name = val; \
+		schedule_work(&haptic->work); \
+	} \
+ \
+	return ret; \
+}
+
+ATTR_DEF_SHOW(enable);
+ATTR_DEF_STORE(enable);
+static DEVICE_ATTR(enable, 0644, isa1200_chip_show_enable,
+		isa1200_chip_store_enable);
+
+static ssize_t isa1200_chip_store_level(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t size)
+{
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
+	struct isa1200_chip *haptic = cdev_to_isa1200_chip(haptic_cdev);
+	ssize_t ret = -EINVAL;
+	unsigned long val;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret == 0) {
+		ret = size;
+		if (haptic->level_max < val)
+			val = haptic->level_max;
+		haptic->level = val;
+		schedule_work(&haptic->work);
+	}
+
+	return ret;
+}
+ATTR_DEF_SHOW(level);
+static DEVICE_ATTR(level, 0644, isa1200_chip_show_level,
+		isa1200_chip_store_level);
+
+ATTR_DEF_SHOW(level_max);
+static DEVICE_ATTR(level_max, 0444, isa1200_chip_show_level_max, NULL);
+
+static ssize_t isa1200_chip_store_oneshot(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t size)
+{
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
+	struct isa1200_chip *haptic = cdev_to_isa1200_chip(haptic_cdev);
+	ssize_t ret = -EINVAL;
+	unsigned long val;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret == 0) {
+		ret = size;
+		haptic->enable = 1;
+		mod_timer(&haptic->timer, jiffies + val * HZ / 1000);
+		schedule_work(&haptic->work);
+	}
+
+	return ret;
+}
+static DEVICE_ATTR(oneshot, 0200, NULL, isa1200_chip_store_oneshot);
+
+static struct attribute *haptic_attributes[] = {
+	&dev_attr_enable.attr,
+	&dev_attr_level.attr,
+	&dev_attr_level_max.attr,
+	&dev_attr_oneshot.attr,
+	NULL,
+};
+
+static const struct attribute_group haptic_group = {
+	.attrs = haptic_attributes,
+};
+
+static void isa1200_setup(struct i2c_client *client)
+{
+	struct isa1200_chip *chip = i2c_get_clientdata(client);
+	int value;
+
+	gpio_set_value(chip->len, 1);
+	udelay(250);
+	gpio_set_value(chip->len, 1);
+
+	value = isa1200_read_reg(client, ISA1200_SCTRL0);
+	value &= ~ISA1200_LDOADJ_MASK;
+	value |= chip->ldo_level;
+	isa1200_write_reg(client, ISA1200_SCTRL0, value);
+
+	value = ISA1200_HAPDREN | ISA1200_OVERHL | ISA1200_HAPDIGMOD_PWM_IN |
+		ISA1200_PWMMOD_DIVIDER_128;
+	isa1200_write_reg(client, ISA1200_HCTRL0, value);
+
+	value = ISA1200_EXTCLKSEL | ISA1200_BIT6_ON | ISA1200_MOTTYP_LRA |
+		ISA1200_SMARTEN | ISA1200_SMARTOFFT_64;
+	isa1200_write_reg(client, ISA1200_HCTRL1, value);
+
+	value = isa1200_read_reg(client, ISA1200_HCTRL2);
+	value |= ISA1200_SEEN;
+	isa1200_write_reg(client, ISA1200_HCTRL2, value);
+	isa1200_chip_power_off(chip);
+	isa1200_chip_power_on(chip);
+
+	/* TODO */
+}
+
+static int __devinit isa1200_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct isa1200_chip *chip;
+	struct haptic_platform_data *pdata;
+	int ret;
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev, "%s: no platform data\n", __func__);
+		return -EINVAL;
+	}
+
+	chip = kzalloc(sizeof(struct isa1200_chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	chip->client = client;
+	chip->cdev.set = isa1200_chip_set;
+	chip->cdev.get = isa1200_chip_get;
+	chip->cdev.show_enable = isa1200_chip_show_enable;
+	chip->cdev.store_enable = isa1200_chip_store_enable;
+	chip->cdev.store_oneshot = isa1200_chip_store_oneshot;
+	chip->cdev.show_level = isa1200_chip_show_level;
+	chip->cdev.store_level = isa1200_chip_store_level;
+	chip->cdev.show_level_max = isa1200_chip_show_level_max;
+	chip->cdev.name = pdata->name;
+	chip->enable = 0;
+	chip->level = PWM_HAPTIC_DEFAULT_LEVEL;
+	chip->level_max = PWM_HAPTIC_DEFAULT_LEVEL;
+	chip->ldo_level = pdata->ldo_level;
+
+	if (pdata->setup_pin)
+		pdata->setup_pin();
+	chip->len = pdata->gpio;
+	chip->hen = pdata->gpio;
+	chip->pwm = pwm_request(pdata->pwm_timer, "haptic");
+	if (IS_ERR(chip->pwm)) {
+		dev_err(&client->dev, "unable to request PWM for haptic.\n");
+		ret = PTR_ERR(chip->pwm);
+		goto error_pwm;
+	}
+
+	INIT_WORK(&chip->work, isa1200_chip_work);
+
+	/* register our new haptic device */
+	ret = haptic_classdev_register(&client->dev, &chip->cdev);
+	if (ret < 0) {
+		dev_err(&client->dev, "haptic_classdev_register failed\n");
+		goto error_classdev;
+	}
+
+	ret = sysfs_create_group(&chip->cdev.dev->kobj, &haptic_group);
+	if (ret)
+		goto error_enable;
+
+	init_timer(&chip->timer);
+	chip->timer.data = (unsigned long)chip;
+	chip->timer.function = &isa1200_chip_timer;
+
+	i2c_set_clientdata(client, chip);
+
+	if (gpio_is_valid(pdata->gpio)) {
+		ret = gpio_request(pdata->gpio, "haptic enable");
+		if (ret)
+			goto error_gpio;
+		gpio_direction_output(pdata->gpio, 1);
+	}
+
+	isa1200_setup(client);
+
+	printk(KERN_INFO "isa1200 %s registered\n", pdata->name);
+	return 0;
+
+error_gpio:
+	gpio_free(pdata->gpio);
+error_enable:
+	sysfs_remove_group(&chip->cdev.dev->kobj, &haptic_group);
+error_classdev:
+	haptic_classdev_unregister(&chip->cdev);
+error_pwm:
+	pwm_free(chip->pwm);
+	kfree(chip);
+	return ret;
+}
+
+static int __devexit isa1200_remove(struct i2c_client *client)
+{
+	struct isa1200_chip *chip = i2c_get_clientdata(client);
+
+	if (gpio_is_valid(chip->len))
+		gpio_free(chip->len);
+
+	sysfs_remove_group(&chip->cdev.dev->kobj, &haptic_group);
+	haptic_classdev_unregister(&chip->cdev);
+	pwm_free(chip->pwm);
+	kfree(chip);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int isa1200_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct isa1200_chip *chip = i2c_get_clientdata(client);
+	isa1200_chip_power_off(chip);
+	return 0;
+}
+
+static int isa1200_resume(struct i2c_client *client)
+{
+	isa1200_setup(client);
+	return 0;
+}
+#else
+#define isa1200_suspend		NULL
+#define isa1200_resume		NULL
+#endif
+
+static const struct i2c_device_id isa1200_id[] = {
+	{ "isa1200", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, isa1200_id);
+
+static struct i2c_driver isa1200_driver = {
+	.driver	= {
+		.name	= "isa1200",
+	},
+	.probe		= isa1200_probe,
+	.remove		= __devexit_p(isa1200_remove),
+	.suspend	= isa1200_suspend,
+	.resume		= isa1200_resume,
+	.id_table	= isa1200_id,
+};
+
+static int __init isa1200_init(void)
+{
+	return i2c_add_driver(&isa1200_driver);
+}
+
+static void __exit isa1200_exit(void)
+{
+	i2c_del_driver(&isa1200_driver);
+}
+
+module_init(isa1200_init);
+module_exit(isa1200_exit);
+
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_DESCRIPTION("ISA1200 Haptic Motor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/i2c/isa1200.h b/include/linux/i2c/isa1200.h
new file mode 100644
index 0000000..3dee1a2
--- /dev/null
+++ b/include/linux/i2c/isa1200.h
@@ -0,0 +1,103 @@
+/*
+ *  isa1200.h - ISA1200 Haptic Motor driver
+ *
+ *  Copyright (C) 2009 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_ISA1200_H
+#define __LINUX_ISA1200_H
+
+#define ISA1200_SCTRL0		0x00
+#define ISA1200_THSWRST		(1 << 7)
+#define ISA1200_EXT2DIV		(1 << 4)
+#define ISA1200_LDOADJ_24V	(0x9 << 0)
+#define ISA1200_LDOADJ_25V	(0xa << 0)
+#define ISA1200_LDOADJ_26V	(0xb << 0)
+#define ISA1200_LDOADJ_27V	(0xc << 0)
+#define ISA1200_LDOADJ_28V	(0xd << 0)
+#define ISA1200_LDOADJ_29V	(0xe << 0)
+#define ISA1200_LDOADJ_30V	(0xf << 0)
+#define ISA1200_LDOADJ_31V	(0x0 << 0)
+#define ISA1200_LDOADJ_32V	(0x1 << 0)
+#define ISA1200_LDOADJ_33V	(0x2 << 0)
+#define ISA1200_LDOADJ_34V	(0x3 << 0)
+#define ISA1200_LDOADJ_35V	(0x4 << 0)
+#define ISA1200_LDOADJ_36V	(0x5 << 0)
+#define ISA1200_LDOADJ_MASK	(0xf << 0)
+#define ISA1200_HCTRL0		0x30
+#define ISA1200_HAPDREN		(1 << 7)
+#define ISA1200_OVEREN		(1 << 6)
+#define ISA1200_OVERHL		(1 << 5)
+#define ISA1200_HAPDIGMOD_PWM_IN	(1 << 3)
+#define ISA1200_HAPDIGMOD_PWM_GEN	(2 << 3)
+#define ISA1200_PLLMOD		(1 << 2)
+#define ISA1200_PWMMOD_DIVIDER_128	(0 << 0)
+#define ISA1200_PWMMOD_DIVIDER_256	(1 << 0)
+#define ISA1200_PWMMOD_DIVIDER_512	(2 << 0)
+#define ISA1200_PWMMOD_DIVIDER_1024	(3 << 0)
+#define ISA1200_HCTRL1		0x31
+#define ISA1200_EXTCLKSEL	(1 << 7)
+#define ISA1200_BIT6_ON		(1 << 6)
+#define ISA1200_MOTTYP_ERM	(1 << 5)
+#define ISA1200_MOTTYP_LRA	(0 << 5)
+#define ISA1200_PLLEN		(1 << 4)
+#define ISA1200_SMARTEN		(1 << 3)
+#define ISA1200_SMARTONT	(1 << 2)
+#define ISA1200_SMARTOFFT_16	(0 << 0)
+#define ISA1200_SMARTOFFT_32	(1 << 0)
+#define ISA1200_SMARTOFFT_64	(2 << 0)
+#define ISA1200_SMARTOFFT_100	(3 << 0)
+#define ISA1200_HCTRL2		0x32
+#define ISA1200_HSWRST		(1 << 7)
+#define ISA1200_SESTMOD		(1 << 2)
+#define ISA1200_SEEN		(1 << 1)
+#define ISA1200_SEEVENT		(1 << 0)
+#define ISA1200_HCTRL3		0x33
+#define ISA1200_PPLLDIV_MASK	(0xf0)
+#define ISA1200_PPLLDIV_SHIFT	(4)
+#define ISA1200_PPLLDIV_1	(0x0)
+#define ISA1200_PPLLDIV_2	(0x1)
+#define ISA1200_PPLLDIV_4	(0x2)
+#define ISA1200_PPLLDIV_8	(0x3)
+#define ISA1200_PPLLDIV_16	(0x4)
+#define ISA1200_PPLLDIV_32	(0x5)
+#define ISA1200_PPLLDIV_64	(0x6)
+#define ISA1200_PPLLDIV_128	(0x7)
+#define ISA1200_WPLLDIV_MASK	(0x0f)
+#define ISA1200_WPLLDIV_SHIFT	(0)
+#define ISA1200_WPLLDIV_1	(0x0)
+#define ISA1200_WPPLLDIV_2	(0x1)
+#define ISA1200_WPPLLDIV_4	(0x2)
+#define ISA1200_WPPLLDIV_8	(0x3)
+#define ISA1200_WPPLLDIV_16	(0x4)
+#define ISA1200_WPPLLDIV_32	(0x5)
+#define ISA1200_WPPLLDIV_64	(0x6)
+#define ISA1200_WPPLLDIV_128	(0x7)
+#define ISA1200_HCTRL4		0x34
+#define ISA1200_HCTRL5		0x35
+#define ISA1200_HCTRL6		0x36
+#define ISA1200_HCTRL7		0x37
+#define ISA1200_HCTRL8		0x38
+#define ISA1200_HCTRL9		0x39
+#define ISA1200_PLLP_SHIFT	(4)
+#define ISA1200_PLLP_MASK	(0xf0)
+#define ISA1200_PLLS_SHIFT	(0)
+#define ISA1200_PLLS_MASK	(0x0f)
+#define ISA1200_HCTRLA		0x3A
+#define ISA1200_PLLMM_MASK	(0xfc)
+#define ISA1200_PLLMM_SHIFT	(2)
+#define ISA1200_PLLMS_MASK	(0x03)
+#define ISA1200_PLLMS_SHIFT	(0)
+#define ISA1200_HCTRLB		0x3B
+#define ISA1200_HCTRLC		0x3C
+#define ISA1200_HCTRLD		0x3D
+
+#define PWM_HAPTIC_PERIOD	44640
+#define PWM_HAPTIC_DEFAULT_LEVEL	99
+
+#endif /* __LINUX_ISA1200_H */
-- 
1.5.3.3

