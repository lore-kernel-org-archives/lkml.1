Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760683AbYLQMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbYLQMd4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYLQM30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53743 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbYLQM3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:21 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/24] GFS2: Clean up & move gfs2_quotad
Date: Wed, 17 Dec 2008 11:30:13 +0000
Message-Id: <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch is a clean up of gfs2_quotad prior to giving it an
extra job to do in addition to the current portfolio of updating
the quota and statfs information from time to time.

As a result it has been moved into quota.c allowing one of the
functions it calls to be made static. Also the clean up allows
the two existing functions to have separate timeouts and also
to coexist with its future role of dealing with the "truncate in
progress" inode flag.

The (pointless) setting of gfs2_quotad_secs is removed since we
arrange to only wake up quotad when one of the two timers expires.

In addition the struct gfs2_quota_data is moved into a slab cache,
mainly for easier debugging. It should also be possible to use
a shrinker in the future, rather than the current scheme of scanning
the quota data entries from time to time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/daemon.c b/fs/gfs2/daemon.c
index e519919..5668aa7 100644
--- a/fs/gfs2/daemon.c
+++ b/fs/gfs2/daemon.c
@@ -23,7 +23,6 @@
 #include "daemon.h"
 #include "glock.h"
 #include "log.h"
-#include "quota.h"
 #include "recovery.h"
 #include "super.h"
 #include "util.h"
@@ -82,55 +81,3 @@ int gfs2_recoverd(void *data)
 	return 0;
 }
 
-/**
- * gfs2_quotad - Write cached quota changes into the quota file
- * @sdp: Pointer to GFS2 superblock
- *
- */
-
-int gfs2_quotad(void *data)
-{
-	struct gfs2_sbd *sdp = data;
-	unsigned long t;
-	int error;
-
-	while (!kthread_should_stop()) {
-		/* Update the master statfs file */
-
-		t = sdp->sd_statfs_sync_time +
-		    gfs2_tune_get(sdp, gt_statfs_quantum) * HZ;
-
-		if (time_after_eq(jiffies, t)) {
-			error = gfs2_statfs_sync(sdp);
-			if (error &&
-			    error != -EROFS &&
-			    !test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-				fs_err(sdp, "quotad: (1) error=%d\n", error);
-			sdp->sd_statfs_sync_time = jiffies;
-		}
-
-		/* Update quota file */
-
-		t = sdp->sd_quota_sync_time +
-		    gfs2_tune_get(sdp, gt_quota_quantum) * HZ;
-
-		if (time_after_eq(jiffies, t)) {
-			error = gfs2_quota_sync(sdp);
-			if (error &&
-			    error != -EROFS &&
-			    !test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-				fs_err(sdp, "quotad: (2) error=%d\n", error);
-			sdp->sd_quota_sync_time = jiffies;
-		}
-
-		gfs2_quota_scan(sdp);
-
-		t = gfs2_tune_get(sdp, gt_quotad_secs) * HZ;
-		if (freezing(current))
-			refrigerator();
-		schedule_timeout_interruptible(t);
-	}
-
-	return 0;
-}
-
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9e3b613..cfebc17 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -402,7 +402,6 @@ struct gfs2_tune {
 
 	unsigned int gt_recoverd_secs;
 	unsigned int gt_logd_secs;
-	unsigned int gt_quotad_secs;
 
 	unsigned int gt_quota_simul_sync; /* Max quotavals to sync at once */
 	unsigned int gt_quota_warn_period; /* Secs between quota warn msgs */
@@ -509,7 +508,6 @@ struct gfs2_sbd {
 	spinlock_t sd_statfs_spin;
 	struct gfs2_statfs_change_host sd_statfs_master;
 	struct gfs2_statfs_change_host sd_statfs_local;
-	unsigned long sd_statfs_sync_time;
 
 	/* Resource group stuff */
 
@@ -551,13 +549,13 @@ struct gfs2_sbd {
 	atomic_t sd_quota_count;
 	spinlock_t sd_quota_spin;
 	struct mutex sd_quota_mutex;
+	wait_queue_head_t sd_quota_wait;
 
 	unsigned int sd_quota_slots;
 	unsigned int sd_quota_chunks;
 	unsigned char **sd_quota_bitmap;
 
 	u64 sd_quota_sync_gen;
-	unsigned long sd_quota_sync_time;
 
 	/* Log stuff */
 
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 3eea03c..e3f6f18 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -93,6 +93,12 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_rgrpd_cachep)
 		goto fail;
 
+	gfs2_quotad_cachep = kmem_cache_create("gfs2_quotad",
+					       sizeof(struct gfs2_quota_data),
+					       0, 0, NULL);
+	if (!gfs2_quotad_cachep)
+		goto fail;
+
 	error = register_filesystem(&gfs2_fs_type);
 	if (error)
 		goto fail;
@@ -112,6 +118,9 @@ fail_unregister:
 fail:
 	gfs2_glock_exit();
 
+	if (gfs2_quotad_cachep)
+		kmem_cache_destroy(gfs2_quotad_cachep);
+
 	if (gfs2_rgrpd_cachep)
 		kmem_cache_destroy(gfs2_rgrpd_cachep);
 
@@ -140,6 +149,7 @@ static void __exit exit_gfs2_fs(void)
 	unregister_filesystem(&gfs2_fs_type);
 	unregister_filesystem(&gfs2meta_fs_type);
 
+	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
 	kmem_cache_destroy(gfs2_bufdata_cachep);
 	kmem_cache_destroy(gfs2_inode_cachep);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index dd83e83..5d13706 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -60,7 +60,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_log_flush_secs = 60;
 	gt->gt_recoverd_secs = 60;
 	gt->gt_logd_secs = 1;
-	gt->gt_quotad_secs = 5;
 	gt->gt_quota_simul_sync = 64;
 	gt->gt_quota_warn_period = 10;
 	gt->gt_quota_scale_num = 1;
@@ -107,6 +106,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	INIT_LIST_HEAD(&sdp->sd_quota_list);
 	spin_lock_init(&sdp->sd_quota_spin);
 	mutex_init(&sdp->sd_quota_mutex);
+	init_waitqueue_head(&sdp->sd_quota_wait);
 
 	spin_lock_init(&sdp->sd_log_lock);
 
@@ -970,9 +970,6 @@ static int init_threads(struct gfs2_sbd *sdp, int undo)
 	}
 	sdp->sd_logd_process = p;
 
-	sdp->sd_statfs_sync_time = jiffies;
-	sdp->sd_quota_sync_time = jiffies;
-
 	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
 	error = IS_ERR(p);
 	if (error) {
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 228a465..0cfe44f 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -46,6 +46,8 @@
 #include <linux/bio.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -94,7 +96,7 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 	struct gfs2_quota_data *qd;
 	int error;
 
-	qd = kzalloc(sizeof(struct gfs2_quota_data), GFP_NOFS);
+	qd = kmem_cache_zalloc(gfs2_quotad_cachep, GFP_NOFS);
 	if (!qd)
 		return -ENOMEM;
 
@@ -119,7 +121,7 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 	return 0;
 
 fail:
-	kfree(qd);
+	kmem_cache_free(gfs2_quotad_cachep, qd);
 	return error;
 }
 
@@ -158,7 +160,7 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
 		if (qd || !create) {
 			if (new_qd) {
 				gfs2_lvb_unhold(new_qd->qd_gl);
-				kfree(new_qd);
+				kmem_cache_free(gfs2_quotad_cachep, new_qd);
 			}
 			*qdp = qd;
 			return 0;
@@ -1195,7 +1197,7 @@ fail:
 	return error;
 }
 
-void gfs2_quota_scan(struct gfs2_sbd *sdp)
+static void gfs2_quota_scan(struct gfs2_sbd *sdp)
 {
 	struct gfs2_quota_data *qd, *safe;
 	LIST_HEAD(dead);
@@ -1222,7 +1224,7 @@ void gfs2_quota_scan(struct gfs2_sbd *sdp)
 		gfs2_assert_warn(sdp, !qd->qd_bh_count);
 
 		gfs2_lvb_unhold(qd->qd_gl);
-		kfree(qd);
+		kmem_cache_free(gfs2_quotad_cachep, qd);
 	}
 }
 
@@ -1257,7 +1259,7 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 		gfs2_assert_warn(sdp, !qd->qd_bh_count);
 
 		gfs2_lvb_unhold(qd->qd_gl);
-		kfree(qd);
+		kmem_cache_free(gfs2_quotad_cachep, qd);
 
 		spin_lock(&sdp->sd_quota_spin);
 	}
@@ -1272,3 +1274,65 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 	}
 }
 
+static void quotad_error(struct gfs2_sbd *sdp, const char *msg, int error)
+{
+	if (error == 0 || error == -EROFS)
+		return;
+	if (!test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
+		fs_err(sdp, "gfs2_quotad: %s error %d\n", msg, error);
+}
+
+static void quotad_check_timeo(struct gfs2_sbd *sdp, const char *msg,
+			       int (*fxn)(struct gfs2_sbd *sdp),
+			       unsigned long t, unsigned long *timeo,
+			       unsigned int *new_timeo)
+{
+	if (t >= *timeo) {
+		int error = fxn(sdp);
+		quotad_error(sdp, msg, error);
+		*timeo = gfs2_tune_get_i(&sdp->sd_tune, new_timeo) * HZ;
+	} else {
+		*timeo -= t;
+	}
+}
+
+/**
+ * gfs2_quotad - Write cached quota changes into the quota file
+ * @sdp: Pointer to GFS2 superblock
+ *
+ */
+
+int gfs2_quotad(void *data)
+{
+	struct gfs2_sbd *sdp = data;
+	struct gfs2_tune *tune = &sdp->sd_tune;
+	unsigned long statfs_timeo = 0;
+	unsigned long quotad_timeo = 0;
+	unsigned long t = 0;
+	DEFINE_WAIT(wait);
+
+	while (!kthread_should_stop()) {
+
+		/* Update the master statfs file */
+		quotad_check_timeo(sdp, "statfs", gfs2_statfs_sync, t,
+				   &statfs_timeo, &tune->gt_statfs_quantum);
+
+		/* Update quota file */
+		quotad_check_timeo(sdp, "sync", gfs2_quota_sync, t,
+				   &quotad_timeo, &tune->gt_quota_quantum);
+
+		/* FIXME: This should be turned into a shrinker */
+		gfs2_quota_scan(sdp);
+
+		if (freezing(current))
+			refrigerator();
+		t = min(quotad_timeo, statfs_timeo);
+
+		prepare_to_wait(&sdp->sd_quota_wait, &wait, TASK_UNINTERRUPTIBLE);
+		t -= schedule_timeout(t);
+		finish_wait(&sdp->sd_quota_wait, &wait);
+	}
+
+	return 0;
+}
+
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 3b7f4b0..1d08aee 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -29,7 +29,6 @@ int gfs2_quota_sync(struct gfs2_sbd *sdp);
 int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id);
 
 int gfs2_quota_init(struct gfs2_sbd *sdp);
-void gfs2_quota_scan(struct gfs2_sbd *sdp);
 void gfs2_quota_cleanup(struct gfs2_sbd *sdp);
 
 static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7e1879f..59e36fd 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -408,7 +408,6 @@ TUNE_ATTR(stall_secs, 1);
 TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_DAEMON(recoverd_secs, recoverd_process);
 TUNE_ATTR_DAEMON(logd_secs, logd_process);
-TUNE_ATTR_DAEMON(quotad_secs, quotad_process);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
 static struct attribute *tune_attrs[] = {
@@ -426,7 +425,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_statfs_quantum.attr,
 	&tune_attr_recoverd_secs.attr,
 	&tune_attr_logd_secs.attr,
-	&tune_attr_quotad_secs.attr,
 	&tune_attr_quota_scale.attr,
 	&tune_attr_new_files_jdata.attr,
 	NULL,
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index d31e355..374f50e 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -25,6 +25,7 @@ struct kmem_cache *gfs2_glock_cachep __read_mostly;
 struct kmem_cache *gfs2_inode_cachep __read_mostly;
 struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
 struct kmem_cache *gfs2_rgrpd_cachep __read_mostly;
+struct kmem_cache *gfs2_quotad_cachep __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 7f48576..33e96b0 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -148,6 +148,7 @@ extern struct kmem_cache *gfs2_glock_cachep;
 extern struct kmem_cache *gfs2_inode_cachep;
 extern struct kmem_cache *gfs2_bufdata_cachep;
 extern struct kmem_cache *gfs2_rgrpd_cachep;
+extern struct kmem_cache *gfs2_quotad_cachep;
 
 static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 					   unsigned int *p)
-- 
1.6.0.3

