Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZFJV7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZFJV7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbZFJV7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:59:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076AbZFJV7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:59:39 -0400
Date: Wed, 10 Jun 2009 23:59:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] core/futexes for v2.6.31
Message-ID: <20090610215925.GA7146@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (13):
      futex: separate futex_wait_queue_me() logic from futex_wait()
      futex: add helper to find the top prio waiter of a futex
      futex: split out atomic logic from futex_lock_pi()
      futex: split out fixup owner logic from futex_lock_pi()
      rt_mutex: add proxy lock routines
      futex: add FUTEX_HAS_TIMEOUT flag to restart.futex.flags
      futex: distangle futex_requeue()
      futex: split out futex value validation code
      futex: add requeue_pi functionality
      futex: fixup unlocked requeue pi case
      futex: fix futex_wait_setup key handling
      futex: remove FUTEX_REQUEUE_PI (non CMP)
      futex: add requeue-pi documentation

Stephen Rothwell (1):
      sparc64: extend TI_RESTART_BLOCK space by 8 bytes

Thomas Gleixner (4):
      futex: remove the wait queue
      futex: cleanup error exit
      futex: fix restart for early wakeup in futex_wait_requeue_pi()
      futex: fix restart in wait_requeue_pi


 Documentation/futex-requeue-pi.txt      |  131 ++++
 arch/sparc/include/asm/thread_info_64.h |    4 +-
 include/linux/futex.h                   |    6 +
 include/linux/thread_info.h             |    3 +-
 kernel/futex.c                          | 1188 +++++++++++++++++++++++--------
 kernel/rtmutex.c                        |  240 +++++--
 kernel/rtmutex_common.h                 |    8 +
 7 files changed, 1225 insertions(+), 355 deletions(-)
 create mode 100644 Documentation/futex-requeue-pi.txt

diff --git a/Documentation/futex-requeue-pi.txt b/Documentation/futex-requeue-pi.txt
new file mode 100644
index 0000000..9dc1ff4
--- /dev/null
+++ b/Documentation/futex-requeue-pi.txt
@@ -0,0 +1,131 @@
+Futex Requeue PI
+----------------
+
+Requeueing of tasks from a non-PI futex to a PI futex requires
+special handling in order to ensure the underlying rt_mutex is never
+left without an owner if it has waiters; doing so would break the PI
+boosting logic [see rt-mutex-desgin.txt] For the purposes of
+brevity, this action will be referred to as "requeue_pi" throughout
+this document.  Priority inheritance is abbreviated throughout as
+"PI".
+
+Motivation
+----------
+
+Without requeue_pi, the glibc implementation of
+pthread_cond_broadcast() must resort to waking all the tasks waiting
+on a pthread_condvar and letting them try to sort out which task
+gets to run first in classic thundering-herd formation.  An ideal
+implementation would wake the highest-priority waiter, and leave the
+rest to the natural wakeup inherent in unlocking the mutex
+associated with the condvar.
+
+Consider the simplified glibc calls:
+
+/* caller must lock mutex */
+pthread_cond_wait(cond, mutex)
+{
+	lock(cond->__data.__lock);
+	unlock(mutex);
+	do {
+	   unlock(cond->__data.__lock);
+	   futex_wait(cond->__data.__futex);
+	   lock(cond->__data.__lock);
+	} while(...)
+	unlock(cond->__data.__lock);
+	lock(mutex);
+}
+
+pthread_cond_broadcast(cond)
+{
+	lock(cond->__data.__lock);
+	unlock(cond->__data.__lock);
+	futex_requeue(cond->data.__futex, cond->mutex);
+}
+
+Once pthread_cond_broadcast() requeues the tasks, the cond->mutex
+has waiters. Note that pthread_cond_wait() attempts to lock the
+mutex only after it has returned to user space.  This will leave the
+underlying rt_mutex with waiters, and no owner, breaking the
+previously mentioned PI-boosting algorithms.
+
+In order to support PI-aware pthread_condvar's, the kernel needs to
+be able to requeue tasks to PI futexes.  This support implies that
+upon a successful futex_wait system call, the caller would return to
+user space already holding the PI futex.  The glibc implementation
+would be modified as follows:
+
+
+/* caller must lock mutex */
+pthread_cond_wait_pi(cond, mutex)
+{
+	lock(cond->__data.__lock);
+	unlock(mutex);
+	do {
+	   unlock(cond->__data.__lock);
+	   futex_wait_requeue_pi(cond->__data.__futex);
+	   lock(cond->__data.__lock);
+	} while(...)
+	unlock(cond->__data.__lock);
+        /* the kernel acquired the the mutex for us */
+}
+
+pthread_cond_broadcast_pi(cond)
+{
+	lock(cond->__data.__lock);
+	unlock(cond->__data.__lock);
+	futex_requeue_pi(cond->data.__futex, cond->mutex);
+}
+
+The actual glibc implementation will likely test for PI and make the
+necessary changes inside the existing calls rather than creating new
+calls for the PI cases.  Similar changes are needed for
+pthread_cond_timedwait() and pthread_cond_signal().
+
+Implementation
+--------------
+
+In order to ensure the rt_mutex has an owner if it has waiters, it
+is necessary for both the requeue code, as well as the waiting code,
+to be able to acquire the rt_mutex before returning to user space.
+The requeue code cannot simply wake the waiter and leave it to
+acquire the rt_mutex as it would open a race window between the
+requeue call returning to user space and the waiter waking and
+starting to run.  This is especially true in the uncontended case.
+
+The solution involves two new rt_mutex helper routines,
+rt_mutex_start_proxy_lock() and rt_mutex_finish_proxy_lock(), which
+allow the requeue code to acquire an uncontended rt_mutex on behalf
+of the waiter and to enqueue the waiter on a contended rt_mutex.
+Two new system calls provide the kernel<->user interface to
+requeue_pi: FUTEX_WAIT_REQUEUE_PI and FUTEX_REQUEUE_CMP_PI.
+
+FUTEX_WAIT_REQUEUE_PI is called by the waiter (pthread_cond_wait()
+and pthread_cond_timedwait()) to block on the initial futex and wait
+to be requeued to a PI-aware futex.  The implementation is the
+result of a high-speed collision between futex_wait() and
+futex_lock_pi(), with some extra logic to check for the additional
+wake-up scenarios.
+
+FUTEX_REQUEUE_CMP_PI is called by the waker
+(pthread_cond_broadcast() and pthread_cond_signal()) to requeue and
+possibly wake the waiting tasks. Internally, this system call is
+still handled by futex_requeue (by passing requeue_pi=1).  Before
+requeueing, futex_requeue() attempts to acquire the requeue target
+PI futex on behalf of the top waiter.  If it can, this waiter is
+woken.  futex_requeue() then proceeds to requeue the remaining
+nr_wake+nr_requeue tasks to the PI futex, calling
+rt_mutex_start_proxy_lock() prior to each requeue to prepare the
+task as a waiter on the underlying rt_mutex.  It is possible that
+the lock can be acquired at this stage as well, if so, the next
+waiter is woken to finish the acquisition of the lock.
+
+FUTEX_REQUEUE_PI accepts nr_wake and nr_requeue as arguments, but
+their sum is all that really matters.  futex_requeue() will wake or
+requeue up to nr_wake + nr_requeue tasks.  It will wake only as many
+tasks as it can acquire the lock for, which in the majority of cases
+should be 0 as good programming practice dictates that the caller of
+either pthread_cond_broadcast() or pthread_cond_signal() acquire the
+mutex prior to making the call. FUTEX_REQUEUE_PI requires that
+nr_wake=1.  nr_requeue should be INT_MAX for broadcast and 0 for
+signal.
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index 639ac80..6586572 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -102,8 +102,8 @@ struct thread_info {
 #define TI_KERN_CNTD1	0x00000488
 #define TI_PCR		0x00000490
 #define TI_RESTART_BLOCK 0x00000498
-#define TI_KUNA_REGS	0x000004c0
-#define TI_KUNA_INSN	0x000004c8
+#define TI_KUNA_REGS	0x000004c8
+#define TI_KUNA_INSN	0x000004d0
 #define TI_FPREGS	0x00000500
 
 /* We embed this in the uppermost byte of thread_info->flags */
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 3bf5bb5..34956c8 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -23,6 +23,8 @@ union ktime;
 #define FUTEX_TRYLOCK_PI	8
 #define FUTEX_WAIT_BITSET	9
 #define FUTEX_WAKE_BITSET	10
+#define FUTEX_WAIT_REQUEUE_PI	11
+#define FUTEX_CMP_REQUEUE_PI	12
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -38,6 +40,10 @@ union ktime;
 #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAIT_REQUEUE_PI_PRIVATE	(FUTEX_WAIT_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
+#define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
+					 FUTEX_PRIVATE_FLAG)
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e6b820f..a8cc4e1 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -21,13 +21,14 @@ struct restart_block {
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
 			u64 time;
+			u32 *uaddr2;
 		} futex;
 		/* For nanosleep */
 		struct {
diff --git a/kernel/futex.c b/kernel/futex.c
index d546b2d..80b5ce7 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -19,6 +19,10 @@
  *  PRIVATE futexes by Eric Dumazet
  *  Copyright (C) 2007 Eric Dumazet <dada1@cosmosbay.com>
  *
+ *  Requeue-PI support by Darren Hart <dvhltc@us.ibm.com>
+ *  Copyright (C) IBM Corporation, 2009
+ *  Thanks to Thomas Gleixner for conceptual design and careful reviews.
+ *
  *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
  *  enough at me, Linus for the original (flawed) idea, Matthew
  *  Kirkwood for proof-of-concept implementation.
@@ -96,8 +100,8 @@ struct futex_pi_state {
  */
 struct futex_q {
 	struct plist_node list;
-	/* There can only be a single waiter */
-	wait_queue_head_t waiter;
+	/* Waiter reference */
+	struct task_struct *task;
 
 	/* Which hash list lock to use: */
 	spinlock_t *lock_ptr;
@@ -107,7 +111,9 @@ struct futex_q {
 
 	/* Optional priority inheritance state: */
 	struct futex_pi_state *pi_state;
-	struct task_struct *task;
+
+	/* rt_waiter storage for requeue_pi: */
+	struct rt_mutex_waiter *rt_waiter;
 
 	/* Bitset for the optional bitmasked wakeup */
 	u32 bitset;
@@ -278,6 +284,25 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
+/**
+ * futex_top_waiter() - Return the highest priority waiter on a futex
+ * @hb:     the hash bucket the futex_q's reside in
+ * @key:    the futex key (to distinguish it from other futex futex_q's)
+ *
+ * Must be called with the hb lock held.
+ */
+static struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb,
+					union futex_key *key)
+{
+	struct futex_q *this;
+
+	plist_for_each_entry(this, &hb->chain, list) {
+		if (match_futex(&this->key, key))
+			return this;
+	}
+	return NULL;
+}
+
 static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
 {
 	u32 curval;
@@ -539,28 +564,160 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	return 0;
 }
 
+/**
+ * futex_lock_pi_atomic() - atomic work required to acquire a pi aware futex
+ * @uaddr:		the pi futex user address
+ * @hb:			the pi futex hash bucket
+ * @key:		the futex key associated with uaddr and hb
+ * @ps:			the pi_state pointer where we store the result of the
+ *			lookup
+ * @task:		the task to perform the atomic lock work for.  This will
+ *			be "current" except in the case of requeue pi.
+ * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
+ *
+ * Returns:
+ *  0 - ready to wait
+ *  1 - acquired the lock
+ * <0 - error
+ *
+ * The hb->lock and futex_key refs shall be held by the caller.
+ */
+static int futex_lock_pi_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
+				union futex_key *key,
+				struct futex_pi_state **ps,
+				struct task_struct *task, int set_waiters)
+{
+	int lock_taken, ret, ownerdied = 0;
+	u32 uval, newval, curval;
+
+retry:
+	ret = lock_taken = 0;
+
+	/*
+	 * To avoid races, we attempt to take the lock here again
+	 * (by doing a 0 -> TID atomic cmpxchg), while holding all
+	 * the locks. It will most likely not succeed.
+	 */
+	newval = task_pid_vnr(task);
+	if (set_waiters)
+		newval |= FUTEX_WAITERS;
+
+	curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
+
+	if (unlikely(curval == -EFAULT))
+		return -EFAULT;
+
+	/*
+	 * Detect deadlocks.
+	 */
+	if ((unlikely((curval & FUTEX_TID_MASK) == task_pid_vnr(task))))
+		return -EDEADLK;
+
+	/*
+	 * Surprise - we got the lock. Just return to userspace:
+	 */
+	if (unlikely(!curval))
+		return 1;
+
+	uval = curval;
+
+	/*
+	 * Set the FUTEX_WAITERS flag, so the owner will know it has someone
+	 * to wake at the next unlock.
+	 */
+	newval = curval | FUTEX_WAITERS;
+
+	/*
+	 * There are two cases, where a futex might have no owner (the
+	 * owner TID is 0): OWNER_DIED. We take over the futex in this
+	 * case. We also do an unconditional take over, when the owner
+	 * of the futex died.
+	 *
+	 * This is safe as we are protected by the hash bucket lock !
+	 */
+	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
+		/* Keep the OWNER_DIED bit */
+		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(task);
+		ownerdied = 0;
+		lock_taken = 1;
+	}
+
+	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
+
+	if (unlikely(curval == -EFAULT))
+		return -EFAULT;
+	if (unlikely(curval != uval))
+		goto retry;
+
+	/*
+	 * We took the lock due to owner died take over.
+	 */
+	if (unlikely(lock_taken))
+		return 1;
+
+	/*
+	 * We dont have the lock. Look up the PI state (or create it if
+	 * we are the first waiter):
+	 */
+	ret = lookup_pi_state(uval, hb, key, ps);
+
+	if (unlikely(ret)) {
+		switch (ret) {
+		case -ESRCH:
+			/*
+			 * No owner found for this futex. Check if the
+			 * OWNER_DIED bit is set to figure out whether
+			 * this is a robust futex or not.
+			 */
+			if (get_futex_value_locked(&curval, uaddr))
+				return -EFAULT;
+
+			/*
+			 * We simply start over in case of a robust
+			 * futex. The code above will take the futex
+			 * and return happy.
+			 */
+			if (curval & FUTEX_OWNER_DIED) {
+				ownerdied = 1;
+				goto retry;
+			}
+		default:
+			break;
+		}
+	}
+
+	return ret;
+}
+
 /*
  * The hash bucket lock must be held when this is called.
  * Afterwards, the futex_q must not be accessed.
  */
 static void wake_futex(struct futex_q *q)
 {
-	plist_del(&q->list, &q->list.plist);
+	struct task_struct *p = q->task;
+
 	/*
-	 * The lock in wake_up_all() is a crucial memory barrier after the
-	 * plist_del() and also before assigning to q->lock_ptr.
+	 * We set q->lock_ptr = NULL _before_ we wake up the task. If
+	 * a non futex wake up happens on another CPU then the task
+	 * might exit and p would dereference a non existing task
+	 * struct. Prevent this by holding a reference on p across the
+	 * wake up.
 	 */
-	wake_up(&q->waiter);
+	get_task_struct(p);
+
+	plist_del(&q->list, &q->list.plist);
 	/*
-	 * The waiting task can free the futex_q as soon as this is written,
-	 * without taking any locks.  This must come last.
-	 *
-	 * A memory barrier is required here to prevent the following store to
-	 * lock_ptr from getting ahead of the wakeup. Clearing the lock at the
-	 * end of wake_up() does not prevent this store from moving.
+	 * The waiting task can free the futex_q as soon as
+	 * q->lock_ptr = NULL is written, without taking any locks. A
+	 * memory barrier is required here to prevent the following
+	 * store to lock_ptr from getting ahead of the plist_del.
 	 */
 	smp_wmb();
 	q->lock_ptr = NULL;
+
+	wake_up_state(p, TASK_NORMAL);
+	put_task_struct(p);
 }
 
 static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
@@ -689,7 +846,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (match_futex (&this->key, &key)) {
-			if (this->pi_state) {
+			if (this->pi_state || this->rt_waiter) {
 				ret = -EINVAL;
 				break;
 			}
@@ -802,24 +959,185 @@ out:
 	return ret;
 }
 
-/*
- * Requeue all waiters hashed on one physical page to another
- * physical page.
+/**
+ * requeue_futex() - Requeue a futex_q from one hb to another
+ * @q:		the futex_q to requeue
+ * @hb1:	the source hash_bucket
+ * @hb2:	the target hash_bucket
+ * @key2:	the new key for the requeued futex_q
+ */
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
+/**
+ * requeue_pi_wake_futex() - Wake a task that acquired the lock during requeue
+ * q:	the futex_q
+ * key:	the key of the requeue target futex
+ *
+ * During futex_requeue, with requeue_pi=1, it is possible to acquire the
+ * target futex if it is uncontended or via a lock steal.  Set the futex_q key
+ * to the requeue target futex so the waiter can detect the wakeup on the right
+ * futex, but remove it from the hb and NULL the rt_waiter so it can detect
+ * atomic lock acquisition.  Must be called with the q->lock_ptr held.
+ */
+static inline
+void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
+{
+	drop_futex_key_refs(&q->key);
+	get_futex_key_refs(key);
+	q->key = *key;
+
+	WARN_ON(plist_node_empty(&q->list));
+	plist_del(&q->list, &q->list.plist);
+
+	WARN_ON(!q->rt_waiter);
+	q->rt_waiter = NULL;
+
+	wake_up_state(q->task, TASK_NORMAL);
+}
+
+/**
+ * futex_proxy_trylock_atomic() - Attempt an atomic lock for the top waiter
+ * @pifutex:		the user address of the to futex
+ * @hb1:		the from futex hash bucket, must be locked by the caller
+ * @hb2:		the to futex hash bucket, must be locked by the caller
+ * @key1:		the from futex key
+ * @key2:		the to futex key
+ * @ps:			address to store the pi_state pointer
+ * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
+ *
+ * Try and get the lock on behalf of the top waiter if we can do it atomically.
+ * Wake the top waiter if we succeed.  If the caller specified set_waiters,
+ * then direct futex_lock_pi_atomic() to force setting the FUTEX_WAITERS bit.
+ * hb1 and hb2 must be held by the caller.
+ *
+ * Returns:
+ *  0 - failed to acquire the lock atomicly
+ *  1 - acquired the lock
+ * <0 - error
+ */
+static int futex_proxy_trylock_atomic(u32 __user *pifutex,
+				 struct futex_hash_bucket *hb1,
+				 struct futex_hash_bucket *hb2,
+				 union futex_key *key1, union futex_key *key2,
+				 struct futex_pi_state **ps, int set_waiters)
+{
+	struct futex_q *top_waiter = NULL;
+	u32 curval;
+	int ret;
+
+	if (get_futex_value_locked(&curval, pifutex))
+		return -EFAULT;
+
+	/*
+	 * Find the top_waiter and determine if there are additional waiters.
+	 * If the caller intends to requeue more than 1 waiter to pifutex,
+	 * force futex_lock_pi_atomic() to set the FUTEX_WAITERS bit now,
+	 * as we have means to handle the possible fault.  If not, don't set
+	 * the bit unecessarily as it will force the subsequent unlock to enter
+	 * the kernel.
+	 */
+	top_waiter = futex_top_waiter(hb1, key1);
+
+	/* There are no waiters, nothing for us to do. */
+	if (!top_waiter)
+		return 0;
+
+	/*
+	 * Try to take the lock for top_waiter.  Set the FUTEX_WAITERS bit in
+	 * the contended case or if set_waiters is 1.  The pi_state is returned
+	 * in ps in contended cases.
+	 */
+	ret = futex_lock_pi_atomic(pifutex, hb2, key2, ps, top_waiter->task,
+				   set_waiters);
+	if (ret == 1)
+		requeue_pi_wake_futex(top_waiter, key2);
+
+	return ret;
+}
+
+/**
+ * futex_requeue() - Requeue waiters from uaddr1 to uaddr2
+ * uaddr1:	source futex user address
+ * uaddr2:	target futex user address
+ * nr_wake:	number of waiters to wake (must be 1 for requeue_pi)
+ * nr_requeue:	number of waiters to requeue (0-INT_MAX)
+ * requeue_pi:	if we are attempting to requeue from a non-pi futex to a
+ * 		pi futex (pi to pi requeue is not supported)
+ *
+ * Requeue waiters on uaddr1 to uaddr2. In the requeue_pi case, try to acquire
+ * uaddr2 atomically on behalf of the top waiter.
+ *
+ * Returns:
+ * >=0 - on success, the number of tasks requeued or woken
+ *  <0 - on error
  */
 static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
-			 int nr_wake, int nr_requeue, u32 *cmpval)
+			 int nr_wake, int nr_requeue, u32 *cmpval,
+			 int requeue_pi)
 {
 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
+	int drop_count = 0, task_count = 0, ret;
+	struct futex_pi_state *pi_state = NULL;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
-	int ret, drop_count = 0;
+	u32 curval2;
+
+	if (requeue_pi) {
+		/*
+		 * requeue_pi requires a pi_state, try to allocate it now
+		 * without any locks in case it fails.
+		 */
+		if (refill_pi_state_cache())
+			return -ENOMEM;
+		/*
+		 * requeue_pi must wake as many tasks as it can, up to nr_wake
+		 * + nr_requeue, since it acquires the rt_mutex prior to
+		 * returning to userspace, so as to not leave the rt_mutex with
+		 * waiters and no owner.  However, second and third wake-ups
+		 * cannot be predicted as they involve race conditions with the
+		 * first wake and a fault while looking up the pi_state.  Both
+		 * pthread_cond_signal() and pthread_cond_broadcast() should
+		 * use nr_wake=1.
+		 */
+		if (nr_wake != 1)
+			return -EINVAL;
+	}
 
 retry:
+	if (pi_state != NULL) {
+		/*
+		 * We will have to lookup the pi_state again, so free this one
+		 * to keep the accounting correct.
+		 */
+		free_pi_state(pi_state);
+		pi_state = NULL;
+	}
+
 	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_READ);
+	ret = get_futex_key(uaddr2, fshared, &key2,
+			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -854,32 +1172,99 @@ retry_private:
 		}
 	}
 
+	if (requeue_pi && (task_count - nr_wake < nr_requeue)) {
+		/*
+		 * Attempt to acquire uaddr2 and wake the top waiter. If we
+		 * intend to requeue waiters, force setting the FUTEX_WAITERS
+		 * bit.  We force this here where we are able to easily handle
+		 * faults rather in the requeue loop below.
+		 */
+		ret = futex_proxy_trylock_atomic(uaddr2, hb1, hb2, &key1,
+						 &key2, &pi_state, nr_requeue);
+
+		/*
+		 * At this point the top_waiter has either taken uaddr2 or is
+		 * waiting on it.  If the former, then the pi_state will not
+		 * exist yet, look it up one more time to ensure we have a
+		 * reference to it.
+		 */
+		if (ret == 1) {
+			WARN_ON(pi_state);
+			task_count++;
+			ret = get_futex_value_locked(&curval2, uaddr2);
+			if (!ret)
+				ret = lookup_pi_state(curval2, hb2, &key2,
+						      &pi_state);
+		}
+
+		switch (ret) {
+		case 0:
+			break;
+		case -EFAULT:
+			double_unlock_hb(hb1, hb2);
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+			ret = get_user(curval2, uaddr2);
+			if (!ret)
+				goto retry;
+			goto out;
+		case -EAGAIN:
+			/* The owner was exiting, try again. */
+			double_unlock_hb(hb1, hb2);
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
-		if (!match_futex (&this->key, &key1))
+		if (task_count - nr_wake >= nr_requeue)
+			break;
+
+		if (!match_futex(&this->key, &key1))
 			continue;
-		if (++ret <= nr_wake) {
+
+		WARN_ON(!requeue_pi && this->rt_waiter);
+		WARN_ON(requeue_pi && !this->rt_waiter);
+
+		/*
+		 * Wake nr_wake waiters.  For requeue_pi, if we acquired the
+		 * lock, we already woke the top_waiter.  If not, it will be
+		 * woken by futex_unlock_pi().
+		 */
+		if (++task_count <= nr_wake && !requeue_pi) {
 			wake_futex(this);
-		} else {
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
-			drop_count++;
+			continue;
+		}
 
-			if (ret - nr_wake >= nr_requeue)
-				break;
+		/*
+		 * Requeue nr_requeue waiters and possibly one more in the case
+		 * of requeue_pi if we couldn't acquire the lock atomically.
+		 */
+		if (requeue_pi) {
+			/* Prepare the waiter to take the rt_mutex. */
+			atomic_inc(&pi_state->refcount);
+			this->pi_state = pi_state;
+			ret = rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
+							this->rt_waiter,
+							this->task, 1);
+			if (ret == 1) {
+				/* We got the lock. */
+				requeue_pi_wake_futex(this, &key2);
+				continue;
+			} else if (ret) {
+				/* -EDEADLK */
+				this->pi_state = NULL;
+				free_pi_state(pi_state);
+				goto out_unlock;
+			}
 		}
+		requeue_futex(this, hb1, hb2, &key2);
+		drop_count++;
 	}
 
 out_unlock:
@@ -899,7 +1284,9 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(fshared, &key1);
 out:
-	return ret;
+	if (pi_state != NULL)
+		free_pi_state(pi_state);
+	return ret ? ret : task_count;
 }
 
 /* The key must be already stored in q->key. */
@@ -907,8 +1294,6 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	init_waitqueue_head(&q->waiter);
-
 	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
@@ -1119,35 +1504,149 @@ handle_fault:
  */
 #define FLAGS_SHARED		0x01
 #define FLAGS_CLOCKRT		0x02
+#define FLAGS_HAS_TIMEOUT	0x04
 
 static long futex_wait_restart(struct restart_block *restart);
 
-static int futex_wait(u32 __user *uaddr, int fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+/**
+ * fixup_owner() - Post lock pi_state and corner case management
+ * @uaddr:	user address of the futex
+ * @fshared:	whether the futex is shared (1) or not (0)
+ * @q:		futex_q (contains pi_state and access to the rt_mutex)
+ * @locked:	if the attempt to take the rt_mutex succeeded (1) or not (0)
+ *
+ * After attempting to lock an rt_mutex, this function is called to cleanup
+ * the pi_state owner as well as handle race conditions that may allow us to
+ * acquire the lock. Must be called with the hb lock held.
+ *
+ * Returns:
+ *  1 - success, lock taken
+ *  0 - success, lock not taken
+ * <0 - on error (-EFAULT)
+ */
+static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
+		       int locked)
 {
-	struct task_struct *curr = current;
-	struct restart_block *restart;
-	DECLARE_WAITQUEUE(wait, curr);
-	struct futex_hash_bucket *hb;
-	struct futex_q q;
-	u32 uval;
-	int ret;
-	struct hrtimer_sleeper t;
-	int rem = 0;
+	struct task_struct *owner;
+	int ret = 0;
 
-	if (!bitset)
-		return -EINVAL;
+	if (locked) {
+		/*
+		 * Got the lock. We might not be the anticipated owner if we
+		 * did a lock-steal - fix up the PI-state in that case:
+		 */
+		if (q->pi_state->owner != current)
+			ret = fixup_pi_state_owner(uaddr, q, current, fshared);
+		goto out;
+	}
 
-	q.pi_state = NULL;
-	q.bitset = bitset;
-retry:
-	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_READ);
-	if (unlikely(ret != 0))
+	/*
+	 * Catch the rare case, where the lock was released when we were on the
+	 * way back before we locked the hash bucket.
+	 */
+	if (q->pi_state->owner == current) {
+		/*
+		 * Try to get the rt_mutex now. This might fail as some other
+		 * task acquired the rt_mutex after we removed ourself from the
+		 * rt_mutex waiters list.
+		 */
+		if (rt_mutex_trylock(&q->pi_state->pi_mutex)) {
+			locked = 1;
+			goto out;
+		}
+
+		/*
+		 * pi_state is incorrect, some other task did a lock steal and
+		 * we returned due to timeout or signal without taking the
+		 * rt_mutex. Too late. We can access the rt_mutex_owner without
+		 * locking, as the other task is now blocked on the hash bucket
+		 * lock. Fix the state up.
+		 */
+		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
+		ret = fixup_pi_state_owner(uaddr, q, owner, fshared);
 		goto out;
+	}
 
-retry_private:
-	hb = queue_lock(&q);
+	/*
+	 * Paranoia check. If we did not take the lock, then we should not be
+	 * the owner, nor the pending owner, of the rt_mutex.
+	 */
+	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
+		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
+				"pi-state %p\n", ret,
+				q->pi_state->pi_mutex.owner,
+				q->pi_state->owner);
+
+out:
+	return ret ? ret : locked;
+}
+
+/**
+ * futex_wait_queue_me() - queue_me() and wait for wakeup, timeout, or signal
+ * @hb:		the futex hash bucket, must be locked by the caller
+ * @q:		the futex_q to queue up on
+ * @timeout:	the prepared hrtimer_sleeper, or null for no timeout
+ */
+static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
+				struct hrtimer_sleeper *timeout)
+{
+	queue_me(q, hb);
+
+	/*
+	 * There might have been scheduling since the queue_me(), as we
+	 * cannot hold a spinlock across the get_user() in case it
+	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
+	 * queueing ourselves into the futex hash. This code thus has to
+	 * rely on the futex_wake() code removing us from hash when it
+	 * wakes us up.
+	 */
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	/* Arm the timer */
+	if (timeout) {
+		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
+		if (!hrtimer_active(&timeout->timer))
+			timeout->task = NULL;
+	}
+
+	/*
+	 * !plist_node_empty() is safe here without any lock.
+	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
+	 */
+	if (likely(!plist_node_empty(&q->list))) {
+		/*
+		 * If the timer has already expired, current will already be
+		 * flagged for rescheduling. Only call schedule if there
+		 * is no timeout, or if it has yet to expire.
+		 */
+		if (!timeout || timeout->task)
+			schedule();
+	}
+	__set_current_state(TASK_RUNNING);
+}
+
+/**
+ * futex_wait_setup() - Prepare to wait on a futex
+ * @uaddr:	the futex userspace address
+ * @val:	the expected value
+ * @fshared:	whether the futex is shared (1) or not (0)
+ * @q:		the associated futex_q
+ * @hb:		storage for hash_bucket pointer to be returned to caller
+ *
+ * Setup the futex_q and locate the hash_bucket.  Get the futex value and
+ * compare it with the expected value.  Handle atomic faults internally.
+ * Return with the hb lock held and a q.key reference on success, and unlocked
+ * with no q.key reference on failure.
+ *
+ * Returns:
+ *  0 - uaddr contains val and hb has been locked
+ * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
+ */
+static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
+			   struct futex_q *q, struct futex_hash_bucket **hb)
+{
+	u32 uval;
+	int ret;
 
 	/*
 	 * Access the page AFTER the hash-bucket is locked.
@@ -1165,95 +1664,83 @@ retry_private:
 	 * A consequence is that futex_wait() can return zero and absorb
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
-	 *
-	 * For shared futexes, we hold the mmap semaphore, so the mapping
-	 * cannot have changed since we looked it up in get_futex_key.
 	 */
+retry:
+	q->key = FUTEX_KEY_INIT;
+	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
+	if (unlikely(ret != 0))
+		return ret;
+
+retry_private:
+	*hb = queue_lock(q);
+
 	ret = get_futex_value_locked(&uval, uaddr);
 
-	if (unlikely(ret)) {
-		queue_unlock(&q, hb);
+	if (ret) {
+		queue_unlock(q, *hb);
 
 		ret = get_user(uval, uaddr);
 		if (ret)
-			goto out_put_key;
+			goto out;
 
 		if (!fshared)
 			goto retry_private;
 
-		put_futex_key(fshared, &q.key);
+		put_futex_key(fshared, &q->key);
 		goto retry;
 	}
-	ret = -EWOULDBLOCK;
-	if (unlikely(uval != val)) {
-		queue_unlock(&q, hb);
-		goto out_put_key;
-	}
 
-	/* Only actually queue if *uaddr contained val.  */
-	queue_me(&q, hb);
+	if (uval != val) {
+		queue_unlock(q, *hb);
+		ret = -EWOULDBLOCK;
+	}
 
-	/*
-	 * There might have been scheduling since the queue_me(), as we
-	 * cannot hold a spinlock across the get_user() in case it
-	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
-	 * queueing ourselves into the futex hash.  This code thus has to
-	 * rely on the futex_wake() code removing us from hash when it
-	 * wakes us up.
-	 */
+out:
+	if (ret)
+		put_futex_key(fshared, &q->key);
+	return ret;
+}
 
-	/* add_wait_queue is the barrier after __set_current_state. */
-	__set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&q.waiter, &wait);
-	/*
-	 * !plist_node_empty() is safe here without any lock.
-	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
-	 */
-	if (likely(!plist_node_empty(&q.list))) {
-		if (!abs_time)
-			schedule();
-		else {
-			hrtimer_init_on_stack(&t.timer,
-					      clockrt ? CLOCK_REALTIME :
-					      CLOCK_MONOTONIC,
-					      HRTIMER_MODE_ABS);
-			hrtimer_init_sleeper(&t, current);
-			hrtimer_set_expires_range_ns(&t.timer, *abs_time,
-						     current->timer_slack_ns);
-
-			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
-			if (!hrtimer_active(&t.timer))
-				t.task = NULL;
+static int futex_wait(u32 __user *uaddr, int fshared,
+		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+{
+	struct hrtimer_sleeper timeout, *to = NULL;
+	struct restart_block *restart;
+	struct futex_hash_bucket *hb;
+	struct futex_q q;
+	int ret;
 
-			/*
-			 * the timer could have already expired, in which
-			 * case current would be flagged for rescheduling.
-			 * Don't bother calling schedule.
-			 */
-			if (likely(t.task))
-				schedule();
+	if (!bitset)
+		return -EINVAL;
 
-			hrtimer_cancel(&t.timer);
+	q.pi_state = NULL;
+	q.bitset = bitset;
+	q.rt_waiter = NULL;
 
-			/* Flag if a timeout occured */
-			rem = (t.task == NULL);
+	if (abs_time) {
+		to = &timeout;
 
-			destroy_hrtimer_on_stack(&t.timer);
-		}
+		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
+				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_sleeper(to, current);
+		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
+					     current->timer_slack_ns);
 	}
-	__set_current_state(TASK_RUNNING);
 
-	/*
-	 * NOTE: we don't remove ourselves from the waitqueue because
-	 * we are the only user of it.
-	 */
+	/* Prepare to wait on uaddr. */
+	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	if (ret)
+		goto out;
+
+	/* queue_me and wait for wakeup, timeout, or a signal. */
+	futex_wait_queue_me(hb, &q, to);
 
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	ret = 0;
 	if (!unqueue_me(&q))
 		goto out_put_key;
 	ret = -ETIMEDOUT;
-	if (rem)
+	if (to && !to->task)
 		goto out_put_key;
 
 	/*
@@ -1270,7 +1757,7 @@ retry_private:
 	restart->futex.val = val;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
-	restart->futex.flags = 0;
+	restart->futex.flags = FLAGS_HAS_TIMEOUT;
 
 	if (fshared)
 		restart->futex.flags |= FLAGS_SHARED;
@@ -1282,6 +1769,10 @@ retry_private:
 out_put_key:
 	put_futex_key(fshared, &q.key);
 out:
+	if (to) {
+		hrtimer_cancel(&to->timer);
+		destroy_hrtimer_on_stack(&to->timer);
+	}
 	return ret;
 }
 
@@ -1290,13 +1781,16 @@ static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
 	int fshared = 0;
-	ktime_t t;
+	ktime_t t, *tp = NULL;
 
-	t.tv64 = restart->futex.time;
+	if (restart->futex.flags & FLAGS_HAS_TIMEOUT) {
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
@@ -1312,11 +1806,10 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
-	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
-	u32 uval, newval, curval;
+	u32 uval;
 	struct futex_q q;
-	int ret, lock_taken, ownerdied = 0;
+	int res, ret;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1330,6 +1823,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	}
 
 	q.pi_state = NULL;
+	q.rt_waiter = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
@@ -1339,81 +1833,15 @@ retry:
 retry_private:
 	hb = queue_lock(&q);
 
-retry_locked:
-	ret = lock_taken = 0;
-
-	/*
-	 * To avoid races, we attempt to take the lock here again
-	 * (by doing a 0 -> TID atomic cmpxchg), while holding all
-	 * the locks. It will most likely not succeed.
-	 */
-	newval = task_pid_vnr(current);
-
-	curval = cmpxchg_futex_value_locked(uaddr, 0, newval);
-
-	if (unlikely(curval == -EFAULT))
-		goto uaddr_faulted;
-
-	/*
-	 * Detect deadlocks. In case of REQUEUE_PI this is a valid
-	 * situation and we return success to user space.
-	 */
-	if (unlikely((curval & FUTEX_TID_MASK) == task_pid_vnr(current))) {
-		ret = -EDEADLK;
-		goto out_unlock_put_key;
-	}
-
-	/*
-	 * Surprise - we got the lock. Just return to userspace:
-	 */
-	if (unlikely(!curval))
-		goto out_unlock_put_key;
-
-	uval = curval;
-
-	/*
-	 * Set the WAITERS flag, so the owner will know it has someone
-	 * to wake at next unlock
-	 */
-	newval = curval | FUTEX_WAITERS;
-
-	/*
-	 * There are two cases, where a futex might have no owner (the
-	 * owner TID is 0): OWNER_DIED. We take over the futex in this
-	 * case. We also do an unconditional take over, when the owner
-	 * of the futex died.
-	 *
-	 * This is safe as we are protected by the hash bucket lock !
-	 */
-	if (unlikely(ownerdied || !(curval & FUTEX_TID_MASK))) {
-		/* Keep the OWNER_DIED bit */
-		newval = (curval & ~FUTEX_TID_MASK) | task_pid_vnr(current);
-		ownerdied = 0;
-		lock_taken = 1;
-	}
-
-	curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
-
-	if (unlikely(curval == -EFAULT))
-		goto uaddr_faulted;
-	if (unlikely(curval != uval))
-		goto retry_locked;
-
-	/*
-	 * We took the lock due to owner died take over.
-	 */
-	if (unlikely(lock_taken))
-		goto out_unlock_put_key;
-
-	/*
-	 * We dont have the lock. Look up the PI state (or create it if
-	 * we are the first waiter):
-	 */
-	ret = lookup_pi_state(uval, hb, &q.key, &q.pi_state);
-
+	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current, 0);
 	if (unlikely(ret)) {
 		switch (ret) {
-
+		case 1:
+			/* We got the lock. */
+			ret = 0;
+			goto out_unlock_put_key;
+		case -EFAULT:
+			goto uaddr_faulted;
 		case -EAGAIN:
 			/*
 			 * Task is exiting and we just wait for the
@@ -1423,25 +1851,6 @@ retry_locked:
 			put_futex_key(fshared, &q.key);
 			cond_resched();
 			goto retry;
-
-		case -ESRCH:
-			/*
-			 * No owner found for this futex. Check if the
-			 * OWNER_DIED bit is set to figure out whether
-			 * this is a robust futex or not.
-			 */
-			if (get_futex_value_locked(&curval, uaddr))
-				goto uaddr_faulted;
-
-			/*
-			 * We simply start over in case of a robust
-			 * futex. The code above will take the futex
-			 * and return happy.
-			 */
-			if (curval & FUTEX_OWNER_DIED) {
-				ownerdied = 1;
-				goto retry_locked;
-			}
 		default:
 			goto out_unlock_put_key;
 		}
@@ -1465,71 +1874,21 @@ retry_locked:
 	}
 
 	spin_lock(q.lock_ptr);
-
-	if (!ret) {
-		/*
-		 * Got the lock. We might not be the anticipated owner
-		 * if we did a lock-steal - fix up the PI-state in
-		 * that case:
-		 */
-		if (q.pi_state->owner != curr)
-			ret = fixup_pi_state_owner(uaddr, &q, curr, fshared);
-	} else {
-		/*
-		 * Catch the rare case, where the lock was released
-		 * when we were on the way back before we locked the
-		 * hash bucket.
-		 */
-		if (q.pi_state->owner == curr) {
-			/*
-			 * Try to get the rt_mutex now. This might
-			 * fail as some other task acquired the
-			 * rt_mutex after we removed ourself from the
-			 * rt_mutex waiters list.
-			 */
-			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
-				ret = 0;
-			else {
-				/*
-				 * pi_state is incorrect, some other
-				 * task did a lock steal and we
-				 * returned due to timeout or signal
-				 * without taking the rt_mutex. Too
-				 * late. We can access the
-				 * rt_mutex_owner without locking, as
-				 * the other task is now blocked on
-				 * the hash bucket lock. Fix the state
-				 * up.
-				 */
-				struct task_struct *owner;
-				int res;
-
-				owner = rt_mutex_owner(&q.pi_state->pi_mutex);
-				res = fixup_pi_state_owner(uaddr, &q, owner,
-							   fshared);
-
-				/* propagate -EFAULT, if the fixup failed */
-				if (res)
-					ret = res;
-			}
-		} else {
-			/*
-			 * Paranoia check. If we did not take the lock
-			 * in the trylock above, then we should not be
-			 * the owner of the rtmutex, neither the real
-			 * nor the pending one:
-			 */
-			if (rt_mutex_owner(&q.pi_state->pi_mutex) == curr)
-				printk(KERN_ERR "futex_lock_pi: ret = %d "
-				       "pi-mutex: %p pi-state %p\n", ret,
-				       q.pi_state->pi_mutex.owner,
-				       q.pi_state->owner);
-		}
-	}
+	/*
+	 * Fixup the pi_state owner and possibly acquire the lock if we
+	 * haven't already.
+	 */
+	res = fixup_owner(uaddr, fshared, &q, !ret);
+	/*
+	 * If fixup_owner() returned an error, proprogate that.  If it acquired
+	 * the lock, clear our -ETIMEDOUT or -EINTR.
+	 */
+	if (res)
+		ret = (res < 0) ? res : 0;
 
 	/*
-	 * If fixup_pi_state_owner() faulted and was unable to handle the
-	 * fault, unlock it and return the fault to userspace.
+	 * If fixup_owner() faulted and was unable to handle the fault, unlock
+	 * it and return the fault to userspace.
 	 */
 	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
 		rt_mutex_unlock(&q.pi_state->pi_mutex);
@@ -1537,9 +1896,7 @@ retry_locked:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+	goto out;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
@@ -1549,7 +1906,7 @@ out_put_key:
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
 	/*
@@ -1572,7 +1929,6 @@ uaddr_faulted:
 	goto retry;
 }
 
-
 /*
  * Userspace attempted a TID -> 0 atomic transition, and failed.
  * This is the in-kernel slowpath: we look up the PI state (if any),
@@ -1674,6 +2030,229 @@ pi_faulted:
 	return ret;
 }
 
+/**
+ * handle_early_requeue_pi_wakeup() - Detect early wakeup on the initial futex
+ * @hb:		the hash_bucket futex_q was original enqueued on
+ * @q:		the futex_q woken while waiting to be requeued
+ * @key2:	the futex_key of the requeue target futex
+ * @timeout:	the timeout associated with the wait (NULL if none)
+ *
+ * Detect if the task was woken on the initial futex as opposed to the requeue
+ * target futex.  If so, determine if it was a timeout or a signal that caused
+ * the wakeup and return the appropriate error code to the caller.  Must be
+ * called with the hb lock held.
+ *
+ * Returns
+ *  0 - no early wakeup detected
+ * <0 - -ETIMEDOUT or -ERESTARTNOINTR
+ */
+static inline
+int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
+				   struct futex_q *q, union futex_key *key2,
+				   struct hrtimer_sleeper *timeout)
+{
+	int ret = 0;
+
+	/*
+	 * With the hb lock held, we avoid races while we process the wakeup.
+	 * We only need to hold hb (and not hb2) to ensure atomicity as the
+	 * wakeup code can't change q.key from uaddr to uaddr2 if we hold hb.
+	 * It can't be requeued from uaddr2 to something else since we don't
+	 * support a PI aware source futex for requeue.
+	 */
+	if (!match_futex(&q->key, key2)) {
+		WARN_ON(q->lock_ptr && (&hb->lock != q->lock_ptr));
+		/*
+		 * We were woken prior to requeue by a timeout or a signal.
+		 * Unqueue the futex_q and determine which it was.
+		 */
+		plist_del(&q->list, &q->list.plist);
+		drop_futex_key_refs(&q->key);
+
+		if (timeout && !timeout->task)
+			ret = -ETIMEDOUT;
+		else
+			ret = -ERESTARTNOINTR;
+	}
+	return ret;
+}
+
+/**
+ * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
+ * @uaddr:	the futex we initialyl wait on (non-pi)
+ * @fshared:	whether the futexes are shared (1) or not (0).  They must be
+ * 		the same type, no requeueing from private to shared, etc.
+ * @val:	the expected value of uaddr
+ * @abs_time:	absolute timeout
+ * @bitset:	32 bit wakeup bitset set by userspace, defaults to all.
+ * @clockrt:	whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
+ * @uaddr2:	the pi futex we will take prior to returning to user-space
+ *
+ * The caller will wait on uaddr and will be requeued by futex_requeue() to
+ * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
+ * complete the acquisition of the rt_mutex prior to returning to userspace.
+ * This ensures the rt_mutex maintains an owner when it has waiters; without
+ * one, the pi logic wouldn't know which task to boost/deboost, if there was a
+ * need to.
+ *
+ * We call schedule in futex_wait_queue_me() when we enqueue and return there
+ * via the following:
+ * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
+ * 2) wakeup on uaddr2 after a requeue and subsequent unlock
+ * 3) signal (before or after requeue)
+ * 4) timeout (before or after requeue)
+ *
+ * If 3, we setup a restart_block with futex_wait_requeue_pi() as the function.
+ *
+ * If 2, we may then block on trying to take the rt_mutex and return via:
+ * 5) successful lock
+ * 6) signal
+ * 7) timeout
+ * 8) other lock acquisition failure
+ *
+ * If 6, we setup a restart_block with futex_lock_pi() as the function.
+ *
+ * If 4 or 7, we cleanup and return with -ETIMEDOUT.
+ *
+ * Returns:
+ *  0 - On success
+ * <0 - On error
+ */
+static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
+				 u32 val, ktime_t *abs_time, u32 bitset,
+				 int clockrt, u32 __user *uaddr2)
+{
+	struct hrtimer_sleeper timeout, *to = NULL;
+	struct rt_mutex_waiter rt_waiter;
+	struct rt_mutex *pi_mutex = NULL;
+	struct futex_hash_bucket *hb;
+	union futex_key key2;
+	struct futex_q q;
+	int res, ret;
+
+	if (!bitset)
+		return -EINVAL;
+
+	if (abs_time) {
+		to = &timeout;
+		hrtimer_init_on_stack(&to->timer, clockrt ? CLOCK_REALTIME :
+				      CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+		hrtimer_init_sleeper(to, current);
+		hrtimer_set_expires_range_ns(&to->timer, *abs_time,
+					     current->timer_slack_ns);
+	}
+
+	/*
+	 * The waiter is allocated on our stack, manipulated by the requeue
+	 * code while we sleep on uaddr.
+	 */
+	debug_rt_mutex_init_waiter(&rt_waiter);
+	rt_waiter.task = NULL;
+
+	q.pi_state = NULL;
+	q.bitset = bitset;
+	q.rt_waiter = &rt_waiter;
+
+	key2 = FUTEX_KEY_INIT;
+	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
+	if (unlikely(ret != 0))
+		goto out;
+
+	/* Prepare to wait on uaddr. */
+	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	if (ret)
+		goto out_key2;
+
+	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
+	futex_wait_queue_me(hb, &q, to);
+
+	spin_lock(&hb->lock);
+	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
+	spin_unlock(&hb->lock);
+	if (ret)
+		goto out_put_keys;
+
+	/*
+	 * In order for us to be here, we know our q.key == key2, and since
+	 * we took the hb->lock above, we also know that futex_requeue() has
+	 * completed and we no longer have to concern ourselves with a wakeup
+	 * race with the atomic proxy lock acquition by the requeue code.
+	 */
+
+	/* Check if the requeue code acquired the second futex for us. */
+	if (!q.rt_waiter) {
+		/*
+		 * Got the lock. We might not be the anticipated owner if we
+		 * did a lock-steal - fix up the PI-state in that case.
+		 */
+		if (q.pi_state && (q.pi_state->owner != current)) {
+			spin_lock(q.lock_ptr);
+			ret = fixup_pi_state_owner(uaddr2, &q, current,
+						   fshared);
+			spin_unlock(q.lock_ptr);
+		}
+	} else {
+		/*
+		 * We have been woken up by futex_unlock_pi(), a timeout, or a
+		 * signal.  futex_unlock_pi() will not destroy the lock_ptr nor
+		 * the pi_state.
+		 */
+		WARN_ON(!&q.pi_state);
+		pi_mutex = &q.pi_state->pi_mutex;
+		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
+		debug_rt_mutex_free_waiter(&rt_waiter);
+
+		spin_lock(q.lock_ptr);
+		/*
+		 * Fixup the pi_state owner and possibly acquire the lock if we
+		 * haven't already.
+		 */
+		res = fixup_owner(uaddr2, fshared, &q, !ret);
+		/*
+		 * If fixup_owner() returned an error, proprogate that.  If it
+		 * acquired the lock, clear our -ETIMEDOUT or -EINTR.
+		 */
+		if (res)
+			ret = (res < 0) ? res : 0;
+
+		/* Unqueue and drop the lock. */
+		unqueue_me_pi(&q);
+	}
+
+	/*
+	 * If fixup_pi_state_owner() faulted and was unable to handle the
+	 * fault, unlock the rt_mutex and return the fault to userspace.
+	 */
+	if (ret == -EFAULT) {
+		if (rt_mutex_owner(pi_mutex) == current)
+			rt_mutex_unlock(pi_mutex);
+	} else if (ret == -EINTR) {
+		/*
+		 * We've already been requeued, but we have no way to
+		 * restart by calling futex_lock_pi() directly. We
+		 * could restart the syscall, but that will look at
+		 * the user space value and return right away. So we
+		 * drop back with EWOULDBLOCK to tell user space that
+		 * "val" has been changed. That's the same what the
+		 * restart of the syscall would do in
+		 * futex_wait_setup().
+		 */
+		ret = -EWOULDBLOCK;
+	}
+
+out_put_keys:
+	put_futex_key(fshared, &q.key);
+out_key2:
+	put_futex_key(fshared, &key2);
+
+out:
+	if (to) {
+		hrtimer_cancel(&to->timer);
+		destroy_hrtimer_on_stack(&to->timer);
+	}
+	return ret;
+}
+
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
@@ -1896,7 +2475,7 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		fshared = 1;
 
 	clockrt = op & FUTEX_CLOCK_REALTIME;
-	if (clockrt && cmd != FUTEX_WAIT_BITSET)
+	if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
 		return -ENOSYS;
 
 	switch (cmd) {
@@ -1911,10 +2490,11 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
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
@@ -1931,6 +2511,15 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		if (futex_cmpxchg_enabled)
 			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
+	case FUTEX_WAIT_REQUEUE_PI:
+		val3 = FUTEX_BITSET_MATCH_ANY;
+		ret = futex_wait_requeue_pi(uaddr, fshared, val, timeout, val3,
+					    clockrt, uaddr2);
+		break;
+	case FUTEX_CMP_REQUEUE_PI:
+		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3,
+				    1);
+		break;
 	default:
 		ret = -ENOSYS;
 	}
@@ -1948,7 +2537,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	int cmd = op & FUTEX_CMD_MASK;
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
-		      cmd == FUTEX_WAIT_BITSET)) {
+		      cmd == FUTEX_WAIT_BITSET ||
+		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -1960,11 +2550,11 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 		tp = &t;
 	}
 	/*
-	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * requeue parameter in 'utime' if cmd == FUTEX_*_REQUEUE_*.
 	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
 	 */
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
-	    cmd == FUTEX_WAKE_OP)
+	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 69d9cb9..fec77e7 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -300,7 +300,8 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
  * assigned pending owner [which might not have taken the
  * lock yet]:
  */
-static inline int try_to_steal_lock(struct rt_mutex *lock)
+static inline int try_to_steal_lock(struct rt_mutex *lock,
+				    struct task_struct *task)
 {
 	struct task_struct *pendowner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *next;
@@ -309,11 +310,11 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
 	if (!rt_mutex_owner_pending(lock))
 		return 0;
 
-	if (pendowner == current)
+	if (pendowner == task)
 		return 1;
 
 	spin_lock_irqsave(&pendowner->pi_lock, flags);
-	if (current->prio >= pendowner->prio) {
+	if (task->prio >= pendowner->prio) {
 		spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 		return 0;
 	}
@@ -338,21 +339,21 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
 	 * We are going to steal the lock and a waiter was
 	 * enqueued on the pending owners pi_waiters queue. So
 	 * we have to enqueue this waiter into
-	 * current->pi_waiters list. This covers the case,
-	 * where current is boosted because it holds another
+	 * task->pi_waiters list. This covers the case,
+	 * where task is boosted because it holds another
 	 * lock and gets unboosted because the booster is
 	 * interrupted, so we would delay a waiter with higher
-	 * priority as current->normal_prio.
+	 * priority as task->normal_prio.
 	 *
 	 * Note: in the rare case of a SCHED_OTHER task changing
 	 * its priority and thus stealing the lock, next->task
-	 * might be current:
+	 * might be task:
 	 */
-	if (likely(next->task != current)) {
-		spin_lock_irqsave(&current->pi_lock, flags);
-		plist_add(&next->pi_list_entry, &current->pi_waiters);
-		__rt_mutex_adjust_prio(current);
-		spin_unlock_irqrestore(&current->pi_lock, flags);
+	if (likely(next->task != task)) {
+		spin_lock_irqsave(&task->pi_lock, flags);
+		plist_add(&next->pi_list_entry, &task->pi_waiters);
+		__rt_mutex_adjust_prio(task);
+		spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
 	return 1;
 }
@@ -389,7 +390,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
 	 */
 	mark_rt_mutex_waiters(lock);
 
-	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock))
+	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
 		return 0;
 
 	/* We got the lock. */
@@ -411,6 +412,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
  */
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
+				   struct task_struct *task,
 				   int detect_deadlock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
@@ -418,21 +420,21 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	unsigned long flags;
 	int chain_walk = 0, res;
 
-	spin_lock_irqsave(&current->pi_lock, flags);
-	__rt_mutex_adjust_prio(current);
-	waiter->task = current;
+	spin_lock_irqsave(&task->pi_lock, flags);
+	__rt_mutex_adjust_prio(task);
+	waiter->task = task;
 	waiter->lock = lock;
-	plist_node_init(&waiter->list_entry, current->prio);
-	plist_node_init(&waiter->pi_list_entry, current->prio);
+	plist_node_init(&waiter->list_entry, task->prio);
+	plist_node_init(&waiter->pi_list_entry, task->prio);
 
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
 		top_waiter = rt_mutex_top_waiter(lock);
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
-	current->pi_blocked_on = waiter;
+	task->pi_blocked_on = waiter;
 
-	spin_unlock_irqrestore(&current->pi_lock, flags);
+	spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		spin_lock_irqsave(&owner->pi_lock, flags);
@@ -460,7 +462,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	spin_unlock(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 current);
+					 task);
 
 	spin_lock(&lock->wait_lock);
 
@@ -605,37 +607,25 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
 }
 
-/*
- * Slow path lock function:
+/**
+ * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
+ * @lock:		 the rt_mutex to take
+ * @state:		 the state the task should block in (TASK_INTERRUPTIBLE
+ * 			 or TASK_UNINTERRUPTIBLE)
+ * @timeout:		 the pre-initialized and started timer, or NULL for none
+ * @waiter:		 the pre-initialized rt_mutex_waiter
+ * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
+ *
+ * lock->wait_lock must be held by the caller.
  */
 static int __sched
-rt_mutex_slowlock(struct rt_mutex *lock, int state,
-		  struct hrtimer_sleeper *timeout,
-		  int detect_deadlock)
+__rt_mutex_slowlock(struct rt_mutex *lock, int state,
+		    struct hrtimer_sleeper *timeout,
+		    struct rt_mutex_waiter *waiter,
+		    int detect_deadlock)
 {
-	struct rt_mutex_waiter waiter;
 	int ret = 0;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
-
-	spin_lock(&lock->wait_lock);
-
-	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock)) {
-		spin_unlock(&lock->wait_lock);
-		return 0;
-	}
-
-	set_current_state(state);
-
-	/* Setup the timer, when timeout != NULL */
-	if (unlikely(timeout)) {
-		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
-		if (!hrtimer_active(&timeout->timer))
-			timeout->task = NULL;
-	}
-
 	for (;;) {
 		/* Try to acquire the lock: */
 		if (try_to_take_rt_mutex(lock))
@@ -656,19 +646,19 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		}
 
 		/*
-		 * waiter.task is NULL the first time we come here and
+		 * waiter->task is NULL the first time we come here and
 		 * when we have been woken up by the previous owner
 		 * but the lock got stolen by a higher prio task.
 		 */
-		if (!waiter.task) {
-			ret = task_blocks_on_rt_mutex(lock, &waiter,
+		if (!waiter->task) {
+			ret = task_blocks_on_rt_mutex(lock, waiter, current,
 						      detect_deadlock);
 			/*
 			 * If we got woken up by the owner then start loop
 			 * all over without going into schedule to try
 			 * to get the lock now:
 			 */
-			if (unlikely(!waiter.task)) {
+			if (unlikely(!waiter->task)) {
 				/*
 				 * Reset the return value. We might
 				 * have returned with -EDEADLK and the
@@ -684,15 +674,52 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		spin_unlock(&lock->wait_lock);
 
-		debug_rt_mutex_print_deadlock(&waiter);
+		debug_rt_mutex_print_deadlock(waiter);
 
-		if (waiter.task)
+		if (waiter->task)
 			schedule_rt_mutex(lock);
 
 		spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
 
+	return ret;
+}
+
+/*
+ * Slow path lock function:
+ */
+static int __sched
+rt_mutex_slowlock(struct rt_mutex *lock, int state,
+		  struct hrtimer_sleeper *timeout,
+		  int detect_deadlock)
+{
+	struct rt_mutex_waiter waiter;
+	int ret = 0;
+
+	debug_rt_mutex_init_waiter(&waiter);
+	waiter.task = NULL;
+
+	spin_lock(&lock->wait_lock);
+
+	/* Try to acquire the lock again: */
+	if (try_to_take_rt_mutex(lock)) {
+		spin_unlock(&lock->wait_lock);
+		return 0;
+	}
+
+	set_current_state(state);
+
+	/* Setup the timer, when timeout != NULL */
+	if (unlikely(timeout)) {
+		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
+		if (!hrtimer_active(&timeout->timer))
+			timeout->task = NULL;
+	}
+
+	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
+				  detect_deadlock);
+
 	set_current_state(TASK_RUNNING);
 
 	if (unlikely(waiter.task))
@@ -986,6 +1013,59 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 }
 
 /**
+ * rt_mutex_start_proxy_lock() - Start lock acquisition for another task
+ * @lock:		the rt_mutex to take
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @task:		the task to prepare
+ * @detect_deadlock:	perform deadlock detection (1) or not (0)
+ *
+ * Returns:
+ *  0 - task blocked on lock
+ *  1 - acquired the lock for task, caller should wake it up
+ * <0 - error
+ *
+ * Special API call for FUTEX_REQUEUE_PI support.
+ */
+int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+			      struct rt_mutex_waiter *waiter,
+			      struct task_struct *task, int detect_deadlock)
+{
+	int ret;
+
+	spin_lock(&lock->wait_lock);
+
+	mark_rt_mutex_waiters(lock);
+
+	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
+		/* We got the lock for task. */
+		debug_rt_mutex_lock(lock);
+
+		rt_mutex_set_owner(lock, task, 0);
+
+		rt_mutex_deadlock_account_lock(lock, task);
+		return 1;
+	}
+
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+
+
+	if (ret && !waiter->task) {
+		/*
+		 * Reset the return value. We might have
+		 * returned with -EDEADLK and the owner
+		 * released the lock while we were walking the
+		 * pi chain.  Let the waiter sort it out.
+		 */
+		ret = 0;
+	}
+	spin_unlock(&lock->wait_lock);
+
+	debug_rt_mutex_print_deadlock(waiter);
+
+	return ret;
+}
+
+/**
  * rt_mutex_next_owner - return the next owner of the lock
  *
  * @lock: the rt lock query
@@ -1004,3 +1084,57 @@ struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
 
 	return rt_mutex_top_waiter(lock)->task;
 }
+
+/**
+ * rt_mutex_finish_proxy_lock() - Complete lock acquisition
+ * @lock:		the rt_mutex we were woken on
+ * @to:			the timeout, null if none. hrtimer should already have
+ * 			been started.
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @detect_deadlock:	perform deadlock detection (1) or not (0)
+ *
+ * Complete the lock acquisition started our behalf by another thread.
+ *
+ * Returns:
+ *  0 - success
+ * <0 - error, one of -EINTR, -ETIMEDOUT, or -EDEADLK
+ *
+ * Special API call for PI-futex requeue support
+ */
+int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
+			       struct hrtimer_sleeper *to,
+			       struct rt_mutex_waiter *waiter,
+			       int detect_deadlock)
+{
+	int ret;
+
+	spin_lock(&lock->wait_lock);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
+				  detect_deadlock);
+
+	set_current_state(TASK_RUNNING);
+
+	if (unlikely(waiter->task))
+		remove_waiter(lock, waiter);
+
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
+	spin_unlock(&lock->wait_lock);
+
+	/*
+	 * Readjust priority, when we did not get the lock. We might have been
+	 * the pending owner and boosted. Since we did not take the lock, the
+	 * PI boost has to go.
+	 */
+	if (unlikely(ret))
+		rt_mutex_adjust_prio(current);
+
+	return ret;
+}
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index e124bf5..97a2f81 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -120,6 +120,14 @@ extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 				  struct task_struct *proxy_owner);
+extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+				     struct rt_mutex_waiter *waiter,
+				     struct task_struct *task,
+				     int detect_deadlock);
+extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
+				      struct hrtimer_sleeper *to,
+				      struct rt_mutex_waiter *waiter,
+				      int detect_deadlock);
 
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"
