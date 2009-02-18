Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZBRTzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZBRTzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBRTys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:54:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZBRTyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:54:46 -0500
Date: Wed, 18 Feb 2009 14:53:28 -0500
From: Jason Baron <jbaron@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
       fche@redhat.com, peterz@infradead.org, compudj@krystal.dyndns.org
Subject: [PATCH] new irq tracer
Message-ID: <20090218195328.GA3112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Using a copule of tracepoints i've implemented an 'irq tracer' which has
the following column format:

[time][irq][action][handled][cpu][length]

for example on my system:

[ 1038.927248381]     28     eth0      1        3     0.000002745
[ 1038.927544688]     28     eth0      1        3     0.000002520
[ 1038.927593609]     28     eth0      1        3     0.000002509
[ 1038.974087675]     29     ahci      1        1     0.000013135
[ 1038.974288475]     29     ahci      1        1     0.000005542
[ 1038.974414324]     29     ahci      1        1     0.000007953

I think this patch is useful in understanding irq system behavior, and
for tracking down irq driver handlers that are firing too often or
spending too much time handling an irq. This approach could be extended
to the timer irq and for softirqs...

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>


---

 include/trace/irq.h      |   24 +++++++
 kernel/irq/handle.c      |    6 ++
 kernel/trace/Kconfig     |    7 ++
 kernel/trace/Makefile    |    1 
 kernel/trace/trace.h     |    8 ++
 kernel/trace/trace_irq.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 197 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/irq.h
 create mode 100644 kernel/trace/trace_irq.c


diff --git a/include/trace/irq.h b/include/trace/irq.h
new file mode 100644
index 0000000..e4669c2
--- /dev/null
+++ b/include/trace/irq.h
@@ -0,0 +1,24 @@
+#ifndef _TRACE_IRQ_H
+#define _TRACE_IRQ_H
+
+#include <linux/interrupt.h>
+#include <linux/tracepoint.h>
+
+struct irq_trace {
+	int retval;
+	int irq;
+	const char *name;
+	int cpu;
+	int handled;
+	struct timespec duration;
+	struct timespec start_time;
+};
+
+DECLARE_TRACE(irq_entry,
+	TPPROTO(unsigned int id),
+	TPARGS(id));
+DECLARE_TRACE(irq_exit,
+	TPPROTO(unsigned int id, irqreturn_t retval),
+	TPARGS(id, retval));
+
+#endif /* _TRACE_IRQ_H */
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index fdff380..34053b5 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,6 +18,7 @@
 #include <linux/rculist.h>
 #include <linux/hash.h>
 #include <linux/bootmem.h>
+#include <trace/irq.h>
 
 #include "internals.h"
 
@@ -338,6 +339,9 @@ irqreturn_t no_action(int cpl, void *dev_id)
 	return IRQ_NONE;
 }
 
+DEFINE_TRACE(irq_entry);
+DEFINE_TRACE(irq_exit);
+
 /**
  * handle_IRQ_event - irq action chain handler
  * @irq:	the interrupt number
@@ -354,7 +358,9 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 		local_irq_enable_in_hardirq();
 
 	do {
+		trace_irq_entry(irq);
 		ret = action->handler(irq, action->dev_id);
+		trace_irq_exit(irq, ret);
 		if (ret == IRQ_HANDLED)
 			status |= action->flags;
 		retval |= ret;
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 620f9cd..f62165c 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -239,6 +239,13 @@ config POWER_TRACER
 	  power management decisions, specifically the C-state and P-state
 	  behavior.
 
+config IRQ_TRACER
+	bool "Trace irq latencies"
+	depends on DEBUG_KERNEL
+	depends on X86
+	select TRACING
+	help
+	  This tracer helps developers anaylze irq latencies.
 
 config STACK_TRACER
 	bool "Trace max stack"
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 627090b..58b9f7e 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -38,5 +38,6 @@ obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+obj-$(CONFIG_IRQ_TRACER) += trace_irq.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dbff020..6a34aaa 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -11,6 +11,7 @@
 #include <trace/boot.h>
 #include <trace/kmemtrace.h>
 #include <trace/power.h>
+#include <trace/irq.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -33,6 +34,7 @@ enum trace_type {
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
+	TRACE_IRQ,
 	TRACE_BLK,
 
 	__TRACE_LAST_TYPE,
@@ -173,6 +175,11 @@ struct trace_power {
 	struct power_trace	state_data;
 };
 
+struct trace_irq {
+	struct trace_entry	ent;
+	struct irq_trace	irq_data;
+};
+
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
 	enum kmemtrace_type_id type_id;
@@ -298,6 +305,7 @@ extern void __ftrace_bad_type(void);
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
  		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
+		IF_ASSIGN(var, ent, struct trace_irq, TRACE_IRQ);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
diff --git a/kernel/trace/trace_irq.c b/kernel/trace/trace_irq.c
new file mode 100644
index 0000000..1808316
--- /dev/null
+++ b/kernel/trace/trace_irq.c
@@ -0,0 +1,151 @@
+/*
+ * Copyright (C) 2009 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
+ */
+
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <trace/irq.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/ktime.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+static struct trace_array *irq_trace;
+static int __read_mostly trace_irq_enabled;
+static ktime_t start_times[NR_IRQS];
+
+static void probe_irq_entry(unsigned int irq)
+{
+	if (!trace_irq_enabled)
+		return;
+	start_times[irq] = ktime_get();
+}
+
+static void probe_irq_exit(unsigned int irq, irqreturn_t retval)
+{
+	struct ring_buffer_event *event;
+	struct trace_irq *entry;
+	struct trace_array *tr = irq_trace;
+	struct irq_desc *desc;
+	ktime_t end_time;
+
+	if (!trace_irq_enabled)
+		return;
+	end_time = ktime_get();
+	desc = irq_to_desc(irq);
+	event = trace_buffer_lock_reserve(tr, TRACE_IRQ,
+					  sizeof(*entry), 0, 0);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->irq_data.retval = retval;
+	entry->irq_data.name = desc->action->name;
+	entry->irq_data.irq = irq;
+	entry->irq_data.cpu = raw_smp_processor_id();
+	if (retval == IRQ_HANDLED)
+		entry->irq_data.handled = 1;
+	else
+		entry->irq_data.handled = 0;
+	entry->irq_data.duration =
+		ktime_to_timespec(ktime_sub(end_time, start_times[irq]));
+	entry->irq_data.start_time = ktime_to_timespec(start_times[irq]);
+	trace_buffer_unlock_commit(tr, event, 0, 0);
+ out:
+	preempt_enable();
+}
+
+static int tracing_irq_register(void)
+{
+	int ret;
+
+	ret = register_trace_irq_entry(probe_irq_entry);
+	if (ret) {
+		pr_info("irq trace: irq entry tracepoint failed to register\n");
+		return ret;
+	}
+	ret = register_trace_irq_exit(probe_irq_exit);
+	if (ret) {
+		pr_info("irq trace: irq exit tracepoint failed to register\n");
+		goto fail_exit;
+	}
+	return ret;
+fail_exit:
+	unregister_trace_irq_entry(probe_irq_entry);
+	return ret;
+}
+
+static void start_irq_trace(struct trace_array *tr)
+{
+	trace_irq_enabled = 1;
+	tracing_irq_register();
+}
+
+static void stop_irq_trace(struct trace_array *tr)
+{
+	trace_irq_enabled = 0;
+	unregister_trace_irq_entry(probe_irq_entry);
+	unregister_trace_irq_exit(probe_irq_exit);
+}
+
+
+static int irq_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	irq_trace = tr;
+
+	trace_irq_enabled = 1;
+	tracing_irq_register();
+	for_each_cpu(cpu, cpu_possible_mask)
+		tracing_reset(tr, cpu);
+	return 0;
+}
+
+static enum print_line_t irq_print_line(struct trace_iterator *iter)
+{
+	int ret = 0;
+	struct trace_entry *entry = iter->ent;
+	struct trace_irq *field;
+	struct irq_trace *it;
+	struct trace_seq *s = &iter->seq;
+
+	trace_assign_type(field, entry);
+	it = &field->irq_data;
+	if (entry->type == TRACE_IRQ) {
+		ret = trace_seq_printf(s, "[%5ld.%09ld]     %d     %s      %d        %d     %ld.%09ld\n",
+					it->start_time.tv_sec,
+					it->start_time.tv_nsec,
+					it->irq, it->name, it->handled, it->cpu,
+					it->duration.tv_sec,
+					it->duration.tv_nsec);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void irq_print_headers(struct seq_file *s)
+{
+	seq_printf(s, "      [time]         [irq] [action] [handled] [cpu] [length]\n");
+	seq_printf(s, "         |             |      |        |        |       |   \n\n");
+}
+
+static struct tracer irq_tracer __read_mostly =
+{
+	.name		= "irq",
+	.init		= irq_trace_init,
+	.start		= start_irq_trace,
+	.stop		= stop_irq_trace,
+	.reset		= stop_irq_trace,
+	.print_header	= irq_print_headers,
+	.print_line	= irq_print_line,
+};
+
+static int init_irq_trace(void)
+{
+	return register_tracer(&irq_tracer);
+}
+device_initcall(init_irq_trace);

