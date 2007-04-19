Return-Path: <linux-kernel-owner+w=401wt.eu-S637775AbXDSOUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637775AbXDSOUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 10:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637772AbXDSOUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 10:20:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51761 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S637775AbXDSOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 10:20:54 -0400
Date: Thu, 19 Apr 2007 10:20:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg K-H <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
       <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070419152941.7c4b7ff2@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704191019320.3413-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Cornelia Huck wrote:

> On Thu, 19 Apr 2007 01:06:25 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
> > Heh heh, I'm amazed it actually works.  Agreed that the list walking
> > isn't pretty but adding completion to each kobject still feels like too
> > much of overhead just for release waiting.  Any better ideas?
> 
> Not really. But I'm more in favour on adding a new field than on adding
> complicated code. (Although, the whole device infrastructure wouldn't
> fare bad with some diet...)

The patch below, applied on top of Cornelia's changes plus the 
kobject_init() patch I posted earlier, actually seems to work.  And it 
prevents an oops which I was able to trigger without it.

Alan Stern



Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -479,8 +479,9 @@ static void klist_children_put(struct kl
 
 
 /**
- *	device_initialize - init device structure.
+ *	device_initialize_owner - init device structure.
  *	@dev:	device.
+ *	@owner:	module owing the release routine.
  *
  *	This prepares the device for use by other layers,
  *	including adding it to the device hierarchy.
@@ -489,10 +490,10 @@ static void klist_children_put(struct kl
  *	may use @dev's fields (e.g. the refcount).
  */
 
-void device_initialize(struct device *dev)
+void device_initialize_owner(struct device *dev, struct module *owner)
 {
 	kobj_set_kset_s(dev, devices_subsys);
-	kobject_init(&dev->kobj);
+	kobject_init_owner(&dev->kobj, owner);
 	klist_init(&dev->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
@@ -756,8 +757,9 @@ int device_add(struct device *dev)
 
 
 /**
- *	device_register - register a device with the system.
+ *	device_register_owner - register a device with the system.
  *	@dev:	pointer to the device structure
+ *	@owner:	module owning the release routine
  *
  *	This happens in two clean steps - initialize the device
  *	and add it to the system. The two steps can be called
@@ -767,9 +769,9 @@ int device_add(struct device *dev)
  *	before it is added to the hierarchy.
  */
 
-int device_register(struct device *dev)
+int device_register_owner(struct device *dev, struct module *owner)
 {
-	device_initialize(dev);
+	device_initialize_owner(dev, owner);
 	return device_add(dev);
 }
 
@@ -1013,9 +1015,9 @@ int __init devices_init(void)
 EXPORT_SYMBOL_GPL(device_for_each_child);
 EXPORT_SYMBOL_GPL(device_find_child);
 
-EXPORT_SYMBOL_GPL(device_initialize);
+EXPORT_SYMBOL_GPL(device_initialize_owner);
 EXPORT_SYMBOL_GPL(device_add);
-EXPORT_SYMBOL_GPL(device_register);
+EXPORT_SYMBOL_GPL(device_register_owner);
 
 EXPORT_SYMBOL_GPL(device_del);
 EXPORT_SYMBOL_GPL(device_unregister);
Index: usb-2.6/include/linux/device.h
===================================================================
--- usb-2.6.orig/include/linux/device.h
+++ usb-2.6/include/linux/device.h
@@ -509,9 +509,12 @@ void driver_init(void);
 /*
  * High level routines for use by the bus drivers
  */
-extern int __must_check device_register(struct device * dev);
+extern int __must_check device_register_owner(struct device * dev,
+		struct module *owner);
+#define device_register(dev)	device_register_owner(dev, THIS_MODULE)
 extern void device_unregister(struct device * dev);
-extern void device_initialize(struct device * dev);
+extern void device_initialize_owner(struct device * dev, struct module *owner);
+#define device_initialize(dev)	device_initialize_owner(dev, THIS_MODULE)
 extern int __must_check device_add(struct device * dev);
 extern void device_del(struct device * dev);
 extern int device_for_each_child(struct device *, void *,
Index: usb-2.6/drivers/base/platform.c
===================================================================
--- usb-2.6.orig/drivers/base/platform.c
+++ usb-2.6/drivers/base/platform.c
@@ -106,13 +106,15 @@ EXPORT_SYMBOL_GPL(platform_get_irq_bynam
  *	platform_add_devices - add a numbers of platform devices
  *	@devs: array of platform devices to add
  *	@num: number of platform devices in array
+ *	@owner: module owning the devices in @devs
  */
-int platform_add_devices(struct platform_device **devs, int num)
+int platform_add_devices_owner(struct platform_device **devs, int num,
+		struct module *owner)
 {
 	int i, ret = 0;
 
 	for (i = 0; i < num; i++) {
-		ret = platform_device_register(devs[i]);
+		ret = platform_device_register_owner(devs[i], owner);
 		if (ret) {
 			while (--i >= 0)
 				platform_device_unregister(devs[i]);
@@ -122,7 +124,7 @@ int platform_add_devices(struct platform
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(platform_add_devices);
+EXPORT_SYMBOL_GPL(platform_add_devices_owner);
 
 struct platform_object {
 	struct platform_device pdev;
@@ -311,16 +313,18 @@ void platform_device_del(struct platform
 EXPORT_SYMBOL_GPL(platform_device_del);
 
 /**
- *	platform_device_register - add a platform-level device
+ *	platform_device_register_owner - add a platform-level device
  *	@pdev:	platform device we're adding
+ *	@owner:	module owning @pdev
  *
  */
-int platform_device_register(struct platform_device * pdev)
+int platform_device_register_owner(struct platform_device * pdev,
+		struct module *owner)
 {
-	device_initialize(&pdev->dev);
+	device_initialize_owner(&pdev->dev, owner);
 	return platform_device_add(pdev);
 }
-EXPORT_SYMBOL_GPL(platform_device_register);
+EXPORT_SYMBOL_GPL(platform_device_register_owner);
 
 /**
  *	platform_device_unregister - unregister a platform-level device
Index: usb-2.6/include/linux/platform_device.h
===================================================================
--- usb-2.6.orig/include/linux/platform_device.h
+++ usb-2.6/include/linux/platform_device.h
@@ -23,7 +23,9 @@ struct platform_device {
 
 #define to_platform_device(x) container_of((x), struct platform_device, dev)
 
-extern int platform_device_register(struct platform_device *);
+extern int platform_device_register_owner(struct platform_device *,
+		struct module *owner);
+#define platform_device_register(pdev)	platform_device_register_owner(pdev, THIS_MODULE)
 extern void platform_device_unregister(struct platform_device *);
 
 extern struct bus_type platform_bus_type;
@@ -33,7 +35,9 @@ extern struct resource *platform_get_res
 extern int platform_get_irq(struct platform_device *, unsigned int);
 extern struct resource *platform_get_resource_byname(struct platform_device *, unsigned int, char *);
 extern int platform_get_irq_byname(struct platform_device *, char *);
-extern int platform_add_devices(struct platform_device **, int);
+extern int platform_add_devices_owner(struct platform_device **, int,
+		struct module *owner);
+#define platform_add_devices(devs, n)	platform_add_devices_owner(devs, n, THIS_MODULE)
 
 extern struct platform_device *platform_device_register_simple(char *, unsigned int, struct resource *, unsigned int);
 

