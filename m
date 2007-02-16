Return-Path: <linux-kernel-owner+w=401wt.eu-S1945954AbXBPQHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945954AbXBPQHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945964AbXBPQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:07:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34806 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945954AbXBPQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:07:07 -0500
Date: Fri, 16 Feb 2007 16:07:04 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sysfs_follow_link error 
Message-ID: <Pine.LNX.4.64.0702161526580.24998@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

  I seen a posting some time ago about this. Well while I was creating my 
display class I came across this problem. I then discovered how to make 
this error repeatable. The oops only occurs when you have turned OFF the
option CONFIG_SYSFS_DEPRECATED. If CONFIG_SYSFS_DEPRECATED is set then the
driver just will not load. The secert to getting this error is attempting 
to set the dev_attrs in struct class. With the attached driver if you 
uncomment the line in display-sysfs.c you will get the error.

//display_class->dev_attrs = display_attrs;

Here is the oops

BUG: at lib/kref.c:32 kref_get()
 [<c01f1184>] kref_get+0x34/0x3c
 [<c01f066b>] kobject_get+0xf/0x13
 [<c0183dd3>] sysfs_follow_link+0x95/0x1a9
 [<c015a0e4>] generic_readlink+0x27/0x6e
 [<c011d2ac>] current_fs_time+0x4f/0x5b
 [<c016487a>] touch_atime+0x9c/0xce
 [<c015700a>] sys_readlinkat+0x5f/0x79
 [<c015704b>] sys_readlink+0x27/0x2b
 [<c0102a18>] syscall_call+0x7/0xb
 [<c0370033>] rfcomm_run+0x8ad/0x10a1
 =======================
BUG: unable to handle kernel paging request at virtual address 00014f24
 printing eip:
c0183e14
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: test display
CPU:    1
EIP:    0060:[<c0183e14>]    Not tainted VLI
EFLAGS: 00010286   (2.6.20 #297)
EIP is at sysfs_follow_link+0xd6/0x1a9
eax: 00000000   ebx: 00000002   ecx: ffffffff   edx: f0c09a78
esi: 00000001   edi: 00014f24   ebp: f0c09a78   esp: c457beb8
ds: 007b   es: 007b   ss: 0068
Process ls (pid: 28316, ti=c457a000 task=f7e610b0 task.ti=c457a000)
Stack: c457bee0 e3c33000 cf6b409c 00000001 c037cc80 00000001 dd08c84c 08062220 
       c015a0e4 00000000 00000000 00000000 00000000 00000000 45d36c08 32f39f9b 
       45d36c08 00000000 f0f70db4 32f39f9b 45d36c08 c011d2ac 00000001 c18f1800 
Call Trace:
 [<c015a0e4>] generic_readlink+0x27/0x6e
 [<c011d2ac>] current_fs_time+0x4f/0x5b
 [<c016487a>] touch_atime+0x9c/0xce
 [<c015700a>] sys_readlinkat+0x5f/0x79
 [<c015704b>] sys_readlink+0x27/0x2b
 [<c0102a18>] syscall_call+0x7/0xb
 [<c0370033>] rfcomm_run+0x8ad/0x10a1
 =======================
Code: e9 c0 00 00 00 b8 c4 92 43 c0 e8 1d 80 fa ff 8b 44 24 08 31 db 43 8b 40 24 85 c0 75 f8 89 ea be 01 00 00 00 8b 3a 31 c0 83 c9 ff <f2> ae f7 d1 49 8d 74 0e 01 8b 52 24 85 d2 75 e9 8d 04 5b 8d 4c 
EIP: [<c0183e14>] sysfs_follow_link+0xd6/0x1a9 SS:ESP 0068:c457beb8

And here is the driver

diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/display-sysfs.c fbdev-2.6/drivers/video/display/display-sysfs.c
--- linus-2.6/drivers/video/display/display-sysfs.c	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/display-sysfs.c	2007-02-16 09:56:05.000000000 -0500
@@ -0,0 +1,209 @@
+/*
+ *  display.c - Display output driver
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
+static ssize_t display_show_power(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t ret = -ENXIO;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver->get_power))
+		ret = sprintf(buf,"%.8x\n", dsp->driver->get_power(dsp));
+	mutex_unlock(&dsp->lock);
+	return ret;
+}
+
+static ssize_t display_store_power(struct device *dev, struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct display_device *dsp = dev_get_drvdata(dev);
+	ssize_t size;
+	char *endp;
+	int power;
+
+	power = simple_strtoul(buf, &endp, 0);
+	size = endp - buf;
+	if (*endp && isspace(*endp))
+		size++;
+	if (size != count)
+		return -EINVAL;
+
+	mutex_lock(&dsp->lock);
+	if (likely(dsp->driver->set_power))
+		dsp->driver->set_power(dsp, power);
+	mutex_unlock(&dsp->lock);
+	return count;
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
+	__ATTR(power, S_IRUGO | S_IWUSR, display_show_power, display_store_power),
+	__ATTR(contrast, S_IRUGO | S_IWUSR, display_show_contrast, display_store_contrast),
+	__ATTR(max_contrast, S_IRUGO, display_show_max_contrast, NULL),
+};
+
+struct class *display_class;
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
+						"display%d", index++);
+		if (!IS_ERR(new_dev->dev)) {
+			dev_set_drvdata(new_dev->dev, new_dev);
+			new_dev->driver = driver;
+			new_dev->parent = dev;
+			mutex_init(&new_dev->lock);
+		} else {
+			kfree(new_dev);
+			new_dev = ERR_PTR(ret);
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
+	//display_class->dev_attrs = display_attrs;
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
diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/Kconfig fbdev-2.6/drivers/video/display/Kconfig
--- linus-2.6/drivers/video/display/Kconfig	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/Kconfig	2007-02-16 09:55:21.000000000 -0500
@@ -0,0 +1,28 @@
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
+config DISPLAY_TEST
+	tristate "Test driver"
+	depends on DISPLAY_SUPPORT
+
+endmenu
diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/Makefile fbdev-2.6/drivers/video/display/Makefile
--- linus-2.6/drivers/video/display/Makefile	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/Makefile	2007-02-16 09:55:37.000000000 -0500
@@ -0,0 +1,7 @@
+# Display drivers
+
+display-objs				:= display-sysfs.o
+
+obj-$(CONFIG_DISPLAY_SUPPORT)		+= display.o
+
+obj-$(CONFIG_DISPLAY_TEST)		+= test.o
diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/drivers/video/display/test.c fbdev-2.6/drivers/video/display/test.c
--- linus-2.6/drivers/video/display/test.c	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/drivers/video/display/test.c	2007-02-16 09:58:54.000000000 -0500
@@ -0,0 +1,68 @@
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/display.h>
+#include <video/edid.h>
+
+static int test_probe(struct display_device *dsp, void *nothing)
+{
+        dsp->name = kzalloc(5, GFP_KERNEL);
+	strcpy(dsp->name, "test");
+        return 5;
+}
+
+static struct display_driver firmware_driver = {
+	.probe = test_probe,
+};
+static struct display_device *firmware_display;
+
+static int __init phony_probe(struct platform_device *dev)
+{
+#ifdef CONFIG_FIRMWARE_EDID
+	firmware_display = display_device_register(&firmware_driver, &dev->dev, edid_info.dummy);
+#endif
+	return 0;
+}
+
+static int phony_remove(struct platform_device *dev)
+{
+	return 0;
+}
+
+static struct platform_driver phony_driver = {
+        .probe          = phony_probe,
+        .remove         = phony_remove,
+        .driver         = {
+                .name   = "phony",
+        },
+};
+
+static struct platform_device *phony_device;
+
+static int __init phony_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&phony_driver);
+	if (!ret) {
+		phony_device = platform_device_register_simple("phony", 0, NULL, 0);
+	}
+        return ret;
+}
+
+static void __exit phony_exit(void)
+{
+        platform_device_unregister(phony_device);
+	platform_driver_unregister(&phony_driver);
+}
+
+module_init(phony_init);
+module_exit(phony_exit);
+
+MODULE_AUTHOR("James Simmons");
+MODULE_DESCRIPTION("Test Display Driver");
+MODULE_LICENSE("GPL");
+
diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/drivers/video/Kconfig fbdev-2.6/drivers/video/Kconfig
--- linus-2.6/drivers/video/Kconfig	2007-02-13 09:05:39.000000000 -0500
+++ fbdev-2.6/drivers/video/Kconfig	2007-02-16 09:58:10.000000000 -0500
@@ -1649,6 +1649,7 @@
 
 if SYSFS
 	source "drivers/video/backlight/Kconfig"
+	source "drivers/video/display/Kconfig"
 endif
 
 endmenu
diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/drivers/video/Makefile fbdev-2.6/drivers/video/Makefile
--- linus-2.6/drivers/video/Makefile	2007-02-13 09:05:39.000000000 -0500
+++ fbdev-2.6/drivers/video/Makefile	2007-02-16 09:50:51.000000000 -0500
@@ -12,7 +12,7 @@
 
 obj-$(CONFIG_VT)		  += console/
 obj-$(CONFIG_LOGO)		  += logo/
-obj-$(CONFIG_SYSFS)		  += backlight/
+obj-$(CONFIG_SYSFS)		  += backlight/ display/
 
 obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
 obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
diff -urN -X fbdev-2.6/Documentation/dontdiff linus-2.6/include/linux/display.h fbdev-2.6/include/linux/display.h
--- linus-2.6/include/linux/display.h	1969-12-31 19:00:00.000000000 -0500
+++ fbdev-2.6/include/linux/display.h	2007-02-11 11:52:29.000000000 -0500
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
+	int (*set_power)(struct display_device *, unsigned int);
+	int (*get_power)(struct display_device *);
+	int (*set_contrast)(struct display_device *, unsigned int);
+	int (*get_contrast)(struct display_device *);
+	int (*probe)(struct display_device *, void *);
+	int (*remove)(struct display_device *);
+	int max_contrast;
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
