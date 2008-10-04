Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbYJDGCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbYJDGCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYJDGCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:02:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55670 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbYJDGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:02:13 -0400
Message-Id: <20081004060211.867050767@goodmis.org>
References: <20081004060057.660306328@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 04 Oct 2008 02:01:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: make some tracers reentrant
Content-Disposition: inline; filename=ftrace-disable-less.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the ring buffer is reentrant, some of the ftrace tracers
(sched_swich, debugging traces) can also be reentrant.

Note: Never make the function tracer reentrant, that can cause
  recursion problems all over the kernel. The function tracer
  must disable reentrancy.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |   10 ++--------
 kernel/trace/trace_sched_switch.c |   10 ++--------
 2 files changed, 4 insertions(+), 16 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-04 01:14:30.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-04 01:49:35.000000000 -0400
@@ -839,7 +839,6 @@ ftrace_special(unsigned long arg1, unsig
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	long disabled;
 	int cpu;
 	int pc;
 
@@ -850,12 +849,10 @@ ftrace_special(unsigned long arg1, unsig
 	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1))
+	if (likely(!atomic_read(&data->disabled)))
 		ftrace_trace_special(tr, data, arg1, arg2, arg3, pc);
 
-	atomic_dec(&data->disabled);
 	preempt_enable_notrace();
 }
 
@@ -2961,7 +2958,6 @@ int trace_vprintk(unsigned long ip, cons
 	struct trace_array_cpu *data;
 	struct print_entry *entry;
 	unsigned long flags, irq_flags;
-	long disabled;
 	int cpu, len = 0, size, pc;
 
 	if (!tr->ctrl || tracing_disabled)
@@ -2971,9 +2967,8 @@ int trace_vprintk(unsigned long ip, cons
 	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (unlikely(disabled != 1))
+	if (unlikely(atomic_read(&data->disabled)))
 		goto out;
 
 	spin_lock_irqsave(&trace_buf_lock, flags);
@@ -2999,7 +2994,6 @@ int trace_vprintk(unsigned long ip, cons
 	spin_unlock_irqrestore(&trace_buf_lock, flags);
 
  out:
-	atomic_dec(&data->disabled);
 	preempt_enable_notrace();
 
 	return len;
Index: linux-tip.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_switch.c	2008-10-04 01:14:30.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_switch.c	2008-10-04 01:49:35.000000000 -0400
@@ -24,7 +24,6 @@ probe_sched_switch(struct rq *__rq, stru
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
 	int cpu;
 	int pc;
 
@@ -41,12 +40,10 @@ probe_sched_switch(struct rq *__rq, stru
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1))
+	if (likely(!atomic_read(&data->disabled)))
 		tracing_sched_switch_trace(ctx_trace, data, prev, next, flags, pc);
 
-	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
@@ -55,7 +52,6 @@ probe_sched_wakeup(struct rq *__rq, stru
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;
-	long disabled;
 	int cpu, pc;
 
 	if (!likely(tracer_enabled))
@@ -67,13 +63,11 @@ probe_sched_wakeup(struct rq *__rq, stru
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
 
-	if (likely(disabled == 1))
+	if (likely(!atomic_read(&data->disabled)))
 		tracing_sched_wakeup_trace(ctx_trace, data, wakee, current,
 					   flags, pc);
 
-	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 

-- 
