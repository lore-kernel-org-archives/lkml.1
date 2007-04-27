Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXD0TLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXD0TLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbXD0S5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:50490 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028AbXD0S4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:56:37 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@insightbb.com>, Dmitry Torokhov <dtor@mail.ru>,
       Kay Sievers <kay.sievers@novell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/46] driver core: Use attribute groups in struct device_type
Date: Fri, 27 Apr 2007 11:53:19 -0700
Message-Id: <11777000552084-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000511784-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@insightbb.com>

Driver core: use attribute groups in struct device_type

Attribute groups are more flexible than attribute lists
(an attribute list can be represented by anonymous group)
so switch struct device_type to use them.

Also rework attribute creation for devices so that they all
cleaned up properly in case of errors.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Kay Sievers <kay.sievers@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |  115 +++++++++++++++++++++++++++++-------------------
 include/linux/device.h |    2 +-
 2 files changed, 70 insertions(+), 47 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 9ea12d9..bb2cc37 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -246,64 +246,95 @@ static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static int device_add_groups(struct device *dev)
+static int device_add_attributes(struct device *dev,
+				 struct device_attribute *attrs)
+{
+	int error = 0;
+	int i;
+
+	if (attrs) {
+		for (i = 0; attr_name(attrs[i]); i++) {
+			error = device_create_file(dev, &attrs[i]);
+			if (error)
+				break;
+		}
+		if (error)
+			while (--i >= 0)
+				device_remove_file(dev, &attrs[i]);
+	}
+	return error;
+}
+
+static void device_remove_attributes(struct device *dev,
+				     struct device_attribute *attrs)
 {
 	int i;
+
+	if (attrs)
+		for (i = 0; attr_name(attrs[i]); i++)
+			device_remove_file(dev, &attrs[i]);
+}
+
+static int device_add_groups(struct device *dev,
+			     struct attribute_group **groups)
+{
 	int error = 0;
+	int i;
 
-	if (dev->groups) {
-		for (i = 0; dev->groups[i]; i++) {
-			error = sysfs_create_group(&dev->kobj, dev->groups[i]);
+	if (groups) {
+		for (i = 0; groups[i]; i++) {
+			error = sysfs_create_group(&dev->kobj, groups[i]);
 			if (error) {
 				while (--i >= 0)
-					sysfs_remove_group(&dev->kobj, dev->groups[i]);
-				goto out;
+					sysfs_remove_group(&dev->kobj, groups[i]);
+				break;
 			}
 		}
 	}
-out:
 	return error;
 }
 
-static void device_remove_groups(struct device *dev)
+static void device_remove_groups(struct device *dev,
+				 struct attribute_group **groups)
 {
 	int i;
-	if (dev->groups) {
-		for (i = 0; dev->groups[i]; i++) {
-			sysfs_remove_group(&dev->kobj, dev->groups[i]);
-		}
-	}
+
+	if (groups)
+		for (i = 0; groups[i]; i++)
+			sysfs_remove_group(&dev->kobj, groups[i]);
 }
 
 static int device_add_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
 	struct device_type *type = dev->type;
-	int error = 0;
-	int i;
+	int error;
 
-	if (class && class->dev_attrs) {
-		for (i = 0; attr_name(class->dev_attrs[i]); i++) {
-			error = device_create_file(dev, &class->dev_attrs[i]);
-			if (error)
-				break;
-		}
+	if (class) {
+		error = device_add_attributes(dev, class->dev_attrs);
 		if (error)
-			while (--i >= 0)
-				device_remove_file(dev, &class->dev_attrs[i]);
+			return error;
 	}
 
-	if (type && type->attrs) {
-		for (i = 0; attr_name(type->attrs[i]); i++) {
-			error = device_create_file(dev, &type->attrs[i]);
-			if (error)
-				break;
-		}
+	if (type) {
+		error = device_add_groups(dev, type->groups);
 		if (error)
-			while (--i >= 0)
-				device_remove_file(dev, &type->attrs[i]);
+			goto err_remove_class_attrs;
 	}
 
+	error = device_add_groups(dev, dev->groups);
+	if (error)
+		goto err_remove_type_groups;
+
+	return 0;
+
+ err_remove_type_groups:
+	if (type)
+		device_remove_groups(dev, type->groups);
+ err_remove_class_attrs:
+	if (class)
+		device_remove_attributes(dev, class->dev_attrs);
+
 	return error;
 }
 
@@ -311,17 +342,14 @@ static void device_remove_attrs(struct device *dev)
 {
 	struct class *class = dev->class;
 	struct device_type *type = dev->type;
-	int i;
 
-	if (class && class->dev_attrs) {
-		for (i = 0; attr_name(class->dev_attrs[i]); i++)
-			device_remove_file(dev, &class->dev_attrs[i]);
-	}
+	device_remove_groups(dev, dev->groups);
 
-	if (type && type->attrs) {
-		for (i = 0; attr_name(type->attrs[i]); i++)
-			device_remove_file(dev, &type->attrs[i]);
-	}
+	if (type)
+		device_remove_groups(dev, type->groups);
+
+	if (class)
+		device_remove_attributes(dev, class->dev_attrs);
 }
 
 
@@ -638,8 +666,6 @@ int device_add(struct device *dev)
 
 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
-	if ((error = device_add_groups(dev)))
-		goto GroupError;
 	if ((error = device_pm_add(dev)))
 		goto PMError;
 	if ((error = bus_add_device(dev)))
@@ -663,7 +689,7 @@ int device_add(struct device *dev)
 		up(&dev->class->sem);
 	}
  Done:
- 	kfree(class_name);
+	kfree(class_name);
 	put_device(dev);
 	return error;
  AttachError:
@@ -674,8 +700,6 @@ int device_add(struct device *dev)
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
-	device_remove_groups(dev);
- GroupError:
 	device_remove_attrs(dev);
  AttrsError:
 	if (dev->devt_attr) {
@@ -838,7 +862,6 @@ void device_del(struct device * dev)
 		}
 	}
 	device_remove_file(dev, &dev->uevent_attr);
-	device_remove_groups(dev);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 9d54fe1..3b64fde 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -332,7 +332,7 @@ extern struct class_device *class_device_create(struct class *cls,
 extern void class_device_destroy(struct class *cls, dev_t devt);
 
 struct device_type {
-	struct device_attribute *attrs;
+	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size);
 	void (*release)(struct device *dev);
-- 
1.5.1.2

