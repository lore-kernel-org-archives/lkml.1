Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbXEWKEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbXEWKEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764050AbXEWKCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765119AbXEWKCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:44 -0400
Message-Id: <20070523095807.537186733@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:20 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/7] lockdep: add waittime to the lock statistics
Content-Disposition: inline; filename=lockstat-waittime.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Track lock waittime - that is the time spend waiting on lock acquisition.

/proc/lock_waittime - starts with the same three colums as lock_contentions:

  <class name> <(write) contentions> <read contentions>

After that come two times four more columns:

  <nr> <min> <max> <total>

for both (write) contentions and read contentions. Times are in 1e-9 seconds.
Writing a 0 to the file clears the stats.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |   15 ++++++++
 kernel/lockdep.c        |   79 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/lockdep_proc.c   |   84 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/mutex.c          |    1 
 4 files changed, 179 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h	2007-05-22 23:46:47.000000000 +0200
+++ linux-2.6/include/linux/lockdep.h	2007-05-22 23:46:53.000000000 +0200
@@ -77,6 +77,13 @@ struct lock_contention_point {
 	atomic_t count;
 };
 
+struct lock_time {
+	raw_spinlock_t lock;
+	unsigned long long min, max;
+	unsigned long long total;
+	unsigned long nr;
+};
+
 /*
  * The lock-class itself:
  */
@@ -125,6 +132,8 @@ struct lock_class {
 	atomic_t			read_contentions;
 	atomic_t			write_contentions;
 	struct lock_contention_point	contention_point[4];
+	struct lock_time		read_waittime;
+	struct lock_time		write_waittime;
 #endif
 };
 
@@ -177,6 +186,9 @@ struct held_lock {
 	unsigned long			acquire_ip;
 	struct lockdep_map		*instance;
 
+#ifdef CONFIG_LOCK_STAT
+	unsigned long long 		waittime_stamp;
+#endif
 	/*
 	 * The lock-stack is unified in that the lock chains of interrupt
 	 * contexts nest ontop of process context chains, but we 'separate'
@@ -296,18 +308,21 @@ struct lock_class_key { };
 #ifdef CONFIG_LOCK_STAT
 
 extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
+extern void lock_acquired(struct lockdep_map *lock);
 
 #define LOCK_CONTENDED(_lock, try, lock)			\
 do {								\
 	if (!try(_lock)) {					\
 		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
 		lock(_lock);					\
+		lock_acquired(&(_lock)->dep_map);		\
 	}							\
 } while (0)
 
 #else /* CONFIG_LOCK_STAT */
 
 #define lock_contended(l, i)			do { } while (0)
+#define lock_acquired(l)			do { } while (0)
 
 #define LOCK_CONTENDED(_lock, try, lock) \
 	lock(_lock)
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-05-22 23:46:47.000000000 +0200
+++ linux-2.6/kernel/lockdep.c	2007-05-22 23:47:06.000000000 +0200
@@ -1280,6 +1280,10 @@ register_lock_class(struct lockdep_map *
 	INIT_LIST_HEAD(&class->lock_entry);
 	INIT_LIST_HEAD(&class->locks_before);
 	INIT_LIST_HEAD(&class->locks_after);
+#ifdef CONFIG_LOCK_STAT
+	class->read_waittime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	class->write_waittime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+#endif
 	class->name_version = count_matching_names(class);
 	/*
 	 * We use RCU's safe list-add method to make
@@ -2081,6 +2085,9 @@ static int __lock_acquire(struct lockdep
 	hlock->read = read;
 	hlock->check = check;
 	hlock->hardirqs_off = hardirqs_off;
+#ifdef CONFIG_LOCK_STAT
+	hlock->waittime_stamp = 0;
+#endif
 
 	if (check != 2)
 		goto out_calc_hash;
@@ -2320,6 +2327,20 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+static void lock_time_add(struct lock_time *lt, unsigned long long wt)
+{
+	__raw_spin_lock(&lt->lock);
+	if (wt > lt->max)
+		lt->max = wt;
+
+	if (wt < lt->min || !lt->min)
+		lt->min = wt;
+
+	lt->total += wt;
+	lt->nr++;
+	__raw_spin_unlock(&lt->lock);
+}
+
 /*
  * Remove the lock to the list of currently held locks in a
  * potentially non-nested (out of order) manner. This is a
@@ -2472,6 +2493,8 @@ __lock_contended(struct lockdep_map *loc
 	return;
 
 found_it:
+	hlock->waittime_stamp = sched_clock();
+
 	if (hlock->read)
 		atomic_inc(&hlock->class->read_contentions);
 	else
@@ -2489,6 +2512,46 @@ found_it:
 		}
 	}
 }
+
+static void
+__lock_acquired(struct lockdep_map *lock)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock, *prev_hlock;
+	unsigned int depth;
+	unsigned long long waittime;
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
+	waittime = sched_clock() - hlock->waittime_stamp;
+
+	if (hlock->read)
+		lock_time_add(&hlock->class->read_waittime, waittime);
+	else
+		lock_time_add(&hlock->class->write_waittime, waittime);
+}
 #endif
 
 /*
@@ -2579,6 +2642,22 @@ void lock_contended(struct lockdep_map *
 	raw_local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(lock_contended);
+
+void lock_acquired(struct lockdep_map *lock)
+{
+	unsigned long flags;
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
 #endif
 
 /*
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c	2007-05-22 23:46:47.000000000 +0200
+++ linux-2.6/kernel/lockdep_proc.c	2007-05-22 23:46:53.000000000 +0200
@@ -16,6 +16,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <asm/uaccess.h>
+#include <asm/div64.h>
 
 #include "lockdep_internals.h"
 
@@ -413,6 +414,85 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
+
+static void print_time(struct seq_file *m, struct lock_time *lt)
+{
+	unsigned long long min, total, max;
+	unsigned long nr;
+
+	__raw_spin_lock(&lt->lock);
+	min = lt->min;
+	total = lt->total;
+	max = lt->max;
+	nr = lt->nr;
+	__raw_spin_unlock(&lt->lock);
+
+	seq_printf(m, " %lu %llu %llu %llu", nr, min, max, total);
+}
+
+static void clear_time(struct lock_time *lt)
+{
+	__raw_spin_lock(&lt->lock);
+	lt->min = 0;
+	lt->total = 0;
+	lt->max = 0;
+	lt->nr = 0;
+	__raw_spin_unlock(&lt->lock);
+}
+
+static int lock_waittime_show(struct seq_file *m, void *v)
+{
+	struct lock_class *class;
+	int r, w;
+
+	list_for_each_entry(class, &all_lock_classes, lock_entry) {
+		r = atomic_read(&class->read_contentions);
+		w = atomic_read(&class->write_contentions);
+
+		if (r || w) {
+			seq_printf(m, "%s: %d %d", class->name, w, r);
+			print_time(m, &class->write_waittime);
+			print_time(m, &class->read_waittime);
+			seq_printf(m, "\n");
+		}
+	}
+
+	return 0;
+}
+
+static int lock_waittime_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, lock_waittime_show, NULL);
+}
+
+ssize_t lock_waittime_write(struct file *file, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct lock_class *class;
+	char c;
+
+	if (count) {
+		if (get_user(c, buf))
+			return -EFAULT;
+
+		if (c != '0')
+			return count;
+
+		list_for_each_entry(class, &all_lock_classes, lock_entry) {
+			clear_time(&class->read_waittime);
+			clear_time(&class->write_waittime);
+		}
+	}
+	return count;
+}
+
+static const struct file_operations proc_lock_waittime_operations = {
+	.open		= lock_waittime_open,
+	.write		= lock_waittime_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif /* CONFIG_LOCK_STAT */
 
 static int __init lockdep_proc_init(void)
@@ -431,6 +511,10 @@ static int __init lockdep_proc_init(void
 	entry = create_proc_entry("lock_contentions", S_IRUSR, NULL);
 	if (entry)
 		entry->proc_fops = &proc_lock_contentions_operations;
+
+	entry = create_proc_entry("lock_waittime", S_IRUSR, NULL);
+	if (entry)
+		entry->proc_fops = &proc_lock_waittime_operations;
 #endif
 
 	return 0;
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c	2007-05-22 23:46:47.000000000 +0200
+++ linux-2.6/kernel/mutex.c	2007-05-22 23:46:53.000000000 +0200
@@ -180,6 +180,7 @@ __mutex_lock_common(struct mutex *lock, 
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
+	lock_acquired(&lock->dep_map);
 done:
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));

-- 

