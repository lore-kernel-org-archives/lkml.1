Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbYGKLCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbYGKLCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYGKLBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbYGKLB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:29 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 02/18] [GFS2] Fix ordering bug in lock_dlm
Date: Fri, 11 Jul 2008 11:11:03 +0100
Message-Id: <1215771089769-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157710872782-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This looks like a lot of change, but in fact its not. Mostly its
things moving from one file to another. The change is just that
instead of queuing lock completions and callbacks from the DLM
we now pass them directly to GFS2.

This gives us a net loss of two list heads per glock (a fair
saving in memory) plus a reduction in the latency of delivering
the messages to GFS2, plus we now have one thread fewer as well.
There was a bug where callbacks and completions could be delivered
in the wrong order due to this unnecessary queuing which is fixed
by this patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index fed9a67..871ffc9 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -11,46 +11,63 @@
 
 static char junk_lvb[GDLM_LVB_SIZE];
 
-static void queue_complete(struct gdlm_lock *lp)
+
+/* convert dlm lock-mode to gfs lock-state */
+
+static s16 gdlm_make_lmstate(s16 dlmmode)
 {
-	struct gdlm_ls *ls = lp->ls;
+	switch (dlmmode) {
+	case DLM_LOCK_IV:
+	case DLM_LOCK_NL:
+		return LM_ST_UNLOCKED;
+	case DLM_LOCK_EX:
+		return LM_ST_EXCLUSIVE;
+	case DLM_LOCK_CW:
+		return LM_ST_DEFERRED;
+	case DLM_LOCK_PR:
+		return LM_ST_SHARED;
+	}
+	gdlm_assert(0, "unknown DLM mode %d", dlmmode);
+	return -1;
+}
 
-	clear_bit(LFL_ACTIVE, &lp->flags);
+/* A lock placed on this queue is re-submitted to DLM as soon as the lock_dlm
+   thread gets to it. */
+
+static void queue_submit(struct gdlm_lock *lp)
+{
+	struct gdlm_ls *ls = lp->ls;
 
 	spin_lock(&ls->async_lock);
-	list_add_tail(&lp->clist, &ls->complete);
+	list_add_tail(&lp->delay_list, &ls->submit);
 	spin_unlock(&ls->async_lock);
 	wake_up(&ls->thread_wait);
 }
 
-static inline void gdlm_ast(void *astarg)
+static void wake_up_ast(struct gdlm_lock *lp)
 {
-	queue_complete(astarg);
+	clear_bit(LFL_AST_WAIT, &lp->flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&lp->flags, LFL_AST_WAIT);
 }
 
-static inline void gdlm_bast(void *astarg, int mode)
+static void gdlm_delete_lp(struct gdlm_lock *lp)
 {
-	struct gdlm_lock *lp = astarg;
 	struct gdlm_ls *ls = lp->ls;
 
-	if (!mode) {
-		printk(KERN_INFO "lock_dlm: bast mode zero %x,%llx\n",
-			lp->lockname.ln_type,
-			(unsigned long long)lp->lockname.ln_number);
-		return;
-	}
-
 	spin_lock(&ls->async_lock);
-	if (!lp->bast_mode) {
-		list_add_tail(&lp->blist, &ls->blocking);
-		lp->bast_mode = mode;
-	} else if (lp->bast_mode < mode)
-		lp->bast_mode = mode;
+	if (!list_empty(&lp->delay_list))
+		list_del_init(&lp->delay_list);
+	gdlm_assert(!list_empty(&lp->all_list), "%x,%llx", lp->lockname.ln_type,
+		    (unsigned long long)lp->lockname.ln_number);
+	list_del_init(&lp->all_list);
+	ls->all_locks_count--;
 	spin_unlock(&ls->async_lock);
-	wake_up(&ls->thread_wait);
+
+	kfree(lp);
 }
 
-void gdlm_queue_delayed(struct gdlm_lock *lp)
+static void gdlm_queue_delayed(struct gdlm_lock *lp)
 {
 	struct gdlm_ls *ls = lp->ls;
 
@@ -59,6 +76,249 @@ void gdlm_queue_delayed(struct gdlm_lock *lp)
 	spin_unlock(&ls->async_lock);
 }
 
+static void process_complete(struct gdlm_lock *lp)
+{
+	struct gdlm_ls *ls = lp->ls;
+	struct lm_async_cb acb;
+	s16 prev_mode = lp->cur;
+
+	memset(&acb, 0, sizeof(acb));
+
+	if (lp->lksb.sb_status == -DLM_ECANCEL) {
+		log_info("complete dlm cancel %x,%llx flags %lx",
+		 	 lp->lockname.ln_type,
+			 (unsigned long long)lp->lockname.ln_number,
+			 lp->flags);
+
+		lp->req = lp->cur;
+		acb.lc_ret |= LM_OUT_CANCELED;
+		if (lp->cur == DLM_LOCK_IV)
+			lp->lksb.sb_lkid = 0;
+		goto out;
+	}
+
+	if (test_and_clear_bit(LFL_DLM_UNLOCK, &lp->flags)) {
+		if (lp->lksb.sb_status != -DLM_EUNLOCK) {
+			log_info("unlock sb_status %d %x,%llx flags %lx",
+				 lp->lksb.sb_status, lp->lockname.ln_type,
+				 (unsigned long long)lp->lockname.ln_number,
+				 lp->flags);
+			return;
+		}
+
+		lp->cur = DLM_LOCK_IV;
+		lp->req = DLM_LOCK_IV;
+		lp->lksb.sb_lkid = 0;
+
+		if (test_and_clear_bit(LFL_UNLOCK_DELETE, &lp->flags)) {
+			gdlm_delete_lp(lp);
+			return;
+		}
+		goto out;
+	}
+
+	if (lp->lksb.sb_flags & DLM_SBF_VALNOTVALID)
+		memset(lp->lksb.sb_lvbptr, 0, GDLM_LVB_SIZE);
+
+	if (lp->lksb.sb_flags & DLM_SBF_ALTMODE) {
+		if (lp->req == DLM_LOCK_PR)
+			lp->req = DLM_LOCK_CW;
+		else if (lp->req == DLM_LOCK_CW)
+			lp->req = DLM_LOCK_PR;
+	}
+
+	/*
+	 * A canceled lock request.  The lock was just taken off the delayed
+	 * list and was never even submitted to dlm.
+	 */
+
+	if (test_and_clear_bit(LFL_CANCEL, &lp->flags)) {
+		log_info("complete internal cancel %x,%llx",
+		 	 lp->lockname.ln_type,
+			 (unsigned long long)lp->lockname.ln_number);
+		lp->req = lp->cur;
+		acb.lc_ret |= LM_OUT_CANCELED;
+		goto out;
+	}
+
+	/*
+	 * An error occured.
+	 */
+
+	if (lp->lksb.sb_status) {
+		/* a "normal" error */
+		if ((lp->lksb.sb_status == -EAGAIN) &&
+		    (lp->lkf & DLM_LKF_NOQUEUE)) {
+			lp->req = lp->cur;
+			if (lp->cur == DLM_LOCK_IV)
+				lp->lksb.sb_lkid = 0;
+			goto out;
+		}
+
+		/* this could only happen with cancels I think */
+		log_info("ast sb_status %d %x,%llx flags %lx",
+			 lp->lksb.sb_status, lp->lockname.ln_type,
+			 (unsigned long long)lp->lockname.ln_number,
+			 lp->flags);
+		if (lp->lksb.sb_status == -EDEADLOCK &&
+		    lp->ls->fsflags & LM_MFLAG_CONV_NODROP) {
+			lp->req = lp->cur;
+			acb.lc_ret |= LM_OUT_CONV_DEADLK;
+			if (lp->cur == DLM_LOCK_IV)
+				lp->lksb.sb_lkid = 0;
+			goto out;
+		} else
+			return;
+	}
+
+	/*
+	 * This is an AST for an EX->EX conversion for sync_lvb from GFS.
+	 */
+
+	if (test_and_clear_bit(LFL_SYNC_LVB, &lp->flags)) {
+		wake_up_ast(lp);
+		return;
+	}
+
+	/*
+	 * A lock has been demoted to NL because it initially completed during
+	 * BLOCK_LOCKS.  Now it must be requested in the originally requested
+	 * mode.
+	 */
+
+	if (test_and_clear_bit(LFL_REREQUEST, &lp->flags)) {
+		gdlm_assert(lp->req == DLM_LOCK_NL, "%x,%llx",
+			    lp->lockname.ln_type,
+			    (unsigned long long)lp->lockname.ln_number);
+		gdlm_assert(lp->prev_req > DLM_LOCK_NL, "%x,%llx",
+			    lp->lockname.ln_type,
+			    (unsigned long long)lp->lockname.ln_number);
+
+		lp->cur = DLM_LOCK_NL;
+		lp->req = lp->prev_req;
+		lp->prev_req = DLM_LOCK_IV;
+		lp->lkf &= ~DLM_LKF_CONVDEADLK;
+
+		set_bit(LFL_NOCACHE, &lp->flags);
+
+		if (test_bit(DFL_BLOCK_LOCKS, &ls->flags) &&
+		    !test_bit(LFL_NOBLOCK, &lp->flags))
+			gdlm_queue_delayed(lp);
+		else
+			queue_submit(lp);
+		return;
+	}
+
+	/*
+	 * A request is granted during dlm recovery.  It may be granted
+	 * because the locks of a failed node were cleared.  In that case,
+	 * there may be inconsistent data beneath this lock and we must wait
+	 * for recovery to complete to use it.  When gfs recovery is done this
+	 * granted lock will be converted to NL and then reacquired in this
+	 * granted state.
+	 */
+
+	if (test_bit(DFL_BLOCK_LOCKS, &ls->flags) &&
+	    !test_bit(LFL_NOBLOCK, &lp->flags) &&
+	    lp->req != DLM_LOCK_NL) {
+
+		lp->cur = lp->req;
+		lp->prev_req = lp->req;
+		lp->req = DLM_LOCK_NL;
+		lp->lkf |= DLM_LKF_CONVERT;
+		lp->lkf &= ~DLM_LKF_CONVDEADLK;
+
+		log_debug("rereq %x,%llx id %x %d,%d",
+			  lp->lockname.ln_type,
+			  (unsigned long long)lp->lockname.ln_number,
+			  lp->lksb.sb_lkid, lp->cur, lp->req);
+
+		set_bit(LFL_REREQUEST, &lp->flags);
+		queue_submit(lp);
+		return;
+	}
+
+	/*
+	 * DLM demoted the lock to NL before it was granted so GFS must be
+	 * told it cannot cache data for this lock.
+	 */
+
+	if (lp->lksb.sb_flags & DLM_SBF_DEMOTED)
+		set_bit(LFL_NOCACHE, &lp->flags);
+
+out:
+	/*
+	 * This is an internal lock_dlm lock
+	 */
+
+	if (test_bit(LFL_INLOCK, &lp->flags)) {
+		clear_bit(LFL_NOBLOCK, &lp->flags);
+		lp->cur = lp->req;
+		wake_up_ast(lp);
+		return;
+	}
+
+	/*
+	 * Normal completion of a lock request.  Tell GFS it now has the lock.
+	 */
+
+	clear_bit(LFL_NOBLOCK, &lp->flags);
+	lp->cur = lp->req;
+
+	acb.lc_name = lp->lockname;
+	acb.lc_ret |= gdlm_make_lmstate(lp->cur);
+
+	if (!test_and_clear_bit(LFL_NOCACHE, &lp->flags) &&
+	    (lp->cur > DLM_LOCK_NL) && (prev_mode > DLM_LOCK_NL))
+		acb.lc_ret |= LM_OUT_CACHEABLE;
+
+	ls->fscb(ls->sdp, LM_CB_ASYNC, &acb);
+}
+
+static void gdlm_ast(void *astarg)
+{
+	struct gdlm_lock *lp = astarg;
+	clear_bit(LFL_ACTIVE, &lp->flags);
+	process_complete(lp);
+}
+
+static void process_blocking(struct gdlm_lock *lp, int bast_mode)
+{
+	struct gdlm_ls *ls = lp->ls;
+	unsigned int cb = 0;
+
+	switch (gdlm_make_lmstate(bast_mode)) {
+	case LM_ST_EXCLUSIVE:
+		cb = LM_CB_NEED_E;
+		break;
+	case LM_ST_DEFERRED:
+		cb = LM_CB_NEED_D;
+		break;
+	case LM_ST_SHARED:
+		cb = LM_CB_NEED_S;
+		break;
+	default:
+		gdlm_assert(0, "unknown bast mode %u", bast_mode);
+	}
+
+	ls->fscb(ls->sdp, cb, &lp->lockname);
+}
+
+
+static void gdlm_bast(void *astarg, int mode)
+{
+	struct gdlm_lock *lp = astarg;
+
+	if (!mode) {
+		printk(KERN_INFO "lock_dlm: bast mode zero %x,%llx\n",
+			lp->lockname.ln_type,
+			(unsigned long long)lp->lockname.ln_number);
+		return;
+	}
+
+	process_blocking(lp, mode);
+}
+
 /* convert gfs lock-state to dlm lock-mode */
 
 static s16 make_mode(s16 lmstate)
@@ -77,24 +337,6 @@ static s16 make_mode(s16 lmstate)
 	return -1;
 }
 
-/* convert dlm lock-mode to gfs lock-state */
-
-s16 gdlm_make_lmstate(s16 dlmmode)
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
 
 /* verify agreement with GFS on the current lock state, NB: DLM_LOCK_NL and
    DLM_LOCK_IV are both considered LM_ST_UNLOCKED by GFS. */
@@ -173,10 +415,6 @@ static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
 	make_strname(name, &lp->strname);
 	lp->ls = ls;
 	lp->cur = DLM_LOCK_IV;
-	lp->lvb = NULL;
-	lp->hold_null = NULL;
-	INIT_LIST_HEAD(&lp->clist);
-	INIT_LIST_HEAD(&lp->blist);
 	INIT_LIST_HEAD(&lp->delay_list);
 
 	spin_lock(&ls->async_lock);
@@ -188,26 +426,6 @@ static int gdlm_create_lp(struct gdlm_ls *ls, struct lm_lockname *name,
 	return 0;
 }
 
-void gdlm_delete_lp(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-
-	spin_lock(&ls->async_lock);
-	if (!list_empty(&lp->clist))
-		list_del_init(&lp->clist);
-	if (!list_empty(&lp->blist))
-		list_del_init(&lp->blist);
-	if (!list_empty(&lp->delay_list))
-		list_del_init(&lp->delay_list);
-	gdlm_assert(!list_empty(&lp->all_list), "%x,%llx", lp->lockname.ln_type,
-		    (unsigned long long)lp->lockname.ln_number);
-	list_del_init(&lp->all_list);
-	ls->all_locks_count--;
-	spin_unlock(&ls->async_lock);
-
-	kfree(lp);
-}
-
 int gdlm_get_lock(void *lockspace, struct lm_lockname *name,
 		  void **lockp)
 {
@@ -261,7 +479,7 @@ unsigned int gdlm_do_lock(struct gdlm_lock *lp)
 
 	if ((error == -EAGAIN) && (lp->lkf & DLM_LKF_NOQUEUE)) {
 		lp->lksb.sb_status = -EAGAIN;
-		queue_complete(lp);
+		gdlm_ast(lp);
 		error = 0;
 	}
 
@@ -311,6 +529,9 @@ unsigned int gdlm_lock(void *lock, unsigned int cur_state,
 	if (req_state == LM_ST_UNLOCKED)
 		return gdlm_unlock(lock, cur_state);
 
+	if (req_state == LM_ST_UNLOCKED)
+		return gdlm_unlock(lock, cur_state);
+
 	clear_bit(LFL_DLM_CANCEL, &lp->flags);
 	if (flags & LM_FLAG_NOEXP)
 		set_bit(LFL_NOBLOCK, &lp->flags);
@@ -354,7 +575,7 @@ void gdlm_cancel(void *lock)
 	if (delay_list) {
 		set_bit(LFL_CANCEL, &lp->flags);
 		set_bit(LFL_ACTIVE, &lp->flags);
-		queue_complete(lp);
+		gdlm_ast(lp);
 		return;
 	}
 
diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index a243cf6..ad944c6 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -72,15 +72,12 @@ struct gdlm_ls {
 	int			recover_jid_done;
 	int			recover_jid_status;
 	spinlock_t		async_lock;
-	struct list_head	complete;
-	struct list_head	blocking;
 	struct list_head	delayed;
 	struct list_head	submit;
 	struct list_head	all_locks;
 	u32		all_locks_count;
 	wait_queue_head_t	wait_control;
-	struct task_struct	*thread1;
-	struct task_struct	*thread2;
+	struct task_struct	*thread;
 	wait_queue_head_t	thread_wait;
 	unsigned long		drop_time;
 	int			drop_locks_count;
@@ -117,10 +114,6 @@ struct gdlm_lock {
 	u32			lkf;		/* dlm flags DLM_LKF_ */
 	unsigned long		flags;		/* lock_dlm flags LFL_ */
 
-	int			bast_mode;	/* protected by async_lock */
-
-	struct list_head	clist;		/* complete */
-	struct list_head	blist;		/* blocking */
 	struct list_head	delay_list;	/* delayed */
 	struct list_head	all_list;	/* all locks for the fs */
 	struct gdlm_lock	*hold_null;	/* NL lock for hold_lvb */
@@ -159,11 +152,8 @@ void gdlm_release_threads(struct gdlm_ls *);
 
 /* lock.c */
 
-s16 gdlm_make_lmstate(s16);
-void gdlm_queue_delayed(struct gdlm_lock *);
 void gdlm_submit_delayed(struct gdlm_ls *);
 int gdlm_release_all_locks(struct gdlm_ls *);
-void gdlm_delete_lp(struct gdlm_lock *);
 unsigned int gdlm_do_lock(struct gdlm_lock *);
 
 int gdlm_get_lock(void *, struct lm_lockname *, void **);
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index 470bdf6..0628520 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -28,15 +28,11 @@ static struct gdlm_ls *init_gdlm(lm_callback_t cb, struct gfs2_sbd *sdp,
 	ls->sdp = sdp;
 	ls->fsflags = flags;
 	spin_lock_init(&ls->async_lock);
-	INIT_LIST_HEAD(&ls->complete);
-	INIT_LIST_HEAD(&ls->blocking);
 	INIT_LIST_HEAD(&ls->delayed);
 	INIT_LIST_HEAD(&ls->submit);
 	INIT_LIST_HEAD(&ls->all_locks);
 	init_waitqueue_head(&ls->thread_wait);
 	init_waitqueue_head(&ls->wait_control);
-	ls->thread1 = NULL;
-	ls->thread2 = NULL;
 	ls->drop_time = jiffies;
 	ls->jid = -1;
 
diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
index e53db6f..f30350a 100644
--- a/fs/gfs2/locking/dlm/thread.c
+++ b/fs/gfs2/locking/dlm/thread.c
@@ -9,255 +9,12 @@
 
 #include "lock_dlm.h"
 
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
-		gdlm_assert(0, "unknown bast mode %u", lp->bast_mode);
-	}
-
-	ls->fscb(ls->sdp, cb, &lp->lockname);
-}
-
-static void wake_up_ast(struct gdlm_lock *lp)
-{
-	clear_bit(LFL_AST_WAIT, &lp->flags);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&lp->flags, LFL_AST_WAIT);
-}
-
-static void process_complete(struct gdlm_lock *lp)
-{
-	struct gdlm_ls *ls = lp->ls;
-	struct lm_async_cb acb;
-	s16 prev_mode = lp->cur;
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
-		if (lp->lksb.sb_status == -EDEADLOCK &&
-		    lp->ls->fsflags & LM_MFLAG_CONV_NODROP) {
-			lp->req = lp->cur;
-			acb.lc_ret |= LM_OUT_CONV_DEADLK;
-			if (lp->cur == DLM_LOCK_IV)
-				lp->lksb.sb_lkid = 0;
-			goto out;
-		} else
-			return;
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
-	if (!test_and_clear_bit(LFL_NOCACHE, &lp->flags) &&
-	    (lp->cur > DLM_LOCK_NL) && (prev_mode > DLM_LOCK_NL))
-		acb.lc_ret |= LM_OUT_CACHEABLE;
-
-	ls->fscb(ls->sdp, LM_CB_ASYNC, &acb);
-}
-
-static inline int no_work(struct gdlm_ls *ls, int blocking)
+static inline int no_work(struct gdlm_ls *ls)
 {
 	int ret;
 
 	spin_lock(&ls->async_lock);
-	ret = list_empty(&ls->complete) && list_empty(&ls->submit);
-	if (ret && blocking)
-		ret = list_empty(&ls->blocking);
+	ret = list_empty(&ls->submit);
 	spin_unlock(&ls->async_lock);
 
 	return ret;
@@ -276,100 +33,55 @@ static inline int check_drop(struct gdlm_ls *ls)
 	return 0;
 }
 
-static int gdlm_thread(void *data, int blist)
+static int gdlm_thread(void *data)
 {
 	struct gdlm_ls *ls = (struct gdlm_ls *) data;
 	struct gdlm_lock *lp = NULL;
-	uint8_t complete, blocking, submit, drop;
-
-	/* Only thread1 is allowed to do blocking callbacks since gfs
-	   may wait for a completion callback within a blocking cb. */
 
 	while (!kthread_should_stop()) {
 		wait_event_interruptible(ls->thread_wait,
-				!no_work(ls, blist) || kthread_should_stop());
-
-		complete = blocking = submit = drop = 0;
+				!no_work(ls) || kthread_should_stop());
 
 		spin_lock(&ls->async_lock);
 
-		if (blist && !list_empty(&ls->blocking)) {
-			lp = list_entry(ls->blocking.next, struct gdlm_lock,
-					blist);
-			list_del_init(&lp->blist);
-			blocking = lp->bast_mode;
-			lp->bast_mode = 0;
-		} else if (!list_empty(&ls->complete)) {
-			lp = list_entry(ls->complete.next, struct gdlm_lock,
-					clist);
-			list_del_init(&lp->clist);
-			complete = 1;
-		} else if (!list_empty(&ls->submit)) {
+		if (!list_empty(&ls->submit)) {
 			lp = list_entry(ls->submit.next, struct gdlm_lock,
 					delay_list);
 			list_del_init(&lp->delay_list);
-			submit = 1;
-		}
-
-		drop = check_drop(ls);
-		spin_unlock(&ls->async_lock);
-
-		if (complete)
-			process_complete(lp);
-
-		else if (blocking)
-			process_blocking(lp, blocking);
-
-		else if (submit)
+			spin_unlock(&ls->async_lock);
 			gdlm_do_lock(lp);
-
-		if (drop)
+			spin_lock(&ls->async_lock);
+		}
+		/* Does this ever happen these days? I hope not anyway */
+		if (check_drop(ls)) {
+			spin_unlock(&ls->async_lock);
 			ls->fscb(ls->sdp, LM_CB_DROPLOCKS, NULL);
-
-		schedule();
+			spin_lock(&ls->async_lock);
+		}
+		spin_unlock(&ls->async_lock);
 	}
 
 	return 0;
 }
 
-static int gdlm_thread1(void *data)
-{
-	return gdlm_thread(data, 1);
-}
-
-static int gdlm_thread2(void *data)
-{
-	return gdlm_thread(data, 0);
-}
-
 int gdlm_init_threads(struct gdlm_ls *ls)
 {
 	struct task_struct *p;
 	int error;
 
-	p = kthread_run(gdlm_thread1, ls, "lock_dlm1");
-	error = IS_ERR(p);
-	if (error) {
-		log_error("can't start lock_dlm1 thread %d", error);
-		return error;
-	}
-	ls->thread1 = p;
-
-	p = kthread_run(gdlm_thread2, ls, "lock_dlm2");
+	p = kthread_run(gdlm_thread, ls, "lock_dlm");
 	error = IS_ERR(p);
 	if (error) {
-		log_error("can't start lock_dlm2 thread %d", error);
-		kthread_stop(ls->thread1);
+		log_error("can't start lock_dlm thread %d", error);
 		return error;
 	}
-	ls->thread2 = p;
+	ls->thread = p;
 
 	return 0;
 }
 
 void gdlm_release_threads(struct gdlm_ls *ls)
 {
-	kthread_stop(ls->thread1);
-	kthread_stop(ls->thread2);
+	kthread_stop(ls->thread);
 }
 
-- 
1.5.1.2

