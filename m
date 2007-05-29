Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbXE2NTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbXE2NTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbXE2NSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:18:42 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65098 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753920AbXE2NSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:18:40 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:18:35 EDT
Message-Id: <20070529130107.112347096@chello.nl>
References: <20070529125248.877196281@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 29 May 2007 14:52:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/5] lockstat: core infrastructure
Content-Disposition: inline; filename=lockstat-core.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the core lock statistics code.

Lock statistics provides lock wait-time and hold-time (as well as the count
of corresponding contention and acquisitions events). Also, the first few
call-sites that encounter contention are tracked.

Lock wait-time is the time spent waiting on the lock. This provides insight
into the locking scheme, that is, a heavily contended lock is indicative of
a too coarse locking scheme.

Lock hold-time is the duration the lock was held, this provides a reference for
the wait-time numbers, so they can be put into perspective.

  1)
    lock
  2)
    ... do stuff ..
    unlock
  3)

The time between 1 and 2 is the wait-time. The time between 2 and 3 is the
hold-time.

The lockdep held-lock tracking code is reused, because it already collects locks
into meaningful groups (classes), and because it is an existing infrastructure
for lock instrumentation.

Currently lockdep tracks lock acquisition with two hooks:

  lock()
    lock_acquire()
    _lock()

 ... code protected by lock ...

  unlock()
    lock_release()
    _unlock()

We need to extend this with two more hooks, in order to measure contention.

  lock_contended() - used to measure contention events
  lock_acquired()  - completion of the contention

These are then placed the following way:

  lock()
    lock_acquire()
    if (!_try_lock())
      lock_contended()
      _lock()
      lock_acquired()

 ... do locked stuff ...

  unlock()
    lock_release()
    _unlock()

(Note: the try_lock() 'trick' is used to avoid instrumenting all platform
       dependent lock primitive implementations.)

It is also possible to toggle the two lockdep features at runtime using:

  /proc/sys/kernel/prove_locking
  /proc/sys/kernel/lock_stat

(esp. turning off the O(n^2) prove_locking functionaliy can help)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/lockdep.h |   50 +++++++
 include/linux/sysctl.h  |    2 
 kernel/lockdep.c        |  314 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c         |   28 ++++
 lib/Kconfig.debug       |   11 +
 5 files changed, 404 insertions(+), 1 deletion(-)

Index: linux-2.6-git/kernel/lockdep.c
===================================================================
--- linux-2.6-git.orig/kernel/lockdep.c
+++ linux-2.6-git/kernel/lockdep.c
@@ -42,6 +42,16 @@
 
 #include "lockdep_internals.h"
 
+#ifdef CONFIG_PROVE_LOCKING
+int prove_locking = 1;
+module_param(prove_locking, int, 0644);
+#endif
+
+#ifdef CONFIG_LOCK_STAT
+int lock_stat = 1;
+module_param(lock_stat, int, 0644);
+#endif
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -123,6 +133,92 @@ static struct lock_list *alloc_list_entr
 unsigned long nr_lock_classes;
 static struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 
+#ifdef CONFIG_LOCK_STAT
+static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
+
+static int lock_contention_point(struct lock_class *class, unsigned long ip)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
+		if (class->contention_point[i] == 0) {
+			class->contention_point[i] = ip;
+			break;
+		}
+		if (class->contention_point[i] == ip)
+			break;
+	}
+
+	return i;
+}
+
+static inline void lock_time_add(struct lock_time *src, struct lock_time *dst)
+{
+	dst->min += src->min;
+	dst->max += src->max;
+	dst->total += src->total;
+	dst->nr += src->nr;
+}
+
+static void lock_time_inc(struct lock_time *lt, unsigned long long time)
+{
+	if (time > lt->max)
+		lt->max = time;
+
+	if (time < lt->min || !lt->min)
+		lt->min = time;
+
+	lt->total += time;
+	lt->nr++;
+}
+
+struct lock_class_stats lock_stats(struct lock_class *class)
+{
+	struct lock_class_stats stats;
+	int cpu, i;
+
+	memset(&stats, 0, sizeof(struct lock_class_stats));
+	for_each_possible_cpu(cpu) {
+		struct lock_class_stats *pcs =
+			&per_cpu(lock_stats, cpu)[class - lock_classes];
+
+		for (i = 0; i < ARRAY_SIZE(stats.contention_point); i++)
+			stats.contention_point[i] += pcs->contention_point[i];
+
+		lock_time_add(&pcs->read_waittime, &stats.read_waittime);
+		lock_time_add(&pcs->write_waittime, &stats.write_waittime);
+
+		lock_time_add(&pcs->read_holdtime, &stats.read_holdtime);
+		lock_time_add(&pcs->write_holdtime, &stats.write_holdtime);
+	}
+
+	return stats;
+}
+
+void clear_lock_stats(struct lock_class *class)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct lock_class_stats *cpu_stats =
+			&per_cpu(lock_stats, cpu)[class - lock_classes];
+
+		memset(cpu_stats, 0, sizeof(struct lock_class_stats));
+	}
+	memset(class->contention_point, 0, sizeof(class->contention_point));
+}
+
+static struct lock_class_stats *get_lock_stats(struct lock_class *class)
+{
+	return &get_cpu_var(lock_stats)[class - lock_classes];
+}
+
+static void put_lock_stats(struct lock_class_stats *stats)
+{
+	put_cpu_var(lock_stats);
+}
+#endif
+
 /*
  * We keep a global list of all lock classes. The list only grows,
  * never shrinks. The list is only accessed with the lockdep
@@ -2035,6 +2131,11 @@ static int __lock_acquire(struct lockdep
 	int chain_head = 0;
 	u64 chain_key;
 
+#ifdef CONFIG_PROVE_LOCKING
+	if (!prove_locking)
+		check = 1;
+#endif
+
 	if (unlikely(!debug_locks))
 		return 0;
 
@@ -2085,6 +2186,10 @@ static int __lock_acquire(struct lockdep
 	hlock->read = read;
 	hlock->check = check;
 	hlock->hardirqs_off = hardirqs_off;
+#ifdef CONFIG_LOCK_STAT
+	hlock->waittime_stamp = 0;
+	hlock->holdtime_stamp = sched_clock();
+#endif
 
 	if (check != 2)
 		goto out_calc_hash;
@@ -2132,10 +2237,11 @@ static int __lock_acquire(struct lockdep
 		}
 	}
 #endif
+out_calc_hash:
 	/* mark it as used: */
 	if (!mark_lock(curr, hlock, LOCK_USED))
 		return 0;
-out_calc_hash:
+
 	/*
 	 * Calculate the chain hash: it's the combined has of all the
 	 * lock keys along the dependency chain. We save the hash value
@@ -2183,6 +2289,7 @@ out_calc_hash:
 	chain_key = iterate_chain_key(chain_key, id);
 	curr->curr_chain_key = chain_key;
 
+#ifdef CONFIG_PROVE_LOCKING
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
 	 * does not add new dependencies, because trylock can be done
@@ -2229,6 +2336,7 @@ out_calc_hash:
 		/* after lookup_chain_cache(): */
 		if (unlikely(!debug_locks))
 			return 0;
+#endif
 
 	curr->lockdep_depth++;
 	check_chain_key(curr);
@@ -2276,6 +2384,35 @@ print_unlock_inbalance_bug(struct task_s
 	return 0;
 }
 
+#ifdef CONFIG_LOCK_STAT
+static int
+print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
+			   unsigned long ip)
+{
+	if (!debug_locks_off())
+		return 0;
+	if (debug_locks_silent)
+		return 0;
+
+	printk("\n=================================\n");
+	printk(  "[ BUG: bad contention detected! ]\n");
+	printk(  "---------------------------------\n");
+	printk("%s/%d is trying to contend lock (",
+		curr->comm, curr->pid);
+	print_lockdep_cache(lock);
+	printk(") at:\n");
+	print_ip_sym(ip);
+	printk("but there are no locks held!\n");
+	printk("\nother info that might help us debug this:\n");
+	lockdep_print_held_locks(curr);
+
+	printk("\nstack backtrace:\n");
+	dump_stack();
+
+	return 0;
+}
+#endif
+
 /*
  * Common debugging checks for both nested and non-nested unlock:
  */
@@ -2293,6 +2430,32 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+#ifdef CONFIG_LOCK_STAT
+static void lock_release_holdtime(struct held_lock *hlock)
+{
+	struct lock_class_stats *stats;
+	unsigned long long holdtime;
+
+	if (!lock_stat)
+		return;
+
+	holdtime = sched_clock() - hlock->holdtime_stamp;
+
+	stats = get_lock_stats(hlock->class);
+
+	if (hlock->read)
+		lock_time_inc(&stats->read_holdtime, holdtime);
+	else
+		lock_time_inc(&stats->write_holdtime, holdtime);
+
+	put_lock_stats(stats);
+}
+#else
+static void lock_release_holdtime(struct held_lock *hlock)
+{
+}
+#endif
+
 /*
  * Remove the lock to the list of currently held locks in a
  * potentially non-nested (out of order) manner. This is a
@@ -2330,6 +2493,8 @@ lock_release_non_nested(struct task_stru
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
+	lock_release_holdtime(hlock);
+
 	/*
 	 * We have the right lock to unlock, 'hlock' points to it.
 	 * Now we remove it from the stack, and add back the other
@@ -2382,6 +2547,8 @@ static int lock_release_nested(struct ta
 
 	curr->curr_chain_key = hlock->prev_chain_key;
 
+	lock_release_holdtime(hlock);
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
 	hlock->class = NULL;
@@ -2416,6 +2583,95 @@ __lock_release(struct lockdep_map *lock,
 	check_chain_key(curr);
 }
 
+#ifdef CONFIG_LOCK_STAT
+static void
+__lock_contended(struct lockdep_map *lock, unsigned long ip)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class_stats *stats;
+	unsigned int depth;
+	int i, point;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
+		return;
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
+	print_lock_contention_bug(curr, lock, ip);
+	return;
+
+found_it:
+	hlock->waittime_stamp = sched_clock();
+
+	point = lock_contention_point(hlock->class, ip);
+
+	stats = get_lock_stats(hlock->class);
+	if (point < ARRAY_SIZE(stats->contention_point))
+		stats->contention_point[i]++;
+	put_lock_stats(stats);
+}
+
+static void
+__lock_acquired(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	struct lock_class_stats *stats;
+	unsigned int depth;
+	unsigned long long now, waittime;
+	int i;
+
+	depth = curr->lockdep_depth;
+	if (DEBUG_LOCKS_WARN_ON(!depth))
+		return;
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
+	print_lock_contention_bug(curr, lock, _RET_IP_);
+	return;
+
+found_it:
+	if (!hlock->waittime_stamp)
+		return;
+
+	now = sched_clock();
+	waittime = now - hlock->waittime_stamp;
+
+	hlock->holdtime_stamp = now;
+
+	stats = get_lock_stats(hlock->class);
+
+	if (hlock->read)
+		lock_time_inc(&stats->read_waittime, waittime);
+	else
+		lock_time_inc(&stats->write_waittime, waittime);
+
+	put_lock_stats(stats);
+}
+#endif
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -2456,6 +2712,14 @@ void lock_acquire(struct lockdep_map *lo
 {
 	unsigned long flags;
 
+#ifdef CONFIG_LOCK_STAT
+	if (unlikely(!lock_stat))
+#endif
+#ifdef CONFIG_PROVE_LOCKING
+		if (unlikely(!prove_locking))
+#endif
+			return;
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2475,6 +2739,14 @@ void lock_release(struct lockdep_map *lo
 {
 	unsigned long flags;
 
+#ifdef CONFIG_LOCK_STAT
+	if (unlikely(!lock_stat))
+#endif
+#ifdef CONFIG_PROVE_LOCKING
+		if (unlikely(!prove_locking))
+#endif
+			return;
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2488,6 +2760,46 @@ void lock_release(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_release);
 
+#ifdef CONFIG_LOCK_STAT
+void lock_contended(struct lockdep_map *lock, unsigned long ip)
+{
+	unsigned long flags;
+
+	if (unlikely(!lock_stat))
+		return;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lock_contended(lock, ip);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lock_contended);
+
+void lock_acquired(struct lockdep_map *lock)
+{
+	unsigned long flags;
+
+	if (unlikely(!lock_stat))
+		return;
+
+	if (unlikely(current->lockdep_recursion))
+		return;
+
+	raw_local_irq_save(flags);
+	check_flags(flags);
+	current->lockdep_recursion = 1;
+	__lock_acquired(lock);
+	current->lockdep_recursion = 0;
+	raw_local_irq_restore(flags);
+}
+EXPORT_SYMBOL_GPL(lock_acquired);
+#endif
+
 /*
  * Used by the testsuite, sanitize the validator state
  * after a simulated failure:
Index: linux-2.6-git/include/linux/lockdep.h
===================================================================
--- linux-2.6-git.orig/include/linux/lockdep.h
+++ linux-2.6-git/include/linux/lockdep.h
@@ -114,8 +114,30 @@ struct lock_class {
 
 	const char			*name;
 	int				name_version;
+
+	unsigned long			contention_point[4];
+};
+
+#ifdef CONFIG_LOCK_STAT
+struct lock_time {
+	unsigned long long		min;
+	unsigned long long		max;
+	unsigned long long		total;
+	unsigned long			nr;
+};
+
+struct lock_class_stats {
+	unsigned long			contention_point[4];
+	struct lock_time		read_waittime;
+	struct lock_time		write_waittime;
+	struct lock_time		read_holdtime;
+	struct lock_time		write_holdtime;
 };
 
+struct lock_class_stats lock_stats(struct lock_class *class);
+void clear_lock_stats(struct lock_class *class);
+#endif
+
 /*
  * Map the lock object (the lock instance) to the lock-class object.
  * This is embedded into specific lock instances:
@@ -165,6 +187,10 @@ struct held_lock {
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
 
+#ifdef CONFIG_LOCK_STAT
+	unsigned long long 		waittime_stamp;
+	unsigned long long		holdtime_stamp;
+#endif
 	/*
 	 * The lock-stack is unified in that the lock chains of interrupt
 	 * contexts nest ontop of process context chains, but we 'separate'
@@ -281,6 +307,30 @@ struct lock_class_key { };
 
 #endif /* !LOCKDEP */
 
+#ifdef CONFIG_LOCK_STAT
+
+extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
+extern void lock_acquired(struct lockdep_map *lock);
+
+#define LOCK_CONTENDED(_lock, try, lock)			\
+do {								\
+	if (!try(_lock)) {					\
+		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
+		lock(_lock);					\
+		lock_acquired(&(_lock)->dep_map);		\
+	}							\
+} while (0)
+
+#else /* CONFIG_LOCK_STAT */
+
+#define lock_contended(l, i)			do { } while (0)
+#define lock_acquired(l)			do { } while (0)
+
+#define LOCK_CONTENDED(_lock, try, lock) \
+	lock(_lock)
+
+#endif /* CONFIG_LOCK_STAT */
+
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
 extern void early_init_irq_lock_class(void);
 #else
Index: linux-2.6-git/lib/Kconfig.debug
===================================================================
--- linux-2.6-git.orig/lib/Kconfig.debug
+++ linux-2.6-git/lib/Kconfig.debug
@@ -273,6 +273,17 @@ config LOCKDEP
 	select KALLSYMS
 	select KALLSYMS_ALL
 
+config LOCK_STAT
+	bool "Lock usage statisitics"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select LOCKDEP
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	select DEBUG_LOCK_ALLOC
+	default n
+	help
+	 This feature enables tracking lock contention points
+
 config DEBUG_LOCKDEP
 	bool "Lock dependency engine debugging"
 	depends on DEBUG_KERNEL && LOCKDEP
Index: linux-2.6-git/kernel/sysctl.c
===================================================================
--- linux-2.6-git.orig/kernel/sysctl.c
+++ linux-2.6-git/kernel/sysctl.c
@@ -164,6 +164,14 @@ int sysctl_legacy_va_layout;
 #endif
 
 
+#ifdef CONFIG_PROVE_LOCKING
+extern int prove_locking;
+#endif
+
+#ifdef CONFIG_LOCK_STAT
+extern int lock_stat;
+#endif
+
 /* The default sysctl tables: */
 
 static ctl_table root_table[] = {
@@ -683,6 +691,26 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		.ctl_name	= KERN_PROVE_LOCKING,
+		.procname	= "prove_locking",
+		.data		= &prove_locking,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_LOCK_STAT
+	{
+		.ctl_name	= KERN_LOCK_STAT,
+		.procname	= "lock_stat",
+		.data		= &lock_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 
 	{ .ctl_name = 0 }
 };
Index: linux-2.6-git/include/linux/sysctl.h
===================================================================
--- linux-2.6-git.orig/include/linux/sysctl.h
+++ linux-2.6-git/include/linux/sysctl.h
@@ -166,6 +166,8 @@ enum
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
 	KERN_POWEROFF_CMD=77,	/* string: poweroff command line */
+	KERN_PROVE_LOCKING=78, /* int: enable lock dependancy checking */
+	KERN_LOCK_STAT=79, /* int: enable lock statistics */
 };
 
 

--

