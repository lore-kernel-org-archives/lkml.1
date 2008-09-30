Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbYI3DIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbYI3DIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYI3DHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:07:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51397 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYI3DG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:06:57 -0400
Message-Id: <20080930030652.883661046@goodmis.org>
References: <20080930030236.230994826@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 23:02:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 6/6] ftrace: take advantage of variable length entries
Content-Disposition: inline; filename=ftrace-variable-length-entries.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the underlining ring buffer for ftrace now hold variable length
entries, we can take advantage of this by only storing the size of the
actual event into the buffer. This happens to increase the number of
entries in the buffer dramatically.

We can also get rid of the "trace_cont" operation, but I'm keeping that
until we have no more users. Some of the ftrace tracers can now change
their code to adapt to this new feature.

CC: Pekka Paalanen <pq@iki.fi>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c           |  441 +++++++++++++++++++++--------------------
 kernel/trace/trace.h           |   81 +++----
 kernel/trace/trace_boot.c      |   13 -
 kernel/trace/trace_mmiotrace.c |   31 +-
 4 files changed, 302 insertions(+), 264 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-09-29 22:28:11.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-09-29 22:55:53.000000000 -0400
@@ -637,9 +637,9 @@ tracing_generic_entry_update(struct trac
 
 	pc = preempt_count();
 
-	entry->field.preempt_count	= pc & 0xff;
-	entry->field.pid		= (tsk) ? tsk->pid : 0;
-	entry->field.flags =
+	entry->preempt_count		= pc & 0xff;
+	entry->pid			= (tsk) ? tsk->pid : 0;
+	entry->flags =
 		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
@@ -651,7 +651,7 @@ trace_function(struct trace_array *tr, s
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct ftrace_entry *entry;
 	unsigned long irq_flags;
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
@@ -659,10 +659,10 @@ trace_function(struct trace_array *tr, s
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, flags);
-	entry->type			= TRACE_FN;
-	entry->field.fn.ip		= ip;
-	entry->field.fn.parent_ip	= parent_ip;
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->ent.type			= TRACE_FN;
+	entry->ip			= ip;
+	entry->parent_ip		= parent_ip;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
 
@@ -680,7 +680,7 @@ void __trace_stack(struct trace_array *t
 		   int skip)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct stack_entry *entry;
 	struct stack_trace trace;
 	unsigned long irq_flags;
 
@@ -692,15 +692,15 @@ void __trace_stack(struct trace_array *t
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_STACK;
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->ent.type		= TRACE_STACK;
 
-	memset(&entry->field.stack, 0, sizeof(entry->field.stack));
+	memset(&entry->caller, 0, sizeof(entry->caller));
 
 	trace.nr_entries	= 0;
 	trace.max_entries	= FTRACE_STACK_ENTRIES;
 	trace.skip		= skip;
-	trace.entries		= entry->field.stack.caller;
+	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
@@ -713,7 +713,7 @@ __trace_special(void *__tr, void *__data
 	struct ring_buffer_event *event;
 	struct trace_array_cpu *data = __data;
 	struct trace_array *tr = __tr;
-	struct trace_entry *entry;
+	struct special_entry *entry;
 	unsigned long irq_flags;
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
@@ -721,11 +721,11 @@ __trace_special(void *__tr, void *__data
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, 0);
-	entry->type			= TRACE_SPECIAL;
-	entry->field.special.arg1	= arg1;
-	entry->field.special.arg2	= arg2;
-	entry->field.special.arg3	= arg3;
+	tracing_generic_entry_update(&entry->ent, 0);
+	entry->ent.type			= TRACE_SPECIAL;
+	entry->arg1			= arg1;
+	entry->arg2			= arg2;
+	entry->arg3			= arg3;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	__trace_stack(tr, data, irq_flags, 4);
 
@@ -740,7 +740,7 @@ tracing_sched_switch_trace(struct trace_
 			   unsigned long flags)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
@@ -748,15 +748,15 @@ tracing_sched_switch_trace(struct trace_
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, flags);
-	entry->type			= TRACE_CTX;
-	entry->field.ctx.prev_pid	= prev->pid;
-	entry->field.ctx.prev_prio	= prev->prio;
-	entry->field.ctx.prev_state	= prev->state;
-	entry->field.ctx.next_pid	= next->pid;
-	entry->field.ctx.next_prio	= next->prio;
-	entry->field.ctx.next_state	= next->state;
-	entry->field.ctx.next_cpu	= task_cpu(next);
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->ent.type			= TRACE_CTX;
+	entry->prev_pid			= prev->pid;
+	entry->prev_prio		= prev->prio;
+	entry->prev_state		= prev->state;
+	entry->next_pid			= next->pid;
+	entry->next_prio		= next->prio;
+	entry->next_state		= next->state;
+	entry->next_cpu	= task_cpu(next);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	__trace_stack(tr, data, flags, 5);
 }
@@ -769,7 +769,7 @@ tracing_sched_wakeup_trace(struct trace_
 			   unsigned long flags)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct ctx_switch_entry *entry;
 	unsigned long irq_flags;
 
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
@@ -777,15 +777,15 @@ tracing_sched_wakeup_trace(struct trace_
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_WAKE;
-	entry->field.ctx.prev_pid	= curr->pid;
-	entry->field.ctx.prev_prio	= curr->prio;
-	entry->field.ctx.prev_state	= curr->state;
-	entry->field.ctx.next_pid	= wakee->pid;
-	entry->field.ctx.next_prio	= wakee->prio;
-	entry->field.ctx.next_state	= wakee->state;
-	entry->field.ctx.next_cpu	= task_cpu(wakee);
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->ent.type			= TRACE_WAKE;
+	entry->prev_pid			= curr->pid;
+	entry->prev_prio		= curr->prio;
+	entry->prev_state		= curr->state;
+	entry->next_pid			= wakee->pid;
+	entry->next_prio		= wakee->prio;
+	entry->next_state		= wakee->state;
+	entry->next_cpu			= task_cpu(wakee);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 	__trace_stack(tr, data, flags, 6);
 
@@ -1173,20 +1173,19 @@ print_trace_header(struct seq_file *m, s
 static void
 lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 {
-	struct trace_field *field = &entry->field;
 	int hardirq, softirq;
 	char *comm;
 
-	comm = trace_find_cmdline(field->pid);
+	comm = trace_find_cmdline(entry->pid);
 
-	trace_seq_printf(s, "%8.8s-%-5d ", comm, field->pid);
+	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
 	trace_seq_printf(s, "%3d", cpu);
 	trace_seq_printf(s, "%c%c",
-			(field->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
-			((field->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
+			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
+			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
 
-	hardirq = field->flags & TRACE_FLAG_HARDIRQ;
-	softirq = field->flags & TRACE_FLAG_SOFTIRQ;
+	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
+	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
 	if (hardirq && softirq) {
 		trace_seq_putc(s, 'H');
 	} else {
@@ -1200,8 +1199,8 @@ lat_print_generic(struct trace_seq *s, s
 		}
 	}
 
-	if (field->preempt_count)
-		trace_seq_printf(s, "%x", field->preempt_count);
+	if (entry->preempt_count)
+		trace_seq_printf(s, "%x", entry->preempt_count);
 	else
 		trace_seq_puts(s, ".");
 }
@@ -1230,6 +1229,7 @@ static const char state_to_char[] = TASK
 void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
 {
 	struct trace_entry *ent;
+	struct trace_field_cont *cont;
 	bool ok = true;
 
 	ent = peek_next_entry(iter, iter->cpu, NULL);
@@ -1239,8 +1239,9 @@ void trace_seq_print_cont(struct trace_s
 	}
 
 	do {
+		cont = (struct trace_field_cont *)ent;
 		if (ok)
-			ok = (trace_seq_printf(s, "%s", ent->cont.buf) > 0);
+			ok = (trace_seq_printf(s, "%s", cont->buf) > 0);
 		ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
 		ent = peek_next_entry(iter, iter->cpu, NULL);
 	} while (ent && ent->type == TRACE_CONT);
@@ -1257,7 +1258,6 @@ print_lat_fmt(struct trace_iterator *ite
 	struct trace_entry *next_entry;
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
-	struct trace_field *field = &entry->field;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
 	u64 next_ts;
@@ -1276,12 +1276,12 @@ print_lat_fmt(struct trace_iterator *ite
 	abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
 
 	if (verbose) {
-		comm = trace_find_cmdline(field->pid);
+		comm = trace_find_cmdline(entry->pid);
 		trace_seq_printf(s, "%16s %5d %3d %d %08x %08x [%08lx]"
 				 " %ld.%03ldms (+%ld.%03ldms): ",
 				 comm,
-				 field->pid, cpu, field->flags,
-				 field->preempt_count, trace_idx,
+				 entry->pid, cpu, entry->flags,
+				 entry->preempt_count, trace_idx,
 				 ns2usecs(iter->ts),
 				 abs_usecs/1000,
 				 abs_usecs % 1000, rel_usecs/1000,
@@ -1291,53 +1291,69 @@ print_lat_fmt(struct trace_iterator *ite
 		lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
 	switch (entry->type) {
-	case TRACE_FN:
-		seq_print_ip_sym(s, field->fn.ip, sym_flags);
+	case TRACE_FN: {
+		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_puts(s, " (");
-		if (kretprobed(field->fn.parent_ip))
+		if (kretprobed(field->parent_ip))
 			trace_seq_puts(s, KRETPROBE_MSG);
 		else
-			seq_print_ip_sym(s, field->fn.parent_ip, sym_flags);
+			seq_print_ip_sym(s, field->parent_ip, sym_flags);
 		trace_seq_puts(s, ")\n");
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		T = field->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field =
+			(struct ctx_switch_entry *)entry;
 
-		state = field->ctx.prev_state ?
-			__ffs(field->ctx.prev_state) + 1 : 0;
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
+
+		state = field->prev_state ?
+			__ffs(field->prev_state) + 1 : 0;
 		S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
-		comm = trace_find_cmdline(field->ctx.next_pid);
+		comm = trace_find_cmdline(field->next_pid);
 		trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
-				 field->ctx.prev_pid,
-				 field->ctx.prev_prio,
+				 field->prev_pid,
+				 field->prev_prio,
 				 S, entry->type == TRACE_CTX ? "==>" : "  +",
-				 field->ctx.next_cpu,
-				 field->ctx.next_pid,
-				 field->ctx.next_prio,
+				 field->next_cpu,
+				 field->next_pid,
+				 field->next_prio,
 				 T, comm);
 		break;
-	case TRACE_SPECIAL:
+	}
+	case TRACE_SPECIAL: {
+		struct special_entry *field = (struct special_entry *)entry;
+
 		trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->special.arg1,
-				 field->special.arg2,
-				 field->special.arg3);
+				 field->arg1,
+				 field->arg2,
+				 field->arg3);
 		break;
-	case TRACE_STACK:
+	}
+	case TRACE_STACK: {
+		struct stack_entry *field = (struct stack_entry *)entry;
+
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i)
 				trace_seq_puts(s, " <= ");
-			seq_print_ip_sym(s, field->stack.caller[i], sym_flags);
+			seq_print_ip_sym(s, field->caller[i], sym_flags);
 		}
 		trace_seq_puts(s, "\n");
 		break;
-	case TRACE_PRINT:
-		seq_print_ip_sym(s, field->print.ip, sym_flags);
-		trace_seq_printf(s, ": %s", field->print.buf);
-		if (field->flags & TRACE_FLAG_CONT)
+	}
+	case TRACE_PRINT: {
+		struct print_entry *field = (struct print_entry *)entry;
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
+		trace_seq_printf(s, ": %s", field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
+	}
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1349,7 +1365,6 @@ static int print_trace_fmt(struct trace_
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
-	struct trace_field *field;
 	unsigned long usec_rem;
 	unsigned long long t;
 	unsigned long secs;
@@ -1363,15 +1378,13 @@ static int print_trace_fmt(struct trace_
 	if (entry->type == TRACE_CONT)
 		return 1;
 
-	field = &entry->field;
-
-	comm = trace_find_cmdline(iter->ent->field.pid);
+	comm = trace_find_cmdline(iter->ent->pid);
 
 	t = ns2usecs(iter->ts);
 	usec_rem = do_div(t, 1000000ULL);
 	secs = (unsigned long)t;
 
-	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
+	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
 	if (!ret)
 		return 0;
 	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
@@ -1382,20 +1395,22 @@ static int print_trace_fmt(struct trace_
 		return 0;
 
 	switch (entry->type) {
-	case TRACE_FN:
-		ret = seq_print_ip_sym(s, field->fn.ip, sym_flags);
+	case TRACE_FN: {
+		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+
+		ret = seq_print_ip_sym(s, field->ip, sym_flags);
 		if (!ret)
 			return 0;
 		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
-						field->fn.parent_ip) {
+						field->parent_ip) {
 			ret = trace_seq_printf(s, " <-");
 			if (!ret)
 				return 0;
-			if (kretprobed(field->fn.parent_ip))
+			if (kretprobed(field->parent_ip))
 				ret = trace_seq_puts(s, KRETPROBE_MSG);
 			else
 				ret = seq_print_ip_sym(s,
-						       field->fn.parent_ip,
+						       field->parent_ip,
 						       sym_flags);
 			if (!ret)
 				return 0;
@@ -1404,40 +1419,50 @@ static int print_trace_fmt(struct trace_
 		if (!ret)
 			return 0;
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		S = field->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.prev_state] : 'X';
-		T = field->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field =
+			(struct ctx_switch_entry *)entry;
+
+		S = field->prev_state < sizeof(state_to_char) ?
+			state_to_char[field->prev_state] : 'X';
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
 		ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
-				       field->ctx.prev_pid,
-				       field->ctx.prev_prio,
+				       field->prev_pid,
+				       field->prev_prio,
 				       S,
 				       entry->type == TRACE_CTX ? "==>" : "  +",
-				       field->ctx.next_cpu,
-				       field->ctx.next_pid,
-				       field->ctx.next_prio,
+				       field->next_cpu,
+				       field->next_pid,
+				       field->next_prio,
 				       T);
 		if (!ret)
 			return 0;
 		break;
-	case TRACE_SPECIAL:
+	}
+	case TRACE_SPECIAL: {
+		struct special_entry *field = (struct special_entry *)entry;
+
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->special.arg1,
-				 field->special.arg2,
-				 field->special.arg3);
+				 field->arg1,
+				 field->arg2,
+				 field->arg3);
 		if (!ret)
 			return 0;
 		break;
-	case TRACE_STACK:
+	}
+	case TRACE_STACK: {
+		struct stack_entry *field = (struct stack_entry *)entry;
+
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i) {
 				ret = trace_seq_puts(s, " <= ");
 				if (!ret)
 					return 0;
 			}
-			ret = seq_print_ip_sym(s, field->stack.caller[i],
+			ret = seq_print_ip_sym(s, field->caller[i],
 					       sym_flags);
 			if (!ret)
 				return 0;
@@ -1446,13 +1471,17 @@ static int print_trace_fmt(struct trace_
 		if (!ret)
 			return 0;
 		break;
-	case TRACE_PRINT:
-		seq_print_ip_sym(s, field->print.ip, sym_flags);
-		trace_seq_printf(s, ": %s", field->print.buf);
-		if (field->flags & TRACE_FLAG_CONT)
+	}
+	case TRACE_PRINT: {
+		struct print_entry *field = (struct print_entry *)entry;
+
+		seq_print_ip_sym(s, field->ip, sym_flags);
+		trace_seq_printf(s, ": %s", field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	}
 	return 1;
 }
 
@@ -1460,7 +1489,6 @@ static int print_raw_fmt(struct trace_it
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
-	struct trace_field *field;
 	int ret;
 	int S, T;
 
@@ -1469,56 +1497,66 @@ static int print_raw_fmt(struct trace_it
 	if (entry->type == TRACE_CONT)
 		return 1;
 
-	field = &entry->field;
-
 	ret = trace_seq_printf(s, "%d %d %llu ",
-		field->pid, iter->cpu, iter->ts);
+		entry->pid, iter->cpu, iter->ts);
 	if (!ret)
 		return 0;
 
 	switch (entry->type) {
-	case TRACE_FN:
+	case TRACE_FN: {
+		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+
 		ret = trace_seq_printf(s, "%x %x\n",
-					field->fn.ip,
-					field->fn.parent_ip);
+					field->ip,
+					field->parent_ip);
 		if (!ret)
 			return 0;
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		S = field->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.prev_state] : 'X';
-		T = field->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field =
+			(struct ctx_switch_entry *)entry;
+
+		S = field->prev_state < sizeof(state_to_char) ?
+			state_to_char[field->prev_state] : 'X';
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
 		ret = trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
-				       field->ctx.prev_pid,
-				       field->ctx.prev_prio,
+				       field->prev_pid,
+				       field->prev_prio,
 				       S,
-				       field->ctx.next_cpu,
-				       field->ctx.next_pid,
-				       field->ctx.next_prio,
+				       field->next_cpu,
+				       field->next_pid,
+				       field->next_prio,
 				       T);
 		if (!ret)
 			return 0;
 		break;
+	}
 	case TRACE_SPECIAL:
-	case TRACE_STACK:
+	case TRACE_STACK: {
+		struct special_entry *field = (struct special_entry *)entry;
+
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->special.arg1,
-				 field->special.arg2,
-				 field->special.arg3);
+				 field->arg1,
+				 field->arg2,
+				 field->arg3);
 		if (!ret)
 			return 0;
 		break;
-	case TRACE_PRINT:
-		trace_seq_printf(s, "# %lx %s",
-				 field->print.ip, field->print.buf);
-		if (field->flags & TRACE_FLAG_CONT)
+	}
+	case TRACE_PRINT: {
+		struct print_entry *field = (struct print_entry *)entry;
+
+		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
+	}
 	return 1;
 }
 
@@ -1539,7 +1577,6 @@ static int print_hex_fmt(struct trace_it
 	struct trace_seq *s = &iter->seq;
 	unsigned char newline = '\n';
 	struct trace_entry *entry;
-	struct trace_field *field;
 	int S, T;
 
 	entry = iter->ent;
@@ -1547,40 +1584,48 @@ static int print_hex_fmt(struct trace_it
 	if (entry->type == TRACE_CONT)
 		return 1;
 
-	field = &entry->field;
-
-	SEQ_PUT_HEX_FIELD_RET(s, field->pid);
+	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
-	case TRACE_FN:
-		SEQ_PUT_HEX_FIELD_RET(s, field->fn.ip);
-		SEQ_PUT_HEX_FIELD_RET(s, field->fn.parent_ip);
+	case TRACE_FN: {
+		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+
+		SEQ_PUT_HEX_FIELD_RET(s, field->ip);
+		SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
 		break;
+	}
 	case TRACE_CTX:
-	case TRACE_WAKE:
-		S = field->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.prev_state] : 'X';
-		T = field->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[field->ctx.next_state] : 'X';
+	case TRACE_WAKE: {
+		struct ctx_switch_entry *field =
+			(struct ctx_switch_entry *)entry;
+
+		S = field->prev_state < sizeof(state_to_char) ?
+			state_to_char[field->prev_state] : 'X';
+		T = field->next_state < sizeof(state_to_char) ?
+			state_to_char[field->next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
-		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.prev_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.prev_prio);
+		SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, S);
-		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_cpu);
-		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_prio);
+		SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
+		SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, T);
 		break;
+	}
 	case TRACE_SPECIAL:
-	case TRACE_STACK:
-		SEQ_PUT_HEX_FIELD_RET(s, field->special.arg1);
-		SEQ_PUT_HEX_FIELD_RET(s, field->special.arg2);
-		SEQ_PUT_HEX_FIELD_RET(s, field->special.arg3);
+	case TRACE_STACK: {
+		struct special_entry *field = (struct special_entry *)entry;
+
+		SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
+		SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
+		SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
 		break;
 	}
+	}
 	SEQ_PUT_FIELD_RET(s, newline);
 
 	return 1;
@@ -1590,39 +1635,46 @@ static int print_bin_fmt(struct trace_it
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
-	struct trace_field *field;
 
 	entry = iter->ent;
 
 	if (entry->type == TRACE_CONT)
 		return 1;
 
-	field = &entry->field;
-
-	SEQ_PUT_FIELD_RET(s, field->pid);
-	SEQ_PUT_FIELD_RET(s, field->cpu);
+	SEQ_PUT_FIELD_RET(s, entry->pid);
+	SEQ_PUT_FIELD_RET(s, iter->cpu);
 	SEQ_PUT_FIELD_RET(s, iter->ts);
 
 	switch (entry->type) {
-	case TRACE_FN:
-		SEQ_PUT_FIELD_RET(s, field->fn.ip);
-		SEQ_PUT_FIELD_RET(s, field->fn.parent_ip);
+	case TRACE_FN: {
+		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+
+		SEQ_PUT_FIELD_RET(s, field->ip);
+		SEQ_PUT_FIELD_RET(s, field->parent_ip);
 		break;
-	case TRACE_CTX:
-		SEQ_PUT_FIELD_RET(s, field->ctx.prev_pid);
-		SEQ_PUT_FIELD_RET(s, field->ctx.prev_prio);
-		SEQ_PUT_FIELD_RET(s, field->ctx.prev_state);
-		SEQ_PUT_FIELD_RET(s, field->ctx.next_pid);
-		SEQ_PUT_FIELD_RET(s, field->ctx.next_prio);
-		SEQ_PUT_FIELD_RET(s, field->ctx.next_state);
+	}
+	case TRACE_CTX: {
+		struct ctx_switch_entry *field =
+			(struct ctx_switch_entry *)entry;
+
+		SEQ_PUT_FIELD_RET(s, field->prev_pid);
+		SEQ_PUT_FIELD_RET(s, field->prev_prio);
+		SEQ_PUT_FIELD_RET(s, field->prev_state);
+		SEQ_PUT_FIELD_RET(s, field->next_pid);
+		SEQ_PUT_FIELD_RET(s, field->next_prio);
+		SEQ_PUT_FIELD_RET(s, field->next_state);
 		break;
+	}
 	case TRACE_SPECIAL:
-	case TRACE_STACK:
-		SEQ_PUT_FIELD_RET(s, field->special.arg1);
-		SEQ_PUT_FIELD_RET(s, field->special.arg2);
-		SEQ_PUT_FIELD_RET(s, field->special.arg3);
+	case TRACE_STACK: {
+		struct special_entry *field = (struct special_entry *)entry;
+
+		SEQ_PUT_FIELD_RET(s, field->arg1);
+		SEQ_PUT_FIELD_RET(s, field->arg2);
+		SEQ_PUT_FIELD_RET(s, field->arg3);
 		break;
 	}
+	}
 	return 1;
 }
 
@@ -2818,10 +2870,10 @@ int trace_vprintk(unsigned long ip, cons
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	struct trace_entry *entry;
+	struct print_entry *entry;
 	unsigned long flags, irq_flags;
 	long disabled;
-	int cpu, len = 0, write, written = 0;
+	int cpu, len = 0, size;
 
 	if (!tr->ctrl || tracing_disabled)
 		return 0;
@@ -2840,39 +2892,18 @@ int trace_vprintk(unsigned long ip, cons
 	len = min(len, TRACE_BUF_SIZE-1);
 	trace_buf[len] = 0;
 
-	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
-					 &irq_flags);
+	size = sizeof(*entry) + len + 1;
+	event = ring_buffer_lock_reserve(tr->buffer, size, &irq_flags);
 	if (!event)
 		goto out_unlock;
-	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, flags);
-	entry->type			= TRACE_PRINT;
-	entry->field.print.ip		= ip;
-
-	write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
-
-	memcpy(&entry->field.print.buf, trace_buf, write);
-	entry->field.print.buf[write] = 0;
-	written = write;
-	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+	entry = ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, flags);
+	entry->ent.type			= TRACE_PRINT;
+	entry->ip			= ip;
 
-	if (written != len)
-		entry->field.flags |= TRACE_FLAG_CONT;
-
-	while (written != len) {
-		event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
-						 &irq_flags);
-		if (!event)
-			goto out_unlock;
-		entry	= ring_buffer_event_data(event);
-
-		entry->type = TRACE_CONT;
-		write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
-		memcpy(&entry->cont.buf, trace_buf+written, write);
-		entry->cont.buf[write] = 0;
-		written += write;
-		ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	}
+	memcpy(&entry->buf, trace_buf, len);
+	entry->buf[len] = 0;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
  out_unlock:
 	spin_unlock(&trace_buf_lock);
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-09-29 22:27:59.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-09-29 22:32:54.000000000 -0400
@@ -27,9 +27,24 @@ enum trace_type {
 };
 
 /*
+ * The trace entry - the most basic unit of tracing. This is what
+ * is printed in the end as a single line in the trace output, such as:
+ *
+ *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
+ */
+struct trace_entry {
+	unsigned char		type;
+	unsigned char		cpu;
+	unsigned char		flags;
+	unsigned char		preempt_count;
+	int			pid;
+};
+
+/*
  * Function trace entry - function address and parent function addres:
  */
 struct ftrace_entry {
+	struct trace_entry	ent;
 	unsigned long		ip;
 	unsigned long		parent_ip;
 };
@@ -39,6 +54,7 @@ extern struct tracer boot_tracer;
  * Context switch trace entry - which task (and prio) we switched from/to:
  */
 struct ctx_switch_entry {
+	struct trace_entry	ent;
 	unsigned int		prev_pid;
 	unsigned char		prev_prio;
 	unsigned char		prev_state;
@@ -52,6 +68,7 @@ struct ctx_switch_entry {
  * Special (free-form) trace entry:
  */
 struct special_entry {
+	struct trace_entry	ent;
 	unsigned long		arg1;
 	unsigned long		arg2;
 	unsigned long		arg3;
@@ -64,6 +81,7 @@ struct special_entry {
 #define FTRACE_STACK_ENTRIES	8
 
 struct stack_entry {
+	struct trace_entry	ent;
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
@@ -71,10 +89,34 @@ struct stack_entry {
  * ftrace_printk entry:
  */
 struct print_entry {
+	struct trace_entry	ent;
 	unsigned long		ip;
 	char			buf[];
 };
 
+#define TRACE_OLD_SIZE		88
+
+struct trace_field_cont {
+	unsigned char		type;
+	/* Temporary till we get rid of this completely */
+	char			buf[TRACE_OLD_SIZE - 1];
+};
+
+struct trace_mmiotrace_rw {
+	struct trace_entry	ent;
+	struct mmiotrace_rw	rw;
+};
+
+struct trace_mmiotrace_map {
+	struct trace_entry	ent;
+	struct mmiotrace_map	map;
+};
+
+struct trace_boot {
+	struct trace_entry	ent;
+	struct boot_trace	initcall;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -92,46 +134,7 @@ enum trace_flag_type {
 	TRACE_FLAG_CONT			= 0x10,
 };
 
-/*
- * The trace field - the most basic unit of tracing. This is what
- * is printed in the end as a single line in the trace output, such as:
- *
- *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
- */
-struct trace_field {
-	char			cpu;
-	char			flags;
-	char			preempt_count;
-	int			pid;
-	union {
-		struct ftrace_entry		fn;
-		struct ctx_switch_entry		ctx;
-		struct special_entry		special;
-		struct stack_entry		stack;
-		struct print_entry		print;
-		struct mmiotrace_rw		mmiorw;
-		struct mmiotrace_map		mmiomap;
-		struct boot_trace		initcall;
-	};
-};
-
-struct trace_field_cont {
-	char				buf[sizeof(struct trace_field)];
-};
-
-struct trace_entry {
-	char 				type;
-	union {
-		struct trace_field	field;
-		struct trace_field_cont	cont;
-	};
-};
-
-#define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
 #define TRACE_BUF_SIZE		1024
-#define TRACE_PRINT_BUF_SIZE \
-	(sizeof(struct trace_field) - offsetof(struct trace_field, print.buf))
-#define TRACE_CONT_BUF_SIZE	sizeof(struct trace_field)
 
 /*
  * The CPU trace array - it consists of thousands of trace entries
Index: linux-tip.git/kernel/trace/trace_mmiotrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_mmiotrace.c	2008-09-29 22:27:59.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_mmiotrace.c	2008-09-29 22:32:54.000000000 -0400
@@ -178,14 +178,16 @@ print_out:
 static int mmio_print_rw(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_rw *rw	= &entry->field.mmiorw;
+	struct trace_mmiotrace_rw *field =
+		(struct trace_mmiotrace_rw *)entry;
+	struct mmiotrace_rw *rw	= &field->rw;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->field.mmiorw.opcode) {
+	switch (rw->opcode) {
 	case MMIO_READ:
 		ret = trace_seq_printf(s,
 			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
@@ -220,14 +222,14 @@ static int mmio_print_rw(struct trace_it
 static int mmio_print_map(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_map *m	= &entry->field.mmiomap;
+	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->field.mmiorw.opcode) {
+	switch (m->opcode) {
 	case MMIO_PROBE:
 		ret = trace_seq_printf(s,
 			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",
@@ -252,7 +254,8 @@ static int mmio_print_map(struct trace_i
 static int mmio_print_mark(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	const char *msg		= entry->field.print.buf;
+	struct print_entry *print = (struct print_entry *)entry;
+	const char *msg		= print->buf;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
@@ -264,7 +267,7 @@ static int mmio_print_mark(struct trace_
 	if (!ret)
 		return 0;
 
-	if (entry->field.flags & TRACE_FLAG_CONT)
+	if (entry->flags & TRACE_FLAG_CONT)
 		trace_seq_print_cont(s, iter);
 
 	return 1;
@@ -308,7 +311,7 @@ static void __trace_mmiotrace_rw(struct 
 				struct mmiotrace_rw *rw)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct trace_mmiotrace_rw *entry;
 	unsigned long irq_flags;
 
 	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
@@ -316,9 +319,9 @@ static void __trace_mmiotrace_rw(struct 
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, 0);
-	entry->type			= TRACE_MMIO_RW;
-	entry->field.mmiorw		= *rw;
+	tracing_generic_entry_update(&entry->ent, 0);
+	entry->ent.type			= TRACE_MMIO_RW;
+	entry->rw			= *rw;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
 	trace_wake_up();
@@ -336,7 +339,7 @@ static void __trace_mmiotrace_map(struct
 				struct mmiotrace_map *map)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct trace_mmiotrace_map *entry;
 	unsigned long irq_flags;
 
 	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
@@ -344,9 +347,9 @@ static void __trace_mmiotrace_map(struct
 	if (!event)
 		return;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, 0);
-	entry->type			= TRACE_MMIO_MAP;
-	entry->field.mmiomap		= *map;
+	tracing_generic_entry_update(&entry->ent, 0);
+	entry->ent.type			= TRACE_MMIO_MAP;
+	entry->map			= *map;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
 	trace_wake_up();
Index: linux-tip.git/kernel/trace/trace_boot.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_boot.c	2008-09-29 22:27:59.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_boot.c	2008-09-29 22:32:54.000000000 -0400
@@ -49,10 +49,11 @@ static int initcall_print_line(struct tr
 {
 	int ret = 0;
 	struct trace_entry *entry = iter->ent;
-	struct boot_trace *it = &entry->field.initcall;
+	struct trace_boot *field = (struct trace_boot *)entry;
+	struct boot_trace *it = &field->initcall;
 	struct trace_seq *s = &iter->seq;
 
-	if (iter->ent->type == TRACE_BOOT)
+	if (entry->type == TRACE_BOOT)
 		ret = trace_seq_printf(s, "%pF called from %i "
 				       "returned %d after %lld msecs\n",
 				       it->func, it->caller, it->result,
@@ -75,7 +76,7 @@ struct tracer boot_tracer __read_mostly 
 void trace_boot(struct boot_trace *it)
 {
 	struct ring_buffer_event *event;
-	struct trace_entry *entry;
+	struct trace_boot *entry;
 	struct trace_array_cpu *data;
 	unsigned long irq_flags;
 	struct trace_array *tr = boot_trace;
@@ -91,9 +92,9 @@ void trace_boot(struct boot_trace *it)
 	if (!event)
 		goto out;
 	entry	= ring_buffer_event_data(event);
-	tracing_generic_entry_update(entry, 0);
-	entry->type = TRACE_BOOT;
-	entry->field.initcall = *it;
+	tracing_generic_entry_update(&entry->ent, 0);
+	entry->ent.type = TRACE_BOOT;
+	entry->initcall = *it;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 
 	trace_wake_up();

-- 
