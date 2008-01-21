Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbYAUBme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbYAUBme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 20:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbYAUBm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 20:42:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:57205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbYAUBm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:42:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Uppq0+pGkvPo7bgvKuyS+2c0PN66b5yk5J7n4sr6Mouwkxl6PC4ef7aoETjb5gSSiX9EL6h5K+UDKyUvXNf27cLQscXBr45V6wa8BMYuCOgXEU3L7c9J3K+/GHBxzw/gU/Y0ln4q+YlLSrXlCJtT7ddNzYHBPv+QMmvIUwNuGJU=
Date: Mon, 21 Jan 2008 09:43:35 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080121014335.GA3219@darkstar.te-china.tietoenator.com>
References: <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com> <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com> <1200626323.5640.21.camel@lov.site> <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com> <20080118073836.GA1703@ff.dom.local> <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com> <20080118082327.GC1703@ff.dom.local> <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com> <4791C555.9050205@gmail.com> <20080121013021.GB2832@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121013021.GB2832@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 09:30:21AM +0800, Dave Young wrote:
> On Sat, Jan 19, 2008 at 10:39:33AM +0100, Jarek Poplawski wrote:
> > Dave Young wrote, On 01/18/2008 10:07 AM:
> > 
> > > On Jan 18, 2008 4:23 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> > 
> > >> On Fri, Jan 18, 2008 at 03:48:02PM +0800, Dave Young wrote:
> > 
> > ...
> > 
> > >>> 1) Using CLASS_NORMAL/CLASS_PARENT/CLASS_CHILD will be enough.
> > >>> or
> > >>> 2) Simply add SINGLE_LEVEL_NESTING in class_device_add and other
> > >>> class_device functions because it is the only possible nest-lock place
> > >>> as I know.
> > 
> > 
> Althoug the class_device will be away soon, the patch is updated as following because the problem is clear and only several lines are changed. At least, it could be used for test.
> 
> 
> Convert the class semaphore to mutex.
> class_interface_register/unregister use class_device_* functions, so SINGLE_DEPTH_NESTING added for lockdep please in these functions. 
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
Sorry for the dirty patch, please don't test the previous one.
I should have drink a cup of coffe before posting.
post the right one again.
---

Convert the class semaphore to mutex.
class_interface_register/unregister use class_device_* functions, so SINGLE_DEPTH_NESTING added for lockdep please in these functions. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/base/class.c   |   38 +++++++++++++++++++-------------------
 drivers/base/core.c    |   18 ++++++++----------
 include/linux/device.h |    3 ++-
 3 files changed, 29 insertions(+), 30 deletions(-)

Index: linux-2.6.23/drivers/base/class.c
===================================================================
--- linux-2.6.23.orig/drivers/base/class.c	2008-01-21 09:36:43.000000000 +0800
+++ linux-2.6.23/drivers/base/class.c	2008-01-21 09:38:14.000000000 +0800
@@ -144,7 +144,7 @@
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
-	init_MUTEX(&cls->sem);
+	mutex_init(&cls->mutex);
 	error = kobject_set_name(&cls->subsys.kobj, "%s", cls->name);
 	if (error)
 		return error;
@@ -617,13 +617,13 @@
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
 
@@ -725,12 +725,12 @@
 	struct class_interface *class_intf;
 
 	if (parent_class) {
-		down(&parent_class->sem);
+		mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);
 		list_del_init(&class_dev->node);
 		list_for_each_entry(class_intf, &parent_class->interfaces, node)
 			if (class_intf->remove)
 				class_intf->remove(class_dev, class_intf);
-		up(&parent_class->sem);
+		mutex_unlock(&parent_class->mutex);
 	}
 
 	if (class_dev->dev) {
@@ -772,14 +772,14 @@
 	struct class_device *class_dev = NULL;
 	struct class_device *class_dev_tmp;
 
-	down(&cls->sem);
+	mutex_lock_nested(&cls->mutex, SINGLE_DEPTH_NESTING);
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
@@ -818,7 +818,7 @@
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -829,7 +829,7 @@
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -860,7 +860,7 @@
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->devices, node) {
 		dev = get_device(dev);
 		if (dev) {
@@ -872,7 +872,7 @@
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -898,7 +898,7 @@
 
 	if (!class)
 		return -EINVAL;
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->children, node) {
 		dev = class_device_get(dev);
 		if (dev) {
@@ -909,7 +909,7 @@
 		if (error)
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return error;
 }
@@ -940,7 +940,7 @@
 	if (!class)
 		return NULL;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(dev, &class->children, node) {
 		dev = class_device_get(dev);
 		if (dev) {
@@ -952,7 +952,7 @@
 		} else
 			break;
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return found ? dev : NULL;
 }
@@ -971,7 +971,7 @@
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -981,7 +981,7 @@
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -995,7 +995,7 @@
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock(&parent->mutex);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -1005,7 +1005,7 @@
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
Index: linux-2.6.23/drivers/base/core.c
===================================================================
--- linux-2.6.23.orig/drivers/base/core.c	2008-01-21 09:35:37.000000000 +0800
+++ linux-2.6.23/drivers/base/core.c	2008-01-21 09:36:47.000000000 +0800
@@ -19,8 +19,6 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 
-#include <asm/semaphore.h>
-
 #include "base.h"
 #include "power/power.h"
 
@@ -783,7 +781,7 @@
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -791,7 +789,7 @@
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -928,14 +926,14 @@
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
@@ -946,7 +944,7 @@
 			 * if we are the last child of our class, delete
 			 * our class-directory at this parent
 			 */
-			down(&dev->class->sem);
+			mutex_lock(&dev->class->mutex);
 			list_for_each_entry(d, &dev->class->devices, node) {
 				if (d == dev)
 					continue;
@@ -959,7 +957,7 @@
 				kobject_del(dev->kobj.parent);
 
 			kobject_put(dev->kobj.parent);
-			up(&dev->class->sem);
+			mutex_unlock(&dev->class->mutex);
 		}
 	}
 	device_remove_file(dev, &uevent_attr);
@@ -1168,14 +1166,14 @@
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
Index: linux-2.6.23/include/linux/device.h
===================================================================
--- linux-2.6.23.orig/include/linux/device.h	2008-01-21 09:36:43.000000000 +0800
+++ linux-2.6.23/include/linux/device.h	2008-01-21 09:36:47.000000000 +0800
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
+ #include <linux/mutex.h>
 #include <asm/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
@@ -180,7 +181,7 @@
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem; /* locks children, devices, interfaces */
+	struct mutex		mutex; /* locks children, devices, interfaces */
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
 	struct device_attribute		* dev_attrs;
