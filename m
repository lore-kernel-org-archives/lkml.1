Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbYEWEh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbYEWEh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYEWEhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:37:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38055 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751045AbYEWEgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:36:43 -0400
Message-Id: <20080523042923.792403846@mvista.com>
References: <20080523042923.594531457@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:00:02 -0700
Subject: [PATCH 2/3] rtmutex: add generic blocked_on usage
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline; filename=blocked_on-rtmutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the rtmutex to use the generic blocked_on field.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/sched.h |    2 --
 kernel/fork.c         |    1 -
 kernel/rtmutex.c      |   35 ++++++++++++++++++++++++-----------
 3 files changed, 24 insertions(+), 14 deletions(-)

Index: linux-2.6.25/include/linux/sched.h
===================================================================
--- linux-2.6.25.orig/include/linux/sched.h
+++ linux-2.6.25/include/linux/sched.h
@@ -1222,8 +1222,6 @@ struct task_struct {
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
 	struct plist_head pi_waiters;
-	/* Deadlock detection and priority inheritance handling */
-	struct rt_mutex_waiter *pi_blocked_on;
 #endif
 
 	/*
Index: linux-2.6.25/kernel/fork.c
===================================================================
--- linux-2.6.25.orig/kernel/fork.c
+++ linux-2.6.25/kernel/fork.c
@@ -980,7 +980,6 @@ static void rt_mutex_init_task(struct ta
 	spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init(&p->pi_waiters, &p->pi_lock);
-	p->pi_blocked_on = NULL;
 #endif
 }
 
Index: linux-2.6.25/kernel/rtmutex.c
===================================================================
--- linux-2.6.25.orig/kernel/rtmutex.c
+++ linux-2.6.25/kernel/rtmutex.c
@@ -74,6 +74,14 @@ static void fixup_rt_mutex_waiters(struc
 		clear_rt_mutex_waiters(lock);
 }
 
+static
+struct rt_mutex_waiter *rt_mutex_get_waiter(struct task_struct *task)
+{
+	if (task->blocked_on && task->blocked_on->lock_type == RT_MUTEX_WAITER)
+		return task->blocked_on->rt_blocked_on;
+	return NULL;
+}
+
 /*
  * We can speed up the acquire/release, if the architecture
  * supports cmpxchg and if there's no debugging state to be set up
@@ -197,7 +205,7 @@ static int rt_mutex_adjust_prio_chain(st
 	 */
 	spin_lock_irqsave(&task->pi_lock, flags);
 
-	waiter = task->pi_blocked_on;
+	waiter = rt_mutex_get_waiter(task);
 	/*
 	 * Check whether the end of the boosting chain has been
 	 * reached or the state of the chain has changed while we
@@ -411,6 +419,7 @@ static int try_to_take_rt_mutex(struct r
  */
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
+				   struct lock_waiter_state *lock_waiter,
 				   int detect_deadlock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
@@ -430,7 +439,7 @@ static int task_blocks_on_rt_mutex(struc
 		top_waiter = rt_mutex_top_waiter(lock);
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
-	current->pi_blocked_on = waiter;
+	current->blocked_on = lock_waiter;
 
 	spin_unlock_irqrestore(&current->pi_lock, flags);
 
@@ -440,7 +449,7 @@ static int task_blocks_on_rt_mutex(struc
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
-		if (owner->pi_blocked_on)
+		if (rt_mutex_get_waiter(owner))
 			chain_walk = 1;
 		spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
@@ -501,7 +510,7 @@ static void wakeup_next_waiter(struct rt
 	spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	/*
-	 * Clear the pi_blocked_on variable and enqueue a possible
+	 * Clear the blocked_on variable and enqueue a possible
 	 * waiter into the pi_waiters list of the pending owner. This
 	 * prevents that in case the pending owner gets unboosted a
 	 * waiter with higher priority than pending-owner->normal_prio
@@ -509,11 +518,12 @@ static void wakeup_next_waiter(struct rt
 	 */
 	spin_lock_irqsave(&pendowner->pi_lock, flags);
 
-	WARN_ON(!pendowner->pi_blocked_on);
-	WARN_ON(pendowner->pi_blocked_on != waiter);
-	WARN_ON(pendowner->pi_blocked_on->lock != lock);
+	WARN_ON(!pendowner->blocked_on);
+	WARN_ON(pendowner->blocked_on->lock_type != RT_MUTEX_WAITER);
+	WARN_ON(pendowner->blocked_on->rt_blocked_on != waiter);
+	WARN_ON(pendowner->blocked_on->rt_blocked_on->lock != lock);
 
-	pendowner->pi_blocked_on = NULL;
+	pendowner->blocked_on = NULL;
 
 	if (rt_mutex_has_waiters(lock)) {
 		struct rt_mutex_waiter *next;
@@ -542,7 +552,7 @@ static void remove_waiter(struct rt_mute
 	spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
 	waiter->task = NULL;
-	current->pi_blocked_on = NULL;
+	current->blocked_on = NULL;
 	spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	if (first && owner != current) {
@@ -559,7 +569,7 @@ static void remove_waiter(struct rt_mute
 		}
 		__rt_mutex_adjust_prio(owner);
 
-		if (owner->pi_blocked_on)
+		if (rt_mutex_get_waiter(owner))
 			chain_walk = 1;
 
 		spin_unlock_irqrestore(&owner->pi_lock, flags);
@@ -592,7 +602,7 @@ void rt_mutex_adjust_pi(struct task_stru
 
 	spin_lock_irqsave(&task->pi_lock, flags);
 
-	waiter = task->pi_blocked_on;
+	waiter = rt_mutex_get_waiter(task);
 	if (!waiter || waiter->list_entry.prio == task->prio) {
 		spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
@@ -614,6 +624,8 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 		  int detect_deadlock)
 {
 	struct rt_mutex_waiter waiter;
+	struct lock_waiter_state lock_waiter =
+		{ .lock_type = RT_MUTEX_WAITER, { .rt_blocked_on = &waiter} };
 	int ret = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);
@@ -663,6 +675,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 		 */
 		if (!waiter.task) {
 			ret = task_blocks_on_rt_mutex(lock, &waiter,
+						      &lock_waiter,
 						      detect_deadlock);
 			/*
 			 * If we got woken up by the owner then start loop

-- 
