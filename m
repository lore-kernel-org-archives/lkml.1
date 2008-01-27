Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYA0Xk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYA0Xk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYA0XkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:40:15 -0500
Received: from mx1.suse.de ([195.135.220.2]:51216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYA0XkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:40:13 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 1/5] Driver core: Fix up build when CONFIG_BLOCK=N
Date: Sun, 27 Jan 2008 15:38:38 -0800
Message-Id: <1201477122-4541-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080127233751.GA4524@kroah.com>
References: <20080127233751.GA4524@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up the driver core build errors when CONFIG_BLOCK=N

Thanks to Alexander van Heukelum <heukelum@mailshack.com> for the basis
of this patch, and to Jeremy Fitzhardinge <jeremy@goop.org> for
reporting the problem.


Cc: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c |    2 +-
 drivers/base/core.c  |   30 +++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 59cf358..d916bbf 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -149,7 +149,7 @@ int class_register(struct class *cls)
 	if (error)
 		return error;
 
-#ifdef CONFIG_SYSFS_DEPRECATED
+#if defined(CONFIG_SYSFS_DEPRECATED) && defined(CONFIG_BLOCK)
 	/* let the block class directory show up in the root of sysfs */
 	if (cls != &block_class)
 		cls->subsys.kobj.kset = class_kset;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index edf3bbe..b172787 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -27,9 +27,17 @@
 int (*platform_notify)(struct device *dev) = NULL;
 int (*platform_notify_remove)(struct device *dev) = NULL;
 
-/*
- * sysfs bindings for devices.
- */
+#ifdef CONFIG_BLOCK
+static inline int device_is_not_partition(struct device *dev)
+{
+	return !(dev->type == &part_type);
+}
+#else
+static inline int device_is_not_partition(struct device *dev)
+{
+	return 1;
+}
+#endif
 
 /**
  * dev_driver_string - Return a device's driver name, if at all possible
@@ -652,14 +660,14 @@ static int device_add_class_symlinks(struct device *dev)
 #ifdef CONFIG_SYSFS_DEPRECATED
 	/* stacked class devices need a symlink in the class directory */
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
-	    dev->type != &part_type) {
+	    device_is_not_partition(dev)) {
 		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
 					  dev->bus_id);
 		if (error)
 			goto out_subsys;
 	}
 
-	if (dev->parent && dev->type != &part_type) {
+	if (dev->parent && device_is_not_partition(dev)) {
 		struct device *parent = dev->parent;
 		char *class_name;
 
@@ -688,11 +696,11 @@ static int device_add_class_symlinks(struct device *dev)
 	return 0;
 
 out_device:
-	if (dev->parent && dev->type != &part_type)
+	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 out_busid:
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
-	    dev->type != &part_type)
+	    device_is_not_partition(dev))
 		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 #else
 	/* link in the class directory pointing to the device */
@@ -701,7 +709,7 @@ out_busid:
 	if (error)
 		goto out_subsys;
 
-	if (dev->parent && dev->type != &part_type) {
+	if (dev->parent && device_is_not_partition(dev)) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
 		if (error)
@@ -725,7 +733,7 @@ static void device_remove_class_symlinks(struct device *dev)
 		return;
 
 #ifdef CONFIG_SYSFS_DEPRECATED
-	if (dev->parent && dev->type != &part_type) {
+	if (dev->parent && device_is_not_partition(dev)) {
 		char *class_name;
 
 		class_name = make_class_name(dev->class->name, &dev->kobj);
@@ -737,10 +745,10 @@ static void device_remove_class_symlinks(struct device *dev)
 	}
 
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
-	    dev->type != &part_type)
+	    device_is_not_partition(dev))
 		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 #else
-	if (dev->parent && dev->type != &part_type)
+	if (dev->parent && device_is_not_partition(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
 	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
-- 
1.5.3.8

