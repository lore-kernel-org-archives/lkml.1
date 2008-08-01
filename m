Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYHAEyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYHAEyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYHAEyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 00:54:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYHAEym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 00:54:42 -0400
Date: Fri, 1 Aug 2008 00:54:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: printk formatting infrastructure
Message-ID: <alpine.DEB.1.10.0808010021110.20407@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a feature that can help kernel developers debug their
code using ftrace.

  int ftrace_printk(const char *fmt, ...);

This records into the ftrace buffer using printf formatting. The entry
size in the buffers are still a fixed length. A new type has been added
that allows for more entries to be used for a single recording.

The start of the print is still the same as the other entries.

It returns the number of characters written to the ftrace buffer.


For example:

Having a module with the following code:

static int __init ftrace_print_test(void)
{
        ftrace_printk("jiffies are %ld\n", jiffies);
	return 0;
}

Gives me:

  insmod-5441  3...1 7569us : ftrace_print_test: jiffies are 4296626666

for the latency_trace file and:

          insmod-5441  [03]  1959.370498: ftrace_print_test jiffies are 4296626666

for the trace file.

Note: Only the infrastructure should go into the kernel. It is to help 
facilitate debugging for other kernel developers. Calls to ftrace_printk 
is not intended to be left in the kernel, and should be frowned upon just 
like scattering printks around in the code.

But having this easily at your fingertips helps the debugging go faster 
and bugs be solved quicker.

Maybe later on, we can hook this with markers and have their printf format 
be sucked into ftrace output.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h        |   10 +
 kernel/trace/trace.c          |  274 +++++++++++++++++++++++++++++++++++++-----
 kernel/trace/trace.h          |   17 ++
 kernel/trace/trace_selftest.c |   11 +
 4 files changed, 279 insertions(+), 33 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-07-31 21:20:54.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-07-31 21:27:04.000000000 -0400
@@ -137,10 +137,20 @@ static inline void tracer_disable(void)
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
 extern void ftrace_dump(void);
+# define ftrace_printk(x...) __ftrace_printk(_THIS_IP_, x)
+extern int
+__ftrace_printk(unsigned long ip, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
 #else
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 static inline void ftrace_dump(void) { }
+static inline int
+ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)))
+{
+	return 0;
+}
 #endif
 
+
 #endif /* _LINUX_FTRACE_H */
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-07-31 21:20:54.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-08-01 00:49:17.000000000 -0400
@@ -206,12 +206,14 @@ unsigned long nsecs_to_usecs(unsigned lo
  *  NEED_RESCED - reschedule is requested
  *  HARDIRQ	- inside an interrupt handler
  *  SOFTIRQ	- inside a softirq handler
+ *  CONT	- multiple entries hold the trace item
  */
 enum trace_flag_type {
 	TRACE_FLAG_IRQS_OFF		= 0x01,
 	TRACE_FLAG_NEED_RESCHED		= 0x02,
 	TRACE_FLAG_HARDIRQ		= 0x04,
 	TRACE_FLAG_SOFTIRQ		= 0x08,
+	TRACE_FLAG_CONT			= 0x10,
 };
 
 /*
@@ -1082,6 +1084,7 @@ enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 };
 
+/* Return the current entry.  */
 static struct trace_entry *
 trace_entry_idx(struct trace_array *tr, struct trace_array_cpu *data,
 		struct trace_iterator *iter, int cpu)
@@ -1112,8 +1115,58 @@ trace_entry_idx(struct trace_array *tr, 
 	return &array[iter->next_page_idx[cpu]];
 }
 
+/* Increment the index counter of an iterator by one */
+static void trace_iterator_increment(struct trace_iterator *iter, int cpu)
+{
+	iter->idx++;
+	iter->next_idx[cpu]++;
+	iter->next_page_idx[cpu]++;
+
+	if (iter->next_page_idx[cpu] >= ENTRIES_PER_PAGE) {
+		struct trace_array_cpu *data = iter->tr->data[cpu];
+
+		iter->next_page_idx[cpu] = 0;
+		iter->next_page[cpu] =
+			trace_next_list(data, iter->next_page[cpu]);
+	}
+}
+
 static struct trace_entry *
-find_next_entry(struct trace_iterator *iter, int *ent_cpu)
+trace_entry_next(struct trace_array *tr, struct trace_array_cpu *data,
+		 struct trace_iterator *iter, int cpu)
+{
+	struct list_head *next_page;
+	struct trace_entry *ent;
+	int idx, next_idx, next_page_idx;
+
+	ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+
+	if (likely(!ent || ent->type != TRACE_CONT))
+		return ent;
+
+	/* save the iterator details */
+	idx		= iter->idx;
+	next_idx	= iter->next_idx[cpu];
+	next_page_idx	= iter->next_page_idx[cpu];
+	next_page	= iter->next_page[cpu];
+
+	/* find a real entry */
+	do {
+		trace_iterator_increment(iter, cpu);
+		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+	} while (ent && ent->type != TRACE_CONT);
+
+	/* reset the iterator */
+	iter->idx			= idx;
+	iter->next_idx[cpu]		= next_idx;
+	iter->next_page_idx[cpu]	= next_page_idx;
+	iter->next_page[cpu]		= next_page;
+
+	return ent;
+}
+
+static struct trace_entry *
+__find_next_entry(struct trace_iterator *iter, int *ent_cpu, int inc)
 {
 	struct trace_array *tr = iter->tr;
 	struct trace_entry *ent, *next = NULL;
@@ -1123,7 +1176,23 @@ find_next_entry(struct trace_iterator *i
 	for_each_tracing_cpu(cpu) {
 		if (!head_page(tr->data[cpu]))
 			continue;
+
 		ent = trace_entry_idx(tr, tr->data[cpu], iter, cpu);
+
+		if (ent && ent->type == TRACE_CONT) {
+			struct trace_array_cpu *data = tr->data[cpu];
+
+			if (!inc)
+				ent = trace_entry_next(tr, data, iter, cpu);
+			else {
+				while (ent && ent->type == TRACE_CONT) {
+					trace_iterator_increment(iter, cpu);
+					ent = trace_entry_idx(tr, tr->data[cpu],
+							      iter, cpu);
+				}
+			}
+		}
+
 		/*
 		 * Pick the entry with the smallest timestamp:
 		 */
@@ -1139,25 +1208,39 @@ find_next_entry(struct trace_iterator *i
 	return next;
 }
 
-static void trace_iterator_increment(struct trace_iterator *iter)
+/* Find the next real entry, without updating the iterator itself */
+static struct trace_entry *
+find_next_entry(struct trace_iterator *iter, int *ent_cpu)
 {
-	iter->idx++;
-	iter->next_idx[iter->cpu]++;
-	iter->next_page_idx[iter->cpu]++;
+	return __find_next_entry(iter, ent_cpu, 0);
+}
 
-	if (iter->next_page_idx[iter->cpu] >= ENTRIES_PER_PAGE) {
-		struct trace_array_cpu *data = iter->tr->data[iter->cpu];
+/* Find the next real entry, and increment the iterator to the next entry */
+static void *find_next_entry_inc(struct trace_iterator *iter)
+{
+	struct trace_entry *next;
+	int next_cpu = -1;
 
-		iter->next_page_idx[iter->cpu] = 0;
-		iter->next_page[iter->cpu] =
-			trace_next_list(data, iter->next_page[iter->cpu]);
-	}
+	next = __find_next_entry(iter, &next_cpu, 1);
+
+	iter->prev_ent = iter->ent;
+	iter->prev_cpu = iter->cpu;
+
+	iter->ent = next;
+	iter->cpu = next_cpu;
+
+	if (next)
+		trace_iterator_increment(iter, iter->cpu);
+
+	return next ? iter : NULL;
 }
 
 static void trace_consume(struct trace_iterator *iter)
 {
 	struct trace_array_cpu *data = iter->tr->data[iter->cpu];
+	struct trace_entry *ent;
 
+ again:
 	data->trace_tail_idx++;
 	if (data->trace_tail_idx >= ENTRIES_PER_PAGE) {
 		data->trace_tail = trace_next_page(data, data->trace_tail);
@@ -1168,25 +1251,11 @@ static void trace_consume(struct trace_i
 	if (data->trace_head == data->trace_tail &&
 	    data->trace_head_idx == data->trace_tail_idx)
 		data->trace_idx = 0;
-}
 
-static void *find_next_entry_inc(struct trace_iterator *iter)
-{
-	struct trace_entry *next;
-	int next_cpu = -1;
-
-	next = find_next_entry(iter, &next_cpu);
-
-	iter->prev_ent = iter->ent;
-	iter->prev_cpu = iter->cpu;
-
-	iter->ent = next;
-	iter->cpu = next_cpu;
-
-	if (next)
-		trace_iterator_increment(iter);
-
-	return next ? iter : NULL;
+	ent = trace_entry_idx(iter->tr, iter->tr->data[iter->cpu],
+			      iter, iter->cpu);
+	if (ent && ent->type == TRACE_CONT)
+		goto again;
 }
 
 static void *s_next(struct seq_file *m, void *v, loff_t *pos)
@@ -1480,6 +1549,28 @@ lat_print_timestamp(struct trace_seq *s,
 
 static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
 
+static void
+trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
+{
+	struct trace_array *tr = iter->tr;
+	struct trace_array_cpu *data = tr->data[iter->cpu];
+	struct trace_entry *ent;
+	struct trace_cont *cont;
+
+	ent = trace_entry_idx(tr, data, iter, iter->cpu);
+	if (!ent || ent->type != TRACE_CONT) {
+		trace_seq_putc(s, '\n');
+		return;
+	}
+
+	do {
+		cont = (struct trace_cont *)ent;
+		trace_seq_printf(s, "%s", cont->buf);
+		trace_iterator_increment(iter, iter->cpu);
+		ent = trace_entry_idx(tr, data, iter, iter->cpu);
+	} while (ent && ent->type == TRACE_CONT);
+}
+
 static int
 print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 {
@@ -1497,6 +1588,10 @@ print_lat_fmt(struct trace_iterator *ite
 
 	if (!next_entry)
 		next_entry = entry;
+
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	rel_usecs = ns2usecs(next_entry->t - entry->t);
 	abs_usecs = ns2usecs(entry->t - iter->tr->time_start);
 
@@ -1555,6 +1650,12 @@ print_lat_fmt(struct trace_iterator *ite
 		}
 		trace_seq_puts(s, "\n");
 		break;
+	case TRACE_PRINT:
+		seq_print_ip_sym(s, entry->print.ip, sym_flags);
+		trace_seq_printf(s, ": %s", entry->print.buf);
+		if (entry->flags && TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
 	default:
 		trace_seq_printf(s, "Unknown type %d\n", entry->type);
 	}
@@ -1576,6 +1677,9 @@ static int print_trace_fmt(struct trace_
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	comm = trace_find_cmdline(iter->ent->pid);
 
 	t = ns2usecs(entry->t);
@@ -1655,6 +1759,12 @@ static int print_trace_fmt(struct trace_
 		if (!ret)
 			return 0;
 		break;
+	case TRACE_PRINT:
+		seq_print_ip_sym(s, entry->print.ip, sym_flags);
+		trace_seq_printf(s, ": %s", entry->print.buf);
+		if (entry->flags && TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
 	}
 	return 1;
 }
@@ -1668,6 +1778,9 @@ static int print_raw_fmt(struct trace_it
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	ret = trace_seq_printf(s, "%d %d %llu ",
 		entry->pid, iter->cpu, entry->t);
 	if (!ret)
@@ -1707,6 +1820,12 @@ static int print_raw_fmt(struct trace_it
 		if (!ret)
 			return 0;
 		break;
+	case TRACE_PRINT:
+		trace_seq_printf(s, "# %lx %s",
+				 entry->print.ip, entry->print.buf);
+		if (entry->flags && TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
 	}
 	return 1;
 }
@@ -1732,6 +1851,9 @@ static int print_hex_fmt(struct trace_it
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
 	SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
 	SEQ_PUT_HEX_FIELD_RET(s, entry->t);
@@ -1776,6 +1898,9 @@ static int print_bin_fmt(struct trace_it
 
 	entry = iter->ent;
 
+	if (entry->type == TRACE_CONT)
+		return 1;
+
 	SEQ_PUT_FIELD_RET(s, entry->pid);
 	SEQ_PUT_FIELD_RET(s, entry->cpu);
 	SEQ_PUT_FIELD_RET(s, entry->t);
@@ -3098,6 +3223,97 @@ void ftrace_dump(void)
 	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
 }
 
+#define TRACE_BUF_SIZE 1024
+#define TRACE_PRINT_BUF_SIZE \
+	(TRACE_ENTRY_SIZE - offsetof(struct trace_entry, print.buf))
+#define TRACE_CONT_BUF_SIZE \
+	(TRACE_ENTRY_SIZE - offsetof(struct trace_cont, buf))
+
+/**
+ * ftrace_printk - printf formatting in the ftrace buffer
+ * @fmt - the printf format for printing.
+ *
+ * Note: __ftrace_printk is an internal function for ftrace_printk and
+ *       the @ip is passed in via the ftrace_printk macro.
+ *
+ * This function allows a kernel developer to debug fast path sections
+ * that printk is not appropriate for. By scattering in various
+ * printk like tracing in the code, a developer can quickly see
+ * where problems are occurring.
+ *
+ * This is intended as a debugging tool for the developer only.
+ * Please abstain from leaving ftrace_printks scattered around in
+ * your code.
+ */
+int __ftrace_printk(unsigned long ip, const char *fmt, ...)
+{
+	struct trace_array *tr = &global_trace;
+	static DEFINE_SPINLOCK(trace_buf_lock);
+	static char trace_buf[TRACE_BUF_SIZE];
+	struct trace_array_cpu *data;
+	struct trace_entry *entry;
+	struct trace_cont *cont;
+	unsigned long flags;
+	long disabled;
+	va_list ap;
+	int cpu, len = 0, write, written = 0;
+
+	if (likely(!ftrace_function_enabled))
+		return 0;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (unlikely(disabled != 1 || !ftrace_function_enabled))
+		goto out;
+
+	spin_lock(&trace_buf_lock);
+	va_start(ap, fmt);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, ap);
+	va_end(ap);
+
+	len = min(len, TRACE_BUF_SIZE-1);
+	trace_buf[len] = 0;
+
+	__raw_spin_lock(&data->lock);
+	entry			= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, flags);
+	entry->type		= TRACE_PRINT;
+	entry->print.ip		= ip;
+
+	write = min(len, (int)(TRACE_PRINT_BUF_SIZE-1));
+
+	memcpy(&entry->print.buf, trace_buf, write);
+	entry->print.buf[write] = 0;
+	written = write;
+
+	if (written != len)
+		entry->flags |= TRACE_FLAG_CONT;
+
+	while (written != len) {
+		entry = tracing_get_trace_entry(tr, data);
+		cont = (struct trace_cont *)entry;
+
+		cont->type = TRACE_CONT;
+		write = min(len - written, (int)(TRACE_CONT_BUF_SIZE-1));
+		memcpy(&cont->buf, trace_buf+written, write);
+		cont->buf[write] = 0;
+		written += write;
+	}
+	__raw_spin_unlock(&data->lock);
+
+	spin_unlock(&trace_buf_lock);
+
+ out:
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(__ftrace_printk);
+
 static int trace_alloc_page(void)
 {
 	struct trace_array_cpu *data;
Index: linux-tip.git/kernel/trace/trace.h
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.h	2008-07-31 21:20:54.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.h	2008-07-31 23:58:22.000000000 -0400
@@ -13,7 +13,9 @@ enum trace_type {
 	TRACE_FN,
 	TRACE_CTX,
 	TRACE_WAKE,
+	TRACE_CONT,
 	TRACE_STACK,
+	TRACE_PRINT,
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
@@ -60,6 +62,11 @@ struct stack_entry {
 	unsigned long		caller[FTRACE_STACK_ENTRIES];
 };
 
+struct print_entry {
+	unsigned long		ip;
+	char			buf[];
+};
+
 /*
  * The trace entry - the most basic unit of tracing. This is what
  * is printed in the end as a single line in the trace output, such as:
@@ -78,11 +85,21 @@ struct trace_entry {
 		struct ctx_switch_entry		ctx;
 		struct special_entry		special;
 		struct stack_entry		stack;
+		struct print_entry		print;
 		struct mmiotrace_rw		mmiorw;
 		struct mmiotrace_map		mmiomap;
 	};
 };
 
+/*
+ * When an item needs more than one entry to fill a buffer
+ * it can use this structure.
+ */
+struct trace_cont {
+	char type;
+	char buf[];
+};
+
 #define TRACE_ENTRY_SIZE	sizeof(struct trace_entry)
 
 /*
Index: linux-tip.git/kernel/trace/trace_selftest.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace_selftest.c	2008-07-31 21:20:54.000000000 -0400
+++ linux-tip.git/kernel/trace/trace_selftest.c	2008-07-31 21:27:04.000000000 -0400
@@ -9,7 +9,9 @@ static inline int trace_valid_entry(stru
 	case TRACE_FN:
 	case TRACE_CTX:
 	case TRACE_WAKE:
+	case TRACE_CONT:
 	case TRACE_STACK:
+	case TRACE_PRINT:
 	case TRACE_SPECIAL:
 		return 1;
 	}
@@ -120,11 +122,11 @@ int trace_selftest_startup_dynamic_traci
 					   struct trace_array *tr,
 					   int (*func)(void))
 {
-	unsigned long count;
-	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	unsigned long count;
 	char *func_name;
+	int ret;
 
 	/* The ftrace test PASSED */
 	printk(KERN_CONT "PASSED\n");
@@ -157,6 +159,7 @@ int trace_selftest_startup_dynamic_traci
 	/* enable tracing */
 	tr->ctrl = 1;
 	trace->init(tr);
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 
@@ -212,10 +215,10 @@ int trace_selftest_startup_dynamic_traci
 int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 {
-	unsigned long count;
-	int ret;
 	int save_ftrace_enabled = ftrace_enabled;
 	int save_tracer_enabled = tracer_enabled;
+	unsigned long count;
+	int ret;
 
 	/* make sure msleep has been recorded */
 	msleep(1);
