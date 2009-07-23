Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZGWTWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZGWTWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZGWTWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:22:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:36975 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZGWTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:12 -0400
Message-Id: <20090723191957.308628611@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:50 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/13] lockdep: Introduce lockdep_assert_held()
Content-Disposition: inline; filename=lockdep-assert-held.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lockdep helper to validate that we indeed are the owner of a
lock.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    8 ++++++++
 kernel/lockdep.c        |   33 +++++++++++++++++++++++++++++++++
 kernel/sched.c          |    2 ++
 3 files changed, 43 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -296,6 +296,10 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+
+extern int lock_is_held(struct lockdep_map *lock);
+
 extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
 			   unsigned long ip);
@@ -314,6 +318,8 @@ extern void lockdep_trace_alloc(gfp_t ma
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
+#define lockdep_assert_held(l)	WARN_ON(debug_locks && !lockdep_is_held(l))
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -358,6 +364,8 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
+#define lockdep_assert_held(l)			do { } while (0)
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCK_STAT
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -3044,6 +3044,19 @@ __lock_release(struct lockdep_map *lock,
 	check_chain_key(curr);
 }
 
+static int __lock_is_held(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	int i;
+
+	for (i = 0; i < curr->lockdep_depth; i++) {
+		if (curr->held_locks[i].instance == lock)
+			return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -3145,6 +3158,26 @@ void lock_release(struct lockdep_map *lo
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
+int lock_is_held(struct lockdep_map *lock)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	if (unlikely(current->lockdep_recursion))
+		return ret;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+
+	current->lockdep_recursion = 1;
+	ret = __lock_is_held(lock);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lock_is_held);
+
 void lockdep_set_current_reclaim_state(gfp_t gfp_mask)
 {
 	current->lockdep_reclaim_gfp = gfp_mask;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6648,6 +6648,8 @@ int cond_resched_lock(spinlock_t *lock)
 	int resched = should_resched();
 	int ret = 0;
 
+	lockdep_assert_held(lock);
+
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
 		if (resched)

-- 

