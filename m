Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbZCCAPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbZCCAPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZCCAPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:15:05 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42722 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZCCAPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:15:04 -0500
Message-ID: <49AC7683.3080503@us.ibm.com>
Date: Mon, 02 Mar 2009 16:14:59 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 4/7] futex: finish_futex_lock_pi()
References: <49AC73A9.4040804@us.ibm.com>
In-Reply-To: <49AC73A9.4040804@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

Refactor the post lock acquisition logic from futex_lock_pi().  This code will
be reused in futex_wait_requeue_pi().

V4: -Corrected string paranoia check
    -Move the spinlock(q->lock_ptr) out of finish_futex_lock_pi to retain
     some semblance of lock/unlock in the same function.
V3: -Initial version

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/futex.c |  146 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 78 insertions(+), 68 deletions(-)


diff --git a/kernel/futex.c b/kernel/futex.c
index c4984d4..9446494 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1303,6 +1303,81 @@ handle_fault:
 
 static long futex_wait_restart(struct restart_block *restart);
 
+/* finish_futex_lock_pi - post lock pi_state and corner case management
+ * @uaddr: the user address of the futex
+ * @fshared: whether the futex is shared (1) or not (0)
+ * @q: the futex_q (containes pi_state and access to the rt_mutex)
+ * @ret: the return value of the preceeding attempt to take the rt_mutex
+ *
+ * After attempting to take an rtmutex, process the return code and cleanup
+ * the pi_state as well as handle race conditions that may have caused us to
+ * lose the lock. Must be called with the hb lock held.
+ *
+ * Returns 0 on success, negative error code otherwise.
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
+		/* dvhart FIXME: can't we just BUG_ON in this case?
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
+	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+}
+
 /*
  * futex_wait_queue_me - queue_me and wait for wakeup, timeout, or signal.
  * @hb: the futex hash bucket, must be locked by the caller
@@ -1505,7 +1580,6 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
-	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
 	u32 uval;
 	struct futex_q q;
@@ -1572,74 +1646,12 @@ retry_unlocked:
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
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+	goto out;
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
@@ -1672,9 +1684,7 @@ uaddr_faulted:
 	if (!ret)
 		goto retry;
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	goto out;
 }
 
 /*

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
