Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZHYHTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZHYHTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZHYHTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:19:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:36768 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbZHYHTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:19:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="487085830"
Subject: [PATCH V4 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2009 15:18:13 +0800
Message-Id: <1251184693.3483.95.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


﻿Introduce ALS sysfs class.

ALS sysfs class provides a standard sysfs interface for
Ambient Light Sensor devices.

please read Documentation/ABI/testing/sysfs-class-als for
detailed sysfs designs.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/ABI/testing/sysfs-class-als |   32 ++++
 drivers/Kconfig                           |    2 
 drivers/Makefile                          |    1 
 drivers/als/Kconfig                       |   10 +
 drivers/als/Makefile                      |    5 
 drivers/als/als_sys.c                     |  220 ++++++++++++++++++++++++++++++
 include/linux/als_sys.h                   |   55 +++++++
 7 files changed, 325 insertions(+)

Index: linux-2.6/drivers/Kconfig
===================================================================
--- linux-2.6.orig/drivers/Kconfig
+++ linux-2.6/drivers/Kconfig
@@ -62,6 +62,8 @@ source "drivers/power/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/als/Kconfig"
+
 source "drivers/thermal/Kconfig"
 
 source "drivers/watchdog/Kconfig"
Index: linux-2.6/drivers/Makefile
===================================================================
--- linux-2.6.orig/drivers/Makefile
+++ linux-2.6/drivers/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_PPS)		+= pps/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
+obj-$(CONFIG_ALS)		+= als/
 obj-$(CONFIG_THERMAL)		+= thermal/
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
Index: linux-2.6/drivers/als/Kconfig
===================================================================
--- /dev/null
+++ linux-2.6/drivers/als/Kconfig
@@ -0,0 +1,10 @@
+#
+# Ambient Light Sensor sysfs device configuration
+#
+
+menuconfig ALS
+	tristate "Ambient Light Sensor sysfs device"
+	help
+	  This framework provides a generic sysfs interface for
+	  Ambient Light Sensor devices.
+	  If you want this support, you should say Y or M here.
Index: linux-2.6/drivers/als/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/drivers/als/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for Ambient Light Sensor device drivers.
+#
+
+obj-$(CONFIG_ALS)		+= als_sys.o
Index: linux-2.6/drivers/als/als_sys.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/als/als_sys.c
@@ -0,0 +1,220 @@
+/*
+ *  als_sys.c - Ambient Light Sensor Sysfs support.
+ *
+ *  Copyright (C) 2009 Intel Corp
+ *  Copyright (C) 2009 Zhang Rui <rui.zhang@intel.com>
+ *
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/als_sys.h>
+
+MODULE_AUTHOR("Zhang Rui");
+MODULE_DESCRIPTION("Ambient Light Sensor sysfs support");
+MODULE_LICENSE("GPL");
+
+static int als_get_adjustment(struct als_device *, int, int *);
+
+/* sys I/F for Ambient Light Sensor */
+
+#define to_als_device(dev) container_of(dev, struct als_device, device)
+
+static ssize_t
+desc_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct als_device *als = to_als_device(dev);
+
+	return sprintf(buf, "%s\n", als->desc ? als->desc : "N/A");
+}
+
+static ssize_t
+illuminance_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct als_device *als = to_als_device(dev);
+	int illuminance;
+	int result;
+
+	result = als->ops->get_illuminance(als, &illuminance);
+	if (result)
+		return result;
+
+	if (!illuminance)
+		return sprintf(buf, "Illuminance below the supported range\n");
+	else if (illuminance == -1)
+		return sprintf(buf, "Illuminance above the supported range\n");
+	else if (illuminance < -1)
+		return -ERANGE;
+	else
+		return sprintf(buf, "%d\n", illuminance);
+}
+
+static ssize_t
+adjustment_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct als_device *als = to_als_device(dev);
+	int illuminance, adjustment;
+	int result;
+
+	result = als->ops->get_illuminance(als, &illuminance);
+	if (result)
+		return result;
+
+	if (illuminance < 0 && illuminance != -1)
+		return sprintf(buf, "Current illuminance invalid\n");
+
+	result = als_get_adjustment(als, illuminance, &adjustment);
+	if (result)
+		return result;
+
+	return sprintf(buf, "%d%%\n", adjustment);
+}
+
+static struct device_attribute als_attrs[] = {
+	__ATTR(desc, 0444, desc_show, NULL),
+	__ATTR(illuminance, 0444, illuminance_show, NULL),
+	__ATTR(display_adjustment, 0444, adjustment_show, NULL),
+	__ATTR_NULL,
+};
+
+static void als_release(struct device *dev)
+{
+	struct als_device *als = to_als_device(dev);
+
+	kfree(als->desc);
+	kfree(als);
+}
+
+static struct class als_class = {
+	.name = "als",
+	.dev_release = als_release,
+	.dev_attrs = als_attrs,
+};
+
+static int als_get_adjustment(struct als_device *als, int illuminance,
+			      int *adjustment)
+{
+	int lux_high, lux_low, adj_high, adj_low;
+	int i;
+
+	if (!als->mappings)
+		return -EINVAL;
+
+	if (illuminance == -1
+	    || illuminance > als->mappings[als->count].illuminance)
+		illuminance = als->mappings[als->count].illuminance;
+	else if (illuminance < als->mappings[0].illuminance)
+		illuminance = als->mappings[0].illuminance;
+
+	for (i = 0; i < als->count; i++) {
+		if (illuminance == als->mappings[i].illuminance) {
+			*adjustment = als->mappings[i].adjustment;
+			return 0;
+		}
+
+		if (illuminance > als->mappings[i].illuminance)
+			continue;
+
+		lux_high = als->mappings[i].illuminance;
+		lux_low = als->mappings[i - 1].illuminance;
+		adj_high = als->mappings[i].adjustment;
+		adj_low = als->mappings[i - 1].adjustment;
+
+		*adjustment =
+		    ((adj_high - adj_low) / (lux_high -
+					     lux_low)) * (illuminance -
+							  lux_low) + adj_low;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/**
+ * als_device_register - register a new Ambient Light Sensor class device
+ * @ops:	standard ALS devices callbacks.
+ * @devdata:	device private data.
+ */
+struct als_device *als_device_register(struct als_device_ops *ops,
+				       char *desc, void *devdata)
+{
+	struct als_device *als;
+	static int als_id;
+	int result = -ENOMEM;
+
+	if (!ops || !ops->get_illuminance)
+		return ERR_PTR(-EINVAL);
+
+	als = kzalloc(sizeof(struct als_device), GFP_KERNEL);
+	if (!als)
+		return ERR_PTR(-ENOMEM);
+
+	als->ops = ops;
+	als->device.class = &als_class;
+	als->devdata = devdata;
+	als->id = als_id++;
+	if (desc) {
+		als->desc = kzalloc(strlen(desc), GFP_KERNEL);
+		if (!als->desc)
+			goto err;
+		strcpy(als->desc, desc);
+	}
+	dev_set_name(&als->device, "als%d", als->id);
+	result = device_register(&als->device);
+	if (result)
+		goto err;
+
+	if (ops->update_mappings) {
+		result = ops->update_mappings(als);
+		if (result) {
+			device_unregister(&als->device);
+			goto err;
+		}
+	}
+	return als;
+
+err:
+	kfree(als->desc);
+	kfree(als);
+	return ERR_PTR(result);
+}
+EXPORT_SYMBOL(als_device_register);
+
+/**
+ * als_device_unregister - removes the registered ALS device
+ * @als:	the ALS device to remove.
+ */
+void als_device_unregister(struct als_device *als)
+{
+	device_unregister(&als->device);
+}
+EXPORT_SYMBOL(als_device_unregister);
+
+static int __init als_init(void)
+{
+	return class_register(&als_class);
+}
+
+static void __exit als_exit(void)
+{
+	class_unregister(&als_class);
+}
+
+subsys_initcall(als_init);
+module_exit(als_exit);
Index: linux-2.6/include/linux/als_sys.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/als_sys.h
@@ -0,0 +1,55 @@
+/*
+ *  als.h
+ *
+ *  Copyright (C) 2009  Intel Corp
+ *  Copyright (C) 2009  Zhang Rui <rui.zhang@intel.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#ifndef __ALS_SYS_H__
+#define __ALS_SYS_H__
+
+#include <linux/device.h>
+
+struct als_device;
+
+struct als_device_ops {
+	int (*get_illuminance) (struct als_device *, int *);
+	int (*update_mappings) (struct als_device *);
+};
+
+struct als_mapping {
+	int illuminance;
+	int adjustment;
+};
+
+struct als_device {
+	int id;
+	int illuminance;
+	struct device device;
+	struct als_device_ops *ops;
+	void *devdata;
+	char *desc;
+	int count;
+	struct als_mapping *mappings;
+};
+
+struct als_device *als_device_register(struct als_device_ops *, char *, void *);
+void als_device_unregister(struct als_device *);
+
+#endif /* __ALS_SYS_H__ */
Index: linux-2.6/Documentation/ABI/testing/sysfs-class-als
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/ABI/testing/sysfs-class-als
@@ -0,0 +1,32 @@
+What:		/sys/class/als/als[0-N]/desc
+Date:		Aug. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	Strings which descibes the current Ambient Light Sensor
+		device. This is given by native ALS driver as part of
+		registration. e.g: "acpi_als" for ACPI ALS devices.
+		RO
+
+What:		/sys/class/als/als[0-N]/illuminance
+Date:		Aug. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	Current Ambient Light Illuminance reported by
+		native ALS driver
+		Unit: lux (lumens per square meter)
+		RO
+
+What:		/sys/class/als/als[0-N]/display_adjustment
+Date:		Aug. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	a relative percentages in order simplify the means
+		by which these adjustments are applied in lieu of
+		changes to the user’s display brightness preference.
+		A value of 100% is used to indicate no display
+		brightness adjustment.
+		Values less than 100% indicate a negative adjustment
+		(dimming); values greater than 100% indicate a positive
+		adjustment (brightening).
+		RO
+


