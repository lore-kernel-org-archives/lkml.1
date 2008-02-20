Return-Path: <linux-kernel-owner+w=401wt.eu-S1763111AbYBTRLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763111AbYBTRLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932124AbYBTRJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:09:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35650 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1765999AbYBTRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:09:14 -0500
Subject: [PATCH 4/6] regulator: regulator core.
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 17:09:11 +0000
Message-Id: <1203527351.4071.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the regulator framework core. The core also provides a
sysfs interface for userspace information.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 drivers/regulator/reg-core.c | 1049 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1049 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/reg-core.c

diff --git a/drivers/regulator/reg-core.c b/drivers/regulator/reg-core.c
new file mode 100644
index 0000000..43610c6
--- /dev/null
+++ b/drivers/regulator/reg-core.c
@@ -0,0 +1,1049 @@
+/*
+ * regulator.c  --  Voltage/Current Regulator framework.
+ *
+ * Copyright 2007 Wolfson Microelectronics PLC.
+ *
+ * Author: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/regulator/regulator.h>
+#include <linux/regulator/regulator-drv.h>
+#include <linux/regulator/regulator-platform.h>
+
+#define REGULATOR_VERSION "0.3"
+
+/* We need to undef the current macro (from include/asm/current.h) otherwise
+ * our "current" sysfs entry becomes "(get_current())".
+ */
+#undef current
+
+static DEFINE_MUTEX(list_mutex);
+static LIST_HEAD(regulator_cdevs);
+
+/**
+ * struct regulator_cdev
+ *
+ * Voltage / Current regulator class device. One for each regulator.
+ */
+struct regulator_cdev {
+	struct regulator_desc *desc;
+	int use_count;
+
+	struct list_head list;
+	struct list_head consumer_list;
+	struct blocking_notifier_head notifier;
+	struct mutex mutex;
+	struct module *owner;
+	struct class_device cdev;
+	struct regulation_constraints *constraints;
+	struct regulator_cdev *parent; /* for tree */
+
+	void *reg_data; /* regulator_cdev data */
+	void *vendor; /* regulator_cdev vendor extensions */
+};
+#define to_rcdev(cd) \
+	container_of(cd, struct regulator_cdev, cdev)
+
+/*
+ * struct regulator
+ *
+ * One for each consumer device.
+ */
+struct regulator {
+	struct device *dev;
+	struct list_head list;
+	int uA_load;
+	int uV_required;
+	int enabled;
+	struct device_attribute dev_attr;
+	struct regulator_cdev *rcdev;
+};
+
+static int _regulator_is_enabled(struct regulator_cdev *rcdev);
+static int _regulator_disable(struct regulator_cdev *rcdev);
+static int _regulator_get_voltage(struct regulator_cdev *rcdev);
+static int _regulator_get_current(struct regulator_cdev *rcdev);
+static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev);
+
+static struct regulator *get_regulator_load(struct device *dev)
+{
+	struct regulator *regulator = NULL;
+	struct regulator_cdev *rcdev;
+
+	list_for_each_entry(rcdev, &regulator_cdevs, list) {
+		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
+			if (regulator->dev == dev)
+				return regulator;
+		}
+	}
+	return NULL;
+}
+
+static int regulator_check_voltage(struct regulator_cdev *rcdev, int uV)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+			rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+			__func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	if (uV > rcdev->constraints->max_uV ||
+		uV < rcdev->constraints->min_uV) {
+		printk(KERN_ERR "%s: invalid voltage %duV for %s\n",
+			__func__, uV, rcdev->desc->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int regulator_check_current(struct regulator_cdev *rcdev, int uA)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+			rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_CURRENT) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+			__func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	if (uA > rcdev->constraints->max_uA ||
+		uA < rcdev->constraints->min_uA) {
+		printk(KERN_ERR "%s: invalid current %duA for %s\n",
+			__func__, uA, rcdev->desc->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int regulator_check_mode(struct regulator_cdev *rcdev, int mode)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+			rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_MODE) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+			__func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	if (!rcdev->constraints->valid_modes_mask & mode) {
+		printk(KERN_ERR "%s: invalid mode %x for %s\n",
+			__func__, mode, rcdev->desc->name);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int regulator_check_drms(struct regulator_cdev *rcdev)
+{
+	if (!rcdev->constraints) {
+		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
+			rcdev->desc->name);
+		return -ENODEV;
+	}
+	if (!rcdev->constraints->valid_ops_mask & REGULATOR_CHANGE_DRMS) {
+		printk(KERN_ERR "%s: operation not allowed for %s\n",
+			__func__, rcdev->desc->name);
+		return -EPERM;
+	}
+	return 0;
+}
+
+static ssize_t dev_load_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct regulator *regulator;
+
+	regulator = get_regulator_load(dev);
+	if (regulator == NULL)
+		return 0;
+
+	return sprintf(buf, "%d\n", regulator->uA_load);
+}
+
+static ssize_t regulator_uV_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	return sprintf(buf, "%d\n", _regulator_get_voltage(rcdev));
+}
+
+static ssize_t regulator_uA_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	return sprintf(buf, "%d\n", _regulator_get_current(rcdev));
+}
+
+static ssize_t regulator_mode_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	int mode = _regulator_get_mode(rcdev);
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		return sprintf(buf, "fast\n");
+	case REGULATOR_MODE_NORMAL:
+		return sprintf(buf, "normal\n");
+	case REGULATOR_MODE_IDLE:
+		return sprintf(buf, "idle\n");
+	case REGULATOR_MODE_STANDBY:
+		return sprintf(buf, "standby\n");
+	}
+	return sprintf(buf, "unknown\n");
+}
+
+static ssize_t regulator_state_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	int state = _regulator_is_enabled(rcdev);
+
+	if (state > 0)
+		return sprintf(buf, "enabled\n");
+	else if (state == 0)
+		return sprintf(buf, "disabled\n");
+	else
+		return sprintf(buf, "unknown\n");
+}
+
+static ssize_t regulator_constraint_uA_show(struct class_device *cdev,
+	char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraints not defined\n");
+
+	return sprintf (buf, "%d %d\n", rcdev->constraints->min_uA,
+		rcdev->constraints->max_uA);
+}
+
+static ssize_t regulator_constraint_uV_show(struct class_device *cdev,
+	char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraints not defined\n");
+
+	return sprintf (buf, "%d %d\n", rcdev->constraints->min_uV,
+		rcdev->constraints->max_uV);
+}
+
+static ssize_t regulator_constraint_modes_show(struct class_device *cdev,
+	char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	int count = 0;
+
+	if (!rcdev->constraints)
+		return sprintf(buf, "constraints not defined\n");
+
+	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_FAST)
+		count = sprintf (buf, "fast ");
+	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_NORMAL)
+		count += sprintf (buf + count, "normal ");
+	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
+		count += sprintf (buf + count, "idle ");
+	if (rcdev->constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
+		count += sprintf (buf + count, "standby");
+	count += sprintf(buf + count, "\n");
+	return count;
+}
+
+static ssize_t regulator_total_dev_load(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	struct regulator *regulator;
+	int uA = 0;
+
+	list_for_each_entry(regulator, &rcdev->consumer_list, list)
+		uA =+ regulator->uA_load;
+	return sprintf(buf, "%d\n", uA);
+}
+
+static ssize_t regulator_enabled_use_count(struct class_device *cdev,
+	char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+	return sprintf(buf, "%d\n", rcdev->use_count);
+}
+
+static ssize_t regulator_type_show(struct class_device *cdev, char *buf)
+{
+	struct regulator_cdev *rcdev = to_rcdev(cdev);
+
+	switch (rcdev->desc->type) {
+	case REGULATOR_VOLTAGE:
+		return sprintf(buf, "voltage\n");
+	case REGULATOR_CURRENT:
+		return sprintf(buf, "current\n");
+	}
+	return sprintf(buf, "unknown\n");
+}
+
+static struct class_device_attribute regulator_dev_attrs[] = {
+	__ATTR(voltage, 0444, regulator_uV_show, NULL),
+	__ATTR(current, 0444, regulator_uA_show, NULL),
+	__ATTR(opmode, 0444, regulator_mode_show, NULL),
+	__ATTR(enabled, 0444, regulator_state_show, NULL),
+	__ATTR(voltage_limits, 0444, regulator_constraint_uA_show, NULL),
+	__ATTR(current_limits, 0444, regulator_constraint_uV_show, NULL),
+	__ATTR(valid_opmodes, 0444, regulator_constraint_modes_show, NULL),
+	__ATTR(total_load, 0444, regulator_total_dev_load, NULL),
+	__ATTR(enabled_count, 0444, regulator_enabled_use_count, NULL),
+	__ATTR(type, 0444, regulator_type_show, NULL),
+	__ATTR_NULL,
+};
+
+static void regulator_dev_release(struct class_device *class_dev) {}
+
+struct class regulator_class = {
+	.name			= "regulator",
+	.release		= regulator_dev_release,
+	.class_dev_attrs	= regulator_dev_attrs,
+};
+
+/* find the lowest stable voltage that all enabled clients can operate at */
+static int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
+{
+	struct regulator *regulator;
+	int highest_uV = 0;
+
+	list_for_each_entry(regulator, &rcdev->consumer_list, list) {
+		if (regulator->enabled && regulator->uV_required > highest_uV)
+			highest_uV = regulator->uV_required;
+	}
+	return highest_uV;
+}
+
+/* set the regulator voltage to the lowest possible value that can safely
+ * support all the client devices */
+static int regulator_set_stable_voltage(struct regulator_cdev *rcdev)
+{
+	int ret = 0, uV;
+
+	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
+		uV = get_lowest_stable_voltage(rcdev);
+		if (uV && rcdev->desc->ops->set_voltage)
+			ret = rcdev->desc->ops->set_voltage(rcdev, uV);
+	}
+	return ret;
+}
+
+static void regulator_load_change (struct regulator_cdev *rcdev)
+{
+	struct regulator *sibling;
+	int current_uA = 0, output_uV, input_uV, err;
+	unsigned int mode;
+
+	err = regulator_check_drms(rcdev);
+	if (err < 0 || !rcdev->desc->ops->get_optimum_mode ||
+		!rcdev->desc->ops->get_voltage || !rcdev->desc->ops->set_mode);
+		return;
+
+	/* get output voltage */
+	output_uV = rcdev->desc->ops->get_voltage(rcdev);
+
+	/* get input voltage */
+	if (rcdev->parent && rcdev->parent->desc->ops->get_voltage)
+		input_uV =
+			rcdev->parent->desc->ops->get_voltage(rcdev->parent);
+	else
+		input_uV = rcdev->constraints->input_uV;
+
+	/* calc total requested load */
+	list_for_each_entry(sibling, &rcdev->consumer_list, list)
+		current_uA += sibling->uA_load;
+
+	/* now get the optimum mode for our new total regulator load */
+	mode = rcdev->desc->ops->get_optimum_mode(rcdev, input_uV,
+		output_uV, current_uA);
+
+	/* check the new mode is allowed */
+	err = regulator_check_mode(rcdev, mode);
+	if (err == 0)
+		rcdev->desc->ops->set_mode(rcdev, mode);
+}
+
+static void print_constraints(struct regulator_cdev *rcdev)
+{
+	struct regulation_constraints *constraints = rcdev->constraints;
+	char buf[80];
+	int count;
+
+	if (rcdev->desc->type == REGULATOR_VOLTAGE) {
+		if (constraints->min_uV == constraints->max_uV)
+			count = sprintf(buf, "%d mV ",
+				uV_to_mV(constraints->min_uV));
+		else
+			count = sprintf(buf, "%d <--> %d mV ",
+				uV_to_mV(constraints->min_uV),
+				uV_to_mV(constraints->max_uV));
+	} else {
+		if (constraints->min_uA == constraints->max_uA)
+			count = sprintf(buf, "%d mA ",
+				uA_to_mA(constraints->min_uA));
+		else
+			count = sprintf(buf, "%d <--> %d mA ",
+				uA_to_mA(constraints->min_uA),
+				uA_to_mA(constraints->max_uA));
+	}
+	if (constraints->valid_modes_mask & REGULATOR_MODE_FAST)
+		count += sprintf (buf + count, "fast ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_NORMAL)
+		count += sprintf (buf + count, "normal ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_IDLE)
+		count += sprintf (buf + count, "idle ");
+	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
+		count += sprintf (buf + count, "standby");
+
+	printk(KERN_INFO "regulator: %s: %s\n", rcdev->desc->name, buf);
+}
+
+static struct regulator *create_regulator(struct regulator_cdev *rcdev,
+	struct device *dev)
+{
+	struct regulator *regulator;
+	char buf[32];
+	int err;
+
+	regulator = kzalloc(sizeof(*regulator), GFP_KERNEL);
+	if (regulator == NULL)
+		return NULL;
+
+	regulator->rcdev = rcdev;
+	sprintf(buf, "current_requested-%s", regulator->rcdev->desc->name);
+	list_add(&regulator->list, &rcdev->consumer_list);
+
+	if (dev == NULL)
+		goto out;
+
+	regulator->dev = dev;
+	regulator->dev_attr.attr.name = kstrdup(buf, GFP_KERNEL);
+	if (regulator->dev_attr.attr.name == NULL)
+		goto err_out;
+	regulator->dev_attr.attr.owner = THIS_MODULE;
+	regulator->dev_attr.attr.mode = 0444;
+	regulator->dev_attr.show = dev_load_show;
+	err = device_create_file(dev, &regulator->dev_attr);
+	if (err < 0) {
+		printk(KERN_WARNING "%s: could not add regulator_cdev load"
+		" sysfs\n", __func__);
+		goto err_out;
+	}
+	err = sysfs_create_link(&rcdev->cdev.kobj, &dev->kobj,
+		dev->kobj.name);
+	if (err) {
+		printk(KERN_WARNING
+			"%s: could not add device link %s err %d\n",
+			__func__, dev->kobj.name, err);
+		goto err_out;
+	}
+out:
+	return regulator;
+err_out:
+	kfree(regulator->dev_attr.attr.name);
+	list_del(&regulator->list);
+	kfree(regulator);
+	return NULL;
+}
+
+struct regulator *regulator_get(struct device *dev, const char *id)
+{
+	struct regulator_cdev *rcdev;
+	struct regulator *regulator = ERR_PTR(-ENODEV);
+
+	if (id == NULL)
+		return regulator;
+
+	mutex_lock(&list_mutex);
+	list_for_each_entry(rcdev, &regulator_cdevs, list) {
+		if (strcmp(id, rcdev->desc->name) == 0 &&
+			try_module_get(rcdev->owner)) {
+			goto found;
+		}
+	}
+	printk(KERN_ERR "regulator: Unable to get requested regulator: %s\n",
+		id);
+	mutex_unlock(&list_mutex);
+	return regulator;
+
+found:
+	regulator = create_regulator(rcdev, dev);
+	if (regulator == NULL) {
+		regulator = ERR_PTR(-ENOMEM);
+		module_put(rcdev->owner);
+	}
+
+	mutex_unlock(&list_mutex);
+	return regulator;
+}
+EXPORT_SYMBOL_GPL(regulator_get);
+
+void regulator_put(struct regulator *regulator)
+{
+	struct regulator_cdev *rcdev;
+
+	if (regulator == NULL || IS_ERR(regulator))
+		return;
+
+	rcdev = regulator->rcdev;
+
+	/* remove any sysfs entries */
+	if (regulator->dev) {
+		sysfs_remove_link(&rcdev->cdev.kobj,
+			regulator->dev->kobj.name);
+		device_remove_file(regulator->dev, &regulator->dev_attr);
+	}
+	list_del(&regulator->list);
+	kfree(regulator->dev_attr.attr.name);
+	kfree(regulator);
+
+	module_put(rcdev->owner);
+	mutex_unlock(&list_mutex);
+}
+EXPORT_SYMBOL_GPL(regulator_put);
+
+static int _regulator_enable(struct regulator_cdev *rcdev)
+{
+	int ret = 0;
+
+	/* if the regulator is currently disabled make sure we check
+	 * it's parent, mode and required voltage */
+	if (rcdev->use_count == 0) {
+		if (rcdev->parent) {
+			ret = _regulator_enable(rcdev->parent);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to enable %s\n",
+					__func__, rcdev->desc->name);
+				goto out;
+			}
+		}
+		if (rcdev->desc->ops->enable) {
+			ret = regulator_set_stable_voltage(rcdev);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: invalid voltage for %s\n",
+					__func__, rcdev->desc->name);
+				goto out;
+			}
+			regulator_load_change(rcdev);
+			ret = rcdev->desc->ops->enable(rcdev);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to enable %s\n",
+					__func__, rcdev->desc->name);
+				goto out;
+			}
+		}
+	} else {
+		ret = regulator_set_stable_voltage(rcdev);
+		if (ret < 0) {
+			printk(KERN_ERR "%s: invalid voltage for %s\n",
+				__func__, rcdev->desc->name);
+			goto out;
+		}
+		regulator_load_change(rcdev);
+	}
+	rcdev->use_count++;
+out:
+	return ret;
+}
+
+int regulator_enable(struct regulator *regulator)
+{
+	int ret;
+
+	mutex_lock(&regulator->rcdev->mutex);
+	regulator->enabled = 1;
+	ret = _regulator_enable(regulator->rcdev);
+	if (ret < 0)
+		regulator->enabled = 0;
+	mutex_unlock(&regulator->rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_enable);
+
+static int _regulator_disable(struct regulator_cdev *rcdev)
+{
+	int ret = 0;
+
+	/* make sure we are the last user before disabling this regulator */
+	if (rcdev->use_count == 1) {
+		if (rcdev->desc->ops->disable) {
+			ret = rcdev->desc->ops->disable(rcdev);
+			if (ret < 0) {
+				printk(KERN_ERR "%s: failed to disable %s\n",
+					__func__, rcdev->desc->name);
+				goto out;
+			}
+		}
+		/* decrease parent ref count and disable if required */
+		if (rcdev->parent)
+			_regulator_disable(rcdev->parent);
+	} else {
+		/* set to next best requested voltage and mode */
+		ret = regulator_set_stable_voltage(rcdev);
+		regulator_load_change(rcdev);
+	}
+	rcdev->use_count--;
+out:
+	if (rcdev->use_count < 0) {
+		printk(KERN_ERR "%s: tried to disable too many times\n",
+			__func__);
+		rcdev->use_count = 0;
+	}
+	return ret;
+}
+
+int regulator_disable(struct regulator *regulator)
+{
+	int ret;
+
+	mutex_lock(&regulator->rcdev->mutex);
+	regulator->enabled = 0;
+	regulator->uA_load = 0;
+	ret = _regulator_disable(regulator->rcdev);
+	if (ret < 0)
+		regulator->enabled = 1;
+	mutex_unlock(&regulator->rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_disable);
+
+static int _regulator_is_enabled(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->is_enabled) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->is_enabled(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+int regulator_is_enabled(struct regulator *regulator)
+{
+	return _regulator_is_enabled(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_is_enabled);
+
+int regulator_set_voltage(struct regulator *regulator, int uV)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->set_voltage) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* constraints check */
+	ret = regulator_check_voltage(rcdev, uV);
+	if (ret < 0)
+		goto out;
+	regulator->uV_required = uV;
+
+	/* only set the new voltage if it's all clients can use it */
+	ret = regulator_set_stable_voltage(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_voltage);
+
+static int _regulator_get_voltage(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_voltage) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_voltage(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+int regulator_get_voltage(struct regulator *regulator)
+{
+	return _regulator_get_voltage(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_get_voltage);
+
+int regulator_set_current(struct regulator *regulator, int uA)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->set_current) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* constraints check */
+	ret = regulator_check_current(rcdev, uA);
+	if (ret < 0)
+		goto out;
+
+	ret = rcdev->desc->ops->set_current(rcdev, uA);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_current);
+
+static int _regulator_get_current(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_current) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_current(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+int regulator_get_current(struct regulator *regulator)
+{
+	return _regulator_get_current(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_get_current);
+
+int regulator_set_mode(struct regulator *regulator, unsigned int mode)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->set_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* constraints check */
+	ret = regulator_check_mode(rcdev, mode);
+	if (ret < 0)
+		goto out;
+
+	ret = rcdev->desc->ops->set_mode(rcdev, mode);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regulator_set_mode);
+
+static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_mode(rcdev);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+unsigned int regulator_get_mode(struct regulator *regulator)
+{
+	return _regulator_get_mode(regulator->rcdev);
+}
+EXPORT_SYMBOL_GPL(regulator_get_mode);
+
+static unsigned int _regulator_get_optimum_mode(struct regulator_cdev *rcdev,
+	int input_uV, int output_uV, int load_uA)
+{
+	int ret;
+
+	mutex_lock(&rcdev->mutex);
+
+	/* sanity check */
+	if (!rcdev->desc->ops->get_optimum_mode) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rcdev->desc->ops->get_optimum_mode(rcdev,
+		input_uV, output_uV, load_uA);
+out:
+	mutex_unlock(&rcdev->mutex);
+	return ret;
+}
+
+unsigned int regulator_get_optimum_mode(struct regulator *regulator,
+	int input_uV, int output_uV, int load_uA)
+{
+	return _regulator_get_optimum_mode(regulator->rcdev, input_uV,
+		output_uV, load_uA);
+}
+EXPORT_SYMBOL_GPL(regulator_get_optimum_mode);
+
+int regulator_register_client(struct regulator *regulator,
+	struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&regulator->rcdev->notifier,
+		nb);
+}
+EXPORT_SYMBOL_GPL(regulator_register_client);
+
+int regulator_unregister_client(struct regulator *regulator,
+	struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&regulator->rcdev->notifier,
+		nb);
+}
+EXPORT_SYMBOL_GPL(regulator_unregister_client);
+
+int regulator_notifier_call_chain(struct regulator_cdev *rcdev,
+	unsigned long event, void *data)
+{
+	return blocking_notifier_call_chain(&rcdev->notifier, event, data);
+}
+EXPORT_SYMBOL_GPL(regulator_notifier_call_chain);
+
+struct regulator_cdev *regulator_register(
+	struct regulator_desc *regulator_desc, void *reg_data)
+{
+	static atomic_t regulator_no = ATOMIC_INIT(0);
+	struct regulator_cdev *rcdev;
+	int ret;
+
+	if (regulator_desc == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (regulator_desc->name == NULL || regulator_desc->ops == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (!regulator_desc->type == REGULATOR_VOLTAGE &&
+		!regulator_desc->type == REGULATOR_CURRENT)
+		return ERR_PTR(-EINVAL);
+
+	rcdev = kzalloc(sizeof(struct regulator_cdev), GFP_KERNEL);
+	if (rcdev == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&list_mutex);
+
+	mutex_init(&rcdev->mutex);
+	rcdev->reg_data = reg_data;
+	rcdev->owner = regulator_desc->owner;
+	rcdev->desc = regulator_desc;
+	INIT_LIST_HEAD(&rcdev->consumer_list);
+	INIT_LIST_HEAD(&rcdev->list);
+	BLOCKING_INIT_NOTIFIER_HEAD(&rcdev->notifier);
+
+	rcdev->cdev.class = &regulator_class;
+	class_device_initialize(&rcdev->cdev);
+	snprintf(rcdev->cdev.class_id, sizeof(rcdev->cdev.class_id),
+		"regulator-%ld-%s",
+		(unsigned long) atomic_inc_return(&regulator_no) - 1,
+		regulator_desc->name);
+
+	ret = class_device_add(&rcdev->cdev);
+	if (ret == 0)
+		list_add(&rcdev->list, &regulator_cdevs);
+	else {
+		kfree(rcdev);
+		rcdev = ERR_PTR(ret);
+	}
+	mutex_unlock(&list_mutex);
+	return rcdev;
+}
+EXPORT_SYMBOL_GPL(regulator_register);
+
+void regulator_unregister(struct regulator_cdev *rcdev)
+{
+	if (rcdev == NULL)
+		return;
+
+	mutex_lock(&list_mutex);
+	list_del(&rcdev->list);
+	if (rcdev->parent)
+		sysfs_remove_link(&rcdev->cdev.kobj, "source");
+	class_device_unregister(&rcdev->cdev);
+	kfree(rcdev);
+	mutex_unlock(&list_mutex);
+}
+EXPORT_SYMBOL_GPL(regulator_unregister);
+
+int regulator_set_platform_source(const char *regulator_source,
+	const char *regulator_parent)
+{
+	struct regulator_cdev *source_rcdev, *parent_rcdev;
+	int err;
+
+	if (regulator_source == NULL || regulator_parent == NULL)
+		return -EINVAL;
+
+	mutex_lock(&list_mutex);
+
+	list_for_each_entry(source_rcdev, &regulator_cdevs, list) {
+		if (!strcmp(source_rcdev->desc->name, regulator_source))
+			goto found_source;
+	}
+	mutex_unlock(&list_mutex);
+	return -ENODEV;
+
+found_source:
+	list_for_each_entry(parent_rcdev, &regulator_cdevs, list) {
+		if (!strcmp(parent_rcdev->desc->name, regulator_parent))
+			goto found_parent;
+	}
+	mutex_unlock(&list_mutex);
+	return -ENODEV;
+
+found_parent:
+	source_rcdev->parent = parent_rcdev;
+	err = sysfs_create_link(&source_rcdev->cdev.kobj,
+		&parent_rcdev->cdev.kobj, "source");
+	if (err)
+		printk(KERN_WARNING
+			"%s: could not add device link %s err %d\n",
+			__func__, parent_rcdev->cdev.kobj.name, err);
+	mutex_unlock(&list_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(regulator_set_platform_source);
+
+const char *regulator_get_platform_source(const char *regulator_name)
+{
+	struct regulator_cdev *rcdev;
+
+	if (regulator_name == NULL)
+		return NULL;
+
+	mutex_lock(&list_mutex);
+	list_for_each_entry(rcdev, &regulator_cdevs, list) {
+		if (!strcmp(rcdev->desc->name, regulator_name))
+			goto found;
+	}
+	mutex_unlock(&list_mutex);
+	return NULL;
+
+found:
+	mutex_unlock(&list_mutex);
+	if (rcdev->parent)
+		return rcdev->parent->desc->name;
+	else
+		return NULL;
+}
+EXPORT_SYMBOL_GPL(regulator_get_platform_source);
+
+int regulator_set_platform_constraints(const char *regulator_name,
+	struct regulation_constraints *constraints)
+{
+	struct regulator_cdev *rcdev;
+
+	if (regulator_name == NULL)
+		return -EINVAL;
+
+	mutex_lock(&list_mutex);
+	list_for_each_entry(rcdev, &regulator_cdevs, list) {
+		if (!strcmp(regulator_name, rcdev->desc->name)) {
+			mutex_lock(&rcdev->mutex);
+			rcdev->constraints = constraints;
+			print_constraints(rcdev);
+			mutex_unlock(&rcdev->mutex);
+			mutex_unlock(&list_mutex);
+			return 0;
+		}
+	}
+	mutex_unlock(&list_mutex);
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(regulator_set_platform_constraints);
+
+void regulator_drms_notify_load(struct regulator *regulator, int uA)
+{
+	struct regulator_cdev *rcdev = regulator->rcdev;
+
+	mutex_lock(&rcdev->mutex);
+	regulator->uA_load = uA;
+	regulator_load_change (rcdev);
+	mutex_unlock(&rcdev->mutex);
+}
+EXPORT_SYMBOL_GPL(regulator_drms_notify_load);
+
+void *regulator_get_drvdata(struct regulator *regulator)
+{
+	return regulator->rcdev->reg_data;
+}
+EXPORT_SYMBOL_GPL(regulator_get_drvdata);
+
+void regulator_set_drvdata(struct regulator *regulator, void *data)
+{
+	regulator->rcdev->reg_data = data;
+}
+EXPORT_SYMBOL_GPL(regulator_set_drvdata);
+
+int rcdev_get_id (struct regulator_cdev *rcdev)
+{
+	return rcdev->desc->id;
+}
+EXPORT_SYMBOL_GPL(rcdev_get_id);
+
+void *rcdev_get_drvdata (struct regulator_cdev *rcdev)
+{
+	return rcdev->reg_data;
+}
+EXPORT_SYMBOL_GPL(rcdev_get_drvdata);
+
+static int __init regulator_init(void)
+{
+	printk(KERN_INFO "regulator: core version %s\n", REGULATOR_VERSION);
+	return class_register(&regulator_class);
+}
+
+/* init early to allow our consumers to complete system booting */
+core_initcall(regulator_init);
-- 
1.5.4.2



