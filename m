Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYHAQiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYHAQiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYHAQhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:37:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYHAQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:37:39 -0400
Message-Id: <20080801163737.239389626@goodmis.org>
References: <20080801162639.175407419@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 01 Aug 2008 12:26:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 1/2] ftrace: new continue entry - separate out from trace_entry
Content-Disposition: inline; filename=ftrace-separate-out-entry-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some tracers will need to work with more than one entry. In order to do this
the trace_entry structure was split into two fields. One for the start of
all entries, and one to continue an existing entry.

The trace_entry structure now has a "field" entry that consists of the previous
content of the trace_entry, and a "cont" entry that is just a string buffer
the size of the "field" entry.

Thanks to Andrew Morton for suggesting this idea.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c           |  267 +++++++++++++++++++++--------------------
 kernel/trace/trace.h           |   17 ++
 kernel/trace/trace_mmiotrace.c |   12 -
 3 files changed, 160 insertions(+), 136 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-08-01 10:18:00.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-08-01 12:07:36.000000000 -0400
@@ -826,10 +826,11 @@ tracing_generic_entry_update(struct trac
 
 	pc = preempt_count();
 
-	entry->preempt_count	= pc & 0xff;
-	entry->pid		= (tsk) ? tsk->pid : 0;
-	entry->t		= ftrace_now(raw_smp_processor_id());
-	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
+	entry->field.preempt_count	= pc & 0xff;
+	entry->field.pid		= (tsk) ? tsk->pid : 0;
+	entry->field.t			= ftrace_now(raw_smp_processor_id());
+	entry->field.flags =
+		(irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
 		((pc & SOFTIRQ_MASK) ? TRACE_FLAG_SOFTIRQ : 0) |
 		(need_resched() ? TRACE_FLAG_NEED_RESCHED : 0);
@@ -844,11 +845,11 @@ trace_function(struct trace_array *tr, s
 
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry				= tracing_get_trace_entry(tr, data);
 	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_FN;
-	entry->fn.ip		= ip;
-	entry->fn.parent_ip	= parent_ip;
+	entry->type			= TRACE_FN;
+	entry->field.fn.ip		= ip;
+	entry->field.fn.parent_ip	= parent_ip;
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
 }
@@ -871,10 +872,10 @@ void __trace_mmiotrace_rw(struct trace_a
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&data->lock);
 
-	entry			= tracing_get_trace_entry(tr, data);
+	entry				= tracing_get_trace_entry(tr, data);
 	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_MMIO_RW;
-	entry->mmiorw		= *rw;
+	entry->type			= TRACE_MMIO_RW;
+	entry->field.mmiorw		= *rw;
 
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -891,10 +892,10 @@ void __trace_mmiotrace_map(struct trace_
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&data->lock);
 
-	entry			= tracing_get_trace_entry(tr, data);
+	entry				= tracing_get_trace_entry(tr, data);
 	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_MMIO_MAP;
-	entry->mmiomap		= *map;
+	entry->type			= TRACE_MMIO_MAP;
+	entry->field.mmiomap		= *map;
 
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -918,12 +919,12 @@ void __trace_stack(struct trace_array *t
 	tracing_generic_entry_update(entry, flags);
 	entry->type		= TRACE_STACK;
 
-	memset(&entry->stack, 0, sizeof(entry->stack));
+	memset(&entry->field.stack, 0, sizeof(entry->field.stack));
 
 	trace.nr_entries	= 0;
 	trace.max_entries	= FTRACE_STACK_ENTRIES;
 	trace.skip		= skip;
-	trace.entries		= entry->stack.caller;
+	trace.entries		= entry->field.stack.caller;
 
 	save_stack_trace(&trace);
 }
@@ -939,12 +940,12 @@ __trace_special(void *__tr, void *__data
 
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry				= tracing_get_trace_entry(tr, data);
 	tracing_generic_entry_update(entry, 0);
-	entry->type		= TRACE_SPECIAL;
-	entry->special.arg1	= arg1;
-	entry->special.arg2	= arg2;
-	entry->special.arg3	= arg3;
+	entry->type			= TRACE_SPECIAL;
+	entry->field.special.arg1	= arg1;
+	entry->field.special.arg2	= arg2;
+	entry->field.special.arg3	= arg3;
 	__trace_stack(tr, data, irq_flags, 4);
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -964,15 +965,15 @@ tracing_sched_switch_trace(struct trace_
 
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&data->lock);
-	entry			= tracing_get_trace_entry(tr, data);
+	entry				= tracing_get_trace_entry(tr, data);
 	tracing_generic_entry_update(entry, flags);
-	entry->type		= TRACE_CTX;
-	entry->ctx.prev_pid	= prev->pid;
-	entry->ctx.prev_prio	= prev->prio;
-	entry->ctx.prev_state	= prev->state;
-	entry->ctx.next_pid	= next->pid;
-	entry->ctx.next_prio	= next->prio;
-	entry->ctx.next_state	= next->state;
+	entry->type			= TRACE_CTX;
+	entry->field.ctx.prev_pid	= prev->pid;
+	entry->field.ctx.prev_prio	= prev->prio;
+	entry->field.ctx.prev_state	= prev->state;
+	entry->field.ctx.next_pid	= next->pid;
+	entry->field.ctx.next_prio	= next->prio;
+	entry->field.ctx.next_state	= next->state;
 	__trace_stack(tr, data, flags, 5);
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -993,12 +994,12 @@ tracing_sched_wakeup_trace(struct trace_
 	entry			= tracing_get_trace_entry(tr, data);
 	tracing_generic_entry_update(entry, flags);
 	entry->type		= TRACE_WAKE;
-	entry->ctx.prev_pid	= curr->pid;
-	entry->ctx.prev_prio	= curr->prio;
-	entry->ctx.prev_state	= curr->state;
-	entry->ctx.next_pid	= wakee->pid;
-	entry->ctx.next_prio	= wakee->prio;
-	entry->ctx.next_state	= wakee->state;
+	entry->field.ctx.prev_pid	= curr->pid;
+	entry->field.ctx.prev_prio	= curr->prio;
+	entry->field.ctx.prev_state	= curr->state;
+	entry->field.ctx.next_pid	= wakee->pid;
+	entry->field.ctx.next_prio	= wakee->prio;
+	entry->field.ctx.next_state	= wakee->state;
 	__trace_stack(tr, data, flags, 6);
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -1127,7 +1128,7 @@ find_next_entry(struct trace_iterator *i
 		/*
 		 * Pick the entry with the smallest timestamp:
 		 */
-		if (ent && (!next || ent->t < next->t)) {
+		if (ent && (!next || ent->field.t < next->field.t)) {
 			next = ent;
 			next_cpu = cpu;
 		}
@@ -1431,19 +1432,20 @@ print_trace_header(struct seq_file *m, s
 static void
 lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 {
+	struct trace_field *field = &entry->field;
 	int hardirq, softirq;
 	char *comm;
 
-	comm = trace_find_cmdline(entry->pid);
+	comm = trace_find_cmdline(field->pid);
 
-	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
+	trace_seq_printf(s, "%8.8s-%-5d ", comm, field->pid);
 	trace_seq_printf(s, "%d", cpu);
 	trace_seq_printf(s, "%c%c",
-			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
-			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
+			(field->flags & TRACE_FLAG_IRQS_OFF) ? 'd' : '.',
+			((field->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
 
-	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
-	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
+	hardirq = field->flags & TRACE_FLAG_HARDIRQ;
+	softirq = field->flags & TRACE_FLAG_SOFTIRQ;
 	if (hardirq && softirq) {
 		trace_seq_putc(s, 'H');
 	} else {
@@ -1457,8 +1459,8 @@ lat_print_generic(struct trace_seq *s, s
 		}
 	}
 
-	if (entry->preempt_count)
-		trace_seq_printf(s, "%x", entry->preempt_count);
+	if (field->preempt_count)
+		trace_seq_printf(s, "%x", field->preempt_count);
 	else
 		trace_seq_puts(s, ".");
 }
@@ -1488,6 +1490,7 @@ print_lat_fmt(struct trace_iterator *ite
 	struct trace_entry *next_entry = find_next_entry(iter, NULL);
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
+	struct trace_field *field = &entry->field;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
 	char *comm;
@@ -1497,17 +1500,17 @@ print_lat_fmt(struct trace_iterator *ite
 
 	if (!next_entry)
 		next_entry = entry;
-	rel_usecs = ns2usecs(next_entry->t - entry->t);
-	abs_usecs = ns2usecs(entry->t - iter->tr->time_start);
+	rel_usecs = ns2usecs(next_entry->field.t - entry->field.t);
+	abs_usecs = ns2usecs(entry->field.t - iter->tr->time_start);
 
 	if (verbose) {
-		comm = trace_find_cmdline(entry->pid);
+		comm = trace_find_cmdline(field->pid);
 		trace_seq_printf(s, "%16s %5d %d %d %08x %08x [%08lx]"
 				 " %ld.%03ldms (+%ld.%03ldms): ",
 				 comm,
-				 entry->pid, cpu, entry->flags,
-				 entry->preempt_count, trace_idx,
-				 ns2usecs(entry->t),
+				 field->pid, cpu, field->flags,
+				 field->preempt_count, trace_idx,
+				 ns2usecs(field->t),
 				 abs_usecs/1000,
 				 abs_usecs % 1000, rel_usecs/1000,
 				 rel_usecs % 1000);
@@ -1517,41 +1520,42 @@ print_lat_fmt(struct trace_iterator *ite
 	}
 	switch (entry->type) {
 	case TRACE_FN:
-		seq_print_ip_sym(s, entry->fn.ip, sym_flags);
+		seq_print_ip_sym(s, field->fn.ip, sym_flags);
 		trace_seq_puts(s, " (");
-		if (kretprobed(entry->fn.parent_ip))
+		if (kretprobed(field->fn.parent_ip))
 			trace_seq_puts(s, KRETPROBE_MSG);
 		else
-			seq_print_ip_sym(s, entry->fn.parent_ip, sym_flags);
+			seq_print_ip_sym(s, field->fn.parent_ip, sym_flags);
 		trace_seq_puts(s, ")\n");
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+		T = field->ctx.next_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.next_state] : 'X';
 
-		state = entry->ctx.prev_state ? __ffs(entry->ctx.prev_state) + 1 : 0;
+		state = field->ctx.prev_state ?
+			__ffs(field->ctx.prev_state) + 1 : 0;
 		S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
-		comm = trace_find_cmdline(entry->ctx.next_pid);
+		comm = trace_find_cmdline(field->ctx.next_pid);
 		trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
-				 entry->ctx.prev_pid,
-				 entry->ctx.prev_prio,
+				 field->ctx.prev_pid,
+				 field->ctx.prev_prio,
 				 S, entry->type == TRACE_CTX ? "==>" : "  +",
-				 entry->ctx.next_pid,
-				 entry->ctx.next_prio,
+				 field->ctx.next_pid,
+				 field->ctx.next_prio,
 				 T, comm);
 		break;
 	case TRACE_SPECIAL:
 		trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+				 field->special.arg1,
+				 field->special.arg2,
+				 field->special.arg3);
 		break;
 	case TRACE_STACK:
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i)
 				trace_seq_puts(s, " <= ");
-			seq_print_ip_sym(s, entry->stack.caller[i], sym_flags);
+			seq_print_ip_sym(s, field->stack.caller[i], sym_flags);
 		}
 		trace_seq_puts(s, "\n");
 		break;
@@ -1566,6 +1570,7 @@ static int print_trace_fmt(struct trace_
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
+	struct trace_field *field;
 	unsigned long usec_rem;
 	unsigned long long t;
 	unsigned long secs;
@@ -1575,14 +1580,15 @@ static int print_trace_fmt(struct trace_
 	int i;
 
 	entry = iter->ent;
+	field = &entry->field;
 
-	comm = trace_find_cmdline(iter->ent->pid);
+	comm = trace_find_cmdline(iter->ent->field.pid);
 
-	t = ns2usecs(entry->t);
+	t = ns2usecs(field->t);
 	usec_rem = do_div(t, 1000000ULL);
 	secs = (unsigned long)t;
 
-	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
+	ret = trace_seq_printf(s, "%16s-%-5d ", comm, field->pid);
 	if (!ret)
 		return 0;
 	ret = trace_seq_printf(s, "[%02d] ", iter->cpu);
@@ -1594,18 +1600,19 @@ static int print_trace_fmt(struct trace_
 
 	switch (entry->type) {
 	case TRACE_FN:
-		ret = seq_print_ip_sym(s, entry->fn.ip, sym_flags);
+		ret = seq_print_ip_sym(s, field->fn.ip, sym_flags);
 		if (!ret)
 			return 0;
 		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
-						entry->fn.parent_ip) {
+						field->fn.parent_ip) {
 			ret = trace_seq_printf(s, " <-");
 			if (!ret)
 				return 0;
-			if (kretprobed(entry->fn.parent_ip))
+			if (kretprobed(field->fn.parent_ip))
 				ret = trace_seq_puts(s, KRETPROBE_MSG);
 			else
-				ret = seq_print_ip_sym(s, entry->fn.parent_ip,
+				ret = seq_print_ip_sym(s,
+						       field->fn.parent_ip,
 						       sym_flags);
 			if (!ret)
 				return 0;
@@ -1616,26 +1623,26 @@ static int print_trace_fmt(struct trace_
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+		S = field->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.prev_state] : 'X';
+		T = field->ctx.next_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.next_state] : 'X';
 		ret = trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c\n",
-				       entry->ctx.prev_pid,
-				       entry->ctx.prev_prio,
+				       field->ctx.prev_pid,
+				       field->ctx.prev_prio,
 				       S,
 				       entry->type == TRACE_CTX ? "==>" : "  +",
-				       entry->ctx.next_pid,
-				       entry->ctx.next_prio,
+				       field->ctx.next_pid,
+				       field->ctx.next_prio,
 				       T);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_SPECIAL:
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+				 field->special.arg1,
+				 field->special.arg2,
+				 field->special.arg3);
 		if (!ret)
 			return 0;
 		break;
@@ -1646,7 +1653,7 @@ static int print_trace_fmt(struct trace_
 				if (!ret)
 					return 0;
 			}
-			ret = seq_print_ip_sym(s, entry->stack.caller[i],
+			ret = seq_print_ip_sym(s, field->stack.caller[i],
 					       sym_flags);
 			if (!ret)
 				return 0;
@@ -1663,37 +1670,40 @@ static int print_raw_fmt(struct trace_it
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	struct trace_field *field;
 	int ret;
 	int S, T;
 
 	entry = iter->ent;
+	field = &entry->field;
 
 	ret = trace_seq_printf(s, "%d %d %llu ",
-		entry->pid, iter->cpu, entry->t);
+		field->pid, iter->cpu, field->t);
 	if (!ret)
 		return 0;
 
 	switch (entry->type) {
 	case TRACE_FN:
 		ret = trace_seq_printf(s, "%x %x\n",
-					entry->fn.ip, entry->fn.parent_ip);
+					field->fn.ip,
+					field->fn.parent_ip);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+		S = field->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.prev_state] : 'X';
+		T = field->ctx.next_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
 		ret = trace_seq_printf(s, "%d %d %c %d %d %c\n",
-				       entry->ctx.prev_pid,
-				       entry->ctx.prev_prio,
+				       field->ctx.prev_pid,
+				       field->ctx.prev_prio,
 				       S,
-				       entry->ctx.next_pid,
-				       entry->ctx.next_prio,
+				       field->ctx.next_pid,
+				       field->ctx.next_prio,
 				       T);
 		if (!ret)
 			return 0;
@@ -1701,9 +1711,9 @@ static int print_raw_fmt(struct trace_it
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+				 field->special.arg1,
+				 field->special.arg2,
+				 field->special.arg3);
 		if (!ret)
 			return 0;
 		break;
@@ -1728,40 +1738,41 @@ static int print_hex_fmt(struct trace_it
 	struct trace_seq *s = &iter->seq;
 	unsigned char newline = '\n';
 	struct trace_entry *entry;
+	struct trace_field *field;
 	int S, T;
 
 	entry = iter->ent;
+	field = &entry->field;
 
-	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
+	SEQ_PUT_HEX_FIELD_RET(s, field->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, entry->t);
+	SEQ_PUT_HEX_FIELD_RET(s, field->t);
 
 	switch (entry->type) {
 	case TRACE_FN:
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.ip);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.parent_ip);
+		SEQ_PUT_HEX_FIELD_RET(s, field->fn.ip);
+		SEQ_PUT_HEX_FIELD_RET(s, field->fn.parent_ip);
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
+		S = field->ctx.prev_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.prev_state] : 'X';
+		T = field->ctx.next_state < sizeof(state_to_char) ?
+			state_to_char[field->ctx.next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.prev_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.prev_prio);
+		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.prev_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.prev_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, S);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.next_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.next_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.parent_ip);
+		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, T);
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg1);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg2);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg3);
+		SEQ_PUT_HEX_FIELD_RET(s, field->special.arg1);
+		SEQ_PUT_HEX_FIELD_RET(s, field->special.arg2);
+		SEQ_PUT_HEX_FIELD_RET(s, field->special.arg3);
 		break;
 	}
 	SEQ_PUT_FIELD_RET(s, newline);
@@ -1773,31 +1784,33 @@ static int print_bin_fmt(struct trace_it
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	struct trace_field *field;
 
 	entry = iter->ent;
+	field = &entry->field;
 
-	SEQ_PUT_FIELD_RET(s, entry->pid);
-	SEQ_PUT_FIELD_RET(s, entry->cpu);
-	SEQ_PUT_FIELD_RET(s, entry->t);
+	SEQ_PUT_FIELD_RET(s, field->pid);
+	SEQ_PUT_FIELD_RET(s, field->cpu);
+	SEQ_PUT_FIELD_RET(s, field->t);
 
 	switch (entry->type) {
 	case TRACE_FN:
-		SEQ_PUT_FIELD_RET(s, entry->fn.ip);
-		SEQ_PUT_FIELD_RET(s, entry->fn.parent_ip);
+		SEQ_PUT_FIELD_RET(s, field->fn.ip);
+		SEQ_PUT_FIELD_RET(s, field->fn.parent_ip);
 		break;
 	case TRACE_CTX:
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_pid);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_prio);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_state);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_pid);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_prio);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_state);
+		SEQ_PUT_FIELD_RET(s, field->ctx.prev_pid);
+		SEQ_PUT_FIELD_RET(s, field->ctx.prev_prio);
+		SEQ_PUT_FIELD_RET(s, field->ctx.prev_state);
+		SEQ_PUT_FIELD_RET(s, field->ctx.next_pid);
+		SEQ_PUT_FIELD_RET(s, field->ctx.next_prio);
+		SEQ_PUT_FIELD_RET(s, field->ctx.next_state);
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		SEQ_PUT_FIELD_RET(s, entry->special.arg1);
-		SEQ_PUT_FIELD_RET(s, entry->special.arg2);
-		SEQ_PUT_FIELD_RET(s, entry->special.arg3);
+		SEQ_PUT_FIELD_RET(s, field->special.arg1);
+		SEQ_PUT_FIELD_RET(s, field->special.arg2);
+		SEQ_PUT_FIELD_RET(s, field->special.arg3);
 		break;
 	}
 	return 1;
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-08-01 10:18:00.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-08-01 11:55:08.000000000 -0400
@@ -61,13 +61,12 @@ struct stack_entry {
 };
 
 /*
- * The trace entry - the most basic unit of tracing. This is what
+ * The trace field - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
  *
  *     bash-15816 [01]   235.197585: idle_cpu <- irq_enter
  */
-struct trace_entry {
-	char			type;
+struct trace_field {
 	char			cpu;
 	char			flags;
 	char			preempt_count;
@@ -83,6 +82,18 @@ struct trace_entry {
 	};
 };
 
+struct trace_field_cont {
+	char				buf[sizeof(struct trace_field)];
+};
+
+struct trace_entry {
+	char 				type;
+	union {
+		struct trace_field	field;
+		struct trace_field_cont	cont;
+	};
+};
+
 #define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
 
 /*
Index: linux-tip.git/kernel/trace/trace_mmiotrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_mmiotrace.c	2008-08-01 10:46:33.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_mmiotrace.c	2008-08-01 11:03:12.000000000 -0400
@@ -174,14 +174,14 @@ print_out:
 static int mmio_print_rw(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_rw *rw	= &entry->mmiorw;
+	struct mmiotrace_rw *rw	= &entry->field.mmiorw;
 	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long long t	= ns2usecs(entry->field.t);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->mmiorw.opcode) {
+	switch (entry->field.mmiorw.opcode) {
 	case MMIO_READ:
 		ret = trace_seq_printf(s,
 			"R %d %lu.%06lu %d 0x%llx 0x%lx 0x%lx %d\n",
@@ -216,14 +216,14 @@ static int mmio_print_rw(struct trace_it
 static int mmio_print_map(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_map *m	= &entry->mmiomap;
+	struct mmiotrace_map *m	= &entry->field.mmiomap;
 	struct trace_seq *s	= &iter->seq;
-	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long long t	= ns2usecs(entry->field.t);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
-	switch (entry->mmiorw.opcode) {
+	switch (entry->field.mmiorw.opcode) {
 	case MMIO_PROBE:
 		ret = trace_seq_printf(s,
 			"MAP %lu.%06lu %d 0x%llx 0x%lx 0x%lx 0x%lx %d\n",

-- 
