Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYGKLBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYGKLBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYGKLBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYGKLB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:27 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 01/18] [GFS2] Clean up the glock core
Date: Fri, 11 Jul 2008 11:11:02 +0100
Message-Id: <12157710872782-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <121577107950-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch implements a number of cleanups to the core of the
GFS2 glock code. As a result a lot of code is removed. It looks
like a really big change, but actually a large part of this patch
is either removing or moving existing code.

There are some new bits too though, such as the new run_queue()
function which is considerably streamlined. Highlights of this
patch include:

 o Fixes a cluster coherency bug during SH -> EX lock conversions
 o Removes the "glmutex" code in favour of a single bit lock
 o Removes the ->go_xmote_bh() for inodes since it was duplicating
   ->go_lock()
 o We now only use the ->lm_lock() function for both locks and
   unlocks (i.e. unlock is a lock with target mode LM_ST_UNLOCKED)
 o The fast path is considerably shortly, giving performance gains
   especially with lock_nolock
 o The glock_workqueue is now used for all the callbacks from the DLM
   which allows us to simplify the lock_dlm module (see following patch)
 o The way is now open to make further changes such as eliminating the two
   threads (gfs2_glockd and gfs2_scand) in favour of a more efficient
   scheme.

This patch has undergone extensive testing with various test suites
so it should be pretty stable by now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index d636b3e..519a54c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -45,21 +45,19 @@ struct gfs2_gl_hash_bucket {
         struct hlist_head hb_list;
 };
 
-struct glock_iter {
-	int hash;                     /* hash bucket index         */
-	struct gfs2_sbd *sdp;         /* incore superblock         */
-	struct gfs2_glock *gl;        /* current glock struct      */
-	struct seq_file *seq;         /* sequence file for debugfs */
-	char string[512];             /* scratch space             */
+struct gfs2_glock_iter {
+	int hash;			/* hash bucket index         */
+	struct gfs2_sbd *sdp;		/* incore superblock         */
+	struct gfs2_glock *gl;		/* current glock struct      */
+	char string[512];		/* scratch space             */
 };
 
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
 static int gfs2_dump_lockstate(struct gfs2_sbd *sdp);
-static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl);
-static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh);
-static void gfs2_glock_drop_th(struct gfs2_glock *gl);
-static void run_queue(struct gfs2_glock *gl);
+static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl);
+#define GLOCK_BUG_ON(gl,x) do { if (unlikely(x)) { __dump_glock(NULL, gl); BUG(); } } while(0)
+static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target);
 
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
 static struct dentry *gfs2_root;
@@ -123,33 +121,6 @@ static inline rwlock_t *gl_lock_addr(unsigned int x)
 #endif
 
 /**
- * relaxed_state_ok - is a requested lock compatible with the current lock mode?
- * @actual: the current state of the lock
- * @requested: the lock state that was requested by the caller
- * @flags: the modifier flags passed in by the caller
- *
- * Returns: 1 if the locks are compatible, 0 otherwise
- */
-
-static inline int relaxed_state_ok(unsigned int actual, unsigned requested,
-				   int flags)
-{
-	if (actual == requested)
-		return 1;
-
-	if (flags & GL_EXACT)
-		return 0;
-
-	if (actual == LM_ST_EXCLUSIVE && requested == LM_ST_SHARED)
-		return 1;
-
-	if (actual != LM_ST_UNLOCKED && (flags & LM_FLAG_ANY))
-		return 1;
-
-	return 0;
-}
-
-/**
  * gl_hash() - Turn glock number into hash bucket number
  * @lock: The glock number
  *
@@ -211,17 +182,14 @@ static void gfs2_glock_hold(struct gfs2_glock *gl)
 int gfs2_glock_put(struct gfs2_glock *gl)
 {
 	int rv = 0;
-	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	write_lock(gl_lock_addr(gl->gl_hash));
 	if (atomic_dec_and_test(&gl->gl_ref)) {
 		hlist_del(&gl->gl_list);
 		write_unlock(gl_lock_addr(gl->gl_hash));
-		gfs2_assert(sdp, gl->gl_state == LM_ST_UNLOCKED);
-		gfs2_assert(sdp, list_empty(&gl->gl_reclaim));
-		gfs2_assert(sdp, list_empty(&gl->gl_holders));
-		gfs2_assert(sdp, list_empty(&gl->gl_waiters1));
-		gfs2_assert(sdp, list_empty(&gl->gl_waiters3));
+		GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_UNLOCKED);
+		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_reclaim));
+		GLOCK_BUG_ON(gl, !list_empty(&gl->gl_holders));
 		glock_free(gl);
 		rv = 1;
 		goto out;
@@ -281,16 +249,382 @@ static struct gfs2_glock *gfs2_glock_find(const struct gfs2_sbd *sdp,
 	return gl;
 }
 
+/**
+ * may_grant - check if its ok to grant a new lock
+ * @gl: The glock
+ * @gh: The lock request which we wish to grant
+ *
+ * Returns: true if its ok to grant the lock
+ */
+
+static inline int may_grant(const struct gfs2_glock *gl, const struct gfs2_holder *gh)
+{
+	const struct gfs2_holder *gh_head = list_entry(gl->gl_holders.next, const struct gfs2_holder, gh_list);
+	if ((gh->gh_state == LM_ST_EXCLUSIVE ||
+	     gh_head->gh_state == LM_ST_EXCLUSIVE) && gh != gh_head)
+		return 0;
+	if (gl->gl_state == gh->gh_state)
+		return 1;
+	if (gh->gh_flags & GL_EXACT)
+		return 0;
+	if (gh->gh_state == LM_ST_SHARED && gl->gl_state == LM_ST_EXCLUSIVE)
+		return 1;
+	if (gl->gl_state != LM_ST_UNLOCKED && (gh->gh_flags & LM_FLAG_ANY))
+		return 1;
+	return 0;
+}
+
+static void gfs2_holder_wake(struct gfs2_holder *gh)
+{
+	clear_bit(HIF_WAIT, &gh->gh_iflags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
+}
+
+/**
+ * do_promote - promote as many requests as possible on the current queue
+ * @gl: The glock
+ * 
+ * Returns: true if there is a blocked holder at the head of the list
+ */
+
+static int do_promote(struct gfs2_glock *gl)
+{
+	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	struct gfs2_holder *gh, *tmp;
+	int ret;
+
+restart:
+	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			continue;
+		if (may_grant(gl, gh)) {
+			if (gh->gh_list.prev == &gl->gl_holders &&
+			    glops->go_lock) {
+				spin_unlock(&gl->gl_spin);
+				/* FIXME: eliminate this eventually */
+				ret = glops->go_lock(gh);
+				spin_lock(&gl->gl_spin);
+				if (ret) {
+					gh->gh_error = ret;
+					list_del_init(&gh->gh_list);
+					gfs2_holder_wake(gh);
+					goto restart;
+				}
+				set_bit(HIF_HOLDER, &gh->gh_iflags);
+				gfs2_holder_wake(gh);
+				goto restart;
+			}
+			set_bit(HIF_HOLDER, &gh->gh_iflags);
+			gfs2_holder_wake(gh);
+			continue;
+		}
+		if (gh->gh_list.prev == &gl->gl_holders)
+			return 1;
+		break;
+	}
+	return 0;
+}
+
+/**
+ * do_error - Something unexpected has happened during a lock request
+ *
+ */
+
+static inline void do_error(struct gfs2_glock *gl, const int ret)
+{
+	struct gfs2_holder *gh, *tmp;
+
+	list_for_each_entry_safe(gh, tmp, &gl->gl_holders, gh_list) {
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			continue;
+		if (ret & LM_OUT_ERROR)
+			gh->gh_error = -EIO;
+		else if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))
+			gh->gh_error = GLR_TRYFAILED;
+		else
+			continue;
+		list_del_init(&gh->gh_list);
+		gfs2_holder_wake(gh);
+	}
+}
+
+/**
+ * find_first_waiter - find the first gh that's waiting for the glock
+ * @gl: the glock
+ */
+
+static inline struct gfs2_holder *find_first_waiter(const struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
+/**
+ * state_change - record that the glock is now in a different state
+ * @gl: the glock
+ * @new_state the new state
+ *
+ */
+
+static void state_change(struct gfs2_glock *gl, unsigned int new_state)
+{
+	int held1, held2;
+
+	held1 = (gl->gl_state != LM_ST_UNLOCKED);
+	held2 = (new_state != LM_ST_UNLOCKED);
+
+	if (held1 != held2) {
+		if (held2)
+			gfs2_glock_hold(gl);
+		else
+			gfs2_glock_put(gl);
+	}
+
+	gl->gl_state = new_state;
+	gl->gl_tchange = jiffies;
+}
+
+static void gfs2_demote_wake(struct gfs2_glock *gl)
+{
+	gl->gl_demote_state = LM_ST_EXCLUSIVE;
+	clear_bit(GLF_DEMOTE, &gl->gl_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
+}
+
+/**
+ * finish_xmote - The DLM has replied to one of our lock requests
+ * @gl: The glock
+ * @ret: The status from the DLM
+ *
+ */
+
+static void finish_xmote(struct gfs2_glock *gl, unsigned int ret)
+{
+	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	struct gfs2_holder *gh;
+	unsigned state = ret & LM_OUT_ST_MASK;
+
+	spin_lock(&gl->gl_spin);
+	state_change(gl, state);
+	gh = find_first_waiter(gl);
+
+	/* Demote to UN request arrived during demote to SH or DF */
+	if (test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags) &&
+	    state != LM_ST_UNLOCKED && gl->gl_demote_state == LM_ST_UNLOCKED)
+		gl->gl_target = LM_ST_UNLOCKED;
+
+	/* Check for state != intended state */
+	if (unlikely(state != gl->gl_target)) {
+		if (gh && !test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags)) {
+			/* move to back of queue and try next entry */
+			if (ret & LM_OUT_CANCELED) {
+				if ((gh->gh_flags & LM_FLAG_PRIORITY) == 0)
+					list_move_tail(&gh->gh_list, &gl->gl_holders);
+				gh = find_first_waiter(gl);
+				gl->gl_target = gh->gh_state;
+				goto retry;
+			}
+			/* Some error or failed "try lock" - report it */
+			if ((ret & LM_OUT_ERROR) ||
+			    (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))) {
+				gl->gl_target = gl->gl_state;
+				do_error(gl, ret);
+				goto out;
+			}
+		}
+		switch(state) {
+		/* Unlocked due to conversion deadlock, try again */
+		case LM_ST_UNLOCKED:
+retry:
+			do_xmote(gl, gh, gl->gl_target);
+			break;
+		/* Conversion fails, unlock and try again */
+		case LM_ST_SHARED:
+		case LM_ST_DEFERRED:
+			do_xmote(gl, gh, LM_ST_UNLOCKED);
+			break;
+		default: /* Everything else */
+			printk(KERN_ERR "GFS2: wanted %u got %u\n", gl->gl_target, state);
+			GLOCK_BUG_ON(gl, 1);
+		}
+		spin_unlock(&gl->gl_spin);
+		gfs2_glock_put(gl);
+		return;
+	}
+
+	/* Fast path - we got what we asked for */
+	if (test_and_clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags))
+		gfs2_demote_wake(gl);
+	if (state != LM_ST_UNLOCKED) {
+		if (glops->go_xmote_bh) {
+			int rv;
+			spin_unlock(&gl->gl_spin);
+			rv = glops->go_xmote_bh(gl, gh);
+			if (rv == -EAGAIN)
+				return;
+			spin_lock(&gl->gl_spin);
+			if (rv) {
+				do_error(gl, rv);
+				goto out;
+			}
+		}
+		do_promote(gl);
+	}
+out:
+	clear_bit(GLF_LOCK, &gl->gl_flags);
+	spin_unlock(&gl->gl_spin);
+	gfs2_glock_put(gl);
+}
+
+static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
+				 unsigned int cur_state, unsigned int req_state,
+				 unsigned int flags)
+{
+	int ret = LM_OUT_ERROR;
+	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
+		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock, cur_state,
+							 req_state, flags);
+	return ret;
+}
+
+/**
+ * do_xmote - Calls the DLM to change the state of a lock
+ * @gl: The lock state
+ * @gh: The holder (only for promotes)
+ * @target: The target lock state
+ *
+ */
+
+static void do_xmote(struct gfs2_glock *gl, struct gfs2_holder *gh, unsigned int target)
+{
+	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	unsigned int lck_flags = gh ? gh->gh_flags : 0;
+	int ret;
+
+	lck_flags &= (LM_FLAG_TRY | LM_FLAG_TRY_1CB | LM_FLAG_NOEXP |
+		      LM_FLAG_PRIORITY);
+	BUG_ON(gl->gl_state == target);
+	BUG_ON(gl->gl_state == gl->gl_target);
+	if ((target == LM_ST_UNLOCKED || target == LM_ST_DEFERRED) &&
+	    glops->go_inval) {
+		set_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
+		do_error(gl, 0); /* Fail queued try locks */
+	}
+	spin_unlock(&gl->gl_spin);
+	if (glops->go_xmote_th)
+		glops->go_xmote_th(gl);
+	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
+		glops->go_inval(gl, target == LM_ST_DEFERRED ? 0 : DIO_METADATA);
+	clear_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags);
+
+	gfs2_glock_hold(gl);
+	if (target != LM_ST_UNLOCKED && (gl->gl_state == LM_ST_SHARED ||
+	    gl->gl_state == LM_ST_DEFERRED) &&
+	    !(lck_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
+		lck_flags |= LM_FLAG_TRY_1CB;
+	ret = gfs2_lm_lock(sdp, gl->gl_lock, gl->gl_state, target, lck_flags);
+
+	if (!(ret & LM_OUT_ASYNC)) {
+		finish_xmote(gl, ret);
+		gfs2_glock_hold(gl);
+		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+			gfs2_glock_put(gl);
+	} else {
+		GLOCK_BUG_ON(gl, ret != LM_OUT_ASYNC);
+	}
+	spin_lock(&gl->gl_spin);
+}
+
+/**
+ * find_first_holder - find the first "holder" gh
+ * @gl: the glock
+ */
+
+static inline struct gfs2_holder *find_first_holder(const struct gfs2_glock *gl)
+{
+	struct gfs2_holder *gh;
+
+	if (!list_empty(&gl->gl_holders)) {
+		gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
+		if (test_bit(HIF_HOLDER, &gh->gh_iflags))
+			return gh;
+	}
+	return NULL;
+}
+
+/**
+ * run_queue - do all outstanding tasks related to a glock
+ * @gl: The glock in question
+ * @nonblock: True if we must not block in run_queue
+ *
+ */
+
+static void run_queue(struct gfs2_glock *gl, const int nonblock)
+{
+	struct gfs2_holder *gh = NULL;
+
+	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags))
+		return;
+
+	GLOCK_BUG_ON(gl, test_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags));
+
+	if (test_bit(GLF_DEMOTE, &gl->gl_flags) &&
+	    gl->gl_demote_state != gl->gl_state) {
+		if (find_first_holder(gl))
+			goto out;
+		if (nonblock)
+			goto out_sched;
+		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
+		gl->gl_target = gl->gl_demote_state;
+	} else {
+		if (test_bit(GLF_DEMOTE, &gl->gl_flags))
+			gfs2_demote_wake(gl);
+		if (do_promote(gl) == 0)
+			goto out;
+		gh = find_first_waiter(gl);
+		gl->gl_target = gh->gh_state;
+		if (!(gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)))
+			do_error(gl, 0); /* Fail queued try locks */
+	}
+	do_xmote(gl, gh, gl->gl_target);
+	return;
+
+out_sched:
+	gfs2_glock_hold(gl);
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+		gfs2_glock_put(gl);
+out:
+	clear_bit(GLF_LOCK, &gl->gl_flags);
+}
+
 static void glock_work_func(struct work_struct *work)
 {
+	unsigned long delay = 0;
 	struct gfs2_glock *gl = container_of(work, struct gfs2_glock, gl_work.work);
 
+	if (test_and_clear_bit(GLF_REPLY_PENDING, &gl->gl_flags))
+		finish_xmote(gl, gl->gl_reply);
 	spin_lock(&gl->gl_spin);
-	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags))
-		set_bit(GLF_DEMOTE, &gl->gl_flags);
-	run_queue(gl);
+	if (test_and_clear_bit(GLF_PENDING_DEMOTE, &gl->gl_flags)) {
+		unsigned long holdtime, now = jiffies;
+		holdtime = gl->gl_tchange + gl->gl_ops->go_min_hold_time;
+		if (time_before(now, holdtime))
+			delay = holdtime - now;
+		set_bit(delay ? GLF_PENDING_DEMOTE : GLF_DEMOTE, &gl->gl_flags);
+	}
+	run_queue(gl, 0);
 	spin_unlock(&gl->gl_spin);
-	gfs2_glock_put(gl);
+	if (!delay ||
+	    queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
+		gfs2_glock_put(gl);
 }
 
 static int gfs2_lm_get_lock(struct gfs2_sbd *sdp, struct lm_lockname *name,
@@ -342,12 +676,10 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	gl->gl_name = name;
 	atomic_set(&gl->gl_ref, 1);
 	gl->gl_state = LM_ST_UNLOCKED;
+	gl->gl_target = LM_ST_UNLOCKED;
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
 	gl->gl_hash = hash;
-	gl->gl_owner_pid = NULL;
-	gl->gl_ip = 0;
 	gl->gl_ops = glops;
-	gl->gl_req_gh = NULL;
 	gl->gl_stamp = jiffies;
 	gl->gl_tchange = jiffies;
 	gl->gl_object = NULL;
@@ -447,13 +779,6 @@ void gfs2_holder_uninit(struct gfs2_holder *gh)
 	gh->gh_ip = 0;
 }
 
-static void gfs2_holder_wake(struct gfs2_holder *gh)
-{
-	clear_bit(HIF_WAIT, &gh->gh_iflags);
-	smp_mb__after_clear_bit();
-	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
-}
-
 static int just_schedule(void *word)
 {
         schedule();
@@ -466,14 +791,6 @@ static void wait_on_holder(struct gfs2_holder *gh)
 	wait_on_bit(&gh->gh_iflags, HIF_WAIT, just_schedule, TASK_UNINTERRUPTIBLE);
 }
 
-static void gfs2_demote_wake(struct gfs2_glock *gl)
-{
-	gl->gl_demote_state = LM_ST_EXCLUSIVE;
-        clear_bit(GLF_DEMOTE, &gl->gl_flags);
-        smp_mb__after_clear_bit();
-        wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
-}
-
 static void wait_on_demote(struct gfs2_glock *gl)
 {
 	might_sleep();
@@ -481,217 +798,6 @@ static void wait_on_demote(struct gfs2_glock *gl)
 }
 
 /**
- * rq_mutex - process a mutex request in the queue
- * @gh: the glock holder
- *
- * Returns: 1 if the queue is blocked
- */
-
-static int rq_mutex(struct gfs2_holder *gh)
-{
-	struct gfs2_glock *gl = gh->gh_gl;
-
-	list_del_init(&gh->gh_list);
-	/*  gh->gh_error never examined.  */
-	set_bit(GLF_LOCK, &gl->gl_flags);
-	clear_bit(HIF_WAIT, &gh->gh_iflags);
-	smp_mb();
-	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
-
-	return 1;
-}
-
-/**
- * rq_promote - process a promote request in the queue
- * @gh: the glock holder
- *
- * Acquire a new inter-node lock, or change a lock state to more restrictive.
- *
- * Returns: 1 if the queue is blocked
- */
-
-static int rq_promote(struct gfs2_holder *gh)
-{
-	struct gfs2_glock *gl = gh->gh_gl;
-
-	if (!relaxed_state_ok(gl->gl_state, gh->gh_state, gh->gh_flags)) {
-		if (list_empty(&gl->gl_holders)) {
-			gl->gl_req_gh = gh;
-			set_bit(GLF_LOCK, &gl->gl_flags);
-			spin_unlock(&gl->gl_spin);
-			gfs2_glock_xmote_th(gh->gh_gl, gh);
-			spin_lock(&gl->gl_spin);
-		}
-		return 1;
-	}
-
-	if (list_empty(&gl->gl_holders)) {
-		set_bit(HIF_FIRST, &gh->gh_iflags);
-		set_bit(GLF_LOCK, &gl->gl_flags);
-	} else {
-		struct gfs2_holder *next_gh;
-		if (gh->gh_state == LM_ST_EXCLUSIVE)
-			return 1;
-		next_gh = list_entry(gl->gl_holders.next, struct gfs2_holder,
-				     gh_list);
-		if (next_gh->gh_state == LM_ST_EXCLUSIVE)
-			 return 1;
-	}
-
-	list_move_tail(&gh->gh_list, &gl->gl_holders);
-	gh->gh_error = 0;
-	set_bit(HIF_HOLDER, &gh->gh_iflags);
-
-	gfs2_holder_wake(gh);
-
-	return 0;
-}
-
-/**
- * rq_demote - process a demote request in the queue
- * @gh: the glock holder
- *
- * Returns: 1 if the queue is blocked
- */
-
-static int rq_demote(struct gfs2_glock *gl)
-{
-	if (!list_empty(&gl->gl_holders))
-		return 1;
-
-	if (gl->gl_state == gl->gl_demote_state ||
-	    gl->gl_state == LM_ST_UNLOCKED) {
-		gfs2_demote_wake(gl);
-		return 0;
-	}
-
-	set_bit(GLF_LOCK, &gl->gl_flags);
-	set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
-
-	if (gl->gl_demote_state == LM_ST_UNLOCKED ||
-	    gl->gl_state != LM_ST_EXCLUSIVE) {
-		spin_unlock(&gl->gl_spin);
-		gfs2_glock_drop_th(gl);
-	} else {
-		spin_unlock(&gl->gl_spin);
-		gfs2_glock_xmote_th(gl, NULL);
-	}
-
-	spin_lock(&gl->gl_spin);
-	clear_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
-
-	return 0;
-}
-
-/**
- * run_queue - process holder structures on a glock
- * @gl: the glock
- *
- */
-static void run_queue(struct gfs2_glock *gl)
-{
-	struct gfs2_holder *gh;
-	int blocked = 1;
-
-	for (;;) {
-		if (test_bit(GLF_LOCK, &gl->gl_flags))
-			break;
-
-		if (!list_empty(&gl->gl_waiters1)) {
-			gh = list_entry(gl->gl_waiters1.next,
-					struct gfs2_holder, gh_list);
-			blocked = rq_mutex(gh);
-		} else if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
-			blocked = rq_demote(gl);
-			if (test_bit(GLF_WAITERS2, &gl->gl_flags) &&
-				     !blocked) {
-				set_bit(GLF_DEMOTE, &gl->gl_flags);
-				gl->gl_demote_state = LM_ST_UNLOCKED;
-			}
-			clear_bit(GLF_WAITERS2, &gl->gl_flags);
-		} else if (!list_empty(&gl->gl_waiters3)) {
-			gh = list_entry(gl->gl_waiters3.next,
-					struct gfs2_holder, gh_list);
-			blocked = rq_promote(gh);
-		} else
-			break;
-
-		if (blocked)
-			break;
-	}
-}
-
-/**
- * gfs2_glmutex_lock - acquire a local lock on a glock
- * @gl: the glock
- *
- * Gives caller exclusive access to manipulate a glock structure.
- */
-
-static void gfs2_glmutex_lock(struct gfs2_glock *gl)
-{
-	spin_lock(&gl->gl_spin);
-	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
-		struct gfs2_holder gh;
-
-		gfs2_holder_init(gl, 0, 0, &gh);
-		set_bit(HIF_WAIT, &gh.gh_iflags);
-		list_add_tail(&gh.gh_list, &gl->gl_waiters1);
-		spin_unlock(&gl->gl_spin);
-		wait_on_holder(&gh);
-		gfs2_holder_uninit(&gh);
-	} else {
-		gl->gl_owner_pid = get_pid(task_pid(current));
-		gl->gl_ip = (unsigned long)__builtin_return_address(0);
-		spin_unlock(&gl->gl_spin);
-	}
-}
-
-/**
- * gfs2_glmutex_trylock - try to acquire a local lock on a glock
- * @gl: the glock
- *
- * Returns: 1 if the glock is acquired
- */
-
-static int gfs2_glmutex_trylock(struct gfs2_glock *gl)
-{
-	int acquired = 1;
-
-	spin_lock(&gl->gl_spin);
-	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
-		acquired = 0;
-	} else {
-		gl->gl_owner_pid = get_pid(task_pid(current));
-		gl->gl_ip = (unsigned long)__builtin_return_address(0);
-	}
-	spin_unlock(&gl->gl_spin);
-
-	return acquired;
-}
-
-/**
- * gfs2_glmutex_unlock - release a local lock on a glock
- * @gl: the glock
- *
- */
-
-static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
-{
-	struct pid *pid;
-
-	spin_lock(&gl->gl_spin);
-	clear_bit(GLF_LOCK, &gl->gl_flags);
-	pid = gl->gl_owner_pid;
-	gl->gl_owner_pid = NULL;
-	gl->gl_ip = 0;
-	run_queue(gl);
-	spin_unlock(&gl->gl_spin);
-
-	put_pid(pid);
-}
-
-/**
  * handle_callback - process a demote request
  * @gl: the glock
  * @state: the state the caller wants us to change to
@@ -705,398 +811,45 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 {
 	int bit = delay ? GLF_PENDING_DEMOTE : GLF_DEMOTE;
 
-	spin_lock(&gl->gl_spin);
 	set_bit(bit, &gl->gl_flags);
 	if (gl->gl_demote_state == LM_ST_EXCLUSIVE) {
 		gl->gl_demote_state = state;
 		gl->gl_demote_time = jiffies;
 		if (remote && gl->gl_ops->go_type == LM_TYPE_IOPEN &&
-		    gl->gl_object) {
+		    gl->gl_object)
 			gfs2_glock_schedule_for_reclaim(gl);
-			spin_unlock(&gl->gl_spin);
-			return;
-		}
 	} else if (gl->gl_demote_state != LM_ST_UNLOCKED &&
 			gl->gl_demote_state != state) {
-		if (test_bit(GLF_DEMOTE_IN_PROGRESS,  &gl->gl_flags)) 
-			set_bit(GLF_WAITERS2, &gl->gl_flags);
-		else 
-			gl->gl_demote_state = LM_ST_UNLOCKED;
+		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
-	spin_unlock(&gl->gl_spin);
 }
 
 /**
- * state_change - record that the glock is now in a different state
- * @gl: the glock
- * @new_state the new state
- *
- */
-
-static void state_change(struct gfs2_glock *gl, unsigned int new_state)
-{
-	int held1, held2;
-
-	held1 = (gl->gl_state != LM_ST_UNLOCKED);
-	held2 = (new_state != LM_ST_UNLOCKED);
-
-	if (held1 != held2) {
-		if (held2)
-			gfs2_glock_hold(gl);
-		else
-			gfs2_glock_put(gl);
-	}
-
-	gl->gl_state = new_state;
-	gl->gl_tchange = jiffies;
-}
-
-/**
- * drop_bh - Called after a lock module unlock completes
- * @gl: the glock
- * @ret: the return status
- *
- * Doesn't wake up the process waiting on the struct gfs2_holder (if any)
- * Doesn't drop the reference on the glock the top half took out
- *
- */
-
-static void drop_bh(struct gfs2_glock *gl, unsigned int ret)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	struct gfs2_holder *gh = gl->gl_req_gh;
-
-	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
-	gfs2_assert_warn(sdp, !ret);
-
-	state_change(gl, LM_ST_UNLOCKED);
-
-	if (test_and_clear_bit(GLF_CONV_DEADLK, &gl->gl_flags)) {
-		spin_lock(&gl->gl_spin);
-		gh->gh_error = 0;
-		spin_unlock(&gl->gl_spin);
-		gfs2_glock_xmote_th(gl, gl->gl_req_gh);
-		gfs2_glock_put(gl);
-		return;
-	}
-
-	spin_lock(&gl->gl_spin);
-	gfs2_demote_wake(gl);
-	clear_bit(GLF_LOCK, &gl->gl_flags);
-	spin_unlock(&gl->gl_spin);
-	gfs2_glock_put(gl);
-}
-
-/**
- * xmote_bh - Called after the lock module is done acquiring a lock
- * @gl: The glock in question
- * @ret: the int returned from the lock module
- *
- */
-
-static void xmote_bh(struct gfs2_glock *gl, unsigned int ret)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	struct gfs2_holder *gh = gl->gl_req_gh;
-	int op_done = 1;
-
-	if (!gh && (ret & LM_OUT_ST_MASK) == LM_ST_UNLOCKED) {
-		drop_bh(gl, ret);
-		return;
-	}
-
-	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
-	gfs2_assert_warn(sdp, !(ret & LM_OUT_ASYNC));
-
-	state_change(gl, ret & LM_OUT_ST_MASK);
-
-	/*  Deal with each possible exit condition  */
-
-	if (!gh) {
-		gl->gl_stamp = jiffies;
-		if (ret & LM_OUT_CANCELED) {
-			op_done = 0;
-		} else {
-			spin_lock(&gl->gl_spin);
-			if (gl->gl_state != gl->gl_demote_state) {
-				spin_unlock(&gl->gl_spin);
-				gfs2_glock_drop_th(gl);
-				gfs2_glock_put(gl);
-				return;
-			}
-			gfs2_demote_wake(gl);
-			spin_unlock(&gl->gl_spin);
-		}
-	} else {
-		spin_lock(&gl->gl_spin);
-		if (ret & LM_OUT_CONV_DEADLK) {
-			gh->gh_error = 0;
-			set_bit(GLF_CONV_DEADLK, &gl->gl_flags);
-			spin_unlock(&gl->gl_spin);
-			gfs2_glock_drop_th(gl);
-			gfs2_glock_put(gl);
-			return;
-		}
-		list_del_init(&gh->gh_list);
-		gh->gh_error = -EIO;
-		if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) 
-			goto out;
-		gh->gh_error = GLR_CANCELED;
-		if (ret & LM_OUT_CANCELED) 
-			goto out;
-		if (relaxed_state_ok(gl->gl_state, gh->gh_state, gh->gh_flags)) {
-			list_add_tail(&gh->gh_list, &gl->gl_holders);
-			gh->gh_error = 0;
-			set_bit(HIF_HOLDER, &gh->gh_iflags);
-			set_bit(HIF_FIRST, &gh->gh_iflags);
-			op_done = 0;
-			goto out;
-		}
-		gh->gh_error = GLR_TRYFAILED;
-		if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB))
-			goto out;
-		gh->gh_error = -EINVAL;
-		if (gfs2_assert_withdraw(sdp, 0) == -1)
-			fs_err(sdp, "ret = 0x%.8X\n", ret);
-out:
-		spin_unlock(&gl->gl_spin);
-	}
-
-	if (glops->go_xmote_bh)
-		glops->go_xmote_bh(gl);
-
-	if (op_done) {
-		spin_lock(&gl->gl_spin);
-		gl->gl_req_gh = NULL;
-		clear_bit(GLF_LOCK, &gl->gl_flags);
-		spin_unlock(&gl->gl_spin);
-	}
-
-	gfs2_glock_put(gl);
-
-	if (gh)
-		gfs2_holder_wake(gh);
-}
-
-static unsigned int gfs2_lm_lock(struct gfs2_sbd *sdp, void *lock,
-				 unsigned int cur_state, unsigned int req_state,
-				 unsigned int flags)
-{
-	int ret = 0;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret = sdp->sd_lockstruct.ls_ops->lm_lock(lock, cur_state,
-							 req_state, flags);
-	return ret;
-}
-
-/**
- * gfs2_glock_xmote_th - Call into the lock module to acquire or change a glock
- * @gl: The glock in question
- * @state: the requested state
- * @flags: modifier flags to the lock call
- *
- */
-
-static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	int flags = gh ? gh->gh_flags : 0;
-	unsigned state = gh ? gh->gh_state : gl->gl_demote_state;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	int lck_flags = flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB |
-				 LM_FLAG_NOEXP | LM_FLAG_ANY |
-				 LM_FLAG_PRIORITY);
-	unsigned int lck_ret;
-
-	if (glops->go_xmote_th)
-		glops->go_xmote_th(gl);
-	if (state == LM_ST_DEFERRED && glops->go_inval)
-		glops->go_inval(gl, DIO_METADATA);
-
-	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
-	gfs2_assert_warn(sdp, state != LM_ST_UNLOCKED);
-	gfs2_assert_warn(sdp, state != gl->gl_state);
-
-	gfs2_glock_hold(gl);
-
-	lck_ret = gfs2_lm_lock(sdp, gl->gl_lock, gl->gl_state, state, lck_flags);
-
-	if (gfs2_assert_withdraw(sdp, !(lck_ret & LM_OUT_ERROR)))
-		return;
-
-	if (lck_ret & LM_OUT_ASYNC)
-		gfs2_assert_warn(sdp, lck_ret == LM_OUT_ASYNC);
-	else
-		xmote_bh(gl, lck_ret);
-}
-
-static unsigned int gfs2_lm_unlock(struct gfs2_sbd *sdp, void *lock,
-				   unsigned int cur_state)
-{
-	int ret = 0;
-	if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-		ret =  sdp->sd_lockstruct.ls_ops->lm_unlock(lock, cur_state);
-	return ret;
-}
-
-/**
- * gfs2_glock_drop_th - call into the lock module to unlock a lock
- * @gl: the glock
- *
- */
-
-static void gfs2_glock_drop_th(struct gfs2_glock *gl)
-{
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-	unsigned int ret;
-
-	if (glops->go_xmote_th)
-		glops->go_xmote_th(gl);
-	if (glops->go_inval)
-		glops->go_inval(gl, DIO_METADATA);
-
-	gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-	gfs2_assert_warn(sdp, list_empty(&gl->gl_holders));
-	gfs2_assert_warn(sdp, gl->gl_state != LM_ST_UNLOCKED);
-
-	gfs2_glock_hold(gl);
-
-	ret = gfs2_lm_unlock(sdp, gl->gl_lock, gl->gl_state);
-
-	if (gfs2_assert_withdraw(sdp, !(ret & LM_OUT_ERROR)))
-		return;
-
-	if (!ret)
-		drop_bh(gl, ret);
-	else
-		gfs2_assert_warn(sdp, ret == LM_OUT_ASYNC);
-}
-
-/**
- * do_cancels - cancel requests for locks stuck waiting on an expire flag
- * @gh: the LM_FLAG_PRIORITY holder waiting to acquire the lock
- *
- * Don't cancel GL_NOCANCEL requests.
- */
-
-static void do_cancels(struct gfs2_holder *gh)
-{
-	struct gfs2_glock *gl = gh->gh_gl;
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-
-	spin_lock(&gl->gl_spin);
-
-	while (gl->gl_req_gh != gh &&
-	       !test_bit(HIF_HOLDER, &gh->gh_iflags) &&
-	       !list_empty(&gh->gh_list)) {
-		if (!(gl->gl_req_gh && (gl->gl_req_gh->gh_flags & GL_NOCANCEL))) {
-			spin_unlock(&gl->gl_spin);
-			if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
-				sdp->sd_lockstruct.ls_ops->lm_cancel(gl->gl_lock);
-			msleep(100);
-			spin_lock(&gl->gl_spin);
-		} else {
-			spin_unlock(&gl->gl_spin);
-			msleep(100);
-			spin_lock(&gl->gl_spin);
-		}
-	}
-
-	spin_unlock(&gl->gl_spin);
-}
-
-/**
- * glock_wait_internal - wait on a glock acquisition
+ * gfs2_glock_wait - wait on a glock acquisition
  * @gh: the glock holder
  *
  * Returns: 0 on success
  */
 
-static int glock_wait_internal(struct gfs2_holder *gh)
+int gfs2_glock_wait(struct gfs2_holder *gh)
 {
-	struct gfs2_glock *gl = gh->gh_gl;
-	struct gfs2_sbd *sdp = gl->gl_sbd;
-	const struct gfs2_glock_operations *glops = gl->gl_ops;
-
-	if (test_bit(HIF_ABORTED, &gh->gh_iflags))
-		return -EIO;
-
-	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
-		spin_lock(&gl->gl_spin);
-		if (gl->gl_req_gh != gh &&
-		    !test_bit(HIF_HOLDER, &gh->gh_iflags) &&
-		    !list_empty(&gh->gh_list)) {
-			list_del_init(&gh->gh_list);
-			gh->gh_error = GLR_TRYFAILED;
-			run_queue(gl);
-			spin_unlock(&gl->gl_spin);
-			return gh->gh_error;
-		}
-		spin_unlock(&gl->gl_spin);
-	}
-
-	if (gh->gh_flags & LM_FLAG_PRIORITY)
-		do_cancels(gh);
-
 	wait_on_holder(gh);
-	if (gh->gh_error)
-		return gh->gh_error;
-
-	gfs2_assert_withdraw(sdp, test_bit(HIF_HOLDER, &gh->gh_iflags));
-	gfs2_assert_withdraw(sdp, relaxed_state_ok(gl->gl_state, gh->gh_state,
-						   gh->gh_flags));
-
-	if (test_bit(HIF_FIRST, &gh->gh_iflags)) {
-		gfs2_assert_warn(sdp, test_bit(GLF_LOCK, &gl->gl_flags));
-
-		if (glops->go_lock) {
-			gh->gh_error = glops->go_lock(gh);
-			if (gh->gh_error) {
-				spin_lock(&gl->gl_spin);
-				list_del_init(&gh->gh_list);
-				spin_unlock(&gl->gl_spin);
-			}
-		}
-
-		spin_lock(&gl->gl_spin);
-		gl->gl_req_gh = NULL;
-		clear_bit(GLF_LOCK, &gl->gl_flags);
-		run_queue(gl);
-		spin_unlock(&gl->gl_spin);
-	}
-
 	return gh->gh_error;
 }
 
-static inline struct gfs2_holder *
-find_holder_by_owner(struct list_head *head, struct pid *pid)
-{
-	struct gfs2_holder *gh;
-
-	list_for_each_entry(gh, head, gh_list) {
-		if (gh->gh_owner_pid == pid)
-			return gh;
-	}
-
-	return NULL;
-}
-
-static void print_dbg(struct glock_iter *gi, const char *fmt, ...)
+void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 {
 	va_list args;
 
 	va_start(args, fmt);
-	if (gi) {
+	if (seq) {
+		struct gfs2_glock_iter *gi = seq->private;
 		vsprintf(gi->string, fmt, args);
-		seq_printf(gi->seq, gi->string);
-	}
-	else
+		seq_printf(seq, gi->string);
+	} else {
+		printk(KERN_ERR " ");
 		vprintk(fmt, args);
+	}
 	va_end(args);
 }
 
@@ -1104,50 +857,75 @@ static void print_dbg(struct glock_iter *gi, const char *fmt, ...)
  * add_to_queue - Add a holder to the wait queue (but look for recursion)
  * @gh: the holder structure to add
  *
+ * Eventually we should move the recursive locking trap to a
+ * debugging option or something like that. This is the fast
+ * path and needs to have the minimum number of distractions.
+ * 
  */
 
-static void add_to_queue(struct gfs2_holder *gh)
+static inline void add_to_queue(struct gfs2_holder *gh)
 {
 	struct gfs2_glock *gl = gh->gh_gl;
-	struct gfs2_holder *existing;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct list_head *insert_pt = NULL;
+	struct gfs2_holder *gh2;
+	int try_lock = 0;
 
 	BUG_ON(gh->gh_owner_pid == NULL);
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
 		BUG();
 
-	if (!(gh->gh_flags & GL_FLOCK)) {
-		existing = find_holder_by_owner(&gl->gl_holders, 
-						gh->gh_owner_pid);
-		if (existing) {
-			print_symbol(KERN_WARNING "original: %s\n", 
-				     existing->gh_ip);
-			printk(KERN_INFO "pid : %d\n",
-					pid_nr(existing->gh_owner_pid));
-			printk(KERN_INFO "lock type : %d lock state : %d\n",
-			       existing->gh_gl->gl_name.ln_type, 
-			       existing->gh_gl->gl_state);
-			print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
-			printk(KERN_INFO "pid : %d\n",
-					pid_nr(gh->gh_owner_pid));
-			printk(KERN_INFO "lock type : %d lock state : %d\n",
-			       gl->gl_name.ln_type, gl->gl_state);
-			BUG();
-		}
-		
-		existing = find_holder_by_owner(&gl->gl_waiters3, 
-						gh->gh_owner_pid);
-		if (existing) {
-			print_symbol(KERN_WARNING "original: %s\n", 
-				     existing->gh_ip);
-			print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
-			BUG();
+	if (gh->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) {
+		if (test_bit(GLF_LOCK, &gl->gl_flags))
+			try_lock = 1;
+		if (test_bit(GLF_INVALIDATE_IN_PROGRESS, &gl->gl_flags))
+			goto fail;
+	}
+
+	list_for_each_entry(gh2, &gl->gl_holders, gh_list) {
+		if (unlikely(gh2->gh_owner_pid == gh->gh_owner_pid &&
+		    (gh->gh_gl->gl_ops->go_type != LM_TYPE_FLOCK)))
+			goto trap_recursive;
+		if (try_lock &&
+		    !(gh2->gh_flags & (LM_FLAG_TRY | LM_FLAG_TRY_1CB)) &&
+		    !may_grant(gl, gh)) {
+fail:
+			gh->gh_error = GLR_TRYFAILED;
+			gfs2_holder_wake(gh);
+			return;
 		}
+		if (test_bit(HIF_HOLDER, &gh2->gh_iflags))
+			continue;
+		if (unlikely((gh->gh_flags & LM_FLAG_PRIORITY) && !insert_pt))
+			insert_pt = &gh2->gh_list;
+	}
+	if (likely(insert_pt == NULL)) {
+		list_add_tail(&gh->gh_list, &gl->gl_holders);
+		if (unlikely(gh->gh_flags & LM_FLAG_PRIORITY))
+			goto do_cancel;
+		return;
 	}
+	list_add_tail(&gh->gh_list, insert_pt);
+do_cancel:
+	gh = list_entry(gl->gl_holders.next, struct gfs2_holder, gh_list);
+	if (!(gh->gh_flags & LM_FLAG_PRIORITY)) {
+		spin_unlock(&gl->gl_spin);
+		sdp->sd_lockstruct.ls_ops->lm_cancel(gl->gl_lock);
+		spin_lock(&gl->gl_spin);
+	}
+	return;
 
-	if (gh->gh_flags & LM_FLAG_PRIORITY)
-		list_add(&gh->gh_list, &gl->gl_waiters3);
-	else
-		list_add_tail(&gh->gh_list, &gl->gl_waiters3);
+trap_recursive:
+	print_symbol(KERN_ERR "original: %s\n", gh2->gh_ip);
+	printk(KERN_ERR "pid: %d\n", pid_nr(gh2->gh_owner_pid));
+	printk(KERN_ERR "lock type: %d req lock state : %d\n",
+	       gh2->gh_gl->gl_name.ln_type, gh2->gh_state);
+	print_symbol(KERN_ERR "new: %s\n", gh->gh_ip);
+	printk(KERN_ERR "pid: %d\n", pid_nr(gh->gh_owner_pid));
+	printk(KERN_ERR "lock type: %d req lock state : %d\n",
+	       gh->gh_gl->gl_name.ln_type, gh->gh_state);
+	__dump_glock(NULL, gl);
+	BUG();
 }
 
 /**
@@ -1165,24 +943,16 @@ int gfs2_glock_nq(struct gfs2_holder *gh)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	int error = 0;
 
-restart:
-	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
-		set_bit(HIF_ABORTED, &gh->gh_iflags);
+	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		return -EIO;
-	}
 
 	spin_lock(&gl->gl_spin);
 	add_to_queue(gh);
-	run_queue(gl);
+	run_queue(gl, 1);
 	spin_unlock(&gl->gl_spin);
 
-	if (!(gh->gh_flags & GL_ASYNC)) {
-		error = glock_wait_internal(gh);
-		if (error == GLR_CANCELED) {
-			msleep(100);
-			goto restart;
-		}
-	}
+	if (!(gh->gh_flags & GL_ASYNC))
+		error = gfs2_glock_wait(gh);
 
 	return error;
 }
@@ -1196,48 +966,7 @@ restart:
 
 int gfs2_glock_poll(struct gfs2_holder *gh)
 {
-	struct gfs2_glock *gl = gh->gh_gl;
-	int ready = 0;
-
-	spin_lock(&gl->gl_spin);
-
-	if (test_bit(HIF_HOLDER, &gh->gh_iflags))
-		ready = 1;
-	else if (list_empty(&gh->gh_list)) {
-		if (gh->gh_error == GLR_CANCELED) {
-			spin_unlock(&gl->gl_spin);
-			msleep(100);
-			if (gfs2_glock_nq(gh))
-				return 1;
-			return 0;
-		} else
-			ready = 1;
-	}
-
-	spin_unlock(&gl->gl_spin);
-
-	return ready;
-}
-
-/**
- * gfs2_glock_wait - wait for a lock acquisition that ended in a GLR_ASYNC
- * @gh: the holder structure
- *
- * Returns: 0, GLR_TRYFAILED, or errno on failure
- */
-
-int gfs2_glock_wait(struct gfs2_holder *gh)
-{
-	int error;
-
-	error = glock_wait_internal(gh);
-	if (error == GLR_CANCELED) {
-		msleep(100);
-		gh->gh_flags &= ~GL_ASYNC;
-		error = gfs2_glock_nq(gh);
-	}
-
-	return error;
+	return test_bit(HIF_WAIT, &gh->gh_iflags) ? 0 : 1;
 }
 
 /**
@@ -1251,26 +980,30 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 	struct gfs2_glock *gl = gh->gh_gl;
 	const struct gfs2_glock_operations *glops = gl->gl_ops;
 	unsigned delay = 0;
+	int fast_path = 0;
 
+	spin_lock(&gl->gl_spin);
 	if (gh->gh_flags & GL_NOCACHE)
 		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
 
-	gfs2_glmutex_lock(gl);
-
-	spin_lock(&gl->gl_spin);
 	list_del_init(&gh->gh_list);
-
-	if (list_empty(&gl->gl_holders)) {
+	if (find_first_holder(gl) == NULL) {
 		if (glops->go_unlock) {
+			GLOCK_BUG_ON(gl, test_and_set_bit(GLF_LOCK, &gl->gl_flags));
 			spin_unlock(&gl->gl_spin);
 			glops->go_unlock(gh);
 			spin_lock(&gl->gl_spin);
+			clear_bit(GLF_LOCK, &gl->gl_flags);
 		}
 		gl->gl_stamp = jiffies;
+		if (list_empty(&gl->gl_holders) &&
+		    !test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
+		    !test_bit(GLF_DEMOTE, &gl->gl_flags))
+			fast_path = 1;
 	}
-
-	clear_bit(GLF_LOCK, &gl->gl_flags);
 	spin_unlock(&gl->gl_spin);
+	if (likely(fast_path))
+		return;
 
 	gfs2_glock_hold(gl);
 	if (test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags) &&
@@ -1469,20 +1202,14 @@ int gfs2_lvb_hold(struct gfs2_glock *gl)
 {
 	int error;
 
-	gfs2_glmutex_lock(gl);
-
 	if (!atomic_read(&gl->gl_lvb_count)) {
 		error = gfs2_lm_hold_lvb(gl->gl_sbd, gl->gl_lock, &gl->gl_lvb);
-		if (error) {
-			gfs2_glmutex_unlock(gl);
+		if (error) 
 			return error;
-		}
 		gfs2_glock_hold(gl);
 	}
 	atomic_inc(&gl->gl_lvb_count);
 
-	gfs2_glmutex_unlock(gl);
-
 	return 0;
 }
 
@@ -1497,8 +1224,6 @@ void gfs2_lvb_unhold(struct gfs2_glock *gl)
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 
 	gfs2_glock_hold(gl);
-	gfs2_glmutex_lock(gl);
-
 	gfs2_assert(gl->gl_sbd, atomic_read(&gl->gl_lvb_count) > 0);
 	if (atomic_dec_and_test(&gl->gl_lvb_count)) {
 		if (likely(!test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
@@ -1506,8 +1231,6 @@ void gfs2_lvb_unhold(struct gfs2_glock *gl)
 		gl->gl_lvb = NULL;
 		gfs2_glock_put(gl);
 	}
-
-	gfs2_glmutex_unlock(gl);
 	gfs2_glock_put(gl);
 }
 
@@ -1527,7 +1250,9 @@ static void blocking_cb(struct gfs2_sbd *sdp, struct lm_lockname *name,
 	if (time_before(now, holdtime))
 		delay = holdtime - now;
 
+	spin_lock(&gl->gl_spin);
 	handle_callback(gl, state, 1, delay);
+	spin_unlock(&gl->gl_spin);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
 		gfs2_glock_put(gl);
 }
@@ -1568,7 +1293,8 @@ void gfs2_glock_cb(void *cb_data, unsigned int type, void *data)
 		gl = gfs2_glock_find(sdp, &async->lc_name);
 		if (gfs2_assert_warn(sdp, gl))
 			return;
-		xmote_bh(gl, async->lc_ret);
+		gl->gl_reply = async->lc_ret;
+		set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 			gfs2_glock_put(gl);
 		up_read(&gfs2_umount_flush_sem);
@@ -1646,6 +1372,7 @@ void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl)
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp)
 {
 	struct gfs2_glock *gl;
+	int done_callback = 0;
 
 	spin_lock(&sdp->sd_reclaim_lock);
 	if (list_empty(&sdp->sd_reclaim_list)) {
@@ -1660,14 +1387,16 @@ void gfs2_reclaim_glock(struct gfs2_sbd *sdp)
 	atomic_dec(&sdp->sd_reclaim_count);
 	atomic_inc(&sdp->sd_reclaimed);
 
-	if (gfs2_glmutex_trylock(gl)) {
-		if (list_empty(&gl->gl_holders) &&
-		    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
-			handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
-		gfs2_glmutex_unlock(gl);
+	spin_lock(&gl->gl_spin);
+	if (find_first_holder(gl) == NULL &&
+	    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl)) {
+		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
+		done_callback = 1;
 	}
-
-	gfs2_glock_put(gl);
+	spin_unlock(&gl->gl_spin);
+	if (!done_callback ||
+	    queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+		gfs2_glock_put(gl);
 }
 
 /**
@@ -1724,18 +1453,14 @@ static void scan_glock(struct gfs2_glock *gl)
 {
 	if (gl->gl_ops == &gfs2_inode_glops && gl->gl_object)
 		return;
+	if (test_bit(GLF_LOCK, &gl->gl_flags))
+		return;
 
-	if (gfs2_glmutex_trylock(gl)) {
-		if (list_empty(&gl->gl_holders) &&
-		    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
-			goto out_schedule;
-		gfs2_glmutex_unlock(gl);
-	}
-	return;
-
-out_schedule:
-	gfs2_glmutex_unlock(gl);
-	gfs2_glock_schedule_for_reclaim(gl);
+	spin_lock(&gl->gl_spin);
+	if (find_first_holder(gl) == NULL &&
+	    gl->gl_state != LM_ST_UNLOCKED && demote_ok(gl))
+		gfs2_glock_schedule_for_reclaim(gl);
+	spin_unlock(&gl->gl_spin);
 }
 
 /**
@@ -1760,12 +1485,13 @@ static void clear_glock(struct gfs2_glock *gl)
 		spin_unlock(&sdp->sd_reclaim_lock);
 	}
 
-	if (gfs2_glmutex_trylock(gl)) {
-		if (list_empty(&gl->gl_holders) &&
-		    gl->gl_state != LM_ST_UNLOCKED)
-			handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
-		gfs2_glmutex_unlock(gl);
-	}
+	spin_lock(&gl->gl_spin);
+	if (find_first_holder(gl) == NULL && gl->gl_state != LM_ST_UNLOCKED)
+		handle_callback(gl, LM_ST_UNLOCKED, 0, 0);
+	spin_unlock(&gl->gl_spin);
+	gfs2_glock_hold(gl);
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+		gfs2_glock_put(gl);
 }
 
 /**
@@ -1810,180 +1536,164 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait)
 	}
 }
 
-/*
- *  Diagnostic routines to help debug distributed deadlock
- */
-
-static void gfs2_print_symbol(struct glock_iter *gi, const char *fmt,
-                              unsigned long address)
+static const char *state2str(unsigned state)
 {
-	char buffer[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(buffer, address);
-	print_dbg(gi, fmt, buffer);
+	switch(state) {
+	case LM_ST_UNLOCKED:
+		return "UN";
+	case LM_ST_SHARED:
+		return "SH";
+	case LM_ST_DEFERRED:
+		return "DF";
+	case LM_ST_EXCLUSIVE:
+		return "EX";
+	}
+	return "??";
+}
+
+static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
+{
+	char *p = buf;
+	if (flags & LM_FLAG_TRY)
+		*p++ = 't';
+	if (flags & LM_FLAG_TRY_1CB)
+		*p++ = 'T';
+	if (flags & LM_FLAG_NOEXP)
+		*p++ = 'e';
+	if (flags & LM_FLAG_ANY)
+		*p++ = 'a';
+	if (flags & LM_FLAG_PRIORITY)
+		*p++ = 'p';
+	if (flags & GL_ASYNC)
+		*p++ = 'a';
+	if (flags & GL_EXACT)
+		*p++ = 'E';
+	if (flags & GL_ATIME)
+		*p++ = 'a';
+	if (flags & GL_NOCACHE)
+		*p++ = 'c';
+	if (test_bit(HIF_HOLDER, &iflags))
+		*p++ = 'H';
+	if (test_bit(HIF_WAIT, &iflags))
+		*p++ = 'W';
+	if (test_bit(HIF_FIRST, &iflags))
+		*p++ = 'F';
+	*p = 0;
+	return buf;
 }
 
 /**
  * dump_holder - print information about a glock holder
- * @str: a string naming the type of holder
+ * @seq: the seq_file struct
  * @gh: the glock holder
  *
  * Returns: 0 on success, -ENOBUFS when we run out of space
  */
 
-static int dump_holder(struct glock_iter *gi, char *str,
-		       struct gfs2_holder *gh)
+static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 {
-	unsigned int x;
-	struct task_struct *gh_owner;
+	struct task_struct *gh_owner = NULL;
+	char buffer[KSYM_SYMBOL_LEN];
+	char flags_buf[32];
 
-	print_dbg(gi, "  %s\n", str);
-	if (gh->gh_owner_pid) {
-		print_dbg(gi, "    owner = %ld ",
-				(long)pid_nr(gh->gh_owner_pid));
+	sprint_symbol(buffer, gh->gh_ip);
+	if (gh->gh_owner_pid)
 		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
-		if (gh_owner)
-			print_dbg(gi, "(%s)\n", gh_owner->comm);
-		else
-			print_dbg(gi, "(ended)\n");
-	} else
-		print_dbg(gi, "    owner = -1\n");
-	print_dbg(gi, "    gh_state = %u\n", gh->gh_state);
-	print_dbg(gi, "    gh_flags =");
-	for (x = 0; x < 32; x++)
-		if (gh->gh_flags & (1 << x))
-			print_dbg(gi, " %u", x);
-	print_dbg(gi, " \n");
-	print_dbg(gi, "    error = %d\n", gh->gh_error);
-	print_dbg(gi, "    gh_iflags =");
-	for (x = 0; x < 32; x++)
-		if (test_bit(x, &gh->gh_iflags))
-			print_dbg(gi, " %u", x);
-	print_dbg(gi, " \n");
-        gfs2_print_symbol(gi, "    initialized at: %s\n", gh->gh_ip);
-
+	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %s\n",
+		  state2str(gh->gh_state),
+		  hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
+		  gh->gh_error, 
+		  gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
+		  gh_owner ? gh_owner->comm : "(ended)", buffer);
 	return 0;
 }
 
-/**
- * dump_inode - print information about an inode
- * @ip: the inode
- *
- * Returns: 0 on success, -ENOBUFS when we run out of space
- */
-
-static int dump_inode(struct glock_iter *gi, struct gfs2_inode *ip)
-{
-	unsigned int x;
-
-	print_dbg(gi, "  Inode:\n");
-	print_dbg(gi, "    num = %llu/%llu\n",
-		  (unsigned long long)ip->i_no_formal_ino,
-		  (unsigned long long)ip->i_no_addr);
-	print_dbg(gi, "    type = %u\n", IF2DT(ip->i_inode.i_mode));
-	print_dbg(gi, "    i_flags =");
-	for (x = 0; x < 32; x++)
-		if (test_bit(x, &ip->i_flags))
-			print_dbg(gi, " %u", x);
-	print_dbg(gi, " \n");
-	return 0;
+static const char *gflags2str(char *buf, const unsigned long *gflags)
+{
+	char *p = buf;
+	if (test_bit(GLF_LOCK, gflags))
+		*p++ = 'l';
+	if (test_bit(GLF_STICKY, gflags))
+		*p++ = 's';
+	if (test_bit(GLF_DEMOTE, gflags))
+		*p++ = 'D';
+	if (test_bit(GLF_PENDING_DEMOTE, gflags))
+		*p++ = 'd';
+	if (test_bit(GLF_DEMOTE_IN_PROGRESS, gflags))
+		*p++ = 'p';
+	if (test_bit(GLF_DIRTY, gflags))
+		*p++ = 'y';
+	if (test_bit(GLF_LFLUSH, gflags))
+		*p++ = 'f';
+	if (test_bit(GLF_INVALIDATE_IN_PROGRESS, gflags))
+		*p++ = 'i';
+	if (test_bit(GLF_REPLY_PENDING, gflags))
+		*p++ = 'r';
+	*p = 0;
+	return buf;
 }
 
 /**
- * dump_glock - print information about a glock
+ * __dump_glock - print information about a glock
+ * @seq: The seq_file struct
  * @gl: the glock
- * @count: where we are in the buffer
+ *
+ * The file format is as follows:
+ * One line per object, capital letters are used to indicate objects
+ * G = glock, I = Inode, R = rgrp, H = holder. Glocks are not indented,
+ * other objects are indented by a single space and follow the glock to
+ * which they are related. Fields are indicated by lower case letters
+ * followed by a colon and the field value, except for strings which are in
+ * [] so that its possible to see if they are composed of spaces for
+ * example. The field's are n = number (id of the object), f = flags,
+ * t = type, s = state, r = refcount, e = error, p = pid.
  *
  * Returns: 0 on success, -ENOBUFS when we run out of space
  */
 
-static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
+static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 {
-	struct gfs2_holder *gh;
-	unsigned int x;
-	int error = -ENOBUFS;
-	struct task_struct *gl_owner;
+	const struct gfs2_glock_operations *glops = gl->gl_ops;
+	unsigned long long dtime;
+	const struct gfs2_holder *gh;
+	char gflags_buf[32];
+	int error = 0;
 
-	spin_lock(&gl->gl_spin);
+	dtime = jiffies - gl->gl_demote_time;
+	dtime *= 1000000/HZ; /* demote time in uSec */
+	if (!test_bit(GLF_DEMOTE, &gl->gl_flags))
+		dtime = 0;
+	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llu f:%s t:%s d:%s/%llu l:%d a:%d r:%d\n",
+		  state2str(gl->gl_state),
+		  gl->gl_name.ln_type,
+		  (unsigned long long)gl->gl_name.ln_number,
+		  gflags2str(gflags_buf, &gl->gl_flags),
+		  state2str(gl->gl_target),
+		  state2str(gl->gl_demote_state), dtime,
+		  atomic_read(&gl->gl_lvb_count),
+		  atomic_read(&gl->gl_ail_count),
+		  atomic_read(&gl->gl_ref));
 
-	print_dbg(gi, "Glock 0x%p (%u, 0x%llx)\n", gl, gl->gl_name.ln_type,
-		   (unsigned long long)gl->gl_name.ln_number);
-	print_dbg(gi, "  gl_flags =");
-	for (x = 0; x < 32; x++) {
-		if (test_bit(x, &gl->gl_flags))
-			print_dbg(gi, " %u", x);
-	}
-	if (!test_bit(GLF_LOCK, &gl->gl_flags))
-		print_dbg(gi, " (unlocked)");
-	print_dbg(gi, " \n");
-	print_dbg(gi, "  gl_ref = %d\n", atomic_read(&gl->gl_ref));
-	print_dbg(gi, "  gl_state = %u\n", gl->gl_state);
-	if (gl->gl_owner_pid) {
-		gl_owner = pid_task(gl->gl_owner_pid, PIDTYPE_PID);
-		if (gl_owner)
-			print_dbg(gi, "  gl_owner = pid %d (%s)\n",
-				  pid_nr(gl->gl_owner_pid), gl_owner->comm);
-		else
-			print_dbg(gi, "  gl_owner = %d (ended)\n",
-				  pid_nr(gl->gl_owner_pid));
-	} else
-		print_dbg(gi, "  gl_owner = -1\n");
-	print_dbg(gi, "  gl_ip = %lu\n", gl->gl_ip);
-	print_dbg(gi, "  req_gh = %s\n", (gl->gl_req_gh) ? "yes" : "no");
-	print_dbg(gi, "  lvb_count = %d\n", atomic_read(&gl->gl_lvb_count));
-	print_dbg(gi, "  object = %s\n", (gl->gl_object) ? "yes" : "no");
-	print_dbg(gi, "  reclaim = %s\n",
-		   (list_empty(&gl->gl_reclaim)) ? "no" : "yes");
-	if (gl->gl_aspace)
-		print_dbg(gi, "  aspace = 0x%p nrpages = %lu\n", gl->gl_aspace,
-			   gl->gl_aspace->i_mapping->nrpages);
-	else
-		print_dbg(gi, "  aspace = no\n");
-	print_dbg(gi, "  ail = %d\n", atomic_read(&gl->gl_ail_count));
-	if (gl->gl_req_gh) {
-		error = dump_holder(gi, "Request", gl->gl_req_gh);
-		if (error)
-			goto out;
-	}
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
-		error = dump_holder(gi, "Holder", gh);
-		if (error)
-			goto out;
-	}
-	list_for_each_entry(gh, &gl->gl_waiters1, gh_list) {
-		error = dump_holder(gi, "Waiter1", gh);
-		if (error)
-			goto out;
-	}
-	list_for_each_entry(gh, &gl->gl_waiters3, gh_list) {
-		error = dump_holder(gi, "Waiter3", gh);
+		error = dump_holder(seq, gh);
 		if (error)
 			goto out;
 	}
-	if (test_bit(GLF_DEMOTE, &gl->gl_flags)) {
-		print_dbg(gi, "  Demotion req to state %u (%llu uS ago)\n",
-			  gl->gl_demote_state, (unsigned long long)
-			  (jiffies - gl->gl_demote_time)*(1000000/HZ));
-	}
-	if (gl->gl_ops == &gfs2_inode_glops && gl->gl_object) {
-		if (!test_bit(GLF_LOCK, &gl->gl_flags) &&
-			list_empty(&gl->gl_holders)) {
-			error = dump_inode(gi, gl->gl_object);
-			if (error)
-				goto out;
-		} else {
-			error = -ENOBUFS;
-			print_dbg(gi, "  Inode: busy\n");
-		}
-	}
-
-	error = 0;
-
+	if (gl->gl_state != LM_ST_UNLOCKED && glops->go_dump)
+		error = glops->go_dump(seq, gl);
 out:
-	spin_unlock(&gl->gl_spin);
 	return error;
 }
 
+static int dump_glock(struct seq_file *seq, struct gfs2_glock *gl)
+{
+	int ret;
+	spin_lock(&gl->gl_spin);
+	ret = __dump_glock(seq, gl);
+	spin_unlock(&gl->gl_spin);
+	return ret;
+}
+
 /**
  * gfs2_dump_lockstate - print out the current lockstate
  * @sdp: the filesystem
@@ -2086,7 +1796,7 @@ void gfs2_glock_exit(void)
 module_param(scand_secs, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scand_secs, "The number of seconds between scand runs");
 
-static int gfs2_glock_iter_next(struct glock_iter *gi)
+static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 {
 	struct gfs2_glock *gl;
 
@@ -2104,7 +1814,7 @@ restart:
 		gfs2_glock_put(gl);
 	if (gl && gi->gl == NULL)
 		gi->hash++;
-	while(gi->gl == NULL) {
+	while (gi->gl == NULL) {
 		if (gi->hash >= GFS2_GL_HASH_SIZE)
 			return 1;
 		read_lock(gl_lock_addr(gi->hash));
@@ -2122,58 +1832,34 @@ restart:
 	return 0;
 }
 
-static void gfs2_glock_iter_free(struct glock_iter *gi)
+static void gfs2_glock_iter_free(struct gfs2_glock_iter *gi)
 {
 	if (gi->gl)
 		gfs2_glock_put(gi->gl);
-	kfree(gi);
-}
-
-static struct glock_iter *gfs2_glock_iter_init(struct gfs2_sbd *sdp)
-{
-	struct glock_iter *gi;
-
-	gi = kmalloc(sizeof (*gi), GFP_KERNEL);
-	if (!gi)
-		return NULL;
-
-	gi->sdp = sdp;
-	gi->hash = 0;
-	gi->seq = NULL;
 	gi->gl = NULL;
-	memset(gi->string, 0, sizeof(gi->string));
-
-	if (gfs2_glock_iter_next(gi)) {
-		gfs2_glock_iter_free(gi);
-		return NULL;
-	}
-
-	return gi;
 }
 
-static void *gfs2_glock_seq_start(struct seq_file *file, loff_t *pos)
+static void *gfs2_glock_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct glock_iter *gi;
+	struct gfs2_glock_iter *gi = seq->private;
 	loff_t n = *pos;
 
-	gi = gfs2_glock_iter_init(file->private);
-	if (!gi)
-		return NULL;
+	gi->hash = 0;
 
-	while(n--) {
+	do {
 		if (gfs2_glock_iter_next(gi)) {
 			gfs2_glock_iter_free(gi);
 			return NULL;
 		}
-	}
+	} while (n--);
 
-	return gi;
+	return gi->gl;
 }
 
-static void *gfs2_glock_seq_next(struct seq_file *file, void *iter_ptr,
+static void *gfs2_glock_seq_next(struct seq_file *seq, void *iter_ptr,
 				 loff_t *pos)
 {
-	struct glock_iter *gi = iter_ptr;
+	struct gfs2_glock_iter *gi = seq->private;
 
 	(*pos)++;
 
@@ -2182,24 +1868,18 @@ static void *gfs2_glock_seq_next(struct seq_file *file, void *iter_ptr,
 		return NULL;
 	}
 
-	return gi;
+	return gi->gl;
 }
 
-static void gfs2_glock_seq_stop(struct seq_file *file, void *iter_ptr)
+static void gfs2_glock_seq_stop(struct seq_file *seq, void *iter_ptr)
 {
-	struct glock_iter *gi = iter_ptr;
-	if (gi)
-		gfs2_glock_iter_free(gi);
+	struct gfs2_glock_iter *gi = seq->private;
+	gfs2_glock_iter_free(gi);
 }
 
-static int gfs2_glock_seq_show(struct seq_file *file, void *iter_ptr)
+static int gfs2_glock_seq_show(struct seq_file *seq, void *iter_ptr)
 {
-	struct glock_iter *gi = iter_ptr;
-
-	gi->seq = file;
-	dump_glock(gi, gi->gl);
-
-	return 0;
+	return dump_glock(seq, iter_ptr);
 }
 
 static const struct seq_operations gfs2_glock_seq_ops = {
@@ -2211,17 +1891,14 @@ static const struct seq_operations gfs2_glock_seq_ops = {
 
 static int gfs2_debugfs_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	int ret;
-
-	ret = seq_open(file, &gfs2_glock_seq_ops);
-	if (ret)
-		return ret;
-
-	seq = file->private_data;
-	seq->private = inode->i_private;
-
-	return 0;
+	int ret = seq_open_private(file, &gfs2_glock_seq_ops,
+				   sizeof(struct gfs2_glock_iter));
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		struct gfs2_glock_iter *gi = seq->private;
+		gi->sdp = inode->i_private;
+	}
+	return ret;
 }
 
 static const struct file_operations gfs2_debug_fops = {
@@ -2229,7 +1906,7 @@ static const struct file_operations gfs2_debug_fops = {
 	.open    = gfs2_debugfs_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release
+	.release = seq_release_private,
 };
 
 int gfs2_create_debugfs_file(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index cdad3e6..7389f8e 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -26,11 +26,8 @@
 #define GL_SKIP			0x00000100
 #define GL_ATIME		0x00000200
 #define GL_NOCACHE		0x00000400
-#define GL_FLOCK		0x00000800
-#define GL_NOCANCEL		0x00001000
 
 #define GLR_TRYFAILED		13
-#define GLR_CANCELED		14
 
 static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *gl)
 {
@@ -41,6 +38,8 @@ static inline struct gfs2_holder *gfs2_glock_is_locked_by_me(struct gfs2_glock *
 	spin_lock(&gl->gl_spin);
 	pid = task_pid(current);
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
+		if (!test_bit(HIF_HOLDER, &gh->gh_iflags))
+			break;
 		if (gh->gh_owner_pid == pid)
 			goto out;
 	}
@@ -70,7 +69,7 @@ static inline int gfs2_glock_is_blocking(struct gfs2_glock *gl)
 {
 	int ret;
 	spin_lock(&gl->gl_spin);
-	ret = test_bit(GLF_DEMOTE, &gl->gl_flags) || !list_empty(&gl->gl_waiters3);
+	ret = test_bit(GLF_DEMOTE, &gl->gl_flags);
 	spin_unlock(&gl->gl_spin);
 	return ret;
 }
@@ -98,6 +97,7 @@ int gfs2_glock_nq_num(struct gfs2_sbd *sdp,
 int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
+void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
 
 /**
  * gfs2_glock_nq_init - intialize a holder and enqueue it on a glock
@@ -130,7 +130,6 @@ int gfs2_lvb_hold(struct gfs2_glock *gl);
 void gfs2_lvb_unhold(struct gfs2_glock *gl);
 
 void gfs2_glock_cb(void *cb_data, unsigned int type, void *data);
-
 void gfs2_glock_schedule_for_reclaim(struct gfs2_glock *gl);
 void gfs2_reclaim_glock(struct gfs2_sbd *sdp);
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 07d84d1..c6c318c 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -13,6 +13,7 @@
 #include <linux/buffer_head.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/lm_interface.h>
+#include <linux/bio.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -172,26 +173,6 @@ static void inode_go_sync(struct gfs2_glock *gl)
 }
 
 /**
- * inode_go_xmote_bh - After promoting/demoting a glock
- * @gl: the glock
- *
- */
-
-static void inode_go_xmote_bh(struct gfs2_glock *gl)
-{
-	struct gfs2_holder *gh = gl->gl_req_gh;
-	struct buffer_head *bh;
-	int error;
-
-	if (gl->gl_state != LM_ST_UNLOCKED &&
-	    (!gh || !(gh->gh_flags & GL_SKIP))) {
-		error = gfs2_meta_read(gl, gl->gl_name.ln_number, 0, &bh);
-		if (!error)
-			brelse(bh);
-	}
-}
-
-/**
  * inode_go_inval - prepare a inode glock to be released
  * @gl: the glock
  * @flags:
@@ -267,6 +248,26 @@ static int inode_go_lock(struct gfs2_holder *gh)
 }
 
 /**
+ * inode_go_dump - print information about an inode
+ * @seq: The iterator
+ * @ip: the inode
+ *
+ * Returns: 0 on success, -ENOBUFS when we run out of space
+ */
+
+static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
+{
+	const struct gfs2_inode *ip = gl->gl_object;
+	if (ip == NULL)
+		return 0;
+	gfs2_print_dbg(seq, " I: n:%llu/%llu t:%u f:0x%08lx\n",
+		  (unsigned long long)ip->i_no_formal_ino,
+		  (unsigned long long)ip->i_no_addr,
+		  IF2DT(ip->i_inode.i_mode), ip->i_flags);
+	return 0;
+}
+
+/**
  * rgrp_go_demote_ok - Check to see if it's ok to unlock a RG's glock
  * @gl: the glock
  *
@@ -306,6 +307,22 @@ static void rgrp_go_unlock(struct gfs2_holder *gh)
 }
 
 /**
+ * rgrp_go_dump - print out an rgrp
+ * @seq: The iterator
+ * @gl: The glock in question
+ *
+ */
+
+static int rgrp_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
+{
+	const struct gfs2_rgrpd *rgd = gl->gl_object;
+	if (rgd == NULL)
+		return 0;
+	gfs2_print_dbg(seq, " R: n:%llu\n", (unsigned long long)rgd->rd_addr);
+	return 0;
+}
+
+/**
  * trans_go_sync - promote/demote the transaction glock
  * @gl: the glock
  * @state: the requested state
@@ -330,7 +347,7 @@ static void trans_go_sync(struct gfs2_glock *gl)
  *
  */
 
-static void trans_go_xmote_bh(struct gfs2_glock *gl)
+static int trans_go_xmote_bh(struct gfs2_glock *gl, struct gfs2_holder *gh)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_jdesc->jd_inode);
@@ -338,8 +355,7 @@ static void trans_go_xmote_bh(struct gfs2_glock *gl)
 	struct gfs2_log_header_host head;
 	int error;
 
-	if (gl->gl_state != LM_ST_UNLOCKED &&
-	    test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
+	if (test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
 		j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 		error = gfs2_find_jhead(sdp->sd_jdesc, &head);
@@ -354,6 +370,7 @@ static void trans_go_xmote_bh(struct gfs2_glock *gl)
 			gfs2_log_pointers_init(sdp, head.lh_blkno);
 		}
 	}
+	return 0;
 }
 
 /**
@@ -375,12 +392,12 @@ const struct gfs2_glock_operations gfs2_meta_glops = {
 
 const struct gfs2_glock_operations gfs2_inode_glops = {
 	.go_xmote_th = inode_go_sync,
-	.go_xmote_bh = inode_go_xmote_bh,
 	.go_inval = inode_go_inval,
 	.go_demote_ok = inode_go_demote_ok,
 	.go_lock = inode_go_lock,
+	.go_dump = inode_go_dump,
 	.go_type = LM_TYPE_INODE,
-	.go_min_hold_time = HZ / 10,
+	.go_min_hold_time = HZ / 5,
 };
 
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
@@ -389,8 +406,9 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_demote_ok = rgrp_go_demote_ok,
 	.go_lock = rgrp_go_lock,
 	.go_unlock = rgrp_go_unlock,
+	.go_dump = rgrp_go_dump,
 	.go_type = LM_TYPE_RGRP,
-	.go_min_hold_time = HZ / 10,
+	.go_min_hold_time = HZ / 5,
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index eabe5ea..4b734c6 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -128,20 +128,20 @@ struct gfs2_bufdata {
 
 struct gfs2_glock_operations {
 	void (*go_xmote_th) (struct gfs2_glock *gl);
-	void (*go_xmote_bh) (struct gfs2_glock *gl);
+	int (*go_xmote_bh) (struct gfs2_glock *gl, struct gfs2_holder *gh);
 	void (*go_inval) (struct gfs2_glock *gl, int flags);
 	int (*go_demote_ok) (struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
+	int (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
 	const int go_type;
 	const unsigned long go_min_hold_time;
 };
 
 enum {
 	/* States */
-	HIF_HOLDER		= 6,
+	HIF_HOLDER		= 6,  /* Set for gh that "holds" the glock */
 	HIF_FIRST		= 7,
-	HIF_ABORTED		= 9,
 	HIF_WAIT		= 10,
 };
 
@@ -154,20 +154,20 @@ struct gfs2_holder {
 	unsigned gh_flags;
 
 	int gh_error;
-	unsigned long gh_iflags;
+	unsigned long gh_iflags; /* HIF_... */
 	unsigned long gh_ip;
 };
 
 enum {
-	GLF_LOCK		= 1,
-	GLF_STICKY		= 2,
-	GLF_DEMOTE		= 3,
-	GLF_PENDING_DEMOTE	= 4,
-	GLF_DIRTY		= 5,
-	GLF_DEMOTE_IN_PROGRESS	= 6,
-	GLF_LFLUSH		= 7,
-	GLF_WAITERS2		= 8,
-	GLF_CONV_DEADLK		= 9,
+	GLF_LOCK			= 1,
+	GLF_STICKY			= 2,
+	GLF_DEMOTE			= 3,
+	GLF_PENDING_DEMOTE		= 4,
+	GLF_DEMOTE_IN_PROGRESS		= 5,
+	GLF_DIRTY			= 6,
+	GLF_LFLUSH			= 7,
+	GLF_INVALIDATE_IN_PROGRESS	= 8,
+	GLF_REPLY_PENDING		= 9,
 };
 
 struct gfs2_glock {
@@ -179,19 +179,14 @@ struct gfs2_glock {
 	spinlock_t gl_spin;
 
 	unsigned int gl_state;
+	unsigned int gl_target;
+	unsigned int gl_reply;
 	unsigned int gl_hash;
 	unsigned int gl_demote_state; /* state requested by remote node */
 	unsigned long gl_demote_time; /* time of first demote request */
-	struct pid *gl_owner_pid;
-	unsigned long gl_ip;
 	struct list_head gl_holders;
-	struct list_head gl_waiters1;	/* HIF_MUTEX */
-	struct list_head gl_waiters3;	/* HIF_PROMOTE */
 
 	const struct gfs2_glock_operations *gl_ops;
-
-	struct gfs2_holder *gl_req_gh;
-
 	void *gl_lock;
 	char *gl_lvb;
 	atomic_t gl_lvb_count;
diff --git a/fs/gfs2/locking/dlm/lock.c b/fs/gfs2/locking/dlm/lock.c
index cf7ea8a..fed9a67 100644
--- a/fs/gfs2/locking/dlm/lock.c
+++ b/fs/gfs2/locking/dlm/lock.c
@@ -308,6 +308,9 @@ unsigned int gdlm_lock(void *lock, unsigned int cur_state,
 {
 	struct gdlm_lock *lp = lock;
 
+	if (req_state == LM_ST_UNLOCKED)
+		return gdlm_unlock(lock, cur_state);
+
 	clear_bit(LFL_DLM_CANCEL, &lp->flags);
 	if (flags & LM_FLAG_NOEXP)
 		set_bit(LFL_NOBLOCK, &lp->flags);
diff --git a/fs/gfs2/locking/nolock/main.c b/fs/gfs2/locking/nolock/main.c
index 284a5ec..627bfb7 100644
--- a/fs/gfs2/locking/nolock/main.c
+++ b/fs/gfs2/locking/nolock/main.c
@@ -107,6 +107,8 @@ static void nolock_put_lock(void *lock)
 static unsigned int nolock_lock(void *lock, unsigned int cur_state,
 				unsigned int req_state, unsigned int flags)
 {
+	if (req_state == LM_ST_UNLOCKED)
+		return 0;
 	return req_state | LM_OUT_CACHEABLE;
 }
 
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index 053e2eb..bcc668d 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -40,8 +40,6 @@ static void gfs2_init_glock_once(struct kmem_cache *cachep, void *foo)
 	INIT_HLIST_NODE(&gl->gl_list);
 	spin_lock_init(&gl->gl_spin);
 	INIT_LIST_HEAD(&gl->gl_holders);
-	INIT_LIST_HEAD(&gl->gl_waiters1);
-	INIT_LIST_HEAD(&gl->gl_waiters3);
 	gl->gl_lvb = NULL;
 	atomic_set(&gl->gl_lvb_count, 0);
 	INIT_LIST_HEAD(&gl->gl_reclaim);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 78d75f8..0985362 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -129,7 +129,7 @@ void gfs2_meta_sync(struct gfs2_glock *gl)
 }
 
 /**
- * getbuf - Get a buffer with a given address space
+ * gfs2_getbuf - Get a buffer with a given address space
  * @gl: the glock
  * @blkno: the block number (filesystem scope)
  * @create: 1 if the buffer should be created
@@ -137,7 +137,7 @@ void gfs2_meta_sync(struct gfs2_glock *gl)
  * Returns: the buffer
  */
 
-static struct buffer_head *getbuf(struct gfs2_glock *gl, u64 blkno, int create)
+struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create)
 {
 	struct address_space *mapping = gl->gl_aspace->i_mapping;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
@@ -205,7 +205,7 @@ static void meta_prep_new(struct buffer_head *bh)
 struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno)
 {
 	struct buffer_head *bh;
-	bh = getbuf(gl, blkno, CREATE);
+	bh = gfs2_getbuf(gl, blkno, CREATE);
 	meta_prep_new(bh);
 	return bh;
 }
@@ -223,7 +223,7 @@ struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno)
 int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 		   struct buffer_head **bhp)
 {
-	*bhp = getbuf(gl, blkno, CREATE);
+	*bhp = gfs2_getbuf(gl, blkno, CREATE);
 	if (!buffer_uptodate(*bhp)) {
 		ll_rw_block(READ_META, 1, bhp);
 		if (flags & DIO_WAIT) {
@@ -346,7 +346,7 @@ void gfs2_meta_wipe(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	struct buffer_head *bh;
 
 	while (blen) {
-		bh = getbuf(ip->i_gl, bstart, NO_CREATE);
+		bh = gfs2_getbuf(ip->i_gl, bstart, NO_CREATE);
 		if (bh) {
 			lock_buffer(bh);
 			gfs2_log_lock(sdp);
@@ -421,7 +421,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	if (extlen > max_ra)
 		extlen = max_ra;
 
-	first_bh = getbuf(gl, dblock, CREATE);
+	first_bh = gfs2_getbuf(gl, dblock, CREATE);
 
 	if (buffer_uptodate(first_bh))
 		goto out;
@@ -432,7 +432,7 @@ struct buffer_head *gfs2_meta_ra(struct gfs2_glock *gl, u64 dblock, u32 extlen)
 	extlen--;
 
 	while (extlen) {
-		bh = getbuf(gl, dblock, CREATE);
+		bh = gfs2_getbuf(gl, dblock, CREATE);
 
 		if (!buffer_uptodate(bh) && !buffer_locked(bh))
 			ll_rw_block(READA, 1, &bh);
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index 73e3b1c..b1a5f36 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -47,6 +47,7 @@ struct buffer_head *gfs2_meta_new(struct gfs2_glock *gl, u64 blkno);
 int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno,
 		   int flags, struct buffer_head **bhp);
 int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh);
+struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create);
 
 void gfs2_attach_bufdata(struct gfs2_glock *gl, struct buffer_head *bh,
 			 int meta);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index f55394e..2b556dd 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -507,26 +507,23 @@ static int __gfs2_readpage(void *file, struct page *page)
 static int gfs2_readpage(struct file *file, struct page *page)
 {
 	struct gfs2_inode *ip = GFS2_I(page->mapping->host);
-	struct gfs2_holder *gh;
+	struct gfs2_holder gh;
 	int error;
 
-	gh = gfs2_glock_is_locked_by_me(ip->i_gl);
-	if (!gh) {
-		gh = kmalloc(sizeof(struct gfs2_holder), GFP_NOFS);
-		if (!gh)
-			return -ENOBUFS;
-		gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME, gh);
+	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, GL_ATIME|LM_FLAG_TRY_1CB, &gh);
+	error = gfs2_glock_nq_atime(&gh);
+	if (unlikely(error)) {
 		unlock_page(page);
-		error = gfs2_glock_nq_atime(gh);
-		if (likely(error != 0))
-			goto out;
-		return AOP_TRUNCATED_PAGE;
+		goto out;
 	}
 	error = __gfs2_readpage(file, page);
-	gfs2_glock_dq(gh);
+	gfs2_glock_dq(&gh);
 out:
-	gfs2_holder_uninit(gh);
-	kfree(gh);
+	gfs2_holder_uninit(&gh);
+	if (error == GLR_TRYFAILED) {
+		yield();
+		return AOP_TRUNCATED_PAGE;
+	}
 	return error;
 }
 
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index e1b7d52..0ff512a 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -669,8 +669,7 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 	int error = 0;
 
 	state = (fl->fl_type == F_WRLCK) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
-	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE 
-		| GL_FLOCK;
+	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE;
 
 	mutex_lock(&fp->f_fl_mutex);
 
@@ -683,9 +682,8 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 		gfs2_glock_dq_wait(fl_gh);
 		gfs2_holder_reinit(state, flags, fl_gh);
 	} else {
-		error = gfs2_glock_get(GFS2_SB(&ip->i_inode),
-				      ip->i_no_addr, &gfs2_flock_glops,
-				      CREATE, &gl);
+		error = gfs2_glock_get(GFS2_SB(&ip->i_inode), ip->i_no_addr,
+				       &gfs2_flock_glops, CREATE, &gl);
 		if (error)
 			goto out;
 		gfs2_holder_init(gl, state, flags, fl_gh);
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 2888e4b..fdd3f0f 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -505,7 +505,7 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd)
 
 		error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED,
 					   LM_FLAG_NOEXP | LM_FLAG_PRIORITY |
-					   GL_NOCANCEL | GL_NOCACHE, &t_gh);
+					   GL_NOCACHE, &t_gh);
 		if (error)
 			goto fail_gunlock_ji;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 7aeacbc..12fe38f 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -941,8 +941,7 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp,
 	}
 
 	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_DEFERRED,
-			       LM_FLAG_PRIORITY | GL_NOCACHE,
-			       t_gh);
+				   GL_NOCACHE, t_gh);
 
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		error = gfs2_jdesc_check(jd);
-- 
1.5.1.2

