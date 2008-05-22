Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYEWEgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYEWEgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYEWEgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:36:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38057 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750982AbYEWEgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:36:43 -0400
Message-Id: <20080523042923.916202203@mvista.com>
References: <20080523042923.594531457@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 22 May 2008 00:00:03 -0700
Subject: [PATCH 3/3] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline; filename=blocked_on-futex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the plist was added to futexes it added overhead to sort based
on priority for the futex waiters. If there is a miss order the value of
this, from my perspective, is lost. Since we don't re-order tasks
when their priority is changed after they sleep then we get a miss ordered
scenerio, and tasks aren't woken in priority order.

This patch corrects this issue, so the tasks are always woken in priority
order.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/sched.h |    2 ++
 kernel/futex.c        |   45 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c        |    1 +
 3 files changed, 48 insertions(+)

Index: linux-2.6.25/include/linux/sched.h
===================================================================
--- linux-2.6.25.orig/include/linux/sched.h
+++ linux-2.6.25/include/linux/sched.h
@@ -1664,6 +1664,8 @@ static inline int rt_mutex_getprio(struc
 # define rt_mutex_adjust_pi(p)		do { } while (0)
 #endif
 
+extern void futex_adjust_waiters(struct task_struct *p);
+
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 extern int task_nice(const struct task_struct *p);
Index: linux-2.6.25/kernel/futex.c
===================================================================
--- linux-2.6.25.orig/kernel/futex.c
+++ linux-2.6.25/kernel/futex.c
@@ -326,6 +326,42 @@ static int get_futex_value_locked(u32 *d
 	return ret ? -EFAULT : 0;
 }
 
+void futex_adjust_waiters(struct task_struct *p)
+{
+	struct futex_hash_bucket *hb;
+	union futex_key key;
+	struct futex_q *q;
+	int prio;
+
+	spin_lock(&p->pi_lock);
+	if (p->blocked_on && p->blocked_on->lock_type == FUTEX_WAITER) {
+		q = p->blocked_on->futex_blocked_on;
+retry:
+		key = q->key;
+
+		hb = hash_futex(&key);
+		spin_lock(&hb->lock);
+
+		/*
+		 * Check if the waiter got requeued to a new page, if so retry.
+		 */
+		if (unlikely(!match_futex(&q->key, &key))) {
+			spin_unlock(&hb->lock);
+			goto retry;
+		}
+
+		if (likely(!plist_node_empty(&q->list))) {
+			plist_del(&q->list, &hb->chain);
+			prio = min(p->normal_prio, MAX_RT_PRIO);
+			plist_node_init(&q->list, prio);
+			plist_add(&q->list, &hb->chain);
+		}
+		spin_unlock(&hb->lock);
+	}
+	spin_unlock(&p->pi_lock);
+}
+
+
 /*
  * Fault handling.
  * if fshared is non NULL, current->mm->mmap_sem is already held
@@ -1155,6 +1191,8 @@ static int futex_wait(u32 __user *uaddr,
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
+	struct lock_waiter_state blocked_on =
+		{ .lock_type = FUTEX_WAITER, { .futex_blocked_on = &q} };
 	u32 uval;
 	int ret;
 	struct hrtimer_sleeper t;
@@ -1215,6 +1253,10 @@ static int futex_wait(u32 __user *uaddr,
 	if (uval != val)
 		goto out_unlock_release_sem;
 
+	spin_lock(&current->pi_lock);
+	current->blocked_on = &blocked_on;
+	spin_unlock(&current->pi_lock);
+
 	/* Only actually queue if *uaddr contained val.  */
 	queue_me(&q, hb);
 
@@ -1272,6 +1314,9 @@ static int futex_wait(u32 __user *uaddr,
 	}
 	__set_current_state(TASK_RUNNING);
 
+	spin_lock(&current->pi_lock);
+	current->blocked_on = NULL;
+	spin_unlock(&current->pi_lock);
 	/*
 	 * NOTE: we don't remove ourselves from the waitqueue because
 	 * we are the only user of it.
Index: linux-2.6.25/kernel/sched.c
===================================================================
--- linux-2.6.25.orig/kernel/sched.c
+++ linux-2.6.25/kernel/sched.c
@@ -5209,6 +5209,7 @@ recheck:
 	spin_unlock_irqrestore(&p->pi_lock, flags);
 
 	rt_mutex_adjust_pi(p);
+	futex_adjust_waiters(p);
 
 	return 0;
 }

-- 
