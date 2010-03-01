Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0CAPTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:19:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0CAPRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:17:55 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/5] GFS2: Remove loopy umount code
Date: Mon,  1 Mar 2010 15:08:23 +0000
Message-Id: <1267456106-3084-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1267456106-3084-2-git-send-email-swhiteho@redhat.com>
References: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a consequence of the previous patch, we can now remove the
loop which used to be required due to the circular dependency
between the inodes and glocks. Instead we can just invalidate
the inodes, and then clear up any glocks which are left.

Also we no longer need the rwsem since there is no longer any
danger of the inode invalidation calling back into the glock
code (and from there back into the inode code).

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c      |   33 ++-------------------------------
 fs/gfs2/incore.h     |    1 -
 fs/gfs2/ops_fstype.c |    4 +---
 fs/gfs2/super.c      |    1 +
 fs/gfs2/sys.c        |    2 --
 5 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index dfb10a4..4773f90 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -19,7 +19,6 @@
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/module.h>
-#include <linux/rwsem.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
@@ -60,7 +59,6 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
 #define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { __dump_glock(NULL, gl); BUG(); } } while(0)
 static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
 
-static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
 static struct workqueue_struct *glock_workqueue;
 struct workqueue_struct *gfs2_delete_workqueue;
@@ -714,7 +712,6 @@ static void glock_work_func(struct work_struct *work)
 		finish_xmote(gl, gl->gl_reply);
 		drop_ref = 1;
 	}
-	down_read(&gfs2_umount_flush_sem);
 	spin_lock(&gl->gl_spin);
 	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
 	    gl->gl_state != LM_ST_UNLOCKED &&
@@ -727,7 +724,6 @@ static void glock_work_func(struct work_struct *work)
 	}
 	run_queue(gl, 0);
 	spin_unlock(&gl->gl_spin);
-	up_read(&gfs2_umount_flush_sem);
 	if (!delay ||
 	    queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
 		gfs2_glock_put(gl);
@@ -1512,35 +1508,10 @@ void gfs2_glock_thaw(struct gfs2_sbd *sdp)
 
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 {
-	unsigned long t;
 	unsigned int x;
-	int cont;
 
-	t = jiffies;
-
-	for (;;) {
-		cont = 0;
-		for (x = 0; x < GFS2_GL_HASH_SIZE; x++) {
-			if (examine_bucket(clear_glock, sdp, x))
-				cont = 1;
-		}
-
-		if (!cont)
-			break;
-
-		if (time_after_eq(jiffies,
-				  t + gfs2_tune_get(sdp, gt_stall_secs) * HZ)) {
-			fs_warn(sdp, "Unmount seems to be stalled. "
-				     "Dumping lock state...\n");
-			gfs2_dump_lockstate(sdp);
-			t = jiffies;
-		}
-
-		down_write(&gfs2_umount_flush_sem);
-		invalidate_inodes(sdp->sd_vfs);
-		up_write(&gfs2_umount_flush_sem);
-		msleep(10);
-	}
+	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
+		examine_bucket(clear_glock, sdp, x);
 	flush_workqueue(glock_workqueue);
 	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
 	gfs2_dump_lockstate(sdp);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 1de7e1b..b8025e5 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -451,7 +451,6 @@ struct gfs2_tune {
 	unsigned int gt_quota_quantum; /* Secs between syncs to quota file */
 	unsigned int gt_new_files_jdata;
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
-	unsigned int gt_stall_secs; /* Detects trouble! */
 	unsigned int gt_complain_secs;
 	unsigned int gt_statfs_quantum;
 	unsigned int gt_statfs_slow;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a86ed63..a054b52 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -65,7 +65,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_quota_scale_den = 1;
 	gt->gt_new_files_jdata = 0;
 	gt->gt_max_readahead = 1 << 18;
-	gt->gt_stall_secs = 600;
 	gt->gt_complain_secs = 10;
 }
 
@@ -1241,10 +1240,9 @@ fail_sb:
 fail_locking:
 	init_locking(sdp, &mount_gh, UNDO);
 fail_lm:
+	invalidate_inodes(sb);
 	gfs2_gl_hash_clear(sdp);
 	gfs2_lm_unmount(sdp);
-	while (invalidate_inodes(sb))
-		yield();
 fail_sys:
 	gfs2_sys_fs_del(sdp);
 fail:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index ad7bc2d..e5e2262 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -859,6 +859,7 @@ restart:
 	gfs2_clear_rgrpd(sdp);
 	gfs2_jindex_free(sdp);
 	/*  Take apart glock structures and buffer lists  */
+	invalidate_inodes(sdp->sd_vfs);
 	gfs2_gl_hash_clear(sdp);
 	/*  Unmount the locking protocol  */
 	gfs2_lm_unmount(sdp);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 0dc3462..a0db1c9 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -478,7 +478,6 @@ TUNE_ATTR(complain_secs, 0);
 TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(quota_simul_sync, 1);
-TUNE_ATTR(stall_secs, 1);
 TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
@@ -491,7 +490,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_complain_secs.attr,
 	&tune_attr_statfs_slow.attr,
 	&tune_attr_quota_simul_sync.attr,
-	&tune_attr_stall_secs.attr,
 	&tune_attr_statfs_quantum.attr,
 	&tune_attr_quota_scale.attr,
 	&tune_attr_new_files_jdata.attr,
-- 
1.6.2.5

