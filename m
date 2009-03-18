Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZCRN1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZCRN1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZCRN0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683AbZCRN0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:39 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Abhijith Das <adas@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/18] GFS2: change gfs2_quota_scan into a shrinker
Date: Wed, 18 Mar 2009 12:23:38 +0000
Message-Id: <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

Deallocation of gfs2_quota_data objects now happens on-demand through a
shrinker instead of routinely deallocating through the quotad daemon.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 608849d..592aa50 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -283,7 +283,9 @@ enum {
 
 struct gfs2_quota_data {
 	struct list_head qd_list;
-	unsigned int qd_count;
+	struct list_head qd_reclaim;
+
+	atomic_t qd_count;
 
 	u32 qd_id;
 	unsigned long qd_flags;		/* QDF_... */
@@ -303,7 +305,6 @@ struct gfs2_quota_data {
 
 	u64 qd_sync_gen;
 	unsigned long qd_last_warn;
-	unsigned long qd_last_touched;
 };
 
 struct gfs2_trans {
@@ -406,7 +407,6 @@ struct gfs2_tune {
 	unsigned int gt_quota_warn_period; /* Secs between quota warn msgs */
 	unsigned int gt_quota_scale_num; /* Numerator */
 	unsigned int gt_quota_scale_den; /* Denominator */
-	unsigned int gt_quota_cache_secs;
 	unsigned int gt_quota_quantum; /* Secs between syncs to quota file */
 	unsigned int gt_new_files_jdata;
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 7cacfde..86fe067 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -23,6 +23,12 @@
 #include "sys.h"
 #include "util.h"
 #include "glock.h"
+#include "quota.h"
+
+static struct shrinker qd_shrinker = {
+	.shrink = gfs2_shrink_qd_memory,
+	.seeks = DEFAULT_SEEKS,
+};
 
 static void gfs2_init_inode_once(void *foo)
 {
@@ -100,6 +106,8 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_quotad_cachep)
 		goto fail;
 
+	register_shrinker(&qd_shrinker);
+
 	error = register_filesystem(&gfs2_fs_type);
 	if (error)
 		goto fail;
@@ -117,6 +125,7 @@ static int __init init_gfs2_fs(void)
 fail_unregister:
 	unregister_filesystem(&gfs2_fs_type);
 fail:
+	unregister_shrinker(&qd_shrinker);
 	gfs2_glock_exit();
 
 	if (gfs2_quotad_cachep)
@@ -145,6 +154,7 @@ fail:
 
 static void __exit exit_gfs2_fs(void)
 {
+	unregister_shrinker(&qd_shrinker);
 	gfs2_glock_exit();
 	gfs2_unregister_debugfs();
 	unregister_filesystem(&gfs2_fs_type);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 4ddab67..dde4ead 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -442,6 +442,7 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 	 */
 	if (unlikely(page->index)) {
 		zero_user(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
 		return 0;
 	}
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3eb49ed..530d3f6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -63,7 +63,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_quota_warn_period = 10;
 	gt->gt_quota_scale_num = 1;
 	gt->gt_quota_scale_den = 1;
-	gt->gt_quota_cache_secs = 300;
 	gt->gt_quota_quantum = 60;
 	gt->gt_new_files_jdata = 0;
 	gt->gt_max_readahead = 1 << 18;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index b08d096..2ada6e1 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -80,6 +80,53 @@ struct gfs2_quota_change_host {
 	u32 qc_id;
 };
 
+static LIST_HEAD(qd_lru_list);
+static atomic_t qd_lru_count = ATOMIC_INIT(0);
+static spinlock_t qd_lru_lock = SPIN_LOCK_UNLOCKED;
+
+int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask)
+{
+	struct gfs2_quota_data *qd;
+	struct gfs2_sbd *sdp;
+
+	if (nr == 0)
+		goto out;
+
+	if (!(gfp_mask & __GFP_FS))
+		return -1;
+
+	spin_lock(&qd_lru_lock);
+	while (nr && !list_empty(&qd_lru_list)) {
+		qd = list_entry(qd_lru_list.next,
+				struct gfs2_quota_data, qd_reclaim);
+		sdp = qd->qd_gl->gl_sbd;
+
+		/* Free from the filesystem-specific list */
+		list_del(&qd->qd_list);
+
+		spin_lock(&sdp->sd_quota_spin);
+		gfs2_assert_warn(sdp, !qd->qd_change);
+		gfs2_assert_warn(sdp, !qd->qd_slot_count);
+		gfs2_assert_warn(sdp, !qd->qd_bh_count);
+
+		gfs2_lvb_unhold(qd->qd_gl);
+		spin_unlock(&sdp->sd_quota_spin);
+		atomic_dec(&sdp->sd_quota_count);
+
+		/* Delete it from the common reclaim list */
+		list_del_init(&qd->qd_reclaim);
+		atomic_dec(&qd_lru_count);
+		spin_unlock(&qd_lru_lock);
+		kmem_cache_free(gfs2_quotad_cachep, qd);
+		spin_lock(&qd_lru_lock);
+		nr--;
+	}
+	spin_unlock(&qd_lru_lock);
+
+out:
+	return (atomic_read(&qd_lru_count) * sysctl_vfs_cache_pressure) / 100;
+}
+
 static u64 qd2offset(struct gfs2_quota_data *qd)
 {
 	u64 offset;
@@ -100,11 +147,12 @@ static int qd_alloc(struct gfs2_sbd *sdp, int user, u32 id,
 	if (!qd)
 		return -ENOMEM;
 
-	qd->qd_count = 1;
+	atomic_set(&qd->qd_count, 1);
 	qd->qd_id = id;
 	if (user)
 		set_bit(QDF_USER, &qd->qd_flags);
 	qd->qd_slot = -1;
+	INIT_LIST_HEAD(&qd->qd_reclaim);
 
 	error = gfs2_glock_get(sdp, 2 * (u64)id + !user,
 			      &gfs2_quota_glops, CREATE, &qd->qd_gl);
@@ -135,11 +183,17 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
 
 	for (;;) {
 		found = 0;
-		spin_lock(&sdp->sd_quota_spin);
+		spin_lock(&qd_lru_lock);
 		list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
 			if (qd->qd_id == id &&
 			    !test_bit(QDF_USER, &qd->qd_flags) == !user) {
-				qd->qd_count++;
+				if (!atomic_read(&qd->qd_count) &&
+				    !list_empty(&qd->qd_reclaim)) {
+					/* Remove it from reclaim list */
+					list_del_init(&qd->qd_reclaim);
+					atomic_dec(&qd_lru_count);
+				}
+				atomic_inc(&qd->qd_count);
 				found = 1;
 				break;
 			}
@@ -155,7 +209,7 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
 			new_qd = NULL;
 		}
 
-		spin_unlock(&sdp->sd_quota_spin);
+		spin_unlock(&qd_lru_lock);
 
 		if (qd || !create) {
 			if (new_qd) {
@@ -175,21 +229,18 @@ static int qd_get(struct gfs2_sbd *sdp, int user, u32 id, int create,
 static void qd_hold(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
-
-	spin_lock(&sdp->sd_quota_spin);
-	gfs2_assert(sdp, qd->qd_count);
-	qd->qd_count++;
-	spin_unlock(&sdp->sd_quota_spin);
+	gfs2_assert(sdp, atomic_read(&qd->qd_count));
+	atomic_inc(&qd->qd_count);
 }
 
 static void qd_put(struct gfs2_quota_data *qd)
 {
-	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
-	spin_lock(&sdp->sd_quota_spin);
-	gfs2_assert(sdp, qd->qd_count);
-	if (!--qd->qd_count)
-		qd->qd_last_touched = jiffies;
-	spin_unlock(&sdp->sd_quota_spin);
+	if (atomic_dec_and_lock(&qd->qd_count, &qd_lru_lock)) {
+		/* Add to the reclaim list */
+		list_add_tail(&qd->qd_reclaim, &qd_lru_list);
+		atomic_inc(&qd_lru_count);
+		spin_unlock(&qd_lru_lock);
+	}
 }
 
 static int slot_get(struct gfs2_quota_data *qd)
@@ -330,6 +381,7 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	if (sdp->sd_vfs->s_flags & MS_RDONLY)
 		return 0;
 
+	spin_lock(&qd_lru_lock);
 	spin_lock(&sdp->sd_quota_spin);
 
 	list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
@@ -341,8 +393,8 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 		list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
 
 		set_bit(QDF_LOCKED, &qd->qd_flags);
-		gfs2_assert_warn(sdp, qd->qd_count);
-		qd->qd_count++;
+		gfs2_assert_warn(sdp, atomic_read(&qd->qd_count));
+		atomic_inc(&qd->qd_count);
 		qd->qd_change_sync = qd->qd_change;
 		gfs2_assert_warn(sdp, qd->qd_slot_count);
 		qd->qd_slot_count++;
@@ -355,6 +407,7 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 		qd = NULL;
 
 	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 
 	if (qd) {
 		gfs2_assert_warn(sdp, qd->qd_change_sync);
@@ -379,24 +432,27 @@ static int qd_trylock(struct gfs2_quota_data *qd)
 	if (sdp->sd_vfs->s_flags & MS_RDONLY)
 		return 0;
 
+	spin_lock(&qd_lru_lock);
 	spin_lock(&sdp->sd_quota_spin);
 
 	if (test_bit(QDF_LOCKED, &qd->qd_flags) ||
 	    !test_bit(QDF_CHANGE, &qd->qd_flags)) {
 		spin_unlock(&sdp->sd_quota_spin);
+		spin_unlock(&qd_lru_lock);
 		return 0;
 	}
 
 	list_move_tail(&qd->qd_list, &sdp->sd_quota_list);
 
 	set_bit(QDF_LOCKED, &qd->qd_flags);
-	gfs2_assert_warn(sdp, qd->qd_count);
-	qd->qd_count++;
+	gfs2_assert_warn(sdp, atomic_read(&qd->qd_count));
+	atomic_inc(&qd->qd_count);
 	qd->qd_change_sync = qd->qd_change;
 	gfs2_assert_warn(sdp, qd->qd_slot_count);
 	qd->qd_slot_count++;
 
 	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 
 	gfs2_assert_warn(sdp, qd->qd_change_sync);
 	if (bh_get(qd)) {
@@ -802,8 +858,8 @@ restart:
 		loff_t pos;
 		gfs2_glock_dq_uninit(q_gh);
 		error = gfs2_glock_nq_init(qd->qd_gl,
-					  LM_ST_EXCLUSIVE, GL_NOCACHE,
-					  q_gh);
+					   LM_ST_EXCLUSIVE, GL_NOCACHE,
+					   q_gh);
 		if (error)
 			return error;
 
@@ -820,7 +876,6 @@ restart:
 
 		gfs2_glock_dq_uninit(&i_gh);
 
-
 		gfs2_quota_in(&q, buf);
 		qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
 		qlvb->qb_magic = cpu_to_be32(GFS2_MAGIC);
@@ -1171,13 +1226,14 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 			qd->qd_change = qc.qc_change;
 			qd->qd_slot = slot;
 			qd->qd_slot_count = 1;
-			qd->qd_last_touched = jiffies;
 
+			spin_lock(&qd_lru_lock);
 			spin_lock(&sdp->sd_quota_spin);
 			gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, slot, 1);
+			spin_unlock(&sdp->sd_quota_spin);
 			list_add(&qd->qd_list, &sdp->sd_quota_list);
 			atomic_inc(&sdp->sd_quota_count);
-			spin_unlock(&sdp->sd_quota_spin);
+			spin_unlock(&qd_lru_lock);
 
 			found++;
 		}
@@ -1197,61 +1253,39 @@ fail:
 	return error;
 }
 
-static void gfs2_quota_scan(struct gfs2_sbd *sdp)
-{
-	struct gfs2_quota_data *qd, *safe;
-	LIST_HEAD(dead);
-
-	spin_lock(&sdp->sd_quota_spin);
-	list_for_each_entry_safe(qd, safe, &sdp->sd_quota_list, qd_list) {
-		if (!qd->qd_count &&
-		    time_after_eq(jiffies, qd->qd_last_touched +
-			        gfs2_tune_get(sdp, gt_quota_cache_secs) * HZ)) {
-			list_move(&qd->qd_list, &dead);
-			gfs2_assert_warn(sdp,
-					 atomic_read(&sdp->sd_quota_count) > 0);
-			atomic_dec(&sdp->sd_quota_count);
-		}
-	}
-	spin_unlock(&sdp->sd_quota_spin);
-
-	while (!list_empty(&dead)) {
-		qd = list_entry(dead.next, struct gfs2_quota_data, qd_list);
-		list_del(&qd->qd_list);
-
-		gfs2_assert_warn(sdp, !qd->qd_change);
-		gfs2_assert_warn(sdp, !qd->qd_slot_count);
-		gfs2_assert_warn(sdp, !qd->qd_bh_count);
-
-		gfs2_lvb_unhold(qd->qd_gl);
-		kmem_cache_free(gfs2_quotad_cachep, qd);
-	}
-}
-
 void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 {
 	struct list_head *head = &sdp->sd_quota_list;
 	struct gfs2_quota_data *qd;
 	unsigned int x;
 
-	spin_lock(&sdp->sd_quota_spin);
+	spin_lock(&qd_lru_lock);
 	while (!list_empty(head)) {
 		qd = list_entry(head->prev, struct gfs2_quota_data, qd_list);
 
-		if (qd->qd_count > 1 ||
-		    (qd->qd_count && !test_bit(QDF_CHANGE, &qd->qd_flags))) {
-			list_move(&qd->qd_list, head);
+		spin_lock(&sdp->sd_quota_spin);
+		if (atomic_read(&qd->qd_count) > 1 ||
+		    (atomic_read(&qd->qd_count) &&
+		     !test_bit(QDF_CHANGE, &qd->qd_flags))) {
 			spin_unlock(&sdp->sd_quota_spin);
+			list_move(&qd->qd_list, head);
+			spin_unlock(&qd_lru_lock);
 			schedule();
-			spin_lock(&sdp->sd_quota_spin);
+			spin_lock(&qd_lru_lock);
 			continue;
 		}
+		spin_unlock(&sdp->sd_quota_spin);
 
 		list_del(&qd->qd_list);
+		/* Also remove if this qd exists in the reclaim list */
+		if (!list_empty(&qd->qd_reclaim)) {
+			list_del_init(&qd->qd_reclaim);
+			atomic_dec(&qd_lru_count);
+		}
 		atomic_dec(&sdp->sd_quota_count);
-		spin_unlock(&sdp->sd_quota_spin);
+		spin_unlock(&qd_lru_lock);
 
-		if (!qd->qd_count) {
+		if (!atomic_read(&qd->qd_count)) {
 			gfs2_assert_warn(sdp, !qd->qd_change);
 			gfs2_assert_warn(sdp, !qd->qd_slot_count);
 		} else
@@ -1261,9 +1295,9 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 		gfs2_lvb_unhold(qd->qd_gl);
 		kmem_cache_free(gfs2_quotad_cachep, qd);
 
-		spin_lock(&sdp->sd_quota_spin);
+		spin_lock(&qd_lru_lock);
 	}
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 
 	gfs2_assert_warn(sdp, !atomic_read(&sdp->sd_quota_count));
 
@@ -1341,9 +1375,6 @@ int gfs2_quotad(void *data)
 		quotad_check_timeo(sdp, "sync", gfs2_quota_sync, t,
 				   &quotad_timeo, &tune->gt_quota_quantum);
 
-		/* FIXME: This should be turned into a shrinker */
-		gfs2_quota_scan(sdp);
-
 		/* Check for & recover partially truncated inodes */
 		quotad_check_trunc_list(sdp);
 
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index cec9032..0fa5fa6 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -49,4 +49,6 @@ static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
 	return ret;
 }
 
+extern int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask);
+
 #endif /* __QUOTA_DOT_H__ */
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 26c1fa7..a58a120 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -373,7 +373,6 @@ TUNE_ATTR(complain_secs, 0);
 TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(quota_simul_sync, 1);
-TUNE_ATTR(quota_cache_secs, 1);
 TUNE_ATTR(stall_secs, 1);
 TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_DAEMON(recoverd_secs, recoverd_process);
@@ -389,7 +388,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_complain_secs.attr,
 	&tune_attr_statfs_slow.attr,
 	&tune_attr_quota_simul_sync.attr,
-	&tune_attr_quota_cache_secs.attr,
 	&tune_attr_stall_secs.attr,
 	&tune_attr_statfs_quantum.attr,
 	&tune_attr_recoverd_secs.attr,
-- 
1.6.0.3

