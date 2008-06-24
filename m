Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbYFXXWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbYFXXWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYFXXVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:21:41 -0400
Received: from homer.mvista.com ([63.81.120.158]:37998 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752962AbYFXXVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:21:40 -0400
Message-Id: <20080624232020.505470899@mvista.com>
References: <20080624232018.817822790@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 16:20:24 -0700
Subject: [PATCH 6/6] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Disposition: inline; filename=blocked_on-futex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds an additional function call to the sched_setscheduler to update the
waiter position of a task if it happens to be waiting on a futex. This
ensures that the kernel level waiter ordering is correctly maintained
based on the changed priority of the task.

I fixed the locking issue noticed by Thomas Gleixner.

This doesn't address userspace at all, only the kernel level wakeups and
kernel level ordering.

The additional locking added to the futex_wait function has no visible speed
impact, and only effects waiters which actual enter the kernel.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/sched.h |   10 ++++++++--
 kernel/fork.c         |    3 ++-
 kernel/futex.c        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c        |    1 +
 4 files changed, 56 insertions(+), 3 deletions(-)

Index: linux-2.6.25/include/linux/sched.h
===================================================================
--- linux-2.6.25.orig/include/linux/sched.h
+++ linux-2.6.25/include/linux/sched.h
@@ -1026,6 +1026,7 @@ struct sched_rt_entity {
 enum lock_waiter_type {
 	MUTEX_WAITER = 1,
 	RT_MUTEX_WAITER,
+	FUTEX_WAITER
 };
 
 struct lock_waiter_state {
@@ -1033,6 +1034,7 @@ struct lock_waiter_state {
 	union {
 		struct mutex_waiter *mutex_blocked_on;
 		struct rt_mutex_waiter *rt_blocked_on;
+		union futex_key	*futex_blocked_on;
 	};
 	struct lock_waiter_state *next;
 };
@@ -1222,7 +1224,8 @@ struct task_struct {
 	struct plist_head pi_waiters;
 #endif
 
-#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_RT_MUTEXES)
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_RT_MUTEXES) \
+	|| defined(CONFIG_FUTEX)
 	/*
 	 * Deadlock detection and priority inheritance handling,
 	 * and any other out of line mutex operations
@@ -1321,7 +1324,8 @@ struct task_struct {
 #endif
 };
 
-#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_RT_MUTEXES)
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_RT_MUTEXES) \
+	|| defined(CONFIG_FUTEX)
 /*
  * set_blocked_on - Set the blocked on field in the task struct.
  */
@@ -1680,6 +1684,8 @@ static inline int rt_mutex_getprio(struc
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 #endif
 
+extern void futex_adjust_waiters(struct task_struct *p);
+
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
Index: linux-2.6.25/kernel/fork.c
===================================================================
--- linux-2.6.25.orig/kernel/fork.c
+++ linux-2.6.25/kernel/fork.c
@@ -1027,7 +1027,8 @@ static struct task_struct *copy_process(
 	p->lockdep_recursion = 0;
 #endif
 
-#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_RT_MUTEXES)
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_RT_MUTEXES) \
+	|| defined(CONFIG_FUTEX)
 	p->blocked_on = NULL; /* not blocked yet */
 #endif
 
Index: linux-2.6.25/kernel/futex.c
===================================================================
--- linux-2.6.25.orig/kernel/futex.c
+++ linux-2.6.25/kernel/futex.c
@@ -328,6 +328,42 @@ static int get_futex_value_locked(u32 *d
 }
 
 /*
+ * Used to update a waiters priority in the plist structure.
+ */
+void futex_adjust_waiters(struct task_struct *p)
+{
+	struct futex_hash_bucket *hb;
+	struct futex_q *q, *next;
+	union futex_key key;
+
+	if (!p->blocked_on)
+		return;
+
+	spin_lock_irq(&p->pi_lock);
+	if (p->blocked_on && p->blocked_on->lock_type == FUTEX_WAITER) {
+		key = *p->blocked_on->futex_blocked_on;
+		spin_unlock_irq(&p->pi_lock);
+	} else {
+		spin_unlock_irq(&p->pi_lock);
+		return;
+	}
+
+	hb = hash_futex(&key);
+	spin_lock(&hb->lock);
+	plist_for_each_entry_safe(q, next, &hb->chain, list) {
+		if (match_futex(&q->key, &key) && q->task == p) {
+			int prio = min(p->normal_prio, MAX_RT_PRIO);
+
+			plist_del(&q->list, &hb->chain);
+			plist_node_init(&q->list, prio);
+			plist_add(&q->list, &hb->chain);
+			break;
+		}
+	}
+	spin_unlock(&hb->lock);
+}
+
+/*
  * Fault handling.
  * if fshared is non NULL, current->mm->mmap_sem is already held
  */
@@ -1160,6 +1196,8 @@ static int futex_wait(u32 __user *uaddr,
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
+	struct lock_waiter_state blocked_on = { .lock_type = FUTEX_WAITER,
+		{ .futex_blocked_on = &q.key }, .next = NULL};
 	u32 uval;
 	int ret;
 	struct hrtimer_sleeper t;
@@ -1177,6 +1215,8 @@ static int futex_wait(u32 __user *uaddr,
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
+	set_blocked_on(current, &blocked_on);
+
 	hb = queue_lock(&q);
 
 	/*
@@ -1204,6 +1244,8 @@ static int futex_wait(u32 __user *uaddr,
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
 
+		set_blocked_on(current, NULL);
+
 		/*
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
@@ -1277,6 +1319,8 @@ static int futex_wait(u32 __user *uaddr,
 	}
 	__set_current_state(TASK_RUNNING);
 
+	set_blocked_on(current, NULL);
+
 	/*
 	 * NOTE: we don't remove ourselves from the waitqueue because
 	 * we are the only user of it.
@@ -1311,6 +1355,7 @@ static int futex_wait(u32 __user *uaddr,
 
  out_unlock_release_sem:
 	queue_unlock(&q, hb);
+	set_blocked_on(current, NULL);
 
  out_release_sem:
 	futex_unlock_mm(fshared);
Index: linux-2.6.25/kernel/sched.c
===================================================================
--- linux-2.6.25.orig/kernel/sched.c
+++ linux-2.6.25/kernel/sched.c
@@ -4869,6 +4869,7 @@ recheck:
 	spin_unlock_irqrestore(&p->pi_lock, flags);
 
 	rt_mutex_adjust_pi(p);
+	futex_adjust_waiters(p);
 
 	return 0;
 }

-- 
