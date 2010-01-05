Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564Ab0AELu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0AELu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789Ab0AELsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab0AELsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:11 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [12/12] SYSFS: Convert some drivers to CLASS_ATTR_STRING
Message-Id: <20100105114809.95C3EB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:48:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Convert some drivers who export a single string as class attribute
to the new class_attr_string functions. This removes redundant
code all over.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/drm_sysfs.c           |   19 ++++++++-----------
 drivers/infiniband/core/ucm.c         |   15 +++++----------
 drivers/infiniband/core/user_mad.c    |   11 +++--------
 drivers/infiniband/core/uverbs_main.c |   11 +++--------
 drivers/misc/phantom.c                |   13 ++++---------
 drivers/staging/asus_oled/asus_oled.c |   13 +++----------
 6 files changed, 26 insertions(+), 56 deletions(-)

Index: linux-2.6.33-rc2-ak/drivers/infiniband/core/ucm.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/infiniband/core/ucm.c
+++ linux-2.6.33-rc2-ak/drivers/infiniband/core/ucm.c
@@ -1297,13 +1297,8 @@ static void ib_ucm_remove_one(struct ib_
 	device_unregister(&ucm_dev->dev);
 }
 
-static ssize_t show_abi_version(struct class *class,
-				struct class_attribute *attr,
-				char *buf)
-{
-	return sprintf(buf, "%d\n", IB_USER_CM_ABI_VERSION);
-}
-static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
+static CLASS_ATTR_STRING(abi_version, S_IRUGO,
+			 __stringify(IB_USER_CM_ABI_VERSION));
 
 static int __init ib_ucm_init(void)
 {
@@ -1316,7 +1311,7 @@ static int __init ib_ucm_init(void)
 		goto error1;
 	}
 
-	ret = class_create_file(&cm_class, &class_attr_abi_version);
+	ret = class_create_file(&cm_class, &class_attr_abi_version.attr);
 	if (ret) {
 		printk(KERN_ERR "ucm: couldn't create abi_version attribute\n");
 		goto error2;
@@ -1330,7 +1325,7 @@ static int __init ib_ucm_init(void)
 	return 0;
 
 error3:
-	class_remove_file(&cm_class, &class_attr_abi_version);
+	class_remove_file(&cm_class, &class_attr_abi_version.attr);
 error2:
 	unregister_chrdev_region(IB_UCM_BASE_DEV, IB_UCM_MAX_DEVICES);
 error1:
@@ -1340,7 +1335,7 @@ error1:
 static void __exit ib_ucm_cleanup(void)
 {
 	ib_unregister_client(&ucm_client);
-	class_remove_file(&cm_class, &class_attr_abi_version);
+	class_remove_file(&cm_class, &class_attr_abi_version.attr);
 	unregister_chrdev_region(IB_UCM_BASE_DEV, IB_UCM_MAX_DEVICES);
 	idr_destroy(&ctx_id_table);
 }
Index: linux-2.6.33-rc2-ak/drivers/infiniband/core/user_mad.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/infiniband/core/user_mad.c
+++ linux-2.6.33-rc2-ak/drivers/infiniband/core/user_mad.c
@@ -984,13 +984,8 @@ static ssize_t show_port(struct device *
 }
 static DEVICE_ATTR(port, S_IRUGO, show_port, NULL);
 
-static ssize_t show_abi_version(struct class *class,
-				struct class_attribute *attr,
-				char *buf)
-{
-	return sprintf(buf, "%d\n", IB_USER_MAD_ABI_VERSION);
-}
-static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
+static CLASS_ATTR_STRING(abi_version, S_IRUGO,
+			 __stringify(IB_USER_MAD_ABI_VERSION));
 
 static int ib_umad_init_port(struct ib_device *device, int port_num,
 			     struct ib_umad_port *port)
@@ -1187,7 +1182,7 @@ static int __init ib_umad_init(void)
 		goto out_chrdev;
 	}
 
-	ret = class_create_file(umad_class, &class_attr_abi_version);
+	ret = class_create_file(umad_class, &class_attr_abi_version.attr);
 	if (ret) {
 		printk(KERN_ERR "user_mad: couldn't create abi_version attribute\n");
 		goto out_class;
Index: linux-2.6.33-rc2-ak/drivers/infiniband/core/uverbs_main.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/infiniband/core/uverbs_main.c
+++ linux-2.6.33-rc2-ak/drivers/infiniband/core/uverbs_main.c
@@ -729,13 +729,8 @@ static ssize_t show_dev_abi_version(stru
 }
 static DEVICE_ATTR(abi_version, S_IRUGO, show_dev_abi_version, NULL);
 
-static ssize_t show_abi_version(struct class *class,
-				struct class_attribute *attr,
-				char *buf)
-{
-	return sprintf(buf, "%d\n", IB_USER_VERBS_ABI_VERSION);
-}
-static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
+static CLASS_ATTR_STRING(abi_version, S_IRUGO,
+			 __stringify(IB_USER_VERBS_ABI_VERSION));
 
 static void ib_uverbs_add_one(struct ib_device *device)
 {
@@ -860,7 +855,7 @@ static int __init ib_uverbs_init(void)
 		goto out_chrdev;
 	}
 
-	ret = class_create_file(uverbs_class, &class_attr_abi_version);
+	ret = class_create_file(uverbs_class, &class_attr_abi_version.attr);
 	if (ret) {
 		printk(KERN_ERR "user_verbs: couldn't create abi_version attribute\n");
 		goto out_class;
Index: linux-2.6.33-rc2-ak/drivers/misc/phantom.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/misc/phantom.c
+++ linux-2.6.33-rc2-ak/drivers/misc/phantom.c
@@ -497,12 +497,7 @@ static struct pci_driver phantom_pci_dri
 	.resume = phantom_resume
 };
 
-static ssize_t phantom_show_version(struct class *cls, struct class_attribute *attr, char *buf)
-{
-	return sprintf(buf, PHANTOM_VERSION "\n");
-}
-
-static CLASS_ATTR(version, 0444, phantom_show_version, NULL);
+static CLASS_ATTR_STRING(version, 0444, PHANTOM_VERSION);
 
 static int __init phantom_init(void)
 {
@@ -515,7 +510,7 @@ static int __init phantom_init(void)
 		printk(KERN_ERR "phantom: can't register phantom class\n");
 		goto err;
 	}
-	retval = class_create_file(phantom_class, &class_attr_version);
+	retval = class_create_file(phantom_class, &class_attr_version.attr);
 	if (retval) {
 		printk(KERN_ERR "phantom: can't create sysfs version file\n");
 		goto err_class;
@@ -541,7 +536,7 @@ static int __init phantom_init(void)
 err_unchr:
 	unregister_chrdev_region(dev, PHANTOM_MAX_MINORS);
 err_attr:
-	class_remove_file(phantom_class, &class_attr_version);
+	class_remove_file(phantom_class, &class_attr_version.attr);
 err_class:
 	class_destroy(phantom_class);
 err:
@@ -554,7 +549,7 @@ static void __exit phantom_exit(void)
 
 	unregister_chrdev_region(MKDEV(phantom_major, 0), PHANTOM_MAX_MINORS);
 
-	class_remove_file(phantom_class, &class_attr_version);
+	class_remove_file(phantom_class, &class_attr_version.attr);
 	class_destroy(phantom_class);
 
 	pr_debug("phantom: module successfully removed\n");
Index: linux-2.6.33-rc2-ak/drivers/gpu/drm/drm_sysfs.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/gpu/drm/drm_sysfs.c
+++ linux-2.6.33-rc2-ak/drivers/gpu/drm/drm_sysfs.c
@@ -70,20 +70,17 @@ static int drm_class_resume(struct devic
 	return 0;
 }
 
-/* Display the version of drm_core. This doesn't work right in current design */
-static ssize_t version_show(struct class *dev, struct class_attribute *attr,
-				char *buf)
-{
-	return sprintf(buf, "%s %d.%d.%d %s\n", CORE_NAME, CORE_MAJOR,
-		       CORE_MINOR, CORE_PATCHLEVEL, CORE_DATE);
-}
-
 static char *drm_devnode(struct device *dev, mode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
 }
 
-static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
+static CLASS_ATTR_STRING(version, S_IRUGO,
+		CORE_NAME " "
+		__stringify(CORE_MAJOR) "."
+		__stringify(CORE_MINOR) "."
+		__stringify(CORE_PATCHLEVEL) " "
+		CORE_DATE);
 
 /**
  * drm_sysfs_create - create a struct drm_sysfs_class structure
@@ -110,7 +107,7 @@ struct class *drm_sysfs_create(struct mo
 	class->suspend = drm_class_suspend;
 	class->resume = drm_class_resume;
 
-	err = class_create_file(class, &class_attr_version);
+	err = class_create_file(class, &class_attr_version.attr);
 	if (err)
 		goto err_out_class;
 
@@ -133,7 +130,7 @@ void drm_sysfs_destroy(void)
 {
 	if ((drm_class == NULL) || (IS_ERR(drm_class)))
 		return;
-	class_remove_file(drm_class, &class_attr_version);
+	class_remove_file(drm_class, &class_attr_version.attr);
 	class_destroy(drm_class);
 }
 
Index: linux-2.6.33-rc2-ak/drivers/staging/asus_oled/asus_oled.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/staging/asus_oled/asus_oled.c
+++ linux-2.6.33-rc2-ak/drivers/staging/asus_oled/asus_oled.c
@@ -755,15 +755,8 @@ static struct usb_driver oled_driver = {
 	.id_table =	id_table,
 };
 
-static ssize_t version_show(struct class *dev,
-			    struct class_attribute *attr,
-			    char *buf)
-{
-	return sprintf(buf, ASUS_OLED_UNDERSCORE_NAME " %s\n",
-		       ASUS_OLED_VERSION);
-}
-
-static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
+static CLASS_ATTR_STRING(version, S_IRUGO,
+		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLD_VERSION);
 
 static int __init asus_oled_init(void)
 {
@@ -775,7 +768,7 @@ static int __init asus_oled_init(void)
 		return PTR_ERR(oled_class);
 	}
 
-	retval = class_create_file(oled_class, &class_attr_version);
+	retval = class_create_file(oled_class, &class_attr_version.attr);
 	if (retval) {
 		err("Error creating class version file");
 		goto error;
