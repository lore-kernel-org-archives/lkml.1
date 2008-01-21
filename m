Return-Path: <linux-kernel-owner+w=401wt.eu-S1763371AbYAUKL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763371AbYAUKL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbYAUKCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758626AbYAUKCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:34 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 26/58] [GFS2] Revise gfs2_logd and flush thresholds
Date: Mon, 21 Jan 2008 09:21:44 +0000
Message-Id: <12009073862261-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073841692-git-send-email-swhiteho@redhat.com>
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
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
Message-Id: <be5784b198847d5cdfa103c6882383c11eb6d7d2.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch intriduces two new log thresholds:

 o thresh1 is the point at which we wake up gfs2_logd due to the pinned
   block count. It is initialised at mount time to 2/5ths of the size
   of the journal. Currently it does not change during the course of
   the mount, but the intention is to adjust it automatically based
   upon various conditions. This automatic adjustment will be the subject
   of later patches.

 o thresh2 is the point at which we wake up gfs2_logd due to the total
   of pinned blocks and AIL blocks. It is initialised at mount time
   to 4/5ths of the size of the journal. The reason for not making it
   equal to 100% of journal size is to give gfs2_logd time to start up
   and do something before the processes filling the journal before
   they land up stalling, and waiting on journal flushes.

At the same time, the incore_log_blocks tunable is removed since it
was wrong (just a basic fixed threshold set to a number plucked out
of the air) and it was being compared against the wrong thing (the
amount of metadata in the journal) rather than the total number of
blocks.

Also, since the free blocks count is now an atomic variable, a
number of these comparisons now do not need locking, so that
the log lock has been removed around some operations.

This patch also ensures that there are no races when gfs2_logd is
woken up. It also changes the behavour of the periodic sync
so that instead of occuring every 60 secs, they will now
occur every 30 secs (which can be set via /sysfs still) if
there have been no other log flushes in the mean time.

When we reserve blocks at the start of a transaction, we now
use a waitqueue too. This means we can remove the old mutex
and the fast path through that code is just a couple of atomic
operations now. Also we no longer do log flushing at this point
in the code. Instead we wake up gfs2_logd to do it for us (this
shouldn't happen if the log is large enough and if gfs2_logd is
properly tuned) and do an exclusive wait.

As a result of these changes, postmark on my test machine runs about
20% faster, mainly due to increased efficiency in flushing the
journal.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 330f4c7..743ebba 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -409,8 +409,6 @@ struct gfs2_tune {
 	spinlock_t gt_spin;
 
 	unsigned int gt_demote_secs; /* Cache retention for unheld glock */
-	unsigned int gt_incore_log_blocks;
-	unsigned int gt_log_flush_secs;
 
 	unsigned int gt_recoverd_secs;
 	unsigned int gt_logd_secs;
@@ -542,7 +540,6 @@ struct gfs2_sbd {
 	spinlock_t sd_jindex_spin;
 	struct mutex sd_jindex_mutex;
 	unsigned int sd_journals;
-	unsigned long sd_jindex_refresh_time;
 
 	struct gfs2_jdesc *sd_jdesc;
 	struct gfs2_holder sd_journal_gh;
@@ -583,6 +580,7 @@ struct gfs2_sbd {
 	unsigned int sd_log_commited_databuf;
 	unsigned int sd_log_commited_revoke;
 
+	atomic_t sd_log_pinned;
 	unsigned int sd_log_num_buf;
 	unsigned int sd_log_num_revoke;
 	unsigned int sd_log_num_rg;
@@ -594,15 +592,17 @@ struct gfs2_sbd {
 	struct list_head sd_log_le_databuf;
 	struct list_head sd_log_le_ordered;
 
+	atomic_t sd_log_thresh1;
+	atomic_t sd_log_thresh2;
 	atomic_t sd_log_blks_free;
-	struct mutex sd_log_reserve_mutex;
+	wait_queue_head_t sd_log_waitq;
+	wait_queue_head_t sd_logd_waitq;
 
 	u64 sd_log_sequence;
 	unsigned int sd_log_head;
 	unsigned int sd_log_tail;
 	int sd_log_idle;
 
-	unsigned long sd_log_flush_time;
 	struct rw_semaphore sd_log_flush_lock;
 	atomic_t sd_log_in_flight;
 	wait_queue_head_t sd_log_flush_wait;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 96dcf05..143311c 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -165,7 +165,7 @@ static int gfs2_ail1_empty_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai, int fl
 	return list_empty(&ai->ai_ail1_list);
 }
 
-static void gfs2_ail1_start(struct gfs2_sbd *sdp, int flags)
+static void gfs2_ail1_start(struct gfs2_sbd *sdp)
 {
 	struct list_head *head;
 	u64 sync_gen;
@@ -186,14 +186,7 @@ static void gfs2_ail1_start(struct gfs2_sbd *sdp, int flags)
 	first_ai->ai_sync_gen = sync_gen;
 	gfs2_ail1_start_one(sdp, first_ai); /* This may drop log lock */
 
-	if (flags & DIO_ALL)
-		first = NULL;
-
 	while(!done) {
-		if (first && (head->prev != first ||
-			      gfs2_ail1_empty_one(sdp, first_ai, 0)))
-			break;
-
 		done = 1;
 		list_for_each_entry_safe_reverse(ai, tmp, head, ai_list) {
 			if (ai->ai_sync_gen >= sync_gen)
@@ -287,56 +280,56 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
  * flush time, so we ensure that we have just enough free blocks at all
  * times to avoid running out during a log flush.
  *
+ * We no longer flush the log here, instead we wake up logd to do that
+ * for us. To avoid the thundering herd and to ensure that we deal fairly
+ * with queued waiters, we use an exclusive wait. This means that when we
+ * get woken with enough journal space to get our reservation, we need to
+ * wake the next waiter on the list.
+ *
  * Returns: errno
  */
 
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks)
 {
-	unsigned int try = 0;
 	unsigned reserved_blks = 6 * (4096 / sdp->sd_vfs->s_blocksize);
+	unsigned wanted = blks + reserved_blks;
+	DEFINE_WAIT(wait);
+	int did_wait = 0;
+	unsigned int free_blocks;
 
 	if (gfs2_assert_warn(sdp, blks) ||
 	    gfs2_assert_warn(sdp, blks <= sdp->sd_jdesc->jd_blocks))
 		return -EINVAL;
-
-	mutex_lock(&sdp->sd_log_reserve_mutex);
-	gfs2_log_lock(sdp);
-	while(atomic_read(&sdp->sd_log_blks_free) <= (blks + reserved_blks)) {
-		gfs2_log_unlock(sdp);
-		gfs2_ail1_empty(sdp, 0);
-		gfs2_log_flush(sdp, NULL);
-
-		if (try++)
-			gfs2_ail1_start(sdp, 0);
-		gfs2_log_lock(sdp);
+retry:
+	free_blocks = atomic_read(&sdp->sd_log_blks_free);
+	if (unlikely(free_blocks <= wanted)) {
+		wake_up(&sdp->sd_logd_waitq);
+		do {
+			prepare_to_wait_exclusive(&sdp->sd_log_waitq, &wait,
+						  TASK_UNINTERRUPTIBLE);
+			did_wait = 1;
+			if (atomic_read(&sdp->sd_log_blks_free) <= wanted)
+				io_schedule();
+			free_blocks = atomic_read(&sdp->sd_log_blks_free);
+		} while(free_blocks <= wanted);
+		finish_wait(&sdp->sd_log_waitq, &wait);
 	}
-	atomic_sub(blks, &sdp->sd_log_blks_free);
-	gfs2_log_unlock(sdp);
-	mutex_unlock(&sdp->sd_log_reserve_mutex);
+	if (atomic_cmpxchg(&sdp->sd_log_blks_free, free_blocks,
+			   free_blocks - blks) != free_blocks)
+		goto retry;
+
+	/* 
+	 * If we waited, then so might others, wake them up _after_ we get
+	 * our share of the log.
+	 */
+	if (unlikely(did_wait))
+		wake_up(&sdp->sd_log_waitq);
 
 	down_read(&sdp->sd_log_flush_lock);
 
 	return 0;
 }
 
-/**
- * gfs2_log_release - Release a given number of log blocks
- * @sdp: The GFS2 superblock
- * @blks: The number of blocks
- *
- */
-
-void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
-{
-
-	gfs2_log_lock(sdp);
-	atomic_add(blks, &sdp->sd_log_blks_free);
-	gfs2_assert_withdraw(sdp,
-			     atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
-	gfs2_log_unlock(sdp);
-	up_read(&sdp->sd_log_flush_lock);
-}
-
 static u64 log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
 {
 	struct inode *inode = sdp->sd_jdesc->jd_inode;
@@ -558,10 +551,9 @@ static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 
 	ail2_empty(sdp, new_tail);
 
-	gfs2_log_lock(sdp);
 	atomic_add(dist, &sdp->sd_log_blks_free);
-	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <= sdp->sd_jdesc->jd_blocks);
-	gfs2_log_unlock(sdp);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
+				  sdp->sd_jdesc->jd_blocks);
 
 	sdp->sd_log_tail = new_tail;
 }
@@ -791,6 +783,13 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
  * @sdp: the filesystem
  * @tr: the transaction
  *
+ * We wake up gfs2_logd if the number of pinned blocks exceed thresh1
+ * or the total number of used blocks (pinned blocks plus AIL blocks)
+ * is greater than thresh2.
+ *
+ * At mount time thresh1 is 1/3rd of journal size, thresh2 is 2/3rd of
+ * journal size.
+ *
  * Returns: errno
  */
 
@@ -802,10 +801,10 @@ void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	sdp->sd_vfs->s_dirt = 1;
 	up_read(&sdp->sd_log_flush_lock);
 
-	gfs2_log_lock(sdp);
-	if (sdp->sd_log_num_buf > gfs2_tune_get(sdp, gt_incore_log_blocks))
-		wake_up_process(sdp->sd_logd_process);
-	gfs2_log_unlock(sdp);
+	if (atomic_read(&sdp->sd_log_pinned) > atomic_read(&sdp->sd_log_thresh1) ||
+	    ((sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free)) <
+	    atomic_read(&sdp->sd_log_thresh2)))
+		wake_up(&sdp->sd_logd_waitq);
 }
 
 /**
@@ -852,13 +851,23 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 {
 	gfs2_log_flush(sdp, NULL);
 	for (;;) {
-		gfs2_ail1_start(sdp, DIO_ALL);
+		gfs2_ail1_start(sdp);
 		if (gfs2_ail1_empty(sdp, DIO_ALL))
 			break;
 		msleep(10);
 	}
 }
 
+static inline int gfs2_jrnl_flush_reqd(struct gfs2_sbd *sdp)
+{
+	return (atomic_read(&sdp->sd_log_pinned) >= atomic_read(&sdp->sd_log_thresh1));
+}
+
+static inline int gfs2_ail_flush_reqd(struct gfs2_sbd *sdp)
+{
+	unsigned int used_blocks = sdp->sd_jdesc->jd_blocks - atomic_read(&sdp->sd_log_blks_free);
+	return used_blocks >= atomic_read(&sdp->sd_log_thresh2);
+}
 
 /**
  * gfs2_logd - Update log tail as Active Items get flushed to in-place blocks
@@ -871,28 +880,43 @@ void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
 int gfs2_logd(void *data)
 {
 	struct gfs2_sbd *sdp = data;
-	unsigned long t;
-	int need_flush;
+	unsigned long t = 1;
+	DEFINE_WAIT(wait);
+	unsigned preflush;
 
 	while (!kthread_should_stop()) {
-		/* Advance the log tail */
 
-		t = sdp->sd_log_flush_time +
-		    gfs2_tune_get(sdp, gt_log_flush_secs) * HZ;
+		preflush = atomic_read(&sdp->sd_log_pinned);
+		if (gfs2_jrnl_flush_reqd(sdp) || t == 0) {
+			gfs2_ail1_empty(sdp, DIO_ALL);
+			gfs2_log_flush(sdp, NULL);
+			gfs2_ail1_empty(sdp, DIO_ALL);
+		}
 
-		gfs2_ail1_empty(sdp, DIO_ALL);
-		gfs2_log_lock(sdp);
-		need_flush = sdp->sd_log_num_buf > gfs2_tune_get(sdp, gt_incore_log_blocks);
-		gfs2_log_unlock(sdp);
-		if (need_flush || time_after_eq(jiffies, t)) {
+		if (gfs2_ail_flush_reqd(sdp)) {
+			gfs2_ail1_start(sdp);
+			io_schedule();
+			gfs2_ail1_empty(sdp, 0);
 			gfs2_log_flush(sdp, NULL);
-			sdp->sd_log_flush_time = jiffies;
+			gfs2_ail1_empty(sdp, DIO_ALL);
 		}
 
+		wake_up(&sdp->sd_log_waitq);
 		t = gfs2_tune_get(sdp, gt_logd_secs) * HZ;
 		if (freezing(current))
 			refrigerator();
-		schedule_timeout_interruptible(t);
+
+		do {
+			prepare_to_wait(&sdp->sd_logd_waitq, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!gfs2_ail_flush_reqd(sdp) &&
+			    !gfs2_jrnl_flush_reqd(sdp) &&
+			    !kthread_should_stop())
+				t = schedule_timeout(t);
+		} while(t && !gfs2_ail_flush_reqd(sdp) &&
+			!gfs2_jrnl_flush_reqd(sdp) &&
+			!kthread_should_stop());
+		finish_wait(&sdp->sd_logd_waitq, &wait);
 	}
 
 	return 0;
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 7711528..bc91125 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -49,7 +49,6 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 			    unsigned int ssize);
 
 int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
-void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks);
 void gfs2_log_incr_head(struct gfs2_sbd *sdp);
 
 struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index fae59d6..29a8689 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -52,6 +52,7 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	if (bd->bd_ail)
 		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
 	get_bh(bh);
+	atomic_inc(&sdp->sd_log_pinned);
 }
 
 /**
@@ -90,6 +91,7 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	clear_bit(GLF_LFLUSH, &bd->bd_gl->gl_flags);
 	gfs2_log_unlock(sdp);
 	unlock_buffer(bh);
+	atomic_dec(&sdp->sd_log_pinned);
 }
 
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 4b1aced..9688785 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -303,6 +303,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 	struct gfs2_sbd *sdp = GFS2_SB(bh->b_page->mapping->host);
 	struct gfs2_bufdata *bd = bh->b_private;
 	if (test_clear_buffer_pinned(bh)) {
+		atomic_dec(&sdp->sd_log_pinned);
 		list_del_init(&bd->bd_le.le_list);
 		if (meta) {
 			gfs2_assert_warn(sdp, sdp->sd_log_num_buf);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1bba6ac..6f5fa5e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -76,14 +76,15 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	mutex_init(&sdp->sd_quota_mutex);
 
 	spin_lock_init(&sdp->sd_log_lock);
-
+	atomic_set(&sdp->sd_log_pinned, 0);
 	INIT_LIST_HEAD(&sdp->sd_log_le_buf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_revoke);
 	INIT_LIST_HEAD(&sdp->sd_log_le_rg);
 	INIT_LIST_HEAD(&sdp->sd_log_le_databuf);
 	INIT_LIST_HEAD(&sdp->sd_log_le_ordered);
 
-	mutex_init(&sdp->sd_log_reserve_mutex);
+	init_waitqueue_head(&sdp->sd_log_waitq);
+	init_waitqueue_head(&sdp->sd_logd_waitq);
 	INIT_LIST_HEAD(&sdp->sd_ail1_list);
 	INIT_LIST_HEAD(&sdp->sd_ail2_list);
 
@@ -340,6 +341,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	if (sdp->sd_args.ar_spectator) {
 		sdp->sd_jdesc = gfs2_jdesc_find(sdp, 0);
 		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
+		atomic_set(&sdp->sd_log_thresh1, 2*sdp->sd_jdesc->jd_blocks/5);
+		atomic_set(&sdp->sd_log_thresh2, 4*sdp->sd_jdesc->jd_blocks/5);
 	} else {
 		if (sdp->sd_lockstruct.ls_jid >= gfs2_jindex_size(sdp)) {
 			fs_err(sdp, "can't mount journal #%u\n",
@@ -377,6 +380,8 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 			goto fail_jinode_gh;
 		}
 		atomic_set(&sdp->sd_log_blks_free, sdp->sd_jdesc->jd_blocks);
+		atomic_set(&sdp->sd_log_thresh1, 2*sdp->sd_jdesc->jd_blocks/5);
+		atomic_set(&sdp->sd_log_thresh2, 4*sdp->sd_jdesc->jd_blocks/5);
 	}
 
 	if (sdp->sd_lockstruct.ls_first) {
@@ -608,9 +613,6 @@ static int init_threads(struct gfs2_sbd *sdp, int undo)
 	if (undo)
 		goto fail_quotad;
 
-	sdp->sd_log_flush_time = jiffies;
-	sdp->sd_jindex_refresh_time = jiffies;
-
 	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
 	error = IS_ERR(p);
 	if (error) {
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2e74792..850df2b 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -52,10 +52,8 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	spin_lock_init(&gt->gt_spin);
 
 	gt->gt_demote_secs = 300;
-	gt->gt_incore_log_blocks = 1024;
-	gt->gt_log_flush_secs = 60;
 	gt->gt_recoverd_secs = 60;
-	gt->gt_logd_secs = 1;
+	gt->gt_logd_secs = 30;
 	gt->gt_quotad_secs = 5;
 	gt->gt_quota_simul_sync = 64;
 	gt->gt_quota_warn_period = 10;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7f828a2..08bc548 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -426,8 +426,6 @@ static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)\
 TUNE_ATTR_2(name, name##_store)
 
 TUNE_ATTR(demote_secs, 0);
-TUNE_ATTR(incore_log_blocks, 0);
-TUNE_ATTR(log_flush_secs, 0);
 TUNE_ATTR(quota_warn_period, 0);
 TUNE_ATTR(quota_quantum, 0);
 TUNE_ATTR(atime_quantum, 0);
@@ -447,8 +445,6 @@ TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
 static struct attribute *tune_attrs[] = {
 	&tune_attr_demote_secs.attr,
-	&tune_attr_incore_log_blocks.attr,
-	&tune_attr_log_flush_secs.attr,
 	&tune_attr_quota_warn_period.attr,
 	&tune_attr_quota_quantum.attr,
 	&tune_attr_atime_quantum.attr,
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 73e5d92..cebca7b 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -79,6 +79,22 @@ fail_holder_uninit:
 	return error;
 }
 
+/**
+ * gfs2_log_release - Release a given number of log blocks
+ * @sdp: The GFS2 superblock
+ * @blks: The number of blocks
+ *
+ */
+
+static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
+{
+
+	atomic_add(blks, &sdp->sd_log_blks_free);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
+				  sdp->sd_jdesc->jd_blocks);
+	up_read(&sdp->sd_log_flush_lock);
+}
+
 void gfs2_trans_end(struct gfs2_sbd *sdp)
 {
 	struct gfs2_trans *tr = current->journal_info;
-- 
1.5.1.2

