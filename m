Return-Path: <linux-kernel-owner+w=401wt.eu-S1761794AbXFCLWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794AbXFCLWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 07:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXFCLWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 07:22:31 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42146 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbXFCLWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 07:22:30 -0400
Date: Sun, 3 Jun 2007 13:22:24 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
 <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz>
 <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Justin Piszcz wrote:

> > Thanks. Does by any chance reverting the commit 
> > 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?
> I have not played around with git/etc enough to back it out, if you have a
> patch that applies on top of 2.6.22-rc3 that backs it out I can give it a try.

Please try this

diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index f493fb1..2fc0f88 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -31,30 +31,7 @@ config USB_DEVICEFS
 	  For the format of the various /proc/bus/usb/ files, please read
 	  <file:Documentation/usb/proc_usb_info.txt>.
 
-	  Usbfs files can't handle Access Control Lists (ACL), which are the
-	  default way to grant access to USB devices for untrusted users of a
-	  desktop system. The usbfs functionality is replaced by real
-	  device-nodes managed by udev. These nodes live in /dev/bus/usb and
-	  are used by libusb.
-
-config USB_DEVICE_CLASS
-	bool "USB device class-devices (DEPRECATED)"
-	depends on USB
-	default n
-	---help---
-	  Userspace access to USB devices is granted by device-nodes exported
-	  directly from the usbdev in sysfs. Old versions of the driver
-	  core and udev needed additional class devices to export device nodes.
-
-	  These additional devices are difficult to handle in userspace, if
-	  information about USB interfaces must be available. One device contains
-	  the device node, the other device contains the interface data. Both
-	  devices are at the same level in sysfs (siblings) and one can't access
-	  the other. The device node created directly by the usbdev is the parent
-	  device of the interface and therefore easily accessible from the interface
-	  event.
-
-	  This option provides backward compatibility if needed.
+	  Most users want to say Y here.
 
 config USB_DYNAMIC_MINORS
 	bool "Dynamic USB minor allocation (EXPERIMENTAL)"
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 927a181..4fcbef1 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -57,6 +57,7 @@
 
 #define USB_MAXBUS			64
 #define USB_DEVICE_MAX			USB_MAXBUS * 128
+static struct class *usb_device_class;
 
 /* Mutual exclusion for removal, open, and release */
 DEFINE_MUTEX(usbfs_mutex);
@@ -513,25 +514,22 @@ static int check_ctrlrecip(struct dev_st
 	return ret;
 }
 
-static int __match_minor(struct device *dev, void *data)
+static struct usb_device *usbdev_lookup_minor(int minor)
 {
-	int minor = *((int *)data);
+	struct device *device;
+	struct usb_device *udev = NULL;
 
-	if (dev->devt == MKDEV(USB_DEVICE_MAJOR, minor))
-		return 1;
-	return 0;
-}
-
-static struct usb_device *usbdev_lookup_by_minor(int minor)
-{
-	struct device *dev;
+	down(&usb_device_class->sem);
+	list_for_each_entry(device, &usb_device_class->devices, node) {
+		if (device->devt == MKDEV(USB_DEVICE_MAJOR, minor)) {
+			udev = device->platform_data;
+			break;
+		}
+	}
+	up(&usb_device_class->sem);
 
-	dev = bus_find_device(&usb_bus_type, NULL, &minor, __match_minor);
-	if (!dev)
-		return NULL;
-	put_device(dev);
-	return container_of(dev, struct usb_device, dev);
-}
+	return udev;
+};
 
 /*
  * file operations
@@ -550,14 +548,11 @@ static int usbdev_open(struct inode *ino
 		goto out;
 
 	ret = -ENOENT;
-	/* usbdev device-node */
+	/* check if we are called from a real node or usbfs */
 	if (imajor(inode) == USB_DEVICE_MAJOR)
-		dev = usbdev_lookup_by_minor(iminor(inode));
-#ifdef CONFIG_USB_DEVICEFS
-	/* procfs file */
+		dev = usbdev_lookup_minor(iminor(inode));
 	if (!dev)
 		dev = inode->i_private;
-#endif
 	if (!dev)
 		goto out;
 	ret = usb_autoresume_device(dev);
@@ -1575,7 +1570,7 @@ static unsigned int usbdev_poll(struct f
 	return mask;
 }
 
-const struct file_operations usbdev_file_operations = {
+const struct file_operations usbfs_device_file_operations = {
 	.llseek =	usbdev_lseek,
 	.read =		usbdev_read,
 	.poll =		usbdev_poll,
@@ -1584,53 +1579,50 @@ const struct file_operations usbdev_file
 	.release =	usbdev_release,
 };
 
-#ifdef CONFIG_USB_DEVICE_CLASS
-static struct class *usb_classdev_class;
-
-static int usb_classdev_add(struct usb_device *dev)
+static int usbdev_add(struct usb_device *dev)
 {
 	int minor = ((dev->bus->busnum-1) * 128) + (dev->devnum-1);
 
-	dev->usb_classdev = device_create(usb_classdev_class, &dev->dev,
+	dev->usbfs_dev = device_create(usb_device_class, &dev->dev,
 				MKDEV(USB_DEVICE_MAJOR, minor),
 				"usbdev%d.%d", dev->bus->busnum, dev->devnum);
-	if (IS_ERR(dev->usb_classdev))
-		return PTR_ERR(dev->usb_classdev);
+	if (IS_ERR(dev->usbfs_dev))
+		return PTR_ERR(dev->usbfs_dev);
 
+	dev->usbfs_dev->platform_data = dev;
 	return 0;
 }
 
-static void usb_classdev_remove(struct usb_device *dev)
+static void usbdev_remove(struct usb_device *dev)
 {
-	device_unregister(dev->usb_classdev);
+	device_unregister(dev->usbfs_dev);
 }
 
-static int usb_classdev_notify(struct notifier_block *self,
-			       unsigned long action, void *dev)
+static int usbdev_notify(struct notifier_block *self, unsigned long action,
+			 void *dev)
 {
 	switch (action) {
 	case USB_DEVICE_ADD:
-		if (usb_classdev_add(dev))
+		if (usbdev_add(dev))
 			return NOTIFY_BAD;
 		break;
 	case USB_DEVICE_REMOVE:
-		usb_classdev_remove(dev);
+		usbdev_remove(dev);
 		break;
 	}
 	return NOTIFY_OK;
 }
 
 static struct notifier_block usbdev_nb = {
-	.notifier_call = 	usb_classdev_notify,
+	.notifier_call = 	usbdev_notify,
 };
-#endif
 
 static struct cdev usb_device_cdev = {
 	.kobj   = {.name = "usb_device", },
 	.owner  = THIS_MODULE,
 };
 
-int __init usb_devio_init(void)
+int __init usbdev_init(void)
 {
 	int retval;
 
@@ -1640,38 +1632,38 @@ int __init usb_devio_init(void)
 		err("unable to register minors for usb_device");
 		goto out;
 	}
-	cdev_init(&usb_device_cdev, &usbdev_file_operations);
+	cdev_init(&usb_device_cdev, &usbfs_device_file_operations);
 	retval = cdev_add(&usb_device_cdev, USB_DEVICE_DEV, USB_DEVICE_MAX);
 	if (retval) {
 		err("unable to get usb_device major %d", USB_DEVICE_MAJOR);
 		goto error_cdev;
 	}
-#ifdef CONFIG_USB_DEVICE_CLASS
-	usb_classdev_class = class_create(THIS_MODULE, "usb_device");
-	if (IS_ERR(usb_classdev_class)) {
+	usb_device_class = class_create(THIS_MODULE, "usb_device");
+	if (IS_ERR(usb_device_class)) {
 		err("unable to register usb_device class");
-		retval = PTR_ERR(usb_classdev_class);
-		cdev_del(&usb_device_cdev);
-		usb_classdev_class = NULL;
-		goto out;
+		retval = PTR_ERR(usb_device_class);
+		goto error_class;
 	}
 
 	usb_register_notify(&usbdev_nb);
-#endif
+
 out:
 	return retval;
 
+error_class:
+	usb_device_class = NULL;
+	cdev_del(&usb_device_cdev);
+
 error_cdev:
 	unregister_chrdev_region(USB_DEVICE_DEV, USB_DEVICE_MAX);
 	goto out;
 }
 
-void usb_devio_cleanup(void)
+void usbdev_cleanup(void)
 {
-#ifdef CONFIG_USB_DEVICE_CLASS
 	usb_unregister_notify(&usbdev_nb);
-	class_destroy(usb_classdev_class);
-#endif
+	class_destroy(usb_device_class);
 	cdev_del(&usb_device_cdev);
 	unregister_chrdev_region(USB_DEVICE_DEV, USB_DEVICE_MAX);
 }
+
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 2619986..a2dd98c 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -574,10 +574,23 @@ static int usb_device_match(struct devic
 }
 
 #ifdef	CONFIG_HOTPLUG
+
+/*
+ * This sends an uevent to userspace, typically helping to load driver
+ * or other modules, configure the device, and more.  Drivers can provide
+ * a MODULE_DEVICE_TABLE to help with module loading subtasks.
+ *
+ * We're called either from khubd (the typical case) or from root hub
+ * (init, kapmd, modprobe, rmmod, etc), but the agents need to handle
+ * delays in event delivery.  Use sysfs (and DEVPATH) to make sure the
+ * device (and this configuration!) are still present.
+ */
 static int usb_uevent(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size)
 {
+	struct usb_interface *intf;
 	struct usb_device *usb_dev;
+	struct usb_host_interface *alt;
 	int i = 0;
 	int length = 0;
 
@@ -587,11 +600,13 @@ static int usb_uevent(struct device *dev
 	/* driver is often null here; dev_dbg() would oops */
 	pr_debug ("usb %s: uevent\n", dev->bus_id);
 
-	if (is_usb_device(dev))
+	if (is_usb_device(dev)) {
 		usb_dev = to_usb_device(dev);
-	else {
-		struct usb_interface *intf = to_usb_interface(dev);
+		alt = NULL;
+	} else {
+		intf = to_usb_interface(dev);
 		usb_dev = interface_to_usbdev(intf);
+		alt = intf->cur_altsetting;
 	}
 
 	if (usb_dev->devnum < 0) {
@@ -606,7 +621,9 @@ static int usb_uevent(struct device *dev
 #ifdef	CONFIG_USB_DEVICEFS
 	/* If this is available, userspace programs can directly read
 	 * all the device descriptors we don't tell them about.  Or
-	 * act as usermode drivers.
+	 * even act as usermode drivers.
+	 *
+	 * FIXME reduce hardwired intelligence here
 	 */
 	if (add_uevent_var(envp, num_envp, &i,
 			   buffer, buffer_size, &length,
@@ -633,29 +650,44 @@ static int usb_uevent(struct device *dev
 			   usb_dev->descriptor.bDeviceProtocol))
 		return -ENOMEM;
 
-	if (add_uevent_var(envp, num_envp, &i,
+	if (!is_usb_device(dev)) {
+
+		if (add_uevent_var(envp, num_envp, &i,
 			   buffer, buffer_size, &length,
-			   "BUSNUM=%03d",
-			   usb_dev->bus->busnum))
-		return -ENOMEM;
+			   "INTERFACE=%d/%d/%d",
+			   alt->desc.bInterfaceClass,
+			   alt->desc.bInterfaceSubClass,
+			   alt->desc.bInterfaceProtocol))
+			return -ENOMEM;
 
-	if (add_uevent_var(envp, num_envp, &i,
+		if (add_uevent_var(envp, num_envp, &i,
 			   buffer, buffer_size, &length,
-			   "DEVNUM=%03d",
-			   usb_dev->devnum))
-		return -ENOMEM;
+			   "MODALIAS=usb:v%04Xp%04Xd%04Xdc%02Xdsc%02Xdp%02Xic%02Xisc%02Xip%02X",
+			   le16_to_cpu(usb_dev->descriptor.idVendor),
+			   le16_to_cpu(usb_dev->descriptor.idProduct),
+			   le16_to_cpu(usb_dev->descriptor.bcdDevice),
+			   usb_dev->descriptor.bDeviceClass,
+			   usb_dev->descriptor.bDeviceSubClass,
+			   usb_dev->descriptor.bDeviceProtocol,
+			   alt->desc.bInterfaceClass,
+			   alt->desc.bInterfaceSubClass,
+			   alt->desc.bInterfaceProtocol))
+			return -ENOMEM;
+	}
 
 	envp[i] = NULL;
+
 	return 0;
 }
 
 #else
 
 static int usb_uevent(struct device *dev, char **envp,
-		      int num_envp, char *buffer, int buffer_size)
+			int num_envp, char *buffer, int buffer_size)
 {
 	return -ENODEV;
 }
+
 #endif	/* CONFIG_HOTPLUG */
 
 /**
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index caaa46f..9ac5eec 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1366,15 +1366,11 @@ int usb_new_device(struct usb_device *ud
 	}
 #endif
 
-	/* export the usbdev device-node for libusb */
-	udev->dev.devt = MKDEV(USB_DEVICE_MAJOR,
-			(((udev->bus->busnum-1) * 128) + (udev->devnum-1)));
-
 	/* Register the device.  The device driver is responsible
-	 * for adding the device files to sysfs and for configuring
-	 * the device.
+	 * for adding the device files to usbfs and sysfs and for
+	 * configuring the device.
 	 */
-	err = device_add(&udev->dev);
+	err = device_add (&udev->dev);
 	if (err) {
 		dev_err(&udev->dev, "can't device_add, error %d\n", err);
 		goto fail;
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index cd4f111..22413a7 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -661,7 +661,7 @@ static void usbfs_add_device(struct usb_
 	sprintf (name, "%03d", dev->devnum);
 	dev->usbfs_dentry = fs_create_file (name, devmode | S_IFREG,
 					    dev->bus->usbfs_dentry, dev,
-					    &usbdev_file_operations,
+					    &usbfs_device_file_operations,
 					    devuid, devgid);
 	if (dev->usbfs_dentry == NULL) {
 		err ("error creating usbfs device entry");
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index f9fed34..ba49204 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1314,7 +1314,7 @@ int usb_reset_configuration(struct usb_d
 	return 0;
 }
 
-void usb_release_interface(struct device *dev)
+static void release_interface(struct device *dev)
 {
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usb_interface_cache *intfc =
@@ -1324,67 +1324,6 @@ void usb_release_interface(struct device
 	kfree(intf);
 }
 
-#ifdef	CONFIG_HOTPLUG
-static int usb_if_uevent(struct device *dev, char **envp, int num_envp,
-		 char *buffer, int buffer_size)
-{
-	struct usb_device *usb_dev;
-	struct usb_interface *intf;
-	struct usb_host_interface *alt;
-	int i = 0;
-	int length = 0;
-
-	if (!dev)
-		return -ENODEV;
-
-	/* driver is often null here; dev_dbg() would oops */
-	pr_debug ("usb %s: uevent\n", dev->bus_id);
-
-	intf = to_usb_interface(dev);
-	usb_dev = interface_to_usbdev(intf);
-	alt = intf->cur_altsetting;
-
-	if (add_uevent_var(envp, num_envp, &i,
-		   buffer, buffer_size, &length,
-		   "INTERFACE=%d/%d/%d",
-		   alt->desc.bInterfaceClass,
-		   alt->desc.bInterfaceSubClass,
-		   alt->desc.bInterfaceProtocol))
-		return -ENOMEM;
-
-	if (add_uevent_var(envp, num_envp, &i,
-		   buffer, buffer_size, &length,
-		   "MODALIAS=usb:v%04Xp%04Xd%04Xdc%02Xdsc%02Xdp%02Xic%02Xisc%02Xip%02X",
-		   le16_to_cpu(usb_dev->descriptor.idVendor),
-		   le16_to_cpu(usb_dev->descriptor.idProduct),
-		   le16_to_cpu(usb_dev->descriptor.bcdDevice),
-		   usb_dev->descriptor.bDeviceClass,
-		   usb_dev->descriptor.bDeviceSubClass,
-		   usb_dev->descriptor.bDeviceProtocol,
-		   alt->desc.bInterfaceClass,
-		   alt->desc.bInterfaceSubClass,
-		   alt->desc.bInterfaceProtocol))
-		return -ENOMEM;
-
-	envp[i] = NULL;
-	return 0;
-}
-
-#else
-
-static int usb_if_uevent(struct device *dev, char **envp,
-			 int num_envp, char *buffer, int buffer_size)
-{
-	return -ENODEV;
-}
-#endif	/* CONFIG_HOTPLUG */
-
-struct device_type usb_if_device_type = {
-	.name =		"usb_interface",
-	.release =	usb_release_interface,
-	.uevent =	usb_if_uevent,
-};
-
 /*
  * usb_set_configuration - Makes a particular device setting be current
  * @dev: the device whose configuration is being updated
@@ -1548,8 +1487,8 @@ free_interfaces:
 		intf->dev.parent = &dev->dev;
 		intf->dev.driver = NULL;
 		intf->dev.bus = &usb_bus_type;
-		intf->dev.type = &usb_if_device_type;
 		intf->dev.dma_mask = dev->dev.dma_mask;
+		intf->dev.release = release_interface;
 		device_initialize (&intf->dev);
 		mark_quiesced(intf);
 		sprintf (&intf->dev.bus_id[0], "%d-%s:%d.%d",
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 80627b6..55e7df8 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -196,11 +196,6 @@ static void usb_release_dev(struct devic
 	kfree(udev);
 }
 
-struct device_type usb_device_type = {
-	.name =		"usb_device",
-	.release =	usb_release_dev,
-};
-
 #ifdef	CONFIG_PM
 
 static int ksuspend_usb_init(void)
@@ -255,10 +250,13 @@ usb_alloc_dev(struct usb_device *parent,
 
 	device_initialize(&dev->dev);
 	dev->dev.bus = &usb_bus_type;
-	dev->dev.type = &usb_device_type;
 	dev->dev.dma_mask = bus->controller->dma_mask;
+	dev->dev.release = usb_release_dev;
 	dev->state = USB_STATE_ATTACHED;
 
+	/* This magic assignment distinguishes devices from interfaces */
+	dev->dev.platform_data = &usb_generic_driver;
+
 	INIT_LIST_HEAD(&dev->ep0.urb_list);
 	dev->ep0.desc.bLength = USB_DT_ENDPOINT_SIZE;
 	dev->ep0.desc.bDescriptorType = USB_DT_ENDPOINT;
@@ -887,9 +885,9 @@ static int __init usb_init(void)
 	retval = usb_register(&usbfs_driver);
 	if (retval)
 		goto driver_register_failed;
-	retval = usb_devio_init();
+	retval = usbdev_init();
 	if (retval)
-		goto usb_devio_init_failed;
+		goto usbdevice_init_failed;
 	retval = usbfs_init();
 	if (retval)
 		goto fs_init_failed;
@@ -904,8 +902,8 @@ static int __init usb_init(void)
 hub_init_failed:
 	usbfs_cleanup();
 fs_init_failed:
-	usb_devio_cleanup();
-usb_devio_init_failed:
+	usbdev_cleanup();
+usbdevice_init_failed:
 	usb_deregister(&usbfs_driver);
 driver_register_failed:
 	usb_major_cleanup();
@@ -932,7 +930,7 @@ static void __exit usb_exit(void)
 	usb_major_cleanup();
 	usbfs_cleanup();
 	usb_deregister(&usbfs_driver);
-	usb_devio_cleanup();
+	usbdev_cleanup();
 	usb_hub_cleanup();
 	usb_host_cleanup();
 	bus_unregister(&usb_bus_type);
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index bf2eb0d..c94379e 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -78,13 +78,15 @@ static inline int usb_autoresume_device(
 
 extern struct workqueue_struct *ksuspend_usb_wq;
 extern struct bus_type usb_bus_type;
-extern struct device_type usb_device_type;
-extern struct device_type usb_if_device_type;
 extern struct usb_device_driver usb_generic_driver;
 
+/* Here's how we tell apart devices and interfaces.  Luckily there's
+ * no such thing as a platform USB device, so we can steal the use
+ * of the platform_data field. */
+
 static inline int is_usb_device(const struct device *dev)
 {
-	return dev->type == &usb_device_type;
+	return dev->platform_data == &usb_generic_driver;
 }
 
 /* Do the same for device drivers and interface drivers. */
@@ -120,11 +122,11 @@ extern const char *usbcore_name;
 extern struct mutex usbfs_mutex;
 extern struct usb_driver usbfs_driver;
 extern const struct file_operations usbfs_devices_fops;
-extern const struct file_operations usbdev_file_operations;
+extern const struct file_operations usbfs_device_file_operations;
 extern void usbfs_conn_disc_event(void);
 
-extern int usb_devio_init(void);
-extern void usb_devio_cleanup(void);
+extern int usbdev_init(void);
+extern void usbdev_cleanup(void);
 
 struct dev_state {
 	struct list_head list;      /* state list */
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 94bd38a..1957674 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -299,9 +299,8 @@ struct usb_bus {
 	int bandwidth_int_reqs;		/* number of Interrupt requests */
 	int bandwidth_isoc_reqs;	/* number of Isoc. requests */
 
-#ifdef CONFIG_USB_DEVICEFS
 	struct dentry *usbfs_dentry;	/* usbfs dentry entry for the bus */
-#endif
+
 	struct class_device *class_dev;	/* class device for this bus */
 
 #if defined(CONFIG_USB_MON)
@@ -374,12 +373,9 @@ struct usb_device {
 	char *serial;			/* iSerialNumber string, if present */
 
 	struct list_head filelist;
-#ifdef CONFIG_USB_DEVICE_CLASS
-	struct device *usb_classdev;
-#endif
-#ifdef CONFIG_USB_DEVICEFS
+	struct device *usbfs_dev;
 	struct dentry *usbfs_dentry;	/* usbfs dentry entry for the device */
-#endif
+
 	/*
 	 * Child devices - these can be either new devices
 	 * (if this is a hub device), or different instances
