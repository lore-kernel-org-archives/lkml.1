Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXA1MKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXA1MKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXA1MKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:10:45 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:15007 "EHLO
	amsfep14-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbXA1MKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:10:43 -0500
Message-Id: <20070128120509.013482000@programming.kicks-ass.net>
References: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 12:51:19 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/7] lockdep: lock_set_subclass - reset a held locks subclass
Content-Disposition: inline; filename=lockdep-lock_set_subclass.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this can be used to reset a held lock's subclass, for arbitrary-depth
iterated data structures such as trees or lists which have per-node
locks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/lockdep.h |    4 ++
 kernel/lockdep.c        |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h	2007-01-13 21:04:10.000000000 +0100
+++ linux-2.6/include/linux/lockdep.h	2007-01-27 21:05:55.000000000 +0100
@@ -240,6 +240,9 @@ extern void lock_acquire(struct lockdep_
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
+			      unsigned long ip);
+
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
 #define lockdep_depth(tsk)	((tsk)->lockdep_depth)
@@ -256,6 +259,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, i)		do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-01-13 21:04:11.000000000 +0100
+++ linux-2.6/kernel/lockdep.c	2007-01-27 21:05:55.000000000 +0100
@@ -2264,6 +2264,55 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+static int
+__lock_set_subclass(struct lockdep_map *lock,
+		    unsigned int subclass, unsigned long ip)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class *class;
+	unsigned int depth;
+	int i;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
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
+			goto found_it;
+		prev_hlock = hlock;
+	}
+	return print_unlock_inbalance_bug(curr, lock, ip);
+
+found_it:
+	class = register_lock_class(lock, subclass, 0);
+	hlock->class = class;
+
+	curr->lockdep_depth = i;
+	curr->curr_chain_key = hlock->prev_chain_key;
+
+	for (; i < depth; i++) {
+		hlock = curr->held_locks + i;
+		if (!__lock_acquire(hlock->instance,
+			hlock->class->subclass, hlock->trylock,
+				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->acquire_ip))
+			return 0;
+	}
+
+	if (DEBUG_LOCKS_WARN_ON(curr->lockdep_depth != depth))
+		return 0;
+	return 1;
+}
+
 /*
  * Remove the lock to the list of currently held locks in a
  * potentially non-nested (out of order) manner. This is a
@@ -2459,6 +2508,26 @@ void lock_release(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_release);
 
+void
+lock_set_subclass(struct lockdep_map *lock,
+		  unsigned int subclass, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
+	check_flags(flags);
+	if (__lock_set_subclass(lock, subclass, ip))
+		check_chain_key(current);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+
+EXPORT_SYMBOL_GPL(lock_set_subclass);
+
 /*
  * Used by the testsuite, sanitize the validator state
  * after a simulated failure:

--

