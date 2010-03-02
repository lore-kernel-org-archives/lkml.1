Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0CBX5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:57:21 -0500
Received: from kroah.org ([198.145.64.141]:38532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0CBX3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/62] driver core: Convert some drivers to CLASS_ATTR_STRING
Date: Tue,  2 Mar 2010 15:28:16 -0800
Message-Id: <1267572541-410-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Convert some drivers who export a single string as class attribute
to the new class_attr_string functions. This removes redundant
code all over.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/drm_sysfs.c           |   19 ++++++++-----------
 drivers/infiniband/core/ucm.c         |   15 +++++----------
 drivers/infiniband/core/user_mad.c    |   11 +++--------
 drivers/infiniband/core/uverbs_main.c |   11 +++--------
 drivers/misc/phantom.c                |   13 ++++---------
 drivers/staging/asus_oled/asus_oled.c |   15 ++++-----------
 6 files changed, 27 insertions(+), 57 deletions(-)

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index b95aaf2..014ce24 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -70,20 +70,17 @@ static int drm_class_resume(struct device *dev)
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
@@ -110,7 +107,7 @@ struct class *drm_sysfs_create(struct module *owner, char *name)
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
 
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 98c1643..622afb6 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1297,13 +1297,8 @@ static void ib_ucm_remove_one(struct ib_device *device)
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
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 113dd0d..bff5a91 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -984,13 +984,8 @@ static ssize_t show_port(struct device *dev, struct device_attribute *attr,
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
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index ef541b9..1f16b88 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -729,13 +729,8 @@ static ssize_t show_dev_abi_version(struct device *device,
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
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index d30ae95..779aa8e 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -497,12 +497,7 @@ static struct pci_driver phantom_pci_driver = {
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
diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index d11e897..34a1f5f 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -759,15 +759,8 @@ static struct usb_driver oled_driver = {
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
+		 	ASUS_OLED_UNDERSCORE_NAME " " ASUS_OLED_VERSION);
 
 static int __init asus_oled_init(void)
 {
@@ -779,7 +772,7 @@ static int __init asus_oled_init(void)
 		return PTR_ERR(oled_class);
 	}
 
-	retval = class_create_file(oled_class, &class_attr_version);
+	retval = class_create_file(oled_class, &class_attr_version.attr);
 	if (retval) {
 		err("Error creating class version file");
 		goto error;
@@ -801,7 +794,7 @@ error:
 
 static void __exit asus_oled_exit(void)
 {
-	class_remove_file(oled_class, &class_attr_version);
+	class_remove_file(oled_class, &class_attr_version.attr);
 	class_destroy(oled_class);
 
 	usb_deregister(&oled_driver);
-- 
1.7.0.1

