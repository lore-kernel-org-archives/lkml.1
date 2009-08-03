Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZHCJLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZHCJLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZHCJLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:11:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:23721 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZHCJLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:11:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,313,1246863600"; 
   d="scan'208";a="480198950"
Subject: [PATCH 2/3 RFC] ALS: introduce ALS sysfs class
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:11:15 +0800
Message-Id: <1249290675.2670.253.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce ALS sysfs class device.

ALS sysfs class device provides a standard sysfs interface
for Ambient Light Sensor devices.

Only two sysfs I/F are introduced currently.
/sys/class/als/alsX/illuminance:
	indicates the amount of light incident upon a specified surface area.
/sys/class/als/alsX/mappings:
	exports ambient light illuminance to display luminance mappings
	that can be used by an OS to calibrate its ambient light policy
	for a given sensor configuration.
	The OS can use this information to extrapolate an ALS response curve
	- noting that these values may be treated differently depending on the
	OS implementation but should be used in some form to calibrate ALS policy.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/Kconfig         |    2 
 drivers/Makefile        |    1 
 drivers/als/Kconfig     |   10 ++
 drivers/als/Makefile    |    5 +
 drivers/als/als_sys.c   |  206 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/als_sys.h |   55 ++++++++++++
 6 files changed, 279 insertions(+)

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
+	  This framework provides a generic sysfs I/F for Ambient Light
+	  Sensor devices.
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
@@ -0,0 +1,206 @@
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
+#define PREFIX "ALS: "
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
+	int result;
+
+	if (!als->ops->get_illuminance)
+		return -EPERM;
+
+	result = als->ops->get_illuminance(als);
+	if (result)
+		return result;
+
+	if (!als->illuminance)
+		return sprintf(buf, "Illuminance below the supported range\n");
+	else if (als->illuminance == -1)
+		return sprintf(buf, "Illuminance above the supported range\n");
+	else if (als->illuminance < -1)
+		return -ERANGE;
+	else
+		return sprintf(buf, "%d\n", als->illuminance);
+}
+
+static ssize_t
+mappings_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct als_device *als = to_als_device(dev);
+	int count;
+	int result;
+
+	if (!als->ops->get_mappings)
+		return -EPERM;
+
+	result = als->ops->get_mappings(als);
+	if (result)
+		return result;
+
+	result = sprintf(buf, "Illuminance	Adjustment\n");
+	for (count = 0; count < als->count; count++) {
+		result += sprintf(buf + result, "%11d\t",
+				  als->mappings[count].illuminance);
+		result += sprintf(buf + result, "%10d\n",
+				  als->mappings[count].adjustment);
+	}
+
+	return result;
+}
+
+static DEVICE_ATTR(desc, 0444, desc_show, NULL);
+static DEVICE_ATTR(illuminance, 0444, illuminance_show, NULL);
+static DEVICE_ATTR(mappings, 0444, mappings_show, NULL);
+
+static void als_release(struct device *dev)
+{
+	struct als_device *als = to_als_device(dev);
+
+	if (als->desc)
+		kfree(als->desc);
+	kfree(als);
+}
+
+static struct class als_class = {
+	.name = "als",
+	.dev_release = als_release,
+};
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
+	if (!ops || !ops->get_illuminance || !ops->get_mappings)
+		return ERR_PTR(-EINVAL);
+
+	als = kzalloc(sizeof(struct als_device), GFP_KERNEL);
+	if (!als)
+		return ERR_PTR(-ENOMEM);
+
+	als->ops = ops;
+	als->device.class = &als_class;
+	als->devdata = devdata;
+	if (desc) {
+		als->desc = kzalloc(strlen(desc), GFP_KERNEL);
+		if (!als->desc) {
+			kfree(als);
+			return ERR_PTR(-ENOMEM);
+		}
+		strcpy(als->desc, desc);
+	}
+	als->id = als_id++;
+	dev_set_name(&als->device, "als%d", als->id);
+	result = device_register(&als->device);
+	if (result) {
+		if (als->desc)
+			kfree(als->desc);
+		kfree(als);
+		return ERR_PTR(result);
+	}
+
+	/* sys I/F */
+	result = device_create_file(&als->device, &dev_attr_illuminance);
+	if (result)
+		goto unregister_device;
+
+	result = device_create_file(&als->device, &dev_attr_mappings);
+	if (result)
+		goto unregister_device;
+
+	result = device_create_file(&als->device, &dev_attr_desc);
+	if (result)
+		goto unregister_device;
+
+	return als;
+
+unregister_device:
+	device_unregister(&als->device);
+	return ERR_PTR(result);
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
+	if (!als)
+		return;
+
+	device_remove_file(&als->device, &dev_attr_desc);
+	device_remove_file(&als->device, &dev_attr_mappings);
+	device_remove_file(&als->device, &dev_attr_illuminance);
+
+	device_unregister(&als->device);
+	return;
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
@@ -0,0 +1,55 @@
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
+struct als_mapping {
+	int illuminance;
+	int adjustment;
+};
+
+struct als_device_ops {
+	int (*get_mappings) (struct als_device *);
+	int (*get_illuminance) (struct als_device *);
+};
+
+struct als_device {
+	int id;
+	int illuminance;
+	struct device device;
+	struct als_device_ops *ops;
+	void *devdata;
+	int count;
+	struct als_mapping *mappings;
+	char *desc;
+};
+
+struct als_device *als_device_register(struct als_device_ops *, char *, void *);
+void als_device_unregister(struct als_device *);
+
+#endif /* __ALS_SYS_H__ */


