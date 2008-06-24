Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYFXXVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYFXXVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbYFXXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:21:39 -0400
Received: from homer.mvista.com ([63.81.120.158]:37986 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751068AbYFXXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:21:38 -0400
Message-Id: <20080624232020.376703616@mvista.com>
References: <20080624232018.817822790@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 16:20:23 -0700
Subject: [PATCH 5/6] -rt: nested rtmutex blocked_on
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Disposition: inline; filename=rtmutex-fix-realtime-blocked-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the rare rare case that you might be inside another blocked_on user section
and locking an rt-mutex. This can't happen in mainline, but can happen in -rt .

Allows nesting of the blocked on structures only for the rtmutex.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/sched.h |    1 
 kernel/mutex.c        |    4 +--
 kernel/rtmutex.c      |   66 +++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 58 insertions(+), 13 deletions(-)

Index: linux-2.6.25/include/linux/sched.h
===================================================================
--- linux-2.6.25.orig/include/linux/sched.h
+++ linux-2.6.25/include/linux/sched.h
@@ -1034,6 +1034,7 @@ struct lock_waiter_state {
 		struct mutex_waiter *mutex_blocked_on;
 		struct rt_mutex_waiter *rt_blocked_on;
 	};
+	struct lock_waiter_state *next;
 };
 
 struct task_struct {
Index: linux-2.6.25/kernel/mutex.c
===================================================================
--- linux-2.6.25.orig/kernel/mutex.c
+++ linux-2.6.25/kernel/mutex.c
@@ -131,8 +131,8 @@ __mutex_lock_common(struct mutex *lock, 
 	unsigned int old_val;
 	unsigned long flags;
 #ifdef CONFIG_DEBUG_MUTEXES
-	struct lock_waiter_state lock_waiter = {
-		.lock_type = MUTEX_WAITER, { .mutex_blocked_on = &waiter} };
+	struct lock_waiter_state lock_waiter = { .lock_type = MUTEX_WAITER,
+		{ .mutex_blocked_on = &waiter}, .next = NULL };
 #endif
 
 	spin_lock_mutex(&lock->wait_lock, flags);
Index: linux-2.6.25/kernel/rtmutex.c
===================================================================
--- linux-2.6.25.orig/kernel/rtmutex.c
+++ linux-2.6.25/kernel/rtmutex.c
@@ -79,9 +79,44 @@ struct rt_mutex_waiter *rt_mutex_get_wai
 {
 	if (task->blocked_on && task->blocked_on->lock_type == RT_MUTEX_WAITER)
 		return task->blocked_on->rt_blocked_on;
+	else if (unlikely(task->blocked_on && task->blocked_on->next))
+		return task->blocked_on->next->rt_blocked_on;
 	return NULL;
 }
 
+#ifdef CONFIG_PREEMPT_RT
+static inline
+void rt_mutex_set_blocked_on(struct task_struct *task,
+			     struct lock_waiter_state *waiter)
+{
+	if (task->blocked_on)
+		task->blocked_on->next = waiter;
+	else
+		task->blocked_on = waiter;
+}
+
+static inline
+void rt_mutex_clear_blocked_on(struct task_struct *task)
+{
+	if (unlikely(task->blocked_on->next))
+		task->blocked_on->next = NULL;
+	else
+		task->blocked_on = NULL;
+}
+#else
+static inline
+void rt_mutex_set_blocked_on(struct task_struct *task,
+			     struct lock_waiter_state *waiter)
+{
+	task->blocked_on = waiter;
+}
+static inline
+void rt_mutex_clear_blocked_on(struct task_struct *task)
+{
+	task->blocked_on = NULL;
+}
+#endif
+
 /*
  * We can speed up the acquire/release, if the architecture
  * supports cmpxchg and if there's no debugging state to be set up
@@ -438,9 +473,7 @@ static int task_blocks_on_rt_mutex(struc
 	if (rt_mutex_has_waiters(lock))
 		top_waiter = rt_mutex_top_waiter(lock);
 	plist_add(&waiter->list_entry, &lock->wait_list);
-
-	current->blocked_on = lock_waiter;
-
+	rt_mutex_set_blocked_on(current, lock_waiter);
 	spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
@@ -519,11 +552,22 @@ static void wakeup_next_waiter(struct rt
 	spin_lock_irqsave(&pendowner->pi_lock, flags);
 
 	WARN_ON(!pendowner->blocked_on);
-	WARN_ON(pendowner->blocked_on->lock_type != RT_MUTEX_WAITER);
-	WARN_ON(pendowner->blocked_on->rt_blocked_on != waiter);
-	WARN_ON(pendowner->blocked_on->rt_blocked_on->lock != lock);
-
-	pendowner->blocked_on = NULL;
+#ifdef CONFIG_PREEMPT_RT
+	if (unlikely(pendowner->blocked_on->next)) {
+		struct lock_waiter_state *blocked_on = pendowner->blocked_on;
+
+		WARN_ON(blocked_on->lock_type != RT_MUTEX_WAITER);
+		WARN_ON(blocked_on->next->rt_blocked_on != waiter);
+		WARN_ON(blocked_on->next->rt_blocked_on->lock != lock);
+		pendowner->blocked_on->next = NULL;
+	} else
+#endif
+	{
+		WARN_ON(pendowner->blocked_on->lock_type != RT_MUTEX_WAITER);
+		WARN_ON(pendowner->blocked_on->rt_blocked_on != waiter);
+		WARN_ON(pendowner->blocked_on->rt_blocked_on->lock != lock);
+		pendowner->blocked_on = NULL;
+	}
 
 	if (rt_mutex_has_waiters(lock)) {
 		struct rt_mutex_waiter *next;
@@ -552,7 +596,7 @@ static void remove_waiter(struct rt_mute
 	spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
 	waiter->task = NULL;
-	current->blocked_on = NULL;
+	rt_mutex_clear_blocked_on(current);
 	spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	if (first && owner != current) {
@@ -624,8 +668,8 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 		  int detect_deadlock)
 {
 	struct rt_mutex_waiter waiter;
-	struct lock_waiter_state lock_waiter = {
-		.lock_type = RT_MUTEX_WAITER, { .rt_blocked_on = &waiter} };
+	struct lock_waiter_state lock_waiter = { .lock_type = RT_MUTEX_WAITER,
+		{ .rt_blocked_on = &waiter}, .next = NULL };
 	int ret = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);

-- 
