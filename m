Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYAHSsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYAHSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYAHSsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:48:37 -0500
Received: from www.tglx.de ([62.245.132.106]:42633 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYAHSsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:48:36 -0500
Date: Tue, 8 Jan 2008 19:47:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland Westrelin <roland.westrelin@sun.com>
Subject: [PATCH] futex: Prevent stale futex owner when interrupted/timeout
Message-ID: <alpine.LFD.0.99999.0801081739000.31637@localhost.localdomain>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Westrelin did a great analysis of a long standing thinko in the
return path of futex_lock_pi.

While we fixed the lock steal case long ago, which was easy to trigger,
we never had a test case which exposed this problem and stupidly never
thought about the reverse lock stealing scenario and the return to user
space with a stale state.

When a blocked tasks returns from rt_mutex_timed_locked without holding
the rt_mutex (due to a signal or timeout) and at the same time the task
holding the futex is releasing the futex and assigning the ownership of
the futex to the returning task, then it might happen that a third task
acquires the rt_mutex before the final rt_mutex_trylock() of the
returning task happens under the futex hash bucket lock. The returning
task returns to user space with ETIMEOUT or EINTR, but the user space
futex value is assigned to this task. The task which acquired the
rt_mutex fixes the user space futex value right after the hash bucket
lock has been released by the returning task, but for a short period of
time the user space value is wrong.

Detailed description is available at:

   https://bugzilla.redhat.com/show_bug.cgi?id=400541

The fix for this is the same as we do when the rt_mutex was acquired by
a higher priority task via lock stealing from the designated new owner.
In that case we already fix the user space value and the internal
pi_state up before we return. This mechanism can be used to fixup the
above corner case as well. When the returning task, which failed to
acquire the rt_mutex, notices that it is the designated owner of the
futex, then it fixes up the stale user space value and the pi_state,
before returning to user space. This happens with the futex hash bucket
lock held, so the task which acquired the rt_mutex is guaranteed to be
blocked on the hash bucket lock. We can access the rt_mutex owner, which
gives us the pid of the new owner, safely here as the owner is not able
to modify (release) it while waiting on the hash bucket lock.

Rename the "curr" argument of fixup_pi_state_owner() to "newowner" to
avoid confusion with current and add the check for the stale state into
the failure path of rt_mutex_trylock() in the return path of
unlock_futex_pi(). If the situation is detected use
fixup_pi_state_owner() to assign everything to the owner of the
rt_mutex.

Pointed-out-by: Roland Westrelin <roland.westrelin@sun.com>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Roland Westrelin <roland.westrelin@sun.com>

diff --git a/kernel/futex.c b/kernel/futex.c
index 172a1ae..db9824d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1097,15 +1097,15 @@ static void unqueue_me_pi(struct futex_q *q)
 }
 
 /*
- * Fixup the pi_state owner with current.
+ * Fixup the pi_state owner with the new owner.
  *
  * Must be called with hash bucket lock held and mm->sem held for non
  * private futexes.
  */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *curr)
+				struct task_struct *newowner)
 {
-	u32 newtid = task_pid_vnr(curr) | FUTEX_WAITERS;
+	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
 	u32 uval, curval, newval;
 	int ret;
@@ -1119,12 +1119,12 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	} else
 		newtid |= FUTEX_OWNER_DIED;
 
-	pi_state->owner = curr;
+	pi_state->owner = newowner;
 
-	spin_lock_irq(&curr->pi_lock);
+	spin_lock_irq(&newowner->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &curr->pi_state_list);
-	spin_unlock_irq(&curr->pi_lock);
+	list_add(&pi_state->list, &newowner->pi_state_list);
+	spin_unlock_irq(&newowner->pi_lock);
 
 	/*
 	 * We own it, so we have to replace the pending owner
@@ -1508,9 +1508,40 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 		 * when we were on the way back before we locked the
 		 * hash bucket.
 		 */
-		if (q.pi_state->owner == curr &&
-		    rt_mutex_trylock(&q.pi_state->pi_mutex)) {
-			ret = 0;
+		if (q.pi_state->owner == curr) {
+			/*
+			 * Try to get the rt_mutex now. This might
+			 * fail as some other task acquired the
+			 * rt_mutex after we removed ourself from the
+			 * rt_mutex waiters list.
+			 */
+			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
+				ret = 0;
+			else {
+				/*
+				 * pi_state is incorrect, some other
+				 * task did a lock steal and we
+				 * returned due to timeout or signal
+				 * without taking the rt_mutex. Too
+				 * late. We can access the
+				 * rt_mutex_owner without locking, as
+				 * the other task is now blocked on
+				 * the hash bucket lock. Fix the state
+				 * up.
+				 */
+				struct task_struct *owner;
+				int res;
+
+				owner = rt_mutex_owner(&q.pi_state->pi_mutex);
+				res = fixup_pi_state_owner(uaddr, &q, owner);
+
+				WARN_ON(rt_mutex_owner(&q.pi_state->pi_mutex) !=
+					owner);
+
+				/* propagate -EFAULT, if the fixup failed */
+				if (res)
+					ret = res;
+			}
 		} else {
 			/*
 			 * Paranoia check. If we did not take the lock
