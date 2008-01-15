Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYAOJMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYAOJMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbYAOJMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:12:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:34696 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272AbYAOJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:12:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=H+1AMxZHjgVt3sKEDIL13wKWOAIwL144vCs/l/gw0wiYIJYjz166939NOGbaJQrLW7TaGhuOVRE5lULVZDECVYe9tVsM2Efqg6N/1toikZVildkp+exaFlnxXl6Ay7J881+H0591fJ9YDHSNtOpNvWASpapQ6ZVmtmaf6giKYqk=
Date: Tue, 15 Jan 2008 17:15:27 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: stefanr@s5r6.in-berlin.de, david-b@pacbell.net, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, jarkao2@gmail.com
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080115091527.GB3186@darkstar.te-china.tietoenator.com>
References: <20080112100515.GA2956@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112100515.GA2956@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the class semaphore to mutex.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/base/class.c   |   38 +++++++++++++++++++-------------------
 drivers/base/core.c    |   18 ++++++++----------
 include/linux/device.h |    3 ++-
 3 files changed, 29 insertions(+), 30 deletions(-)

diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
--- linux/drivers/base/class.c	2008-01-15 14:04:26.000000000 +0800
+++ linux.new/drivers/base/class.c	2008-01-15 14:04:26.000000000 +0800
@@ -144,7 +144,7 @@ int class_register(struct class * cls)
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -617,13 +617,13 @@ int class_device_add(struct class_device
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
 
@@ -725,12 +725,12 @@ void class_device_del(struct class_devic
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
@@ -772,14 +772,14 @@ void class_device_destroy(struct class *
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
@@ -818,7 +818,7 @@ int class_for_each_device(struct class *
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -829,7 +829,7 @@ int class_for_each_device(struct class *
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -860,7 +860,7 @@ struct device *class_find_device(struct 
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -872,7 +872,7 @@ struct device *class_find_device(struct 
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -898,7 +898,7 @@ int class_for_each_child(struct class *c
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->children, node) {
 		dev = class_device_get(dev);
 		if (dev) {
@@ -909,7 +909,7 @@ int class_for_each_child(struct class *c
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -940,7 +940,7 @@ struct class_device *class_find_child(st
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->children, node) {
 		dev = class_device_get(dev);
 		if (dev) {
@@ -952,7 +952,7 @@ struct class_device *class_find_child(st
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -971,7 +971,7 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -981,7 +981,7 @@ int class_interface_register(struct clas
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -995,7 +995,7 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -1005,7 +1005,7 @@ void class_interface_unregister(struct c
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
diff -upr linux/drivers/base/core.c linux.new/drivers/base/core.c
--- linux/drivers/base/core.c	2008-01-15 14:04:26.000000000 +0800
+++ linux.new/drivers/base/core.c	2008-01-15 14:04:26.000000000 +0800
@@ -19,8 +19,6 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 
-#include <asm/semaphore.h>
-
 #include "base.h"
 #include "power/power.h"
 
@@ -783,7 +781,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -791,7 +789,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -928,14 +926,14 @@ void device_del(struct device * dev)
 			sysfs_remove_link(&dev->kobj, "device");
 		}
 
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
 
 		/* If we live in a parent class-directory, unreference it */
 		if (dev->kobj.parent->kset == &dev->class->class_dirs) {
@@ -946,7 +944,7 @@ void device_del(struct device * dev)
 			 * if we are the last child of our class, delete
 			 * our class-directory at this parent
 			 */
-			down(&dev->class->sem);
+			mutex_lock(&dev->class->mutex);
 			list_for_each_entry(d, &dev->class->devices, node) {
 				if (d == dev)
 					continue;
@@ -959,7 +957,7 @@ void device_del(struct device * dev)
 				kobject_del(dev->kobj.parent);
 
 			kobject_put(dev->kobj.parent);
-			up(&dev->class->sem);
+			mutex_unlock(&dev->class->mutex);
 		}
 	}
 	device_remove_file(dev, &uevent_attr);
@@ -1168,14 +1166,14 @@ void device_destroy(struct class *class,
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
--- linux/include/linux/device.h	2008-01-15 14:04:26.000000000 +0800
+++ linux.new/include/linux/device.h	2008-01-15 14:04:26.000000000 +0800
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+ #include <linux/mutex.h>
 #include <asm/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -180,7 +181,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem; /* locks children, devices, interfaces */
+	struct mutex		mutex; /* locks children, devices, interfaces */
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
 	struct device_attribute		* dev_attrs;
