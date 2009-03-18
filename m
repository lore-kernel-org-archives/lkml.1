Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbZCRN2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbZCRN2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZCRN0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312AbZCRN0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:40 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>,
       Abhijith Das <adas@redhat.com>
Subject: [PATCH 04/18] GFS2: Remove "double" locking in quota
Date: Wed, 18 Mar 2009 12:23:39 +0000
Message-Id: <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We only really need a single spin lock for the quota data, so
lets just use the lru lock for now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 592aa50..a0117d6 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -540,7 +540,6 @@ struct gfs2_sbd {
 
 	struct list_head sd_quota_list;
 	atomic_t sd_quota_count;
-	spinlock_t sd_quota_spin;
 	struct mutex sd_quota_mutex;
 	wait_queue_head_t sd_quota_wait;
 	struct list_head sd_trunc_list;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 530d3f6..402b6a2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -98,7 +98,6 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	mutex_init(&sdp->sd_jindex_mutex);
 
 	INIT_LIST_HEAD(&sdp->sd_quota_list);
-	spin_lock_init(&sdp->sd_quota_spin);
 	mutex_init(&sdp->sd_quota_mutex);
 	init_waitqueue_head(&sdp->sd_quota_wait);
 	INIT_LIST_HEAD(&sdp->sd_trunc_list);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 2ada6e1..e8ef0f8 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -104,13 +104,11 @@ int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask)
 		/* Free from the filesystem-specific list */
 		list_del(&qd->qd_list);
 
-		spin_lock(&sdp->sd_quota_spin);
 		gfs2_assert_warn(sdp, !qd->qd_change);
 		gfs2_assert_warn(sdp, !qd->qd_slot_count);
 		gfs2_assert_warn(sdp, !qd->qd_bh_count);
 
 		gfs2_lvb_unhold(qd->qd_gl);
-		spin_unlock(&sdp->sd_quota_spin);
 		atomic_dec(&sdp->sd_quota_count);
 
 		/* Delete it from the common reclaim list */
@@ -249,10 +247,10 @@ static int slot_get(struct gfs2_quota_data *qd)
 	unsigned int c, o = 0, b;
 	unsigned char byte = 0;
 
-	spin_lock(&sdp->sd_quota_spin);
+	spin_lock(&qd_lru_lock);
 
 	if (qd->qd_slot_count++) {
-		spin_unlock(&sdp->sd_quota_spin);
+		spin_unlock(&qd_lru_lock);
 		return 0;
 	}
 
@@ -276,13 +274,13 @@ found:
 
 	sdp->sd_quota_bitmap[c][o] |= 1 << b;
 
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 
 	return 0;
 
 fail:
 	qd->qd_slot_count--;
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 	return -ENOSPC;
 }
 
@@ -290,23 +288,23 @@ static void slot_hold(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	spin_lock(&sdp->sd_quota_spin);
+	spin_lock(&qd_lru_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	qd->qd_slot_count++;
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 }
 
 static void slot_put(struct gfs2_quota_data *qd)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	spin_lock(&sdp->sd_quota_spin);
+	spin_lock(&qd_lru_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	if (!--qd->qd_slot_count) {
 		gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, qd->qd_slot, 0);
 		qd->qd_slot = -1;
 	}
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 }
 
 static int bh_get(struct gfs2_quota_data *qd)
@@ -382,7 +380,6 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 		return 0;
 
 	spin_lock(&qd_lru_lock);
-	spin_lock(&sdp->sd_quota_spin);
 
 	list_for_each_entry(qd, &sdp->sd_quota_list, qd_list) {
 		if (test_bit(QDF_LOCKED, &qd->qd_flags) ||
@@ -406,7 +403,6 @@ static int qd_fish(struct gfs2_sbd *sdp, struct gfs2_quota_data **qdp)
 	if (!found)
 		qd = NULL;
 
-	spin_unlock(&sdp->sd_quota_spin);
 	spin_unlock(&qd_lru_lock);
 
 	if (qd) {
@@ -433,11 +429,9 @@ static int qd_trylock(struct gfs2_quota_data *qd)
 		return 0;
 
 	spin_lock(&qd_lru_lock);
-	spin_lock(&sdp->sd_quota_spin);
 
 	if (test_bit(QDF_LOCKED, &qd->qd_flags) ||
 	    !test_bit(QDF_CHANGE, &qd->qd_flags)) {
-		spin_unlock(&sdp->sd_quota_spin);
 		spin_unlock(&qd_lru_lock);
 		return 0;
 	}
@@ -451,7 +445,6 @@ static int qd_trylock(struct gfs2_quota_data *qd)
 	gfs2_assert_warn(sdp, qd->qd_slot_count);
 	qd->qd_slot_count++;
 
-	spin_unlock(&sdp->sd_quota_spin);
 	spin_unlock(&qd_lru_lock);
 
 	gfs2_assert_warn(sdp, qd->qd_change_sync);
@@ -612,9 +605,9 @@ static void do_qc(struct gfs2_quota_data *qd, s64 change)
 	x = be64_to_cpu(qc->qc_change) + change;
 	qc->qc_change = cpu_to_be64(x);
 
-	spin_lock(&sdp->sd_quota_spin);
+	spin_lock(&qd_lru_lock);
 	qd->qd_change = x;
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 
 	if (!x) {
 		gfs2_assert_warn(sdp, test_bit(QDF_CHANGE, &qd->qd_flags));
@@ -945,9 +938,9 @@ static int need_sync(struct gfs2_quota_data *qd)
 	if (!qd->qd_qb.qb_limit)
 		return 0;
 
-	spin_lock(&sdp->sd_quota_spin);
+	spin_lock(&qd_lru_lock);
 	value = qd->qd_change;
-	spin_unlock(&sdp->sd_quota_spin);
+	spin_unlock(&qd_lru_lock);
 
 	spin_lock(&gt->gt_spin);
 	num = gt->gt_quota_scale_num;
@@ -1040,9 +1033,9 @@ int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid)
 			continue;
 
 		value = (s64)be64_to_cpu(qd->qd_qb.qb_value);
-		spin_lock(&sdp->sd_quota_spin);
+		spin_lock(&qd_lru_lock);
 		value += qd->qd_change;
-		spin_unlock(&sdp->sd_quota_spin);
+		spin_unlock(&qd_lru_lock);
 
 		if (be64_to_cpu(qd->qd_qb.qb_limit) && (s64)be64_to_cpu(qd->qd_qb.qb_limit) < value) {
 			print_message(qd, "exceeded");
@@ -1228,9 +1221,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 			qd->qd_slot_count = 1;
 
 			spin_lock(&qd_lru_lock);
-			spin_lock(&sdp->sd_quota_spin);
 			gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, slot, 1);
-			spin_unlock(&sdp->sd_quota_spin);
 			list_add(&qd->qd_list, &sdp->sd_quota_list);
 			atomic_inc(&sdp->sd_quota_count);
 			spin_unlock(&qd_lru_lock);
@@ -1263,18 +1254,15 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 	while (!list_empty(head)) {
 		qd = list_entry(head->prev, struct gfs2_quota_data, qd_list);
 
-		spin_lock(&sdp->sd_quota_spin);
 		if (atomic_read(&qd->qd_count) > 1 ||
 		    (atomic_read(&qd->qd_count) &&
 		     !test_bit(QDF_CHANGE, &qd->qd_flags))) {
-			spin_unlock(&sdp->sd_quota_spin);
 			list_move(&qd->qd_list, head);
 			spin_unlock(&qd_lru_lock);
 			schedule();
 			spin_lock(&qd_lru_lock);
 			continue;
 		}
-		spin_unlock(&sdp->sd_quota_spin);
 
 		list_del(&qd->qd_list);
 		/* Also remove if this qd exists in the reclaim list */
-- 
1.6.0.3

