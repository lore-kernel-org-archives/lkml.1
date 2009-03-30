Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbZC3VjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbZC3VjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761696AbZC3ViO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:38:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39853 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761239AbZC3ViL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:38:11 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v6 4/8] RFC: futex: finish_futex_lock_pi()
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
Date: Mon, 30 Mar 2009 14:38:05 -0700
Message-ID: <20090330213805.606.35912.stgit@Aeon>
In-Reply-To: <20090330213306.606.9540.stgit@Aeon>
References: <20090330213306.606.9540.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the post lock acquisition logic from futex_lock_pi().  This code will
be reused in futex_wait_requeue_pi().

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

 kernel/futex.c |  147 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 81 insertions(+), 66 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 905b52a..dd05803 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1258,6 +1258,84 @@ handle_fault:
 static long futex_wait_restart(struct restart_block *restart);
 
 /**
+ * finish_futex_lock_pi() - Post lock pi_state and corner case management
+ * @uaddr:	user address of the futex
+ * @fshared:	whether the futex is shared (1) or not (0)
+ * @q:		futex_q (contains pi_state and access to the rt_mutex)
+ * @ret:	the return value of the preceeding attempt to lock the rt_mutex
+ *
+ * After attempting to lock an rt_mutex, process the return code and cleanup
+ * the pi_state as well as handle race conditions that may have caused us to
+ * lose the lock. Must be called with the hb lock held.
+ *
+ * Returns:
+ *  0 - on success
+ * <0 - on error
+ */
+static int finish_futex_lock_pi(u32 __user *uaddr, int fshared,
+				struct futex_q *q, int ret)
+{
+	if (!ret) {
+		/*
+		 * Got the lock. We might not be the anticipated owner
+		 * if we did a lock-steal - fix up the PI-state in
+		 * that case:
+		 */
+		if (q->pi_state->owner != current)
+			ret = fixup_pi_state_owner(uaddr, q, current, fshared);
+		return ret;
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
+		if (rt_mutex_trylock(&q->pi_state->pi_mutex))
+			ret = 0;
+		else {
+			/*
+			 * pi_state is incorrect, some other task did a lock
+			 * steal and we returned due to timeout or signal
+			 * without taking the rt_mutex. Too late. We can access
+			 * the rt_mutex_owner without locking, as the other
+			 * task is now blocked on the hash bucket lock. Fix the
+			 * state up.
+			 */
+			struct task_struct *owner;
+			int res;
+
+			owner = rt_mutex_owner(&q->pi_state->pi_mutex);
+			res = fixup_pi_state_owner(uaddr, q, owner,
+					fshared);
+
+			/* propagate -EFAULT, if the fixup failed */
+			if (res)
+				ret = res;
+		}
+	} else {
+		/*
+		 * Paranoia check. If we did not take the lock in the trylock
+		 * above, then we should not be the owner of the rtmutex,
+		 * neither the real nor the pending one:
+		 */
+		if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
+			printk(KERN_ERR "finish_futex_lock_pi: "
+					"ret = %d pi-mutex: %p "
+					"pi-state %p\n", ret,
+					q->pi_state->pi_mutex.owner,
+					q->pi_state->owner);
+	}
+
+	return ret;
+}
+
+/**
  * futex_wait_queue_me() - queue_me and wait for wakeup, timeout, or signal.
  * @hb:		the futex hash bucket, must be locked by the caller
  * @q:		the futex_q to queue up on
@@ -1461,7 +1539,6 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
-	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
 	u32 uval;
 	struct futex_q q;
@@ -1529,67 +1606,7 @@ retry_private:
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
+	ret = finish_futex_lock_pi(uaddr, fshared, &q, ret);
 
 	/*
 	 * If fixup_pi_state_owner() faulted and was unable to handle the
@@ -1601,9 +1618,7 @@ retry_private:
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+	goto out;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
@@ -1613,7 +1628,7 @@ out_put_key:
 out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
 	/*

