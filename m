Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYJBIyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYJBIyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYJBIyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:54:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076AbYJBIyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:54:24 -0400
Date: Thu, 2 Oct 2008 10:50:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: allocate buffer page pointer
Message-ID: <20081002085030.GF26084@elte.hu>
References: <20080930000307.GA2929@Krystal> <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com> <20080930034603.GA13801@Krystal> <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> The current method of overlaying the page frame as the buffer page pointer
> can be very dangerous and limits our ability to do other things with
> a page from the buffer, like send it off to disk.
> 
> This patch allocates the buffer_page instead of overlaying the page's
> page frame. The use of the buffer_page has hardly changed due to this.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |   54 ++++++++++++++++++++++++++-------------------
>  1 file changed, 32 insertions(+), 22 deletions(-)

applied to tip/tracing/ftrace, with the extended changlog below - i 
think this commit warrants that extra mention.

	Ingo

--------------->
>From da78331b4ced2763322d732ac5ba275965853bde Mon Sep 17 00:00:00 2001
From: Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 1 Oct 2008 10:52:51 -0400
Subject: [PATCH] ftrace: type cast filter+verifier

The mmiotrace map had a bug that would typecast the entry from
the trace to the wrong type. That is a known danger of C typecasts,
there's absolutely zero checking done on them.

Help that problem a bit by using a GCC extension to implement a
type filter that restricts the types that a trace record can be
cast into, and by adding a dynamic check (in debug mode) to verify
the type of the entry.

This patch adds a macro to assign all entries of ftrace using the type
of the variable and checking the entry id. The typecasts are now done
in the macro for only those types that it knows about, which should
be all the types that are allowed to be read from the tracer.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c           |   85 ++++++++++++++++++++++++++++------------
 kernel/trace/trace.h           |   42 ++++++++++++++++++++
 kernel/trace/trace_mmiotrace.c |   14 +++++--
 3 files changed, 112 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c163406..948f7d8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1350,7 +1350,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 	}
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_puts(s, " (");
@@ -1363,8 +1365,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
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
@@ -1384,7 +1387,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		break;
 	}
 	case TRACE_SPECIAL: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "# %ld %ld %ld\n",
 				 field->arg1,
@@ -1393,7 +1398,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		break;
 	}
 	case TRACE_STACK: {
-		struct stack_entry *field = (struct stack_entry *)entry;
+		struct stack_entry *field;
+
+		trace_assign_type(field, entry);
 
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i)
@@ -1404,7 +1411,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 		break;
 	}
 	case TRACE_PRINT: {
-		struct print_entry *field = (struct print_entry *)entry;
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->buf);
@@ -1454,7 +1463,9 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = seq_print_ip_sym(s, field->ip, sym_flags);
 		if (!ret)
@@ -1480,8 +1491,9 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
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
@@ -1501,7 +1513,9 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_SPECIAL: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
 				 field->arg1,
@@ -1512,7 +1526,9 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_STACK: {
-		struct stack_entry *field = (struct stack_entry *)entry;
+		struct stack_entry *field;
+
+		trace_assign_type(field, entry);
 
 		for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
 			if (i) {
@@ -1531,7 +1547,9 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_PRINT: {
-		struct print_entry *field = (struct print_entry *)entry;
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
 
 		seq_print_ip_sym(s, field->ip, sym_flags);
 		trace_seq_printf(s, ": %s", field->buf);
@@ -1562,7 +1580,9 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = trace_seq_printf(s, "%x %x\n",
 					field->ip,
@@ -1573,8 +1593,9 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
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
@@ -1596,7 +1617,9 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 	}
 	case TRACE_SPECIAL:
 	case TRACE_STACK: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		ret = trace_seq_printf(s, "# %ld %ld %ld\n",
 				 field->arg1,
@@ -1607,7 +1630,9 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_PRINT: {
-		struct print_entry *field = (struct print_entry *)entry;
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
 
 		trace_seq_printf(s, "# %lx %s", field->ip, field->buf);
 		if (entry->flags & TRACE_FLAG_CONT)
@@ -1648,7 +1673,9 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	switch (entry->type) {
 	case TRACE_FN: {
-		struct ftrace_entry *field = (struct ftrace_entry *)entry;
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_HEX_FIELD_RET(s, field->ip);
 		SEQ_PUT_HEX_FIELD_RET(s, field->parent_ip);
@@ -1656,8 +1683,9 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
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
@@ -1676,7 +1704,9 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	}
 	case TRACE_SPECIAL:
 	case TRACE_STACK: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_HEX_FIELD_RET(s, field->arg1);
 		SEQ_PUT_HEX_FIELD_RET(s, field->arg2);
@@ -1705,15 +1735,18 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
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
@@ -1725,7 +1758,9 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	}
 	case TRACE_SPECIAL:
 	case TRACE_STACK: {
-		struct special_entry *field = (struct special_entry *)entry;
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
 
 		SEQ_PUT_FIELD_RET(s, field->arg1);
 		SEQ_PUT_FIELD_RET(s, field->arg2);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a921ba5..f02042d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
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
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 1a266aa..0e819f4 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
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
@@ -222,13 +224,17 @@ static enum print_line_t mmio_print_rw(struct trace_iterator *iter)
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
