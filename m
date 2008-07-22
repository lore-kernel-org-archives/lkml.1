Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYGVFVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYGVFVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYGVFVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:21:36 -0400
Received: from ns.suse.de ([195.135.220.2]:53672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYGVFVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:21:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>,
       Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/79] sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
Date: Mon, 21 Jul 2008 22:18:25 -0700
Message-Id: <1216703983-21448-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Why?:
There are occasions where userspace would like to access sysfs
attributes for a device but it may not know how sysfs has named the
device or the path.  For example what is the sysfs path for
/dev/disk/by-id/ata-ST3160827AS_5MT004CK?  With this change a call to
stat(2) returns the major:minor then userspace can see that
/sys/dev/block/8:32 links to /sys/block/sdc.

What are the alternatives?:
1/ Add an ioctl to return the path: Doable, but sysfs is meant to reduce
   the need to proliferate ioctl interfaces into the kernel, so this
   seems counter productive.

2/ Use udev to create these symlinks: Also doable, but it adds a
   udev dependency to utilities that might be running in a limited
   environment like an initramfs.

3/ Do a full-tree search of sysfs.

[kay.sievers@vrfy.org: fix duplicate registrations]
[kay.sievers@vrfy.org: cleanup suggestions]

Cc: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Reviewed-by: SL Baur <steve@xemacs.org>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Mark Lord <lkml@rtr.ca>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-dev |   20 ++++++++
 Documentation/filesystems/sysfs.txt |    6 +++
 block/genhd.c                       |    5 ++-
 drivers/base/class.c                |    4 ++
 drivers/base/core.c                 |   83 ++++++++++++++++++++++++++++++++++-
 drivers/usb/core/devio.c            |    5 ++
 include/linux/device.h              |    3 +
 7 files changed, 124 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-dev

diff --git a/Documentation/ABI/testing/sysfs-dev b/Documentation/ABI/testing/sysfs-dev
new file mode 100644
index 0000000..a9f2b8b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-dev
@@ -0,0 +1,20 @@
+What:		/sys/dev
+Date:		April 2008
+KernelVersion:	2.6.26
+Contact:	Dan Williams <dan.j.williams@intel.com>
+Description:	The /sys/dev tree provides a method to look up the sysfs
+		path for a device using the information returned from
+		stat(2).  There are two directories, 'block' and 'char',
+		beneath /sys/dev containing symbolic links with names of
+		the form "<major>:<minor>".  These links point to the
+		corresponding sysfs path for the given device.
+
+		Example:
+		$ readlink /sys/dev/block/8:32
+		../../block/sdc
+
+		Entries in /sys/dev/char and /sys/dev/block will be
+		dynamically created and destroyed as devices enter and
+		leave the system.
+
+Users:		mdadm <linux-raid@vger.kernel.org>
diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index 7f27b8f..9e9c348 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -248,6 +248,7 @@ The top level sysfs directory looks like:
 block/
 bus/
 class/
+dev/
 devices/
 firmware/
 net/
@@ -274,6 +275,11 @@ fs/ contains a directory for some filesystems.  Currently each
 filesystem wanting to export attributes must create its own hierarchy
 below fs/ (see ./fuse.txt for an example).
 
+dev/ contains two directories char/ and block/. Inside these two
+directories there are symlinks named <major>:<minor>.  These symlinks
+point to the sysfs directory for the given device.  /sys/dev provides a
+quick way to lookup the sysfs interface for a device from the result of
+a stat(2) operation.
 
 More information can driver-model specific features can be found in
 Documentation/driver-model/. 
diff --git a/block/genhd.c b/block/genhd.c
index 9074f38..24e3fc9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -370,7 +370,10 @@ static struct kobject *base_probe(dev_t devt, int *part, void *data)
 
 static int __init genhd_device_init(void)
 {
-	int error = class_register(&block_class);
+	int error;
+
+	block_class.dev_kobj = sysfs_dev_block_kobj;
+	error = class_register(&block_class);
 	if (unlikely(error))
 		return error;
 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
diff --git a/drivers/base/class.c b/drivers/base/class.c
index e085af0..71ce3ff 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -148,6 +148,10 @@ int class_register(struct class *cls)
 	if (error)
 		return error;
 
+	/* set the default /sys/dev directory for devices of this class */
+	if (!cls->dev_kobj)
+		cls->dev_kobj = sysfs_dev_char_kobj;
+
 #if defined(CONFIG_SYSFS_DEPRECATED) && defined(CONFIG_BLOCK)
 	/* let the block class directory show up in the root of sysfs */
 	if (cls != &block_class)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index ee0a51a..be9aba4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -27,6 +27,9 @@
 
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
+static struct kobject *dev_kobj;
+struct kobject *sysfs_dev_char_kobj;
+struct kobject *sysfs_dev_block_kobj;
 
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -776,6 +779,54 @@ int dev_set_name(struct device *dev, const char *fmt, ...)
 EXPORT_SYMBOL_GPL(dev_set_name);
 
 /**
+ * device_to_dev_kobj - select a /sys/dev/ directory for the device
+ * @dev: device
+ *
+ * By default we select char/ for new entries.  Setting class->dev_obj
+ * to NULL prevents an entry from being created.  class->dev_kobj must
+ * be set (or cleared) before any devices are registered to the class
+ * otherwise device_create_sys_dev_entry() and
+ * device_remove_sys_dev_entry() will disagree about the the presence
+ * of the link.
+ */
+static struct kobject *device_to_dev_kobj(struct device *dev)
+{
+	struct kobject *kobj;
+
+	if (dev->class)
+		kobj = dev->class->dev_kobj;
+	else
+		kobj = sysfs_dev_char_kobj;
+
+	return kobj;
+}
+
+static int device_create_sys_dev_entry(struct device *dev)
+{
+	struct kobject *kobj = device_to_dev_kobj(dev);
+	int error = 0;
+	char devt_str[15];
+
+	if (kobj) {
+		format_dev_t(devt_str, dev->devt);
+		error = sysfs_create_link(kobj, &dev->kobj, devt_str);
+	}
+
+	return error;
+}
+
+static void device_remove_sys_dev_entry(struct device *dev)
+{
+	struct kobject *kobj = device_to_dev_kobj(dev);
+	char devt_str[15];
+
+	if (kobj) {
+		format_dev_t(devt_str, dev->devt);
+		sysfs_remove_link(kobj, devt_str);
+	}
+}
+
+/**
  * device_add - add device to device hierarchy.
  * @dev: device.
  *
@@ -829,6 +880,10 @@ int device_add(struct device *dev)
 		error = device_create_file(dev, &devt_attr);
 		if (error)
 			goto ueventattrError;
+
+		error = device_create_sys_dev_entry(dev);
+		if (error)
+			goto devtattrError;
 	}
 
 	error = device_add_class_symlinks(dev);
@@ -873,6 +928,9 @@ int device_add(struct device *dev)
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		device_remove_sys_dev_entry(dev);
+ devtattrError:
+	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
@@ -948,8 +1006,10 @@ void device_del(struct device *dev)
 	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (MAJOR(dev->devt))
+	if (MAJOR(dev->devt)) {
+		device_remove_sys_dev_entry(dev);
 		device_remove_file(dev, &devt_attr);
+	}
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
@@ -1074,7 +1134,25 @@ int __init devices_init(void)
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
 	if (!devices_kset)
 		return -ENOMEM;
+	dev_kobj = kobject_create_and_add("dev", NULL);
+	if (!dev_kobj)
+		goto dev_kobj_err;
+	sysfs_dev_block_kobj = kobject_create_and_add("block", dev_kobj);
+	if (!sysfs_dev_block_kobj)
+		goto block_kobj_err;
+	sysfs_dev_char_kobj = kobject_create_and_add("char", dev_kobj);
+	if (!sysfs_dev_char_kobj)
+		goto char_kobj_err;
+
 	return 0;
+
+ char_kobj_err:
+	kobject_put(sysfs_dev_block_kobj);
+ block_kobj_err:
+	kobject_put(dev_kobj);
+ dev_kobj_err:
+	kset_unregister(devices_kset);
+	return -ENOMEM;
 }
 
 EXPORT_SYMBOL_GPL(device_for_each_child);
@@ -1447,4 +1525,7 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+	kobject_put(sysfs_dev_char_kobj);
+	kobject_put(sysfs_dev_block_kobj);
+	kobject_put(dev_kobj);
 }
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 54a350c..6fbc8f5 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1792,6 +1792,11 @@ int __init usb_devio_init(void)
 		usb_classdev_class = NULL;
 		goto out;
 	}
+	/* devices of this class shadow the major:minor of their parent
+	 * device, so clear ->dev_kobj to prevent adding duplicate entries
+	 * to /sys/dev
+	 */
+	usb_classdev_class->dev_kobj = NULL;
 
 	usb_register_notify(&usbdev_nb);
 #endif
diff --git a/include/linux/device.h b/include/linux/device.h
index f71a78d..e49aa74 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -193,6 +193,7 @@ struct class {
 	struct semaphore	sem; /* locks children, devices, interfaces */
 	struct class_attribute		*class_attrs;
 	struct device_attribute		*dev_attrs;
+	struct kobject			*dev_kobj;
 
 	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
 
@@ -205,6 +206,8 @@ struct class {
 	struct pm_ops *pm;
 };
 
+extern struct kobject *sysfs_dev_block_kobj;
+extern struct kobject *sysfs_dev_char_kobj;
 extern int __must_check class_register(struct class *class);
 extern void class_unregister(struct class *class);
 extern int class_for_each_device(struct class *class, void *data,
-- 
1.5.6.3

