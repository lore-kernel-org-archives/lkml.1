Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYJAOxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYJAOxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYJAOwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:52:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbYJAOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:52:53 -0400
Date: Wed, 1 Oct 2008 10:52:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH] ftrace: type cast verifier
In-Reply-To: <20081001075419.GA24509@elte.hu>
Message-ID: <alpine.DEB.1.10.0810011052130.30777@gandalf.stny.rr.com>
References: <20080930030236.230994826@goodmis.org> <20080930030652.883661046@goodmis.org> <20080930203342.5b5ca814@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809301341300.6224@gandalf.stny.rr.com> <20081001075419.GA24509@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mmiotrace map had a bug that would typecast the entry from
the trace to the wrong type.

This patch adds a macro to assign all entries of ftrace using the type
of the variable and checking the entry id. The typecasts are now done
in the macro for only those types that it knows about, which should
be all the types that are allowed to be read from the tracer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c           |   85 ++++++++++++++++++++++++++++-------------
 kernel/trace/trace.h           |   42 ++++++++++++++++++++
 kernel/trace/trace_mmiotrace.c |   14 ++++--
 3 files changed, 112 insertions(+), 29 deletions(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-01 10:41:27.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-01 10:41:59.000000000 -0400
@@ -1350,7 +1350,9 @@ print_lat_fmt(struct trace_iterator *ite
 	}
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_puts(s, " (");
@@ -1363,8 +1365,9 @@ print_lat_fmt(struct trace_iterator *ite
 	}
 	case TRACE_CTX:
 	case TRACE_WAKE: {
-		struct ctx_switch_entry *field =
-			(struct ctx_switch_entry *)entry;
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
 
 		T = field->next_state < sizeof(state_to_char) ?
 			state_to_char[field->next_state] : 'X';
@@ -1384,7 +1387,9 @@ print_lat_fmt(struct trace_iterator *ite
 		break;
 	}
 	case TRACE_SPECIAL: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "# %ld %ld %ld\n",
 				 field->arg1,
@@ -1393,7 +1398,9 @@ print_lat_fmt(struct trace_iterator *ite
 		break;
 	}
 	case TRACE_STACK: {
-		struct stack_entry *field = (struct stack_entry *)entry;
+		struct stack_entry *field;
+
+		trace_assign_type(field, entry);
 
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i)
@@ -1404,7 +1411,9 @@ print_lat_fmt(struct trace_iterator *ite
 		break;
 	}
 	case TRACE_PRINT: {
-		struct print_entry *field = (struct print_entry *)entry;
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->buf);
@@ -1454,7 +1463,9 @@ static enum print_line_t print_trace_fmt
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = seq_print_ip_sym(s, field->ip, sym_flags);
 		if (!ret)
@@ -1480,8 +1491,9 @@ static enum print_line_t print_trace_fmt
 	}
 	case TRACE_CTX:
 	case TRACE_WAKE: {
-		struct ctx_switch_entry *field =
-			(struct ctx_switch_entry *)entry;
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
 
 		S = field->prev_state < sizeof(state_to_char) ?
 			state_to_char[field->prev_state] : 'X';
@@ -1501,7 +1513,9 @@ static enum print_line_t print_trace_fmt
 		break;
 	}
 	case TRACE_SPECIAL: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
 				 field->arg1,
@@ -1512,7 +1526,9 @@ static enum print_line_t print_trace_fmt
 		break;
 	}
 	case TRACE_STACK: {
-		struct stack_entry *field = (struct stack_entry *)entry;
+		struct stack_entry *field;
+
+		trace_assign_type(field, entry);
 
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i) {
@@ -1531,7 +1547,9 @@ static enum print_line_t print_trace_fmt
 		break;
 	}
 	case TRACE_PRINT: {
-		struct print_entry *field = (struct print_entry *)entry;
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->buf);
@@ -1562,7 +1580,9 @@ static enum print_line_t print_raw_fmt(s
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = trace_seq_printf(s, "%x %x\n",
 					field->ip,
@@ -1573,8 +1593,9 @@ static enum print_line_t print_raw_fmt(s
 	}
 	case TRACE_CTX:
 	case TRACE_WAKE: {
-		struct ctx_switch_entry *field =
-			(struct ctx_switch_entry *)entry;
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
 
 		S = field->prev_state < sizeof(state_to_char) ?
 			state_to_char[field->prev_state] : 'X';
@@ -1596,7 +1617,9 @@ static enum print_line_t print_raw_fmt(s
 	}
 	case TRACE_SPECIAL:
 	case TRACE_STACK: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
 				 field->arg1,
@@ -1607,7 +1630,9 @@ static enum print_line_t print_raw_fmt(s
 		break;
 	}
 	case TRACE_PRINT: {
-		struct print_entry *field = (struct print_entry *)entry;
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
 		if (entry->flags & TRACE_FLAG_CONT)
@@ -1648,7 +1673,9 @@ static enum print_line_t print_hex_fmt(s
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_HEX_FIELD_RET(s, field->ip);
 		SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
@@ -1656,8 +1683,9 @@ static enum print_line_t print_hex_fmt(s
 	}
 	case TRACE_CTX:
 	case TRACE_WAKE: {
-		struct ctx_switch_entry *field =
-			(struct ctx_switch_entry *)entry;
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
 
 		S = field->prev_state < sizeof(state_to_char) ?
 			state_to_char[field->prev_state] : 'X';
@@ -1676,7 +1704,9 @@ static enum print_line_t print_hex_fmt(s
 	}
 	case TRACE_SPECIAL:
 	case TRACE_STACK: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
 		SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
@@ -1705,15 +1735,18 @@ static enum print_line_t print_bin_fmt(s
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_FIELD_RET(s, field->ip);
 		SEQ_PUT_FIELD_RET(s, field->parent_ip);
 		break;
 	}
 	case TRACE_CTX: {
-		struct ctx_switch_entry *field =
-			(struct ctx_switch_entry *)entry;
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_FIELD_RET(s, field->prev_pid);
 		SEQ_PUT_FIELD_RET(s, field->prev_prio);
@@ -1725,7 +1758,9 @@ static enum print_line_t print_bin_fmt(s
 	}
 	case TRACE_SPECIAL:
 	case TRACE_STACK: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_FIELD_RET(s, field->arg1);
 		SEQ_PUT_FIELD_RET(s, field->arg2);
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-10-01 10:41:27.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-10-01 10:41:59.000000000 -0400
@@ -177,6 +177,48 @@ struct trace_array {
 	struct trace_array_cpu	*data[NR_CPUS];
 };
 
+#define FTRACE_CMP_TYPE(var, type) \
+	__builtin_types_compatible_p(typeof(var), type *)
+
+#undef IF_ASSIGN
+#define IF_ASSIGN(var, entry, etype, id)		\
+	if (FTRACE_CMP_TYPE(var, etype)) {		\
+		var = (typeof(var))(entry);		\
+		WARN_ON(id && (entry)->type != id);	\
+		break;					\
+	}
+
+/* Will cause compile errors if type is not found. */
+extern void __ftrace_bad_type(void);
+
+/*
+ * The trace_assign_type is a verifier that the entry type is
+ * the same as the type being assigned. To add new types simply
+ * add a line with the following format:
+ *
+ * IF_ASSIGN(var, ent, type, id);
+ *
+ *  Where "type" is the trace type that includes the trace_entry
+ *  as the "ent" item. And "id" is the trace identifier that is
+ *  used in the trace_type enum.
+ *
+ *  If the type can have more than one id, then use zero.
+ */
+#define trace_assign_type(var, ent)					\
+	do {								\
+		IF_ASSIGN(var, ent, struct ftrace_entry, TRACE_FN);	\
+		IF_ASSIGN(var, ent, struct ctx_switch_entry, 0);	\
+		IF_ASSIGN(var, ent, struct trace_field_cont, TRACE_CONT); \
+		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
+		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
+		IF_ASSIGN(var, ent, struct special_entry, 0);		\
+		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
+			  TRACE_MMIO_RW);				\
+		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
+			  TRACE_MMIO_MAP);				\
+		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		__ftrace_bad_type();					\
+	} while (0)
 
 /* Return values for print_line callback */
 enum print_line_t {
Index: linux-tip.git/kernel/trace/trace_mmiotrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_mmiotrace.c	2008-10-01 10:41:27.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_mmiotrace.c	2008-10-01 10:41:59.000000000 -0400
@@ -178,15 +178,17 @@ print_out:
 static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct trace_mmiotrace_rw *field =
-		(struct trace_mmiotrace_rw *)entry;
-	struct mmiotrace_rw *rw	= &field->rw;
+	struct trace_mmiotrace_rw *field;
+	struct mmiotrace_rw *rw;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret = 1;
 
+	trace_assign_type(field, entry);
+	rw = &field->rw;
+
 	switch (rw->opcode) {
 	case MMIO_READ:
 		ret = trace_seq_printf(s,
@@ -222,13 +224,17 @@ static enum print_line_t mmio_print_rw(s
 static enum print_line_t mmio_print_map(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
-	struct mmiotrace_map *m	= (struct mmiotrace_map *)entry;
+	struct trace_mmiotrace_map *field;
+	struct mmiotrace_map *m;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, 1000000ULL);
 	unsigned secs		= (unsigned long)t;
 	int ret;
 
+	trace_assign_type(field, entry);
+	m = &field->map;
+
 	switch (m->opcode) {
 	case MMIO_PROBE:
 		ret = trace_seq_printf(s,


