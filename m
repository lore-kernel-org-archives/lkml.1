Return-Path: <linux-kernel-owner+w=401wt.eu-S936554AbXGKXzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936554AbXGKXzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934975AbXGKXgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:33452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935257AbXGKXg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/61] sysfs: slim down sysfs_dirent->s_active
Date: Wed, 11 Jul 2007 16:32:06 -0700
Message-Id: <11841969641445-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196954330-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
@@ -48,8 +62,21 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
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
@@ -95,17 +122,25 @@ void sysfs_put_active_two(struct sysfs_dirent *sd)
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
@@ -141,19 +176,6 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
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
@@ -213,8 +235,8 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
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
1.5.2.2

