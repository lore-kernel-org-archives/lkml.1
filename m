Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbYJLNN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbYJLNN4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYJLNMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:12:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:46654 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYJLNMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=U3ZS0BUPfpJ76kLcCeazzr5M6m8ulC2/NMZkWeHQyAWw88Bu9xfHaVtwbAGcP3tFyl
         Xf/MgHyD3OWXXKCAMpSAFL0IiLaPLeoW6+f3a8rArmRfBO4aLxkk5k6NBxUP4rTtS0W+
         im1UexmUA4F+iQRiIr13M98bxZHpm5q/cjvgI=
From: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: mingo@elte.hu, srostedt@redhat.com
Cc: a.p.zijlstra@chello.nl, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
Subject: [PATCH 4/4] Implement semaphore latency tracer
Date: Sun, 12 Oct 2008 16:12:04 +0300
Message-Id: <1223817124-27239-6-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time a down_read or down_write fails, a unique latency id is generated.
Later when someone releases the semaphore, it is blamed for the latency of all
tasks on the wait_list of the semaphore.
If you would group the output from latency_trace by the latency_id you get all those
who were contending on a lock, and the tasks that were holding the lock.
An entry in latency_trace has the format:
(latency_id) [semaphore_id] read|write
stacktrace <= stacktrace

Signed-off-by: Török Edwin <edwintorok@gmail.com>
---
 kernel/trace/Kconfig        |   12 +++
 kernel/trace/Makefile       |    1 +
 kernel/trace/trace.c        |  105 +++++++++++++++++++++----
 kernel/trace/trace.h        |   32 ++++++++
 kernel/trace/trace_semlat.c |  186 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 321 insertions(+), 15 deletions(-)
 create mode 100644 kernel/trace/trace_semlat.c

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 396aea1..8faac14 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -144,6 +144,18 @@ config STACK_TRACER
 	  This tracer records the max stack of the kernel, and displays
 	  it in debugfs/tracing/stack_trace
 
+config SEMLAT_TRACER
+	bool "Semaphore latency tracer"
+	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
+	select TRACING
+	select TRACEPOINTS
+	select TRACER_MAX_TRACE
+	help
+	  This tracer records the reason for semaphore contention, showing
+	  who is holding a lock for too long and causing other tasks to contend
+	  on the semaphore. Currently it instruments rwsem and rwsem-spinlock with tracepoints.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index a85dfba..d037df3 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_SEMLAT_TRACER) += trace_semlat.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 722ab74..bd9145a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -752,26 +752,42 @@ void __trace_stack(struct trace_array *tr,
 	ftrace_trace_stack(tr, data, flags, skip, preempt_count());
 }
 
-static void __trace_userstack(struct trace_array *tr,
+static void ftrace_trace_userstack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
-		   unsigned long flags)
+		   unsigned long flags, int pc)
 {
-	struct trace_entry *entry;
+	struct userstack_entry *entry;
 	struct stack_trace trace;
+	struct ring_buffer_event *event;
+	unsigned long irq_flags;
 
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
-	entry			= tracing_get_trace_entry(tr, data);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_USER_STACK;
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
+	entry->ent.type		= TRACE_USER_STACK;
+
+	memset(&entry->caller, 0, sizeof(entry->caller));
 
-	memset(&entry->field.stack, 0, sizeof(entry->field.stack));
 	trace.nr_entries	= 0;
 	trace.max_entries	= FTRACE_STACK_ENTRIES;
 	trace.skip		= 0;
-	trace.entries		= entry->field.stack.caller;
+	trace.entries		= entry->caller;
+
 	save_stack_trace_user(&trace);
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+}
+
+void __trace_userstack(struct trace_array *tr,
+		   struct trace_array_cpu *data,
+		   unsigned long flags)
+{
+	ftrace_trace_userstack(tr, data, flags, preempt_count());
 }
 
 static void
@@ -810,6 +826,36 @@ __trace_special(void *__tr, void *__data,
 }
 
 void
+trace_semlat(struct trace_array *tr, struct trace_array_cpu *data,
+		const struct semlat_data *sdata, int samestack)
+{
+	struct ring_buffer_event *event;
+	struct semlat_entry *entry;
+	unsigned long irq_flags;
+	int pc = preempt_count();
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, pc);
+	entry->ent.type			= TRACE_SEM;
+	entry->data 			= *sdata;
+	entry->data.pid			= current->pid;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	if (!samestack) {
+		/* show a stack trace only if different from  previous */
+		__trace_stack(tr, data, irq_flags, 3);
+		__trace_userstack(tr, data, irq_flags);
+	}
+	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
+	__trace_userstack(tr, data, irq_flags);
+
+	trace_wake_up();
+}
+
+void
 tracing_sched_switch_trace(struct trace_array *tr,
 			   struct trace_array_cpu *data,
 			   struct task_struct *prev,
@@ -1192,7 +1238,7 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 }
 
 static int
-seq_print_userip_objs(const struct trace_entry *entry, struct trace_seq *s,
+seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
 		unsigned long sym_flags)
 {
 	struct mm_struct *mm = NULL;
@@ -1204,7 +1250,7 @@ seq_print_userip_objs(const struct trace_entry *entry, struct trace_seq *s,
 		/* we do the lookup on the thread group leader,
 		 * since individual threads might have already quit! */
 		rcu_read_lock();
-		task = find_task_by_vpid(entry->field.tgid);
+		task = find_task_by_vpid(entry->ent.tgid);
 		rcu_read_unlock();
 
 		if (task)
@@ -1212,7 +1258,7 @@ seq_print_userip_objs(const struct trace_entry *entry, struct trace_seq *s,
 	}
 
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		unsigned long ip = entry->field.stack.caller[i];
+		unsigned long ip = entry->caller[i];
 		unsigned long vmstart = 0;
 		struct file *file = NULL;
 
@@ -1532,10 +1578,34 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
-	case TRACE_USER_STACK:
-		seq_print_userip_objs(entry, s, sym_flags);
+	case TRACE_USER_STACK: {
+		struct userstack_entry *field;
+
+		trace_assign_type(field, entry);
+
+		seq_print_userip_objs(field, s, sym_flags);
 		trace_seq_putc(s, '\n');
 		break;
+	}
+	case TRACE_SEM: {
+		struct semlat_entry *field;
+
+		trace_assign_type(field, entry);
+
+		if (field->data.pid == field->ent.pid) {
+			/* task that suffered the latency */
+			comm = trace_find_cmdline(field->data.pid);
+			trace_seq_printf(s, " (%u) %s["IP_FMT"] %s %s\n",
+				field->data.latency_id,
+				field->data.name ? field->data.name : "",
+				field->data.semaphore,
+				field->data.kind_read ? "read" : "write",
+				comm);
+		} else
+			trace_seq_printf(s, " (%u)\n",
+					 field->data.latency_id);
+		break;
+	}
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1671,8 +1741,13 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		if (entry->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
-	case TRACE_USER_STACK:
-		ret = seq_print_userip_objs(entry, s, sym_flags);
+	}
+	case TRACE_USER_STACK: {
+		struct userstack_entry *field;
+
+		trace_assign_type(field, entry);
+
+		ret = seq_print_userip_objs(field, s, sym_flags);
 		if (!ret)
 			return 0;
 		ret = trace_seq_putc(s, '\n');
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 59d3b17..d734561 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -23,6 +23,7 @@ enum trace_type {
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
 	TRACE_USER_STACK,
+	TRACE_SEM,
 
 	__TRACE_LAST_TYPE
 };
@@ -39,6 +40,7 @@ struct trace_entry {
 	unsigned char		flags;
 	unsigned char		preempt_count;
 	int			pid;
+	int			tgid;
 };
 
 /*
@@ -86,6 +88,11 @@ struct stack_entry {
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
+struct userstack_entry {
+	struct trace_entry	ent;
+	unsigned long		caller[FTRACE_STACK_ENTRIES];
+};
+
 /*
  * ftrace_printk entry:
  */
@@ -119,6 +126,25 @@ struct trace_boot {
 };
 
 /*
+ * semaphore-latency entry
+ */
+
+struct semlat_data {
+	const void     *semaphore;
+	const char     *name;
+	unsigned int	latency_id; /* a unique id for this latency instance */
+	unsigned int 	kind_read;
+	unsigned int    pid;/* pid of task that suffered the latency */
+	cycle_t  	t;/* start of latency - lock contention */
+	int      	cpu;
+};
+
+struct semlat_entry {
+	struct trace_entry	ent;
+	struct semlat_data      data;
+};
+
+/*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
  *  IRQS_OFF	- interrupts were disabled
@@ -211,6 +237,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct ctx_switch_entry, 0);	\
 		IF_ASSIGN(var, ent, struct trace_field_cont, TRACE_CONT); \
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
+		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
 		IF_ASSIGN(var, ent, struct special_entry, 0);		\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
@@ -218,6 +245,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct semlat_entry, TRACE_SEM);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -314,6 +342,10 @@ void trace_special(struct trace_array *tr,
 		   unsigned long arg1,
 		   unsigned long arg2,
 		   unsigned long arg3, int pc);
+
+void trace_semlat(struct trace_array *tr, struct trace_array_cpu *data,
+		  const struct semlat_data *sdata, int samestack);
+
 void trace_function(struct trace_array *tr,
 		    struct trace_array_cpu *data,
 		    unsigned long ip,
diff --git a/kernel/trace/trace_semlat.c b/kernel/trace/trace_semlat.c
new file mode 100644
index 0000000..d72e3e3
--- /dev/null
+++ b/kernel/trace/trace_semlat.c
@@ -0,0 +1,186 @@
+/*
+ * Semaphore latency tracer
+ *
+ * Copyright (C) 2008 Török Edwin <edwintorok@gmail.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <trace/rwsem.h>
+#include "trace.h"
+
+static struct trace_array	*ctx_trace;
+static int __read_mostly	tracer_enabled;
+
+static struct semlat_data map_pid_to_latency[PID_MAX_DEFAULT+1];
+
+static inline int report_latency(unsigned long delta)
+{
+	if (tracing_thresh) {
+		if (delta < tracing_thresh)
+			return 0;
+	} else {
+		if (delta <= tracing_max_latency)
+			return 0;
+	}
+	return 1;
+}
+
+static inline void probe_rwsem_wake(const struct rw_semaphore *sem,
+				    const struct rwsem_waiter *waiter)
+{
+	/* first task in waitlist is oldest, so calculate delta against it */
+	const struct semlat_data *data;
+	struct trace_array_cpu *cpudata;
+	unsigned long T0, T1, delta;
+	int cpu, first;
+
+	if (!tracer_enabled)
+		return;
+	data = &map_pid_to_latency[waiter->task->pid];
+
+	if (data->cpu == -1)
+		return;
+	T0 = data->t;
+	T1 = ftrace_now(data->cpu);
+	delta = T1-T0;
+
+	if (!report_latency(delta))
+		return;
+	cpu = raw_smp_processor_id();
+	cpudata = ctx_trace->data[cpu];
+	/* blame the current task for latency of all tasks on wait list
+	 * note that some of those are being woken now, but that doesn't matter
+	 * we want to blame this task for their latency too */
+	if (list_empty(&waiter->list)) {
+		/* waiter is not part of wait_list, so process it here */
+		trace_semlat(ctx_trace, cpudata, data, 1);
+		first = 0;
+	} else {
+		first = 1;
+	}
+	list_for_each_entry(waiter, &sem->wait_list, list) {
+		data = &map_pid_to_latency[waiter->task->pid];
+		if (data->cpu != -1)
+			trace_semlat(ctx_trace, cpudata, data, first);
+		first = 0;
+	}
+}
+
+static atomic_t unique_latency_id = ATOMIC_INIT(0);
+
+static void probe_rwsem_lock_failed(const struct rw_semaphore *sem)
+{
+	const struct rwsem_waiter *waiter;
+	struct semlat_data *data;
+	int cpu = raw_smp_processor_id();
+
+	if (!tracer_enabled)
+		return;
+	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
+	data = &map_pid_to_latency[waiter->task->pid];
+	data->semaphore = sem;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	data->name = sem->dep_map.name;
+#else
+	data->name = NULL;
+#endif
+
+	data->latency_id = atomic_inc_return(&unique_latency_id);
+	data->kind_read = waiter->flags == RWSEM_WAITING_FOR_READ;
+	data->t = ftrace_now(cpu);
+	data->cpu = cpu;
+}
+
+static void probe_rwsem_lock_ok(const struct task_struct *tsk)
+{
+	struct semlat_data *data = &map_pid_to_latency[tsk->pid];
+	struct trace_array_cpu *cpudata;
+	int cpu;
+	cpu = raw_smp_processor_id();
+	cpudata = ctx_trace->data[cpu];
+
+	if (!tracer_enabled)
+		return;
+	trace_semlat(ctx_trace, cpudata, data, 1);
+	/* invalidate entry */
+	data->cpu = -1;
+}
+
+static void start_semlat_trace(struct trace_array *tr)
+{
+	int ret;
+	ret = register_trace_rwsem_wake(probe_rwsem_wake);
+	WARN_ON(ret);
+
+	ret = register_trace_rwsem_lock_failed(probe_rwsem_lock_failed);
+	WARN_ON(ret);
+
+	ret = register_trace_rwsem_lock_ok(probe_rwsem_lock_ok);
+	WARN_ON(ret);
+	printk(KERN_INFO "registered semlat\n");
+	tracer_enabled = 1;
+}
+
+static void stop_semlat_trace(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+	unregister_trace_rwsem_wake(probe_rwsem_wake);
+	unregister_trace_rwsem_lock_failed(probe_rwsem_lock_failed);
+	printk(KERN_INFO "unregistered semlat\n");
+}
+
+static void semlat_trace_init(struct trace_array *tr)
+{
+	unsigned int i;
+	int cpu;
+
+	ctx_trace = tr;
+
+	atomic_set(&unique_latency_id, 0);
+	for (i = 0; i <= PID_MAX_DEFAULT; i++)
+		map_pid_to_latency[i].cpu = -1;
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+
+	if (tr->ctrl)
+		start_semlat_trace(tr);
+}
+
+static void semlat_trace_reset(struct trace_array *tr)
+{
+
+	if (tr->ctrl)
+		stop_semlat_trace(tr);
+}
+
+static void semlat_trace_ctrl_update(struct trace_array *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_semlat_trace(tr);
+	else
+		stop_semlat_trace(tr);
+}
+
+static struct tracer semlat_trace __read_mostly =
+{
+	.name		= "semlat",
+	.init		= semlat_trace_init,
+	.reset		= semlat_trace_reset,
+	.ctrl_update	= semlat_trace_ctrl_update,
+#ifdef CONFIG_FTRACE_SELFTEST
+/*	.selftest	= trace_selftest_startup_semlat,*/
+#endif
+};
+
+__init static int init_semlat_trace(void)
+{
+	return register_tracer(&semlat_trace);
+}
+device_initcall(init_semlat_trace);
-- 
1.5.6.5

