Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYJAROd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYJAROd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYJAROQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:14:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYJARON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:14:13 -0400
Date: Wed, 1 Oct 2008 13:14:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Martin Bligh <mbligh@google.com>
Subject: [PATCH] ftrace: preempt disable over interrupt disable
In-Reply-To: <20081001072300.GD9366@elte.hu>
Message-ID: <alpine.DEB.1.10.0810011313280.2504@gandalf.stny.rr.com>
References: <20081001042951.412019606@goodmis.org> <c62985530810010020u1f3f44e1l6b8fb2f31c35d215@mail.gmail.com> <20081001072300.GD9366@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the new ring buffer infrastructure in ftrace, I'm trying to make
ftrace a little more light weight.

This patch converts a lot of the local_irq_save/restore into
preempt_disable/enable.  The original preempt count in a lot of cases
has to be sent in as a parameter so that it can be recorded correctly.
Some places were recording it incorrectly before anyway.

This is also laying the ground work to make ftrace a little bit
more reentrant, and remove all locking. The function tracers must
still protect from reentrancy.

Note: All the function tracers must be careful when using preempt_disable.
  It must do the following:

  resched = need_resched();
  preempt_disable_notrace();
  [...]
  if (resched)
	preempt_enable_no_resched_notrace();
  else
	preempt_enable_notrace();

The reason is that if this function traces schedule() itself, the
preempt_enable_notrace() will cause a schedule, which will lead
us into a recursive failure.

If we needed to reschedule before calling preempt_disable, we
should have already scheduled. Since we did not, this is most
likely that we should not and are probably inside a schedule
function.

If resched was not set, we still need to catch the need resched
flag being set when preemption was off and the if case at the
end will catch that for us.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |  123 +++++++++++++++++++-------------------
 kernel/trace/trace.h              |   13 ++--
 kernel/trace/trace_boot.c         |    2 
 kernel/trace/trace_irqsoff.c      |   13 ++--
 kernel/trace/trace_mmiotrace.c    |    4 -
 kernel/trace/trace_sched_switch.c |    9 +-
 kernel/trace/trace_sched_wakeup.c |   13 +++-
 7 files changed, 97 insertions(+), 80 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-01 10:41:59.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-01 12:18:14.000000000 -0400
@@ -652,12 +652,10 @@ void tracing_record_cmdline(struct task_
 }
 
 void
-tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
+tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
+			     int pc)
 {
 	struct task_struct *tsk = current;
-	unsigned long pc;
-
-	pc = preempt_count();
 
 	entry->preempt_count		= pc & 0xff;
 	entry->pid			= (tsk) ? tsk->pid : 0;
@@ -670,7 +668,8 @@ tracing_generic_entry_update(struct trac
 
 void
 trace_function(struct trace_array *tr, struct trace_array_cpu *data,
-	       unsigned long ip, unsigned long parent_ip, unsigned long flags)
+	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
+	       int pc)
 {
 	struct ring_buffer_event *event;
 	struct ftrace_entry *entry;
@@ -685,7 +684,7 @@ trace_function(struct trace_array *tr, s
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
 	entry->ent.type			= TRACE_FN;
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
@@ -694,16 +693,17 @@ trace_function(struct trace_array *tr, s
 
 void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
-       unsigned long ip, unsigned long parent_ip, unsigned long flags)
+       unsigned long ip, unsigned long parent_ip, unsigned long flags,
+       int pc)
 {
 	if (likely(!atomic_read(&data->disabled)))
-		trace_function(tr, data, ip, parent_ip, flags);
+		trace_function(tr, data, ip, parent_ip, flags, pc);
 }
 
-void __trace_stack(struct trace_array *tr,
-		   struct trace_array_cpu *data,
-		   unsigned long flags,
-		   int skip)
+static void ftrace_trace_stack(struct trace_array *tr,
+			       struct trace_array_cpu *data,
+			       unsigned long flags,
+			       int skip, int pc)
 {
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
@@ -718,7 +718,7 @@ void __trace_stack(struct trace_array *t
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
 	entry->ent.type		= TRACE_STACK;
 
 	memset(&entry->caller, 0, sizeof(entry->caller));
@@ -732,9 +732,18 @@ void __trace_stack(struct trace_array *t
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
 
-void
-__trace_special(void *__tr, void *__data,
-		unsigned long arg1, unsigned long arg2, unsigned long arg3)
+void __trace_stack(struct trace_array *tr,
+		   struct trace_array_cpu *data,
+		   unsigned long flags,
+		   int skip)
+{
+	ftrace_trace_stack(tr, data, flags, skip, preempt_count());
+}
+
+static void
+ftrace_trace_special(void *__tr, void *__data,
+		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
+		     int pc)
 {
 	struct ring_buffer_event *event;
 	struct trace_array_cpu *data = __data;
@@ -747,23 +756,30 @@ __trace_special(void *__tr, void *__data
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0);
+	tracing_generic_entry_update(&entry->ent, 0, pc);
 	entry->ent.type			= TRACE_SPECIAL;
 	entry->arg1			= arg1;
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	__trace_stack(tr, data, irq_flags, 4);
+	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
 
 	trace_wake_up();
 }
 
 void
+__trace_special(void *__tr, void *__data,
+		unsigned long arg1, unsigned long arg2, unsigned long arg3)
+{
+	ftrace_trace_special(__tr, __data, arg1, arg2, arg3, preempt_count());
+}
+
+void
 tracing_sched_switch_trace(struct trace_array *tr,
 			   struct trace_array_cpu *data,
 			   struct task_struct *prev,
 			   struct task_struct *next,
-			   unsigned long flags)
+			   unsigned long flags, int pc)
 {
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
@@ -774,7 +790,7 @@ tracing_sched_switch_trace(struct trace_
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
 	entry->ent.type			= TRACE_CTX;
 	entry->prev_pid			= prev->pid;
 	entry->prev_prio		= prev->prio;
@@ -784,7 +800,7 @@ tracing_sched_switch_trace(struct trace_
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	__trace_stack(tr, data, flags, 5);
+	ftrace_trace_stack(tr, data, flags, 5, pc);
 }
 
 void
@@ -792,7 +808,7 @@ tracing_sched_wakeup_trace(struct trace_
 			   struct trace_array_cpu *data,
 			   struct task_struct *wakee,
 			   struct task_struct *curr,
-			   unsigned long flags)
+			   unsigned long flags, int pc)
 {
 	struct ring_buffer_event *event;
 	struct ctx_switch_entry *entry;
@@ -803,7 +819,7 @@ tracing_sched_wakeup_trace(struct trace_
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
 	entry->ent.type			= TRACE_WAKE;
 	entry->prev_pid			= curr->pid;
 	entry->prev_prio		= curr->prio;
@@ -813,7 +829,7 @@ tracing_sched_wakeup_trace(struct trace_
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	__trace_stack(tr, data, flags, 6);
+	ftrace_trace_stack(tr, data, flags, 6, pc);
 
 	trace_wake_up();
 }
@@ -823,23 +839,24 @@ ftrace_special(unsigned long arg1, unsig
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	unsigned long flags;
 	long disabled;
 	int cpu;
+	int pc;
 
 	if (tracing_disabled || !tr->ctrl)
 		return;
 
-	local_irq_save(flags);
+	pc = preempt_count();
+	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		__trace_special(tr, data, arg1, arg2, arg3);
+		ftrace_trace_special(tr, data, arg1, arg2, arg3, pc);
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	preempt_enable_notrace();
 }
 
 #ifdef CONFIG_FTRACE
@@ -850,7 +867,8 @@ function_trace_call(unsigned long ip, un
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
-	int cpu;
+	int cpu, resched;
+	int pc;
 
 	if (unlikely(!ftrace_function_enabled))
 		return;
@@ -858,16 +876,22 @@ function_trace_call(unsigned long ip, un
 	if (skip_trace(ip))
 		return;
 
-	local_irq_save(flags);
+	pc = preempt_count();
+	resched = need_resched();
+	preempt_disable_notrace();
+	local_save_flags(flags);
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags);
+		trace_function(tr, data, ip, parent_ip, flags, pc);
 
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
 }
 
 static struct ftrace_ops trace_ops __read_mostly =
@@ -2508,9 +2532,6 @@ tracing_read_pipe(struct file *filp, cha
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-#ifdef CONFIG_FTRACE
-	int ftrace_save;
-#endif
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -2593,20 +2614,6 @@ waitagain:
 	       offsetof(struct trace_iterator, seq));
 	iter->pos = -1;
 
-	/*
-	 * We need to stop all tracing on all CPUS to read the
-	 * the next buffer. This is a bit expensive, but is
-	 * not done often. We fill all what we can read,
-	 * and then release the locks again.
-	 */
-
-	local_irq_disable();
-#ifdef CONFIG_FTRACE
-	ftrace_save = ftrace_enabled;
-	ftrace_enabled = 0;
-#endif
-	smp_wmb();
-
 	while (find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
@@ -2624,11 +2631,6 @@ waitagain:
 			break;
 	}
 
-#ifdef CONFIG_FTRACE
-	ftrace_enabled = ftrace_save;
-#endif
-	local_irq_enable();
-
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
 	if (iter->seq.readpos >= iter->seq.len)
@@ -2960,12 +2962,13 @@ int trace_vprintk(unsigned long ip, cons
 	struct print_entry *entry;
 	unsigned long flags, irq_flags;
 	long disabled;
-	int cpu, len = 0, size;
+	int cpu, len = 0, size, pc;
 
 	if (!tr->ctrl || tracing_disabled)
 		return 0;
 
-	local_irq_save(flags);
+	pc = preempt_count();
+	preempt_disable_notrace();
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
@@ -2973,7 +2976,7 @@ int trace_vprintk(unsigned long ip, cons
 	if (unlikely(disabled != 1))
 		goto out;
 
-	spin_lock(&trace_buf_lock);
+	spin_lock_irqsave(&trace_buf_lock, flags);
 	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	len = min(len, TRACE_BUF_SIZE-1);
@@ -2984,7 +2987,7 @@ int trace_vprintk(unsigned long ip, cons
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, flags);
+	tracing_generic_entry_update(&entry->ent, flags, pc);
 	entry->ent.type			= TRACE_PRINT;
 	entry->ip			= ip;
 
@@ -2993,11 +2996,11 @@ int trace_vprintk(unsigned long ip, cons
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
  out_unlock:
-	spin_unlock(&trace_buf_lock);
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
 
  out:
 	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
+	preempt_enable_notrace();
 
 	return len;
 }
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-10-01 10:41:59.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-10-01 11:42:37.000000000 -0400
@@ -288,35 +288,36 @@ void init_tracer_sysprof_debugfs(struct 
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
 void tracing_generic_entry_update(struct trace_entry *entry,
-						unsigned long flags);
+				  unsigned long flags,
+				  int pc);
 
 void ftrace(struct trace_array *tr,
 			    struct trace_array_cpu *data,
 			    unsigned long ip,
 			    unsigned long parent_ip,
-			    unsigned long flags);
+			    unsigned long flags, int pc);
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct task_struct *prev,
 				struct task_struct *next,
-				unsigned long flags);
+				unsigned long flags, int pc);
 void tracing_record_cmdline(struct task_struct *tsk);
 
 void tracing_sched_wakeup_trace(struct trace_array *tr,
 				struct trace_array_cpu *data,
 				struct task_struct *wakee,
 				struct task_struct *cur,
-				unsigned long flags);
+				unsigned long flags, int pc);
 void trace_special(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long arg1,
 		   unsigned long arg2,
-		   unsigned long arg3);
+		   unsigned long arg3, int pc);
 void trace_function(struct trace_array *tr,
 		    struct trace_array_cpu *data,
 		    unsigned long ip,
 		    unsigned long parent_ip,
-		    unsigned long flags);
+		    unsigned long flags, int pc);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
Index: linux-tip.git/kernel/trace/trace_boot.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_boot.c	2008-10-01 10:41:18.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_boot.c	2008-10-01 12:16:03.000000000 -0400
@@ -95,7 +95,7 @@ void trace_boot(struct boot_trace *it)
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
 	entry->ent.type = TRACE_BOOT;
 	entry->initcall = *it;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
Index: linux-tip.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_irqsoff.c	2008-10-01 10:41:18.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_irqsoff.c	2008-10-01 11:46:11.000000000 -0400
@@ -95,7 +95,7 @@ irqsoff_tracer_call(unsigned long ip, un
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags);
+		trace_function(tr, data, ip, parent_ip, flags, preempt_count());
 
 	atomic_dec(&data->disabled);
 }
@@ -130,6 +130,7 @@ check_critical_timing(struct trace_array
 	unsigned long latency, t0, t1;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
+	int pc;
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -144,13 +145,15 @@ check_critical_timing(struct trace_array
 	if (!report_latency(delta))
 		goto out;
 
+	pc = preempt_count();
+
 	spin_lock_irqsave(&max_trace_lock, flags);
 
 	/* check if we are still the max latency */
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags);
+	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags, pc);
 
 	latency = nsecs_to_usecs(delta);
 
@@ -174,7 +177,7 @@ out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_reset(tr, cpu);
-	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags);
+	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
 static inline void
@@ -207,7 +210,7 @@ start_critical_timing(unsigned long ip, 
 
 	local_save_flags(flags);
 
-	trace_function(tr, data, ip, parent_ip, flags);
+	trace_function(tr, data, ip, parent_ip, flags, preempt_count());
 
 	per_cpu(tracing_cpu, cpu) = 1;
 
@@ -241,7 +244,7 @@ stop_critical_timing(unsigned long ip, u
 	atomic_inc(&data->disabled);
 
 	local_save_flags(flags);
-	trace_function(tr, data, ip, parent_ip, flags);
+	trace_function(tr, data, ip, parent_ip, flags, preempt_count());
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
Index: linux-tip.git/kernel/trace/trace_mmiotrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_mmiotrace.c	2008-10-01 10:41:59.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_mmiotrace.c	2008-10-01 11:47:15.000000000 -0400
@@ -324,7 +324,7 @@ static void __trace_mmiotrace_rw(struct 
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
 	entry->ent.type			= TRACE_MMIO_RW;
 	entry->rw			= *rw;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
@@ -352,7 +352,7 @@ static void __trace_mmiotrace_map(struct
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(&entry->ent, 0);
+	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
 	entry->ent.type			= TRACE_MMIO_MAP;
 	entry->map			= *map;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
Index: linux-tip.git/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_switch.c	2008-10-01 10:41:18.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_switch.c	2008-10-01 12:18:49.000000000 -0400
@@ -26,6 +26,7 @@ probe_sched_switch(struct rq *__rq, stru
 	unsigned long flags;
 	long disabled;
 	int cpu;
+	int pc;
 
 	if (!atomic_read(&sched_ref))
 		return;
@@ -36,13 +37,14 @@ probe_sched_switch(struct rq *__rq, stru
 	if (!tracer_enabled)
 		return;
 
+	pc = preempt_count();
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = ctx_trace->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		tracing_sched_switch_trace(ctx_trace, data, prev, next, flags);
+		tracing_sched_switch_trace(ctx_trace, data, prev, next, flags, pc);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
@@ -54,11 +56,12 @@ probe_sched_wakeup(struct rq *__rq, stru
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
-	int cpu;
+	int cpu, pc;
 
 	if (!likely(tracer_enabled))
 		return;
 
+	pc = preempt_count();
 	tracing_record_cmdline(current);
 
 	local_irq_save(flags);
@@ -68,7 +71,7 @@ probe_sched_wakeup(struct rq *__rq, stru
 
 	if (likely(disabled == 1))
 		tracing_sched_wakeup_trace(ctx_trace, data, wakee, current,
-			flags);
+					   flags, pc);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
Index: linux-tip.git/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_sched_wakeup.c	2008-10-01 10:41:18.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_sched_wakeup.c	2008-10-01 12:15:10.000000000 -0400
@@ -44,10 +44,12 @@ wakeup_tracer_call(unsigned long ip, uns
 	long disabled;
 	int resched;
 	int cpu;
+	int pc;
 
 	if (likely(!wakeup_task))
 		return;
 
+	pc = preempt_count();
 	resched = need_resched();
 	preempt_disable_notrace();
 
@@ -70,7 +72,7 @@ wakeup_tracer_call(unsigned long ip, uns
 	if (task_cpu(wakeup_task) != cpu)
 		goto unlock;
 
-	trace_function(tr, data, ip, parent_ip, flags);
+	trace_function(tr, data, ip, parent_ip, flags, pc);
 
  unlock:
 	__raw_spin_unlock(&wakeup_lock);
@@ -121,6 +123,7 @@ probe_wakeup_sched_switch(struct rq *rq,
 	unsigned long flags;
 	long disabled;
 	int cpu;
+	int pc;
 
 	tracing_record_cmdline(prev);
 
@@ -139,6 +142,8 @@ probe_wakeup_sched_switch(struct rq *rq,
 	if (next != wakeup_task)
 		return;
 
+	pc = preempt_count();
+
 	/* The task we are waiting for is waking up */
 	data = wakeup_trace->data[wakeup_cpu];
 
@@ -155,7 +160,7 @@ probe_wakeup_sched_switch(struct rq *rq,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
-	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2, flags);
+	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -220,6 +225,7 @@ probe_wakeup(struct rq *rq, struct task_
 	int cpu = smp_processor_id();
 	unsigned long flags;
 	long disabled;
+	int pc;
 
 	if (likely(!tracer_enabled))
 		return;
@@ -232,6 +238,7 @@ probe_wakeup(struct rq *rq, struct task_
 			p->prio >= current->prio)
 		return;
 
+	pc = preempt_count();
 	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
@@ -256,7 +263,7 @@ probe_wakeup(struct rq *rq, struct task_
 
 	wakeup_trace->data[wakeup_cpu]->preempt_timestamp = ftrace_now(cpu);
 	trace_function(wakeup_trace, wakeup_trace->data[wakeup_cpu],
-		       CALLER_ADDR1, CALLER_ADDR2, flags);
+		       CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
 	__raw_spin_unlock(&wakeup_lock);


