Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbZBBWal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbZBBWal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZBBWaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:30:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZBBWa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:30:28 -0500
Date: Mon, 2 Feb 2009 20:30:12 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 2/3] trace: Change struct trace_event callbacks
	parameter list
Message-ID: <20090202223012.GC12082@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: API change

The trace_seq and trace_entry are in trace_iterator, where there are
more fields that may be needed by tracers, so just pass the
tracer_iterator as is already the case for struct tracer->print_line.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 block/blktrace.c            |    8 +-
 kernel/trace/trace.c        |   10 ++--
 kernel/trace/trace_branch.c |    7 +-
 kernel/trace/trace_output.c |  139 +++++++++++++++++++------------------------
 kernel/trace/trace_output.h |    6 +-
 5 files changed, 76 insertions(+), 94 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 3f25425..570cd3c 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -1140,10 +1140,10 @@ static struct {
 	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
 };
 
-static int blk_trace_event_print(struct trace_seq *s, struct trace_entry *ent,
-				 int flags)
+static int blk_trace_event_print(struct trace_iterator *iter, int flags)
 {
-	const struct blk_io_trace *t = (struct blk_io_trace *)ent;
+	struct trace_seq *s = &iter->seq;
+	const struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
 	const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
 	int ret;
 
@@ -1153,7 +1153,7 @@ static int blk_trace_event_print(struct trace_seq *s, struct trace_entry *ent,
 		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
 		ret = blk_log_action_seq(s, t, what2act[what].act[long_act]);
 		if (ret)
-			ret = what2act[what].print(s, ent);
+			ret = what2act[what].print(s, iter->ent);
 	}
 
 	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5ec49c3..152d096 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1388,7 +1388,7 @@ static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
 	}
 
 	if (event && event->latency_trace) {
-		ret = event->latency_trace(s, entry, sym_flags);
+		ret = event->latency_trace(iter, sym_flags);
 		if (ret)
 			return ret;
 		return TRACE_TYPE_HANDLED;
@@ -1419,7 +1419,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	}
 
 	if (event && event->trace) {
-		ret = event->trace(s, entry, sym_flags);
+		ret = event->trace(iter, sym_flags);
 		if (ret)
 			return ret;
 		return TRACE_TYPE_HANDLED;
@@ -1449,7 +1449,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->raw) {
-		ret = event->raw(s, entry, 0);
+		ret = event->raw(iter, 0);
 		if (ret)
 			return ret;
 		return TRACE_TYPE_HANDLED;
@@ -1478,7 +1478,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->hex)
-		event->hex(s, entry, 0);
+		event->hex(iter, 0);
 
 	SEQ_PUT_FIELD_RET(s, newline);
 
@@ -1517,7 +1517,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->binary)
-		event->binary(s, entry, 0);
+		event->binary(iter, 0);
 
 	return TRACE_TYPE_HANDLED;
 }
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 1284145..ea62f10 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -160,14 +160,13 @@ trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int
-trace_branch_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_branch_print(struct trace_iterator *iter, int flags)
 {
 	struct trace_branch *field;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
-	if (trace_seq_printf(s, "[%s] %s:%s:%d\n",
+	if (trace_seq_printf(&iter->seq, "[%s] %s:%s:%d\n",
 			     field->correct ? "  ok  " : " MISS ",
 			     field->func,
 			     field->file,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index a5752d4..c24503b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -484,19 +484,18 @@ int unregister_ftrace_event(struct trace_event *event)
  * Standard events
  */
 
-int
-trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+int trace_nop_print(struct trace_iterator *iter, int flags)
 {
 	return 0;
 }
 
 /* TRACE_FN */
-static int
-trace_fn_latency(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_fn_latency(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!seq_print_ip_sym(s, field->ip, flags))
 		goto partial;
@@ -513,12 +512,12 @@ trace_fn_latency(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int
-trace_fn_trace(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_fn_trace(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!seq_print_ip_sym(s, field->ip, flags))
 		goto partial;
@@ -540,14 +539,13 @@ trace_fn_trace(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int
-trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_fn_raw(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, "%lx %lx\n",
+	if (!trace_seq_printf(&iter->seq, "%lx %lx\n",
 			      field->ip,
 			      field->parent_ip))
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -555,12 +553,12 @@ trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return 0;
 }
 
-static int
-trace_fn_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_fn_hex(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	SEQ_PUT_HEX_FIELD_RET(s, field->ip);
 	SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
@@ -568,12 +566,12 @@ trace_fn_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return 0;
 }
 
-static int
-trace_fn_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_fn_bin(struct trace_iterator *iter, int flags)
 {
 	struct ftrace_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	SEQ_PUT_FIELD_RET(s, field->ip);
 	SEQ_PUT_FIELD_RET(s, field->parent_ip);
@@ -591,20 +589,19 @@ static struct trace_event trace_fn_event = {
 };
 
 /* TRACE_CTX an TRACE_WAKE */
-static int
-trace_ctxwake_print(struct trace_seq *s, struct trace_entry *entry, int flags,
-		    char *delim)
+static int trace_ctxwake_print(struct trace_iterator *iter, char *delim)
 {
 	struct ctx_switch_entry *field;
 	char *comm;
 	int S, T;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	T = task_state_char(field->next_state);
 	S = task_state_char(field->prev_state);
 	comm = trace_find_cmdline(field->next_pid);
-	if (!trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+	if (!trace_seq_printf(&iter->seq,
+			      " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
 			      field->prev_pid,
 			      field->prev_prio,
 			      S, delim,
@@ -617,31 +614,27 @@ trace_ctxwake_print(struct trace_seq *s, struct trace_entry *entry, int flags,
 	return 0;
 }
 
-static int
-trace_ctx_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_ctx_print(struct trace_iterator *iter, int flags)
 {
-	return trace_ctxwake_print(s, entry, flags, "==>");
+	return trace_ctxwake_print(iter, "==>");
 }
 
-static int
-trace_wake_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_wake_print(struct trace_iterator *iter, int flags)
 {
-	return trace_ctxwake_print(s, entry, flags, "  +");
+	return trace_ctxwake_print(iter, "  +");
 }
 
-static int
-trace_ctxwake_raw(struct trace_seq *s, struct trace_entry *entry, int flags,
-		  char S)
+static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 {
 	struct ctx_switch_entry *field;
 	int T;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!S)
 		task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
-	if (!trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
+	if (!trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
 			      field->prev_pid,
 			      field->prev_prio,
 			      S,
@@ -654,27 +647,24 @@ trace_ctxwake_raw(struct trace_seq *s, struct trace_entry *entry, int flags,
 	return 0;
 }
 
-static int
-trace_ctx_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_ctx_raw(struct trace_iterator *iter, int flags)
 {
-	return trace_ctxwake_raw(s, entry, flags, 0);
+	return trace_ctxwake_raw(iter, 0);
 }
 
-static int
-trace_wake_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_wake_raw(struct trace_iterator *iter, int flags)
 {
-	return trace_ctxwake_raw(s, entry, flags, '+');
+	return trace_ctxwake_raw(iter, '+');
 }
 
 
-static int
-trace_ctxwake_hex(struct trace_seq *s, struct trace_entry *entry, int flags,
-		  char S)
+static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 {
 	struct ctx_switch_entry *field;
+	struct trace_seq *s = &iter->seq;
 	int T;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!S)
 		task_state_char(field->prev_state);
@@ -691,24 +681,22 @@ trace_ctxwake_hex(struct trace_seq *s, struct trace_entry *entry, int flags,
 	return 0;
 }
 
-static int
-trace_ctx_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_ctx_hex(struct trace_iterator *iter, int flags)
 {
-	return trace_ctxwake_hex(s, entry, flags, 0);
+	return trace_ctxwake_hex(iter, 0);
 }
 
-static int
-trace_wake_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_wake_hex(struct trace_iterator *iter, int flags)
 {
-	return trace_ctxwake_hex(s, entry, flags, '+');
+	return trace_ctxwake_hex(iter, '+');
 }
 
-static int
-trace_ctxwake_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_ctxwake_bin(struct trace_iterator *iter, int flags)
 {
 	struct ctx_switch_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	SEQ_PUT_FIELD_RET(s, field->prev_pid);
 	SEQ_PUT_FIELD_RET(s, field->prev_prio);
@@ -739,14 +727,13 @@ static struct trace_event trace_wake_event = {
 };
 
 /* TRACE_SPECIAL */
-static int
-trace_special_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_special_print(struct trace_iterator *iter, int flags)
 {
 	struct special_entry *field;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, "# %ld %ld %ld\n",
+	if (!trace_seq_printf(&iter->seq, "# %ld %ld %ld\n",
 			      field->arg1,
 			      field->arg2,
 			      field->arg3))
@@ -755,12 +742,12 @@ trace_special_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return 0;
 }
 
-static int
-trace_special_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_special_hex(struct trace_iterator *iter, int flags)
 {
 	struct special_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
 	SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
@@ -769,12 +756,12 @@ trace_special_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return 0;
 }
 
-static int
-trace_special_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_special_bin(struct trace_iterator *iter, int flags)
 {
 	struct special_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	SEQ_PUT_FIELD_RET(s, field->arg1);
 	SEQ_PUT_FIELD_RET(s, field->arg2);
@@ -794,13 +781,13 @@ static struct trace_event trace_special_event = {
 
 /* TRACE_STACK */
 
-static int
-trace_stack_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_stack_print(struct trace_iterator *iter, int flags)
 {
 	struct stack_entry *field;
+	struct trace_seq *s = &iter->seq;
 	int i;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 		if (i) {
@@ -830,13 +817,12 @@ static struct trace_event trace_stack_event = {
 };
 
 /* TRACE_USER_STACK */
-static int
-trace_user_stack_print(struct trace_seq *s, struct trace_entry *entry,
-		       int flags)
+static int trace_user_stack_print(struct trace_iterator *iter, int flags)
 {
 	struct userstack_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!seq_print_userip_objs(field, s, flags))
 		goto partial;
@@ -860,12 +846,12 @@ static struct trace_event trace_user_stack_event = {
 };
 
 /* TRACE_PRINT */
-static int
-trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_print_print(struct trace_iterator *iter, int flags)
 {
 	struct print_entry *field;
+	struct trace_seq *s = &iter->seq;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!seq_print_ip_sym(s, field->ip, flags))
 		goto partial;
@@ -879,14 +865,13 @@ trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static int
-trace_print_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+static int trace_print_raw(struct trace_iterator *iter, int flags)
 {
 	struct print_entry *field;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
-	if (!trace_seq_printf(s, "# %lx %s", field->ip, field->buf))
+	if (!trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf))
 		goto partial;
 
 	return 0;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index ec2ed90..3aeb31f 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -3,8 +3,7 @@
 
 #include "trace.h"
 
-typedef int (*trace_print_func)(struct trace_seq *s, struct trace_entry *entry,
-				int flags);
+typedef int (*trace_print_func)(struct trace_iterator *iter, int flags);
 
 struct trace_event {
 	struct hlist_node	node;
@@ -40,8 +39,7 @@ struct trace_event *ftrace_find_event(int type);
 int register_ftrace_event(struct trace_event *event);
 int unregister_ftrace_event(struct trace_event *event);
 
-int
-trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags);
+int trace_nop_print(struct trace_iterator *iter, int flags);
 
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-- 
1.6.0.6

