Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZCAECR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZCAECR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 23:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZCAEBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 23:01:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:15315 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbZCAEB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 23:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:from:date:subject:to:cc;
        b=X0CjUnaKe5bFd1Kg29HZzfQPXTmi86c36lrkg+mGPY9s+b1d56yoB6KrX0YPssuBwG
         DA8lxvRDccmolEGK1odcG2zpfk3rCpmm9WKsi+GFQeGHNeVvYEjkbXwZBLdpsrCJYYp6
         w5szHRKrWx5ZJX3/GiP3olPigcQUUo7RSla3g=
Message-ID: <49aa0896.1c05d00a.5aa7.25b2@mx.google.com>
In-Reply-To: <20090228091305.GA20533@elte.hu>
References: <20090228091305.GA20533@elte.hu>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 28 Feb 2009 23:16:05 +0100
Subject: [PATCH 4/5] tracing/core: drop the old ftrace_printk implementation in favour of ftrace_bprintk
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: faster and lighter tracing

Now that we have ftrace_bprintk() which is faster and consume lesser
memory than ftrace_printk() and has the same purpose, we can now drop
the old implementation in favour of the binary one from ftrace_bprintk(),
which means we move all the implementation of ftrace_bprintk() to
ftrace_printk(), so the Api doesn't change except that we must now use
trace_seq_bprintk() to print the TRACE_PRINT entries.

Some changes result of this:

- Previously, ftrace_bprintk depended of a single tracer and couldn't
  work without. This tracer has been dropped and the whole implementation
  of ftrace_printk() (like the module formats management) is now integrated
  in the tracing core (comes with CONFIG_TRACING), though we keep the file
  trace_bprintk (previously trace_bprintk.c) where we can find the module
  management. Thus we don't overflow trace.c

- changes some parts to use trace_seq_bprintk() to print TRACE_PRINT entries.

- change a bit ftrace_printk/ftrace_vprintk macros to support non-builtin formats
  constants, and fix 'const' qualifiers warnings. But this is all transparent for
  developers.

- etc...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace.h                           |   68 ++++----
 include/linux/module.h                           |    2 +-
 kernel/trace/Kconfig                             |    7 +-
 kernel/trace/Makefile                            |    2 +-
 kernel/trace/trace.c                             |  209 +++++++---------------
 kernel/trace/trace.h                             |   14 +--
 kernel/trace/trace_functions_graph.c             |    6 +-
 kernel/trace/trace_mmiotrace.c                   |    9 +-
 kernel/trace/trace_output.c                      |   69 +------
 kernel/trace/trace_output.h                      |    2 +
 kernel/trace/{trace_bprintk.c => trace_printk.c} |  113 ++++--------
 11 files changed, 162 insertions(+), 339 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f82b986..696a09b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -222,31 +222,6 @@ extern int ftrace_make_nop(struct module *mod,
  */
 extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
 
-#ifdef CONFIG_TRACE_BPRINTK
-extern int trace_vbprintk(unsigned long ip, const char *fmt, va_list args);
-extern int __ftrace_bprintk(unsigned long ip, const char *fmt, ...)
-		__attribute__ ((format (printf, 2, 3)));
-
-static inline void  ____ftrace_bprintk_check_format(const char *fmt, ...)
-		__attribute__ ((format (printf, 1, 2)));
-static inline void ____ftrace_bprintk_check_format(const char *fmt, ...) {}
-#define __ftrace_bprintk_check_format(fmt, args...)			\
-do {									\
-	if (0)								\
-		____ftrace_bprintk_check_format(fmt, ##args);		\
-} while (0)
-
-#define ftrace_bprintk(fmt, args...)					\
-do {									\
-	static char *__attribute__((section("__trace_bprintk_fmt")))	\
-			ftrace_bprintk_fmt = fmt;			\
-	__ftrace_bprintk_check_format(fmt, ##args);			\
-	__ftrace_bprintk(_THIS_IP_, ftrace_bprintk_fmt, ##args);	\
-} while (0)
-#else
-#define ftrace_bprintk ftrace_printk
-#endif
-
 /* May be defined in arch */
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
@@ -367,15 +342,40 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
  * Please refrain from leaving ftrace_printks scattered around in
  * your code.
  */
-# define ftrace_printk(fmt...) __ftrace_printk(_THIS_IP_, fmt)
-extern int
-__ftrace_printk(unsigned long ip, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-# define ftrace_vprintk(fmt, ap) __ftrace_printk(_THIS_IP_, fmt, ap)
-extern int
-__ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap);
+extern int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list args);
+extern int __ftrace_printk(unsigned long ip, const char *fmt, ...)
+		__attribute__ ((format (printf, 2, 3)));
+
+static inline void  ____ftrace_printk_check_format(const char *fmt, ...)
+		__attribute__ ((format (printf, 1, 2)));
+static inline void ____ftrace_printk_check_format(const char *fmt, ...) {}
+#define __ftrace_printk_check_format(fmt, args...)			\
+do {									\
+	if (0)								\
+		____ftrace_printk_check_format(fmt, ##args);		\
+} while (0)
+
+#define ftrace_vprintk(fmt, vargs)					\
+do {									\
+	static const char *ftrace_printk_fmt				\
+	__attribute__((section("__trace_bprintk_fmt")));		\
+	ftrace_printk_fmt = fmt;					\
+	__ftrace_vprintk(_THIS_IP_, ftrace_printk_fmt, vargs);		\
+} while (0)
+
+#define ftrace_printk(fmt, args...)					\
+do {									\
+	static const char *ftrace_printk_fmt				\
+	__attribute__((section("__trace_bprintk_fmt")));		\
+	ftrace_printk_fmt = fmt;					\
+	__ftrace_printk_check_format(fmt, ##args);			\
+	__ftrace_printk(_THIS_IP_, ftrace_printk_fmt, ##args);		\
+} while (0)
+
 extern void ftrace_dump(void);
-#else
+
+#else /* !CONFIG_TRACING */
+
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 static inline int
@@ -395,7 +395,7 @@ ftrace_vprintk(const char *fmt, va_list ap)
 	return 0;
 }
 static inline void ftrace_dump(void) { }
-#endif
+#endif /* CONFIG_TRACING */
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
diff --git a/include/linux/module.h b/include/linux/module.h
index c4f2845..e418da1 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -347,7 +347,7 @@ struct module
 	unsigned int num_tracepoints;
 #endif
 
-#ifdef CONFIG_TRACE_BPRINTK
+#ifdef CONFIG_TRACING
 	const char **trace_bprintk_fmt_start;
 	unsigned int num_trace_bprintk_fmt;
 #endif
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 2e84fc7..52439c8 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -52,6 +52,7 @@ config TRACING
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select TRACEPOINTS
 	select NOP_TRACER
+	select BINARY_PRINTF
 
 menu "Tracers"
 
@@ -86,12 +87,6 @@ config FUNCTION_GRAPH_TRACER
 	  This is done by setting the current return address on the current
 	  task structure into a stack of calls.
 
-config TRACE_BPRINTK
-	bool "Binary printk for tracing"
-	default y
-	depends on TRACING
-	select BINARY_PRINTF
-
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index dba6157..25e243f 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_clock.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
-obj-$(CONFIG_TRACE_BPRINTK) += trace_bprintk.o
+obj-$(CONFIG_TRACING) += trace_printk.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0e30dce..2ad285b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1171,6 +1171,67 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
+
+/**
+ * trace_vprintk - write binary msg to tracing buffer
+ *
+ * Caller must insure @fmt are valid when msg is in tracing buffer.
+ */
+int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
+{
+	static DEFINE_SPINLOCK(trace_buf_lock);
+	static u32 trace_buf[TRACE_BUF_SIZE];
+
+	struct ring_buffer_event *event;
+	struct trace_array *tr = &global_trace;
+	struct trace_array_cpu *data;
+	struct print_entry *entry;
+	unsigned long flags;
+	int cpu, len = 0, size, pc;
+
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
+	/* Don't pollute graph traces with trace_vprintk internals */
+	pause_graph_tracing();
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+
+	if (unlikely(atomic_read(&data->disabled)))
+		goto out;
+
+	spin_lock_irqsave(&trace_buf_lock, flags);
+	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+
+	if (len > TRACE_BUF_SIZE || len < 0)
+		goto out_unlock;
+
+	size = sizeof(*entry) + sizeof(u32) * len;
+	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, flags, pc);
+	if (!event)
+		goto out_unlock;
+	entry = ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->depth			= depth;
+	entry->fmt			= fmt;
+
+	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	ring_buffer_unlock_commit(tr->buffer, event);
+
+out_unlock:
+	spin_unlock_irqrestore(&trace_buf_lock, flags);
+
+out:
+	preempt_enable_notrace();
+	unpause_graph_tracing();
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(trace_vprintk);
+
 enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 	TRACE_FILE_ANNOTATE	= 2,
@@ -1588,7 +1649,7 @@ static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_printf(s, "%s", field->buf);
+	ret = trace_seq_bprintf(s, field->fmt, field->buf);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
@@ -3496,152 +3557,6 @@ static __init int tracer_init_debugfs(void)
 	return 0;
 }
 
-int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
-{
-	static DEFINE_SPINLOCK(trace_buf_lock);
-	static char trace_buf[TRACE_BUF_SIZE];
-
-	struct ring_buffer_event *event;
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	int cpu, len = 0, size, pc;
-	struct print_entry *entry;
-	unsigned long irq_flags;
-
-	if (tracing_disabled || tracing_selftest_running)
-		return 0;
-
-	pc = preempt_count();
-	preempt_disable_notrace();
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-
-	if (unlikely(atomic_read(&data->disabled)))
-		goto out;
-
-	pause_graph_tracing();
-	spin_lock_irqsave(&trace_buf_lock, irq_flags);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
-
-	len = min(len, TRACE_BUF_SIZE-1);
-	trace_buf[len] = 0;
-
-	size = sizeof(*entry) + len + 1;
-	event = trace_buffer_lock_reserve(tr, TRACE_PRINT, size, irq_flags, pc);
-	if (!event)
-		goto out_unlock;
-	entry = ring_buffer_event_data(event);
-	entry->ip			= ip;
-	entry->depth			= depth;
-
-	memcpy(&entry->buf, trace_buf, len);
-	entry->buf[len] = 0;
-	ring_buffer_unlock_commit(tr->buffer, event);
-
- out_unlock:
-	spin_unlock_irqrestore(&trace_buf_lock, irq_flags);
-	unpause_graph_tracing();
- out:
-	preempt_enable_notrace();
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(trace_vprintk);
-
-int __ftrace_printk(unsigned long ip, const char *fmt, ...)
-{
-	int ret;
-	va_list ap;
-
-	if (!(trace_flags & TRACE_ITER_PRINTK))
-		return 0;
-
-	va_start(ap, fmt);
-	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
-	va_end(ap);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(__ftrace_printk);
-
-int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
-{
-	if (!(trace_flags & TRACE_ITER_PRINTK))
-		return 0;
-
-	return trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
-}
-EXPORT_SYMBOL_GPL(__ftrace_vprintk);
-
-/**
- * trace_vbprintk - write binary msg to tracing buffer
- *
- * Caller must insure @fmt are valid when msg is in tracing buffer.
- */
-int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
-{
-	static DEFINE_SPINLOCK(trace_buf_lock);
-	static u32 trace_buf[TRACE_BUF_SIZE];
-
-	struct ring_buffer_event *event;
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	struct bprintk_entry *entry;
-	unsigned long flags;
-	int cpu, len = 0, size, pc;
-
-	if (tracing_disabled || !trace_bprintk_enable)
-		return 0;
-
-	pc = preempt_count();
-	preempt_disable_notrace();
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-
-	if (unlikely(atomic_read(&data->disabled)))
-		goto out;
-
-	spin_lock_irqsave(&trace_buf_lock, flags);
-	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
-
-	if (len > TRACE_BUF_SIZE || len < 0)
-		goto out_unlock;
-
-	size = sizeof(*entry) + sizeof(u32) * len;
-	event = trace_buffer_lock_reserve(tr, TRACE_BPRINTK, size, flags, pc);
-	if (!event)
-		goto out_unlock;
-	entry = ring_buffer_event_data(event);
-	entry->ip			= ip;
-	entry->fmt			= fmt;
-
-	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	ring_buffer_unlock_commit(tr->buffer, event);
-
-out_unlock:
-	spin_unlock_irqrestore(&trace_buf_lock, flags);
-
-out:
-	preempt_enable_notrace();
-
-	return len;
-}
-EXPORT_SYMBOL_GPL(trace_vbprintk);
-
-int __ftrace_bprintk(unsigned long ip, const char *fmt, ...)
-{
-	int ret;
-	va_list ap;
-
-	if (!fmt)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = trace_vbprintk(ip, fmt, ap);
-	va_end(ap);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(__ftrace_bprintk);
-
 static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 92703b1..0ccc678 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -20,7 +20,6 @@ enum trace_type {
 	TRACE_WAKE,
 	TRACE_STACK,
 	TRACE_PRINT,
-	TRACE_BPRINTK,
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
@@ -120,16 +119,10 @@ struct userstack_entry {
  */
 struct print_entry {
 	struct trace_entry	ent;
-	unsigned long		ip;
+	unsigned long 		ip;
 	int			depth;
-	char			buf[];
-};
-
-struct bprintk_entry {
-	struct trace_entry ent;
-	unsigned long ip;
-	const char *fmt;
-	u32 buf[];
+	const char		*fmt;
+	u32 			buf[];
 };
 #ifdef CONFIG_TRACE_BPRINTK
 extern int trace_bprintk_enable;
@@ -295,7 +288,6 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct stack_entry, TRACE_STACK);	\
 		IF_ASSIGN(var, ent, struct userstack_entry, TRACE_USER_STACK);\
 		IF_ASSIGN(var, ent, struct print_entry, TRACE_PRINT);	\
-		IF_ASSIGN(var, ent, struct bprintk_entry, TRACE_BPRINTK);\
 		IF_ASSIGN(var, ent, struct special_entry, 0);		\
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_rw,		\
 			  TRACE_MMIO_RW);				\
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 2461732..13e362d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -742,7 +742,11 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
 		}
 
 	/* The comment */
-	ret = trace_seq_printf(s, "/* %s", trace->buf);
+	ret = trace_seq_printf(s, "/* ");
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_bprintf(s, trace->fmt, trace->buf);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index c401b90..23e346a 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -254,15 +254,18 @@ static enum print_line_t mmio_print_mark(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	struct print_entry *print = (struct print_entry *)entry;
-	const char *msg		= print->buf;
 	struct trace_seq *s	= &iter->seq;
 	unsigned long long t	= ns2usecs(iter->ts);
-	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned long usec_rem	= do_div(t, USEC_PER_SEC);
 	unsigned secs		= (unsigned long)t;
 	int ret;
 
 	/* The trailing newline must be in the message. */
-	ret = trace_seq_printf(s, "MARK %u.%06lu %s", secs, usec_rem, msg);
+	ret = trace_seq_printf(s, "MARK %u.%06lu ", secs, usec_rem);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_bprintf(s, print->fmt, print->buf);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 7897b5d..a020a9b 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -53,8 +53,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	return len;
 }
 
-static int
-trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
+int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
 	int len = (PAGE_SIZE - 1) - s->len;
 	int ret;
@@ -876,50 +875,6 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 	if (!seq_print_ip_sym(s, field->ip, flags))
 		goto partial;
 
-	if (!trace_seq_printf(s, ": %s", field->buf))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
-}
-
-static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
-{
-	struct print_entry *field;
-
-	trace_assign_type(field, iter->ent);
-
-	if (!trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf))
-		goto partial;
-
-	return TRACE_TYPE_HANDLED;
-
- partial:
-	return TRACE_TYPE_PARTIAL_LINE;
-}
-
-static struct trace_event trace_print_event = {
-	.type	 	= TRACE_PRINT,
-	.trace		= trace_print_print,
-	.latency_trace	= trace_print_print,
-	.raw		= trace_print_raw,
-};
-
-/* TRACE_BPRINTK */
-static enum print_line_t
-trace_bprintk_print(struct trace_iterator *iter, int flags)
-{
-	struct trace_entry *entry = iter->ent;
-	struct trace_seq *s = &iter->seq;
-	struct bprintk_entry *field;
-
-	trace_assign_type(field, entry);
-
-	if (!seq_print_ip_sym(s, field->ip, flags))
-		goto partial;
-
 	if (!trace_seq_puts(s, ": "))
 		goto partial;
 
@@ -932,14 +887,13 @@ trace_bprintk_print(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static enum print_line_t
-trace_bprintk_raw(struct trace_iterator *iter, int flags)
+
+static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags)
 {
-	struct trace_entry *entry = iter->ent;
+	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
-	struct bprintk_entry *field;
 
-	trace_assign_type(field, entry);
+	trace_assign_type(field, iter->ent);
 
 	if (!trace_seq_printf(s, ": %lx : ", field->ip))
 		goto partial;
@@ -953,13 +907,11 @@ trace_bprintk_raw(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event trace_bprintk_event = {
-	.type	 	= TRACE_BPRINTK,
-	.trace		= trace_bprintk_print,
-	.latency_trace	= trace_bprintk_print,
-	.raw		= trace_bprintk_raw,
-	.hex		= trace_nop_print,
-	.binary		= trace_nop_print,
+static struct trace_event trace_print_event = {
+	.type	 	= TRACE_PRINT,
+	.trace		= trace_print_print,
+	.latency_trace	= trace_print_print,
+	.raw		= trace_print_raw,
 };
 
 static struct trace_event *events[] __initdata = {
@@ -970,7 +922,6 @@ static struct trace_event *events[] __initdata = {
 	&trace_stack_event,
 	&trace_user_stack_event,
 	&trace_print_event,
-	&trace_bprintk_event,
 	NULL
 };
 
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 551a25a..6d39010 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -19,6 +19,8 @@ struct trace_event {
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int
+trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
+extern int
 seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
 		unsigned long sym_flags);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
diff --git a/kernel/trace/trace_bprintk.c b/kernel/trace/trace_printk.c
similarity index 65%
rename from kernel/trace/trace_bprintk.c
rename to kernel/trace/trace_printk.c
index 28e6286..09f4ace 100644
--- a/kernel/trace/trace_bprintk.c
+++ b/kernel/trace/trace_printk.c
@@ -21,32 +21,21 @@
 
 #ifdef CONFIG_MODULES
 
-/* binary printk basic */
-static DEFINE_MUTEX(btrace_mutex);
-static int btrace_metadata_count;
 /*
- * modules ftrace_bprintk()'s formats are autosaved in struct trace_bprintk_fmt
+ * modules ftrace_printk()'s formats are autosaved in struct trace_bprintk_fmt
  * which are queued on trace_bprintk_fmt_list.
  */
 static LIST_HEAD(trace_bprintk_fmt_list);
 
+/* serialize accesses to trace_bprintk_fmt_list */
+static DEFINE_MUTEX(btrace_mutex);
+
 struct trace_bprintk_fmt {
 	struct list_head list;
 	int count;
 	char fmt[0];
 };
 
-
-static inline void lock_btrace(void)
-{
-	mutex_lock(&btrace_mutex);
-}
-
-static inline void unlock_btrace(void)
-{
-	mutex_unlock(&btrace_mutex);
-}
-
 /*
  * If trace_bprintk() is not active, we release the trace_bprintk's
  * formats that no modules has reference to.
@@ -76,7 +65,8 @@ static
 void hold_module_trace_bprintk_format(const char **start, const char **end)
 {
 	const char **iter;
-	lock_btrace();
+
+	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
 		struct trace_bprintk_fmt *tb_fmt = lookup_format(*iter);
 		if (tb_fmt) {
@@ -95,14 +85,15 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 		} else
 			*iter = NULL;
 	}
-	unlock_btrace();
+	mutex_unlock(&btrace_mutex);
 }
 
 static
 void release_module_trace_bprintk_format(const char **start, const char **end)
 {
 	const char **iter;
-	lock_btrace();
+
+	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
 		struct trace_bprintk_fmt *tb_fmt;
 		if (!*iter)
@@ -110,12 +101,12 @@ void release_module_trace_bprintk_format(const char **start, const char **end)
 
 		tb_fmt = container_of(*iter, struct trace_bprintk_fmt, fmt[0]);
 		tb_fmt->count--;
-		if (!tb_fmt->count && !btrace_metadata_count) {
+		if (!tb_fmt->count) {
 			list_del(&tb_fmt->list);
 			kfree(tb_fmt);
 		}
 	}
-	unlock_btrace();
+	mutex_unlock(&btrace_mutex);
 }
 
 static int module_trace_bprintk_format_notify(struct notifier_block *self,
@@ -134,24 +125,6 @@ static int module_trace_bprintk_format_notify(struct notifier_block *self,
 	return 0;
 }
 
-static void get_btrace_metadata(void)
-{
-	lock_btrace();
-	btrace_metadata_count++;
-	unlock_btrace();
-}
-
-static void put_btrace_metadata(void)
-{
-	lock_btrace();
-	btrace_metadata_count--;
-
-	if (!btrace_metadata_count) {
-		shrink_trace_bprintk_fmt();
-	}
-	unlock_btrace();
-}
-
 #else /* !CONFIG_MODULES */
 __init static int
 module_trace_bprintk_format_notify(struct notifier_block *self,
@@ -159,9 +132,6 @@ module_trace_bprintk_format_notify(struct notifier_block *self,
 {
 	return 0;
 }
-
-static inline void get_btrace_metadata(void) { }
-static inline void put_btrace_metadata(void) { }
 #endif /* CONFIG_MODULES */
 
 
@@ -170,48 +140,39 @@ struct notifier_block module_trace_bprintk_format_nb = {
 	.notifier_call = module_trace_bprintk_format_notify,
 };
 
-/* events tracer */
-int trace_bprintk_enable;
-
-static void start_bprintk_trace(struct trace_array *tr)
+int __ftrace_printk(unsigned long ip, const char *fmt, ...)
 {
-	get_btrace_metadata();
-	tracing_reset_online_cpus(tr);
-	trace_bprintk_enable = 1;
-}
+	int ret;
+	va_list ap;
 
-static void stop_bprintk_trace(struct trace_array *tr)
-{
-	trace_bprintk_enable = 0;
-	tracing_reset_online_cpus(tr);
-	put_btrace_metadata();
-}
+	if (unlikely(!fmt))
+		return 0;
 
-static int init_bprintk_trace(struct trace_array *tr)
-{
-	start_bprintk_trace(tr);
-	return 0;
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
+	va_start(ap, fmt);
+	ret = trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	va_end(ap);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(__ftrace_printk);
 
-static struct tracer bprintk_trace __read_mostly =
+int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
 {
-	.name	     = "events",
-	.init	     = init_bprintk_trace,
-	.reset	     = stop_bprintk_trace,
-	.start	     = start_bprintk_trace,
-	.stop	     = stop_bprintk_trace,
-};
+	if (unlikely(!fmt))
+		return 0;
 
-static __init int init_bprintk(void)
-{
-	int ret = register_module_notifier(&module_trace_bprintk_format_nb);
-	if (ret)
-		return ret;
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
 
-	ret = register_tracer(&bprintk_trace);
-	if (ret)
-		unregister_module_notifier(&module_trace_bprintk_format_nb);
-	return ret;
+	return trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
 }
+EXPORT_SYMBOL_GPL(__ftrace_vprintk);
+
 
-device_initcall(init_bprintk);
+static __init int init_trace_printk(void)
+{
+	return register_module_notifier(&module_trace_bprintk_format_nb);
+}
+early_initcall(init_trace_printk);
-- 
1.6.1


