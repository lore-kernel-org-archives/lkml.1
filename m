Return-Path: <linux-kernel-owner+w=401wt.eu-S936164AbYEVKHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936164AbYEVKHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935978AbYEVKGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:06:55 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:38730 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935786AbYEVKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:06:52 -0400
Message-ID: <48354476.3060508@miraclelinux.com>
Date: Thu, 22 May 2008 19:01:26 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>
Subject: [RFC][PATCH 2/2 v2] MAZE: Mazed processes monitor
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.5.22.24453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for linux-2.6.26-rc2-mm1 that is tested on x86_64 hardware.

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
---
 include/linux/maze.h  |   94 ++++++++
 include/linux/sched.h |    3
 init/Kconfig          |   18 +
 init/main.c           |    2
 kernel/Makefile       |    1
 kernel/exit.c         |    2
 kernel/fork.c         |    2
 kernel/maze.c         |  529 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c        |    3
 9 files changed, 654 insertions(+)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc2-mm1/include/linux/maze.h	2008-05-22 10:11:59.000000000 +0900
@@ -0,0 +1,94 @@
+/*
+ *  Copyright (C) 2007-2008 MIRACLE LINUX Corp.
+ *
+ *  Written by Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ */
+#ifndef _LINUX_MAZE_H
+#define _LINUX_MAZE_H
+
+#ifdef __KERNEL__
+
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+
+struct maze_context {
+	struct task_struct *task;
+
+	/* The stime of task when the maze count was reseted */
+	cputime_t reset_stime;
+	/* The utime of task when the maze count was reseted */
+	cputime_t reset_utime;
+
+	/* The soft limit of maze count */
+	unsigned long soft_limit;
+	/* THe hard limit of maze count */
+	unsigned long hard_limit;
+
+	/* The send signal when the maze count reach soft limit */
+	int soft_signal;
+	/* The send signal when the maze count reach hard limit */
+	int hard_signal;
+
+#define MAZE_SENT_SOFT_SIG  1
+#define MAZE_SENT_HARD_SIG  2
+	/* The flags of sent signal */
+	unsigned long flags;
+
+#define MAZE_ENQUEUE 1
+#define MAZE_EXIT    2
+	/* The state of queue */
+	unsigned long state;
+
+	/* This value is 1, if preempt_notifier is registered */
+	atomic_t registered_notifier;
+
+	struct preempt_notifier notifier;
+
+	/* This list_head is linked from the maze_queue */
+	struct list_head queue;
+	/* This list_head is linked from the maze_list */
+	struct list_head list;
+
+	spinlock_t lock;
+};
+
+#ifdef CONFIG_MAZE
+
+/* This function is called start_kernel() */
+extern void maze_init_early(void);
+
+/* This function is called do_exit() */
+extern void maze_exit(struct task_struct *task);
+
+/* This function is called copy_process() */
+extern void maze_fork(struct task_struct *task);
+
+/* This function is called sys_sched_yield() */
+extern void maze_sched_yield(struct task_struct *task);
+
+#else  /* !CONFIG_MAZE */
+
+static inline void maze_init_early(void)
+{
+}
+
+static inline maze_exit(struct task_struct *task)
+{
+}
+
+static inline void maze_fork(struct task_struct *task)
+{
+}
+
+static inline void maze_sched_yield(struct task_struct *task)
+{
+}
+#endif /* CONFIG_MAZE */
+
+#endif /* __KERNEL__    */
+#endif /* _LINUX_MAZE_H */
--- linux-2.6.26-rc2-mm1.orig/include/linux/sched.h	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/include/linux/sched.h	2008-05-22 10:11:59.000000000 +0900
@@ -1280,6 +1280,9 @@ struct task_struct {
 	/* cg_list protected by css_set_lock and tsk->alloc_lock */
 	struct list_head cg_list;
 #endif
+#ifdef CONFIG_MAZE
+	struct maze_context *maze_context;
+#endif
 #ifdef CONFIG_FUTEX
 	struct robust_list_head __user *robust_list;
 #ifdef CONFIG_COMPAT
--- linux-2.6.26-rc2-mm1.orig/init/Kconfig	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/init/Kconfig	2008-05-22 10:11:59.000000000 +0900
@@ -385,6 +385,24 @@ config RESOURCE_COUNTERS
           infrastructure that works with cgroups
 	depends on CGROUPS

+config MAZE
+	bool "MAZE monitor support"
+	select PREEMPT_NOTIFIERS
+	help
+	  MAZE is a function to monitor mazed processes which use excessive CPU cycles.
+	  This is a CGL (Carrier Grade Linux) requirement (AVL.14.0). MAZE detects such
+	  processes and sends specified signals to the processes for their termination.
+
+	  Say N if unsure.
+
+config MAZE_TIMER
+        int  "MAZE monitoring timer interval"
+	depends on MAZE
+        default 100
+	help
+	  This is the interval of MAZE monitoring timer.
+	  It unit is msec.
+
 config MM_OWNER
 	bool

--- linux-2.6.26-rc2-mm1.orig/init/main.c	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/init/main.c	2008-05-22 10:11:59.000000000 +0900
@@ -60,6 +60,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/maze.h>

 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -544,6 +545,7 @@ asmlinkage void __init start_kernel(void
 	lockdep_init();
 	debug_objects_early_init();
 	cgroup_init_early();
+	maze_init_early();

 	local_irq_disable();
 	early_boot_irqs_off();
--- linux-2.6.26-rc2-mm1.orig/kernel/Makefile	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/kernel/Makefile	2008-05-22 10:11:59.000000000 +0900
@@ -77,6 +77,7 @@ obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_FTRACE) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_MAZE) += maze.o

 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
--- linux-2.6.26-rc2-mm1.orig/kernel/exit.c	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/kernel/exit.c	2008-05-22 10:11:59.000000000 +0900
@@ -45,6 +45,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/maze.h>

 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1042,6 +1043,7 @@ NORET_TYPE void do_exit(long code)
 	exit_fs(tsk);
 	check_stack_usage();
 	exit_thread();
+	maze_exit(tsk);
 	cgroup_exit(tsk, 1);
 	exit_keys(tsk);

--- linux-2.6.26-rc2-mm1.orig/kernel/fork.c	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/kernel/fork.c	2008-05-22 10:11:59.000000000 +0900
@@ -54,6 +54,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <linux/maze.h>

 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1223,6 +1224,7 @@ static struct task_struct *copy_process(
 	write_unlock_irq(&tasklist_lock);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
+	maze_fork(p);
 	return p;

 bad_fork_free_pid:
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc2-mm1/kernel/maze.c	2008-05-22 10:23:19.000000000 +0900
@@ -0,0 +1,529 @@
+/*
+ *  Copyright (C) 2007-2008 MIRACLE LINUX Corp.
+ *
+ *  Written by Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation, version 2.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/timer.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <linux/capability.h>
+#include <linux/maze.h>
+
+#define ERRPRINT(str, ...) printk(KERN_ERR"[%s] " str, __func__, ##__VA_ARGS__);
+
+/* The root directory of procfs. */
+static struct proc_dir_entry *maze_proc_dir;
+
+/* This list contains all maze_context.
+ * Note, this list is protected maze_list_lock.
+ */
+static LIST_HEAD(maze_list);
+
+/* The protection of maze_list. */
+static DEFINE_SPINLOCK(maze_list_lock);
+
+/* The interval of softirq timer. */
+static int maze_timer_interval;
+
+/* This list is linked scheduling task. */
+static DEFINE_PER_CPU(struct list_head, maze_queue);
+
+/* The timer of check maze-count.  */
+static DEFINE_PER_CPU(struct timer_list, maze_timer);
+
+/*
+ * Calculate maze-count.
+ * The definition of maze-count is keeping TASK_RUNNINT time.
+ */
+static inline cputime_t get_maze_count(struct maze_context *context)
+{
+	return (context->task->utime - context->reset_utime) +
+		(context->task->stime - context->reset_stime);
+}
+
+/*
+ * Reset maze-count.
+ * This function is called when watch task state is not TASK_RUNNING
+ * and it is preempted.
+ */
+static inline void reset_maze_count(struct maze_context *context)
+{
+	context->reset_utime = context->task->utime;
+	context->reset_stime = context->task->stime;
+	context->flags = 0;
+}
+
+/*
+ * Initializ init-process's maze_context.
+ * Note, this function is called start_kernel().
+ */
+void maze_init_early(void)
+{
+	init_task.maze_context = NULL;
+}
+
+/*
+ * Enqueue maze_context to maze_queue.
+ * Note, Must be called under spin_lock of context->lock.
+ */
+static void enqueue(struct maze_context *context)
+{
+	if (!(context->state & MAZE_ENQUEUE)) {
+		list_add(&context->queue, &__get_cpu_var(maze_queue));
+		context->state |= MAZE_ENQUEUE;
+	}
+}
+
+/*
+ * Free maze_context, if monitoring task exited.
+ * Note, this function is called do_exit().
+ */
+void maze_exit(struct task_struct *task)
+{
+	struct maze_context *context;
+	unsigned long flags;
+
+	spin_lock(&maze_list_lock);
+
+	context = task->maze_context;
+	if (context) {
+		spin_lock_irqsave(&context->lock, flags);
+		task->maze_context = NULL;
+
+		if (atomic_xchg(&context->registered_notifier, 1))
+			preempt_notifier_unregister(&context->notifier);
+
+		context->state |= MAZE_EXIT;
+
+		list_del(&context->list);
+		enqueue(context);
+
+		spin_unlock_irqrestore(&context->lock, flags);
+	}
+
+	spin_unlock(&maze_list_lock);
+}
+
+static inline void copy_limit_and_signal(struct maze_context *to,
+			struct maze_context *from)
+{
+	to->soft_limit = from->soft_limit;
+	to->hard_limit = from->hard_limit;
+	to->soft_signal = from->soft_signal;
+	to->hard_signal = from->hard_signal;
+}
+
+/*
+ * Make sched-in task pickup.
+ */
+static void sched_in_event(struct preempt_notifier *notifier, int cpu)
+{
+	struct maze_context *context;
+	unsigned long flags;
+
+	context = current->maze_context;
+	if (context) {
+		spin_lock_irqsave(&context->lock, flags);
+		enqueue(context);
+		spin_unlock_irqrestore(&context->lock, flags);
+	}
+}
+
+/*
+ * Make scheduling task pickup.
+ */
+static void sched_out_event(struct preempt_notifier *notifier,
+			  struct task_struct *next)
+{
+	struct maze_context *context;
+	unsigned long flags;
+
+	context = current->maze_context;
+	if (context) {
+		spin_lock_irqsave(&context->lock, flags);
+		if (current->state != TASK_RUNNING)
+			reset_maze_count(context);
+		spin_unlock_irqrestore(&context->lock, flags);
+	}
+
+	context = next->maze_context;
+	if (context) {
+		spin_lock_irqsave(&context->lock, flags);
+		enqueue(context);
+		spin_unlock_irqrestore(&context->lock, flags);
+	}
+}
+
+static struct preempt_ops preempt_ops = {
+	.sched_in = sched_in_event,
+	.sched_out = sched_out_event,
+};
+
+/*
+ * Copy parent's maze_context to child process,
+ * if monitoring process forked.
+ * Note, this function is called copy_process().
+ */
+void maze_fork(struct task_struct *task)
+{
+	struct maze_context *context;
+
+	task->maze_context = NULL;
+	if (!current->maze_context)
+		return;
+
+	spin_lock(&maze_list_lock);
+	context = kzalloc(sizeof(struct maze_context), GFP_KERNEL);
+	if (unlikely(!context)) {
+		ERRPRINT("fail to alloc maze_context.\n");
+		goto unlock;
+	}
+
+	spin_lock_init(&context->lock);
+
+	task->maze_context = context;
+	context->task = task;
+
+	copy_limit_and_signal(task->maze_context, current->maze_context);
+	preempt_notifier_init(&task->maze_context->notifier, &preempt_ops);
+
+	list_add(&task->maze_context->list, &maze_list);
+
+unlock:
+	spin_unlock(&maze_list_lock);
+}
+
+/*
+ * Reset maze-count.
+ * Note, this function is called sys_sched_yield().
+ */
+void maze_sched_yield(struct task_struct *task)
+{
+	if (task->maze_context)
+		reset_maze_count(task->maze_context);
+}
+
+/*
+ * Setup preempt notifier,if watch task has not setup it.
+ */
+static void set_preempt_notifier(struct maze_context *context)
+{
+	if (!atomic_xchg(&context->registered_notifier, 1))
+		preempt_notifier_register(&context->notifier);
+}
+
+/*
+ * Add monitoring task or copy new monitor state.
+ */
+static int add_maze_context(int pid, struct maze_context *context)
+{
+	struct task_struct *task;
+	unsigned long flags;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	task = find_task_by_vpid(pid);
+	if (unlikely(!task))
+		goto read_unlock;
+
+	spin_lock(&maze_list_lock);
+
+	if (!task->maze_context) {
+		spin_lock_init(&context->lock);
+		spin_lock_irqsave(&context->lock, flags);
+
+		task->maze_context = context;
+		context->task = task;
+
+		list_add(&context->list, &maze_list);
+		reset_maze_count(context);
+
+		preempt_notifier_init(&context->notifier, &preempt_ops);
+		if (current == task)
+			set_preempt_notifier(context);
+
+		spin_unlock_irqrestore(&context->lock, flags);
+	} else {
+		spin_lock_irqsave(&task->maze_context->lock, flags);
+		copy_limit_and_signal(task->maze_context, context);
+		spin_unlock_irqrestore(&task->maze_context->lock, flags);
+		ret = 1;
+	}
+
+	spin_unlock(&maze_list_lock);
+
+read_unlock:
+	rcu_read_unlock();
+	return ret;
+}
+
+/*
+ * Build maze_context from a procfs input
+ */
+static int build_maze_context(const char *read_line,
+		    struct maze_context *context, int *pid)
+{
+	unsigned long soft_limit, hard_limit;
+	int soft_signal, hard_signal;
+	int res;
+
+	res = sscanf(read_line, "%d %ld %ld %d %d", pid, &soft_limit,
+				 &hard_limit, &soft_signal, &hard_signal);
+
+	if (res != 5 || *pid < 0 ||
+		soft_limit < 0 || hard_limit < 0 ||
+		soft_signal < 0 || hard_signal < 0)
+		return -EINVAL;
+
+	context->soft_limit = soft_limit;
+	context->hard_limit = hard_limit;
+	context->soft_signal = soft_signal;
+	context->hard_signal = hard_signal;
+
+	return 0;
+}
+
+static void timer_handler(unsigned long data);
+
+/*
+ * Setup softirq timer.
+ */
+static void continue_timer(int cpu)
+{
+	setup_timer(&per_cpu(maze_timer, cpu),
+				timer_handler,
+				jiffies + maze_timer_interval);
+
+	add_timer_on(&per_cpu(maze_timer, cpu), cpu);
+}
+
+/*
+ * Check maze-count that did't exceed limit.
+ */
+static void check_limit(struct maze_context *context)
+{
+	cputime_t t = get_maze_count(context);
+
+	if (!(context->flags & MAZE_SENT_SOFT_SIG)) {
+		if (t >= context->soft_limit) {
+			/* Send soft-signal */
+			send_sig(context->soft_signal, context->task, 1);
+			context->flags |= MAZE_SENT_SOFT_SIG;
+		}
+	} else if (!(context->flags & MAZE_SENT_HARD_SIG)) {
+		if (t >= context->hard_limit) {
+			/* Send hard-signal */
+			send_sig(context->hard_signal, context->task, 1);
+			context->flags |= MAZE_SENT_HARD_SIG;
+		}
+	}
+}
+
+/*
+ * Watch registed task.
+ * Timer interval is in CONFIG_MAZE_TIMER.
+ */
+static void timer_handler(unsigned long data)
+{
+	struct maze_context *context, *next;
+
+	context = current->maze_context;
+	if (context) {
+		spin_lock(&context->lock);
+		if (!context->state) {
+			set_preempt_notifier(context);
+			check_limit(context);
+		}
+		spin_unlock(&context->lock);
+	}
+
+	if (!list_empty(&__get_cpu_var(maze_queue))) {
+		list_for_each_entry_safe(context, next,
+				    &__get_cpu_var(maze_queue), queue) {
+			spin_lock(&context->lock);
+
+			if (context->state & MAZE_EXIT) {
+				list_del(&context->queue);
+				spin_unlock(&context->lock);
+				kfree(context);
+				continue;
+			}
+
+			check_limit(context);
+			list_del(&context->queue);
+			context->state = 0;
+			spin_unlock(&context->lock);
+		}
+	}
+
+	continue_timer(smp_processor_id());
+}
+
+static int maze_entries_file_show(struct seq_file *seq, void *nouse)
+{
+	struct maze_context *context;
+
+	spin_lock(&maze_list_lock);
+
+	list_for_each_entry(context, &maze_list, list) {
+		seq_printf(seq, "pid:%5d   ", context->task->pid);
+		seq_printf(seq, "count:%6ld  ", get_maze_count(context));
+		seq_printf(seq, "soft-limit:%6ld  ", context->soft_limit);
+		seq_printf(seq, "hard-limit:%6ld  ", context->hard_limit);
+		seq_printf(seq, "soft-signal:%2d  ", context->soft_signal);
+		seq_printf(seq, "hard-signal:%2d  ", context->hard_signal);
+		seq_printf(seq, "\n");
+	}
+
+	spin_unlock(&maze_list_lock);
+
+	return 0;
+}
+
+/*
+ * Open operation of /proc/maze/entries
+ */
+static int maze_entries_file_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, maze_entries_file_show, NULL);
+}
+
+/*
+ * Release operation of /proc/maze/entries
+ */
+static int maze_entries_file_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+/*
+ * Write operation of /proc/maze/entries
+ */
+static ssize_t maze_entries_file_write(struct file *file,
+					const char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	struct maze_context *context;
+	char read_line[32];
+	int ret, pid;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (count > sizeof(read_line) - 1)
+		return -EINVAL;
+
+	if (copy_from_user(read_line, buffer, count))
+		return -EFAULT;
+
+	read_line[count] = '\0';
+
+	context = kzalloc(sizeof(struct maze_context), GFP_KERNEL);
+	if (unlikely(!context)) {
+		ERRPRINT("fail to alloc maze_context.\n");
+		return -ENOMEM;
+	}
+
+	ret = build_maze_context(read_line, context, &pid);
+	if (ret) {
+		kfree(context);
+		return ret;
+	}
+
+	if (add_maze_context(pid, context))
+		/* Free maze_context, if already added it. */
+		kfree(context);
+
+	return count;
+}
+
+static struct file_operations maze_entries_file_ops = {
+	.owner	 = THIS_MODULE,
+	.open	 = maze_entries_file_open,
+	.read	 = seq_read,
+	.write   = maze_entries_file_write,
+	.llseek	 = seq_lseek,
+	.release = maze_entries_file_release,
+};
+
+/*
+ * Creating /proc/maze/
+ */
+static int init_dir(void)
+{
+	maze_proc_dir =
+		create_proc_entry("maze", S_IFDIR | S_IRUGO | S_IXUGO, NULL);
+
+	if (!maze_proc_dir)
+		panic("fail to create /proc/maze\n");
+
+	return 0;
+}
+
+/*
+ * Creating /proc/maze/entries
+ */
+static int init_entries(void)
+{
+	struct proc_dir_entry *p;
+
+	p = create_proc_entry("entries", S_IRUGO, maze_proc_dir);
+	if (p == NULL)
+		panic("fail to create /proc/maze/entries\n");
+
+	p->proc_fops = &maze_entries_file_ops;
+
+	return 0;
+}
+
+/*
+ * Initializ maze procfs.
+ */
+static void __init init_proc(void)
+{
+	init_dir();
+	init_entries();
+}
+
+/*
+ * Initializ timer and queue
+ */
+static void __init init_cpu(int cpu)
+{
+	INIT_LIST_HEAD(&per_cpu(maze_queue, cpu));
+
+	/* Setup softirq timer */
+	continue_timer(cpu);
+}
+
+static int __init maze_init(void)
+{
+	int cpu;
+
+	printk(KERN_INFO "Maze: Initializing\n");
+	init_proc();
+
+	/* Initializ interval of softirq timer */
+	maze_timer_interval = msecs_to_jiffies(CONFIG_MAZE_TIMER);
+
+	/* Initializ each cpu's timer and queue */
+	for_each_online_cpu(cpu)
+		init_cpu(cpu);
+
+	return 0;
+}
+__initcall(maze_init);
--- linux-2.6.26-rc2-mm1.orig/kernel/sched.c	2008-05-22 10:08:46.000000000 +0900
+++ linux-2.6.26-rc2-mm1/kernel/sched.c	2008-05-22 10:11:59.000000000 +0900
@@ -71,6 +71,7 @@
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
+#include <linux/maze.h>

 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -5557,6 +5558,8 @@ asmlinkage long sys_sched_yield(void)
 	_raw_spin_unlock(&rq->lock);
 	preempt_enable_no_resched();

+	maze_sched_yield(current);
+
 	schedule();

 	return 0;



