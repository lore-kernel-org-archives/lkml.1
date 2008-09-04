Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYIDI1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYIDI1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757816AbYIDIYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:24:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:58038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797AbYIDIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:24:16 -0400
Subject: [PATCH] ftrace: sched_switch: show the wakee's cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080903214249.661170580@goodmis.org>
References: <20080903214249.661170580@goodmis.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 10:24:16 +0200
Message-Id: <1220516656.8609.201.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ftrace: sched_switch: show the wakee's cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Sep 02 21:12:13 CEST 2008

While profiling the smp behaviour of the scheduler it was needed to know to
which cpu a task got woken.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/trace.c |   41 +++++++++++++++++++++++++++--------------
 kernel/trace/trace.h |    2 ++
 2 files changed, 29 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/trace/trace.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace.c
+++ linux-2.6/kernel/trace/trace.c
@@ -976,6 +977,7 @@ tracing_sched_switch_trace(struct trace_
 	entry->field.ctx.next_pid	= next->pid;
 	entry->field.ctx.next_prio	= next->prio;
 	entry->field.ctx.next_state	= next->state;
+	entry->field.ctx.next_cpu	= task_cpu(next);
 	__trace_stack(tr, data, flags, 5);
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -1002,6 +1004,7 @@ tracing_sched_wakeup_trace(struct trace_
 	entry->field.ctx.next_pid	= wakee->pid;
 	entry->field.ctx.next_prio	= wakee->prio;
 	entry->field.ctx.next_state	= wakee->state;
+	entry->field.ctx.next_cpu	= task_cpu(wakee);
 	__trace_stack(tr, data, flags, 6);
 	__raw_spin_unlock(&data->lock);
 	raw_local_irq_restore(irq_flags);
@@ -1630,10 +1638,11 @@ print_lat_fmt(struct trace_iterator *ite
 			__ffs(field->ctx.prev_state) + 1 : 0;
 		S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
 		comm = trace_find_cmdline(field->ctx.next_pid);
-		trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
+		trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
 				 field->ctx.prev_pid,
 				 field->ctx.prev_prio,
 				 S, entry->type == TRACE_CTX ? "==>" : "  +",
+				 field->ctx.next_cpu,
 				 field->ctx.next_pid,
 				 field->ctx.next_prio,
 				 T, comm);
@@ -1730,11 +1739,12 @@ static int print_trace_fmt(struct trace_
 			state_to_char[field->ctx.prev_state] : 'X';
 		T = field->ctx.next_state < sizeof(state_to_char) ?
 			state_to_char[field->ctx.next_state] : 'X';
-		ret = trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c\n",
+		ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
 				       field->ctx.prev_pid,
 				       field->ctx.prev_prio,
 				       S,
 				       entry->type == TRACE_CTX ? "==>" : "  +",
+				       field->ctx.next_cpu,
 				       field->ctx.next_pid,
 				       field->ctx.next_prio,
 				       T);
@@ -1811,10 +1821,11 @@ static int print_raw_fmt(struct trace_it
 			state_to_char[field->ctx.next_state] : 'X';
 		if (entry->type == TRACE_WAKE)
 			S = '+';
-		ret = trace_seq_printf(s, "%d %d %c %d %d %c\n",
+		ret = trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
 				       field->ctx.prev_pid,
 				       field->ctx.prev_prio,
 				       S,
+				       field->ctx.next_cpu,
 				       field->ctx.next_pid,
 				       field->ctx.next_prio,
 				       T);
@@ -1887,6 +1898,7 @@ static int print_hex_fmt(struct trace_it
 		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.prev_pid);
 		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.prev_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, S);
+		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_cpu);
 		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_pid);
 		SEQ_PUT_HEX_FIELD_RET(s, field->ctx.next_prio);
 		SEQ_PUT_HEX_FIELD_RET(s, T);
Index: linux-2.6/kernel/trace/trace.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace.h
+++ linux-2.6/kernel/trace/trace.h
@@ -41,6 +41,7 @@ struct ctx_switch_entry {
 	unsigned int		next_pid;
 	unsigned char		next_prio;
 	unsigned char		next_state;
+	unsigned int		next_cpu;
 };
 
 /*


