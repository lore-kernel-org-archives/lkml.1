Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZIHKIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZIHKIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZIHKIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:08:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57387 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZIHKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:08:38 -0400
Date: Tue, 08 Sep 2009 19:03:43 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH] HAPTIC: add HAPTIC class
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kmpark@infradead.org, dg77.kim@samsung.com,
       soni.trilok@gmail.com
Message-id: <4AA62BFF.2050703@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 08 Sep 2009 10:03:44.0020 (UTC)
 FILETIME=[A61F8D40:01CA306B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for HAPTIC framework.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
---
I post this patch instead of Kyungmin Park.
Maybe Kyungmin will make a description of the patch in the concrete.

 arch/arm/Kconfig              |    2 +
 drivers/Kconfig               |    2 +
 drivers/Makefile              |    1 +
 drivers/haptic/Kconfig        |   14 ++++
 drivers/haptic/Makefile       |    2 +
 drivers/haptic/haptic-class.c |  165 +++++++++++++++++++++++++++++++++++++++++
 drivers/haptic/haptic.h       |   35 +++++++++
 include/linux/haptic.h        |   66 ++++++++++++++++
 8 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 drivers/haptic/Kconfig
 create mode 100644 drivers/haptic/Makefile
 create mode 100644 drivers/haptic/haptic-class.c
 create mode 100644 drivers/haptic/haptic.h
 create mode 100644 include/linux/haptic.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aef63c8..86f0ef8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1463,6 +1463,8 @@ source "drivers/accessibility/Kconfig"
 
 source "drivers/leds/Kconfig"
 
+source "drivers/haptic/Kconfig"
+
 source "drivers/rtc/Kconfig"
 
 source "drivers/dma/Kconfig"
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..a44348e 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -90,6 +90,8 @@ source "drivers/memstick/Kconfig"
 
 source "drivers/leds/Kconfig"
 
+source "drivers/haptic/Kconfig"
+
 source "drivers/accessibility/Kconfig"
 
 source "drivers/infiniband/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index bc4205d..29d3419 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -93,6 +93,7 @@ obj-y				+= idle/
 obj-$(CONFIG_MMC)		+= mmc/
 obj-$(CONFIG_MEMSTICK)		+= memstick/
 obj-$(CONFIG_NEW_LEDS)		+= leds/
+obj-$(CONFIG_HAPTIC)		+= haptic/
 obj-$(CONFIG_INFINIBAND)	+= infiniband/
 obj-$(CONFIG_SGI_SN)		+= sn/
 obj-y				+= firmware/
diff --git a/drivers/haptic/Kconfig b/drivers/haptic/Kconfig
new file mode 100644
index 0000000..fdbaa5c
--- /dev/null
+++ b/drivers/haptic/Kconfig
@@ -0,0 +1,14 @@
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
index 0000000..39a488f
--- /dev/null
+++ b/drivers/haptic/haptic-class.c
@@ -0,0 +1,165 @@
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
+
+static void haptic_update_value(struct haptic_classdev *haptic_cdev)
+{
+	if (haptic_cdev->get)
+		haptic_cdev->value = haptic_cdev->get(haptic_cdev);
+}
+
+static ssize_t haptic_value_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
+	ssize_t ret = 0;
+
+	/* no lock needed for this */
+	haptic_update_value(haptic_cdev);
+	sprintf(buf, "%u\n", haptic_get_value(haptic_cdev));
+	ret = strlen(buf) + 1;
+
+	return ret;
+}
+
+static ssize_t haptic_value_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct haptic_classdev *haptic_cdev = dev_get_drvdata(dev);
+	ssize_t ret = -EINVAL;
+	char *after;
+	unsigned long state = simple_strtoul(buf, &after, 10);
+	size_t count = after - buf;
+
+	if (*after && isspace(*after))
+		count++;
+
+	if (count == size) {
+		ret = count;
+		haptic_set_value(haptic_cdev, state);
+	}
+
+	return ret;
+}
+
+static DEVICE_ATTR(value, 0644, haptic_value_show, haptic_value_store);
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
+	ret = device_create_file(haptic_cdev->dev, &dev_attr_value);
+	if (ret)
+		goto err_out;
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
+
+err_out:
+	device_unregister(haptic_cdev->dev);
+	return ret;
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
+	device_remove_file(haptic_cdev->dev, &dev_attr_value);
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
+	return 0;
+}
+subsys_initcall(haptic_init);
+
+static void __exit haptic_exit(void)
+{
+	class_destroy(haptic_class);
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
index 0000000..34160fd
--- /dev/null
+++ b/include/linux/haptic.h
@@ -0,0 +1,66 @@
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
1.6.0.4
