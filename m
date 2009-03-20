Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZCTNy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZCTNy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZCTNyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:54:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:43998 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZCTNyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:54:14 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, juha.yrjola@solidboot.com,
       ext-jani.1.nikula@nokia.com
Subject: [RFC PATCH 2/3] GPIO-SWITCH: Adaptation of GPIO switch framework for mainline
Date: Fri, 20 Mar 2009 15:50:49 +0200
Message-Id: <c2a7291982d37847ef8670c7deeb8e95663d0ae2.1237555607.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
 <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
References: <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 20 Mar 2009 13:51:47.0563 (UTC) FILETIME=[031983B0:01C9A963]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt OMAP GPIO switch framework for mainline integration. The purpose
of the framework is to support reporting and changing GPIO switches via
sysfs. The starting point for the adaptation is:

  $ cp arch/arm/plat-omap/gpio-switch.c drivers/gpio/.
  $ cp arch/arm/plat-omap/include/mach/gpio-switch.h include/linux/.

Changes from OMAP version:
  - Remove OMAP dependencies.
  - Add dynamic switch add/remove.
  - Use gpiolib sysfs structure for the switches.
  - Use dev_dbg and friends instead of printk.
  - Misc cleanup.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/gpio-switch.c  |  534 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/gpio-switch.h |   74 ++++++
 2 files changed, 608 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/gpio-switch.c
 create mode 100644 include/linux/gpio-switch.h

diff --git a/drivers/gpio/gpio-switch.c b/drivers/gpio/gpio-switch.c
new file mode 100644
index 0000000..141e4e2
--- /dev/null
+++ b/drivers/gpio/gpio-switch.c
@@ -0,0 +1,534 @@
+/*
+ *  gpio-switch.c - GPIO switch framework
+ *
+ *  Copyright (C) 2004-2006,2009 Nokia Corporation
+ *  Written by Juha Yrjölä <juha.yrjola@nokia.com>
+ *         and Paul Mundt <paul.mundt@nokia.com>
+ *  Adapted for mainline by Jani Nikula <ext-jani.1.nikula@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/timer.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/gpio-switch.h>
+
+struct gpio_sw {
+	char		name[14];
+	u16		gpio;
+	unsigned	flags:4;
+	unsigned	type:4;
+	unsigned	state:1;
+
+	u16		debounce_rising;
+	u16		debounce_falling;
+
+	void (*notify)(void *data, int state);
+	void *notify_data;
+
+	struct work_struct	work;
+	struct timer_list	timer;
+	struct device		*dev;
+
+	struct list_head	node;
+};
+
+static LIST_HEAD(gpio_switches);
+/* FIXME: this lock protects gpio_switches list, but how about locking
+ * in sysfs access? */
+static DEFINE_MUTEX(gpio_switches_mutex);
+static struct device *dbg_dev;
+
+static const char *cover_str[2] = { "open", "closed" };
+static const char *connection_str[2] = { "disconnected", "connected" };
+static const char *activity_str[2] = { "inactive", "active" };
+
+/*
+ * GPIO switch state default debounce delay in ms
+ */
+#define GPIO_SW_DEFAULT_DEBOUNCE		10
+
+static const char **get_sw_str(struct gpio_sw *sw)
+{
+	switch (sw->type) {
+	case GPIO_SWITCH_TYPE_COVER:
+		return cover_str;
+	case GPIO_SWITCH_TYPE_CONNECTION:
+		return connection_str;
+	case GPIO_SWITCH_TYPE_ACTIVITY:
+		return activity_str;
+	default:
+		BUG();
+		return NULL;
+	}
+}
+
+static const char *get_sw_type(struct gpio_sw *sw)
+{
+	switch (sw->type) {
+	case GPIO_SWITCH_TYPE_COVER:
+		return "cover";
+	case GPIO_SWITCH_TYPE_CONNECTION:
+		return "connection";
+	case GPIO_SWITCH_TYPE_ACTIVITY:
+		return "activity";
+	default:
+		BUG();
+		return NULL;
+	}
+}
+
+static void print_sw_state(struct gpio_sw *sw, int state)
+{
+	const char **str;
+
+	str = get_sw_str(sw);
+	if (str != NULL)
+		dev_info(sw->dev, "(GPIO %d) is now %s\n", sw->gpio,
+			str[state]);
+}
+
+static int gpio_sw_get_state(struct gpio_sw *sw)
+{
+	int state;
+
+	state = gpio_get_value(sw->gpio);
+	if (sw->flags & GPIO_SWITCH_FLAG_INVERTED)
+		state = !state;
+
+	return state;
+}
+
+static ssize_t gpio_sw_state_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct gpio_sw *sw = dev_get_drvdata(dev);
+	const char **str;
+	char state[16];
+	int enable;
+
+	if (!(sw->flags & GPIO_SWITCH_FLAG_OUTPUT))
+		return -EPERM;
+
+	if (sscanf(buf, "%15s", state) != 1)
+		return -EINVAL;
+
+	str = get_sw_str(sw);
+	if (strcmp(state, str[0]) == 0)
+		sw->state = enable = 0;
+	else if (strcmp(state, str[1]) == 0)
+		sw->state = enable = 1;
+	else
+		return -EINVAL;
+
+	if (sw->flags & GPIO_SWITCH_FLAG_INVERTED)
+		enable = !enable;
+	gpio_set_value(sw->gpio, enable);
+
+	return count;
+}
+
+static ssize_t gpio_sw_state_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct gpio_sw *sw = dev_get_drvdata(dev);
+	const char **str;
+
+	str = get_sw_str(sw);
+
+	return sprintf(buf, "%s\n", str[sw->state]);
+}
+
+static DEVICE_ATTR(state, S_IRUGO | S_IWUSR, gpio_sw_state_show,
+		gpio_sw_state_store);
+
+static ssize_t gpio_sw_type_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct gpio_sw *sw = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", get_sw_type(sw));
+}
+
+static DEVICE_ATTR(type, S_IRUGO, gpio_sw_type_show, NULL);
+
+static ssize_t gpio_sw_direction_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct gpio_sw *sw = dev_get_drvdata(dev);
+	int is_output;
+
+	is_output = sw->flags & GPIO_SWITCH_FLAG_OUTPUT;
+
+	return sprintf(buf, "%s\n", is_output ? "output" : "input");
+}
+
+static DEVICE_ATTR(direction, S_IRUGO, gpio_sw_direction_show, NULL);
+
+static struct attribute *gpio_sw_attributes[] = {
+	&dev_attr_state.attr,
+	&dev_attr_type.attr,
+	&dev_attr_direction.attr,
+	NULL
+};
+
+static const struct attribute_group gpio_sw_attr_group = {
+	.attrs = gpio_sw_attributes,
+};
+
+static irqreturn_t gpio_sw_irq_handler(int irq, void *arg)
+{
+	struct gpio_sw *sw = arg;
+	unsigned long timeout;
+	int state;
+
+	state = gpio_sw_get_state(sw);
+	if (sw->state == state)
+		return IRQ_HANDLED;
+
+	if (state)
+		timeout = sw->debounce_rising;
+	else
+		timeout = sw->debounce_falling;
+
+	if (!timeout)
+		schedule_work(&sw->work);
+	else
+		mod_timer(&sw->timer, jiffies + msecs_to_jiffies(timeout));
+
+	return IRQ_HANDLED;
+}
+
+static void gpio_sw_timer(unsigned long arg)
+{
+	struct gpio_sw *sw = (struct gpio_sw *) arg;
+
+	schedule_work(&sw->work);
+}
+
+static void gpio_sw_handler(struct work_struct *work)
+{
+	struct gpio_sw *sw = container_of(work, struct gpio_sw, work);
+	int state;
+
+	state = gpio_sw_get_state(sw);
+	if (sw->state == state)
+		return;
+
+	sw->state = state;
+	if (sw->notify != NULL)
+		sw->notify(sw->notify_data, state);
+	sysfs_notify(&sw->dev->kobj, NULL, "state");
+	print_sw_state(sw, state);
+}
+
+static int new_switch(struct gpio_sw *sw)
+{
+	int r, direction;
+	struct device *dev;
+
+	switch (sw->type) {
+	case GPIO_SWITCH_TYPE_COVER:
+	case GPIO_SWITCH_TYPE_CONNECTION:
+	case GPIO_SWITCH_TYPE_ACTIVITY:
+		break;
+	default:
+		dev_err(dbg_dev, "invalid GPIO switch type: %d\n", sw->type);
+		return -EINVAL;
+	}
+
+	r = gpio_request(sw->gpio, sw->name);
+	if (r < 0) {
+		dev_err(dbg_dev, "gpio_request failed for %s", sw->name);
+		goto err_gpio;
+	}
+
+	/* input: 1, output: 0 */
+	direction = !(sw->flags & GPIO_SWITCH_FLAG_OUTPUT);
+	if (direction) {
+		gpio_direction_input(sw->gpio);
+		sw->state = gpio_sw_get_state(sw);
+	} else {
+		int state = sw->state =
+			!!(sw->flags & GPIO_SWITCH_FLAG_OUTPUT_INIT_HIGH);
+
+		if (sw->flags & GPIO_SWITCH_FLAG_INVERTED)
+			state = !state;
+		gpio_direction_output(sw->gpio, state);
+	}
+
+	/* switch device in gpiolib sysfs */
+	dev = gpio_device_create(sw->gpio, sw, "switch-%s", sw->name);
+	if (IS_ERR(dev)) {
+		r = PTR_ERR(dev);
+		goto err_dev;
+	}
+
+	sw->dev = dev;
+
+	r = sysfs_create_group(&dev->kobj, &gpio_sw_attr_group);
+	if (r)
+		dev_err(dbg_dev, "attribute group creation failed for %s\n",
+			sw->name);
+
+	if (direction) {
+		r = request_irq(gpio_to_irq(sw->gpio), gpio_sw_irq_handler,
+				IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+				IRQF_SHARED, sw->name, sw);
+		if (r < 0) {
+			dev_err(dbg_dev, "request_irq() failed for GPIO %d\n",
+				sw->gpio);
+			goto err_irq;
+		}
+
+		INIT_WORK(&sw->work, gpio_sw_handler);
+		init_timer(&sw->timer);
+
+		sw->timer.function = gpio_sw_timer;
+		sw->timer.data = (unsigned long)sw;
+	}
+
+	list_add(&sw->node, &gpio_switches);
+
+	return 0;
+
+err_irq:
+	device_unregister(dev);
+err_dev:
+	gpio_free(sw->gpio);
+err_gpio:
+	return r;
+}
+
+static struct gpio_sw *find_switch(int gpio, const char *name)
+{
+	struct gpio_sw *sw;
+
+	list_for_each_entry(sw, &gpio_switches, node) {
+		if ((gpio < 0 || sw->gpio != gpio) &&
+			(name == NULL || strcmp(sw->name, name) != 0))
+			continue;
+
+		if (gpio < 0 || name == NULL)
+			goto no_check;
+
+		if (strcmp(sw->name, name) != 0)
+			dev_err(dbg_dev, "name mismatch for %d (%s, %s)\n",
+				gpio, name, sw->name);
+		else if (sw->gpio != gpio)
+			dev_err(dbg_dev, "GPIO mismatch for %s (%d, %d)\n",
+				name, gpio, sw->gpio);
+no_check:
+		return sw;
+	}
+
+	return NULL;
+}
+
+static void report_initial_state(struct gpio_sw *sw)
+{
+	int state;
+
+	if (sw->flags & GPIO_SWITCH_FLAG_OUTPUT)
+		return;
+
+	state = gpio_get_value(sw->gpio);
+	if (sw->flags & GPIO_SWITCH_FLAG_INVERTED)
+		state = !state;
+	if (sw->notify != NULL)
+		sw->notify(sw->notify_data, state);
+	print_sw_state(sw, state);
+}
+
+static void free_switch(struct gpio_sw *sw)
+{
+	if (!(sw->flags & GPIO_SWITCH_FLAG_OUTPUT)) {
+		free_irq(gpio_to_irq(sw->gpio), sw);
+		del_timer_sync(&sw->timer);
+		flush_scheduled_work();
+	}
+
+	sysfs_remove_group(&sw->dev->kobj, &gpio_sw_attr_group);
+	device_unregister(sw->dev);
+
+	gpio_free(sw->gpio);
+
+	kfree(sw);
+}
+
+static void free_switches(void)
+{
+	struct gpio_sw *sw;
+	struct gpio_sw *tmp;
+
+	mutex_lock(&gpio_switches_mutex);
+	list_for_each_entry_safe(sw, tmp, &gpio_switches, node) {
+		list_del(&sw->node);
+		free_switch(sw);
+	}
+	mutex_unlock(&gpio_switches_mutex);
+}
+
+/**
+ * gpio_switch_request - request a GPIO switch
+ * @sw: pointer to GPIO switch structure
+ *
+ */
+int gpio_switch_request(const struct gpio_switch *sw)
+{
+	int r = 0;
+	struct gpio_sw *drvdata;
+
+	mutex_lock(&gpio_switches_mutex);
+	if (find_switch(sw->gpio, sw->name) != NULL) {
+		r = -EINVAL;
+		goto done;
+	}
+
+	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
+	if (drvdata == NULL) {
+		r = -ENOMEM;
+		goto done;
+	}
+
+	strlcpy(drvdata->name, sw->name, sizeof(drvdata->name));
+	drvdata->gpio = sw->gpio;
+	drvdata->flags = sw->flags;
+	drvdata->type = sw->type;
+	drvdata->debounce_rising = sw->debounce_rising;
+	drvdata->debounce_falling = sw->debounce_falling;
+	drvdata->notify = sw->notify;
+	drvdata->notify_data = sw->notify_data;
+
+	r = new_switch(drvdata);
+	if (r < 0) {
+		kfree(drvdata);
+		goto done;
+	}
+
+	report_initial_state(drvdata);
+
+done:
+	mutex_unlock(&gpio_switches_mutex);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(gpio_switch_request);
+
+/**
+ * gpio_switch_free - remove a GPIO switch
+ * @gpio: the GPIO switch to remove
+ */
+void gpio_switch_free(unsigned gpio)
+{
+	struct gpio_sw *sw;
+
+	mutex_lock(&gpio_switches_mutex);
+	sw = find_switch(gpio, NULL);
+	if (sw != NULL) {
+		list_del(&sw->node);
+		free_switch(sw);
+	}
+	mutex_unlock(&gpio_switches_mutex);
+}
+EXPORT_SYMBOL_GPL(gpio_switch_free);
+
+static int add_switches(const struct gpio_switch **switches, unsigned count)
+{
+	unsigned i;
+	int ret = 0;
+
+	for (i = 0; i < count; i++) {
+		ret = gpio_switch_request(switches[i]);
+		if (ret) {
+			while (--i >= 0)
+				gpio_switch_free(switches[i]->gpio);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int __init gpio_switch_probe(struct platform_device *pdev)
+{
+	struct gpio_switch_platform_data *pdata;
+	int ret;
+
+	dbg_dev = &pdev->dev;
+
+	dev_dbg(dbg_dev, "GPIO switch handler initializing\n");
+
+	pdata = pdev->dev.platform_data;
+	if (pdata != NULL) {
+		ret = add_switches(pdata->switches, pdata->count);
+		if (ret) {
+			dev_err(dbg_dev, "could not add GPIO switches\n");
+			goto err_addsw;
+		}
+	}
+
+	dev_info(dbg_dev, "GPIO switch handler initialized\n");
+
+	return 0;
+
+err_addsw:
+	return ret;
+}
+
+static int __exit gpio_switch_remove(struct platform_device *pdev)
+{
+	free_switches();
+
+	return 0;
+}
+
+static struct platform_device gpio_switch_device = {
+	.name	= "gpio-switch",
+	.id	= -1,
+};
+
+static struct platform_driver gpio_switch_driver = {
+	.driver		= {
+		.name	= "gpio-switch",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= gpio_switch_probe,
+	.remove		= __exit_p(gpio_switch_remove),
+};
+
+static int __init gpio_switch_init(void)
+{
+	/* FIXME: don't register device if it's been done in board
+	 * file - how to accomplish? now assuming failure means it's
+	 * been registered already, which isn't the way to go. */
+	platform_device_register(&gpio_switch_device);
+
+	return platform_driver_register(&gpio_switch_driver);
+}
+module_init(gpio_switch_init);
+
+static void __exit gpio_switch_exit(void)
+{
+	/* FIXME: platform_device_unregister if registered in init. */
+	platform_driver_unregister(&gpio_switch_driver);
+}
+module_exit(gpio_switch_exit);
+
+MODULE_AUTHOR("Juha Yrjölä <juha.yrjola@nokia.com>, "
+	"Paul Mundt <paul.mundt@nokia.com, "
+	"Jani Nikula <ext-jani.1.nikula@nokia.com>");
+MODULE_DESCRIPTION("GPIO switch driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/gpio-switch.h b/include/linux/gpio-switch.h
new file mode 100644
index 0000000..ac432cc
--- /dev/null
+++ b/include/linux/gpio-switch.h
@@ -0,0 +1,74 @@
+/*
+ * GPIO switch definitions
+ *
+ * Copyright (C) 2006,2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ */
+
+#ifndef __GPIO_SWITCH_H
+#define __GPIO_SWITCH_H
+
+#include <linux/types.h>
+
+/* Cover:
+ *	high -> closed
+ *	low  -> open
+ * Connection:
+ *	high -> connected
+ *	low  -> disconnected
+ * Activity:
+ *	high -> active
+ *	low  -> inactive
+ *
+ */
+#define GPIO_SWITCH_TYPE_COVER			0x0000
+#define GPIO_SWITCH_TYPE_CONNECTION		0x0001
+#define GPIO_SWITCH_TYPE_ACTIVITY		0x0002
+#define GPIO_SWITCH_FLAG_INVERTED		0x0001
+#define GPIO_SWITCH_FLAG_OUTPUT			0x0002
+#define GPIO_SWITCH_FLAG_OUTPUT_INIT_HIGH	0x0004
+
+struct gpio_switch {
+	const char *name;
+	s16 gpio;
+	unsigned flags:4;
+	unsigned type:4;
+
+	/* Time in ms to debounce when transitioning from
+	 * inactive state to active state. */
+	u16 debounce_rising;
+	/* Same for transition from active to inactive state. */
+	u16 debounce_falling;
+
+	/* Callback for state changes */
+	void (*notify)(void *data, int state);
+	void *notify_data;
+};
+
+struct gpio_switch_platform_data {
+	const struct gpio_switch **switches;
+	unsigned count;
+};
+
+#if defined(CONFIG_GPIO_SWITCH) || defined(CONFIG_GPIO_SWITCH_MODULE)
+
+extern int gpio_switch_request(const struct gpio_switch *sw);
+extern void gpio_switch_free(unsigned gpio);
+
+#else
+
+static inline int gpio_switch_request(const struct gpio_switch *sw)
+{
+	return -EINVAL;
+}
+
+static inline void gpio_switch_free(unsigned gpio)
+{
+}
+
+#endif /* defined(CONFIG_GPIO_SWITCH) || defined(CONFIG_GPIO_SWITCH_MODULE) */
+
+#endif
-- 
1.6.0.4

