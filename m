Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbYLXEZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbYLXEZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 23:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYLXEZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 23:25:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYLXEZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 23:25:01 -0500
Message-Id: <20081224042459.654746922@goodmis.org>
References: <20081224042410.746044949@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 23:24:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/3] ftrace: remove obsolete print continue functionality
Content-Disposition: inline; filename=0001-ftrace-remove-obsolete-print-continue-functionality.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up

Now that the ring buffer used by ftrace allows for variable length
entries, we do not need the 'cont' feature of the buffer.  This code
makes other parts of ftrace more complex and by removing this it
simplifies the ftrace code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c                 |   61 ----------------------------------
 kernel/trace/trace.h                 |    7 ----
 kernel/trace/trace_functions_graph.c |    3 --
 kernel/trace/trace_mmiotrace.c       |    3 --
 4 files changed, 0 insertions(+), 74 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b07e34e..481d79b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1765,43 +1765,6 @@ static int task_state_char(unsigned long state)
 	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
 }
 
-/*
- * The message is supposed to contain an ending newline.
- * If the printing stops prematurely, try to add a newline of our own.
- */
-void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
-{
-	struct trace_entry *ent;
-	struct trace_field_cont *cont;
-	bool ok = true;
-
-	ent = peek_next_entry(iter, iter->cpu, NULL);
-	if (!ent || ent->type != TRACE_CONT) {
-		trace_seq_putc(s, '\n');
-		return;
-	}
-
-	do {
-		cont = (struct trace_field_cont *)ent;
-		if (ok)
-			ok = (trace_seq_printf(s, "%s", cont->buf) > 0);
-
-		ftrace_disable_cpu();
-
-		if (iter->buffer_iter[iter->cpu])
-			ring_buffer_read(iter->buffer_iter[iter->cpu], NULL);
-		else
-			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
-
-		ftrace_enable_cpu();
-
-		ent = peek_next_entry(iter, iter->cpu, NULL);
-	} while (ent && ent->type == TRACE_CONT);
-
-	if (!ok)
-		trace_seq_putc(s, '\n');
-}
-
 static void test_cpu_buff_start(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1834,9 +1797,6 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 	int S, T;
 	int i;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	test_cpu_buff_start(iter);
 
 	next_entry = find_next_entry(iter, NULL, &next_ts);
@@ -1922,8 +1882,6 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->buf);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
 		break;
 	}
 	case TRACE_BRANCH: {
@@ -1968,9 +1926,6 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	test_cpu_buff_start(iter);
 
 	comm = trace_find_cmdline(iter->ent->pid);
@@ -2076,8 +2031,6 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->buf);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
 		break;
 	}
 	case TRACE_GRAPH_RET: {
@@ -2124,9 +2077,6 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	ret = trace_seq_printf(s, "%d %d %llu ",
 		entry->pid, iter->cpu, iter->ts);
 	if (!ret)
@@ -2187,8 +2137,6 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
-		if (entry->flags & TRACE_FLAG_CONT)
-			trace_seq_print_cont(s, iter);
 		break;
 	}
 	}
@@ -2217,9 +2165,6 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
@@ -2283,9 +2228,6 @@ static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (entry->flags & TRACE_FLAG_CONT)
-		trace_seq_print_cont(s, iter);
-
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -2296,9 +2238,6 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	if (entry->type == TRACE_CONT)
-		return TRACE_TYPE_HANDLED;
-
 	SEQ_PUT_FIELD_RET(s, entry->pid);
 	SEQ_PUT_FIELD_RET(s, entry->cpu);
 	SEQ_PUT_FIELD_RET(s, iter->ts);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cc7a4f8..3a35738 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -16,7 +16,6 @@ enum trace_type {
 	TRACE_FN,
 	TRACE_CTX,
 	TRACE_WAKE,
-	TRACE_CONT,
 	TRACE_STACK,
 	TRACE_PRINT,
 	TRACE_SPECIAL,
@@ -178,7 +177,6 @@ struct trace_power {
  *  NEED_RESCED		- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
- *  CONT		- multiple entries hold the trace item
  */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
@@ -186,7 +184,6 @@ enum trace_flag_type {
 	TRACE_FLAG_NEED_RESCHED		= 0x04,
 	TRACE_FLAG_HARDIRQ		= 0x08,
 	TRACE_FLAG_SOFTIRQ		= 0x10,
-	TRACE_FLAG_CONT			= 0x20,
 };
 
 #define TRACE_BUF_SIZE		1024
@@ -262,7 +259,6 @@ extern void __ftrace_bad_type(void);
 	do {								\
 		IF_ASSIGN(var, ent, struct ftrace_entry, TRACE_FN);	\
 		IF_ASSIGN(var, ent, struct ctx_switch_entry, 0);	\
-		IF_ASSIGN(var, ent, struct trace_field_cont, TRACE_CONT); \
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
 		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
@@ -489,9 +485,6 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 
 extern void *head_page(struct trace_array_cpu *data);
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
-extern void trace_seq_print_cont(struct trace_seq *s,
-				 struct trace_iterator *iter);
-
 extern int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
 		unsigned long sym_flags);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4bf39fc..a02c997 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -589,9 +589,6 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (ent->flags & TRACE_FLAG_CONT)
-		trace_seq_print_cont(s, iter);
-
 	ret = trace_seq_printf(s, " */\n");
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fffcb06..83f20ae 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -262,9 +262,6 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	if (entry->flags & TRACE_FLAG_CONT)
-		trace_seq_print_cont(s, iter);
-
 	return TRACE_TYPE_HANDLED;
 }
 
-- 
1.5.6.5

-- 
