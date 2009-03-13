Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZCMCmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZCMCmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZCMCig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbZCMCi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:29 -0400
Message-Id: <20090313023826.096779116@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/16] tracing/core: bring back raw trace_printk for dynamic formats strings
Content-Disposition: inline; filename=0006-tracing-core-bring-back-raw-trace_printk-for-dynami.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Impact: fix callsites with dynamic format strings

Since its new binary implementation, trace_printk() internally uses static
containers for the format strings on each callsites. But the value is
assigned once at build time, which means that it can't take dynamic
formats.

So this patch unearthes the raw trace_printk implementation for the callers
that will need trace_printk to be able to carry these dynamic format
strings. The trace_printk() macro will use the appropriate implementation
for each callsite. Most of the time however, the binary implementation will
still be used.

The other impact of this patch is that mmiotrace_printk() will use the old
implementation because it calls the low level trace_vprintk and we can't
guess here whether the format passed in it is dynamic or not.

Some parts of this patch have been written by Steven Rostedt (most notably
the part that chooses the appropriate implementation for each callsites).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/kernel.h               |   40 +++++++++++-----
 kernel/trace/trace.c                 |   85 ++++++++++++++++++++++++++++++++--
 kernel/trace/trace.h                 |   13 +++++-
 kernel/trace/trace_event_types.h     |   11 ++++-
 kernel/trace/trace_functions_graph.c |    6 +-
 kernel/trace/trace_mmiotrace.c       |    7 +--
 kernel/trace/trace_output.c          |   57 ++++++++++++++++++++--
 kernel/trace/trace_printk.c          |   33 +++++++++++--
 8 files changed, 213 insertions(+), 39 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7742798..1daca3b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -452,32 +452,46 @@ do {									\
 
 #define trace_printk(fmt, args...)					\
 do {									\
-	static const char *trace_printk_fmt				\
-	__attribute__((section("__trace_printk_fmt")));			\
-									\
-	if (!trace_printk_fmt)						\
-		trace_printk_fmt = fmt;					\
-									\
 	__trace_printk_check_format(fmt, ##args);			\
-	__trace_printk(_THIS_IP_, trace_printk_fmt, ##args);		\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
+									\
+		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
+	} else								\
+		__trace_printk(_THIS_IP_, fmt, ##args);		\
 } while (0)
 
 extern int
+__trace_bprintk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+
+extern int
 __trace_printk(unsigned long ip, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 
+/*
+ * The double __builtin_constant_p is because gcc will give us an error
+ * if we try to allocate the static variable to fmt if it is not a
+ * constant. Even with the outer if statement.
+ */
 #define ftrace_vprintk(fmt, vargs)					\
 do {									\
-	static const char *trace_printk_fmt				\
-	__attribute__((section("__trace_printk_fmt")));			\
-									\
-	if (!trace_printk_fmt)						\
-		trace_printk_fmt = fmt;					\
+	if (__builtin_constant_p(fmt)) {				\
+		static const char *trace_printk_fmt			\
+		  __attribute__((section("__trace_printk_fmt"))) =	\
+			__builtin_constant_p(fmt) ? fmt : NULL;		\
 									\
-	__ftrace_vprintk(_THIS_IP_, trace_printk_fmt, vargs);		\
+		__ftrace_vbprintk(_THIS_IP_, trace_printk_fmt, vargs);	\
+	} else								\
+		__ftrace_vprintk(_THIS_IP_, fmt, vargs);		\
 } while (0)
 
 extern int
+__ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap);
+
+extern int
 __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
 
 extern void ftrace_dump(void);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 62a63b2..dbb077d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1179,10 +1179,10 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 
 
 /**
- * trace_vprintk - write binary msg to tracing buffer
+ * trace_vbprintk - write binary msg to tracing buffer
  *
  */
-int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
+int trace_vbprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 {
 	static raw_spinlock_t trace_buf_lock =
 		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
@@ -1191,7 +1191,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 	struct ring_buffer_event *event;
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
-	struct print_entry *entry;
+	struct bprint_entry *entry;
 	unsigned long flags;
 	int resched;
 	int cpu, len = 0, size, pc;
@@ -1219,7 +1219,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
 		goto out_unlock;
 
 	size = sizeof(*entry) + sizeof(u32) * len;
-	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, flags, pc);
+	event = trace_buffer_lock_reserve(tr, TRACE_BPRINT, size, flags, pc);
 	if (!event)
 		goto out_unlock;
 	entry = ring_buffer_event_data(event);
@@ -1240,6 +1240,60 @@ out:
 
 	return len;
 }
+EXPORT_SYMBOL_GPL(trace_vbprintk);
+
+int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
+{
+	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
+	static char trace_buf[TRACE_BUF_SIZE];
+
+	struct ring_buffer_event *event;
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	int cpu, len = 0, size, pc;
+	struct print_entry *entry;
+	unsigned long irq_flags;
+
+	if (tracing_disabled || tracing_selftest_running)
+		return 0;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	if (unlikely(atomic_read(&data->disabled)))
+		goto out;
+
+	pause_graph_tracing();
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&trace_buf_lock);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+
+	len = min(len, TRACE_BUF_SIZE-1);
+	trace_buf[len] = 0;
+
+	size = sizeof(*entry) + len + 1;
+	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, irq_flags, pc);
+	if (!event)
+		goto out_unlock;
+	entry = ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->depth			= depth;
+
+	memcpy(&entry->buf, trace_buf, len);
+	entry->buf[len] = 0;
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+ out_unlock:
+	__raw_spin_unlock(&trace_buf_lock);
+	raw_local_irq_restore(irq_flags);
+	unpause_graph_tracing();
+ out:
+	preempt_enable_notrace();
+
+	return len;
+}
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
 enum trace_file_type {
@@ -1628,6 +1682,22 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
+static enum print_line_t print_bprintk_msg_only(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct bprint_entry *field;
+	int ret;
+
+	trace_assign_type(field, entry);
+
+	ret = trace_seq_bprintf(s, field->fmt, field->buf);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
 static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1637,7 +1707,7 @@ static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_bprintf(s, field->fmt, field->buf);
+	ret = trace_seq_printf(s, "%s", field->buf);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -1702,6 +1772,11 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 			return ret;
 	}
 
+	if (iter->ent->type == TRACE_BPRINT &&
+			trace_flags & TRACE_ITER_PRINTK &&
+			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
+		return print_bprintk_msg_only(iter);
+
 	if (iter->ent->type == TRACE_PRINT &&
 			trace_flags & TRACE_ITER_PRINTK &&
 			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 336324d..cede1ab 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -20,6 +20,7 @@ enum trace_type {
 	TRACE_WAKE,
 	TRACE_STACK,
 	TRACE_PRINT,
+	TRACE_BPRINT,
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
@@ -117,7 +118,7 @@ struct userstack_entry {
 /*
  * trace_printk entry:
  */
-struct print_entry {
+struct bprint_entry {
 	struct trace_entry	ent;
 	unsigned long		ip;
 	int			depth;
@@ -125,6 +126,13 @@ struct print_entry {
 	u32			buf[];
 };
 
+struct print_entry {
+	struct trace_entry	ent;
+	unsigned long		ip;
+	int			depth;
+	char			buf[];
+};
+
 #define TRACE_OLD_SIZE		88
 
 struct trace_field_cont {
@@ -286,6 +294,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
 		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
+		IF_ASSIGN(var, ent, struct bprint_entry, TRACE_BPRINT);	\
 		IF_ASSIGN(var, ent, struct special_entry, 0);		\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
 			  TRACE_MMIO_RW);				\
@@ -570,6 +579,8 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 extern void *head_page(struct trace_array_cpu *data);
 extern long ns2usecs(cycle_t nsec);
 extern int
+trace_vbprintk(unsigned long ip, int depth, const char *fmt, va_list args);
+extern int
 trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
 
 extern unsigned long trace_flags;
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 5cca4c9..d0907d7 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -102,7 +102,7 @@ TRACE_EVENT_FORMAT(user_stack, TRACE_USER_STACK, userstack_entry, ignore,
 		 "\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n\t=> (%08lx)\n")
 );
 
-TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
+TRACE_EVENT_FORMAT(bprint, TRACE_PRINT, bprint_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(unsigned int, depth, depth)
@@ -112,6 +112,15 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
 
+TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
+	TRACE_STRUCT(
+		TRACE_FIELD(unsigned long, ip, ip)
+		TRACE_FIELD(unsigned int, depth, depth)
+		TRACE_FIELD_ZERO_CHAR(buf)
+	),
+	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
+);
+
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned int, line, line)
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 8566c14..4c38860 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -684,7 +684,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 }
 
 static enum print_line_t
-print_graph_comment(struct print_entry *trace, struct trace_seq *s,
+print_graph_comment(struct bprint_entry *trace, struct trace_seq *s,
 		   struct trace_entry *ent, struct trace_iterator *iter)
 {
 	int i;
@@ -781,8 +781,8 @@ print_graph_function(struct trace_iterator *iter)
 		trace_assign_type(field, entry);
 		return print_graph_return(&field->ret, s, entry, iter);
 	}
-	case TRACE_PRINT: {
-		struct print_entry *field;
+	case TRACE_BPRINT: {
+		struct bprint_entry *field;
 		trace_assign_type(field, entry);
 		return print_graph_comment(field, s, entry, iter);
 	}
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 23e346a..f095916 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -254,6 +254,7 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	struct print_entry *print = (struct print_entry *)entry;
+	const char *msg		= print->buf;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
 	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
@@ -261,11 +262,7 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 	int ret;
 
 	/* The trailing newline must be in the message. */
-	ret = trace_seq_printf(s, "MARK %u.%06lu ", secs, usec_rem);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	ret = trace_seq_bprintf(s, print->fmt, print->buf);
+	ret = trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 491832a..ea9d3b4 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -832,13 +832,13 @@ static struct trace_event trace_user_stack_event = {
 	.binary		= trace_special_bin,
 };
 
-/* TRACE_PRINT */
+/* TRACE_BPRINT */
 static enum print_line_t
-trace_print_print(struct trace_iterator *iter, int flags)
+trace_bprint_print(struct trace_iterator *iter, int flags)
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
-	struct print_entry *field;
+	struct bprint_entry *field;
 
 	trace_assign_type(field, entry);
 
@@ -858,9 +858,10 @@ trace_print_print(struct trace_iterator *iter, int flags)
 }
 
 
-static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
+static enum print_line_t
+trace_bprint_raw(struct trace_iterator *iter, int flags)
 {
-	struct print_entry *field;
+	struct bprint_entry *field;
 	struct trace_seq *s = &iter->seq;
 
 	trace_assign_type(field, iter->ent);
@@ -878,12 +879,55 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 }
 
 
+static struct trace_event trace_bprint_event = {
+	.type		= TRACE_BPRINT,
+	.trace		= trace_bprint_print,
+	.raw		= trace_bprint_raw,
+};
+
+/* TRACE_PRINT */
+static enum print_line_t trace_print_print(struct trace_iterator *iter,
+					   int flags)
+{
+	struct print_entry *field;
+	struct trace_seq *s = &iter->seq;
+
+	trace_assign_type(field, iter->ent);
+
+	if (!seq_print_ip_sym(s, field->ip, flags))
+		goto partial;
+
+	if (!trace_seq_printf(s, ": %s", field->buf))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
+static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
+{
+	struct print_entry *field;
+
+	trace_assign_type(field, iter->ent);
+
+	if (!trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf))
+		goto partial;
+
+	return TRACE_TYPE_HANDLED;
+
+ partial:
+	return TRACE_TYPE_PARTIAL_LINE;
+}
+
 static struct trace_event trace_print_event = {
-	.type		= TRACE_PRINT,
+	.type	 	= TRACE_PRINT,
 	.trace		= trace_print_print,
 	.raw		= trace_print_raw,
 };
 
+
 static struct trace_event *events[] __initdata = {
 	&trace_fn_event,
 	&trace_ctx_event,
@@ -891,6 +935,7 @@ static struct trace_event *events[] __initdata = {
 	&trace_special_event,
 	&trace_stack_event,
 	&trace_user_stack_event,
+	&trace_bprint_event,
 	&trace_print_event,
 	NULL
 };
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index a50aea2..f307a11 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -99,7 +99,7 @@ struct notifier_block module_trace_bprintk_format_nb = {
 	.notifier_call = module_trace_bprintk_format_notify,
 };
 
-int __trace_printk(unsigned long ip, const char *fmt, ...)
+int __trace_bprintk(unsigned long ip, const char *fmt, ...)
  {
 	int ret;
 	va_list ap;
@@ -111,13 +111,13 @@ int __trace_printk(unsigned long ip, const char *fmt, ...)
 		return 0;
 
 	va_start(ap, fmt);
-	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	ret = trace_vbprintk(ip, task_curr_ret_stack(current), fmt, ap);
 	va_end(ap);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__trace_printk);
+EXPORT_SYMBOL_GPL(__trace_bprintk);
 
-int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
+int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
  {
 	if (unlikely(!fmt))
 		return 0;
@@ -125,11 +125,34 @@ int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 	if (!(trace_flags & TRACE_ITER_PRINTK))
 		return 0;
 
+	return trace_vbprintk(ip, task_curr_ret_stack(current), fmt, ap);
+}
+EXPORT_SYMBOL_GPL(__ftrace_vbprintk);
+
+int __trace_printk(unsigned long ip, const char *fmt, ...)
+{
+	int ret;
+	va_list ap;
+
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	va_end(ap);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__trace_printk);
+
+int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
+{
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	return trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
 }
 EXPORT_SYMBOL_GPL(__ftrace_vprintk);
 
-
 static __init int init_trace_printk(void)
 {
 	return register_module_notifier(&module_trace_bprintk_format_nb);
-- 
1.6.1.3

-- 
