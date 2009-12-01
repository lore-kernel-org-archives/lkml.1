Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZLAPhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZLAPhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZLAPhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:37:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZLAPhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:37:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, steved@redhat.com, jens.axboe@oracle.com,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: [PATCH] SLOW_WORK: Move slow_work's proc file to debugfs
Date: Tue, 01 Dec 2009 15:36:11 +0000
Message-ID: <6941.1259681771@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move slow_work's debugging proc file to debugfs.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |    4 -
 include/linux/slow-work.h   |    8 +-
 init/Kconfig                |    8 +-
 kernel/Makefile             |    2 
 kernel/slow-work-debugfs.c  |  227 +++++++++++++++++++++++++++++++++++++++++++
 kernel/slow-work-proc.c     |  227 -------------------------------------------
 kernel/slow-work.c          |   18 ++-
 kernel/slow-work.h          |    6 +
 8 files changed, 253 insertions(+), 247 deletions(-)
 create mode 100644 kernel/slow-work-debugfs.c
 delete mode 100644 kernel/slow-work-proc.c


diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index 52bc314..9dbf447 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -279,9 +279,9 @@ The slow-work thread pool has a number of configurables:
 VIEWING EXECUTING AND QUEUED ITEMS
 ==================================
 
-If CONFIG_SLOW_WORK_PROC is enabled, a proc file is made available:
+If CONFIG_SLOW_WORK_DEBUG is enabled, a debugfs file is made available:
 
-	/proc/slow_work_rq
+	/sys/kernel/debug/slow_work/runqueue
 
 through which the list of work items being executed and the queues of items to
 be executed may be viewed.  The owner of a work item is given the chance to
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index 5035a26..13337bf 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -20,7 +20,7 @@
 #include <linux/timer.h>
 
 struct slow_work;
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 struct seq_file;
 #endif
 
@@ -42,8 +42,8 @@ struct slow_work_ops {
 	/* execute a work item */
 	void (*execute)(struct slow_work *work);
 
-#ifdef CONFIG_SLOW_WORK_PROC
-	/* describe a work item for /proc */
+#ifdef CONFIG_SLOW_WORK_DEBUG
+	/* describe a work item for debugfs */
 	void (*desc)(struct slow_work *work, struct seq_file *m);
 #endif
 };
@@ -64,7 +64,7 @@ struct slow_work {
 #define SLOW_WORK_DELAYED	5	/* item is struct delayed_slow_work with active timer */
 	const struct slow_work_ops *ops; /* operations table for this item */
 	struct list_head	link;	/* link in queue */
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	struct timespec		mark;	/* jiffies at which queued or exec begun */
 #endif
 };
diff --git a/init/Kconfig b/init/Kconfig
index ab5c648..39923cc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1098,12 +1098,12 @@ config SLOW_WORK
 
 	  See Documentation/slow-work.txt.
 
-config SLOW_WORK_PROC
-	bool "Slow work debugging through /proc"
+config SLOW_WORK_DEBUG
+	bool "Slow work debugging through debugfs"
 	default n
-	depends on SLOW_WORK && PROC_FS
+	depends on SLOW_WORK && DEBUG_FS
 	help
-	  Display the contents of the slow work run queue through /proc,
+	  Display the contents of the slow work run queue through debugfs,
 	  including items currently executing.
 
 	  See Documentation/slow-work.txt.
diff --git a/kernel/Makefile b/kernel/Makefile
index 776ffed..d7c13d2 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -94,7 +94,7 @@ obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
-obj-$(CONFIG_SLOW_WORK_PROC) += slow-work-proc.o
+obj-$(CONFIG_SLOW_WORK_DEBUG) += slow-work-debugfs.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
diff --git a/kernel/slow-work-debugfs.c b/kernel/slow-work-debugfs.c
new file mode 100644
index 0000000..e45c436
--- /dev/null
+++ b/kernel/slow-work-debugfs.c
@@ -0,0 +1,227 @@
+/* Slow work debugging
+ *
+ * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slow-work.h>
+#include <linux/fs.h>
+#include <linux/time.h>
+#include <linux/seq_file.h>
+#include "slow-work.h"
+
+#define ITERATOR_SHIFT		(BITS_PER_LONG - 4)
+#define ITERATOR_SELECTOR	(0xfUL << ITERATOR_SHIFT)
+#define ITERATOR_COUNTER	(~ITERATOR_SELECTOR)
+
+void slow_work_new_thread_desc(struct slow_work *work, struct seq_file *m)
+{
+	seq_puts(m, "Slow-work: New thread");
+}
+
+/*
+ * Render the time mark field on a work item into a 5-char time with units plus
+ * a space
+ */
+static void slow_work_print_mark(struct seq_file *m, struct slow_work *work)
+{
+	struct timespec now, diff;
+
+	now = CURRENT_TIME;
+	diff = timespec_sub(now, work->mark);
+
+	if (diff.tv_sec < 0)
+		seq_puts(m, "  -ve ");
+	else if (diff.tv_sec == 0 && diff.tv_nsec < 1000)
+		seq_printf(m, "%3luns ", diff.tv_nsec);
+	else if (diff.tv_sec == 0 && diff.tv_nsec < 1000000)
+		seq_printf(m, "%3luus ", diff.tv_nsec / 1000);
+	else if (diff.tv_sec == 0 && diff.tv_nsec < 1000000000)
+		seq_printf(m, "%3lums ", diff.tv_nsec / 1000000);
+	else if (diff.tv_sec <= 1)
+		seq_puts(m, "   1s ");
+	else if (diff.tv_sec < 60)
+		seq_printf(m, "%4lus ", diff.tv_sec);
+	else if (diff.tv_sec < 60 * 60)
+		seq_printf(m, "%4lum ", diff.tv_sec / 60);
+	else if (diff.tv_sec < 60 * 60 * 24)
+		seq_printf(m, "%4luh ", diff.tv_sec / 3600);
+	else
+		seq_puts(m, "exces ");
+}
+
+/*
+ * Describe a slow work item for debugfs
+ */
+static int slow_work_runqueue_show(struct seq_file *m, void *v)
+{
+	struct slow_work *work;
+	struct list_head *p = v;
+	unsigned long id;
+
+	switch ((unsigned long) v) {
+	case 1:
+		seq_puts(m, "THR PID   ITEM ADDR        FL MARK  DESC\n");
+		return 0;
+	case 2:
+		seq_puts(m, "=== ===== ================ == ===== ==========\n");
+		return 0;
+
+	case 3 ... 3 + SLOW_WORK_THREAD_LIMIT - 1:
+		id = (unsigned long) v - 3;
+
+		read_lock(&slow_work_execs_lock);
+		work = slow_work_execs[id];
+		if (work) {
+			smp_read_barrier_depends();
+
+			seq_printf(m, "%3lu %5d %16p %2lx ",
+				   id, slow_work_pids[id], work, work->flags);
+			slow_work_print_mark(m, work);
+
+			if (work->ops->desc)
+				work->ops->desc(work, m);
+			seq_putc(m, '\n');
+		}
+		read_unlock(&slow_work_execs_lock);
+		return 0;
+
+	default:
+		work = list_entry(p, struct slow_work, link);
+		seq_printf(m, "%3s     - %16p %2lx ",
+			   work->flags & SLOW_WORK_VERY_SLOW ? "vsq" : "sq",
+			   work, work->flags);
+		slow_work_print_mark(m, work);
+
+		if (work->ops->desc)
+			work->ops->desc(work, m);
+		seq_putc(m, '\n');
+		return 0;
+	}
+}
+
+/*
+ * map the iterator to a work item
+ */
+static void *slow_work_runqueue_index(struct seq_file *m, loff_t *_pos)
+{
+	struct list_head *p;
+	unsigned long count, id;
+
+	switch (*_pos >> ITERATOR_SHIFT) {
+	case 0x0:
+		if (*_pos == 0)
+			*_pos = 1;
+		if (*_pos < 3)
+			return (void *)(unsigned long) *_pos;
+		if (*_pos < 3 + SLOW_WORK_THREAD_LIMIT)
+			for (id = *_pos - 3;
+			     id < SLOW_WORK_THREAD_LIMIT;
+			     id++, (*_pos)++)
+				if (slow_work_execs[id])
+					return (void *)(unsigned long) *_pos;
+		*_pos = 0x1UL << ITERATOR_SHIFT;
+
+	case 0x1:
+		count = *_pos & ITERATOR_COUNTER;
+		list_for_each(p, &slow_work_queue) {
+			if (count == 0)
+				return p;
+			count--;
+		}
+		*_pos = 0x2UL << ITERATOR_SHIFT;
+
+	case 0x2:
+		count = *_pos & ITERATOR_COUNTER;
+		list_for_each(p, &vslow_work_queue) {
+			if (count == 0)
+				return p;
+			count--;
+		}
+		*_pos = 0x3UL << ITERATOR_SHIFT;
+
+	default:
+		return NULL;
+	}
+}
+
+/*
+ * set up the iterator to start reading from the first line
+ */
+static void *slow_work_runqueue_start(struct seq_file *m, loff_t *_pos)
+{
+	spin_lock_irq(&slow_work_queue_lock);
+	return slow_work_runqueue_index(m, _pos);
+}
+
+/*
+ * move to the next line
+ */
+static void *slow_work_runqueue_next(struct seq_file *m, void *v, loff_t *_pos)
+{
+	struct list_head *p = v;
+	unsigned long selector = *_pos >> ITERATOR_SHIFT;
+
+	(*_pos)++;
+	switch (selector) {
+	case 0x0:
+		return slow_work_runqueue_index(m, _pos);
+
+	case 0x1:
+		if (*_pos >> ITERATOR_SHIFT == 0x1) {
+			p = p->next;
+			if (p != &slow_work_queue)
+				return p;
+		}
+		*_pos = 0x2UL << ITERATOR_SHIFT;
+		p = &vslow_work_queue;
+
+	case 0x2:
+		if (*_pos >> ITERATOR_SHIFT == 0x2) {
+			p = p->next;
+			if (p != &vslow_work_queue)
+				return p;
+		}
+		*_pos = 0x3UL << ITERATOR_SHIFT;
+
+	default:
+		return NULL;
+	}
+}
+
+/*
+ * clean up after reading
+ */
+static void slow_work_runqueue_stop(struct seq_file *m, void *v)
+{
+	spin_unlock_irq(&slow_work_queue_lock);
+}
+
+static const struct seq_operations slow_work_runqueue_ops = {
+	.start		= slow_work_runqueue_start,
+	.stop		= slow_work_runqueue_stop,
+	.next		= slow_work_runqueue_next,
+	.show		= slow_work_runqueue_show,
+};
+
+/*
+ * open "/sys/kernel/debug/slow_work/runqueue" to list queue contents
+ */
+static int slow_work_runqueue_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &slow_work_runqueue_ops);
+}
+
+const struct file_operations slow_work_runqueue_fops = {
+	.owner		= THIS_MODULE,
+	.open		= slow_work_runqueue_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
diff --git a/kernel/slow-work-proc.c b/kernel/slow-work-proc.c
deleted file mode 100644
index 3988032..0000000
--- a/kernel/slow-work-proc.c
+++ /dev/null
@@ -1,227 +0,0 @@
-/* Slow work debugging
- *
- * Copyright (C) 2009 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/slow-work.h>
-#include <linux/fs.h>
-#include <linux/time.h>
-#include <linux/seq_file.h>
-#include "slow-work.h"
-
-#define ITERATOR_SHIFT		(BITS_PER_LONG - 4)
-#define ITERATOR_SELECTOR	(0xfUL << ITERATOR_SHIFT)
-#define ITERATOR_COUNTER	(~ITERATOR_SELECTOR)
-
-void slow_work_new_thread_desc(struct slow_work *work, struct seq_file *m)
-{
-	seq_puts(m, "Slow-work: New thread");
-}
-
-/*
- * Render the time mark field on a work item into a 5-char time with units plus
- * a space
- */
-static void slow_work_print_mark(struct seq_file *m, struct slow_work *work)
-{
-	struct timespec now, diff;
-
-	now = CURRENT_TIME;
-	diff = timespec_sub(now, work->mark);
-
-	if (diff.tv_sec < 0)
-		seq_puts(m, "  -ve ");
-	else if (diff.tv_sec == 0 && diff.tv_nsec < 1000)
-		seq_printf(m, "%3luns ", diff.tv_nsec);
-	else if (diff.tv_sec == 0 && diff.tv_nsec < 1000000)
-		seq_printf(m, "%3luus ", diff.tv_nsec / 1000);
-	else if (diff.tv_sec == 0 && diff.tv_nsec < 1000000000)
-		seq_printf(m, "%3lums ", diff.tv_nsec / 1000000);
-	else if (diff.tv_sec <= 1)
-		seq_puts(m, "   1s ");
-	else if (diff.tv_sec < 60)
-		seq_printf(m, "%4lus ", diff.tv_sec);
-	else if (diff.tv_sec < 60 * 60)
-		seq_printf(m, "%4lum ", diff.tv_sec / 60);
-	else if (diff.tv_sec < 60 * 60 * 24)
-		seq_printf(m, "%4luh ", diff.tv_sec / 3600);
-	else
-		seq_puts(m, "exces ");
-}
-
-/*
- * Describe a slow work item for /proc
- */
-static int slow_work_runqueue_show(struct seq_file *m, void *v)
-{
-	struct slow_work *work;
-	struct list_head *p = v;
-	unsigned long id;
-
-	switch ((unsigned long) v) {
-	case 1:
-		seq_puts(m, "THR PID   ITEM ADDR        FL MARK  DESC\n");
-		return 0;
-	case 2:
-		seq_puts(m, "=== ===== ================ == ===== ==========\n");
-		return 0;
-
-	case 3 ... 3 + SLOW_WORK_THREAD_LIMIT - 1:
-		id = (unsigned long) v - 3;
-
-		read_lock(&slow_work_execs_lock);
-		work = slow_work_execs[id];
-		if (work) {
-			smp_read_barrier_depends();
-
-			seq_printf(m, "%3lu %5d %16p %2lx ",
-				   id, slow_work_pids[id], work, work->flags);
-			slow_work_print_mark(m, work);
-
-			if (work->ops->desc)
-				work->ops->desc(work, m);
-			seq_putc(m, '\n');
-		}
-		read_unlock(&slow_work_execs_lock);
-		return 0;
-
-	default:
-		work = list_entry(p, struct slow_work, link);
-		seq_printf(m, "%3s     - %16p %2lx ",
-			   work->flags & SLOW_WORK_VERY_SLOW ? "vsq" : "sq",
-			   work, work->flags);
-		slow_work_print_mark(m, work);
-
-		if (work->ops->desc)
-			work->ops->desc(work, m);
-		seq_putc(m, '\n');
-		return 0;
-	}
-}
-
-/*
- * map the iterator to a work item
- */
-static void *slow_work_runqueue_index(struct seq_file *m, loff_t *_pos)
-{
-	struct list_head *p;
-	unsigned long count, id;
-
-	switch (*_pos >> ITERATOR_SHIFT) {
-	case 0x0:
-		if (*_pos == 0)
-			*_pos = 1;
-		if (*_pos < 3)
-			return (void *)(unsigned long) *_pos;
-		if (*_pos < 3 + SLOW_WORK_THREAD_LIMIT)
-			for (id = *_pos - 3;
-			     id < SLOW_WORK_THREAD_LIMIT;
-			     id++, (*_pos)++)
-				if (slow_work_execs[id])
-					return (void *)(unsigned long) *_pos;
-		*_pos = 0x1UL << ITERATOR_SHIFT;
-
-	case 0x1:
-		count = *_pos & ITERATOR_COUNTER;
-		list_for_each(p, &slow_work_queue) {
-			if (count == 0)
-				return p;
-			count--;
-		}
-		*_pos = 0x2UL << ITERATOR_SHIFT;
-
-	case 0x2:
-		count = *_pos & ITERATOR_COUNTER;
-		list_for_each(p, &vslow_work_queue) {
-			if (count == 0)
-				return p;
-			count--;
-		}
-		*_pos = 0x3UL << ITERATOR_SHIFT;
-
-	default:
-		return NULL;
-	}
-}
-
-/*
- * set up the iterator to start reading from the first line
- */
-static void *slow_work_runqueue_start(struct seq_file *m, loff_t *_pos)
-{
-	spin_lock_irq(&slow_work_queue_lock);
-	return slow_work_runqueue_index(m, _pos);
-}
-
-/*
- * move to the next line
- */
-static void *slow_work_runqueue_next(struct seq_file *m, void *v, loff_t *_pos)
-{
-	struct list_head *p = v;
-	unsigned long selector = *_pos >> ITERATOR_SHIFT;
-
-	(*_pos)++;
-	switch (selector) {
-	case 0x0:
-		return slow_work_runqueue_index(m, _pos);
-
-	case 0x1:
-		if (*_pos >> ITERATOR_SHIFT == 0x1) {
-			p = p->next;
-			if (p != &slow_work_queue)
-				return p;
-		}
-		*_pos = 0x2UL << ITERATOR_SHIFT;
-		p = &vslow_work_queue;
-
-	case 0x2:
-		if (*_pos >> ITERATOR_SHIFT == 0x2) {
-			p = p->next;
-			if (p != &vslow_work_queue)
-				return p;
-		}
-		*_pos = 0x3UL << ITERATOR_SHIFT;
-
-	default:
-		return NULL;
-	}
-}
-
-/*
- * clean up after reading
- */
-static void slow_work_runqueue_stop(struct seq_file *m, void *v)
-{
-	spin_unlock_irq(&slow_work_queue_lock);
-}
-
-static const struct seq_operations slow_work_runqueue_ops = {
-	.start		= slow_work_runqueue_start,
-	.stop		= slow_work_runqueue_stop,
-	.next		= slow_work_runqueue_next,
-	.show		= slow_work_runqueue_show,
-};
-
-/*
- * open "/proc/slow_work_rq" to list queue contents
- */
-static int slow_work_runqueue_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &slow_work_runqueue_ops);
-}
-
-const struct file_operations slow_work_runqueue_fops = {
-	.owner		= THIS_MODULE,
-	.open		= slow_work_runqueue_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= seq_release,
-};
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index b5c17f1..00889bd 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -16,7 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/wait.h>
-#include <linux/proc_fs.h>
+#include <linux/debugfs.h>
 #include "slow-work.h"
 
 static void slow_work_cull_timeout(unsigned long);
@@ -138,7 +138,7 @@ static void slow_work_clear_thread_processing(int id) {}
 /*
  * Data for tracking currently executing items for indication through /proc
  */
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 struct slow_work *slow_work_execs[SLOW_WORK_THREAD_LIMIT];
 pid_t slow_work_pids[SLOW_WORK_THREAD_LIMIT];
 DEFINE_RWLOCK(slow_work_execs_lock);
@@ -823,7 +823,7 @@ static void slow_work_new_thread_execute(struct slow_work *work)
 static const struct slow_work_ops slow_work_new_thread_ops = {
 	.owner		= THIS_MODULE,
 	.execute	= slow_work_new_thread_execute,
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 	.desc		= slow_work_new_thread_desc,
 #endif
 };
@@ -1055,9 +1055,15 @@ static int __init init_slow_work(void)
 	if (slow_work_max_max_threads < nr_cpus * 2)
 		slow_work_max_max_threads = nr_cpus * 2;
 #endif
-#ifdef CONFIG_SLOW_WORK_PROC
-	proc_create("slow_work_rq", S_IFREG | 0400, NULL,
-		    &slow_work_runqueue_fops);
+#ifdef CONFIG_SLOW_WORK_DEBUG
+	{
+		struct dentry *dbdir;
+
+		dbdir = debugfs_create_dir("slow_work", NULL);
+		if (dbdir && !IS_ERR(dbdir))
+			debugfs_create_file("runqueue", S_IFREG | 0400, dbdir,
+					    NULL, &slow_work_runqueue_fops);
+	}
 #endif
 	return 0;
 }
diff --git a/kernel/slow-work.h b/kernel/slow-work.h
index 3c2f007..321f3c5 100644
--- a/kernel/slow-work.h
+++ b/kernel/slow-work.h
@@ -19,7 +19,7 @@
 /*
  * slow-work.c
  */
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 extern struct slow_work *slow_work_execs[];
 extern pid_t slow_work_pids[];
 extern rwlock_t slow_work_execs_lock;
@@ -30,9 +30,9 @@ extern struct list_head vslow_work_queue;
 extern spinlock_t slow_work_queue_lock;
 
 /*
- * slow-work-proc.c
+ * slow-work-debugfs.c
  */
-#ifdef CONFIG_SLOW_WORK_PROC
+#ifdef CONFIG_SLOW_WORK_DEBUG
 extern const struct file_operations slow_work_runqueue_fops;
 
 extern void slow_work_new_thread_desc(struct slow_work *, struct seq_file *);
