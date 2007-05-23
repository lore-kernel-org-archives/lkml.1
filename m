Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXEWKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXEWKD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbXEWKCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851AbXEWKCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:36 -0400
Message-Id: <20070523095807.802501556@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/7] lockdep: scalable statistics
Content-Disposition: inline; filename=lockstat-scalability.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the lock stat counters to be scalable.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |   34 +++++-----
 kernel/lockdep.c        |  162 ++++++++++++++++++++++++++++++++++++------------
 kernel/lockdep_proc.c   |  136 ++++++++++------------------------------
 3 files changed, 178 insertions(+), 154 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h	2007-05-23 10:23:16.000000000 +0200
+++ linux-2.6/include/linux/lockdep.h	2007-05-23 10:36:45.000000000 +0200
@@ -72,18 +72,6 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
-struct lock_contention_point {
-	unsigned long ip;
-	atomic_t count;
-};
-
-struct lock_time {
-	raw_spinlock_t lock;
-	unsigned long long min, max;
-	unsigned long long total;
-	unsigned long nr;
-};
-
 /*
  * The lock-class itself:
  */
@@ -128,17 +116,31 @@ struct lock_class {
 	const char			*name;
 	int				name_version;
 
+	unsigned long			contention_point[4];
+};
+
 #ifdef CONFIG_LOCK_STAT
-	atomic_t			read_contentions;
-	atomic_t			write_contentions;
-	struct lock_contention_point	contention_point[4];
+struct lock_time {
+	unsigned long long		min;
+	unsigned long long		max;
+	unsigned long long		total;
+	unsigned long			nr;
+};
+
+struct lock_class_stats {
+	unsigned long			read_contentions;
+	unsigned long			write_contentions;
+	unsigned long			contention_point[4];
 	struct lock_time		read_waittime;
 	struct lock_time		write_waittime;
 	struct lock_time		read_holdtime;
 	struct lock_time		write_holdtime;
-#endif
 };
 
+struct lock_class_stats lock_stats(struct lock_class *class);
+void clear_lock_stats(struct lock_class *class);
+#endif
+
 /*
  * Map the lock object (the lock instance) to the lock-class object.
  * This is embedded into specific lock instances:
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-05-23 10:23:16.000000000 +0200
+++ linux-2.6/kernel/lockdep.c	2007-05-23 11:50:13.000000000 +0200
@@ -133,6 +133,105 @@ static struct lock_list *alloc_list_entr
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
+static inline void lock_contention_add(struct lock_class_stats *src,
+		struct lock_class_stats *dst)
+{
+	int i;
+
+	dst->read_contentions += src->read_contentions;
+	dst->write_contentions += src->write_contentions;
+	for (i = 0; i < ARRAY_SIZE(dst->contention_point); i++)
+		dst->contention_point[i] += src->contention_point[i];
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
+		stats.read_contentions += pcs->read_contentions;
+		stats.write_contentions += pcs->write_contentions;
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
@@ -1290,12 +1389,6 @@ register_lock_class(struct lockdep_map *
 	INIT_LIST_HEAD(&class->lock_entry);
 	INIT_LIST_HEAD(&class->locks_before);
 	INIT_LIST_HEAD(&class->locks_after);
-#ifdef CONFIG_LOCK_STAT
-	class->read_waittime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-	class->write_waittime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-	class->read_holdtime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-	class->write_holdtime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-#endif
 	class->name_version = count_matching_names(class);
 	/*
 	 * We use RCU's safe list-add method to make
@@ -2349,22 +2442,9 @@ static int check_unlock(struct task_stru
 }
 
 #ifdef CONFIG_LOCK_STAT
-static void lock_time_add(struct lock_time *lt, unsigned long long wt)
-{
-	__raw_spin_lock(&lt->lock);
-	if (wt > lt->max)
-		lt->max = wt;
-
-	if (wt < lt->min || !lt->min)
-		lt->min = wt;
-
-	lt->total += wt;
-	lt->nr++;
-	__raw_spin_unlock(&lt->lock);
-}
-
 static void lock_release_holdtime(struct held_lock *hlock)
 {
+	struct lock_class_stats *stats;
 	unsigned long long holdtime;
 
 	if (!lock_stat)
@@ -2372,10 +2452,14 @@ static void lock_release_holdtime(struct
 
 	holdtime = sched_clock() - hlock->holdtime_stamp;
 
+	stats = get_lock_stats(hlock->class);
+
 	if (hlock->read)
-		lock_time_add(&hlock->class->read_holdtime, holdtime);
+		lock_time_inc(&stats->read_holdtime, holdtime);
 	else
-		lock_time_add(&hlock->class->write_holdtime, holdtime);
+		lock_time_inc(&stats->write_holdtime, holdtime);
+
+	put_lock_stats(stats);
 }
 #else
 static void lock_release_holdtime(struct held_lock *hlock)
@@ -2516,8 +2600,9 @@ __lock_contended(struct lockdep_map *loc
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
+	struct lock_class_stats *stats;
 	unsigned int depth;
-	int i;
+	int i, point;
 
 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -2541,22 +2626,18 @@ __lock_contended(struct lockdep_map *loc
 found_it:
 	hlock->waittime_stamp = sched_clock();
 
+	point = lock_contention_point(hlock->class, ip);
+
+	stats = get_lock_stats(hlock->class);
+	if (point < ARRAY_SIZE(stats->contention_point))
+		stats->contention_point[i]++;
+
 	if (hlock->read)
-		atomic_inc(&hlock->class->read_contentions);
+		stats->read_contentions++;
 	else
-		atomic_inc(&hlock->class->write_contentions);
+		stats->write_contentions++;
 
-	for (i = 0; i < ARRAY_SIZE(hlock->class->contention_point); i++) {
-		if (hlock->class->contention_point[i].ip == 0) {
-			hlock->class->contention_point[i].ip = ip;
-			atomic_set(&hlock->class->contention_point[i].count, 1);
-			break;
-		}
-		if (hlock->class->contention_point[i].ip == ip) {
-			atomic_inc(&hlock->class->contention_point[i].count);
-			break;
-		}
-	}
+	put_lock_stats(stats);
 }
 
 static void
@@ -2564,6 +2645,7 @@ __lock_acquired(struct lockdep_map *lock
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
+	struct lock_class_stats *stats;
 	unsigned int depth;
 	unsigned long long now, waittime;
 	int i;
@@ -2596,10 +2678,14 @@ found_it:
 
 	hlock->holdtime_stamp = now;
 
+	stats = get_lock_stats(hlock->class);
+
 	if (hlock->read)
-		lock_time_add(&hlock->class->read_waittime, waittime);
+		lock_time_inc(&stats->read_waittime, waittime);
 	else
-		lock_time_add(&hlock->class->write_waittime, waittime);
+		lock_time_inc(&stats->write_waittime, waittime);
+
+	put_lock_stats(stats);
 }
 #endif
 
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c	2007-05-23 10:23:16.000000000 +0200
+++ linux-2.6/kernel/lockdep_proc.c	2007-05-23 10:36:45.000000000 +0200
@@ -347,27 +347,28 @@ static const struct file_operations proc
 #ifdef CONFIG_LOCK_STAT
 static int lock_contentions_show(struct seq_file *m, void *v)
 {
-	struct lock_contention_point *cp;
 	char sym[KSYM_SYMBOL_LEN];
 	struct lock_class *class;
-	int r, w, i;
+	struct lock_class_stats stats;
+	int i;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		r = atomic_read(&class->read_contentions);
-		w = atomic_read(&class->write_contentions);
+		stats = lock_stats(class);
+
+		if (stats.read_contentions || stats.write_contentions) {
+			seq_printf(m, "%s: %lu %lu", class->name,
+					stats.write_contentions,
+					stats.read_contentions);
 
-		if (r || w) {
-			seq_printf(m, "%s: %d %d", class->name, w, r);
 			for (i = 0; i < ARRAY_SIZE(class->contention_point);
 					i++) {
-				cp = &class->contention_point[i];
-
-				if (cp->ip == 0)
+				if (class->contention_point[i] == 0)
 					break;
-				sprint_symbol(sym, cp->ip);
-				seq_printf(m, " [%d] [<%p>] %s",
-						atomic_read(&cp->count),
-						(void *)cp->ip, sym);
+				sprint_symbol(sym, class->contention_point[i]);
+				seq_printf(m, " %lu [<%p>] %s",
+					stats.contention_point[i],
+					(void *)class->contention_point[i],
+					sym);
 			}
 			seq_printf(m, "\n");
 		}
@@ -395,14 +396,8 @@ ssize_t lock_contentions_write(struct fi
 		if (c != '0')
 			return count;
 
-		list_for_each_entry(class, &all_lock_classes, lock_entry) {
-			atomic_set(&class->write_contentions, 0);
-			atomic_set(&class->read_contentions, 0);
-			for (i = 0; i < ARRAY_SIZE(class->contention_point);
-					i++) {
-				class->contention_point[i].ip = 0;
-			}
-		}
+		list_for_each_entry(class, &all_lock_classes, lock_entry)
+			clear_lock_stats(class);
 	}
 	return count;
 }
@@ -417,42 +412,24 @@ static const struct file_operations proc
 
 static void print_time(struct seq_file *m, struct lock_time *lt)
 {
-	unsigned long long min, total, max;
-	unsigned long nr;
-
-	__raw_spin_lock(&lt->lock);
-	min = lt->min;
-	total = lt->total;
-	max = lt->max;
-	nr = lt->nr;
-	__raw_spin_unlock(&lt->lock);
-
-	seq_printf(m, " %lu %llu %llu %llu", nr, min, max, total);
-}
-
-static void clear_time(struct lock_time *lt)
-{
-	__raw_spin_lock(&lt->lock);
-	lt->min = 0;
-	lt->total = 0;
-	lt->max = 0;
-	lt->nr = 0;
-	__raw_spin_unlock(&lt->lock);
+	seq_printf(m, " %lu %llu %llu %llu",
+			lt->nr, lt->min, lt->max, lt->total);
 }
 
 static int lock_waittime_show(struct seq_file *m, void *v)
 {
 	struct lock_class *class;
-	int r, w;
+	struct lock_class_stats stats;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		r = atomic_read(&class->read_contentions);
-		w = atomic_read(&class->write_contentions);
+		stats = lock_stats(class);
 
-		if (r || w) {
-			seq_printf(m, "%s: %d %d", class->name, w, r);
-			print_time(m, &class->write_waittime);
-			print_time(m, &class->read_waittime);
+		if (stats.read_contentions || stats.write_contentions) {
+			seq_printf(m, "%s: %lu %lu", class->name,
+					stats.write_contentions,
+					stats.read_contentions);
+			print_time(m, &stats.write_waittime);
+			print_time(m, &stats.read_waittime);
 			seq_printf(m, "\n");
 		}
 	}
@@ -465,30 +442,9 @@ static int lock_waittime_open(struct ino
 	return single_open(file, lock_waittime_show, NULL);
 }
 
-ssize_t lock_waittime_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct lock_class *class;
-	char c;
-
-	if (count) {
-		if (get_user(c, buf))
-			return -EFAULT;
-
-		if (c != '0')
-			return count;
-
-		list_for_each_entry(class, &all_lock_classes, lock_entry) {
-			clear_time(&class->read_waittime);
-			clear_time(&class->write_waittime);
-		}
-	}
-	return count;
-}
-
 static const struct file_operations proc_lock_waittime_operations = {
 	.open		= lock_waittime_open,
-	.write		= lock_waittime_write,
+	.write		= lock_contentions_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
@@ -497,16 +453,17 @@ static const struct file_operations proc
 static int lock_holdtime_show(struct seq_file *m, void *v)
 {
 	struct lock_class *class;
-	int r, w;
+	struct lock_class_stats stats;
 
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
-		r = atomic_read(&class->read_contentions);
-		w = atomic_read(&class->write_contentions);
+		stats = lock_stats(class);
 
-		if (r || w) {
-			seq_printf(m, "%s: %d %d", class->name, w, r);
-			print_time(m, &class->write_holdtime);
-			print_time(m, &class->read_holdtime);
+		if (stats.read_contentions || stats.write_contentions) {
+			seq_printf(m, "%s: %lu %lu", class->name,
+					stats.write_contentions,
+					stats.read_contentions);
+			print_time(m, &stats.write_holdtime);
+			print_time(m, &stats.read_holdtime);
 			seq_printf(m, "\n");
 		}
 	}
@@ -519,30 +476,9 @@ static int lock_holdtime_open(struct ino
 	return single_open(file, lock_holdtime_show, NULL);
 }
 
-ssize_t lock_holdtime_write(struct file *file, const char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct lock_class *class;
-	char c;
-
-	if (count) {
-		if (get_user(c, buf))
-			return -EFAULT;
-
-		if (c != '0')
-			return count;
-
-		list_for_each_entry(class, &all_lock_classes, lock_entry) {
-			clear_time(&class->read_holdtime);
-			clear_time(&class->write_holdtime);
-		}
-	}
-	return count;
-}
-
 static const struct file_operations proc_lock_holdtime_operations = {
 	.open		= lock_holdtime_open,
-	.write		= lock_holdtime_write,
+	.write		= lock_contentions_write,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release,

-- 

