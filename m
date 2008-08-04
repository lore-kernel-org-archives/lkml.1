Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYHDNVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYHDNVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYHDNTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:19:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbYHDNTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:19:51 -0400
Message-Id: <20080804131012.161572745@chello.nl>
References: <20080804130317.994042639@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 04 Aug 2008 15:03:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [RFC][PATCH 6/7] lockdep: lock protection locks
Content-Disposition: inline; filename=lockdep-nest-lock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 16:26 -0700, Linus Torvalds wrote:

> On Fri, 1 Aug 2008, David Miller wrote:
> > 
> > Taking more than a few locks of the same class at once is bad
> > news and it's better to find an alternative method.
> 
> It's not always wrong.
> 
> If you can guarantee that anybody that takes more than one lock of a 
> particular class will always take a single top-level lock _first_, then 
> that's all good. You can obviously screw up and take the same lock _twice_ 
> (which will deadlock), but at least you cannot get into ABBA situations.
> 
> So maybe the right thing to do is to just teach lockdep about "lock 
> protection locks". That would have solved the multi-queue issues for 
> networking too - all the actual network drivers would still have taken 
> just their single queue lock, but the one case that needs to take all of 
> them would have taken a separate top-level lock first.
> 
> Never mind that the multi-queue locks were always taken in the same order: 
> it's never wrong to just have some top-level serialization, and anybody 
> who needs to take <n> locks might as well do <n+1>, because they sure as 
> hell aren't going to be on _any_ fastpaths.
> 
> So the simplest solution really sounds like just teaching lockdep about 
> that one special case. It's not "nesting" exactly, although it's obviously 
> related to it.

Do as Linus suggested. The lock protection lock is called nest_lock.

Note that we still have the MAX_LOCK_DEPTH (48) limit to consider, so anything
that spills that it still up shit creek.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h    |   34 ++++++++++++++++++----------------
 include/linux/rcuclassic.h |    2 +-
 kernel/lockdep.c           |   26 +++++++++++++++++++++-----
 3 files changed, 40 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -1372,18 +1372,32 @@ check_deadlock(struct task_struct *curr,
 	       struct lockdep_map *next_instance, int read)
 {
 	struct held_lock *prev;
+	struct held_lock *nest = NULL;
 	int i;
 
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		prev = curr->held_locks + i;
+
+		if (prev->instance == next->nest_lock)
+			nest = prev;
+
 		if (hlock_class(prev) != hlock_class(next))
 			continue;
+
 		/*
 		 * Allow read-after-read recursion of the same
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
 		if ((read == 2) && prev->read)
 			return 2;
+
+		/*
+		 * We're holding the nest_lock, which serializes this lock's
+		 * nesting behaviour.
+		 */
+		if (nest)
+			return 2;
+
 		return print_deadlock_bug(curr, prev, next);
 	}
 	return 1;
@@ -2507,7 +2521,7 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
-			  unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -2566,6 +2580,7 @@ static int __lock_acquire(struct lockdep
 	hlock->class_idx = class - lock_classes + 1;
 	hlock->acquire_ip = ip;
 	hlock->instance = lock;
+	hlock->nest_lock = nest_lock;
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
@@ -2717,7 +2732,7 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2778,7 +2793,7 @@ found_it:
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2915,7 +2930,8 @@ EXPORT_SYMBOL_GPL(lock_set_subclass);
  * and also avoid lockdep recursion:
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check, unsigned long ip)
+			  int trylock, int read, int check,
+			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -2930,7 +2946,7 @@ void lock_acquire(struct lockdep_map *lo
 
 	current->lockdep_recursion = 1;
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), ip);
+		       irqs_disabled_flags(flags), nest_lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -211,6 +211,7 @@ struct held_lock {
 	u64				prev_chain_key;
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
+	struct lockdep_map		*nest_lock;
 #ifdef CONFIG_LOCK_STAT
 	u64 				waittime_stamp;
 	u64				holdtime_stamp;
@@ -297,7 +298,8 @@ extern void lockdep_init_map(struct lock
  *   2: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check, unsigned long ip);
+			 int trylock, int read, int check,
+			 struct lockdep_map *nest_lock, unsigned long ip);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
@@ -319,7 +321,7 @@ static inline void lockdep_on(void)
 {
 }
 
-# define lock_acquire(l, s, t, r, c, i)		do { } while (0)
+# define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
@@ -407,9 +409,9 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
 # else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
 # endif
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -419,11 +421,11 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, i)
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
 # else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, i)
+#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
 # endif
 # define rwlock_release(l, n, i)		lock_release(l, n, i)
 #else
@@ -434,9 +436,9 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
 # else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
+#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -446,11 +448,11 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, i)
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
 # else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, i)
+#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
 # endif
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -461,9 +463,9 @@ static inline void print_irqtrace_events
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, _THIS_IP_)
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
 # else
-#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, _THIS_IP_)
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
 # endif
 # define map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
Index: linux-2.6/include/linux/rcuclassic.h
===================================================================
--- linux-2.6.orig/include/linux/rcuclassic.h
+++ linux-2.6/include/linux/rcuclassic.h
@@ -117,7 +117,7 @@ extern int rcu_needs_cpu(int cpu);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
 #else
 # define rcu_read_acquire()	do { } while (0)

-- 

