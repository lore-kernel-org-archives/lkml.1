Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXITH2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXITH2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbXITH0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:30 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33312 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbXITH0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=mnVLzj7w73RXpKSKN+DMww/HRhAbZWHbIIYjAsrQLNToxbUq9VniaG5o0GsZYEktluHIX8LCLXHvVHyffcWOUN2hM3ygKIyXmsEhJKkwX1n3o9Ul+SiAIvLz2wCyTJw0JltNhC1t+/1t4dML36p9/n+BX32wEFkegB9cG6OZqkU=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/4] sysfs: make suicidal nodes just do it directly
In-Reply-To: <11902731752407-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:26:15 +0900
Message-Id: <11902731751771-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs now allows direct suicide.  Make suicidial sysfs nodes to use
it and remove now unncessary callback mechanism.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/base/core.c         |   33 ----------------------
 drivers/s390/cio/ccwgroup.c |   25 +++-------------
 drivers/scsi/scsi_sysfs.c   |   13 +--------
 fs/sysfs/file.c             |   63 -------------------------------------------
 include/linux/device.h      |    6 ----
 include/linux/sysfs.h       |    9 ------
 6 files changed, 6 insertions(+), 143 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d290ceb..a4942f1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -464,39 +464,6 @@ void device_remove_bin_file(struct device *dev, struct bin_attribute *attr)
 }
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
-/**
- * device_schedule_callback_owner - helper to schedule a callback for a device
- * @dev: device.
- * @func: callback function to invoke later.
- * @owner: module owning the callback routine
- *
- * Attribute methods must not unregister themselves or their parent device
- * (which would amount to the same thing).  Attempts to do so will deadlock,
- * since unregistration is mutually exclusive with driver callbacks.
- *
- * Instead methods can call this routine, which will attempt to allocate
- * and schedule a workqueue request to call back @func with @dev as its
- * argument in the workqueue's process context.  @dev will be pinned until
- * @func returns.
- *
- * This routine is usually called via the inline device_schedule_callback(),
- * which automatically sets @owner to THIS_MODULE.
- *
- * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated, -ENODEV if a reference to @owner isn't available.
- *
- * NOTE: This routine won't work if CONFIG_SYSFS isn't set!  It uses an
- * underlying sysfs routine (since it is intended for use by attribute
- * methods), and if sysfs isn't available you'll get nothing but -ENOSYS.
- */
-int device_schedule_callback_owner(struct device *dev,
-		void (*func)(struct device *), struct module *owner)
-{
-	return sysfs_schedule_callback(&dev->kobj,
-			(void (*)(void *)) func, dev, owner);
-}
-EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
-
 static void klist_children_get(struct klist_node *n)
 {
 	struct device *dev = container_of(n, struct device, knode_parent);
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 5d967c4..7085305 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -66,20 +66,6 @@ __ccwgroup_remove_symlinks(struct ccwgroup_device *gdev)
 	
 }
 
-/*
- * Provide an 'ungroup' attribute so the user can remove group devices no
- * longer needed or accidentially created. Saves memory :)
- */
-static void ccwgroup_ungroup_callback(struct device *dev)
-{
-	struct ccwgroup_device *gdev = to_ccwgroupdev(dev);
-
-	mutex_lock(&gdev->reg_mutex);
-	__ccwgroup_remove_symlinks(gdev);
-	device_unregister(dev);
-	mutex_unlock(&gdev->reg_mutex);
-}
-
 static ssize_t
 ccwgroup_ungroup_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
@@ -91,12 +77,11 @@ ccwgroup_ungroup_store(struct device *dev, struct device_attribute *attr, const
 	if (gdev->state != CCWGROUP_OFFLINE)
 		return -EINVAL;
 
-	/* Note that we cannot unregister the device from one of its
-	 * attribute methods, so we have to use this roundabout approach.
-	 */
-	rc = device_schedule_callback(dev, ccwgroup_ungroup_callback);
-	if (rc)
-		count = rc;
+	mutex_lock(&gdev->reg_mutex);
+	__ccwgroup_remove_symlinks(gdev);
+	device_unregister(dev);
+	mutex_unlock(&gdev->reg_mutex);
+
 	return count;
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ede9986..fdac321 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -466,22 +466,11 @@ store_rescan_field (struct device *dev, struct device_attribute *attr, const cha
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
-static void sdev_store_delete_callback(struct device *dev)
-{
-	scsi_remove_device(to_scsi_device(dev));
-}
-
 static ssize_t sdev_store_delete(struct device *dev, struct device_attribute *attr, const char *buf,
 				 size_t count)
 {
-	int rc;
+	scsi_remove_device(to_scsi_device(dev));
 
-	/* An attribute cannot be unregistered by one of its own methods,
-	 * so we have to use this roundabout approach.
-	 */
-	rc = device_schedule_callback(dev, sdev_store_delete_callback);
-	if (rc)
-		count = rc;
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 0460970..5d708ff 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -715,68 +715,5 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
 
-struct sysfs_schedule_callback_struct {
-	struct kobject 		*kobj;
-	void			(*func)(void *);
-	void			*data;
-	struct module		*owner;
-	struct work_struct	work;
-};
-
-static void sysfs_schedule_callback_work(struct work_struct *work)
-{
-	struct sysfs_schedule_callback_struct *ss = container_of(work,
-			struct sysfs_schedule_callback_struct, work);
-
-	(ss->func)(ss->data);
-	kobject_put(ss->kobj);
-	module_put(ss->owner);
-	kfree(ss);
-}
-
-/**
- * sysfs_schedule_callback - helper to schedule a callback for a kobject
- * @kobj: object we're acting for.
- * @func: callback function to invoke later.
- * @data: argument to pass to @func.
- * @owner: module owning the callback code
- *
- * sysfs attribute methods must not unregister themselves or their parent
- * kobject (which would amount to the same thing).  Attempts to do so will
- * deadlock, since unregistration is mutually exclusive with driver
- * callbacks.
- *
- * Instead methods can call this routine, which will attempt to allocate
- * and schedule a workqueue request to call back @func with @data as its
- * argument in the workqueue's process context.  @kobj will be pinned
- * until @func returns.
- *
- * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated, -ENODEV if a reference to @owner isn't available.
- */
-int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-		void *data, struct module *owner)
-{
-	struct sysfs_schedule_callback_struct *ss;
-
-	if (!try_module_get(owner))
-		return -ENODEV;
-	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-	if (!ss) {
-		module_put(owner);
-		return -ENOMEM;
-	}
-	kobject_get(kobj);
-	ss->kobj = kobj;
-	ss->func = func;
-	ss->data = data;
-	ss->owner = owner;
-	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
-	schedule_work(&ss->work);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
-
-
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
diff --git a/include/linux/device.h b/include/linux/device.h
index 2e15822..61fc85d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -356,12 +356,6 @@ extern int __must_check device_create_bin_file(struct device *dev,
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
-extern int device_schedule_callback_owner(struct device *dev,
-		void (*func)(struct device *), struct module *owner);
-
-/* This is a macro to avoid include problems with THIS_MODULE */
-#define device_schedule_callback(dev, func)			\
-	device_schedule_callback_owner(dev, func, THIS_MODULE)
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index db5dd24..8af072e 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -76,9 +76,6 @@ struct sysfs_ops {
 
 #ifdef CONFIG_SYSFS
 
-int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-			    void *data, struct module *owner);
-
 int __must_check sysfs_create_dir(struct kobject *kobj);
 void sysfs_remove_dir(struct kobject *kobj);
 int __must_check sysfs_rename_dir(struct kobject *kobj, const char *new_name);
@@ -114,12 +111,6 @@ extern int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
 
-static inline int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data, struct module *owner)
-{
-	return -ENOSYS;
-}
-
 static inline int sysfs_create_dir(struct kobject *kobj)
 {
 	return 0;
-- 
1.5.0.3


