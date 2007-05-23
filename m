Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbXEWKE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbXEWKE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765308AbXEWKCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765224AbXEWKCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:48 -0400
Message-Id: <20070523095807.407148940@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/7] lockdep: lock contention tracking
Content-Disposition: inline; filename=lockstat.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Count lock contention events per lock class. Additionally track the first four
callsites that resulted in the contention.

/proc/lock_contentions - gives a single line per lock class:

  <class name> <(write) contentions> <read contentions>

Followed by another three columns per contention point:

  <contentions from this point> <IP> <symbol name>

writing a '0' to the file will clear the stats.

example output:

[root@taijtu ~]# cat /proc/lock_contentions | sort -rnk 2 | head
dcache_lock: 3000 0 [618] [<ffffffff8033badd>] _atomic_dec_and_lock+0x39/0x58 [17] [<ffffffff802d6dce>] sysfs_open_file+0x28/0x25a [160] [<ffffffff802a5b61>] d_instantiate+0x2a/0xad [52] [<ffffffff8029d926>] __link_path_walk+0x270/0xde9
&inode->i_mutex: 235 0 [15] [<ffffffff8029b053>] pipe_read+0x74/0x39d [23] [<ffffffff8029a9f8>] pipe_wait+0x86/0x8d [105] [<ffffffff8029bc9a>] do_lookup+0x81/0x1ae [85] [<ffffffff802a0be7>] vfs_readdir+0x5c/0xa9
&zone->lru_lock: 141 0 [11] [<ffffffff8027366b>] activate_page+0x37/0xd6 [75] [<ffffffff80273327>] release_pages+0xb2/0x16c [42] [<ffffffff80273443>] __pagevec_lru_add_active+0x62/0xe5 [12] [<ffffffff80273529>] __pagevec_lru_add+0x63/0xe2
&rq->rq_lock_key: 93 0 [66] [<ffffffff8022b202>] task_rq_lock+0x42/0x74 [24] [<ffffffff80461f2a>] __sched_text_start+0x17a/0x869 [2] [<ffffffff8022a58e>] double_rq_lock+0x38/0x3d [1] [<ffffffff8022b1af>] double_lock_balance+0x41/0x52
&rq->rq_lock_key: 59 0 [15] [<ffffffff80461f2a>] __sched_text_start+0x17a/0x869 [27] [<ffffffff8022b202>] task_rq_lock+0x42/0x74 [17] [<ffffffff80462090>] __sched_text_start+0x2e0/0x869
files_lock: 57 0 [28] [<ffffffff8029581d>] file_move+0x1d/0x51 [29] [<ffffffff802957dc>] file_kill+0x15/0x39
&inode->i_data.i_mmap_lock: 52 0 [16] [<ffffffff8023149f>] copy_process+0xe10/0x1684 [5] [<ffffffff8027e38d>] vma_link+0x40/0x107 [20] [<ffffffff8027d866>] unlink_file_vma+0x2c/0x53 [11] [<ffffffff8027da53>] vma_adjust+0x154/0x452
&q->__queue_lock: 47 0 [16] [<ffffffff8033348a>] __make_request+0x5e/0x663 [4] [<ffffffff803339e8>] __make_request+0x5bc/0x663 [2] [<ffffffff803320c3>] generic_unplug_device+0x18/0x25 [1] [<ffffffff803320bb>] generic_unplug_device+0x10/0x25
&dentry->d_lock: 26 0 [22] [<ffffffff802a58be>] __d_lookup+0x7d/0x136 [4] [<ffffffff802ccd61>] dnotify_parent+0x1f/0x6d
vfsmount_lock: 17 0 [16] [<ffffffff802ab31d>] lookup_mnt+0x19/0x4c [1] [<ffffffff802a51df>] __d_path+0xae/0x14c

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |   33 ++++++++++++++++
 kernel/lockdep.c        |   95 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/lockdep_proc.c   |   79 +++++++++++++++++++++++++++++++++++++++
 kernel/mutex.c          |    7 +++
 kernel/rwsem.c          |    8 ++--
 kernel/spinlock.c       |   28 +++++++-------
 lib/Kconfig.debug       |   13 ++++++
 7 files changed, 245 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h	2007-05-22 23:29:08.000000000 +0200
+++ linux-2.6/include/linux/lockdep.h	2007-05-22 23:46:47.000000000 +0200
@@ -16,6 +16,7 @@ struct task_struct;
 #include <linux/list.h>
 #include <linux/debug_locks.h>
 #include <linux/stacktrace.h>
+#include <asm/atomic.h>
 
 /*
  * Lock-class usage-state bits:
@@ -71,6 +72,11 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+struct lock_contention_point {
+	unsigned long ip;
+	atomic_t count;
+};
+
 /*
  * The lock-class itself:
  */
@@ -114,6 +120,12 @@ struct lock_class {
 
 	const char			*name;
 	int				name_version;
+
+#ifdef CONFIG_LOCK_STAT
+	atomic_t			read_contentions;
+	atomic_t			write_contentions;
+	struct lock_contention_point	contention_point[4];
+#endif
 };
 
 /*
@@ -281,6 +293,27 @@ struct lock_class_key { };
 
 #endif /* !LOCKDEP */
 
+#ifdef CONFIG_LOCK_STAT
+
+extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
+
+#define LOCK_CONTENDED(_lock, try, lock)			\
+do {								\
+	if (!try(_lock)) {					\
+		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
+		lock(_lock);					\
+	}							\
+} while (0)
+
+#else /* CONFIG_LOCK_STAT */
+
+#define lock_contended(l, i)			do { } while (0)
+
+#define LOCK_CONTENDED(_lock, try, lock) \
+	lock(_lock)
+
+#endif /* CONFIG_LOCK_STAT */
+
 #if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_GENERIC_HARDIRQS)
 extern void early_init_irq_lock_class(void);
 #else
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-05-22 23:46:23.000000000 +0200
+++ linux-2.6/kernel/lockdep.c	2007-05-22 23:46:47.000000000 +0200
@@ -2274,6 +2274,35 @@ print_unlock_inbalance_bug(struct task_s
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
@@ -2414,6 +2443,54 @@ __lock_release(struct lockdep_map *lock,
 	check_chain_key(curr);
 }
 
+#ifdef CONFIG_LOCK_STAT
+static void
+__lock_contended(struct lockdep_map *lock, unsigned long ip)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	unsigned int depth;
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
+	print_lock_contention_bug(curr, lock, ip);
+	return;
+
+found_it:
+	if (hlock->read)
+		atomic_inc(&hlock->class->read_contentions);
+	else
+		atomic_inc(&hlock->class->write_contentions);
+
+	for (i = 0; i < ARRAY_SIZE(hlock->class->contention_point); i++) {
+		if (hlock->class->contention_point[i].ip == 0) {
+			hlock->class->contention_point[i].ip = ip;
+			atomic_set(&hlock->class->contention_point[i].count, 1);
+			break;
+		}
+		if (hlock->class->contention_point[i].ip == ip) {
+			atomic_inc(&hlock->class->contention_point[i].count);
+			break;
+		}
+	}
+}
+#endif
+
 /*
  * Check whether we follow the irq-flags state precisely:
  */
@@ -2486,6 +2563,24 @@ void lock_release(struct lockdep_map *lo
 
 EXPORT_SYMBOL_GPL(lock_release);
 
+#ifdef CONFIG_LOCK_STAT
+void lock_contended(struct lockdep_map *lock, unsigned long ip)
+{
+	unsigned long flags;
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
+#endif
+
 /*
  * Used by the testsuite, sanitize the validator state
  * after a simulated failure:
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c	2007-05-22 23:29:08.000000000 +0200
+++ linux-2.6/kernel/mutex.c	2007-05-22 23:46:47.000000000 +0200
@@ -139,6 +139,12 @@ __mutex_lock_common(struct mutex *lock, 
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
+	old_val = atomic_xchg(&lock->count, -1);
+	if (old_val == 1)
+		goto done;
+
+	lock_contended(&lock->dep_map, _RET_IP_);
+
 	for (;;) {
 		/*
 		 * Lets try to take the lock again - this is needed even if
@@ -174,6 +180,7 @@ __mutex_lock_common(struct mutex *lock, 
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
+done:
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c	2007-05-22 23:29:08.000000000 +0200
+++ linux-2.6/kernel/lockdep_proc.c	2007-05-22 23:46:47.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
+#include <asm/uaccess.h>
 
 #include "lockdep_internals.h"
 
@@ -342,6 +343,78 @@ static const struct file_operations proc
 	.release	= seq_release,
 };
 
+#ifdef CONFIG_LOCK_STAT
+static int lock_contentions_show(struct seq_file *m, void *v)
+{
+	struct lock_contention_point *cp;
+	char sym[KSYM_SYMBOL_LEN];
+	struct lock_class *class;
+	int r, w, i;
+
+	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		r = atomic_read(&class->read_contentions);
+		w = atomic_read(&class->write_contentions);
+
+		if (r || w) {
+			seq_printf(m, "%s: %d %d", class->name, w, r);
+			for (i = 0; i < ARRAY_SIZE(class->contention_point);
+					i++) {
+				cp = &class->contention_point[i];
+
+				if (cp->ip == 0)
+					break;
+				sprint_symbol(sym, cp->ip);
+				seq_printf(m, " [%d] [<%p>] %s",
+						atomic_read(&cp->count),
+						(void *)cp->ip, sym);
+			}
+			seq_printf(m, "\n");
+		}
+	}
+
+	return 0;
+}
+
+static int lock_contentions_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, lock_contentions_show, NULL);
+}
+
+ssize_t lock_contentions_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct lock_class *class;
+	char c;
+	int i;
+
+	if (count) {
+		if (get_user(c, buf))
+			return -EFAULT;
+
+		if (c != '0')
+			return count;
+
+		list_for_each_entry(class, &all_lock_classes, lock_entry) {
+			atomic_set(&class->write_contentions, 0);
+			atomic_set(&class->read_contentions, 0);
+			for (i = 0; i < ARRAY_SIZE(class->contention_point);
+					i++) {
+				class->contention_point[i].ip = 0;
+			}
+		}
+	}
+	return count;
+}
+
+static const struct file_operations proc_lock_contentions_operations = {
+	.open		= lock_contentions_open,
+	.write		= lock_contentions_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+#endif /* CONFIG_LOCK_STAT */
+
 static int __init lockdep_proc_init(void)
 {
 	struct proc_dir_entry *entry;
@@ -354,6 +427,12 @@ static int __init lockdep_proc_init(void
 	if (entry)
 		entry->proc_fops = &proc_lockdep_stats_operations;
 
+#ifdef CONFIG_LOCK_STAT
+	entry = create_proc_entry("lock_contentions", S_IRUSR, NULL);
+	if (entry)
+		entry->proc_fops = &proc_lock_contentions_operations;
+#endif
+
 	return 0;
 }
 
Index: linux-2.6/kernel/rwsem.c
===================================================================
--- linux-2.6.orig/kernel/rwsem.c	2007-05-22 23:29:08.000000000 +0200
+++ linux-2.6/kernel/rwsem.c	2007-05-22 23:46:47.000000000 +0200
@@ -20,7 +20,7 @@ void down_read(struct rw_semaphore *sem)
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
-	__down_read(sem);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
 
 EXPORT_SYMBOL(down_read);
@@ -47,7 +47,7 @@ void down_write(struct rw_semaphore *sem
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
-	__down_write(sem);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -111,7 +111,7 @@ void down_read_nested(struct rw_semaphor
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	__down_read(sem);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
 
 EXPORT_SYMBOL(down_read_nested);
@@ -130,7 +130,7 @@ void down_write_nested(struct rw_semapho
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	__down_write_nested(sem, subclass);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
 
 EXPORT_SYMBOL(down_write_nested);
Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c	2007-05-22 23:29:08.000000000 +0200
+++ linux-2.6/kernel/spinlock.c	2007-05-22 23:46:47.000000000 +0200
@@ -72,7 +72,7 @@ void __lockfunc _read_lock(rwlock_t *loc
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock);
 
@@ -89,7 +89,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_PROVE_LOCKING
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
 #endif
@@ -102,7 +102,7 @@ void __lockfunc _spin_lock_irq(spinlock_
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
 
@@ -111,7 +111,7 @@ void __lockfunc _spin_lock_bh(spinlock_t
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
 
@@ -122,7 +122,7 @@ unsigned long __lockfunc _read_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 	return flags;
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
@@ -132,7 +132,7 @@ void __lockfunc _read_lock_irq(rwlock_t 
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
 
@@ -141,7 +141,7 @@ void __lockfunc _read_lock_bh(rwlock_t *
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
 
@@ -152,7 +152,7 @@ unsigned long __lockfunc _write_lock_irq
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 	return flags;
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
@@ -162,7 +162,7 @@ void __lockfunc _write_lock_irq(rwlock_t
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
 
@@ -171,7 +171,7 @@ void __lockfunc _write_lock_bh(rwlock_t 
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
 
@@ -179,7 +179,7 @@ void __lockfunc _spin_lock(spinlock_t *l
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
 EXPORT_SYMBOL(_spin_lock);
@@ -188,7 +188,7 @@ void __lockfunc _write_lock(rwlock_t *lo
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 
 EXPORT_SYMBOL(_write_lock);
@@ -289,7 +289,7 @@ void __lockfunc _spin_lock_nested(spinlo
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
 EXPORT_SYMBOL(_spin_lock_nested);
@@ -306,7 +306,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_PROVE_SPIN_LOCKING
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
 #endif
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug	2007-05-22 23:29:08.000000000 +0200
+++ linux-2.6/lib/Kconfig.debug	2007-05-22 23:46:47.000000000 +0200
@@ -258,6 +258,17 @@ config LOCKDEP
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
@@ -442,3 +453,5 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	select FRAME_POINTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
+
+

-- 

