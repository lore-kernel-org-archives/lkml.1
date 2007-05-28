Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbXE1QYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbXE1QYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbXE1QYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:24:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:13708 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXE1QYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:24:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=Js6Q1LkuJyxE/D6WxXqjM8I/fpvv4KFqcjix+WVERVwEzkJluLrSJ7ZZTyoYcFl49nM/orxXkubYw0YHagiUbozAVsJ7s5UrX4uG0KwF8gpxPKCdo46gbdIPp+vvvqimYYpeqgLjr2nUidFqwV51SJSSlPikFCeK89+ZKGYoQkI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/3] sysfs: slim down sysfs_dirent->s_active
In-Reply-To: <118036944617-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:24:06 +0900
Message-Id: <11803694463144-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sysfs_dirent->s_active an atomic_t instead of rwsem.  This
reduces the size of sysfs_dirent from 136 to 104 on 64bit and from 76
to 60 on 32bit with lock debugging turned off.  With lock debugging
turned on the reduction is much larger.

s_active starts at zero and each active reference increments s_active.
Putting a reference decrements s_active.  Deactivation subtracts
SD_DEACTIVATED_BIAS which is currently INT_MIN and assumed to be small
enough to make s_active negative.  If s_active is negative,
sysfs_get() no longer grants new references.  Deactivation succeeds
immediately if there is no active user; otherwise, it waits using a
completion for the last put.

Due to the removal of lockdep tricks, this change makes things less
trickier in release_sysfs_dirent().  As all the complexity is
contained in three s_active functions, I think it's more readable this
way.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   74 +++++++++++++++++++++++++++++++++++-------------------
 fs/sysfs/sysfs.h |   13 +--------
 2 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f5f0b93..40596a0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -10,6 +10,7 @@
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
+#include <linux/completion.h>
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
@@ -32,11 +33,24 @@ static DEFINE_IDA(sysfs_ino_ida);
  */
 struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 {
-	if (sd) {
-		if (unlikely(!down_read_trylock(&sd->s_active)))
-			sd = NULL;
+	if (unlikely(!sd))
+		return NULL;
+
+	while (1) {
+		int v, t;
+
+		v = atomic_read(&sd->s_active);
+		if (unlikely(v < 0))
+			return NULL;
+
+		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
+		if (likely(t == v))
+			return sd;
+		if (t < 0)
+			return NULL;
+
+		cpu_relax();
 	}
-	return sd;
 }
 
 /**
@@ -48,8 +62,21 @@ struct sysfs_dirent *sysfs_get_active(st
  */
 void sysfs_put_active(struct sysfs_dirent *sd)
 {
-	if (sd)
-		up_read(&sd->s_active);
+	struct completion *cmpl;
+	int v;
+
+	if (unlikely(!sd))
+		return;
+
+	v = atomic_dec_return(&sd->s_active);
+	if (likely(v != SD_DEACTIVATED_BIAS))
+		return;
+
+	/* atomic_dec_return() is a mb(), we'll always see the updated
+	 * sd->s_sibling.next.
+	 */
+	cmpl = (void *)sd->s_sibling.next;
+	complete(cmpl);
 }
 
 /**
@@ -95,17 +122,25 @@ void sysfs_put_active_two(struct sysfs_d
  *	sysfs_deactivate - deactivate sysfs_dirent
  *	@sd: sysfs_dirent to deactivate
  *
- *	Deny new active references and drain existing ones.  s_active
- *	will be unlocked when the sysfs_dirent is released.
+ *	Deny new active references and drain existing ones.
  */
 void sysfs_deactivate(struct sysfs_dirent *sd)
 {
-	down_write_nested(&sd->s_active, SYSFS_S_ACTIVE_DEACTIVATE);
+	DECLARE_COMPLETION_ONSTACK(wait);
+	int v;
+
+	BUG_ON(!list_empty(&sd->s_sibling));
+	sd->s_sibling.next = (void *)&wait;
 
-	/* s_active will be unlocked by the thread doing the final put
-	 * on @sd.  Lie to lockdep.
+	/* atomic_add_return() is a mb(), put_active() will always see
+	 * the updated sd->s_sibling.next.
 	 */
-	rwsem_release(&sd->s_active.dep_map, 1, _RET_IP_);
+	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
+
+	if (v != SD_DEACTIVATED_BIAS)
+		wait_for_completion(&wait);
+
+	INIT_LIST_HEAD(&sd->s_sibling);
 }
 
 static int sysfs_alloc_ino(ino_t *pino)
@@ -141,19 +176,6 @@ void release_sysfs_dirent(struct sysfs_d
  repeat:
 	parent_sd = sd->s_parent;
 
-	/* If @sd is being released after deletion, s_active is write
-	 * locked.  If @sd is cursor for directory walk or being
-	 * released prematurely, s_active has no reader or writer.
-	 *
-	 * sysfs_deactivate() lies to lockdep that s_active is
-	 * unlocked immediately.  Lie one more time to cover the
-	 * previous lie.
-	 */
-	if (!down_write_trylock(&sd->s_active))
-		rwsem_acquire(&sd->s_active.dep_map,
-			      SYSFS_S_ACTIVE_DEACTIVATE, 0, _RET_IP_);
-	up_write(&sd->s_active);
-
 	if (sd->s_type & SYSFS_KOBJ_LINK)
 		sysfs_put(sd->s_elem.symlink.target_sd);
 	if (sd->s_type & SYSFS_COPY_NAME)
@@ -213,8 +235,8 @@ struct sysfs_dirent *sysfs_new_dirent(co
 		goto err_out;
 
 	atomic_set(&sd->s_count, 1);
+	atomic_set(&sd->s_active, 0);
 	atomic_set(&sd->s_event, 1);
-	init_rwsem(&sd->s_active);
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f8779ea..ae006b0 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -21,7 +21,7 @@ struct sysfs_elem_bin_attr {
  */
 struct sysfs_dirent {
 	atomic_t		s_count;
-	struct rw_semaphore	s_active;
+	atomic_t		s_active;
 	struct sysfs_dirent	* s_parent;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
@@ -42,16 +42,7 @@ struct sysfs_dirent {
 	atomic_t		s_event;
 };
 
-/*
- * A sysfs file which deletes another file when written to need to
- * write lock the s_active of the victim while its s_active is read
- * locked for the write operation.  Tell lockdep that this is okay.
- */
-enum sysfs_s_active_class
-{
-	SYSFS_S_ACTIVE_NORMAL,		/* file r/w access, etc - default */
-	SYSFS_S_ACTIVE_DEACTIVATE,	/* file deactivation */
-};
+#define SD_DEACTIVATED_BIAS	INT_MIN
 
 extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
-- 
1.4.3.4


