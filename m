Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYJPRYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYJPRYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYJPROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:44 -0400
Received: from kroah.org ([198.145.64.141]:46985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756307AbYJPROm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/46] sysfs: Support sysfs_notify from atomic context with new sysfs_notify_dirent
Date: Thu, 16 Oct 2008 10:10:26 -0700
Message-Id: <1224177047-11859-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Brown <neilb@suse.de>

Support sysfs_notify from atomic context with new sysfs_notify_dirent

sysfs_notify currently takes sysfs_mutex.
This means that it cannot be called in atomic context.
sysfs_mutex  is sometimes held over a malloc (sysfs_rename_dir)
so it can block on low memory.

In md I want to be able to notify on a sysfs attribute from
atomic context, and I don't want to block on low memory because I
could be in the writeout path for freeing memory.

So:
 - export the "sysfs_dirent" structure along with sysfs_get, sysfs_put
   and sysfs_get_dirent so I can get the sysfs_dirent that I want to
   notify on and hold it in an md structure.
 - split sysfs_notify_dirent out of sysfs_notify so the sysfs_dirent
   can be notified on with no blocking (just a spinlock).

Signed-off-by: Neil Brown <neilb@suse.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c        |    1 +
 fs/sysfs/file.c       |   31 ++++++++++++++++++-------------
 fs/sysfs/mount.c      |   15 +++++++++++++++
 fs/sysfs/sysfs.h      |    6 ++++--
 include/linux/sysfs.h |   27 ++++++++++++++++++++++++---
 5 files changed, 62 insertions(+), 18 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index aedaeba..53bc7fc 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -636,6 +636,7 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 
 	return sd;
 }
+EXPORT_SYMBOL_GPL(sysfs_get_dirent);
 
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index ce8339c..d0d79e6 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -453,6 +453,22 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	return POLLERR|POLLPRI;
 }
 
+void sysfs_notify_dirent(struct sysfs_dirent *sd)
+{
+	struct sysfs_open_dirent *od;
+
+	spin_lock(&sysfs_open_dirent_lock);
+
+	od = sd->s_attr.open;
+	if (od) {
+		atomic_inc(&od->event);
+		wake_up_interruptible(&od->poll);
+	}
+
+	spin_unlock(&sysfs_open_dirent_lock);
+}
+EXPORT_SYMBOL_GPL(sysfs_notify_dirent);
+
 void sysfs_notify(struct kobject *k, char *dir, char *attr)
 {
 	struct sysfs_dirent *sd = k->sd;
@@ -463,19 +479,8 @@ void sysfs_notify(struct kobject *k, char *dir, char *attr)
 		sd = sysfs_find_dirent(sd, dir);
 	if (sd && attr)
 		sd = sysfs_find_dirent(sd, attr);
-	if (sd) {
-		struct sysfs_open_dirent *od;
-
-		spin_lock(&sysfs_open_dirent_lock);
-
-		od = sd->s_attr.open;
-		if (od) {
-			atomic_inc(&od->event);
-			wake_up_interruptible(&od->poll);
-		}
-
-		spin_unlock(&sysfs_open_dirent_lock);
-	}
+	if (sd)
+		sysfs_notify_dirent(sd);
 
 	mutex_unlock(&sysfs_mutex);
 }
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 14f0023..ab343e3 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -16,6 +16,7 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
+#include <linux/module.h>
 
 #include "sysfs.h"
 
@@ -115,3 +116,17 @@ out_err:
 	sysfs_dir_cachep = NULL;
 	goto out;
 }
+
+#undef sysfs_get
+struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
+{
+	return __sysfs_get(sd);
+}
+EXPORT_SYMBOL_GPL(sysfs_get);
+
+#undef sysfs_put
+void sysfs_put(struct sysfs_dirent *sd)
+{
+	__sysfs_put(sd);
+}
+EXPORT_SYMBOL_GPL(sysfs_put);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index a5db496..93c6d6b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -124,7 +124,7 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
 void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
-static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
+static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
 		WARN_ON(!atomic_read(&sd->s_count));
@@ -132,12 +132,14 @@ static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
 	}
 	return sd;
 }
+#define sysfs_get(sd) __sysfs_get(sd)
 
-static inline void sysfs_put(struct sysfs_dirent *sd)
+static inline void __sysfs_put(struct sysfs_dirent *sd)
 {
 	if (sd && atomic_dec_and_test(&sd->s_count))
 		release_sysfs_dirent(sd);
 }
+#define sysfs_put(sd) __sysfs_put(sd)
 
 /*
  * inode.c
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 8ec406a..d8e0230 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -78,6 +78,8 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
 };
 
+struct sysfs_dirent;
+
 #ifdef CONFIG_SYSFS
 
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
@@ -118,10 +120,13 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
-
+void sysfs_notify_dirent(struct sysfs_dirent *sd);
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name);
+struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
+void sysfs_put(struct sysfs_dirent *sd);
 void sysfs_printk_last_file(void);
-
-extern int __must_check sysfs_init(void);
+int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
 
@@ -227,6 +232,22 @@ static inline void sysfs_remove_file_from_group(struct kobject *kobj,
 static inline void sysfs_notify(struct kobject *kobj, char *dir, char *attr)
 {
 }
+static inline void sysfs_notify_dirent(struct sysfs_dirent *sd)
+{
+}
+static inline
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name)
+{
+	return NULL;
+}
+static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
+{
+	return NULL;
+}
+static inline void sysfs_put(struct sysfs_dirent *sd)
+{
+}
 
 static inline int __must_check sysfs_init(void)
 {
-- 
1.6.0.2

