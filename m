Return-Path: <linux-kernel-owner+w=401wt.eu-S1758484AbYAOUzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbYAOUzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYAOUur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:47 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56908 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbYAOUud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:33 -0500
Message-Id: <20080115205026.402021623@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 27/30 v3] Add tracing of context switches
Content-Disposition: inline; filename=trace-add-cmdline-switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds context switch tracing, of the format of:

                 _------=> CPU#            
                / _-----=> irqs-off        
               | / _----=> need-resched    
               || / _---=> hardirq/softirq 
               ||| / _--=> preempt-depth   
               |||| /                      
               |||||     delay             
   cmd     pid ||||| time  |   caller      
      \   /    |||||   \   |   /           
  <idle>-0     1d..3  361us!:  0:140:R --> 5028
    bash-5036  0d..3  552us+:  5036:120:D --> 0
  <idle>-0     0d..3  606us!:  0:140:R --> 5036
    sshd-5028  1d..3  943us!:  5028:120:S --> 0
  <idle>-0     1d..3 1316us+:  0:140:R --> 5028
    bash-5036  0d..3 1388us!:  5036:120:S --> 0
    sshd-5028  1d..3 1772us!:  5028:120:S --> 0

Two files are added to /debugfs/tracing

  sched_trace - outputs the above format.

  sched_trace_ctrl
     0 - turns off context switch tracing.
     1 - turns on context switch tracing.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 lib/tracing/Kconfig              |   10 +
 lib/tracing/Makefile             |    1 
 lib/tracing/trace_sched_switch.c |  205 +++++++++++++++++++++++++++++++++++++++
 lib/tracing/tracer.c             |   31 +++++
 lib/tracing/tracer.h             |   18 +++
 5 files changed, 264 insertions(+), 1 deletion(-)

Index: linux-compile.git/lib/tracing/Kconfig
===================================================================
--- linux-compile.git.orig/lib/tracing/Kconfig	2008-01-15 11:13:54.000000000 -0500
+++ linux-compile.git/lib/tracing/Kconfig	2008-01-15 11:15:00.000000000 -0500
@@ -42,3 +42,13 @@ config CRITICAL_IRQSOFF_TIMING
 
 	      echo 0 > /debug/tracing/preempt_max_latency
 
+config CONTEXT_SWITCH_TRACER
+	bool "Trace process context switches"
+	depends on DEBUG_KERNEL
+	default n
+	select TRACING
+	select MARKERS
+	help
+	  This tracer hooks into the context switch and records
+	  all switching of tasks.
+
Index: linux-compile.git/lib/tracing/Makefile
===================================================================
--- linux-compile.git.orig/lib/tracing/Makefile	2008-01-15 11:12:31.000000000 -0500
+++ linux-compile.git/lib/tracing/Makefile	2008-01-15 11:14:44.000000000 -0500
@@ -1,6 +1,7 @@
 obj-$(CONFIG_MCOUNT) += libmcount.o
 
 obj-$(CONFIG_TRACING) += tracer.o
+obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
 obj-$(CONFIG_CRITICAL_IRQSOFF_TIMING) += trace_irqsoff.o
 
Index: linux-compile.git/lib/tracing/trace_sched_switch.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/lib/tracing/trace_sched_switch.c	2008-01-15 11:14:44.000000000 -0500
@@ -0,0 +1,205 @@
+/*
+ * trace context switch
+ *
+ * Copyright (C) 2007 Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/kallsyms.h>
+#include <linux/uaccess.h>
+#include <linux/marker.h>
+#include <linux/mcount.h>
+
+#include "tracer.h"
+
+static struct tracing_trace sched_switch_trace __read_mostly;
+static DEFINE_PER_CPU(struct tracing_trace_cpu, sched_switch_trace_cpu);
+
+static int trace_enabled __read_mostly;
+
+static notrace void sched_switch_callback(const struct marker *mdata,
+					  void *private_data,
+					  const char *format, ...)
+{
+	struct tracing_trace *tr = mdata->private;
+	struct tracing_trace_cpu *data;
+	struct task_struct *prev = current;
+	int prev_pid, next_pid;
+	unsigned long flags;
+	va_list ap;
+	int cpu;
+
+	if (!trace_enabled)
+		return;
+
+	va_start(ap, format);
+
+	/* just use prev pointer and grab next. */
+	prev_pid = va_arg(ap, typeof(prev_pid));
+
+	/*
+	 * Unfortunately we are limited to just the
+	 * next_pid, and the marker doesn't give us
+	 * next itself.
+	 */
+	next_pid = va_arg(ap, typeof(next_pid));
+
+	/* Ignore prev_state, since we get that from prev itself */
+	va_end(ap);
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	atomic_inc(&data->disabled);
+
+	if (likely(atomic_read(&data->disabled) == 1))
+		tracing_sched_switch_trace(tr, data, prev, next_pid, flags);
+
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+
+static notrace void sched_switch_reset(struct tracing_trace *tr)
+{
+	int cpu;
+
+	tr->time_start = now();
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr->data[cpu]);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void sched_switch_trace_ctrl_update(struct tracing_trace *tr,
+					   unsigned long val)
+{
+	val = !!val;
+
+	/* When starting a new trace, reset the buffers */
+	if (val)
+		sched_switch_reset(tr);
+
+	if (tr->ctrl ^ val) {
+		if (val)
+			trace_enabled = 1;
+		else
+			trace_enabled = 0;
+		tr->ctrl = val;
+	}
+}
+
+static __init void sched_switch_trace_init_debugfs(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	sched_switch_trace.ctrl_update = sched_switch_trace_ctrl_update;
+
+	entry = debugfs_create_file("sched_trace_ctrl", 0644, d_tracer,
+				    &sched_switch_trace, &tracing_ctrl_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'sched_trace_ctrl' entry\n");
+
+	entry = debugfs_create_file("sched_trace", 0444, d_tracer,
+				    &sched_switch_trace, &tracing_lt_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'sched_trace' entry\n");
+}
+
+#else
+static __init void sched_switch_trace_init_debugfs(void)
+{
+	/*
+	 * No way to turn on or off the trace function
+	 * without debugfs, so we just turn it on.
+	 */
+}
+#endif
+
+static void sched_switch_trace_open(struct tracing_iterator *iter)
+{
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		trace_enabled = 0;
+}
+
+static void sched_switch_trace_close(struct tracing_iterator *iter)
+{
+	if (iter->tr->ctrl)
+		trace_enabled = 1;
+}
+
+__init static int sched_switch_trace_alloc_buffers(void)
+{
+	const int order = page_order(TRACING_NR_ENTRIES * TRACING_ENTRY_SIZE);
+	const unsigned long size = (1UL << order) << PAGE_SHIFT;
+	struct tracing_entry *array;
+	int ret;
+	int i;
+
+	for_each_possible_cpu(i) {
+		sched_switch_trace.data[i] =
+			&per_cpu(sched_switch_trace_cpu, i);
+		array = (struct tracing_entry *)
+			  __get_free_pages(GFP_KERNEL, order);
+		if (array == NULL) {
+			printk(KERN_ERR "sched_switch tracer: failed to"
+			       " allocate %ld bytes for trace buffer!\n", size);
+			goto free_buffers;
+		}
+		sched_switch_trace.data[i]->trace = array;
+	}
+
+	/*
+	 * Since we allocate by orders of pages, we may be able to
+	 * round up a bit.
+	 */
+	sched_switch_trace.entries = size / TRACING_ENTRY_SIZE;
+
+	pr_info("sched_switch tracer: %ld bytes allocated for %ld",
+		size, TRACING_NR_ENTRIES);
+	pr_info(" entries of %ld bytes\n", (long)TRACING_ENTRY_SIZE);
+	pr_info("   actual entries %ld\n", sched_switch_trace.entries);
+
+	sched_switch_trace_init_debugfs();
+
+	sched_switch_trace.open = sched_switch_trace_open;
+	sched_switch_trace.close = sched_switch_trace_close;
+
+	ret = marker_probe_register("kernel_sched_schedule",
+				    "prev_pid %d next_pid %d prev_state %ld",
+				    sched_switch_callback,
+				    &sched_switch_trace);
+	if (ret) {
+		pr_info("sched trace: Couldn't add marker"
+			" probe to switch_to\n");
+		goto out;
+	}
+
+	ret = marker_arm("kernel_sched_schedule");
+	if (ret) {
+		pr_info("sched trace: Couldn't arm probe switch_to\n");
+		goto out;
+	}
+
+ out:
+	return 0;
+
+ free_buffers:
+	for (i-- ; i >= 0; i--) {
+		struct tracing_trace_cpu *data = sched_switch_trace.data[i];
+
+		if (data && data->trace) {
+			free_pages((unsigned long)data->trace, order);
+			data->trace = NULL;
+		}
+	}
+	return -ENOMEM;
+}
+
+device_initcall(sched_switch_trace_alloc_buffers);
Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-15 11:12:31.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-15 11:14:44.000000000 -0500
@@ -31,6 +31,7 @@ enum trace_type
 	__TRACE_FIRST_TYPE = 0,
 
 	TRACE_FN,
+	TRACE_CTX,
 
 	__TRACE_LAST_TYPE
 };
@@ -107,6 +108,24 @@ notrace void tracing_function_trace(stru
 	entry->fn.parent_ip = parent_ip;
 }
 
+notrace void tracing_sched_switch_trace(struct tracing_trace *tr,
+					struct tracing_trace_cpu *data,
+					struct task_struct *prev,
+					int next_pid,
+					unsigned long flags)
+{
+	struct tracing_entry *entry;
+
+	entry = tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type		= TRACE_CTX;
+	entry->ctx.prev_pid	= prev->pid;
+	entry->ctx.prev_prio	= prev->prio;
+	entry->ctx.prev_state	= prev->state;
+	entry->ctx.next_pid	= next_pid;
+	/* would like to save next prio, but we cant :-( */
+}
+
 #ifdef CONFIG_DEBUG_FS
 enum trace_iterator {
 	TRACE_ITER_SYM_ONLY	= 1,
@@ -414,6 +433,8 @@ lat_print_timestamp(struct seq_file *m, 
 		seq_puts(m, " : ");
 }
 
+static const char state_to_char[] = "RSDTtZX";
+
 static void notrace
 print_lat_fmt(struct seq_file *m, struct tracing_iterator *iter,
 	      unsigned int trace_idx, int cpu)
@@ -424,6 +445,7 @@ print_lat_fmt(struct seq_file *m, struct
 	unsigned long rel_usecs;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
+	int S;
 
 	if (!next_entry)
 		next_entry = entry;
@@ -450,6 +472,15 @@ print_lat_fmt(struct seq_file *m, struct
 		seq_print_ip_sym(m, entry->fn.parent_ip, sym_only);
 		seq_puts(m, ")\n");
 		break;
+	case TRACE_CTX:
+		S = entry->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[entry->ctx.prev_state] : 'X';
+		seq_printf(m, " %d:%d:%c --> %d\n",
+			   entry->ctx.prev_pid,
+			   entry->ctx.prev_prio,
+			   S,
+			   entry->ctx.next_pid);
+		break;
 	}
 }
 
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-15 11:12:31.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-15 11:14:44.000000000 -0500
@@ -10,6 +10,14 @@ struct tracing_function {
 	unsigned long parent_ip;
 };
 
+struct tracing_sched_switch {
+	unsigned int prev_pid;
+	unsigned char prev_prio;
+	unsigned char prev_state;
+	unsigned int next_pid;
+	unsigned char next_prio;
+};
+
 struct tracing_entry {
 	char type;
 	char cpu;  /* who will want to trace more than 256 CPUS? */
@@ -18,7 +26,10 @@ struct tracing_entry {
 	int pid;
 	cycle_t t;
 	char comm[TASK_COMM_LEN];
-	struct tracing_function fn;
+	union {
+		struct tracing_function fn;
+		struct tracing_sched_switch ctx;
+	};
 };
 
 struct tracing_trace_cpu {
@@ -76,6 +87,11 @@ void tracing_function_trace(struct traci
 			    unsigned long ip,
 			    unsigned long parent_ip,
 			    unsigned long flags);
+void tracing_sched_switch_trace(struct tracing_trace *tr,
+				struct tracing_trace_cpu *data,
+				struct task_struct *prev,
+				int next_pid,
+				unsigned long flags);
 
 extern struct file_operations tracing_fops;
 extern struct file_operations tracing_lt_fops;

-- 
