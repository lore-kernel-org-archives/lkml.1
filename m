Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYACFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYACFtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYACFtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:49:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:39103 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbYACFtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=wwMUHt3e0suRuNuezWjFJIhITL9V80Y7T9+bKOXZXKQxXGjibr71+DBjxeAykMhRepL9zsuIjG2RvH+lXv7eyvy5AWxLm2KUn6RDQHTLrS5TVFIZUXz5t/z8wNm6QLQj9O3yAEmH0VyUj75Z2Ny/qu3Ij2QlG6wjJl84pZtvwTM=
Date: Thu, 3 Jan 2008 13:52:45 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] driver core : convert semaphore to class in struct
	class
Message-ID: <20080103055245.GB4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
---
drivers/base/class.c   |   22 +++++++++++-----------
drivers/base/core.c    |   13 ++++++-------
include/linux/device.h |    3 ++-
3 files changed, 19 insertions(+), 19 deletions(-)

diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
--- linux/drivers/base/class.c	2007-12-27 13:03:58.000000000 +0800
+++ linux.new/drivers/base/class.c	2008-01-03 12:51:51.000000000 +0800
@@ -145,7 +145,7 @@ int class_register(struct class * cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -628,13 +628,13 @@ int class_device_add(struct class_device
 	kobject_uevent(&class_dev->kobj, KOBJ_ADD);
 
 	/* notify any interfaces this device is now here */
-	down(&parent_class->sem);
+	mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);
 	list_add_tail(&class_dev->node, &parent_class->children);
 	list_for_each_entry(class_intf, &parent_class->interfaces, node) {
 		if (class_intf->add)
 			class_intf->add(class_dev, class_intf);
 	}
-	up(&parent_class->sem);
+	mutex_unlock(&parent_class->mutex);
 
 	goto out1;
 
@@ -736,12 +736,12 @@ void class_device_del(struct class_devic
 	struct class_interface *class_intf;
 
 	if (parent_class) {
-		down(&parent_class->sem);
+		mutex_lock(&parent_class->mutex);
 		list_del_init(&class_dev->node);
 		list_for_each_entry(class_intf, &parent_class->interfaces, node)
 			if (class_intf->remove)
 				class_intf->remove(class_dev, class_intf);
-		up(&parent_class->sem);
+		mutex_unlock(&parent_class->mutex);
 	}
 
 	if (class_dev->dev) {
@@ -783,14 +783,14 @@ void class_device_destroy(struct class *
 	struct class_device *class_dev = NULL;
 	struct class_device *class_dev_tmp;
 
-	down(&cls->sem);
+	mutex_lock(&cls->mutex);
 	list_for_each_entry(class_dev_tmp, &cls->children, node) {
 		if (class_dev_tmp->devt == devt) {
 			class_dev = class_dev_tmp;
 			break;
 		}
 	}
-	up(&cls->sem);
+	mutex_unlock(&cls->mutex);
 
 	if (class_dev)
 		class_device_unregister(class_dev);
@@ -823,7 +823,7 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -833,7 +833,7 @@ int class_interface_register(struct clas
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -847,7 +847,7 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -857,7 +857,7 @@ void class_interface_unregister(struct c
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -upr linux/drivers/base/core.c linux.new/drivers/base/core.c
--- linux/drivers/base/core.c	2007-12-27 13:03:58.000000000 +0800
+++ linux.new/drivers/base/core.c	2008-01-03 09:27:16.000000000 +0800
@@ -19,7 +19,6 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 #include <linux/genhd.h>
-#include <asm/semaphore.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -823,7 +822,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -831,7 +830,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -933,14 +932,14 @@ void device_del(struct device * dev)
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* notify any interfaces that the device is now gone */
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->remove_dev)
 				class_intf->remove_dev(dev, class_intf);
 		/* remove the device from the class list */
 		list_del_init(&dev->node);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
 	device_remove_file(dev, &uevent_attr);
 	device_remove_attrs(dev);
@@ -1151,14 +1150,14 @@ void device_destroy(struct class *class,
 	struct device *dev = NULL;
 	struct device *dev_tmp;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev_tmp, &class->devices, node) {
 		if (dev_tmp->devt == devt) {
 			dev = dev_tmp;
 			break;
 		}
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	if (dev)
 		device_unregister(dev);
diff -upr linux/include/linux/device.h linux.new/include/linux/device.h
--- linux/include/linux/device.h	2007-12-28 09:47:17.000000000 +0800
+++ linux.new/include/linux/device.h	2008-01-03 09:21:07.000000000 +0800
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
@@ -178,7 +179,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem;	/* locks both the children and interfaces lists */
+	struct mutex		mutex;	/* locks both the children and interfaces lists */
 
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
