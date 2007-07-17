Return-Path: <linux-kernel-owner+w=401wt.eu-S934572AbXGQPoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572AbXGQPoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbXGQPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:41:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593AbXGQPlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:41:11 -0400
Message-Id: <20070717173758.272328000@chello.nl>
References: <20070717173428.355522000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 17 Jul 2007 19:34:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/T PATCH 07/12] lockdep: non-recursive validation
Content-Disposition: inline; filename=lockdep-norecursion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a validation mode that diregards all recursive locking errors.
This is useful for locks like lock_page where there is a high degree
of nested locking.

Obviously it will not report a useful class of errors :-/

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |   15 ++++++++-------
 kernel/lockdep.c        |   15 ++++++++++++---
 2 files changed, 20 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -286,7 +286,8 @@ extern void lockdep_init_map(struct lock
  *
  *   0: disabled
  *   1: simple checks (freeing, held-at-exit-time, etc.)
- *   2: full validation
+ *   2: validation without recursion checks
+ *   3: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			 int trylock, int read, int check, unsigned long ip);
@@ -426,7 +427,7 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 3, i)
 # else
 #  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
 # endif
@@ -438,8 +439,8 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, i)
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 3, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 3, i)
 # else
 #  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
 #  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, i)
@@ -453,7 +454,7 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 3, i)
 # else
 #  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
 # endif
@@ -465,8 +466,8 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, i)
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 3, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 3, i)
 # else
 #  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
 #  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, i)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2176,7 +2176,7 @@ static int __lock_acquire(struct lockdep
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
 	struct held_lock *hlock;
-	unsigned int depth, id;
+	unsigned int depth, id, first;
 	int chain_head = 0;
 	u64 chain_key;
 
@@ -2225,6 +2225,14 @@ static int __lock_acquire(struct lockdep
 		return 0;
 
 	hlock = curr->held_locks + depth;
+	if (check == 2 && depth > 0) {
+		struct held_lock *prev_hlock = NULL;
+
+		prev_hlock = curr->held_locks + depth - 1;
+		if (prev_hlock->class == class)
+			first = 0;
+	} else
+		first = 1;
 
 	hlock->class = class;
 	hlock->acquire_ip = ip;
@@ -2238,7 +2246,7 @@ static int __lock_acquire(struct lockdep
 	hlock->holdtime_stamp = sched_clock();
 #endif
 
-	if (check != 2)
+	if (check < 2)
 		goto out_calc_hash;
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/*
@@ -2347,7 +2355,8 @@ out_calc_hash:
 	 * graph_lock for us)
 	 */
 #ifdef CONFIG_PROVE_LOCKING
-	if (!trylock && (check == 2) && lookup_chain_cache(chain_key, class)) {
+	if (!trylock && (check >= 2 && first) &&
+			lookup_chain_cache(chain_key, class)) {
 		/*
 		 * Check whether last held lock:
 		 *

--

