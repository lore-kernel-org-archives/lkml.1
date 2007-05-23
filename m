Return-Path: <linux-kernel-owner+w=401wt.eu-S1765068AbXEWKCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765068AbXEWKCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbXEWKCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631AbXEWKCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:34 -0400
Message-Id: <20070523095807.607124679@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/7] lockdep: add holdtime to the lock statistics
Content-Disposition: inline; filename=lockstat-holdtime.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Track lock hold times - that is the time we held the lock.

/proc/lock_holdtime - starts with the same three colums as lock_contentions:

  <class name> <(write) contentions> <read contentions>

After that come two times four more columns:

  <nr> <min> <max> <total>

for both (write) locks and read locks. Times are in 1e-9 seconds.
Writing a 0 to the file clears the stats.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h |    3 ++
 kernel/lockdep.c        |   32 ++++++++++++++++++++++++--
 kernel/lockdep_proc.c   |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h	2007-05-22 23:46:53.000000000 +0200
+++ linux-2.6/include/linux/lockdep.h	2007-05-22 23:47:16.000000000 +0200
@@ -134,6 +134,8 @@ struct lock_class {
 	struct lock_contention_point	contention_point[4];
 	struct lock_time		read_waittime;
 	struct lock_time		write_waittime;
+	struct lock_time		read_holdtime;
+	struct lock_time		write_holdtime;
 #endif
 };
 
@@ -188,6 +190,7 @@ struct held_lock {
 
 #ifdef CONFIG_LOCK_STAT
 	unsigned long long 		waittime_stamp;
+	unsigned long long		holdtime_stamp;
 #endif
 	/*
 	 * The lock-stack is unified in that the lock chains of interrupt
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-05-22 23:47:06.000000000 +0200
+++ linux-2.6/kernel/lockdep.c	2007-05-22 23:47:23.000000000 +0200
@@ -1283,6 +1283,8 @@ register_lock_class(struct lockdep_map *
 #ifdef CONFIG_LOCK_STAT
 	class->read_waittime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	class->write_waittime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	class->read_holdtime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	class->write_holdtime.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 #endif
 	class->name_version = count_matching_names(class);
 	/*
@@ -2087,6 +2089,7 @@ static int __lock_acquire(struct lockdep
 	hlock->hardirqs_off = hardirqs_off;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
+	hlock->holdtime_stamp = sched_clock();
 #endif
 
 	if (check != 2)
@@ -2327,6 +2330,7 @@ static int check_unlock(struct task_stru
 	return 1;
 }
 
+#ifdef CONFIG_LOCK_STAT
 static void lock_time_add(struct lock_time *lt, unsigned long long wt)
 {
 	__raw_spin_lock(&lt->lock);
@@ -2341,6 +2345,23 @@ static void lock_time_add(struct lock_ti
 	__raw_spin_unlock(&lt->lock);
 }
 
+static void lock_release_holdtime(struct held_lock *hlock)
+{
+	unsigned long long holdtime;
+
+	holdtime = sched_clock() - hlock->holdtime_stamp;
+
+	if (hlock->read)
+		lock_time_add(&hlock->class->read_holdtime, holdtime);
+	else
+		lock_time_add(&hlock->class->write_holdtime, holdtime);
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
@@ -2378,6 +2399,8 @@ lock_release_non_nested(struct task_stru
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
+	lock_release_holdtime(hlock);
+
 	/*
 	 * We have the right lock to unlock, 'hlock' points to it.
 	 * Now we remove it from the stack, and add back the other
@@ -2430,6 +2453,8 @@ static int lock_release_nested(struct ta
 
 	curr->curr_chain_key = hlock->prev_chain_key;
 
+	lock_release_holdtime(hlock);
+
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
 	hlock->class = NULL;
@@ -2519,7 +2544,7 @@ __lock_acquired(struct lockdep_map *lock
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
 	unsigned int depth;
-	unsigned long long waittime;
+	unsigned long long now, waittime;
 	int i;
 
 	depth = curr->lockdep_depth;
@@ -2545,7 +2570,10 @@ found_it:
 	if (!hlock->waittime_stamp)
 		return;
 
-	waittime = sched_clock() - hlock->waittime_stamp;
+	now = sched_clock();
+	waittime = now - hlock->waittime_stamp;
+
+	hlock->holdtime_stamp = now;
 
 	if (hlock->read)
 		lock_time_add(&hlock->class->read_waittime, waittime);
Index: linux-2.6/kernel/lockdep_proc.c
===================================================================
--- linux-2.6.orig/kernel/lockdep_proc.c	2007-05-22 23:46:53.000000000 +0200
+++ linux-2.6/kernel/lockdep_proc.c	2007-05-22 23:47:16.000000000 +0200
@@ -493,6 +493,60 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
+
+static int lock_holdtime_show(struct seq_file *m, void *v)
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
+			print_time(m, &class->write_holdtime);
+			print_time(m, &class->read_holdtime);
+			seq_printf(m, "\n");
+		}
+	}
+
+	return 0;
+}
+
+static int lock_holdtime_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, lock_holdtime_show, NULL);
+}
+
+ssize_t lock_holdtime_write(struct file *file, const char __user *buf,
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
+			clear_time(&class->read_holdtime);
+			clear_time(&class->write_holdtime);
+		}
+	}
+	return count;
+}
+
+static const struct file_operations proc_lock_holdtime_operations = {
+	.open		= lock_holdtime_open,
+	.write		= lock_holdtime_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif /* CONFIG_LOCK_STAT */
 
 static int __init lockdep_proc_init(void)
@@ -515,6 +569,10 @@ static int __init lockdep_proc_init(void
 	entry = create_proc_entry("lock_waittime", S_IRUSR, NULL);
 	if (entry)
 		entry->proc_fops = &proc_lock_waittime_operations;
+
+	entry = create_proc_entry("lock_holdtime", S_IRUSR, NULL);
+	if (entry)
+		entry->proc_fops = &proc_lock_holdtime_operations;
 #endif
 
 	return 0;

-- 

