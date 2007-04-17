Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbXDQLcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbXDQLcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXDQLcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:32:14 -0400
Received: from holomorphy.com ([66.93.40.71]:41124 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbXDQLcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:32:10 -0400
Date: Tue, 17 Apr 2007 04:31:34 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>, Nick Piggin <npiggin@suse.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417113134.GW8915@holomorphy.com>
References: <46244A52.4000403@bigpond.net.au> <20070417042954.GG25513@wotan.suse.de> <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <Pine.LNX.4.64.0704162317330.30516@alien.or.mcafeemobile.com> <20070417070949.GR8915@holomorphy.com> <20070417073308.GB30559@elte.hu> <20070417090538.GU8915@holomorphy.com> <20070417092422.GA19414@elte.hu> <20070417095749.GN2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417095749.GN2986@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 02:57:49AM -0700, William Lee Irwin III wrote:
> Interesting! That's what vdls did, except its fundamental data structure
> was more like a circular buffer data structure (resembling Davide
> Libenzi's timer ring in concept, but with all the details different).
> I'm not entirely sure how that would've turned out performancewise if
> I'd done any tuning at all. I was mostly interested in doing something
> like what I heard Bob Mullens did in 1976 for basic pedagogical value
> about schedulers to prepare for writing patches for gang scheduling as
> opposed to creating a viable replacement for the mainline scheduler.

Con helped me dredge up the vdls bits, so here is the last version I
before I got tired of toying with the idea. It's not all that clean,
with a fair amount of debug code floating around and a number of
idiocies (it seems there was a plot to use a heap somewhere I forgot
about entirely, never mind other cruft), but I thought I should at least
say something more provable than "there was a patch I never posted."

Enjoy!


-- wli

diff -prauN linux-2.6.0-test11/fs/proc/array.c sched-2.6.0-test11-5/fs/proc/array.c
--- linux-2.6.0-test11/fs/proc/array.c	2003-11-26 12:44:26.000000000 -0800
+++ sched-2.6.0-test11-5/fs/proc/array.c	2003-12-17 07:37:11.000000000 -0800
@@ -162,7 +162,7 @@ static inline char * task_state(struct t
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
-		(p->sleep_avg/1024)*100/(1000000000/1024),
+		0UL, /* was ->sleep_avg */
 	       	p->tgid,
 		p->pid, p->pid ? p->real_parent->pid : 0,
 		p->pid && p->ptrace ? p->parent->pid : 0,
@@ -345,7 +345,7 @@ int proc_pid_stat(struct task_struct *ta
 	read_unlock(&tasklist_lock);
 	res = sprintf(buffer,"%d (%s) %c %d %d %d %d %d %lu %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d %ld %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %lu %lu\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %d %d\n",
 		task->pid,
 		task->comm,
 		state,
@@ -390,8 +390,8 @@ int proc_pid_stat(struct task_struct *ta
 		task->cnswap,
 		task->exit_signal,
 		task_cpu(task),
-		task->rt_priority,
-		task->policy);
+		task_prio(task),
+		task_sched_policy(task));
 	if(mm)
 		mmput(mm);
 	return res;
diff -prauN linux-2.6.0-test11/include/asm-i386/thread_info.h sched-2.6.0-test11-5/include/asm-i386/thread_info.h
--- linux-2.6.0-test11/include/asm-i386/thread_info.h	2003-11-26 12:43:06.000000000 -0800
+++ sched-2.6.0-test11-5/include/asm-i386/thread_info.h	2003-12-17 04:55:22.000000000 -0800
@@ -114,6 +114,8 @@ static inline struct thread_info *curren
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_IRET		5	/* return with iret */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_QUEUED		17
+#define TIF_PREEMPT		18
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -prauN linux-2.6.0-test11/include/linux/binomial.h sched-2.6.0-test11-5/include/linux/binomial.h
--- linux-2.6.0-test11/include/linux/binomial.h	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/include/linux/binomial.h	2003-12-20 15:53:33.000000000 -0800
@@ -0,0 +1,16 @@
+/*
+ * Simple binomial heaps.
+ */
+
+struct binomial {
+	unsigned priority, degree;
+	struct binomial *parent, *child, *sibling;
+};
+
+
+struct binomial *binomial_minimum(struct binomial **);
+void binomial_union(struct binomial **, struct binomial **, struct binomial **);
+void binomial_insert(struct binomial **, struct binomial *);
+struct binomial *binomial_extract_min(struct binomial **);
+void binomial_decrease(struct binomial **, struct binomial *, unsigned);
+void binomial_delete(struct binomial **, struct binomial *);
diff -prauN linux-2.6.0-test11/include/linux/init_task.h sched-2.6.0-test11-5/include/linux/init_task.h
--- linux-2.6.0-test11/include/linux/init_task.h	2003-11-26 12:42:58.000000000 -0800
+++ sched-2.6.0-test11-5/include/linux/init_task.h	2003-12-18 05:51:16.000000000 -0800
@@ -56,6 +56,12 @@
 	.siglock	= SPIN_LOCK_UNLOCKED, 		\
 }
 
+#define INIT_SCHED_INFO(info)					\
+{								\
+	.run_list	= LIST_HEAD_INIT((info).run_list),	\
+	.policy		= 1 /* SCHED_POLICY_TS */,		\
+}
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -67,14 +73,10 @@
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= 0,						\
 	.lock_depth	= -1,						\
-	.prio		= MAX_PRIO-20,					\
-	.static_prio	= MAX_PRIO-20,					\
-	.policy		= SCHED_NORMAL,					\
+	.sched_info	= INIT_SCHED_INFO(tsk.sched_info),		\
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
-	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
-	.time_slice	= HZ,						\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
 	.ptrace_list	= LIST_HEAD_INIT(tsk.ptrace_list),		\
diff -prauN linux-2.6.0-test11/include/linux/sched.h sched-2.6.0-test11-5/include/linux/sched.h
--- linux-2.6.0-test11/include/linux/sched.h	2003-11-26 12:42:58.000000000 -0800
+++ sched-2.6.0-test11-5/include/linux/sched.h	2003-12-23 03:47:45.000000000 -0800
@@ -126,6 +126,8 @@ extern unsigned long nr_iowait(void);
 #define SCHED_NORMAL		0
 #define SCHED_FIFO		1
 #define SCHED_RR		2
+#define SCHED_BATCH		3
+#define SCHED_IDLE		4
 
 struct sched_param {
 	int sched_priority;
@@ -281,10 +283,14 @@ struct signal_struct {
 
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
-
-#define rt_task(p)		((p)->prio < MAX_RT_PRIO)
+#define NICE_QLEN		128
+#define MIN_TS_PRIO		MAX_RT_PRIO
+#define MAX_TS_PRIO		(40*NICE_QLEN)
+#define MIN_BATCH_PRIO		(MAX_RT_PRIO + MAX_TS_PRIO)
+#define MAX_BATCH_PRIO		100
+#define MAX_PRIO		(MIN_BATCH_PRIO + MAX_BATCH_PRIO)
+#define USER_PRIO(prio)		((prio) - MAX_RT_PRIO)
+#define MAX_USER_PRIO		USER_PRIO(MAX_PRIO)
 
 /*
  * Some day this will be a full-fledged user tracking system..
@@ -330,6 +336,36 @@ struct k_itimer {
 struct io_context;			/* See blkdev.h */
 void exit_io_context(void);
 
+struct rt_data {
+	int prio, rt_policy;
+	unsigned long quantum, ticks; 
+};
+
+/* XXX: do %cpu estimation for ts wakeup levels */
+struct ts_data {
+	int nice;
+	unsigned long ticks, frac_cpu;
+	unsigned long sample_start, sample_ticks;
+};
+
+struct bt_data {
+	int prio;
+	unsigned long ticks;
+};
+
+union class_data {
+	struct rt_data rt;
+	struct ts_data ts;
+	struct bt_data bt;
+};
+
+struct sched_info {
+	int idx;			/* queue index, used by all classes */
+	unsigned long policy;		/* scheduling policy */
+	struct list_head run_list;	/* list links for priority queues */
+	union class_data cl_data;	/* class-specific data */
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	struct thread_info *thread_info;
@@ -339,18 +375,9 @@ struct task_struct {
 
 	int lock_depth;		/* Lock depth */
 
-	int prio, static_prio;
-	struct list_head run_list;
-	prio_array_t *array;
-
-	unsigned long sleep_avg;
-	long interactive_credit;
-	unsigned long long timestamp;
-	int activated;
+	struct sched_info sched_info;
 
-	unsigned long policy;
 	cpumask_t cpus_allowed;
-	unsigned int time_slice, first_time_slice;
 
 	struct list_head tasks;
 	struct list_head ptrace_children;
@@ -391,7 +418,6 @@ struct task_struct {
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
-	unsigned long rt_priority;
 	unsigned long it_real_value, it_prof_value, it_virt_value;
 	unsigned long it_real_incr, it_prof_incr, it_virt_incr;
 	struct timer_list real_timer;
@@ -520,12 +546,14 @@ extern void node_nr_running_init(void);
 #define node_nr_running_init() {}
 #endif
 
-extern void set_user_nice(task_t *p, long nice);
-extern int task_prio(task_t *p);
-extern int task_nice(task_t *p);
-extern int task_curr(task_t *p);
-extern int idle_cpu(int cpu);
-
+void set_user_nice(task_t *task, long nice);
+int task_prio(task_t *task);
+int task_nice(task_t *task);
+int task_sched_policy(task_t *task);
+void set_task_sched_policy(task_t *task, int policy);
+int rt_task(task_t *task);
+int task_curr(task_t *task);
+int idle_cpu(int cpu);
 void yield(void);
 
 /*
@@ -844,6 +872,21 @@ static inline int need_resched(void)
 	return unlikely(test_thread_flag(TIF_NEED_RESCHED));
 }
 
+static inline void set_task_queued(task_t *task)
+{
+	set_tsk_thread_flag(task, TIF_QUEUED);
+}
+
+static inline void clear_task_queued(task_t *task)
+{
+	clear_tsk_thread_flag(task, TIF_QUEUED);
+}
+
+static inline int task_queued(task_t *task)
+{
+	return test_tsk_thread_flag(task, TIF_QUEUED);
+}
+
 extern void __cond_resched(void);
 static inline void cond_resched(void)
 {
diff -prauN linux-2.6.0-test11/kernel/Makefile sched-2.6.0-test11-5/kernel/Makefile
--- linux-2.6.0-test11/kernel/Makefile	2003-11-26 12:43:24.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/Makefile	2003-12-17 03:30:08.000000000 -0800
@@ -6,7 +6,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
-	    rcupdate.o intermodule.o extable.o params.o posix-timers.o
+	    rcupdate.o intermodule.o extable.o params.o posix-timers.o sched/
 
 obj-$(CONFIG_FUTEX) += futex.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
diff -prauN linux-2.6.0-test11/kernel/exit.c sched-2.6.0-test11-5/kernel/exit.c
--- linux-2.6.0-test11/kernel/exit.c	2003-11-26 12:45:29.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/exit.c	2003-12-17 07:04:02.000000000 -0800
@@ -225,7 +225,7 @@ void reparent_to_init(void)
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
 	current->exit_signal = SIGCHLD;
 
-	if ((current->policy == SCHED_NORMAL) && (task_nice(current) < 0))
+	if (task_nice(current) < 0)
 		set_user_nice(current, 0);
 	/* cpus_allowed? */
 	/* rt_priority? */
diff -prauN linux-2.6.0-test11/kernel/fork.c sched-2.6.0-test11-5/kernel/fork.c
--- linux-2.6.0-test11/kernel/fork.c	2003-11-26 12:42:58.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/fork.c	2003-12-23 06:22:59.000000000 -0800
@@ -836,6 +836,9 @@ struct task_struct *copy_process(unsigne
 	atomic_inc(&p->user->__count);
 	atomic_inc(&p->user->processes);
 
+	clear_tsk_thread_flag(p, TIF_SIGPENDING);
+	clear_tsk_thread_flag(p, TIF_QUEUED);
+
 	/*
 	 * If multiple threads are within copy_process(), then this check
 	 * triggers too late. This doesn't hurt, the check is only there
@@ -861,13 +864,21 @@ struct task_struct *copy_process(unsigne
 	p->state = TASK_UNINTERRUPTIBLE;
 
 	copy_flags(clone_flags, p);
-	if (clone_flags & CLONE_IDLETASK)
+	if (clone_flags & CLONE_IDLETASK) {
 		p->pid = 0;
-	else {
+		set_task_sched_policy(p, SCHED_IDLE);
+	} else {
+		if (task_sched_policy(p) == SCHED_IDLE) {
+			memset(&p->sched_info, 0, sizeof(struct sched_info));
+			set_task_sched_policy(p, SCHED_NORMAL);
+			set_user_nice(p, 0);
+		}
 		p->pid = alloc_pidmap();
 		if (p->pid == -1)
 			goto bad_fork_cleanup;
 	}
+	if (p->pid == 1)
+		BUG_ON(task_nice(p));
 	retval = -EFAULT;
 	if (clone_flags & CLONE_PARENT_SETTID)
 		if (put_user(p->pid, parent_tidptr))
@@ -875,8 +886,7 @@ struct task_struct *copy_process(unsigne
 
 	p->proc_dentry = NULL;
 
-	INIT_LIST_HEAD(&p->run_list);
-
+	INIT_LIST_HEAD(&p->sched_info.run_list);
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	INIT_LIST_HEAD(&p->posix_timers);
@@ -885,8 +895,6 @@ struct task_struct *copy_process(unsigne
 	spin_lock_init(&p->alloc_lock);
 	spin_lock_init(&p->switch_lock);
 	spin_lock_init(&p->proc_lock);
-
-	clear_tsk_thread_flag(p, TIF_SIGPENDING);
 	init_sigpending(&p->pending);
 
 	p->it_real_value = p->it_virt_value = p->it_prof_value = 0;
@@ -898,7 +906,6 @@ struct task_struct *copy_process(unsigne
 	p->tty_old_pgrp = 0;
 	p->utime = p->stime = 0;
 	p->cutime = p->cstime = 0;
-	p->array = NULL;
 	p->lock_depth = -1;		/* -1 = no lock */
 	p->start_time = get_jiffies_64();
 	p->security = NULL;
@@ -948,33 +955,6 @@ struct task_struct *copy_process(unsigne
 	p->pdeath_signal = 0;
 
 	/*
-	 * Share the timeslice between parent and child, thus the
-	 * total amount of pending timeslices in the system doesn't change,
-	 * resulting in more scheduling fairness.
-	 */
-	local_irq_disable();
-        p->time_slice = (current->time_slice + 1) >> 1;
-	/*
-	 * The remainder of the first timeslice might be recovered by
-	 * the parent if the child exits early enough.
-	 */
-	p->first_time_slice = 1;
-	current->time_slice >>= 1;
-	p->timestamp = sched_clock();
-	if (!current->time_slice) {
-		/*
-	 	 * This case is rare, it happens when the parent has only
-	 	 * a single jiffy left from its timeslice. Taking the
-		 * runqueue lock is not a problem.
-		 */
-		current->time_slice = 1;
-		preempt_disable();
-		scheduler_tick(0, 0);
-		local_irq_enable();
-		preempt_enable();
-	} else
-		local_irq_enable();
-	/*
 	 * Ok, add it to the run-queues and make it
 	 * visible to the rest of the system.
 	 *
diff -prauN linux-2.6.0-test11/kernel/sched/Makefile sched-2.6.0-test11-5/kernel/sched/Makefile
--- linux-2.6.0-test11/kernel/sched/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/Makefile	2003-12-17 03:32:21.000000000 -0800
@@ -0,0 +1 @@
+obj-y = util.o ts.o idle.o rt.o batch.o
diff -prauN linux-2.6.0-test11/kernel/sched/batch.c sched-2.6.0-test11-5/kernel/sched/batch.c
--- linux-2.6.0-test11/kernel/sched/batch.c	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/batch.c	2003-12-19 21:32:49.000000000 -0800
@@ -0,0 +1,190 @@
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <linux/kernel_stat.h>
+#include <asm/page.h>
+#include "queue.h"
+
+struct batch_queue {
+	int base, tasks;
+	task_t *curr;
+	unsigned long bitmap[BITS_TO_LONGS(MAX_BATCH_PRIO)];
+	struct list_head queue[MAX_BATCH_PRIO];
+};
+
+static int batch_quantum = 1024;
+static DEFINE_PER_CPU(struct batch_queue, batch_queues);
+
+static int batch_init(struct policy *policy, int cpu)
+{
+	int k;
+	struct batch_queue *queue = &per_cpu(batch_queues, cpu);
+
+	policy->queue = (struct queue *)queue;
+	for (k = 0; k < MAX_BATCH_PRIO; ++k)
+		INIT_LIST_HEAD(&queue->queue[k]);
+	return 0;
+}
+
+static int batch_tick(struct queue *__queue, task_t *task, int user_ticks, int sys_ticks)
+{
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+
+	cpustat->nice += user_ticks;
+	cpustat->system += sys_ticks;
+
+	task->sched_info.cl_data.bt.ticks--;
+	if (!task->sched_info.cl_data.bt.ticks) {
+		int new_idx;
+
+		task->sched_info.cl_data.bt.ticks = batch_quantum;
+		new_idx = (task->sched_info.idx + task->sched_info.cl_data.bt.prio)
+				% MAX_BATCH_PRIO;
+		if (!test_bit(new_idx, queue->bitmap))
+			__set_bit(new_idx, queue->bitmap);
+		list_move_tail(&task->sched_info.run_list,
+				&queue->queue[new_idx]);
+		if (list_empty(&queue->queue[task->sched_info.idx]))
+			__clear_bit(task->sched_info.idx, queue->bitmap);
+		task->sched_info.idx = new_idx;
+		queue->base = find_first_circular_bit(queue->bitmap,
+							queue->base,
+							MAX_BATCH_PRIO);
+		set_need_resched();
+	}
+	return 0;
+}
+
+static void batch_yield(struct queue *__queue, task_t *task)
+{
+	int new_idx;
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+
+	new_idx = (queue->base + MAX_BATCH_PRIO - 1) % MAX_BATCH_PRIO;
+	if (!test_bit(new_idx, queue->bitmap))
+		__set_bit(new_idx, queue->bitmap);
+	list_move_tail(&task->sched_info.run_list, &queue->queue[new_idx]);
+	if (list_empty(&queue->queue[task->sched_info.idx]))
+		__clear_bit(task->sched_info.idx, queue->bitmap);
+	task->sched_info.idx = new_idx;
+	queue->base = find_first_circular_bit(queue->bitmap,
+						queue->base,
+						MAX_BATCH_PRIO);
+	set_need_resched();
+}
+
+static task_t *batch_curr(struct queue *__queue)
+{
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+	return queue->curr;
+}
+
+static void batch_set_curr(struct queue *__queue, task_t *task)
+{
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+	queue->curr = task;
+}
+
+static task_t *batch_best(struct queue *__queue)
+{
+	int idx;
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+
+	idx = find_first_circular_bit(queue->bitmap,
+					queue->base,
+					MAX_BATCH_PRIO);
+	BUG_ON(idx >= MAX_BATCH_PRIO);
+	BUG_ON(list_empty(&queue->queue[idx]));
+	return list_entry(queue->queue[idx].next, task_t, sched_info.run_list);
+}
+
+static void batch_enqueue(struct queue *__queue, task_t *task)
+{
+	int idx;
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+
+	idx = (queue->base + task->sched_info.cl_data.bt.prio) % MAX_BATCH_PRIO;
+	if (!test_bit(idx, queue->bitmap))
+		__set_bit(idx, queue->bitmap);
+	list_add_tail(&task->sched_info.run_list, &queue->queue[idx]);
+	task->sched_info.idx = idx;
+	task->sched_info.cl_data.bt.ticks = batch_quantum;
+	queue->tasks++;
+	if (!queue->curr)
+		queue->curr = task;
+}
+
+static void batch_dequeue(struct queue *__queue, task_t *task)
+{
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+	list_del(&task->sched_info.run_list);
+	if (list_empty(&queue->queue[task->sched_info.idx]))
+		__clear_bit(task->sched_info.idx, queue->bitmap);
+	queue->tasks--;
+	if (!queue->tasks)
+		queue->curr = NULL;
+	else if (task == queue->curr)
+		queue->curr = batch_best(__queue);
+}
+
+static int batch_preempt(struct queue *__queue, task_t *task)
+{
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+	if (!queue->curr)
+		return 1;
+	else
+		return task->sched_info.cl_data.bt.prio
+				< queue->curr->sched_info.cl_data.bt.prio;
+}
+
+static int batch_tasks(struct queue *__queue)
+{
+	struct batch_queue *queue = (struct batch_queue *)__queue;
+	return queue->tasks;
+}
+
+static int batch_nice(struct queue *queue, task_t *task)
+{
+	return 20;
+}
+
+static int batch_prio(task_t *task)
+{
+	return USER_PRIO(task->sched_info.cl_data.bt.prio + MIN_BATCH_PRIO);
+}
+
+static void batch_setprio(task_t *task, int prio)
+{
+	BUG_ON(prio < 0);
+	BUG_ON(prio >= MAX_BATCH_PRIO);
+	task->sched_info.cl_data.bt.prio = prio;
+}
+
+struct queue_ops batch_ops = {
+	.init		= batch_init,
+	.fini		= nop_fini,
+	.tick		= batch_tick,
+	.yield		= batch_yield,
+	.curr		= batch_curr,
+	.set_curr	= batch_set_curr,
+	.tasks		= batch_tasks,
+	.best		= batch_best,
+	.enqueue	= batch_enqueue,
+	.dequeue	= batch_dequeue,
+	.start_wait	= queue_nop,
+	.stop_wait	= queue_nop,
+	.sleep		= queue_nop,
+	.wake		= queue_nop,
+	.preempt	= batch_preempt,
+	.nice		= batch_nice,
+	.renice		= nop_renice,
+	.prio		= batch_prio,
+	.setprio	= batch_setprio,
+	.timeslice	= nop_timeslice,
+	.set_timeslice	= nop_set_timeslice,
+};
+
+struct policy batch_policy = {
+	.ops	= &batch_ops,
+};
diff -prauN linux-2.6.0-test11/kernel/sched/idle.c sched-2.6.0-test11-5/kernel/sched/idle.c
--- linux-2.6.0-test11/kernel/sched/idle.c	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/idle.c	2003-12-19 17:31:39.000000000 -0800
@@ -0,0 +1,99 @@
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <linux/kernel_stat.h>
+#include <asm/page.h>
+#include "queue.h"
+
+static DEFINE_PER_CPU(task_t *, idle_tasks) = NULL;
+
+static int idle_nice(struct queue *queue, task_t *task)
+{
+	return 20;
+}
+
+static int idle_tasks(struct queue *queue)
+{
+	task_t **idle = (task_t **)queue;
+	return !!(*idle);
+}
+
+static task_t *idle_task(struct queue *queue)
+{
+	return *((task_t **)queue);
+}
+
+static void idle_yield(struct queue *queue, task_t *task)
+{
+	set_need_resched();
+}
+
+static void idle_enqueue(struct queue *queue, task_t *task)
+{
+	task_t **idle = (task_t **)queue;
+	*idle = task;
+}
+
+static void idle_dequeue(struct queue *queue, task_t *task)
+{
+}
+
+static int idle_preempt(struct queue *queue, task_t *task)
+{
+	return 0;
+}
+
+static int idle_tick(struct queue *queue, task_t *task, int user_ticks, int sys_ticks)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	runqueue_t *rq = &per_cpu(runqueues, smp_processor_id());
+
+	if (atomic_read(&rq->nr_iowait) > 0)
+		cpustat->iowait += sys_ticks;
+	else
+		cpustat->idle += sys_ticks;
+	return 1;
+}
+
+static int idle_init(struct policy *policy, int cpu)
+{
+	policy->queue = (struct queue *)&per_cpu(idle_tasks, cpu);
+	return 0;
+}
+
+static int idle_prio(task_t *task)
+{
+	return MAX_USER_PRIO;
+}
+
+static void idle_setprio(task_t *task, int prio)
+{
+}
+
+static struct queue_ops idle_ops = {
+	.init		= idle_init,
+	.fini		= nop_fini,
+	.tick		= idle_tick,
+	.yield		= idle_yield,
+	.curr		= idle_task,
+	.set_curr	= queue_nop,
+	.tasks		= idle_tasks,
+	.best		= idle_task,
+	.enqueue	= idle_enqueue,
+	.dequeue	= idle_dequeue,
+	.start_wait	= queue_nop,
+	.stop_wait	= queue_nop,
+	.sleep		= queue_nop,
+	.wake		= queue_nop,
+	.preempt	= idle_preempt,
+	.nice		= idle_nice,
+	.renice		= nop_renice,
+	.prio		= idle_prio,
+	.setprio	= idle_setprio,
+	.timeslice	= nop_timeslice,
+	.set_timeslice	= nop_set_timeslice,
+};
+
+struct policy idle_policy = {
+	.ops	= &idle_ops,
+};
diff -prauN linux-2.6.0-test11/kernel/sched/queue.h sched-2.6.0-test11-5/kernel/sched/queue.h
--- linux-2.6.0-test11/kernel/sched/queue.h	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/queue.h	2003-12-23 03:58:02.000000000 -0800
@@ -0,0 +1,104 @@
+#define SCHED_POLICY_RT		0
+#define SCHED_POLICY_TS		1
+#define SCHED_POLICY_BATCH	2
+#define SCHED_POLICY_IDLE	3
+
+#define RT_POLICY_FIFO		0
+#define RT_POLICY_RR		1
+
+#define NODE_THRESHOLD		125
+
+struct queue;
+struct queue_ops;
+
+struct policy {
+	struct queue *queue;
+	struct queue_ops *ops;
+};
+
+extern struct policy rt_policy, ts_policy, batch_policy, idle_policy;
+
+struct runqueue {
+        spinlock_t lock;
+	int curr;
+	task_t *__curr;
+	unsigned long policy_bitmap;
+	struct policy *policies[BITS_PER_LONG];
+        unsigned long nr_running, nr_switches, nr_uninterruptible;
+        struct mm_struct *prev_mm;
+        int prev_cpu_load[NR_CPUS];
+#ifdef CONFIG_NUMA
+        atomic_t *node_nr_running;
+        int prev_node_load[MAX_NUMNODES];
+#endif
+        task_t *migration_thread;
+        struct list_head migration_queue;
+
+        atomic_t nr_iowait;
+};
+
+typedef struct runqueue runqueue_t;
+
+struct queue_ops {
+	int (*init)(struct policy *, int);
+	void (*fini)(struct policy *, int);
+	task_t *(*curr)(struct queue *);
+	void (*set_curr)(struct queue *, task_t *);
+	task_t *(*best)(struct queue *);
+	int (*tick)(struct queue *, task_t *, int, int);
+	int (*tasks)(struct queue *);
+	void (*enqueue)(struct queue *, task_t *);
+	void (*dequeue)(struct queue *, task_t *);
+	void (*start_wait)(struct queue *, task_t *);
+	void (*stop_wait)(struct queue *, task_t *);
+	void (*sleep)(struct queue *, task_t *);
+	void (*wake)(struct queue *, task_t *);
+	int (*preempt)(struct queue *, task_t *);
+	void (*yield)(struct queue *, task_t *);
+	int (*prio)(task_t *);
+	void (*setprio)(task_t *, int);
+	int (*nice)(struct queue *, task_t *);
+	void (*renice)(struct queue *, task_t *, int);
+	unsigned long (*timeslice)(struct queue *, task_t *);
+	void (*set_timeslice)(struct queue *, task_t *, unsigned long);
+};
+
+DECLARE_PER_CPU(runqueue_t, runqueues);
+
+int find_first_circular_bit(unsigned long *, int, int);
+void queue_nop(struct queue *, task_t *);
+void nop_renice(struct queue *, task_t *, int);
+void nop_fini(struct policy *, int);
+unsigned long nop_timeslice(struct queue *, task_t *);
+void nop_set_timeslice(struct queue *, task_t *, unsigned long);
+
+/* #define DEBUG_SCHED */
+
+#ifdef DEBUG_SCHED
+#define __check_task_policy(idx)					\
+do {									\
+	unsigned long __idx__ = (idx);					\
+	if (__idx__ > SCHED_POLICY_IDLE) {				\
+		printk("invalid policy 0x%lx\n", __idx__);		\
+		BUG();							\
+	}								\
+} while (0)
+
+#define check_task_policy(task)						\
+do {									\
+	__check_task_policy((task)->sched_info.policy);			\
+} while (0)
+
+#define check_policy(policy)						\
+do {									\
+	BUG_ON((policy) != &rt_policy &&				\
+		(policy) != &ts_policy &&				\
+		(policy) != &batch_policy &&				\
+		(policy) != &idle_policy);				\
+} while (0)
+
+#else /* !DEBUG_SCHED */
+#define __check_task_policy(idx)			do { } while (0)
+#define check_task_policy(task)				do { } while (0)
+#define check_policy(policy)				do { } while (0)
+#endif /* !DEBUG_SCHED */
diff -prauN linux-2.6.0-test11/kernel/sched/rt.c sched-2.6.0-test11-5/kernel/sched/rt.c
--- linux-2.6.0-test11/kernel/sched/rt.c	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/rt.c	2003-12-19 18:16:07.000000000 -0800
@@ -0,0 +1,208 @@
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <linux/kernel_stat.h>
+#include <asm/page.h>
+#include "queue.h"
+
+#ifdef DEBUG_SCHED
+#define check_rt_policy(task)						\
+do {									\
+	BUG_ON((task)->sched_info.policy != SCHED_POLICY_RT);		\
+	BUG_ON((task)->sched_info.cl_data.rt.rt_policy != RT_POLICY_RR	\
+			&&						\
+	      (task)->sched_info.cl_data.rt.rt_policy!=RT_POLICY_FIFO);	\
+	BUG_ON((task)->sched_info.cl_data.rt.prio < 0);			\
+	BUG_ON((task)->sched_info.cl_data.rt.prio >= MAX_RT_PRIO);	\
+} while (0)
+#else
+#define check_rt_policy(task)				do { } while (0)
+#endif
+
+struct rt_queue {
+	unsigned long bitmap[BITS_TO_LONGS(MAX_RT_PRIO)];
+	struct list_head queue[MAX_RT_PRIO];
+	task_t *curr;
+	int tasks;
+};
+
+static DEFINE_PER_CPU(struct rt_queue, rt_queues);
+
+static int rt_init(struct policy *policy, int cpu)
+{
+	int k;
+	struct rt_queue *queue = &per_cpu(rt_queues, cpu);
+
+	policy->queue = (struct queue *)queue;
+	for (k = 0; k < MAX_RT_PRIO; ++k)
+		INIT_LIST_HEAD(&queue->queue[k]);
+	return 0;
+}
+
+static void rt_yield(struct queue *__queue, task_t *task)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	check_rt_policy(task);
+	list_del(&task->sched_info.run_list);
+	if (list_empty(&queue->queue[task->sched_info.cl_data.rt.prio]))
+		set_need_resched();
+	list_add_tail(&task->sched_info.run_list,
+			&queue->queue[task->sched_info.cl_data.rt.prio]);
+	check_rt_policy(task);
+}
+
+static int rt_tick(struct queue *queue, task_t *task, int user_ticks, int sys_ticks)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	check_rt_policy(task);
+	cpustat->user += user_ticks;
+	cpustat->system += sys_ticks;
+	if (task->sched_info.cl_data.rt.rt_policy == RT_POLICY_RR) {
+		task->sched_info.cl_data.rt.ticks--;
+		if (!task->sched_info.cl_data.rt.ticks) {
+			task->sched_info.cl_data.rt.ticks =
+				task->sched_info.cl_data.rt.quantum;
+			rt_yield(queue, task);
+		}
+	}
+	check_rt_policy(task);
+	return 0;
+}
+
+static task_t *rt_curr(struct queue *__queue)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	task_t *task = queue->curr;
+	check_rt_policy(task);
+	return task;
+}
+
+static void rt_set_curr(struct queue *__queue, task_t *task)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	queue->curr = task;
+	check_rt_policy(task);
+}
+
+static task_t *rt_best(struct queue *__queue)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	task_t *task;
+	int idx;
+	idx = find_first_bit(queue->bitmap, MAX_RT_PRIO);
+	BUG_ON(idx >= MAX_RT_PRIO);
+	task = list_entry(queue->queue[idx].next, task_t, sched_info.run_list);
+	check_rt_policy(task);
+	return task;
+}
+
+static void rt_enqueue(struct queue *__queue, task_t *task)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	check_rt_policy(task);
+	if (!test_bit(task->sched_info.cl_data.rt.prio, queue->bitmap))
+		__set_bit(task->sched_info.cl_data.rt.prio, queue->bitmap);
+	list_add_tail(&task->sched_info.run_list,
+			&queue->queue[task->sched_info.cl_data.rt.prio]);
+	check_rt_policy(task);
+	queue->tasks++;
+	if (!queue->curr)
+		queue->curr = task;
+}
+
+static void rt_dequeue(struct queue *__queue, task_t *task)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	check_rt_policy(task);
+	list_del(&task->sched_info.run_list);
+	if (list_empty(&queue->queue[task->sched_info.cl_data.rt.prio]))
+		__clear_bit(task->sched_info.cl_data.rt.prio, queue->bitmap);
+	queue->tasks--;
+	check_rt_policy(task);
+	if (!queue->tasks)
+		queue->curr = NULL;
+	else if (task == queue->curr)
+		queue->curr = rt_best(__queue);
+}
+
+static int rt_preempt(struct queue *__queue, task_t *task)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	check_rt_policy(task);
+	if (!queue->curr)
+		return 1;
+	check_rt_policy(queue->curr);
+	return task->sched_info.cl_data.rt.prio
+			< queue->curr->sched_info.cl_data.rt.prio;
+}
+
+static int rt_tasks(struct queue *__queue)
+{
+	struct rt_queue *queue = (struct rt_queue *)__queue;
+	return queue->tasks;
+}
+
+static int rt_nice(struct queue *queue, task_t *task)
+{
+	check_rt_policy(task);
+	return -20;
+}
+
+static unsigned long rt_timeslice(struct queue *queue, task_t *task)
+{
+	check_rt_policy(task);
+	if (task->sched_info.cl_data.rt.rt_policy != RT_POLICY_RR)
+		return 0;
+	else
+		return task->sched_info.cl_data.rt.quantum;
+}
+
+static void rt_set_timeslice(struct queue *queue, task_t *task, unsigned long n)
+{
+	check_rt_policy(task);
+	if (task->sched_info.cl_data.rt.rt_policy == RT_POLICY_RR)
+		task->sched_info.cl_data.rt.quantum = n;
+	check_rt_policy(task);
+}
+
+static void rt_setprio(task_t *task, int prio)
+{
+	check_rt_policy(task);
+	BUG_ON(prio < 0);
+	BUG_ON(prio >= MAX_RT_PRIO);
+	task->sched_info.cl_data.rt.prio = prio;
+}
+
+static int rt_prio(task_t *task)
+{
+	check_rt_policy(task);
+	return USER_PRIO(task->sched_info.cl_data.rt.prio);
+}
+
+static struct queue_ops rt_ops = {
+	.init		= rt_init,
+	.fini		= nop_fini,
+	.tick		= rt_tick,
+	.yield		= rt_yield,
+	.curr		= rt_curr,
+	.set_curr	= rt_set_curr,
+	.tasks		= rt_tasks,
+	.best		= rt_best,
+	.enqueue	= rt_enqueue,
+	.dequeue	= rt_dequeue,
+	.start_wait	= queue_nop,
+	.stop_wait	= queue_nop,
+	.sleep		= queue_nop,
+	.wake		= queue_nop,
+	.preempt	= rt_preempt,
+	.nice		= rt_nice,
+	.renice		= nop_renice,
+	.prio		= rt_prio,
+	.setprio	= rt_setprio,
+	.timeslice	= rt_timeslice,
+	.set_timeslice	= rt_set_timeslice,
+};
+
+struct policy rt_policy = {
+	.ops	= &rt_ops,
+};
diff -prauN linux-2.6.0-test11/kernel/sched/ts.c sched-2.6.0-test11-5/kernel/sched/ts.c
--- linux-2.6.0-test11/kernel/sched/ts.c	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/ts.c	2003-12-23 08:24:55.000000000 -0800
@@ -0,0 +1,841 @@
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <linux/kernel_stat.h>
+#include <asm/page.h>
+#include "queue.h"
+
+#ifdef DEBUG_SCHED
+#define check_ts_policy(task)						\
+do {									\
+	BUG_ON((task)->sched_info.policy != SCHED_POLICY_TS);		\
+} while (0)
+
+#define check_nice(__queue__)						\
+({									\
+	int __k__, __count__ = 0;					\
+	if ((__queue__)->tasks < 0) {					\
+		printk("negative nice task count %d\n", 		\
+			(__queue__)->tasks);				\
+		BUG();							\
+	}								\
+	for (__k__ = 0; __k__ < NICE_QLEN; ++__k__) {			\
+		task_t *__task__;					\
+		if (list_empty(&(__queue__)->queue[__k__])) {		\
+			if (test_bit(__k__, (__queue__)->bitmap)) {	\
+				printk("wrong nice bit set\n");		\
+				BUG();					\
+			}						\
+		} else {						\
+			if (!test_bit(__k__, (__queue__)->bitmap)) {	\
+				printk("wrong nice bit clear\n");	\
+				BUG();					\
+			}						\
+		}							\
+		list_for_each_entry(__task__,				\
+					&(__queue__)->queue[__k__],	\
+					sched_info.run_list) {		\
+			check_ts_policy(__task__);			\
+			if (__task__->sched_info.idx != __k__) {	\
+				printk("nice index mismatch\n");	\
+				BUG();					\
+			}						\
+			++__count__;					\
+		}							\
+	}								\
+	if ((__queue__)->tasks != __count__) {				\
+		printk("wrong nice task count\n");			\
+		printk("expected %d, got %d\n",				\
+			(__queue__)->tasks,				\
+			__count__);					\
+		BUG();							\
+	}								\
+	__count__;							\
+})
+
+#define check_queue(__queue)						\
+do {									\
+	int __k, __count = 0;						\
+	if ((__queue)->tasks < 0) {					\
+		printk("negative queue task count %d\n", 		\
+			(__queue)->tasks);				\
+		BUG();							\
+	}								\
+	for (__k = 0; __k < 40; ++__k) {				\
+		struct nice_queue *__nice;				\
+		if (list_empty(&(__queue)->nices[__k])) {		\
+			if (test_bit(__k, (__queue)->bitmap)) {		\
+				printk("wrong queue bit set\n");	\
+				BUG();					\
+			}						\
+		} else {						\
+			if (!test_bit(__k, (__queue)->bitmap)) {	\
+				printk("wrong queue bit clear\n");	\
+				BUG();					\
+			}						\
+		}							\
+		list_for_each_entry(__nice,				\
+					&(__queue)->nices[__k],		\
+					list) {				\
+			__count += check_nice(__nice);			\
+			if (__nice->idx != __k) {			\
+				printk("queue index mismatch\n");	\
+				BUG();					\
+			}						\
+		}							\
+	}								\
+	if ((__queue)->tasks != __count) {				\
+		printk("wrong queue task count\n");			\
+		printk("expected %d, got %d\n",				\
+			(__queue)->tasks,				\
+			__count);					\
+		BUG();							\
+	}								\
+} while (0)
+
+#else /* !DEBUG_SCHED */
+#define check_ts_policy(task)			do { } while (0)
+#define check_nice(nice)			do { } while (0)
+#define check_queue(queue)			do { } while (0)
+#endif
+
+/*
+ * Hybrid deadline/multilevel scheduling. Cpu utilization
+ * -dependent deadlines at wake. Queue rotation every 50ms or when
+ * demotions empty the highest level, setting demoted deadlines
+ * relative to the new highest level. Intra-level RR quantum at 10ms.
+ */
+struct nice_queue {
+	int idx, nice, base, tasks, level_quantum, expired;
+	unsigned long bitmap[BITS_TO_LONGS(NICE_QLEN)];
+	struct list_head list, queue[NICE_QLEN];
+	task_t *curr;
+};
+
+/*
+ * Deadline schedule nice levels with priority-dependent deadlines,
+ * default quantum of 100ms. Queue rotates at demotions emptying the
+ * highest level, setting the demoted deadline relative to the new
+ * highest level.
+ */
+struct ts_queue {
+	struct nice_queue nice_levels[40];
+	struct list_head nices[40];
+	int base, quantum, tasks;
+	unsigned long bitmap[BITS_TO_LONGS(40)];
+	struct nice_queue *curr;
+};
+
+/*
+ * Make these sysctl-tunable.
+ */
+static int nice_quantum = 100;
+static int rr_quantum = 10;
+static int level_quantum = 50;
+static int sample_interval = HZ;
+
+static DEFINE_PER_CPU(struct ts_queue, ts_queues);
+
+static task_t *nice_best(struct nice_queue *);
+static struct nice_queue *ts_best_nice(struct ts_queue *);
+
+static void nice_init(struct nice_queue *queue)
+{
+	int k;
+
+	INIT_LIST_HEAD(&queue->list);
+	for (k = 0; k < NICE_QLEN; ++k) {
+		INIT_LIST_HEAD(&queue->queue[k]);
+	}
+}
+
+static int ts_init(struct policy *policy, int cpu)
+{
+	int k;
+	struct ts_queue *queue = &per_cpu(ts_queues, cpu);
+
+	policy->queue = (struct queue *)queue;
+	queue->quantum = nice_quantum;
+
+	for (k = 0; k < 40; ++k) {
+		nice_init(&queue->nice_levels[k]);
+		queue->nice_levels[k].nice = k;
+		INIT_LIST_HEAD(&queue->nices[k]);
+	}
+	return 0;
+}
+
+static int task_deadline(task_t *task)
+{
+	u64 frac_cpu = task->sched_info.cl_data.ts.frac_cpu;
+	frac_cpu *= (u64)NICE_QLEN;
+	frac_cpu >>= 32;
+	return (int)min((u32)(NICE_QLEN - 1), (u32)frac_cpu);
+}
+
+static void nice_rotate_queue(struct nice_queue *queue)
+{
+	int idx, new_idx, deadline, idxdiff;
+	task_t *task = queue->curr;
+
+	check_nice(queue);
+
+	/* shit what if idxdiff == NICE_QLEN - 1?? */
+	idx = queue->curr->sched_info.idx;
+	idxdiff = (idx - queue->base + NICE_QLEN) % NICE_QLEN;
+	deadline = min(1 + task_deadline(task), NICE_QLEN - idxdiff - 1);
+	new_idx = (idx + deadline) % NICE_QLEN;
+#if 0
+	if (idx == new_idx) {
+		/*
+		 * buggy; it sets queue->base = idx because in this case
+		 * we have task_deadline(task) == 0
+		 */
+		new_idx = (idx - task_deadline(task) + NICE_QLEN) % NICE_QLEN;
+		if (queue->base != new_idx)
+			queue->base = new_idx;
+		return;
+	}
+	BUG_ON(!deadline);
+	BUG_ON(queue->base <= new_idx && new_idx <= idx);
+	BUG_ON(idx < queue->base && queue->base <= new_idx);
+	BUG_ON(new_idx <= idx && idx < queue->base);
+	if (0 && idx == new_idx) {
+		printk("FUCKUP: pid = %d, tdl = %d, dl = %d, idx = %d, "
+				"base = %d, diff = %d, fcpu = 0x%lx\n",
+			queue->curr->pid,
+			task_deadline(queue->curr),
+			deadline,
+			idx,
+			queue->base,
+			idxdiff,
+			task->sched_info.cl_data.ts.frac_cpu);
+		BUG();
+	}
+#else
+	/*
+	 * RR in the last deadline
+	 * special-cased so as not to trip BUG_ON()'s below
+	 */
+	if (idx == new_idx) {
+		/* if we got here these two things must hold */
+		BUG_ON(idxdiff != NICE_QLEN - 1);
+		BUG_ON(deadline);
+		list_move_tail(&task->sched_info.run_list, &queue->queue[idx]);
+		if (queue->expired) {
+			queue->level_quantum = level_quantum;
+			queue->expired = 0;
+		}
+		return;
+	}
+#endif
+	task->sched_info.idx = new_idx;
+	if (!test_bit(new_idx, queue->bitmap)) {
+		BUG_ON(!list_empty(&queue->queue[new_idx]));
+		__set_bit(new_idx, queue->bitmap);
+	}
+	list_move_tail(&task->sched_info.run_list,
+			&queue->queue[new_idx]);
+
+	/* expired until list drains */
+	if (!list_empty(&queue->queue[idx]))
+		queue->expired = 1;
+	else {
+		int k, w, m = NICE_QLEN % BITS_PER_LONG;
+		BUG_ON(!test_bit(idx, queue->bitmap));
+		__clear_bit(idx, queue->bitmap);
+
+		for (w = 0, k = 0; k < NICE_QLEN/BITS_PER_LONG; ++k)
+			w += hweight_long(queue->bitmap[k]);
+		if (NICE_QLEN % BITS_PER_LONG)
+			w += hweight_long(queue->bitmap[k] & ((1UL << m) - 1));
+		if (w > 1)
+			queue->base = (queue->base + 1) % NICE_QLEN;
+		queue->level_quantum = level_quantum;
+		queue->expired = 0;
+	}
+	check_nice(queue);
+}
+
+static void nice_tick(struct nice_queue *queue, task_t *task)
+{
+	int idx = task->sched_info.idx;
+	BUG_ON(!task_queued(task));
+	BUG_ON(task != queue->curr);
+	BUG_ON(!test_bit(idx, queue->bitmap));
+	BUG_ON(list_empty(&queue->queue[idx]));
+	check_ts_policy(task);
+	check_nice(queue);
+
+	if (task->sched_info.cl_data.ts.ticks)
+		task->sched_info.cl_data.ts.ticks--;
+
+	if (queue->level_quantum > level_quantum) {
+		WARN_ON(1);
+		queue->level_quantum = 1;
+	}
+
+	if (!queue->expired) {
+		if (queue->level_quantum)
+			queue->level_quantum--;
+	} else if (0 && queue->queue[idx].prev != &task->sched_info.run_list) {
+		int queued = 0, new_idx = (queue->base + 1) % NICE_QLEN;
+		task_t *curr, *sav;
+		task_t *victim = list_entry(queue->queue[idx].prev,
+						task_t,
+						sched_info.run_list);
+		victim->sched_info.idx = new_idx;
+		if (!test_bit(new_idx, queue->bitmap))
+			__set_bit(new_idx, queue->bitmap);
+#if 1
+		list_for_each_entry_safe(curr, sav, &queue->queue[new_idx], sched_info.run_list) {
+			if (victim->sched_info.cl_data.ts.frac_cpu
+				< curr->sched_info.cl_data.ts.frac_cpu) {
+				queued = 1;
+				list_move(&victim->sched_info.run_list,
+						curr->sched_info.run_list.prev);
+				break;
+			}
+		}
+		if (!queued)
+			list_move_tail(&victim->sched_info.run_list,
+					&queue->queue[new_idx]);
+#else
+		list_move(&victim->sched_info.run_list, &queue->queue[new_idx]);
+#endif
+		BUG_ON(list_empty(&queue->queue[idx]));
+	}
+
+	if (!queue->level_quantum && !queue->expired) {
+		check_nice(queue);
+		nice_rotate_queue(queue);
+		check_nice(queue);
+		set_need_resched();
+	} else if (!task->sched_info.cl_data.ts.ticks) {
+		int idxdiff = (idx - queue->base + NICE_QLEN) % NICE_QLEN;
+		check_nice(queue);
+		task->sched_info.cl_data.ts.ticks = rr_quantum;
+		BUG_ON(!test_bit(idx, queue->bitmap));
+		BUG_ON(list_empty(&queue->queue[idx]));
+		if (queue->expired)
+			nice_rotate_queue(queue);
+		else if (idxdiff == NICE_QLEN - 1)
+			list_move_tail(&task->sched_info.run_list,
+					&queue->queue[idx]);
+		else {
+			int new_idx = (idx + 1) % NICE_QLEN;
+			list_del(&task->sched_info.run_list);
+			if (list_empty(&queue->queue[idx])) {
+				BUG_ON(!test_bit(idx, queue->bitmap));
+				__clear_bit(idx, queue->bitmap);
+			}
+			if (!test_bit(new_idx, queue->bitmap)) {
+				BUG_ON(!list_empty(&queue->queue[new_idx]));
+				__set_bit(new_idx, queue->bitmap);
+			}
+			task->sched_info.idx = new_idx;
+			list_add(&task->sched_info.run_list,
+					&queue->queue[new_idx]);
+		}
+		check_nice(queue);
+		set_need_resched();
+	}
+	check_nice(queue);
+	check_ts_policy(task);
+}
+
+static void ts_rotate_queue(struct ts_queue *queue)
+{
+	int idx, new_idx, idxdiff, off, deadline;
+
+	queue->base = find_first_circular_bit(queue->bitmap, queue->base, 40);
+
+	/* shit what if idxdiff == 39?? */
+	check_queue(queue);
+	idx = queue->curr->idx;
+	idxdiff = (idx - queue->base + 40) % 40;
+	off = (int)(queue->curr - queue->nice_levels);
+	deadline = min(1 + off, 40 - idxdiff - 1);
+	new_idx = (idx + deadline) % 40;
+	if (idx == new_idx) {
+		new_idx = (idx - off + 40) % 40;
+		if (queue->base != new_idx)
+			queue->base = new_idx;
+		return;
+	}
+	BUG_ON(!deadline);
+	BUG_ON(queue->base <= new_idx && new_idx <= idx);
+	BUG_ON(idx < queue->base && queue->base <= new_idx);
+	BUG_ON(new_idx <= idx && idx < queue->base);
+	if (!test_bit(new_idx, queue->bitmap)) {
+		BUG_ON(!list_empty(&queue->nices[new_idx]));
+		__set_bit(new_idx, queue->bitmap);
+	}
+	list_move_tail(&queue->curr->list, &queue->nices[new_idx]);
+	queue->curr->idx = new_idx;
+
+	if (list_empty(&queue->nices[idx])) {
+		BUG_ON(!test_bit(idx, queue->bitmap));
+		__clear_bit(idx, queue->bitmap);
+		queue->base = (queue->base + 1) % 40;
+	}
+	check_queue(queue);
+}
+
+static int ts_tick(struct queue *__queue, task_t *task, int user_ticks, int sys_ticks)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice = queue->curr;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	int nice_idx = (int)(queue->curr - queue->nice_levels);
+	unsigned long sample_end, delta;
+
+	check_queue(queue);
+	check_ts_policy(task);
+	BUG_ON(!nice);
+	BUG_ON(nice_idx != task->sched_info.cl_data.ts.nice);
+	BUG_ON(!test_bit(nice->idx, queue->bitmap));
+	BUG_ON(list_empty(&queue->nices[nice->idx]));
+
+	sample_end = jiffies;
+	delta = sample_end - task->sched_info.cl_data.ts.sample_start;
+	if (delta)
+		task->sched_info.cl_data.ts.sample_ticks++;
+	else {
+		task->sched_info.cl_data.ts.sample_start = jiffies;
+		task->sched_info.cl_data.ts.sample_ticks = 1;
+	}
+
+	if (delta >= sample_interval) {
+		u64 frac_cpu;
+		frac_cpu = (u64)task->sched_info.cl_data.ts.sample_ticks << 32;
+		do_div(frac_cpu, delta);
+		frac_cpu = 2*frac_cpu + task->sched_info.cl_data.ts.frac_cpu;
+		do_div(frac_cpu, 3);
+		frac_cpu = min(frac_cpu, (1ULL << 32) - 1);
+		task->sched_info.cl_data.ts.frac_cpu = (unsigned long)frac_cpu;
+		task->sched_info.cl_data.ts.sample_start = sample_end;
+		task->sched_info.cl_data.ts.sample_ticks = 0;
+	}
+
+	cpustat->user += user_ticks;
+	cpustat->system += sys_ticks;
+	nice_tick(nice, task);
+	if (queue->quantum > nice_quantum) {
+		queue->quantum = 0;
+		WARN_ON(1);
+	} else if (queue->quantum)
+		queue->quantum--;
+	if (!queue->quantum) {
+		queue->quantum = nice_quantum;
+		ts_rotate_queue(queue);
+		set_need_resched();
+	}
+	check_queue(queue);
+	check_ts_policy(task);
+	return 0;
+}
+
+static void nice_yield(struct nice_queue *queue, task_t *task)
+{
+	int idx, new_idx = (queue->base + NICE_QLEN - 1) % NICE_QLEN;
+
+	check_nice(queue);
+	check_ts_policy(task);
+	if (!test_bit(new_idx, queue->bitmap)) {
+		BUG_ON(!list_empty(&queue->queue[new_idx]));
+		__set_bit(new_idx, queue->bitmap);
+	}
+	list_move_tail(&task->sched_info.run_list, &queue->queue[new_idx]);
+	idx = task->sched_info.idx;
+	task->sched_info.idx = new_idx;
+	set_need_resched();
+
+	if (list_empty(&queue->queue[idx])) {
+		BUG_ON(!test_bit(idx, queue->bitmap));
+		__clear_bit(idx, queue->bitmap);
+	}
+	queue->curr = nice_best(queue);
+#if 0
+	if (queue->curr->sched_info.idx != queue->base)
+		queue->base = queue->curr->sched_info.idx;
+#endif
+	check_nice(queue);
+	check_ts_policy(task);
+}
+
+/*
+ * This is somewhat problematic; nice_yield() only parks tasks on
+ * the end of their current nice levels.
+ */
+static void ts_yield(struct queue *__queue, task_t *task)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice = queue->curr;
+
+	check_queue(queue);
+	check_ts_policy(task);
+	nice_yield(nice, task);
+
+	/*
+	 * If there's no one to yield to, move the whole nice level.
+	 * If this is problematic, setting nice-dependent deadlines
+	 * on a single unified queue may be in order.
+	 */
+	if (nice->tasks == 1) {
+		int idx, new_idx = (queue->base + 40 - 1) % 40;
+		idx = nice->idx;
+		if (!test_bit(new_idx, queue->bitmap)) {
+			BUG_ON(!list_empty(&queue->nices[new_idx]));
+			__set_bit(new_idx, queue->bitmap);
+		}
+		list_move_tail(&nice->list, &queue->nices[new_idx]);
+		if (list_empty(&queue->nices[idx])) {
+			BUG_ON(!test_bit(idx, queue->bitmap));
+			__clear_bit(idx, queue->bitmap);
+		}
+		nice->idx = new_idx;
+		queue->base = find_first_circular_bit(queue->bitmap,
+							queue->base,
+							40);
+		BUG_ON(queue->base >= 40);
+		BUG_ON(!test_bit(queue->base, queue->bitmap));
+		queue->curr = ts_best_nice(queue);
+	}
+	check_queue(queue);
+	check_ts_policy(task);
+}
+
+static task_t *ts_curr(struct queue *__queue)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	task_t *task = queue->curr->curr;
+	check_queue(queue);
+	if (task)
+		check_ts_policy(task);
+	return task;
+}
+
+static void ts_set_curr(struct queue *__queue, task_t *task)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice;
+	check_queue(queue);
+	check_ts_policy(task);
+	nice = &queue->nice_levels[task->sched_info.cl_data.ts.nice];
+	queue->curr = nice;
+	nice->curr = task;
+	check_queue(queue);
+	check_ts_policy(task);
+}
+
+static task_t *nice_best(struct nice_queue *queue)
+{
+	task_t *task;
+	int idx = find_first_circular_bit(queue->bitmap,
+						queue->base,
+						NICE_QLEN);
+	check_nice(queue);
+	if (idx >= NICE_QLEN)
+		return NULL;
+	BUG_ON(list_empty(&queue->queue[idx]));
+	BUG_ON(!test_bit(idx, queue->bitmap));
+	task = list_entry(queue->queue[idx].next, task_t, sched_info.run_list);
+	check_nice(queue);
+	check_ts_policy(task);
+	return task;
+}
+
+static struct nice_queue *ts_best_nice(struct ts_queue *queue)
+{
+	int idx = find_first_circular_bit(queue->bitmap, queue->base, 40);
+	check_queue(queue);
+	if (idx >= 40)
+		return NULL;
+	BUG_ON(list_empty(&queue->nices[idx]));
+	BUG_ON(!test_bit(idx, queue->bitmap));
+	return list_entry(queue->nices[idx].next, struct nice_queue, list);
+}
+
+static task_t *ts_best(struct queue *__queue)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice = ts_best_nice(queue);
+	return nice ? nice_best(nice) : NULL;
+}
+
+static void nice_enqueue(struct nice_queue *queue, task_t *task)
+{
+	task_t *curr, *sav;
+	int queued = 0, idx, deadline, base, idxdiff;
+	check_nice(queue);
+	check_ts_policy(task);
+
+	/* don't livelock when queue->expired */
+	deadline = min(!!queue->expired + task_deadline(task), NICE_QLEN - 1);
+	idx = (queue->base + deadline) % NICE_QLEN;
+
+	if (!test_bit(idx, queue->bitmap)) {
+		BUG_ON(!list_empty(&queue->queue[idx]));
+		__set_bit(idx, queue->bitmap);
+	}
+
+#if 1
+	/* keep nice level's queue sorted -- use binomial heaps here soon */
+	list_for_each_entry_safe(curr, sav, &queue->queue[idx], sched_info.run_list) {
+		if (task->sched_info.cl_data.ts.frac_cpu
+				>= curr->sched_info.cl_data.ts.frac_cpu) {
+			list_add(&task->sched_info.run_list,
+					curr->sched_info.run_list.prev);
+			queued = 1;
+			break;
+		}
+	}
+	if (!queued)
+		list_add_tail(&task->sched_info.run_list, &queue->queue[idx]);
+#else
+	list_add_tail(&task->sched_info.run_list, &queue->queue[idx]);
+#endif
+	task->sched_info.idx = idx;
+	/* if (!task->sched_info.cl_data.ts.ticks) */
+		task->sched_info.cl_data.ts.ticks = rr_quantum;
+
+	if (queue->tasks)
+		BUG_ON(!queue->curr);
+	else {
+		BUG_ON(queue->curr);
+		queue->curr = task;
+	}
+	queue->tasks++;
+	check_nice(queue);
+	check_ts_policy(task);
+}
+
+static void ts_enqueue(struct queue *__queue, task_t *task)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice;
+
+	check_queue(queue);
+	check_ts_policy(task);
+	nice = &queue->nice_levels[task->sched_info.cl_data.ts.nice];
+	if (!nice->tasks) {
+		int idx = (queue->base + task->sched_info.cl_data.ts.nice) % 40;
+		if (!test_bit(idx, queue->bitmap)) {
+			BUG_ON(!list_empty(&queue->nices[idx]));
+			__set_bit(idx, queue->bitmap);
+		}
+		list_add_tail(&nice->list, &queue->nices[idx]);
+		nice->idx = idx;
+		if (!queue->curr)
+			queue->curr = nice;
+	}
+	nice_enqueue(nice, task);
+	queue->tasks++;
+	queue->base = find_first_circular_bit(queue->bitmap, queue->base, 40);
+	check_queue(queue);
+	check_ts_policy(task);
+}
+
+static void nice_dequeue(struct nice_queue *queue, task_t *task)
+{
+	check_nice(queue);
+	check_ts_policy(task);
+	list_del(&task->sched_info.run_list);
+	if (list_empty(&queue->queue[task->sched_info.idx])) {
+		BUG_ON(!test_bit(task->sched_info.idx, queue->bitmap));
+		__clear_bit(task->sched_info.idx, queue->bitmap);
+	}
+	queue->tasks--;
+	if (task == queue->curr) {
+		queue->curr = nice_best(queue);
+#if 0
+		if (queue->curr)
+			queue->base = queue->curr->sched_info.idx;
+#endif
+	}
+	check_nice(queue);
+	check_ts_policy(task);
+}
+
+static void ts_dequeue(struct queue *__queue, task_t *task)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice;
+
+	BUG_ON(!queue->tasks);
+	check_queue(queue);
+	check_ts_policy(task);
+	nice = &queue->nice_levels[task->sched_info.cl_data.ts.nice];
+
+	nice_dequeue(nice, task);
+	queue->tasks--;
+	if (!nice->tasks) {
+		list_del_init(&nice->list);
+		if (list_empty(&queue->nices[nice->idx])) {
+			BUG_ON(!test_bit(nice->idx, queue->bitmap));
+			__clear_bit(nice->idx, queue->bitmap);
+		}
+		if (nice == queue->curr)
+			queue->curr = ts_best_nice(queue);
+	}
+	queue->base = find_first_circular_bit(queue->bitmap, queue->base, 40);
+	if (queue->base >= 40)
+		queue->base = 0;
+	check_queue(queue);
+	check_ts_policy(task);
+}
+
+static int ts_tasks(struct queue *__queue)
+{
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	check_queue(queue);
+	return queue->tasks;
+}
+
+static int ts_nice(struct queue *__queue, task_t *task)
+{
+	int nice = task->sched_info.cl_data.ts.nice - 20;
+	check_ts_policy(task);
+	BUG_ON(nice < -20);
+	BUG_ON(nice >= 20);
+	return nice;
+}
+
+static void ts_renice(struct queue *queue, task_t *task, int nice)
+{
+	check_queue((struct ts_queue *)queue);
+	check_ts_policy(task);
+	BUG_ON(nice < -20);
+	BUG_ON(nice >= 20);
+	task->sched_info.cl_data.ts.nice = nice + 20;
+	check_queue((struct ts_queue *)queue);
+}
+
+static int nice_task_prio(struct nice_queue *nice, task_t *task)
+{
+	if (!task_queued(task))
+		return task_deadline(task);
+	else {
+		int prio = task->sched_info.idx - nice->base;
+		return prio < 0 ? prio + NICE_QLEN : prio;
+	}
+}
+
+static int ts_nice_prio(struct ts_queue *ts, struct nice_queue *nice)
+{
+	if (list_empty(&nice->list))
+		return (int)(nice - ts->nice_levels);
+	else {
+		int prio = nice->idx - ts->base;
+		return prio < 0 ? prio + 40 : prio;
+	}
+}
+
+/* 100% fake priority to report heuristics and the like */
+static int ts_prio(task_t *task)
+{
+	int policy_idx;
+	struct policy *policy;
+	struct ts_queue *ts;
+	struct nice_queue *nice;
+
+	policy_idx = task->sched_info.policy;
+	policy = per_cpu(runqueues, task_cpu(task)).policies[policy_idx];
+	ts = (struct ts_queue *)policy->queue;
+	nice = &ts->nice_levels[task->sched_info.cl_data.ts.nice];
+	return 40*ts_nice_prio(ts, nice) + nice_task_prio(nice, task);
+}
+
+static void ts_setprio(task_t *task, int prio)
+{
+}
+
+static void ts_start_wait(struct queue *__queue, task_t *task)
+{
+}
+
+static void ts_stop_wait(struct queue *__queue, task_t *task)
+{
+}
+
+static void ts_sleep(struct queue *__queue, task_t *task)
+{
+}
+
+static void ts_wake(struct queue *__queue, task_t *task)
+{
+}
+
+static int nice_preempt(struct nice_queue *queue, task_t *task)
+{
+	check_nice(queue);
+	check_ts_policy(task);
+	/* assume FB style preemption at wakeup */
+	if (!task_queued(task) || !queue->curr)
+		return 1;
+	else {
+		int delta_t, delta_q;
+		delta_t = (task->sched_info.idx - queue->base + NICE_QLEN)
+				% NICE_QLEN;
+		delta_q = (queue->curr->sched_info.idx - queue->base
+							+ NICE_QLEN)
+				% NICE_QLEN;
+		if (delta_t < delta_q)
+			return 1;
+		else if (task->sched_info.cl_data.ts.frac_cpu
+				< queue->curr->sched_info.cl_data.ts.frac_cpu)
+			return 1;
+		else
+			return 0;
+	}
+	check_nice(queue);
+}
+
+static int ts_preempt(struct queue *__queue, task_t *task)
+{
+	int curr_nice;
+	struct ts_queue *queue = (struct ts_queue *)__queue;
+	struct nice_queue *nice = queue->curr;
+
+	check_queue(queue);
+	check_ts_policy(task);
+	if (!queue->curr)
+		return 1;
+
+	curr_nice = (int)(nice - queue->nice_levels);
+
+	/* preempt when nice number is lower, or the above for matches */
+	if (task->sched_info.cl_data.ts.nice != curr_nice)
+		return task->sched_info.cl_data.ts.nice < curr_nice;
+	else
+		return nice_preempt(nice, task);
+}
+
+static struct queue_ops ts_ops = {
+	.init		= ts_init,
+	.fini		= nop_fini,
+	.tick		= ts_tick,
+	.yield		= ts_yield,
+	.curr		= ts_curr,
+	.set_curr	= ts_set_curr,
+	.tasks		= ts_tasks,
+	.best		= ts_best,
+	.enqueue	= ts_enqueue,
+	.dequeue	= ts_dequeue,
+	.start_wait	= ts_start_wait,
+	.stop_wait	= ts_stop_wait,
+	.sleep		= ts_sleep,
+	.wake		= ts_wake,
+	.preempt	= ts_preempt,
+	.nice		= ts_nice,
+	.renice		= ts_renice,
+	.prio		= ts_prio,
+	.setprio	= ts_setprio,
+	.timeslice	= nop_timeslice,
+	.set_timeslice	= nop_set_timeslice,
+};
+
+struct policy ts_policy = {
+	.ops	= &ts_ops,
+};
diff -prauN linux-2.6.0-test11/kernel/sched/util.c sched-2.6.0-test11-5/kernel/sched/util.c
--- linux-2.6.0-test11/kernel/sched/util.c	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched/util.c	2003-12-19 08:43:20.000000000 -0800
@@ -0,0 +1,37 @@
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+#include <asm/page.h>
+#include "queue.h"
+
+int find_first_circular_bit(unsigned long *addr, int start, int end)
+{
+	int bit = find_next_bit(addr, end, start);
+	if (bit < end)
+		return bit;
+	bit = find_first_bit(addr, start);
+	if (bit < start)
+		return bit;
+	return end;
+}
+
+void queue_nop(struct queue *queue, task_t *task)
+{
+}
+
+void nop_renice(struct queue *queue, task_t *task, int nice)
+{
+}
+
+void nop_fini(struct policy *policy, int cpu)
+{
+}
+
+unsigned long nop_timeslice(struct queue *queue, task_t *task)
+{
+	return 0;
+}
+
+void nop_set_timeslice(struct queue *queue, task_t *task, unsigned long n)
+{
+}
diff -prauN linux-2.6.0-test11/kernel/sched.c sched-2.6.0-test11-5/kernel/sched.c
--- linux-2.6.0-test11/kernel/sched.c	2003-11-26 12:45:17.000000000 -0800
+++ sched-2.6.0-test11-5/kernel/sched.c	2003-12-21 06:06:32.000000000 -0800
@@ -15,6 +15,8 @@
  *		and per-CPU runqueues.  Cleanups and useful suggestions
  *		by Davide Libenzi, preemptible kernel bits by Robert Love.
  *  2003-09-03	Interactivity tuning by Con Kolivas.
+ *  2003-12-17	Total rewrite and generalized scheduler policies
+ *		by William Irwin.
  */
 
 #include <linux/mm.h>
@@ -38,6 +40,8 @@
 #include <linux/cpu.h>
 #include <linux/percpu.h>
 
+#include "sched/queue.h"
+
 #ifdef CONFIG_NUMA
 #define cpu_to_node_mask(cpu) node_to_cpumask(cpu_to_node(cpu))
 #else
@@ -45,181 +49,79 @@
 #endif
 
 /*
- * Convert user-nice values [ -20 ... 0 ... 19 ]
- * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
- * and back.
- */
-#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
-#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
-#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
-
-/*
- * 'User priority' is the nice value converted to something we
- * can work with better when scaling various scheduler parameters,
- * it's a [ 0 ... 39 ] range.
- */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
-#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
-#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
-#define AVG_TIMESLICE	(MIN_TIMESLICE + ((MAX_TIMESLICE - MIN_TIMESLICE) *\
-			(MAX_PRIO-1-NICE_TO_PRIO(0))/(MAX_USER_PRIO - 1)))
-
-/*
- * Some helpers for converting nanosecond timing to jiffy resolution
- */
-#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
-#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
-
-/*
- * These are the 'tuning knobs' of the scheduler:
- *
- * Minimum timeslice is 10 msecs, default timeslice is 100 msecs,
- * maximum timeslice is 200 msecs. Timeslices get refilled after
- * they expire.
- */
-#define MIN_TIMESLICE		( 10 * HZ / 1000)
-#define MAX_TIMESLICE		(200 * HZ / 1000)
-#define ON_RUNQUEUE_WEIGHT	30
-#define CHILD_PENALTY		95
-#define PARENT_PENALTY		100
-#define EXIT_WEIGHT		3
-#define PRIO_BONUS_RATIO	25
-#define MAX_BONUS		(MAX_USER_PRIO * PRIO_BONUS_RATIO / 100)
-#define INTERACTIVE_DELTA	2
-#define MAX_SLEEP_AVG		(AVG_TIMESLICE * MAX_BONUS)
-#define STARVATION_LIMIT	(MAX_SLEEP_AVG)
-#define NS_MAX_SLEEP_AVG	(JIFFIES_TO_NS(MAX_SLEEP_AVG))
-#define NODE_THRESHOLD		125
-#define CREDIT_LIMIT		100
-
-/*
- * If a task is 'interactive' then we reinsert it in the active
- * array after it has expired its current timeslice. (it will not
- * continue to run immediately, it will still roundrobin with
- * other interactive tasks.)
- *
- * This part scales the interactivity limit depending on niceness.
- *
- * We scale it linearly, offset by the INTERACTIVE_DELTA delta.
- * Here are a few examples of different nice levels:
- *
- *  TASK_INTERACTIVE(-20): [1,1,1,1,1,1,1,1,1,0,0]
- *  TASK_INTERACTIVE(-10): [1,1,1,1,1,1,1,0,0,0,0]
- *  TASK_INTERACTIVE(  0): [1,1,1,1,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 10): [1,1,0,0,0,0,0,0,0,0,0]
- *  TASK_INTERACTIVE( 19): [0,0,0,0,0,0,0,0,0,0,0]
- *
- * (the X axis represents the possible -5 ... 0 ... +5 dynamic
- *  priority range a task can explore, a value of '1' means the
- *  task is rated interactive.)
- *
- * Ie. nice +19 tasks can never get 'interactive' enough to be
- * reinserted into the active array. And only heavily CPU-hog nice -20
- * tasks will be expired. Default nice 0 tasks are somewhere between,
- * it takes some effort for them to get interactive, but it's not
- * too hard.
- */
-
-#define CURRENT_BONUS(p) \
-	(NS_TO_JIFFIES((p)->sleep_avg) * MAX_BONUS / \
-		MAX_SLEEP_AVG)
-
-#ifdef CONFIG_SMP
-#define TIMESLICE_GRANULARITY(p)	(MIN_TIMESLICE * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)) * \
-			num_online_cpus())
-#else
-#define TIMESLICE_GRANULARITY(p)	(MIN_TIMESLICE * \
-		(1 << (((MAX_BONUS - CURRENT_BONUS(p)) ? : 1) - 1)))
-#endif
-
-#define SCALE(v1,v1_max,v2_max) \
-	(v1) * (v2_max) / (v1_max)
-
-#define DELTA(p) \
-	(SCALE(TASK_NICE(p), 40, MAX_USER_PRIO*PRIO_BONUS_RATIO/100) + \
-		INTERACTIVE_DELTA)
-
-#define TASK_INTERACTIVE(p) \
-	((p)->prio <= (p)->static_prio - DELTA(p))
-
-#define JUST_INTERACTIVE_SLEEP(p) \
-	(JIFFIES_TO_NS(MAX_SLEEP_AVG * \
-		(MAX_BONUS / 2 + DELTA((p)) + 1) / MAX_BONUS - 1))
-
-#define HIGH_CREDIT(p) \
-	((p)->interactive_credit > CREDIT_LIMIT)
-
-#define LOW_CREDIT(p) \
-	((p)->interactive_credit < -CREDIT_LIMIT)
-
-#define TASK_PREEMPTS_CURR(p, rq) \
-	((p)->prio < (rq)->curr->prio)
-
-/*
- * BASE_TIMESLICE scales user-nice values [ -20 ... 19 ]
- * to time slice values.
- *
- * The higher a thread's priority, the bigger timeslices
- * it gets during one round of execution. But even the lowest
- * priority thread gets MIN_TIMESLICE worth of execution time.
- *
- * task_timeslice() is the interface that is used by the scheduler.
- */
-
-#define BASE_TIMESLICE(p) (MIN_TIMESLICE + \
-	((MAX_TIMESLICE - MIN_TIMESLICE) * (MAX_PRIO-1-(p)->static_prio)/(MAX_USER_PRIO - 1)))
-
-static inline unsigned int task_timeslice(task_t *p)
-{
-	return BASE_TIMESLICE(p);
-}
-
-/*
- * These are the runqueue data structures:
- */
-
-#define BITMAP_SIZE ((((MAX_PRIO+1+7)/8)+sizeof(long)-1)/sizeof(long))
-
-typedef struct runqueue runqueue_t;
-
-struct prio_array {
-	int nr_active;
-	unsigned long bitmap[BITMAP_SIZE];
-	struct list_head queue[MAX_PRIO];
-};
-
-/*
  * This is the main, per-CPU runqueue data structure.
  *
  * Locking rule: those places that want to lock multiple runqueues
  * (such as the load balancing or the thread migration code), lock
  * acquire operations must be ordered by ascending &runqueue.
  */
-struct runqueue {
-	spinlock_t lock;
-	unsigned long nr_running, nr_switches, expired_timestamp,
-			nr_uninterruptible;
-	task_t *curr, *idle;
-	struct mm_struct *prev_mm;
-	prio_array_t *active, *expired, arrays[2];
-	int prev_cpu_load[NR_CPUS];
-#ifdef CONFIG_NUMA
-	atomic_t *node_nr_running;
-	int prev_node_load[MAX_NUMNODES];
-#endif
-	task_t *migration_thread;
-	struct list_head migration_queue;
+DEFINE_PER_CPU(struct runqueue, runqueues);
 
-	atomic_t nr_iowait;
+struct policy *policies[] = {
+	&rt_policy,
+	&ts_policy,
+	&batch_policy,
+	&idle_policy,
+	NULL,
 };
 
-static DEFINE_PER_CPU(struct runqueue, runqueues);
-
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
-#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+#define rq_curr(rq)		(rq)->__curr
+#define cpu_curr(cpu)		rq_curr(cpu_rq(cpu))
+
+static inline struct policy *task_policy(task_t *task)
+{
+	unsigned long idx;
+	struct policy *policy;
+	idx = task->sched_info.policy;
+	__check_task_policy(idx);
+	policy = task_rq(task)->policies[idx];
+	check_policy(policy);
+	return policy;
+}
+
+static inline struct policy *rq_policy(runqueue_t *rq)
+{
+	unsigned long idx;
+	task_t *task;
+	struct policy *policy;
+
+	task = rq_curr(rq);
+	BUG_ON(!task);
+	BUG_ON((unsigned long)task < PAGE_OFFSET);
+	idx = task->sched_info.policy;
+	__check_task_policy(idx);
+	policy = rq->policies[idx];
+	check_policy(policy);
+	return policy;
+}
+
+static int __task_nice(task_t *task)
+{
+	struct policy *policy = task_policy(task);
+	return policy->ops->nice(policy->queue, task);
+}
+
+static inline void set_rq_curr(runqueue_t *rq, task_t *task)
+{
+	rq->curr = task->sched_info.policy;
+	__check_task_policy(rq->curr);
+	rq->__curr = task;
+}
+
+static inline int task_preempts_curr(task_t *task, runqueue_t *rq)
+{
+	check_task_policy(rq_curr(rq));
+	check_task_policy(task);
+	if (rq_curr(rq)->sched_info.policy != task->sched_info.policy)
+		return task->sched_info.policy < rq_curr(rq)->sched_info.policy;
+	else {
+		struct policy *policy = rq_policy(rq);
+		return policy->ops->preempt(policy->queue, task);
+	}
+}
 
 /*
  * Default context-switch locking:
@@ -227,7 +129,7 @@ static DEFINE_PER_CPU(struct runqueue, r
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(rq, next)	do { } while(0)
 # define finish_arch_switch(rq, next)	spin_unlock_irq(&(rq)->lock)
-# define task_running(rq, p)		((rq)->curr == (p))
+# define task_running(rq, p)		(rq_curr(rq) == (p))
 #endif
 
 #ifdef CONFIG_NUMA
@@ -320,53 +222,32 @@ static inline void rq_unlock(runqueue_t 
 }
 
 /*
- * Adding/removing a task to/from a priority array:
+ * Adding/removing a task to/from a policy's queue.
+ * We dare not BUG_ON() a wrong task_queued() as boot-time
+ * calls may trip it.
  */
-static inline void dequeue_task(struct task_struct *p, prio_array_t *array)
+static inline void dequeue_task(task_t *task, runqueue_t *rq)
 {
-	array->nr_active--;
-	list_del(&p->run_list);
-	if (list_empty(array->queue + p->prio))
-		__clear_bit(p->prio, array->bitmap);
+	struct policy *policy = task_policy(task);
+	BUG_ON(!task_queued(task));
+	policy->ops->dequeue(policy->queue, task);
+	if (!policy->ops->tasks(policy->queue)) {
+		BUG_ON(!test_bit(task->sched_info.policy, &rq->policy_bitmap));
+		__clear_bit(task->sched_info.policy, &rq->policy_bitmap);
+	}
+	clear_task_queued(task);
 }
 
-static inline void enqueue_task(struct task_struct *p, prio_array_t *array)
+static inline void enqueue_task(task_t *task, runqueue_t *rq)
 {
-	list_add_tail(&p->run_list, array->queue + p->prio);
-	__set_bit(p->prio, array->bitmap);
-	array->nr_active++;
-	p->array = array;
-}
-
-/*
- * effective_prio - return the priority that is based on the static
- * priority but is modified by bonuses/penalties.
- *
- * We scale the actual sleep average [0 .... MAX_SLEEP_AVG]
- * into the -5 ... 0 ... +5 bonus/penalty range.
- *
- * We use 25% of the full 0...39 priority range so that:
- *
- * 1) nice +19 interactive tasks do not preempt nice 0 CPU hogs.
- * 2) nice -20 CPU hogs do not get preempted by nice 0 tasks.
- *
- * Both properties are important to certain workloads.
- */
-static int effective_prio(task_t *p)
-{
-	int bonus, prio;
-
-	if (rt_task(p))
-		return p->prio;
-
-	bonus = CURRENT_BONUS(p) - MAX_BONUS / 2;
-
-	prio = p->static_prio - bonus;
-	if (prio < MAX_RT_PRIO)
-		prio = MAX_RT_PRIO;
-	if (prio > MAX_PRIO-1)
-		prio = MAX_PRIO-1;
-	return prio;
+	struct policy *policy = task_policy(task);
+	BUG_ON(task_queued(task));
+	if (!policy->ops->tasks(policy->queue)) {
+		BUG_ON(test_bit(task->sched_info.policy, &rq->policy_bitmap));
+		__set_bit(task->sched_info.policy, &rq->policy_bitmap);
+	}
+	policy->ops->enqueue(policy->queue, task);
+	set_task_queued(task);
 }
 
 /*
@@ -374,134 +255,34 @@ static int effective_prio(task_t *p)
  */
 static inline void __activate_task(task_t *p, runqueue_t *rq)
 {
-	enqueue_task(p, rq->active);
+	enqueue_task(p, rq);
 	nr_running_inc(rq);
 }
 
-static void recalc_task_prio(task_t *p, unsigned long long now)
-{
-	unsigned long long __sleep_time = now - p->timestamp;
-	unsigned long sleep_time;
-
-	if (__sleep_time > NS_MAX_SLEEP_AVG)
-		sleep_time = NS_MAX_SLEEP_AVG;
-	else
-		sleep_time = (unsigned long)__sleep_time;
-
-	if (likely(sleep_time > 0)) {
-		/*
-		 * User tasks that sleep a long time are categorised as
-		 * idle and will get just interactive status to stay active &
-		 * prevent them suddenly becoming cpu hogs and starving
-		 * other processes.
-		 */
-		if (p->mm && p->activated != -1 &&
-			sleep_time > JUST_INTERACTIVE_SLEEP(p)){
-				p->sleep_avg = JIFFIES_TO_NS(MAX_SLEEP_AVG -
-						AVG_TIMESLICE);
-				if (!HIGH_CREDIT(p))
-					p->interactive_credit++;
-		} else {
-			/*
-			 * The lower the sleep avg a task has the more
-			 * rapidly it will rise with sleep time.
-			 */
-			sleep_time *= (MAX_BONUS - CURRENT_BONUS(p)) ? : 1;
-
-			/*
-			 * Tasks with low interactive_credit are limited to
-			 * one timeslice worth of sleep avg bonus.
-			 */
-			if (LOW_CREDIT(p) &&
-				sleep_time > JIFFIES_TO_NS(task_timeslice(p)))
-					sleep_time =
-						JIFFIES_TO_NS(task_timeslice(p));
-
-			/*
-			 * Non high_credit tasks waking from uninterruptible
-			 * sleep are limited in their sleep_avg rise as they
-			 * are likely to be cpu hogs waiting on I/O
-			 */
-			if (p->activated == -1 && !HIGH_CREDIT(p) && p->mm){
-				if (p->sleep_avg >= JUST_INTERACTIVE_SLEEP(p))
-					sleep_time = 0;
-				else if (p->sleep_avg + sleep_time >=
-					JUST_INTERACTIVE_SLEEP(p)){
-						p->sleep_avg =
-							JUST_INTERACTIVE_SLEEP(p);
-						sleep_time = 0;
-					}
-			}
-
-			/*
-			 * This code gives a bonus to interactive tasks.
-			 *
-			 * The boost works by updating the 'average sleep time'
-			 * value here, based on ->timestamp. The more time a task
-			 * spends sleeping, the higher the average gets - and the
-			 * higher the priority boost gets as well.
-			 */
-			p->sleep_avg += sleep_time;
-
-			if (p->sleep_avg > NS_MAX_SLEEP_AVG){
-				p->sleep_avg = NS_MAX_SLEEP_AVG;
-				if (!HIGH_CREDIT(p))
-					p->interactive_credit++;
-			}
-		}
-	}
-
-	p->prio = effective_prio(p);
-}
-
 /*
  * activate_task - move a task to the runqueue and do priority recalculation
  *
  * Update all the scheduling statistics stuff. (sleep average
  * calculation, priority modifiers, etc.)
  */
-static inline void activate_task(task_t *p, runqueue_t *rq)
+static inline void activate_task(task_t *task, runqueue_t *rq)
 {
-	unsigned long long now = sched_clock();
-
-	recalc_task_prio(p, now);
-
-	/*
-	 * This checks to make sure it's not an uninterruptible task
-	 * that is now waking up.
-	 */
-	if (!p->activated){
-		/*
-		 * Tasks which were woken up by interrupts (ie. hw events)
-		 * are most likely of interactive nature. So we give them
-		 * the credit of extending their sleep time to the period
-		 * of time they spend on the runqueue, waiting for execution
-		 * on a CPU, first time around:
-		 */
-		if (in_interrupt())
-			p->activated = 2;
-		else
-		/*
-		 * Normal first-time wakeups get a credit too for on-runqueue
-		 * time, but it will be weighted down:
-		 */
-			p->activated = 1;
-		}
-	p->timestamp = now;
-
-	__activate_task(p, rq);
+	struct policy *policy = task_policy(task);
+	policy->ops->wake(policy->queue, task);
+	__activate_task(task, rq);
 }
 
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static inline void deactivate_task(struct task_struct *p, runqueue_t *rq)
+static inline void deactivate_task(task_t *task, runqueue_t *rq)
 {
+	struct policy *policy = task_policy(task);
 	nr_running_dec(rq);
-	if (p->state == TASK_UNINTERRUPTIBLE)
+	if (task->state == TASK_UNINTERRUPTIBLE)
 		rq->nr_uninterruptible++;
-	dequeue_task(p, p->array);
-	p->array = NULL;
+	policy->ops->sleep(policy->queue, task);
+	dequeue_task(task, rq);
 }
 
 /*
@@ -625,7 +406,7 @@ repeat_lock_task:
 	rq = task_rq_lock(p, &flags);
 	old_state = p->state;
 	if (old_state & state) {
-		if (!p->array) {
+		if (!task_queued(p)) {
 			/*
 			 * Fast-migrate the task if it's not running or runnable
 			 * currently. Do not violate hard affinity.
@@ -644,14 +425,13 @@ repeat_lock_task:
 				 * Tasks on involuntary sleep don't earn
 				 * sleep_avg beyond just interactive state.
 				 */
-				p->activated = -1;
 			}
 			if (sync)
 				__activate_task(p, rq);
 			else {
 				activate_task(p, rq);
-				if (TASK_PREEMPTS_CURR(p, rq))
-					resched_task(rq->curr);
+				if (task_preempts_curr(p, rq))
+					resched_task(rq_curr(rq));
 			}
 			success = 1;
 		}
@@ -679,68 +459,26 @@ int wake_up_state(task_t *p, unsigned in
  * This function will do some initial scheduler statistics housekeeping
  * that must be done for every newly created process.
  */
-void wake_up_forked_process(task_t * p)
+void wake_up_forked_process(task_t *task)
 {
 	unsigned long flags;
 	runqueue_t *rq = task_rq_lock(current, &flags);
 
-	p->state = TASK_RUNNING;
-	/*
-	 * We decrease the sleep average of forking parents
-	 * and children as well, to keep max-interactive tasks
-	 * from forking tasks that are max-interactive.
-	 */
-	current->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(current) *
-		PARENT_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
-
-	p->sleep_avg = JIFFIES_TO_NS(CURRENT_BONUS(p) *
-		CHILD_PENALTY / 100 * MAX_SLEEP_AVG / MAX_BONUS);
-
-	p->interactive_credit = 0;
-
-	p->prio = effective_prio(p);
-	set_task_cpu(p, smp_processor_id());
-
-	if (unlikely(!current->array))
-		__activate_task(p, rq);
-	else {
-		p->prio = current->prio;
-		list_add_tail(&p->run_list, &current->run_list);
-		p->array = current->array;
-		p->array->nr_active++;
-		nr_running_inc(rq);
-	}
+	task->state = TASK_RUNNING;
+	set_task_cpu(task, smp_processor_id());
+	if (unlikely(!task_queued(current)))
+		__activate_task(task, rq);
+	else
+		activate_task(task, rq);
 	task_rq_unlock(rq, &flags);
 }
 
 /*
- * Potentially available exiting-child timeslices are
- * retrieved here - this way the parent does not get
- * penalized for creating too many threads.
- *
- * (this cannot be used to 'generate' timeslices
- * artificially, because any timeslice recovered here
- * was given away by the parent in the first place.)
+ * Policies that depend on trapping fork() and exit() may need to
+ * put a hook here.
  */
-void sched_exit(task_t * p)
+void sched_exit(task_t *task)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	if (p->first_time_slice) {
-		p->parent->time_slice += p->time_slice;
-		if (unlikely(p->parent->time_slice > MAX_TIMESLICE))
-			p->parent->time_slice = MAX_TIMESLICE;
-	}
-	local_irq_restore(flags);
-	/*
-	 * If the child was a (relative-) CPU hog then decrease
-	 * the sleep_avg of the parent as well.
-	 */
-	if (p->sleep_avg < p->parent->sleep_avg)
-		p->parent->sleep_avg = p->parent->sleep_avg /
-		(EXIT_WEIGHT + 1) * EXIT_WEIGHT + p->sleep_avg /
-		(EXIT_WEIGHT + 1);
 }
 
 /**
@@ -1128,18 +866,18 @@ out:
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
  */
-static inline void pull_task(runqueue_t *src_rq, prio_array_t *src_array, task_t *p, runqueue_t *this_rq, int this_cpu)
+static inline void pull_task(runqueue_t *src_rq, task_t *p, runqueue_t *this_rq, int this_cpu)
 {
-	dequeue_task(p, src_array);
+	dequeue_task(p, src_rq);
 	nr_running_dec(src_rq);
 	set_task_cpu(p, this_cpu);
 	nr_running_inc(this_rq);
-	enqueue_task(p, this_rq->active);
+	enqueue_task(p, this_rq);
 	/*
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
 	 */
-	if (TASK_PREEMPTS_CURR(p, this_rq))
+	if (task_preempts_curr(p, this_rq))
 		set_need_resched();
 }
 
@@ -1150,14 +888,14 @@ static inline void pull_task(runqueue_t 
  *	((!idle || (NS_TO_JIFFIES(now - (p)->timestamp) > \
  *		cache_decay_ticks)) && !task_running(rq, p) && \
  *			cpu_isset(this_cpu, (p)->cpus_allowed))
+ *
+ * Since there isn't a timestamp anymore, this needs adjustment.
  */
 
 static inline int
 can_migrate_task(task_t *tsk, runqueue_t *rq, int this_cpu, int idle)
 {
-	unsigned long delta = sched_clock() - tsk->timestamp;
-
-	if (!idle && (delta <= JIFFIES_TO_NS(cache_decay_ticks)))
+	if (!idle)
 		return 0;
 	if (task_running(rq, tsk))
 		return 0;
@@ -1176,11 +914,8 @@ can_migrate_task(task_t *tsk, runqueue_t
  */
 static void load_balance(runqueue_t *this_rq, int idle, cpumask_t cpumask)
 {
-	int imbalance, idx, this_cpu = smp_processor_id();
+	int imbalance, this_cpu = smp_processor_id();
 	runqueue_t *busiest;
-	prio_array_t *array;
-	struct list_head *head, *curr;
-	task_t *tmp;
 
 	busiest = find_busiest_queue(this_rq, this_cpu, idle, &imbalance, cpumask);
 	if (!busiest)
@@ -1192,37 +927,6 @@ static void load_balance(runqueue_t *thi
 	 */
 	imbalance /= 2;
 
-	/*
-	 * We first consider expired tasks. Those will likely not be
-	 * executed in the near future, and they are most likely to
-	 * be cache-cold, thus switching CPUs has the least effect
-	 * on them.
-	 */
-	if (busiest->expired->nr_active)
-		array = busiest->expired;
-	else
-		array = busiest->active;
-
-new_array:
-	/* Start searching at priority 0: */
-	idx = 0;
-skip_bitmap:
-	if (!idx)
-		idx = sched_find_first_bit(array->bitmap);
-	else
-		idx = find_next_bit(array->bitmap, MAX_PRIO, idx);
-	if (idx >= MAX_PRIO) {
-		if (array == busiest->expired) {
-			array = busiest->active;
-			goto new_array;
-		}
-		goto out_unlock;
-	}
-
-	head = array->queue + idx;
-	curr = head->prev;
-skip_queue:
-	tmp = list_entry(curr, task_t, run_list);
 
 	/*
 	 * We do not migrate tasks that are:
@@ -1231,21 +935,19 @@ skip_queue:
 	 * 3) are cache-hot on their current CPU.
 	 */
 
-	curr = curr->prev;
+	do {
+		struct policy *policy;
+		task_t *task;
+
+		policy = rq_migrate_policy(busiest);
+		if (!policy)
+			break;
+		task = policy->migrate(policy->queue);
+		if (!task)
+			break;
+		pull_task(busiest, task, this_rq, this_cpu);
+	} while (!idle && --imbalance);
 
-	if (!can_migrate_task(tmp, busiest, this_cpu, idle)) {
-		if (curr != head)
-			goto skip_queue;
-		idx++;
-		goto skip_bitmap;
-	}
-	pull_task(busiest, array, tmp, this_rq, this_cpu);
-	if (!idle && --imbalance) {
-		if (curr != head)
-			goto skip_queue;
-		idx++;
-		goto skip_bitmap;
-	}
 out_unlock:
 	spin_unlock(&busiest->lock);
 out:
@@ -1356,10 +1058,10 @@ EXPORT_PER_CPU_SYMBOL(kstat);
  */
 void scheduler_tick(int user_ticks, int sys_ticks)
 {
-	int cpu = smp_processor_id();
+	int idle, cpu = smp_processor_id();
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	struct policy *policy;
 	runqueue_t *rq = this_rq();
-	task_t *p = current;
 
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_ticks);
@@ -1373,98 +1075,28 @@ void scheduler_tick(int user_ticks, int 
 		sys_ticks = 0;
 	}
 
-	if (p == rq->idle) {
-		if (atomic_read(&rq->nr_iowait) > 0)
-			cpustat->iowait += sys_ticks;
-		else
-			cpustat->idle += sys_ticks;
-		rebalance_tick(rq, 1);
-		return;
-	}
-	if (TASK_NICE(p) > 0)
-		cpustat->nice += user_ticks;
-	else
-		cpustat->user += user_ticks;
-	cpustat->system += sys_ticks;
-
-	/* Task might have expired already, but not scheduled off yet */
-	if (p->array != rq->active) {
-		set_tsk_need_resched(p);
-		goto out;
-	}
 	spin_lock(&rq->lock);
-	/*
-	 * The task was running during this tick - update the
-	 * time slice counter. Note: we do not update a thread's
-	 * priority until it either goes to sleep or uses up its
-	 * timeslice. This makes it possible for interactive tasks
-	 * to use up their timeslices at their highest priority levels.
-	 */
-	if (unlikely(rt_task(p))) {
-		/*
-		 * RR tasks need a special form of timeslice management.
-		 * FIFO tasks have no timeslices.
-		 */
-		if ((p->policy == SCHED_RR) && !--p->time_slice) {
-			p->time_slice = task_timeslice(p);
-			p->first_time_slice = 0;
-			set_tsk_need_resched(p);
-
-			/* put it at the end of the queue: */
-			dequeue_task(p, rq->active);
-			enqueue_task(p, rq->active);
-		}
-		goto out_unlock;
-	}
-	if (!--p->time_slice) {
-		dequeue_task(p, rq->active);
-		set_tsk_need_resched(p);
-		p->prio = effective_prio(p);
-		p->time_slice = task_timeslice(p);
-		p->first_time_slice = 0;
-
-		if (!rq->expired_timestamp)
-			rq->expired_timestamp = jiffies;
-		if (!TASK_INTERACTIVE(p) || EXPIRED_STARVING(rq)) {
-			enqueue_task(p, rq->expired);
-		} else
-			enqueue_task(p, rq->active);
-	} else {
-		/*
-		 * Prevent a too long timeslice allowing a task to monopolize
-		 * the CPU. We do this by splitting up the timeslice into
-		 * smaller pieces.
-		 *
-		 * Note: this does not mean the task's timeslices expire or
-		 * get lost in any way, they just might be preempted by
-		 * another task of equal priority. (one with higher
-		 * priority would have preempted this task already.) We
-		 * requeue this task to the end of the list on this priority
-		 * level, which is in essence a round-robin of tasks with
-		 * equal priority.
-		 *
-		 * This only applies to tasks in the interactive
-		 * delta range with at least TIMESLICE_GRANULARITY to requeue.
-		 */
-		if (TASK_INTERACTIVE(p) && !((task_timeslice(p) -
-			p->time_slice) % TIMESLICE_GRANULARITY(p)) &&
-			(p->time_slice >= TIMESLICE_GRANULARITY(p)) &&
-			(p->array == rq->active)) {
-
-			dequeue_task(p, rq->active);
-			set_tsk_need_resched(p);
-			p->prio = effective_prio(p);
-			enqueue_task(p, rq->active);
-		}
-	}
-out_unlock:
+	policy = rq_policy(rq);
+	idle = policy->ops->tick(policy->queue, current, user_ticks, sys_ticks);
 	spin_unlock(&rq->lock);
-out:
-	rebalance_tick(rq, 0);
+	rebalance_tick(rq, idle);
 }
 
 void scheduling_functions_start_here(void) { }
 
+static inline task_t *find_best_task(runqueue_t *rq)
+{
+	int idx;
+	struct policy *policy;
+
+	BUG_ON(!rq->policy_bitmap);
+	idx = __ffs(rq->policy_bitmap);
+	__check_task_policy(idx);
+	policy = rq->policies[idx];
+	check_policy(policy);
+	return policy->ops->best(policy->queue);
+}
+
 /*
  * schedule() is the main scheduler function.
  */
@@ -1472,11 +1104,7 @@ asmlinkage void schedule(void)
 {
 	task_t *prev, *next;
 	runqueue_t *rq;
-	prio_array_t *array;
-	struct list_head *queue;
-	unsigned long long now;
-	unsigned long run_time;
-	int idx;
+	struct policy *policy;
 
 	/*
 	 * Test if we are atomic.  Since do_exit() needs to call into
@@ -1494,22 +1122,9 @@ need_resched:
 	preempt_disable();
 	prev = current;
 	rq = this_rq();
+	policy = rq_policy(rq);
 
 	release_kernel_lock(prev);
-	now = sched_clock();
-	if (likely(now - prev->timestamp < NS_MAX_SLEEP_AVG))
-		run_time = now - prev->timestamp;
-	else
-		run_time = NS_MAX_SLEEP_AVG;
-
-	/*
-	 * Tasks with interactive credits get charged less run_time
-	 * at high sleep_avg to delay them losing their interactive
-	 * status
-	 */
-	if (HIGH_CREDIT(prev))
-		run_time /= (CURRENT_BONUS(prev) ? : 1);
-
 	spin_lock_irq(&rq->lock);
 
 	/*
@@ -1530,66 +1145,27 @@ need_resched:
 		prev->nvcsw++;
 		break;
 	case TASK_RUNNING:
+		policy->ops->start_wait(policy->queue, prev);
 		prev->nivcsw++;
 	}
+
 pick_next_task:
-	if (unlikely(!rq->nr_running)) {
 #ifdef CONFIG_SMP
+	if (unlikely(!rq->nr_running))
 		load_balance(rq, 1, cpu_to_node_mask(smp_processor_id()));
-		if (rq->nr_running)
-			goto pick_next_task;
 #endif
-		next = rq->idle;
-		rq->expired_timestamp = 0;
-		goto switch_tasks;
-	}
-
-	array = rq->active;
-	if (unlikely(!array->nr_active)) {
-		/*
-		 * Switch the active and expired arrays.
-		 */
-		rq->active = rq->expired;
-		rq->expired = array;
-		array = rq->active;
-		rq->expired_timestamp = 0;
-	}
-
-	idx = sched_find_first_bit(array->bitmap);
-	queue = array->queue + idx;
-	next = list_entry(queue->next, task_t, run_list);
-
-	if (next->activated > 0) {
-		unsigned long long delta = now - next->timestamp;
-
-		if (next->activated == 1)
-			delta = delta * (ON_RUNQUEUE_WEIGHT * 128 / 100) / 128;
-
-		array = next->array;
-		dequeue_task(next, array);
-		recalc_task_prio(next, next->timestamp + delta);
-		enqueue_task(next, array);
-	}
-	next->activated = 0;
-switch_tasks:
+	next = find_best_task(rq);
+	BUG_ON(!next);
 	prefetch(next);
 	clear_tsk_need_resched(prev);
 	RCU_qsctr(task_cpu(prev))++;
 
-	prev->sleep_avg -= run_time;
-	if ((long)prev->sleep_avg <= 0){
-		prev->sleep_avg = 0;
-		if (!(HIGH_CREDIT(prev) || LOW_CREDIT(prev)))
-			prev->interactive_credit--;
-	}
-	prev->timestamp = now;
-
 	if (likely(prev != next)) {
-		next->timestamp = now;
 		rq->nr_switches++;
-		rq->curr = next;
-
 		prepare_arch_switch(rq, next);
+		policy = task_policy(next);
+		policy->ops->set_curr(policy->queue, next);
+		set_rq_curr(rq, next);
 		prev = context_switch(rq, prev, next);
 		barrier();
 
@@ -1845,45 +1421,46 @@ void scheduling_functions_end_here(void)
 void set_user_nice(task_t *p, long nice)
 {
 	unsigned long flags;
-	prio_array_t *array;
 	runqueue_t *rq;
-	int old_prio, new_prio, delta;
+	struct policy *policy;
+	int delta, queued;
 
-	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
+	if (nice < -20 || nice > 19)
 		return;
 	/*
 	 * We have to be careful, if called from sys_setpriority(),
 	 * the task might be in the middle of scheduling on another CPU.
 	 */
 	rq = task_rq_lock(p, &flags);
+	delta = nice - __task_nice(p);
+	if (!delta) {
+		if (p->pid == 0 || p->pid == 1)
+			printk("no change in nice, set_user_nice() nops!\n");
+		goto out_unlock;
+	}
+
+	policy = task_policy(p);
+
 	/*
 	 * The RT priorities are set via setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
 	 * it wont have any effect on scheduling until the task is
 	 * not SCHED_NORMAL:
 	 */
-	if (rt_task(p)) {
-		p->static_prio = NICE_TO_PRIO(nice);
-		goto out_unlock;
-	}
-	array = p->array;
-	if (array)
-		dequeue_task(p, array);
-
-	old_prio = p->prio;
-	new_prio = NICE_TO_PRIO(nice);
-	delta = new_prio - old_prio;
-	p->static_prio = NICE_TO_PRIO(nice);
-	p->prio += delta;
+	queued = task_queued(p);
+	if (queued)
+		dequeue_task(p, rq);
+
+	policy->ops->renice(policy->queue, p, nice);
 
-	if (array) {
-		enqueue_task(p, array);
+	if (queued) {
+		enqueue_task(p, rq);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
 		 */
 		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+			resched_task(rq_curr(rq));
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);
@@ -1919,7 +1496,7 @@ asmlinkage long sys_nice(int increment)
 	if (increment > 40)
 		increment = 40;
 
-	nice = PRIO_TO_NICE(current->static_prio) + increment;
+	nice = task_nice(current) + increment;
 	if (nice < -20)
 		nice = -20;
 	if (nice > 19)
@@ -1935,6 +1512,12 @@ asmlinkage long sys_nice(int increment)
 
 #endif
 
+static int __task_prio(task_t *task)
+{
+	struct policy *policy = task_policy(task);
+	return policy->ops->prio(task);
+}
+
 /**
  * task_prio - return the priority value of a given task.
  * @p: the task in question.
@@ -1943,29 +1526,111 @@ asmlinkage long sys_nice(int increment)
  * RT tasks are offset by -200. Normal tasks are centered
  * around 0, value goes from -16 to +15.
  */
-int task_prio(task_t *p)
+int task_prio(task_t *task)
 {
-	return p->prio - MAX_RT_PRIO;
+	int prio;
+	unsigned long flags;
+	runqueue_t *rq;
+
+	rq = task_rq_lock(task, &flags);
+	prio = __task_prio(task);
+	task_rq_unlock(rq, &flags);
+	return prio;
 }
 
 /**
  * task_nice - return the nice value of a given task.
  * @p: the task in question.
  */
-int task_nice(task_t *p)
+int task_nice(task_t *task)
 {
-	return TASK_NICE(p);
+	int nice;
+	unsigned long flags;
+	runqueue_t *rq;
+
+
+	rq = task_rq_lock(task, &flags);
+	nice = __task_nice(task);
+	task_rq_unlock(rq, &flags);
+	return nice;
 }
 
 EXPORT_SYMBOL(task_nice);
 
+int task_sched_policy(task_t *task)
+{
+	check_task_policy(task);
+	switch (task->sched_info.policy) {
+		case SCHED_POLICY_RT:
+			if (task->sched_info.cl_data.rt.rt_policy
+							== RT_POLICY_RR)
+				return SCHED_RR;
+			else
+				return SCHED_FIFO;
+		case SCHED_POLICY_TS:
+			return SCHED_NORMAL;
+		case SCHED_POLICY_BATCH:
+			return SCHED_BATCH;
+		case SCHED_POLICY_IDLE:
+			return SCHED_IDLE;
+		default:
+			BUG();
+			return -1;
+	}
+}
+EXPORT_SYMBOL(task_sched_policy);
+
+void set_task_sched_policy(task_t *task, int policy)
+{
+	check_task_policy(task);
+	BUG_ON(task_queued(task));
+	switch (policy) {
+		case SCHED_FIFO:
+			task->sched_info.policy = SCHED_POLICY_RT;
+			task->sched_info.cl_data.rt.rt_policy = RT_POLICY_FIFO;
+			break;
+		case SCHED_RR:
+			task->sched_info.policy = SCHED_POLICY_RT;
+			task->sched_info.cl_data.rt.rt_policy = RT_POLICY_RR;
+			break;
+		case SCHED_NORMAL:
+			task->sched_info.policy = SCHED_POLICY_TS;
+			break;
+		case SCHED_BATCH:
+			task->sched_info.policy = SCHED_POLICY_BATCH;
+			break;
+		case SCHED_IDLE:
+			task->sched_info.policy = SCHED_POLICY_IDLE;
+			break;
+		default:
+			BUG();
+			break;
+	}
+	check_task_policy(task);
+}
+EXPORT_SYMBOL(set_task_sched_policy);
+
+int rt_task(task_t *task)
+{
+	check_task_policy(task);
+	return !!(task->sched_info.policy == SCHED_POLICY_RT);
+}
+EXPORT_SYMBOL(rt_task);
+
 /**
  * idle_cpu - is a given cpu idle currently?
  * @cpu: the processor in question.
  */
 int idle_cpu(int cpu)
 {
-	return cpu_curr(cpu) == cpu_rq(cpu)->idle;
+	int idle;
+	unsigned long flags;
+	runqueue_t *rq = cpu_rq(cpu);
+
+	spin_lock_irqsave(&rq->lock, flags);
+	idle = !!(rq->curr == SCHED_POLICY_IDLE);
+	spin_unlock_irqrestore(&rq->lock, flags);
+	return idle;
 }
 
 EXPORT_SYMBOL_GPL(idle_cpu);
@@ -1985,11 +1650,10 @@ static inline task_t *find_process_by_pi
 static int setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 {
 	struct sched_param lp;
-	int retval = -EINVAL;
-	int oldprio;
-	prio_array_t *array;
+	int queued, retval = -EINVAL;
 	unsigned long flags;
 	runqueue_t *rq;
+	struct policy *rq_policy;
 	task_t *p;
 
 	if (!param || pid < 0)
@@ -2017,7 +1681,7 @@ static int setscheduler(pid_t pid, int p
 	rq = task_rq_lock(p, &flags);
 
 	if (policy < 0)
-		policy = p->policy;
+		policy = task_sched_policy(p);
 	else {
 		retval = -EINVAL;
 		if (policy != SCHED_FIFO && policy != SCHED_RR &&
@@ -2047,29 +1711,23 @@ static int setscheduler(pid_t pid, int p
 	if (retval)
 		goto out_unlock;
 
-	array = p->array;
-	if (array)
+	queued = task_queued(p);
+	if (queued)
 		deactivate_task(p, task_rq(p));
 	retval = 0;
-	p->policy = policy;
-	p->rt_priority = lp.sched_priority;
-	oldprio = p->prio;
-	if (policy != SCHED_NORMAL)
-		p->prio = MAX_USER_RT_PRIO-1 - p->rt_priority;
-	else
-		p->prio = p->static_prio;
-	if (array) {
+	set_task_sched_policy(p, policy);
+	check_task_policy(p);
+	rq_policy = rq->policies[p->sched_info.policy];
+	check_policy(rq_policy);
+	rq_policy->ops->setprio(p, lp.sched_priority);
+	if (queued) {
 		__activate_task(p, task_rq(p));
 		/*
 		 * Reschedule if we are currently running on this runqueue and
 		 * our priority decreased, or if we are not currently running on
 		 * this runqueue and our priority is higher than the current's
 		 */
-		if (rq->curr == p) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else if (p->prio < rq->curr->prio)
-			resched_task(rq->curr);
+		resched_task(rq_curr(rq));
 	}
 
 out_unlock:
@@ -2121,7 +1779,7 @@ asmlinkage long sys_sched_getscheduler(p
 	if (p) {
 		retval = security_task_getscheduler(p);
 		if (!retval)
-			retval = p->policy;
+			retval = task_sched_policy(p);
 	}
 	read_unlock(&tasklist_lock);
 
@@ -2153,7 +1811,7 @@ asmlinkage long sys_sched_getparam(pid_t
 	if (retval)
 		goto out_unlock;
 
-	lp.sched_priority = p->rt_priority;
+	lp.sched_priority = task_prio(p);
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -2262,32 +1920,13 @@ out_unlock:
  */
 asmlinkage long sys_sched_yield(void)
 {
+	struct policy *policy;
 	runqueue_t *rq = this_rq_lock();
-	prio_array_t *array = current->array;
-
-	/*
-	 * We implement yielding by moving the task into the expired
-	 * queue.
-	 *
-	 * (special rule: RT tasks will just roundrobin in the active
-	 *  array.)
-	 */
-	if (likely(!rt_task(current))) {
-		dequeue_task(current, array);
-		enqueue_task(current, rq->expired);
-	} else {
-		list_del(&current->run_list);
-		list_add_tail(&current->run_list, array->queue + current->prio);
-	}
-	/*
-	 * Since we are going to call schedule() anyway, there's
-	 * no need to preempt:
-	 */
+	policy = rq_policy(rq);
+	policy->ops->yield(policy->queue, current);
 	_raw_spin_unlock(&rq->lock);
 	preempt_enable_no_resched();
-
 	schedule();
-
 	return 0;
 }
 
@@ -2387,6 +2026,19 @@ asmlinkage long sys_sched_get_priority_m
 	return ret;
 }
 
+static inline unsigned long task_timeslice(task_t *task)
+{
+	unsigned long flags, timeslice;
+	struct policy *policy;
+	runqueue_t *rq;
+
+	rq = task_rq_lock(task, &flags);
+	policy = task_policy(task);
+	timeslice = policy->ops->timeslice(policy->queue, task);
+	task_rq_unlock(rq, &flags);
+	return timeslice;
+}
+
 /**
  * sys_sched_rr_get_interval - return the default timeslice of a process.
  * @pid: pid of the process.
@@ -2414,8 +2066,7 @@ asmlinkage long sys_sched_rr_get_interva
 	if (retval)
 		goto out_unlock;
 
-	jiffies_to_timespec(p->policy & SCHED_FIFO ?
-				0 : task_timeslice(p), &t);
+	jiffies_to_timespec(task_timeslice(p), &t);
 	read_unlock(&tasklist_lock);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 out_nounlock:
@@ -2523,17 +2174,22 @@ void show_state(void)
 void __init init_idle(task_t *idle, int cpu)
 {
 	runqueue_t *idle_rq = cpu_rq(cpu), *rq = cpu_rq(task_cpu(idle));
+	struct policy *policy;
 	unsigned long flags;
 
 	local_irq_save(flags);
 	double_rq_lock(idle_rq, rq);
-
-	idle_rq->curr = idle_rq->idle = idle;
+	policy = rq_policy(rq);
+	BUG_ON(policy != task_policy(idle));
+	printk("deactivating, have %d tasks\n",
+			policy->ops->tasks(policy->queue));
 	deactivate_task(idle, rq);
-	idle->array = NULL;
-	idle->prio = MAX_PRIO;
+	set_task_sched_policy(idle, SCHED_IDLE);
 	idle->state = TASK_RUNNING;
 	set_task_cpu(idle, cpu);
+	activate_task(idle, rq);
+	nr_running_dec(rq);
+	set_rq_curr(rq, idle);
 	double_rq_unlock(idle_rq, rq);
 	set_tsk_need_resched(idle);
 	local_irq_restore(flags);
@@ -2804,38 +2460,27 @@ __init static void init_kstat(void) {
 void __init sched_init(void)
 {
 	runqueue_t *rq;
-	int i, j, k;
+	int i, j;
 
 	/* Init the kstat counters */
 	init_kstat();
 	for (i = 0; i < NR_CPUS; i++) {
-		prio_array_t *array;
-
 		rq = cpu_rq(i);
-		rq->active = rq->arrays;
-		rq->expired = rq->arrays + 1;
 		spin_lock_init(&rq->lock);
 		INIT_LIST_HEAD(&rq->migration_queue);
 		atomic_set(&rq->nr_iowait, 0);
 		nr_running_init(rq);
-
-		for (j = 0; j < 2; j++) {
-			array = rq->arrays + j;
-			for (k = 0; k < MAX_PRIO; k++) {
-				INIT_LIST_HEAD(array->queue + k);
-				__clear_bit(k, array->bitmap);
-			}
-			// delimiter for bitsearch
-			__set_bit(MAX_PRIO, array->bitmap);
-		}
+		memcpy(rq->policies, policies, sizeof(policies));
+		for (j = 0; j < BITS_PER_LONG && rq->policies[j]; ++j)
+			rq->policies[j]->ops->init(rq->policies[j], i);
 	}
 	/*
 	 * We have to do a little magic to get the first
 	 * thread right in SMP mode.
 	 */
 	rq = this_rq();
-	rq->curr = current;
-	rq->idle = current;
+	set_task_sched_policy(current, SCHED_NORMAL);
+	set_rq_curr(rq, current);
 	set_task_cpu(current, smp_processor_id());
 	wake_up_forked_process(current);
 
diff -prauN linux-2.6.0-test11/lib/Makefile sched-2.6.0-test11-5/lib/Makefile
--- linux-2.6.0-test11/lib/Makefile	2003-11-26 12:42:55.000000000 -0800
+++ sched-2.6.0-test11-5/lib/Makefile	2003-12-20 15:09:16.000000000 -0800
@@ -5,7 +5,7 @@
 
 lib-y := errno.o ctype.o string.o vsprintf.o cmdline.o \
 	 bust_spinlocks.o rbtree.o radix-tree.o dump_stack.o \
-	 kobject.o idr.o div64.o parser.o
+	 kobject.o idr.o div64.o parser.o binomial.o
 
 lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
diff -prauN linux-2.6.0-test11/lib/binomial.c sched-2.6.0-test11-5/lib/binomial.c
--- linux-2.6.0-test11/lib/binomial.c	1969-12-31 16:00:00.000000000 -0800
+++ sched-2.6.0-test11-5/lib/binomial.c	2003-12-20 17:32:09.000000000 -0800
@@ -0,0 +1,138 @@
+#include <linux/kernel.h>
+#include <linux/binomial.h>
+
+struct binomial *binomial_minimum(struct binomial **heap)
+{
+	struct binomial *minimum, *tmp;
+
+	for (minimum = NULL, tmp = *heap; tmp; tmp = tmp->sibling) {
+		if (!minimum || minimum->priority > tmp->priority)
+			minimum = tmp;
+	}
+	return minimum;
+}
+
+static void binomial_link(struct binomial *left, struct binomial *right)
+{
+	left->parent  = right;
+	left->sibling = right->child;
+	right->child  = left;
+	right->degree++;
+}
+
+static void binomial_merge(struct binomial **both, struct binomial **left,
+						struct binomial **right)
+{
+	while (*left && *right) {
+		if ((*left)->degree < (*right)->degree) {
+			*both = *left;
+			left = &(*left)->sibling;
+		} else {
+			*both = *right;
+			right = &(*right)->sibling;
+		}
+		both = &(*both)->sibling;
+	}
+	/*
+	 * for more safety:
+	 * *left = *right = NULL;
+	 */
+}
+
+void binomial_union(struct binomial **both, struct binomial **left,
+						struct binomial **right)
+{
+	struct binomial *prev, *tmp, *next;
+
+	binomial_merge(both, left, right);
+	if (!(tmp = *both))
+		return;
+
+	for (prev = NULL, next = tmp->sibling; next; next = tmp->sibling) {
+		if ((next->sibling && next->sibling->degree == tmp->degree)
+					|| tmp->degree != next->degree) {
+			prev = tmp;
+			tmp  = next;
+		} else if (tmp->priority <= next->priority) {
+			tmp->sibling = next->sibling;
+			binomial_link(next, tmp);
+		} else {
+			if (!prev)
+				*both = next;
+			else
+				prev->sibling = next;
+			binomial_link(tmp, next);
+			tmp = next;
+		}
+	}
+}
+
+void binomial_insert(struct binomial **heap, struct binomial *element)
+{
+	element->parent  = NULL;
+	element->child   = NULL;
+	element->sibling = NULL;
+	element->degree  = 0;
+	binomial_union(heap, heap, &element);
+}
+
+static void binomial_reverse(struct binomial **in, struct binomial **out)
+{
+	while (*in) {
+		struct binomial *tmp = *in;
+		*in = (*in)->sibling;
+		tmp->sibling = *out;
+		*out = tmp;
+	}
+}
+
+struct binomial *binomial_extract_min(struct binomial **heap)
+{
+	struct binomial *tmp, *minimum, *last, *min_last, *new_heap;
+
+	minimum = last = min_last = new_heap = NULL;
+	for (tmp = *heap; tmp; last = tmp, tmp = tmp->sibling) {
+		if (!minimum || tmp->priority < minimum->priority) {
+			minimum  = tmp;
+			min_last = last;
+		}
+	}
+	if (min_last && minimum)
+		min_last->sibling = minimum->sibling;
+	else if (minimum)
+		(*heap)->sibling = minimum->sibling;
+	else
+		return NULL;
+	binomial_reverse(&minimum->child, &new_heap);
+	binomial_union(heap, heap, &new_heap);
+	return minimum;
+}
+
+void binomial_decrease(struct binomial **heap, struct binomial *element,
+							unsigned increment)
+{
+	struct binomial *tmp, *last = NULL;
+
+	element->priority -= min(element->priority, increment);
+	last = element;
+	tmp  = last->parent;
+	while (tmp && last->priority < tmp->priority) {
+		unsigned tmp_prio = tmp->priority;
+		tmp->priority = last->priority;
+		last->priority = tmp_prio;
+		last = tmp;
+		tmp  = tmp->parent;
+	}
+}
+
+void binomial_delete(struct binomial **heap, struct binomial *element)
+{
+	struct binomial *tmp, *last = element;
+	for (tmp = last->parent; tmp; last = tmp, tmp = tmp->parent) {
+		unsigned tmp_prio = tmp->priority;
+		tmp->priority = last->priority;
+		last->priority = tmp_prio;
+	}
+	binomial_reverse(&last->child, &tmp);
+	binomial_union(heap, heap, &tmp);
+}
diff -prauN linux-2.6.0-test11/mm/oom_kill.c sched-2.6.0-test11-5/mm/oom_kill.c
--- linux-2.6.0-test11/mm/oom_kill.c	2003-11-26 12:44:16.000000000 -0800
+++ sched-2.6.0-test11-5/mm/oom_kill.c	2003-12-17 07:07:53.000000000 -0800
@@ -158,7 +158,6 @@ static void __oom_kill_task(task_t *p)
 	 * all the memory it needs. That way it should be able to
 	 * exit() and clear out its resources quickly...
 	 */
-	p->time_slice = HZ;
 	p->flags |= PF_MEMALLOC | PF_MEMDIE;
 
 	/* This process has hardware access, be more careful. */
