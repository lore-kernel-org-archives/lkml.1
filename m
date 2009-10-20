Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZJTMGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZJTMGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 08:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZJTMGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 08:06:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZJTMGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 08:06:42 -0400
Date: Tue, 20 Oct 2009 14:06:32 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
cc: linux-rt-users@vger.kernel.org
Subject: [PATCH -rt] Futex Comments-fix-ups (from Darren Hart)
Message-ID: <alpine.LFD.2.00.0910201359280.3609@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Darren

As requested, I took your futex comment fix-ups from the following commits

9beba3c54dd180a26a1da2027cfbe9edfaf9c40e
d8d88fbb186fe3ea37b2a58adb32413c98b59656
d96ee56ce0582967fba9f3f0ac4503957147bea6
d40d65c8dbdd39f0b64e043f6bd08f8a38f55194
56ec1607b15b6a5f6de5aab14f16a763b88296fc

and cherry-picked them all for v2.6.31.4-rt14

Here they are all, put together as one patch.
Signed-off-by: John Kacur <jkacur@redhat.com>

>From dc4073833a7543322f945c4bcf67bc106d7128f6 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 24 Sep 2009 11:54:47 -0700
Subject: [PATCH] futex: Add memory barrier commentary to futex_wait_queue_me()

The memory barrier semantics of futex_wait_queue_me() are
non-obvious. Add some commentary to try and clarify it.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090924185447.694.38948.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5978a84..61761ef 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1638,6 +1638,12 @@ out:
 static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 				struct hrtimer_sleeper *timeout)
 {
+	/*
+	 * The task state is guaranteed to be set before another task can
+	 * wake it. set_current_state() is implemented using set_mb() and
+	 * queue_me() calls spin_unlock() upon completion, both serializing
+	 * access to the hash list and forcing another memory barrier.
+	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	queue_me(q, hb);
 
-- 
1.6.0.6

>From 6575a45a2ed6bad78390cdfd2668fbbaceb6956a Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:22 -0700
Subject: [PATCH] futex: Make function kernel-doc commentary consistent

Make the existing function kernel-doc consistent throughout
futex.c, following Documentation/kernel-doc-nano-howto.txt as
closely as possible.

When unsure, at least be consistent within futex.c.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053022.8717.13339.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 61761ef..5df1f49 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
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
@@ -2313,9 +2314,9 @@ out:
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
@@ -2334,10 +2335,10 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
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
-- 
1.6.0.6

>From bfe470aa42687965162cb68219ffd583f628cac8 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:15 -0700
Subject: [PATCH] futex: Correct queue_me and unqueue_me commentary

The queue_me/unqueue_me commentary is oddly placed and out of date.
Clean it up and correct the inaccurate bits.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053015.8717.71713.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 5df1f49..77cc68e 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1351,6 +1351,25 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
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
@@ -1374,19 +1393,17 @@ static inline void queue_me(struct futex_q *q, struct futex_hash_bucket *hb)
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
-- 
1.6.0.6

>From 176b6c836c722fdeb50ba33c24a009b77708209a Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:30 -0700
Subject: [PATCH] futex: Correct futex_q woken state commentary

Use kernel-doc format to describe struct futex_q.

Correct the wakeup definition to eliminate the statement about
waking the waiter between the plist_del() and the q->lock_ptr = 0.

Note in the comment that PI futexes have a different definition of
the woken state.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922053029.8717.62798.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 77cc68e..3e0455a 100644
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
 
-- 
1.6.0.6

>From 0694a339cdbd4bb41a1699d6aa9d1671baae1edc Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Mon, 21 Sep 2009 22:29:59 -0700
Subject: [PATCH] futex: Correct futex_wait_requeue_pi() commentary

Correct various typos and formatting inconsistencies in the
commentary of futex_wait_requeue_pi().

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <20090922052958.8717.21932.stgit@Aeon>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/futex.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 3e0455a..fb2386c 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2136,12 +2136,12 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
 
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
@@ -2269,7 +2269,7 @@ retry:
 		res = fixup_owner(uaddr2, fshared, &q, !ret);
 		/*
 		 * If fixup_owner() returned an error, proprogate that.  If it
-		 * acquired the lock, clear our -ETIMEDOUT or -EINTR.
+		 * acquired the lock, clear -ETIMEDOUT or -EINTR.
 		 */
 		if (res)
 			ret = (res < 0) ? res : 0;
-- 
1.6.0.6

