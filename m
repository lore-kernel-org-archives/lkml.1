Return-Path: <linux-kernel-owner+w=401wt.eu-S1422835AbXBHAgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422835AbXBHAgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161504AbXBHAdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:34092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965705AbXBHAcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:51 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@novell.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/28] Driver core: add device_type to struct device
Date: Wed,  7 Feb 2007 16:30:13 -0800
Message-Id: <11708947024054-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946993815-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com> <11708946871208-git-send-email-greg@kroah.com> <1170894
 6903974-git-send-email-greg@kroah.com> <11708946932742-git-send-email-greg@kroah.com> <11708946963110-git-send-email-greg@kroah.com> <11708946993815-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@novell.com>

This allows us to add type specific attributes, uevent vars and
release funtions.

A subsystem can carry different types of devices like the "block"
subsys has disks and partitions. Both types create a different set
of attributes, but belong to the same subsystem.

This corresponds to the low level objects:
  kobject   -> device       (object/device data)
  kobj_type -> device_type  (type of object/device we are embedded in)
  kset      -> class/bus    (list of objects/devices of a subsystem)

Signed-off-by: Kay Sievers <kay.sievers@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c          |   57 ++++++++++++++++++++++++++++-------------
 drivers/usb/input/hid-lgff.c |    4 +-
 include/linux/device.h       |    8 ++++++
 3 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7a5336f..34ac187 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -95,6 +95,8 @@ static void device_release(struct kobject * kobj)
 
 	if (dev->release)
 		dev->release(dev);
+	else if (dev->type && dev->type->release)
+		dev->type->release(dev);
 	else if (dev->class && dev->class->dev_release)
 		dev->class->dev_release(dev);
 	else {
@@ -206,19 +208,25 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj, char **envp,
 	if (dev->bus && dev->bus->uevent) {
 		/* have the bus specific function add its stuff */
 		retval = dev->bus->uevent(dev, envp, num_envp, buffer, buffer_size);
-			if (retval) {
-			pr_debug ("%s - uevent() returned %d\n",
+		if (retval)
+			pr_debug ("%s: bus uevent() returned %d\n",
 				  __FUNCTION__, retval);
-		}
 	}
 
 	if (dev->class && dev->class->dev_uevent) {
 		/* have the class specific function add its stuff */
 		retval = dev->class->dev_uevent(dev, envp, num_envp, buffer, buffer_size);
-			if (retval) {
-				pr_debug("%s - dev_uevent() returned %d\n",
-					 __FUNCTION__, retval);
-		}
+		if (retval)
+			pr_debug("%s: class uevent() returned %d\n",
+				 __FUNCTION__, retval);
+	}
+
+	if (dev->type && dev->type->uevent) {
+		/* have the device type specific fuction add its stuff */
+		retval = dev->type->uevent(dev, envp, num_envp, buffer, buffer_size);
+		if (retval)
+			pr_debug("%s: dev_type uevent() returned %d\n",
+				 __FUNCTION__, retval);
 	}
 
 	return retval;
@@ -269,37 +277,50 @@ static void device_remove_groups(struct device *dev)
 static int device_add_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
+	struct device_type *type = dev->type;
 	int error = 0;
 	int i;
 
-	if (!class)
-		return 0;
-
-	if (class->dev_attrs) {
+	if (class && class->dev_attrs) {
 		for (i = 0; attr_name(class->dev_attrs[i]); i++) {
 			error = device_create_file(dev, &class->dev_attrs[i]);
 			if (error)
 				break;
 		}
+		if (error)
+			while (--i >= 0)
+				device_remove_file(dev, &class->dev_attrs[i]);
 	}
-	if (error)
-		while (--i >= 0)
-			device_remove_file(dev, &class->dev_attrs[i]);
+
+	if (type && type->attrs) {
+		for (i = 0; attr_name(type->attrs[i]); i++) {
+			error = device_create_file(dev, &type->attrs[i]);
+			if (error)
+				break;
+		}
+		if (error)
+			while (--i >= 0)
+				device_remove_file(dev, &type->attrs[i]);
+	}
+
 	return error;
 }
 
 static void device_remove_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
+	struct device_type *type = dev->type;
 	int i;
 
-	if (!class)
-		return;
-
-	if (class->dev_attrs) {
+	if (class && class->dev_attrs) {
 		for (i = 0; attr_name(class->dev_attrs[i]); i++)
 			device_remove_file(dev, &class->dev_attrs[i]);
 	}
+
+	if (type && type->attrs) {
+		for (i = 0; attr_name(type->attrs[i]); i++)
+			device_remove_file(dev, &type->attrs[i]);
+	}
 }
 
 
diff --git a/drivers/usb/input/hid-lgff.c b/drivers/usb/input/hid-lgff.c
index e474662..4f4fc3b 100644
--- a/drivers/usb/input/hid-lgff.c
+++ b/drivers/usb/input/hid-lgff.c
@@ -32,7 +32,7 @@
 #include <linux/hid.h>
 #include "usbhid.h"
 
-struct device_type {
+struct dev_type {
 	u16 idVendor;
 	u16 idProduct;
 	const signed short *ff;
@@ -48,7 +48,7 @@ static const signed short ff_joystick[] = {
 	-1
 };
 
-static const struct device_type devices[] = {
+static const struct dev_type devices[] = {
 	{ 0x046d, 0xc211, ff_rumble },
 	{ 0x046d, 0xc219, ff_rumble },
 	{ 0x046d, 0xc283, ff_joystick },
diff --git a/include/linux/device.h b/include/linux/device.h
index da72219..e1e164f 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -328,6 +328,13 @@ extern struct class_device *class_device_create(struct class *cls,
 					__attribute__((format(printf,5,6)));
 extern void class_device_destroy(struct class *cls, dev_t devt);
 
+struct device_type {
+	struct device_attribute *attrs;
+	int (*uevent)(struct device *dev, char **envp, int num_envp,
+		      char *buffer, int buffer_size);
+	void (*release)(struct device *dev);
+};
+
 /* interface for exporting device attributes */
 struct device_attribute {
 	struct attribute	attr;
@@ -356,6 +363,7 @@ struct device {
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
+	struct device_type	*type;
 	unsigned		is_registered:1;
 	struct device_attribute uevent_attr;
 	struct device_attribute *devt_attr;
-- 
1.4.4.4

