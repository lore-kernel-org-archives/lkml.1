Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYGOW6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYGOW6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYGOW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:58:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:51148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487AbYGOW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:58:08 -0400
From: Neil Brown <neilb@suse.de>
To: Greg K-H <gregkh@suse.de>, Tejun Heo <teheo@suse.de>
Date: Wed, 16 Jul 2008 08:58:04 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18557.11132.728439.827572@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] sysfs: Support sysfs_notify from atomic context with new sysfs_notify_dirent
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Greg,
 I wonder if you would consider this patch for sysfs.  It makes
 sysfs_notify functionality more useful to me.

Thanks,
NeilBrown




Author: NeilBrown <neilb@suse.de>
Date:   Wed Jul 16 08:54:36 2008 +1000

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
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 8c0e4b9..0ea8458 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -606,6 +606,7 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 
 	return sd;
 }
+EXPORT_SYMBOL_GPL(sysfs_get_dirent);
 
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e7735f6..c6060e8 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -440,6 +440,22 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
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
@@ -450,19 +466,8 @@ void sysfs_notify(struct kobject *k, char *dir, char *attr)
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
index ce4e15f..389cb3d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -123,7 +123,7 @@ int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
 void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
-static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
+static inline struct sysfs_dirent *__sysfs_get(struct sysfs_dirent *sd)
 {
 	if (sd) {
 		WARN_ON(!atomic_read(&sd->s_count));
@@ -131,12 +131,14 @@ static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
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
index 7858eac..3ab58db 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -78,6 +78,8 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
 };
 
+struct sysfs_dirent;
+
 #ifdef CONFIG_SYSFS
 
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
@@ -115,6 +117,11 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
+void sysfs_notify_dirent(struct sysfs_dirent *sd);
+struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
+				      const unsigned char *name);
+struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd);
+void sysfs_put(struct sysfs_dirent *sd);
 
 extern int __must_check sysfs_init(void);
 
@@ -215,6 +222,22 @@ static inline void sysfs_remove_file_from_group(struct kobject *kobj,
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
+static inline struct sysfs_dirent sysfs_get(struct sysfs_dirent *sd)
+{
+	return NULL;
+}
+static inline void sysfs_put(struct sysfs_dirent *sd)
+{
+}
 
 static inline int __must_check sysfs_init(void)
 {
