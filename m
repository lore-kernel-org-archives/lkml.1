Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZEKMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZEKMlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbZEKMj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:56 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52203 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275AbZEKMjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:54 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH PATCH 3/6] lockdep: Annotate Read/write states
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:41 +0530
Message-ID: <20090511123940.31159.10431.stgit@sofia.in.ibm.com>
In-Reply-To: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
References: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we do not save the recursive read dependencies in the dependency
chain. As a result, a deadlock caused by the following chains are not spotted,
since we never have the chain 1 in our dependency list.

1: Rlock(A)-->lock(B)
2: lock(B) --> Wlock(A), where A is a recursive read lock.

Before adding the Recursive Read locks to the dependency chains, we need to
distinguish them from the normal read locks since the conflicting states for
these two are quite different.

Currently the read/write status of a lock while it's acquired is denoted by a
monotonically increasing variable where
0 - WRITE
1 - READ
2 - RECURSIVE READ.

In this patch, we propose to modify this distinction from a monotonically
increasing variable to a bit mask where
0x1 - WRITE
0x2 - READ
0x4 - RECURSIVE READ.

This helps us to define the conflicting states for each lock with ease:
Thereby, the conflicting states for a given states are defined as follows:
Conflicting_states(WRITE): RECURSIVE_READ | READ | WRITE
Conflicting_states(READ):  READ | WRITE
Conflicting_states(RECURSIVE_READ): WRITE

Also, we use one more bit in the bitmask to distinguish the first recursive
read in the current chain from the others, since it is sufficient to add only
this dependency to the dependency list.


Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/lockdep.h |  103 ++++++++++++++++++++++++++++++++++++-----------
 kernel/lockdep.c        |   52 +++++++++++++-----------
 2 files changed, 107 insertions(+), 48 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index da5a5a1..161deee 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -209,7 +209,7 @@ struct held_lock {
 	 */
 	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
 	unsigned int trylock:1;
-	unsigned int read:2;        /* see lock_acquire() comment */
+	unsigned int rw_state:4;        /* see lock states comment */
 	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
 };
@@ -259,14 +259,49 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		lockdep_init_map(&(lock)->dep_map, #lock, \
 				 (lock)->dep_map.key, sub)
 
+/* lock_state bits */
+#define _W_		0
+#define _R_		(_W_ + 1)
+#define _RR_		(_W_ + 2)
+#define _FIRST_RR_	(_W_ + 3)
+
+#define get_lock_state(lock_bit)	(1 << lock_bit)
+
 /*
- * Acquire a lock.
+ * lock states:
  *
- * Values for "read":
+ * A given lock can have one of the following states:
+ * - STATE_WRITE: Exclusive Write.
+ * - STATE_READ: Non-recursive read.
+ * - STATE_RECURSIVE_READ: Recursive Read.
+ *
+ * These states are represented as bitmasks
+ */
+#define STATE_WRITE		get_lock_state(_W_)
+#define STATE_READ		get_lock_state(_R_)
+#define STATE_RECURSIVE_READ	get_lock_state(_RR_)
+
+/* Helpers to check the current lock's state */
+#define is_simple_read(state)	(state & STATE_READ)
+#define is_rec_read(state)	(state & STATE_RECURSIVE_READ)
+#define is_read(state)		(is_simple_read(state) | is_rec_read(state))
+#define is_write(state)		(state & STATE_WRITE)
+
+/*
+ * When maintaining dependency chains for locks acquired with
+ * STATE_RECURSIVE_READ state, we add a particular instance of the lock to the
+ * dependency chain only if it's the first recursive read instance in the
+ * current dependency chain. We don't add recurring instances of the lock
+ * to the dependency chains.
+ */
+#define STATE_FIRST_RECURSIVE_READ	get_lock_state(_FIRST_RR_)
+#define is_first_rec_read(state)	(state & STATE_FIRST_RECURSIVE_READ)
+
+/*
+ * Acquire a lock.
  *
- *   0: exclusive (write) acquire
- *   1: read-acquire (no recursion allowed)
- *   2: read-acquire with same-instance recursion allowed
+ * Values for "rw_state":
+ *	See comment for lock states:
  *
  * Values for check:
  *
@@ -275,7 +310,7 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
  *   2: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check,
+			 int trylock, int rw_state, int check,
 			 struct lockdep_map *nest_lock, unsigned long ip);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
@@ -419,11 +454,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
+#  define spin_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	\
+		lock_acquire(l, s, t, STATE_WRITE, 2, n, i)
 # else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define spin_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
 # endif
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -433,11 +472,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 2, NULL, i)
+#  define rwlock_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_RECURSIVE_READ, 2, NULL, i)
 # else
-#  define rwlock_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwlock_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 2, 1, NULL, i)
+#  define rwlock_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
+#  define rwlock_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_RECURSIVE_READ, 1, NULL, i)
 # endif
 # define rwlock_release(l, n, i)		lock_release(l, n, i)
 #else
@@ -448,9 +491,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define mutex_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
 # else
-#  define mutex_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define mutex_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
 # endif
 # define mutex_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -460,11 +505,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 2, NULL, i)
+#  define rwsem_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 2, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_READ, 2, NULL, i)
 # else
-#  define rwsem_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
-#  define rwsem_acquire_read(l, s, t, i)	lock_acquire(l, s, t, 1, 1, NULL, i)
+#  define rwsem_acquire(l, s, t, i)		\
+		lock_acquire(l, s, t, STATE_WRITE, 1, NULL, i)
+#  define rwsem_acquire_read(l, s, t, i)	\
+		lock_acquire(l, s, t, STATE_READ, 1, NULL, i)
 # endif
 # define rwsem_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -475,9 +524,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)		\
+		lock_acquire(l, 0, 0, STATE_WRITE, 2, NULL, _THIS_IP_)
 # else
-#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
+#  define lock_map_acquire(l)		\
+		lock_acquire(l, 0, 0, STATE_WRITE, 1, NULL, _THIS_IP_)
 # endif
 # define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
 #else
@@ -489,13 +540,15 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define might_lock(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, STATE_WRITE,		\
+						2, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 # define might_lock_read(lock) 						\
 do {									\
 	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
-	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_acquire(&(lock)->dep_map, 0, 0, STATE_READ,		\
+						2, NULL, _THIS_IP_);	\
 	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
 } while (0)
 #else
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 597479a..5f92ea4 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -239,7 +239,7 @@ static void lock_release_holdtime(struct held_lock *hlock)
 	holdtime = sched_clock() - hlock->holdtime_stamp;
 
 	stats = get_lock_stats(hlock_class(hlock));
-	if (hlock->read)
+	if (is_read(hlock->rw_state))
 		lock_time_inc(&stats->read_holdtime, holdtime);
 	else
 		lock_time_inc(&stats->write_holdtime, holdtime);
@@ -1408,7 +1408,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
  */
 static int
 check_deadlock(struct task_struct *curr, struct held_lock *next,
-	       struct lockdep_map *next_instance, int read)
+	       struct lockdep_map *next_instance, int rw_state)
 {
 	struct held_lock *prev;
 	struct held_lock *nest = NULL;
@@ -1427,7 +1427,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 		 * Allow read-after-read recursion of the same
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
-		if ((read == 2) && prev->read)
+		if (is_rec_read(rw_state) && is_read(prev->rw_state))
 			return 2;
 
 		/*
@@ -1496,7 +1496,7 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * write-lock never takes any other locks, then the reads are
 	 * equivalent to a NOP.
 	 */
-	if (next->read == 2)
+	if (is_rec_read(next->rw_state))
 		return 1;
 	/*
 	 * Is the <prev> -> <next> dependency already present?
@@ -1581,7 +1581,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (hlock->read != 2) {
+		if (!is_rec_read(hlock->rw_state)) {
 			if (!check_prev_add(curr, hlock, next, distance))
 				return 0;
 			/*
@@ -1749,7 +1749,7 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 		 * any of these scenarios could lead to a deadlock. If
 		 * All validations
 		 */
-		int ret = check_deadlock(curr, hlock, lock, hlock->read);
+		int ret = check_deadlock(curr, hlock, lock, hlock->rw_state);
 
 		if (!ret)
 			return 0;
@@ -2077,7 +2077,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 		hlock = curr->held_locks + i;
 
 		usage_bit = 2 + (mark << 2); /* ENABLED */
-		if (hlock->read)
+		if (hlock->rw_state)
 			usage_bit += 1; /* READ */
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
@@ -2301,7 +2301,7 @@ static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 	 * mark the lock as used in these contexts:
 	 */
 	if (!hlock->trylock) {
-		if (hlock->read) {
+		if (is_read(hlock->rw_state)) {
 			if (curr->hardirq_context)
 				if (!mark_lock(curr, hlock,
 						LOCK_USED_IN_HARDIRQ_READ))
@@ -2320,7 +2320,7 @@ static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 		}
 	}
 	if (!hlock->hardirqs_off) {
-		if (hlock->read) {
+		if (is_read(hlock->rw_state)) {
 			if (!mark_lock(curr, hlock,
 					LOCK_ENABLED_HARDIRQ_READ))
 				return 0;
@@ -2346,7 +2346,7 @@ static int mark_irqflags(struct task_struct *curr, struct held_lock *hlock)
 	 * allocation).
 	 */
 	if (!hlock->trylock && (curr->lockdep_reclaim_gfp & __GFP_FS)) {
-		if (hlock->read) {
+		if (is_read(hlock->rw_state)) {
 			if (!mark_lock(curr, hlock, LOCK_USED_IN_RECLAIM_FS_READ))
 					return 0;
 		} else {
@@ -2521,8 +2521,9 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
  * We maintain the dependency maps and validate the locking attempt:
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check, int hardirqs_off,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+			  int trylock, int rw_state, int check,
+			  int hardirqs_off, struct lockdep_map *nest_lock,
+			  unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -2584,7 +2585,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->instance = lock;
 	hlock->nest_lock = nest_lock;
 	hlock->trylock = trylock;
-	hlock->read = read;
+	hlock->rw_state = rw_state;
 	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
 #ifdef CONFIG_LOCK_STAT
@@ -2736,8 +2737,9 @@ found_it:
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
-				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->nest_lock, hlock->acquire_ip))
+				hlock->rw_state, hlock->check,
+				hlock->hardirqs_off, hlock->nest_lock,
+				hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2797,8 +2799,9 @@ found_it:
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
 			hlock_class(hlock)->subclass, hlock->trylock,
-				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->nest_lock, hlock->acquire_ip))
+				hlock->rw_state, hlock->check,
+				hlock->hardirqs_off, hlock->nest_lock,
+				hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2936,12 +2939,13 @@ DEFINE_TRACE(lock_acquire);
  * and also avoid lockdep recursion:
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check,
+			  int trylock, int rw_state, int check,
 			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
+	trace_lock_acquire(lock, subclass, trylock, rw_state, check,
+							nest_lock, ip);
 
 	if (unlikely(current->lockdep_recursion))
 		return;
@@ -2950,7 +2954,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	check_flags(flags);
 
 	current->lockdep_recursion = 1;
-	__lock_acquire(lock, subclass, trylock, read, check,
+	__lock_acquire(lock, subclass, trylock, rw_state, check,
 		       irqs_disabled_flags(flags), nest_lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
@@ -3057,7 +3061,8 @@ found_it:
 	if (contending_point < LOCKSTAT_POINTS)
 		stats->contending_point[contending_point]++;
 	if (lock->cpu != smp_processor_id())
-		stats->bounces[bounce_contended + !!hlock->read]++;
+		stats->bounces[bounce_contended +
+				!!is_read(hlock->rw_state)]++;
 	put_lock_stats(stats);
 }
 
@@ -3101,13 +3106,14 @@ found_it:
 
 	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
-		if (hlock->read)
+		if (is_read(hlock->rw_state))
 			lock_time_inc(&stats->read_waittime, waittime);
 		else
 			lock_time_inc(&stats->write_waittime, waittime);
 	}
 	if (lock->cpu != cpu)
-		stats->bounces[bounce_acquired + !!hlock->read]++;
+		stats->bounces[bounce_acquired +
+				!!is_read(hlock->rw_state)]++;
 	put_lock_stats(stats);
 
 	lock->cpu = cpu;

