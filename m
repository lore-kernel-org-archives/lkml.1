Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbXD0TAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbXD0TAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbXD0S7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074AbXD0S6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Satyam Sharma <satyam.sharma@gmail.com>, Neil Brown <neilb@suse.de>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/46] device_schedule_callback() needs a module reference
Date: Fri, 27 Apr 2007 11:53:54 -0700
Message-Id: <11777001891914-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001852549-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
 <11777001773804-git-send-email-gregkh@suse.de>
 <11777001803098-git-send-email-gregkh@suse.de>
 <11777001852549-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as896b) fixes an oversight in the design of
device_schedule_callback().  It is necessary to acquire a reference to the
module owning the callback routine, to prevent the module from being
unloaded before the callback can run.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c    |   16 ++++++++++------
 fs/sysfs/file.c        |   14 +++++++++++---
 include/linux/device.h |    8 ++++++--
 include/linux/sysfs.h  |    4 ++--
 4 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f69305c..8aa090d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -480,9 +480,10 @@ void device_remove_bin_file(struct device *dev, struct bin_attribute *attr)
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
 /**
- * device_schedule_callback - helper to schedule a callback for a device
+ * device_schedule_callback_owner - helper to schedule a callback for a device
  * @dev: device.
  * @func: callback function to invoke later.
+ * @owner: module owning the callback routine
  *
  * Attribute methods must not unregister themselves or their parent device
  * (which would amount to the same thing).  Attempts to do so will deadlock,
@@ -493,20 +494,23 @@ EXPORT_SYMBOL_GPL(device_remove_bin_file);
  * argument in the workqueue's process context.  @dev will be pinned until
  * @func returns.
  *
+ * This routine is usually called via the inline device_schedule_callback(),
+ * which automatically sets @owner to THIS_MODULE.
+ *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  *
  * NOTE: This routine won't work if CONFIG_SYSFS isn't set!  It uses an
  * underlying sysfs routine (since it is intended for use by attribute
  * methods), and if sysfs isn't available you'll get nothing but -ENOSYS.
  */
-int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *))
+int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner)
 {
 	return sysfs_schedule_callback(&dev->kobj,
-			(void (*)(void *)) func, dev);
+			(void (*)(void *)) func, dev, owner);
 }
-EXPORT_SYMBOL_GPL(device_schedule_callback);
+EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
 static void klist_children_get(struct klist_node *n)
 {
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fc46333..db0413a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -633,6 +633,7 @@ struct sysfs_schedule_callback_struct {
 	struct kobject 		*kobj;
 	void			(*func)(void *);
 	void			*data;
+	struct module		*owner;
 	struct work_struct	work;
 };
 
@@ -643,6 +644,7 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
 
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
+	module_put(ss->owner);
 	kfree(ss);
 }
 
@@ -651,6 +653,7 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
  * @kobj: object we're acting for.
  * @func: callback function to invoke later.
  * @data: argument to pass to @func.
+ * @owner: module owning the callback code
  *
  * sysfs attribute methods must not unregister themselves or their parent
  * kobject (which would amount to the same thing).  Attempts to do so will
@@ -663,20 +666,25 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
  * until @func returns.
  *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  */
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-		void *data)
+		void *data, struct module *owner)
 {
 	struct sysfs_schedule_callback_struct *ss;
 
+	if (!try_module_get(owner))
+		return -ENODEV;
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-	if (!ss)
+	if (!ss) {
+		module_put(owner);
 		return -ENOMEM;
+	}
 	kobject_get(kobj);
 	ss->kobj = kobj;
 	ss->func = func;
 	ss->data = data;
+	ss->owner = owner;
 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
 	schedule_work(&ss->work);
 	return 0;
diff --git a/include/linux/device.h b/include/linux/device.h
index af603a1..8511d14 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -367,8 +367,12 @@ extern int __must_check device_create_bin_file(struct device *dev,
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
-extern int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *));
+extern int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner);
+
+/* This is a macro to avoid include problems with THIS_MODULE */
+#define device_schedule_callback(dev, func)			\
+	device_schedule_callback_owner(dev, func, THIS_MODULE)
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index fea9a6b..7d5d1ec 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -80,7 +80,7 @@ struct sysfs_ops {
 #ifdef CONFIG_SYSFS
 
 extern int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data);
+		void (*func)(void *), void *data, struct module *owner);
 
 extern int __must_check
 sysfs_create_dir(struct kobject *, struct dentry *);
@@ -137,7 +137,7 @@ extern int __must_check sysfs_init(void);
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data)
+		void (*func)(void *), void *data, struct module *owner)
 {
 	return -ENOSYS;
 }
-- 
1.5.1.2

