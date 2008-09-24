Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYIXFP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYIXFP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYIXFOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:14:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbYIXFOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:14:32 -0400
Message-Id: <20080924051400.377065232@goodmis.org>
References: <20080924051056.650388887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 01:10:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Tom Zanussi <zanussi@comcast.net>, Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 2/3] ftrace: combine some print formating
Content-Disposition: inline; filename=ftrace-separate-out-prints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that the print formating was getting a bit out of hand,
so I tried to pull it mostly together.

This helps with hacking ftrace with my proposed ring buffer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  341 +++++++++++++++++++++++++++++----------------------
 1 file changed, 199 insertions(+), 142 deletions(-)

Index: linux-compile.git/kernel/trace/trace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace.c	2008-09-23 15:36:46.000000000 -0400
+++ linux-compile.git/kernel/trace/trace.c	2008-09-24 00:46:33.000000000 -0400
@@ -1471,6 +1471,184 @@ lat_print_timestamp(struct trace_seq *s,
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
+#define SEQ_PUT_FIELD_RET(s, x)				\
+do {							\
+	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
+		return 0;				\
+} while (0)
+
+#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
+do {							\
+	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
+		return 0;				\
+} while (0)
+
+static int
+trace_print_func(struct trace_seq *s, struct ftrace_entry *entry,
+		 int sym_flags, int print_type)
+{
+	int ret = 1;
+
+	switch (print_type) {
+	case TRACE_ITER_BIN:
+		SEQ_PUT_FIELD_RET(s, entry->ip);
+		SEQ_PUT_FIELD_RET(s, entry->parent_ip);
+		break;
+	case TRACE_ITER_HEX:
+		SEQ_PUT_HEX_FIELD_RET(s, entry->ip);
+		SEQ_PUT_HEX_FIELD_RET(s, entry->parent_ip);
+		break;
+	case TRACE_ITER_RAW:
+		ret = trace_seq_printf(s, "%x %x\n",
+					entry->ip, entry->parent_ip);
+		break;
+	case TRACE_FILE_LAT_FMT:
+		seq_print_ip_sym(s, entry->ip, sym_flags);
+		trace_seq_puts(s, " (");
+		if (kretprobed(entry->parent_ip))
+			trace_seq_puts(s, KRETPROBE_MSG);
+		else
+			seq_print_ip_sym(s, entry->parent_ip, sym_flags);
+		trace_seq_puts(s, ")\n");
+		break;
+	default:
+		ret = seq_print_ip_sym(s, entry->ip, sym_flags);
+		if (!ret)
+			return 0;
+		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
+					entry->parent_ip) {
+			ret = trace_seq_printf(s, " <-");
+			if (!ret)
+				return 0;
+			if (kretprobed(entry->parent_ip))
+				ret = trace_seq_puts(s, KRETPROBE_MSG);
+			else
+				ret = seq_print_ip_sym(s, entry->parent_ip,
+						       sym_flags);
+			if (!ret)
+				return 0;
+		}
+		ret = trace_seq_printf(s, "\n");
+	}
+
+	return ret;
+}
+
+static int
+trace_print_ctx(struct trace_seq *s, struct ctx_switch_entry *entry,
+		int type, int print_type)
+{
+	unsigned state;
+	char *comm;
+	int T, S;
+	int ret = 0;
+
+	T = entry->next_state < sizeof(state_to_char) ?
+		state_to_char[entry->next_state] : 'X';
+
+	state = entry->prev_state ? __ffs(entry->prev_state) + 1 : 0;
+	S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
+
+	switch (print_type) {
+	case TRACE_ITER_BIN:
+		SEQ_PUT_FIELD_RET(s, entry->prev_pid);
+		SEQ_PUT_FIELD_RET(s, entry->prev_prio);
+		SEQ_PUT_FIELD_RET(s, entry->prev_state);
+		SEQ_PUT_FIELD_RET(s, entry->next_pid);
+		SEQ_PUT_FIELD_RET(s, entry->next_prio);
+		SEQ_PUT_FIELD_RET(s, entry->next_state);
+		break;
+	case TRACE_ITER_HEX:
+		if (type == TRACE_WAKE)
+			S = '+';
+		SEQ_PUT_HEX_FIELD_RET(s, entry->prev_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, entry->prev_prio);
+		SEQ_PUT_HEX_FIELD_RET(s, S);
+		SEQ_PUT_HEX_FIELD_RET(s, entry->next_pid);
+		SEQ_PUT_HEX_FIELD_RET(s, entry->next_prio);
+		SEQ_PUT_HEX_FIELD_RET(s, T);
+		break;
+	case TRACE_ITER_RAW:
+		if (type == TRACE_WAKE)
+			S = '+';
+		ret = trace_seq_printf(s, "%d %d %c %d %d %c\n",
+				       entry->prev_pid,
+				       entry->prev_prio,
+				       S,
+				       entry->next_pid,
+				       entry->next_prio,
+				       T);
+		break;
+	default:
+		comm = trace_find_cmdline(entry->next_pid);
+		ret = trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
+				       entry->prev_pid,
+				       entry->prev_prio,
+				       S, type == TRACE_CTX ? "==>" : "  +",
+				       entry->next_pid,
+				       entry->next_prio,
+				       T, comm);
+	}
+
+	return ret;
+}
+
+static int
+trace_print_special(struct trace_seq *s, struct special_entry *entry,
+			    int print_type)
+{
+	int ret = 0;
+
+	switch (print_type) {
+	case TRACE_ITER_BIN:
+		SEQ_PUT_FIELD_RET(s, entry->arg1);
+		SEQ_PUT_FIELD_RET(s, entry->arg2);
+		SEQ_PUT_FIELD_RET(s, entry->arg3);
+		break;
+	case TRACE_ITER_HEX:
+		SEQ_PUT_HEX_FIELD_RET(s, entry->arg1);
+		SEQ_PUT_HEX_FIELD_RET(s, entry->arg2);
+		SEQ_PUT_HEX_FIELD_RET(s, entry->arg3);
+		break;
+	case TRACE_ITER_RAW:
+	default:
+		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
+				       entry->arg1,
+				       entry->arg2,
+				       entry->arg3);
+	}
+	return ret;
+}
+
+static int
+trace_print_stack(struct trace_seq *s, struct stack_entry *entry, int sym_flags,
+		  int print_type)
+{
+	int i;
+	int ret;
+
+	switch (print_type) {
+	case TRACE_ITER_BIN:
+	case TRACE_ITER_HEX:
+	case TRACE_ITER_RAW:
+	default:
+		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+			if (i) {
+				ret = trace_seq_puts(s, " <= ");
+				if (!ret)
+					return 0;
+			}
+			ret = seq_print_ip_sym(s, entry->caller[i],
+					       sym_flags);
+			if (!ret)
+				return 0;
+		}
+		ret = trace_seq_puts(s, "\n");
+	}
+
+	return ret;
+}
+
 static int
 print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 {
@@ -1482,9 +1660,7 @@ print_lat_fmt(struct trace_iterator *ite
 	unsigned long abs_usecs;
 	unsigned long rel_usecs;
 	char *comm;
-	int S, T;
-	int i;
-	unsigned state;
+	int print_type = TRACE_FILE_LAT_FMT;
 
 	if (!next_entry)
 		next_entry = entry;
@@ -1508,43 +1684,17 @@ print_lat_fmt(struct trace_iterator *ite
 	}
 	switch (entry->type) {
 	case TRACE_FN:
-		seq_print_ip_sym(s, entry->fn.ip, sym_flags);
-		trace_seq_puts(s, " (");
-		if (kretprobed(entry->fn.parent_ip))
-			trace_seq_puts(s, KRETPROBE_MSG);
-		else
-			seq_print_ip_sym(s, entry->fn.parent_ip, sym_flags);
-		trace_seq_puts(s, ")\n");
+		trace_print_func(s, &entry->fn, sym_flags, print_type);
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
-
-		state = entry->ctx.prev_state ? __ffs(entry->ctx.prev_state) + 1 : 0;
-		S = state < sizeof(state_to_char) - 1 ? state_to_char[state] : 'X';
-		comm = trace_find_cmdline(entry->ctx.next_pid);
-		trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c %s\n",
-				 entry->ctx.prev_pid,
-				 entry->ctx.prev_prio,
-				 S, entry->type == TRACE_CTX ? "==>" : "  +",
-				 entry->ctx.next_pid,
-				 entry->ctx.next_prio,
-				 T, comm);
+		trace_print_ctx(s, &entry->ctx, entry->type, print_type);
 		break;
 	case TRACE_SPECIAL:
-		trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+		trace_print_special(s, &entry->special, print_type);
 		break;
 	case TRACE_STACK:
-		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-			if (i)
-				trace_seq_puts(s, " <= ");
-			seq_print_ip_sym(s, entry->stack.caller[i], sym_flags);
-		}
-		trace_seq_puts(s, "\n");
+		trace_print_stack(s, &entry->stack, sym_flags, print_type);
 		break;
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
@@ -1562,8 +1712,6 @@ static int print_trace_fmt(struct trace_
 	unsigned long secs;
 	char *comm;
 	int ret;
-	int S, T;
-	int i;
 
 	entry = iter->ent;
 
@@ -1585,64 +1733,23 @@ static int print_trace_fmt(struct trace_
 
 	switch (entry->type) {
 	case TRACE_FN:
-		ret = seq_print_ip_sym(s, entry->fn.ip, sym_flags);
-		if (!ret)
-			return 0;
-		if ((sym_flags & TRACE_ITER_PRINT_PARENT) &&
-						entry->fn.parent_ip) {
-			ret = trace_seq_printf(s, " <-");
-			if (!ret)
-				return 0;
-			if (kretprobed(entry->fn.parent_ip))
-				ret = trace_seq_puts(s, KRETPROBE_MSG);
-			else
-				ret = seq_print_ip_sym(s, entry->fn.parent_ip,
-						       sym_flags);
-			if (!ret)
-				return 0;
-		}
-		ret = trace_seq_printf(s, "\n");
+		ret = trace_print_func(s, &entry->fn, sym_flags, 0);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
-		ret = trace_seq_printf(s, " %5d:%3d:%c %s %5d:%3d:%c\n",
-				       entry->ctx.prev_pid,
-				       entry->ctx.prev_prio,
-				       S,
-				       entry->type == TRACE_CTX ? "==>" : "  +",
-				       entry->ctx.next_pid,
-				       entry->ctx.next_prio,
-				       T);
+		ret = trace_print_ctx(s, &entry->ctx, entry->type, 0);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_SPECIAL:
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+		ret = trace_print_special(s, &entry->special, 0);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_STACK:
-		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-			if (i) {
-				ret = trace_seq_puts(s, " <= ");
-				if (!ret)
-					return 0;
-			}
-			ret = seq_print_ip_sym(s, entry->stack.caller[i],
-					       sym_flags);
-			if (!ret)
-				return 0;
-		}
-		ret = trace_seq_puts(s, "\n");
+		ret = trace_print_stack(s, &entry->stack, sym_flags, 0);
 		if (!ret)
 			return 0;
 		break;
@@ -1654,8 +1761,8 @@ static int print_raw_fmt(struct trace_it
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	int print_type = TRACE_ITER_RAW;
 	int ret;
-	int S, T;
 
 	entry = iter->ent;
 
@@ -1666,35 +1773,19 @@ static int print_raw_fmt(struct trace_it
 
 	switch (entry->type) {
 	case TRACE_FN:
-		ret = trace_seq_printf(s, "%x %x\n",
-					entry->fn.ip, entry->fn.parent_ip);
+		ret = trace_print_func(s, &entry->fn, 0, print_type);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
-		if (entry->type == TRACE_WAKE)
-			S = '+';
-		ret = trace_seq_printf(s, "%d %d %c %d %d %c\n",
-				       entry->ctx.prev_pid,
-				       entry->ctx.prev_prio,
-				       S,
-				       entry->ctx.next_pid,
-				       entry->ctx.next_prio,
-				       T);
+		ret = trace_print_ctx(s, &entry->ctx, entry->type, print_type);
 		if (!ret)
 			return 0;
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
-				 entry->special.arg1,
-				 entry->special.arg2,
-				 entry->special.arg3);
+		ret = trace_print_special(s, &entry->special, print_type);
 		if (!ret)
 			return 0;
 		break;
@@ -1702,24 +1793,12 @@ static int print_raw_fmt(struct trace_it
 	return 1;
 }
 
-#define SEQ_PUT_FIELD_RET(s, x)				\
-do {							\
-	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\
-		return 0;				\
-} while (0)
-
-#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
-do {							\
-	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
-		return 0;				\
-} while (0)
-
 static int print_hex_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned char newline = '\n';
 	struct trace_entry *entry;
-	int S, T;
+	int print_type = TRACE_ITER_HEX;
 
 	entry = iter->ent;
 
@@ -1729,30 +1808,15 @@ static int print_hex_fmt(struct trace_it
 
 	switch (entry->type) {
 	case TRACE_FN:
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.ip);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.parent_ip);
+		trace_print_func(s, &entry->fn, 0, print_type);
 		break;
 	case TRACE_CTX:
 	case TRACE_WAKE:
-		S = entry->ctx.prev_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.prev_state] : 'X';
-		T = entry->ctx.next_state < sizeof(state_to_char) ?
-			state_to_char[entry->ctx.next_state] : 'X';
-		if (entry->type == TRACE_WAKE)
-			S = '+';
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.prev_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.prev_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, S);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.next_pid);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->ctx.next_prio);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->fn.parent_ip);
-		SEQ_PUT_HEX_FIELD_RET(s, T);
+		trace_print_ctx(s, &entry->ctx, entry->type, print_type);
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg1);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg2);
-		SEQ_PUT_HEX_FIELD_RET(s, entry->special.arg3);
+		trace_print_special(s, &entry->special, print_type);
 		break;
 	}
 	SEQ_PUT_FIELD_RET(s, newline);
@@ -1764,6 +1828,7 @@ static int print_bin_fmt(struct trace_it
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry;
+	int print_type = TRACE_ITER_BIN;
 
 	entry = iter->ent;
 
@@ -1773,22 +1838,14 @@ static int print_bin_fmt(struct trace_it
 
 	switch (entry->type) {
 	case TRACE_FN:
-		SEQ_PUT_FIELD_RET(s, entry->fn.ip);
-		SEQ_PUT_FIELD_RET(s, entry->fn.parent_ip);
+		trace_print_func(s, &entry->fn, 0, print_type);
 		break;
 	case TRACE_CTX:
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_pid);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_prio);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.prev_state);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_pid);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_prio);
-		SEQ_PUT_FIELD_RET(s, entry->ctx.next_state);
+		trace_print_ctx(s, &entry->ctx, entry->type, print_type);
 		break;
 	case TRACE_SPECIAL:
 	case TRACE_STACK:
-		SEQ_PUT_FIELD_RET(s, entry->special.arg1);
-		SEQ_PUT_FIELD_RET(s, entry->special.arg2);
-		SEQ_PUT_FIELD_RET(s, entry->special.arg3);
+		trace_print_special(s, &entry->special, print_type);
 		break;
 	}
 	return 1;

-- 
