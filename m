Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZGWTV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZGWTV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZGWTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:21:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZGWTVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:23 -0400
Message-Id: <20090723191957.401245856@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 09/13] lockdep: Deal with many similar locks
Content-Disposition: inline; filename=lockdep-held-refcount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_lock_nest_lock() allows to take many instances of the same class,
this can easily lead to overflow of MAX_LOCK_DEPTH.

To avoid this overflow, we'll stop accounting instances but start
reference counting the class in the held_lock structure.

[ we could maintain a list of instances, if we'd move the hlock stuff
  into __lock_acquired(), but that would require significant
  modifications to the current code. ]

We restrict this mode to spin_lock_nest_lock() only, because it
degrades the lockdep quality due to lost of instance.

For lockstat this means we don't track lock statistics for any but the
first lock in the series.

Currently nesting is limited to 11 bits because that was the spare
space available in held_lock. This yields a 2048 instances maximium.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
---
 include/linux/lockdep.h |    4 +-
 kernel/lockdep.c        |   89 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 80 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -213,10 +213,12 @@ struct held_lock {
 	 * interrupt context:
 	 */
 	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
-	unsigned int trylock:1;
+	unsigned int trylock:1;						/* 16 bits */
+
 	unsigned int read:2;        /* see lock_acquire() comment */
 	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
+	unsigned int references:11;					/* 32 bits */
 };
 
 /*
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2699,13 +2699,15 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip,
+			  int references)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
 	struct held_lock *hlock;
 	unsigned int depth, id;
 	int chain_head = 0;
+	int class_idx;
 	u64 chain_key;
 
 	if (!prove_locking)
@@ -2753,10 +2755,24 @@ static int __lock_acquire(struct lockdep
 	if (DEBUG_LOCKS_WARN_ON(depth >= MAX_LOCK_DEPTH))
 		return 0;
 
+	class_idx = class - lock_classes + 1;
+
+	if (depth) {
+		hlock = curr->held_locks + depth - 1;
+		if (hlock->class_idx == class_idx && nest_lock) {
+			if (hlock->references)
+				hlock->references++;
+			else
+				hlock->references = 2;
+
+			return 1;
+		}
+	}
+
 	hlock = curr->held_locks + depth;
 	if (DEBUG_LOCKS_WARN_ON(!class))
 		return 0;
-	hlock->class_idx = class - lock_classes + 1;
+	hlock->class_idx = class_idx;
 	hlock->acquire_ip = ip;
 	hlock->instance = lock;
 	hlock->nest_lock = nest_lock;
@@ -2764,6 +2780,7 @@ static int __lock_acquire(struct lockdep
 	hlock->read = read;
 	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
+	hlock->references = references;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = sched_clock();
@@ -2872,6 +2889,30 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
+{
+	if (hlock->instance == lock)
+		return 1;
+
+	if (hlock->references) {
+		struct lock_class *class = lock->class_cache;
+
+		if (!class)
+			class = look_up_lock_class(lock, 0);
+
+		if (DEBUG_LOCKS_WARN_ON(!class))
+			return 0;
+
+		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
+			return 0;
+
+		if (hlock->class_idx == class - lock_classes + 1)
+			return 1;
+	}
+
+	return 0;
+}
+
 static int
 __lock_set_class(struct lockdep_map *lock, const char *name,
 		 struct lock_class_key *key, unsigned int subclass,
@@ -2895,7 +2936,7 @@ __lock_set_class(struct lockdep_map *loc
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -2914,7 +2955,8 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->nest_lock, hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip,
+				hlock->references))
 			return 0;
 	}
 
@@ -2953,20 +2995,34 @@ lock_release_non_nested(struct task_stru
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
-	lock_release_holdtime(hlock);
+	if (hlock->instance == lock)
+		lock_release_holdtime(hlock);
+
+	if (hlock->references) {
+		hlock->references--;
+		if (hlock->references) {
+			/*
+			 * We had, and after removing one, still have
+			 * references, the current lock stack is still
+			 * valid. We're done!
+			 */
+			return 1;
+		}
+	}
 
 	/*
 	 * We have the right lock to unlock, 'hlock' points to it.
 	 * Now we remove it from the stack, and add back the other
 	 * entries (if any), recalculating the hash along the way:
 	 */
+
 	curr->lockdep_depth = i;
 	curr->curr_chain_key = hlock->prev_chain_key;
 
@@ -2975,7 +3031,8 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->nest_lock, hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip,
+				hlock->references))
 			return 0;
 	}
 
@@ -3005,7 +3062,7 @@ static int lock_release_nested(struct ta
 	/*
 	 * Is the unlock non-nested:
 	 */
-	if (hlock->instance != lock)
+	if (hlock->instance != lock || hlock->references)
 		return lock_release_non_nested(curr, lock, ip);
 	curr->lockdep_depth--;
 
@@ -3056,7 +3113,9 @@ static int __lock_is_held(struct lockdep
 	int i;
 
 	for (i = 0; i < curr->lockdep_depth; i++) {
-		if (curr->held_locks[i].instance == lock)
+		struct held_lock *hlock = curr->held_locks + i;
+
+		if (match_held_lock(hlock, lock))
 			return 1;
 	}
 
@@ -3139,7 +3198,7 @@ void lock_acquire(struct lockdep_map *lo
 
 	current->lockdep_recursion = 1;
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), nest_lock, ip);
+		       irqs_disabled_flags(flags), nest_lock, ip, 0);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
@@ -3243,7 +3302,7 @@ __lock_contended(struct lockdep_map *loc
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3251,6 +3310,9 @@ __lock_contended(struct lockdep_map *loc
 	return;
 
 found_it:
+	if (hlock->instance != lock)
+		return;
+
 	hlock->waittime_stamp = sched_clock();
 
 	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
@@ -3290,7 +3352,7 @@ __lock_acquired(struct lockdep_map *lock
 		 */
 		if (prev_hlock && prev_hlock->irq_context != hlock->irq_context)
 			break;
-		if (hlock->instance == lock)
+		if (match_held_lock(hlock, lock))
 			goto found_it;
 		prev_hlock = hlock;
 	}
@@ -3298,6 +3360,9 @@ __lock_acquired(struct lockdep_map *lock
 	return;
 
 found_it:
+	if (hlock->instance != lock)
+		return;
+
 	cpu = smp_processor_id();
 	if (hlock->waittime_stamp) {
 		now = sched_clock();

-- 

