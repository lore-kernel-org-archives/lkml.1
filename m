Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZKSRVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZKSRVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZKSRVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952AbZKSRU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:20:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/28] SLOW_WORK: Allow the work items to be viewed through a
	/proc file
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:20:59 +0000
Message-ID: <20091119172059.1679.94500.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the executing and queued work items to be viewed through a /proc file
for debugging purposes.  The contents look something like the following:

    THR PID   ITEM ADDR        FL MARK  DESC
    === ===== ================ == ===== ==========
      0  3005 ffff880023f52348  a 952ms FSC: OBJ17d3: LOOK
      1  3006 ffff880024e33668  2 160ms FSC: OBJ17e5 OP60d3b: Write1/Store fl=2
      2  3165 ffff8800296dd180  a 424ms FSC: OBJ17e4: LOOK
      3  4089 ffff8800262c8d78  a 212ms FSC: OBJ17ea: CRTN
      4  4090 ffff88002792bed8  2 388ms FSC: OBJ17e8 OP60d36: Write1/Store fl=2
      5  4092 ffff88002a0ef308  2 388ms FSC: OBJ17e7 OP60d2e: Write1/Store fl=2
      6  4094 ffff88002abaf4b8  2 132ms FSC: OBJ17e2 OP60d4e: Write1/Store fl=2
      7  4095 ffff88002bb188e0  a 388ms FSC: OBJ17e9: CRTN
    vsq     - ffff880023d99668  1 308ms FSC: OBJ17e0 OP60f91: Write1/EnQ fl=2
    vsq     - ffff8800295d1740  1 212ms FSC: OBJ16be OP4d4b6: Write1/EnQ fl=2
    vsq     - ffff880025ba3308  1 160ms FSC: OBJ179a OP58dec: Write1/EnQ fl=2
    vsq     - ffff880024ec83e0  1 160ms FSC: OBJ17ae OP599f2: Write1/EnQ fl=2
    vsq     - ffff880026618e00  1 160ms FSC: OBJ17e6 OP60d33: Write1/EnQ fl=2
    vsq     - ffff880025a2a4b8  1 132ms FSC: OBJ16a2 OP4d583: Write1/EnQ fl=2
    vsq     - ffff880023cbe6d8  9 212ms FSC: OBJ17eb: LOOK
    vsq     - ffff880024d37590  9 212ms FSC: OBJ17ec: LOOK
    vsq     - ffff880027746cb0  9 212ms FSC: OBJ17ed: LOOK
    vsq     - ffff880024d37ae8  9 212ms FSC: OBJ17ee: LOOK
    vsq     - ffff880024d37cb0  9 212ms FSC: OBJ17ef: LOOK
    vsq     - ffff880025036550  9 212ms FSC: OBJ17f0: LOOK
    vsq     - ffff8800250368e0  9 212ms FSC: OBJ17f1: LOOK
    vsq     - ffff880025036aa8  9 212ms FSC: OBJ17f2: LOOK

In the 'THR' column, executing items show the thread they're occupying and
queued threads indicate which queue they're on.  'PID' shows the process ID of
a slow-work thread that's executing something.  'FL' shows the work item flags.
'MARK' indicates how long since an item was queued or began executing.  Lastly,
the 'DESC' column permits the owner of an item to give some information.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |   60 +++++++++++
 include/linux/slow-work.h   |   11 ++
 init/Kconfig                |   10 ++
 kernel/Makefile             |    1 
 kernel/slow-work-proc.c     |  227 +++++++++++++++++++++++++++++++++++++++++++
 kernel/slow-work.c          |   44 ++++++--
 kernel/slow-work.h          |   72 ++++++++++++++
 7 files changed, 413 insertions(+), 12 deletions(-)
 create mode 100644 kernel/slow-work-proc.c
 create mode 100644 kernel/slow-work.h

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index a9d1b0f..f120238 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -149,7 +149,8 @@ ITEM OPERATIONS
 ===============
 
 Each work item requires a table of operations of type struct slow_work_ops.
-Only ->execute() is required, getting and putting of a reference are optional.
+Only ->execute() is required; the getting and putting of a reference and the
+describing of an item are all optional.
 
  (*) Get a reference on an item:
 
@@ -179,6 +180,16 @@ Only ->execute() is required, getting and putting of a reference are optional.
      This should perform the work required of the item.  It may sleep, it may
      perform disk I/O and it may wait for locks.
 
+ (*) View an item through /proc:
+
+	void (*desc)(struct slow_work *work, struct seq_file *m);
+
+     If supplied, this should print to 'm' a small string describing the work
+     the item is to do.  This should be no more than about 40 characters, and
+     shouldn't include a newline character.
+
+     See the 'Viewing executing and queued items' section below.
+
 
 ==================
 POOL CONFIGURATION
@@ -203,3 +214,50 @@ The slow-work thread pool has a number of configurables:
      is bounded to between 1 and one fewer than the number of active threads.
      This ensures there is always at least one thread that can process very
      slow work items, and always at least one thread that won't.
+
+
+==================================
+VIEWING EXECUTING AND QUEUED ITEMS
+==================================
+
+If CONFIG_SLOW_WORK_PROC is enabled, a proc file is made available:
+
+	/proc/slow_work_rq
+
+through which the list of work items being executed and the queues of items to
+be executed may be viewed.  The owner of a work item is given the chance to
+add some information of its own.
+
+The contents look something like the following:
+
+    THR PID   ITEM ADDR        FL MARK  DESC
+    === ===== ================ == ===== ==========
+      0  3005 ffff880023f52348  a 952ms FSC: OBJ17d3: LOOK
+      1  3006 ffff880024e33668  2 160ms FSC: OBJ17e5 OP60d3b: Write1/Store fl=2
+      2  3165 ffff8800296dd180  a 424ms FSC: OBJ17e4: LOOK
+      3  4089 ffff8800262c8d78  a 212ms FSC: OBJ17ea: CRTN
+      4  4090 ffff88002792bed8  2 388ms FSC: OBJ17e8 OP60d36: Write1/Store fl=2
+      5  4092 ffff88002a0ef308  2 388ms FSC: OBJ17e7 OP60d2e: Write1/Store fl=2
+      6  4094 ffff88002abaf4b8  2 132ms FSC: OBJ17e2 OP60d4e: Write1/Store fl=2
+      7  4095 ffff88002bb188e0  a 388ms FSC: OBJ17e9: CRTN
+    vsq     - ffff880023d99668  1 308ms FSC: OBJ17e0 OP60f91: Write1/EnQ fl=2
+    vsq     - ffff8800295d1740  1 212ms FSC: OBJ16be OP4d4b6: Write1/EnQ fl=2
+    vsq     - ffff880025ba3308  1 160ms FSC: OBJ179a OP58dec: Write1/EnQ fl=2
+    vsq     - ffff880024ec83e0  1 160ms FSC: OBJ17ae OP599f2: Write1/EnQ fl=2
+    vsq     - ffff880026618e00  1 160ms FSC: OBJ17e6 OP60d33: Write1/EnQ fl=2
+    vsq     - ffff880025a2a4b8  1 132ms FSC: OBJ16a2 OP4d583: Write1/EnQ fl=2
+    vsq     - ffff880023cbe6d8  9 212ms FSC: OBJ17eb: LOOK
+    vsq     - ffff880024d37590  9 212ms FSC: OBJ17ec: LOOK
+    vsq     - ffff880027746cb0  9 212ms FSC: OBJ17ed: LOOK
+    vsq     - ffff880024d37ae8  9 212ms FSC: OBJ17ee: LOOK
+    vsq     - ffff880024d37cb0  9 212ms FSC: OBJ17ef: LOOK
+    vsq     - ffff880025036550  9 212ms FSC: OBJ17f0: LOOK
+    vsq     - ffff8800250368e0  9 212ms FSC: OBJ17f1: LOOK
+    vsq     - ffff880025036aa8  9 212ms FSC: OBJ17f2: LOOK
+
+In the 'THR' column, executing items show the thread they're occupying and
+queued threads indicate which queue they're on.  'PID' shows the process ID of
+a slow-work thread that's executing something.  'FL' shows the work item flags.
+'MARK' indicates how long since an item was queued or began executing.  Lastly,
+the 'DESC' column permits the owner of an item to give some information.
+
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index b245b9a..f414851 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -20,6 +20,9 @@
 #include <linux/timer.h>
 
 struct slow_work;
+#ifdef CONFIG_SLOW_WORK_PROC
+struct seq_file;
+#endif
 
 /*
  * The operations used to support slow work items
@@ -38,6 +41,11 @@ struct slow_work_ops {
 
 	/* execute a work item */
 	void (*execute)(struct slow_work *work);
+
+#ifdef CONFIG_SLOW_WORK_PROC
+	/* describe a work item for /proc */
+	void (*desc)(struct slow_work *work, struct seq_file *m);
+#endif
 };
 
 /*
@@ -56,6 +64,9 @@ struct slow_work {
 #define SLOW_WORK_DELAYED	5	/* item is struct delayed_slow_work with active timer */
 	const struct slow_work_ops *ops; /* operations table for this item */
 	struct list_head	link;	/* link in queue */
+#ifdef CONFIG_SLOW_WORK_PROC
+	struct timespec		mark;	/* jiffies at which queued or exec begun */
+#endif
 };
 
 struct delayed_slow_work {
diff --git a/init/Kconfig b/init/Kconfig
index 9e03ef8..ab5c648 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1098,6 +1098,16 @@ config SLOW_WORK
 
 	  See Documentation/slow-work.txt.
 
+config SLOW_WORK_PROC
+	bool "Slow work debugging through /proc"
+	default n
+	depends on SLOW_WORK && PROC_FS
+	help
+	  Display the contents of the slow work run queue through /proc,
+	  including items currently executing.
+
+	  See Documentation/slow-work.txt.
+
 endmenu		# General setup
 
 config HAVE_GENERIC_DMA_COHERENT
diff --git a/kernel/Makefile b/kernel/Makefile
index b8d4cd8..776ffed 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_X86_DS) += trace/
 obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
+obj-$(CONFIG_SLOW_WORK_PROC) += slow-work-proc.o
 obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
diff --git a/kernel/slow-work-proc.c b/kernel/slow-work-proc.c
new file mode 100644
index 0000000..3988032
--- /dev/null
+++ b/kernel/slow-work-proc.c
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
+ * Describe a slow work item for /proc
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
+ * open "/proc/slow_work_rq" to list queue contents
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
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index f67e1da..b763bc2 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -16,13 +16,8 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/wait.h>
-
-#define SLOW_WORK_CULL_TIMEOUT (5 * HZ)	/* cull threads 5s after running out of
-					 * things to do */
-#define SLOW_WORK_OOM_TIMEOUT (5 * HZ)	/* can't start new threads for 5s after
-					 * OOM */
-
-#define SLOW_WORK_THREAD_LIMIT	255	/* abs maximum number of slow-work threads */
+#include <linux/proc_fs.h>
+#include "slow-work.h"
 
 static void slow_work_cull_timeout(unsigned long);
 static void slow_work_oom_timeout(unsigned long);
@@ -117,6 +112,15 @@ static DEFINE_MUTEX(slow_work_unreg_sync_lock);
 #endif
 
 /*
+ * Data for tracking currently executing items for indication through /proc
+ */
+#ifdef CONFIG_SLOW_WORK_PROC
+struct slow_work *slow_work_execs[SLOW_WORK_THREAD_LIMIT];
+pid_t slow_work_pids[SLOW_WORK_THREAD_LIMIT];
+DEFINE_RWLOCK(slow_work_execs_lock);
+#endif
+
+/*
  * The queues of work items and the lock governing access to them.  These are
  * shared between all the CPUs.  It doesn't make sense to have per-CPU queues
  * as the number of threads bears no relation to the number of CPUs.
@@ -124,9 +128,9 @@ static DEFINE_MUTEX(slow_work_unreg_sync_lock);
  * There are two queues of work items: one for slow work items, and one for
  * very slow work items.
  */
-static LIST_HEAD(slow_work_queue);
-static LIST_HEAD(vslow_work_queue);
-static DEFINE_SPINLOCK(slow_work_queue_lock);
+LIST_HEAD(slow_work_queue);
+LIST_HEAD(vslow_work_queue);
+DEFINE_SPINLOCK(slow_work_queue_lock);
 
 /*
  * The thread controls.  A variable used to signal to the threads that they
@@ -182,7 +186,7 @@ static unsigned slow_work_calc_vsmax(void)
  * Attempt to execute stuff queued on a slow thread.  Return true if we managed
  * it, false if there was nothing to do.
  */
-static bool slow_work_execute(int id)
+static noinline bool slow_work_execute(int id)
 {
 #ifdef CONFIG_MODULES
 	struct module *module;
@@ -227,6 +231,10 @@ static bool slow_work_execute(int id)
 	if (work)
 		slow_work_thread_processing[id] = work->owner;
 #endif
+	if (work) {
+		slow_work_mark_time(work);
+		slow_work_begin_exec(id, work);
+	}
 
 	spin_unlock_irq(&slow_work_queue_lock);
 
@@ -247,6 +255,8 @@ static bool slow_work_execute(int id)
 	/* wake up anyone waiting for this work to be complete */
 	wake_up_bit(&work->flags, SLOW_WORK_EXECUTING);
 
+	slow_work_end_exec(id, work);
+
 	/* if someone tried to enqueue the item whilst we were executing it,
 	 * then it'll be left unenqueued to avoid multiple threads trying to
 	 * execute it simultaneously
@@ -285,6 +295,7 @@ auto_requeue:
 	 * - we transfer our ref on the item back to the appropriate queue
 	 * - don't wake another thread up as we're awake already
 	 */
+	slow_work_mark_time(work);
 	if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
 		list_add_tail(&work->link, &vslow_work_queue);
 	else
@@ -368,6 +379,7 @@ int slow_work_enqueue(struct slow_work *work)
 			ret = slow_work_get_ref(work);
 			if (ret < 0)
 				goto failed;
+			slow_work_mark_time(work);
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
 				list_add_tail(&work->link, &vslow_work_queue);
 			else
@@ -489,6 +501,7 @@ static void delayed_slow_work_timer(unsigned long data)
 			set_bit(SLOW_WORK_ENQ_DEFERRED, &work->flags);
 			put = true;
 		} else {
+			slow_work_mark_time(work);
 			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
 				list_add_tail(&work->link, &vslow_work_queue);
 			else
@@ -627,6 +640,7 @@ static int slow_work_thread(void *_data)
 	id = find_first_zero_bit(slow_work_ids, SLOW_WORK_THREAD_LIMIT);
 	BUG_ON(id < 0 || id >= SLOW_WORK_THREAD_LIMIT);
 	__set_bit(id, slow_work_ids);
+	slow_work_set_thread_pid(id, current->pid);
 	spin_unlock_irq(&slow_work_queue_lock);
 
 	sprintf(current->comm, "kslowd%03u", id);
@@ -669,6 +683,7 @@ static int slow_work_thread(void *_data)
 	}
 
 	spin_lock_irq(&slow_work_queue_lock);
+	slow_work_set_thread_pid(id, 0);
 	__clear_bit(id, slow_work_ids);
 	spin_unlock_irq(&slow_work_queue_lock);
 
@@ -722,6 +737,9 @@ static void slow_work_new_thread_execute(struct slow_work *work)
 static const struct slow_work_ops slow_work_new_thread_ops = {
 	.owner		= THIS_MODULE,
 	.execute	= slow_work_new_thread_execute,
+#ifdef CONFIG_SLOW_WORK_PROC
+	.desc		= slow_work_new_thread_desc,
+#endif
 };
 
 /*
@@ -949,6 +967,10 @@ static int __init init_slow_work(void)
 	if (slow_work_max_max_threads < nr_cpus * 2)
 		slow_work_max_max_threads = nr_cpus * 2;
 #endif
+#ifdef CONFIG_SLOW_WORK_PROC
+	proc_create("slow_work_rq", S_IFREG | 0400, NULL,
+		    &slow_work_runqueue_fops);
+#endif
 	return 0;
 }
 
diff --git a/kernel/slow-work.h b/kernel/slow-work.h
new file mode 100644
index 0000000..3c2f007
--- /dev/null
+++ b/kernel/slow-work.h
@@ -0,0 +1,72 @@
+/* Slow work private definitions
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
+#define SLOW_WORK_CULL_TIMEOUT (5 * HZ)	/* cull threads 5s after running out of
+					 * things to do */
+#define SLOW_WORK_OOM_TIMEOUT (5 * HZ)	/* can't start new threads for 5s after
+					 * OOM */
+
+#define SLOW_WORK_THREAD_LIMIT	255	/* abs maximum number of slow-work threads */
+
+/*
+ * slow-work.c
+ */
+#ifdef CONFIG_SLOW_WORK_PROC
+extern struct slow_work *slow_work_execs[];
+extern pid_t slow_work_pids[];
+extern rwlock_t slow_work_execs_lock;
+#endif
+
+extern struct list_head slow_work_queue;
+extern struct list_head vslow_work_queue;
+extern spinlock_t slow_work_queue_lock;
+
+/*
+ * slow-work-proc.c
+ */
+#ifdef CONFIG_SLOW_WORK_PROC
+extern const struct file_operations slow_work_runqueue_fops;
+
+extern void slow_work_new_thread_desc(struct slow_work *, struct seq_file *);
+#endif
+
+/*
+ * Helper functions
+ */
+static inline void slow_work_set_thread_pid(int id, pid_t pid)
+{
+#ifdef CONFIG_SLOW_WORK_PROC
+	slow_work_pids[id] = pid;
+#endif
+}
+
+static inline void slow_work_mark_time(struct slow_work *work)
+{
+#ifdef CONFIG_SLOW_WORK_PROC
+	work->mark = CURRENT_TIME;
+#endif
+}
+
+static inline void slow_work_begin_exec(int id, struct slow_work *work)
+{
+#ifdef CONFIG_SLOW_WORK_PROC
+	slow_work_execs[id] = work;
+#endif
+}
+
+static inline void slow_work_end_exec(int id, struct slow_work *work)
+{
+#ifdef CONFIG_SLOW_WORK_PROC
+	write_lock(&slow_work_execs_lock);
+	slow_work_execs[id] = NULL;
+	write_unlock(&slow_work_execs_lock);
+#endif
+}

