Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbXKEK53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbXKEK53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXKEK5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:57:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbXKEK5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:57:19 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <peterz@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1194259581.27652.418.camel@twins>
References: <20071103124823.6059640e@shemminger-laptop>
	 <1194208158.5911.63.camel@lappy>  <20071105035855.GA25511@kroah.com>
	 <1194259581.27652.418.camel@twins>
Content-Type: text/plain
Date: Mon, 05 Nov 2007 11:57:14 +0100
Message-Id: <1194260234.27652.425.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, the problem seems to be stuff like:

add usb driver to pci
  scan pci devices
     add usb host controller device
        scan usb devices
          add usb hub device
            scan usb devices
              add usb .....

This seems to be able to go on forever, as long as one can cascade usb
hubs. Doesn't seem like an ideal thing to do from a stack space POV
either.

Would it be possible to break at the second scan, that is the device
probe and stick that into a workqueue or something. Then we'd only ever
have driver->device nesting.



Anyway, for those who care here is the patch:

---
 drivers/base/bus.c                |   20 ++++++++++----------
 drivers/base/class.c              |   22 +++++++++++-----------
 drivers/base/core.c               |   20 +++++++++-----------
 drivers/base/dd.c                 |   38 +++++++++++++++++++-------------------
 drivers/base/power/main.c         |    8 ++++----
 drivers/pci/bus.c                 |    4 ++--
 drivers/pnp/interface.c           |   10 +++++-----
 drivers/pnp/manager.c             |   18 +++++++++---------
 drivers/power/power_supply_core.c |    8 ++++----
 drivers/rtc/interface.c           |    4 ++--
 drivers/scsi/hosts.c              |    4 ++--
 drivers/spi/spi.c                 |   10 +++++-----
 drivers/usb/core/hub.c            |    4 ++--
 include/linux/device.h            |   18 +++++++++++-------
 include/linux/usb.h               |    6 +++---
 15 files changed, 98 insertions(+), 96 deletions(-)

Index: linux-2.6-2/drivers/base/bus.c
===================================================================
--- linux-2.6-2.orig/drivers/base/bus.c
+++ linux-2.6-2/drivers/base/bus.c
@@ -190,10 +190,10 @@ static ssize_t driver_unbind(struct devi
 	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
 	if (dev && dev->driver == drv) {
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
+			mutex_lock_nested(&dev->parent->mutex, DRIVER_PARENT);
 		device_release_driver(dev);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 		err = count;
 	}
 	put_device(dev);
@@ -217,12 +217,12 @@ static ssize_t driver_bind(struct device
 	dev = bus_find_device(bus, NULL, (void *)buf, driver_helper);
 	if (dev && dev->driver == NULL) {
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
-		down(&dev->sem);
+			mutex_lock_nested(&dev->parent->mutex, DRIVER_PARENT);
+		mutex_lock_nested(&dev->mutex, DRIVER_NORMAL);
 		err = driver_probe_device(drv, dev);
-		up(&dev->sem);
+		mutex_unlock(&dev->mutex);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 
 		if (err > 0) 		/* success */
 			err = count;
@@ -711,10 +711,10 @@ static int __must_check bus_rescan_devic
 
 	if (!dev->driver) {
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
+			mutex_lock_nested(&dev->parent->mutex, DEVICE_PARENT);
 		ret = device_attach(dev);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 	}
 	return ret < 0 ? ret : 0;
 }
@@ -745,10 +745,10 @@ int device_reprobe(struct device *dev)
 {
 	if (dev->driver) {
 		if (dev->parent)        /* Needed for USB */
-			down(&dev->parent->sem);
+			mutex_lock_nested(&dev->parent->mutex, DEVICE_PARENT);
 		device_release_driver(dev);
 		if (dev->parent)
-			up(&dev->parent->sem);
+			mutex_unlock(&dev->parent->mutex);
 	}
 	return bus_rescan_devices_helper(dev, NULL);
 }
Index: linux-2.6-2/drivers/base/class.c
===================================================================
--- linux-2.6-2.orig/drivers/base/class.c
+++ linux-2.6-2/drivers/base/class.c
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
+		mutex_lock_nested(&parent_class->mutex, SINGLE_DEPTH_NESTING);
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
@@ -812,7 +812,7 @@ int class_interface_register(struct clas
 	if (!parent)
 		return -EINVAL;
 
-	down(&parent->sem);
+	mutex_lock_nested(&parent->mutex, SINGLE_DEPTH_NESTING);
 	list_add_tail(&class_intf->node, &parent->interfaces);
 	if (class_intf->add) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -822,7 +822,7 @@ int class_interface_register(struct clas
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->add_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	return 0;
 }
@@ -836,7 +836,7 @@ void class_interface_unregister(struct c
 	if (!parent)
 		return;
 
-	down(&parent->sem);
+	mutex_lock_nested(&parent->mutex, SINGLE_DEPTH_NESTING);
 	list_del_init(&class_intf->node);
 	if (class_intf->remove) {
 		list_for_each_entry(class_dev, &parent->children, node)
@@ -846,7 +846,7 @@ void class_interface_unregister(struct c
 		list_for_each_entry(dev, &parent->devices, node)
 			class_intf->remove_dev(dev, class_intf);
 	}
-	up(&parent->sem);
+	mutex_unlock(&parent->mutex);
 
 	class_put(parent);
 }
Index: linux-2.6-2/drivers/base/core.c
===================================================================
--- linux-2.6-2.orig/drivers/base/core.c
+++ linux-2.6-2/drivers/base/core.c
@@ -19,8 +19,6 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 
-#include <asm/semaphore.h>
-
 #include "base.h"
 #include "power/power.h"
 
@@ -531,7 +529,7 @@ void device_initialize(struct device *de
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	INIT_LIST_HEAD(&dev->node);
-	init_MUTEX(&dev->sem);
+	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
 	device_init_wakeup(dev, 0);
@@ -782,7 +780,7 @@ int device_add(struct device *dev)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
 
 	if (dev->class) {
-		down(&dev->class->sem);
+		mutex_lock(&dev->class->mutex);
 		/* tie the class to the device */
 		list_add_tail(&dev->node, &dev->class->devices);
 
@@ -790,7 +788,7 @@ int device_add(struct device *dev)
 		list_for_each_entry(class_intf, &dev->class->interfaces, node)
 			if (class_intf->add_dev)
 				class_intf->add_dev(dev, class_intf);
-		up(&dev->class->sem);
+		mutex_unlock(&dev->class->mutex);
 	}
  Done:
 	put_device(dev);
@@ -926,14 +924,14 @@ void device_del(struct device * dev)
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
@@ -944,7 +942,7 @@ void device_del(struct device * dev)
 			 * if we are the last child of our class, delete
 			 * our class-directory at this parent
 			 */
-			down(&dev->class->sem);
+			mutex_lock(&dev->class->mutex);
 			list_for_each_entry(d, &dev->class->devices, node) {
 				if (d == dev)
 					continue;
@@ -957,7 +955,7 @@ void device_del(struct device * dev)
 				kobject_del(dev->kobj.parent);
 
 			kobject_put(dev->kobj.parent);
-			up(&dev->class->sem);
+			mutex_unlock(&dev->class->mutex);
 		}
 	}
 	device_remove_file(dev, &uevent_attr);
@@ -1166,14 +1164,14 @@ void device_destroy(struct class *class,
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
Index: linux-2.6-2/drivers/base/dd.c
===================================================================
--- linux-2.6-2.orig/drivers/base/dd.c
+++ linux-2.6-2/drivers/base/dd.c
@@ -82,7 +82,7 @@ static void driver_sysfs_remove(struct d
  *	for before calling this. (It is ok to call with no other effort
  *	from a driver's probe() method.)
  *
- *	This function must be called with @dev->sem held.
+ *	This function must be called with @dev->mutex held.
  */
 int device_bind_driver(struct device *dev)
 {
@@ -180,8 +180,8 @@ int driver_probe_done(void)
  * This function returns 1 if a match is found, -ENODEV if the device is
  * not registered, and 0 otherwise.
  *
- * This function must be called with @dev->sem held.  When called for a
- * USB interface, @dev->parent->sem must be held as well.
+ * This function must be called with @dev->mutex held.  When called for a
+ * USB interface, @dev->parent->mutex must be held as well.
  */
 int driver_probe_device(struct device_driver * drv, struct device * dev)
 {
@@ -219,13 +219,13 @@ static int __device_attach(struct device
  *	0 if no matching device was found;
  *	-ENODEV if the device is not registered.
  *
- *	When called for a USB interface, @dev->parent->sem must be held.
+ *	When called for a USB interface, @dev->parent->mutex must be held.
  */
 int device_attach(struct device * dev)
 {
 	int ret = 0;
 
-	down(&dev->sem);
+	mutex_lock_nested(&dev->mutex, DEVICE_NORMAL);
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
+		mutex_lock_nested(&dev->parent->mutex, DRIVER_PARENT);
+	mutex_lock_nested(&dev->mutex, DRIVER_NORMAL);
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
+ *	__device_release_driver() must be called with @dev->mutex held.
+ *	When called for a USB interface, @dev->parent->mutex must be held as well.
  */
 static void __device_release_driver(struct device * dev)
 {
@@ -315,7 +315,7 @@ static void __device_release_driver(stru
  *	@dev:	device.
  *
  *	Manually detach device from driver.
- *	When called for a USB interface, @dev->parent->sem must be held.
+ *	When called for a USB interface, @dev->parent->mutex must be held.
  */
 void device_release_driver(struct device * dev)
 {
@@ -324,9 +324,9 @@ void device_release_driver(struct device
 	 * within their ->remove callback for the same device, they
 	 * will deadlock right here.
 	 */
-	down(&dev->sem);
+	mutex_lock_nested(&dev->mutex, DEVICE_NORMAL);
 	__device_release_driver(dev);
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 }
 
 
@@ -350,13 +350,13 @@ void driver_detach(struct device_driver 
 		spin_unlock(&drv->klist_devices.k_lock);
 
 		if (dev->parent)	/* Needed for USB */
-			down(&dev->parent->sem);
-		down(&dev->sem);
+			mutex_lock_nested(&dev->parent->mutex, DRIVER_PARENT);
+		mutex_lock_nested(&dev->mutex, DRIVER_NORMAL);
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
Index: linux-2.6-2/drivers/base/power/main.c
===================================================================
--- linux-2.6-2.orig/drivers/base/power/main.c
+++ linux-2.6-2/drivers/base/power/main.c
@@ -81,7 +81,7 @@ static int resume_device(struct device *
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
@@ -98,7 +98,7 @@ static int resume_device(struct device *
 		error = dev->class->resume(dev);
 	}
 
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 
 	TRACE_RESUME(error);
 	return error;
@@ -247,7 +247,7 @@ static int suspend_device(struct device 
 {
 	int error = 0;
 
-	down(&dev->sem);
+	mutex_lock(&dev->mutex);
 	if (dev->power.power_state.event) {
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
@@ -270,7 +270,7 @@ static int suspend_device(struct device 
 		error = dev->bus->suspend(dev, state);
 		suspend_report_result(dev->bus->suspend, error);
 	}
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 	return error;
 }
 
Index: linux-2.6-2/drivers/pci/bus.c
===================================================================
--- linux-2.6-2.orig/drivers/pci/bus.c
+++ linux-2.6-2/drivers/pci/bus.c
@@ -198,9 +198,9 @@ void pci_walk_bus(struct pci_bus *top, v
 			next = dev->bus_list.next;
 
 		/* Run device routines with the device locked */
-		down(&dev->dev.sem);
+		mutex_lock(&dev->dev.mutex);
 		cb(dev, userdata);
-		up(&dev->dev.sem);
+		mutex_unlock(&dev->dev.mutex);
 	}
 	up_read(&pci_bus_sem);
 }
Index: linux-2.6-2/drivers/pnp/interface.c
===================================================================
--- linux-2.6-2.orig/drivers/pnp/interface.c
+++ linux-2.6-2/drivers/pnp/interface.c
@@ -315,7 +315,7 @@ static ssize_t pnp_show_current_resource
 	return ret;
 }
 
-extern struct semaphore pnp_res_mutex;
+extern struct mutex pnp_res_mutex;
 
 static ssize_t
 pnp_set_current_resources(struct device *dmdev, struct device_attribute *attr,
@@ -361,10 +361,10 @@ pnp_set_current_resources(struct device 
 		goto done;
 	}
 	if (!strnicmp(buf, "get", 3)) {
-		down(&pnp_res_mutex);
+		mutex_lock(&pnp_res_mutex);
 		if (pnp_can_read(dev))
 			dev->protocol->get(dev, &dev->res);
-		up(&pnp_res_mutex);
+		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
 	if (!strnicmp(buf, "set", 3)) {
@@ -373,7 +373,7 @@ pnp_set_current_resources(struct device 
 			goto done;
 		buf += 3;
 		pnp_init_resource_table(&dev->res);
-		down(&pnp_res_mutex);
+		mutex_lock(&pnp_res_mutex);
 		while (1) {
 			while (isspace(*buf))
 				++buf;
@@ -455,7 +455,7 @@ pnp_set_current_resources(struct device 
 			}
 			break;
 		}
-		up(&pnp_res_mutex);
+		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
 
Index: linux-2.6-2/drivers/pnp/manager.c
===================================================================
--- linux-2.6-2.orig/drivers/pnp/manager.c
+++ linux-2.6-2/drivers/pnp/manager.c
@@ -14,7 +14,7 @@
 #include <linux/bitmap.h>
 #include "base.h"
 
-DECLARE_MUTEX(pnp_res_mutex);
+DEFINE_MUTEX(pnp_res_mutex);
 
 static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
 {
@@ -297,7 +297,7 @@ static int pnp_assign_resources(struct p
 	if (!pnp_can_configure(dev))
 		return -ENODEV;
 
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);	/* start with a fresh slate */
 	if (dev->independent) {
 		port = dev->independent->port;
@@ -366,12 +366,12 @@ static int pnp_assign_resources(struct p
 	} else if (dev->dependent)
 		goto fail;
 
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	return 1;
 
 fail:
 	pnp_clean_resource_table(&dev->res);
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	return 0;
 }
 
@@ -396,7 +396,7 @@ int pnp_manual_config_dev(struct pnp_dev
 		return -ENOMEM;
 	*bak = dev->res;
 
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	dev->res = *res;
 	if (!(mode & PNP_CONFIG_FORCE)) {
 		for (i = 0; i < PNP_MAX_PORT; i++) {
@@ -416,14 +416,14 @@ int pnp_manual_config_dev(struct pnp_dev
 				goto fail;
 		}
 	}
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 
 	kfree(bak);
 	return 0;
 
 fail:
 	dev->res = *bak;
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 	kfree(bak);
 	return -EINVAL;
 }
@@ -547,9 +547,9 @@ int pnp_disable_dev(struct pnp_dev *dev)
 	dev->active = 0;
 
 	/* release the resources so that other devices can use them */
-	down(&pnp_res_mutex);
+	mutex_lock(&pnp_res_mutex);
 	pnp_clean_resource_table(&dev->res);
-	up(&pnp_res_mutex);
+	mutex_unlock(&pnp_res_mutex);
 
 	return 1;
 }
Index: linux-2.6-2/drivers/power/power_supply_core.c
===================================================================
--- linux-2.6-2.orig/drivers/power/power_supply_core.c
+++ linux-2.6-2/drivers/power/power_supply_core.c
@@ -31,7 +31,7 @@ static void power_supply_changed_work(st
 	for (i = 0; i < psy->num_supplicants; i++) {
 		struct device *dev;
 
-		down(&power_supply_class->sem);
+		mutex_lock(&power_supply_class->mutex);
 		list_for_each_entry(dev, &power_supply_class->devices, node) {
 			struct power_supply *pst = dev_get_drvdata(dev);
 
@@ -40,7 +40,7 @@ static void power_supply_changed_work(st
 					pst->external_power_changed(pst);
 			}
 		}
-		up(&power_supply_class->sem);
+		mutex_unlock(&power_supply_class->mutex);
 	}
 
 	power_supply_update_leds(psy);
@@ -60,7 +60,7 @@ int power_supply_am_i_supplied(struct po
 	union power_supply_propval ret = {0,};
 	struct device *dev;
 
-	down(&power_supply_class->sem);
+	mutex_lock(&power_supply_class->mutex);
 	list_for_each_entry(dev, &power_supply_class->devices, node) {
 		struct power_supply *epsy = dev_get_drvdata(dev);
 		int i;
@@ -76,7 +76,7 @@ int power_supply_am_i_supplied(struct po
 		}
 	}
 out:
-	up(&power_supply_class->sem);
+	mutex_unlock(&power_supply_class->mutex);
 
 	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret.intval);
 
Index: linux-2.6-2/drivers/rtc/interface.c
===================================================================
--- linux-2.6-2.orig/drivers/rtc/interface.c
+++ linux-2.6-2/drivers/rtc/interface.c
@@ -256,7 +256,7 @@ struct rtc_device *rtc_class_open(char *
 	struct device *dev;
 	struct rtc_device *rtc = NULL;
 
-	down(&rtc_class->sem);
+	mutex_lock(&rtc_class->mutex);
 	list_for_each_entry(dev, &rtc_class->devices, node) {
 		if (strncmp(dev->bus_id, name, BUS_ID_SIZE) == 0) {
 			dev = get_device(dev);
@@ -272,7 +272,7 @@ struct rtc_device *rtc_class_open(char *
 			rtc = NULL;
 		}
 	}
-	up(&rtc_class->sem);
+	mutex_unlock(&rtc_class->mutex);
 
 	return rtc;
 }
Index: linux-2.6-2/drivers/scsi/hosts.c
===================================================================
--- linux-2.6-2.orig/drivers/scsi/hosts.c
+++ linux-2.6-2/drivers/scsi/hosts.c
@@ -443,7 +443,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 	struct class_device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(cdev, &class->children, node) {
 		p = class_to_shost(cdev);
 		if (p->host_no == hostnum) {
@@ -451,7 +451,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 			break;
 		}
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return shost;
 }
Index: linux-2.6-2/drivers/spi/spi.c
===================================================================
--- linux-2.6-2.orig/drivers/spi/spi.c
+++ linux-2.6-2/drivers/spi/spi.c
@@ -499,7 +499,7 @@ struct spi_master *spi_busnum_to_master(
 	struct spi_master	*master = NULL;
 	struct spi_master	*m;
 
-	down(&spi_master_class.sem);
+	mutex_lock(&spi_master_class.mutex);
 	list_for_each_entry(dev, &spi_master_class.children, node) {
 		m = container_of(dev, struct spi_master, dev);
 		if (m->bus_num == bus_num) {
@@ -507,7 +507,7 @@ struct spi_master *spi_busnum_to_master(
 			break;
 		}
 	}
-	up(&spi_master_class.sem);
+	mutex_unlock(&spi_master_class.mutex);
 	return master;
 }
 EXPORT_SYMBOL_GPL(spi_busnum_to_master);
@@ -587,7 +587,7 @@ int spi_write_then_read(struct spi_devic
 		const u8 *txbuf, unsigned n_tx,
 		u8 *rxbuf, unsigned n_rx)
 {
-	static DECLARE_MUTEX(lock);
+	static DEFINE_MUTEX(lock);
 
 	int			status;
 	struct spi_message	message;
@@ -613,7 +613,7 @@ int spi_write_then_read(struct spi_devic
 	}
 
 	/* ... unless someone else is using the pre-allocated buffer */
-	if (down_trylock(&lock)) {
+	if (mutex_trylock(&lock)) {
 		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
 		if (!local_buf)
 			return -ENOMEM;
@@ -632,7 +632,7 @@ int spi_write_then_read(struct spi_devic
 	}
 
 	if (x[0].tx_buf == buf)
-		up(&lock);
+		mutex_unlock(&lock);
 	else
 		kfree(local_buf);
 
Index: linux-2.6-2/drivers/usb/core/hub.c
===================================================================
--- linux-2.6-2.orig/drivers/usb/core/hub.c
+++ linux-2.6-2/drivers/usb/core/hub.c
@@ -3143,7 +3143,7 @@ int usb_reset_composite_device(struct us
 		for (i = 0; i < config->desc.bNumInterfaces; ++i) {
 			cintf = config->interface[i];
 			if (cintf != iface)
-				down(&cintf->dev.sem);
+				mutex_lock(&cintf->dev.mutex);
 			if (device_is_registered(&cintf->dev) &&
 					cintf->dev.driver) {
 				drv = to_usb_driver(cintf->dev.driver);
@@ -3171,7 +3171,7 @@ int usb_reset_composite_device(struct us
 	/* FIXME: Unbind if post_reset returns an error or isn't defined */
 			}
 			if (cintf != iface)
-				up(&cintf->dev.sem);
+				mutex_unlock(&cintf->dev.mutex);
 		}
 	}
 
Index: linux-2.6-2/include/linux/device.h
===================================================================
--- linux-2.6-2.orig/include/linux/device.h
+++ linux-2.6-2/include/linux/device.h
@@ -20,7 +20,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pm.h>
-#include <asm/semaphore.h>
+#include <asm/mutex.h>
 #include <asm/atomic.h>
 #include <asm/device.h>
 
@@ -110,7 +110,7 @@ extern int bus_unregister_notifier(struc
 
 /* All 4 notifers below get called with the target struct device *
  * as an argument. Note that those functions are likely to be called
- * with the device semaphore held in the core, so be careful.
+ * with the device mutex held in the core, so be careful.
  */
 #define BUS_NOTIFY_ADD_DEVICE		0x00000001 /* device added */
 #define BUS_NOTIFY_DEL_DEVICE		0x00000002 /* device removed */
@@ -137,7 +137,6 @@ struct device_driver {
 	int	(*resume)	(struct device * dev);
 };
 
-
 extern int __must_check driver_register(struct device_driver * drv);
 extern void driver_unregister(struct device_driver * drv);
 
@@ -180,7 +179,7 @@ struct class {
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
-	struct semaphore	sem;	/* locks both the children and interfaces lists */
+	struct mutex		mutex;	/* locks both the children and interfaces lists */
 
 	struct class_attribute		* class_attrs;
 	struct class_device_attribute	* class_dev_attrs;
@@ -410,9 +409,7 @@ struct device {
 	unsigned		is_registered:1;
 	unsigned		uevent_suppress:1;
 
-	struct semaphore	sem;	/* semaphore to synchronize calls to
-					 * its driver.
-					 */
+	struct mutex		mutex;	/* synchronize calls to its driver. */
 
 	struct bus_type	* bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
@@ -451,6 +448,13 @@ struct device {
 	void	(*release)(struct device * dev);
 };
 
+enum {
+	DEVICE_NORMAL,
+	DEVICE_PARENT,
+	DRIVER_NORMAL,
+	DRIVER_PARENT,
+};
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
Index: linux-2.6-2/include/linux/usb.h
===================================================================
--- linux-2.6-2.orig/include/linux/usb.h
+++ linux-2.6-2/include/linux/usb.h
@@ -439,9 +439,9 @@ extern struct usb_device *usb_get_dev(st
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
 


