Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZJFH5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZJFH5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZJFH5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:57:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51322 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbZJFH5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:57:22 -0400
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 03:57:21 EDT
Date: Tue, 06 Oct 2009 16:45:33 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] Haptic class support (v2)
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091006074533.GA28889@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 06 Oct 2009 07:45:39.0978 (UTC)
 FILETIME=[00040EA0:01CA4659]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes two haptic devices, isa1000 and isa1200
ISA1000 is gpio based haptic, but isa1200 is based on I2C
Both are working on Samsung SoCs and tested.

To enable the haptic, echo 1 > /sys/class/haptic/${name}/enable
You can adjust the level by echo ${level} > /sys/class/haptic/${name}/enable
or
With oneshot feature, echo ${msec time} > /sys/class/haptic/${name}/oneshot

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/Kconfig                     |    2
 drivers/Makefile                    |    1
 drivers/haptic/Kconfig              |   31 ++
 drivers/haptic/Makefile             |    8
 drivers/haptic/haptic-class.c       |  256 ++++++++++++++++++++++
 drivers/haptic/haptic-samsung-pwm.c |  377 ++++++++++++++++++++++++++++++++
 drivers/haptic/haptic.h             |   35 +++
 drivers/haptic/isa1200.c            |  413 ++++++++++++++++++++++++++++++++++++
 include/linux/haptic.h              |   85 +++++++
 9 files changed, 1208 insertions(+)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..d44a601 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -62,6 +62,8 @@ source "drivers/power/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/haptic/Kconfig"
+
 source "drivers/thermal/Kconfig"
 
 source "drivers/watchdog/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 6ee53c7..16b8f67 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_PPS)		+= pps/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
+obj-$(CONFIG_HAPTIC)		+= haptic/
 obj-$(CONFIG_THERMAL)		+= thermal/
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
diff --git a/drivers/haptic/Kconfig b/drivers/haptic/Kconfig
new file mode 100644
index 0000000..9acb02a
--- /dev/null
+++ b/drivers/haptic/Kconfig
@@ -0,0 +1,31 @@
+menuconfig HAPTIC
+	bool "HAPTIC support"
+	help
+	  Say Y to enalbe haptic support. It enables the haptic and controlled
+	  from both userspace and kernel
+
+if HAPTIC
+
+config HAPTIC_CLASS
+	tristate "Haptic Class Support"
+	help
+	  This option enables the haptic sysfs class in /sys/class/haptic.
+
+comment "Haptic drivers"
+
+config HAPTIC_SAMSUNG_PWM
+	tristate "Haptic Support for SAMSUNG PWM-controlled motor (ISA1000)"
+	depends on HAPTIC_CLASS && (ARCH_S3C64XX || ARCH_S5PC1XX)
+	help
+	  This options enables support for haptic connected to GPIO lines
+	  controlled by a PWM timer on SAMSUNG CPUs.
+
+comment "Haptic chips"
+
+config HAPTIC_ISA1200
+	tristate "Haptic Motor"
+	depends on HAPTIC_CLASS && I2C
+	help
+	  The ISA1200 is a high performance enhanced haptic motor driver
+
+endif	# HAPTIC
diff --git a/drivers/haptic/Makefile b/drivers/haptic/Makefile
new file mode 100644
index 0000000..be20d4f
--- /dev/null
+++ b/drivers/haptic/Makefile
@@ -0,0 +1,8 @@
+# Haptic Core
+obj-$(CONFIG_HAPTIC_CLASS)		+= haptic-class.o
+
+# Drivers
+obj-$(CONFIG_HAPTIC_SAMSUNG_PWM)	+= haptic-samsung-pwm.o
+
+# Chips
+obj-$(CONFIG_HAPTIC_ISA1200)		+= isa1200.o
diff --git a/drivers/haptic/haptic-class.c b/drivers/haptic/haptic-class.c
new file mode 100644
index 0000000..b93e8e0
--- /dev/null
+++ b/drivers/haptic/haptic-class.c
@@ -0,0 +1,256 @@
+/*
+ *  Haptic Class Core
+ *
+ *  Copyright (C) 2008 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/rwsem.h>
+#include <linux/sysdev.h>
+#include <linux/timer.h>
+#include <linux/err.h>
+#include <linux/ctype.h>
+#include <linux/haptic.h>
+#include "haptic.h"
+
+static DECLARE_RWSEM(haptic_list_lock);
+static LIST_HEAD(haptic_list);
+static struct class *haptic_class;
+static struct class_dev_iter *iter;
+
+static void haptic_update_value(struct haptic_classdev *haptic_cdev)
+{
+	if (haptic_cdev->get)
+		haptic_cdev->value = haptic_cdev->get(haptic_cdev);
+}
+
+#define ATTR_DEF_SHOW(name) \
+static ssize_t haptic_show_##name(struct class *class, \
+		char *buf) \
+{ \
+	struct device *dev; \
+	struct haptic_classdev *haptic_cdev; \
+	ssize_t ret = -EINVAL; \
+  \
+	class_dev_iter_init(iter, haptic_class, NULL, NULL); \
+	while ((dev = class_dev_iter_next(iter))) { \
+		haptic_cdev = dev_get_drvdata(dev); \
+		if (haptic_cdev->show_##name) \
+			ret = haptic_cdev->show_##name(dev, NULL, buf); \
+	} \
+  \
+	return ret; \
+}
+
+#define ATTR_DEF_STORE(name) \
+static ssize_t haptic_store_##name(struct class *class, \
+		const char *buf, size_t count) \
+{ \
+	struct device *dev; \
+	struct haptic_classdev *haptic_cdev; \
+	ssize_t ret = -EINVAL; \
+  \
+	class_dev_iter_init(iter, haptic_class, NULL, NULL); \
+	while ((dev = class_dev_iter_next(iter))) { \
+		haptic_cdev = dev_get_drvdata(dev); \
+		if (haptic_cdev->store_##name) \
+			ret = haptic_cdev->store_##name( \
+					dev, NULL, buf, count); \
+	} \
+  \
+	return ret; \
+}
+
+ATTR_DEF_SHOW(enable);
+ATTR_DEF_STORE(enable);
+static CLASS_ATTR(enable, 0644, haptic_show_enable, haptic_store_enable);
+
+ATTR_DEF_STORE(oneshot);
+static CLASS_ATTR(oneshot, 0200, NULL, haptic_store_oneshot);
+
+ATTR_DEF_SHOW(level);
+ATTR_DEF_STORE(level);
+static CLASS_ATTR(level, 0644, haptic_show_level, haptic_store_level);
+
+ATTR_DEF_SHOW(level_max);
+static CLASS_ATTR(level_max, 0444, haptic_show_level_max, NULL);
+
+static ssize_t haptic_show_value(struct class *class,
+		char *buf)
+{
+	struct device *dev;
+	struct haptic_classdev *haptic_cdev;
+	ssize_t ret = 0;
+
+	class_dev_iter_init(iter, haptic_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(iter))) {
+		haptic_cdev = dev_get_drvdata(dev);
+
+		/* no lock needed for this */
+		haptic_update_value(haptic_cdev);
+		sprintf(buf, "%u\n", haptic_get_value(haptic_cdev));
+		ret = strlen(buf) + 1;
+	}
+
+	return ret;
+}
+
+static ssize_t haptic_store_value(struct class *class,
+		const char *buf, size_t count)
+{
+	struct device *dev;
+	struct haptic_classdev *haptic_cdev;
+	ssize_t ret = -EINVAL;
+	unsigned long val;
+
+	class_dev_iter_init(iter, haptic_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(iter))) {
+		haptic_cdev = dev_get_drvdata(dev);
+		ret = strict_strtoul(buf, 10, &val);
+		if (ret == 0) {
+			ret = count;
+			haptic_set_value(haptic_cdev, val);
+		}
+	}
+
+	return ret;
+}
+static CLASS_ATTR(value, 0644, haptic_show_value, haptic_store_value);
+
+/**
+ * haptic_classdev_suspend - suspend an haptic_classdev.
+ * @haptic_cdev: the haptic_classdev to suspend.
+ */
+void haptic_classdev_suspend(struct haptic_classdev *haptic_cdev)
+{
+	haptic_cdev->flags |= HAPTIC_SUSPENDED;
+	haptic_cdev->set(haptic_cdev, HAPTIC_OFF);
+}
+EXPORT_SYMBOL_GPL(haptic_classdev_suspend);
+
+/**
+ * haptic_classdev_resume - resume an haptic_classdev.
+ * @haptic_cdev: the haptic_classdev to resume.
+ */
+void haptic_classdev_resume(struct haptic_classdev *haptic_cdev)
+{
+	haptic_cdev->set(haptic_cdev, haptic_cdev->value);
+	haptic_cdev->flags &= ~HAPTIC_SUSPENDED;
+}
+EXPORT_SYMBOL_GPL(haptic_classdev_resume);
+
+/**
+ * haptic_classdev_register - register a new object of haptic_classdev class.
+ * @dev: The device to register.
+ * @haptic_cdev: the haptic_classdev structure for this device.
+ */
+int haptic_classdev_register(struct device *parent,
+				struct haptic_classdev *haptic_cdev)
+{
+	int ret;
+
+	haptic_cdev->dev = device_create(haptic_class, parent, 0,
+				haptic_cdev, "%s", haptic_cdev->name);
+	if (IS_ERR(haptic_cdev->dev))
+		return PTR_ERR(haptic_cdev->dev);
+
+	/* register the attributes */
+	ret = class_create_file(haptic_class, &class_attr_enable);
+	if (ret) {
+		printk(KERN_ERR "%s: class_create_file(enable) failed\n",
+				 __func__);
+		return ret;
+	}
+	ret = class_create_file(haptic_class, &class_attr_oneshot);
+	if (ret) {
+		printk(KERN_ERR "%s: class_create_file(oneshot) failed\n",
+				 __func__);
+		return ret;
+	}
+	ret = class_create_file(haptic_class, &class_attr_level);
+	if (ret) {
+		printk(KERN_ERR "%s: class_create_file(level) failed\n",
+				 __func__);
+		return ret;
+	}
+	ret = class_create_file(haptic_class, &class_attr_level_max);
+	if (ret) {
+		printk(KERN_ERR "%s: class_create_file(level_max) failed\n",
+				 __func__);
+		return ret;
+	}
+	ret = class_create_file(haptic_class, &class_attr_value);
+	if (ret) {
+		printk(KERN_ERR "%s: class_create_file(value) failed\n",
+				 __func__);
+		return ret;
+	}
+
+	/* add to the list of haptic */
+	down_write(&haptic_list_lock);
+	list_add_tail(&haptic_cdev->node, &haptic_list);
+	up_write(&haptic_list_lock);
+
+	haptic_update_value(haptic_cdev);
+
+	printk(KERN_INFO "Registered haptic device: %s\n", haptic_cdev->name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(haptic_classdev_register);
+
+/**
+ * haptic_classdev_unregister - unregisters a object of haptic_properties class.
+ * @haptic_cdev: the haptic device to unregister
+ *
+ * Unregisters a previously registered via haptic_classdev_register object.
+ */
+void haptic_classdev_unregister(struct haptic_classdev *haptic_cdev)
+{
+	class_remove_file(haptic_class, &class_attr_enable);
+	class_remove_file(haptic_class, &class_attr_oneshot);
+	class_remove_file(haptic_class, &class_attr_level);
+	class_remove_file(haptic_class, &class_attr_level_max);
+	class_remove_file(haptic_class, &class_attr_value);
+
+	device_unregister(haptic_cdev->dev);
+
+	down_write(&haptic_list_lock);
+	list_del(&haptic_cdev->node);
+	up_write(&haptic_list_lock);
+}
+EXPORT_SYMBOL_GPL(haptic_classdev_unregister);
+
+static int __init haptic_init(void)
+{
+	haptic_class = class_create(THIS_MODULE, "haptic");
+	if (IS_ERR(haptic_class))
+		return PTR_ERR(haptic_class);
+
+	iter = kmalloc(sizeof(struct class_dev_iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+	return 0;
+}
+subsys_initcall(haptic_init);
+
+static void __exit haptic_exit(void)
+{
+	class_destroy(haptic_class);
+	kfree(iter);
+}
+module_exit(haptic_exit);
+
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Haptic Class Interface");
diff --git a/drivers/haptic/haptic-samsung-pwm.c b/drivers/haptic/haptic-samsung-pwm.c
new file mode 100644
index 0000000..0fc1093
--- /dev/null
+++ b/drivers/haptic/haptic-samsung-pwm.c
@@ -0,0 +1,377 @@
+/*
+ *  drivers/haptic/haptic-samsung-pwm.c
+ *
+ *  Copyright (C) 2008 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/ctype.h>
+#include <linux/haptic.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/err.h>
+#include <linux/pwm.h>
+#include <linux/timer.h>
+
+#include "haptic.h"
+
+#define PWM_HAPTIC_PERIOD		44640
+#define PWM_HAPTIC_DEFAULT_LEVEL		2
+
+static int haptic_levels[] = { 18360, 14880, 10860, 5280, 540, };
+
+struct samsung_pwm_haptic {
+	struct haptic_classdev cdev;
+	struct work_struct work;
+	struct haptic_platform_data *pdata;
+	struct pwm_device *pwm;
+	struct timer_list timer;
+
+	int enable;
+	int powered;
+
+	int level;
+	int level_max;
+};
+
+static inline struct samsung_pwm_haptic *cdev_to_samsung_pwm_haptic(
+		struct haptic_classdev *haptic_cdev)
+{
+	return container_of(haptic_cdev, struct samsung_pwm_haptic, cdev);
+}
+
+static void samsung_pwm_haptic_power_on(struct samsung_pwm_haptic *haptic)
+{
+	if (haptic->powered)
+		return;
+	haptic->powered = 1;
+
+	if (gpio_is_valid(haptic->pdata->gpio))
+		gpio_set_value(haptic->pdata->gpio, 1);
+
+	pwm_enable(haptic->pwm);
+}
+
+static void samsung_pwm_haptic_power_off(struct samsung_pwm_haptic *haptic)
+{
+	if (!haptic->powered)
+		return;
+	haptic->powered = 0;
+
+	if (gpio_is_valid(haptic->pdata->gpio))
+		gpio_set_value(haptic->pdata->gpio, 0);
+
+	pwm_disable(haptic->pwm);
+}
+
+static int samsung_pwm_haptic_set_pwm_cycle(struct samsung_pwm_haptic *haptic)
+{
+	int duty = haptic_levels[haptic->level];
+	return pwm_config(haptic->pwm, duty, PWM_HAPTIC_PERIOD);
+}
+
+static void samsung_pwm_haptic_work(struct work_struct *work)
+{
+	struct samsung_pwm_haptic *haptic;
+	int r;
+
+	haptic = container_of(work, struct samsung_pwm_haptic, work);
+
+	if (haptic->enable) {
+		r = samsung_pwm_haptic_set_pwm_cycle(haptic);
+		if (r) {
+			dev_dbg(haptic->cdev.dev, "set_pwm_cycle failed\n");
+			return;
+		}
+		samsung_pwm_haptic_power_on(haptic);
+	} else {
+		samsung_pwm_haptic_power_off(haptic);
+	}
+}
+
+static void samsung_pwm_haptic_timer(unsigned long data)
+{
+	struct samsung_pwm_haptic *haptic = (struct samsung_pwm_haptic *)data;
+
+	haptic->enable = 0;
+	samsung_pwm_haptic_power_off(haptic);
+}
+
+static void samsung_pwm_haptic_set(struct haptic_classdev *haptic_cdev,
+				enum haptic_value value)
+{
+	struct samsung_pwm_haptic *haptic =
+		cdev_to_samsung_pwm_haptic(haptic_cdev);
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
+static enum haptic_value samsung_pwm_haptic_get(
+		struct haptic_classdev *haptic_cdev)
+{
+	struct samsung_pwm_haptic *haptic =
+		cdev_to_samsung_pwm_haptic(haptic_cdev);
+
+	if (haptic->enable)
+		return HAPTIC_FULL;
+
+	return HAPTIC_OFF;
+}
+
+#define ATTR_DEF_SHOW(name) \
+static ssize_t samsung_pwm_haptic_show_##name(struct device *dev, \
+		struct device_attribute *attr, char *buf) \
+{ \
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev); \
+	struct samsung_pwm_haptic *haptic =\
+		cdev_to_samsung_pwm_haptic(haptic_cdev); \
+ \
+	return sprintf(buf, "%u\n", haptic->name) + 1; \
+}
+
+#define ATTR_DEF_STORE(name) \
+static ssize_t samsung_pwm_haptic_store_##name(struct device *dev, \
+		struct device_attribute *attr, \
+		const char *buf, size_t size) \
+{ \
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev); \
+	struct samsung_pwm_haptic *haptic =\
+		 cdev_to_samsung_pwm_haptic(haptic_cdev); \
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
+static DEVICE_ATTR(enable, 0644, samsung_pwm_haptic_show_enable,
+		samsung_pwm_haptic_store_enable);
+
+static ssize_t samsung_pwm_haptic_store_level(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t size)
+{
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
+	struct samsung_pwm_haptic *haptic =
+		cdev_to_samsung_pwm_haptic(haptic_cdev);
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
+static DEVICE_ATTR(level, 0644, samsung_pwm_haptic_show_level,
+		samsung_pwm_haptic_store_level);
+
+ATTR_DEF_SHOW(level_max);
+static DEVICE_ATTR(level_max, 0444, samsung_pwm_haptic_show_level_max, NULL);
+
+static ssize_t samsung_pwm_haptic_store_oneshot(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t size)
+{
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
+	struct samsung_pwm_haptic *haptic =
+		cdev_to_samsung_pwm_haptic(haptic_cdev);
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
+static DEVICE_ATTR(oneshot, 0200, NULL, samsung_pwm_haptic_store_oneshot);
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
+static int samsung_pwm_haptic_probe(struct platform_device *pdev)
+{
+	struct haptic_platform_data *pdata = pdev->dev.platform_data;
+	struct samsung_pwm_haptic *haptic;
+	int ret;
+
+	haptic = kzalloc(sizeof(struct samsung_pwm_haptic), GFP_KERNEL);
+	if (!haptic) {
+		dev_err(&pdev->dev, "No memory for device\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, haptic);
+	haptic->cdev.set = samsung_pwm_haptic_set;
+	haptic->cdev.get = samsung_pwm_haptic_get;
+	haptic->cdev.show_enable = samsung_pwm_haptic_show_enable;
+	haptic->cdev.store_enable = samsung_pwm_haptic_store_enable;
+	haptic->cdev.store_oneshot = samsung_pwm_haptic_store_oneshot;
+	haptic->cdev.show_level = samsung_pwm_haptic_show_level;
+	haptic->cdev.store_level = samsung_pwm_haptic_store_level;
+	haptic->cdev.show_level_max = samsung_pwm_haptic_show_level_max;
+	haptic->cdev.name = pdata->name;
+	haptic->pdata = pdata;
+	haptic->enable = 0;
+	haptic->level = PWM_HAPTIC_DEFAULT_LEVEL;
+	haptic->level_max = ARRAY_SIZE(haptic_levels);
+
+	if (pdata->setup_pin)
+		pdata->setup_pin();
+
+	INIT_WORK(&haptic->work, samsung_pwm_haptic_work);
+
+	/* register our new haptic device */
+	ret = haptic_classdev_register(&pdev->dev, &haptic->cdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "haptic_classdev_register failed\n");
+		goto error_classdev;
+	}
+
+	haptic->pwm = pwm_request(pdata->pwm_timer, "haptic");
+	if (IS_ERR(haptic->pwm)) {
+		dev_err(&pdev->dev, "unable to request PWM for haptic\n");
+		ret = PTR_ERR(haptic->pwm);
+		goto err_pwm;
+	} else
+		dev_dbg(&pdev->dev, "got pwm for haptic\n");
+
+	ret = sysfs_create_group(&haptic->cdev.dev->kobj, &haptic_group);
+	if (ret)
+		goto error_enable;
+
+	if (gpio_is_valid(pdata->gpio)) {
+		printk(KERN_INFO "Motor enable gpio %d\n", pdata->gpio);
+		ret = gpio_request(pdata->gpio, "haptic enable");
+		if (ret)
+			goto error_gpio;
+		gpio_direction_output(pdata->gpio, 0);
+	}
+
+	init_timer(&haptic->timer);
+	haptic->timer.data = (unsigned long)haptic;
+	haptic->timer.function = &samsung_pwm_haptic_timer;
+
+	printk(KERN_INFO "samsung %s registed\n", pdata->name);
+	return 0;
+
+error_gpio:
+	gpio_free(pdata->gpio);
+error_enable:
+	sysfs_remove_group(&haptic->cdev.dev->kobj, &haptic_group);
+err_pwm:
+	pwm_free(haptic->pwm);
+error_classdev:
+	haptic_classdev_unregister(&haptic->cdev);
+	kfree(haptic);
+	return ret;
+}
+
+static int samsung_pwm_haptic_remove(struct platform_device *pdev)
+{
+	struct samsung_pwm_haptic *haptic = platform_get_drvdata(pdev);
+
+	samsung_pwm_haptic_set(&haptic->cdev, HAPTIC_OFF);
+	del_timer_sync(&haptic->timer);
+
+	if (haptic->pdata->gpio)
+		gpio_free(haptic->pdata->gpio);
+	device_remove_file(haptic->cdev.dev, &dev_attr_enable);
+	haptic_classdev_unregister(&haptic->cdev);
+	kfree(haptic);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int samsung_pwm_haptic_suspend(
+	struct platform_device *pdev, pm_message_t state)
+{
+	struct samsung_pwm_haptic *haptic = platform_get_drvdata(pdev);
+
+	haptic_classdev_suspend(&haptic->cdev);
+	return 0;
+}
+
+static int samsung_pwm_haptic_resume(struct platform_device *pdev)
+{
+	struct samsung_pwm_haptic *haptic = platform_get_drvdata(pdev);
+
+	haptic_classdev_resume(&haptic->cdev);
+	return 0;
+}
+#else
+#define samsung_pwm_haptic_suspend	NULL
+#define samsung_pwm_haptic_resume	NULL
+#endif
+
+static struct platform_driver samsung_pwm_haptic_driver = {
+	.probe		= samsung_pwm_haptic_probe,
+	.remove		= samsung_pwm_haptic_remove,
+	.suspend	= samsung_pwm_haptic_suspend,
+	.resume		= samsung_pwm_haptic_resume,
+	.driver		= {
+		.name	= "samsung_pwm_haptic",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init samsung_pwm_haptic_init(void)
+{
+	return platform_driver_register(&samsung_pwm_haptic_driver);
+}
+module_init(samsung_pwm_haptic_init);
+
+static void __exit samsung_pwm_haptic_exit(void)
+{
+	platform_driver_unregister(&samsung_pwm_haptic_driver);
+}
+module_exit(samsung_pwm_haptic_exit);
+
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_DESCRIPTION("samsung PWM haptic driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/haptic/haptic.h b/drivers/haptic/haptic.h
new file mode 100644
index 0000000..888aaa3
--- /dev/null
+++ b/drivers/haptic/haptic.h
@@ -0,0 +1,35 @@
+/*
+ *  Haptic Core
+ *
+ *  Copyright (C) 2008 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __HAPTIC_H_INCLUDED
+#define __HAPTIC_H_INCLUDED
+
+#include <linux/device.h>
+#include <linux/rwsem.h>
+#include <linux/haptic.h>
+
+static inline void haptic_set_value(struct haptic_classdev *haptic_cdev,
+					enum haptic_value value)
+{
+	if (value > HAPTIC_FULL)
+		value = HAPTIC_FULL;
+	haptic_cdev->value = value;
+	if (!(haptic_cdev->flags & HAPTIC_SUSPENDED))
+		haptic_cdev->set(haptic_cdev, value);
+}
+
+static inline int haptic_get_value(struct haptic_classdev *haptic_cdev)
+{
+	return haptic_cdev->value;
+}
+
+#endif	/* __HAPTIC_H_INCLUDED */
diff --git a/drivers/haptic/isa1200.c b/drivers/haptic/isa1200.c
new file mode 100644
index 0000000..19a3801
--- /dev/null
+++ b/drivers/haptic/isa1200.c
@@ -0,0 +1,413 @@
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
+	unsigned int	hen;		/* Haptic haptic enable */
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
+	return 0;
+}
+
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
diff --git a/include/linux/haptic.h b/include/linux/haptic.h
new file mode 100644
index 0000000..c8c0778
--- /dev/null
+++ b/include/linux/haptic.h
@@ -0,0 +1,85 @@
+/*
+ *  Driver model for haptic
+ *
+ *  Copyright (C) 2008 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __LINUX_HAPTIC_H_INCLUDED
+#define __LINUX_HAPTIC_H_INCLUDED
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/rwsem.h>
+
+struct device;
+/*
+ * Motor Core
+ */
+
+enum haptic_value {
+	HAPTIC_OFF	= 0,
+	HAPTIC_HALF	= 127,
+	HAPTIC_FULL	= 255,
+};
+
+struct haptic_classdev {
+	const char		*name;
+	int			value;
+#define HAPTIC_SUSPENDED		(1 << 0)
+	int			flags;
+
+	/* Set haptic value */
+	/* Must not sleep, use a workqueue if needed */
+	void			(*set)(struct haptic_classdev *self,
+					  enum haptic_value value);
+	/* Get haptic value */
+	enum haptic_value	(*get)(struct haptic_classdev *self);
+
+	ssize_t (*show_enable)(struct device *dev,
+			struct device_attribute *attr, char *buf);
+	ssize_t (*store_enable)(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t size);
+
+	ssize_t (*store_oneshot)(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t size);
+
+	ssize_t (*show_level)(struct device *dev,
+			struct device_attribute *attr, char *buf);
+	ssize_t (*store_level)(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t size);
+
+	ssize_t (*show_level_max)(struct device *dev,
+			struct device_attribute *attr, char *buf);
+
+	struct device		*dev;
+	struct list_head	node;	/* Motor Device list */
+};
+
+extern int haptic_classdev_register(struct device *parent,
+				 struct haptic_classdev *haptic_cdev);
+extern void haptic_classdev_unregister(struct haptic_classdev *lcd);
+extern void haptic_classdev_suspend(struct haptic_classdev *haptic_cdev);
+extern void haptic_classdev_resume(struct haptic_classdev *haptic_cdev);
+
+/*
+ * Generic and gpio haptic platform data for describing haptic names.
+ */
+struct haptic_platform_data {
+	const char	*name;
+	int		pwm_timer;
+	int		gpio;
+	void	(*setup_pin)(void);
+	u8		active_low;
+	int		ldo_level;
+};
+
+#endif	/* __LINUX_HAPTIC_H_INCLUDED */
