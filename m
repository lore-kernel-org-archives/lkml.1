Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbXITHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbXITHKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbXITHFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:65209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbXITHFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=EO32ZYfI3LfR6PpLa8F0iWTjRYWoMwIWEGE7vJYeEcYivIK6s4krwCifHHEeMQGh9E1CPX07tbk3hz/L5r+f5iapcK7p827DPdcCF+ih+Lch13ug/CCZ/m+OBHKvF+AQvxg5legSQeajfMsQbRers9rtgv+hAyleuKU32jJtxs4=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 15/15] sysfs: move sysfs file poll implementation to sysfs_open_dirent
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:12 +0900
Message-Id: <11902719121259-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs file poll implementation is scattered over sysfs and kobject.
Event numbering is done in sysfs_dirent but wait itself is done on
kobject.  This not only unecessarily bloats both kobject and
sysfs_dirent but is also buggy - if a sysfs_dirent is removed while
there still are pollers, the associaton betwen the kobject and
sysfs_dirent breaks and kobject may be freed with the pollers still
sleeping on it.

This patch moves whole poll implementation into sysfs_open_dirent.
Each time a sysfs_open_dirent is created, event number restarts from 1
and pollers sleep on sysfs_open_dirent.  As event sequence number is
meaningless without any open file and pollers should have open file
and thus sysfs_open_dirent, this ephemeral event counting works and is
a saner implementation.

This patch fixes the dnagling sleepers bug and reduces the sizes of
kobject and sysfs_dirent by one pointer.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c          |    1 -
 fs/sysfs/file.c         |   25 +++++++++++++++++++------
 fs/sysfs/sysfs.h        |    1 -
 include/linux/kobject.h |    1 -
 lib/kobject.c           |    1 -
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b81744b..ad3394a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -318,7 +318,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	atomic_set(&sd->s_event, 1);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b13ba94..c05f961 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -62,6 +62,8 @@ static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
+	atomic_t		event;
+	wait_queue_head_t	poll;
 	struct list_head	buffers; /* goes through sysfs_buffer.list */
 };
 
@@ -104,7 +106,7 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
-	buffer->event = atomic_read(&attr_sd->s_event);
+	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
 	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
 
 	sysfs_put_active_two(attr_sd);
@@ -301,6 +303,8 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 		return -ENOMEM;
 
 	atomic_set(&new_od->refcnt, 0);
+	atomic_set(&new_od->event, 1);
+	init_waitqueue_head(&new_od->poll);
 	INIT_LIST_HEAD(&new_od->buffers);
 	goto retry;
 }
@@ -443,17 +447,17 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
+	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
 
 	/* need parent for the kobj, grab both */
 	if (!sysfs_get_active_two(attr_sd))
 		goto trigger;
 
-	poll_wait(filp, &kobj->poll, wait);
+	poll_wait(filp, &od->poll, wait);
 
 	sysfs_put_active_two(attr_sd);
 
-	if (buffer->event != atomic_read(&attr_sd->s_event))
+	if (buffer->event != atomic_read(&od->event))
 		goto trigger;
 
 	return 0;
@@ -474,8 +478,17 @@ void sysfs_notify(struct kobject *k, char *dir, char *attr)
 	if (sd && attr)
 		sd = sysfs_find_dirent(sd, attr);
 	if (sd) {
-		atomic_inc(&sd->s_event);
-		wake_up_interruptible(&k->poll);
+		struct sysfs_open_dirent *od;
+
+		spin_lock(&sysfs_open_dirent_lock);
+
+		od = sd->s_attr.open;
+		if (od) {
+			atomic_inc(&od->event);
+			wake_up_interruptible(&od->poll);
+		}
+
+		spin_unlock(&sysfs_open_dirent_lock);
 	}
 
 	mutex_unlock(&sysfs_mutex);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3adce7d..269c845 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -46,7 +46,6 @@ struct sysfs_dirent {
 	ino_t			s_ino;
 	umode_t			s_mode;
 	struct iattr		*s_iattr;
-	atomic_t		s_event;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 0777b3f..a8a84fc 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -66,7 +66,6 @@ struct kobject {
 	struct kset		* kset;
 	struct kobj_type	* ktype;
 	struct sysfs_dirent	* sd;
-	wait_queue_head_t	poll;
 };
 
 extern int kobject_set_name(struct kobject *, const char *, ...)
diff --git a/lib/kobject.c b/lib/kobject.c
index 01f9c3b..a280c62 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -131,7 +131,6 @@ void kobject_init(struct kobject * kobj)
 		return;
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
-	init_waitqueue_head(&kobj->poll);
 	kobj->kset = kset_get(kobj->kset);
 }
 
-- 
1.5.0.3


