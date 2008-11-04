Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYKDEWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYKDEWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYKDEWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:22:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYKDEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:22:06 -0500
Message-Id: <20081104042203.499871423@goodmis.org>
References: <20081104041554.605521183@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 03 Nov 2008 23:15:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: function tracer with irqs disabled
Content-Disposition: inline; filename=ftrace-irq-disabled-function-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help with performance, I set the ftracer to not disable interrupts,
and only to disable preemption. If an interrupt occurred, it would not
be traced, because the function tracer protects itself from recursion.
This may be faster, but the trace output might miss some traces.

This patch makes the fuction trace disable interrupts, but it also
adds a runtime feature to disable preemption instead. It does this by
having two different tracer functions. When the function tracer is
enabled, it will check to see which version is requested (irqs disabled
or preemption disabled). Then it will use the corresponding function
as the tracer.

Irq disabling is the default behaviour, but if the user wants better
performance, with the chance of missing traces, then they can choose
the preempt disabled version.

Running hackbench 3 times with the irqs disabled and 3 times with
the preempt disabled function tracer yielded:

tracing type       times            entries recorded
------------      --------          ----------------
irq disabled      43.393            166433066
                  43.282            166172618
                  43.298            166256704

preempt disabled  38.969            159871710
                  38.943            159972935
                  39.325            161056510


Average:

   irqs disabled:  43.324           166287462
preempt disabled:  39.079           160300385

 preempt is 10.8 percent faster than irqs disabled.

I wrote a patch to count function trace recursion and reran hackbench. 

With irq disabled: 1,150 times the function tracer did not trace due to
  recursion.
with preempt disabled: 5,117,718 times.

The thousand times with irq disabled could be due to NMIs, or simply a case
where it called a function that was not protected by notrace.

But we also see that a large amount of the trace is lost with the
preempt version.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   40 +++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h |    1 +
 2 files changed, 40 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-11-03 19:05:24.000000000 -0500
+++ linux-tip.git/kernel/trace/trace.c	2008-11-03 22:29:17.000000000 -0500
@@ -235,6 +235,7 @@ static const char *trace_options[] = {
 	"stacktrace",
 	"sched-tree",
 	"ftrace_printk",
+	"ftrace_preempt",
 	NULL
 };
 
@@ -880,7 +881,7 @@ ftrace_special(unsigned long arg1, unsig
 
 #ifdef CONFIG_FUNCTION_TRACER
 static void
-function_trace_call(unsigned long ip, unsigned long parent_ip)
+function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
@@ -906,6 +907,37 @@ function_trace_call(unsigned long ip, un
 	ftrace_preempt_enable(resched);
 }
 
+static void
+function_trace_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	if (unlikely(!ftrace_function_enabled))
+		return;
+
+	/*
+	 * Need to use raw, since this must be called before the
+	 * recursive protection is performed.
+	 */
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		trace_function(tr, data, ip, parent_ip, flags, pc);
+	}
+
+	atomic_dec(&data->disabled);
+	raw_local_irq_restore(flags);
+}
+
 static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = function_trace_call,
@@ -914,6 +946,12 @@ static struct ftrace_ops trace_ops __rea
 void tracing_start_function_trace(void)
 {
 	ftrace_function_enabled = 0;
+
+	if (trace_flags & TRACE_ITER_PREEMPTONLY)
+		trace_ops.func = function_trace_call_preempt_only;
+	else
+		trace_ops.func = function_trace_call;
+
 	register_ftrace_function(&trace_ops);
 	if (tracer_enabled)
 		ftrace_function_enabled = 1;
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-11-03 18:49:38.000000000 -0500
+++ linux-tip.git/kernel/trace/trace.h	2008-11-03 19:15:04.000000000 -0500
@@ -415,6 +415,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_STACKTRACE		= 0x100,
 	TRACE_ITER_SCHED_TREE		= 0x200,
 	TRACE_ITER_PRINTK		= 0x400,
+	TRACE_ITER_PREEMPTONLY		= 0x800,
 };
 
 extern struct tracer nop_trace;

-- 
