Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZJGG2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZJGG2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 02:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZJGG2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 02:28:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57724 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZJGG23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 02:28:29 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 02:28:28 EDT
Date: Wed, 07 Oct 2009 15:17:01 +0900
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/6] Haptic: add haptic class
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com
Message-id: <20091007061701.GA7567@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 07 Oct 2009 06:17:07.0566 (UTC)
 FILETIME=[CBFC10E0:01CA4715]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New haptic class support.
This class handles the haptic devices.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/haptic/Kconfig        |   14 +++
 drivers/haptic/Makefile       |    2 +
 drivers/haptic/haptic-class.c |  255 +++++++++++++++++++++++++++++++++++++++++
 drivers/haptic/haptic.h       |   35 ++++++
 include/linux/haptic.h        |   85 ++++++++++++++
 5 files changed, 391 insertions(+), 0 deletions(-)
 create mode 100644 drivers/haptic/Kconfig
 create mode 100644 drivers/haptic/Makefile
 create mode 100644 drivers/haptic/haptic-class.c
 create mode 100644 drivers/haptic/haptic.h
 create mode 100644 include/linux/haptic.h

diff --git a/drivers/haptic/Kconfig b/drivers/haptic/Kconfig
new file mode 100644
index 0000000..656b022
--- /dev/null
+++ b/drivers/haptic/Kconfig
@@ -0,0 +1,14 @@
+menuconfig HAPTIC
+	bool "Haptic support"
+	help
+	  Say Y to enable haptic support. It enables the haptic and controls
+	  from userspace.
+
+if HAPTIC
+
+config HAPTIC_CLASS
+	tristate "Haptic Class Support"
+	help
+	  This option enables the haptic sysfs class in /sys/class/haptic.
+
+endif	# HAPTIC
diff --git a/drivers/haptic/Makefile b/drivers/haptic/Makefile
new file mode 100644
index 0000000..d30f8cd
--- /dev/null
+++ b/drivers/haptic/Makefile
@@ -0,0 +1,2 @@
+# Haptic Core
+obj-$(CONFIG_HAPTIC_CLASS)		+= haptic-class.o
diff --git a/drivers/haptic/haptic-class.c b/drivers/haptic/haptic-class.c
new file mode 100644
index 0000000..d2151bc
--- /dev/null
+++ b/drivers/haptic/haptic-class.c
@@ -0,0 +1,255 @@
+/*
+ *  Haptic Class Core
+ *
+ *  Copyright (C) 2008 - 2009 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
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
+ * haptic_classdev_unregister - unregisters a object of haptic class.
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
-- 
1.5.3.3

