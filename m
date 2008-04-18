Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYDRCLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYDRCLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 22:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYDRCLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 22:11:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:65130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbYDRCLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 22:11:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,674,1199692800"; 
   d="scan'208";a="234247318"
Subject: [PATCH mm] sysfs: add /sys/dev/usb to handle
	CONFIG_USB_DEVICE_CLASS=y
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Thu, 17 Apr 2008 19:11:03 -0700
Message-Id: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices
with duplicate major:minor numbers to be registered.  In effect they
represent a usb specific address space for major:minor numbers so add 'usb'
as a directory along side 'block' and 'char'.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
This boots up without warning on my dev system.  We end up with the
following situation:

$ ls -l /sys/dev/usb/189:0
lrwxrwxrwx 1 root root 0 2008-04-17 12:00 /sys/dev/usb/189:0 -> ../../class/usb_device/usbdev1.1
$ ls -l /sys/dev/char/189:0
lrwxrwxrwx 1 root root 0 2008-04-17 12:01 /sys/dev/char/189:0 -> ../../devices/pci0000:00/0000:00:1d.7/usb1

 drivers/base/core.c      |   25 +++++++++++++++++++++++--
 drivers/usb/core/devio.c |    2 +-
 2 files changed, 24 insertions(+), 3 deletions(-)


diff --git a/drivers/base/core.c b/drivers/base/core.c
index ba21118..bce5e4b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -30,6 +30,10 @@ int (*platform_notify_remove)(struct device *dev) = NULL;
 static struct kobject *dev_kobj;
 static struct kobject *char_kobj;
 static struct kobject *block_kobj;
+#ifdef CONFIG_USB_DEVICE_CLASS
+extern struct class *usb_classdev_class;
+static struct kobject *usb_kobj;
+#endif
 
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
@@ -764,7 +768,13 @@ static void device_remove_class_symlinks(struct device *dev)
 
 static struct kobject *device_to_dev_kobj(struct device *dev)
 {
-	return dev->class == &block_class ? block_kobj : char_kobj;
+	if (dev->class == &block_class)
+		return block_kobj;
+#ifdef CONFIG_USB_DEVICE_CLASS	
+	if (usb_classdev_class && dev->class == usb_classdev_class)
+		return usb_kobj;
+#endif 
+	return char_kobj;
 }
 
 /**
@@ -1087,9 +1097,17 @@ int __init devices_init(void)
 	char_kobj = kobject_create_and_add("char", dev_kobj);
 	if (!char_kobj)
 		goto char_kobj_err;
-
+#ifdef CONFIG_USB_DEVICE_CLASS
+	usb_kobj = kobject_create_and_add("usb", dev_kobj);
+	if (!usb_kobj)
+		goto usb_kobj_err;
+#endif
 	return 0;
 
+#ifdef CONFIG_USB_DEVICE_CLASS
+ usb_kobj_err:
+	kobject_put(char_kobj);
+#endif
  char_kobj_err:
 	kobject_put(block_kobj);
  block_kobj_err:
@@ -1421,6 +1439,9 @@ void device_shutdown(void)
 			dev->driver->shutdown(dev);
 		}
 	}
+#ifdef CONFIG_USB_DEVICE_CLASS
+	kobject_put(usb_kobj);
+#endif
 	kobject_put(char_kobj);
 	kobject_put(block_kobj);
 	kobject_put(dev_kobj);
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index ae94176..2075622 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1660,7 +1660,7 @@ const struct file_operations usbdev_file_operations = {
 };
 
 #ifdef CONFIG_USB_DEVICE_CLASS
-static struct class *usb_classdev_class;
+struct class *usb_classdev_class;
 
 static int usb_classdev_add(struct usb_device *dev)
 {


