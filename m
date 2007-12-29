Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXL2A6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXL2A6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 19:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbXL2A6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 19:58:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5340 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbXL2A6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 19:58:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=HHi0hdnuQ8/xHm/PNqbVeLC0hSYGtQtQ7d6SWgcM3DY0NHG4Dgvm3APNXEM77jDvDwG2ivS+Wtb1AR+2ERSQgPnAwPBPwctex9i5bqRrvIVRNsDbl+d0PP/dYBqKy5z+gRW6r2+P/yIGCAv9ZIAUSSQM+LuOE4Yantu/p+ss23U=
Date: Sat, 29 Dec 2007 09:01:57 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/base/bus.c        |   20 ++++++++++----------
drivers/base/class.c      |   22 +++++++++++-----------
drivers/base/core.c       |   16 ++++++++--------
drivers/base/dd.c         |   38 +++++++++++++++++++-------------------
drivers/base/power/main.c |    8 ++++----
include/linux/device.h    |    8 ++++----
6 files changed, 56 insertions(+), 56 deletions(-)

diff -upr linux/drivers/base/bus.c linux.new/drivers/base/bus.c
--- linux/drivers/base/bus.c	2007-12-27 13:03:58.000000000 +0800
+++ linux.new/drivers/base/bus.c	2007-12-27 14:01:34.000000000 +0800
@@ -185,10 +185,10 @@ static ssize_t driver_unbind(struct devi
 	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
 	if (dev && dev->driver == drv) {
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
+			mutex_lock(&dev->parent->mutex);
 		device_release_driver(dev);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 		err = count;
 	}
 	put_device(dev);
@@ -212,12 +212,12 @@ static ssize_t driver_bind(struct device
 	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
 	if (dev && dev->driver == NULL) {
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
-		down(&dev->sem);
+			mutex_lock(&dev->parent->mutex);
+		mutex_lock(&dev->mutex);
 		err = driver_probe_device(drv, dev);
-		up(&dev->sem);
+		mutex_unlock(&dev->mutex);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 
 		if (err > 0) 		/* success */
 			err = count;
@@ -721,10 +721,10 @@ static int __must_check bus_rescan_devic
 
 	if (!dev->driver) {
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
+			mutex_lock(&dev->parent->mutex);
 		ret = device_attach(dev);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 	}
 	return ret < 0 ? ret : 0;
 }
@@ -755,10 +755,10 @@ int device_reprobe(struct device *dev)
 {
 	if (dev->driver) {
 		if (dev->parent)        /* Needed for USB */
-			down(&dev->parent->sem);
+			mutex_lock(&dev->parent->mutex);
 		device_release_driver(dev);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 	}
 	return bus_rescan_devices_helper(dev, NULL);
 }
diff -upr linux/drivers/base/class.c linux.new/drivers/base/class.c
--- linux/drivers/base/class.c	2007-12-27 13:03:58.000000000 +0800
+++ linux.new/drivers/base/class.c	2007-12-27 13:54:50.000000000 +0800
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
+	mutex_lock(&parent_class->mutex);
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
+++ linux.new/drivers/base/core.c	2007-12-27 13:52:43.000000000 +0800
@@ -19,7 +19,7 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 #include <linux/genhd.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -531,7 +531,7 @@ void device_initialize(struct device *de
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	INIT_LIST_HEAD(&dev->node);
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
@@ -823,7 +823,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -831,7 +831,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -933,14 +933,14 @@ void device_del(struct device * dev)
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
@@ -1151,14 +1151,14 @@ void device_destroy(struct class *class,
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
diff -upr linux/drivers/base/dd.c linux.new/drivers/base/dd.c
--- linux/drivers/base/dd.c	2007-12-27 13:03:58.000000000 +0800
+++ linux.new/drivers/base/dd.c	2007-12-27 13:59:39.000000000 +0800
@@ -82,7 +82,7 @@ static void driver_sysfs_remove(struct d
  *	for before calling this. (It is ok to call with no other effort
  *	from a driver's probe() method.)
  *
- *	This function must be called with @dev->sem held.
+ *	This function must be called with @dev->mutex locked.
  */
 int device_bind_driver(struct device *dev)
 {
@@ -180,8 +180,8 @@ int driver_probe_done(void)
  * This function returns 1 if a match is found, -ENODEV if the device is
  * not registered, and 0 otherwise.
  *
- * This function must be called with @dev->sem held.  When called for a
- * USB interface, @dev->parent->sem must be held as well.
+ * This function must be called with @dev->mutex locked.  When called for a
+ * USB interface, @dev->parent->mutex must be locked as well.
  */
 int driver_probe_device(struct device_driver * drv, struct device * dev)
 {
@@ -219,13 +219,13 @@ static int __device_attach(struct device
  *	0 if no matching device was found;
  *	-ENODEV if the device is not registered.
  *
- *	When called for a USB interface, @dev->parent->sem must be held.
+ *	When called for a USB interface, @dev->parent->mutex must be locked.
  */
 int device_attach(struct device * dev)
 {
 	int ret = 0;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	if (dev->driver) {
 		ret = device_bind_driver(dev);
 		if (ret == 0)
@@ -237,7 +237,7 @@ int device_attach(struct device * dev)
 	} else {
 		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
 	}
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	return ret;
 }
 
@@ -256,13 +256,13 @@ static int __driver_attach(struct device
 	 */
 
 	if (dev->parent)	/* Needed for USB */
-		down(&dev->parent->sem);
-	down(&dev->sem);
+		mutex_lock(&dev->parent->mutex);
+	mutex_lock(&dev->mutex);
 	if (!dev->driver)
 		driver_probe_device(drv, dev);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	if (dev->parent)
-		up(&dev->parent->sem);
+		mutex_unlock(&dev->parent->mutex);
 
 	return 0;
 }
@@ -282,8 +282,8 @@ int driver_attach(struct device_driver *
 }
 
 /*
- *	__device_release_driver() must be called with @dev->sem held.
- *	When called for a USB interface, @dev->parent->sem must be held as well.
+ *	__device_release_driver() must be called with @dev->mutex locked.
+ *	When called for a USB interface, @dev->parent->mutex must be locked as well.
  */
 static void __device_release_driver(struct device * dev)
 {
@@ -314,7 +314,7 @@ static void __device_release_driver(stru
  *	@dev:	device.
  *
  *	Manually detach device from driver.
- *	When called for a USB interface, @dev->parent->sem must be held.
+ *	When called for a USB interface, @dev->parent->mutex must be locked.
  */
 void device_release_driver(struct device * dev)
 {
@@ -323,9 +323,9 @@ void device_release_driver(struct device
 	 * within their ->remove callback for the same device, they
 	 * will deadlock right here.
 	 */
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	__device_release_driver(dev);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 
 
@@ -349,13 +349,13 @@ void driver_detach(struct device_driver 
 		spin_unlock(&drv->p->klist_devices.k_lock);
 
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
-		down(&dev->sem);
+			mutex_lock(&dev->parent->mutex);
+		mutex_lock(&dev->mutex);
 		if (dev->driver == drv)
 			__device_release_driver(dev);
-		up(&dev->sem);
+		mutex_unlock(&dev->mutex);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 		put_device(dev);
 	}
 }
diff -upr linux/drivers/base/power/main.c linux.new/drivers/base/power/main.c
--- linux/drivers/base/power/main.c	2007-12-27 13:03:32.000000000 +0800
+++ linux.new/drivers/base/power/main.c	2007-12-27 14:02:37.000000000 +0800
@@ -75,7 +75,7 @@ static int resume_device(struct device *
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
@@ -92,7 +92,7 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 
 	TRACE_RESUME(error);
 	return error;
@@ -241,7 +241,7 @@ static int suspend_device(struct device 
 {
 	int error = 0;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -264,7 +264,7 @@ static int suspend_device(struct device 
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	return error;
 }
 
diff -upr linux/include/linux/device.h linux.new/include/linux/device.h
--- linux/include/linux/device.h	2007-12-28 09:47:17.000000000 +0800
+++ linux.new/include/linux/device.h	2007-12-28 09:49:06.000000000 +0800
@@ -20,7 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
@@ -102,7 +102,7 @@ extern int bus_unregister_notifier(struc
 
 /* All 4 notifers below get called with the target struct device *
  * as an argument. Note that those functions are likely to be called
- * with the device semaphore held in the core, so be careful.
+ * with the device mutex locked in the core, so be careful.
  */
 #define BUS_NOTIFY_ADD_DEVICE		0x00000001 /* device added */
 #define BUS_NOTIFY_DEL_DEVICE		0x00000002 /* device removed */
@@ -178,7 +178,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem;	/* locks both the children and interfaces lists */
+	struct mutex		mutex;	/* locks both the children and interfaces lists */
 
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
@@ -417,7 +417,7 @@ struct device {
 	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
 
-	struct semaphore	sem;	/* semaphore to synchronize calls to
+	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
 					 */
 
