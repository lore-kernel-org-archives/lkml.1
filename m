Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755993AbYLQMfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYLQMfF (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYLQM3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53746 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbYLQM3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:25 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/24] GFS2: Kill two daemons with one patch
Date: Wed, 17 Dec 2008 11:30:16 +0000
Message-Id: <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch removes the two daemons, gfs2_scand and gfs2_glockd
and replaces them with a shrinker which is called from the VM.

The net result is that GFS2 responds better when there is memory
pressure, since it shrinks the glock cache at the same rate
as the VFS shrinks the dcache and icache. There are no longer
any time based criteria for shrinking glocks, they are kept
until such time as the VM asks for more memory and then we
demote just as many glocks as required.

There are potential future changes to this code, including the
possibility of sorting the glocks which are to be written back
into inode number order, to get a better I/O ordering. It would
be very useful to have an elevator based workqueue implementation
for this, as that would automatically deal with the read I/O cases
at the same time.

This patch is my answer to Andrew Morton's remark, made during
the initial review of GFS2, asking why GFS2 needs so many kernel
threads, the answer being that it doesn't :-) This patch is a
net loss of about 200 lines of code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Makefile b/fs/gfs2/Makefile
index ec65851..c1b4ec6 100644
--- a/fs/gfs2/Makefile
+++ b/fs/gfs2/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_GFS2_FS) += gfs2.o
-gfs2-y := acl.o bmap.o daemon.o dir.o eaops.o eattr.o glock.o \
+gfs2-y := acl.o bmap.o dir.o eaops.o eattr.o glock.o \
 	glops.o inode.o log.o lops.o locking.o main.o meta_io.o \
 	mount.o ops_address.o ops_dentry.o ops_export.o ops_file.o \
 	ops_fstype.o ops_inode.o ops_super.o quota.o \
diff --git a/fs/gfs2/daemon.c b/fs/gfs2/daemon.c
deleted file mode 100644
index 2662df0..0000000
--- a/fs/gfs2/daemon.c
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/completion.h>
-#include <linux/buffer_head.h>
-#include <linux/kthread.h>
-#include <linux/delay.h>
-#include <linux/gfs2_ondisk.h>
-#include <linux/lm_interface.h>
-#include <linux/freezer.h>
-
-#include "gfs2.h"
-#include "incore.h"
-#include "daemon.h"
-#include "glock.h"
-#include "log.h"
-#include "recovery.h"
-#include "super.h"
-#include "util.h"
-
-/* This uses schedule_timeout() instead of msleep() because it's good for
-   the daemons to wake up more often than the timeout when unmounting so
-   the user's unmount doesn't sit there forever.
-
-   The kthread functions used to start these daemons block and flush signals. */
-
-/**
- * gfs2_glockd - Reclaim unused glock structures
- * @sdp: Pointer to GFS2 superblock
- *
- * One or more of these daemons run, reclaiming glocks on sd_reclaim_list.
- * Number of daemons can be set by user, with num_glockd mount option.
- */
-
-int gfs2_glockd(void *data)
-{
-	struct gfs2_sbd *sdp = data;
-
-	while (!kthread_should_stop()) {
-		while (atomic_read(&sdp->sd_reclaim_count))
-			gfs2_reclaim_glock(sdp);
-
-		wait_event_interruptible(sdp->sd_reclaim_wq,
-					 (atomic_read(&sdp->sd_reclaim_count) ||
-					 kthread_should_stop()));
-		if (freezing(current))
-			refrigerator();
-	}
-
-	return 0;
-}
-
diff --git a/fs/gfs2/daemon.h b/fs/gfs2/daemon.h
deleted file mode 100644
index 5258954..0000000
--- a/fs/gfs2/daemon.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
- *
- * This copyrighted material is made available to anyone wishing to use,
- * modify, copy, or redistribute it subject to the terms and conditions
- * of the GNU General Public License version 2.
- */
-
-#ifndef __DAEMON_DOT_H__
-#define __DAEMON_DOT_H__
-
-int gfs2_glockd(void *data);
-
-#endif /* __DAEMON_DOT_H__ */
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 4ddf3bd..07ffc81 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -62,9 +62,10 @@ static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int
 
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
-static struct task_struct *scand_process;
-static unsigned int scand_secs = 5;
 static struct workqueue_struct *glock_workqueue;
+static LIST_HEAD(lru_list);
+static atomic_t lru_count = ATOMIC_INIT(0);
+static spinlock_t lru_lock = SPIN_LOCK_UNLOCKED;
 
 #define GFS2_GL_HASH_SHIFT      15
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
@@ -175,6 +176,22 @@ static void gfs2_glock_hold(struct gfs2_glock *gl)
 }
 
 /**
+ * gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
+ * @gl: the glock
+ *
+ */
+
+static void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
+{
+	spin_lock(&lru_lock);
+	if (list_empty(&gl->gl_lru) && gl->gl_state != LM_ST_UNLOCKED) {
+		list_add_tail(&gl->gl_lru, &lru_list);
+		atomic_inc(&lru_count);
+	}
+	spin_unlock(&lru_lock);
+}
+
+/**
  * gfs2_glock_put() - Decrement reference count on glock
  * @gl: The glock to put
  *
@@ -188,14 +205,23 @@ int gfs2_glock_put(struct gfs2_glock *gl)
 	if (atomic_dec_and_test(&gl->gl_ref)) {
 		hlist_del(&gl->gl_list);
 		write_unlock(gl_lock_addr(gl->gl_hash));
+		spin_lock(&lru_lock);
+		if (!list_empty(&gl->gl_lru)) {
+			list_del_init(&gl->gl_lru);
+			atomic_dec(&lru_count);
+		}
+		spin_unlock(&lru_lock);
 		GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_UNLOCKED);
-		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_reclaim));
+		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_lru));
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
 		glock_free(gl);
 		rv = 1;
 		goto out;
 	}
 	write_unlock(gl_lock_addr(gl->gl_hash));
+	/* 1 for being hashed, 1 for having state != LM_ST_UNLOCKED */
+	if (atomic_read(&gl->gl_ref) == 2)
+		gfs2_glock_schedule_for_reclaim(gl);
 out:
 	return rv;
 }
@@ -837,7 +863,7 @@ static void wait_on_demote(struct gfs2_glock *gl)
  */
 
 static void handle_callback(struct gfs2_glock *gl, unsigned int state,
-			    int remote, unsigned long delay)
+			    unsigned long delay)
 {
 	int bit = delay ? GLF_PENDING_DEMOTE : GLF_DEMOTE;
 
@@ -845,9 +871,6 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 	if (gl->gl_demote_state == LM_ST_EXCLUSIVE) {
 		gl->gl_demote_state = state;
 		gl->gl_demote_time = jiffies;
-		if (remote && gl->gl_ops->go_type == LM_TYPE_IOPEN &&
-		    gl->gl_object)
-			gfs2_glock_schedule_for_reclaim(gl);
 	} else if (gl->gl_demote_state != LM_ST_UNLOCKED &&
 			gl->gl_demote_state != state) {
 		gl->gl_demote_state = LM_ST_UNLOCKED;
@@ -1017,7 +1040,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 
 	spin_lock(&gl->gl_spin);
 	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
+		handle_callback(gl, LM_ST_UNLOCKED, 0);
 
 	list_del_init(&gh->gh_list);
 	if (find_first_holder(gl) == NULL) {
@@ -1288,7 +1311,7 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 		delay = gl->gl_ops->go_min_hold_time;
 
 	spin_lock(&gl->gl_spin);
-	handle_callback(gl, state, 1, delay);
+	handle_callback(gl, state, delay);
 	spin_unlock(&gl->gl_spin);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
 		gfs2_glock_put(gl);
@@ -1357,80 +1380,83 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
  * Returns: 1 if it's ok
  */
 
-static int demote_ok(struct gfs2_glock *gl)
+static int demote_ok(const struct gfs2_glock *gl)
 {
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	int demote = 1;
-
-	if (test_bit(GLF_STICKY, &gl->gl_flags))
-		demote = 0;
-	else if (glops->go_demote_ok)
-		demote = glops->go_demote_ok(gl);
-
-	return demote;
-}
 
-/**
- * gfs2_glock_schedule_for_reclaim - Add a glock to the reclaim list
- * @gl: the glock
- *
- */
-
-void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-
-	spin_lock(&sdp->sd_reclaim_lock);
-	if (list_empty(&gl->gl_reclaim)) {
-		gfs2_glock_hold(gl);
-		list_add(&gl->gl_reclaim, &sdp->sd_reclaim_list);
-		atomic_inc(&sdp->sd_reclaim_count);
-		spin_unlock(&sdp->sd_reclaim_lock);
-		wake_up(&sdp->sd_reclaim_wq);
-	} else
-		spin_unlock(&sdp->sd_reclaim_lock);
+	if (gl->gl_state == LM_ST_UNLOCKED)
+		return 0;
+	if (!list_empty(&gl->gl_holders))
+		return 0;
+	if (glops->go_demote_ok)
+		return glops->go_demote_ok(gl);
+	return 1;
 }
 
-/**
- * gfs2_reclaim_glock - process the next glock on the filesystem's reclaim list
- * @sdp: the filesystem
- *
- * Called from gfs2_glockd() glock reclaim daemon, or when promoting a
- * different glock and we notice that there are a lot of glocks in the
- * reclaim list.
- *
- */
 
-void gfs2_reclaim_glock(struct gfs2_sbd *sdp)
+static int gfs2_shrink_glock_memory(int nr, gfp_t gfp_mask)
 {
 	struct gfs2_glock *gl;
-	int done_callback = 0;
+	int may_demote;
+	int nr_skipped = 0;
+	int got_ref = 0;
+	LIST_HEAD(skipped);
 
-	spin_lock(&sdp->sd_reclaim_lock);
-	if (list_empty(&sdp->sd_reclaim_list)) {
-		spin_unlock(&sdp->sd_reclaim_lock);
-		return;
-	}
-	gl = list_entry(sdp->sd_reclaim_list.next,
-			struct gfs2_glock, gl_reclaim);
-	list_del_init(&gl->gl_reclaim);
-	spin_unlock(&sdp->sd_reclaim_lock);
+	if (nr == 0)
+		goto out;
 
-	atomic_dec(&sdp->sd_reclaim_count);
-	atomic_inc(&sdp->sd_reclaimed);
+	if (!(gfp_mask & __GFP_FS))
+		return -1;
 
-	spin_lock(&gl->gl_spin);
-	if (find_first_holder(gl) == NULL &&
-	    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl)) {
-		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
-		done_callback = 1;
+	spin_lock(&lru_lock);
+	while(nr && !list_empty(&lru_list)) {
+		gl = list_entry(lru_list.next, struct gfs2_glock, gl_lru);
+		list_del_init(&gl->gl_lru);
+		atomic_dec(&lru_count);
+
+		/* Test for being demotable */
+		if (!test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
+			gfs2_glock_hold(gl);
+			got_ref = 1;
+			spin_unlock(&lru_lock);
+			spin_lock(&gl->gl_spin);
+			may_demote = demote_ok(gl);
+			spin_unlock(&gl->gl_spin);
+			clear_bit(GLF_LOCK, &gl->gl_flags);
+			if (may_demote) {
+				handle_callback(gl, LM_ST_UNLOCKED, 0);
+				nr--;
+				if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+					gfs2_glock_put(gl);
+			}
+			spin_lock(&lru_lock);
+			if (may_demote)
+				continue;
+		}
+		if (list_empty(&gl->gl_lru) &&
+		    (atomic_read(&gl->gl_ref) <= (2 + got_ref))) {
+			nr_skipped++;
+			list_add(&gl->gl_lru, &skipped);
+		}
+		if (got_ref) {
+			spin_unlock(&lru_lock);
+			gfs2_glock_put(gl);
+			spin_lock(&lru_lock);
+			got_ref = 0;
+		}
 	}
-	spin_unlock(&gl->gl_spin);
-	if (!done_callback ||
-	    queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
-		gfs2_glock_put(gl);
+	list_splice(&skipped, &lru_list);
+	atomic_add(nr_skipped, &lru_count);
+	spin_unlock(&lru_lock);
+out:
+	return (atomic_read(&lru_count) / 100) * sysctl_vfs_cache_pressure;
 }
 
+static struct shrinker glock_shrinker = {
+	.shrink = gfs2_shrink_glock_memory,
+	.seeks = DEFAULT_SEEKS,
+};
+
 /**
  * examine_bucket - Call a function for glock in a hash bucket
  * @examiner: the function
@@ -1476,26 +1502,6 @@ out:
 }
 
 /**
- * scan_glock - look at a glock and see if we can reclaim it
- * @gl: the glock to look at
- *
- */
-
-static void scan_glock(struct gfs2_glock *gl)
-{
-	if (gl->gl_ops == &gfs2_inode_glops && gl->gl_object)
-		return;
-	if (test_bit(GLF_LOCK, &gl->gl_flags))
-		return;
-
-	spin_lock(&gl->gl_spin);
-	if (find_first_holder(gl) == NULL &&
-	    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
-		gfs2_glock_schedule_for_reclaim(gl);
-	spin_unlock(&gl->gl_spin);
-}
-
-/**
  * clear_glock - look at a glock and see if we can free it from glock cache
  * @gl: the glock to look at
  *
@@ -1503,23 +1509,16 @@ static void scan_glock(struct gfs2_glock *gl)
 
 static void clear_glock(struct gfs2_glock *gl)
 {
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	int released;
-
-	spin_lock(&sdp->sd_reclaim_lock);
-	if (!list_empty(&gl->gl_reclaim)) {
-		list_del_init(&gl->gl_reclaim);
-		atomic_dec(&sdp->sd_reclaim_count);
-		spin_unlock(&sdp->sd_reclaim_lock);
-		released = gfs2_glock_put(gl);
-		gfs2_assert(sdp, !released);
-	} else {
-		spin_unlock(&sdp->sd_reclaim_lock);
+	spin_lock(&lru_lock);
+	if (!list_empty(&gl->gl_lru)) {
+		list_del_init(&gl->gl_lru);
+		atomic_dec(&lru_count);
 	}
+	spin_unlock(&lru_lock);
 
 	spin_lock(&gl->gl_spin);
 	if (find_first_holder(gl) == NULL && gl->gl_state != LM_ST_UNLOCKED)
-		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
+		handle_callback(gl, LM_ST_UNLOCKED, 0);
 	spin_unlock(&gl->gl_spin);
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
@@ -1656,8 +1655,6 @@ static const char *gflags2str(char *buf, const unsigned long *gflags)
 	char *p = buf;
 	if (test_bit(GLF_LOCK, gflags))
 		*p++ = 'l';
-	if (test_bit(GLF_STICKY, gflags))
-		*p++ = 's';
 	if (test_bit(GLF_DEMOTE, gflags))
 		*p++ = 'D';
 	if (test_bit(GLF_PENDING_DEMOTE, gflags))
@@ -1776,34 +1773,6 @@ static int gfs2_dump_lockstate(struct gfs2_sbd *sdp)
 	return error;
 }
 
-/**
- * gfs2_scand - Look for cached glocks and inodes to toss from memory
- * @sdp: Pointer to GFS2 superblock
- *
- * One of these daemons runs, finding candidates to add to sd_reclaim_list.
- * See gfs2_glockd()
- */
-
-static int gfs2_scand(void *data)
-{
-	unsigned x;
-	unsigned delay;
-
-	while (!kthread_should_stop()) {
-		for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
-			examine_bucket(scan_glock, NULL, x);
-		if (freezing(current))
-			refrigerator();
-		delay = scand_secs;
-		if (delay < 1)
-			delay = 1;
-		schedule_timeout_interruptible(delay * HZ);
-	}
-
-	return 0;
-}
-
-
 
 int __init gfs2_glock_init(void)
 {
@@ -1817,28 +1786,21 @@ int __init gfs2_glock_init(void)
 	}
 #endif
 
-	scand_process = kthread_run(gfs2_scand, NULL, "gfs2_scand");
-	if (IS_ERR(scand_process))
-		return PTR_ERR(scand_process);
-
 	glock_workqueue = create_workqueue("glock_workqueue");
-	if (IS_ERR(glock_workqueue)) {
-		kthread_stop(scand_process);
+	if (IS_ERR(glock_workqueue))
 		return PTR_ERR(glock_workqueue);
-	}
+
+	register_shrinker(&glock_shrinker);
 
 	return 0;
 }
 
 void gfs2_glock_exit(void)
 {
+	unregister_shrinker(&glock_shrinker);
 	destroy_workqueue(glock_workqueue);
-	kthread_stop(scand_process);
 }
 
-module_param(scand_secs, uint, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(scand_secs, "The number of seconds between scand runs");
-
 static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 {
 	struct gfs2_glock *gl;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 13a64ee..543ec7e 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -129,7 +129,6 @@ int gfs2_lvb_hold(struct gfs2_glock *gl);
 void gfs2_lvb_unhold(struct gfs2_glock *gl);
 
 void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
-void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp);
 void gfs2_glock_finish_truncate(struct gfs2_inode *ip);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 8ebff8e..8522d3a 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -201,19 +201,12 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
  * Returns: 1 if it's ok
  */
 
-static int inode_go_demote_ok(struct gfs2_glock *gl)
+static int inode_go_demote_ok(const struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	int demote = 0;
-
-	if (!gl->gl_object && !gl->gl_aspace->i_mapping->nrpages)
-		demote = 1;
-	else if (!sdp->sd_args.ar_localcaching &&
-		 time_after_eq(jiffies, gl->gl_stamp +
-			       gfs2_tune_get(sdp, gt_demote_secs) * HZ))
-		demote = 1;
-
-	return demote;
+	if (sdp->sd_jindex == gl->gl_object || sdp->sd_rindex == gl->gl_object)
+		return 0;
+	return 1;
 }
 
 /**
@@ -284,7 +277,7 @@ static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
  * Returns: 1 if it's ok
  */
 
-static int rgrp_go_demote_ok(struct gfs2_glock *gl)
+static int rgrp_go_demote_ok(const struct gfs2_glock *gl)
 {
 	return !gl->gl_aspace->i_mapping->nrpages;
 }
@@ -386,13 +379,25 @@ static int trans_go_xmote_bh(struct gfs2_glock *gl, struct gfs2_holder *gh)
 }
 
 /**
+ * trans_go_demote_ok
+ * @gl: the glock
+ *
+ * Always returns 0
+ */
+
+static int trans_go_demote_ok(const struct gfs2_glock *gl)
+{
+	return 0;
+}
+
+/**
  * quota_go_demote_ok - Check to see if it's ok to unlock a quota glock
  * @gl: the glock
  *
  * Returns: 1 if it's ok
  */
 
-static int quota_go_demote_ok(struct gfs2_glock *gl)
+static int quota_go_demote_ok(const struct gfs2_glock *gl)
 {
 	return !atomic_read(&gl->gl_lvb_count);
 }
@@ -426,6 +431,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 const struct gfs2_glock_operations gfs2_trans_glops = {
 	.go_xmote_th = trans_go_sync,
 	.go_xmote_bh = trans_go_xmote_bh,
+	.go_demote_ok = trans_go_demote_ok,
 	.go_type = LM_TYPE_NONDISK,
 };
 
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index dd7d0f8..608849d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -125,7 +125,7 @@ struct gfs2_glock_operations {
 	void (*go_xmote_th) (struct gfs2_glock *gl);
 	int (*go_xmote_bh) (struct gfs2_glock *gl, struct gfs2_holder *gh);
 	void (*go_inval) (struct gfs2_glock *gl, int flags);
-	int (*go_demote_ok) (struct gfs2_glock *gl);
+	int (*go_demote_ok) (const struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
 	int (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
@@ -155,7 +155,6 @@ struct gfs2_holder {
 
 enum {
 	GLF_LOCK			= 1,
-	GLF_STICKY			= 2,
 	GLF_DEMOTE			= 3,
 	GLF_PENDING_DEMOTE		= 4,
 	GLF_DEMOTE_IN_PROGRESS		= 5,
@@ -190,7 +189,7 @@ struct gfs2_glock {
 	unsigned long gl_tchange;
 	void *gl_object;
 
-	struct list_head gl_reclaim;
+	struct list_head gl_lru;
 
 	struct gfs2_sbd *gl_sbd;
 
@@ -397,7 +396,6 @@ struct gfs2_args {
 struct gfs2_tune {
 	spinlock_t gt_spin;
 
-	unsigned int gt_demote_secs; /* Cache retention for unheld glock */
 	unsigned int gt_incore_log_blocks;
 	unsigned int gt_log_flush_secs;
 
@@ -478,10 +476,6 @@ struct gfs2_sbd {
 	/* Lock Stuff */
 
 	struct lm_lockstruct sd_lockstruct;
-	struct list_head sd_reclaim_list;
-	spinlock_t sd_reclaim_lock;
-	wait_queue_head_t sd_reclaim_wq;
-	atomic_t sd_reclaim_count;
 	struct gfs2_holder sd_live_gh;
 	struct gfs2_glock *sd_rename_gl;
 	struct gfs2_glock *sd_trans_gl;
@@ -541,8 +535,6 @@ struct gfs2_sbd {
 	struct task_struct *sd_recoverd_process;
 	struct task_struct *sd_logd_process;
 	struct task_struct *sd_quotad_process;
-	struct task_struct *sd_glockd_process[GFS2_GLOCKD_MAX];
-	unsigned int sd_glockd_num;
 
 	/* Quota stuff */
 
@@ -615,10 +607,6 @@ struct gfs2_sbd {
 	struct mutex sd_freeze_lock;
 	unsigned int sd_freeze_count;
 
-	/* Counters */
-
-	atomic_t sd_reclaimed;
-
 	char sd_fsname[GFS2_FSNAME_LEN];
 	char sd_table_name[GFS2_FSNAME_LEN];
 	char sd_proto_name[GFS2_FSNAME_LEN];
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 1e66fb7..606bf44 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -386,7 +386,6 @@ int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	gfs2_free_di(rgd, ip);
 
 	gfs2_trans_end(sdp);
-	clear_bit(GLF_STICKY, &ip->i_gl->gl_flags);
 
 out_rg_gunlock:
 	gfs2_glock_dq_uninit(&al->al_rgd_gh);
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index cf39295..7cacfde 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -43,7 +43,7 @@ static void gfs2_init_glock_once(void *foo)
 	INIT_LIST_HEAD(&gl->gl_holders);
 	gl->gl_lvb = NULL;
 	atomic_set(&gl->gl_lvb_count, 0);
-	INIT_LIST_HEAD(&gl->gl_reclaim);
+	INIT_LIST_HEAD(&gl->gl_lru);
 	INIT_LIST_HEAD(&gl->gl_ail_list);
 	atomic_set(&gl->gl_ail_count, 0);
 }
diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index f96eb90..8c0f16e 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -32,7 +32,6 @@ enum {
 	Opt_debug,
 	Opt_nodebug,
 	Opt_upgrade,
-	Opt_num_glockd,
 	Opt_acl,
 	Opt_noacl,
 	Opt_quota_off,
@@ -57,7 +56,6 @@ static const match_table_t tokens = {
 	{Opt_debug, "debug"},
 	{Opt_nodebug, "nodebug"},
 	{Opt_upgrade, "upgrade"},
-	{Opt_num_glockd, "num_glockd=%d"},
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_quota_off, "quota=off"},
@@ -96,7 +94,6 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 		spin_unlock(&gfs2_sys_margs_lock);
 
 		/*  Set some defaults  */
-		args->ar_num_glockd = GFS2_GLOCKD_DEFAULT;
 		args->ar_quota = GFS2_QUOTA_DEFAULT;
 		args->ar_data = GFS2_DATA_DEFAULT;
 	}
@@ -105,7 +102,7 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 	   process them */
 
 	for (options = data; (o = strsep(&options, ",")); ) {
-		int token, option;
+		int token;
 		substring_t tmp[MAX_OPT_ARGS];
 
 		if (!*o)
@@ -196,22 +193,6 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 				goto cant_remount;
 			args->ar_upgrade = 1;
 			break;
-		case Opt_num_glockd:
-			if ((error = match_int(&tmp[0], &option))) {
-				fs_info(sdp, "problem getting num_glockd\n");
-				goto out_error;
-			}
-
-			if (remount && option != args->ar_num_glockd)
-				goto cant_remount;
-			if (!option || option > GFS2_GLOCKD_MAX) {
-				fs_info(sdp, "0 < num_glockd <= %u  (not %u)\n",
-				        GFS2_GLOCKD_MAX, option);
-				error = -EINVAL;
-				goto out_error;
-			}
-			args->ar_num_glockd = option;
-			break;
 		case Opt_acl:
 			args->ar_posix_acl = 1;
 			sdp->sd_vfs->s_flags |= MS_POSIXACL;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index d159e7e..fc300ea 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -22,7 +22,6 @@
 #include "gfs2.h"
 #include "incore.h"
 #include "bmap.h"
-#include "daemon.h"
 #include "glock.h"
 #include "glops.h"
 #include "inode.h"
@@ -56,7 +55,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 {
 	spin_lock_init(&gt->gt_spin);
 
-	gt->gt_demote_secs = 300;
 	gt->gt_incore_log_blocks = 1024;
 	gt->gt_log_flush_secs = 60;
 	gt->gt_recoverd_secs = 60;
@@ -88,10 +86,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	gfs2_tune_init(&sdp->sd_tune);
 
-	INIT_LIST_HEAD(&sdp->sd_reclaim_list);
-	spin_lock_init(&sdp->sd_reclaim_lock);
-	init_waitqueue_head(&sdp->sd_reclaim_wq);
-
 	mutex_init(&sdp->sd_inum_mutex);
 	spin_lock_init(&sdp->sd_statfs_spin);
 
@@ -443,24 +437,11 @@ out:
 static int init_locking(struct gfs2_sbd *sdp, struct gfs2_holder *mount_gh,
 			int undo)
 {
-	struct task_struct *p;
 	int error = 0;
 
 	if (undo)
 		goto fail_trans;
 
-	for (sdp->sd_glockd_num = 0;
-	     sdp->sd_glockd_num < sdp->sd_args.ar_num_glockd;
-	     sdp->sd_glockd_num++) {
-		p = kthread_run(gfs2_glockd, sdp, "gfs2_glockd");
-		error = IS_ERR(p);
-		if (error) {
-			fs_err(sdp, "can't start glockd thread: %d\n", error);
-			goto fail;
-		}
-		sdp->sd_glockd_process[sdp->sd_glockd_num] = p;
-	}
-
 	error = gfs2_glock_nq_num(sdp,
 				  GFS2_MOUNT_LOCK, &gfs2_nondisk_glops,
 				  LM_ST_EXCLUSIVE, LM_FLAG_NOEXP | GL_NOCACHE,
@@ -493,7 +474,6 @@ static int init_locking(struct gfs2_sbd *sdp, struct gfs2_holder *mount_gh,
 		fs_err(sdp, "can't create transaction glock: %d\n", error);
 		goto fail_rename;
 	}
-	set_bit(GLF_STICKY, &sdp->sd_trans_gl->gl_flags);
 
 	return 0;
 
@@ -506,9 +486,6 @@ fail_live:
 fail_mount:
 	gfs2_glock_dq_uninit(mount_gh);
 fail:
-	while (sdp->sd_glockd_num--)
-		kthread_stop(sdp->sd_glockd_process[sdp->sd_glockd_num]);
-
 	return error;
 }
 
@@ -681,7 +658,6 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		return PTR_ERR(sdp->sd_jindex);
 	}
 	ip = GFS2_I(sdp->sd_jindex);
-	set_bit(GLF_STICKY, &ip->i_gl->gl_flags);
 
 	/* Load in the journal index special file */
 
@@ -832,7 +808,6 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 		goto fail_statfs;
 	}
 	ip = GFS2_I(sdp->sd_rindex);
-	set_bit(GLF_STICKY, &ip->i_gl->gl_flags);
 	sdp->sd_rindex_uptodate = 0;
 
 	/* Read in the quota inode */
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index ad36af2..29f8a5c 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -142,8 +142,6 @@ static void gfs2_put_super(struct super_block *sb)
 	kthread_stop(sdp->sd_quotad_process);
 	kthread_stop(sdp->sd_logd_process);
 	kthread_stop(sdp->sd_recoverd_process);
-	while (sdp->sd_glockd_num--)
-		kthread_stop(sdp->sd_glockd_process[sdp->sd_glockd_num]);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		error = gfs2_make_fs_ro(sdp);
@@ -369,7 +367,6 @@ static void gfs2_clear_inode(struct inode *inode)
 	 */
 	if (test_bit(GIF_USER, &ip->i_flags)) {
 		ip->i_gl->gl_object = NULL;
-		gfs2_glock_schedule_for_reclaim(ip->i_gl);
 		gfs2_glock_put(ip->i_gl);
 		ip->i_gl = NULL;
 		if (ip->i_iopen_gh.gh_gl) {
@@ -422,8 +419,6 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		seq_printf(s, ",debug");
 	if (args->ar_upgrade)
 		seq_printf(s, ",upgrade");
-	if (args->ar_num_glockd != GFS2_GLOCKD_DEFAULT)
-		seq_printf(s, ",num_glockd=%u", args->ar_num_glockd);
 	if (args->ar_posix_acl)
 		seq_printf(s, ",acl");
 	if (args->ar_quota != GFS2_QUOTA_DEFAULT) {
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 59e36fd..67ba5b7 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -263,7 +263,6 @@ ARGS_ATTR(localcaching,    "%d\n");
 ARGS_ATTR(localflocks,     "%d\n");
 ARGS_ATTR(debug,           "%d\n");
 ARGS_ATTR(upgrade,         "%d\n");
-ARGS_ATTR(num_glockd,      "%u\n");
 ARGS_ATTR(posix_acl,       "%d\n");
 ARGS_ATTR(quota,           "%u\n");
 ARGS_ATTR(suiddir,         "%d\n");
@@ -279,7 +278,6 @@ static struct attribute *args_attrs[] = {
 	&args_attr_localflocks.attr,
 	&args_attr_debug.attr,
 	&args_attr_upgrade.attr,
-	&args_attr_num_glockd.attr,
 	&args_attr_posix_acl.attr,
 	&args_attr_quota.attr,
 	&args_attr_suiddir.attr,
@@ -288,30 +286,6 @@ static struct attribute *args_attrs[] = {
 };
 
 /*
- * display counters from superblock
- */
-
-struct counters_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct gfs2_sbd *, char *);
-};
-
-#define COUNTERS_ATTR(name, fmt)                                            \
-static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                 \
-{                                                                           \
-	return snprintf(buf, PAGE_SIZE, fmt,                                \
-			(unsigned int)atomic_read(&sdp->sd_##name));        \
-}                                                                           \
-static struct counters_attr counters_attr_##name = __ATTR_RO(name)
-
-COUNTERS_ATTR(reclaimed,        "%u\n");
-
-static struct attribute *counters_attrs[] = {
-	&counters_attr_reclaimed.attr,
-	NULL,
-};
-
-/*
  * get and set struct gfs2_tune fields
  */
 
@@ -393,7 +367,6 @@ static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)\
 }                                                                             \
 TUNE_ATTR_2(name, name##_store)
 
-TUNE_ATTR(demote_secs, 0);
 TUNE_ATTR(incore_log_blocks, 0);
 TUNE_ATTR(log_flush_secs, 0);
 TUNE_ATTR(quota_warn_period, 0);
@@ -411,7 +384,6 @@ TUNE_ATTR_DAEMON(logd_secs, logd_process);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
 static struct attribute *tune_attrs[] = {
-	&tune_attr_demote_secs.attr,
 	&tune_attr_incore_log_blocks.attr,
 	&tune_attr_log_flush_secs.attr,
 	&tune_attr_quota_warn_period.attr,
@@ -435,11 +407,6 @@ static struct attribute_group lockstruct_group = {
 	.attrs = lockstruct_attrs,
 };
 
-static struct attribute_group counters_group = {
-	.name = "counters",
-	.attrs = counters_attrs,
-};
-
 static struct attribute_group args_group = {
 	.name = "args",
 	.attrs = args_attrs,
@@ -464,13 +431,9 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail_reg;
 
-	error = sysfs_create_group(&sdp->sd_kobj, &counters_group);
-	if (error)
-		goto fail_lockstruct;
-
 	error = sysfs_create_group(&sdp->sd_kobj, &args_group);
 	if (error)
-		goto fail_counters;
+		goto fail_lockstruct;
 
 	error = sysfs_create_group(&sdp->sd_kobj, &tune_group);
 	if (error)
@@ -481,8 +444,6 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 
 fail_args:
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
-fail_counters:
-	sysfs_remove_group(&sdp->sd_kobj, &counters_group);
 fail_lockstruct:
 	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
 fail_reg:
@@ -496,7 +457,6 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 {
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
-	sysfs_remove_group(&sdp->sd_kobj, &counters_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
 	kobject_put(&sdp->sd_kobj);
 }
-- 
1.6.0.3

