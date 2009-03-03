Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZCCAUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZCCAUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZCCAUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:20:40 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58030 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZCCAUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:20:38 -0500
Message-ID: <49AC77D1.6090106@us.ibm.com>
Date: Mon, 02 Mar 2009 16:20:33 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 6/7] futex: add requeue_pi calls
References: <49AC73A9.4040804@us.ibm.com>
In-Reply-To: <49AC73A9.4040804@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

PI Futexes must have an owner at all times, so the standard requeue commands
aren't sufficient.  The new commands properly manage pi futex ownership by
ensuring a futex with waiters has an owner at all times.  Once complete these
patches will allow glibc to properly handle pi mutexes with pthread_condvars.

The approach taken here is to create two new futex op codes:

FUTEX_WAIT_REQUEUE_PI:
Threads will use this op code to wait on a futex (such as a non-pi waitqueue)
and wake after they have been requeued to a pi futex.  Prior to returning to
userspace, they will take this pi futex (and the underlying rt_mutex).

futex_wait_requeue_pi() is currently the result of a high speed collision
between futex_wait and futex_lock_pi (with the first part of futex_lock_pi
being done by futex_requeue_pi_init() on behalf of the waiter).

FUTEX_REQUEUE_PI:
This call must be used to wake threads waiting with FUTEX_WAIT_REQUEUE_PI,
regardless of how many threads the caller intends to wake or requeue.
pthread_cond_broadcast should call this with nr_wake=1 and nr_requeue=-1 (all).
pthread_cond_signal should call this with nr_wake=1 and nr_requeue=0.  The
reason being we need both callers to get the benefit of the
futex_requeue_pi_init() routine which will prepare the top_waiter (the thread
to be woken) to take possesion of the pi futex by setting FUTEX_WAITERS and
preparing the futex_q.pi_state.  futex_requeue() also enqueues the top_waiter
on the rt_mutex via rt_mutex_start_proxy_lock(). If pthread_cond_signal used
FUTEX_WAKE, we would have a similar race window where the caller can return and
release the mutex before the waiters can fully wake, potentially leaving the
rt_mutex with waiters but no owner.

We hit a failed paging request running the testcase (7/7) in a loop
(only takes a few minutes at most to hit on my 8way x86_64 test
machine).  It appears to be the result of splitting rt_mutex_slowlock()
across two execution contexts by means of rt_mutex_start_proxy_lock()
and rt_mutex_finish_proxy_lock().  The former calls
task_blocks_on_rt_mutex() on behalf of the waiting task prior to
requeuing and waking it by the requeueing thread.  The latter is
executed upon wakeup by the waiting thread which somehow manages to call
the new __rt_mutex_slowlock() with waiter->task != NULL and still
succeed with try_to_take_lock(), this leads to corruption of the plists
and an eventual failed paging request.  See 7/7 for the rather crude
testcase that causes this.  Any tips on where this race might be
occuring are welcome.

Changelog:
V5: -Update futex_requeue to allow for nr_requeue == 0
    -Whitespace cleanup
    -Added task_count var to futex_requeue to avoid confusion between
     ret, res, and ret used to count wakes and requeues
V4: -Cleanups to pass checkpatch.pl
    -Added missing goto out; in futex_wait_requeue_pi
    -Moved rt_mutex_handle_wakeup to the rt_mutex_enqueue_task patch as they
     are a functional pair.
    -Fixed several error exit paths that failed to unqueue the futex_q, which
     not only would leave the futex_q on the hb, but would have caused an exit
     race with the waiter since they weren't synchonized on the hb lock.  Thanks
     Sripathi for catching this.
    -Fix pi_state handling in futex_requeue
    -Several other minor fixes to futex_requeue_pi
    -add requeue_futex function and force the requeue in requeue_pi even for the
     task we wake in the requeue loop
    -refill the pi state cache at the beginning of futex_requeue for requeue_pi
    -have futex_requeue_pi_init ensure it stores off the pi_state for use in
     futex_requeue
    - Delayed starting the hrtimer until after TASK_INTERRUPTIBLE is set
    - Fixed NULL pointer bug when futex_wait_requeue_pi has no timer and
      receives a signal after waking on uaddr2.  Added has_timeout to the
      restart->futex structure.
V3: -Added FUTEX_CMP_REQUEUE_PI op
    -Put fshared support back.  So long as it is encoded in the op code, we
     assume both the uaddr's are either private or share, but not mixed.
    -Fixed access to expected value of uaddr2 in futex_wait_requeue_pi
V2: -Added rt_mutex enqueueing to futex_requeue_pi_init
    -Updated fault handling and exit logic
V1: -Initial verion

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 include/asm-generic/errno.h |    2 
 include/linux/futex.h       |    8 +
 include/linux/thread_info.h |    4 
 kernel/futex.c              |  653 ++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 623 insertions(+), 44 deletions(-)


diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
index e8852c0..eaeda1b 100644
--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -106,4 +106,6 @@
 #define	EOWNERDEAD	130	/* Owner died */
 #define	ENOTRECOVERABLE	131	/* State not recoverable */
 
+#define	EMORON		132	/* Dumb user error */
+
 #endif
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 3bf5bb5..b05519c 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -23,6 +23,9 @@ union ktime;
 #define FUTEX_TRYLOCK_PI	8
 #define FUTEX_WAIT_BITSET	9
 #define FUTEX_WAKE_BITSET	10
+#define FUTEX_WAIT_REQUEUE_PI	11
+#define FUTEX_REQUEUE_PI	12
+#define FUTEX_CMP_REQUEUE_PI	13
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -38,6 +41,11 @@ union ktime;
 #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#define FUTEX_REQUEUE_PI_PRIVATE	(FUTEX_REQUEUE_PI | FUTEX_PRIVATE_FLAG)
+#define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e6b820f..bd1e2ab 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -21,13 +21,15 @@ struct restart_block {
 		struct {
 			unsigned long arg0, arg1, arg2, arg3;
 		};
-		/* For futex_wait */
+		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
 			u32 *uaddr;
 			u32 val;
 			u32 flags;
 			u32 bitset;
+			int has_timeout;
 			u64 time;
+			u32 *uaddr2;
 		} futex;
 		/* For nanosleep */
 		struct {
diff --git a/kernel/futex.c b/kernel/futex.c
index 9446494..e020b92 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -109,10 +109,17 @@ struct futex_q {
 	struct futex_pi_state *pi_state;
 	struct task_struct *task;
 
+	/* rt_waiter storage for requeue_pi: */
+	struct rt_mutex_waiter *rt_waiter;
+
 	/* Bitset for the optional bitmasked wakeup */
 	u32 bitset;
 };
 
+/* dvhart: FIXME: some commentary here would help to clarify that hb->chain is
+ * actually the queue which contains multiple instances of futex_q - one per
+ * waiter.  The naming is extremely unfortunate as it refects the datastructure
+ * more than its usage. */
 /*
  * Split the global futex_lock into every hash list lock.
  */
@@ -189,6 +196,7 @@ static void drop_futex_key_refs(union futex_key *key)
 /**
  * get_futex_key - Get parameters which are the keys for a futex.
  * @uaddr: virtual address of the futex
+ * dvhart FIXME: incorrent shared comment (fshared, and it's a boolean int)
  * @shared: NULL for a PROCESS_PRIVATE futex,
  *	&current->mm->mmap_sem for a PROCESS_SHARED futex
  * @key: address where result is stored.
@@ -200,6 +208,7 @@ static void drop_futex_key_refs(union futex_key *key)
  * offset_within_page).  For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
+ * dvhart FIXME: incorrent shared comment (fshared, and it's a boolean int)
  * fshared is NULL for PROCESS_PRIVATE futexes
  * For other futexes, it points to &current->mm->mmap_sem and
  * caller must have taken the reader lock. but NOT any spinlocks.
@@ -429,6 +438,21 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 }
 
 /*
+ * futex_requeue_pi_cleanup - cleanup after futex_requeue_pi_init after failed
+ *                            lock acquisition.
+ * @q: the futex_q of the futex we failed to acquire
+ */
+static void futex_requeue_pi_cleanup(struct futex_q *q)
+{
+	if (!q->pi_state)
+		return;
+	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
+		rt_mutex_unlock(&q->pi_state->pi_mutex);
+	else
+		free_pi_state(q->pi_state);
+}
+
+/*
  * Look up the task based on what TID userspace gave us.
  * We dont trust it.
  */
@@ -736,6 +760,7 @@ static void wake_futex(struct futex_q *q)
 	 * at the end of wake_up_all() does not prevent this store from
 	 * moving.
 	 */
+	/* dvhart FIXME: "end of wake_up()" */
 	smp_wmb();
 	q->lock_ptr = NULL;
 }
@@ -834,6 +859,12 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 	}
 }
 
+/* dvhart FIXME: the wording here is inaccurate as both the physical page and
+ * the offset are required for the hashing, it is also non-intuitve as most
+ * will be thinking of "the futex" not "the physical page and offset this
+ * virtual address points to".  Used throughout - consider wholesale cleanup of
+ * function commentary.
+ */
 /*
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
@@ -988,19 +1019,123 @@ out:
 }
 
 /*
- * Requeue all waiters hashed on one physical page to another
- * physical page.
+ * futex_requeue_pi_init - prepare the top waiter to lock the pi futex on wake
+ * @pifutex: the user address of the to futex
+ * @hb1: the from futex hash bucket, must be locked by the caller
+ * @hb2: the to futex hash bucket, must be locked by the caller
+ * @key1: the from futex key
+ * @key2: the to futex key
+ *
+ * Returns 0 on success, a negative error code on failure.
+ *
+ * Prepare the top_waiter and the pi_futex for requeing.  We handle
+ * the userspace r/w here so that we can handle any faults prior
+ * to entering the requeue loop.  hb1 and hb2 must be held by the caller.
+ *
+ * Faults occur for two primary reasons at this point:
+ * 1) The address isn't mapped (what? you didn't use mlock() in your real-time
+ *    application code? *gasp*)
+ * 2) The address isn't writeable
+ *
+ * We return EFAULT on either of these cases and rely on futex_requeue to
+ * handle them.
+ */
+static int futex_requeue_pi_init(u32 __user *pifutex,
+				 struct futex_hash_bucket *hb1,
+				 struct futex_hash_bucket *hb2,
+				 union futex_key *key1, union futex_key *key2,
+				 struct futex_pi_state **ps)
+{
+	u32 curval;
+	struct futex_q *top_waiter;
+	pid_t pid;
+	int ret;
+
+	if (get_futex_value_locked(&curval, pifutex))
+		return -EFAULT;
+
+	top_waiter = futex_top_waiter(hb1, key1);
+
+	/* There are no waiters, nothing for us to do. */
+	if (!top_waiter)
+		return 0;
+
+	/*
+	 * The pifutex has an owner, make sure it's us, if not complain
+	 * to userspace.
+	 * FIXME_LATER: handle this gracefully
+	 */
+	pid = curval & FUTEX_TID_MASK;
+	if (pid && pid != task_pid_vnr(current))
+		return -EMORON;
+
+	/*
+	 * Current should own pifutex, but it could be uncontended.  Here we
+	 * either take the lock for top_waiter or set the FUTEX_WAITERS bit.
+	 * The pi_state is also looked up, but we don't care about the return
+	 * code as we'll have to look that up during requeue for each waiter
+	 * anyway.
+	 */
+	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task);
+
+	/*
+	 * At this point the top_waiter has either taken the pifutex or it is
+	 * waiting on it.  If the former, then the pi_state will not exist yet,
+	 * look it up one more time to ensure we have a reference to it.
+	 */
+	if (!ps /* FIXME && some ret values in here I think ... */)
+		ret = lookup_pi_state(curval, hb2, key2, ps);
+	return ret;
+}
+
+static inline
+void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
+		   struct futex_hash_bucket *hb2, union futex_key *key2)
+{
+
+	/*
+	 * If key1 and key2 hash to the same bucket, no need to
+	 * requeue.
+	 */
+	if (likely(&hb1->chain != &hb2->chain)) {
+		plist_del(&q->list, &hb1->chain);
+		plist_add(&q->list, &hb2->chain);
+		q->lock_ptr = &hb2->lock;
+#ifdef CONFIG_DEBUG_PI_LIST
+		q->list.plist.lock = &hb2->lock;
+#endif
+	}
+	get_futex_key_refs(key2);
+	q->key = *key2;
+}
+
+/*
+ * Requeue all waiters hashed on one physical page to another physical page.
+ * In the requeue_pi case, either takeover uaddr2 or set FUTEX_WAITERS and
+ * setup the pistate.  FUTEX_REQUEUE_PI only supports requeueing from a non-pi
+ * futex to a pi futex.
  */
 static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
-			 int nr_wake, int nr_requeue, u32 *cmpval)
+			 int nr_wake, int nr_requeue, u32 *cmpval,
+			 int requeue_pi)
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
-	int ret, drop_count = 0;
+	u32 curval2;
+	struct futex_pi_state *pi_state = NULL;
+	int drop_count = 0, attempt = 0, task_count = 0, ret;
+
+	if (requeue_pi && refill_pi_state_cache())
+		return -ENOMEM;
 
 retry:
+	if (pi_state != NULL) {
+		free_pi_state(pi_state);
+		pi_state = NULL;
+	}
+
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
@@ -1023,12 +1158,15 @@ retry:
 			if (hb1 != hb2)
 				spin_unlock(&hb2->lock);
 
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+
 			ret = get_user(curval, uaddr1);
 
 			if (!ret)
 				goto retry;
 
-			goto out_put_keys;
+			goto out;
 		}
 		if (curval != *cmpval) {
 			ret = -EAGAIN;
@@ -1036,32 +1174,104 @@ retry:
 		}
 	}
 
+	if (requeue_pi) {
+		/* FIXME: should we handle the no waiters case special? */
+		ret = futex_requeue_pi_init(uaddr2, hb1, hb2, &key1, &key2,
+					    &pi_state);
+
+		if (!ret)
+			ret = get_futex_value_locked(&curval2, uaddr2);
+
+		switch (ret) {
+		case 0:
+			break;
+		case 1:
+			/* we got the lock */
+			ret = 0;
+			break;
+		case -EFAULT:
+			/*
+			 * We handle the fault here instead of in
+			 * futex_requeue_pi_init because we have to reacquire
+			 * both locks to avoid deadlock.
+			 */
+			spin_unlock(&hb1->lock);
+			if (hb1 != hb2)
+				spin_unlock(&hb2->lock);
+
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+
+			if (attempt++) {
+				ret = futex_handle_fault((unsigned long)uaddr2,
+							 attempt);
+				if (ret)
+					goto out;
+				goto retry;
+			}
+
+			ret = get_user(curval2, uaddr2);
+
+			if (!ret)
+				goto retry;
+			goto out;
+		case -EAGAIN:
+			/* The owner was exiting, try again. */
+			spin_unlock(&hb1->lock);
+			if (hb1 != hb2)
+				spin_unlock(&hb2->lock);
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+			cond_resched();
+			goto retry;
+		default:
+			goto out_unlock;
+		}
+	}
+
 	head1 = &hb1->chain;
 	plist_for_each_entry_safe(this, next, head1, list) {
 		if (!match_futex (&this->key, &key1))
 			continue;
-		if (++ret <= nr_wake) {
-			wake_futex(this);
+		/*
+		 * Regardless of if we are waking or requeueing, we need to
+		 * prepare the waiting task to take the rt_mutex in the
+		 * requeue_pi case. If we gave the lock to the top_waiter in
+		 * futex_requeue_pi_init() then don't enqueue that task as a
+		 * waiter on the rt_mutex (it already owns it).
+		 */
+		if (requeue_pi &&
+		    ((curval2 & FUTEX_TID_MASK) != task_pid_vnr(this->task))) {
+			atomic_inc(&pi_state->refcount);
+			this->pi_state = pi_state;
+			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
+							this->rt_waiter,
+							this->task, 1);
+			if (ret)
+				goto out_unlock;
+		}
+
+		if (++task_count <= nr_wake) {
+			if (requeue_pi) {
+				/*
+				 * In the case of requeue_pi we need to know if
+				 * we were requeued or not, so do the requeue
+				 * regardless if we are to wake this task.
+				 */
+				requeue_futex(this, hb1, hb2, &key2);
+				drop_count++;
+				/* FIXME: look into altering wake_futex so we
+				 * can use it (we can't null the lock_ptr) */
+				wake_up(&this->waiter);
+			} else
+				wake_futex(this);
 		} else {
-			/*
-			 * If key1 and key2 hash to the same bucket, no need to
-			 * requeue.
-			 */
-			if (likely(head1 != &hb2->chain)) {
-				plist_del(&this->list, &hb1->chain);
-				plist_add(&this->list, &hb2->chain);
-				this->lock_ptr = &hb2->lock;
-#ifdef CONFIG_DEBUG_PI_LIST
-				this->list.plist.lock = &hb2->lock;
-#endif
-			}
-			this->key = key2;
-			get_futex_key_refs(&key2);
+			requeue_futex(this, hb1, hb2, &key2);
 			drop_count++;
-
-			if (ret - nr_wake >= nr_requeue)
-				break;
 		}
+
+		if (task_count - nr_wake >= nr_requeue)
+			break;
 	}
 
 out_unlock:
@@ -1073,12 +1283,13 @@ out_unlock:
 	while (--drop_count >= 0)
 		drop_futex_key_refs(&key1);
 
-out_put_keys:
 	put_futex_key(fshared, &key2);
 out_put_key1:
 	put_futex_key(fshared, &key1);
 out:
-	return ret;
+	if (pi_state != NULL)
+		free_pi_state(pi_state);
+	return ret ? ret : task_count;
 }
 
 /* The key must be already stored in q->key. */
@@ -1180,6 +1391,7 @@ retry:
  */
 static void unqueue_me_pi(struct futex_q *q)
 {
+	/* FIXME: hitting this warning for requeue_pi */
 	WARN_ON(plist_node_empty(&q->list));
 	plist_del(&q->list, &q->list.plist);
 
@@ -1302,6 +1514,8 @@ handle_fault:
 #define FLAGS_CLOCKRT		0x02
 
 static long futex_wait_restart(struct restart_block *restart);
+static long futex_wait_requeue_pi_restart(struct restart_block *restart);
+static long futex_lock_pi_restart(struct restart_block *restart);
 
 /* finish_futex_lock_pi - post lock pi_state and corner case management
  * @uaddr: the user address of the futex
@@ -1466,6 +1680,9 @@ retry:
 
 	hb = queue_lock(&q);
 
+	/* dvhart FIXME: we access the page before it is queued... obsolete
+	 * comments? */
+
 	/*
 	 * Access the page AFTER the futex is queued.
 	 * Order is important:
@@ -1529,6 +1746,7 @@ retry:
 		restart->fn = futex_wait_restart;
 		restart->futex.uaddr = (u32 *)uaddr;
 		restart->futex.val = val;
+		restart->futex.has_timeout = 1;
 		restart->futex.time = abs_time->tv64;
 		restart->futex.bitset = bitset;
 		restart->futex.flags = 0;
@@ -1559,12 +1777,16 @@ static long futex_wait_restart(struct restart_block *restart)
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
 	int fshared = 0;
 	ktime_t t;
+	ktime_t *tp = NULL;
 
-	t.tv64 = restart->futex.time;
+	if (restart->futex.has_timeout) {
+		t.tv64 = restart->futex.time;
+		tp = &t;
+	}
 	restart->fn = do_no_restart_syscall;
 	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = 1;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
+	return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
 				restart->futex.bitset,
 				restart->futex.flags & FLAGS_CLOCKRT);
 }
@@ -1621,6 +1843,7 @@ retry_unlocked:
 			 * complete.
 			 */
 			queue_unlock(&q, hb);
+			/* FIXME: need to put_futex_key() ? */
 			cond_resched();
 			goto retry;
 		default:
@@ -1653,16 +1876,6 @@ retry_unlocked:
 
 	goto out;
 
-out_unlock_put_key:
-	queue_unlock(&q, hb);
-
-out_put_key:
-	put_futex_key(fshared, &q.key);
-out:
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
-
 uaddr_faulted:
 	/*
 	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
@@ -1685,6 +1898,34 @@ uaddr_faulted:
 		goto retry;
 
 	goto out;
+
+out_unlock_put_key:
+	queue_unlock(&q, hb);
+
+out_put_key:
+	put_futex_key(fshared, &q.key);
+
+out:
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
+	return ret;
+
+}
+
+static long futex_lock_pi_restart(struct restart_block *restart)
+{
+	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
+	ktime_t t;
+	ktime_t *tp = NULL;
+	int fshared = restart->futex.flags & FLAGS_SHARED;
+
+	if (restart->futex.has_timeout) {
+		t.tv64 = restart->futex.time;
+		tp = &t;
+	}
+	restart->fn = do_no_restart_syscall;
+
+	return (long)futex_lock_pi(uaddr, fshared, restart->futex.val, tp, 0);
 }
 
 /*
@@ -1797,6 +2038,316 @@ pi_faulted:
 }
 
 /*
+ * futex_wait_requeue_pi - wait on futex1 (uaddr) and take the futex2 (uaddr2)
+ *                         before returning
+ * @uaddr: the futex we initialyl wait on (possibly non-pi)
+ * @fshared: whether the futexes are shared (1) or not (0).  They must be the
+ *           same type, no requeueing from private to shared, etc.
+ * @val: the expected value of uaddr
+ * @abs_time: absolute timeout
+ * @bitset: FIXME ???
+ * @clockrt: whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
+ * @uaddr2: the pi futex we will take prior to returning to user-space
+ *
+ * The caller will wait on futex1 (uaddr) and will be requeued by
+ * futex_requeue() to futex2 (uaddr2) which must be PI aware.  Normal wakeup
+ * will wake on futex2 and then proceed to take the underlying rt_mutex prior
+ * to returning to userspace.  This ensures the rt_mutex maintains an owner
+ * when it has waiters.  Without one we won't know who to boost/deboost, if
+ * there was a need to.
+ *
+ * We call schedule in futex_wait_queue_me() when we enqueue and return there
+ * via the following:
+ * 1) signal
+ * 2) timeout
+ * 3) wakeup on the first futex (uaddr)
+ * 4) wakeup on the second futex (uaddr2, the pi futex) after a requeue
+ *
+ * If 1 or 2, we need to check if we got the rtmutex, setup the pi_state, or
+ * were enqueued on the rt_mutex via futex_requeue_pi_init() just before the
+ * signal or timeout arrived.  If so, we need to clean that up.  Note: the
+ * setting of FUTEX_WAITERS will be handled when the owner unlocks the
+ * rt_mutex.
+ *
+ * If 3, userspace wrongly called FUTEX_WAKE on the first futex (uaddr) rather
+ * than using the FUTEX_REQUEUE_PI call with nr_requeue=0.  Return -EINVAL.
+ *
+ * If 4, we may then block on trying to take the rt_mutex and return via:
+ * 5) signal
+ * 6) timeout
+ * 7) successful lock
+ *
+ * If 5, we setup a restart_block with futex_lock_pi() as the function.
+ *
+ * If 6, we cleanup and return with -ETIMEDOUT.
+ *
+ * TODO:
+ *   o once we have the all the return points correct, we need to collect
+ *     common code into exit labels.
+ *
+ * Returns:
+ * 0				Success
+ * -EFAULT			For various faults
+ * -EWOULDBLOCK			uaddr has an unexpected value (it changed
+ *  				before we got going)
+ * -ETIMEDOUT			timeout (from either wait on futex1 or locking
+ *				futex2)
+ * -ERESTARTSYS			Signal received (during wait on futex1) with no
+ *				timeout
+ * -ERESTART_RESTARTBLOCK	Signal received (during wait on futex1)
+ * -RESTARTNOINTR		Signal received (during lock of futex2)
+ * -EINVAL			No bitset, woke via FUTEX_WAKE, etc.
+ *
+ * May also passthrough the follpowing return codes (not exhaustive):
+ * -EPERM		see get_futex_key()
+ * -EACCESS		see get_futex_key()
+ * -ENOMEM		see get_user_pages()
+ *
+ */
+static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
+				 u32 val, ktime_t *abs_time, u32 bitset,
+				 int clockrt, u32 __user *uaddr2)
+{
+	struct futex_hash_bucket *hb;
+	struct futex_q q;
+	union futex_key key2 = FUTEX_KEY_INIT;
+	u32 uval;
+	struct rt_mutex *pi_mutex;
+	struct rt_mutex_waiter rt_waiter;
+	struct hrtimer_sleeper timeout, *to = NULL;
+	int requeued = 0;
+	int ret;
+
+	if (!bitset)
+		return -EINVAL;
+
+	if (abs_time) {
+		unsigned long slack;
+		to = &timeout;
+		slack = current->timer_slack_ns;
+		if (rt_task(current))
+			slack = 0;
+		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
+				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_sleeper(to, current);
+		hrtimer_set_expires_range_ns(&to->timer, *abs_time, slack);
+	}
+
+	/*
+	 * The waiter is allocated on our stack, manipulated by the requeue
+	 * code while we sleep on the initial futex (uaddr).
+	 */
+	debug_rt_mutex_init_waiter(&rt_waiter);
+	rt_waiter.task = NULL;
+
+	q.pi_state = NULL;
+	q.bitset = bitset;
+	q.rt_waiter = &rt_waiter;
+
+retry:
+	q.key = FUTEX_KEY_INIT;
+	ret = get_futex_key(uaddr, fshared, &q.key);
+	if (unlikely(ret != 0))
+		goto out;
+
+	ret = get_futex_key(uaddr2, fshared, &key2);
+	if (unlikely(ret != 0)) {
+		drop_futex_key_refs(&q.key);
+		goto out;
+	}
+
+	hb = queue_lock(&q);
+
+	/* dvhart FIXME: we access the page before it is queued... obsolete
+	 * comments? */
+	/*
+	 * Access the page AFTER the futex is queued.
+	 * Order is important:
+	 *
+	 *   Userspace waiter: val = var; if (cond(val)) futex_wait(&var, val);
+	 *   Userspace waker:  if (cond(var)) { var = new; futex_wake(&var); }
+	 *
+	 * The basic logical guarantee of a futex is that it blocks ONLY
+	 * if cond(var) is known to be true at the time of blocking, for
+	 * any cond.  If we queued after testing *uaddr, that would open
+	 * a race condition where we could block indefinitely with
+	 * cond(var) false, which would violate the guarantee.
+	 *
+	 * A consequence is that futex_wait() can return zero and absorb
+	 * a wakeup when *uaddr != val on entry to the syscall.  This is
+	 * rare, but normal.
+	 *
+	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * cannot have changed since we looked it up in get_futex_key.
+	 */
+	ret = get_futex_value_locked(&uval, uaddr);
+
+	if (unlikely(ret)) {
+		queue_unlock(&q, hb);
+		put_futex_key(fshared, &q.key);
+
+		ret = get_user(uval, uaddr);
+
+		if (!ret)
+			goto retry;
+		goto out;
+	}
+	ret = -EWOULDBLOCK;
+
+	/* Only actually queue if *uaddr contained val.  */
+	if (uval != val) {
+		queue_unlock(&q, hb);
+		put_futex_key(fshared, &q.key);
+		goto out;
+	}
+
+	/* queue_me and wait for wakeup, timeout, or a signal. */
+	futex_wait_queue_me(hb, &q, to);
+
+	/*
+	 * Upon return from futex_wait_queue_me, we no longer hold the hb lock,
+	 * but do still hold a key reference.  unqueue_me* will drop a key
+	 * reference to q.key.
+	 */
+
+	requeued = match_futex(&q.key, &key2);
+	drop_futex_key_refs(&key2);
+
+	if (!requeued) {
+		/* Handle wakeup from futex1 (uaddr). */
+		ret = unqueue_me(&q);
+		if (unlikely(ret)) { /* signal */
+			/*
+			 * We expect signal_pending(current), but another
+			 * thread may have handled it for us already.
+			 */
+			if (!abs_time) {
+				ret = -ERESTARTSYS;
+			} else {
+				struct restart_block *restart;
+				restart = &current_thread_info()->restart_block;
+				restart->fn = futex_wait_requeue_pi_restart;
+				restart->futex.uaddr = (u32 *)uaddr;
+				restart->futex.val = val;
+				restart->futex.has_timeout = 1;
+				restart->futex.time = abs_time->tv64;
+				restart->futex.bitset = bitset;
+				restart->futex.flags = 0;
+				restart->futex.uaddr2 = (u32 *)uaddr2;
+
+				if (fshared)
+					restart->futex.flags |= FLAGS_SHARED;
+				if (clockrt)
+					restart->futex.flags |= FLAGS_CLOCKRT;
+				ret = -ERESTART_RESTARTBLOCK;
+			}
+		} else if (to && !to->task) {/* timeout */
+			ret = -ETIMEDOUT;
+		} else {
+			/*
+			 * We woke on uaddr, so userspace probably paired a
+			 * FUTEX_WAKE with FUTEX_WAIT_REQUEUE_PI, which is not
+			 * valid.
+			 */
+			ret = -EINVAL;
+		}
+		goto out;
+	}
+
+	/* Handle wakeup from rt_mutex of futex2 (uaddr2). */
+
+	/* FIXME: this test is REALLY scary... gotta be a better way...
+	 * If the pi futex was uncontended, futex_requeue_pi_init() gave us
+	 * the lock.
+	 */
+	if (!q.pi_state) {
+		ret = 0;
+		goto out;
+	}
+	pi_mutex = &q.pi_state->pi_mutex;
+
+	ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
+	debug_rt_mutex_free_waiter(&waiter);
+
+	if (ret) {
+		if (get_user(uval, uaddr2))
+			ret = -EFAULT;
+
+		if (ret == -EINTR) {
+			/*
+			 * We've already been requeued and enqueued on the
+			 * rt_mutex, so restart by calling futex_lock_pi()
+			 * directly, rather then returning to this function.
+			 */
+			struct restart_block *restart;
+			restart = &current_thread_info()->restart_block;
+			restart->fn = futex_lock_pi_restart;
+			restart->futex.uaddr = (u32 *)uaddr2;
+			restart->futex.val = uval;
+			if (abs_time) {
+				restart->futex.has_timeout = 1;
+				restart->futex.time = abs_time->tv64;
+			} else
+				restart->futex.has_timeout = 0;
+			restart->futex.flags = 0;
+
+			if (fshared)
+				restart->futex.flags |= FLAGS_SHARED;
+			if (clockrt)
+				restart->futex.flags |= FLAGS_CLOCKRT;
+			ret = -ERESTART_RESTARTBLOCK;
+		}
+	}
+
+	spin_lock(q.lock_ptr);
+	ret = finish_futex_lock_pi(uaddr, fshared, &q, ret);
+
+	/* Unqueue and drop the lock. */
+	unqueue_me_pi(&q);
+
+out:
+	if (to) {
+		hrtimer_cancel(&to->timer);
+		destroy_hrtimer_on_stack(&to->timer);
+	}
+	if (requeued) {
+		/* We were requeued, so we now have two reference to key2,
+		 * unqueue_me_pi releases one of them, we must release the
+		 * other. */
+		drop_futex_key_refs(&key2);
+		if (ret) {
+			futex_requeue_pi_cleanup(&q);
+			if (get_user(uval, uaddr2))
+				ret = -EFAULT;
+			if (ret != -ERESTART_RESTARTBLOCK && ret != -EFAULT)
+				ret = futex_lock_pi(uaddr2, fshared, uval,
+						    abs_time, 0);
+		}
+	}
+	return ret;
+}
+
+static long futex_wait_requeue_pi_restart(struct restart_block *restart)
+{
+	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
+	u32 __user *uaddr2 = (u32 __user *)restart->futex.uaddr2;
+	ktime_t t;
+	ktime_t *tp = NULL;
+	int fshared = restart->futex.flags & FLAGS_SHARED;
+	int clockrt = restart->futex.flags & FLAGS_CLOCKRT;
+	int ret;
+
+	if (restart->futex.has_timeout) {
+		t.tv64 = restart->futex.time;
+		tp = &t;
+	}
+	restart->fn = do_no_restart_syscall;
+	ret = futex_wait_requeue_pi(uaddr, fshared, restart->futex.val, tp,
+				    restart->futex.bitset, clockrt, uaddr2);
+	return (long)ret;
+}
+
+/*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
  *
@@ -2016,7 +2567,7 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		fshared = 1;
 
 	clockrt = op & FUTEX_CLOCK_REALTIME;
-	if (clockrt && cmd != FUTEX_WAIT_BITSET)
+	if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
 		return -ENOSYS;
 
 	switch (cmd) {
@@ -2031,10 +2582,11 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		ret = futex_wake(uaddr, fshared, val, val3);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
+		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 0);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3);
+		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
+				    0);
 		break;
 	case FUTEX_WAKE_OP:
 		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
@@ -2051,6 +2603,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		if (futex_cmpxchg_enabled)
 			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
+	case FUTEX_WAIT_REQUEUE_PI:
+		val3 = FUTEX_BITSET_MATCH_ANY;
+		ret = futex_wait_requeue_pi(uaddr, fshared, val, timeout, val3,
+					    clockrt, uaddr2);
+		break;
+	case FUTEX_REQUEUE_PI:
+		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL, 1);
+		break;
+	case FUTEX_CMP_REQUEUE_PI:
+		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
+				    1);
+		break;
 	default:
 		ret = -ENOSYS;
 	}
@@ -2068,22 +2632,25 @@ asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
-		      cmd == FUTEX_WAIT_BITSET)) {
+		      cmd == FUTEX_WAIT_BITSET ||
+		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
 
 		t = timespec_to_ktime(ts);
+		/* dvhart FIXME: do we add FUTEX_WAIT_REQUEUE_PI here? */
 		if (cmd == FUTEX_WAIT)
 			t = ktime_add_safe(ktime_get(), t);
 		tp = &t;
 	}
 	/*
-	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * requeue parameter in 'utime' if cmd == FUTEX_*_REQUEUE_*.
 	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
 	 */
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_REQUEUE_PI || cmd == FUTEX_CMP_REQUEUE_PI ||
 	    cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
 

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
