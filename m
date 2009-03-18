Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZCRN2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZCRN2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZCRN0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbZCRN0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:44 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/18] GFS2: Merge lock_dlm module into GFS2
Date: Wed, 18 Mar 2009 12:23:40 +0000
Message-Id: <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This is the big patch that I've been working on for some time
now. There are many reasons for wanting to make this change
such as:
 o Reducing overhead by eliminating duplicated fields between structures
 o Simplifcation of the code (reduces the code size by a fair bit)
 o The locking interface is now the DLM interface itself as proposed
   some time ago.
 o Fewer lookups of glocks when processing replies from the DLM
 o Fewer memory allocations/deallocations for each glock
 o Scope to do further optimisations in the future (but this patch is
   more than big enough for now!)

Please note that (a) this patch relates to the lock_dlm module and
not the DLM itself, that is still a separate module; and (b) that
we retain the ability to build GFS2 as a standalone single node
filesystem with out requiring the DLM.

This patch needs a lot of testing, hence my keeping it I restarted
my -git tree after the last merge window. That way, this has the maximum
exposure before its merged. This is (modulo a few minor bug fixes) the
same patch that I've been posting on and off the the last three months
and its passed a number of different tests so far.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index e563a64..3a981b7 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,6 +1,10 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
 	depends on EXPERIMENTAL && (64BIT || LBD)
+	select DLM if GFS2_FS_LOCKING_DLM
+	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
+	select SYSFS if GFS2_FS_LOCKING_DLM
+	select IP_SCTP if DLM_SCTP
 	select FS_POSIX_ACL
 	select CRC32
 	help
@@ -18,17 +22,16 @@ config GFS2_FS
 	  the locking module below. Documentation and utilities for GFS2 can
 	  be found here: http://sources.redhat.com/cluster
 
-	  The "nolock" lock module is now built in to GFS2 by default.
+	  The "nolock" lock module is now built in to GFS2 by default. If
+	  you want to use the DLM, be sure to enable HOTPLUG and IPv4/6
+	  networking.
 
 config GFS2_FS_LOCKING_DLM
-	tristate "GFS2 DLM locking module"
-	depends on GFS2_FS && SYSFS && NET && INET && (IPV6 || IPV6=n)
-	select IP_SCTP if DLM_SCTP
-	select CONFIGFS_FS
-	select DLM
+	bool "GFS2 DLM locking"
+	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && HOTPLUG
 	help
 	  Multiple node locking module for GFS2
 
-	  Most users of GFS2 will require this module. It provides the locking
+	  Most users of GFS2 will require this. It provides the locking
 	  interface between GFS2 and the DLM, which is required to use GFS2
 	  in a cluster environment.
diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index c1b4ec6..a851ea4 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,9 +1,9 @@
 obj-$(CONFIG_GFS2_FS) += gfs2.o
 gfs2-y := acl.o bmap.o dir.o eaops.o eattr.o glock.o \
-	glops.o inode.o log.o lops.o locking.o main.o meta_io.o \
+	glops.o inode.o log.o lops.o main.o meta_io.o \
 	mount.o ops_address.o ops_dentry.o ops_export.o ops_file.o \
 	ops_fstype.o ops_inode.o ops_super.o quota.o \
 	recovery.o rgrp.o super.o sys.o trans.o util.o
 
-obj-$(CONFIG_GFS2_FS_LOCKING_DLM) += locking/dlm/
+gfs2-$(CONFIG_GFS2_FS_LOCKING_DLM) += lock_dlm.o
 
diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index e335dce..43764f4 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -15,7 +15,6 @@
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 11ffc56..3a5d3f8 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -13,7 +13,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index b7c8e5c..aef4d0c 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -60,7 +60,6 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/vmalloc.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/eaops.c b/fs/gfs2/eaops.c
index f114ba2..dee9b03 100644
--- a/fs/gfs2/eaops.c
+++ b/fs/gfs2/eaops.c
@@ -14,7 +14,6 @@
 #include <linux/capability.h>
 #include <linux/xattr.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 0d1c76d..899763a 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -13,7 +13,6 @@
 #include <linux/buffer_head.h>
 #include <linux/xattr.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6b983ae..cd200a5 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/delay.h>
 #include <linux/sort.h>
@@ -18,7 +17,6 @@
 #include <linux/kallsyms.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/list.h>
-#include <linux/lm_interface.h>
 #include <linux/wait.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
@@ -155,13 +153,10 @@ static void glock_free(struct gfs2_glock *gl)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct inode *aspace = gl->gl_aspace;
 
-	if (sdp->sd_lockstruct.ls_ops->lm_put_lock)
-		sdp->sd_lockstruct.ls_ops->lm_put_lock(gl->gl_lock);
-
 	if (aspace)
 		gfs2_aspace_put(aspace);
 
-	kmem_cache_free(gfs2_glock_cachep, gl);
+	sdp->sd_lockstruct.ls_ops->lm_put_lock(gfs2_glock_cachep, gl);
 }
 
 /**
@@ -211,7 +206,6 @@ int gfs2_glock_put(struct gfs2_glock *gl)
 			atomic_dec(&lru_count);
 		}
 		spin_unlock(&lru_lock);
-		GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_UNLOCKED);
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_lru));
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
 		glock_free(gl);
@@ -256,27 +250,6 @@ static struct gfs2_glock *search_bucket(unsigned int hash,
 }
 
 /**
- * gfs2_glock_find() - Find glock by lock number
- * @sdp: The GFS2 superblock
- * @name: The lock name
- *
- * Returns: NULL, or the struct gfs2_glock with the requested number
- */
-
-static struct gfs2_glock *gfs2_glock_find(const struct gfs2_sbd *sdp,
-					  const struct lm_lockname *name)
-{
-	unsigned int hash = gl_hash(sdp, name);
-	struct gfs2_glock *gl;
-
-	read_lock(gl_lock_addr(hash));
-	gl = search_bucket(hash, sdp, name);
-	read_unlock(gl_lock_addr(hash));
-
-	return gl;
-}
-
-/**
  * may_grant - check if its ok to grant a new lock
  * @gl: The glock
  * @gh: The lock request which we wish to grant
@@ -523,7 +496,7 @@ out_locked:
 }
 
 static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
-				 unsigned int cur_state, unsigned int req_state,
+				 unsigned int req_state,
 				 unsigned int flags)
 {
 	int ret = LM_OUT_ERROR;
@@ -532,7 +505,7 @@ static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
 		return req_state == LM_ST_UNLOCKED ? 0 : req_state;
 
 	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock, cur_state,
+		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock,
 							 req_state, flags);
 	return ret;
 }
@@ -575,7 +548,7 @@ __acquires(&gl->gl_spin)
 	    gl->gl_state == LM_ST_DEFERRED) &&
 	    !(lck_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
 		lck_flags |= LM_FLAG_TRY_1CB;
-	ret = gfs2_lm_lock(sdp, gl->gl_lock, gl->gl_state, target, lck_flags);
+	ret = gfs2_lm_lock(sdp, gl, target, lck_flags);
 
 	if (!(ret & LM_OUT_ASYNC)) {
 		finish_xmote(gl, ret);
@@ -681,18 +654,6 @@ static void glock_work_func(struct work_struct *work)
 		gfs2_glock_put(gl);
 }
 
-static int gfs2_lm_get_lock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		     void **lockp)
-{
-	int error = -EIO;
-	if (!sdp->sd_lockstruct.ls_ops->lm_get_lock)
-		return 0;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_get_lock(
-				sdp->sd_lockstruct.ls_lockspace, name, lockp);
-	return error;
-}
-
 /**
  * gfs2_glock_get() - Get a glock, or create one if one doesn't exist
  * @sdp: The GFS2 superblock
@@ -736,6 +697,9 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
 	gl->gl_hash = hash;
 	gl->gl_ops = glops;
+	snprintf(gl->gl_strname, GDLM_STRNAME_BYTES, "%8x%16llx", name.ln_type, (unsigned long long)number);
+	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
+	gl->gl_lksb.sb_lvbptr = gl->gl_lvb;
 	gl->gl_stamp = jiffies;
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
@@ -753,10 +717,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		}
 	}
 
-	error = gfs2_lm_get_lock(sdp, &name, &gl->gl_lock);
-	if (error)
-		goto fail_aspace;
-
 	write_lock(gl_lock_addr(hash));
 	tmp = search_bucket(hash, sdp, &name);
 	if (tmp) {
@@ -772,9 +732,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 
 	return 0;
 
-fail_aspace:
-	if (gl->gl_aspace)
-		gfs2_aspace_put(gl->gl_aspace);
 fail:
 	kmem_cache_free(gfs2_glock_cachep, gl);
 	return error;
@@ -966,7 +923,7 @@ do_cancel:
 	if (!(gh->gh_flags & LM_FLAG_PRIORITY)) {
 		spin_unlock(&gl->gl_spin);
 		if (sdp->sd_lockstruct.ls_ops->lm_cancel)
-			sdp->sd_lockstruct.ls_ops->lm_cancel(gl->gl_lock);
+			sdp->sd_lockstruct.ls_ops->lm_cancel(gl);
 		spin_lock(&gl->gl_spin);
 	}
 	return;
@@ -1240,70 +1197,13 @@ void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs)
 		gfs2_glock_dq_uninit(&ghs[x]);
 }
 
-static int gfs2_lm_hold_lvb(struct gfs2_sbd *sdp, void *lock, char **lvbp)
+void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 {
-	int error = -EIO;
-	if (!sdp->sd_lockstruct.ls_ops->lm_hold_lvb)
-		return 0;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_hold_lvb(lock, lvbp);
-	return error;
-}
-
-/**
- * gfs2_lvb_hold - attach a LVB from a glock
- * @gl: The glock in question
- *
- */
-
-int gfs2_lvb_hold(struct gfs2_glock *gl)
-{
-	int error;
-
-	if (!atomic_read(&gl->gl_lvb_count)) {
-		error = gfs2_lm_hold_lvb(gl->gl_sbd, gl->gl_lock, &gl->gl_lvb);
-		if (error) 
-			return error;
-		gfs2_glock_hold(gl);
-	}
-	atomic_inc(&gl->gl_lvb_count);
-
-	return 0;
-}
-
-/**
- * gfs2_lvb_unhold - detach a LVB from a glock
- * @gl: The glock in question
- *
- */
-
-void gfs2_lvb_unhold(struct gfs2_glock *gl)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-
-	gfs2_glock_hold(gl);
-	gfs2_assert(gl->gl_sbd, atomic_read(&gl->gl_lvb_count) > 0);
-	if (atomic_dec_and_test(&gl->gl_lvb_count)) {
-		if (sdp->sd_lockstruct.ls_ops->lm_unhold_lvb)
-			sdp->sd_lockstruct.ls_ops->lm_unhold_lvb(gl->gl_lock, gl->gl_lvb);
-		gl->gl_lvb = NULL;
-		gfs2_glock_put(gl);
-	}
-	gfs2_glock_put(gl);
-}
-
-static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
-			unsigned int state)
-{
-	struct gfs2_glock *gl;
 	unsigned long delay = 0;
 	unsigned long holdtime;
 	unsigned long now = jiffies;
 
-	gl = gfs2_glock_find(sdp, name);
-	if (!gl)
-		return;
-
+	gfs2_glock_hold(gl);
 	holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
 	if (time_before(now, holdtime))
 		delay = holdtime - now;
@@ -1317,74 +1217,37 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 		gfs2_glock_put(gl);
 }
 
-static void gfs2_jdesc_make_dirty(struct gfs2_sbd *sdp, unsigned int jid)
-{
-	struct gfs2_jdesc *jd;
-
-	spin_lock(&sdp->sd_jindex_spin);
-	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
-		if (jd->jd_jid != jid)
-			continue;
-		jd->jd_dirty = 1;
-		break;
-	}
-	spin_unlock(&sdp->sd_jindex_spin);
-}
-
 /**
- * gfs2_glock_cb - Callback used by locking module
- * @sdp: Pointer to the superblock
- * @type: Type of callback
- * @data: Type dependent data pointer
+ * gfs2_glock_complete - Callback used by locking
+ * @gl: Pointer to the glock
+ * @ret: The return value from the dlm
  *
- * Called by the locking module when it wants to tell us something.
- * Either we need to drop a lock, one of our ASYNC requests completed, or
- * a journal from another client needs to be recovered.
  */
 
-void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
+void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 {
-	struct gfs2_sbd *sdp = cb_data;
-
-	switch (type) {
-	case LM_CB_NEED_E:
-		blocking_cb(sdp, data, LM_ST_UNLOCKED);
-		return;
-
-	case LM_CB_NEED_D:
-		blocking_cb(sdp, data, LM_ST_DEFERRED);
-		return;
-
-	case LM_CB_NEED_S:
-		blocking_cb(sdp, data, LM_ST_SHARED);
-		return;
-
-	case LM_CB_ASYNC: {
-		struct lm_async_cb *async = data;
-		struct gfs2_glock *gl;
-
-		down_read(&gfs2_umount_flush_sem);
-		gl = gfs2_glock_find(sdp, &async->lc_name);
-		if (gfs2_assert_warn(sdp, gl))
+	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
+	down_read(&gfs2_umount_flush_sem);
+	gl->gl_reply = ret;
+	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))) {
+		struct gfs2_holder *gh;
+		spin_lock(&gl->gl_spin);
+		gh = find_first_waiter(gl);
+		if ((!(gh && (gh->gh_flags & LM_FLAG_NOEXP)) &&
+		     (gl->gl_target != LM_ST_UNLOCKED)) ||
+		    ((ret & ~LM_OUT_ST_MASK) != 0))
+			set_bit(GLF_FROZEN, &gl->gl_flags);
+		spin_unlock(&gl->gl_spin);
+		if (test_bit(GLF_FROZEN, &gl->gl_flags)) {
+			up_read(&gfs2_umount_flush_sem);
 			return;
-		gl->gl_reply = async->lc_ret;
-		set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-			gfs2_glock_put(gl);
-		up_read(&gfs2_umount_flush_sem);
-		return;
-	}
-
-	case LM_CB_NEED_RECOVERY:
-		gfs2_jdesc_make_dirty(sdp, *(unsigned int *)data);
-		if (sdp->sd_recoverd_process)
-			wake_up_process(sdp->sd_recoverd_process);
-		return;
-
-	default:
-		gfs2_assert_warn(sdp, 0);
-		return;
+		}
 	}
+	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
+	gfs2_glock_hold(gl);
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+		gfs2_glock_put(gl);
+	up_read(&gfs2_umount_flush_sem);
 }
 
 /**
@@ -1515,6 +1378,27 @@ out:
 	return has_entries;
 }
 
+
+/**
+ * thaw_glock - thaw out a glock which has an unprocessed reply waiting
+ * @gl: The glock to thaw
+ *
+ * N.B. When we freeze a glock, we leave a ref to the glock outstanding,
+ * so this has to result in the ref count being dropped by one.
+ */
+
+static void thaw_glock(struct gfs2_glock *gl)
+{
+	if (!test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
+		return;
+	down_read(&gfs2_umount_flush_sem);
+	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
+	gfs2_glock_hold(gl);
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+		gfs2_glock_put(gl);
+	up_read(&gfs2_umount_flush_sem);
+}
+
 /**
  * clear_glock - look at a glock and see if we can free it from glock cache
  * @gl: the glock to look at
@@ -1540,6 +1424,20 @@ static void clear_glock(struct gfs2_glock *gl)
 }
 
 /**
+ * gfs2_glock_thaw - Thaw any frozen glocks
+ * @sdp: The super block
+ *
+ */
+
+void gfs2_glock_thaw(struct gfs2_sbd *sdp)
+{
+	unsigned x;
+
+	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
+		examine_bucket(thaw_glock, sdp, x);
+}
+
+/**
  * gfs2_gl_hash_clear - Empty out the glock hash table
  * @sdp: the filesystem
  * @wait: wait until it's all gone
@@ -1619,7 +1517,7 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
 	if (flags & LM_FLAG_NOEXP)
 		*p++ = 'e';
 	if (flags & LM_FLAG_ANY)
-		*p++ = 'a';
+		*p++ = 'A';
 	if (flags & LM_FLAG_PRIORITY)
 		*p++ = 'p';
 	if (flags & GL_ASYNC)
@@ -1683,6 +1581,10 @@ static const char *gflags2str(char *buf, const unsigned long *gflags)
 		*p++ = 'i';
 	if (test_bit(GLF_REPLY_PENDING, gflags))
 		*p++ = 'r';
+	if (test_bit(GLF_INITIAL, gflags))
+		*p++ = 'i';
+	if (test_bit(GLF_FROZEN, gflags))
+		*p++ = 'F';
 	*p = 0;
 	return buf;
 }
@@ -1717,14 +1619,13 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 	dtime *= 1000000/HZ; /* demote time in uSec */
 	if (!test_bit(GLF_DEMOTE, &gl->gl_flags))
 		dtime = 0;
-	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llu f:%s t:%s d:%s/%llu l:%d a:%d r:%d\n",
+	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llu f:%s t:%s d:%s/%llu a:%d r:%d\n",
 		  state2str(gl->gl_state),
 		  gl->gl_name.ln_type,
 		  (unsigned long long)gl->gl_name.ln_number,
 		  gflags2str(gflags_buf, &gl->gl_flags),
 		  state2str(gl->gl_target),
 		  state2str(gl->gl_demote_state), dtime,
-		  atomic_read(&gl->gl_lvb_count),
 		  atomic_read(&gl->gl_ail_count),
 		  atomic_read(&gl->gl_ref));
 
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 543ec7e..a602a28 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -11,15 +11,130 @@
 #define __GLOCK_DOT_H__
 
 #include <linux/sched.h>
+#include <linux/parser.h>
 #include "incore.h"
 
-/* Flags for lock requests; used in gfs2_holder gh_flag field.
-   From lm_interface.h:
+/* Options for hostdata parser */
+
+enum {
+	Opt_jid,
+	Opt_id,
+	Opt_first,
+	Opt_nodir,
+	Opt_err,
+};
+
+/*
+ * lm_lockname types
+ */
+
+#define LM_TYPE_RESERVED	0x00
+#define LM_TYPE_NONDISK		0x01
+#define LM_TYPE_INODE		0x02
+#define LM_TYPE_RGRP		0x03
+#define LM_TYPE_META		0x04
+#define LM_TYPE_IOPEN		0x05
+#define LM_TYPE_FLOCK		0x06
+#define LM_TYPE_PLOCK		0x07
+#define LM_TYPE_QUOTA		0x08
+#define LM_TYPE_JOURNAL		0x09
+
+/*
+ * lm_lock() states
+ *
+ * SHARED is compatible with SHARED, not with DEFERRED or EX.
+ * DEFERRED is compatible with DEFERRED, not with SHARED or EX.
+ */
+
+#define LM_ST_UNLOCKED		0
+#define LM_ST_EXCLUSIVE		1
+#define LM_ST_DEFERRED		2
+#define LM_ST_SHARED		3
+
+/*
+ * lm_lock() flags
+ *
+ * LM_FLAG_TRY
+ * Don't wait to acquire the lock if it can't be granted immediately.
+ *
+ * LM_FLAG_TRY_1CB
+ * Send one blocking callback if TRY is set and the lock is not granted.
+ *
+ * LM_FLAG_NOEXP
+ * GFS sets this flag on lock requests it makes while doing journal recovery.
+ * These special requests should not be blocked due to the recovery like
+ * ordinary locks would be.
+ *
+ * LM_FLAG_ANY
+ * A SHARED request may also be granted in DEFERRED, or a DEFERRED request may
+ * also be granted in SHARED.  The preferred state is whichever is compatible
+ * with other granted locks, or the specified state if no other locks exist.
+ *
+ * LM_FLAG_PRIORITY
+ * Override fairness considerations.  Suppose a lock is held in a shared state
+ * and there is a pending request for the deferred state.  A shared lock
+ * request with the priority flag would be allowed to bypass the deferred
+ * request and directly join the other shared lock.  A shared lock request
+ * without the priority flag might be forced to wait until the deferred
+ * requested had acquired and released the lock.
+ */
+
 #define LM_FLAG_TRY		0x00000001
 #define LM_FLAG_TRY_1CB		0x00000002
 #define LM_FLAG_NOEXP		0x00000004
 #define LM_FLAG_ANY		0x00000008
-#define LM_FLAG_PRIORITY	0x00000010 */
+#define LM_FLAG_PRIORITY	0x00000010
+#define GL_ASYNC		0x00000040
+#define GL_EXACT		0x00000080
+#define GL_SKIP			0x00000100
+#define GL_ATIME		0x00000200
+#define GL_NOCACHE		0x00000400
+  
+/*
+ * lm_lock() and lm_async_cb return flags
+ *
+ * LM_OUT_ST_MASK
+ * Masks the lower two bits of lock state in the returned value.
+ *
+ * LM_OUT_CANCELED
+ * The lock request was canceled.
+ *
+ * LM_OUT_ASYNC
+ * The result of the request will be returned in an LM_CB_ASYNC callback.
+ *
+ */
+
+#define LM_OUT_ST_MASK		0x00000003
+#define LM_OUT_CANCELED		0x00000008
+#define LM_OUT_ASYNC		0x00000080
+#define LM_OUT_ERROR		0x00000100
+
+/*
+ * lm_recovery_done() messages
+ */
+
+#define LM_RD_GAVEUP		308
+#define LM_RD_SUCCESS		309
+
+#define GLR_TRYFAILED		13
+
+struct lm_lockops {
+	const char *lm_proto_name;
+	int (*lm_mount) (struct gfs2_sbd *sdp, const char *fsname);
+ 	void (*lm_unmount) (struct gfs2_sbd *sdp);
+	void (*lm_withdraw) (struct gfs2_sbd *sdp);
+	void (*lm_put_lock) (struct kmem_cache *cachep, void *gl);
+	unsigned int (*lm_lock) (struct gfs2_glock *gl,
+				 unsigned int req_state, unsigned int flags);
+	void (*lm_cancel) (struct gfs2_glock *gl);
+	const match_table_t *lm_tokens;
+};
+
+#define LM_FLAG_TRY		0x00000001
+#define LM_FLAG_TRY_1CB		0x00000002
+#define LM_FLAG_NOEXP		0x00000004
+#define LM_FLAG_ANY		0x00000008
+#define LM_FLAG_PRIORITY	0x00000010
 
 #define GL_ASYNC		0x00000040
 #define GL_EXACT		0x00000080
@@ -128,10 +243,12 @@ static inline int gfs2_glock_nq_init(struct gfs2_glock *gl,
 int gfs2_lvb_hold(struct gfs2_glock *gl);
 void gfs2_lvb_unhold(struct gfs2_glock *gl);
 
-void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
+void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state);
+void gfs2_glock_complete(struct gfs2_glock *gl, int ret);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
 void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
+void gfs2_glock_thaw(struct gfs2_sbd *sdp);
 
 int __init gfs2_glock_init(void);
 void gfs2_glock_exit(void);
@@ -141,4 +258,6 @@ void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp);
 int gfs2_register_debugfs(void);
 void gfs2_unregister_debugfs(void);
 
+extern const struct lm_lockops gfs2_dlm_ops;
+
 #endif /* __GLOCK_DOT_H__ */
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 8522d3a..f07ede8 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -12,7 +12,6 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <linux/bio.h>
 
 #include "gfs2.h"
@@ -390,18 +389,6 @@ static int trans_go_demote_ok(const struct gfs2_glock *gl)
 	return 0;
 }
 
-/**
- * quota_go_demote_ok - Check to see if it's ok to unlock a quota glock
- * @gl: the glock
- *
- * Returns: 1 if it's ok
- */
-
-static int quota_go_demote_ok(const struct gfs2_glock *gl)
-{
-	return !atomic_read(&gl->gl_lvb_count);
-}
-
 const struct gfs2_glock_operations gfs2_meta_glops = {
 	.go_xmote_th = meta_go_sync,
 	.go_type = LM_TYPE_META,
@@ -448,7 +435,6 @@ const struct gfs2_glock_operations gfs2_nondisk_glops = {
 };
 
 const struct gfs2_glock_operations gfs2_quota_glops = {
-	.go_demote_ok = quota_go_demote_ok,
 	.go_type = LM_TYPE_QUOTA,
 };
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index a0117d6..0af7c24 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -12,6 +12,8 @@
 
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/dlm.h>
+#include <linux/buffer_head.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -26,6 +28,7 @@ struct gfs2_trans;
 struct gfs2_ail;
 struct gfs2_jdesc;
 struct gfs2_sbd;
+struct lm_lockops;
 
 typedef void (*gfs2_glop_bh_t) (struct gfs2_glock *gl, unsigned int ret);
 
@@ -121,6 +124,28 @@ struct gfs2_bufdata {
 	struct list_head bd_ail_gl_list;
 };
 
+/*
+ * Internally, we prefix things with gdlm_ and GDLM_ (for gfs-dlm) since a
+ * prefix of lock_dlm_ gets awkward.
+ */
+
+#define GDLM_STRNAME_BYTES	25
+#define GDLM_LVB_SIZE		32
+
+enum {
+	DFL_BLOCK_LOCKS		= 0,
+};
+
+struct lm_lockname {
+	u64 ln_number;
+	unsigned int ln_type;
+};
+
+#define lm_name_equal(name1, name2) \
+        (((name1)->ln_number == (name2)->ln_number) && \
+         ((name1)->ln_type == (name2)->ln_type))
+
+
 struct gfs2_glock_operations {
 	void (*go_xmote_th) (struct gfs2_glock *gl);
 	int (*go_xmote_bh) (struct gfs2_glock *gl, struct gfs2_holder *gh);
@@ -162,6 +187,8 @@ enum {
 	GLF_LFLUSH			= 7,
 	GLF_INVALIDATE_IN_PROGRESS	= 8,
 	GLF_REPLY_PENDING		= 9,
+	GLF_INITIAL			= 10,
+	GLF_FROZEN			= 11,
 };
 
 struct gfs2_glock {
@@ -181,10 +208,9 @@ struct gfs2_glock {
 	struct list_head gl_holders;
 
 	const struct gfs2_glock_operations *gl_ops;
-	void *gl_lock;
-	char *gl_lvb;
-	atomic_t gl_lvb_count;
-
+	char gl_strname[GDLM_STRNAME_BYTES];
+	struct dlm_lksb gl_lksb;
+	char gl_lvb[32];
 	unsigned long gl_stamp;
 	unsigned long gl_tchange;
 	void *gl_object;
@@ -447,6 +473,30 @@ struct gfs2_sb_host {
 	char sb_locktable[GFS2_LOCKNAME_LEN];
 };
 
+/*
+ * lm_mount() return values
+ *
+ * ls_jid - the journal ID this node should use
+ * ls_first - this node is the first to mount the file system
+ * ls_lockspace - lock module's context for this file system
+ * ls_ops - lock module's functions
+ */
+
+struct lm_lockstruct {
+	u32 ls_id;
+	unsigned int ls_jid;
+	unsigned int ls_first;
+	unsigned int ls_first_done;
+	unsigned int ls_nodir;
+	const struct lm_lockops *ls_ops;
+	unsigned long ls_flags;
+	dlm_lockspace_t *ls_dlm;
+
+	int ls_recover_jid;
+	int ls_recover_jid_done;
+	int ls_recover_jid_status;
+};
+
 struct gfs2_sbd {
 	struct super_block *sd_vfs;
 	struct kobject sd_kobj;
@@ -520,7 +570,6 @@ struct gfs2_sbd {
 	spinlock_t sd_jindex_spin;
 	struct mutex sd_jindex_mutex;
 	unsigned int sd_journals;
-	unsigned long sd_jindex_refresh_time;
 
 	struct gfs2_jdesc *sd_jdesc;
 	struct gfs2_holder sd_journal_gh;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3b87c18..7b277d4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -16,7 +16,6 @@
 #include <linux/sort.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 #include <linux/security.h>
 #include <linux/time.h>
 
@@ -137,16 +136,16 @@ void gfs2_set_iop(struct inode *inode)
 
 	if (S_ISREG(mode)) {
 		inode->i_op = &gfs2_file_iops;
-		if (sdp->sd_args.ar_localflocks)
-			inode->i_fop = &gfs2_file_fops_nolock;
+		if (gfs2_localflocks(sdp))
+			inode->i_fop = gfs2_file_fops_nolock;
 		else
-			inode->i_fop = &gfs2_file_fops;
+			inode->i_fop = gfs2_file_fops;
 	} else if (S_ISDIR(mode)) {
 		inode->i_op = &gfs2_dir_iops;
-		if (sdp->sd_args.ar_localflocks)
-			inode->i_fop = &gfs2_dir_fops_nolock;
+		if (gfs2_localflocks(sdp))
+			inode->i_fop = gfs2_dir_fops_nolock;
 		else
-			inode->i_fop = &gfs2_dir_fops;
+			inode->i_fop = gfs2_dir_fops;
 	} else if (S_ISLNK(mode)) {
 		inode->i_op = &gfs2_symlink_iops;
 	} else {
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index d532936..dca4fee 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -101,12 +101,26 @@ void gfs2_dinode_print(const struct gfs2_inode *ip);
 extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
 extern const struct inode_operations gfs2_symlink_iops;
-extern const struct file_operations gfs2_file_fops;
-extern const struct file_operations gfs2_dir_fops;
-extern const struct file_operations gfs2_file_fops_nolock;
-extern const struct file_operations gfs2_dir_fops_nolock;
+extern const struct file_operations *gfs2_file_fops_nolock;
+extern const struct file_operations *gfs2_dir_fops_nolock;
 
 extern void gfs2_set_inode_flags(struct inode *inode);
+ 
+#ifdef CONFIG_GFS2_FS_LOCKING_DLM
+extern const struct file_operations *gfs2_file_fops;
+extern const struct file_operations *gfs2_dir_fops;
+static inline int gfs2_localflocks(const struct gfs2_sbd *sdp)
+{
+	return sdp->sd_args.ar_localflocks;
+}
+#else /* Single node only */
+#define gfs2_file_fops NULL
+#define gfs2_dir_fops NULL
+static inline int gfs2_localflocks(const struct gfs2_sbd *sdp)
+{
+	return 1;
+}
+#endif /* CONFIG_GFS2_FS_LOCKING_DLM */
 
 #endif /* __INODE_DOT_H__ */
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
new file mode 100644
index 0000000..a0bb7d2
--- /dev/null
+++ b/fs/gfs2/lock_dlm.c
@@ -0,0 +1,240 @@
+/*
+ * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
+ * Copyright (C) 2004-2009 Red Hat, Inc.  All rights reserved.
+ *
+ * This copyrighted material is made available to anyone wishing to use,
+ * modify, copy, or redistribute it subject to the terms and conditions
+ * of the GNU General Public License version 2.
+ */
+
+#include <linux/fs.h>
+#include <linux/dlm.h>
+#include <linux/types.h>
+#include <linux/gfs2_ondisk.h>
+
+#include "incore.h"
+#include "glock.h"
+#include "util.h"
+
+
+static void gdlm_ast(void *arg)
+{
+	struct gfs2_glock *gl = arg;
+	unsigned ret = gl->gl_state;
+
+	BUG_ON(gl->gl_lksb.sb_flags & DLM_SBF_DEMOTED);
+
+	if (gl->gl_lksb.sb_flags & DLM_SBF_VALNOTVALID)
+		memset(gl->gl_lvb, 0, GDLM_LVB_SIZE);
+
+	switch (gl->gl_lksb.sb_status) {
+	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
+		kmem_cache_free(gfs2_glock_cachep, gl);
+		return;
+	case -DLM_ECANCEL: /* Cancel while getting lock */
+		ret |= LM_OUT_CANCELED;
+		goto out;
+	case -EAGAIN: /* Try lock fails */
+		goto out;
+	case -EINVAL: /* Invalid */
+	case -ENOMEM: /* Out of memory */
+		ret |= LM_OUT_ERROR;
+		goto out;
+	case 0: /* Success */
+		break;
+	default: /* Something unexpected */
+		BUG();
+	}
+
+	ret = gl->gl_target;
+	if (gl->gl_lksb.sb_flags & DLM_SBF_ALTMODE) {
+		if (gl->gl_target == LM_ST_SHARED)
+			ret = LM_ST_DEFERRED;
+		else if (gl->gl_target == LM_ST_DEFERRED)
+			ret = LM_ST_SHARED;
+		else
+			BUG();
+	}
+
+	set_bit(GLF_INITIAL, &gl->gl_flags);
+	gfs2_glock_complete(gl, ret);
+	return;
+out:
+	if (!test_bit(GLF_INITIAL, &gl->gl_flags))
+		gl->gl_lksb.sb_lkid = 0;
+	gfs2_glock_complete(gl, ret);
+}
+
+static void gdlm_bast(void *arg, int mode)
+{
+	struct gfs2_glock *gl = arg;
+
+	switch (mode) {
+	case DLM_LOCK_EX:
+		gfs2_glock_cb(gl, LM_ST_UNLOCKED);
+		break;
+	case DLM_LOCK_CW:
+		gfs2_glock_cb(gl, LM_ST_DEFERRED);
+		break;
+	case DLM_LOCK_PR:
+		gfs2_glock_cb(gl, LM_ST_SHARED);
+		break;
+	default:
+		printk(KERN_ERR "unknown bast mode %d", mode);
+		BUG();
+	}
+}
+
+/* convert gfs lock-state to dlm lock-mode */
+
+static int make_mode(const unsigned int lmstate)
+{
+	switch (lmstate) {
+	case LM_ST_UNLOCKED:
+		return DLM_LOCK_NL;
+	case LM_ST_EXCLUSIVE:
+		return DLM_LOCK_EX;
+	case LM_ST_DEFERRED:
+		return DLM_LOCK_CW;
+	case LM_ST_SHARED:
+		return DLM_LOCK_PR;
+	}
+	printk(KERN_ERR "unknown LM state %d", lmstate);
+	BUG();
+	return -1;
+}
+
+static u32 make_flags(const u32 lkid, const unsigned int gfs_flags,
+		      const int req)
+{
+	u32 lkf = 0;
+
+	if (gfs_flags & LM_FLAG_TRY)
+		lkf |= DLM_LKF_NOQUEUE;
+
+	if (gfs_flags & LM_FLAG_TRY_1CB) {
+		lkf |= DLM_LKF_NOQUEUE;
+		lkf |= DLM_LKF_NOQUEUEBAST;
+	}
+
+	if (gfs_flags & LM_FLAG_PRIORITY) {
+		lkf |= DLM_LKF_NOORDER;
+		lkf |= DLM_LKF_HEADQUE;
+	}
+
+	if (gfs_flags & LM_FLAG_ANY) {
+		if (req == DLM_LOCK_PR)
+			lkf |= DLM_LKF_ALTCW;
+		else if (req == DLM_LOCK_CW)
+			lkf |= DLM_LKF_ALTPR;
+		else
+			BUG();
+	}
+
+	if (lkid != 0) 
+		lkf |= DLM_LKF_CONVERT;
+
+	lkf |= DLM_LKF_VALBLK;
+
+	return lkf;
+}
+
+static unsigned int gdlm_lock(struct gfs2_glock *gl,
+			      unsigned int req_state, unsigned int flags)
+{
+	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
+	int error;
+	int req;
+	u32 lkf;
+
+	req = make_mode(req_state);
+	lkf = make_flags(gl->gl_lksb.sb_lkid, flags, req);
+
+	/*
+	 * Submit the actual lock request.
+	 */
+
+	error = dlm_lock(ls->ls_dlm, req, &gl->gl_lksb, lkf, gl->gl_strname,
+			 GDLM_STRNAME_BYTES - 1, 0, gdlm_ast, gl, gdlm_bast);
+	if (error == -EAGAIN)
+		return 0;
+	if (error)
+		return LM_OUT_ERROR;
+	return LM_OUT_ASYNC;
+}
+
+static void gdlm_put_lock(struct kmem_cache *cachep, void *ptr)
+{
+	struct gfs2_glock *gl = ptr;
+	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
+	int error;
+
+	if (gl->gl_lksb.sb_lkid == 0) {
+		kmem_cache_free(cachep, gl);
+		return;
+	}
+
+	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_VALBLK,
+			   NULL, gl);
+	if (error) {
+		printk(KERN_ERR "gdlm_unlock %x,%llx err=%d\n",
+		       gl->gl_name.ln_type,
+		       (unsigned long long)gl->gl_name.ln_number, error);
+		return;
+	}
+}
+
+static void gdlm_cancel(struct gfs2_glock *gl)
+{
+	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
+	dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_CANCEL, NULL, gl);
+}
+
+static int gdlm_mount(struct gfs2_sbd *sdp, const char *fsname)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	int error;
+
+	if (fsname == NULL) {
+		fs_info(sdp, "no fsname found\n");
+		return -EINVAL;
+	}
+
+	error = dlm_new_lockspace(fsname, strlen(fsname), &ls->ls_dlm,
+				  DLM_LSFL_FS | DLM_LSFL_NEWEXCL |
+				  (ls->ls_nodir ? DLM_LSFL_NODIR : 0),
+				  GDLM_LVB_SIZE);
+	if (error)
+		printk(KERN_ERR "dlm_new_lockspace error %d", error);
+
+	return error;
+}
+
+static void gdlm_unmount(struct gfs2_sbd *sdp)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+
+	if (ls->ls_dlm) {
+		dlm_release_lockspace(ls->ls_dlm, 2);
+		ls->ls_dlm = NULL;
+	}
+}
+
+static const match_table_t dlm_tokens = {
+	{ Opt_jid, "jid=%d"},
+	{ Opt_id, "id=%d"},
+	{ Opt_first, "first=%d"},
+	{ Opt_nodir, "nodir=%d"},
+	{ Opt_err, NULL },
+};
+
+const struct lm_lockops gfs2_dlm_ops = {
+	.lm_proto_name = "lock_dlm",
+	.lm_mount = gdlm_mount,
+	.lm_unmount = gdlm_unmount,
+	.lm_put_lock = gdlm_put_lock,
+	.lm_lock = gdlm_lock,
+	.lm_cancel = gdlm_cancel,
+	.lm_tokens = &dlm_tokens,
+};
+
diff --git a/fs/gfs2/locking.c b/fs/gfs2/locking.c
deleted file mode 100644
index d3657bc..0000000
--- a/fs/gfs2/locking.c
+++ /dev/null
@@ -1,314 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/wait.h>
-#include <linux/sched.h>
-#include <linux/kmod.h>
-#include <linux/fs.h>
-#include <linux/delay.h>
-#include <linux/lm_interface.h>
-
-struct lmh_wrapper {
-	struct list_head lw_list;
-	const struct lm_lockops *lw_ops;
-};
-
-struct nolock_lockspace {
-	unsigned int nl_lvb_size;
-};
-
-/**
- * nolock_get_lock - get a lm_lock_t given a descripton of the lock
- * @lockspace: the lockspace the lock lives in
- * @name: the name of the lock
- * @lockp: return the lm_lock_t here
- *
- * Returns: 0 on success, -EXXX on failure
- */
-
-static int nolock_get_lock(void *lockspace, struct lm_lockname *name,
-                           void **lockp)
-{
-        *lockp = lockspace;
-        return 0;
-}
-
-/**
- * nolock_put_lock - get rid of a lock structure
- * @lock: the lock to throw away
- *
- */
-
-static void nolock_put_lock(void *lock)
-{
-}
-
-/**
- * nolock_hold_lvb - hold on to a lock value block
- * @lock: the lock the LVB is associated with
- * @lvbp: return the lm_lvb_t here
- *
- * Returns: 0 on success, -EXXX on failure
- */
-
-static int nolock_hold_lvb(void *lock, char **lvbp)
-{
-	struct nolock_lockspace *nl = lock;
-	int error = 0;
-
-	*lvbp = kzalloc(nl->nl_lvb_size, GFP_KERNEL);
-	if (!*lvbp)
-		error = -ENOMEM;
-
-	return error;
-}
-
-/**
- * nolock_unhold_lvb - release a LVB
- * @lock: the lock the LVB is associated with
- * @lvb: the lock value block
- *
- */
-
-static void nolock_unhold_lvb(void *lock, char *lvb)
-{
-	kfree(lvb);
-}
-
-static int nolock_mount(char *table_name, char *host_data,
-			lm_callback_t cb, void *cb_data,
-			unsigned int min_lvb_size, int flags,
-			struct lm_lockstruct *lockstruct,
-			struct kobject *fskobj);
-static void nolock_unmount(void *lockspace);
-
-/* List of registered low-level locking protocols.  A file system selects one
-   of them by name at mount time, e.g. lock_nolock, lock_dlm. */
-
-static const struct lm_lockops nolock_ops = {
-	.lm_proto_name = "lock_nolock",
-	.lm_mount = nolock_mount,
-	.lm_unmount = nolock_unmount,
-	.lm_get_lock = nolock_get_lock,
-	.lm_put_lock = nolock_put_lock,
-	.lm_hold_lvb = nolock_hold_lvb,
-	.lm_unhold_lvb = nolock_unhold_lvb,
-};
-
-static struct lmh_wrapper nolock_proto  = {
-	.lw_list = LIST_HEAD_INIT(nolock_proto.lw_list),
-	.lw_ops = &nolock_ops,
-};
-
-static LIST_HEAD(lmh_list);
-static DEFINE_MUTEX(lmh_lock);
-
-static int nolock_mount(char *table_name, char *host_data,
-			lm_callback_t cb, void *cb_data,
-			unsigned int min_lvb_size, int flags,
-			struct lm_lockstruct *lockstruct,
-			struct kobject *fskobj)
-{
-	char *c;
-	unsigned int jid;
-	struct nolock_lockspace *nl;
-
-	c = strstr(host_data, "jid=");
-	if (!c)
-		jid = 0;
-	else {
-		c += 4;
-		sscanf(c, "%u", &jid);
-	}
-
-	nl = kzalloc(sizeof(struct nolock_lockspace), GFP_KERNEL);
-	if (!nl)
-		return -ENOMEM;
-
-	nl->nl_lvb_size = min_lvb_size;
-
-	lockstruct->ls_jid = jid;
-	lockstruct->ls_first = 1;
-	lockstruct->ls_lvb_size = min_lvb_size;
-	lockstruct->ls_lockspace = nl;
-	lockstruct->ls_ops = &nolock_ops;
-	lockstruct->ls_flags = LM_LSFLAG_LOCAL;
-
-	return 0;
-}
-
-static void nolock_unmount(void *lockspace)
-{
-        struct nolock_lockspace *nl = lockspace;
-        kfree(nl);
-}
-
-/**
- * gfs2_register_lockproto - Register a low-level locking protocol
- * @proto: the protocol definition
- *
- * Returns: 0 on success, -EXXX on failure
- */
-
-int gfs2_register_lockproto(const struct lm_lockops *proto)
-{
-	struct lmh_wrapper *lw;
-
-	mutex_lock(&lmh_lock);
-
-	list_for_each_entry(lw, &lmh_list, lw_list) {
-		if (!strcmp(lw->lw_ops->lm_proto_name, proto->lm_proto_name)) {
-			mutex_unlock(&lmh_lock);
-			printk(KERN_INFO "GFS2: protocol %s already exists\n",
-			       proto->lm_proto_name);
-			return -EEXIST;
-		}
-	}
-
-	lw = kzalloc(sizeof(struct lmh_wrapper), GFP_KERNEL);
-	if (!lw) {
-		mutex_unlock(&lmh_lock);
-		return -ENOMEM;
-	}
-
-	lw->lw_ops = proto;
-	list_add(&lw->lw_list, &lmh_list);
-
-	mutex_unlock(&lmh_lock);
-
-	return 0;
-}
-
-/**
- * gfs2_unregister_lockproto - Unregister a low-level locking protocol
- * @proto: the protocol definition
- *
- */
-
-void gfs2_unregister_lockproto(const struct lm_lockops *proto)
-{
-	struct lmh_wrapper *lw;
-
-	mutex_lock(&lmh_lock);
-
-	list_for_each_entry(lw, &lmh_list, lw_list) {
-		if (!strcmp(lw->lw_ops->lm_proto_name, proto->lm_proto_name)) {
-			list_del(&lw->lw_list);
-			mutex_unlock(&lmh_lock);
-			kfree(lw);
-			return;
-		}
-	}
-
-	mutex_unlock(&lmh_lock);
-
-	printk(KERN_WARNING "GFS2: can't unregister lock protocol %s\n",
-	       proto->lm_proto_name);
-}
-
-/**
- * gfs2_mount_lockproto - Mount a lock protocol
- * @proto_name - the name of the protocol
- * @table_name - the name of the lock space
- * @host_data - data specific to this host
- * @cb - the callback to the code using the lock module
- * @sdp - The GFS2 superblock
- * @min_lvb_size - the mininum LVB size that the caller can deal with
- * @flags - LM_MFLAG_*
- * @lockstruct - a structure returned describing the mount
- *
- * Returns: 0 on success, -EXXX on failure
- */
-
-int gfs2_mount_lockproto(char *proto_name, char *table_name, char *host_data,
-			 lm_callback_t cb, void *cb_data,
-			 unsigned int min_lvb_size, int flags,
-			 struct lm_lockstruct *lockstruct,
-			 struct kobject *fskobj)
-{
-	struct lmh_wrapper *lw = NULL;
-	int try = 0;
-	int error, found;
-
-
-retry:
-	mutex_lock(&lmh_lock);
-
-	if (list_empty(&nolock_proto.lw_list))
-		list_add(&nolock_proto.lw_list, &lmh_list);
-
-	found = 0;
-	list_for_each_entry(lw, &lmh_list, lw_list) {
-		if (!strcmp(lw->lw_ops->lm_proto_name, proto_name)) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		if (!try && capable(CAP_SYS_MODULE)) {
-			try = 1;
-			mutex_unlock(&lmh_lock);
-			request_module(proto_name);
-			goto retry;
-		}
-		printk(KERN_INFO "GFS2: can't find protocol %s\n", proto_name);
-		error = -ENOENT;
-		goto out;
-	}
-
-	if (lw->lw_ops->lm_owner &&
-	    !try_module_get(lw->lw_ops->lm_owner)) {
-		try = 0;
-		mutex_unlock(&lmh_lock);
-		msleep(1000);
-		goto retry;
-	}
-
-	error = lw->lw_ops->lm_mount(table_name, host_data, cb, cb_data,
-				     min_lvb_size, flags, lockstruct, fskobj);
-	if (error)
-		module_put(lw->lw_ops->lm_owner);
-out:
-	mutex_unlock(&lmh_lock);
-	return error;
-}
-
-void gfs2_unmount_lockproto(struct lm_lockstruct *lockstruct)
-{
-	mutex_lock(&lmh_lock);
-	if (lockstruct->ls_ops->lm_unmount)
-		lockstruct->ls_ops->lm_unmount(lockstruct->ls_lockspace);
-	if (lockstruct->ls_ops->lm_owner)
-		module_put(lockstruct->ls_ops->lm_owner);
-	mutex_unlock(&lmh_lock);
-}
-
-/**
- * gfs2_withdraw_lockproto - abnormally unmount a lock module
- * @lockstruct: the lockstruct passed into mount
- *
- */
-
-void gfs2_withdraw_lockproto(struct lm_lockstruct *lockstruct)
-{
-	mutex_lock(&lmh_lock);
-	lockstruct->ls_ops->lm_withdraw(lockstruct->ls_lockspace);
-	if (lockstruct->ls_ops->lm_owner)
-		module_put(lockstruct->ls_ops->lm_owner);
-	mutex_unlock(&lmh_lock);
-}
-
-EXPORT_SYMBOL_GPL(gfs2_register_lockproto);
-EXPORT_SYMBOL_GPL(gfs2_unregister_lockproto);
-
diff --git a/fs/gfs2/locking/dlm/Makefile b/fs/gfs2/locking/dlm/Makefile
deleted file mode 100644
index 2609bb6..0000000
--- a/fs/gfs2/locking/dlm/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-obj-$(CONFIG_GFS2_FS_LOCKING_DLM) += lock_dlm.o
-lock_dlm-y := lock.o main.o mount.o sysfs.o thread.o
-
diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
deleted file mode 100644
index 2482c90..0000000
--- a/fs/gfs2/locking/dlm/lock.c
+++ /dev/null
@@ -1,708 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include "lock_dlm.h"
-
-static char junk_lvb[GDLM_LVB_SIZE];
-
-
-/* convert dlm lock-mode to gfs lock-state */
-
-static s16 gdlm_make_lmstate(s16 dlmmode)
-{
-	switch (dlmmode) {
-	case DLM_LOCK_IV:
-	case DLM_LOCK_NL:
-		return LM_ST_UNLOCKED;
-	case DLM_LOCK_EX:
-		return LM_ST_EXCLUSIVE;
-	case DLM_LOCK_CW:
-		return LM_ST_DEFERRED;
-	case DLM_LOCK_PR:
-		return LM_ST_SHARED;
-	}
-	gdlm_assert(0, "unknown DLM mode %d", dlmmode);
-	return -1;
-}
-
-/* A lock placed on this queue is re-submitted to DLM as soon as the lock_dlm
-   thread gets to it. */
-
-static void queue_submit(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-
-	spin_lock(&ls->async_lock);
-	list_add_tail(&lp->delay_list, &ls->submit);
-	spin_unlock(&ls->async_lock);
-	wake_up(&ls->thread_wait);
-}
-
-static void wake_up_ast(struct gdlm_lock *lp)
-{
-	clear_bit(LFL_AST_WAIT, &lp->flags);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&lp->flags, LFL_AST_WAIT);
-}
-
-static void gdlm_delete_lp(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-
-	spin_lock(&ls->async_lock);
-	if (!list_empty(&lp->delay_list))
-		list_del_init(&lp->delay_list);
-	ls->all_locks_count--;
-	spin_unlock(&ls->async_lock);
-
-	kfree(lp);
-}
-
-static void gdlm_queue_delayed(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-
-	spin_lock(&ls->async_lock);
-	list_add_tail(&lp->delay_list, &ls->delayed);
-	spin_unlock(&ls->async_lock);
-}
-
-static void process_complete(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-	struct lm_async_cb acb;
-
-	memset(&acb, 0, sizeof(acb));
-
-	if (lp->lksb.sb_status == -DLM_ECANCEL) {
-		log_info("complete dlm cancel %x,%llx flags %lx",
-		 	 lp->lockname.ln_type,
-			 (unsigned long long)lp->lockname.ln_number,
-			 lp->flags);
-
-		lp->req = lp->cur;
-		acb.lc_ret |= LM_OUT_CANCELED;
-		if (lp->cur == DLM_LOCK_IV)
-			lp->lksb.sb_lkid = 0;
-		goto out;
-	}
-
-	if (test_and_clear_bit(LFL_DLM_UNLOCK, &lp->flags)) {
-		if (lp->lksb.sb_status != -DLM_EUNLOCK) {
-			log_info("unlock sb_status %d %x,%llx flags %lx",
-				 lp->lksb.sb_status, lp->lockname.ln_type,
-				 (unsigned long long)lp->lockname.ln_number,
-				 lp->flags);
-			return;
-		}
-
-		lp->cur = DLM_LOCK_IV;
-		lp->req = DLM_LOCK_IV;
-		lp->lksb.sb_lkid = 0;
-
-		if (test_and_clear_bit(LFL_UNLOCK_DELETE, &lp->flags)) {
-			gdlm_delete_lp(lp);
-			return;
-		}
-		goto out;
-	}
-
-	if (lp->lksb.sb_flags & DLM_SBF_VALNOTVALID)
-		memset(lp->lksb.sb_lvbptr, 0, GDLM_LVB_SIZE);
-
-	if (lp->lksb.sb_flags & DLM_SBF_ALTMODE) {
-		if (lp->req == DLM_LOCK_PR)
-			lp->req = DLM_LOCK_CW;
-		else if (lp->req == DLM_LOCK_CW)
-			lp->req = DLM_LOCK_PR;
-	}
-
-	/*
-	 * A canceled lock request.  The lock was just taken off the delayed
-	 * list and was never even submitted to dlm.
-	 */
-
-	if (test_and_clear_bit(LFL_CANCEL, &lp->flags)) {
-		log_info("complete internal cancel %x,%llx",
-		 	 lp->lockname.ln_type,
-			 (unsigned long long)lp->lockname.ln_number);
-		lp->req = lp->cur;
-		acb.lc_ret |= LM_OUT_CANCELED;
-		goto out;
-	}
-
-	/*
-	 * An error occured.
-	 */
-
-	if (lp->lksb.sb_status) {
-		/* a "normal" error */
-		if ((lp->lksb.sb_status == -EAGAIN) &&
-		    (lp->lkf & DLM_LKF_NOQUEUE)) {
-			lp->req = lp->cur;
-			if (lp->cur == DLM_LOCK_IV)
-				lp->lksb.sb_lkid = 0;
-			goto out;
-		}
-
-		/* this could only happen with cancels I think */
-		log_info("ast sb_status %d %x,%llx flags %lx",
-			 lp->lksb.sb_status, lp->lockname.ln_type,
-			 (unsigned long long)lp->lockname.ln_number,
-			 lp->flags);
-		return;
-	}
-
-	/*
-	 * This is an AST for an EX->EX conversion for sync_lvb from GFS.
-	 */
-
-	if (test_and_clear_bit(LFL_SYNC_LVB, &lp->flags)) {
-		wake_up_ast(lp);
-		return;
-	}
-
-	/*
-	 * A lock has been demoted to NL because it initially completed during
-	 * BLOCK_LOCKS.  Now it must be requested in the originally requested
-	 * mode.
-	 */
-
-	if (test_and_clear_bit(LFL_REREQUEST, &lp->flags)) {
-		gdlm_assert(lp->req == DLM_LOCK_NL, "%x,%llx",
-			    lp->lockname.ln_type,
-			    (unsigned long long)lp->lockname.ln_number);
-		gdlm_assert(lp->prev_req > DLM_LOCK_NL, "%x,%llx",
-			    lp->lockname.ln_type,
-			    (unsigned long long)lp->lockname.ln_number);
-
-		lp->cur = DLM_LOCK_NL;
-		lp->req = lp->prev_req;
-		lp->prev_req = DLM_LOCK_IV;
-		lp->lkf &= ~DLM_LKF_CONVDEADLK;
-
-		set_bit(LFL_NOCACHE, &lp->flags);
-
-		if (test_bit(DFL_BLOCK_LOCKS, &ls->flags) &&
-		    !test_bit(LFL_NOBLOCK, &lp->flags))
-			gdlm_queue_delayed(lp);
-		else
-			queue_submit(lp);
-		return;
-	}
-
-	/*
-	 * A request is granted during dlm recovery.  It may be granted
-	 * because the locks of a failed node were cleared.  In that case,
-	 * there may be inconsistent data beneath this lock and we must wait
-	 * for recovery to complete to use it.  When gfs recovery is done this
-	 * granted lock will be converted to NL and then reacquired in this
-	 * granted state.
-	 */
-
-	if (test_bit(DFL_BLOCK_LOCKS, &ls->flags) &&
-	    !test_bit(LFL_NOBLOCK, &lp->flags) &&
-	    lp->req != DLM_LOCK_NL) {
-
-		lp->cur = lp->req;
-		lp->prev_req = lp->req;
-		lp->req = DLM_LOCK_NL;
-		lp->lkf |= DLM_LKF_CONVERT;
-		lp->lkf &= ~DLM_LKF_CONVDEADLK;
-
-		log_debug("rereq %x,%llx id %x %d,%d",
-			  lp->lockname.ln_type,
-			  (unsigned long long)lp->lockname.ln_number,
-			  lp->lksb.sb_lkid, lp->cur, lp->req);
-
-		set_bit(LFL_REREQUEST, &lp->flags);
-		queue_submit(lp);
-		return;
-	}
-
-	/*
-	 * DLM demoted the lock to NL before it was granted so GFS must be
-	 * told it cannot cache data for this lock.
-	 */
-
-	if (lp->lksb.sb_flags & DLM_SBF_DEMOTED)
-		set_bit(LFL_NOCACHE, &lp->flags);
-
-out:
-	/*
-	 * This is an internal lock_dlm lock
-	 */
-
-	if (test_bit(LFL_INLOCK, &lp->flags)) {
-		clear_bit(LFL_NOBLOCK, &lp->flags);
-		lp->cur = lp->req;
-		wake_up_ast(lp);
-		return;
-	}
-
-	/*
-	 * Normal completion of a lock request.  Tell GFS it now has the lock.
-	 */
-
-	clear_bit(LFL_NOBLOCK, &lp->flags);
-	lp->cur = lp->req;
-
-	acb.lc_name = lp->lockname;
-	acb.lc_ret |= gdlm_make_lmstate(lp->cur);
-
-	ls->fscb(ls->sdp, LM_CB_ASYNC, &acb);
-}
-
-static void gdlm_ast(void *astarg)
-{
-	struct gdlm_lock *lp = astarg;
-	clear_bit(LFL_ACTIVE, &lp->flags);
-	process_complete(lp);
-}
-
-static void process_blocking(struct gdlm_lock *lp, int bast_mode)
-{
-	struct gdlm_ls *ls = lp->ls;
-	unsigned int cb = 0;
-
-	switch (gdlm_make_lmstate(bast_mode)) {
-	case LM_ST_EXCLUSIVE:
-		cb = LM_CB_NEED_E;
-		break;
-	case LM_ST_DEFERRED:
-		cb = LM_CB_NEED_D;
-		break;
-	case LM_ST_SHARED:
-		cb = LM_CB_NEED_S;
-		break;
-	default:
-		gdlm_assert(0, "unknown bast mode %u", bast_mode);
-	}
-
-	ls->fscb(ls->sdp, cb, &lp->lockname);
-}
-
-
-static void gdlm_bast(void *astarg, int mode)
-{
-	struct gdlm_lock *lp = astarg;
-
-	if (!mode) {
-		printk(KERN_INFO "lock_dlm: bast mode zero %x,%llx\n",
-			lp->lockname.ln_type,
-			(unsigned long long)lp->lockname.ln_number);
-		return;
-	}
-
-	process_blocking(lp, mode);
-}
-
-/* convert gfs lock-state to dlm lock-mode */
-
-static s16 make_mode(s16 lmstate)
-{
-	switch (lmstate) {
-	case LM_ST_UNLOCKED:
-		return DLM_LOCK_NL;
-	case LM_ST_EXCLUSIVE:
-		return DLM_LOCK_EX;
-	case LM_ST_DEFERRED:
-		return DLM_LOCK_CW;
-	case LM_ST_SHARED:
-		return DLM_LOCK_PR;
-	}
-	gdlm_assert(0, "unknown LM state %d", lmstate);
-	return -1;
-}
-
-
-/* verify agreement with GFS on the current lock state, NB: DLM_LOCK_NL and
-   DLM_LOCK_IV are both considered LM_ST_UNLOCKED by GFS. */
-
-static void check_cur_state(struct gdlm_lock *lp, unsigned int cur_state)
-{
-	s16 cur = make_mode(cur_state);
-	if (lp->cur != DLM_LOCK_IV)
-		gdlm_assert(lp->cur == cur, "%d, %d", lp->cur, cur);
-}
-
-static inline unsigned int make_flags(struct gdlm_lock *lp,
-				      unsigned int gfs_flags,
-				      s16 cur, s16 req)
-{
-	unsigned int lkf = 0;
-
-	if (gfs_flags & LM_FLAG_TRY)
-		lkf |= DLM_LKF_NOQUEUE;
-
-	if (gfs_flags & LM_FLAG_TRY_1CB) {
-		lkf |= DLM_LKF_NOQUEUE;
-		lkf |= DLM_LKF_NOQUEUEBAST;
-	}
-
-	if (gfs_flags & LM_FLAG_PRIORITY) {
-		lkf |= DLM_LKF_NOORDER;
-		lkf |= DLM_LKF_HEADQUE;
-	}
-
-	if (gfs_flags & LM_FLAG_ANY) {
-		if (req == DLM_LOCK_PR)
-			lkf |= DLM_LKF_ALTCW;
-		else if (req == DLM_LOCK_CW)
-			lkf |= DLM_LKF_ALTPR;
-	}
-
-	if (lp->lksb.sb_lkid != 0) {
-		lkf |= DLM_LKF_CONVERT;
-	}
-
-	if (lp->lvb)
-		lkf |= DLM_LKF_VALBLK;
-
-	return lkf;
-}
-
-/* make_strname - convert GFS lock numbers to a string */
-
-static inline void make_strname(const struct lm_lockname *lockname,
-				struct gdlm_strname *str)
-{
-	sprintf(str->name, "%8x%16llx", lockname->ln_type,
-		(unsigned long long)lockname->ln_number);
-	str->namelen = GDLM_STRNAME_BYTES;
-}
-
-static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
-			  struct gdlm_lock **lpp)
-{
-	struct gdlm_lock *lp;
-
-	lp = kzalloc(sizeof(struct gdlm_lock), GFP_NOFS);
-	if (!lp)
-		return -ENOMEM;
-
-	lp->lockname = *name;
-	make_strname(name, &lp->strname);
-	lp->ls = ls;
-	lp->cur = DLM_LOCK_IV;
-	INIT_LIST_HEAD(&lp->delay_list);
-
-	spin_lock(&ls->async_lock);
-	ls->all_locks_count++;
-	spin_unlock(&ls->async_lock);
-
-	*lpp = lp;
-	return 0;
-}
-
-int gdlm_get_lock(void *lockspace, struct lm_lockname *name,
-		  void **lockp)
-{
-	struct gdlm_lock *lp;
-	int error;
-
-	error = gdlm_create_lp(lockspace, name, &lp);
-
-	*lockp = lp;
-	return error;
-}
-
-void gdlm_put_lock(void *lock)
-{
-	gdlm_delete_lp(lock);
-}
-
-unsigned int gdlm_do_lock(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-	int error, bast = 1;
-
-	/*
-	 * When recovery is in progress, delay lock requests for submission
-	 * once recovery is done.  Requests for recovery (NOEXP) and unlocks
-	 * can pass.
-	 */
-
-	if (test_bit(DFL_BLOCK_LOCKS, &ls->flags) &&
-	    !test_bit(LFL_NOBLOCK, &lp->flags) && lp->req != DLM_LOCK_NL) {
-		gdlm_queue_delayed(lp);
-		return LM_OUT_ASYNC;
-	}
-
-	/*
-	 * Submit the actual lock request.
-	 */
-
-	if (test_bit(LFL_NOBAST, &lp->flags))
-		bast = 0;
-
-	set_bit(LFL_ACTIVE, &lp->flags);
-
-	log_debug("lk %x,%llx id %x %d,%d %x", lp->lockname.ln_type,
-		  (unsigned long long)lp->lockname.ln_number, lp->lksb.sb_lkid,
-		  lp->cur, lp->req, lp->lkf);
-
-	error = dlm_lock(ls->dlm_lockspace, lp->req, &lp->lksb, lp->lkf,
-			 lp->strname.name, lp->strname.namelen, 0, gdlm_ast,
-			 lp, bast ? gdlm_bast : NULL);
-
-	if ((error == -EAGAIN) && (lp->lkf & DLM_LKF_NOQUEUE)) {
-		lp->lksb.sb_status = -EAGAIN;
-		gdlm_ast(lp);
-		error = 0;
-	}
-
-	if (error) {
-		log_error("%s: gdlm_lock %x,%llx err=%d cur=%d req=%d lkf=%x "
-			  "flags=%lx", ls->fsname, lp->lockname.ln_type,
-			  (unsigned long long)lp->lockname.ln_number, error,
-			  lp->cur, lp->req, lp->lkf, lp->flags);
-		return LM_OUT_ERROR;
-	}
-	return LM_OUT_ASYNC;
-}
-
-static unsigned int gdlm_do_unlock(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-	unsigned int lkf = 0;
-	int error;
-
-	set_bit(LFL_DLM_UNLOCK, &lp->flags);
-	set_bit(LFL_ACTIVE, &lp->flags);
-
-	if (lp->lvb)
-		lkf = DLM_LKF_VALBLK;
-
-	log_debug("un %x,%llx %x %d %x", lp->lockname.ln_type,
-		  (unsigned long long)lp->lockname.ln_number,
-		  lp->lksb.sb_lkid, lp->cur, lkf);
-
-	error = dlm_unlock(ls->dlm_lockspace, lp->lksb.sb_lkid, lkf, NULL, lp);
-
-	if (error) {
-		log_error("%s: gdlm_unlock %x,%llx err=%d cur=%d req=%d lkf=%x "
-			  "flags=%lx", ls->fsname, lp->lockname.ln_type,
-			  (unsigned long long)lp->lockname.ln_number, error,
-			  lp->cur, lp->req, lp->lkf, lp->flags);
-		return LM_OUT_ERROR;
-	}
-	return LM_OUT_ASYNC;
-}
-
-unsigned int gdlm_lock(void *lock, unsigned int cur_state,
-		       unsigned int req_state, unsigned int flags)
-{
-	struct gdlm_lock *lp = lock;
-
-	if (req_state == LM_ST_UNLOCKED)
-		return gdlm_unlock(lock, cur_state);
-
-	if (req_state == LM_ST_UNLOCKED)
-		return gdlm_unlock(lock, cur_state);
-
-	clear_bit(LFL_DLM_CANCEL, &lp->flags);
-	if (flags & LM_FLAG_NOEXP)
-		set_bit(LFL_NOBLOCK, &lp->flags);
-
-	check_cur_state(lp, cur_state);
-	lp->req = make_mode(req_state);
-	lp->lkf = make_flags(lp, flags, lp->cur, lp->req);
-
-	return gdlm_do_lock(lp);
-}
-
-unsigned int gdlm_unlock(void *lock, unsigned int cur_state)
-{
-	struct gdlm_lock *lp = lock;
-
-	clear_bit(LFL_DLM_CANCEL, &lp->flags);
-	if (lp->cur == DLM_LOCK_IV)
-		return 0;
-	return gdlm_do_unlock(lp);
-}
-
-void gdlm_cancel(void *lock)
-{
-	struct gdlm_lock *lp = lock;
-	struct gdlm_ls *ls = lp->ls;
-	int error, delay_list = 0;
-
-	if (test_bit(LFL_DLM_CANCEL, &lp->flags))
-		return;
-
-	log_info("gdlm_cancel %x,%llx flags %lx", lp->lockname.ln_type,
-		 (unsigned long long)lp->lockname.ln_number, lp->flags);
-
-	spin_lock(&ls->async_lock);
-	if (!list_empty(&lp->delay_list)) {
-		list_del_init(&lp->delay_list);
-		delay_list = 1;
-	}
-	spin_unlock(&ls->async_lock);
-
-	if (delay_list) {
-		set_bit(LFL_CANCEL, &lp->flags);
-		set_bit(LFL_ACTIVE, &lp->flags);
-		gdlm_ast(lp);
-		return;
-	}
-
-	if (!test_bit(LFL_ACTIVE, &lp->flags) ||
-	    test_bit(LFL_DLM_UNLOCK, &lp->flags)) {
-		log_info("gdlm_cancel skip %x,%llx flags %lx",
-		 	 lp->lockname.ln_type,
-			 (unsigned long long)lp->lockname.ln_number, lp->flags);
-		return;
-	}
-
-	/* the lock is blocked in the dlm */
-
-	set_bit(LFL_DLM_CANCEL, &lp->flags);
-	set_bit(LFL_ACTIVE, &lp->flags);
-
-	error = dlm_unlock(ls->dlm_lockspace, lp->lksb.sb_lkid, DLM_LKF_CANCEL,
-			   NULL, lp);
-
-	log_info("gdlm_cancel rv %d %x,%llx flags %lx", error,
-		 lp->lockname.ln_type,
-		 (unsigned long long)lp->lockname.ln_number, lp->flags);
-
-	if (error == -EBUSY)
-		clear_bit(LFL_DLM_CANCEL, &lp->flags);
-}
-
-static int gdlm_add_lvb(struct gdlm_lock *lp)
-{
-	char *lvb;
-
-	lvb = kzalloc(GDLM_LVB_SIZE, GFP_NOFS);
-	if (!lvb)
-		return -ENOMEM;
-
-	lp->lksb.sb_lvbptr = lvb;
-	lp->lvb = lvb;
-	return 0;
-}
-
-static void gdlm_del_lvb(struct gdlm_lock *lp)
-{
-	kfree(lp->lvb);
-	lp->lvb = NULL;
-	lp->lksb.sb_lvbptr = NULL;
-}
-
-static int gdlm_ast_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
-/* This can do a synchronous dlm request (requiring a lock_dlm thread to get
-   the completion) because gfs won't call hold_lvb() during a callback (from
-   the context of a lock_dlm thread). */
-
-static int hold_null_lock(struct gdlm_lock *lp)
-{
-	struct gdlm_lock *lpn = NULL;
-	int error;
-
-	if (lp->hold_null) {
-		printk(KERN_INFO "lock_dlm: lvb already held\n");
-		return 0;
-	}
-
-	error = gdlm_create_lp(lp->ls, &lp->lockname, &lpn);
-	if (error)
-		goto out;
-
-	lpn->lksb.sb_lvbptr = junk_lvb;
-	lpn->lvb = junk_lvb;
-
-	lpn->req = DLM_LOCK_NL;
-	lpn->lkf = DLM_LKF_VALBLK | DLM_LKF_EXPEDITE;
-	set_bit(LFL_NOBAST, &lpn->flags);
-	set_bit(LFL_INLOCK, &lpn->flags);
-	set_bit(LFL_AST_WAIT, &lpn->flags);
-
-	gdlm_do_lock(lpn);
-	wait_on_bit(&lpn->flags, LFL_AST_WAIT, gdlm_ast_wait, TASK_UNINTERRUPTIBLE);
-	error = lpn->lksb.sb_status;
-	if (error) {
-		printk(KERN_INFO "lock_dlm: hold_null_lock dlm error %d\n",
-		       error);
-		gdlm_delete_lp(lpn);
-		lpn = NULL;
-	}
-out:
-	lp->hold_null = lpn;
-	return error;
-}
-
-/* This cannot do a synchronous dlm request (requiring a lock_dlm thread to get
-   the completion) because gfs may call unhold_lvb() during a callback (from
-   the context of a lock_dlm thread) which could cause a deadlock since the
-   other lock_dlm thread could be engaged in recovery. */
-
-static void unhold_null_lock(struct gdlm_lock *lp)
-{
-	struct gdlm_lock *lpn = lp->hold_null;
-
-	gdlm_assert(lpn, "%x,%llx", lp->lockname.ln_type,
-		    (unsigned long long)lp->lockname.ln_number);
-	lpn->lksb.sb_lvbptr = NULL;
-	lpn->lvb = NULL;
-	set_bit(LFL_UNLOCK_DELETE, &lpn->flags);
-	gdlm_do_unlock(lpn);
-	lp->hold_null = NULL;
-}
-
-/* Acquire a NL lock because gfs requires the value block to remain
-   intact on the resource while the lvb is "held" even if it's holding no locks
-   on the resource. */
-
-int gdlm_hold_lvb(void *lock, char **lvbp)
-{
-	struct gdlm_lock *lp = lock;
-	int error;
-
-	error = gdlm_add_lvb(lp);
-	if (error)
-		return error;
-
-	*lvbp = lp->lvb;
-
-	error = hold_null_lock(lp);
-	if (error)
-		gdlm_del_lvb(lp);
-
-	return error;
-}
-
-void gdlm_unhold_lvb(void *lock, char *lvb)
-{
-	struct gdlm_lock *lp = lock;
-
-	unhold_null_lock(lp);
-	gdlm_del_lvb(lp);
-}
-
-void gdlm_submit_delayed(struct gdlm_ls *ls)
-{
-	struct gdlm_lock *lp, *safe;
-
-	spin_lock(&ls->async_lock);
-	list_for_each_entry_safe(lp, safe, &ls->delayed, delay_list) {
-		list_del_init(&lp->delay_list);
-		list_add_tail(&lp->delay_list, &ls->submit);
-	}
-	spin_unlock(&ls->async_lock);
-	wake_up(&ls->thread_wait);
-}
-
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
deleted file mode 100644
index 3c98e7c..0000000
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef LOCK_DLM_DOT_H
-#define LOCK_DLM_DOT_H
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/list.h>
-#include <linux/socket.h>
-#include <linux/delay.h>
-#include <linux/kthread.h>
-#include <linux/kobject.h>
-#include <linux/fcntl.h>
-#include <linux/wait.h>
-#include <net/sock.h>
-
-#include <linux/dlm.h>
-#include <linux/dlm_plock.h>
-#include <linux/lm_interface.h>
-
-/*
- * Internally, we prefix things with gdlm_ and GDLM_ (for gfs-dlm) since a
- * prefix of lock_dlm_ gets awkward.  Externally, GFS refers to this module
- * as "lock_dlm".
- */
-
-#define GDLM_STRNAME_BYTES	24
-#define GDLM_LVB_SIZE		32
-#define GDLM_DROP_COUNT		0
-#define GDLM_DROP_PERIOD	60
-#define GDLM_NAME_LEN		128
-
-/* GFS uses 12 bytes to identify a resource (32 bit type + 64 bit number).
-   We sprintf these numbers into a 24 byte string of hex values to make them
-   human-readable (to make debugging simpler.) */
-
-struct gdlm_strname {
-	unsigned char		name[GDLM_STRNAME_BYTES];
-	unsigned short		namelen;
-};
-
-enum {
-	DFL_BLOCK_LOCKS		= 0,
-	DFL_SPECTATOR		= 1,
-	DFL_WITHDRAW		= 2,
-};
-
-struct gdlm_ls {
-	u32		id;
-	int			jid;
-	int			first;
-	int			first_done;
-	unsigned long		flags;
-	struct kobject		kobj;
-	char			clustername[GDLM_NAME_LEN];
-	char			fsname[GDLM_NAME_LEN];
-	int			fsflags;
-	dlm_lockspace_t		*dlm_lockspace;
-	lm_callback_t		fscb;
-	struct gfs2_sbd		*sdp;
-	int			recover_jid;
-	int			recover_jid_done;
-	int			recover_jid_status;
-	spinlock_t		async_lock;
-	struct list_head	delayed;
-	struct list_head	submit;
-	u32		all_locks_count;
-	wait_queue_head_t	wait_control;
-	struct task_struct	*thread;
-	wait_queue_head_t	thread_wait;
-};
-
-enum {
-	LFL_NOBLOCK		= 0,
-	LFL_NOCACHE		= 1,
-	LFL_DLM_UNLOCK		= 2,
-	LFL_DLM_CANCEL		= 3,
-	LFL_SYNC_LVB		= 4,
-	LFL_FORCE_PROMOTE	= 5,
-	LFL_REREQUEST		= 6,
-	LFL_ACTIVE		= 7,
-	LFL_INLOCK		= 8,
-	LFL_CANCEL		= 9,
-	LFL_NOBAST		= 10,
-	LFL_HEADQUE		= 11,
-	LFL_UNLOCK_DELETE	= 12,
-	LFL_AST_WAIT		= 13,
-};
-
-struct gdlm_lock {
-	struct gdlm_ls		*ls;
-	struct lm_lockname	lockname;
-	struct gdlm_strname	strname;
-	char			*lvb;
-	struct dlm_lksb		lksb;
-
-	s16			cur;
-	s16			req;
-	s16			prev_req;
-	u32			lkf;		/* dlm flags DLM_LKF_ */
-	unsigned long		flags;		/* lock_dlm flags LFL_ */
-
-	struct list_head	delay_list;	/* delayed */
-	struct gdlm_lock	*hold_null;	/* NL lock for hold_lvb */
-};
-
-#define gdlm_assert(assertion, fmt, args...)                                  \
-do {                                                                          \
-	if (unlikely(!(assertion))) {                                         \
-		printk(KERN_EMERG "lock_dlm: fatal assertion failed \"%s\"\n" \
-				  "lock_dlm:  " fmt "\n",                     \
-				  #assertion, ##args);                        \
-		BUG();                                                        \
-	}                                                                     \
-} while (0)
-
-#define log_print(lev, fmt, arg...) printk(lev "lock_dlm: " fmt "\n" , ## arg)
-#define log_info(fmt, arg...)  log_print(KERN_INFO , fmt , ## arg)
-#define log_error(fmt, arg...) log_print(KERN_ERR , fmt , ## arg)
-#ifdef LOCK_DLM_LOG_DEBUG
-#define log_debug(fmt, arg...) log_print(KERN_DEBUG , fmt , ## arg)
-#else
-#define log_debug(fmt, arg...)
-#endif
-
-/* sysfs.c */
-
-int gdlm_sysfs_init(void);
-void gdlm_sysfs_exit(void);
-int gdlm_kobject_setup(struct gdlm_ls *, struct kobject *);
-void gdlm_kobject_release(struct gdlm_ls *);
-
-/* thread.c */
-
-int gdlm_init_threads(struct gdlm_ls *);
-void gdlm_release_threads(struct gdlm_ls *);
-
-/* lock.c */
-
-void gdlm_submit_delayed(struct gdlm_ls *);
-unsigned int gdlm_do_lock(struct gdlm_lock *);
-
-int gdlm_get_lock(void *, struct lm_lockname *, void **);
-void gdlm_put_lock(void *);
-unsigned int gdlm_lock(void *, unsigned int, unsigned int, unsigned int);
-unsigned int gdlm_unlock(void *, unsigned int);
-void gdlm_cancel(void *);
-int gdlm_hold_lvb(void *, char **);
-void gdlm_unhold_lvb(void *, char *);
-
-/* mount.c */
-
-extern const struct lm_lockops gdlm_ops;
-
-#endif
-
diff --git a/fs/gfs2/locking/dlm/main.c b/fs/gfs2/locking/dlm/main.c
deleted file mode 100644
index b9a03a7..0000000
--- a/fs/gfs2/locking/dlm/main.c
+++ /dev/null
@@ -1,48 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/init.h>
-
-#include "lock_dlm.h"
-
-static int __init init_lock_dlm(void)
-{
-	int error;
-
-	error = gfs2_register_lockproto(&gdlm_ops);
-	if (error) {
-		printk(KERN_WARNING "lock_dlm:  can't register protocol: %d\n",
-		       error);
-		return error;
-	}
-
-	error = gdlm_sysfs_init();
-	if (error) {
-		gfs2_unregister_lockproto(&gdlm_ops);
-		return error;
-	}
-
-	printk(KERN_INFO
-	       "Lock_DLM (built %s %s) installed\n", __DATE__, __TIME__);
-	return 0;
-}
-
-static void __exit exit_lock_dlm(void)
-{
-	gdlm_sysfs_exit();
-	gfs2_unregister_lockproto(&gdlm_ops);
-}
-
-module_init(init_lock_dlm);
-module_exit(exit_lock_dlm);
-
-MODULE_DESCRIPTION("GFS DLM Locking Module");
-MODULE_AUTHOR("Red Hat, Inc.");
-MODULE_LICENSE("GPL");
-
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
deleted file mode 100644
index 1aa7eb6..0000000
--- a/fs/gfs2/locking/dlm/mount.c
+++ /dev/null
@@ -1,276 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include "lock_dlm.h"
-
-const struct lm_lockops gdlm_ops;
-
-
-static struct gdlm_ls *init_gdlm(lm_callback_t cb, struct gfs2_sbd *sdp,
-				 int flags, char *table_name)
-{
-	struct gdlm_ls *ls;
-	char buf[256], *p;
-
-	ls = kzalloc(sizeof(struct gdlm_ls), GFP_KERNEL);
-	if (!ls)
-		return NULL;
-
-	ls->fscb = cb;
-	ls->sdp = sdp;
-	ls->fsflags = flags;
-	spin_lock_init(&ls->async_lock);
-	INIT_LIST_HEAD(&ls->delayed);
-	INIT_LIST_HEAD(&ls->submit);
-	init_waitqueue_head(&ls->thread_wait);
-	init_waitqueue_head(&ls->wait_control);
-	ls->jid = -1;
-
-	strncpy(buf, table_name, 256);
-	buf[255] = '\0';
-
-	p = strchr(buf, ':');
-	if (!p) {
-		log_info("invalid table_name \"%s\"", table_name);
-		kfree(ls);
-		return NULL;
-	}
-	*p = '\0';
-	p++;
-
-	strncpy(ls->clustername, buf, GDLM_NAME_LEN);
-	strncpy(ls->fsname, p, GDLM_NAME_LEN);
-
-	return ls;
-}
-
-static int make_args(struct gdlm_ls *ls, char *data_arg, int *nodir)
-{
-	char data[256];
-	char *options, *x, *y;
-	int error = 0;
-
-	memset(data, 0, 256);
-	strncpy(data, data_arg, 255);
-
-	if (!strlen(data)) {
-		log_error("no mount options, (u)mount helpers not installed");
-		return -EINVAL;
-	}
-
-	for (options = data; (x = strsep(&options, ":")); ) {
-		if (!*x)
-			continue;
-
-		y = strchr(x, '=');
-		if (y)
-			*y++ = 0;
-
-		if (!strcmp(x, "jid")) {
-			if (!y) {
-				log_error("need argument to jid");
-				error = -EINVAL;
-				break;
-			}
-			sscanf(y, "%u", &ls->jid);
-
-		} else if (!strcmp(x, "first")) {
-			if (!y) {
-				log_error("need argument to first");
-				error = -EINVAL;
-				break;
-			}
-			sscanf(y, "%u", &ls->first);
-
-		} else if (!strcmp(x, "id")) {
-			if (!y) {
-				log_error("need argument to id");
-				error = -EINVAL;
-				break;
-			}
-			sscanf(y, "%u", &ls->id);
-
-		} else if (!strcmp(x, "nodir")) {
-			if (!y) {
-				log_error("need argument to nodir");
-				error = -EINVAL;
-				break;
-			}
-			sscanf(y, "%u", nodir);
-
-		} else {
-			log_error("unkonwn option: %s", x);
-			error = -EINVAL;
-			break;
-		}
-	}
-
-	return error;
-}
-
-static int gdlm_mount(char *table_name, char *host_data,
-			lm_callback_t cb, void *cb_data,
-			unsigned int min_lvb_size, int flags,
-			struct lm_lockstruct *lockstruct,
-			struct kobject *fskobj)
-{
-	struct gdlm_ls *ls;
-	int error = -ENOMEM, nodir = 0;
-
-	if (min_lvb_size > GDLM_LVB_SIZE)
-		goto out;
-
-	ls = init_gdlm(cb, cb_data, flags, table_name);
-	if (!ls)
-		goto out;
-
-	error = make_args(ls, host_data, &nodir);
-	if (error)
-		goto out;
-
-	error = gdlm_init_threads(ls);
-	if (error)
-		goto out_free;
-
-	error = gdlm_kobject_setup(ls, fskobj);
-	if (error)
-		goto out_thread;
-
-	error = dlm_new_lockspace(ls->fsname, strlen(ls->fsname),
-				  &ls->dlm_lockspace,
-				  DLM_LSFL_FS | DLM_LSFL_NEWEXCL |
-				  (nodir ? DLM_LSFL_NODIR : 0),
-				  GDLM_LVB_SIZE);
-	if (error) {
-		log_error("dlm_new_lockspace error %d", error);
-		goto out_kobj;
-	}
-
-	lockstruct->ls_jid = ls->jid;
-	lockstruct->ls_first = ls->first;
-	lockstruct->ls_lockspace = ls;
-	lockstruct->ls_ops = &gdlm_ops;
-	lockstruct->ls_flags = 0;
-	lockstruct->ls_lvb_size = GDLM_LVB_SIZE;
-	return 0;
-
-out_kobj:
-	gdlm_kobject_release(ls);
-out_thread:
-	gdlm_release_threads(ls);
-out_free:
-	kfree(ls);
-out:
-	return error;
-}
-
-static void gdlm_unmount(void *lockspace)
-{
-	struct gdlm_ls *ls = lockspace;
-
-	log_debug("unmount flags %lx", ls->flags);
-
-	/* FIXME: serialize unmount and withdraw in case they
-	   happen at once.  Also, if unmount follows withdraw,
-	   wait for withdraw to finish. */
-
-	if (test_bit(DFL_WITHDRAW, &ls->flags))
-		goto out;
-
-	gdlm_kobject_release(ls);
-	dlm_release_lockspace(ls->dlm_lockspace, 2);
-	gdlm_release_threads(ls);
-	BUG_ON(ls->all_locks_count);
-out:
-	kfree(ls);
-}
-
-static void gdlm_recovery_done(void *lockspace, unsigned int jid,
-                               unsigned int message)
-{
-	char env_jid[20];
-	char env_status[20];
-	char *envp[] = { env_jid, env_status, NULL };
-	struct gdlm_ls *ls = lockspace;
-	ls->recover_jid_done = jid;
-	ls->recover_jid_status = message;
-	sprintf(env_jid, "JID=%d", jid);
-	sprintf(env_status, "RECOVERY=%s",
-		message == LM_RD_SUCCESS ? "Done" : "Failed");
-	kobject_uevent_env(&ls->kobj, KOBJ_CHANGE, envp);
-}
-
-static void gdlm_others_may_mount(void *lockspace)
-{
-	char *message = "FIRSTMOUNT=Done";
-	char *envp[] = { message, NULL };
-	struct gdlm_ls *ls = lockspace;
-	ls->first_done = 1;
-	kobject_uevent_env(&ls->kobj, KOBJ_CHANGE, envp);
-}
-
-/* Userspace gets the offline uevent, blocks new gfs locks on
-   other mounters, and lets us know (sets WITHDRAW flag).  Then,
-   userspace leaves the mount group while we leave the lockspace. */
-
-static void gdlm_withdraw(void *lockspace)
-{
-	struct gdlm_ls *ls = lockspace;
-
-	kobject_uevent(&ls->kobj, KOBJ_OFFLINE);
-
-	wait_event_interruptible(ls->wait_control,
-				 test_bit(DFL_WITHDRAW, &ls->flags));
-
-	dlm_release_lockspace(ls->dlm_lockspace, 2);
-	gdlm_release_threads(ls);
-	gdlm_kobject_release(ls);
-}
-
-static int gdlm_plock(void *lockspace, struct lm_lockname *name,
-	       struct file *file, int cmd, struct file_lock *fl)
-{
-	struct gdlm_ls *ls = lockspace;
-	return dlm_posix_lock(ls->dlm_lockspace, name->ln_number, file, cmd, fl);
-}
-
-static int gdlm_punlock(void *lockspace, struct lm_lockname *name,
-		 struct file *file, struct file_lock *fl)
-{
-	struct gdlm_ls *ls = lockspace;
-	return dlm_posix_unlock(ls->dlm_lockspace, name->ln_number, file, fl);
-}
-
-static int gdlm_plock_get(void *lockspace, struct lm_lockname *name,
-		   struct file *file, struct file_lock *fl)
-{
-	struct gdlm_ls *ls = lockspace;
-	return dlm_posix_get(ls->dlm_lockspace, name->ln_number, file, fl);
-}
-
-const struct lm_lockops gdlm_ops = {
-	.lm_proto_name = "lock_dlm",
-	.lm_mount = gdlm_mount,
-	.lm_others_may_mount = gdlm_others_may_mount,
-	.lm_unmount = gdlm_unmount,
-	.lm_withdraw = gdlm_withdraw,
-	.lm_get_lock = gdlm_get_lock,
-	.lm_put_lock = gdlm_put_lock,
-	.lm_lock = gdlm_lock,
-	.lm_unlock = gdlm_unlock,
-	.lm_plock = gdlm_plock,
-	.lm_punlock = gdlm_punlock,
-	.lm_plock_get = gdlm_plock_get,
-	.lm_cancel = gdlm_cancel,
-	.lm_hold_lvb = gdlm_hold_lvb,
-	.lm_unhold_lvb = gdlm_unhold_lvb,
-	.lm_recovery_done = gdlm_recovery_done,
-	.lm_owner = THIS_MODULE,
-};
-
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
deleted file mode 100644
index 9b7edcf..0000000
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ /dev/null
@@ -1,226 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/ctype.h>
-#include <linux/stat.h>
-
-#include "lock_dlm.h"
-
-static ssize_t proto_name_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%s\n", gdlm_ops.lm_proto_name);
-}
-
-static ssize_t block_show(struct gdlm_ls *ls, char *buf)
-{
-	ssize_t ret;
-	int val = 0;
-
-	if (test_bit(DFL_BLOCK_LOCKS, &ls->flags))
-		val = 1;
-	ret = sprintf(buf, "%d\n", val);
-	return ret;
-}
-
-static ssize_t block_store(struct gdlm_ls *ls, const char *buf, size_t len)
-{
-	ssize_t ret = len;
-	int val;
-
-	val = simple_strtol(buf, NULL, 0);
-
-	if (val == 1)
-		set_bit(DFL_BLOCK_LOCKS, &ls->flags);
-	else if (val == 0) {
-		clear_bit(DFL_BLOCK_LOCKS, &ls->flags);
-		gdlm_submit_delayed(ls);
-	} else {
-		ret = -EINVAL;
-	}
-	return ret;
-}
-
-static ssize_t withdraw_show(struct gdlm_ls *ls, char *buf)
-{
-	ssize_t ret;
-	int val = 0;
-
-	if (test_bit(DFL_WITHDRAW, &ls->flags))
-		val = 1;
-	ret = sprintf(buf, "%d\n", val);
-	return ret;
-}
-
-static ssize_t withdraw_store(struct gdlm_ls *ls, const char *buf, size_t len)
-{
-	ssize_t ret = len;
-	int val;
-
-	val = simple_strtol(buf, NULL, 0);
-
-	if (val == 1)
-		set_bit(DFL_WITHDRAW, &ls->flags);
-	else
-		ret = -EINVAL;
-	wake_up(&ls->wait_control);
-	return ret;
-}
-
-static ssize_t id_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%u\n", ls->id);
-}
-
-static ssize_t jid_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->jid);
-}
-
-static ssize_t first_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->first);
-}
-
-static ssize_t first_done_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->first_done);
-}
-
-static ssize_t recover_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->recover_jid);
-}
-
-static ssize_t recover_store(struct gdlm_ls *ls, const char *buf, size_t len)
-{
-	ls->recover_jid = simple_strtol(buf, NULL, 0);
-	ls->fscb(ls->sdp, LM_CB_NEED_RECOVERY, &ls->recover_jid);
-	return len;
-}
-
-static ssize_t recover_done_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->recover_jid_done);
-}
-
-static ssize_t recover_status_show(struct gdlm_ls *ls, char *buf)
-{
-	return sprintf(buf, "%d\n", ls->recover_jid_status);
-}
-
-struct gdlm_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gdlm_ls *, char *);
-	ssize_t (*store)(struct gdlm_ls *, const char *, size_t);
-};
-
-#define GDLM_ATTR(_name,_mode,_show,_store) \
-static struct gdlm_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
-
-GDLM_ATTR(proto_name,     0444, proto_name_show,     NULL);
-GDLM_ATTR(block,          0644, block_show,          block_store);
-GDLM_ATTR(withdraw,       0644, withdraw_show,       withdraw_store);
-GDLM_ATTR(id,             0444, id_show,             NULL);
-GDLM_ATTR(jid,            0444, jid_show,            NULL);
-GDLM_ATTR(first,          0444, first_show,          NULL);
-GDLM_ATTR(first_done,     0444, first_done_show,     NULL);
-GDLM_ATTR(recover,        0644, recover_show,        recover_store);
-GDLM_ATTR(recover_done,   0444, recover_done_show,   NULL);
-GDLM_ATTR(recover_status, 0444, recover_status_show, NULL);
-
-static struct attribute *gdlm_attrs[] = {
-	&gdlm_attr_proto_name.attr,
-	&gdlm_attr_block.attr,
-	&gdlm_attr_withdraw.attr,
-	&gdlm_attr_id.attr,
-	&gdlm_attr_jid.attr,
-	&gdlm_attr_first.attr,
-	&gdlm_attr_first_done.attr,
-	&gdlm_attr_recover.attr,
-	&gdlm_attr_recover_done.attr,
-	&gdlm_attr_recover_status.attr,
-	NULL,
-};
-
-static ssize_t gdlm_attr_show(struct kobject *kobj, struct attribute *attr,
-			      char *buf)
-{
-	struct gdlm_ls *ls = container_of(kobj, struct gdlm_ls, kobj);
-	struct gdlm_attr *a = container_of(attr, struct gdlm_attr, attr);
-	return a->show ? a->show(ls, buf) : 0;
-}
-
-static ssize_t gdlm_attr_store(struct kobject *kobj, struct attribute *attr,
-			       const char *buf, size_t len)
-{
-	struct gdlm_ls *ls = container_of(kobj, struct gdlm_ls, kobj);
-	struct gdlm_attr *a = container_of(attr, struct gdlm_attr, attr);
-	return a->store ? a->store(ls, buf, len) : len;
-}
-
-static struct sysfs_ops gdlm_attr_ops = {
-	.show  = gdlm_attr_show,
-	.store = gdlm_attr_store,
-};
-
-static struct kobj_type gdlm_ktype = {
-	.default_attrs = gdlm_attrs,
-	.sysfs_ops     = &gdlm_attr_ops,
-};
-
-static struct kset *gdlm_kset;
-
-int gdlm_kobject_setup(struct gdlm_ls *ls, struct kobject *fskobj)
-{
-	int error;
-
-	ls->kobj.kset = gdlm_kset;
-	error = kobject_init_and_add(&ls->kobj, &gdlm_ktype, fskobj,
-				     "lock_module");
-	if (error)
-		log_error("can't register kobj %d", error);
-	kobject_uevent(&ls->kobj, KOBJ_ADD);
-
-	return error;
-}
-
-void gdlm_kobject_release(struct gdlm_ls *ls)
-{
-	kobject_put(&ls->kobj);
-}
-
-static int gdlm_uevent(struct kset *kset, struct kobject *kobj,
-		       struct kobj_uevent_env *env)
-{
-        struct gdlm_ls *ls = container_of(kobj, struct gdlm_ls, kobj);
-        add_uevent_var(env, "LOCKTABLE=%s:%s", ls->clustername, ls->fsname);
-        add_uevent_var(env, "LOCKPROTO=lock_dlm");
-        return 0;
-}
-
-static struct kset_uevent_ops gdlm_uevent_ops = {
-	.uevent = gdlm_uevent,
-};
-
-
-int gdlm_sysfs_init(void)
-{
-	gdlm_kset = kset_create_and_add("lock_dlm", &gdlm_uevent_ops, kernel_kobj);
-	if (!gdlm_kset) {
-		printk(KERN_WARNING "%s: can not create kset\n", __func__);
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-void gdlm_sysfs_exit(void)
-{
-	kset_unregister(gdlm_kset);
-}
-
diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
deleted file mode 100644
index 38823ef..0000000
--- a/fs/gfs2/locking/dlm/thread.c
+++ /dev/null
@@ -1,68 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2005 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include "lock_dlm.h"
-
-static inline int no_work(struct gdlm_ls *ls)
-{
-	int ret;
-
-	spin_lock(&ls->async_lock);
-	ret = list_empty(&ls->submit);
-	spin_unlock(&ls->async_lock);
-
-	return ret;
-}
-
-static int gdlm_thread(void *data)
-{
-	struct gdlm_ls *ls = (struct gdlm_ls *) data;
-	struct gdlm_lock *lp = NULL;
-
-	while (!kthread_should_stop()) {
-		wait_event_interruptible(ls->thread_wait,
-				!no_work(ls) || kthread_should_stop());
-
-		spin_lock(&ls->async_lock);
-
-		if (!list_empty(&ls->submit)) {
-			lp = list_entry(ls->submit.next, struct gdlm_lock,
-					delay_list);
-			list_del_init(&lp->delay_list);
-			spin_unlock(&ls->async_lock);
-			gdlm_do_lock(lp);
-			spin_lock(&ls->async_lock);
-		}
-		spin_unlock(&ls->async_lock);
-	}
-
-	return 0;
-}
-
-int gdlm_init_threads(struct gdlm_ls *ls)
-{
-	struct task_struct *p;
-	int error;
-
-	p = kthread_run(gdlm_thread, ls, "lock_dlm");
-	error = IS_ERR(p);
-	if (error) {
-		log_error("can't start lock_dlm thread %d", error);
-		return error;
-	}
-	ls->thread = p;
-
-	return 0;
-}
-
-void gdlm_release_threads(struct gdlm_ls *ls)
-{
-	kthread_stop(ls->thread);
-}
-
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index ad30585..98918a7 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -14,7 +14,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 4390f6f..80e4f5f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -13,7 +13,6 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 86fe067..a6892ed 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <asm/atomic.h>
 
 #include "gfs2.h"
@@ -47,8 +46,6 @@ static void gfs2_init_glock_once(void *foo)
 	INIT_HLIST_NODE(&gl->gl_list);
 	spin_lock_init(&gl->gl_spin);
 	INIT_LIST_HEAD(&gl->gl_holders);
-	gl->gl_lvb = NULL;
-	atomic_set(&gl->gl_lvb_count, 0);
 	INIT_LIST_HEAD(&gl->gl_lru);
 	INIT_LIST_HEAD(&gl->gl_ail_list);
 	atomic_set(&gl->gl_ail_count, 0);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 0985362..870d65a 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -19,7 +19,6 @@
 #include <linux/delay.h>
 #include <linux/bio.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 3524ae8..fba502a 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -12,7 +12,6 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <linux/parser.h>
 
 #include "gfs2.h"
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index dde4ead..a6d00e8 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -19,7 +19,6 @@
 #include <linux/writeback.h>
 #include <linux/swap.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <linux/backing-dev.h>
 
 #include "gfs2.h"
diff --git a/fs/gfs2/ops_dentry.c b/fs/gfs2/ops_dentry.c
index c2ad363..5eb57b0 100644
--- a/fs/gfs2/ops_dentry.c
+++ b/fs/gfs2/ops_dentry.c
@@ -13,7 +13,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/ops_export.c b/fs/gfs2/ops_export.c
index 7fdeb14..9200ef2 100644
--- a/fs/gfs2/ops_export.c
+++ b/fs/gfs2/ops_export.c
@@ -14,7 +14,6 @@
 #include <linux/exportfs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 93fe41b..99d726f 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -20,9 +20,10 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/ext2_fs.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 #include <linux/writeback.h>
 #include <asm/uaccess.h>
+#include <linux/dlm.h>
+#include <linux/dlm_plock.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -560,57 +561,24 @@ static int gfs2_fsync(struct file *file, struct dentry *dentry, int datasync)
 	return ret;
 }
 
+#ifdef CONFIG_GFS2_FS_LOCKING_DLM
+
 /**
  * gfs2_setlease - acquire/release a file lease
  * @file: the file pointer
  * @arg: lease type
  * @fl: file lock
  *
+ * We don't currently have a way to enforce a lease across the whole
+ * cluster; until we do, disable leases (by just returning -EINVAL),
+ * unless the administrator has requested purely local locking.
+ *
  * Returns: errno
  */
 
 static int gfs2_setlease(struct file *file, long arg, struct file_lock **fl)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
-
-	/*
-	 * We don't currently have a way to enforce a lease across the whole
-	 * cluster; until we do, disable leases (by just returning -EINVAL),
-	 * unless the administrator has requested purely local locking.
-	 */
-	if (!sdp->sd_args.ar_localflocks)
-		return -EINVAL;
-	return generic_setlease(file, arg, fl);
-}
-
-static int gfs2_lm_plock_get(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		      struct file *file, struct file_lock *fl)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_plock_get(
-				sdp->sd_lockstruct.ls_lockspace, name, file, fl);
-	return error;
-}
-
-static int gfs2_lm_plock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		  struct file *file, int cmd, struct file_lock *fl)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_plock(
-				sdp->sd_lockstruct.ls_lockspace, name, file, cmd, fl);
-	return error;
-}
-
-static int gfs2_lm_punlock(struct gfs2_sbd *sdp, struct lm_lockname *name,
-		    struct file *file, struct file_lock *fl)
-{
-	int error = -EIO;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		error = sdp->sd_lockstruct.ls_ops->lm_punlock(
-				sdp->sd_lockstruct.ls_lockspace, name, file, fl);
-	return error;
+	return -EINVAL;
 }
 
 /**
@@ -626,9 +594,7 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 {
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
 	struct gfs2_sbd *sdp = GFS2_SB(file->f_mapping->host);
-	struct lm_lockname name =
-		{ .ln_number = ip->i_no_addr,
-		  .ln_type = LM_TYPE_PLOCK };
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
@@ -640,12 +606,14 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 		cmd = F_SETLK;
 		fl->fl_type = F_UNLCK;
 	}
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		return -EIO;
 	if (IS_GETLK(cmd))
-		return gfs2_lm_plock_get(sdp, &name, file, fl);
+		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else if (fl->fl_type == F_UNLCK)
-		return gfs2_lm_punlock(sdp, &name, file, fl);
+		return dlm_posix_unlock(ls->ls_dlm, ip->i_no_addr, file, fl);
 	else
-		return gfs2_lm_plock(sdp, &name, file, cmd, fl);
+		return dlm_posix_lock(ls->ls_dlm, ip->i_no_addr, file, cmd, fl);
 }
 
 static int do_flock(struct file *file, int cmd, struct file_lock *fl)
@@ -732,7 +700,7 @@ static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
 	}
 }
 
-const struct file_operations gfs2_file_fops = {
+const struct file_operations *gfs2_file_fops = &(const struct file_operations){
 	.llseek		= gfs2_llseek,
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
@@ -750,7 +718,7 @@ const struct file_operations gfs2_file_fops = {
 	.setlease	= gfs2_setlease,
 };
 
-const struct file_operations gfs2_dir_fops = {
+const struct file_operations *gfs2_dir_fops = &(const struct file_operations){
 	.readdir	= gfs2_readdir,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
@@ -760,7 +728,9 @@ const struct file_operations gfs2_dir_fops = {
 	.flock		= gfs2_flock,
 };
 
-const struct file_operations gfs2_file_fops_nolock = {
+#endif /* CONFIG_GFS2_FS_LOCKING_DLM */
+
+const struct file_operations *gfs2_file_fops_nolock = &(const struct file_operations){
 	.llseek		= gfs2_llseek,
 	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
@@ -773,10 +743,10 @@ const struct file_operations gfs2_file_fops_nolock = {
 	.fsync		= gfs2_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
-	.setlease	= gfs2_setlease,
+	.setlease	= generic_setlease,
 };
 
-const struct file_operations gfs2_dir_fops_nolock = {
+const struct file_operations *gfs2_dir_fops_nolock = &(const struct file_operations){
 	.readdir	= gfs2_readdir,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 402b6a2..95bb33e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -17,7 +17,6 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -627,13 +626,13 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
 	return rc;
 }
 
-static void gfs2_lm_others_may_mount(struct gfs2_sbd *sdp)
+static void gfs2_others_may_mount(struct gfs2_sbd *sdp)
 {
-	if (!sdp->sd_lockstruct.ls_ops->lm_others_may_mount)
-		return;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_others_may_mount(
-					sdp->sd_lockstruct.ls_lockspace);
+	char *message = "FIRSTMOUNT=Done";
+	char *envp[] = { message, NULL };
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	ls->ls_first_done = 1;
+	kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
 }
 
 /**
@@ -793,7 +792,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 			}
 		}
 
-		gfs2_lm_others_may_mount(sdp);
+		gfs2_others_may_mount(sdp);
 	} else if (!sdp->sd_args.ar_spectator) {
 		error = gfs2_recover_journal(sdp->sd_jdesc);
 		if (error) {
@@ -1002,7 +1001,6 @@ static int init_threads(struct gfs2_sbd *sdp, int undo)
 		goto fail_quotad;
 
 	sdp->sd_log_flush_time = jiffies;
-	sdp->sd_jindex_refresh_time = jiffies;
 
 	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
 	error = IS_ERR(p);
@@ -1030,6 +1028,17 @@ fail:
 	return error;
 }
 
+static const match_table_t nolock_tokens = {
+	{ Opt_jid, "jid=%d\n", },
+	{ Opt_err, NULL },
+};
+
+static const struct lm_lockops nolock_ops = {
+	.lm_proto_name = "lock_nolock",
+	.lm_put_lock = kmem_cache_free,
+	.lm_tokens = &nolock_tokens,
+};
+
 /**
  * gfs2_lm_mount - mount a locking protocol
  * @sdp: the filesystem
@@ -1041,31 +1050,73 @@ fail:
 
 static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 {
-	char *proto = sdp->sd_proto_name;
-	char *table = sdp->sd_table_name;
-	int flags = LM_MFLAG_CONV_NODROP;
-	int error;
+	const struct lm_lockops *lm;
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	struct gfs2_args *args = &sdp->sd_args;
+	const char *proto = sdp->sd_proto_name;
+	const char *table = sdp->sd_table_name;
+	const char *fsname;
+	char *o, *options;
+	int ret;
 
-	if (sdp->sd_args.ar_spectator)
-		flags |= LM_MFLAG_SPECTATOR;
+	if (!strcmp("lock_nolock", proto)) {
+		lm = &nolock_ops;
+		sdp->sd_args.ar_localflocks = 1;
+		sdp->sd_args.ar_localcaching = 1;
+#ifdef CONFIG_GFS2_FS_LOCKING_DLM
+	} else if (!strcmp("lock_dlm", proto)) {
+		lm = &gfs2_dlm_ops;
+#endif
+	} else {
+		printk(KERN_INFO "GFS2: can't find protocol %s\n", proto);
+		return -ENOENT;
+	}
 
 	fs_info(sdp, "Trying to join cluster \"%s\", \"%s\"\n", proto, table);
 
-	error = gfs2_mount_lockproto(proto, table, sdp->sd_args.ar_hostdata,
-				     gfs2_glock_cb, sdp,
-				     GFS2_MIN_LVB_SIZE, flags,
-				     &sdp->sd_lockstruct, &sdp->sd_kobj);
-	if (error) {
-		fs_info(sdp, "can't mount proto=%s, table=%s, hostdata=%s\n",
-			proto, table, sdp->sd_args.ar_hostdata);
-		goto out;
-	}
+	ls->ls_ops = lm;
+	ls->ls_first = 1;
+	ls->ls_id = 0;
 
-	if (gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_ops) ||
-	    gfs2_assert_warn(sdp, sdp->sd_lockstruct.ls_lvb_size >=
-				  GFS2_MIN_LVB_SIZE)) {
-		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
-		goto out;
+	for (options = args->ar_hostdata; (o = strsep(&options, ":")); ) {
+		substring_t tmp[MAX_OPT_ARGS];
+		int token, option;
+
+		if (!o || !*o)
+			continue;
+
+		token = match_token(o, *lm->lm_tokens, tmp);
+		switch (token) {
+		case Opt_jid:
+			ret = match_int(&tmp[0], &option);
+			if (ret || option < 0) 
+				goto hostdata_error;
+			ls->ls_jid = option;
+			break;
+		case Opt_id:
+			ret = match_int(&tmp[0], &option);
+			if (ret)
+				goto hostdata_error;
+			ls->ls_id = option;
+			break;
+		case Opt_first:
+			ret = match_int(&tmp[0], &option);
+			if (ret || (option != 0 && option != 1))
+				goto hostdata_error;
+			ls->ls_first = option;
+			break;
+		case Opt_nodir:
+			ret = match_int(&tmp[0], &option);
+			if (ret || (option != 0 && option != 1))
+				goto hostdata_error;
+			ls->ls_nodir = option;
+			break;
+		case Opt_err:
+		default:
+hostdata_error:
+			fs_info(sdp, "unknown hostdata (%s)\n", o);
+			return -EINVAL;
+		}
 	}
 
 	if (sdp->sd_args.ar_spectator)
@@ -1074,22 +1125,25 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 		snprintf(sdp->sd_fsname, GFS2_FSNAME_LEN, "%s.%u", table,
 			 sdp->sd_lockstruct.ls_jid);
 
-	fs_info(sdp, "Joined cluster. Now mounting FS...\n");
-
-	if ((sdp->sd_lockstruct.ls_flags & LM_LSFLAG_LOCAL) &&
-	    !sdp->sd_args.ar_ignore_local_fs) {
-		sdp->sd_args.ar_localflocks = 1;
-		sdp->sd_args.ar_localcaching = 1;
+	fsname = strchr(table, ':');
+	if (fsname)
+		fsname++;
+	if (lm->lm_mount == NULL) {
+		fs_info(sdp, "Now mounting FS...\n");
+		return 0;
 	}
-
-out:
-	return error;
+	ret = lm->lm_mount(sdp, fsname);
+	if (ret == 0)
+		fs_info(sdp, "Joined cluster. Now mounting FS...\n");
+	return ret;
 }
 
 void gfs2_lm_unmount(struct gfs2_sbd *sdp)
 {
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		gfs2_unmount_lockproto(&sdp->sd_lockstruct);
+	const struct lm_lockops *lm = sdp->sd_lockstruct.ls_ops;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)) &&
+	    lm->lm_unmount)
+		lm->lm_unmount(sdp);
 }
 
 /**
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 4987754..abd5429 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -18,7 +18,6 @@
 #include <linux/posix_acl.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 #include <linux/fiemap.h>
 #include <asm/uaccess.h>
 
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index f0699ac..4ecdad0 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -19,7 +19,6 @@
 #include <linux/delay.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 #include <linux/time.h>
 
 #include "gfs2.h"
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index e8ef0f8..8d53f66 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -45,7 +45,6 @@
 #include <linux/fs.h>
 #include <linux/bio.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
@@ -108,7 +107,7 @@ int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask)
 		gfs2_assert_warn(sdp, !qd->qd_slot_count);
 		gfs2_assert_warn(sdp, !qd->qd_bh_count);
 
-		gfs2_lvb_unhold(qd->qd_gl);
+		gfs2_glock_put(qd->qd_gl);
 		atomic_dec(&sdp->sd_quota_count);
 
 		/* Delete it from the common reclaim list */
@@ -157,11 +156,6 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 	if (error)
 		goto fail;
 
-	error = gfs2_lvb_hold(qd->qd_gl);
-	gfs2_glock_put(qd->qd_gl);
-	if (error)
-		goto fail;
-
 	*qdp = qd;
 
 	return 0;
@@ -211,7 +205,7 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
 
 		if (qd || !create) {
 			if (new_qd) {
-				gfs2_lvb_unhold(new_qd->qd_gl);
+				gfs2_glock_put(new_qd->qd_gl);
 				kmem_cache_free(gfs2_quotad_cachep, new_qd);
 			}
 			*qdp = qd;
@@ -1280,7 +1274,7 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 			gfs2_assert_warn(sdp, qd->qd_slot_count == 1);
 		gfs2_assert_warn(sdp, !qd->qd_bh_count);
 
-		gfs2_lvb_unhold(qd->qd_gl);
+		gfs2_glock_put(qd->qd_gl);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
 
 		spin_lock(&qd_lru_lock);
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index efd09c3..247e8f7 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -13,7 +13,6 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
-#include <linux/lm_interface.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
@@ -427,20 +426,23 @@ static int clean_journal(struct gfs2_jdesc *jd, struct gfs2_log_header_host *hea
 }
 
 
-static void gfs2_lm_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
-				  unsigned int message)
+static void gfs2_recovery_done(struct gfs2_sbd *sdp, unsigned int jid,
+                               unsigned int message)
 {
-	if (!sdp->sd_lockstruct.ls_ops->lm_recovery_done)
-		return;
-
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		sdp->sd_lockstruct.ls_ops->lm_recovery_done(
-			sdp->sd_lockstruct.ls_lockspace, jid, message);
+	char env_jid[20];
+	char env_status[20];
+	char *envp[] = { env_jid, env_status, NULL };
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+        ls->ls_recover_jid_done = jid;
+        ls->ls_recover_jid_status = message;
+	sprintf(env_jid, "JID=%d", jid);
+	sprintf(env_status, "RECOVERY=%s",
+		message == LM_RD_SUCCESS ? "Done" : "Failed");
+        kobject_uevent_env(&sdp->sd_kobj, KOBJ_CHANGE, envp);
 }
 
-
 /**
- * gfs2_recover_journal - recovery a given journal
+ * gfs2_recover_journal - recover a given journal
  * @jd: the struct gfs2_jdesc describing the journal
  *
  * Acquire the journal's lock, check to see if the journal is clean, and
@@ -561,7 +563,7 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd)
 	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid)
 		gfs2_glock_dq_uninit(&ji_gh);
 
-	gfs2_lm_recovery_done(sdp, jd->jd_jid, LM_RD_SUCCESS);
+	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_SUCCESS);
 
 	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid)
 		gfs2_glock_dq_uninit(&j_gh);
@@ -581,7 +583,7 @@ fail_gunlock_j:
 	fs_info(sdp, "jid=%u: %s\n", jd->jd_jid, (error) ? "Failed" : "Done");
 
 fail:
-	gfs2_lm_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
+	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
 	return error;
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8b01c63..ba5a021 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -13,7 +13,6 @@
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <linux/prefetch.h>
 
 #include "gfs2.h"
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 141b781..7cf302b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -15,7 +15,6 @@
 #include <linux/crc32.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/bio.h>
-#include <linux/lm_interface.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index a58a120..a78997e 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -14,9 +14,8 @@
 #include <linux/buffer_head.h>
 #include <linux/module.h>
 #include <linux/kobject.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <asm/uaccess.h>
+#include <linux/gfs2_ondisk.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -224,14 +223,145 @@ static struct lockstruct_attr lockstruct_attr_##name = __ATTR_RO(name)
 
 LOCKSTRUCT_ATTR(jid,      "%u\n");
 LOCKSTRUCT_ATTR(first,    "%u\n");
-LOCKSTRUCT_ATTR(lvb_size, "%u\n");
-LOCKSTRUCT_ATTR(flags,    "%d\n");
 
 static struct attribute *lockstruct_attrs[] = {
 	&lockstruct_attr_jid.attr,
 	&lockstruct_attr_first.attr,
-	&lockstruct_attr_lvb_size.attr,
-	&lockstruct_attr_flags.attr,
+	NULL,
+};
+
+/*
+ * lock_module. Originally from lock_dlm
+ */
+
+static ssize_t proto_name_show(struct gfs2_sbd *sdp, char *buf)
+{
+	const struct lm_lockops *ops = sdp->sd_lockstruct.ls_ops;
+	return sprintf(buf, "%s\n", ops->lm_proto_name);
+}
+
+static ssize_t block_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	ssize_t ret;
+	int val = 0;
+
+	if (test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))
+		val = 1;
+	ret = sprintf(buf, "%d\n", val);
+	return ret;
+}
+
+static ssize_t block_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	ssize_t ret = len;
+	int val;
+
+	val = simple_strtol(buf, NULL, 0);
+
+	if (val == 1)
+		set_bit(DFL_BLOCK_LOCKS, &ls->ls_flags);
+	else if (val == 0) {
+		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_flags);
+		smp_mb__after_clear_bit();
+		gfs2_glock_thaw(sdp);
+	} else {
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static ssize_t lkid_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sprintf(buf, "%u\n", ls->ls_id);
+}
+
+static ssize_t lkfirst_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sprintf(buf, "%d\n", ls->ls_first);
+}
+
+static ssize_t first_done_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sprintf(buf, "%d\n", ls->ls_first_done);
+}
+
+static ssize_t recover_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sprintf(buf, "%d\n", ls->ls_recover_jid);
+}
+
+static void gfs2_jdesc_make_dirty(struct gfs2_sbd *sdp, unsigned int jid)
+{
+	struct gfs2_jdesc *jd;
+
+	spin_lock(&sdp->sd_jindex_spin);
+	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
+		if (jd->jd_jid != jid)
+			continue;
+		jd->jd_dirty = 1;
+		break;
+	}
+	spin_unlock(&sdp->sd_jindex_spin);
+}
+
+static ssize_t recover_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	ls->ls_recover_jid = simple_strtol(buf, NULL, 0);
+	gfs2_jdesc_make_dirty(sdp, ls->ls_recover_jid);
+	if (sdp->sd_recoverd_process)
+		wake_up_process(sdp->sd_recoverd_process);
+	return len;
+}
+
+static ssize_t recover_done_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sprintf(buf, "%d\n", ls->ls_recover_jid_done);
+}
+
+static ssize_t recover_status_show(struct gfs2_sbd *sdp, char *buf)
+{
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	return sprintf(buf, "%d\n", ls->ls_recover_jid_status);
+}
+
+struct gdlm_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct gfs2_sbd *sdp, char *);
+	ssize_t (*store)(struct gfs2_sbd *sdp, const char *, size_t);
+};
+
+#define GDLM_ATTR(_name,_mode,_show,_store) \
+static struct gdlm_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
+
+GDLM_ATTR(proto_name,     0444, proto_name_show,     NULL);
+GDLM_ATTR(block,          0644, block_show,          block_store);
+GDLM_ATTR(withdraw,       0644, withdraw_show,       withdraw_store);
+GDLM_ATTR(id,             0444, lkid_show,           NULL);
+GDLM_ATTR(first,          0444, lkfirst_show,        NULL);
+GDLM_ATTR(first_done,     0444, first_done_show,     NULL);
+GDLM_ATTR(recover,        0644, recover_show,        recover_store);
+GDLM_ATTR(recover_done,   0444, recover_done_show,   NULL);
+GDLM_ATTR(recover_status, 0444, recover_status_show, NULL);
+
+static struct attribute *lock_module_attrs[] = {
+	&gdlm_attr_proto_name.attr,
+	&gdlm_attr_block.attr,
+	&gdlm_attr_withdraw.attr,
+	&gdlm_attr_id.attr,
+	&lockstruct_attr_jid.attr,
+	&gdlm_attr_first.attr,
+	&gdlm_attr_first_done.attr,
+	&gdlm_attr_recover.attr,
+	&gdlm_attr_recover_done.attr,
+	&gdlm_attr_recover_status.attr,
 	NULL,
 };
 
@@ -412,6 +542,11 @@ static struct attribute_group tune_group = {
 	.attrs = tune_attrs,
 };
 
+static struct attribute_group lock_module_group = {
+	.name = "lock_module",
+	.attrs = lock_module_attrs,
+};
+
 int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 {
 	int error;
@@ -434,9 +569,15 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail_args;
 
+	error = sysfs_create_group(&sdp->sd_kobj, &lock_module_group);
+	if (error)
+		goto fail_tune;
+
 	kobject_uevent(&sdp->sd_kobj, KOBJ_ADD);
 	return 0;
 
+fail_tune:
+	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 fail_args:
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
 fail_lockstruct:
@@ -453,6 +594,7 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
+	sysfs_remove_group(&sdp->sd_kobj, &lock_module_group);
 	kobject_put(&sdp->sd_kobj);
 }
 
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index f677b8a..33cd523 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -12,9 +12,8 @@
 #include <linux/spinlock.h>
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
-#include <linux/gfs2_ondisk.h>
 #include <linux/kallsyms.h>
-#include <linux/lm_interface.h>
+#include <linux/gfs2_ondisk.h>
 
 #include "gfs2.h"
 #include "incore.h"
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 374f50e..9d12b11 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -13,7 +13,6 @@
 #include <linux/buffer_head.h>
 #include <linux/crc32.h>
 #include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
 #include <asm/uaccess.h>
 
 #include "gfs2.h"
@@ -35,6 +34,8 @@ void gfs2_assert_i(struct gfs2_sbd *sdp)
 
 int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
 {
+	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
+	const struct lm_lockops *lm = ls->ls_ops;
 	va_list args;
 
 	if (test_and_set_bit(SDF_SHUTDOWN, &sdp->sd_flags))
@@ -47,8 +48,12 @@ int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
 	fs_err(sdp, "about to withdraw this file system\n");
 	BUG_ON(sdp->sd_args.ar_debug);
 
-	fs_err(sdp, "telling LM to withdraw\n");
-	gfs2_withdraw_lockproto(&sdp->sd_lockstruct);
+	kobject_uevent(&sdp->sd_kobj, KOBJ_OFFLINE);
+
+	if (lm->lm_unmount) {
+		fs_err(sdp, "telling LM to unmount\n");
+		lm->lm_unmount(sdp);
+	}
 	fs_err(sdp, "withdrawn\n");
 	dump_stack();
 
diff --git a/include/linux/lm_interface.h b/include/linux/lm_interface.h
deleted file mode 100644
index 2ed8fa1..0000000
--- a/include/linux/lm_interface.h
+++ /dev/null
@@ -1,277 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __LM_INTERFACE_DOT_H__
-#define __LM_INTERFACE_DOT_H__
-
-
-typedef void (*lm_callback_t) (void *ptr, unsigned int type, void *data);
-
-/*
- * lm_mount() flags
- *
- * LM_MFLAG_SPECTATOR
- * GFS is asking to join the filesystem's lockspace, but it doesn't want to
- * modify the filesystem.  The lock module shouldn't assign a journal to the FS
- * mount.  It shouldn't send recovery callbacks to the FS mount.  If the node
- * dies or withdraws, all locks can be wiped immediately.
- *
- * LM_MFLAG_CONV_NODROP
- * Do not allow the dlm to internally resolve conversion deadlocks by demoting
- * the lock to unlocked and then reacquiring it in the requested mode. Instead,
- * it should cancel the request and return LM_OUT_CONV_DEADLK.
- */
-
-#define LM_MFLAG_SPECTATOR	0x00000001
-#define LM_MFLAG_CONV_NODROP	0x00000002
-
-/*
- * lm_lockstruct flags
- *
- * LM_LSFLAG_LOCAL
- * The lock_nolock module returns LM_LSFLAG_LOCAL to GFS, indicating that GFS
- * can make single-node optimizations.
- */
-
-#define LM_LSFLAG_LOCAL		0x00000001
-
-/*
- * lm_lockname types
- */
-
-#define LM_TYPE_RESERVED	0x00
-#define LM_TYPE_NONDISK		0x01
-#define LM_TYPE_INODE		0x02
-#define LM_TYPE_RGRP		0x03
-#define LM_TYPE_META		0x04
-#define LM_TYPE_IOPEN		0x05
-#define LM_TYPE_FLOCK		0x06
-#define LM_TYPE_PLOCK		0x07
-#define LM_TYPE_QUOTA		0x08
-#define LM_TYPE_JOURNAL		0x09
-
-/*
- * lm_lock() states
- *
- * SHARED is compatible with SHARED, not with DEFERRED or EX.
- * DEFERRED is compatible with DEFERRED, not with SHARED or EX.
- */
-
-#define LM_ST_UNLOCKED		0
-#define LM_ST_EXCLUSIVE		1
-#define LM_ST_DEFERRED		2
-#define LM_ST_SHARED		3
-
-/*
- * lm_lock() flags
- *
- * LM_FLAG_TRY
- * Don't wait to acquire the lock if it can't be granted immediately.
- *
- * LM_FLAG_TRY_1CB
- * Send one blocking callback if TRY is set and the lock is not granted.
- *
- * LM_FLAG_NOEXP
- * GFS sets this flag on lock requests it makes while doing journal recovery.
- * These special requests should not be blocked due to the recovery like
- * ordinary locks would be.
- *
- * LM_FLAG_ANY
- * A SHARED request may also be granted in DEFERRED, or a DEFERRED request may
- * also be granted in SHARED.  The preferred state is whichever is compatible
- * with other granted locks, or the specified state if no other locks exist.
- *
- * LM_FLAG_PRIORITY
- * Override fairness considerations.  Suppose a lock is held in a shared state
- * and there is a pending request for the deferred state.  A shared lock
- * request with the priority flag would be allowed to bypass the deferred
- * request and directly join the other shared lock.  A shared lock request
- * without the priority flag might be forced to wait until the deferred
- * requested had acquired and released the lock.
- */
-
-#define LM_FLAG_TRY		0x00000001
-#define LM_FLAG_TRY_1CB		0x00000002
-#define LM_FLAG_NOEXP		0x00000004
-#define LM_FLAG_ANY		0x00000008
-#define LM_FLAG_PRIORITY	0x00000010
-
-/*
- * lm_lock() and lm_async_cb return flags
- *
- * LM_OUT_ST_MASK
- * Masks the lower two bits of lock state in the returned value.
- *
- * LM_OUT_CACHEABLE
- * The lock hasn't been released so GFS can continue to cache data for it.
- *
- * LM_OUT_CANCELED
- * The lock request was canceled.
- *
- * LM_OUT_ASYNC
- * The result of the request will be returned in an LM_CB_ASYNC callback.
- *
- * LM_OUT_CONV_DEADLK
- * The lock request was canceled do to a conversion deadlock.
- */
-
-#define LM_OUT_ST_MASK		0x00000003
-#define LM_OUT_CANCELED		0x00000008
-#define LM_OUT_ASYNC		0x00000080
-#define LM_OUT_ERROR		0x00000100
-
-/*
- * lm_callback_t types
- *
- * LM_CB_NEED_E LM_CB_NEED_D LM_CB_NEED_S
- * Blocking callback, a remote node is requesting the given lock in
- * EXCLUSIVE, DEFERRED, or SHARED.
- *
- * LM_CB_NEED_RECOVERY
- * The given journal needs to be recovered.
- *
- * LM_CB_ASYNC
- * The given lock has been granted.
- */
-
-#define LM_CB_NEED_E		257
-#define LM_CB_NEED_D		258
-#define LM_CB_NEED_S		259
-#define LM_CB_NEED_RECOVERY	260
-#define LM_CB_ASYNC		262
-
-/*
- * lm_recovery_done() messages
- */
-
-#define LM_RD_GAVEUP		308
-#define LM_RD_SUCCESS		309
-
-
-struct lm_lockname {
-	u64 ln_number;
-	unsigned int ln_type;
-};
-
-#define lm_name_equal(name1, name2) \
-	(((name1)->ln_number == (name2)->ln_number) && \
-	 ((name1)->ln_type == (name2)->ln_type)) \
-
-struct lm_async_cb {
-	struct lm_lockname lc_name;
-	int lc_ret;
-};
-
-struct lm_lockstruct;
-
-struct lm_lockops {
-	const char *lm_proto_name;
-
-	/*
-	 * Mount/Unmount
-	 */
-
-	int (*lm_mount) (char *table_name, char *host_data,
-			 lm_callback_t cb, void *cb_data,
-			 unsigned int min_lvb_size, int flags,
-			 struct lm_lockstruct *lockstruct,
-			 struct kobject *fskobj);
-
-	void (*lm_others_may_mount) (void *lockspace);
-
-	void (*lm_unmount) (void *lockspace);
-
-	void (*lm_withdraw) (void *lockspace);
-
-	/*
-	 * Lock oriented operations
-	 */
-
-	int (*lm_get_lock) (void *lockspace, struct lm_lockname *name, void **lockp);
-
-	void (*lm_put_lock) (void *lock);
-
-	unsigned int (*lm_lock) (void *lock, unsigned int cur_state,
-				 unsigned int req_state, unsigned int flags);
-
-	unsigned int (*lm_unlock) (void *lock, unsigned int cur_state);
-
-	void (*lm_cancel) (void *lock);
-
-	int (*lm_hold_lvb) (void *lock, char **lvbp);
-	void (*lm_unhold_lvb) (void *lock, char *lvb);
-
-	/*
-	 * Posix Lock oriented operations
-	 */
-
-	int (*lm_plock_get) (void *lockspace, struct lm_lockname *name,
-			     struct file *file, struct file_lock *fl);
-
-	int (*lm_plock) (void *lockspace, struct lm_lockname *name,
-			 struct file *file, int cmd, struct file_lock *fl);
-
-	int (*lm_punlock) (void *lockspace, struct lm_lockname *name,
-			   struct file *file, struct file_lock *fl);
-
-	/*
-	 * Client oriented operations
-	 */
-
-	void (*lm_recovery_done) (void *lockspace, unsigned int jid,
-				  unsigned int message);
-
-	struct module *lm_owner;
-};
-
-/*
- * lm_mount() return values
- *
- * ls_jid - the journal ID this node should use
- * ls_first - this node is the first to mount the file system
- * ls_lvb_size - size in bytes of lock value blocks
- * ls_lockspace - lock module's context for this file system
- * ls_ops - lock module's functions
- * ls_flags - lock module features
- */
-
-struct lm_lockstruct {
-	unsigned int ls_jid;
-	unsigned int ls_first;
-	unsigned int ls_lvb_size;
-	void *ls_lockspace;
-	const struct lm_lockops *ls_ops;
-	int ls_flags;
-};
-
-/*
- * Lock module bottom interface.  A lock module makes itself available to GFS
- * with these functions.
- */
-
-int gfs2_register_lockproto(const struct lm_lockops *proto);
-void gfs2_unregister_lockproto(const struct lm_lockops *proto);
-
-/*
- * Lock module top interface.  GFS calls these functions when mounting or
- * unmounting a file system.
- */
-
-int gfs2_mount_lockproto(char *proto_name, char *table_name, char *host_data,
-			 lm_callback_t cb, void *cb_data,
-			 unsigned int min_lvb_size, int flags,
-			 struct lm_lockstruct *lockstruct,
-			 struct kobject *fskobj);
-
-void gfs2_unmount_lockproto(struct lm_lockstruct *lockstruct);
-
-void gfs2_withdraw_lockproto(struct lm_lockstruct *lockstruct);
-
-#endif /* __LM_INTERFACE_DOT_H__ */
-
-- 
1.6.0.3

