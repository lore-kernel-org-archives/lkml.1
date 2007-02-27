Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbXB0OAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbXB0OAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXB0N7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:59:51 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:15089 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbXB0N7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Dy0mvGIWe9KmqMJCZd0KSAIzPC9v/XoTT2xiA24DOrEnNEEzmxzKZZRHIQOuz5O09bbe8/zYysobZweAjJBy34n4T2En9zF+bNpqeLYiRlQzuPpAVhuBKzghnQ2ueZEvDp69rSe+IB6cBhV7XFD4kjOiQ8JuLLaTZrZGFOjTmlo=
Message-ID: <961aa3350702270559uc300ba1hbfc674fddea3895c@mail.gmail.com>
Date: Tue, 27 Feb 2007 22:59:45 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>
Subject: Subject: [PATCH 1/3] driver core: cleanup device links code
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup by introducing device_add_links() and device_remove_links().

This patch should not change any current behavior except the scope of
class_name moved to the inside of device_add_links().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |   92 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 40 deletions(-)

Index: 2.6-mm/drivers/base/core.c
===================================================================
--- 2.6-mm.orig/drivers/base/core.c
+++ 2.6-mm/drivers/base/core.c
@@ -487,6 +487,56 @@ static int setup_parent(struct device *d
 	return 0;
 }

+static void device_add_links(struct device *dev, struct device *parent)
+{
+	if (dev->class) {
+		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
+				  "subsystem");
+		/* If this is not a "fake" compatible device, then create the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_create_link(&dev->class->subsys.kset.kobj,
+					  &dev->kobj, dev->bus_id);
+#ifdef CONFIG_SYSFS_DEPRECATED
+		if (parent) {
+			char *class_name = NULL;
+
+			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+							"device");
+			class_name = make_class_name(dev->class->name,
+							&dev->kobj);
+			if (class_name)
+				sysfs_create_link(&dev->parent->kobj,
+						  &dev->kobj, class_name);
+			kfree(class_name);
+		}
+#endif
+	}
+}
+
+static void device_remove_links(struct device *dev, struct device *parent)
+{
+	if (dev->class) {
+		sysfs_remove_link(&dev->kobj, "subsystem");
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
+			sysfs_remove_link(&dev->class->subsys.kset.kobj,
+					  dev->bus_id);
+#ifdef CONFIG_SYSFS_DEPRECATED
+		if (parent) {
+			char *class_name = make_class_name(dev->class->name,
+							   &dev->kobj);
+			if (class_name)
+				sysfs_remove_link(&dev->parent->kobj,
+						  class_name);
+			kfree(class_name);
+			sysfs_remove_link(&dev->kobj, "device");
+		}
+#endif
+	}
+}
+
 /**
  *	device_add - add device to device hierarchy.
  *	@dev:	device.
@@ -501,7 +551,6 @@ static int setup_parent(struct device *d
 int device_add(struct device *dev)
 {
 	struct device *parent = NULL;
-	char *class_name = NULL;
 	struct class_interface *class_intf;
 	int error = -EINVAL;

@@ -562,26 +611,7 @@ int device_add(struct device *dev)
 		dev->devt_attr = attr;
 	}

-	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
-				  "subsystem");
-		/* If this is not a "fake" compatible device, then create the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_create_link(&dev->class->subsys.kset.kobj,
-					  &dev->kobj, dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
-		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
-			class_name = make_class_name(dev->class->name,
-							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
-		}
-#endif
-	}
+	device_add_links(dev, parent);

 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
@@ -609,7 +639,6 @@ int device_add(struct device *dev)
 		up(&dev->class->sem);
 	}
  Done:
- 	kfree(class_name);
 	put_device(dev);
 	return error;
  BusError:
@@ -709,25 +738,8 @@ void device_del(struct device * dev)
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
 	}
+	device_remove_links(dev, parent);
 	if (dev->class) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		/* If this is not a "fake" compatible device, remove the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_remove_link(&dev->class->subsys.kset.kobj,
-					  dev->bus_id);
-#ifdef CONFIG_SYSFS_DEPRECATED
-		if (parent) {
-			char *class_name = make_class_name(dev->class->name,
-							   &dev->kobj);
-			if (class_name)
-				sysfs_remove_link(&dev->parent->kobj,
-						  class_name);
-			kfree(class_name);
-			sysfs_remove_link(&dev->kobj, "device");
-		}
-#endif
-
 		down(&dev->class->sem);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
