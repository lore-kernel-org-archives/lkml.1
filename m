Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXJDJV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXJDJV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbXJDJRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759469AbXJDJRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:38 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/51] [GFS2] Reduce number of gfs2_scand processes to one
Date: Thu,  4 Oct 2007 09:49:06 +0100
Message-Id: <11914878141625-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487812928-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We only need a single gfs2_scand process rather than the one
per filesystem which we had previously. As a result the parameter
determining the frequency of gfs2_scand runs becomes a module
parameter rather than a mount parameter as it was before.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/daemon.c b/fs/gfs2/daemon.c
index 3548d9f..3731ab0 100644
--- a/fs/gfs2/daemon.c
+++ b/fs/gfs2/daemon.c
@@ -35,30 +35,6 @@
    The kthread functions used to start these daemons block and flush signals. */
 
 /**
- * gfs2_scand - Look for cached glocks and inodes to toss from memory
- * @sdp: Pointer to GFS2 superblock
- *
- * One of these daemons runs, finding candidates to add to sd_reclaim_list.
- * See gfs2_glockd()
- */
-
-int gfs2_scand(void *data)
-{
-	struct gfs2_sbd *sdp = data;
-	unsigned long t;
-
-	while (!kthread_should_stop()) {
-		gfs2_scand_internal(sdp);
-		t = gfs2_tune_get(sdp, gt_scand_secs) * HZ;
-		if (freezing(current))
-			refrigerator();
-		schedule_timeout_interruptible(t);
-	}
-
-	return 0;
-}
-
-/**
  * gfs2_glockd - Reclaim unused glock structures
  * @sdp: Pointer to GFS2 superblock
  *
diff --git a/fs/gfs2/daemon.h b/fs/gfs2/daemon.h
index 8010071..0de9b35 100644
--- a/fs/gfs2/daemon.h
+++ b/fs/gfs2/daemon.h
@@ -10,7 +10,6 @@
 #ifndef __DAEMON_DOT_H__
 #define __DAEMON_DOT_H__
 
-int gfs2_scand(void *data);
 int gfs2_glockd(void *data);
 int gfs2_recoverd(void *data);
 int gfs2_logd(void *data);
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 0054b7d..559937c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -25,6 +25,8 @@
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -58,6 +60,8 @@ static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh);
 static void gfs2_glock_drop_th(struct gfs2_glock *gl);
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
+static struct task_struct *scand_process;
+static unsigned int scand_secs = 5;
 
 #define GFS2_GL_HASH_SHIFT      15
 #define GFS2_GL_HASH_SIZE       (1 << GFS2_GL_HASH_SHIFT)
@@ -1627,7 +1631,7 @@ static int examine_bucket(glock_examiner examiner, struct gfs2_sbd *sdp,
 		goto out;
 	gl = list_entry(head->first, struct gfs2_glock, gl_list);
 	while(1) {
-		if (gl->gl_sbd == sdp) {
+		if (!sdp || gl->gl_sbd == sdp) {
 			gfs2_glock_hold(gl);
 			read_unlock(gl_lock_addr(hash));
 			if (prev)
@@ -1645,6 +1649,7 @@ out:
 	read_unlock(gl_lock_addr(hash));
 	if (prev)
 		gfs2_glock_put(prev);
+	cond_resched();
 	return has_entries;
 }
 
@@ -1673,20 +1678,6 @@ out_schedule:
 }
 
 /**
- * gfs2_scand_internal - Look for glocks and inodes to toss from memory
- * @sdp: the filesystem
- *
- */
-
-void gfs2_scand_internal(struct gfs2_sbd *sdp)
-{
-	unsigned int x;
-
-	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
-		examine_bucket(scan_glock, sdp, x);
-}
-
-/**
  * clear_glock - look at a glock and see if we can free it from glock cache
  * @gl: the glock to look at
  *
@@ -1973,6 +1964,35 @@ static int gfs2_dump_lockstate(struct gfs2_sbd *sdp)
 	return error;
 }
 
+/**
+ * gfs2_scand - Look for cached glocks and inodes to toss from memory
+ * @sdp: Pointer to GFS2 superblock
+ *
+ * One of these daemons runs, finding candidates to add to sd_reclaim_list.
+ * See gfs2_glockd()
+ */
+
+static int gfs2_scand(void *data)
+{
+	unsigned x;
+	unsigned delay;
+
+	while (!kthread_should_stop()) {
+		for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
+			examine_bucket(scan_glock, NULL, x);
+		if (freezing(current))
+			refrigerator();
+		delay = scand_secs;
+		if (delay < 1)
+			delay = 1;
+		schedule_timeout_interruptible(delay * HZ);
+	}
+
+	return 0;
+}
+
+
+
 int __init gfs2_glock_init(void)
 {
 	unsigned i;
@@ -1984,9 +2004,22 @@ int __init gfs2_glock_init(void)
 		rwlock_init(&gl_hash_locks[i]);
 	}
 #endif
+
+	scand_process = kthread_run(gfs2_scand, NULL, "gfs2_scand");
+	if (IS_ERR(scand_process))
+		return PTR_ERR(scand_process);
+
 	return 0;
 }
 
+void gfs2_glock_exit(void)
+{
+	kthread_stop(scand_process);
+}
+
+module_param(scand_secs, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scand_secs, "The number of seconds between scand runs");
+
 static int gfs2_glock_iter_next(struct glock_iter *gi)
 {
 	struct gfs2_glock *gl;
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 7721ca3..f7a8e62 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -132,11 +132,11 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
 
 void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
-
-void gfs2_scand_internal(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait);
 
 int __init gfs2_glock_init(void);
+void gfs2_glock_exit(void);
+
 int gfs2_create_debugfs_file(struct gfs2_sbd *sdp);
 void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp);
 int gfs2_register_debugfs(void);
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 170ba93..1390b30 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -429,7 +429,6 @@ struct gfs2_tune {
 	unsigned int gt_log_flush_secs;
 	unsigned int gt_jindex_refresh_secs; /* Check for new journal index */
 
-	unsigned int gt_scand_secs;
 	unsigned int gt_recoverd_secs;
 	unsigned int gt_logd_secs;
 	unsigned int gt_quotad_secs;
@@ -574,7 +573,6 @@ struct gfs2_sbd {
 
 	/* Daemon stuff */
 
-	struct task_struct *sd_scand_process;
 	struct task_struct *sd_recoverd_process;
 	struct task_struct *sd_logd_process;
 	struct task_struct *sd_quotad_process;
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index d5d4e68..79c91fd 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -107,6 +107,8 @@ static int __init init_gfs2_fs(void)
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
 fail:
+	gfs2_glock_exit();
+
 	if (gfs2_bufdata_cachep)
 		kmem_cache_destroy(gfs2_bufdata_cachep);
 
@@ -127,6 +129,7 @@ fail:
 
 static void __exit exit_gfs2_fs(void)
 {
+	gfs2_glock_exit();
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9a5e840..58c730b 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -160,14 +160,6 @@ static int init_locking(struct gfs2_sbd *sdp, struct gfs2_holder *mount_gh,
 	if (undo)
 		goto fail_trans;
 
-	p = kthread_run(gfs2_scand, sdp, "gfs2_scand");
-	error = IS_ERR(p);
-	if (error) {
-		fs_err(sdp, "can't start scand thread: %d\n", error);
-		return error;
-	}
-	sdp->sd_scand_process = p;
-
 	for (sdp->sd_glockd_num = 0;
 	     sdp->sd_glockd_num < sdp->sd_args.ar_num_glockd;
 	     sdp->sd_glockd_num++) {
@@ -228,7 +220,6 @@ fail:
 	while (sdp->sd_glockd_num--)
 		kthread_stop(sdp->sd_glockd_process[sdp->sd_glockd_num]);
 
-	kthread_stop(sdp->sd_scand_process);
 	return error;
 }
 
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 603d940..4316690 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -92,7 +92,6 @@ static void gfs2_put_super(struct super_block *sb)
 	kthread_stop(sdp->sd_recoverd_process);
 	while (sdp->sd_glockd_num--)
 		kthread_stop(sdp->sd_glockd_process[sdp->sd_glockd_num]);
-	kthread_stop(sdp->sd_scand_process);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
 		error = gfs2_make_fs_ro(sdp);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f916b97..5589802 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -58,7 +58,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_incore_log_blocks = 1024;
 	gt->gt_log_flush_secs = 60;
 	gt->gt_jindex_refresh_secs = 60;
-	gt->gt_scand_secs = 15;
 	gt->gt_recoverd_secs = 60;
 	gt->gt_logd_secs = 1;
 	gt->gt_quotad_secs = 5;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index c26c21b..ba3a172 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -442,7 +442,6 @@ TUNE_ATTR(quota_simul_sync, 1);
 TUNE_ATTR(quota_cache_secs, 1);
 TUNE_ATTR(stall_secs, 1);
 TUNE_ATTR(statfs_quantum, 1);
-TUNE_ATTR_DAEMON(scand_secs, scand_process);
 TUNE_ATTR_DAEMON(recoverd_secs, recoverd_process);
 TUNE_ATTR_DAEMON(logd_secs, logd_process);
 TUNE_ATTR_DAEMON(quotad_secs, quotad_process);
@@ -464,7 +463,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_quota_cache_secs.attr,
 	&tune_attr_stall_secs.attr,
 	&tune_attr_statfs_quantum.attr,
-	&tune_attr_scand_secs.attr,
 	&tune_attr_recoverd_secs.attr,
 	&tune_attr_logd_secs.attr,
 	&tune_attr_quotad_secs.attr,
-- 
1.5.1.2

