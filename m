Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYBJH0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYBJH0G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbYBJHVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:21:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758124AbYBJHVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:21:01 -0500
Date: Sun, 10 Feb 2008 08:20:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [13/19] ftrace: add tracing of context switches
Message-ID: <20080210072050.GN4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds context switch tracing, of the format of:

                  _------=> CPU#
                 / _-----=> irqs-off
                | / _----=> need-resched
                || / _---=> hardirq/softirq
                ||| / _--=> preempt-depth
                |||| /
                |||||     delay
    cmd     pid ||||| time  |      pid:prio:state
       \   /    |||||   \   |      /
  swapper-0     1d..3    137us+:  0:140:R --> 2912:120
     sshd-2912  1d..3    216us+:  2912:120:S --> 0:140
  swapper-0     1d..3    261us+:  0:140:R --> 2912:120
     bash-2920  0d..3    267us+:  2920:120:S --> 0:140
     sshd-2912  1d..3    330us!:  2912:120:S --> 0:140
  swapper-0     1d..3   2389us+:  0:140:R --> 2847:120
 yum-upda-2847  1d..3   2411us!:  2847:120:S --> 0:140
  swapper-0     0d..3  11089us+:  0:140:R --> 3139:120
 gdm-bina-3139  0d..3  11113us!:  3139:120:S --> 0:140
  swapper-0     1d..3 102328us+:  0:140:R --> 2847:120
 yum-upda-2847  1d..3 102348us!:  2847:120:S --> 0:140

 "sched_switch" is added to /debugfs/tracing/available_tracers

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/Kconfig              |   11 +++
 kernel/trace/Makefile             |    1 
 kernel/trace/trace_sched_switch.c |  125 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)

Index: linux/kernel/trace/Kconfig
===================================================================
--- linux.orig/kernel/trace/Kconfig
+++ linux/kernel/trace/Kconfig
@@ -13,6 +13,7 @@ config FTRACE
 	depends on DEBUG_KERNEL && HAVE_FTRACE
 	select FRAME_POINTER
 	select TRACING
+	select CONTEXT_SWITCH_TRACER
 	help
 	  Enable the kernel to trace every kernel function. This is done
 	  by using a compiler feature to insert a small, 5-byte No-Operation
@@ -21,3 +22,13 @@ config FTRACE
 	  tracing is enabled by the administrator. If it's runtime disabled
 	  (the bootup default), then the overhead of the instructions is very
 	  small and not measurable even in micro-benchmarks.
+
+config CONTEXT_SWITCH_TRACER
+	bool "Trace process context switches"
+	depends on DEBUG_KERNEL
+	select TRACING
+	select MARKERS
+	help
+	  This tracer gets called from the context switch and records
+	  all switching of tasks.
+
Index: linux/kernel/trace/Makefile
===================================================================
--- linux.orig/kernel/trace/Makefile
+++ linux/kernel/trace/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_FTRACE) += libftrace.o
 
 obj-$(CONFIG_TRACING) += trace.o
+obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_FTRACE) += trace_functions.o
 
 libftrace-y := ftrace.o
Index: linux/kernel/trace/trace_sched_switch.c
===================================================================
--- /dev/null
+++ linux/kernel/trace/trace_sched_switch.c
@@ -0,0 +1,125 @@
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
+#include <linux/ftrace.h>
+
+#include "trace.h"
+
+static struct trace_array	*ctx_trace;
+static int __read_mostly	tracer_enabled;
+int __read_mostly		tracing_sched_switch_enabled;
+
+static void notrace
+ctx_switch_func(struct task_struct *prev, struct task_struct *next)
+{
+	struct trace_array *tr = ctx_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+
+	if (!tracer_enabled)
+		return;
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
+void ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next)
+{
+	tracing_record_cmdline(prev);
+
+	/*
+	 * If tracer_switch_func only points to the local
+	 * switch func, it still needs the ptr passed to it.
+	 */
+	ctx_switch_func(prev, next);
+
+	/*
+	 * Chain to the wakeup tracer (this is a NOP if disabled):
+	 */
+	wakeup_sched_switch(prev, next);
+}
+
+static notrace void sched_switch_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr->data[cpu]);
+}
+
+static notrace void start_sched_trace(struct trace_array *tr)
+{
+	sched_switch_reset(tr);
+	tracer_enabled = 1;
+}
+
+static notrace void stop_sched_trace(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+}
+
+static notrace void sched_switch_trace_init(struct trace_array *tr)
+{
+	ctx_trace = tr;
+
+	if (tr->ctrl)
+		start_sched_trace(tr);
+}
+
+static notrace void sched_switch_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_sched_trace(tr);
+}
+
+static void sched_switch_trace_ctrl_update(struct trace_array *tr)
+{
+	/* When starting a new trace, reset the buffers */
+	if (tr->ctrl)
+		start_sched_trace(tr);
+	else
+		stop_sched_trace(tr);
+}
+
+static struct tracer sched_switch_trace __read_mostly =
+{
+	.name		= "sched_switch",
+	.init		= sched_switch_trace_init,
+	.reset		= sched_switch_trace_reset,
+	.ctrl_update	= sched_switch_trace_ctrl_update,
+};
+
+__init static int init_sched_switch_trace(void)
+{
+	int ret;
+
+	ret = register_tracer(&sched_switch_trace);
+	if (ret)
+		return ret;
+
+	tracing_sched_switch_enabled = 1;
+
+	return ret;
+}
+device_initcall(init_sched_switch_trace);
