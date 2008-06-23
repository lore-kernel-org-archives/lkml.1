Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYFWKWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYFWKWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbYFWKV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:21:56 -0400
Received: from www.tglx.de ([62.245.132.106]:53017 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbYFWKVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:21:55 -0400
Message-Id: <20080623092216.380067035@linutronix.de>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jun 2008 10:19:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Holmes <david.holmes@sun.com>,
       Peter Zijlstra <peterz@infradead.org>, stable@kernel.org
Subject: [patch] futex: fix fault handling in futex_lock_pi
Content-Disposition: inline; filename=futex-fix-fault-damage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current futex_lock_pi() code drops out with an inconsistent
internal state in case it faults when trying to fixup the user space
futex variable in the user space return path. User space has no way to
fixup that state.

This can happen when a fork mapped the anon memory which contains the
futex readonly for COW or the page got swapped out.

When we wrote this code we thought that we could not drop the hash
bucket lock at this point to handle the fault.

After analysing the code again it turned out to be wrong because there
are only two tasks involved which might modify the pi_state and the
user space variable:

 - the task which acquired the rtmutex
 - the pending owner of the pi_state which did not get the rtmutex

Both tasks drop into the fixup_pi_state() function before returning to
user space. The first task which acquired the hash bucket lock faults
in the fixup of the user space variable, drops the spinlock and calls
futex_handle_fault() to fault in the page. Now the second task could
acquire the hash bucket lock and tries to fixup the user space
variable as well. It either faults as well or it succeeds because the
first task already faulted the page in.

One caveat is to avoid a double fixup. After returning from the fault
handling we reacquire the hash bucket lock and check whether the
pi_state owner has been modified already.

The problem was reported by David Holmes who provided a reproducer as
well.

Reported-by: David Holmes <david.holmes@sun.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Holmes <david.holmes@sun.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@kernel.org

---
 kernel/futex.c |   93 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 73 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1096,21 +1096,64 @@ static void unqueue_me_pi(struct futex_q
  * private futexes.
  */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *newowner)
+				struct task_struct *newowner,
+				struct rw_semaphore *fshared)
 {
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
+	struct task_struct *oldowner = pi_state->owner;
 	u32 uval, curval, newval;
-	int ret;
+	int ret, attempt = 0;
 
 	/* Owner died? */
+	if (!pi_state->owner)
+		newtid |= FUTEX_OWNER_DIED;
+
+	/*
+	 * We are here either because we stole the rtmutex from the
+	 * pending owner or we are the pending owner which failed to
+	 * get the rtmutex. We have to replace the pending owner TID
+	 * in the user space variable. This must be atomic as we have
+	 * to preserve the owner died bit here.
+	 *
+	 * Note: We write the user space value _before_ changing the
+	 * pi_state because we can fault here. Imagine swapped out
+	 * pages or a fork, which was running right before we acquired
+	 * mmap_sem, that marked all the anonymous memory readonly for
+	 * cow.
+	 *
+	 * Modifying pi_state _before_ the user space value would
+	 * leave the pi_state in an inconsistent state when we fault
+	 * here, because we need to drop the hash bucket lock to
+	 * handle the fault. This might be observed in the PID check
+	 * in lookup_pi_state.
+	 */
+retry:
+	if (get_futex_value_locked(&uval, uaddr))
+		goto handle_fault;
+
+	while (1) {
+		newval = (uval & FUTEX_OWNER_DIED) | newtid;
+
+		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
+
+		if (curval == -EFAULT)
+			goto handle_fault;
+		if (curval == uval)
+			break;
+		uval = curval;
+	}
+
+	/*
+	 * We fixed up user space. Now we need to fix the pi_state
+	 * itself.
+	 */
 	if (pi_state->owner != NULL) {
 		spin_lock_irq(&pi_state->owner->pi_lock);
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
 		spin_unlock_irq(&pi_state->owner->pi_lock);
-	} else
-		newtid |= FUTEX_OWNER_DIED;
+	}
 
 	pi_state->owner = newowner;
 
@@ -1118,26 +1161,35 @@ static int fixup_pi_state_owner(u32 __us
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &newowner->pi_state_list);
 	spin_unlock_irq(&newowner->pi_lock);
+	return 0;
 
 	/*
-	 * We own it, so we have to replace the pending owner
-	 * TID. This must be atomic as we have preserve the
-	 * owner died bit here.
+	 * To handle the page fault we need to drop the hash bucket
+	 * lock here. That gives the other task (either the pending
+	 * owner itself or the task which stole the rtmutex) the
+	 * chance to try the fixup of the pi_state. So once we are
+	 * back from handling the fault we need to check the pi_state
+	 * after reacquiring the hash bucket lock and before trying to
+	 * do another fixup. When the fixup has been done already we
+	 * simply return.
 	 */
-	ret = get_futex_value_locked(&uval, uaddr);
+handle_fault:
+	spin_unlock(q->lock_ptr);
 
-	while (!ret) {
-		newval = (uval & FUTEX_OWNER_DIED) | newtid;
+	ret = futex_handle_fault((unsigned long)uaddr, fshared, attempt++);
 
-		curval = cmpxchg_futex_value_locked(uaddr, uval, newval);
+	spin_lock(q->lock_ptr);
 
-		if (curval == -EFAULT)
-			ret = -EFAULT;
-		if (curval == uval)
-			break;
-		uval = curval;
-	}
-	return ret;
+	/*
+	 * Check if someone else fixed it for us:
+	 */
+	if (pi_state->owner != oldowner)
+		return 0;
+
+	if (ret)
+		return ret;
+
+	goto retry;
 }
 
 /*
@@ -1507,7 +1559,7 @@ static int futex_lock_pi(u32 __user *uad
 		 * that case:
 		 */
 		if (q.pi_state->owner != curr)
-			ret = fixup_pi_state_owner(uaddr, &q, curr);
+			ret = fixup_pi_state_owner(uaddr, &q, curr, fshared);
 	} else {
 		/*
 		 * Catch the rare case, where the lock was released
@@ -1539,7 +1591,8 @@ static int futex_lock_pi(u32 __user *uad
 				int res;
 
 				owner = rt_mutex_owner(&q.pi_state->pi_mutex);
-				res = fixup_pi_state_owner(uaddr, &q, owner);
+				res = fixup_pi_state_owner(uaddr, &q, owner,
+							   fshared);
 
 				/* propagate -EFAULT, if the fixup failed */
 				if (res)

-- 

