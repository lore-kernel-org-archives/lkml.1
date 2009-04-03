Return-Path: <linux-kernel-owner+w=401wt.eu-S937040AbZDCUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937040AbZDCUlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936913AbZDCUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:40:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34110 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936907AbZDCUkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:40:10 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 4/9] RFC: futex: fixup_owner()
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
Date: Fri, 03 Apr 2009 13:40:02 -0700
Message-ID: <20090403204001.9772.15397.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the post lock acquisition logic from futex_lock_pi().  This code will
be reused in futex_wait_requeue_pi().

Changelog:
V7: -Rename finish_futex_lock_pi() to fixup_owner() (per Dinakar G.)
V6: -Minor comment updates
V4: -Corrected string paranoia check
    -Move the spinlock(q->lock_ptr) out of finish_futex_lock_pi to retain
     some semblance of lock/unlock in the same function.
V3: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
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

 kernel/futex.c |  158 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 89 insertions(+), 69 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 36b5367..c2b58d8 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1256,6 +1256,79 @@ handle_fault:
 static long futex_wait_restart(struct restart_block *restart);
 
 /**
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
+{
+	struct task_struct *owner;
+	int ret = 0;
+
+	if (locked) {
+		/*
+		 * Got the lock. We might not be the anticipated owner if we
+		 * did a lock-steal - fix up the PI-state in that case:
+		 */
+		if (q->pi_state->owner != current)
+			ret = fixup_pi_state_owner(uaddr, q, current, fshared);
+		goto out;
+	}
+
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
+		goto out;
+	}
+
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
  * futex_wait_queue_me() - queue_me() and wait for wakeup, timeout, or signal
  * @hb:		the futex hash bucket, must be locked by the caller
  * @q:		the futex_q to queue up on
@@ -1459,11 +1532,10 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
-	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
 	u32 uval;
 	struct futex_q q;
-	int ret;
+	int res, ret;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1527,71 +1599,21 @@ retry_private:
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
@@ -1599,9 +1621,7 @@ retry_private:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+	goto out;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
@@ -1611,7 +1631,7 @@ out_put_key:
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
 	/*

