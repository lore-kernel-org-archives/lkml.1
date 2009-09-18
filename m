Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZIRT0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZIRT0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757957AbZIRT0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:26:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:54615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbZIRT0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:26:35 -0400
Date: Fri, 18 Sep 2009 21:26:36 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, lizf@cn.fujitsu.com
Subject: Re: [git pull] timechart for -tip
Message-ID: <20090918212636.627cf799@infradead.org>
In-Reply-To: <20090917221337.7a7b3c81@infradead.org>
References: <20090917221337.7a7b3c81@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch is below for review

diff --git a/Documentation/trace/power.txt b/Documentation/trace/power.txt
deleted file mode 100644
index cd805e1..0000000
--- a/Documentation/trace/power.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-The power tracer collects detailed information about C-state and P-state
-transitions, instead of just looking at the high-level "average"
-information.
-
-There is a helper script found in scrips/tracing/power.pl in the kernel
-sources which can be used to parse this information and create a
-Scalable Vector Graphics (SVG) picture from the trace data.
-
-To use this tracer:
-
-	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
-	echo power > /sys/kernel/debug/tracing/current_tracer
-	echo 1 > /sys/kernel/debug/tracing/tracing_enabled
-	sleep 1
-	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
-	cat /sys/kernel/debug/tracing/trace | \
-		perl scripts/tracing/power.pl > out.sv
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4109679..479cc8c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,7 +33,7 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
-#include <trace/power.h>
+#include <trace/events/power.h>
 
 #include <linux/acpi.h>
 #include <linux/io.h>
@@ -72,8 +72,6 @@ static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
 static DEFINE_PER_CPU(struct aperfmperf, old_perf);
 
-DEFINE_TRACE(power_mark);
-
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
@@ -332,7 +330,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
 	int result = 0;
-	struct power_trace it;
 
 	dprintk("acpi_cpufreq_target %d (%d)\n", target_freq, policy->cpu);
 
@@ -364,7 +361,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
+	trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
 
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1092a1a..98e9cac 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -9,7 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/random.h>
-#include <trace/power.h>
+#include <trace/events/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
@@ -27,9 +27,6 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
-DEFINE_TRACE(power_start);
-DEFINE_TRACE(power_end);
-
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
@@ -289,9 +286,7 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
-		struct power_trace it;
-
-		trace_power_start(&it, POWER_CSTATE, 1);
+		trace_power_start(POWER_CSTATE, 1);
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -304,7 +299,7 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(&it);
+		trace_power_end(0);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -362,9 +357,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
-	struct power_trace it;
-
-	trace_power_start(&it, POWER_CSTATE, (ax>>4)+1);
+	trace_power_start(POWER_CSTATE, (ax>>4)+1);
 	if (!need_resched()) {
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -374,15 +367,14 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
-	trace_power_end(&it);
+	trace_power_end(0);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
-	struct power_trace it;
 	if (!need_resched()) {
-		trace_power_start(&it, POWER_CSTATE, 1);
+		trace_power_start(POWER_CSTATE, 1);
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
@@ -392,7 +384,7 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end(&it);
+		trace_power_end(0);
 	} else
 		local_irq_enable();
 }
@@ -404,13 +396,11 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	struct power_trace it;
-
-	trace_power_start(&it, POWER_CSTATE, 0);
+	trace_power_start(POWER_CSTATE, 0);
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(&it);
+	trace_power_end(0);
 }
 
 /*
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 6c1ef72..a9c934c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -336,6 +336,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_EXIT			= 4,
@@ -356,6 +357,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	{ u64				time;     } && PERF_SAMPLE_TIME
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
new file mode 100644
index 0000000..ea6d579
--- /dev/null
+++ b/include/trace/events/power.h
@@ -0,0 +1,81 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM power
+
+#if !defined(_TRACE_POWER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_POWER_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+#ifndef _TRACE_POWER_ENUM_
+#define _TRACE_POWER_ENUM_
+enum {
+	POWER_NONE = 0,
+	POWER_CSTATE = 1,
+	POWER_PSTATE = 2,
+};
+#endif
+
+
+
+TRACE_EVENT(power_start,
+
+	TP_PROTO(unsigned int type, unsigned int state),
+
+	TP_ARGS(type, state),
+
+	TP_STRUCT__entry(
+		__field(	u64,		type		)
+		__field(	u64,		state		)
+	),
+
+	TP_fast_assign(
+		__entry->type = type;
+		__entry->state = state;
+	),
+
+	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long)__entry->state)
+);
+
+TRACE_EVENT(power_end,
+
+	TP_PROTO(int dummy),
+
+	TP_ARGS(dummy),
+
+	TP_STRUCT__entry(
+		__field(	u64,		dummy		)
+	),
+
+	TP_fast_assign(
+		__entry->dummy = 0xffff;
+	),
+
+	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
+
+);
+
+
+TRACE_EVENT(power_frequency,
+
+	TP_PROTO(unsigned int type, unsigned int state),
+
+	TP_ARGS(type, state),
+
+	TP_STRUCT__entry(
+		__field(	u64,		type		)
+		__field(	u64,		state		)
+	),
+
+	TP_fast_assign(
+		__entry->type = type;
+		__entry->state = state;
+	),
+
+	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long) __entry->state)
+);
+
+#endif /* _TRACE_POWER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 76287f5..7f0a2b0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3078,6 +3078,7 @@ struct perf_task_event {
 		u32				ppid;
 		u32				tid;
 		u32				ptid;
+		u64				time;
 	} event;
 };
 
@@ -3085,9 +3086,12 @@ static void perf_counter_task_output(struct perf_counter *counter,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size = task_event->event.header.size;
+	int size;
 	struct task_struct *task = task_event->task;
-	int ret = perf_output_begin(&handle, counter, size, 0, 0);
+	int ret;
+
+	size  = task_event->event.header.size;
+	ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
@@ -3098,7 +3102,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
 	task_event->event.tid = perf_counter_tid(counter, task);
 	task_event->event.ptid = perf_counter_tid(counter, current);
 
+	task_event->event.time = sched_clock();
+
 	perf_output_put(&handle, task_event->event);
+
 	perf_output_end(&handle);
 }
 
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index ce3b1cd..b5ca90b 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
-obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
@@ -54,6 +53,7 @@ obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += power-traces.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
new file mode 100644
index 0000000..e06c6e3
--- /dev/null
+++ b/kernel/trace/power-traces.c
@@ -0,0 +1,20 @@
+/*
+ * Power trace points
+ *
+ * Copyright (C) 2009 Arjan van de Ven <arjan@linux.intel.com>
+ */
+
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/power.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
+
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e747162..210a41f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -11,7 +11,6 @@
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
-#include <trace/power.h>
 
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
@@ -41,7 +40,6 @@ enum trace_type {
 	TRACE_HW_BRANCHES,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
-	TRACE_POWER,
 	TRACE_BLK,
 	TRACE_KSYM,
 
@@ -212,7 +210,6 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
-		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
 		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index a431748..ead3d72 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -330,23 +330,6 @@ FTRACE_ENTRY(hw_branch, hw_branch_entry,
 	F_printk("from: %llx to: %llx", __entry->from, __entry->to)
 );
 
-FTRACE_ENTRY(power, trace_power,
-
-	TRACE_POWER,
-
-	F_STRUCT(
-		__field_struct(	struct power_trace,	state_data	)
-		__field_desc(	s64,	state_data,	stamp		)
-		__field_desc(	s64,	state_data,	end		)
-		__field_desc(	int,	state_data,	type		)
-		__field_desc(	int,	state_data,	state		)
-	),
-
-	F_printk("%llx->%llx type:%u state:%u",
-		 __entry->stamp, __entry->end,
-		 __entry->type, __entry->state)
-);
-
 FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
 
 	TRACE_KMEM_ALLOC,
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
deleted file mode 100644
index fe1a00f..0000000
--- a/kernel/trace/trace_power.c
+++ /dev/null
@@ -1,218 +0,0 @@
-/*
- * ring buffer based C-state tracer
- *
- * Arjan van de Ven <arjan@linux.intel.com>
- * Copyright (C) 2008 Intel Corporation
- *
- * Much is borrowed from trace_boot.c which is
- * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
- *
- */
-
-#include <linux/init.h>
-#include <linux/debugfs.h>
-#include <trace/power.h>
-#include <linux/kallsyms.h>
-#include <linux/module.h>
-
-#include "trace.h"
-#include "trace_output.h"
-
-static struct trace_array *power_trace;
-static int __read_mostly trace_power_enabled;
-
-static void probe_power_start(struct power_trace *it, unsigned int type,
-				unsigned int level)
-{
-	if (!trace_power_enabled)
-		return;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-}
-
-
-static void probe_power_end(struct power_trace *it)
-{
-	struct ftrace_event_call *call = &event_power;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	buffer = tr->buffer;
-
-	preempt_disable();
-	it->end = ktime_get();
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
- out:
-	preempt_enable();
-}
-
-static void probe_power_mark(struct power_trace *it, unsigned int type,
-				unsigned int level)
-{
-	struct ftrace_event_call *call = &event_power;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	buffer = tr->buffer;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-	preempt_disable();
-	it->end = it->stamp;
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
- out:
-	preempt_enable();
-}
-
-static int tracing_power_register(void)
-{
-	int ret;
-
-	ret = register_trace_power_start(probe_power_start);
-	if (ret) {
-		pr_info("power trace: Couldn't activate tracepoint"
-			" probe to trace_power_start\n");
-		return ret;
-	}
-	ret = register_trace_power_end(probe_power_end);
-	if (ret) {
-		pr_info("power trace: Couldn't activate tracepoint"
-			" probe to trace_power_end\n");
-		goto fail_start;
-	}
-	ret = register_trace_power_mark(probe_power_mark);
-	if (ret) {
-		pr_info("power trace: Couldn't activate tracepoint"
-			" probe to trace_power_mark\n");
-		goto fail_end;
-	}
-	return ret;
-fail_end:
-	unregister_trace_power_end(probe_power_end);
-fail_start:
-	unregister_trace_power_start(probe_power_start);
-	return ret;
-}
-
-static void start_power_trace(struct trace_array *tr)
-{
-	trace_power_enabled = 1;
-}
-
-static void stop_power_trace(struct trace_array *tr)
-{
-	trace_power_enabled = 0;
-}
-
-static void power_trace_reset(struct trace_array *tr)
-{
-	trace_power_enabled = 0;
-	unregister_trace_power_start(probe_power_start);
-	unregister_trace_power_end(probe_power_end);
-	unregister_trace_power_mark(probe_power_mark);
-}
-
-
-static int power_trace_init(struct trace_array *tr)
-{
-	power_trace = tr;
-
-	trace_power_enabled = 1;
-	tracing_power_register();
-
-	tracing_reset_online_cpus(tr);
-	return 0;
-}
-
-static enum print_line_t power_print_line(struct trace_iterator *iter)
-{
-	int ret = 0;
-	struct trace_entry *entry = iter->ent;
-	struct trace_power *field ;
-	struct power_trace *it;
-	struct trace_seq *s = &iter->seq;
-	struct timespec stamp;
-	struct timespec duration;
-
-	trace_assign_type(field, entry);
-	it = &field->state_data;
-	stamp = ktime_to_timespec(it->stamp);
-	duration = ktime_to_timespec(ktime_sub(it->end, it->stamp));
-
-	if (entry->type == TRACE_POWER) {
-		if (it->type == POWER_CSTATE)
-			ret = trace_seq_printf(s, "[%5ld.%09ld] CSTATE: Going to C%i on cpu %i for %ld.%09ld\n",
-					  stamp.tv_sec,
-					  stamp.tv_nsec,
-					  it->state, iter->cpu,
-					  duration.tv_sec,
-					  duration.tv_nsec);
-		if (it->type == POWER_PSTATE)
-			ret = trace_seq_printf(s, "[%5ld.%09ld] PSTATE: Going to P%i on cpu %i\n",
-					  stamp.tv_sec,
-					  stamp.tv_nsec,
-					  it->state, iter->cpu);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		return TRACE_TYPE_HANDLED;
-	}
-	return TRACE_TYPE_UNHANDLED;
-}
-
-static void power_print_header(struct seq_file *s)
-{
-	seq_puts(s, "#   TIMESTAMP      STATE  EVENT\n");
-	seq_puts(s, "#       |            |      |\n");
-}
-
-static struct tracer power_tracer __read_mostly =
-{
-	.name		= "power",
-	.init		= power_trace_init,
-	.start		= start_power_trace,
-	.stop		= stop_power_trace,
-	.reset		= power_trace_reset,
-	.print_line	= power_print_line,
-	.print_header	= power_print_header,
-};
-
-static int init_power_trace(void)
-{
-	return register_tracer(&power_tracer);
-}
-device_initcall(init_power_trace);
diff --git a/scripts/tracing/power.pl b/scripts/tracing/power.pl
deleted file mode 100644
index 4f729b3..0000000
--- a/scripts/tracing/power.pl
+++ /dev/null
@@ -1,108 +0,0 @@
-#!/usr/bin/perl
-
-# Copyright 2008, Intel Corporation
-#
-# This file is part of the Linux kernel
-#
-# This program file is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by the
-# Free Software Foundation; version 2 of the License.
-#
-# This program is distributed in the hope that it will be useful, but WITHOUT
-# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
-# for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program in a file named COPYING; if not, write to the
-# Free Software Foundation, Inc.,
-# 51 Franklin Street, Fifth Floor,
-# Boston, MA 02110-1301 USA
-#
-# Authors:
-# 	Arjan van de Ven <arjan@linux.intel.com>
-
-
-#
-# This script turns a cstate ftrace output into a SVG graphic that shows
-# historic C-state information
-#
-#
-# 	cat /sys/kernel/debug/tracing/trace | perl power.pl > out.svg
-#
-
-my @styles;
-my $base = 0;
-
-my @pstate_last;
-my @pstate_level;
-
-$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[8] = "fill:rgb(0,25,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-
-
-print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
-print "<svg width=\"10000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
-
-my $scale = 30000.0;
-while (<>) {
-	my $line = $_;
-	if ($line =~ /([0-9\.]+)\] CSTATE: Going to C([0-9]) on cpu ([0-9]+) for ([0-9\.]+)/) {
-		if ($base == 0) {
-			$base = $1;
-		}
-		my $time = $1 - $base;
-		$time = $time * $scale;
-		my $C = $2;
-		my $cpu = $3;
-		my $y = 400 * $cpu;
-		my $duration = $4 * $scale;
-		my $msec = int($4 * 100000)/100.0;
-		my $height = $C * 20;
-		$style = $styles[$C];
-
-		$y = $y + 140 - $height;
-
-		$x2 = $time + 4;
-		$y2 = $y + 4;
-
-
-		print "<rect x=\"$time\" width=\"$duration\" y=\"$y\" height=\"$height\" style=\"$style\"/>\n";
-		print "<text transform=\"translate($x2,$y2) rotate(90)\">C$C $msec</text>\n";
-	}
-	if ($line =~ /([0-9\.]+)\] PSTATE: Going to P([0-9]) on cpu ([0-9]+)/) {
-		my $time = $1 - $base;
-		my $state = $2;
-		my $cpu = $3;
-
-		if (defined($pstate_last[$cpu])) {
-			my $from = $pstate_last[$cpu];
-			my $oldstate = $pstate_state[$cpu];
-			my $duration = ($time-$from) * $scale;
-
-			$from = $from * $scale;
-			my $to = $from + $duration;
-			my $height = 140 - ($oldstate * (140/8));
-
-			my $y = 400 * $cpu + 200 + $height;
-			my $y2 = $y+4;
-			my $style = $styles[8];
-
-			print "<rect x=\"$from\" y=\"$y\" width=\"$duration\" height=\"5\" style=\"$style\"/>\n";
-			print "<text transform=\"translate($from,$y2)\">P$oldstate (cpu $cpu)</text>\n";
-		};
-
-		$pstate_last[$cpu] = $time;
-		$pstate_state[$cpu] = $state;
-	}
-}
-
-
-print "</svg>\n";
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2cb8cc3..0aba8b6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -373,6 +373,7 @@ LIB_OBJS += util/thread.o
 LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
 LIB_OBJS += util/trace-event-info.o
+LIB_OBJS += util/svghelper.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
@@ -381,6 +382,7 @@ BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
 BUILTIN_OBJS += builtin-stat.o
+BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
 
@@ -711,6 +713,12 @@ builtin-help.o: builtin-help.c common-cmds.h PERF-CFLAGS
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
 
+builtin-timechart.o: builtin-timechart.c common-cmds.h PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) \
+		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
+		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
+		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+
 $(BUILT_INS): perf$X
 	$(QUIET_BUILT_IN)$(RM) $@ && \
 	ln perf$X $@ 2>/dev/null || \
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2459e5a..7ac1968 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -47,6 +47,7 @@ static int			append_file			= 0;
 static int			call_graph			= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
+static int			timechart			= 0;
 static int			sample_address			= 0;
 static int			multiplex			= 0;
 static int			multiplex_fd			= -1;
@@ -387,6 +388,12 @@ static void create_counter(int counter, int cpu, pid_t pid)
 
 	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
+	if (timechart) {
+		attr->sample_type |= PERF_SAMPLE_CPU;
+		attr->sample_type |= PERF_SAMPLE_TIME;
+		attr->sample_type |= PERF_SAMPLE_RAW;
+	}
+
 	if (freq) {
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 		attr->freq		= 1;
@@ -661,6 +668,24 @@ static int __cmd_record(int argc, const char **argv)
 	return 0;
 }
 
+static int do_timechart(const struct option *opt __used, const char *str __used, int unset __used)
+{
+	parse_events(NULL, "power:power_start", 0);
+	parse_events(NULL, "power:power_end", 0);
+	parse_events(NULL, "power:power_frequency", 0);
+	parse_events(NULL, "sched:sched_wakeup", 0);
+	parse_events(NULL, "sched:sched_switch", 0);
+	default_interval = 1;
+	system_wide = 1;
+	timechart = 1;
+	if (!nr_counters) {
+		printf("No counters found.. is debugfs mounted?\n");
+		exit(0);
+	}
+	return 0;
+}
+
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -707,6 +732,9 @@ static const struct option options[] = {
 		    "don't sample"),
 	OPT_BOOLEAN('M', "multiplex", &multiplex,
 		    "multiplex counter output in a single channel"),
+	OPT_CALLBACK_NOOPT('t', "timechart", NULL, NULL,
+		     "create a timechart recording",
+		     do_timechart),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
new file mode 100644
index 0000000..9b79d4a
--- /dev/null
+++ b/tools/perf/builtin-timechart.c
@@ -0,0 +1,1120 @@
+/*
+ * builtin-timechart.c - make an svg timechart of system activity
+ *
+ * (C) Copyright 2009 Intel Corporation
+ *
+ * Authors:
+ *     Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include "builtin.h"
+
+#include "util/util.h"
+
+#include "util/color.h"
+#include <linux/list.h>
+#include "util/cache.h"
+#include <linux/rbtree.h>
+#include "util/symbol.h"
+#include "util/string.h"
+#include "util/callchain.h"
+#include "util/strlist.h"
+
+#include "perf.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+#include "util/svghelper.h"
+
+static char		const *input_name = "perf.data";
+static char		const *output_name = "output.svg";
+
+
+static unsigned long	page_size;
+static unsigned long	mmap_window = 32;
+static u64		sample_type;
+
+static unsigned int	numcpus;
+static u64		min_freq;	/* Lowest CPU frequency seen */
+static u64 		max_freq;	/* Highest CPU frequency seen */
+static u64		turbo_frequency;
+
+static u64 		first_time, last_time;
+
+
+static struct perf_header	*header;
+
+struct per_pid;
+struct per_pidcomm;
+
+struct cpu_sample;
+struct power_event;
+struct wake_event;
+
+struct sample_wrapper;
+
+/*
+ * Datastructure layout:
+ * We keep an list of "pid"s, matching the kernels notion of a task struct.
+ * Each "pid" entry, has a list of "comm"s.
+ *	this is because we want to track different programs different, while
+ *	exec will reuse the original pid (by design).
+ * Each comm has a list of samples that will be used to draw
+ * final graph.
+ */
+
+struct per_pid {
+	struct per_pid *next;
+
+	int		pid;
+	int		ppid;
+
+	u64		start_time;
+	u64		end_time;
+	u64		total_time;
+	int 		display;
+
+	struct per_pidcomm *all;
+	struct per_pidcomm *current;
+
+	int painted;
+};
+
+
+struct per_pidcomm {
+	struct per_pidcomm *next;
+
+	u64		start_time;
+	u64		end_time;
+	u64		total_time;
+
+	int		Y;
+	int		display;
+
+	long		state;
+	u64		state_since;
+
+	char		*comm;
+
+	struct cpu_sample *samples;
+};
+
+struct sample_wrapper {
+	struct sample_wrapper *next;
+
+	u64		timestamp;
+	unsigned char	data[0];
+};
+
+#define TYPE_NONE 	0
+#define TYPE_RUNNING 	1
+#define TYPE_WAITING	2
+#define TYPE_BLOCKED	3
+
+struct cpu_sample {
+	struct cpu_sample *next;
+
+	u64 start_time;
+	u64 end_time;
+	int type;
+	int cpu;
+};
+
+static struct per_pid *all_data;
+
+#define CSTATE 1
+#define PSTATE 2
+
+struct power_event {
+	struct power_event *next;
+	int type;
+	int state;
+	u64 start_time;
+	u64 end_time;
+	int cpu;
+};
+
+struct wake_event {
+	struct wake_event *next;
+	int waker;
+	int wakee;
+	u64 time;
+};
+
+static struct power_event    *power_events;
+static struct wake_event     *wake_events;
+
+struct sample_wrapper *all_samples;
+
+static struct per_pid *find_create_pid(int pid)
+{
+	struct per_pid *cursor = all_data;
+
+	while (cursor) {
+		if (cursor->pid == pid)
+			return cursor;
+		cursor = cursor->next;
+	}
+	cursor = malloc(sizeof(struct per_pid));
+	assert(cursor != NULL);
+	memset(cursor, 0, sizeof(struct per_pid));
+	cursor->pid = pid;
+	cursor->next = all_data;
+	all_data = cursor;
+	return cursor;
+}
+
+static void pid_set_comm(int pid, char *comm)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	p = find_create_pid(pid);
+	c = p->all;
+	while (c) {
+		if (c->comm && strcmp(c->comm, comm) == 0) {
+			p->current = c;
+			return;
+		}
+		if (!c->comm) {
+			c->comm = strdup(comm);
+			p->current = c;
+			return;
+		}
+		c = c->next;
+	}
+	c = malloc(sizeof(struct per_pidcomm));
+	assert(c != NULL);
+	memset(c, 0, sizeof(struct per_pidcomm));
+	c->comm = strdup(comm);
+	p->current = c;
+	c->next = p->all;
+	p->all = c;
+}
+
+static void pid_fork(int pid, int ppid, u64 timestamp)
+{
+	struct per_pid *p, *pp;
+	p = find_create_pid(pid);
+	pp = find_create_pid(ppid);
+	p->ppid = ppid;
+	if (pp->current && pp->current->comm && !p->current)
+		pid_set_comm(pid, pp->current->comm);
+
+	p->start_time = timestamp;
+	if (p->current) {
+		p->current->start_time = timestamp;
+		p->current->state_since = timestamp;
+	}
+}
+
+static void pid_exit(int pid, u64 timestamp)
+{
+	struct per_pid *p;
+	p = find_create_pid(pid);
+	p->end_time = timestamp;
+	if (p->current)
+		p->current->end_time = timestamp;
+}
+
+static void
+pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct cpu_sample *sample;
+
+	p = find_create_pid(pid);
+	c = p->current;
+	if (!c) {
+		c = malloc(sizeof(struct per_pidcomm));
+		assert(c != NULL);
+		memset(c, 0, sizeof(struct per_pidcomm));
+		p->current = c;
+		c->next = p->all;
+		p->all = c;
+	}
+
+	sample = malloc(sizeof(struct cpu_sample));
+	assert(sample != NULL);
+	memset(sample, 0, sizeof(struct cpu_sample));
+	sample->start_time = start;
+	sample->end_time = end;
+	sample->type = type;
+	sample->next = c->samples;
+	sample->cpu = cpu;
+	c->samples = sample;
+
+	if (sample->type == TYPE_RUNNING && end > start && start > 0) {
+		c->total_time += (end-start);
+		p->total_time += (end-start);
+	}
+
+	if (c->start_time == 0 || c->start_time > start)
+		c->start_time = start;
+	if (p->start_time == 0 || p->start_time > start)
+		p->start_time = start;
+
+	if (cpu > numcpus)
+		numcpus = cpu;
+}
+
+#define MAX_CPUS 4096
+
+static u64 cpus_cstate_start_times[MAX_CPUS];
+static int cpus_cstate_state[MAX_CPUS];
+static u64 cpus_pstate_start_times[MAX_CPUS];
+static u64 cpus_pstate_state[MAX_CPUS];
+
+static int
+process_comm_event(event_t *event)
+{
+	pid_set_comm(event->comm.pid, event->comm.comm);
+	return 0;
+}
+static int
+process_fork_event(event_t *event)
+{
+	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
+	return 0;
+}
+
+static int
+process_exit_event(event_t *event)
+{
+	pid_exit(event->fork.pid, event->fork.time);
+	return 0;
+}
+
+struct trace_entry {
+	u32			size;
+	unsigned short		type;
+	unsigned char		flags;
+	unsigned char		preempt_count;
+	int			pid;
+	int			tgid;
+};
+
+struct power_entry {
+	struct trace_entry te;
+	s64	type;
+	s64	value;
+};
+
+#define TASK_COMM_LEN 16
+struct wakeup_entry {
+	struct trace_entry te;
+	char comm[TASK_COMM_LEN];
+	int   pid;
+	int   prio;
+	int   success;
+};
+
+/*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF            - interrupts were disabled
+ *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
+ *  NEED_RESCED         - reschedule is requested
+ *  HARDIRQ             - inside an interrupt handler
+ *  SOFTIRQ             - inside a softirq handler
+ */
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
+	TRACE_FLAG_NEED_RESCHED		= 0x04,
+	TRACE_FLAG_HARDIRQ		= 0x08,
+	TRACE_FLAG_SOFTIRQ		= 0x10,
+};
+
+
+
+struct sched_switch {
+	struct trace_entry te;
+	char prev_comm[TASK_COMM_LEN];
+	int  prev_pid;
+	int  prev_prio;
+	long prev_state; /* Arjan weeps. */
+	char next_comm[TASK_COMM_LEN];
+	int  next_pid;
+	int  next_prio;
+};
+
+static void c_state_start(int cpu, u64 timestamp, int state)
+{
+	cpus_cstate_start_times[cpu] = timestamp;
+	cpus_cstate_state[cpu] = state;
+}
+
+static void c_state_end(int cpu, u64 timestamp)
+{
+	struct power_event *pwr;
+	pwr = malloc(sizeof(struct power_event));
+	if (!pwr)
+		return;
+	memset(pwr, 0, sizeof(struct power_event));
+
+	pwr->state = cpus_cstate_state[cpu];
+	pwr->start_time = cpus_cstate_start_times[cpu];
+	pwr->end_time = timestamp;
+	pwr->cpu = cpu;
+	pwr->type = CSTATE;
+	pwr->next = power_events;
+
+	power_events = pwr;
+}
+
+static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
+{
+	struct power_event *pwr;
+	pwr = malloc(sizeof(struct power_event));
+
+	if (new_freq > 8000000) /* detect invalid data */
+		return;
+
+	if (!pwr)
+		return;
+	memset(pwr, 0, sizeof(struct power_event));
+
+	pwr->state = cpus_pstate_state[cpu];
+	pwr->start_time = cpus_pstate_start_times[cpu];
+	pwr->end_time = timestamp;
+	pwr->cpu = cpu;
+	pwr->type = PSTATE;
+	pwr->next = power_events;
+
+	if (!pwr->start_time)
+		pwr->start_time = first_time;
+
+	power_events = pwr;
+
+	cpus_pstate_state[cpu] = new_freq;
+	cpus_pstate_start_times[cpu] = timestamp;
+
+	if ((u64)new_freq > max_freq)
+		max_freq = new_freq;
+
+	if (new_freq < min_freq || min_freq == 0)
+		min_freq = new_freq;
+
+	if (new_freq == max_freq - 1000)
+			turbo_frequency = max_freq;
+}
+
+static void
+sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
+{
+	struct wake_event *we;
+	struct per_pid *p;
+	struct wakeup_entry *wake = (void *)te;
+
+	we = malloc(sizeof(struct wake_event));
+	if (!we)
+		return;
+
+	memset(we, 0, sizeof(struct wake_event));
+	we->time = timestamp;
+	we->waker = pid;
+
+	if ((te->flags & TRACE_FLAG_HARDIRQ) || (te->flags & TRACE_FLAG_SOFTIRQ))
+		we->waker = -1;
+
+	we->wakee = wake->pid;
+	we->next = wake_events;
+	wake_events = we;
+	p = find_create_pid(we->wakee);
+
+	if (p && p->current && p->current->state == TYPE_NONE) {
+		p->current->state_since = timestamp;
+		p->current->state = TYPE_WAITING;
+	}
+	if (p && p->current && p->current->state == TYPE_BLOCKED) {
+		pid_put_sample(p->pid, p->current->state, cpu, p->current->state_since, timestamp);
+		p->current->state_since = timestamp;
+		p->current->state = TYPE_WAITING;
+	}
+}
+
+static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
+{
+	struct per_pid *p = NULL, *prev_p;
+	struct sched_switch *sw = (void *)te;
+
+
+	prev_p = find_create_pid(sw->prev_pid);
+
+	p = find_create_pid(sw->next_pid);
+
+	if (prev_p->current && prev_p->current->state != TYPE_NONE)
+		pid_put_sample(sw->prev_pid, TYPE_RUNNING, cpu, prev_p->current->state_since, timestamp);
+	if (p && p->current) {
+		if (p->current->state != TYPE_NONE)
+			pid_put_sample(sw->next_pid, p->current->state, cpu, p->current->state_since, timestamp);
+
+			p->current->state_since = timestamp;
+			p->current->state = TYPE_RUNNING;
+	}
+
+	if (prev_p->current) {
+		prev_p->current->state = TYPE_NONE;
+		prev_p->current->state_since = timestamp;
+		if (sw->prev_state & 2)
+			prev_p->current->state = TYPE_BLOCKED;
+		if (sw->prev_state == 0)
+			prev_p->current->state = TYPE_WAITING;
+	}
+}
+
+
+static int
+process_sample_event(event_t *event)
+{
+	int cursor = 0;
+	u64 addr = 0;
+	u64 stamp = 0;
+	u32 cpu = 0;
+	u32 pid = 0;
+	struct trace_entry *te;
+
+	if (sample_type & PERF_SAMPLE_IP)
+		cursor++;
+
+	if (sample_type & PERF_SAMPLE_TID) {
+		pid = event->sample.array[cursor]>>32;
+		cursor++;
+	}
+	if (sample_type & PERF_SAMPLE_TIME) {
+		stamp = event->sample.array[cursor++];
+
+		if (!first_time || first_time > stamp)
+			first_time = stamp;
+		if (last_time < stamp)
+			last_time = stamp;
+
+	}
+	if (sample_type & PERF_SAMPLE_ADDR)
+		addr = event->sample.array[cursor++];
+	if (sample_type & PERF_SAMPLE_ID)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_CPU)
+		cpu = event->sample.array[cursor++] & 0xFFFFFFFF;
+	if (sample_type & PERF_SAMPLE_PERIOD)
+		cursor++;
+
+	te = (void *)&event->sample.array[cursor];
+
+	if (sample_type & PERF_SAMPLE_RAW && te->size > 0) {
+		char *event_str;
+		struct power_entry *pe;
+
+		pe = (void *)te;
+
+		event_str = perf_header__find_event(te->type);
+
+		if (!event_str)
+			return 0;
+
+		if (strcmp(event_str, "power:power_start") == 0)
+			c_state_start(cpu, stamp, pe->value);
+
+		if (strcmp(event_str, "power:power_end") == 0)
+			c_state_end(cpu, stamp);
+
+		if (strcmp(event_str, "power:power_frequency") == 0)
+			p_state_change(cpu, stamp, pe->value);
+
+		if (strcmp(event_str, "sched:sched_wakeup") == 0)
+			sched_wakeup(cpu, stamp, pid, te);
+
+		if (strcmp(event_str, "sched:sched_switch") == 0)
+			sched_switch(cpu, stamp, te);
+	}
+	return 0;
+}
+
+/*
+ * After the last sample we need to wrap up the current C/P state
+ * and close out each CPU for these.
+ */
+static void end_sample_processing(void)
+{
+	u64 cpu;
+	struct power_event *pwr;
+
+	for (cpu = 0; cpu < numcpus; cpu++) {
+		pwr = malloc(sizeof(struct power_event));
+		if (!pwr)
+			return;
+		memset(pwr, 0, sizeof(struct power_event));
+
+		/* C state */
+#if 0
+		pwr->state = cpus_cstate_state[cpu];
+		pwr->start_time = cpus_cstate_start_times[cpu];
+		pwr->end_time = last_time;
+		pwr->cpu = cpu;
+		pwr->type = CSTATE;
+		pwr->next = power_events;
+
+		power_events = pwr;
+#endif
+		/* P state */
+
+		pwr = malloc(sizeof(struct power_event));
+		if (!pwr)
+			return;
+		memset(pwr, 0, sizeof(struct power_event));
+
+		pwr->state = cpus_pstate_state[cpu];
+		pwr->start_time = cpus_pstate_start_times[cpu];
+		pwr->end_time = last_time;
+		pwr->cpu = cpu;
+		pwr->type = PSTATE;
+		pwr->next = power_events;
+
+		if (!pwr->start_time)
+			pwr->start_time = first_time;
+		if (!pwr->state)
+			pwr->state = min_freq;
+		power_events = pwr;
+	}
+}
+
+static u64 sample_time(event_t *event)
+{
+	int cursor;
+
+	cursor = 0;
+	if (sample_type & PERF_SAMPLE_IP)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_TID)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_TIME)
+		return event->sample.array[cursor];
+	return 0;
+}
+
+
+/*
+ * We first queue all events, sorted backwards by insertion.
+ * The order will get flipped later.
+ */
+static int
+queue_sample_event(event_t *event)
+{
+	struct sample_wrapper *copy, *prev;
+	int size;
+
+	size = event->sample.header.size + sizeof(struct sample_wrapper) + 8;
+
+	copy = malloc(size);
+	if (!copy)
+		return 1;
+
+	memset(copy, 0, size);
+
+	copy->next = NULL;
+	copy->timestamp = sample_time(event);
+
+	memcpy(&copy->data, event, event->sample.header.size);
+
+	/* insert in the right place in the list */
+
+	if (!all_samples) {
+		/* first sample ever */
+		all_samples = copy;
+		return 0;
+	}
+
+	if (all_samples->timestamp < copy->timestamp) {
+		/* insert at the head of the list */
+		copy->next = all_samples;
+		all_samples = copy;
+		return 0;
+	}
+
+	prev = all_samples;
+	while (prev->next) {
+		if (prev->next->timestamp < copy->timestamp) {
+			copy->next = prev->next;
+			prev->next = copy;
+			return 0;
+		}
+		prev = prev->next;
+	}
+	/* insert at the end of the list */
+	prev->next = copy;
+
+	return 0;
+}
+
+static void sort_queued_samples(void)
+{
+	struct sample_wrapper *cursor, *next;
+
+	cursor = all_samples;
+	all_samples = NULL;
+
+	while (cursor) {
+		next = cursor->next;
+		cursor->next = all_samples;
+		all_samples = cursor;
+		cursor = next;
+	}
+}
+
+/*
+ * Sort the pid datastructure
+ */
+static void sort_pids(void)
+{
+	struct per_pid *new_list, *p, *cursor, *prev;
+	/* sort by ppid first, then by pid, lowest to highest */
+
+	new_list = NULL;
+
+	while (all_data) {
+		p = all_data;
+		all_data = p->next;
+		p->next = NULL;
+
+		if (new_list == NULL) {
+			new_list = p;
+			p->next = NULL;
+			continue;
+		}
+		prev = NULL;
+		cursor = new_list;
+		while (cursor) {
+			if (cursor->ppid > p->ppid ||
+				(cursor->ppid == p->ppid && cursor->pid > p->pid)) {
+				/* must insert before */
+				if (prev) {
+					p->next = prev->next;
+					prev->next = p;
+					cursor = NULL;
+					continue;
+				} else {
+					p->next = new_list;
+					new_list = p;
+					cursor = NULL;
+					continue;
+				}
+			}
+
+			prev = cursor;
+			cursor = cursor->next;
+			if (!cursor)
+				prev->next = p;
+		}
+	}
+	all_data = new_list;
+}
+
+
+static void draw_c_p_states(void)
+{
+	struct power_event *pwr;
+	pwr = power_events;
+
+	/*
+	 * two pass drawing so that the P state bars are on top of the C state blocks
+	 */
+	while (pwr) {
+		if (pwr->type == CSTATE)
+			svg_cstate(pwr->cpu, pwr->start_time, pwr->end_time, pwr->state);
+		pwr = pwr->next;
+	}
+
+	pwr = power_events;
+	while (pwr) {
+		if (pwr->type == PSTATE) {
+			if (!pwr->state)
+				pwr->state = min_freq;
+			svg_pstate(pwr->cpu, pwr->start_time, pwr->end_time, pwr->state);
+		}
+		pwr = pwr->next;
+	}
+}
+
+static void draw_wakeups(void)
+{
+	struct wake_event *we;
+	struct per_pid *p;
+	struct per_pidcomm *c;
+
+	we = wake_events;
+	while (we) {
+		int from = 0, to = 0;
+
+		/* locate the column of the waker and wakee */
+		p = all_data;
+		while (p) {
+			if (p->pid == we->waker || p->pid == we->wakee) {
+				c = p->all;
+				while (c) {
+					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
+						if (p->pid == we->waker)
+							from = c->Y;
+						if (p->pid == we->wakee)
+							to = c->Y;
+					}
+					c = c->next;
+				}
+			}
+			p = p->next;
+		}
+
+		if (we->waker == -1)
+			svg_interrupt(we->time, to);
+		else if (from && to && abs(from - to) == 1)
+			svg_wakeline(we->time, from, to);
+		else
+			svg_partial_wakeline(we->time, from, to);
+		we = we->next;
+	}
+}
+
+static void draw_cpu_usage(void)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct cpu_sample *sample;
+	p = all_data;
+	while (p) {
+		c = p->all;
+		while (c) {
+			sample = c->samples;
+			while (sample) {
+				if (sample->type == TYPE_RUNNING)
+					svg_process(sample->cpu, sample->start_time, sample->end_time, "sample", c->comm);
+
+				sample = sample->next;
+			}
+			c = c->next;
+		}
+		p = p->next;
+	}
+}
+
+static void draw_process_bars(void)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct cpu_sample *sample;
+	int Y = 0;
+
+	Y = 2 * numcpus + 2;
+
+	p = all_data;
+	while (p) {
+		c = p->all;
+		while (c) {
+			if (!c->display) {
+				c->Y = 0;
+				c = c->next;
+				continue;
+			}
+
+			svg_box(Y, p->start_time, p->end_time, "process");
+			sample = c->samples;
+			while (sample) {
+				if (sample->type == TYPE_RUNNING)
+					svg_sample(Y, sample->cpu, sample->start_time, sample->end_time, "sample");
+				if (sample->type == TYPE_BLOCKED)
+					svg_box(Y, sample->start_time, sample->end_time, "blocked");
+				if (sample->type == TYPE_WAITING)
+					svg_box(Y, sample->start_time, sample->end_time, "waiting");
+				sample = sample->next;
+			}
+
+			if (c->comm) {
+				char comm[256];
+				if (c->total_time > 5000000000) /* 5 seconds */
+					sprintf(comm, "%s:%i (%2.2fs)", c->comm, p->pid, c->total_time / 1000000000.0);
+				else
+					sprintf(comm, "%s:%i (%3.1fms)", c->comm, p->pid, c->total_time / 1000000.0);
+
+				svg_text(Y, c->start_time, comm);
+			}
+			c->Y = Y;
+			Y++;
+			c = c->next;
+		}
+		p = p->next;
+	}
+}
+
+static int determine_display_tasks(u64 threshold)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	int count = 0;
+
+	p = all_data;
+	while (p) {
+		p->display = 0;
+		if (p->start_time == 1)
+			p->start_time = first_time;
+
+		/* no exit marker, task kept running to the end */
+		if (p->end_time == 0)
+			p->end_time = last_time;
+		if (p->total_time >= threshold)
+			p->display = 1;
+
+		c = p->all;
+
+		while (c) {
+			c->display = 0;
+
+			if (c->start_time == 1)
+				c->start_time = first_time;
+
+			if (c->total_time >= threshold) {
+				c->display = 1;
+				count++;
+			}
+
+			if (c->end_time == 0)
+				c->end_time = last_time;
+
+			c = c->next;
+		}
+		p = p->next;
+	}
+	return count;
+}
+
+
+
+#define TIME_THRESH 10000000
+
+static void write_svg_file(const char *filename)
+{
+	u64 i;
+	int count;
+
+	numcpus++;
+
+
+	count = determine_display_tasks(TIME_THRESH);
+
+	/* We'd like to show at least 15 tasks; be less picky if we have fewer */
+	if (count < 15)
+		count = determine_display_tasks(TIME_THRESH / 10);
+
+	open_svg(filename, numcpus, count);
+
+	svg_time_grid(first_time, last_time);
+	svg_legenda();
+
+	for (i = 0; i < numcpus; i++)
+		svg_cpu_box(i, max_freq, turbo_frequency);
+
+	draw_cpu_usage();
+	draw_process_bars();
+	draw_c_p_states();
+	draw_wakeups();
+
+	svg_close();
+}
+
+static int
+process_event(event_t *event)
+{
+
+	switch (event->header.type) {
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event);
+	case PERF_EVENT_FORK:
+		return process_fork_event(event);
+	case PERF_EVENT_EXIT:
+		return process_exit_event(event);
+	case PERF_EVENT_SAMPLE:
+		return queue_sample_event(event);
+
+	/*
+	 * We dont process them right now but they are fine:
+	 */
+	case PERF_EVENT_MMAP:
+	case PERF_EVENT_THROTTLE:
+	case PERF_EVENT_UNTHROTTLE:
+		return 0;
+
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static void process_samples(void)
+{
+	struct sample_wrapper *cursor;
+	event_t *event;
+
+	sort_queued_samples();
+
+	cursor = all_samples;
+	while (cursor) {
+		event = (void *)&cursor->data;
+		cursor = cursor->next;
+		process_sample_event(event);
+	}
+}
+
+
+static int __cmd_timechart(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head, shift;
+	struct stat statbuf;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+	int input;
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		fprintf(stderr, " failed to open file: %s", input_name);
+		if (!strcmp(input_name, "perf.data"))
+			fprintf(stderr, "  (try 'perf record' first)");
+		fprintf(stderr, "\n");
+		exit(-1);
+	}
+
+	ret = fstat(input, &statbuf);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!statbuf.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	header = perf_header__read(input);
+	head = header->data_offset;
+
+	sample_type = perf_header__sample_type(header);
+
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		int ret2;
+
+		shift = page_size * (head / page_size);
+
+		ret2 = munmap(buf, page_size * mmap_window);
+		assert(ret2 == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	if (!size || process_event(event) < 0) {
+
+		printf("%p [%p]: skipping unknown header type: %d\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->header.type);
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head >= header->data_offset + header->data_size)
+		goto done;
+
+	if (offset + head < (unsigned long)statbuf.st_size)
+		goto more;
+
+done:
+	rc = EXIT_SUCCESS;
+	close(input);
+
+
+	process_samples();
+
+	end_sample_processing();
+
+	sort_pids();
+
+	write_svg_file(output_name);
+
+	printf("Written %2.1f seconds of trace to %s.\n", (last_time - first_time) / 1000000000.0, output_name);
+
+	return rc;
+}
+
+static const char * const report_usage[] = {
+	"perf report [<options>] <command>",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_STRING('o', "output", &output_name, "file",
+		    "output file name"),
+	OPT_END()
+};
+
+
+int cmd_timechart(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, options, report_usage, 0);
+
+	/*
+	 * Any (unrecognized) arguments left?
+	 */
+	if (argc)
+		usage_with_options(report_usage, options);
+
+	setup_pager();
+
+	return __cmd_timechart();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b09cadb..e11d8d2 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -21,6 +21,7 @@ extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_record(int argc, const char **argv, const char *prefix);
 extern int cmd_report(int argc, const char **argv, const char *prefix);
 extern int cmd_stat(int argc, const char **argv, const char *prefix);
+extern int cmd_timechart(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index c972d1c..19fc7fe 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -289,6 +289,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "record", cmd_record, 0 },
 		{ "report", cmd_report, 0 },
 		{ "stat", cmd_stat, 0 },
+		{ "timechart", cmd_timechart, 0 },
 		{ "top", cmd_top, 0 },
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2495529..018d414 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -39,6 +39,7 @@ struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
 	u32 tid, ptid;
+	u64 time;
 };
 
 struct lost_event {
@@ -59,6 +60,12 @@ struct read_event {
 	u64 id;
 };
 
+struct sample_event{
+	struct perf_event_header        header;
+	u64 array[];
+};
+
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -67,6 +74,7 @@ typedef union event_union {
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
+	struct sample_event		sample;
 } event_t;
 
 struct map {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ec4d4c2..ef91145 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -86,6 +86,44 @@ void perf_header__add_attr(struct perf_header *self,
 	self->attr[pos] = attr;
 }
 
+struct perf_trace_event_type {
+	u64	event_id;
+	char	name[64];
+};
+
+static int event_count;
+static struct perf_trace_event_type *events;
+
+void perf_header__push_event(u64 id, const char *name)
+{
+	if (strlen(name) > 64)
+		printf("Event %s will be truncated\n", name);
+
+	if (!events) {
+		events = malloc(sizeof(struct perf_trace_event_type));
+		if (!events)
+			die("nomem");
+	} else {
+		events = realloc(events, (event_count + 1) * sizeof(struct perf_trace_event_type));
+		if (!events)
+			die("nomem");
+	}
+	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
+	events[event_count].event_id = id;
+	strncpy(events[event_count].name, name, 63);
+	event_count++;
+}
+
+char *perf_header__find_event(u64 id)
+{
+	int i;
+	for (i = 0 ; i < event_count; i++) {
+		if (events[i].event_id == id)
+			return events[i].name;
+	}
+	return NULL;
+}
+
 static const char *__perf_magic = "PERFFILE";
 
 #define PERF_MAGIC	(*(u64 *)__perf_magic)
@@ -106,6 +144,7 @@ struct perf_file_header {
 	u64				attr_size;
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
+	struct perf_file_section	event_types;
 };
 
 static void do_write(int fd, void *buf, size_t size)
@@ -154,6 +193,11 @@ void perf_header__write(struct perf_header *self, int fd)
 		do_write(fd, &f_attr, sizeof(f_attr));
 	}
 
+	self->event_offset = lseek(fd, 0, SEEK_CUR);
+	self->event_size = event_count * sizeof(struct perf_trace_event_type);
+	if (events)
+		do_write(fd, events, self->event_size);
+
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
@@ -169,6 +213,10 @@ void perf_header__write(struct perf_header *self, int fd)
 			.offset = self->data_offset,
 			.size	= self->data_size,
 		},
+		.event_types = {
+			.offset = self->event_offset,
+			.size	= self->event_size,
+		},
 	};
 
 	lseek(fd, 0, SEEK_SET);
@@ -234,6 +282,17 @@ struct perf_header *perf_header__read(int fd)
 		lseek(fd, tmp, SEEK_SET);
 	}
 
+	if (f_header.event_types.size) {
+		lseek(fd, f_header.event_types.offset, SEEK_SET);
+		events = malloc(f_header.event_types.size);
+		if (!events)
+			die("nomem");
+		do_read(fd, events, f_header.event_types.size);
+		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
+	}
+	self->event_offset = f_header.event_types.offset;
+	self->event_size   = f_header.event_types.size;
+
 	self->data_offset = f_header.data.offset;
 	self->data_size   = f_header.data.size;
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 5d0a72e..7b0e84a 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -19,6 +19,8 @@ struct perf_header {
 	s64 attr_offset;
 	u64 data_offset;
 	u64 data_size;
+	u64 event_offset;
+	u64 event_size;
 };
 
 struct perf_header *perf_header__read(int fd);
@@ -27,6 +29,10 @@ void perf_header__write(struct perf_header *self, int fd);
 void perf_header__add_attr(struct perf_header *self,
 			   struct perf_header_attr *attr);
 
+void perf_header__push_event(u64 id, const char *name);
+char *perf_header__find_event(u64 id);
+
+
 struct perf_header_attr *
 perf_header_attr__new(struct perf_counter_attr *attr);
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 034245e..0efc405 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,6 +6,7 @@
 #include "exec_cmd.h"
 #include "string.h"
 #include "cache.h"
+#include "header.h"
 
 int					nr_counters;
 
@@ -684,11 +685,35 @@ modifier:
 	return ret;
 }
 
+static void store_event_type(const char *orgname)
+{
+	char filename[PATH_MAX], *c;
+	FILE *file;
+	int id;
+
+	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
+	c = strchr(filename, ':');
+	if (c)
+		*c = '/';
+
+	file = fopen(filename, "r");
+	if (!file)
+		return;
+	if (fscanf(file, "%i", &id) < 1)
+		die("cannot store event ID");
+	fclose(file);
+	perf_header__push_event(id, orgname);
+}
+
+
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_counter_attr attr;
 	enum event_result ret;
 
+	if (strchr(str, ':'))
+		store_event_type(str);
+
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 8aa3464..2ee248f 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -104,6 +104,8 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
+#define OPT_CALLBACK_NOOPT(s, l, v, a, h, f) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
 #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
new file mode 100644
index 0000000..c7a29af
--- /dev/null
+++ b/tools/perf/util/svghelper.c
@@ -0,0 +1,382 @@
+/*
+ * svghelper.c - helper functions for outputting svg
+ *
+ * (C) Copyright 2009 Intel Corporation
+ *
+ * Authors:
+ *     Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "svghelper.h"
+
+static u64 first_time, last_time;
+static u64 turbo_frequency, max_freq;
+
+
+#define SLOT_MULT 30.0
+#define SLOT_HEIGHT 25.0
+#define WIDTH 1000.0
+
+static u64 total_height;
+static FILE *svgfile;
+
+static double cpu2slot(int cpu)
+{
+	return 2 * cpu + 1;
+}
+
+static double cpu2y(int cpu)
+{
+	return cpu2slot(cpu) * SLOT_MULT;
+}
+
+static double time2pixels(u64 time)
+{
+	double X;
+
+	X = WIDTH * (time - first_time) / (last_time - first_time);
+	return X;
+}
+
+void open_svg(const char *filename, int cpus, int rows)
+{
+
+	svgfile = fopen(filename, "w");
+	if (!svgfile) {
+		fprintf(stderr, "Cannot open %s for output\n", filename);
+		return;
+	}
+	total_height = (1 + rows + cpu2slot(cpus)) * SLOT_MULT;
+	fprintf(svgfile, "<?xml version=\"1.0\" standalone=\"no\"?> \n");
+	fprintf(svgfile, "<svg width=\"%4.1f\" height=\"%llu\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n", WIDTH, total_height);
+
+	fprintf(svgfile, "<defs>\n  <style type=\"text/css\">\n    <![CDATA[\n");
+
+	fprintf(svgfile, "      rect          { stroke-width: 1; }\n");
+	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.waiting  { fill:rgb(255,255,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
+	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c1       { fill:rgb(255,214,214); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c2       { fill:rgb(255,172,172); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c3       { fill:rgb(255,130,130); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c4       { fill:rgb(255, 88, 88); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c5       { fill:rgb(255, 44, 44); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c6       { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      line.pstate   { stroke:rgb(255,255,  0); stroke-opacity:0.8; stroke-width:2; } \n");
+
+	fprintf(svgfile, "    ]]>\n   </style>\n</defs>\n");
+}
+
+void svg_box(int Yslot, u64 start, u64 end, const char *type)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
+}
+
+void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type)
+{
+	double text_size;
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
+
+	text_size = (time2pixels(end)-time2pixels(start));
+	if (cpu > 9)
+		text_size = text_size/2;
+	if (text_size > 1.25)
+		text_size = 1.25;
+	if (text_size > 0.0001)
+		fprintf(svgfile, "<text transform=\"translate(%1.6f,%1.6f)\" font-size=\"%1.6fpt\">%i</text>\n",
+			time2pixels(start), Yslot *  SLOT_MULT + SLOT_HEIGHT - 1, text_size,  cpu + 1);
+
+}
+
+static char *cpu_model(void)
+{
+	static char cpu_m[255];
+	char buf[256];
+	FILE *file;
+
+	cpu_m[0] = 0;
+	/* CPU type */
+	file = fopen("/proc/cpuinfo", "r");
+	if (file) {
+		while (fgets(buf, 255, file)) {
+			if (strstr(buf, "model name")) {
+				strncpy(cpu_m, &buf[13], 255);
+				break;
+			}
+		}
+		fclose(file);
+	}
+	return cpu_m;
+}
+
+void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
+{
+	char cpu_string[80];
+	if (!svgfile)
+		return;
+
+	max_freq = __max_freq;
+	turbo_frequency = __turbo_freq;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"cpu\"/>\n",
+		time2pixels(first_time),
+		time2pixels(last_time)-time2pixels(first_time),
+		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
+
+	sprintf(cpu_string, "CPU %i", (int)cpu+1);
+	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\">%s</text>\n",
+		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
+
+	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\" font-size=\"1.25pt\">%s</text>\n",
+		10+time2pixels(first_time), cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - 4, cpu_model());
+}
+
+void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name)
+{
+	double width;
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT, type);
+	width = time2pixels(end)-time2pixels(start);
+	if (width > 6)
+		width = 6;
+
+	if (width > 0.001)
+		fprintf(svgfile, "<text  transform=\"translate(%4.5f,%4.5f) rotate(90)\" font-size=\"%3.4fpt\">%s</text>\n",
+			time2pixels(start), cpu2y(cpu), width, name);
+}
+
+void svg_cstate(int cpu, u64 start, u64 end, int type)
+{
+	double width;
+	char style[128];
+
+	if (!svgfile)
+		return;
+
+
+	if (type > 6)
+		type = 6;
+	sprintf(style, "c%i", type);
+
+	fprintf(svgfile, "<rect class=\"%s\" x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\"/>\n",
+		style,
+		time2pixels(start), time2pixels(end)-time2pixels(start),
+		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
+
+	width = time2pixels(end)-time2pixels(start);
+	if (width > 6)
+		width = 6;
+
+	if (width > 0.05)
+		fprintf(svgfile, "<text  transform=\"translate(%4.5f,%4.5f) rotate(90)\" font-size=\"%3.4fpt\">C%i</text>\n",
+			time2pixels(start), cpu2y(cpu), width, type);
+}
+
+static char *HzToHuman(unsigned long hz)
+{
+	static char buffer[1024];
+	unsigned long long Hz;
+
+	memset(buffer, 0, 1024);
+
+	Hz = hz;
+
+	/* default: just put the Number in */
+	sprintf(buffer, "%9lli", Hz);
+
+	if (Hz > 1000)
+		sprintf(buffer, " %6lli Mhz", (Hz+500)/1000);
+
+	if (Hz > 1500000)
+		sprintf(buffer, " %6.2f Ghz", (Hz+5000.0)/1000000);
+
+	if (Hz == turbo_frequency)
+		sprintf(buffer, "Turbo");
+
+	return buffer;
+}
+
+void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
+{
+	double height = 0;
+
+	if (!svgfile)
+		return;
+
+	if (max_freq)
+		height = freq * 1.0 / max_freq * (SLOT_HEIGHT + SLOT_MULT);
+	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
+	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
+		time2pixels(start), time2pixels(end), height, height);
+	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\" font-size=\"0.25pt\">%s</text>\n",
+		time2pixels(start), height+0.9, HzToHuman(freq));
+
+}
+
+
+void svg_partial_wakeline(u64 start, int row1, int row2)
+{
+	double height;
+
+	if (!svgfile)
+		return;
+
+
+	if (row1 < row2) {
+		if (row1)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
+
+		if (row2)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
+	} else {
+		if (row2)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
+
+		if (row1)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
+	}
+	height = row1 * SLOT_MULT;
+	if (row2 > row1)
+		height += SLOT_HEIGHT;
+	if (row1)
+		fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+			time2pixels(start), height);
+}
+
+void svg_wakeline(u64 start, int row1, int row2)
+{
+	double height;
+
+	if (!svgfile)
+		return;
+
+
+	if (row1 < row2)
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT);
+	else
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT);
+
+	height = row1 * SLOT_MULT;
+	if (row2 > row1)
+		height += SLOT_HEIGHT;
+	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+			time2pixels(start), height);
+}
+
+void svg_interrupt(u64 start, int row)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+			time2pixels(start), row * SLOT_MULT);
+	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+			time2pixels(start), row * SLOT_MULT + SLOT_HEIGHT);
+}
+
+void svg_text(int Yslot, u64 start, const char *text)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\">%s</text>\n",
+		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
+}
+
+static void svg_legenda_box(int X, const char *text, const char *style)
+{
+	double boxsize;
+	boxsize = SLOT_HEIGHT / 2;
+
+	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+		X, boxsize, boxsize, style);
+	fprintf(svgfile, "<text transform=\"translate(%4.1f, %4.1f)\" font-size=\"%4.4fpt\">%s</text>\n",
+		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
+}
+
+void svg_legenda(void)
+{
+	if (!svgfile)
+		return;
+
+	svg_legenda_box(0,	"Running", "sample");
+	svg_legenda_box(100,	"Idle","rect.c1");
+	svg_legenda_box(200,	"Deeper Idle", "rect.c3");
+	svg_legenda_box(350,	"Deepest Idle", "rect.c6");
+	svg_legenda_box(550,	"Sleeping", "process2");
+	svg_legenda_box(650,	"Waiting for cpu", "waiting");
+	svg_legenda_box(800,	"Blocked on IO", "blocked");
+}
+
+void svg_time_grid(u64 start, u64 end)
+{
+	u64 i;
+
+	first_time = start;
+	last_time = end;
+
+	first_time = first_time / 100000000 * 100000000;
+
+	if (!svgfile)
+		return;
+
+	i = first_time;
+	while (i < last_time) {
+		int color = 220;
+		double thickness = 0.075;
+		if ((i % 100000000) == 0) {
+			thickness = 0.5;
+			color = 192;
+		}
+		if ((i % 1000000000) == 0) {
+			thickness = 2.0;
+			color = 128;
+		}
+
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%llu\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
+			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
+
+		i += 10000000;
+	}
+}
+
+void svg_close(void)
+{
+	if (svgfile) {
+		fprintf(svgfile, "</svg>\n");
+		fclose(svgfile);
+		svgfile = NULL;
+	}
+}
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
new file mode 100644
index 0000000..ad79b5d
--- /dev/null
+++ b/tools/perf/util/svghelper.h
@@ -0,0 +1,25 @@
+#ifndef _INCLUDE_GUARD_SVG_HELPER_
+#define _INCLUDE_GUARD_SVG_HELPER_
+
+#include "types.h"
+
+extern void open_svg(const char *filename, int cpus, int rows);
+extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
+extern void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type);
+extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
+
+
+extern void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name);
+extern void svg_cstate(int cpu, u64 start, u64 end, int type);
+extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
+
+
+extern void svg_time_grid(u64 start, u64 end);
+extern void svg_legenda(void);
+extern void svg_wakeline(u64 start, int row1, int row2);
+extern void svg_partial_wakeline(u64 start, int row1, int row2);
+extern void svg_interrupt(u64 start, int row);
+extern void svg_text(int Yslot, u64 start, const char *text);
+extern void svg_close(void);
+
+#endif



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
