Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZBBW36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZBBW36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZBBW3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:29:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758363AbZBBW3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:29:41 -0500
Date: Mon, 2 Feb 2009 20:29:21 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/3] trace: better manage the context info for events
Message-ID: <20090202222921.GB12082@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Impact: make trace_event more convenient for tracers

All tracers (for the moment) that use the struct trace_event want to
have the context info printed before their own output: the pid/cmdline,
cpu, and timestamp.

But some other tracers that want to implement their trace_event
callbacks will not necessary need these information or they may want to
format them as they want.

This patch adds a new default-enabled trace option:
TRACE_ITER_CONTEXT_INFO When disabled through:

echo nocontext-info > /debugfs/tracing/trace_options

The pid, cpu and timestamps headers will not be printed.

IE with the sched_switch tracer with context-info (default):

     bash-2935 [001] 100.356561: 2935:120:S ==> [001]  0:140:R <idle>
   <idle>-0    [000] 100.412804:    0:140:R   + [000] 11:115:S events/0
   <idle>-0    [000] 100.412816:    0:140:R ==> [000] 11:115:R events/0
 events/0-11   [000] 100.412829:   11:115:S ==> [000]  0:140:R <idle>

Without context-info:

 2935:120:S ==> [001]  0:140:R <idle>
    0:140:R   + [000] 11:115:S events/0
    0:140:R ==> [000] 11:115:R events/0
   11:115:S ==> [000]  0:140:R <idle>

A tracer can disable it at runtime by clearing the bit
TRACE_ITER_CONTEXT_INFO in trace_flags.

The print routines were renamed to trace_print_context and
trace_print_lat_context, so that they can be used by tracers if they
want to use them for one of the trace_event callbacks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace.c        |  149 ++++++++++---------------------------------
 kernel/trace/trace.h        |    7 ++-
 kernel/trace/trace_output.c |  107 +++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h |    3 +
 4 files changed, 151 insertions(+), 115 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2f8ac1f..5ec49c3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -227,7 +227,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
-	TRACE_ITER_ANNOTATE;
+	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
 
 /**
  * trace_wake_up - wake up tasks waiting for trace input
@@ -285,6 +285,7 @@ static const char *trace_options[] = {
 	"userstacktrace",
 	"sym-userobj",
 	"printk-msg-only",
+	"context-info",
 	NULL
 };
 
@@ -1171,8 +1172,8 @@ __find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
 }
 
 /* Find the next real entry, without updating the iterator itself */
-static struct trace_entry *
-find_next_entry(struct trace_iterator *iter, int *ent_cpu, u64 *ent_ts)
+struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
+					  int *ent_cpu, u64 *ent_ts)
 {
 	return __find_next_entry(iter, ent_cpu, ent_ts);
 }
@@ -1351,57 +1352,6 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	seq_puts(m, "\n");
 }
 
-static void
-lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
-{
-	int hardirq, softirq;
-	char *comm;
-
-	comm = trace_find_cmdline(entry->pid);
-
-	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
-	trace_seq_printf(s, "%3d", cpu);
-	trace_seq_printf(s, "%c%c",
-			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
-			 (entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' : '.',
-			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
-
-	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
-	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
-	if (hardirq && softirq) {
-		trace_seq_putc(s, 'H');
-	} else {
-		if (hardirq) {
-			trace_seq_putc(s, 'h');
-		} else {
-			if (softirq)
-				trace_seq_putc(s, 's');
-			else
-				trace_seq_putc(s, '.');
-		}
-	}
-
-	if (entry->preempt_count)
-		trace_seq_printf(s, "%x", entry->preempt_count);
-	else
-		trace_seq_puts(s, ".");
-}
-
-unsigned long preempt_mark_thresh = 100;
-
-static void
-lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
-		    unsigned long rel_usecs)
-{
-	trace_seq_printf(s, " %4lldus", abs_usecs);
-	if (rel_usecs > preempt_mark_thresh)
-		trace_seq_puts(s, "!: ");
-	else if (rel_usecs > 1)
-		trace_seq_puts(s, "+: ");
-	else
-		trace_seq_puts(s, " : ");
-}
-
 static void test_cpu_buff_start(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1419,46 +1369,24 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	trace_seq_printf(s, "##### CPU %u buffer started ####\n", iter->cpu);
 }
 
-static enum print_line_t
-print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
+static enum print_line_t print_lat_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
-	struct trace_entry *next_entry;
 	struct trace_event *event;
-	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
 	struct trace_entry *entry = iter->ent;
-	unsigned long abs_usecs;
-	unsigned long rel_usecs;
-	u64 next_ts;
-	char *comm;
 	int ret;
 
 	test_cpu_buff_start(iter);
 
-	next_entry = find_next_entry(iter, NULL, &next_ts);
-	if (!next_entry)
-		next_ts = iter->ts;
-	rel_usecs = ns2usecs(next_ts - iter->ts);
-	abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
-
-	if (verbose) {
-		comm = trace_find_cmdline(entry->pid);
-		trace_seq_printf(s, "%16s %5d %3d %d %08x %08x [%08lx]"
-				 " %ld.%03ldms (+%ld.%03ldms): ",
-				 comm,
-				 entry->pid, cpu, entry->flags,
-				 entry->preempt_count, trace_idx,
-				 ns2usecs(iter->ts),
-				 abs_usecs/1000,
-				 abs_usecs % 1000, rel_usecs/1000,
-				 rel_usecs % 1000);
-	} else {
-		lat_print_generic(s, entry, cpu);
-		lat_print_timestamp(s, abs_usecs, rel_usecs);
+	event = ftrace_find_event(entry->type);
+
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		ret = trace_print_lat_context(iter);
+		if (ret)
+			return ret;
 	}
 
-	event = ftrace_find_event(entry->type);
 	if (event && event->latency_trace) {
 		ret = event->latency_trace(s, entry, sym_flags);
 		if (ret)
@@ -1476,33 +1404,20 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 	unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
 	struct trace_entry *entry;
 	struct trace_event *event;
-	unsigned long usec_rem;
-	unsigned long long t;
-	unsigned long secs;
-	char *comm;
 	int ret;
 
 	entry = iter->ent;
 
 	test_cpu_buff_start(iter);
 
-	comm = trace_find_cmdline(iter->ent->pid);
-
-	t = ns2usecs(iter->ts);
-	usec_rem = do_div(t, 1000000ULL);
-	secs = (unsigned long)t;
+	event = ftrace_find_event(entry->type);
 
-	ret = trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	ret = trace_seq_printf(s, "[%03d] ", iter->cpu);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-	ret = trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		ret = trace_print_context(iter);
+		if (ret)
+			return ret;
+	}
 
-	event = ftrace_find_event(entry->type);
 	if (event && event->trace) {
 		ret = event->trace(s, entry, sym_flags);
 		if (ret)
@@ -1525,10 +1440,12 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	ret = trace_seq_printf(s, "%d %d %llu ",
-		entry->pid, iter->cpu, iter->ts);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		ret = trace_seq_printf(s, "%d %d %llu ",
+			entry->pid, iter->cpu, iter->ts);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->raw) {
@@ -1553,9 +1470,11 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
-	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
-	SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
+		SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
+		SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->hex)
@@ -1575,7 +1494,7 @@ static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_printf(s, field->buf);
+	ret = trace_seq_printf(s, "%s", field->buf);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -1590,9 +1509,11 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 
 	entry = iter->ent;
 
-	SEQ_PUT_FIELD_RET(s, entry->pid);
-	SEQ_PUT_FIELD_RET(s, entry->cpu);
-	SEQ_PUT_FIELD_RET(s, iter->ts);
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		SEQ_PUT_FIELD_RET(s, entry->pid);
+		SEQ_PUT_FIELD_RET(s, entry->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->ts);
+	}
 
 	event = ftrace_find_event(entry->type);
 	if (event && event->binary)
@@ -1643,7 +1564,7 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 		return print_raw_fmt(iter);
 
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
-		return print_lat_fmt(iter, iter->idx, iter->cpu);
+		return print_lat_fmt(iter);
 
 	return print_trace_fmt(iter);
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e603a29..f0c7a0f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -405,6 +405,10 @@ void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
+
+struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
+					  int *ent_cpu, u64 *ent_ts);
+
 void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
@@ -591,7 +595,8 @@ enum trace_iterator_flags {
 	TRACE_ITER_ANNOTATE		= 0x2000,
 	TRACE_ITER_USERSTACKTRACE       = 0x4000,
 	TRACE_ITER_SYM_USEROBJ          = 0x8000,
-	TRACE_ITER_PRINTK_MSGONLY	= 0x10000
+	TRACE_ITER_PRINTK_MSGONLY	= 0x10000,
+	TRACE_ITER_CONTEXT_INFO		= 0x20000 /* Print pid/cpu/time */
 };
 
 /*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 1a4e144..a5752d4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -286,6 +286,113 @@ seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
 	return ret;
 }
 
+static void
+lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
+{
+	int hardirq, softirq;
+	char *comm;
+
+	comm = trace_find_cmdline(entry->pid);
+
+	trace_seq_printf(s, "%8.8s-%-5d ", comm, entry->pid);
+	trace_seq_printf(s, "%3d", cpu);
+	trace_seq_printf(s, "%c%c",
+			(entry->flags & TRACE_FLAG_IRQS_OFF) ? 'd' :
+			 (entry->flags & TRACE_FLAG_IRQS_NOSUPPORT) ? 'X' : '.',
+			((entry->flags & TRACE_FLAG_NEED_RESCHED) ? 'N' : '.'));
+
+	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
+	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
+	if (hardirq && softirq) {
+		trace_seq_putc(s, 'H');
+	} else {
+		if (hardirq) {
+			trace_seq_putc(s, 'h');
+		} else {
+			if (softirq)
+				trace_seq_putc(s, 's');
+			else
+				trace_seq_putc(s, '.');
+		}
+	}
+
+	if (entry->preempt_count)
+		trace_seq_printf(s, "%x", entry->preempt_count);
+	else
+		trace_seq_puts(s, ".");
+}
+
+static unsigned long preempt_mark_thresh = 100;
+
+static void
+lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
+		    unsigned long rel_usecs)
+{
+	trace_seq_printf(s, " %4lldus", abs_usecs);
+	if (rel_usecs > preempt_mark_thresh)
+		trace_seq_puts(s, "!: ");
+	else if (rel_usecs > 1)
+		trace_seq_puts(s, "+: ");
+	else
+		trace_seq_puts(s, " : ");
+}
+
+int trace_print_context(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	char *comm = trace_find_cmdline(entry->pid);
+	unsigned long long t = ns2usecs(iter->ts);
+	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
+	unsigned long secs = (unsigned long)t;
+
+	if (!trace_seq_printf(s, "%16s-%-5d ", comm, entry->pid))
+		goto partial;
+	if (!trace_seq_printf(s, "[%03d] ", entry->cpu))
+		goto partial;
+	if (!trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem))
+		goto partial;
+
+	return 0;
+
+partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+int trace_print_lat_context(struct trace_iterator *iter)
+{
+	u64 next_ts;
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent,
+			   *next_entry = trace_find_next_entry(iter, NULL,
+							       &next_ts);
+	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
+	unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
+	unsigned long rel_usecs;
+
+	if (!next_entry)
+		next_ts = iter->ts;
+	rel_usecs = ns2usecs(next_ts - iter->ts);
+
+	if (verbose) {
+		char *comm = trace_find_cmdline(entry->pid);
+		trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
+				 " %ld.%03ldms (+%ld.%03ldms): ",
+				 comm,
+				 entry->pid, entry->cpu, entry->flags,
+				 entry->preempt_count, iter->idx,
+				 ns2usecs(iter->ts),
+				 abs_usecs/1000,
+				 abs_usecs % 1000, rel_usecs/1000,
+				 rel_usecs % 1000);
+	} else {
+		lat_print_generic(s, entry, entry->cpu);
+		lat_print_timestamp(s, abs_usecs, rel_usecs);
+	}
+
+	return 0;
+}
+
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
 static int task_state_char(unsigned long state)
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 1cbab5e..ec2ed90 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -33,6 +33,9 @@ int seq_print_userip_objs(const struct userstack_entry *entry,
 int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 		      unsigned long ip, unsigned long sym_flags);
 
+int trace_print_context(struct trace_iterator *iter);
+int trace_print_lat_context(struct trace_iterator *iter);
+
 struct trace_event *ftrace_find_event(int type);
 int register_ftrace_event(struct trace_event *event);
 int unregister_ftrace_event(struct trace_event *event);
-- 
1.6.0.6

