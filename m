Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYLKMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYLKMxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbYLKMxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:53:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:22231 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbYLKMxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:53:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,753,1220252400"; 
   d="scan'208";a="413536156"
Date: Thu, 11 Dec 2008 13:53:26 +0100
From: Markus Metzger <markut.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, eranian@googlemail.com
Subject: [patch 3/3] x86, bts, ftrace: adapt the hw-branch-tracer to the ds.c interface
Message-ID: <20081211135326.A13769@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove BTS bits from the hw-branch-tracer (renamed from bts-tracer) and use the ds interface.

Signed-off-by: Markus Metzger <markut.t.metzger@intel.com>
---

Index: gits/kernel/trace/trace_bts.c
===================================================================
--- gits.orig/kernel/trace/trace_bts.c	2008-12-11 10:45:12.000000000 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,276 +0,0 @@
-/*
- * BTS tracer
- *
- * Copyright (C) 2008 Markus Metzger <markus.t.metzger@gmail.com>
- *
- */
-
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/debugfs.h>
-#include <linux/ftrace.h>
-#include <linux/kallsyms.h>
-
-#include <asm/ds.h>
-
-#include "trace.h"
-
-
-#define SIZEOF_BTS (1 << 13)
-
-static DEFINE_PER_CPU(struct bts_tracer *, tracer);
-static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
-
-#define this_tracer per_cpu(tracer, smp_processor_id())
-#define this_buffer per_cpu(buffer, smp_processor_id())
-
-
-/*
- * Information to interpret a BTS record.
- * This will go into an in-kernel BTS interface.
- */
-static unsigned char sizeof_field;
-static unsigned long debugctl_mask;
-
-#define sizeof_bts (3 * sizeof_field)
-
-static void bts_trace_cpuinit(struct cpuinfo_x86 *c)
-{
-	switch (c->x86) {
-	case 0x6:
-		switch (c->x86_model) {
-		case 0x0 ... 0xC:
-			break;
-		case 0xD:
-		case 0xE: /* Pentium M */
-			sizeof_field = sizeof(long);
-			debugctl_mask = (1<<6)|(1<<7);
-			break;
-		default:
-			sizeof_field = 8;
-			debugctl_mask = (1<<6)|(1<<7);
-			break;
-		}
-		break;
-	case 0xF:
-		switch (c->x86_model) {
-		case 0x0:
-		case 0x1:
-		case 0x2: /* Netburst */
-			sizeof_field = sizeof(long);
-			debugctl_mask = (1<<2)|(1<<3);
-			break;
-		default:
-			/* sorry, don't know about them */
-			break;
-		}
-		break;
-	default:
-		/* sorry, don't know about them */
-		break;
-	}
-}
-
-static inline void bts_enable(void)
-{
-	unsigned long debugctl;
-
-	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl | debugctl_mask);
-}
-
-static inline void bts_disable(void)
-{
-	unsigned long debugctl;
-
-	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl & ~debugctl_mask);
-}
-
-static void bts_trace_reset(struct trace_array *tr)
-{
-	int cpu;
-
-	tr->time_start = ftrace_now(tr->cpu);
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-}
-
-static void bts_trace_start_cpu(void *arg)
-{
-	this_tracer =
-		ds_request_bts(/* task = */ NULL, this_buffer, SIZEOF_BTS,
-			       /* ovfl = */ NULL, /* th = */ (size_t)-1);
-	if (IS_ERR(this_tracer)) {
-		this_tracer = NULL;
-		return;
-	}
-
-	bts_enable();
-}
-
-static void bts_trace_start(struct trace_array *tr)
-{
-	int cpu;
-
-	bts_trace_reset(tr);
-
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
-}
-
-static void bts_trace_stop_cpu(void *arg)
-{
-	if (this_tracer) {
-		bts_disable();
-
-		ds_release_bts(this_tracer);
-		this_tracer = NULL;
-	}
-}
-
-static void bts_trace_stop(struct trace_array *tr)
-{
-	int cpu;
-
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
-}
-
-static int bts_trace_init(struct trace_array *tr)
-{
-	bts_trace_cpuinit(&boot_cpu_data);
-	bts_trace_reset(tr);
-	bts_trace_start(tr);
-
-	return 0;
-}
-
-static void bts_trace_print_header(struct seq_file *m)
-{
-#ifdef __i386__
-	seq_puts(m, "# CPU#    FROM           TO     FUNCTION\n");
-	seq_puts(m, "#  |       |             |         |\n");
-#else
-	seq_puts(m,
-		 "# CPU#        FROM                   TO         FUNCTION\n");
-	seq_puts(m,
-		 "#  |           |                     |             |\n");
-#endif
-}
-
-static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
-{
-	struct trace_entry *entry = iter->ent;
-	struct trace_seq *seq = &iter->seq;
-	struct bts_entry *it;
-
-	trace_assign_type(it, entry);
-
-	if (entry->type == TRACE_BTS) {
-		int ret;
-#ifdef CONFIG_KALLSYMS
-		char function[KSYM_SYMBOL_LEN];
-		sprint_symbol(function, it->from);
-#else
-		char *function = "<unknown>";
-#endif
-
-		ret = trace_seq_printf(seq, "%4d  0x%lx -> 0x%lx [%s]\n",
-				       entry->cpu, it->from, it->to, function);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;;
-		return TRACE_TYPE_HANDLED;
-	}
-	return TRACE_TYPE_UNHANDLED;
-}
-
-void trace_bts(struct trace_array *tr, unsigned long from, unsigned long to)
-{
-	struct ring_buffer_event *event;
-	struct bts_entry *entry;
-	unsigned long irq;
-
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0, from);
-	entry->ent.type = TRACE_BTS;
-	entry->ent.cpu = smp_processor_id();
-	entry->from = from;
-	entry->to   = to;
-	ring_buffer_unlock_commit(tr->buffer, event, irq);
-}
-
-static void trace_bts_at(struct trace_array *tr, size_t index)
-{
-	const void *raw = NULL;
-	unsigned long from, to;
-	int err;
-
-	err = ds_access_bts(this_tracer, index, &raw);
-	if (err < 0)
-		return;
-
-	from = *(const unsigned long *)raw;
-	to = *(const unsigned long *)((const char *)raw + sizeof_field);
-
-	trace_bts(tr, from, to);
-}
-
-static void trace_bts_cpu(void *arg)
-{
-	struct trace_array *tr = (struct trace_array *) arg;
-	size_t index = 0, end = 0, i;
-	int err;
-
-	if (!this_tracer)
-		return;
-
-	bts_disable();
-
-	err = ds_get_bts_index(this_tracer, &index);
-	if (err < 0)
-		goto out;
-
-	err = ds_get_bts_end(this_tracer, &end);
-	if (err < 0)
-		goto out;
-
-	for (i = index; i < end; i++)
-		trace_bts_at(tr, i);
-
-	for (i = 0; i < index; i++)
-		trace_bts_at(tr, i);
-
-out:
-	bts_enable();
-}
-
-static void trace_bts_prepare(struct trace_iterator *iter)
-{
-	int cpu;
-
-	for_each_cpu_mask(cpu, cpu_possible_map)
-		smp_call_function_single(cpu, trace_bts_cpu, iter->tr, 1);
-}
-
-struct tracer bts_tracer __read_mostly =
-{
-	.name		= "bts",
-	.init		= bts_trace_init,
-	.reset		= bts_trace_stop,
-	.print_header	= bts_trace_print_header,
-	.print_line	= bts_trace_print_line,
-	.start		= bts_trace_start,
-	.stop		= bts_trace_stop,
-	.open		= trace_bts_prepare
-};
-
-__init static int init_bts_trace(void)
-{
-	return register_tracer(&bts_tracer);
-}
-device_initcall(init_bts_trace);
Index: gits/kernel/trace/trace_hw_branches.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ gits/kernel/trace/trace_hw_branches.c	2008-12-11 11:21:19.000000000 +0100
@@ -0,0 +1,205 @@
+/*
+ * h/w branch tracer for x86 based on bts
+ *
+ * Copyright (C) 2008 Markus Metzger <markus.t.metzger@gmail.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <linux/kallsyms.h>
+
+#include <asm/ds.h>
+
+#include "trace.h"
+
+
+#define SIZEOF_BTS (1 << 13)
+
+static DEFINE_PER_CPU(struct bts_tracer *, tracer);
+static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
+
+#define this_tracer per_cpu(tracer, smp_processor_id())
+#define this_buffer per_cpu(buffer, smp_processor_id())
+
+
+static void bts_trace_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
+static void bts_trace_start_cpu(void *arg)
+{
+	if (this_tracer)
+		ds_release_bts(this_tracer);
+
+	this_tracer =
+		ds_request_bts(/* task = */ NULL, this_buffer, SIZEOF_BTS,
+			       /* ovfl = */ NULL, /* th = */ (size_t)-1,
+			       BTS_KERNEL);
+	if (IS_ERR(this_tracer)) {
+		this_tracer = NULL;
+		return;
+	}
+}
+
+static void bts_trace_start(struct trace_array *tr)
+{
+	int cpu;
+
+	bts_trace_reset(tr);
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
+}
+
+static void bts_trace_stop_cpu(void *arg)
+{
+	if (this_tracer) {
+		ds_release_bts(this_tracer);
+		this_tracer = NULL;
+	}
+}
+
+static void bts_trace_stop(struct trace_array *tr)
+{
+	int cpu;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		smp_call_function_single(cpu, bts_trace_stop_cpu, NULL, 1);
+}
+
+static int bts_trace_init(struct trace_array *tr)
+{
+	bts_trace_reset(tr);
+	bts_trace_start(tr);
+
+	return 0;
+}
+
+static void bts_trace_print_header(struct seq_file *m)
+{
+	seq_puts(m,
+		 "# CPU#        FROM                   TO         FUNCTION\n");
+	seq_puts(m,
+		 "#  |           |                     |             |\n");
+}
+
+static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *seq = &iter->seq;
+	struct hw_branch_entry *it;
+
+	trace_assign_type(it, entry);
+
+	if (entry->type == TRACE_HW_BRANCHES) {
+		if (trace_seq_printf(seq, "%4d  ", entry->cpu) &&
+		    trace_seq_printf(seq, "0x%016llx -> 0x%016llx ",
+				     it->from, it->to) &&
+		    (!it->from ||
+		     seq_print_ip_sym(seq, it->from, /* sym_flags = */ 0)) &&
+		    trace_seq_printf(seq, "\n"))
+			return TRACE_TYPE_HANDLED;
+		return TRACE_TYPE_PARTIAL_LINE;;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+void trace_hw_branch(struct trace_array *tr, u64 from, u64 to)
+{
+	struct ring_buffer_event *event;
+	struct hw_branch_entry *entry;
+	unsigned long irq;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, from);
+	entry->ent.type = TRACE_HW_BRANCHES;
+	entry->ent.cpu = smp_processor_id();
+	entry->from = from;
+	entry->to   = to;
+	ring_buffer_unlock_commit(tr->buffer, event, irq);
+}
+
+static void trace_bts_at(struct trace_array *tr,
+			 const struct bts_trace *trace, void *at)
+{
+	struct bts_struct bts;
+	int err = 0;
+
+	WARN_ON_ONCE(!trace->read);
+	if (!trace->read)
+		return;
+
+	err = trace->read(this_tracer, at, &bts);
+	if (err < 0)
+		return;
+
+	switch (bts.qualifier) {
+	case BTS_BRANCH:
+		trace_hw_branch(tr, bts.variant.lbr.from, bts.variant.lbr.to);
+		break;
+	}
+}
+
+static void trace_bts_cpu(void *arg)
+{
+	struct trace_array *tr = (struct trace_array *) arg;
+	const struct bts_trace *trace;
+	unsigned char *at;
+
+	if (!this_tracer)
+		return;
+
+	ds_suspend_bts(this_tracer);
+	trace = ds_read_bts(this_tracer);
+	if (!trace)
+		goto out;
+
+	for (at = trace->ds.top; (void *)at < trace->ds.end;
+	     at += trace->ds.size)
+		trace_bts_at(tr, trace, at);
+
+	for (at = trace->ds.begin; (void *)at < trace->ds.top;
+	     at += trace->ds.size)
+		trace_bts_at(tr, trace, at);
+
+out:
+	ds_resume_bts(this_tracer);
+}
+
+static void trace_bts_prepare(struct trace_iterator *iter)
+{
+	int cpu;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		smp_call_function_single(cpu, trace_bts_cpu, iter->tr, 1);
+}
+
+struct tracer bts_tracer __read_mostly =
+{
+	.name		= "hw-branch-tracer",
+	.init		= bts_trace_init,
+	.reset		= bts_trace_stop,
+	.print_header	= bts_trace_print_header,
+	.print_line	= bts_trace_print_line,
+	.start		= bts_trace_start,
+	.stop		= bts_trace_stop,
+	.open		= trace_bts_prepare
+};
+
+__init static int init_bts_trace(void)
+{
+	return register_tracer(&bts_tracer);
+}
+device_initcall(init_bts_trace);
Index: gits/kernel/trace/trace.h
===================================================================
--- gits.orig/kernel/trace/trace.h	2008-12-11 10:45:12.000000000 +0100
+++ gits/kernel/trace/trace.h	2008-12-11 11:21:57.000000000 +0100
@@ -28,7 +28,7 @@
 	TRACE_GRAPH_RET,
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
-	TRACE_BTS,
+	TRACE_HW_BRANCHES,
 	TRACE_POWER,
 
 	__TRACE_LAST_TYPE
@@ -159,10 +159,10 @@
 	char			correct;
 };
 
-struct bts_entry {
+struct hw_branch_entry {
 	struct trace_entry	ent;
-	unsigned long		from;
-	unsigned long		to;
+	u64			from;
+	u64			to;
 };
 
 struct trace_power {
@@ -278,7 +278,7 @@
 			  TRACE_GRAPH_ENT);		\
 		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
 			  TRACE_GRAPH_RET);		\
-		IF_ASSIGN(var, ent, struct bts_entry, TRACE_BTS);\
+		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
  		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
 		__ftrace_bad_type();					\
 	} while (0)
@@ -414,9 +414,7 @@
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
-void trace_bts(struct trace_array *tr,
-	       unsigned long from,
-	       unsigned long to);
+void trace_hw_branch(struct trace_array *tr, u64 from, u64 to);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
Index: gits/kernel/trace/Kconfig
===================================================================
--- gits.orig/kernel/trace/Kconfig	2008-12-11 10:45:12.000000000 +0100
+++ gits/kernel/trace/Kconfig	2008-12-11 11:21:19.000000000 +0100
@@ -251,9 +251,9 @@
 
 	  Say N if unsure.
 
-config BTS_TRACER
+config HW_BRANCH_TRACER
 	depends on HAVE_HW_BRANCH_TRACER
-	bool "Trace branches"
+	bool "Trace hw branches"
 	select TRACING
 	help
 	  This tracer records all branches on the system in a circular
Index: gits/kernel/trace/Makefile
===================================================================
--- gits.orig/kernel/trace/Makefile	2008-12-11 10:45:12.000000000 +0100
+++ gits/kernel/trace/Makefile	2008-12-11 11:21:19.000000000 +0100
@@ -31,7 +31,7 @@
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
-obj-$(CONFIG_BTS_TRACER) += trace_bts.o
+obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
 obj-$(CONFIG_POWER_TRACER) += trace_power.o
 
 libftrace-y := ftrace.o
Index: gits/kernel/trace/trace.c
===================================================================
--- gits.orig/kernel/trace/trace.c	2008-12-11 10:45:12.000000000 +0100
+++ gits/kernel/trace/trace.c	2008-12-11 11:21:19.000000000 +0100
@@ -2425,7 +2425,7 @@
 
 	/* Notify the tracer early; before we stop tracing. */
 	if (iter->trace && iter->trace->open)
-			iter->trace->open(iter);
+		iter->trace->open(iter);
 
 	/* Annotate start of buffers if we had overruns */
 	if (ring_buffer_overruns(iter->tr->buffer))
