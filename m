Return-Path: <linux-kernel-owner+w=401wt.eu-S937003AbZDCUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937003AbZDCUlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936883AbZDCUkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:40:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46477 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936899AbZDCUkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:40:01 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 3/9] RFC: futex: futex_lock_pi_atomic()
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Fri, 03 Apr 2009 13:39:52 -0700
Message-ID: <20090403203952.9772.37159.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the atomic portion of futex_lock_pi() into futex_lock_pi_atomic().
This logic will be needed elsewhere, so modularize it to reduce code
duplication.  The only significant change is passing of the task to try and
take the lock for.  This simplifies the -EDEADLK test as if the lock is owned
by task t, it's a deadlock, regardless of if we are doing requeue pi or not.
This patch updates the corresponding comment accordingly.

Changelog:
V7: -coding style updates from tglx
V6: -comment update from peterz
V4: -fixes for style errors caught by checkpatch.pl
    -use task instead of t for legibility whilst searching
    -pass key and pi_state directly rather than trying to rely on the futex_q
     since the key may be different.
    -minor cleanups suggested by tglx
V2: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Reviewed-by: Steven Rostedt <srostedt@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
---

 kernel/futex.c |  224 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 130 insertions(+), 94 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a13369d..36b5367 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -556,6 +556,127 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	return 0;
 }
 
+/**
+ * futex_lock_pi_atomic() - atomic work required to acquire a pi aware futex
+ * @uaddr:	the pi futex user address
+ * @hb:		the pi futex hash bucket
+ * @key:	the futex key associated with uaddr and hb
+ * @ps:		the pi_state pointer where we store the result of the lookup
+ * @task:	the task to perform the atomic lock work for.  This will be
+ * 		"current" except in the case of requeue pi.
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
+				struct task_struct *task)
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
@@ -1340,9 +1461,9 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
-	u32 uval, newval, curval;
+	u32 uval;
 	struct futex_q q;
-	int ret, lock_taken, ownerdied = 0;
+	int ret;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1365,81 +1486,15 @@ retry:
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
+	ret = futex_lock_pi_atomic(uaddr, hb, &q.key, &q.pi_state, current);
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
@@ -1449,25 +1504,6 @@ retry_locked:
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

