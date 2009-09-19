Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZISJxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZISJxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175AbZISJxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:53:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018AbZISJxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:53:05 -0400
Date: Sat, 19 Sep 2009 09:52:32 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090912130542.6d314860@infradead.org>
References: <20090912130542.6d314860@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] tracing, perf: Convert the power tracer into an event tracer
Message-ID: <tip-6161352142d5fed4cd753b32e5ccde66e705b14e@git.kernel.org>
Git-Commit-ID: 6161352142d5fed4cd753b32e5ccde66e705b14e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 09:52:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6161352142d5fed4cd753b32e5ccde66e705b14e
Gitweb:     http://git.kernel.org/tip/6161352142d5fed4cd753b32e5ccde66e705b14e
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Thu, 17 Sep 2009 16:11:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 11:42:12 +0200

tracing, perf: Convert the power tracer into an event tracer

This patch converts the existing power tracer into an event tracer,
so that power events (C states and frequency changes) can be
tracked via "perf".

This also removes the perl script that was used to demo the tracer;
its functionality is being replaced entirely with timechart.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090912130542.6d314860@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/trace/power.txt              |   17 --
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    7 +-
 arch/x86/kernel/process.c                  |   28 +---
 include/trace/events/power.h               |   81 ++++++++++
 kernel/trace/Makefile                      |    2 +-
 kernel/trace/power-traces.c                |   20 +++
 kernel/trace/trace.h                       |    3 -
 kernel/trace/trace_entries.h               |   17 --
 kernel/trace/trace_power.c                 |  218 ----------------------------
 scripts/tracing/power.pl                   |  108 --------------
 10 files changed, 113 insertions(+), 388 deletions(-)

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
index 071166a..7b60e39 100644
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
@@ -25,9 +25,6 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
-DEFINE_TRACE(power_start);
-DEFINE_TRACE(power_end);
-
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
@@ -299,9 +296,7 @@ static inline int hlt_use_halt(void)
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
@@ -314,7 +309,7 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(&it);
+		trace_power_end(0);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -372,9 +367,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
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
@@ -384,15 +377,14 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
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
 
@@ -402,7 +394,7 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end(&it);
+		trace_power_end(0);
 	} else
 		local_irq_enable();
 }
@@ -414,13 +406,11 @@ static void mwait_idle(void)
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
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 844164d..26f03ac 100644
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
@@ -54,5 +53,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += power-traces.o
 
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
index 86bcff9..405cb85 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -11,7 +11,6 @@
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
-#include <trace/power.h>
 
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
@@ -37,7 +36,6 @@ enum trace_type {
 	TRACE_HW_BRANCHES,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
-	TRACE_POWER,
 	TRACE_BLK,
 
 	__TRACE_LAST_TYPE,
@@ -207,7 +205,6 @@ extern void __ftrace_bad_type(void);
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
