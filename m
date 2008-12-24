Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYLXE0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYLXE0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 23:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYLXEZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 23:25:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYLXEZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 23:25:03 -0500
Message-Id: <20081224042500.201498488@goodmis.org>
References: <20081224042410.746044949@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 23:24:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: change trace.c to use registered events
Content-Disposition: inline; filename=0003-ftrace-change-trace.c-to-use-registered-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: rework to use new event register API

Almost every ftrace event has to implement its output display in
trace.c through a different function. Some events did not handle
all the formats (trace, latency-trace, raw, hex, binary), and
this method does not scale well.

This patch converts the format functions to use the event API to
find the event and and print its format. Currently, we have
a print function for trace, latency_trace, raw, hex and binary.
A trace_nop_print is available if the event wants to avoid output
on a particular format.

Perhaps other tracers could use this in the future (like mmiotrace and
function_graph).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c        |  402 ++++---------------------------------
 kernel/trace/trace_branch.c |   53 +++++
 kernel/trace/trace_output.c |  467 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h |   16 ++
 4 files changed, 574 insertions(+), 364 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 707340f..a087add 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1483,15 +1483,6 @@ lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
 		trace_seq_puts(s, " : ");
 }
 
-static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
-
-static int task_state_char(unsigned long state)
-{
-	int bit = state ? __ffs(state) + 1 : 0;
-
-	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
-}
-
 static void test_cpu_buff_start(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1515,14 +1506,14 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *next_entry;
+	struct trace_event *event;
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
 	u64 next_ts;
 	char *comm;
-	int S, T;
-	int i;
+	int ret;
 
 	test_cpu_buff_start(iter);
 
@@ -1547,94 +1538,16 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		lat_print_generic(s, entry, cpu);
 		lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		seq_print_ip_sym(s, field->ip, sym_flags);
-		trace_seq_puts(s, " (");
-		seq_print_ip_sym(s, field->parent_ip, sym_flags);
-		trace_seq_puts(s, ")\n");
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = task_state_char(field->prev_state);
-		comm = trace_find_cmdline(field->next_pid);
-		trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
-				 field->prev_pid,
-				 field->prev_prio,
-				 S, entry->type == TRACE_CTX ? "==>" : "  +",
-				 field->next_cpu,
-				 field->next_pid,
-				 field->next_prio,
-				 T, comm);
-		break;
-	}
-	case TRACE_SPECIAL: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->arg1,
-				 field->arg2,
-				 field->arg3);
-		break;
-	}
-	case TRACE_STACK: {
-		struct stack_entry *field;
-
-		trace_assign_type(field, entry);
-
-		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-			if (i)
-				trace_seq_puts(s, " <= ");
-			seq_print_ip_sym(s, field->caller[i], sym_flags);
-		}
-		trace_seq_puts(s, "\n");
-		break;
-	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
-
-		trace_assign_type(field, entry);
 
-		seq_print_ip_sym(s, field->ip, sym_flags);
-		trace_seq_printf(s, ": %s", field->buf);
-		break;
-	}
-	case TRACE_BRANCH: {
-		struct trace_branch *field;
-
-		trace_assign_type(field, entry);
-
-		trace_seq_printf(s, "[%s] %s:%s:%d\n",
-				 field->correct ? "  ok  " : " MISS ",
-				 field->func,
-				 field->file,
-				 field->line);
-		break;
+	event = ftrace_find_event(entry->type);
+	if (event && event->latency_trace) {
+		ret = event->latency_trace(s, entry, sym_flags);
+		if (ret)
+			return ret;
+		return TRACE_TYPE_HANDLED;
 	}
-	case TRACE_USER_STACK: {
-		struct userstack_entry *field;
 
-		trace_assign_type(field, entry);
-
-		seq_print_userip_objs(field, s, sym_flags);
-		trace_seq_putc(s, '\n');
-		break;
-	}
-	default:
-		trace_seq_printf(s, "Unknown type %d\n", entry->type);
-	}
+	trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -1643,13 +1556,12 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
+	struct trace_event *event;
 	unsigned long usec_rem;
 	unsigned long long t;
 	unsigned long secs;
 	char *comm;
 	int ret;
-	int S, T;
-	int i;
 
 	entry = iter->ent;
 
@@ -1671,127 +1583,17 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = seq_print_ip_sym(s, field->ip, sym_flags);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
-						field->parent_ip) {
-			ret = trace_seq_printf(s, " <-");
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-			ret = seq_print_ip_sym(s,
-					       field->parent_ip,
-					       sym_flags);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-		ret = trace_seq_printf(s, "\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = task_state_char(field->prev_state);
-		ret = trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c\n",
-				       field->prev_pid,
-				       field->prev_prio,
-				       S,
-				       entry->type == TRACE_CTX ? "==>" : "  +",
-				       field->next_cpu,
-				       field->next_pid,
-				       field->next_prio,
-				       T);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_SPECIAL: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->arg1,
-				 field->arg2,
-				 field->arg3);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_STACK: {
-		struct stack_entry *field;
-
-		trace_assign_type(field, entry);
-
-		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-			if (i) {
-				ret = trace_seq_puts(s, " <= ");
-				if (!ret)
-					return TRACE_TYPE_PARTIAL_LINE;
-			}
-			ret = seq_print_ip_sym(s, field->caller[i],
-					       sym_flags);
-			if (!ret)
-				return TRACE_TYPE_PARTIAL_LINE;
-		}
-		ret = trace_seq_puts(s, "\n");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
-
-		trace_assign_type(field, entry);
-
-		seq_print_ip_sym(s, field->ip, sym_flags);
-		trace_seq_printf(s, ": %s", field->buf);
-		break;
-	}
-	case TRACE_GRAPH_RET: {
-		return print_graph_function(iter);
-	}
-	case TRACE_GRAPH_ENT: {
-		return print_graph_function(iter);
-	}
-	case TRACE_BRANCH: {
-		struct trace_branch *field;
-
-		trace_assign_type(field, entry);
-
-		trace_seq_printf(s, "[%s] %s:%s:%d\n",
-				 field->correct ? "  ok  " : " MISS ",
-				 field->func,
-				 field->file,
-				 field->line);
-		break;
+	event = ftrace_find_event(entry->type);
+	if (event && event->trace) {
+		ret = event->trace(s, entry, sym_flags);
+		if (ret)
+			return ret;
+		return TRACE_TYPE_HANDLED;
 	}
-	case TRACE_USER_STACK: {
-		struct userstack_entry *field;
-
-		trace_assign_type(field, entry);
+	ret = trace_seq_printf(s, "Unknown type %d\n", entry->type);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		ret = seq_print_userip_objs(field, s, sym_flags);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		ret = trace_seq_putc(s, '\n');
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	}
 	return TRACE_TYPE_HANDLED;
 }
 
@@ -1799,8 +1601,8 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	struct trace_event *event;
 	int ret;
-	int S, T;
 
 	entry = iter->ent;
 
@@ -1809,86 +1611,26 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = trace_seq_printf(s, "%x %x\n",
-					field->ip,
-					field->parent_ip);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = entry->type == TRACE_WAKE ? '+' :
-			task_state_char(field->prev_state);
-		ret = trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
-				       field->prev_pid,
-				       field->prev_prio,
-				       S,
-				       field->next_cpu,
-				       field->next_pid,
-				       field->next_prio,
-				       T);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
-	}
-	case TRACE_SPECIAL:
-	case TRACE_USER_STACK:
-	case TRACE_STACK: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 field->arg1,
-				 field->arg2,
-				 field->arg3);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		break;
+	event = ftrace_find_event(entry->type);
+	if (event && event->raw) {
+		ret = event->raw(s, entry, 0);
+		if (ret)
+			return ret;
+		return TRACE_TYPE_HANDLED;
 	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
-
-		trace_assign_type(field, entry);
+	ret = trace_seq_printf(s, "%d ?\n", entry->type);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
-		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
-		break;
-	}
-	}
 	return TRACE_TYPE_HANDLED;
 }
 
-#define SEQ_PUT_FIELD_RET(s, x)				\
-do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return 0;				\
-} while (0)
-
-#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
-do {							\
-	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return 0;				\
-} while (0)
-
 static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned char newline = '\n';
 	struct trace_entry *entry;
-	int S, T;
+	struct trace_event *event;
 
 	entry = iter->ent;
 
@@ -1896,47 +1638,10 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_HEX_FIELD_RET(s, field->ip);
-		SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
-		break;
-	}
-	case TRACE_CTX:
-	case TRACE_WAKE: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		T = task_state_char(field->next_state);
-		S = entry->type == TRACE_WAKE ? '+' :
-			task_state_char(field->prev_state);
-		SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, S);
-		SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
-		SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, T);
-		break;
-	}
-	case TRACE_SPECIAL:
-	case TRACE_USER_STACK:
-	case TRACE_STACK: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
+	event = ftrace_find_event(entry->type);
+	if (event && event->hex)
+		event->hex(s, entry, 0);
 
-		SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
-		SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
-		SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
-		break;
-	}
-	}
 	SEQ_PUT_FIELD_RET(s, newline);
 
 	return TRACE_TYPE_HANDLED;
@@ -1962,6 +1667,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	struct trace_event *event;
 
 	entry = iter->ent;
 
@@ -1969,43 +1675,11 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	SEQ_PUT_FIELD_RET(s, entry->cpu);
 	SEQ_PUT_FIELD_RET(s, iter->ts);
 
-	switch (entry->type) {
-	case TRACE_FN: {
-		struct ftrace_entry *field;
-
-		trace_assign_type(field, entry);
+	event = ftrace_find_event(entry->type);
+	if (event && event->binary)
+		event->binary(s, entry, 0);
 
-		SEQ_PUT_FIELD_RET(s, field->ip);
-		SEQ_PUT_FIELD_RET(s, field->parent_ip);
-		break;
-	}
-	case TRACE_CTX: {
-		struct ctx_switch_entry *field;
-
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_FIELD_RET(s, field->prev_pid);
-		SEQ_PUT_FIELD_RET(s, field->prev_prio);
-		SEQ_PUT_FIELD_RET(s, field->prev_state);
-		SEQ_PUT_FIELD_RET(s, field->next_pid);
-		SEQ_PUT_FIELD_RET(s, field->next_prio);
-		SEQ_PUT_FIELD_RET(s, field->next_state);
-		break;
-	}
-	case TRACE_SPECIAL:
-	case TRACE_USER_STACK:
-	case TRACE_STACK: {
-		struct special_entry *field;
-
-		trace_assign_type(field, entry);
-
-		SEQ_PUT_FIELD_RET(s, field->arg1);
-		SEQ_PUT_FIELD_RET(s, field->arg2);
-		SEQ_PUT_FIELD_RET(s, field->arg3);
-		break;
-	}
-	}
-	return 1;
+	return TRACE_TYPE_HANDLED;
 }
 
 static int trace_empty(struct trace_iterator *iter)
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 6c00feb..c15222a 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -14,7 +14,9 @@
 #include <linux/hash.h>
 #include <linux/fs.h>
 #include <asm/local.h>
+
 #include "trace.h"
+#include "trace_output.h"
 
 #ifdef CONFIG_BRANCH_TRACER
 
@@ -142,6 +144,49 @@ static void branch_trace_reset(struct trace_array *tr)
 	stop_branch_trace(tr);
 }
 
+static int
+trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct print_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (trace_seq_printf(s, ": %s", field->buf))
+		goto partial;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_branch_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct trace_branch *field;
+
+	trace_assign_type(field, entry);
+
+	if (trace_seq_printf(s, "[%s] %s:%s:%d\n",
+			     field->correct ? "  ok  " : " MISS ",
+			     field->func,
+			     field->file,
+			     field->line))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static struct trace_event trace_branch_event = {
+	.type	 	= TRACE_BRANCH,
+	.trace		= trace_branch_print,
+	.latency_trace	= trace_branch_print,
+	.raw		= trace_nop_print,
+	.hex		= trace_nop_print,
+	.binary		= trace_nop_print,
+};
+
 struct tracer branch_trace __read_mostly =
 {
 	.name		= "branch",
@@ -154,6 +199,14 @@ struct tracer branch_trace __read_mostly =
 
 __init static int init_branch_trace(void)
 {
+	int ret;
+
+	ret = register_ftrace_event(&trace_branch_event);
+	if (!ret) {
+		printk(KERN_WARNING "Warning: could not register branch events\n");
+		return 1;
+	}
+
 	return register_tracer(&branch_trace);
 }
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 1f3f800..df0c25c 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -286,6 +286,15 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
+static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
+
+static int task_state_char(unsigned long state)
+{
+	int bit = state ? __ffs(state) + 1 : 0;
+
+	return bit < sizeof(state_to_char) - 1 ? state_to_char[bit] : '?';
+}
+
 /**
  * ftrace_find_event - find a registered event
  * @type: the type of event to look for
@@ -363,3 +372,461 @@ int unregister_ftrace_event(struct trace_event *event)
 
 	return 0;
 }
+
+/*
+ * Standard events
+ */
+
+int
+trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return 0;
+}
+
+/* TRACE_FN */
+static int
+trace_fn_latency(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+	if (!trace_seq_puts(s, " ("))
+		goto partial;
+	if (!seq_print_ip_sym(s, field->parent_ip, flags))
+		goto partial;
+	if (!trace_seq_puts(s, ")\n"))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_fn_trace(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if ((flags & TRACE_ITER_PRINT_PARENT) && field->parent_ip) {
+		if (!trace_seq_printf(s, " <-"))
+			goto partial;
+		if (!seq_print_ip_sym(s,
+				      field->parent_ip,
+				      flags))
+			goto partial;
+	}
+	if (!trace_seq_printf(s, "\n"))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_fn_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (trace_seq_printf(s, "%x %x\n",
+			     field->ip,
+			     field->parent_ip))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_fn_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_HEX_FIELD_RET(s, field->ip);
+	SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
+
+	return 0;
+}
+
+static int
+trace_fn_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ftrace_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_FIELD_RET(s, field->ip);
+	SEQ_PUT_FIELD_RET(s, field->parent_ip);
+
+	return 0;
+}
+
+static struct trace_event trace_fn_event = {
+	.type	 	= TRACE_FN,
+	.trace		= trace_fn_trace,
+	.latency_trace	= trace_fn_latency,
+	.raw		= trace_fn_raw,
+	.hex		= trace_fn_hex,
+	.binary		= trace_fn_bin,
+};
+
+/* TRACE_CTX an TRACE_WAKE */
+static int
+trace_ctxwake_print(struct trace_seq *s, struct trace_entry *entry, int flags,
+		    char *delim)
+{
+	struct ctx_switch_entry *field;
+	char *comm;
+	int S, T;
+
+	trace_assign_type(field, entry);
+
+	T = task_state_char(field->next_state);
+	S = task_state_char(field->prev_state);
+	comm = trace_find_cmdline(field->next_pid);
+	if (trace_seq_printf(s, " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
+			     field->prev_pid,
+			     field->prev_prio,
+			     S, delim,
+			     field->next_cpu,
+			     field->next_pid,
+			     field->next_prio,
+			     T, comm))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_ctx_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_print(s, entry, flags, "==>");
+}
+
+static int
+trace_wake_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_print(s, entry, flags, "  +");
+}
+
+static int
+trace_ctxwake_raw(struct trace_seq *s, struct trace_entry *entry, int flags,
+		  char S)
+{
+	struct ctx_switch_entry *field;
+	int T;
+
+	trace_assign_type(field, entry);
+
+	if (!S)
+		task_state_char(field->prev_state);
+	T = task_state_char(field->next_state);
+	if (trace_seq_printf(s, "%d %d %c %d %d %d %c\n",
+			     field->prev_pid,
+			     field->prev_prio,
+			     S,
+			     field->next_cpu,
+			     field->next_pid,
+			     field->next_prio,
+			     T))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_ctx_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_raw(s, entry, flags, 0);
+}
+
+static int
+trace_wake_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_raw(s, entry, flags, '+');
+}
+
+
+static int
+trace_ctxwake_hex(struct trace_seq *s, struct trace_entry *entry, int flags,
+		  char S)
+{
+	struct ctx_switch_entry *field;
+	int T;
+
+	trace_assign_type(field, entry);
+
+	if (!S)
+		task_state_char(field->prev_state);
+	T = task_state_char(field->next_state);
+
+	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
+	SEQ_PUT_HEX_FIELD_RET(s, field->prev_prio);
+	SEQ_PUT_HEX_FIELD_RET(s, S);
+	SEQ_PUT_HEX_FIELD_RET(s, field->next_cpu);
+	SEQ_PUT_HEX_FIELD_RET(s, field->next_pid);
+	SEQ_PUT_HEX_FIELD_RET(s, field->next_prio);
+	SEQ_PUT_HEX_FIELD_RET(s, T);
+
+	return 0;
+}
+
+static int
+trace_ctx_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_hex(s, entry, flags, 0);
+}
+
+static int
+trace_wake_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	return trace_ctxwake_hex(s, entry, flags, '+');
+}
+
+static int
+trace_ctxwake_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct ctx_switch_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_FIELD_RET(s, field->prev_pid);
+	SEQ_PUT_FIELD_RET(s, field->prev_prio);
+	SEQ_PUT_FIELD_RET(s, field->prev_state);
+	SEQ_PUT_FIELD_RET(s, field->next_pid);
+	SEQ_PUT_FIELD_RET(s, field->next_prio);
+	SEQ_PUT_FIELD_RET(s, field->next_state);
+
+	return 0;
+}
+
+static struct trace_event trace_ctx_event = {
+	.type	 	= TRACE_CTX,
+	.trace		= trace_ctx_print,
+	.latency_trace	= trace_ctx_print,
+	.raw		= trace_ctx_raw,
+	.hex		= trace_ctx_hex,
+	.binary		= trace_ctxwake_bin,
+};
+
+static struct trace_event trace_wake_event = {
+	.type	 	= TRACE_WAKE,
+	.trace		= trace_wake_print,
+	.latency_trace	= trace_wake_print,
+	.raw		= trace_wake_raw,
+	.hex		= trace_wake_hex,
+	.binary		= trace_ctxwake_bin,
+};
+
+/* TRACE_SPECIAL */
+static int
+trace_special_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct special_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (trace_seq_printf(s, "# %ld %ld %ld\n",
+			     field->arg1,
+			     field->arg2,
+			     field->arg3))
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return 0;
+}
+
+static int
+trace_special_hex(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct special_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
+	SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
+	SEQ_PUT_HEX_FIELD_RET(s, field->arg3);
+
+	return 0;
+}
+
+static int
+trace_special_bin(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct special_entry *field;
+
+	trace_assign_type(field, entry);
+
+	SEQ_PUT_FIELD_RET(s, field->arg1);
+	SEQ_PUT_FIELD_RET(s, field->arg2);
+	SEQ_PUT_FIELD_RET(s, field->arg3);
+
+	return 0;
+}
+
+static struct trace_event trace_special_event = {
+	.type	 	= TRACE_SPECIAL,
+	.trace		= trace_special_print,
+	.latency_trace	= trace_special_print,
+	.raw		= trace_special_print,
+	.hex		= trace_special_hex,
+	.binary		= trace_special_bin,
+};
+
+/* TRACE_STACK */
+
+static int
+trace_stack_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct stack_entry *field;
+	int i;
+
+	trace_assign_type(field, entry);
+
+	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		if (i) {
+			if (trace_seq_puts(s, " <= "))
+				goto partial;
+
+			if (seq_print_ip_sym(s, field->caller[i], flags))
+				goto partial;
+		}
+		if (trace_seq_puts(s, "\n"))
+			goto partial;
+	}
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_stack_event = {
+	.type	 	= TRACE_STACK,
+	.trace		= trace_stack_print,
+	.latency_trace	= trace_stack_print,
+	.raw		= trace_special_print,
+	.hex		= trace_special_hex,
+	.binary		= trace_special_bin,
+};
+
+/* TRACE_USER_STACK */
+static int
+trace_user_stack_print(struct trace_seq *s, struct trace_entry *entry,
+		       int flags)
+{
+	struct userstack_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_userip_objs(field, s, flags))
+		goto partial;
+
+	if (trace_seq_putc(s, '\n'))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_user_stack_event = {
+	.type	 	= TRACE_USER_STACK,
+	.trace		= trace_user_stack_print,
+	.latency_trace	= trace_user_stack_print,
+	.raw		= trace_special_print,
+	.hex		= trace_special_hex,
+	.binary		= trace_special_bin,
+};
+
+/* TRACE_PRINT */
+static int
+trace_print_print(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct print_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (trace_seq_printf(s, ": %s", field->buf))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static int
+trace_print_raw(struct trace_seq *s, struct trace_entry *entry, int flags)
+{
+	struct print_entry *field;
+
+	trace_assign_type(field, entry);
+
+	if (seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (trace_seq_printf(s, "# %lx %s", field->ip, field->buf))
+		goto partial;
+
+	return 0;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct trace_event trace_print_event = {
+	.type	 	= TRACE_PRINT,
+	.trace		= trace_print_print,
+	.latency_trace	= trace_print_print,
+	.raw		= trace_print_raw,
+	.hex		= trace_nop_print,
+	.binary		= trace_nop_print,
+};
+
+static struct trace_event *events[] __initdata = {
+	&trace_fn_event,
+	&trace_ctx_event,
+	&trace_wake_event,
+	&trace_special_event,
+	&trace_stack_event,
+	&trace_user_stack_event,
+	&trace_print_event,
+	NULL
+};
+
+__init static int init_events(void)
+{
+	struct trace_event *event;
+	int i, ret;
+
+	for (i = 0; events[i]; i++) {
+		event = events[i];
+
+		ret = register_ftrace_event(event);
+		if (!ret) {
+			printk(KERN_WARNING "event %d failed to register\n",
+			       event->type);
+			WARN_ON_ONCE(1);
+		}
+	}
+
+	return 0;
+}
+device_initcall(init_events);
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 1fcc76e..ecab4ea 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -36,8 +36,24 @@ struct trace_event *ftrace_find_event(int type);
 int register_ftrace_event(struct trace_event *event);
 int unregister_ftrace_event(struct trace_event *event);
 
+int
+trace_nop_print(struct trace_seq *s, struct trace_entry *entry, int flags);
+
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
 
+#define SEQ_PUT_FIELD_RET(s, x)				\
+do {							\
+	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
+		return 0;				\
+} while (0)
+
+#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
+do {							\
+	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
+	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
+		return 0;				\
+} while (0)
+
 #endif
 
-- 
1.5.6.5

-- 
