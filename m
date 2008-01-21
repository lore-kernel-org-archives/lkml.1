Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYAUKJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYAUKJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759665AbYAUKCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759557AbYAUKCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:23 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/58] [GFS2] Use atomic_t for journal free blocks counter
Date: Mon, 21 Jan 2008 09:21:38 +0000
Message-Id: <12009073753723-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907374616-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
Message-Id: <c8ee33b1cb02b568a26a56d4fb46920578b509e4.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch changes the counter which keeps track of the free
blocks in the journal to an atomic_t in preparation for the
following patch which will update the log reservation code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 911822d..7ae0206 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -595,7 +595,7 @@ struct gfs2_sbd {
 	struct list_head sd_log_le_databuf;
 	struct list_head sd_log_le_ordered;
 
-	unsigned int sd_log_blks_free;
+	atomic_t sd_log_blks_free;
 	struct mutex sd_log_reserve_mutex;
 
 	u64 sd_log_sequence;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index d246843..9192398 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -301,7 +301,7 @@ int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 
 	mutex_lock(&sdp->sd_log_reserve_mutex);
 	gfs2_log_lock(sdp);
-	while(sdp->sd_log_blks_free <= (blks + reserved_blks)) {
+	while(atomic_read(&sdp->sd_log_blks_free) <= (blks + reserved_blks)) {
 		gfs2_log_unlock(sdp);
 		gfs2_ail1_empty(sdp, 0);
 		gfs2_log_flush(sdp, NULL);
@@ -310,7 +310,7 @@ int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 			gfs2_ail1_start(sdp, 0);
 		gfs2_log_lock(sdp);
 	}
-	sdp->sd_log_blks_free -= blks;
+	atomic_sub(blks, &sdp->sd_log_blks_free);
 	gfs2_log_unlock(sdp);
 	mutex_unlock(&sdp->sd_log_reserve_mutex);
 
@@ -330,9 +330,9 @@ void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 {
 
 	gfs2_log_lock(sdp);
-	sdp->sd_log_blks_free += blks;
+	atomic_add(blks, &sdp->sd_log_blks_free);
 	gfs2_assert_withdraw(sdp,
-			     sdp->sd_log_blks_free <= sdp->sd_jdesc->jd_blocks);
+			     atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
 	gfs2_log_unlock(sdp);
 	up_read(&sdp->sd_log_flush_lock);
 }
@@ -559,8 +559,8 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 	ail2_empty(sdp, new_tail);
 
 	gfs2_log_lock(sdp);
-	sdp->sd_log_blks_free += dist;
-	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_free <= sdp->sd_jdesc->jd_blocks);
+	atomic_add(dist, &sdp->sd_log_blks_free);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
 	gfs2_log_unlock(sdp);
 
 	sdp->sd_log_tail = new_tail;
@@ -733,7 +733,7 @@ void __gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 		log_flush_commit(sdp);
 	else if (sdp->sd_log_tail != current_tail(sdp) && !sdp->sd_log_idle){
 		gfs2_log_lock(sdp);
-		sdp->sd_log_blks_free--; /* Adjust for unreserved buffer */
+		atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
 		gfs2_log_unlock(sdp);
 		log_write_header(sdp, 0, PULL);
 	}
@@ -773,12 +773,12 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	sdp->sd_log_commited_revoke += tr->tr_num_revoke - tr->tr_num_revoke_rm;
 	gfs2_assert_withdraw(sdp, ((int)sdp->sd_log_commited_revoke) >= 0);
 	reserved = calc_reserved(sdp);
-	old = sdp->sd_log_blks_free;
-	sdp->sd_log_blks_free += tr->tr_reserved -
-				 (reserved - sdp->sd_log_blks_reserved);
+	old = atomic_read(&sdp->sd_log_blks_free);
+	atomic_add(tr->tr_reserved - (reserved - sdp->sd_log_blks_reserved),
+		   &sdp->sd_log_blks_free);
 
-	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_free >= old);
-	gfs2_assert_withdraw(sdp, sdp->sd_log_blks_free <=
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) >= old);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
 			     sdp->sd_jdesc->jd_blocks);
 
 	sdp->sd_log_blks_reserved = reserved;
@@ -831,7 +831,7 @@ void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 	log_write_header(sdp, GFS2_LOG_HEAD_UNMOUNT,
 			 (sdp->sd_log_tail == current_tail(sdp)) ? 0 : PULL);
 
-	gfs2_assert_warn(sdp, sdp->sd_log_blks_free == sdp->sd_jdesc->jd_blocks);
+	gfs2_assert_warn(sdp, atomic_read(&sdp->sd_log_blks_free) == sdp->sd_jdesc->jd_blocks);
 	gfs2_assert_warn(sdp, sdp->sd_log_head == sdp->sd_log_tail);
 	gfs2_assert_warn(sdp, list_empty(&sdp->sd_ail2_list));
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 52aaba9..1bba6ac 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -339,7 +339,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 
 	if (sdp->sd_args.ar_spectator) {
 		sdp->sd_jdesc = gfs2_jdesc_find(sdp, 0);
-		sdp->sd_log_blks_free = sdp->sd_jdesc->jd_blocks;
+		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
 	} else {
 		if (sdp->sd_lockstruct.ls_jid >= gfs2_jindex_size(sdp)) {
 			fs_err(sdp, "can't mount journal #%u\n",
@@ -376,7 +376,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 			       sdp->sd_jdesc->jd_jid, error);
 			goto fail_jinode_gh;
 		}
-		sdp->sd_log_blks_free = sdp->sd_jdesc->jd_blocks;
+		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
 	}
 
 	if (sdp->sd_lockstruct.ls_first) {
-- 
1.5.1.2

