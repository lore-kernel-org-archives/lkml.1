Return-Path: <linux-kernel-owner+w=401wt.eu-S1763609AbXK2Qzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763609AbXK2Qzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760510AbXK2Qzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:55:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57017 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760136AbXK2Qzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:55:45 -0500
Date: Thu, 29 Nov 2007 11:55:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
In-Reply-To: <20071129172833.0203a75b@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0711291152380.4712-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Cornelia Huck wrote:

> > Unfortunately kobjects don't have an owner field.  In practice this 
> > means that it isn't possible to pin the owner of some random kobject -- 
> > you have to know where the kobject came from or what it's embedded in.  
> > All users of kobjects need to work this way.
> 
> Yeah, that is what the-patchset-I-have-to-dig-around-for does:
> Introduce an owner field in the kobject for pinning the module. (IIRC,
> you even did some of the patches?)

Are these two patches what you mean?  They are a little out-of-date
now, but the main idea hasn't changed.

Alan Stern



Index: usb-2.6/include/linux/kobject.h
===================================================================
--- usb-2.6.orig/include/linux/kobject.h
+++ usb-2.6/include/linux/kobject.h
@@ -71,7 +71,8 @@ static inline const char * kobject_name(
 	return kobj->k_name;
 }
 
-extern void kobject_init(struct kobject *);
+extern void kobject_init_owner(struct kobject *, struct module *owner);
+#define kobject_init(kobj)	kobject_init_owner(kobj, THIS_MODULE)
 extern void kobject_cleanup(struct kobject *);
 
 extern int __must_check kobject_add(struct kobject *);
@@ -84,7 +85,9 @@ extern int __must_check kobject_shadow_r
 						const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
-extern int __must_check kobject_register(struct kobject *);
+extern int __must_check kobject_register_owner(struct kobject *,
+		struct module *owner);
+#define kobject_register(kobj)	kobject_register_owner(kobj, THIS_MODULE)
 extern void kobject_unregister(struct kobject *);
 
 extern struct kobject * kobject_get(struct kobject *);
Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -164,10 +164,11 @@ static void verify_dynamic_kobject_alloc
 #endif
 
 /**
- *	kobject_init - initialize object.
+ *	kobject_init_onwer - initialize object.
  *	@kobj:	object in question.
+ *	@owner: module owning @kobj.
  */
-void kobject_init(struct kobject * kobj)
+void kobject_init_owner(struct kobject * kobj, struct module *owner)
 {
 	if (!kobj)
 		return;
@@ -178,6 +179,7 @@ void kobject_init(struct kobject * kobj)
 	init_waitqueue_head(&kobj->poll);
 	kobj->kset = kset_get(kobj->kset);
 	/* Attempt to grab reference of owning module's kobject. */
+	kobj->owner = owner;
 	mod_kobject_get(kobj->owner);
 }
 
@@ -272,15 +274,16 @@ int kobject_add(struct kobject * kobj)
 
 
 /**
- *	kobject_register - initialize and add an object.
+ *	kobject_register_owner - initialize and add an object.
  *	@kobj:	object in question.
+ *	@owner:	module owning @kobj.
  */
 
-int kobject_register(struct kobject * kobj)
+int kobject_register_owner(struct kobject * kobj, struct module *owner)
 {
 	int error = -EINVAL;
 	if (kobj) {
-		kobject_init(kobj);
+		kobject_init_owner(kobj, owner);
 		error = kobject_add(kobj);
 		if (!error)
 			kobject_uevent(kobj, KOBJ_ADD);
@@ -750,8 +753,8 @@ void subsys_remove_file(struct subsystem
 }
 #endif  /*  0  */
 
-EXPORT_SYMBOL(kobject_init);
-EXPORT_SYMBOL(kobject_register);
+EXPORT_SYMBOL(kobject_init_owner);
+EXPORT_SYMBOL(kobject_register_owner);
 EXPORT_SYMBOL(kobject_unregister);
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);




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
 

