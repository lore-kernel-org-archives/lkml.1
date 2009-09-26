Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbZIZMba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbZIZMba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZIZMb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:31:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZIZMb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:31:28 -0400
Date: Sat, 26 Sep 2009 14:31:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] futex fixes
Message-ID: <20090926123121.GA12839@elte.hu>
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

Please pull the latest futex fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (6):
      futex: Correct futex_wait_requeue_pi() commentary
      futex: Correct queue_me and unqueue_me commentary
      futex: Make function kernel-doc commentary consistent
      futex: Correct futex_q woken state commentary
      futex: Fix wakeup race by setting TASK_INTERRUPTIBLE before queue_me()
      futex: Add memory barrier commentary to futex_wait_queue_me()


 kernel/futex.c |  137 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 76 insertions(+), 61 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 248dd11..b911adc 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -89,36 +89,36 @@ struct futex_pi_state {
 	union futex_key key;
 };
 
-/*
- * We use this hashed waitqueue instead of a normal wait_queue_t, so
+/**
+ * struct futex_q - The hashed futex queue entry, one per waiting task
+ * @task:		the task waiting on the futex
+ * @lock_ptr:		the hash bucket lock
+ * @key:		the key the futex is hashed on
+ * @pi_state:		optional priority inheritance state
+ * @rt_waiter:		rt_waiter storage for use with requeue_pi
+ * @requeue_pi_key:	the requeue_pi target futex key
+ * @bitset:		bitset for the optional bitmasked wakeup
+ *
+ * We use this hashed waitqueue, instead of a normal wait_queue_t, so
  * we can wake only the relevant ones (hashed queues may be shared).
  *
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
  * The order of wakup is always to make the first condition true, then
- * wake up q->waiter, then make the second condition true.
+ * the second.
+ *
+ * PI futexes are typically woken before they are removed from the hash list via
+ * the rt_mutex code. See unqueue_me_pi().
  */
 struct futex_q {
 	struct plist_node list;
-	/* Waiter reference */
-	struct task_struct *task;
 
-	/* Which hash list lock to use: */
+	struct task_struct *task;
 	spinlock_t *lock_ptr;
-
-	/* Key which the futex is hashed on: */
 	union futex_key key;
-
-	/* Optional priority inheritance state: */
 	struct futex_pi_state *pi_state;
-
-	/* rt_waiter storage for requeue_pi: */
 	struct rt_mutex_waiter *rt_waiter;
-
-	/* The expected requeue pi target futex key: */
 	union futex_key *requeue_pi_key;
-
-	/* Bitset for the optional bitmasked wakeup */
 	u32 bitset;
 };
 
@@ -198,11 +198,12 @@ static void drop_futex_key_refs(union futex_key *key)
 }
 
 /**
- * get_futex_key - Get parameters which are the keys for a futex.
- * @uaddr: virtual address of the futex
- * @fshared: 0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
- * @key: address where result is stored.
- * @rw: mapping needs to be read/write (values: VERIFY_READ, VERIFY_WRITE)
+ * get_futex_key() - Get parameters which are the keys for a futex
+ * @uaddr:	virtual address of the futex
+ * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
+ * @key:	address where result is stored.
+ * @rw:		mapping needs to be read/write (values: VERIFY_READ,
+ * 		VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -288,8 +289,8 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
-/*
- * fault_in_user_writeable - fault in user address and verify RW access
+/**
+ * fault_in_user_writeable() - Fault in user address and verify RW access
  * @uaddr:	pointer to faulting user space address
  *
  * Slow path to fixup the fault we just took in the atomic write
@@ -309,8 +310,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 
 /**
  * futex_top_waiter() - Return the highest priority waiter on a futex
- * @hb:     the hash bucket the futex_q's reside in
- * @key:    the futex key (to distinguish it from other futex futex_q's)
+ * @hb:		the hash bucket the futex_q's reside in
+ * @key:	the futex key (to distinguish it from other futex futex_q's)
  *
  * Must be called with the hb lock held.
  */
@@ -588,7 +589,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 }
 
 /**
- * futex_lock_pi_atomic() - atomic work required to acquire a pi aware futex
+ * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
  * @uaddr:		the pi futex user address
  * @hb:			the pi futex hash bucket
  * @key:		the futex key associated with uaddr and hb
@@ -1011,9 +1012,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 
 /**
  * requeue_pi_wake_futex() - Wake a task that acquired the lock during requeue
- * q:	the futex_q
- * key:	the key of the requeue target futex
- * hb:  the hash_bucket of the requeue target futex
+ * @q:		the futex_q
+ * @key:	the key of the requeue target futex
+ * @hb:		the hash_bucket of the requeue target futex
  *
  * During futex_requeue, with requeue_pi=1, it is possible to acquire the
  * target futex if it is uncontended or via a lock steal.  Set the futex_q key
@@ -1350,6 +1351,25 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 	return hb;
 }
 
+static inline void
+queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
+{
+	spin_unlock(&hb->lock);
+	drop_futex_key_refs(&q->key);
+}
+
+/**
+ * queue_me() - Enqueue the futex_q on the futex_hash_bucket
+ * @q:	The futex_q to enqueue
+ * @hb:	The destination hash bucket
+ *
+ * The hb->lock must be held by the caller, and is released here. A call to
+ * queue_me() is typically paired with exactly one call to unqueue_me().  The
+ * exceptions involve the PI related operations, which may use unqueue_me_pi()
+ * or nothing if the unqueue is done as part of the wake process and the unqueue
+ * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
+ * an example).
+ */
 static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	int prio;
@@ -1373,19 +1393,17 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
 	spin_unlock(&hb->lock);
 }
 
-static inline void
-queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
-{
-	spin_unlock(&hb->lock);
-	drop_futex_key_refs(&q->key);
-}
-
-/*
- * queue_me and unqueue_me must be called as a pair, each
- * exactly once.  They are called with the hashed spinlock held.
+/**
+ * unqueue_me() - Remove the futex_q from its futex_hash_bucket
+ * @q:	The futex_q to unqueue
+ *
+ * The q->lock_ptr must not be held by the caller. A call to unqueue_me() must
+ * be paired with exactly one earlier call to queue_me().
+ *
+ * Returns:
+ *   1 - if the futex_q was still queued (and we removed unqueued it)
+ *   0 - if the futex_q was already removed by the waking thread
  */
-
-/* Return 1 if we were still queued (ie. 0 means we were woken) */
 static int unqueue_me(struct futex_q *q)
 {
 	spinlock_t *lock_ptr;
@@ -1638,17 +1656,14 @@ out:
 static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 				struct hrtimer_sleeper *timeout)
 {
-	queue_me(q, hb);
-
 	/*
-	 * There might have been scheduling since the queue_me(), as we
-	 * cannot hold a spinlock across the get_user() in case it
-	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
-	 * queueing ourselves into the futex hash. This code thus has to
-	 * rely on the futex_wake() code removing us from hash when it
-	 * wakes us up.
+	 * The task state is guaranteed to be set before another task can
+	 * wake it. set_current_state() is implemented using set_mb() and
+	 * queue_me() calls spin_unlock() upon completion, both serializing
+	 * access to the hash list and forcing another memory barrier.
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
+	queue_me(q, hb);
 
 	/* Arm the timer */
 	if (timeout) {
@@ -1658,8 +1673,8 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 	}
 
 	/*
-	 * !plist_node_empty() is safe here without any lock.
-	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
+	 * If we have been removed from the hash list, then another task
+	 * has tried to wake us, and we can skip the call to schedule().
 	 */
 	if (likely(!plist_node_empty(&q->list))) {
 		/*
@@ -2114,12 +2129,12 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 
 /**
  * futex_wait_requeue_pi() - Wait on uaddr and take uaddr2
- * @uaddr:	the futex we initialyl wait on (non-pi)
+ * @uaddr:	the futex we initially wait on (non-pi)
  * @fshared:	whether the futexes are shared (1) or not (0).  They must be
  * 		the same type, no requeueing from private to shared, etc.
  * @val:	the expected value of uaddr
  * @abs_time:	absolute timeout
- * @bitset:	32 bit wakeup bitset set by userspace, defaults to all.
+ * @bitset:	32 bit wakeup bitset set by userspace, defaults to all
  * @clockrt:	whether to use CLOCK_REALTIME (1) or CLOCK_MONOTONIC (0)
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
@@ -2246,7 +2261,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		res = fixup_owner(uaddr2, fshared, &q, !ret);
 		/*
 		 * If fixup_owner() returned an error, proprogate that.  If it
-		 * acquired the lock, clear our -ETIMEDOUT or -EINTR.
+		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
 		 */
 		if (res)
 			ret = (res < 0) ? res : 0;
@@ -2302,9 +2317,9 @@ out:
  */
 
 /**
- * sys_set_robust_list - set the robust-futex list head of a task
- * @head: pointer to the list-head
- * @len: length of the list-head, as userspace expects
+ * sys_set_robust_list() - Set the robust-futex list head of a task
+ * @head:	pointer to the list-head
+ * @len:	length of the list-head, as userspace expects
  */
 SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 		size_t, len)
@@ -2323,10 +2338,10 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 }
 
 /**
- * sys_get_robust_list - get the robust-futex list head of a task
- * @pid: pid of the process [zero for current task]
- * @head_ptr: pointer to a list-head pointer, the kernel fills it in
- * @len_ptr: pointer to a length field, the kernel fills in the header size
+ * sys_get_robust_list() - Get the robust-futex list head of a task
+ * @pid:	pid of the process [zero for current task]
+ * @head_ptr:	pointer to a list-head pointer, the kernel fills it in
+ * @len_ptr:	pointer to a length field, the kernel fills in the header size
  */
 SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,
