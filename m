Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYKYIYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYKYIYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 03:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYKYIYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 03:24:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:13897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYKYIYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 03:24:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="407760791"
Date: Tue, 25 Nov 2008 09:24:15 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Message-ID: <20081125092415.A31432@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A prototype for a BTS ftrace plug-in.

The tracer collects branch trace in a cyclic buffer for each cpu.

The tracer is not configurable and the trace for each snapshot is
appended when doing cat /debug/tracing/trace.

This is a proof of concept that will be extended with future patches
to become a (hopefully) useful tool.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/kernel/trace/Kconfig
===================================================================
--- ftrace.orig/kernel/trace/Kconfig	2008-11-24 13:46:25.000000000 +0100
+++ ftrace/kernel/trace/Kconfig	2008-11-25 08:18:07.000000000 +0100
@@ -28,6 +28,9 @@
 config HAVE_FTRACE_MCOUNT_RECORD
 	bool
 
+config HAVE_HW_BRANCH_TRACER
+	bool
+
 config TRACER_MAX_TRACE
 	bool
 
@@ -233,6 +236,14 @@
 
 	  Say N if unsure.
 
+config BTS_TRACER
+	depends on HAVE_HW_BRANCH_TRACER
+	bool "Trace branches"
+	select TRACING
+	help
+	  This tracer records all branches on the system in a circular
+	  buffer giving access to the last N branches for each cpu.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
Index: ftrace/kernel/trace/Makefile
===================================================================
--- ftrace.orig/kernel/trace/Makefile	2008-11-24 13:46:25.000000000 +0100
+++ ftrace/kernel/trace/Makefile	2008-11-25 08:18:07.000000000 +0100
@@ -31,5 +31,6 @@
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_RET_TRACER) += trace_functions_return.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
+obj-$(CONFIG_BTS_TRACER) += trace_bts.o
 
 libftrace-y := ftrace.o
Index: ftrace/kernel/trace/trace_bts.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ ftrace/kernel/trace/trace_bts.c	2008-11-25 08:18:07.000000000 +0100
@@ -0,0 +1,276 @@
+/*
+ * BTS tracer
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
+/*
+ * Information to interpret a BTS record.
+ * This will go into an in-kernel BTS interface.
+ */
+static unsigned char sizeof_field;
+static unsigned long debugctl_mask;
+
+#define sizeof_bts (3 * sizeof_field)
+
+static void bts_trace_cpuinit(struct cpuinfo_x86 *c)
+{
+	switch (c->x86) {
+	case 0x6:
+		switch (c->x86_model) {
+		case 0x0 ... 0xC:
+			break;
+		case 0xD:
+		case 0xE: /* Pentium M */
+			sizeof_field = sizeof(long);
+			debugctl_mask = (1<<6)|(1<<7);
+			break;
+		default:
+			sizeof_field = 8;
+			debugctl_mask = (1<<6)|(1<<7);
+			break;
+		}
+		break;
+	case 0xF:
+		switch (c->x86_model) {
+		case 0x0:
+		case 0x1:
+		case 0x2: /* Netburst */
+			sizeof_field = sizeof(long);
+			debugctl_mask = (1<<2)|(1<<3);
+			break;
+		default:
+			/* sorry, don't know about them */
+			break;
+		}
+		break;
+	default:
+		/* sorry, don't know about them */
+		break;
+	}
+}
+
+static inline void bts_enable(void)
+{
+	unsigned long debugctl;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl | debugctl_mask);
+}
+
+static inline void bts_disable(void)
+{
+	unsigned long debugctl;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl & ~debugctl_mask);
+}
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
+	this_tracer =
+		ds_request_bts(/* task = */ NULL, this_buffer, SIZEOF_BTS,
+			       /* ovfl = */ NULL, /* th = */ (size_t)-1);
+	if (IS_ERR(this_tracer)) {
+		this_tracer = NULL;
+		return;
+	}
+
+	bts_enable();
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
+		bts_disable();
+
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
+	bts_trace_cpuinit(&boot_cpu_data);
+	bts_trace_reset(tr);
+	bts_trace_start(tr);
+
+	return 0;
+}
+
+static void bts_trace_print_header(struct seq_file *m)
+{
+#ifdef __i386__
+	seq_puts(m, "# CPU#    FROM           TO     FUNCTION\n");
+	seq_puts(m, "#  |       |             |         |\n");
+#else
+	seq_puts(m,
+		 "# CPU#        FROM                   TO         FUNCTION\n");
+	seq_puts(m,
+		 "#  |           |                     |             |\n");
+#endif
+}
+
+static enum print_line_t bts_trace_print_line(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct trace_seq *seq = &iter->seq;
+	struct bts_entry *it;
+
+	trace_assign_type(it, entry);
+
+	if (entry->type == TRACE_BTS) {
+		int ret;
+#ifdef CONFIG_KALLSYMS
+		char function[KSYM_SYMBOL_LEN];
+		sprint_symbol(function, it->from);
+#else
+		char *function = "<unknown>";
+#endif
+
+		ret = trace_seq_printf(seq, "%4d  0x%lx -> 0x%lx [%s]\n",
+				       entry->cpu, it->from, it->to, function);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;;
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+void trace_bts(struct trace_array *tr, unsigned long from, unsigned long to)
+{
+	struct ring_buffer_event *event;
+	struct bts_entry *entry;
+	unsigned long irq;
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, from);
+	entry->ent.type = TRACE_BTS;
+	entry->ent.cpu = smp_processor_id();
+	entry->from = from;
+	entry->to   = to;
+	ring_buffer_unlock_commit(tr->buffer, event, irq);
+}
+
+static void trace_bts_at(struct trace_array *tr, size_t index)
+{
+	const void *raw = NULL;
+	unsigned long from, to;
+	int err;
+
+	err = ds_access_bts(this_tracer, index, &raw);
+	if (err < 0)
+		return;
+
+	from = *(const unsigned long *)raw;
+	to = *(const unsigned long *)((const char *)raw + sizeof_field);
+
+	trace_bts(tr, from, to);
+}
+
+static void trace_bts_cpu(void *arg)
+{
+	struct trace_array *tr = (struct trace_array *) arg;
+	size_t index = 0, end = 0, i;
+	int err;
+
+	if (!this_tracer)
+		return;
+
+	bts_disable();
+
+	err = ds_get_bts_index(this_tracer, &index);
+	if (err < 0)
+		goto out;
+
+	err = ds_get_bts_end(this_tracer, &end);
+	if (err < 0)
+		goto out;
+
+	for (i = index; i < end; i++)
+		trace_bts_at(tr, i);
+
+	for (i = 0; i < index; i++)
+		trace_bts_at(tr, i);
+
+out:
+	bts_enable();
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
+	.name		= "bts",
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
Index: ftrace/kernel/trace/trace.h
===================================================================
--- ftrace.orig/kernel/trace/trace.h	2008-11-25 08:18:05.000000000 +0100
+++ ftrace/kernel/trace/trace.h	2008-11-25 08:18:07.000000000 +0100
@@ -27,6 +27,7 @@
 	TRACE_BOOT_RET,
 	TRACE_FN_RET,
 	TRACE_USER_STACK,
+	TRACE_BTS,
 
 	__TRACE_LAST_TYPE
 };
@@ -153,6 +154,12 @@
 	char			correct;
 };
 
+struct bts_entry {
+	struct trace_entry	ent;
+	unsigned long		from;
+	unsigned long		to;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -258,6 +265,7 @@
 		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
 		IF_ASSIGN(var, ent, struct trace_branch, TRACE_BRANCH); \
 		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET);\
+		IF_ASSIGN(var, ent, struct bts_entry, TRACE_BTS);\
 		__ftrace_bad_type();					\
 	} while (0)
 
@@ -392,6 +400,10 @@
 void
 trace_function_return(struct ftrace_retfunc *trace);
 
+void trace_bts(struct trace_array *tr,
+	       unsigned long from,
+	       unsigned long to);
+
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
 void tracing_sched_switch_assign_trace(struct trace_array *tr);
Index: ftrace/arch/x86/Kconfig.cpu
===================================================================
--- ftrace.orig/arch/x86/Kconfig.cpu	2008-11-24 13:46:25.000000000 +0100
+++ ftrace/arch/x86/Kconfig.cpu	2008-11-25 08:18:07.000000000 +0100
@@ -515,6 +515,7 @@
 config X86_DS
 	def_bool X86_PTRACE_BTS
 	depends on X86_DEBUGCTLMSR
+	select HAVE_HW_BRANCH_TRACER
 
 config X86_PTRACE_BTS
 	bool "Branch Trace Store"
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

