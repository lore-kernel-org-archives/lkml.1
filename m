Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZCRN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZCRN33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 09:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbZCRN04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 09:26:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbZCRN0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 09:26:47 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/18] GFS2: Fix deadlock on journal flush
Date: Wed, 18 Mar 2009 12:23:43 +0000
Message-Id: <1237379033-28095-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
References: <1237379033-28095-1-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-2-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-3-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-4-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-5-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-6-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-7-git-send-email-swhiteho@redhat.com>
 <1237379033-28095-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch fixes a deadlock when the journal is flushed and there
are dirty inodes other than the one which caused the journal flush.
Originally the journal flushing code was trying to obtain the
transaction glock while running the flush code for an inode glock.
We no longer require the transaction glock at this point in time
since we know that any attempt to get the transaction glock from
another node will result in a journal flush. So if we are flushing
the journal, we can be sure that the transaction lock is still
cached from when the transaction was started.

By inlining a version of gfs2_trans_begin() (minus the bit which
gets the transaction glock) we can avoid the deadlock problems
caused if there is a demote request queued up on the transaction
glock.

In addition I've also moved the umount rwsem so that it covers
the glock workqueue, since it all demotions are done by this
workqueue now. That fixes a bug on umount which I came across
while fixing the original problem.

Reported-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 173e59c..ad8e121 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -167,6 +167,7 @@ static void glock_free(struct gfs2_glock *gl)
 
 static void gfs2_glock_hold(struct gfs2_glock *gl)
 {
+	GLOCK_BUG_ON(gl, atomic_read(&gl->gl_ref) == 0);
 	atomic_inc(&gl->gl_ref);
 }
 
@@ -206,16 +207,15 @@ int gfs2_glock_put(struct gfs2_glock *gl)
 			atomic_dec(&lru_count);
 		}
 		spin_unlock(&lru_lock);
-		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_lru));
 		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
 		glock_free(gl);
 		rv = 1;
 		goto out;
 	}
-	write_unlock(gl_lock_addr(gl->gl_hash));
 	/* 1 for being hashed, 1 for having state != LM_ST_UNLOCKED */
 	if (atomic_read(&gl->gl_ref) == 2)
 		gfs2_glock_schedule_for_reclaim(gl);
+	write_unlock(gl_lock_addr(gl->gl_hash));
 out:
 	return rv;
 }
@@ -597,10 +597,11 @@ __acquires(&gl->gl_spin)
 
 	GLOCK_BUG_ON(gl, test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags));
 
+	down_read(&gfs2_umount_flush_sem);
 	if (test_bit(GLF_DEMOTE, &gl->gl_flags) &&
 	    gl->gl_demote_state != gl->gl_state) {
 		if (find_first_holder(gl))
-			goto out;
+			goto out_unlock;
 		if (nonblock)
 			goto out_sched;
 		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
@@ -611,23 +612,26 @@ __acquires(&gl->gl_spin)
 			gfs2_demote_wake(gl);
 		ret = do_promote(gl);
 		if (ret == 0)
-			goto out;
+			goto out_unlock;
 		if (ret == 2)
-			return;
+			goto out_sem;
 		gh = find_first_waiter(gl);
 		gl->gl_target = gh->gh_state;
 		if (!(gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
 			do_error(gl, 0); /* Fail queued try locks */
 	}
 	do_xmote(gl, gh, gl->gl_target);
+out_sem:
+	up_read(&gfs2_umount_flush_sem);
 	return;
 
 out_sched:
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put(gl);
-out:
+out_unlock:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
+	goto out_sem;
 }
 
 static void glock_work_func(struct work_struct *work)
@@ -1225,7 +1229,6 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 {
 	struct lm_lockstruct *ls = &gl->gl_sbd->sd_lockstruct;
-	down_read(&gfs2_umount_flush_sem);
 	gl->gl_reply = ret;
 	if (unlikely(test_bit(DFL_BLOCK_LOCKS, &ls->ls_flags))) {
 		struct gfs2_holder *gh;
@@ -1236,16 +1239,13 @@ void gfs2_glock_complete(struct gfs2_glock *gl, int ret)
 		    ((ret & ~LM_OUT_ST_MASK) != 0))
 			set_bit(GLF_FROZEN, &gl->gl_flags);
 		spin_unlock(&gl->gl_spin);
-		if (test_bit(GLF_FROZEN, &gl->gl_flags)) {
-			up_read(&gfs2_umount_flush_sem);
+		if (test_bit(GLF_FROZEN, &gl->gl_flags))
 			return;
-		}
 	}
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put(gl);
-	up_read(&gfs2_umount_flush_sem);
 }
 
 /**
@@ -1389,12 +1389,10 @@ static void thaw_glock(struct gfs2_glock *gl)
 {
 	if (!test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
 		return;
-	down_read(&gfs2_umount_flush_sem);
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put(gl);
-	up_read(&gfs2_umount_flush_sem);
 }
 
 /**
@@ -1580,7 +1578,7 @@ static const char *gflags2str(char *buf, const unsigned long *gflags)
 	if (test_bit(GLF_REPLY_PENDING, gflags))
 		*p++ = 'r';
 	if (test_bit(GLF_INITIAL, gflags))
-		*p++ = 'i';
+		*p++ = 'I';
 	if (test_bit(GLF_FROZEN, gflags))
 		*p++ = 'F';
 	*p = 0;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index f07ede8..a9b7d3a 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -37,20 +37,25 @@
 static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
-	unsigned int blocks;
 	struct list_head *head = &gl->gl_ail_list;
 	struct gfs2_bufdata *bd;
 	struct buffer_head *bh;
-	int error;
+	struct gfs2_trans tr;
 
-	blocks = atomic_read(&gl->gl_ail_count);
-	if (!blocks)
-		return;
+	memset(&tr, 0, sizeof(tr));
+	tr.tr_revokes = atomic_read(&gl->gl_ail_count);
 
-	error = gfs2_trans_begin(sdp, 0, blocks);
-	if (gfs2_assert_withdraw(sdp, !error))
+	if (!tr.tr_revokes)
 		return;
 
+	/* A shortened, inline version of gfs2_trans_begin() */
+	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
+	tr.tr_ip = (unsigned long)__builtin_return_address(0);
+	INIT_LIST_HEAD(&tr.tr_list_buf);
+	gfs2_log_reserve(sdp, tr.tr_reserved);
+	BUG_ON(current->journal_info);
+	current->journal_info = &tr;
+
 	gfs2_log_lock(sdp);
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata,
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 33cd523..053752d 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -87,9 +87,11 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 
 	if (!tr->tr_touched) {
 		gfs2_log_release(sdp, tr->tr_reserved);
-		gfs2_glock_dq(&tr->tr_t_gh);
-		gfs2_holder_uninit(&tr->tr_t_gh);
-		kfree(tr);
+		if (tr->tr_t_gh.gh_gl) {
+			gfs2_glock_dq(&tr->tr_t_gh);
+			gfs2_holder_uninit(&tr->tr_t_gh);
+			kfree(tr);
+		}
 		return;
 	}
 
@@ -105,9 +107,11 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 	}
 
 	gfs2_log_commit(sdp, tr);
-        gfs2_glock_dq(&tr->tr_t_gh);
-        gfs2_holder_uninit(&tr->tr_t_gh);
-        kfree(tr);
+	if (tr->tr_t_gh.gh_gl) {
+		gfs2_glock_dq(&tr->tr_t_gh);
+		gfs2_holder_uninit(&tr->tr_t_gh);
+		kfree(tr);
+	}
 
 	if (sdp->sd_vfs->s_flags & MS_SYNCHRONOUS)
 		gfs2_log_flush(sdp, NULL);
-- 
1.6.0.3

