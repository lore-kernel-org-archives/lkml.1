Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYLSVj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYLSVj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYLSVi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:38:56 -0500
Received: from www.tglx.de ([62.245.132.106]:55782 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbYLSViy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:38:54 -0500
Message-Id: <20081219211948.043710919@linutronix.de>
References: <20081219211656.875192771@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 21:23:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: [patch 5/7] rtmutex: remove uber optimization
Content-Disposition: inline; filename=rtmutex-remove-uber-optimization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The adaptive spin patches introduced an overdesigned optimization for
the adaptive path. This avoidance of those code pathes is not worth
the extra conditionals and furthermore it is inconsistent in itself.

Remove it and use the same mechanism as the other lock pathes. That
way we have a consistent state manipulation scheme and less extra
cases.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rtmutex.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

Index: linux-2.6.24/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.orig/kernel/rtmutex.c
+++ linux-2.6.24/kernel/rtmutex.c
@@ -839,7 +839,6 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 	struct rt_mutex_waiter waiter;
 	unsigned long saved_state, flags;
 	struct task_struct *orig_owner;
-	int missed = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -861,20 +860,15 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 	 * about original state TASK_INTERRUPTIBLE as well, as we
 	 * could miss a wakeup_interruptible()
 	 */
-	saved_state = current->state;
+	saved_state = rt_set_current_blocked_state(current->state);
 
 	for (;;) {
 		unsigned long saved_flags;
 		int saved_lock_depth = current->lock_depth;
 
 		/* Try to acquire the lock */
-		if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
-			/* If we never blocked break out now */
-			if (!missed)
-				goto unlock;
+		if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL))
 			break;
-		}
-		missed = 1;
 
 		/*
 		 * waiter.task is NULL the first time we come here and
@@ -904,12 +898,6 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 		if (adaptive_wait(&waiter, orig_owner)) {
 			put_task_struct(orig_owner);
 
-			saved_state = rt_set_current_blocked_state(saved_state);
-			/*
-			 * The xchg() in update_current() is an implicit
-			 * barrier which we rely upon to ensure current->state
-			 * is visible before we test waiter.task.
-			 */
 			if (waiter.task)
 				schedule_rt_mutex(lock);
 		} else
@@ -918,6 +906,7 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 		spin_lock_irqsave(&lock->wait_lock, flags);
 		current->flags |= saved_flags;
 		current->lock_depth = saved_lock_depth;
+		saved_state = rt_set_current_blocked_state(saved_state);
 	}
 
 	rt_restore_current_state(saved_state);
@@ -936,7 +925,6 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 	 */
 	fixup_rt_mutex_waiters(lock);
 
- unlock:
 	spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	debug_rt_mutex_free_waiter(&waiter);

-- 

