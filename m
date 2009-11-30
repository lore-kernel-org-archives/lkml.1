Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbZK3Lqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbZK3Lqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZK3Lqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:46:33 -0500
Received: from smtp.nokia.com ([192.100.105.134]:55422 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZK3Lqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:46:32 -0500
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rui.zhang@intel.com, jic23@cam.ac.uk, khali@linux-fr.org,
       alan@linux.intel.com, linux-acpi@vger.kernel.org, gregkh@suse.de
Subject: [PATCH 1/2] introduce ALS sysfs class
Date: Mon, 30 Nov 2009 13:46:28 +0200
Message-Id: <1259581588-16053-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259581514-15356-1-git-send-email-amit.kucheria@verdurent.com>
References: <1259581514-15356-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 30 Nov 2009 11:46:20.0822 (UTC) FILETIME=[BC263B60:01CA71B2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

This is a refresh of the ALS sysfs class driver.

ALS sysfs class device provides a standard sysfs interface
for Ambient Light Sensor devices.

Only one sysfs I/F is introduced currently.
/sys/class/als/xxx/illuminance:
	indicates the amount of light incident upon a specified surface area.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Acked-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 Documentation/ABI/testing/sysfs-class-als |    9 ++++
 MAINTAINERS                               |    6 ++
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/als/Kconfig                       |   10 ++++
 drivers/als/Makefile                      |    5 ++
 drivers/als/als_sys.c                     |   74 +++++++++++++++++++++++++++++
 include/linux/als_sys.h                   |   35 ++++++++++++++
 8 files changed, 142 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-als
 create mode 100644 drivers/als/Kconfig
 create mode 100644 drivers/als/Makefile
 create mode 100644 drivers/als/als_sys.c
 create mode 100644 include/linux/als_sys.h

diff --git a/Documentation/ABI/testing/sysfs-class-als b/Documentation/ABI/testing/sysfs-class-als
new file mode 100644
index 0000000..d3b33f3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-als
@@ -0,0 +1,9 @@
+What:		/sys/class/als/.../illuminance
+Date:		Sep. 2009
+KernelVersion:	2.6.32
+Contact:	Zhang Rui <rui.zhang@intel.com>
+Description:	Current Ambient Light Illuminance reported by
+		native ALS driver
+		Unit: lux (lumens per square meter)
+		RO
+
diff --git a/MAINTAINERS b/MAINTAINERS
index c824b4d..0894a1c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -409,6 +409,12 @@ S:	Maintained for 2.4; PCI support for 2.6.
 L:	linux-alpha@vger.kernel.org
 F:	arch/alpha/
 
+AMBIENT LIGHT SENSOR
+M:	Zhang Rui <rui.zhang@intel.com>
+S:	Supported
+F:	include/linux/als_sys.h
+F:	drivers/als/
+
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 M:	Thomas Dahlmann <dahlmann.thomas@arcor.de>
 L:	linux-geode@lists.infradead.org (moderated for non-subscribers)
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..67cf884 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -62,6 +62,8 @@ source "drivers/power/Kconfig"
 
 source "drivers/hwmon/Kconfig"
 
+source "drivers/als/Kconfig"
+
 source "drivers/thermal/Kconfig"
 
 source "drivers/watchdog/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 6ee53c7..ecb6d5d 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_PPS)		+= pps/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
+obj-$(CONFIG_ALS)		+= als/
 obj-$(CONFIG_THERMAL)		+= thermal/
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
diff --git a/drivers/als/Kconfig b/drivers/als/Kconfig
new file mode 100644
index 0000000..200c52b
--- /dev/null
+++ b/drivers/als/Kconfig
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
diff --git a/drivers/als/Makefile b/drivers/als/Makefile
new file mode 100644
index 0000000..a527197
--- /dev/null
+++ b/drivers/als/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for sensor chip drivers.
+#
+
+obj-$(CONFIG_ALS)		+= als_sys.o
diff --git a/drivers/als/als_sys.c b/drivers/als/als_sys.c
new file mode 100644
index 0000000..e1d6395
--- /dev/null
+++ b/drivers/als/als_sys.c
@@ -0,0 +1,74 @@
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
+#include <linux/kdev_t.h>
+
+MODULE_AUTHOR("Zhang Rui <rui.zhang@intel.com>");
+MODULE_DESCRIPTION("Ambient Light Sensor sysfs/class support");
+MODULE_LICENSE("GPL");
+
+static struct class *als_class;
+
+/**
+ * als_device_register - register a new Ambient Light Sensor class device
+ * @parent:	the device to register.
+ *
+ * Returns the pointer to the new device
+ */
+struct device *als_device_register(struct device *dev, char *name)
+{
+	return device_create(als_class, dev, MKDEV(0, 0), NULL, name);
+}
+EXPORT_SYMBOL(als_device_register);
+
+/**
+ * als_device_unregister - removes the registered ALS class device
+ * @dev:	the class device to destroy.
+ */
+void als_device_unregister(struct device *dev)
+{
+	device_unregister(dev);
+}
+EXPORT_SYMBOL(als_device_unregister);
+
+static int __init als_init(void)
+{
+	als_class = class_create(THIS_MODULE, "als");
+	if (IS_ERR(als_class)) {
+		printk(KERN_ERR "als_sys.c: couldn't create sysfs class\n");
+		return PTR_ERR(als_class);
+	}
+	return 0;
+}
+
+static void __exit als_exit(void)
+{
+	class_destroy(als_class);
+}
+
+subsys_initcall(als_init);
+module_exit(als_exit);
diff --git a/include/linux/als_sys.h b/include/linux/als_sys.h
new file mode 100644
index 0000000..500f300
--- /dev/null
+++ b/include/linux/als_sys.h
@@ -0,0 +1,35 @@
+/*
+ *  als_sys.h
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
+#define ALS_ILLUMINANCE_MIN 0
+#define ALS_ILLUMINANCE_MAX -1
+
+struct device *als_device_register(struct device *dev, char *name);
+void als_device_unregister(struct device *dev);
+
+#endif /* __ALS_SYS_H__ */
-- 
1.6.3.3

