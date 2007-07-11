Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXGKEte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXGKEte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 00:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXGKEtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 00:49:24 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:40401 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759932AbXGKEtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 00:49:21 -0400
Date: Wed, 11 Jul 2007 00:49:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC] Thread Migration Preemption - v2
Message-ID: <20070711044915.GA4025@Krystal>
References: <20070706060257.GA188@tv-sign.ru> <20070706142339.GA32754@Krystal> <20070706145634.GA198@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070706145634.GA198@tv-sign.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:32:05 up 3 days, 18:37,  2 users,  load average: 0.30, 0.30, 0.28
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Still as an RFC, here is an updated version of the migration handling
code in sched.c that supports migrate_disable()/migrate_enable().

I have taken care of the comments I received, thanks. I switched to
migrate_enable/disable following Matt Mackall's comments. He also
suggested to create, for now, an alias of migrate_disable/enable() to
preempt_disable/enable() so that people could better identify what
protection their code requires. This transition phase makes perfect
sense to me.

A case study of scenarios where migration disabling without preemption
disabling is useful must still be done, both for mainline kernel and for
the -rt patch case. It basically involves any case where per-cpu data
can be atomically updated using local atomic operations or where being
tied to a CPU is important due to usage of its specific resources
(performance counters could be a good example of this). We can also
find, in the -rt kernel, the exemple of the threaded softirqs which must
stay binded on a specific CPU and, due to performance reasons, cannot
set the cpu affinity.

A new idea came to me recently: using migration disabling from
user-space through a vsyscall page to protect accesses to per-cpu data
in a locally atomic manner, which would be reentrant wrt signals and use
less space than per thread data. I clearly see an interest for
user-space tracing, where duplicating buffers per thread would be a
waste of ressources. Since it is not possible to disable preemption from
user-space context, disabling migration efficiently would be the
solution that could provide critical regions bound to a CPU to
user-space programs.

Mathieu


Thread Migration Preemption - v2

This patch adds the ability to protect critical sections from migration to
another CPU without disabling preemption.

This will be useful to minimize the amount of preemption disabling for the -rt
patch. It will help leveraging improvements brought by the local_t types in
asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
variables protected by migrate_disable must be either atomic or protected from
concurrent updates done by other threads.

Typical use:

migrate_disable();
local_inc(&__get_cpu_var(&my_local_t_var));
migrate_enable();

Which will increment the variable atomically wrt the local CPU.

Changes:

Do a check_migrate() upon migrate_enable() to answer to the migration
thread waiting for us to exit the migration disabled critical section. Use a
NEED_MIGRATE thread flag for this.

Note: (or we could say FIXME)
Is we ever want to check migration pending in assembly code, we will have to
make sure we test the right thread flag bits on each architectures. Care should
also be taken to check that the thread flags used won't trigger false positives
in non selective asm thread flag checks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-alpha/thread_info.h     |    3 +
 include/asm-arm/thread_info.h       |    5 +
 include/asm-arm26/thread_info.h     |    5 +
 include/asm-avr32/thread_info.h     |    4 +
 include/asm-blackfin/thread_info.h  |    4 +
 include/asm-cris/thread_info.h      |    4 +
 include/asm-frv/thread_info.h       |    4 +
 include/asm-h8300/thread_info.h     |    4 +
 include/asm-i386/thread_info.h      |    6 +-
 include/asm-ia64/thread_info.h      |    4 +
 include/asm-m32r/thread_info.h      |    4 +
 include/asm-m68k/thread_info.h      |    2 
 include/asm-m68knommu/thread_info.h |    3 +
 include/asm-mips/thread_info.h      |    4 +
 include/asm-parisc/thread_info.h    |    4 +
 include/asm-powerpc/thread_info.h   |    4 +
 include/asm-s390/thread_info.h      |    4 +
 include/asm-sh/thread_info.h        |    4 +
 include/asm-sh64/thread_info.h      |    4 +
 include/asm-sparc/thread_info.h     |    4 +
 include/asm-sparc64/thread_info.h   |    5 +
 include/asm-um/thread_info.h        |    4 +
 include/asm-v850/thread_info.h      |    4 +
 include/asm-x86_64/thread_info.h    |    4 +
 include/asm-xtensa/thread_info.h    |    4 +
 include/linux/preempt.h             |   43 ++++++++++++++++
 kernel/sched.c                      |   92 +++++++++++++++++++++++++++++++++---
 lib/smp_processor_id.c              |    6 +-
 28 files changed, 230 insertions(+), 12 deletions(-)

Index: linux-2.6-lttng/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-i386/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-i386/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -31,8 +31,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
-
+	int			migrate_count;/* 0: can migrate, <0: BUG */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread
@@ -74,6 +73,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
@@ -132,6 +132,7 @@
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_SECCOMP		7	/* secure computing */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
+#define TIF_NEED_MIGRATE	9	/* migration necessary */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
@@ -147,6 +148,7 @@
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
Index: linux-2.6-lttng/include/linux/preempt.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/preempt.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/linux/preempt.h	2007-07-11 00:43:03.000000000 -0400
@@ -12,15 +12,24 @@
 #ifdef CONFIG_DEBUG_PREEMPT
   extern void fastcall add_preempt_count(int val);
   extern void fastcall sub_preempt_count(int val);
+  extern void fastcall add_migrate_count(int val);
+  extern void fastcall sub_migrate_count(int val);
 #else
 # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
 # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define add_migrate_count(val) do { migrate_count() += (val); } while (0)
+# define sub_migrate_count(val) do { migrate_count() -= (val); } while (0)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
 #define dec_preempt_count() sub_preempt_count(1)
 
-#define preempt_count()	(current_thread_info()->preempt_count)
+#define preempt_count() (current_thread_info()->preempt_count)
+
+#define inc_migrate_count() add_migrate_count(1)
+#define dec_migrate_count() sub_migrate_count(1)
+
+#define migrate_count() (current_thread_info()->migrate_count)
 
 #ifdef CONFIG_PREEMPT
 
@@ -51,6 +60,35 @@
 	preempt_check_resched(); \
 } while (0)
 
+#define migrate_disable() \
+do { \
+	inc_migrate_count(); \
+	barrier(); \
+} while (0)
+
+#define migrate_enable_no_check() \
+do { \
+	barrier(); \
+	dec_migrate_count(); \
+} while (0)
+
+#ifdef CONFIG_SMP
+#define check_migrate() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_MIGRATE))) \
+		do_check_migrate(); \
+} while (0)
+#else
+#define check_migrate()
+#endif
+
+#define migrate_enable() \
+do { \
+	migrate_enable_no_check(); \
+	barrier(); \
+	check_migrate(); \
+} while (0)
+
 #else
 
 #define preempt_disable()		do { } while (0)
@@ -58,6 +96,9 @@
 #define preempt_enable()		do { } while (0)
 #define preempt_check_resched()		do { } while (0)
 
+#define migrate_disable()		do { } while (0)
+#define migrate_enable()		do { } while (0)
+
 #endif
 
 #endif /* __LINUX_PREEMPT_H */
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-07-11 00:43:02.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-07-11 00:43:03.000000000 -0400
@@ -946,7 +946,8 @@
 	 * If the task is not on a runqueue (and not running), then
 	 * it is sufficient to simply update the task's cpu field.
 	 */
-	if (!p->se.on_rq && !task_running(rq, p)) {
+	if (!p->se.on_rq && !task_running(rq, p)
+			&& !task_thread_info(p)->migrate_count) {
 		set_task_cpu(p, dest_cpu);
 		return 0;
 	}
@@ -1347,7 +1348,10 @@
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
-
+#ifdef CONFIG_PREEMPT
+	if (task_thread_info(p)->migrate_count)
+		goto out_activate;
+#endif
 	new_cpu = cpu;
 
 	schedstat_inc(rq, ttwu_cnt);
@@ -1534,6 +1538,7 @@
 #ifdef CONFIG_PREEMPT
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
+	task_thread_info(p)->migrate_count = 0;
 #endif
 	put_cpu();
 }
@@ -1933,6 +1938,10 @@
 	if (!cpu_isset(dest_cpu, p->cpus_allowed)
 	    || unlikely(cpu_is_offline(dest_cpu)))
 		goto out;
+#ifdef CONFIG_PREEMPT
+	if (task_thread_info(p)->migrate_count)
+		goto out;
+#endif
 
 	trace_mark(kernel_sched_migrate_task, "%d %ld %d",
 		p->pid, p->state, dest_cpu);
@@ -1996,6 +2005,7 @@
 	 * 1) running (obviously), or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
+	 * 4) migration preemption is non 0 for this non running task.
 	 */
 	if (!cpu_isset(this_cpu, p->cpus_allowed))
 		return 0;
@@ -2003,6 +2013,10 @@
 
 	if (task_running(rq, p))
 		return 0;
+#ifdef CONFIG_PREEMPT
+	if (task_thread_info(p)->migrate_count)
+		return 0;
+#endif
 
 	/*
 	 * Aggressive migration if too many balance attempts have failed:
@@ -3220,6 +3234,29 @@
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
+void fastcall add_migrate_count(int val)
+{
+	/*
+	 * Underflow?
+	 */
+	if (DEBUG_LOCKS_WARN_ON((migrate_count() < 0)))
+		return;
+	migrate_count() += val;
+}
+EXPORT_SYMBOL(add_migrate_count);
+
+void fastcall sub_migrate_count(int val)
+{
+	/*
+	 * Underflow?
+	 */
+	if (DEBUG_LOCKS_WARN_ON(val > migrate_count()))
+		return;
+
+	migrate_count() -= val;
+}
+EXPORT_SYMBOL(sub_migrate_count);
+
 #endif
 
 /*
@@ -3353,6 +3390,28 @@
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_PREEMPT
+
+#ifdef CONFIG_SMP
+/*
+ * Wake up the migration thread to deal with our pending migration.
+ * If we have been moved since, we will just wake up the migration thread from
+ * the wrong CPU, which does not hurt anyone. (that's why we use
+ * raw_smp_processor_id()).
+ */
+void __sched do_check_migrate(void)
+{
+	struct rq *rq;
+
+	if (migrate_count())
+		return;
+
+	clear_thread_flag(TIF_NEED_MIGRATE);
+	rq = cpu_rq(raw_smp_processor_id());
+	wake_up_process(rq->migration_thread);
+}
+EXPORT_SYMBOL(do_check_migrate);
+#endif
+
 /*
  * this is the entry point to schedule() from in-kernel preemption
  * off of preempt_enable.  Kernel preemptions off return from interrupt
@@ -4814,7 +4873,7 @@
  * So we race with normal scheduler movements, but that's OK, as long
  * as the task is no longer on this CPU.
  *
- * Returns non-zero if task was successfully migrated.
+ * Returns non-zero if task is on dest_cpu when this function ends.
  */
 static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 {
@@ -4829,13 +4888,19 @@
 
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
-	if (task_cpu(p) != src_cpu)
+	if (task_cpu(p) != src_cpu) {
+		ret = 1;
 		goto out;
+	}
 	/* Affinity changed (again). */
 	if (!cpu_isset(dest_cpu, p->cpus_allowed))
 		goto out;
 
 	on_rq = p->se.on_rq;
+#ifdef CONFIG_PREEMPT
+	if (!on_rq && task_thread_info(p)->migrate_count)
+		goto out;
+#endif
 	if (on_rq)
 		deactivate_task(rq_src, p, 0);
 	set_task_cpu(p, dest_cpu);
@@ -4858,6 +4923,7 @@
 {
 	int cpu = (long)data;
 	struct rq *rq;
+	int migrated;
 
 	rq = cpu_rq(cpu);
 	BUG_ON(rq->migration_thread != current);
@@ -4891,10 +4957,22 @@
 		list_del_init(head->next);
 
 		spin_unlock(&rq->lock);
-		__migrate_task(req->task, cpu, req->dest_cpu);
+		migrated = __migrate_task(req->task, cpu, req->dest_cpu);
 		local_irq_enable();
-
-		complete(&req->done);
+		if (!migrated) {
+			/*
+			 * If the process has not been migrated, let it run
+			 * until it reaches a migration_check() so it can
+			 * wake us up.
+			 */
+			spin_lock_irq(&rq->lock);
+			head = &rq->migration_queue;
+			list_add(&req->list, head);
+			set_tsk_thread_flag(req->task, TIF_NEED_MIGRATE);
+			spin_unlock_irq(&rq->lock);
+			wake_up_process(req->task);
+		} else
+			complete(&req->done);
 	}
 	__set_current_state(TASK_RUNNING);
 	return 0;
Index: linux-2.6-lttng/include/asm-alpha/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-alpha/thread_info.h	2007-07-11 00:43:02.000000000 -0400
+++ linux-2.6-lttng/include/asm-alpha/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -21,6 +21,7 @@
 	mm_segment_t		addr_limit;	/* thread address space */
 	unsigned		cpu;		/* current CPU */
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	int bpt_nsaved;
 	unsigned long bpt_addr[2];		/* breakpoint handling  */
@@ -77,6 +78,7 @@
 #define TIF_MEMDIE		8
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define	TIF_SYSCALL_AUDIT	10
+#define TIF_NEED_MIGRATE	11	/* migration necessary */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -84,6 +86,7 @@
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
Index: linux-2.6-lttng/include/asm-arm/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm/thread_info.h	2007-07-11 00:43:00.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -51,6 +51,7 @@
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
@@ -72,6 +73,7 @@
 	.exec_domain	= &default_exec_domain,				\
 	.flags		= 0,						\
 	.preempt_count	= 1,						\
+	.migrate_count = 0,						\
 	.addr_limit	= KERNEL_DS,					\
 	.cpu_domain	= domain_val(DOMAIN_USER, DOMAIN_MANAGER) |	\
 			  domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) |	\
@@ -137,12 +139,14 @@
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
+ *  TIF_NEED_MIGRATE	- migration necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
  *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  *  TIF_SYSCALL_AUDIT	- Syscall audting active - LTTng
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
+#define TIF_NEED_MIGRATE	2
 #define	TIF_SYSCALL_AUDIT	7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
@@ -152,6 +156,7 @@
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define	_TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
Index: linux-2.6-lttng/include/asm-arm26/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm26/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm26/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -45,6 +45,7 @@
 struct thread_info {
 	unsigned long		flags;		/* low level flags */
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* address limit */
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain      *exec_domain;   /* execution domain */
@@ -60,6 +61,7 @@
 	.exec_domain	&default_exec_domain,	\
 	.flags		0,			\
 	.preempt_count	0,			\
+	.migrate_count 0,			\
 	.addr_limit	KERNEL_DS,		\
 	.restart_block  = {                             \
 		.fn     = do_no_restart_syscall,        \
@@ -112,11 +114,13 @@
  *  TIF_SYSCALL_TRACE	- syscall trace active
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
+ *  TIF_NEED_MIGRATE	- migration necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
  *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  */
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
+#define TIF_NEED_MIGRATE	2
 #define TIF_SYSCALL_TRACE	8
 #define TIF_USED_FPU		16
 #define TIF_POLLING_NRFLAG	17
@@ -124,6 +128,7 @@
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_USED_FPU		(1 << TIF_USED_FPU)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
Index: linux-2.6-lttng/include/asm-avr32/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-avr32/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-avr32/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -25,6 +25,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;
 	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block	restart_block;
 	__u8			supervisor_stack[0];
 };
@@ -36,6 +37,7 @@
 	.flags		= 0,						\
 	.cpu		= 0,						\
 	.preempt_count	= 1,						\
+	.migrate_count = 0,						\
 	.restart_block	= {						\
 		.fn	= do_no_restart_syscall				\
 	}								\
@@ -83,6 +85,7 @@
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
+#define TIF_NEED_MIGRATE      9       /* migration necessary */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
@@ -94,6 +97,7 @@
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 
 /* XXX: These two masks must never span more than 16 bits! */
 /* work to do on interrupt/exception return */
Index: linux-2.6-lttng/include/asm-blackfin/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-blackfin/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-blackfin/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -54,6 +54,7 @@
 	unsigned long flags;	/* low level flags */
 	int cpu;		/* cpu we're on */
 	int preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int migrate_count;	/* 0: can migrate, <0 => BUG */
 	mm_segment_t addr_limit;	/* address limit */
 	struct restart_block restart_block;
 	struct l1_scratch_task_info l1_task_info;
@@ -69,6 +70,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count  = 1,                    \
+	.migrate_count = 0,			\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
@@ -125,6 +127,7 @@
 #define TIF_MEMDIE              4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              6       /* is freezing for suspend */
+#define TIF_NEED_MIGRATE	7	/* migration necessary */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -133,6 +136,7 @@
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
Index: linux-2.6-lttng/include/asm-cris/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-cris/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-cris/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -32,6 +32,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
@@ -58,6 +59,7 @@
 	.flags		= 0,				\
 	.cpu		= 0,				\
 	.preempt_count	= 1,				\
+	.migrate_count = 0,				\
 	.addr_limit	= KERNEL_DS,			\
 	.restart_block = {				\
 		       .fn = do_no_restart_syscall,	\
@@ -81,6 +83,7 @@
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_NEED_MIGRATE	3	/* migration necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 
@@ -88,6 +91,7 @@
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
Index: linux-2.6-lttng/include/asm-frv/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-frv/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -36,6 +36,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
@@ -68,6 +69,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
@@ -113,6 +115,7 @@
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_IRET		4	/* return with iret */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_NEED_MIGRATE	6	/* migration necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
@@ -125,6 +128,7 @@
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
Index: linux-2.6-lttng/include/asm-h8300/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-h8300/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-h8300/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -24,6 +24,7 @@
 	unsigned long	   flags;		/* low level flags */
 	int		   cpu;			/* cpu we're on */
 	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -37,6 +38,7 @@
 	.flags =	0,			\
 	.cpu =		0,			\
 	.preempt_count = 1,			\
+	.migrate_count = 0,			\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
@@ -91,12 +93,14 @@
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_NEED_MIGRATE	5	/* migration necessary */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
Index: linux-2.6-lttng/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ia64/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-ia64/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -30,6 +30,7 @@
 	__u32 status;			/* Thread synchronous flags */
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
+	int migrate_count;		/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -43,6 +44,7 @@
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= 0,			\
+	.migrate_count = 0,			\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
@@ -86,6 +88,7 @@
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_PERFMON_WORK	6	/* work for pfm_handle_work() */
+#define TIF_NEED_MIGRATE	7	/* migration necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
@@ -98,6 +101,7 @@
 #define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_PERFMON_WORK	(1 << TIF_PERFMON_WORK)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
Index: linux-2.6-lttng/include/asm-m32r/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-m32r/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -29,6 +29,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thread
@@ -69,6 +70,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
@@ -150,6 +152,7 @@
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
 #define TIF_IRET		4	/* return with iret */
+#define TIF_NEED_MIGRATE	5	/* migration necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 					/* 31..28 fault code */
 #define TIF_MEMDIE		17
@@ -160,6 +163,7 @@
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_IRET		(1<<TIF_IRET)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
Index: linux-2.6-lttng/include/asm-m68k/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68k/thread_info.h	2007-07-11 00:43:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68k/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -9,6 +9,7 @@
 	unsigned long		flags;
 	struct exec_domain	*exec_domain;	/* execution domain */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	__u32 cpu; /* should always be 0 on m68k */
 	struct restart_block    restart_block;
 };
@@ -59,5 +60,6 @@
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16
+#define TIF_NEED_MIGRATE	17	/* migration necessary */
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
Index: linux-2.6-lttng/include/asm-m68knommu/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68knommu/thread_info.h	2007-07-11 00:43:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68knommu/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -37,6 +37,7 @@
 	unsigned long	   flags;		/* low level flags */
 	int		   cpu;			/* cpu we're on */
 	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int		   migrate_count;	/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -88,6 +89,7 @@
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_NEED_MIGRATE	5	/* migration necessary */
 #define	TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 
 /* as above, but as bit values */
@@ -96,6 +98,7 @@
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
Index: linux-2.6-lttng/include/asm-mips/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-mips/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-mips/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -28,6 +28,7 @@
 	unsigned long		tp_value;	/* thread pointer */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space:
 						   0-0xBFFFFFFF for user-thead
@@ -49,6 +50,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
@@ -113,6 +115,7 @@
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
 #define TIF_SECCOMP		4	/* secure computing */
+#define TIF_NEED_MIGRATE	5	/* migration necessary */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
@@ -125,6 +128,7 @@
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
Index: linux-2.6-lttng/include/asm-parisc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-parisc/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-parisc/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -13,6 +13,7 @@
 	mm_segment_t addr_limit;	/* user-level address space limit */
 	__u32 cpu;			/* current CPU */
 	int preempt_count;		/* 0=premptable, <0=BUG; will also serve as bh-counter */
+	int migrate_count;		/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 };
 
@@ -24,6 +25,7 @@
 	.cpu		= 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
   	.restart_block	= {			\
 		.fn = do_no_restart_syscall	\
 	}					\
@@ -62,6 +64,7 @@
 #define TIF_32BIT               4       /* 32 bit binary */
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
+#define TIF_NEED_MIGRATE	7	/* migration necessary */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -69,6 +72,7 @@
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 
 #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
                                  _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
Index: linux-2.6-lttng/include/asm-powerpc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -35,6 +35,7 @@
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
+	int		migrate_count;	/* 0: can migrate, <0 => BUG */
 	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
@@ -53,6 +54,7 @@
 	.exec_domain =	&default_exec_domain,	\
 	.cpu =		0,			\
 	.preempt_count = 1,			\
+	.migrate_count = 0,			\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
@@ -124,6 +126,7 @@
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
 #define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
+#define TIF_NEED_MIGRATE	17	/* migration necessary */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -142,6 +145,7 @@
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	( _TIF_SIGPENDING | \
Index: linux-2.6-lttng/include/asm-s390/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-s390/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-s390/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -51,6 +51,7 @@
 	unsigned long		flags;		/* low level flags */
 	unsigned int		cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block	restart_block;
 };
 
@@ -64,6 +65,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
@@ -96,6 +98,7 @@
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SINGLE_STEP		6	/* deliver sigtrap on return to user */
 #define TIF_MCCK_PENDING	7	/* machine check handling is pending */
+#define TIF_NEED_MIGRATE	8	/* migration necessary */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
 					   TIF_NEED_RESCHED */
@@ -110,6 +113,7 @@
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
Index: linux-2.6-lttng/include/asm-sh/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh/thread_info.h	2007-07-11 00:43:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -21,6 +21,7 @@
 	unsigned long		flags;		/* low level flags */
 	__u32			cpu;
 	int			preempt_count; /* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block	restart_block;
 	unsigned long		previous_sp;	/* sp of previous stack in case
@@ -58,6 +59,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
@@ -112,6 +114,7 @@
 #define TIF_RESTORE_SIGMASK	3	/* restore signal mask in do_signal() */
 #define TIF_SINGLESTEP		4	/* singlestepping active */
 #define	TIF_SYSCALL_AUDIT	6	/* syscall audit active */
+#define TIF_NEED_MIGRATE	7	/* migration necessary */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
@@ -123,6 +126,7 @@
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
Index: linux-2.6-lttng/include/asm-sh64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh64/thread_info.h	2007-07-11 00:43:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh64/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -23,6 +23,7 @@
 	unsigned long		flags;		/* low level flags */
 	/* Put the 4 32-bit fields together to make asm offsetting easier. */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	__u16			cpu;
 
 	mm_segment_t		addr_limit;
@@ -41,6 +42,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit     = KERNEL_DS,            \
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
@@ -80,12 +82,14 @@
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_MEMDIE		4
 #define TIF_RESTORE_SIGMASK	5	/* Restore signal mask in do_signal */
+#define TIF_NEED_MIGRATE	6	/* migration necessary */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6-lttng/include/asm-sparc/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc/thread_info.h	2007-07-11 00:43:01.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -33,6 +33,7 @@
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	int			softirq_count;
 	int			hardirq_count;
 
@@ -65,6 +66,7 @@
 	.flags		=	0,			\
 	.cpu		=	0,			\
 	.preempt_count	=	1,			\
+	.migrate_count =	0,			\
 	.restart_block	= {				\
 		.fn	=	do_no_restart_syscall,	\
 	},						\
@@ -132,6 +134,7 @@
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
+#define TIF_NEED_MIGRATE	5	/* migration necessary */
 #define TIF_USEDFPU		8	/* FPU was used by this task
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
@@ -144,6 +147,7 @@
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
Index: linux-2.6-lttng/include/asm-sparc64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc64/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc64/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -47,6 +47,7 @@
 	struct pt_regs		*kregs;
 	struct exec_domain	*exec_domain;
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	__u8			new_child;
 	__u8			syscall_noerror;
 	__u16			cpu;
@@ -137,6 +138,7 @@
 	.flags		= ((unsigned long)ASI_P) << TI_FLAG_CURRENT_DS_SHIFT,	\
 	.exec_domain	=	&default_exec_domain,	\
 	.preempt_count	=	1,			\
+	.migrate_count =	0,			\
 	.restart_block	= {				\
 		.fn	=	do_no_restart_syscall,	\
 	},						\
@@ -225,7 +227,7 @@
 #define TIF_UNALIGNED		5	/* allowed to do unaligned accesses */
 #define TIF_NEWSIGNALS		6	/* wants new-style signals */
 #define TIF_32BIT		7	/* 32-bit binary */
-/* flag bit 8 is available */
+#define TIF_NEED_MIGRATE	8	/* migration necessary */
 #define TIF_SECCOMP		9	/* secure computing */
 #define TIF_SYSCALL_AUDIT	10	/* syscall auditing active */
 /* flag bit 11 is available */
@@ -244,6 +246,7 @@
 #define _TIF_UNALIGNED		(1<<TIF_UNALIGNED)
 #define _TIF_NEWSIGNALS		(1<<TIF_NEWSIGNALS)
 #define _TIF_32BIT		(1<<TIF_32BIT)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
Index: linux-2.6-lttng/include/asm-um/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-um/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-um/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -18,6 +18,7 @@
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;  /* 0 => preemptable,
 						   <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user
 						   0-0xFFFFFFFF for kernel */
@@ -32,6 +33,7 @@
 	.flags =		0,		\
 	.cpu =		0,			\
 	.preempt_count =	1,		\
+	.migrate_count =	0,		\
 	.addr_limit =	KERNEL_DS,		\
 	.restart_block =  {			\
 		.fn =  do_no_restart_syscall,	\
@@ -82,6 +84,7 @@
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_NEED_MIGRATE	8	/* migration necessary */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -90,5 +93,6 @@
 #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_NEED_MIGRATE	(1 << TIF_NEED_MIGRATE)
 
 #endif
Index: linux-2.6-lttng/include/asm-v850/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-v850/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-v850/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -32,6 +32,7 @@
 	int			cpu;		/* cpu we're on */
 	int			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 	struct restart_block	restart_block;
 };
 
@@ -42,6 +43,7 @@
 	.flags =	0,						      \
 	.cpu =		0,						      \
 	.preempt_count = 1,						      \
+	.migrate_count = 0,						      \
 	.restart_block = {						      \
 		.fn = do_no_restart_syscall,				      \
 	},								      \
@@ -82,12 +84,14 @@
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		4
+#define TIF_NEED_MIGRATE	5	/* migration necessary */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 
 
 /* Size of kernel stack for each process.  */
Index: linux-2.6-lttng/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -30,6 +30,7 @@
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
+	int			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	
 	struct restart_block    restart_block;
@@ -48,6 +49,7 @@
 	.flags	       = 0,			\
 	.cpu	       = 0,			\
 	.preempt_count = 1,			\
+	.migrate_count = 0,			\
 	.addr_limit     = KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
@@ -115,6 +117,7 @@
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_NEED_MIGRATE	11	/* migration necessary */
 /* 16 free */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
@@ -133,6 +136,7 @@
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_IA32		(1<<TIF_IA32)
 #define _TIF_FORK		(1<<TIF_FORK)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
Index: linux-2.6-lttng/include/asm-xtensa/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-xtensa/thread_info.h	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/include/asm-xtensa/thread_info.h	2007-07-11 00:43:03.000000000 -0400
@@ -34,6 +34,7 @@
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	__s32			preempt_count;	/* 0 => preemptable,< 0 => BUG*/
+	__s32			migrate_count;/* 0: can migrate, <0 => BUG */
 
 	mm_segment_t		addr_limit;	/* thread address space */
 	struct restart_block    restart_block;
@@ -72,6 +73,7 @@
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.preempt_count	= 1,			\
+	.migrate_count = 0,			\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
@@ -116,6 +118,7 @@
 #define TIF_IRET		4	/* return with iret */
 #define TIF_MEMDIE		5
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
+#define TIF_NEED_MIGRATE	7	/* migration necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -123,6 +126,7 @@
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_IRET		(1<<TIF_IRET)
+#define _TIF_NEED_MIGRATE	(1<<TIF_NEED_MIGRATE)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 
Index: linux-2.6-lttng/lib/smp_processor_id.c
===================================================================
--- linux-2.6-lttng.orig/lib/smp_processor_id.c	2007-07-10 02:29:10.000000000 -0400
+++ linux-2.6-lttng/lib/smp_processor_id.c	2007-07-11 00:43:03.000000000 -0400
@@ -10,12 +10,16 @@
 unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
+	unsigned long migrate_count = migrate_count();
 	int this_cpu = raw_smp_processor_id();
 	cpumask_t this_mask;
 
 	if (likely(preempt_count))
 		goto out;
 
+	if (likely(migrate_count))
+		goto out;
+
 	if (irqs_disabled())
 		goto out;
 
@@ -42,7 +46,7 @@
 	if (!printk_ratelimit())
 		goto out_enable;
 
-	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] code: %s/%d\n", preempt_count(), current->comm, current->pid);
+	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] migration [%08x] code: %s/%d\n", preempt_count(), migrate_count(), current->comm, current->pid);
 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
