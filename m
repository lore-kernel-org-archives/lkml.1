Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbZCYAuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbZCYAuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbZCYAap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:45 -0400
Received: from kroah.org ([198.145.64.141]:54206 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756895AbZCYAa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Chiang <achiang@hp.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/61] sysfs: only allow one scheduled removal callback per kobj
Date: Tue, 24 Mar 2009 17:26:59 -0700
Message-Id: <1237940825-22904-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Chiang <achiang@hp.com>

The only way for a sysfs attribute to remove itself (without
deadlock) is to use the sysfs_schedule_callback() interface.

Vegard Nossum discovered that a poorly written sysfs ->store
callback can repeatedly schedule remove callbacks on the same
device over and over, e.g.

	$ while true ; do echo 1 > /sys/devices/.../remove ; done

If the 'remove' attribute uses the sysfs_schedule_callback API
and also does not protect itself from concurrent accesses, its
callback handler will be called multiple times, and will
eventually attempt to perform operations on a freed kobject,
leading to many problems.

Instead of requiring all callers of sysfs_schedule_callback to
implement their own synchronization, provide the protection in
the infrastructure.

Now, sysfs_schedule_callback will only allow one scheduled
callback per kobject. On subsequent calls with the same kobject,
return -EAGAIN.

This is a short term fix. The long term fix is to allow sysfs
attributes to remove themselves directly, without any of this
callback hokey pokey.

[cornelia.huck@de.ibm.com: s390 ccwgroup bits]

Reported-by: vegard.nossum@gmail.com
Signed-off-by: Alex Chiang <achiang@hp.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/s390/cio/ccwgroup.c |    5 +++--
 fs/sysfs/file.c             |   26 +++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 918e6fc..b91c171 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -104,8 +104,9 @@ ccwgroup_ungroup_store(struct device *dev, struct device_attribute *attr, const
 	rc = device_schedule_callback(dev, ccwgroup_ungroup_callback);
 out:
 	if (rc) {
-		/* Release onoff "lock" when ungrouping failed. */
-		atomic_set(&gdev->onoff, 0);
+		if (rc != -EAGAIN)
+			/* Release onoff "lock" when ungrouping failed. */
+			atomic_set(&gdev->onoff, 0);
 		return rc;
 	}
 	return count;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1f4a3f8..289c43a 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -659,13 +659,16 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
 
 struct sysfs_schedule_callback_struct {
-	struct kobject 		*kobj;
+	struct list_head	workq_list;
+	struct kobject		*kobj;
 	void			(*func)(void *);
 	void			*data;
 	struct module		*owner;
 	struct work_struct	work;
 };
 
+static DEFINE_MUTEX(sysfs_workq_mutex);
+static LIST_HEAD(sysfs_workq);
 static void sysfs_schedule_callback_work(struct work_struct *work)
 {
 	struct sysfs_schedule_callback_struct *ss = container_of(work,
@@ -674,6 +677,9 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
 	module_put(ss->owner);
+	mutex_lock(&sysfs_workq_mutex);
+	list_del(&ss->workq_list);
+	mutex_unlock(&sysfs_workq_mutex);
 	kfree(ss);
 }
 
@@ -695,15 +701,25 @@ static void sysfs_schedule_callback_work(struct work_struct *work)
  * until @func returns.
  *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated, -ENODEV if a reference to @owner isn't available.
+ * be allocated, -ENODEV if a reference to @owner isn't available,
+ * -EAGAIN if a callback has already been scheduled for @kobj.
  */
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 		void *data, struct module *owner)
 {
-	struct sysfs_schedule_callback_struct *ss;
+	struct sysfs_schedule_callback_struct *ss, *tmp;
 
 	if (!try_module_get(owner))
 		return -ENODEV;
+
+	mutex_lock(&sysfs_workq_mutex);
+	list_for_each_entry_safe(ss, tmp, &sysfs_workq, workq_list)
+		if (ss->kobj == kobj) {
+			mutex_unlock(&sysfs_workq_mutex);
+			return -EAGAIN;
+		}
+	mutex_unlock(&sysfs_workq_mutex);
+
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
 	if (!ss) {
 		module_put(owner);
@@ -715,6 +731,10 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 	ss->data = data;
 	ss->owner = owner;
 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
+	INIT_LIST_HEAD(&ss->workq_list);
+	mutex_lock(&sysfs_workq_mutex);
+	list_add_tail(&ss->workq_list, &sysfs_workq);
+	mutex_unlock(&sysfs_workq_mutex);
 	schedule_work(&ss->work);
 	return 0;
 }
-- 
1.6.2

