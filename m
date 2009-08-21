Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZHUB4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZHUB4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 21:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbZHUBz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 21:55:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:57482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZHUBz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 21:55:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,247,1249282800"; 
   d="scan'208";a="719068173"
Subject: Re: [RFC] [PATCH v3 1/2] introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <20090819160144.GB1020@kroah.com>
References: <1250671229.17853.51.camel@rzhang-dt>
	 <20090819160144.GB1020@kroah.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Aug 2009 09:54:07 +0800
Message-Id: <1250819647.17853.144.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 00:01 +0800, Greg KH wrote:
> On Wed, Aug 19, 2009 at 04:40:29PM +0800, Zhang Rui wrote:
> > --- /dev/null
> > +++ linux-2.6/Documentation/ABI/testing/sysfs-class-als
> > @@ -0,0 +1,137 @@
> > +Ambient Light Sensor Sysfs driver How To
> > +=========================
> 
> <snip>
> 
> While this is a nice document, it does not follow the standard that the
> files in Documentation/ABI/ should be in.  Can you please read
> Documentation/ABI/README and convert the file to follow that?
> 
sure. done
refreshed patch attached.

﻿Introduce ALS sysfs class device.

ALS sysfs class device provides a standard sysfs interface
for Ambient Light Sensor devices.

please read Documentation/ABI/testing/sysfs-class-als for detailed sysfs
designs.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 Documentation/ABI/testing/sysfs-class-als |   47 +++++
 drivers/Kconfig                           |    2 
 drivers/Makefile                          |    1 
 drivers/als/Kconfig                       |   10 +
 drivers/als/Makefile                      |    5 
 drivers/als/als_sys.c                     |  256 ++++++++++++++++++++++++++++++
 include/linux/als_sys.h                   |   57 ++++++
 7 files changed, 378 insertions(+)

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
+# Makefile for sensor chip drivers.
+#
+
+obj-$(CONFIG_ALS)		+= als_sys.o
Index: linux-2.6/drivers/als/als_sys.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/als/als_sys.c
@@ -0,0 +1,256 @@
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
+struct als_mapping_item {
+	struct kobject kobj;
+	int index;
+	struct list_head node;
+};
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
+static struct device_attribute als_attrs[] = {
+	__ATTR(desc, 0444, desc_show, NULL),
+	__ATTR(illuminance, 0444, illuminance_show, NULL),
+	__ATTR_NULL,
+};
+
+static void als_release(struct device *dev)
+{
+	struct als_device *als = to_als_device(dev);
+	struct als_mapping_item *pos, *n;
+
+	if (als->desc)
+		kfree(als->desc);
+	list_for_each_entry_safe(pos, n, &als->mappings, node){
+		list_del(&pos->node);
+		kfree(pos);
+	}
+	kfree(als);
+}
+
+static struct class als_class = {
+	.name = "als",
+	.dev_release = als_release,
+	.dev_attrs = als_attrs,
+};
+
+#define ATTR(_name, _mode)      \
+	struct attribute als_##_name##_attr = {               \
+	.name = __stringify(_name), .mode = _mode, \
+	};
+
+static ATTR(illuminance, 0444);
+static ATTR(adjustment, 0444);
+
+static struct attribute * als_mapping_attrs[] = {
+	&als_illuminance_attr,
+	&als_adjustment_attr,
+	NULL,
+};
+
+static ssize_t show_mapping_info(struct kobject *kobj,
+				       struct attribute *attr, char *buf)
+{
+	struct device *dev = container_of(kobj->parent, struct device, kobj);
+	struct als_device *als = to_als_device(dev);
+	int index, illuminance, adjustment;
+	int result;
+
+	if (!sscanf(kobj->name, "mapping%d", &index))
+		return -EINVAL;
+
+	result = als->ops->get_mapping_info(als, index, &illuminance, &adjustment);
+	if (result)
+		return result;
+
+	return sprintf(buf, "%u\n", (attr == &als_illuminance_attr) ? illuminance : adjustment);
+}
+
+static struct sysfs_ops als_mapping_info_ops = {
+	.show = show_mapping_info,
+	.store = NULL,
+};
+
+static struct kobj_type als_mapping_ktype = {
+	.sysfs_ops = &als_mapping_info_ops,
+	.default_attrs = als_mapping_attrs,
+};
+
+/**
+ * als_device_update_mappings - update the ambient light illuminance to
+ * 				display luminance adjustment mappings
+ */
+int als_device_update_mappings(struct als_device *als, int count)
+{
+	int old_count = als->count;
+	int i;
+	struct als_mapping_item *pos, *next;
+	int result;
+
+	als->count = count;
+	if (old_count == als->count)
+		return 0;
+
+	mutex_lock(&als->lock);
+	if (als->count > old_count)
+		for (i = old_count; i < als->count; i++) {
+			pos = kzalloc(sizeof(struct als_mapping_item), GFP_KERNEL);
+			if (!pos)
+				return -ENOMEM;
+
+			pos->index = i;
+			result = kobject_init_and_add(&pos->kobj, &als_mapping_ktype,
+					&als->device.kobj, "mapping%d", pos->index);
+			if (result)
+				break;
+			list_add_tail(&pos->node, &als->mappings);
+		}
+	else
+		list_for_each_entry_safe(pos, next, &als->mappings, node) {
+			if (pos->index < als->count)
+				continue;
+			list_del(&pos->node);
+			kobject_put(&pos->kobj);
+			kfree(pos);
+		}
+
+	if (result)
+		als->count = i;
+	mutex_unlock(&als->lock);
+	return 0;
+}
+
+EXPORT_SYMBOL(als_device_update_mappings);
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
+	int result;
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
+	INIT_LIST_HEAD(&als->mappings);
+	mutex_init(&als->lock);
+	if (desc) {
+		als->desc = kzalloc(strlen(desc), GFP_KERNEL);
+		if (!als->desc) {
+			kfree(als);
+			return ERR_PTR(-ENOMEM);
+		}
+		strcpy(als->desc, desc);
+	}
+	dev_set_name(&als->device, "als%d", als->id);
+	result = device_register(&als->device);
+	if (result) {
+		if (als->desc)
+			kfree(als->desc);
+		kfree(als);
+		return ERR_PTR(result);
+	}
+
+	return als;
+}
+
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
+
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
@@ -0,0 +1,57 @@
+/*
+ *  als.h  ($Revision: 0 $)
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
+	int (*get_mapping_info) (struct als_device *, int, int *, int *);
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
+	struct list_head mappings;
+	struct mutex lock;
+};
+
+int als_device_update_mappings(struct als_device *, int);
+struct als_device *als_device_register(struct als_device_ops *, char *, void *);
+void als_device_unregister(struct als_device *);
+
+#endif /* __ALS_SYS_H__ */
Index: linux-2.6/Documentation/ABI/testing/sysfs-class-als
===================================================================
--- /dev/null
+++ linux-2.6/Documentation/ABI/testing/sysfs-class-als
@@ -0,0 +1,47 @@
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
+What:		/sys/class/als/als[0-N]/mapping[0-N]
+Date:		Aug. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	represent one item of the Ambient Light Illuminance
+		to Display Luminance Adjustment mappings.
+
+What:		/sys/class/als/als[0-N]/mapping[0-N]/illuminance
+Date:		Aug. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	ambient light illuminance threshold when a display
+		luminance(backlight) adjustment is needed.
+		RO
+
+What:		/sys/class/als/als[0-N]/mapping[0-N]/adjustment
+Date:		Aug. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	a relative percentages in order simplify the means
+		by which these adjustments are applied in lieu of
+		changes to the user’s display brightness preference.
+		A value of 100 is used to indicate no (0%) display
+		brightness adjustment.
+		Values less than 100 indicate a negative adjustment
+		(dimming); values greater than 100 indicate a positive
+		adjustment (brightening).
+		RO
+



