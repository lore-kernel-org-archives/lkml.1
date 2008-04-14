Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbYDNQ57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbYDNQ57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYDNQ5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:57:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:39598 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYDNQ5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:57:49 -0400
X-ExtLoop1: 1
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] sysfs: add /sys/dev/{char,
	block} to lookup sysfs path by major:minor
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, neilb@suse.de,
       htejun@gmail.com, hpa@zytor.com, lkml@rtr.ca
Date: Mon, 14 Apr 2008 09:57:48 -0700
Message-ID: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Mark Lord <lkml@rtr.ca>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
This is the second revision of the patch originally posted here:
http://marc.info/?l=linux-kernel&m=120795638915272&w=2

* Fixed up ENOMEM handling in devices_init()
* Added a short blurb in Documentation/filesystems/sysfs.txt

 Documentation/filesystems/sysfs.txt |    6 +++++
 drivers/base/core.c                 |   46 ++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletions(-)


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
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 24198ad..39db294 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -27,6 +27,9 @@
 
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
+static struct kobject *dev_kobj;
+static struct kobject *char_kobj;
+static struct kobject *block_kobj;
 
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -759,6 +762,11 @@ static void device_remove_class_symlinks(struct device *dev)
 	sysfs_remove_link(&dev->kobj, "subsystem");
 }
 
+static struct kobject *device_to_dev_kobj(struct device *dev)
+{
+	return dev->class == &block_class ? block_kobj : char_kobj;
+}
+
 /**
  * device_add - add device to device hierarchy.
  * @dev: device.
@@ -775,6 +783,7 @@ int device_add(struct device *dev)
 	struct device *parent = NULL;
 	struct class_interface *class_intf;
 	int error;
+	char devt_str[25];
 
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
@@ -806,9 +815,16 @@ int device_add(struct device *dev)
 		goto attrError;
 
 	if (MAJOR(dev->devt)) {
+		struct kobject *kobj = device_to_dev_kobj(dev);
+
 		error = device_create_file(dev, &devt_attr);
 		if (error)
 			goto ueventattrError;
+
+		format_dev_t(devt_str, dev->devt);
+		error = sysfs_create_link(kobj, &dev->kobj, devt_str);
+		if (error)
+			goto devtattrError;
 	}
 
 	error = device_add_class_symlinks(dev);
@@ -854,6 +870,9 @@ int device_add(struct device *dev)
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
+ devtattrError:
+	if (MAJOR(dev->devt))
 		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
@@ -925,12 +944,16 @@ void device_del(struct device *dev)
 {
 	struct device *parent = dev->parent;
 	struct class_interface *class_intf;
+	char devt_str[25];
 
 	device_pm_remove(dev);
 	if (parent)
 		klist_del(&dev->knode_parent);
-	if (MAJOR(dev->devt))
+	if (MAJOR(dev->devt)) {
+		format_dev_t(devt_str, dev->devt);
+		sysfs_remove_link(device_to_dev_kobj(dev), devt_str);
 		device_remove_file(dev, &devt_attr);
+	}
 	if (dev->class) {
 		device_remove_class_symlinks(dev);
 
@@ -1055,7 +1078,25 @@ int __init devices_init(void)
 	devices_kset = kset_create_and_add("devices", &device_uevent_ops, NULL);
 	if (!devices_kset)
 		return -ENOMEM;
+	dev_kobj = kobject_create_and_add("dev", NULL);
+	if (!dev_kobj)
+		goto dev_kobj_err;
+	block_kobj = kobject_create_and_add("block", dev_kobj);
+	if (!block_kobj)
+		goto block_kobj_err;
+	char_kobj = kobject_create_and_add("char", dev_kobj);
+	if (!char_kobj)
+		goto char_kobj_err;
+
 	return 0;
+
+ char_kobj_err:
+	kobject_put(block_kobj);
+ block_kobj_err:
+	kobject_put(dev_kobj);
+ dev_kobj_err:
+	kset_unregister(devices_kset);
+	return -ENOMEM; 
 }
 
 EXPORT_SYMBOL_GPL(device_for_each_child);
@@ -1380,4 +1421,7 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+	kobject_put(char_kobj);
+	kobject_put(block_kobj);
+	kobject_put(dev_kobj);
 }

