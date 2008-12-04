Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYLDXr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYLDXr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYLDXqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:46:25 -0500
Received: from www.tglx.de ([62.245.132.106]:38355 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYLDXqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:46:16 -0500
Message-Id: <20081204230228.470613892@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 04 Dec 2008 23:44:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>
Subject: [patch 1/3] performance counters: core code
References: <20081204225345.654705757@linutronix.de>
Content-Disposition: inline; filename=perf-counters-core.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the core kernel bits of Performance Counters subsystem.

The Linux Performance Counter subsystem provides an abstraction of
performance counter hardware capabilities. It provides per task and per
CPU counters, and it provides event capabilities on top of those.

Performance counters are accessed via special file descriptors.
There's one file descriptor per virtual counter used.

The special file descriptor is opened via the perf_counter_open()
system call:

 int
 perf_counter_open(u32 hw_event_type,
                   u32 hw_event_period,
                   u32 record_type,
                   pid_t pid,
                   int cpu);

The syscall returns the new fd. The fd can be used via the normal
VFS system calls: read() can be used to read the counter, fcntl()
can be used to set the blocking mode, etc.

Multiple counters can be kept open at a time, and the counters
can be poll()ed.

See more details in Documentation/perf-counters.txt.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_counter.h |  152 +++++++
 include/linux/sched.h        |    9 
 include/linux/syscalls.h     |    6 
 init/Kconfig                 |   29 +
 kernel/Makefile              |    1 
 kernel/fork.c                |    1 
 kernel/perf_counter.c        |  918 +++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c               |   23 +
 kernel/sys_ni.c              |    3 
 9 files changed, 1142 insertions(+)

Index: linux/include/linux/perf_counter.h
===================================================================
--- /dev/null
+++ linux/include/linux/perf_counter.h
@@ -0,0 +1,152 @@
+/*
+ *  Performance counters:
+ *
+ *   Copyright(C) 2008, Thomas Gleixner <tglx@linutronix.de>
+ *   Copyright(C) 2008, Red Hat, Inc., Ingo Molnar
+ *
+ *  Data type definitions, declarations, prototypes.
+ *
+ *  Started by: Thomas Gleixner and Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+#ifndef _LINUX_PERF_COUNTER_H
+#define _LINUX_PERF_COUNTER_H
+
+#include <asm/atomic.h>
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rculist.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+struct task_struct;
+
+/*
+ * Generalized hardware event types, used by the hw_event_type parameter
+ * of the sys_perf_counter_open() syscall:
+ */
+enum hw_event_types {
+	PERF_COUNT_CYCLES,
+	PERF_COUNT_INSTRUCTIONS,
+	PERF_COUNT_CACHE_REFERENCES,
+	PERF_COUNT_CACHE_MISSES,
+	PERF_COUNT_BRANCH_INSTRUCTIONS,
+	PERF_COUNT_BRANCH_MISSES,
+};
+
+/*
+ * IRQ-notification data record type:
+ */
+enum perf_record_type {
+	PERF_RECORD_SIMPLE,
+	PERF_RECORD_IRQ,
+};
+
+/**
+ * struct hw_perf_counter - performance counter hardware details
+ */
+struct hw_perf_counter {
+	u64			config;
+	unsigned long		config_base;
+	unsigned long		counter_base;
+	unsigned int		idx;
+	u64			prev_count;
+	s32			next_count;
+	u64			irq_period;
+};
+
+/*
+ * Hardcoded buffer length limit for now, for IRQ-fed events:
+ */
+#define PERF_DATA_BUFLEN	512
+
+/**
+ * struct perf_data - performance counter IRQ data sampling ...
+ */
+struct perf_data {
+	int			len;
+	int			rd_idx;
+	int			overrun;
+	u8			data[PERF_DATA_BUFLEN];
+};
+
+/**
+ * struct perf_counter - performance counter kernel representation:
+ */
+struct perf_counter {
+	struct list_head		list;
+	int				active;
+#if BITS_PER_LONG == 64
+	atomic64_t			count;
+#else
+	atomic_t			count32[2];
+#endif
+	u64				__irq_period;
+
+	struct hw_perf_counter		hw;
+
+	struct perf_counter_context	*ctx;
+	struct task_struct		*task;
+
+	/*
+	 * Protect attach/detach:
+	 */
+	struct mutex			mutex;
+	struct rcu_head			rcu;
+
+	int				oncpu;
+	int				cpu;
+
+	s32				hw_event_type;
+	enum perf_record_type		record_type;
+
+	/* read() / irq related data */
+	wait_queue_head_t		waitq;
+	struct perf_data		*irqdata;
+	struct perf_data		*usrdata;
+	struct perf_data		data[2];
+};
+
+/**
+ * struct perf_counter_context - counter context structure
+ *
+ * Used as a container for task counters and CPU counters as well:
+ */
+struct perf_counter_context {
+#ifdef CONFIG_PERF_COUNTERS
+	/*
+	 * Protect the list of counters:
+	 */
+	spinlock_t		lock;
+	struct list_head	counters;
+	int			nr_counters;
+	int			nr_active;
+	struct task_struct	*task;
+#endif
+};
+
+/**
+ * struct perf_counter_cpu_context - per cpu counter context structure
+ */
+struct perf_cpu_context {
+	struct perf_counter_context	ctx;
+	struct perf_counter_context	*task_ctx;
+	int				active_oncpu;
+	int				max_pertask;
+};
+
+#ifdef CONFIG_PERF_COUNTERS
+extern void perf_counter_task_sched_in(struct task_struct *task, int cpu);
+extern void perf_counter_task_sched_out(struct task_struct *task, int cpu);
+extern void perf_counter_init_task(struct task_struct *task);
+#else
+static inline void
+perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
+static inline void
+perf_counter_task_sched_out(struct task_struct *task, int cpu)		{ }
+static inline void perf_counter_init_task(struct task_struct *task)	{ }
+#endif
+
+#endif /* _LINUX_PERF_COUNTER_H */
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -71,6 +71,7 @@ struct sched_param {
 #include <linux/fs_struct.h>
 #include <linux/compiler.h>
 #include <linux/completion.h>
+#include <linux/perf_counter.h>
 #include <linux/pid.h>
 #include <linux/percpu.h>
 #include <linux/topology.h>
@@ -1326,6 +1327,7 @@ struct task_struct {
 	struct list_head pi_state_list;
 	struct futex_pi_state *pi_state_cache;
 #endif
+	struct perf_counter_context perf_counter_ctx;
 #ifdef CONFIG_NUMA
 	struct mempolicy *mempolicy;
 	short il_next;
@@ -2285,6 +2287,13 @@ static inline void inc_syscw(struct task
 #define TASK_SIZE_OF(tsk)	TASK_SIZE
 #endif
 
+/*
+ * Call the function if the target task is executing on a CPU right now:
+ */
+extern void task_oncpu_function_call(struct task_struct *p,
+				     void (*func) (void *info), void *info);
+
+
 #ifdef CONFIG_MM_OWNER
 extern void mm_update_next_owner(struct mm_struct *mm);
 extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
Index: linux/include/linux/syscalls.h
===================================================================
--- linux.orig/include/linux/syscalls.h
+++ linux/include/linux/syscalls.h
@@ -624,4 +624,10 @@ asmlinkage long sys_fallocate(int fd, in
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
+asmlinkage int
+sys_perf_counter_open(u32 hw_event_type,
+		      u32 hw_event_period,
+		      u32 record_type,
+		      pid_t pid,
+		      int cpu);
 #endif
Index: linux/init/Kconfig
===================================================================
--- linux.orig/init/Kconfig
+++ linux/init/Kconfig
@@ -732,6 +732,35 @@ config AIO
           by some high performance threaded applications. Disabling
           this option saves about 7k.
 
+config HAVE_PERF_COUNTERS
+	bool
+
+menu "Performance Counters"
+
+config PERF_COUNTERS
+	bool "Kernel Performance Counters"
+	depends on HAVE_PERF_COUNTERS
+	default y
+	help
+	  Enable kernel support for performance counter hardware.
+
+	  Performance counters are special hardware registers available
+	  on most modern CPUs. These registers count the number of certain
+	  types of hw events: such as instructions executed, cachemisses
+	  suffered, or branches mis-predicted - without slowing down the
+	  kernel or applications. These registers can also trigger interrupts
+	  when a threshold number of events have passed - and can thus be
+	  used to profile the code that runs on that CPU.
+
+	  The Linux Performance Counter subsystem provides an abstraction of
+	  these hardware capabilities, available via a system call. It
+	  provides per task and per CPU counters, and it provides event
+	  capabilities on top of those.
+
+	  Say Y if unsure.
+
+endmenu
+
 config VM_EVENT_COUNTERS
 	default y
 	bool "Enable VM event counters for /proc/vmstat" if EMBEDDED
Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) 
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
+obj-$(CONFIG_PERF_COUNTERS) += perf_counter.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
Index: linux/kernel/fork.c
===================================================================
--- linux.orig/kernel/fork.c
+++ linux/kernel/fork.c
@@ -975,6 +975,7 @@ static struct task_struct *copy_process(
 		goto fork_out;
 
 	rt_mutex_init_task(p);
+	perf_counter_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
Index: linux/kernel/perf_counter.c
===================================================================
--- /dev/null
+++ linux/kernel/perf_counter.c
@@ -0,0 +1,918 @@
+/*
+ * Performance counter core code
+ *
+ *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
+ *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/fs.h>
+#include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/poll.h>
+#include <linux/sysfs.h>
+#include <linux/ptrace.h>
+#include <linux/percpu.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/anon_inodes.h>
+#include <linux/perf_counter.h>
+
+/*
+ * Each CPU has a list of per CPU counters:
+ */
+DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
+
+static int perf_max_counters __read_mostly = 2;
+static int perf_reserved_percpu __read_mostly;
+static int perf_overcommit __read_mostly = 1;
+
+/*
+ * Mutex for (sysadmin-configurable) counter reservations:
+ */
+static DEFINE_MUTEX(perf_resource_mutex);
+
+/*
+ * Architecture provided APIs - weak aliases:
+ */
+
+int __weak hw_perf_counter_init(struct perf_counter *counter, u32 hw_event_type)
+{
+	return -EINVAL;
+}
+
+void __weak hw_perf_counter_enable(struct perf_counter *counter)	 { }
+void __weak hw_perf_counter_disable(struct perf_counter *counter)	 { }
+void __weak hw_perf_counter_read(struct perf_counter *counter)		 { }
+void __weak hw_perf_counter_enable_config(struct perf_counter *counter)	 { }
+void __weak hw_perf_counter_disable_config(struct perf_counter *counter) { }
+void __weak hw_perf_counter_setup(void) { }
+
+/*
+ * RCU callback to free a performance counter:
+ */
+static void perf_free_ctr_rcu(struct rcu_head *rhp)
+
+{
+	kfree(container_of(rhp, struct perf_counter, rcu));
+}
+
+#if BITS_PER_LONG == 64
+
+/*
+ * Read the cached counter in counter safe against cross CPU / NMI
+ * modifications. 64 bit version - no complications.
+ */
+static inline u64 perf_read_counter_safe(struct perf_counter *counter)
+{
+	return (u64) atomic64_read(&counter->count);
+}
+
+#else
+
+/*
+ * Read the cached counter in counter safe against cross CPU / NMI
+ * modifications. 32 bit version.
+ */
+static u64 perf_read_counter_safe(struct perf_counter *counter)
+{
+	u32 cntl, cnth;
+
+	local_irq_disable();
+	do {
+		cnth = atomic_read(&counter->count32[1]);
+		cntl = atomic_read(&counter->count32[0]);
+	} while (cnth != atomic_read(&counter->count32[1]));
+
+	local_irq_enable();
+
+	return cntl | ((u64) cnth) << 32;
+}
+
+#endif
+
+/*
+ * Cross CPU call to remove a performance counter
+ *
+ * We disable the counter on the hardware level first. After that we
+ * remove it from the context list.
+ */
+static void __perf_remove_from_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+
+	spin_lock(&cpuctx->ctx.lock);
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task) {
+		if (cpuctx->task_ctx != ctx)
+			goto out;
+		spin_lock(&ctx->lock);
+	}
+
+	if (counter->active) {
+		hw_perf_counter_disable_config(counter);
+		hw_perf_counter_disable(counter);
+		counter->active = 0;
+		ctx->nr_active--;
+		cpuctx->active_oncpu--;
+	}
+
+	ctx->nr_counters--;
+
+	list_del_rcu(&counter->list);
+
+	if (ctx->task) {
+		spin_unlock(&ctx->lock);
+	} else {
+		/*
+		 * Allow more per task counters with respect to the
+		 * reservation:
+		 */
+		cpuctx->max_pertask =
+			min(perf_max_counters - ctx->nr_counters,
+			    perf_max_counters - perf_reserved_percpu);
+	}
+out:
+	spin_unlock(&cpuctx->ctx.lock);
+}
+
+
+/*
+ * Remove the counter from a task's (or a CPU's) list of counters.
+ *
+ * Must be called with counter->mutex held.
+ *
+ * First we disable the counter enable bit in counter->hw_config. This
+ * ensures that a context switch on another CPU or a NMI on the local
+ * CPU does not enable the counter.
+ *
+ * CPU counters are removed with a smp call. For task counters we only
+ * call when the task is on a CPU.
+ */
+static void perf_remove_from_context(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct task_struct *task = ctx->task;
+
+	hw_perf_counter_disable_config(counter);
+
+	if (!task) {
+		/*
+		 * Per cpu counters are removed via an smp call and
+		 * the removal is always sucessful.
+		 */
+		smp_call_function_single(counter->cpu,
+					 __perf_remove_from_context,
+					 counter, 1);
+		return;
+	}
+
+retry:
+	task_oncpu_function_call(task, __perf_remove_from_context,
+				 counter);
+	/*
+	 * We might have failed to deactivate it due to
+	 * task migration:
+	 */
+	spin_lock_irq(&ctx->lock);
+
+	/* FIXME: No generic function for this */
+	if (counter->list.prev != LIST_POISON2) {
+		if (counter->active) {
+			spin_unlock_irq(&ctx->lock);
+			goto retry;
+		}
+		ctx->nr_counters--;
+		list_del_rcu(&counter->list);
+	}
+	spin_unlock_irq(&ctx->lock);
+
+	counter->task = NULL;
+}
+
+/*
+ * Cross CPU call to install and enable a preformance counter
+ */
+static void __perf_install_in_context(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	int cpu = smp_processor_id();
+
+	spin_lock(&cpuctx->ctx.lock);
+
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task) {
+		if (cpuctx->task_ctx != ctx)
+			goto out;
+		spin_lock(&ctx->lock);
+	}
+
+	if (cpuctx->active_oncpu < perf_max_counters) {
+		hw_perf_counter_enable_config(counter);
+		hw_perf_counter_enable(counter);
+		counter->active = 1;
+		counter->oncpu = cpu;
+		ctx->nr_active++;
+		cpuctx->active_oncpu++;
+	}
+
+	if (ctx->task) {
+		spin_unlock(&ctx->lock);
+	} else {
+		if (cpuctx->max_pertask)
+			cpuctx->max_pertask--;
+	}
+out:
+	spin_unlock(&cpuctx->ctx.lock);
+}
+
+/*
+ * Attach a performance counter to a context
+ *
+ * First we add the counter to the list with the hardware enable bit
+ * in counter->hw_config cleared.
+ *
+ * Now we enable the hardware enable bit in counter->hw_config and if
+ * the counter is attached to a task which is on a CPU we use a smp call
+ * to enable it in the task context. The task might have been scheduled
+ * away, but we check this in the smp call again.
+ */
+static void
+perf_install_in_context(struct perf_counter_context *ctx,
+			struct perf_counter *counter,
+			int cpu)
+{
+	struct task_struct *task = ctx->task;
+
+	if (task)
+		counter->task = task;
+
+	spin_lock_irq(&ctx->lock);
+	list_add_tail_rcu(&counter->list, &ctx->counters);
+	ctx->nr_counters++;
+	counter->ctx = ctx;
+	spin_unlock_irq(&ctx->lock);
+
+	hw_perf_counter_enable_config(counter);
+
+	if (task) {
+		task_oncpu_function_call(task, __perf_install_in_context,
+					 counter);
+	} else {
+		smp_call_function_single(cpu, __perf_install_in_context,
+					 counter, 1);
+	}
+}
+
+/*
+ * Called from scheduler to remove the counters of the current task,
+ * with interrupts disabled.
+ *
+ * We stop each counter and update the counter value in counter->count.
+ *
+ * We dont use the rcu list walk here as we are protected by the
+ * spinlock.
+ *
+ * This does not protect us against NMI, but hw_perf_counter_disable()
+ * sets the disabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * not restart the counter.
+ */
+void perf_counter_task_sched_out(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct perf_counter *counter;
+
+	if (likely(!cpuctx->task_ctx))
+		return;
+
+	spin_lock(&cpuctx->ctx.lock);
+	spin_lock(&ctx->lock);
+	list_for_each_entry(counter, &ctx->counters, list) {
+		if (!ctx->nr_active)
+			break;
+		if (counter->active) {
+			hw_perf_counter_disable(counter);
+			counter->active = 0;
+			counter->oncpu = -1;
+			ctx->nr_active--;
+			cpuctx->active_oncpu--;
+		}
+	}
+	cpuctx->task_ctx = NULL;
+	spin_unlock(&ctx->lock);
+	spin_unlock(&cpuctx->ctx.lock);
+}
+
+/*
+ * Called from scheduler to add the counters of the current task
+ * with interrupts disabled.
+ *
+ * We restore the counter value and then enable it.
+ *
+ * We dont use the rcu list walk here as we are protected by the
+ * spinlock.
+ *
+ * This does not protect us against NMI, but hw_perf_counter_enable()
+ * sets the enabled bit in the control field of counter _before_
+ * accessing the counter control register. If a NMI hits, then it will
+ * keep the counter running.
+ */
+void perf_counter_task_sched_in(struct task_struct *task, int cpu)
+{
+	struct perf_cpu_context *cpuctx = &per_cpu(perf_cpu_context, cpu);
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+	struct perf_counter *counter;
+
+	if (likely(!ctx->nr_counters))
+		return;
+
+	spin_lock(&cpuctx->ctx.lock);
+	spin_lock(&ctx->lock);
+	list_for_each_entry(counter, &ctx->counters, list) {
+		if (ctx->nr_active == cpuctx->max_pertask)
+			break;
+		if (counter->cpu != -1 && counter->cpu != cpu)
+			continue;
+		hw_perf_counter_enable(counter);
+		counter->active = 1;
+		counter->oncpu = cpu;
+		ctx->nr_active++;
+		cpuctx->active_oncpu++;
+	}
+	cpuctx->task_ctx = ctx;
+	spin_unlock(&ctx->lock);
+	spin_unlock(&cpuctx->ctx.lock);
+}
+
+/*
+ * Initialize the perf_counter context in task_struct
+ */
+void perf_counter_init_task(struct task_struct *task)
+{
+	struct perf_counter_context *ctx = &task->perf_counter_ctx;
+
+	spin_lock_init(&ctx->lock);
+	INIT_LIST_HEAD(&ctx->counters);
+	ctx->nr_counters = 0;
+	ctx->task = NULL;
+}
+
+/*
+ * Cross CPU call to read the hardware counter
+ */
+static void __hw_perf_counter_read(void *info)
+{
+	hw_perf_counter_read(info);
+}
+
+static u64 perf_read_counter(struct perf_counter *counter)
+{
+	/*
+	 * If counter is enabled and currently active on a CPU, update the
+	 * value in the counter structure:
+	 */
+	if (counter->active) {
+		smp_call_function_single(counter->oncpu,
+					 __hw_perf_counter_read, counter, 1);
+	}
+
+	return perf_read_counter_safe(counter);
+}
+
+/*
+ * Cross CPU call to switch performance data pointers
+ */
+static void __perf_switch_irq_data(void *info)
+{
+	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
+	struct perf_counter *counter = info;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+
+	spin_lock(&cpuctx->ctx.lock);
+	/*
+	 * If this is a task context, we need to check whether it is
+	 * the current task context of this cpu. If not it has been
+	 * scheduled out before the smp call arrived.
+	 */
+	if (ctx->task) {
+		if (cpuctx->task_ctx != ctx)
+			goto out;
+		spin_lock(&ctx->lock);
+	}
+
+	/* Change the pointer NMI safe */
+	atomic_long_set((atomic_long_t *)&counter->irqdata,
+			(unsigned long) counter->usrdata);
+	counter->usrdata = oldirqdata;
+
+	if (ctx->task)
+		spin_unlock(&ctx->lock);
+out:
+	spin_unlock(&cpuctx->ctx.lock);
+}
+
+static struct perf_data *perf_switch_irq_data(struct perf_counter *counter)
+{
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_data *oldirqdata = counter->irqdata;
+	struct task_struct *task = ctx->task;
+
+	if (!task) {
+		smp_call_function_single(counter->cpu,
+					 __perf_switch_irq_data,
+					 counter, 1);
+		return counter->usrdata;
+	}
+
+retry:
+	spin_lock_irq(&ctx->lock);
+	if (!counter->active) {
+		counter->irqdata = counter->usrdata;
+		counter->usrdata = oldirqdata;
+		spin_unlock_irq(&ctx->lock);
+		return oldirqdata;
+	}
+	spin_unlock_irq(&ctx->lock);
+	task_oncpu_function_call(task, __perf_switch_irq_data, counter);
+	/* Might have failed, because task was scheduled out */
+	if (counter->irqdata == oldirqdata)
+		goto retry;
+
+	return counter->usrdata;
+}
+
+static void put_context(struct perf_counter_context *ctx)
+{
+	if (ctx->task) {
+		put_task_struct(ctx->task);
+		ctx->task = NULL;
+	}
+}
+
+static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
+{
+	struct perf_cpu_context *cpuctx;
+	struct perf_counter_context *ctx;
+	struct task_struct *task;
+
+	/*
+	 * If cpu is not a wildcard then this is a percpu counter:
+	 */
+	if (cpu != -1) {
+		/* Must be root to operate on a CPU counter: */
+		if (!capable(CAP_SYS_ADMIN))
+			return ERR_PTR(-EACCES);
+
+		if (cpu < 0 || cpu > num_possible_cpus())
+			return ERR_PTR(-EINVAL);
+
+		/*
+		 * We could be clever and allow to attach a counter to an
+		 * offline CPU and activate it when the CPU comes up, but
+		 * that's for later.
+		 */
+		if (!cpu_isset(cpu, cpu_online_map))
+			return ERR_PTR(-ENODEV);
+
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		ctx = &cpuctx->ctx;
+
+		WARN_ON_ONCE(ctx->task);
+		return ctx;
+	}
+
+	rcu_read_lock();
+	if (!pid)
+		task = current;
+	else
+		task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	if (!task)
+		return ERR_PTR(-ESRCH);
+
+	ctx = &task->perf_counter_ctx;
+	ctx->task = task;
+
+	/* Reuse ptrace permission checks for now. */
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		put_context(ctx);
+		return ERR_PTR(-EACCES);
+	}
+
+	return ctx;
+}
+
+/*
+ * Called when the last reference to the file is gone.
+ */
+static int perf_release(struct inode *inode, struct file *file)
+{
+	struct perf_counter *counter = file->private_data;
+	struct perf_counter_context *ctx = counter->ctx;
+
+	file->private_data = NULL;
+
+	mutex_lock(&counter->mutex);
+
+	perf_remove_from_context(counter);
+	put_context(ctx);
+
+	mutex_unlock(&counter->mutex);
+
+	call_rcu(&counter->rcu, perf_free_ctr_rcu);
+
+	return 0;
+}
+
+/*
+ * Read the performance counter - simple non blocking version for now
+ */
+static ssize_t
+perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
+{
+	u64 cntval;
+
+	if (count != sizeof(cntval))
+		return -EINVAL;
+
+	mutex_lock(&counter->mutex);
+	cntval = perf_read_counter(counter);
+	mutex_unlock(&counter->mutex);
+
+	return put_user(cntval, (u64 __user *) buf) ? -EFAULT : sizeof(cntval);
+}
+
+static ssize_t
+perf_copy_usrdata(struct perf_data *usrdata, char __user *buf, size_t count)
+{
+	if (!usrdata->len)
+		return 0;
+
+	count = min(count, (size_t)usrdata->len);
+	if (copy_to_user(buf, usrdata->data + usrdata->rd_idx, count))
+		return -EFAULT;
+
+	/* Adjust the counters */
+	usrdata->len -= count;
+	if (!usrdata->len)
+		usrdata->rd_idx = 0;
+	else
+		usrdata->rd_idx += count;
+
+	return count;
+}
+
+static ssize_t
+perf_read_irq_data(struct perf_counter	*counter,
+		   char __user		*buf,
+		   size_t		count,
+		   int			nonblocking)
+{
+	struct perf_data *irqdata, *usrdata;
+	DECLARE_WAITQUEUE(wait, current);
+	ssize_t res;
+
+	irqdata = counter->irqdata;
+	usrdata = counter->usrdata;
+
+	if (usrdata->len + irqdata->len >= count)
+		goto read_pending;
+
+	if (nonblocking)
+		return -EAGAIN;
+
+	spin_lock_irq(&counter->waitq.lock);
+	__add_wait_queue(&counter->waitq, &wait);
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (usrdata->len + irqdata->len >= count)
+			break;
+
+		if (signal_pending(current))
+			break;
+
+		spin_unlock_irq(&counter->waitq.lock);
+		schedule();
+		spin_lock_irq(&counter->waitq.lock);
+	}
+	__remove_wait_queue(&counter->waitq, &wait);
+	__set_current_state(TASK_RUNNING);
+	spin_unlock_irq(&counter->waitq.lock);
+
+	if (usrdata->len + irqdata->len < count)
+		return -ERESTARTSYS;
+read_pending:
+	mutex_lock(&counter->mutex);
+
+	/* Drain pending data first: */
+	res = perf_copy_usrdata(usrdata, buf, count);
+	if (res < 0 || res == count)
+		goto out;
+
+	/* Switch irq buffer: */
+	usrdata = perf_switch_irq_data(counter);
+	if (perf_copy_usrdata(usrdata, buf + res, count - res) < 0) {
+		if (!res)
+			res = -EFAULT;
+	} else {
+		res = count;
+	}
+out:
+	mutex_unlock(&counter->mutex);
+
+	return res;
+}
+
+static ssize_t
+perf_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct perf_counter *counter = file->private_data;
+
+	switch (counter->record_type) {
+	case PERF_RECORD_SIMPLE:
+		return perf_read_hw(counter, buf, count);
+
+	case PERF_RECORD_IRQ:
+		return perf_read_irq_data(counter, buf, count,
+					  file->f_flags & O_NONBLOCK);
+	}
+	return -EINVAL;
+}
+
+static unsigned int perf_poll(struct file *file, poll_table *wait)
+{
+	struct perf_counter *counter = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &counter->waitq, wait);
+
+	spin_lock_irqsave(&counter->waitq.lock, flags);
+	if (counter->usrdata->len || counter->irqdata->len)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&counter->waitq.lock, flags);
+
+	return events;
+}
+
+static const struct file_operations perf_fops = {
+	.release		= perf_release,
+	.read			= perf_read,
+	.poll			= perf_poll,
+};
+
+/*
+ * Allocate and initialize a counter structure
+ */
+static struct perf_counter *
+perf_counter_alloc(u32 hw_event_period, int cpu, u32 record_type)
+{
+	struct perf_counter *counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+
+	if (!counter)
+		return NULL;
+
+	mutex_init(&counter->mutex);
+	INIT_LIST_HEAD(&counter->list);
+	init_waitqueue_head(&counter->waitq);
+
+	counter->irqdata	= &counter->data[0];
+	counter->usrdata	= &counter->data[1];
+	counter->cpu		= cpu;
+	counter->record_type	= record_type;
+	counter->__irq_period	= hw_event_period;
+
+	return counter;
+}
+
+/**
+ * sys_perf_task_open - open a performance counter associate it to a task
+ * @hw_event_type:	event type for monitoring/sampling...
+ * @pid:		target pid
+ */
+asmlinkage int
+sys_perf_counter_open(u32 hw_event_type,
+		      u32 hw_event_period,
+		      u32 record_type,
+		      pid_t pid,
+		      int cpu)
+{
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+	int ret;
+
+	ctx = find_get_context(pid, cpu);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	ret = -ENOMEM;
+	counter = perf_counter_alloc(hw_event_period, cpu, record_type);
+	if (!counter)
+		goto err_put_context;
+
+	ret = hw_perf_counter_init(counter, hw_event_type);
+	if (ret)
+		goto err_free_put_context;
+
+	perf_install_in_context(ctx, counter, cpu);
+
+	ret = anon_inode_getfd("[perf_counter]", &perf_fops, counter, 0);
+	if (ret < 0)
+		goto err_remove_free_put_context;
+
+	return ret;
+
+err_remove_free_put_context:
+	mutex_lock(&counter->mutex);
+	perf_remove_from_context(counter);
+	mutex_unlock(&counter->mutex);
+
+err_free_put_context:
+	call_rcu(&counter->rcu, perf_free_ctr_rcu);
+
+err_put_context:
+	put_context(ctx);
+
+	return ret;
+}
+
+static void __cpuinit perf_init_cpu(int cpu)
+{
+	struct perf_cpu_context *ctx;
+
+	ctx = &per_cpu(perf_cpu_context, cpu);
+	spin_lock_init(&ctx->ctx.lock);
+	INIT_LIST_HEAD(&ctx->ctx.counters);
+
+	mutex_lock(&perf_resource_mutex);
+	ctx->max_pertask = perf_max_counters - perf_reserved_percpu;
+	mutex_unlock(&perf_resource_mutex);
+	hw_perf_counter_setup();
+}
+
+static void perf_exit_cpu(int cpu)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+
+	ctx = &per_cpu(perf_cpu_context, cpu).ctx;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(counter, &ctx->counters, list) {
+		mutex_lock(&counter->mutex);
+		perf_remove_from_context(counter);
+		mutex_unlock(&counter->mutex);
+	}
+	rcu_read_unlock();
+#endif
+}
+
+static int __cpuinit
+perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action) {
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		perf_init_cpu(cpu);
+		break;
+
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		perf_exit_cpu(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata perf_cpu_nb = {
+	.notifier_call		= perf_cpu_notify,
+};
+
+static int __init perf_counter_init(void)
+{
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
+			(void *)(long)smp_processor_id());
+	register_cpu_notifier(&perf_cpu_nb);
+
+	return 0;
+}
+early_initcall(perf_counter_init);
+
+static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_reserved_percpu);
+}
+
+static ssize_t
+perf_set_reserve_percpu(struct sysdev_class *class,
+			const char *buf,
+			size_t count)
+{
+	struct perf_cpu_context *cpuctx;
+	unsigned long val;
+	int err, cpu, mpt;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > perf_max_counters)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_reserved_percpu = val;
+	for_each_online_cpu(cpu) {
+		cpuctx = &per_cpu(perf_cpu_context, cpu);
+		spin_lock_irq(&cpuctx->ctx.lock);
+		mpt = min(perf_max_counters - cpuctx->ctx.nr_counters,
+			  perf_max_counters - perf_reserved_percpu);
+		cpuctx->max_pertask = mpt;
+		spin_unlock_irq(&cpuctx->ctx.lock);
+	}
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static ssize_t perf_show_overcommit(struct sysdev_class *class, char *buf)
+{
+	return sprintf(buf, "%d\n", perf_overcommit);
+}
+
+static ssize_t
+perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
+{
+	unsigned long val;
+	int err;
+
+	err = strict_strtoul(buf, 10, &val);
+	if (err)
+		return err;
+	if (val > 1)
+		return -EINVAL;
+
+	mutex_lock(&perf_resource_mutex);
+	perf_overcommit = val;
+	mutex_unlock(&perf_resource_mutex);
+
+	return count;
+}
+
+static SYSDEV_CLASS_ATTR(
+				reserve_percpu,
+				0644,
+				perf_show_reserve_percpu,
+				perf_set_reserve_percpu
+			);
+
+static SYSDEV_CLASS_ATTR(
+				overcommit,
+				0644,
+				perf_show_overcommit,
+				perf_set_overcommit
+			);
+
+static struct attribute *perfclass_attrs[] = {
+	&attr_reserve_percpu.attr,
+	&attr_overcommit.attr,
+	NULL
+};
+
+static struct attribute_group perfclass_attr_group = {
+	.attrs			= perfclass_attrs,
+	.name			= "perf_counters",
+};
+
+static int __init perf_counter_sysfs_init(void)
+{
+	return sysfs_create_group(&cpu_sysdev_class.kset.kobj,
+				  &perfclass_attr_group);
+}
+device_initcall(perf_counter_sysfs_init);
+
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -2212,6 +2212,27 @@ static int sched_balance_self(int cpu, i
 
 #endif /* CONFIG_SMP */
 
+/**
+ * task_oncpu_function_call - call a function on the cpu on which a task runs
+ * @p:		the task to evaluate
+ * @func:	the function to be called
+ * @info:	the function call argument
+ *
+ * Calls the function @func when the task is currently running. This might
+ * be on the current CPU, which just calls the function directly
+ */
+void task_oncpu_function_call(struct task_struct *p,
+			      void (*func) (void *info), void *info)
+{
+	int cpu;
+
+	preempt_disable();
+	cpu = task_cpu(p);
+	if (task_curr(p))
+		smp_call_function_single(cpu, func, info, 1);
+	preempt_enable();
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2534,6 +2555,7 @@ prepare_task_switch(struct rq *rq, struc
 		    struct task_struct *next)
 {
 	fire_sched_out_preempt_notifiers(prev, next);
+	perf_counter_task_sched_out(prev, cpu_of(rq));
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2574,6 +2596,7 @@ static void finish_task_switch(struct rq
 	 */
 	prev_state = prev->state;
 	finish_arch_switch(prev);
+	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
 #ifdef CONFIG_SMP
 	if (current->sched_class->post_schedule)
Index: linux/kernel/sys_ni.c
===================================================================
--- linux.orig/kernel/sys_ni.c
+++ linux/kernel/sys_ni.c
@@ -174,3 +174,6 @@ cond_syscall(compat_sys_timerfd_settime)
 cond_syscall(compat_sys_timerfd_gettime);
 cond_syscall(sys_eventfd);
 cond_syscall(sys_eventfd2);
+
+/* performance counters: */
+cond_syscall(sys_perf_counter_open);


