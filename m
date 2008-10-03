Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYJCXzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYJCXzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYJCXzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:55:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:54035 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYJCXzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:55:42 -0400
Date: Fri, 3 Oct 2008 16:55:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: Add a C-state tracer to help power optimization
Message-ID: <20081003165533.249261b1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 3 Oct 2008 10:18:21 -0700
Subject: [PATCH] ftrace: Add a C-state tracer to help power optimization

This patch adds a C-state ftrace plugin that will generate
detailed statistics about the C-states that are being used,
so that we can look at detailed decisions that the C-state
code is making, rather than the too high level "average"
that we have today.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/process.c   |    9 +++
 include/linux/ftrace.h      |   13 +++++
 kernel/trace/Kconfig        |   11 ++++
 kernel/trace/Makefile       |    1 +
 kernel/trace/trace.h        |    5 ++
 kernel/trace/trace_cstate.c |  123 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 162 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_cstate.c

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3468131..68c7234 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
+#include <linux/ftrace.h>
 #include <asm/system.h>
 
 unsigned long idle_halt;
@@ -100,6 +101,8 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
+		struct cstate_trace it;
+		it.stamp = ktime_get();
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -112,6 +115,8 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
+		it.end = ktime_get();
+		trace_cstate(&it, 1);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -154,12 +159,16 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
+	struct cstate_trace it;
+	it.stamp = ktime_get();
 	if (!need_resched()) {
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
+	it.end = ktime_get();
+	trace_cstate(&it, (ax>>4)+1);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 91954eb..e6b4da6 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -226,6 +226,19 @@ static inline void trace_boot(struct boot_trace *it) { }
 static inline void start_boot_trace(void) { }
 #endif
 
+struct cstate_trace {
+	ktime_t			stamp;
+	ktime_t			end;
+	int			state;
+	int			CPU;
+};
+
+#ifdef CONFIG_CSTATE_TRACER
+extern void trace_cstate(struct cstate_trace *it, int state);
+#else
+static inline void trace_cstate(struct cstate_trace *it, int state) { }
+#endif
+
 
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 396aea1..fa2347a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -134,6 +134,17 @@ config BOOT_TRACER
 	  be enabled if this tracer is selected since only one tracer
 	  should touch the tracing buffer at a time.
 
+config CSTATE_TRACER
+	bool "Trace C-state behavior"
+	depends on HAVE_FTRACE
+	depends on DEBUG_KERNEL
+	depends on X86
+	select TRACING
+	help
+	  This tracer helps developers to analyize and optimize the kernels
+	  power management decisions, specifically the C-state behavior.
+
+
 config STACK_TRACER
 	bool "Trace max stack"
 	depends on HAVE_FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index a85dfba..2b85724 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_CSTATE_TRACER) += trace_cstate.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a921ba5..1ef1ded 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -117,6 +117,11 @@ struct trace_boot {
 	struct boot_trace	initcall;
 };
 
+struct trace_cstate {
+	struct trace_entry	ent;
+	struct cstate_trace	state_data;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
diff --git a/kernel/trace/trace_cstate.c b/kernel/trace/trace_cstate.c
new file mode 100644
index 0000000..fcd4e6e
--- /dev/null
+++ b/kernel/trace/trace_cstate.c
@@ -0,0 +1,123 @@
+/*
+ * ring buffer based C-state tracer
+ *
+ * Arjan van de Ven <arjan@linux.intel.com>
+ * Copyright (C) 2009 Intel Corporation
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
+
+#include "trace.h"
+
+static struct trace_array *cstate_trace;
+static int trace_cstate_enabled;
+
+
+/* Should be started after do_pre_smp_initcalls() in init/main.c */
+static void start_cstate_trace(void)
+{
+	trace_cstate_enabled = 1;
+}
+
+void stop_cstate_trace(struct trace_array *tr)
+{
+	trace_cstate_enabled = 0;
+}
+
+static void cstate_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	cstate_trace = tr;
+
+	trace_cstate_enabled = 1;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+}
+
+static void cstate_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_cstate_trace();
+	else
+		stop_cstate_trace(tr);
+}
+
+static enum print_line_t cstate_print_line(struct trace_iterator *iter)
+{
+	int ret;
+	struct trace_entry *entry = iter->ent;
+	struct trace_cstate *field = (struct trace_cstate *)entry;
+	struct cstate_trace *it = &field->state_data;
+	struct trace_seq *s = &iter->seq;
+	struct timespec stamp = ktime_to_timespec(it->stamp);
+	struct timespec duration = ktime_to_timespec(
+					ktime_sub(it->end, it->stamp));
+
+	if (entry->type == TRACE_BOOT) {
+		ret = trace_seq_printf(s, "[%5ld.%09ld] Going to C%i on cpu %i for %ld.%09ld\n",
+					  stamp.tv_sec,
+					  stamp.tv_nsec,
+					  it->state, it->CPU,
+					  duration.tv_sec,
+					  duration.tv_nsec);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+struct tracer cstate_tracer __read_mostly =
+{
+	.name		= "cstate",
+	.init		= cstate_trace_init,
+	.reset		= stop_cstate_trace,
+	.ctrl_update	= cstate_trace_ctrl_update,
+	.print_line	= cstate_print_line,
+};
+
+static int init_cstate_trace(void)
+{
+	return register_tracer(&cstate_tracer);
+}
+device_initcall(init_cstate_trace);
+
+void trace_cstate(struct cstate_trace *it, int level)
+{
+	struct ring_buffer_event *event;
+	struct trace_cstate *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = cstate_trace;
+
+	if (!trace_cstate_enabled)
+		return;
+
+	it->state = level;
+	preempt_disable();
+	it->CPU = smp_processor_id();
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0);
+	entry->ent.type = TRACE_BOOT;
+	entry->state_data = *it;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+
+ out:
+	preempt_enable();
+}
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
