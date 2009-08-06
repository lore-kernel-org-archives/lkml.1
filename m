Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZHFABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZHFABT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZHFABT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:01:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52946 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZHFABS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:01:18 -0400
Message-ID: <4A7A1D48.7040309@us.ibm.com>
Date: Wed, 05 Aug 2009 17:01:12 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>, Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [RFC][PATCH] fixup pi_state in futex_requeue on lock steal
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOT FOR INCLUSION

Fixup the uval and pi_state owner in futex_requeue(requeue_pi=1) in the event
of a lock steal or owner died.  I had hoped to leave it up to the new owner to
fix up the userspace value since we can't really handle a fault here
gracefully.  This should be safe as the lock is contended and should force all
userspace attempts to lock or unlock into the kernel where they'll block on the
hb lock.  However, when I don't update the uaddr, I hit the WARN_ON(pid !=
pi_state->owner->pid) as expected, and the userspace testcase deadlocks.

I need to try and better understand what's happening to hang userspace.  In the
meantime I thought I'd share what I'm working with atm.  This is a complete HACK
and is ugly, non-modular, etc etc.  However, it currently works.  It would explode
in a most impressive fashion should we happen to fault.  So the remaining questions
are:

o Why does userspace deadlock if we leave the uval updating to the new owner
  waking up in futex_wait_requeue_pi()?

o If we have to handle a fault in futex_requeue(), how can we best cleanup the
  proxy lock acquisition and get things back into a sane state.  We faulted, so
  determinism is out the window anyway, we just need to recover gracefully.

Thoughts welcome.

Darren Hart

Index: 2.6.31-rc4-rt1/kernel/futex.c
===================================================================
--- 2.6.31-rc4-rt1.orig/kernel/futex.c	2009-08-05 13:27:11.000000000 -0700
+++ 2.6.31-rc4-rt1/kernel/futex.c	2009-08-05 16:19:08.000000000 -0700
@@ -1174,7 +1174,7 @@ static int futex_requeue(u32 __user *uad
 	struct plist_head *head1;
 	struct futex_q *this, *next;
 	struct task_struct *wake_list = &init_task;
-	u32 curval2;
+	u32 curval, curval2, newval;
 
 	if (requeue_pi) {
 		/*
@@ -1329,6 +1329,45 @@ retry_private:
 			if (ret == 1) {
 				/* We got the lock. */
 				requeue_pi_wake_futex(this, &key2, hb2);
+
+				while (1) {
+					newval = (curval2 & FUTEX_OWNER_DIED) |
+						 task_pid_vnr(this->task) |
+						 FUTEX_WAITERS;
+
+					curval = cmpxchg_futex_value_locked(uaddr2, curval2, newval);
+
+					if (curval == -EFAULT)
+						goto handle_fault;
+					if (curval == curval2)
+						break;
+					curval2 = curval;
+				}
+				/*
+				 * Fixup the pi_state owner to ensure pi
+				 * boosting happens in the event of a race
+				 * between us dropping the lock and the new
+				 * owner waking and grabbing the lock.  Since
+				 * the lock is contended, we leave it to the new
+				 * owner to fix up the userspace value since we
+				 * can't handle a fault here gracefully.
+				 */
+				/*
+				 * FIXME: we duplicate this in 3 places now.  If
+				 * we keep this solution, let's refactor this
+				 * pi_state reparenting thing.
+				 */
+				BUG_ON(!pi_state->owner);
+				atomic_spin_lock_irq(&pi_state->owner->pi_lock);
+				WARN_ON(list_empty(&pi_state->list));
+				list_del_init(&pi_state->list);
+				atomic_spin_unlock_irq(&pi_state->owner->pi_lock);
+
+				atomic_spin_lock_irq(&this->task->pi_lock);
+				WARN_ON(!list_empty(&pi_state->list));
+				list_add(&pi_state->list, &this->task->pi_state_list);
+				pi_state->owner = this->task;
+				atomic_spin_unlock_irq(&this->task->pi_lock);
 				continue;
 			} else if (ret) {
 				/* -EDEADLK */
@@ -1363,6 +1402,17 @@ out:
 	if (pi_state != NULL)
 		free_pi_state(pi_state);
 	return ret ? ret : task_count;
+
+handle_fault:
+	/*
+	 * We can't handle a fault, so instead, give up the lock and requeue the
+	 * would-have-been-new-owner instead.
+	 */
+	printk("ERROR: faulted during futex_requeue loop, trying to fixup pi_state owner\n");
+	/* FIXME: write the unlock and requeue code ... */
+	ret = -EFAULT;
+	goto out_unlock;
+
 }
 
 /* The key must be already stored in q->key. */
-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
