Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZGZIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZGZIXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZGZIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:23:13 -0400
Received: from www.tglx.de ([62.245.132.106]:33898 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZGZIVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:21:00 -0400
Message-Id: <20090726081557.253041003@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [Patch RFC 30/37] drivers/base: Convert dev->sem to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=drivers-base-convert-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore is used as mutex so make it a mutex. Clean up all
users outside of drivers/base as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/base/bus.c             |   20 ++++++++++----------
 drivers/base/core.c            |    3 +--
 drivers/base/dd.c              |   38 +++++++++++++++++++-------------------
 drivers/base/power/main.c      |   20 ++++++++++----------
 drivers/firewire/core-device.c |    4 ++--
 drivers/ieee1394/nodemgr.c     |    4 ++--
 drivers/net/mlx4/mlx4.h        |    1 +
 drivers/pci/bus.c              |    4 ++--
 drivers/pci/pci.c              |    4 ++--
 drivers/pcmcia/ds.c            |    8 ++++----
 drivers/usb/core/driver.c      |    4 ++--
 drivers/uwb/umc-bus.c          |    4 ++--
 drivers/uwb/uwb-internal.h     |    4 ++--
 include/linux/device.h         |    5 ++---
 include/linux/usb.h            |    6 +++---
 15 files changed, 64 insertions(+), 65 deletions(-)

Index: linux-2.6-tip/drivers/base/bus.c
===================================================================
--- linux-2.6-tip.orig/drivers/base/bus.c
+++ linux-2.6-tip/drivers/base/bus.c
@@ -173,10 +173,10 @@ static ssize_t driver_unbind(struct devi
 	dev = bus_find_device_by_name(bus, NULL, buf);
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
@@ -200,12 +200,12 @@ static ssize_t driver_bind(struct device
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
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
 
 		if (err > 0) {
 			/* success */
@@ -742,10 +742,10 @@ static int __must_check bus_rescan_devic
 
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
@@ -777,10 +777,10 @@ int device_reprobe(struct device *dev)
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
Index: linux-2.6-tip/drivers/base/core.c
===================================================================
--- linux-2.6-tip.orig/drivers/base/core.c
+++ linux-2.6-tip/drivers/base/core.c
@@ -20,7 +20,6 @@
 #include <linux/notifier.h>
 #include <linux/genhd.h>
 #include <linux/kallsyms.h>
-#include <linux/semaphore.h>
 #include <linux/mutex.h>
 #include <linux/async.h>
 
@@ -550,7 +549,7 @@ void device_initialize(struct device *de
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);
 	INIT_LIST_HEAD(&dev->dma_pools);
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
Index: linux-2.6-tip/drivers/base/dd.c
===================================================================
--- linux-2.6-tip.orig/drivers/base/dd.c
+++ linux-2.6-tip/drivers/base/dd.c
@@ -84,7 +84,7 @@ static void driver_sysfs_remove(struct d
  * for before calling this. (It is ok to call with no other effort
  * from a driver's probe() method.)
  *
- * This function must be called with @dev->sem held.
+ * This function must be called with @dev->mutex held.
  */
 int device_bind_driver(struct device *dev)
 {
@@ -189,8 +189,8 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe)
  * This function returns -ENODEV if the device is not registered,
  * 1 if the device is bound sucessfully and 0 otherwise.
  *
- * This function must be called with @dev->sem held.  When called for a
- * USB interface, @dev->parent->sem must be held as well.
+ * This function must be called with @dev->mutex held.  When called for a
+ * USB interface, @dev->parent->mutex must be held as well.
  */
 int driver_probe_device(struct device_driver *drv, struct device *dev)
 {
@@ -229,13 +229,13 @@ static int __device_attach(struct device
  * 0 if no matching driver was found;
  * -ENODEV if the device is not registered.
  *
- * When called for a USB interface, @dev->parent->sem must be held.
+ * When called for a USB interface, @dev->parent->mutex must be held.
  */
 int device_attach(struct device *dev)
 {
 	int ret = 0;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	if (dev->driver) {
 		ret = device_bind_driver(dev);
 		if (ret == 0)
@@ -247,7 +247,7 @@ int device_attach(struct device *dev)
 	} else {
 		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
 	}
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(device_attach);
@@ -270,13 +270,13 @@ static int __driver_attach(struct device
 		return 0;
 
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
@@ -297,8 +297,8 @@ int driver_attach(struct device_driver *
 EXPORT_SYMBOL_GPL(driver_attach);
 
 /*
- * __device_release_driver() must be called with @dev->sem held.
- * When called for a USB interface, @dev->parent->sem must be held as well.
+ * __device_release_driver() must be called with @dev->mutex held.
+ * When called for a USB interface, @dev->parent->mutex must be held as well.
  */
 static void __device_release_driver(struct device *dev)
 {
@@ -332,7 +332,7 @@ static void __device_release_driver(stru
  * @dev: device.
  *
  * Manually detach device from driver.
- * When called for a USB interface, @dev->parent->sem must be held.
+ * When called for a USB interface, @dev->parent->mutex must be held.
  */
 void device_release_driver(struct device *dev)
 {
@@ -341,9 +341,9 @@ void device_release_driver(struct device
 	 * within their ->remove callback for the same device, they
 	 * will deadlock right here.
 	 */
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	__device_release_driver(dev);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 EXPORT_SYMBOL_GPL(device_release_driver);
 
@@ -370,13 +370,13 @@ void driver_detach(struct device_driver 
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
Index: linux-2.6-tip/drivers/base/power/main.c
===================================================================
--- linux-2.6-tip.orig/drivers/base/power/main.c
+++ linux-2.6-tip/drivers/base/power/main.c
@@ -33,8 +33,8 @@
  * because children are guaranteed to be discovered after parents, and
  * are inserted at the back of the list on discovery.
  *
- * Since device_pm_add() may be called with a device semaphore held,
- * we must never try to acquire a device semaphore while holding
+ * Since device_pm_add() may be called with a device mutex held,
+ * we must never try to acquire a device mutex while holding
  * dpm_list_mutex.
  */
 
@@ -381,7 +381,7 @@ static int device_resume(struct device *
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 
 	if (dev->bus) {
 		if (dev->bus->pm) {
@@ -414,7 +414,7 @@ static int device_resume(struct device *
 		}
 	}
  End:
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 
 	TRACE_RESUME(error);
 	return error;
@@ -468,7 +468,7 @@ static void dpm_resume(pm_message_t stat
  */
 static void device_complete(struct device *dev, pm_message_t state)
 {
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 
 	if (dev->class && dev->class->pm && dev->class->pm->complete) {
 		pm_dev_dbg(dev, state, "completing class ");
@@ -485,7 +485,7 @@ static void device_complete(struct devic
 		dev->bus->pm->complete(dev);
 	}
 
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 
 /**
@@ -619,7 +619,7 @@ static int device_suspend(struct device 
 {
 	int error = 0;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 
 	if (dev->class) {
 		if (dev->class->pm) {
@@ -654,7 +654,7 @@ static int device_suspend(struct device 
 		}
 	}
  End:
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 
 	return error;
 }
@@ -705,7 +705,7 @@ static int device_prepare(struct device 
 {
 	int error = 0;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 
 	if (dev->bus && dev->bus->pm && dev->bus->pm->prepare) {
 		pm_dev_dbg(dev, state, "preparing ");
@@ -729,7 +729,7 @@ static int device_prepare(struct device 
 		suspend_report_result(dev->class->pm->prepare, error);
 	}
  End:
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 
 	return error;
 }
Index: linux-2.6-tip/drivers/firewire/core-device.c
===================================================================
--- linux-2.6-tip.orig/drivers/firewire/core-device.c
+++ linux-2.6-tip/drivers/firewire/core-device.c
@@ -762,9 +762,9 @@ static int update_unit(struct device *de
 	struct fw_driver *driver = (struct fw_driver *)dev->driver;
 
 	if (is_fw_unit(dev) && driver != NULL && driver->update != NULL) {
-		down(&dev->sem);
+		mutex_lock(&dev->mutex);
 		driver->update(unit);
-		up(&dev->sem);
+		mutex_unlock(&dev->mutex);
 	}
 
 	return 0;
Index: linux-2.6-tip/drivers/ieee1394/nodemgr.c
===================================================================
--- linux-2.6-tip.orig/drivers/ieee1394/nodemgr.c
+++ linux-2.6-tip/drivers/ieee1394/nodemgr.c
@@ -1397,9 +1397,9 @@ static int update_pdrv(struct device *de
 			pdrv = container_of(drv, struct hpsb_protocol_driver,
 					    driver);
 			if (pdrv->update) {
-				down(&ud->device.sem);
+				mutex_lock(&ud->device.mutex);
 				error = pdrv->update(ud);
-				up(&ud->device.sem);
+				mutex_unlock(&ud->device.mutex);
 			}
 			if (error)
 				device_release_driver(&ud->device);
Index: linux-2.6-tip/drivers/net/mlx4/mlx4.h
===================================================================
--- linux-2.6-tip.orig/drivers/net/mlx4/mlx4.h
+++ linux-2.6-tip/drivers/net/mlx4/mlx4.h
@@ -40,6 +40,7 @@
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/timer.h>
+#include <linux/semaphore.h>
 #include <linux/workqueue.h>
 
 #include <linux/mlx4/device.h>
Index: linux-2.6-tip/drivers/pci/bus.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/bus.c
+++ linux-2.6-tip/drivers/pci/bus.c
@@ -240,9 +240,9 @@ void pci_walk_bus(struct pci_bus *top, i
 			next = dev->bus_list.next;
 
 		/* Run device routines with the device locked */
-		down(&dev->dev.sem);
+		mutex_lock(&dev->dev.mutex);
 		retval = cb(dev, userdata);
-		up(&dev->dev.sem);
+		mutex_unlock(&dev->dev.mutex);
 		if (retval)
 			break;
 	}
Index: linux-2.6-tip/drivers/pci/pci.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/pci.c
+++ linux-2.6-tip/drivers/pci/pci.c
@@ -2211,7 +2211,7 @@ static int pci_dev_reset(struct pci_dev 
 	if (!probe) {
 		pci_block_user_cfg_access(dev);
 		/* block PM suspend, driver probe, etc. */
-		down(&dev->dev.sem);
+		mutex_lock(&dev->dev.mutex);
 	}
 
 	rc = pcie_flr(dev, probe);
@@ -2229,7 +2229,7 @@ static int pci_dev_reset(struct pci_dev 
 	rc = pci_parent_bus_reset(dev, probe);
 done:
 	if (!probe) {
-		up(&dev->dev.sem);
+		mutex_unlock(&dev->dev.mutex);
 		pci_unblock_user_cfg_access(dev);
 	}
 
Index: linux-2.6-tip/drivers/pcmcia/ds.c
===================================================================
--- linux-2.6-tip.orig/drivers/pcmcia/ds.c
+++ linux-2.6-tip/drivers/pcmcia/ds.c
@@ -1082,9 +1082,9 @@ static int runtime_suspend(struct device
 {
 	int rc;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	return rc;
 }
 
@@ -1092,9 +1092,9 @@ static void runtime_resume(struct device
 {
 	int rc;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	rc = pcmcia_dev_resume(dev);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 
 /************************ per-device sysfs output ***************************/
Index: linux-2.6-tip/drivers/usb/core/driver.c
===================================================================
--- linux-2.6-tip.orig/drivers/usb/core/driver.c
+++ linux-2.6-tip/drivers/usb/core/driver.c
@@ -391,10 +391,10 @@ void usb_driver_release_interface(struct
 	if (device_is_registered(dev)) {
 		device_release_driver(dev);
 	} else {
-		down(&dev->sem);
+		mutex_lock(&dev->mutex);
 		usb_unbind_interface(dev);
 		dev->driver = NULL;
-		up(&dev->sem);
+		mutex_unlock(&dev->mutex);
 	}
 }
 EXPORT_SYMBOL_GPL(usb_driver_release_interface);
Index: linux-2.6-tip/drivers/uwb/umc-bus.c
===================================================================
--- linux-2.6-tip.orig/drivers/uwb/umc-bus.c
+++ linux-2.6-tip/drivers/uwb/umc-bus.c
@@ -62,12 +62,12 @@ int umc_controller_reset(struct umc_dev 
 	struct device *parent = umc->dev.parent;
 	int ret = 0;
 
-	if(down_trylock(&parent->sem))
+	if (mutex_trylock(&parent->mutex))
 		return -EAGAIN;
 	ret = device_for_each_child(parent, parent, umc_bus_pre_reset_helper);
 	if (ret >= 0)
 		device_for_each_child(parent, parent, umc_bus_post_reset_helper);
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return ret;
 }
Index: linux-2.6-tip/drivers/uwb/uwb-internal.h
===================================================================
--- linux-2.6-tip.orig/drivers/uwb/uwb-internal.h
+++ linux-2.6-tip/drivers/uwb/uwb-internal.h
@@ -366,12 +366,12 @@ struct dentry *uwb_dbg_create_pal_dir(st
 
 static inline void uwb_dev_lock(struct uwb_dev *uwb_dev)
 {
-	down(&uwb_dev->dev.sem);
+	mutex_lock(&uwb_dev->dev.mutex);
 }
 
 static inline void uwb_dev_unlock(struct uwb_dev *uwb_dev)
 {
-	up(&uwb_dev->dev.sem);
+	mutex_unlock(&uwb_dev->dev.mutex);
 }
 
 #endif /* #ifndef __UWB_INTERNAL_H__ */
Index: linux-2.6-tip/include/linux/device.h
===================================================================
--- linux-2.6-tip.orig/include/linux/device.h
+++ linux-2.6-tip/include/linux/device.h
@@ -21,7 +21,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <linux/semaphore.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
@@ -105,7 +104,7 @@ extern int bus_unregister_notifier(struc
 
 /* All 4 notifers below get called with the target struct device *
  * as an argument. Note that those functions are likely to be called
- * with the device semaphore held in the core, so be careful.
+ * with the device mutex held in the core, so be careful.
  */
 #define BUS_NOTIFY_ADD_DEVICE		0x00000001 /* device added */
 #define BUS_NOTIFY_DEL_DEVICE		0x00000002 /* device removed */
@@ -373,7 +372,7 @@ struct device {
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
 
-	struct semaphore	sem;	/* semaphore to synchronize calls to
+	struct mutex		mutex;	/* mutex to synchronize calls to
 					 * its driver.
 					 */
 
Index: linux-2.6-tip/include/linux/usb.h
===================================================================
--- linux-2.6-tip.orig/include/linux/usb.h
+++ linux-2.6-tip/include/linux/usb.h
@@ -529,9 +529,9 @@ extern struct usb_device *usb_get_dev(st
 extern void usb_put_dev(struct usb_device *dev);
 
 /* USB device locking */
-#define usb_lock_device(udev)		down(&(udev)->dev.sem)
-#define usb_unlock_device(udev)		up(&(udev)->dev.sem)
-#define usb_trylock_device(udev)	down_trylock(&(udev)->dev.sem)
+#define usb_lock_device(udev)		mutex_lock(&(udev)->dev.mutex)
+#define usb_unlock_device(udev)		mutex_unlock(&(udev)->dev.mutex)
+#define usb_trylock_device(udev)	mutex_trylock(&(udev)->dev.mutex)
 extern int usb_lock_device_for_reset(struct usb_device *udev,
 				     const struct usb_interface *iface);
 


