Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbYA3VIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbYA3VIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYA3VFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:05:47 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39630 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015AbYA3VFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:05:36 -0500
Message-Id: <20080130210527.028868510@goodmis.org>
References: <20080130210357.927754294@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 30 Jan 2008 16:04:11 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 14/23 -v8] Add tracing of context switches
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
 swapper-0     1d..3  137us+:  0:140:R --> 2912:120
    sshd-2912  1d..3  216us+:  2912:120:S --> 0:140
 swapper-0     1d..3  261us+:  0:140:R --> 2912:120
    bash-2920  0d..3  267us+:  2920:120:S --> 0:140
    sshd-2912  1d..3  330us!:  2912:120:S --> 0:140
 swapper-0     1d..3 2389us+:  0:140:R --> 2847:120
yum-upda-2847  1d..3 2411us!:  2847:120:S --> 0:140
 swapper-0     0d..3 11089us+:  0:140:R --> 3139:120
gdm-bina-3139  0d..3 11113us!:  3139:120:S --> 0:140
 swapper-0     1d..3 102328us+:  0:140:R --> 2847:120
yum-upda-2847  1d..3 102348us!:  2847:120:S --> 0:140


 "sched_switch" is added to /debugfs/tracing/available_tracers

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 lib/tracing/Kconfig              |    9 ++
 lib/tracing/Makefile             |    1 
 lib/tracing/trace_sched_switch.c |  166 +++++++++++++++++++++++++++++++++++++++
 lib/tracing/tracer.c             |   43 ++++++++++
 lib/tracing/tracer.h             |   23 +++++
 5 files changed, 241 insertions(+), 1 deletion(-)

Index: linux-mcount.git/lib/tracing/Kconfig
===================================================================
--- linux-mcount.git.orig/lib/tracing/Kconfig	2008-01-30 15:18:18.000000000 -0500
+++ linux-mcount.git/lib/tracing/Kconfig	2008-01-30 15:32:33.000000000 -0500
@@ -23,3 +23,12 @@ config FUNCTION_TRACER
 	  insert a call to an architecture specific __mcount routine,
 	  that the debugging mechanism using this facility will hook by
 	  providing a set of inline routines.
+
+config CONTEXT_SWITCH_TRACER
+	bool "Trace process context switches"
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer hooks into the context switch and records
+	  all switching of tasks.
+
Index: linux-mcount.git/lib/tracing/Makefile
===================================================================
--- linux-mcount.git.orig/lib/tracing/Makefile	2008-01-30 15:18:18.000000000 -0500
+++ linux-mcount.git/lib/tracing/Makefile	2008-01-30 15:32:34.000000000 -0500
@@ -1,6 +1,7 @@
 obj-$(CONFIG_MCOUNT) += libmcount.o
 
 obj-$(CONFIG_TRACING) += tracer.o
+obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_function.o
 
 libmcount-y := mcount.o
Index: linux-mcount.git/lib/tracing/trace_sched_switch.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mcount.git/lib/tracing/trace_sched_switch.c	2008-01-30 15:32:34.000000000 -0500
@@ -0,0 +1,166 @@
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
+static struct tracing_trace *tracer_trace;
+static int trace_enabled __read_mostly;
+static atomic_t sched_ref;
+int tracing_sched_switch_enabled __read_mostly;
+
+static notrace void sched_switch_callback(const struct marker *mdata,
+					  void *private_data,
+					  const char *format, ...)
+{
+	struct tracing_trace **p = mdata->private;
+	struct tracing_trace *tr = *p;
+	struct tracing_trace_cpu *data;
+	struct task_struct *prev;
+	struct task_struct *next;
+	unsigned long flags;
+	long disabled;
+	va_list ap;
+	int cpu;
+
+	if (!trace_enabled)
+		return;
+
+	va_start(ap, format);
+	prev = va_arg(ap, typeof(prev));
+	next = va_arg(ap, typeof(next));
+	va_end(ap);
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1))
+		tracing_sched_switch_trace(tr, data, prev, next, flags);
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
+static notrace void start_sched_trace(struct tracing_trace *tr)
+{
+	sched_switch_reset(tr);
+	trace_enabled = 1;
+	tracing_start_sched_switch();
+}
+
+static notrace void stop_sched_trace(struct tracing_trace *tr)
+{
+	tracing_stop_sched_switch();
+	trace_enabled = 0;
+}
+
+static notrace void sched_switch_trace_init(struct tracing_trace *tr)
+{
+	tracer_trace = tr;
+
+	if (tr->ctrl)
+		start_sched_trace(tr);
+}
+
+static notrace void sched_switch_trace_reset(struct tracing_trace *tr)
+{
+	if (tr->ctrl)
+		stop_sched_trace(tr);
+}
+
+static void sched_switch_trace_ctrl_update(struct tracing_trace *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_sched_trace(tr);
+	else
+		stop_sched_trace(tr);
+}
+
+static struct trace_types_struct sched_switch_trace __read_mostly =
+{
+	.name = "sched_switch",
+	.init = sched_switch_trace_init,
+	.reset = sched_switch_trace_reset,
+	.ctrl_update = sched_switch_trace_ctrl_update,
+};
+
+static int tracing_sched_arm(void)
+{
+	int ret;
+
+	ret = marker_arm("kernel_sched_schedule");
+	if (ret)
+		pr_info("sched trace: Couldn't arm probe switch_to\n");
+
+	return ret;
+}
+
+void tracing_start_sched_switch(void)
+{
+	long ref;
+
+	ref = atomic_inc_return(&sched_ref);
+	if (tracing_sched_switch_enabled && ref == 1)
+		tracing_sched_arm();
+}
+
+void tracing_stop_sched_switch(void)
+{
+	long ref;
+
+	ref = atomic_dec_and_test(&sched_ref);
+	if (tracing_sched_switch_enabled && ref)
+		marker_disarm("kernel_sched_schedule");
+}
+
+__init static int init_sched_switch_trace(void)
+{
+	int ret;
+
+	ret = register_trace(&sched_switch_trace);
+	if (ret)
+		return ret;
+
+	ret = marker_probe_register("kernel_sched_schedule",
+				    "prev %p next %p",
+				    sched_switch_callback,
+				    &tracer_trace);
+	if (ret) {
+		pr_info("sched trace: Couldn't add marker"
+			" probe to switch_to\n");
+		goto out;
+	}
+
+	if (atomic_read(&sched_ref))
+		ret = tracing_sched_arm();
+
+	tracing_sched_switch_enabled = 1;
+
+ out:
+	return ret;
+}
+
+device_initcall(init_sched_switch_trace);
Index: linux-mcount.git/lib/tracing/tracer.c
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.c	2008-01-30 15:18:18.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.c	2008-01-30 15:32:34.000000000 -0500
@@ -52,6 +52,7 @@ enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
 
 	TRACE_FN,
+	TRACE_CTX,
 
 	__TRACE_LAST_TYPE
 };
@@ -230,6 +231,24 @@ notrace void tracing_function_trace(stru
 	entry->fn.parent_ip = parent_ip;
 }
 
+notrace void tracing_sched_switch_trace(struct tracing_trace *tr,
+					struct tracing_trace_cpu *data,
+					struct task_struct *prev,
+					struct task_struct *next,
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
+	entry->ctx.next_pid	= next->pid;
+	entry->ctx.next_prio	= next->prio;
+}
+
 enum trace_iterator {
 	TRACE_ITER_SYM_ONLY	= 1,
 	TRACE_ITER_VERBOSE	= 2,
@@ -548,6 +567,8 @@ lat_print_timestamp(struct seq_file *m, 
 		seq_puts(m, " : ");
 }
 
+static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
+
 static void notrace
 print_lat_fmt(struct seq_file *m, struct tracing_iterator *iter,
 	      unsigned int trace_idx, int cpu)
@@ -558,6 +579,7 @@ print_lat_fmt(struct seq_file *m, struct
 	unsigned long rel_usecs;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	int verbose = !!(trace_flags & TRACE_ITER_VERBOSE);
+	int S;
 
 	if (!next_entry)
 		next_entry = entry;
@@ -584,6 +606,16 @@ print_lat_fmt(struct seq_file *m, struct
 		seq_print_ip_sym(m, entry->fn.parent_ip, sym_only);
 		seq_puts(m, ")\n");
 		break;
+	case TRACE_CTX:
+		S = entry->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[entry->ctx.prev_state] : 'X';
+		seq_printf(m, " %d:%d:%c --> %d:%d\n",
+			   entry->ctx.prev_pid,
+			   entry->ctx.prev_prio,
+			   S,
+			   entry->ctx.next_pid,
+			   entry->ctx.next_prio);
+		break;
 	}
 }
 
@@ -595,6 +627,7 @@ static void notrace print_trace_fmt(stru
 	unsigned long secs;
 	int sym_only = !!(trace_flags & TRACE_ITER_SYM_ONLY);
 	unsigned long long t;
+	int S;
 
 	t = cycles_to_usecs(entry->t);
 	usec_rem = do_div(t, 1000000ULL);
@@ -613,6 +646,16 @@ static void notrace print_trace_fmt(stru
 					 sym_only);
 		}
 		break;
+	case TRACE_CTX:
+		S = entry->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[entry->ctx.prev_state] : 'X';
+		seq_printf(m, " %d:%d:%c ==> %d:%d\n",
+			   entry->ctx.prev_pid,
+			   entry->ctx.prev_prio,
+			   S,
+			   entry->ctx.next_pid,
+			   entry->ctx.next_prio);
+		break;
 	}
 	seq_printf(m, "\n");
 }
Index: linux-mcount.git/lib/tracing/tracer.h
===================================================================
--- linux-mcount.git.orig/lib/tracing/tracer.h	2008-01-30 15:18:18.000000000 -0500
+++ linux-mcount.git/lib/tracing/tracer.h	2008-01-30 15:32:34.000000000 -0500
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
@@ -82,11 +93,21 @@ void tracing_function_trace(struct traci
 			    unsigned long ip,
 			    unsigned long parent_ip,
 			    unsigned long flags);
+void tracing_sched_switch_trace(struct tracing_trace *tr,
+				struct tracing_trace_cpu *data,
+				struct task_struct *prev,
+				struct task_struct *next,
+				unsigned long flags);
+
 
 void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);
 int register_trace(struct trace_types_struct *type);
 void unregister_trace(struct trace_types_struct *type);
+void tracing_start_sched_switch(void);
+void tracing_stop_sched_switch(void);
+
+extern int tracing_sched_switch_enabled;
 
 static inline notrace cycle_t now(void)
 {

-- 
