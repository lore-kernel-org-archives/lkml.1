Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYHLPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYHLPVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYHLPVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:21:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbYHLPVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:21:07 -0400
Date: Tue, 12 Aug 2008 17:20:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [git pull] core fixes
Message-ID: <20080812152047.GA4028@elte.hu>
References: <20080811222026.GA20579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811222026.GA20579@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest core-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

i've added Nick's smp_call_function fix as well, which you can pull from 
the core-fixes-for-linus-2 branch:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus-2

[ the original branch is unchanged and is still pullable - the second 
  branch embedds the first branch and adds Nick's fix. The second branch 
  can be pulled ontop of the first branch as well. ]

Thanks,

	Ingo

------------------>
Dave Jones (1):
      lockdep: shrink held_lock structure

David Miller (2):
      lockdep: fix combinatorial explosion in lock subgraph traversal
      debug_locks: set oops_in_progress if we will log messages.

Ingo Molnar (2):
      lockdep: rename map_[acquire|release]() => lock_map_[acquire|release]()
      lockdep: increase MAX_LOCKDEP_KEYS

Nick Piggin (2):
      generic-ipi: fix stack and rcu interaction bug in smp_call_function_mask()
      generic-ipi: fix stack and rcu interaction bug in smp_call_function_mask(), fix

Peter Zijlstra (10):
      lockdep: change scheduler annotation
      lockdep: lock_set_subclass - reset a held lock's subclass
      lockdep: re-annotate scheduler runqueues
      lockdep: map_acquire
      lockdep: lock protection locks
      lockdep: spin_lock_nest_lock()
      lockdep: annotate mm_take_all_locks()
      mm: fix mm_take_all_locks() locking order
      lockdep: fix overflow in the hlock shrinkage code
      lockdep: fix debug_lock_alloc

Rabin Vincent (1):
      lockdep: handle chains involving classes defined in modules


 fs/jbd/transaction.c             |    4 +-
 fs/jbd2/transaction.c            |    4 +-
 include/linux/lockdep.h          |   70 +++++++---
 include/linux/rcuclassic.h       |    2 +-
 include/linux/spinlock.h         |    6 +
 include/linux/spinlock_api_smp.h |    2 +
 kernel/lockdep.c                 |  295 ++++++++++++++++++++++++++++++-------
 kernel/lockdep_internals.h       |    6 +-
 kernel/lockdep_proc.c            |   37 +----
 kernel/sched.c                   |   21 ++-
 kernel/sched_rt.c                |    8 +-
 kernel/smp.c                     |   58 +++++++-
 kernel/spinlock.c                |   11 ++
 kernel/workqueue.c               |   24 ++--
 lib/debug_locks.c                |    2 +
 mm/mmap.c                        |   20 ++-
 16 files changed, 416 insertions(+), 154 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 8dee320..0540ca2 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -291,7 +291,7 @@ handle_t *journal_start(journal_t *journal, int nblocks)
 		goto out;
 	}
 
-	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_map_acquire(&handle->h_lockdep_map);
 
 out:
 	return handle;
@@ -1448,7 +1448,7 @@ int journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+	lock_map_release(&handle->h_lockdep_map);
 
 	jbd_free_handle(handle);
 	return err;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4f7cadb..e5d5405 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -301,7 +301,7 @@ handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
 		goto out;
 	}
 
-	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	lock_map_acquire(&handle->h_lockdep_map);
 out:
 	return handle;
 }
@@ -1279,7 +1279,7 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+	lock_map_release(&handle->h_lockdep_map);
 
 	jbd2_free_handle(handle);
 	return err;
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2486eb4..331e5f1 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -89,6 +89,7 @@ struct lock_class {
 
 	struct lockdep_subclass_key	*key;
 	unsigned int			subclass;
+	unsigned int			dep_gen_id;
 
 	/*
 	 * IRQ/softirq usage tracking bits:
@@ -189,6 +190,14 @@ struct lock_chain {
 	u64				chain_key;
 };
 
+#define MAX_LOCKDEP_KEYS_BITS		13
+/*
+ * Subtract one because we offset hlock->class_idx by 1 in order
+ * to make 0 mean no class. This avoids overflowing the class_idx
+ * bitfield and hitting the BUG in hlock_class().
+ */
+#define MAX_LOCKDEP_KEYS		((1UL << MAX_LOCKDEP_KEYS_BITS) - 1)
+
 struct held_lock {
 	/*
 	 * One-way hash of the dependency chain up to this point. We
@@ -205,14 +214,14 @@ struct held_lock {
 	 * with zero), here we store the previous hash value:
 	 */
 	u64				prev_chain_key;
-	struct lock_class		*class;
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
-
+	struct lockdep_map		*nest_lock;
 #ifdef CONFIG_LOCK_STAT
 	u64 				waittime_stamp;
 	u64				holdtime_stamp;
 #endif
+	unsigned int			class_idx:MAX_LOCKDEP_KEYS_BITS;
 	/*
 	 * The lock-stack is unified in that the lock chains of interrupt
 	 * contexts nest ontop of process context chains, but we 'separate'
@@ -226,11 +235,11 @@ struct held_lock {
 	 * The following field is used to detect when we cross into an
 	 * interrupt context:
 	 */
-	int				irq_context;
-	int				trylock;
-	int				read;
-	int				check;
-	int				hardirqs_off;
+	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
+	unsigned int trylock:1;
+	unsigned int read:2;        /* see lock_acquire() comment */
+	unsigned int check:2;       /* see lock_acquire() comment */
+	unsigned int hardirqs_off:1;
 };
 
 /*
@@ -294,11 +303,15 @@ extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
  *   2: full validation
  */
 extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check, unsigned long ip);
+			 int trylock, int read, int check,
+			 struct lockdep_map *nest_lock, unsigned long ip);
 
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
+extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
+			      unsigned long ip);
+
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
@@ -313,8 +326,9 @@ static inline void lockdep_on(void)
 {
 }
 
-# define lock_acquire(l, s, t, r, c, i)		do { } while (0)
+# define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
 # define lockdep_init_map(lock, name, key, sub)	do { (void)(key); } while (0)
@@ -400,9 +414,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # ifdef CONFIG_PROVE_LOCKING
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 2, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 2, n, i)
 # else
-#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, i)
+#  define spin_acquire(l, s, t, i)		lock_acquire(l, s, t, 0, 1, NULL, i)
+#  define spin_acquire_nest(l, s, t, n, i)	lock_acquire(l, s, t, 0, 1, NULL, i)
 # endif
 # define spin_release(l, n, i)			lock_release(l, n, i)
 #else
@@ -412,11 +428,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
@@ -427,9 +443,9 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
@@ -439,11 +455,11 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 
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
@@ -452,4 +468,16 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, NULL, _THIS_IP_)
+# else
+#  define lock_map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, NULL, _THIS_IP_)
+# endif
+# define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
+#else
+# define lock_map_acquire(l)			do { } while (0)
+# define lock_map_release(l)			do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 8c77490..4ab8436 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -117,7 +117,7 @@ extern int rcu_needs_cpu(int cpu);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
 #else
 # define rcu_read_acquire()	do { } while (0)
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 61e5610..e0c0fcc 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -183,8 +183,14 @@ do {								\
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
+# define spin_lock_nest_lock(lock, nest_lock)				\
+	 do {								\
+		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
+		 _spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
+	 } while (0)
 #else
 # define spin_lock_nested(lock, subclass) _spin_lock(lock)
+# define spin_lock_nest_lock(lock, nest_lock) _spin_lock(lock)
 #endif
 
 #define write_lock(lock)		_write_lock(lock)
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 8a2307c..d79845d 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -22,6 +22,8 @@ int in_lock_functions(unsigned long addr);
 void __lockfunc _spin_lock(spinlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 							__acquires(lock);
+void __lockfunc _spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *map)
+							__acquires(lock);
 void __lockfunc _read_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _write_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_bh(spinlock_t *lock)		__acquires(lock);
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index d38a643..1aa91fd 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -124,6 +124,15 @@ static struct lock_list list_entries[MAX_LOCKDEP_ENTRIES];
 unsigned long nr_lock_classes;
 static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 
+static inline struct lock_class *hlock_class(struct held_lock *hlock)
+{
+	if (!hlock->class_idx) {
+		DEBUG_LOCKS_WARN_ON(1);
+		return NULL;
+	}
+	return lock_classes + hlock->class_idx - 1;
+}
+
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
@@ -222,7 +231,7 @@ static void lock_release_holdtime(struct held_lock *hlock)
 
 	holdtime = sched_clock() - hlock->holdtime_stamp;
 
-	stats = get_lock_stats(hlock->class);
+	stats = get_lock_stats(hlock_class(hlock));
 	if (hlock->read)
 		lock_time_inc(&stats->read_holdtime, holdtime);
 	else
@@ -372,6 +381,19 @@ unsigned int nr_process_chains;
 unsigned int max_lockdep_depth;
 unsigned int max_recursion_depth;
 
+static unsigned int lockdep_dependency_gen_id;
+
+static bool lockdep_dependency_visit(struct lock_class *source,
+				     unsigned int depth)
+{
+	if (!depth)
+		lockdep_dependency_gen_id++;
+	if (source->dep_gen_id == lockdep_dependency_gen_id)
+		return true;
+	source->dep_gen_id = lockdep_dependency_gen_id;
+	return false;
+}
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * We cannot printk in early bootup code. Not even early_printk()
@@ -505,7 +527,7 @@ static void print_lockdep_cache(struct lockdep_map *lock)
 
 static void print_lock(struct held_lock *hlock)
 {
-	print_lock_name(hlock->class);
+	print_lock_name(hlock_class(hlock));
 	printk(", at: ");
 	print_ip_sym(hlock->acquire_ip);
 }
@@ -558,6 +580,9 @@ static void print_lock_dependencies(struct lock_class *class, int depth)
 {
 	struct lock_list *entry;
 
+	if (lockdep_dependency_visit(class, depth))
+		return;
+
 	if (DEBUG_LOCKS_WARN_ON(depth >= 20))
 		return;
 
@@ -932,7 +957,7 @@ static noinline int print_circular_bug_tail(void)
 	if (debug_locks_silent)
 		return 0;
 
-	this.class = check_source->class;
+	this.class = hlock_class(check_source);
 	if (!save_trace(&this.trace))
 		return 0;
 
@@ -959,6 +984,67 @@ static int noinline print_infinite_recursion_bug(void)
 	return 0;
 }
 
+unsigned long __lockdep_count_forward_deps(struct lock_class *class,
+					   unsigned int depth)
+{
+	struct lock_list *entry;
+	unsigned long ret = 1;
+
+	if (lockdep_dependency_visit(class, depth))
+		return 0;
+
+	/*
+	 * Recurse this class's dependency list:
+	 */
+	list_for_each_entry(entry, &class->locks_after, entry)
+		ret += __lockdep_count_forward_deps(entry->class, depth + 1);
+
+	return ret;
+}
+
+unsigned long lockdep_count_forward_deps(struct lock_class *class)
+{
+	unsigned long ret, flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&lockdep_lock);
+	ret = __lockdep_count_forward_deps(class, 0);
+	__raw_spin_unlock(&lockdep_lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+unsigned long __lockdep_count_backward_deps(struct lock_class *class,
+					    unsigned int depth)
+{
+	struct lock_list *entry;
+	unsigned long ret = 1;
+
+	if (lockdep_dependency_visit(class, depth))
+		return 0;
+	/*
+	 * Recurse this class's dependency list:
+	 */
+	list_for_each_entry(entry, &class->locks_before, entry)
+		ret += __lockdep_count_backward_deps(entry->class, depth + 1);
+
+	return ret;
+}
+
+unsigned long lockdep_count_backward_deps(struct lock_class *class)
+{
+	unsigned long ret, flags;
+
+	local_irq_save(flags);
+	__raw_spin_lock(&lockdep_lock);
+	ret = __lockdep_count_backward_deps(class, 0);
+	__raw_spin_unlock(&lockdep_lock);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 /*
  * Prove that the dependency graph starting at <entry> can not
  * lead to <target>. Print an error and return 0 if it does.
@@ -968,6 +1054,9 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 {
 	struct lock_list *entry;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	debug_atomic_inc(&nr_cyclic_check_recursions);
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
@@ -977,7 +1066,7 @@ check_noncircular(struct lock_class *source, unsigned int depth)
 	 * Check this lock's dependency list:
 	 */
 	list_for_each_entry(entry, &source->locks_after, entry) {
-		if (entry->class == check_target->class)
+		if (entry->class == hlock_class(check_target))
 			return print_circular_bug_header(entry, depth+1);
 		debug_atomic_inc(&nr_cyclic_checks);
 		if (!check_noncircular(entry->class, depth+1))
@@ -1011,6 +1100,9 @@ find_usage_forwards(struct lock_class *source, unsigned int depth)
 	struct lock_list *entry;
 	int ret;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	if (depth > max_recursion_depth)
 		max_recursion_depth = depth;
 	if (depth >= RECURSION_LIMIT)
@@ -1050,6 +1142,9 @@ find_usage_backwards(struct lock_class *source, unsigned int depth)
 	struct lock_list *entry;
 	int ret;
 
+	if (lockdep_dependency_visit(source, depth))
+		return 1;
+
 	if (!__raw_spin_is_locked(&lockdep_lock))
 		return DEBUG_LOCKS_WARN_ON(1);
 
@@ -1064,6 +1159,11 @@ find_usage_backwards(struct lock_class *source, unsigned int depth)
 		return 2;
 	}
 
+	if (!source && debug_locks_off_graph_unlock()) {
+		WARN_ON(1);
+		return 0;
+	}
+
 	/*
 	 * Check this lock's dependency list:
 	 */
@@ -1103,9 +1203,9 @@ print_bad_irq_dependency(struct task_struct *curr,
 	printk("\nand this task is already holding:\n");
 	print_lock(prev);
 	printk("which would create a new lock dependency:\n");
-	print_lock_name(prev->class);
+	print_lock_name(hlock_class(prev));
 	printk(" ->");
-	print_lock_name(next->class);
+	print_lock_name(hlock_class(next));
 	printk("\n");
 
 	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
@@ -1146,12 +1246,12 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 
 	find_usage_bit = bit_backwards;
 	/* fills in <backwards_match> */
-	ret = find_usage_backwards(prev->class, 0);
+	ret = find_usage_backwards(hlock_class(prev), 0);
 	if (!ret || ret == 1)
 		return ret;
 
 	find_usage_bit = bit_forwards;
-	ret = find_usage_forwards(next->class, 0);
+	ret = find_usage_forwards(hlock_class(next), 0);
 	if (!ret || ret == 1)
 		return ret;
 	/* ret == 2 */
@@ -1272,18 +1372,32 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
 	       struct lockdep_map *next_instance, int read)
 {
 	struct held_lock *prev;
+	struct held_lock *nest = NULL;
 	int i;
 
 	for (i = 0; i < curr->lockdep_depth; i++) {
 		prev = curr->held_locks + i;
-		if (prev->class != next->class)
+
+		if (prev->instance == next->nest_lock)
+			nest = prev;
+
+		if (hlock_class(prev) != hlock_class(next))
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
@@ -1329,7 +1443,7 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 */
 	check_source = next;
 	check_target = prev;
-	if (!(check_noncircular(next->class, 0)))
+	if (!(check_noncircular(hlock_class(next), 0)))
 		return print_circular_bug_tail();
 
 	if (!check_prev_add_irq(curr, prev, next))
@@ -1353,8 +1467,8 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 *  chains - the second one will be new, but L1 already has
 	 *  L2 added to its dependency list, due to the first chain.)
 	 */
-	list_for_each_entry(entry, &prev->class->locks_after, entry) {
-		if (entry->class == next->class) {
+	list_for_each_entry(entry, &hlock_class(prev)->locks_after, entry) {
+		if (entry->class == hlock_class(next)) {
 			if (distance == 1)
 				entry->distance = 1;
 			return 2;
@@ -1365,26 +1479,28 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
-	ret = add_lock_to_list(prev->class, next->class,
-			       &prev->class->locks_after, next->acquire_ip, distance);
+	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
+			       &hlock_class(prev)->locks_after,
+			       next->acquire_ip, distance);
 
 	if (!ret)
 		return 0;
 
-	ret = add_lock_to_list(next->class, prev->class,
-			       &next->class->locks_before, next->acquire_ip, distance);
+	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
+			       &hlock_class(next)->locks_before,
+			       next->acquire_ip, distance);
 	if (!ret)
 		return 0;
 
 	/*
 	 * Debugging printouts:
 	 */
-	if (verbose(prev->class) || verbose(next->class)) {
+	if (verbose(hlock_class(prev)) || verbose(hlock_class(next))) {
 		graph_unlock();
 		printk("\n new dependency: ");
-		print_lock_name(prev->class);
+		print_lock_name(hlock_class(prev));
 		printk(" => ");
-		print_lock_name(next->class);
+		print_lock_name(hlock_class(next));
 		printk("\n");
 		dump_stack();
 		return graph_lock();
@@ -1481,7 +1597,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 				     struct held_lock *hlock,
 				     u64 chain_key)
 {
-	struct lock_class *class = hlock->class;
+	struct lock_class *class = hlock_class(hlock);
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 	struct held_lock *hlock_curr, *hlock_next;
@@ -1554,7 +1670,7 @@ cache_hit:
 	if (likely(cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
 		chain->base = cn;
 		for (j = 0; j < chain->depth - 1; j++, i++) {
-			int lock_id = curr->held_locks[i].class - lock_classes;
+			int lock_id = curr->held_locks[i].class_idx - 1;
 			chain_hlocks[chain->base + j] = lock_id;
 		}
 		chain_hlocks[chain->base + j] = class - lock_classes;
@@ -1650,7 +1766,7 @@ static void check_chain_key(struct task_struct *curr)
 			WARN_ON(1);
 			return;
 		}
-		id = hlock->class - lock_classes;
+		id = hlock->class_idx - 1;
 		if (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
 			return;
 
@@ -1695,7 +1811,7 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 	print_lock(this);
 
 	printk("{%s} state was registered at:\n", usage_str[prev_bit]);
-	print_stack_trace(this->class->usage_traces + prev_bit, 1);
+	print_stack_trace(hlock_class(this)->usage_traces + prev_bit, 1);
 
 	print_irqtrace_events(curr);
 	printk("\nother info that might help us debug this:\n");
@@ -1714,7 +1830,7 @@ static inline int
 valid_state(struct task_struct *curr, struct held_lock *this,
 	    enum lock_usage_bit new_bit, enum lock_usage_bit bad_bit)
 {
-	if (unlikely(this->class->usage_mask & (1 << bad_bit)))
+	if (unlikely(hlock_class(this)->usage_mask & (1 << bad_bit)))
 		return print_usage_bug(curr, this, bad_bit, new_bit);
 	return 1;
 }
@@ -1753,7 +1869,7 @@ print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe first lock's dependencies:\n");
-	print_lock_dependencies(this->class, 0);
+	print_lock_dependencies(hlock_class(this), 0);
 
 	printk("\nthe second lock's dependencies:\n");
 	print_lock_dependencies(other, 0);
@@ -1776,7 +1892,7 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 
 	find_usage_bit = bit;
 	/* fills in <forwards_match> */
-	ret = find_usage_forwards(this->class, 0);
+	ret = find_usage_forwards(hlock_class(this), 0);
 	if (!ret || ret == 1)
 		return ret;
 
@@ -1795,7 +1911,7 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 
 	find_usage_bit = bit;
 	/* fills in <backwards_match> */
-	ret = find_usage_backwards(this->class, 0);
+	ret = find_usage_backwards(hlock_class(this), 0);
 	if (!ret || ret == 1)
 		return ret;
 
@@ -1861,7 +1977,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 				LOCK_ENABLED_HARDIRQS_READ, "hard-read"))
 			return 0;
 #endif
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_SOFTIRQ:
@@ -1886,7 +2002,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 				LOCK_ENABLED_SOFTIRQS_READ, "soft-read"))
 			return 0;
 #endif
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_HARDIRQ_READ:
@@ -1899,7 +2015,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		if (!check_usage_forwards(curr, this,
 					  LOCK_ENABLED_HARDIRQS, "hard"))
 			return 0;
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_USED_IN_SOFTIRQ_READ:
@@ -1912,7 +2028,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 		if (!check_usage_forwards(curr, this,
 					  LOCK_ENABLED_SOFTIRQS, "soft"))
 			return 0;
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_HARDIRQS:
@@ -1938,7 +2054,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 				   LOCK_USED_IN_HARDIRQ_READ, "hard-read"))
 			return 0;
 #endif
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_SOFTIRQS:
@@ -1964,7 +2080,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 				   LOCK_USED_IN_SOFTIRQ_READ, "soft-read"))
 			return 0;
 #endif
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_HARDIRQS_READ:
@@ -1979,7 +2095,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 					   LOCK_USED_IN_HARDIRQ, "hard"))
 			return 0;
 #endif
-		if (hardirq_verbose(this->class))
+		if (hardirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	case LOCK_ENABLED_SOFTIRQS_READ:
@@ -1994,7 +2110,7 @@ static int mark_lock_irq(struct task_struct *curr, struct held_lock *this,
 					   LOCK_USED_IN_SOFTIRQ, "soft"))
 			return 0;
 #endif
-		if (softirq_verbose(this->class))
+		if (softirq_verbose(hlock_class(this)))
 			ret = 2;
 		break;
 	default:
@@ -2310,7 +2426,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 	 * If already set then do not dirty the cacheline,
 	 * nor do any checks:
 	 */
-	if (likely(this->class->usage_mask & new_mask))
+	if (likely(hlock_class(this)->usage_mask & new_mask))
 		return 1;
 
 	if (!graph_lock())
@@ -2318,14 +2434,14 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 	/*
 	 * Make sure we didnt race:
 	 */
-	if (unlikely(this->class->usage_mask & new_mask)) {
+	if (unlikely(hlock_class(this)->usage_mask & new_mask)) {
 		graph_unlock();
 		return 1;
 	}
 
-	this->class->usage_mask |= new_mask;
+	hlock_class(this)->usage_mask |= new_mask;
 
-	if (!save_trace(this->class->usage_traces + new_bit))
+	if (!save_trace(hlock_class(this)->usage_traces + new_bit))
 		return 0;
 
 	switch (new_bit) {
@@ -2405,7 +2521,7 @@ EXPORT_SYMBOL_GPL(lockdep_init_map);
  */
 static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 			  int trylock, int read, int check, int hardirqs_off,
-			  unsigned long ip)
+			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct lock_class *class = NULL;
@@ -2459,10 +2575,12 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		return 0;
 
 	hlock = curr->held_locks + depth;
-
-	hlock->class = class;
+	if (DEBUG_LOCKS_WARN_ON(!class))
+		return 0;
+	hlock->class_idx = class - lock_classes + 1;
 	hlock->acquire_ip = ip;
 	hlock->instance = lock;
+	hlock->nest_lock = nest_lock;
 	hlock->trylock = trylock;
 	hlock->read = read;
 	hlock->check = check;
@@ -2574,6 +2692,55 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
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
+	hlock->class_idx = class - lock_classes + 1;
+
+	curr->lockdep_depth = i;
+	curr->curr_chain_key = hlock->prev_chain_key;
+
+	for (; i < depth; i++) {
+		hlock = curr->held_locks + i;
+		if (!__lock_acquire(hlock->instance,
+			hlock_class(hlock)->subclass, hlock->trylock,
+				hlock->read, hlock->check, hlock->hardirqs_off,
+				hlock->nest_lock, hlock->acquire_ip))
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
@@ -2624,9 +2791,9 @@ found_it:
 	for (i++; i < depth; i++) {
 		hlock = curr->held_locks + i;
 		if (!__lock_acquire(hlock->instance,
-			hlock->class->subclass, hlock->trylock,
+			hlock_class(hlock)->subclass, hlock->trylock,
 				hlock->read, hlock->check, hlock->hardirqs_off,
-				hlock->acquire_ip))
+				hlock->nest_lock, hlock->acquire_ip))
 			return 0;
 	}
 
@@ -2669,7 +2836,7 @@ static int lock_release_nested(struct task_struct *curr,
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
-	hlock->class = NULL;
+	hlock->class_idx = 0;
 	hlock->acquire_ip = 0;
 	hlock->irq_context = 0;
 #endif
@@ -2738,18 +2905,36 @@ static void check_flags(unsigned long flags)
 #endif
 }
 
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
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
  */
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check, unsigned long ip)
+			  int trylock, int read, int check,
+			  struct lockdep_map *nest_lock, unsigned long ip)
 {
 	unsigned long flags;
 
-	if (unlikely(!lock_stat && !prove_locking))
-		return;
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2758,7 +2943,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 	current->lockdep_recursion = 1;
 	__lock_acquire(lock, subclass, trylock, read, check,
-		       irqs_disabled_flags(flags), ip);
+		       irqs_disabled_flags(flags), nest_lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
@@ -2770,9 +2955,6 @@ void lock_release(struct lockdep_map *lock, int nested,
 {
 	unsigned long flags;
 
-	if (unlikely(!lock_stat && !prove_locking))
-		return;
-
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2845,9 +3027,9 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 found_it:
 	hlock->waittime_stamp = sched_clock();
 
-	point = lock_contention_point(hlock->class, ip);
+	point = lock_contention_point(hlock_class(hlock), ip);
 
-	stats = get_lock_stats(hlock->class);
+	stats = get_lock_stats(hlock_class(hlock));
 	if (point < ARRAY_SIZE(stats->contention_point))
 		stats->contention_point[i]++;
 	if (lock->cpu != smp_processor_id())
@@ -2893,7 +3075,7 @@ found_it:
 		hlock->holdtime_stamp = now;
 	}
 
-	stats = get_lock_stats(hlock->class);
+	stats = get_lock_stats(hlock_class(hlock));
 	if (waittime) {
 		if (hlock->read)
 			lock_time_inc(&stats->read_waittime, waittime);
@@ -2988,6 +3170,7 @@ static void zap_class(struct lock_class *class)
 	list_del_rcu(&class->hash_entry);
 	list_del_rcu(&class->lock_entry);
 
+	class->key = NULL;
 }
 
 static inline int within(const void *addr, void *start, unsigned long size)
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index c3600a0..55db193 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -17,9 +17,6 @@
  */
 #define MAX_LOCKDEP_ENTRIES	8192UL
 
-#define MAX_LOCKDEP_KEYS_BITS	11
-#define MAX_LOCKDEP_KEYS	(1UL << MAX_LOCKDEP_KEYS_BITS)
-
 #define MAX_LOCKDEP_CHAINS_BITS	14
 #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
 
@@ -53,6 +50,9 @@ extern unsigned int nr_process_chains;
 extern unsigned int max_lockdep_depth;
 extern unsigned int max_recursion_depth;
 
+extern unsigned long lockdep_count_forward_deps(struct lock_class *);
+extern unsigned long lockdep_count_backward_deps(struct lock_class *);
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
  * Various lockdep statistics:
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 9b0e940..fa19aee 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -63,34 +63,6 @@ static void l_stop(struct seq_file *m, void *v)
 {
 }
 
-static unsigned long count_forward_deps(struct lock_class *class)
-{
-	struct lock_list *entry;
-	unsigned long ret = 1;
-
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_after, entry)
-		ret += count_forward_deps(entry->class);
-
-	return ret;
-}
-
-static unsigned long count_backward_deps(struct lock_class *class)
-{
-	struct lock_list *entry;
-	unsigned long ret = 1;
-
-	/*
-	 * Recurse this class's dependency list:
-	 */
-	list_for_each_entry(entry, &class->locks_before, entry)
-		ret += count_backward_deps(entry->class);
-
-	return ret;
-}
-
 static void print_name(struct seq_file *m, struct lock_class *class)
 {
 	char str[128];
@@ -124,10 +96,10 @@ static int l_show(struct seq_file *m, void *v)
 #ifdef CONFIG_DEBUG_LOCKDEP
 	seq_printf(m, " OPS:%8ld", class->ops);
 #endif
-	nr_forward_deps = count_forward_deps(class);
+	nr_forward_deps = lockdep_count_forward_deps(class);
 	seq_printf(m, " FD:%5ld", nr_forward_deps);
 
-	nr_backward_deps = count_backward_deps(class);
+	nr_backward_deps = lockdep_count_backward_deps(class);
 	seq_printf(m, " BD:%5ld", nr_backward_deps);
 
 	get_usage_chars(class, &c1, &c2, &c3, &c4);
@@ -229,6 +201,9 @@ static int lc_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < chain->depth; i++) {
 		class = lock_chain_get_class(chain, i);
+		if (!class->key)
+			continue;
+
 		seq_printf(m, "[%p] ", class->key);
 		print_name(m, class);
 		seq_puts(m, "\n");
@@ -350,7 +325,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		if (class->usage_mask & LOCKF_ENABLED_HARDIRQS_READ)
 			nr_hardirq_read_unsafe++;
 
-		sum_forward_deps += count_forward_deps(class);
+		sum_forward_deps += lockdep_count_forward_deps(class);
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
diff --git a/kernel/sched.c b/kernel/sched.c
index 04160d2..ace566b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -600,7 +600,6 @@ struct rq {
 	/* BKL stats */
 	unsigned int bkl_count;
 #endif
-	struct lock_class_key rq_lock_key;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2759,10 +2758,10 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 	} else {
 		if (rq1 < rq2) {
 			spin_lock(&rq1->lock);
-			spin_lock(&rq2->lock);
+			spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
 		} else {
 			spin_lock(&rq2->lock);
-			spin_lock(&rq1->lock);
+			spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 	update_rq_clock(rq1);
@@ -2805,14 +2804,21 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 		if (busiest < this_rq) {
 			spin_unlock(&this_rq->lock);
 			spin_lock(&busiest->lock);
-			spin_lock(&this_rq->lock);
+			spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			spin_lock(&busiest->lock);
+			spin_lock_nested(&busiest->lock, SINGLE_DEPTH_NESTING);
 	}
 	return ret;
 }
 
+static void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
+	__releases(busiest->lock)
+{
+	spin_unlock(&busiest->lock);
+	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+}
+
 /*
  * If dest_cpu is allowed for this process, migrate the task to it.
  * This is accomplished by forcing the cpu_allowed mask to only
@@ -3637,7 +3643,7 @@ redo:
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 					imbalance, sd, CPU_NEWLY_IDLE,
 					&all_pinned);
-		spin_unlock(&busiest->lock);
+		double_unlock_balance(this_rq, busiest);
 
 		if (unlikely(all_pinned)) {
 			cpu_clear(cpu_of(busiest), *cpus);
@@ -3752,7 +3758,7 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 		else
 			schedstat_inc(sd, alb_failed);
 	}
-	spin_unlock(&target_rq->lock);
+	double_unlock_balance(busiest_rq, target_rq);
 }
 
 #ifdef CONFIG_NO_HZ
@@ -8000,7 +8006,6 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
-		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 908c04f..6163e4c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -861,6 +861,8 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 #define RT_MAX_TRIES 3
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
+static void double_unlock_balance(struct rq *this_rq, struct rq *busiest);
+
 static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
@@ -1022,7 +1024,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 			break;
 
 		/* try again */
-		spin_unlock(&lowest_rq->lock);
+		double_unlock_balance(rq, lowest_rq);
 		lowest_rq = NULL;
 	}
 
@@ -1091,7 +1093,7 @@ static int push_rt_task(struct rq *rq)
 
 	resched_task(lowest_rq->curr);
 
-	spin_unlock(&lowest_rq->lock);
+	double_unlock_balance(rq, lowest_rq);
 
 	ret = 1;
 out:
@@ -1197,7 +1199,7 @@ static int pull_rt_task(struct rq *this_rq)
 
 		}
  skip:
-		spin_unlock(&src_rq->lock);
+		double_unlock_balance(this_rq, src_rq);
 	}
 
 	return ret;
diff --git a/kernel/smp.c b/kernel/smp.c
index 96fc7c0..782e2b9 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -135,7 +135,8 @@ void generic_smp_call_function_interrupt(void)
 			 */
 			smp_wmb();
 			data->csd.flags &= ~CSD_FLAG_WAIT;
-		} else
+		}
+		if (data->csd.flags & CSD_FLAG_ALLOC)
 			call_rcu(&data->rcu_head, rcu_free_call_data);
 	}
 	rcu_read_unlock();
@@ -260,6 +261,42 @@ void __smp_call_function_single(int cpu, struct call_single_data *data)
 	generic_exec_single(cpu, data);
 }
 
+/* Dummy function */
+static void quiesce_dummy(void *unused)
+{
+}
+
+/*
+ * Ensure stack based data used in call function mask is safe to free.
+ *
+ * This is needed by smp_call_function_mask when using on-stack data, because
+ * a single call function queue is shared by all CPUs, and any CPU may pick up
+ * the data item on the queue at any time before it is deleted. So we need to
+ * ensure that all CPUs have transitioned through a quiescent state after
+ * this call.
+ *
+ * This is a very slow function, implemented by sending synchronous IPIs to
+ * all possible CPUs. For this reason, we have to alloc data rather than use
+ * stack based data even in the case of synchronous calls. The stack based
+ * data is then just used for deadlock/oom fallback which will be very rare.
+ *
+ * If a faster scheme can be made, we could go back to preferring stack based
+ * data -- the data allocation/free is non-zero cost.
+ */
+static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
+{
+	struct call_single_data data;
+	int cpu;
+
+	data.func = quiesce_dummy;
+	data.info = NULL;
+
+	for_each_cpu_mask(cpu, mask) {
+		data.flags = CSD_FLAG_WAIT;
+		generic_exec_single(cpu, &data);
+	}
+}
+
 /**
  * smp_call_function_mask(): Run a function on a set of other CPUs.
  * @mask: The set of cpus to run on.
@@ -285,6 +322,7 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
+	int slowpath = 0;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
@@ -306,15 +344,16 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 		return smp_call_function_single(cpu, func, info, wait);
 	}
 
-	if (!wait) {
-		data = kmalloc(sizeof(*data), GFP_ATOMIC);
-		if (data)
-			data->csd.flags = CSD_FLAG_ALLOC;
-	}
-	if (!data) {
+	data = kmalloc(sizeof(*data), GFP_ATOMIC);
+	if (data) {
+		data->csd.flags = CSD_FLAG_ALLOC;
+		if (wait)
+			data->csd.flags |= CSD_FLAG_WAIT;
+	} else {
 		data = &d;
 		data->csd.flags = CSD_FLAG_WAIT;
 		wait = 1;
+		slowpath = 1;
 	}
 
 	spin_lock_init(&data->lock);
@@ -331,8 +370,11 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 	arch_send_call_function_ipi(mask);
 
 	/* optionally wait for the CPUs to complete */
-	if (wait)
+	if (wait) {
 		csd_flag_wait(&data->csd);
+		if (unlikely(slowpath))
+			smp_call_function_mask_quiesce_stack(mask);
+	}
 
 	return 0;
 }
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index a1fb54c..44baeea 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -292,6 +292,7 @@ void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 }
 
 EXPORT_SYMBOL(_spin_lock_nested);
+
 unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 {
 	unsigned long flags;
@@ -314,6 +315,16 @@ unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclas
 
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
 
+void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
+				     struct lockdep_map *nest_lock)
+{
+	preempt_disable();
+	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+EXPORT_SYMBOL(_spin_lock_nest_lock);
+
 #endif
 
 void __lockfunc _spin_unlock(spinlock_t *lock)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4a26a13..4048e92 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -290,11 +290,11 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
-		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		lock_map_acquire(&cwq->wq->lockdep_map);
+		lock_map_acquire(&lockdep_map);
 		f(work);
-		lock_release(&lockdep_map, 1, _THIS_IP_);
-		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+		lock_map_release(&lockdep_map);
+		lock_map_release(&cwq->wq->lockdep_map);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -413,8 +413,8 @@ void flush_workqueue(struct workqueue_struct *wq)
 	int cpu;
 
 	might_sleep();
-	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
+	lock_map_acquire(&wq->lockdep_map);
+	lock_map_release(&wq->lockdep_map);
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -441,8 +441,8 @@ int flush_work(struct work_struct *work)
 	if (!cwq)
 		return 0;
 
-	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_release(&cwq->wq->lockdep_map);
 
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
@@ -536,8 +536,8 @@ static void wait_on_work(struct work_struct *work)
 
 	might_sleep();
 
-	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+	lock_map_acquire(&work->lockdep_map);
+	lock_map_release(&work->lockdep_map);
 
 	cwq = get_wq_data(work);
 	if (!cwq)
@@ -872,8 +872,8 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	if (cwq->thread == NULL)
 		return;
 
-	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+	lock_map_acquire(&cwq->wq->lockdep_map);
+	lock_map_release(&cwq->wq->lockdep_map);
 
 	flush_cpu_workqueue(cwq);
 	/*
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index 0ef01d1..0218b46 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -8,6 +8,7 @@
  *
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
+#include <linux/kernel.h>
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -37,6 +38,7 @@ int debug_locks_off(void)
 {
 	if (xchg(&debug_locks, 0)) {
 		if (!debug_locks_silent) {
+			oops_in_progress = 1;
 			console_verbose();
 			return 1;
 		}
diff --git a/mm/mmap.c b/mm/mmap.c
index 971d0ed..339cf5c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2273,14 +2273,14 @@ int install_special_mapping(struct mm_struct *mm,
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
 
-static void vm_lock_anon_vma(struct anon_vma *anon_vma)
+static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
 	if (!test_bit(0, (unsigned long *) &anon_vma->head.next)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_lock(&anon_vma->lock);
+		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
 		/*
 		 * We can safely modify head.next after taking the
 		 * anon_vma->lock. If some other vma in this mm shares
@@ -2296,7 +2296,7 @@ static void vm_lock_anon_vma(struct anon_vma *anon_vma)
 	}
 }
 
-static void vm_lock_mapping(struct address_space *mapping)
+static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
 {
 	if (!test_bit(AS_MM_ALL_LOCKS, &mapping->flags)) {
 		/*
@@ -2310,7 +2310,7 @@ static void vm_lock_mapping(struct address_space *mapping)
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		spin_lock(&mapping->i_mmap_lock);
+		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
 	}
 }
 
@@ -2358,11 +2358,17 @@ int mm_take_all_locks(struct mm_struct *mm)
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (signal_pending(current))
 			goto out_unlock;
-		if (vma->anon_vma)
-			vm_lock_anon_vma(vma->anon_vma);
 		if (vma->vm_file && vma->vm_file->f_mapping)
-			vm_lock_mapping(vma->vm_file->f_mapping);
+			vm_lock_mapping(mm, vma->vm_file->f_mapping);
+	}
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (signal_pending(current))
+			goto out_unlock;
+		if (vma->anon_vma)
+			vm_lock_anon_vma(mm, vma->anon_vma);
 	}
+
 	ret = 0;
 
 out_unlock:
