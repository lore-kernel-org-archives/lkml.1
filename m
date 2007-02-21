Return-Path: <linux-kernel-owner+w=401wt.eu-S1423131AbXBUVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423131AbXBUVYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423146AbXBUVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:24:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52496 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423154AbXBUVX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:23:58 -0500
Date: Wed, 21 Feb 2007 21:23:55 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Andrew Morton <akpm@osdl.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: [PATCH]
Message-ID: <Pine.LNX.4.64.0702212105280.20620@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is the new display intreface. Its goal is to provide a standard 
interface to various types of displays. Currently we have auxdisplay, 
output acpi device and the now defunct lcd class in the backlight directory.
Please apply.

Signed-Off: James Simmons <jsimmons@infradead.org>

diff -urN -X linus-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/display-sysfs.c fbdev-2.6/drivers/video/display/display-sysfs.c
--- linus-2.6/drivers/video/display/display-sysfs.c	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/display-sysfs.c	2007-02-21 15:55:18.000000000 -0500
@@ -0,0 +1,200 @@
+/*
+ *  display-sysfs.c - Display output driver sysfs interface
+ *
+ *  Copyright (C) 2007 James Simmons <jsimmons@infradead.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
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
+#include <linux/module.h>
+#include <linux/display.h>
+#include <linux/err.h>
+#include <linux/ctype.h>
+
+static ssize_t display_show_name(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%s\n", dsp->name);
+}
+
+static ssize_t display_show_type(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%s\n", dsp->type);
+}
+
+static ssize_t display_show_contrast(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t rc = -ENXIO;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver) && dsp->driver->get_contrast)
+		rc = sprintf(buf, "%d\n", dsp->driver->get_contrast(dsp));
+	mutex_unlock(&dsp->lock);
+	return rc;
+}
+
+static ssize_t display_store_contrast(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t ret = -EINVAL, size;
+	int contrast;
+	char *endp;
+
+	contrast = simple_strtoul(buf, &endp, 0);
+	size = endp - buf;
+
+	if (*endp && isspace(*endp))
+		size++;
+
+	if (size != count)
+		return ret;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver && dsp->driver->set_contrast)) {
+		pr_debug("display: set contrast to %d\n", contrast);
+		dsp->driver->set_contrast(dsp, contrast);
+		ret = count;
+	}
+	mutex_unlock(&dsp->lock);
+	return ret;
+}
+
+static ssize_t display_show_max_contrast(struct device *dev, struct device_attribute *attr,
+					char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t rc = -ENXIO;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver))
+		rc = sprintf(buf, "%d\n", dsp->driver->max_contrast);
+	mutex_unlock(&dsp->lock);
+	return rc;
+}
+
+static struct device_attribute display_attrs[] = {
+	__ATTR(name, S_IRUGO, display_show_name, NULL),
+	__ATTR(type, S_IRUGO, display_show_type, NULL),
+	__ATTR(contrast, S_IRUGO | S_IWUSR, display_show_contrast, display_store_contrast),
+	__ATTR(max_contrast, S_IRUGO, display_show_max_contrast, NULL),
+};
+
+static int display_suspend(struct device *dev, pm_message_t state)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver->suspend))
+		dsp->driver->suspend(dsp, state);
+	mutex_unlock(&dsp->lock);
+	return 0;
+};
+
+static int display_resume(struct device *dev)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver->resume))
+		dsp->driver->resume(dsp);
+	mutex_unlock(&dsp->lock);
+	return 0;
+};
+
+struct class *display_class;
+EXPORT_SYMBOL(display_class);
+static int index;
+
+struct display_device *display_device_register(struct display_driver *driver,
+						struct device *dev, void *devdata)
+{
+	struct display_device *new_dev = NULL;
+	int ret = -EINVAL;
+
+	if (unlikely(!driver))
+		return ERR_PTR(ret);
+
+	new_dev = kzalloc(sizeof(struct display_device), GFP_KERNEL);
+	if (likely(new_dev) && unlikely(driver->probe(new_dev, devdata))) {
+		new_dev->dev = device_create(display_class, dev, 0,
+						"display%d", index);
+
+		if (!IS_ERR(new_dev->dev)) {
+			dev_set_drvdata(new_dev->dev, new_dev);
+			new_dev->driver = driver;
+			new_dev->parent = dev;
+			mutex_init(&new_dev->lock);
+			index++;
+		} else {
+			new_dev->dev = NULL;
+			kfree(new_dev);
+		}
+	}
+	return new_dev;
+}
+EXPORT_SYMBOL(display_device_register);
+
+void display_device_unregister(struct display_device *ddev)
+{
+	if (!ddev)
+		return;
+	mutex_lock(&ddev->lock);
+	device_del(ddev->dev);
+	ddev->driver = NULL;
+	index--;
+	mutex_unlock(&ddev->lock);
+	kfree(ddev);
+}
+EXPORT_SYMBOL(display_device_unregister);
+
+static int __init display_class_init(void)
+{
+	display_class = class_create(THIS_MODULE, "display");
+	if (IS_ERR(display_class)) {
+		printk(KERN_ERR "Failed to create display class\n");
+		display_class = NULL;
+		return -EINVAL;
+	}
+	display_class->dev_attrs = display_attrs;
+	display_class->suspend = display_suspend;
+	display_class->resume = display_resume;
+	return 0;
+}
+
+#ifdef MODULE
+module_init(display_class_init);
+
+static void __exit display_class_exit(void)
+{
+	class_destroy(display_class);
+}
+module_exit(display_class_exit);
+#else
+subsys_initcall(display_class_init);
+#endif
+
+MODULE_DESCRIPTION("Display Hardware handling");
+MODULE_AUTHOR("James Simmons <jsimmons@infradead.org>");
+MODULE_LICENSE("GPL");
+
diff -urN -X linus-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/Kconfig fbdev-2.6/drivers/video/display/Kconfig
--- linus-2.6/drivers/video/display/Kconfig	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/Kconfig	2007-02-21 15:56:32.000000000 -0500
@@ -0,0 +1,24 @@
+#
+# Display drivers configuration
+#
+
+menu "Display device support"
+
+config DISPLAY_SUPPORT
+	tristate "Display panel/monitor support"
+	---help---
+	  This framework adds support for low-level control of a display.
+	  This includes support for power.
+
+	  Enable this to be able to choose the drivers for controlling the
+	  physical display panel/monitor on some platforms. This not only
+	  covers LCD displays for PDAs but also other types of displays
+	  such as CRT, TVout etc.
+
+	  To have support for your specific display panel you will have to
+	  select the proper drivers which depend on this option.
+
+comment "Display hardware drivers"
+	depends on DISPLAY_SUPPORT
+
+endmenu
diff -urN -X linus-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/Makefile fbdev-2.6/drivers/video/display/Makefile
--- linus-2.6/drivers/video/display/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/Makefile	2007-02-21 15:56:22.000000000 -0500
@@ -0,0 +1,6 @@
+# Display drivers
+
+display-objs				:= display-sysfs.o
+
+obj-$(CONFIG_DISPLAY_SUPPORT)		+= display.o
+
diff -urN -X linus-2.6/Documentation/dontdiff linus-2.6/drivers/video/Kconfig fbdev-2.6/drivers/video/Kconfig
--- linus-2.6/drivers/video/Kconfig	2007-02-21 10:59:24.000000000 -0500
+++ fbdev-2.6/drivers/video/Kconfig	2007-02-21 15:55:56.000000000 -0500
@@ -5,6 +5,7 @@
 menu "Graphics support"
 
 source "drivers/video/backlight/Kconfig"
+source "drivers/video/display/Kconfig"
 
 config FB
 	tristate "Support for frame buffer devices"
diff -urN -X linus-2.6/Documentation/dontdiff linus-2.6/drivers/video/Makefile fbdev-2.6/drivers/video/Makefile
--- linus-2.6/drivers/video/Makefile	2007-02-21 10:59:24.000000000 -0500
+++ fbdev-2.6/drivers/video/Makefile	2007-02-21 15:16:48.000000000 -0500
@@ -12,7 +12,7 @@
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
-obj-y				  += backlight/
+obj-y				  += backlight/ display/
 
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
diff -urN -X linus-2.6/Documentation/dontdiff linus-2.6/include/linux/display.h fbdev-2.6/include/linux/display.h
--- linus-2.6/include/linux/display.h	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/include/linux/display.h	2007-02-21 15:34:31.000000000 -0500
@@ -0,0 +1,60 @@
+/*
+ *  Copyright (C) 2006 James Simmons <jsimmons@infradead.org>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
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
+#ifndef _LINUX_DISPLAY_H
+#define _LINUX_DISPLAY_H
+
+#include <linux/device.h>
+
+struct display_device;
+
+/* This structure defines all the properties of a Display. */
+struct display_driver {
+	int  (*set_contrast)(struct display_device *, unsigned int);
+	int  (*get_contrast)(struct display_device *);
+	void (*suspend)(struct display_device *, pm_message_t state);
+	void (*resume)(struct display_device *);
+	int  (*probe)(struct display_device *, void *);
+	int  (*remove)(struct display_device *);
+	int  max_contrast;
+};
+
+struct display_device {
+	struct module *owner;	/* Owner module */
+	char type[16];
+	char *name;
+	struct mutex lock;
+	struct display_driver *driver;
+	struct device *parent;			/* This is the parent */
+	struct device *dev;			/* This is this display device */
+	void *priv_data;
+};
+
+extern struct display_device *display_device_register(struct display_driver *driver,
+					struct device *dev, void *devdata);
+extern void display_device_unregister(struct display_device *dev);
+
+extern int probe_edid(struct display_device *dev, void *devdata);
+
+#define to_display_device(obj) container_of(obj, struct display_device, class_dev)
+
+#endif
