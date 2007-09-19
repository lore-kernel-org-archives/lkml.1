Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXISKvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXISKvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbXISKvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:51:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbXISKvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:51:05 -0400
Message-Id: <20070919105054.332308000@chello.nl>
References: <20070919104125.286538000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 19 Sep 2007 12:41:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Content-Disposition: inline; filename=rcu-lockdep-validate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Warn when rcu_dereference() is not used in combination with rcu_read_lock()

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h  |    4 +++
 include/linux/rcupdate.h |    3 ++
 kernel/lockdep.c         |   60 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -241,6 +241,7 @@ extern void lockdep_free_key_range(void 
 
 extern void lockdep_off(void);
 extern void lockdep_on(void);
+extern int lockdep_enabled(void);
 
 /*
  * These methods are used by specific locking variants (spinlocks,
@@ -303,6 +304,8 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+extern int lock_is_held(struct lockdep_map *lock);
+
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
@@ -319,6 +322,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, i)		do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_is_held(l)			(0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
Index: linux-2.6/include/linux/rcupdate.h
===================================================================
--- linux-2.6.orig/include/linux/rcupdate.h
+++ linux-2.6/include/linux/rcupdate.h
@@ -138,9 +138,11 @@ extern int rcu_needs_cpu(int cpu);
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+# define rcu_read_held()	WARN_ON_ONCE(lockdep_enabled() && !lock_is_held(&rcu_lock_map))
 #else
 # define rcu_read_acquire()	do { } while (0)
 # define rcu_read_release()	do { } while (0)
+# define rcu_read_held()	do { } while (0)
 #endif
 
 /**
@@ -256,6 +258,7 @@ extern struct lockdep_map rcu_lock_map;
 #define rcu_dereference(p)     ({ \
 				typeof(p) _________p1 = ACCESS_ONCE(p); \
 				smp_read_barrier_depends(); \
+				rcu_read_held(); \
 				(_________p1); \
 				})
 
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -284,6 +284,13 @@ void lockdep_on(void)
 
 EXPORT_SYMBOL(lockdep_on);
 
+int lockdep_enabled(void)
+{
+	return debug_locks && !current->lockdep_recursion;
+}
+
+EXPORT_SYMBOL(lockdep_enabled);
+
 /*
  * Debugging switches:
  */
@@ -2624,6 +2631,36 @@ static int lock_release_nested(struct ta
 	return 1;
 }
 
+static int __lock_is_held(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	unsigned int depth;
+       	int i;
+
+	/*
+	 * Check whether the lock exists in the current stack
+	 * of held locks:
+	 */
+	depth = curr->lockdep_depth;
+	if (!depth)
+		return 0;
+
+	prev_hlock = NULL;
+	for (i = depth-1; i >= 0; i--) {
+		hlock = curr->held_locks + i;
+		/*
+		 * We must not cross into another context:
+		 */
+		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
+			break;
+		if (hlock->instance == lock)
+			return 1;
+		prev_hlock = hlock;
+	}
+	return 0;
+}
+
 /*
  * Remove the lock to the list of currently held locks - this gets
  * called on mutex_unlock()/spin_unlock*() (or on a failed
@@ -2727,6 +2764,29 @@ void lock_release(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_release);
 
+int lock_is_held(struct lockdep_map *lock)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	if (unlikely(!lock_stat && !prove_locking))
+		return 0;
+
+	if (unlikely(current->lockdep_recursion))
+		return -EBUSY;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	ret = __lock_is_held(lock);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+
+	return ret;
+}
+
+EXPORT_SYMBOL_GPL(lock_is_held);
+
 #ifdef CONFIG_LOCK_STAT
 static int
 print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,

--

