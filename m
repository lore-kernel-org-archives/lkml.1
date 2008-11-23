Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYKWU6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYKWU6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYKWU6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:58:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:55039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYKWU6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:58:42 -0500
Date: Sun, 23 Nov 2008 12:59:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, rostedt@goodmis.org
Subject: [PATCH] ftrace: Add a C/P state tracer to help power optimization
Message-ID: <20081123125931.4afe16ca@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9625f8f58b86ddfd49351a252adce2ce85f6070c Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 3 Oct 2008 10:18:21 -0700
Subject: [PATCH] ftrace: Add a C/P state tracer to help power optimization

This patch adds a C/P-state ftrace plugin that will generate
detailed statistics about the C/P-states that are being used,
so that we can look at detailed decisions that the C/P-state
code is making, rather than the too high level "average"
that we have today.

An example way of using this is:
mount -t debugfs none /sys/kernel/debug
echo cstate > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_enabled
sleep 1
echo 0 > /sys/kernel/debug/tracing/tracing_enabled
cat /sys/kernel/debug/tracing/trace | perl scripts/trace/cstate.pl > out.svg

Impact: New code
Impact: Minor additions to existing code

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 +
 arch/x86/kernel/process.c                  |   16 +++
 include/linux/ftrace.h                     |   29 +++++
 kernel/trace/Kconfig                       |   11 ++
 kernel/trace/Makefile                      |    1 +
 kernel/trace/trace.h                       |    7 +
 kernel/trace/trace_power.c                 |  184 ++++++++++++++++++++++++++++
 7 files changed, 252 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_power.c

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 8e48c5d..88ea02d 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,6 +33,7 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
+#include <linux/ftrace.h>
 
 #include <linux/acpi.h>
 #include <acpi/processor.h>
@@ -391,6 +392,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
 	int result = 0;
+	struct power_trace it;
 
 	dprintk("acpi_cpufreq_target %d (%d)\n", target_freq, policy->cpu);
 
@@ -427,6 +429,8 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
+	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
+
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c622772..c27af49 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
+#include <linux/ftrace.h>
 #include <asm/system.h>
 
 unsigned long idle_halt;
@@ -100,6 +101,9 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
+		struct power_trace it;
+
+		trace_power_start(&it, POWER_CSTATE, 1);
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -112,6 +116,7 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
+		trace_power_end(&it);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -154,24 +159,31 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
+	struct power_trace it;
+
+	trace_power_start(&it, POWER_CSTATE, (ax>>4)+1);
 	if (!need_resched()) {
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
+	trace_power_end(&it);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
+	struct power_trace it;
 	if (!need_resched()) {
+		trace_power_start(&it, POWER_CSTATE, 1);
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
+		trace_power_end(&it);
 	} else
 		local_irq_enable();
 }
@@ -183,9 +195,13 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
+	struct power_trace it;
+
+	trace_power_start(&it, POWER_CSTATE, 0);
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
+	trace_power_end(&it);
 }
 
 /*
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 703eb53..573095b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -248,6 +248,35 @@ static inline void start_boot_trace(void) { }
 static inline void stop_boot_trace(void) { }
 #endif
 
+enum {
+	POWER_NONE = 0,
+	POWER_CSTATE = 1,
+	POWER_PSTATE = 2,
+};
+
+struct power_trace {
+#ifdef CONFIG_POWER_TRACER
+	ktime_t			stamp;
+	ktime_t			end;
+	int			type;
+	int			state;
+#endif
+};
+
+#ifdef CONFIG_POWER_TRACER
+extern void trace_power_start(struct power_trace *it, unsigned int type,
+					unsigned int state);
+extern void trace_power_mark(struct power_trace *it, unsigned int type,
+					unsigned int state);
+extern void trace_power_end(struct power_trace *it);
+#else
+static inline void trace_power_start(struct power_trace *it, unsigned int type,
+					unsigned int state) { }
+static inline void trace_power_mark(struct power_trace *it, unsigned int type,
+					unsigned int state) { }
+static inline void trace_power_end(struct power_trace *it) { }
+#endif
+
 
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 33dbefd..f5f2363 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -138,6 +138,17 @@ config BOOT_TRACER
 	    selected, because the self-tests are an initcall as well and that
 	    would invalidate the boot trace. )
 
+config POWER_TRACER
+	bool "Trace power consumption behavior"
+	depends on DEBUG_KERNEL
+	depends on X86
+	select TRACING
+	help
+	  This tracer helps developers to analyze and optimize the kernels
+	  power management decisions, specifically the C-state and P-state
+	  behavior.
+
+
 config STACK_TRACER
 	bool "Trace max stack"
 	depends on HAVE_FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c8228b1..917b42e 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_POWER_TRACER) += trace_power.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8465ad0..77cc01c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_POWER,
 
 	__TRACE_LAST_TYPE
 };
@@ -117,6 +118,11 @@ struct trace_boot {
 	struct boot_trace	initcall;
 };
 
+struct trace_power {
+	struct trace_entry	ent;
+	struct power_trace	state_data;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -219,6 +225,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
new file mode 100644
index 0000000..db51f3f
--- /dev/null
+++ b/kernel/trace/trace_power.c
@@ -0,0 +1,184 @@
+/*
+ * ring buffer based C-state tracer
+ *
+ * Arjan van de Ven <arjan@linux.intel.com>
+ * Copyright (C) 2008 Intel Corporation
+ *
+ * Much is borrowed from trace_boot.c which is
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+
+#include "trace.h"
+
+static struct trace_array *power_trace;
+static int __read_mostly trace_power_enabled;
+
+
+static void start_power_trace(void)
+{
+	trace_power_enabled = 1;
+}
+
+static void stop_power_trace(struct trace_array *tr)
+{
+	trace_power_enabled = 0;
+}
+
+static void power_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	power_trace = tr;
+
+	trace_power_enabled = 1;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+}
+
+static void power_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_power_trace();
+	else
+		stop_power_trace(tr);
+}
+
+static enum print_line_t power_print_line(struct trace_iterator *iter)
+{
+	int ret = 0;
+	struct trace_entry *entry = iter->ent;
+	struct trace_power *field ;
+	struct power_trace *it;
+	struct trace_seq *s = &iter->seq;
+	struct timespec stamp;
+	struct timespec duration;
+
+	trace_assign_type(field, entry);
+	it = &field->state_data;
+	stamp = ktime_to_timespec(it->stamp);
+	duration = ktime_to_timespec(ktime_sub(it->end, it->stamp));
+
+	if (entry->type == TRACE_POWER) {
+		if (it->type == POWER_CSTATE)
+			ret = trace_seq_printf(s, "[%5ld.%09ld] CSTATE: Going to C%i on cpu %i for %ld.%09ld\n",
+					  stamp.tv_sec,
+					  stamp.tv_nsec,
+					  it->state, iter->cpu,
+					  duration.tv_sec,
+					  duration.tv_nsec);
+		if (it->type == POWER_PSTATE)
+			ret = trace_seq_printf(s, "[%5ld.%09ld] PSTATE: Going to P%i on cpu %i\n",
+					  stamp.tv_sec,
+					  stamp.tv_nsec,
+					  it->state, iter->cpu);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static struct tracer power_tracer __read_mostly =
+{
+	.name		= "power",
+	.init		= power_trace_init,
+	.reset		= stop_power_trace,
+	.ctrl_update	= power_trace_ctrl_update,
+	.print_line	= power_print_line,
+};
+
+static int init_power_trace(void)
+{
+	return register_tracer(&power_tracer);
+}
+device_initcall(init_power_trace);
+
+void trace_power_start(struct power_trace *it, unsigned int type,
+			 unsigned int level)
+{
+	if (!trace_power_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct power_trace));
+	it->state = level;
+	it->type = type;
+	it->stamp = ktime_get();
+}
+EXPORT_SYMBOL_GPL(trace_power_start);
+
+
+void trace_power_end(struct power_trace *it)
+{
+	struct ring_buffer_event *event;
+	struct trace_power *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = power_trace;
+
+	if (!trace_power_enabled)
+		return;
+
+	preempt_disable();
+	it->end = ktime_get();
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_POWER;
+	entry->state_data = *it;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+
+ out:
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(trace_power_end);
+
+void trace_power_mark(struct power_trace *it, unsigned int type,
+			 unsigned int level)
+{
+	struct ring_buffer_event *event;
+	struct trace_power *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = power_trace;
+
+	if (!trace_power_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct power_trace));
+	it->state = level;
+	it->type = type;
+	it->stamp = ktime_get();
+	preempt_disable();
+	it->end = it->stamp;
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_POWER;
+	entry->state_data = *it;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+
+ out:
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(trace_power_mark);
-- 
1.6.0.3



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
