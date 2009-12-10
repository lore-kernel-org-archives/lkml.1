Return-Path: <linux-kernel-owner+w=401wt.eu-S1761640AbZLJTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640AbZLJTk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 14:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZLJTkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 14:40:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50922 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbZLJTkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 14:40:22 -0500
Date: Thu, 10 Dec 2009 20:40:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20091210194016.GA20811@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Carsten Emde (1):
      tracing: Remove comparing of NULL to va_list in trace_array_vprintk()

Jiri Olsa (1):
      tracing: Fix function graph trace_pipe to properly display failed entries

Johannes Berg (1):
      tracing: Add full state to trace_seq

Steven Rostedt (3):
      tracing: Add pipe_close interface
      tracing: Only call pipe_close if pipe_close is defined
      tracing: Buffer the output of seq_file in case of filled buffer


 include/linux/ftrace_event.h         |    1 +
 include/linux/trace_seq.h            |    7 +-
 kernel/trace/trace.c                 |   57 ++++++++++--
 kernel/trace/trace.h                 |    2 +
 kernel/trace/trace_functions_graph.c |  165 +++++++++++++++++++++++++++-------
 kernel/trace/trace_output.c          |   75 +++++++++++++---
 6 files changed, 248 insertions(+), 59 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 47bbdf9..38f8d65 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -57,6 +57,7 @@ struct trace_iterator {
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
+	int			leftover;
 	int			cpu;
 	u64			ts;
 
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 09077f6..5cf397c 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -14,6 +14,7 @@ struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
 	unsigned int		len;
 	unsigned int		readpos;
+	int			full;
 };
 
 static inline void
@@ -21,6 +22,7 @@ trace_seq_init(struct trace_seq *s)
 {
 	s->len = 0;
 	s->readpos = 0;
+	s->full = 0;
 }
 
 /*
@@ -33,7 +35,7 @@ extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
-extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
+extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern int trace_seq_puts(struct trace_seq *s, const char *str);
@@ -55,8 +57,9 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	return 0;
 }
 
-static inline void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
+	return 0;
 }
 static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 874f289..88bd9ae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1361,11 +1361,7 @@ int trace_array_vprintk(struct trace_array *tr,
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
 	__raw_spin_lock(&trace_buf_lock);
-	if (args == NULL) {
-		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
-		len = strlen(trace_buf);
-	} else
-		len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
@@ -1516,6 +1512,8 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 	int i = (int)*pos;
 	void *ent;
 
+	WARN_ON_ONCE(iter->leftover);
+
 	(*pos)++;
 
 	/* can't go backwards */
@@ -1614,8 +1612,16 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 			;
 
 	} else {
-		l = *pos - 1;
-		p = s_next(m, p, &l);
+		/*
+		 * If we overflowed the seq_file before, then we want
+		 * to just reuse the trace_seq buffer again.
+		 */
+		if (iter->leftover)
+			p = iter;
+		else {
+			l = *pos - 1;
+			p = s_next(m, p, &l);
+		}
 	}
 
 	trace_event_read_lock();
@@ -1923,6 +1929,7 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
+	int ret;
 
 	if (iter->ent == NULL) {
 		if (iter->tr) {
@@ -1942,9 +1949,27 @@ static int s_show(struct seq_file *m, void *v)
 			if (!(trace_flags & TRACE_ITER_VERBOSE))
 				print_func_help_header(m);
 		}
+	} else if (iter->leftover) {
+		/*
+		 * If we filled the seq_file buffer earlier, we
+		 * want to just show it now.
+		 */
+		ret = trace_print_seq(m, &iter->seq);
+
+		/* ret should this time be zero, but you never know */
+		iter->leftover = ret;
+
 	} else {
 		print_trace_line(iter);
-		trace_print_seq(m, &iter->seq);
+		ret = trace_print_seq(m, &iter->seq);
+		/*
+		 * If we overflow the seq_file buffer, then it will
+		 * ask us for this data again at start up.
+		 * Use that instead.
+		 *  ret is 0 if seq_file write succeeded.
+		 *        -1 otherwise.
+		 */
+		iter->leftover = ret;
 	}
 
 	return 0;
@@ -2898,6 +2923,10 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	else
 		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
 
+
+	if (iter->trace->pipe_close)
+		iter->trace->pipe_close(iter);
+
 	mutex_unlock(&trace_types_lock);
 
 	free_cpumask_var(iter->started);
@@ -3320,6 +3349,16 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int mark_printk(const char *fmt, ...)
+{
+	int ret;
+	va_list args;
+	va_start(args, fmt);
+	ret = trace_vprintk(0, fmt, args);
+	va_end(args);
+	return ret;
+}
+
 static ssize_t
 tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
@@ -3346,7 +3385,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 	} else
 		buf[cnt] = '\0';
 
-	cnt = trace_vprintk(0, buf, NULL);
+	cnt = mark_printk("%s", buf);
 	kfree(buf);
 	*fpos += cnt;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 1d7f483..7fa33ca 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -272,6 +272,7 @@ struct tracer_flags {
  * @pipe_open: called when the trace_pipe file is opened
  * @wait_pipe: override how the user waits for traces on trace_pipe
  * @close: called when the trace file is released
+ * @pipe_close: called when the trace_pipe file is released
  * @read: override the default read callback on trace_pipe
  * @splice_read: override the default splice_read callback on trace_pipe
  * @selftest: selftest to run on boot (see trace_selftest.c)
@@ -290,6 +291,7 @@ struct tracer {
 	void			(*pipe_open)(struct trace_iterator *iter);
 	void			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
+	void			(*pipe_close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
 					struct file *filp, char __user *ubuf,
 					size_t cnt, loff_t *ppos);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..a43d009 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -14,9 +14,20 @@
 #include "trace.h"
 #include "trace_output.h"
 
-struct fgraph_data {
+struct fgraph_cpu_data {
 	pid_t		last_pid;
 	int		depth;
+	int		ignore;
+};
+
+struct fgraph_data {
+	struct fgraph_cpu_data		*cpu_data;
+
+	/* Place to preserve last processed entry. */
+	struct ftrace_graph_ent_entry	ent;
+	struct ftrace_graph_ret_entry	ret;
+	int				failed;
+	int				cpu;
 };
 
 #define TRACE_GRAPH_INDENT	2
@@ -384,7 +395,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 	if (!data)
 		return TRACE_TYPE_HANDLED;
 
-	last_pid = &(per_cpu_ptr(data, cpu)->last_pid);
+	last_pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
 
 	if (*last_pid == pid)
 		return TRACE_TYPE_HANDLED;
@@ -435,26 +446,49 @@ static struct ftrace_graph_ret_entry *
 get_return_for_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *curr)
 {
-	struct ring_buffer_iter *ring_iter;
+	struct fgraph_data *data = iter->private;
+	struct ring_buffer_iter *ring_iter = NULL;
 	struct ring_buffer_event *event;
 	struct ftrace_graph_ret_entry *next;
 
-	ring_iter = iter->buffer_iter[iter->cpu];
+	/*
+	 * If the previous output failed to write to the seq buffer,
+	 * then we just reuse the data from before.
+	 */
+	if (data && data->failed) {
+		curr = &data->ent;
+		next = &data->ret;
+	} else {
 
-	/* First peek to compare current entry and the next one */
-	if (ring_iter)
-		event = ring_buffer_iter_peek(ring_iter, NULL);
-	else {
-	/* We need to consume the current entry to see the next one */
-		ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
-		event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
-					NULL);
-	}
+		ring_iter = iter->buffer_iter[iter->cpu];
+
+		/* First peek to compare current entry and the next one */
+		if (ring_iter)
+			event = ring_buffer_iter_peek(ring_iter, NULL);
+		else {
+			/*
+			 * We need to consume the current entry to see
+			 * the next one.
+			 */
+			ring_buffer_consume(iter->tr->buffer, iter->cpu, NULL);
+			event = ring_buffer_peek(iter->tr->buffer, iter->cpu,
+						 NULL);
+		}
 
-	if (!event)
-		return NULL;
+		if (!event)
+			return NULL;
+
+		next = ring_buffer_event_data(event);
 
-	next = ring_buffer_event_data(event);
+		if (data) {
+			/*
+			 * Save current and next entries for later reference
+			 * if the output fails.
+			 */
+			data->ent = *curr;
+			data->ret = *next;
+		}
+	}
 
 	if (next->ent.type != TRACE_GRAPH_RET)
 		return NULL;
@@ -640,7 +674,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		/*
 		 * Comments display at + 1 to depth. Since
@@ -688,7 +722,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		*depth = call->depth;
 	}
@@ -782,19 +816,34 @@ static enum print_line_t
 print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 			struct trace_iterator *iter)
 {
-	int cpu = iter->cpu;
+	struct fgraph_data *data = iter->private;
 	struct ftrace_graph_ent *call = &field->graph_ent;
 	struct ftrace_graph_ret_entry *leaf_ret;
+	static enum print_line_t ret;
+	int cpu = iter->cpu;
 
 	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
-		return print_graph_entry_leaf(iter, field, leaf_ret, s);
+		ret = print_graph_entry_leaf(iter, field, leaf_ret, s);
 	else
-		return print_graph_entry_nested(iter, field, s, cpu);
+		ret = print_graph_entry_nested(iter, field, s, cpu);
 
+	if (data) {
+		/*
+		 * If we failed to write our output, then we need to make
+		 * note of it. Because we already consumed our entry.
+		 */
+		if (s->full) {
+			data->failed = 1;
+			data->cpu = cpu;
+		} else
+			data->failed = 0;
+	}
+
+	return ret;
 }
 
 static enum print_line_t
@@ -810,7 +859,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
 
 		/*
 		 * Comments display at + 1 to depth. This is the
@@ -873,7 +922,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 	int i;
 
 	if (data)
-		depth = per_cpu_ptr(data, iter->cpu)->depth;
+		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
 	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -941,8 +990,33 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
+	struct ftrace_graph_ent_entry *field;
+	struct fgraph_data *data = iter->private;
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
+	int cpu = iter->cpu;
+	int ret;
+
+	if (data && per_cpu_ptr(data->cpu_data, cpu)->ignore) {
+		per_cpu_ptr(data->cpu_data, cpu)->ignore = 0;
+		return TRACE_TYPE_HANDLED;
+	}
+
+	/*
+	 * If the last output failed, there's a possibility we need
+	 * to print out the missing entry which would never go out.
+	 */
+	if (data && data->failed) {
+		field = &data->ent;
+		iter->cpu = data->cpu;
+		ret = print_graph_entry(field, s, iter);
+		if (ret == TRACE_TYPE_HANDLED && iter->cpu != cpu) {
+			per_cpu_ptr(data->cpu_data, iter->cpu)->ignore = 1;
+			ret = TRACE_TYPE_NO_CONSUME;
+		}
+		iter->cpu = cpu;
+		return ret;
+	}
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
@@ -952,7 +1026,7 @@ print_graph_function(struct trace_iterator *iter)
 		 * sizeof(struct ftrace_graph_ent_entry) is very small,
 		 * it can be safely saved at the stack.
 		 */
-		struct ftrace_graph_ent_entry *field, saved;
+		struct ftrace_graph_ent_entry saved;
 		trace_assign_type(field, entry);
 		saved = *field;
 		return print_graph_entry(&saved, s, iter);
@@ -1030,31 +1104,54 @@ static void print_graph_headers(struct seq_file *s)
 static void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
-	struct fgraph_data *data = alloc_percpu(struct fgraph_data);
+	struct fgraph_data *data;
 	int cpu;
 
+	iter->private = NULL;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		pr_warning("function graph tracer: not enough memory\n");
-	else
-		for_each_possible_cpu(cpu) {
-			pid_t *pid = &(per_cpu_ptr(data, cpu)->last_pid);
-			int *depth = &(per_cpu_ptr(data, cpu)->depth);
-			*pid = -1;
-			*depth = 0;
-		}
+		goto out_err;
+
+	data->cpu_data = alloc_percpu(struct fgraph_cpu_data);
+	if (!data->cpu_data)
+		goto out_err_free;
+
+	for_each_possible_cpu(cpu) {
+		pid_t *pid = &(per_cpu_ptr(data->cpu_data, cpu)->last_pid);
+		int *depth = &(per_cpu_ptr(data->cpu_data, cpu)->depth);
+		int *ignore = &(per_cpu_ptr(data->cpu_data, cpu)->ignore);
+		*pid = -1;
+		*depth = 0;
+		*ignore = 0;
+	}
 
 	iter->private = data;
+
+	return;
+
+ out_err_free:
+	kfree(data);
+ out_err:
+	pr_warning("function graph tracer: not enough memory\n");
 }
 
 static void graph_trace_close(struct trace_iterator *iter)
 {
-	free_percpu(iter->private);
+	struct fgraph_data *data = iter->private;
+
+	if (data) {
+		free_percpu(data->cpu_data);
+		kfree(data);
+	}
 }
 
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
+	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
+	.pipe_close	= graph_trace_close,
 	.wait_pipe	= poll_wait_pipe,
 	.init		= graph_trace_init,
 	.reset		= graph_trace_reset,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6c12c6..8e46b33 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -23,13 +23,21 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
-void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+	int ret;
+
+	ret = seq_write(m, s->buffer, len);
 
-	seq_write(m, s->buffer, len);
+	/*
+	 * Only reset this buffer if we successfully wrote to the
+	 * seq_file buffer.
+	 */
+	if (!ret)
+		trace_seq_init(s);
 
-	trace_seq_init(s);
+	return ret;
 }
 
 enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
@@ -85,7 +93,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_list ap;
 	int ret;
 
-	if (!len)
+	if (s->full || !len)
 		return 0;
 
 	va_start(ap, fmt);
@@ -93,8 +101,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	if (ret >= len) {
+		s->full = 1;
 		return 0;
+	}
 
 	s->len += ret;
 
@@ -119,14 +129,16 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	int len = (PAGE_SIZE - 1) - s->len;
 	int ret;
 
-	if (!len)
+	if (s->full || !len)
 		return 0;
 
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	if (ret >= len) {
+		s->full = 1;
 		return 0;
+	}
 
 	s->len += ret;
 
@@ -139,14 +151,16 @@ int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	int len = (PAGE_SIZE - 1) - s->len;
 	int ret;
 
-	if (!len)
+	if (s->full || !len)
 		return 0;
 
 	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	if (ret >= len) {
+		s->full = 1;
 		return 0;
+	}
 
 	s->len += ret;
 
@@ -167,8 +181,13 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	int len = strlen(str);
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (s->full)
+		return 0;
+
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
 		return 0;
+	}
 
 	memcpy(s->buffer + s->len, str, len);
 	s->len += len;
@@ -178,9 +197,14 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	if (s->len >= (PAGE_SIZE - 1))
+	if (s->full)
 		return 0;
 
+	if (s->len >= (PAGE_SIZE - 1)) {
+		s->full = 1;
+		return 0;
+	}
+
 	s->buffer[s->len++] = c;
 
 	return 1;
@@ -188,9 +212,14 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 
 int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (s->full)
 		return 0;
 
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
+		return 0;
+	}
+
 	memcpy(s->buffer + s->len, mem, len);
 	s->len += len;
 
@@ -203,6 +232,9 @@ int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
 	const unsigned char *data = mem;
 	int i, j;
 
+	if (s->full)
+		return 0;
+
 #ifdef __BIG_ENDIAN
 	for (i = 0, j = 0; i < len; i++) {
 #else
@@ -220,8 +252,13 @@ void *trace_seq_reserve(struct trace_seq *s, size_t len)
 {
 	void *ret;
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	if (s->full)
+		return 0;
+
+	if (len > ((PAGE_SIZE - 1) - s->len)) {
+		s->full = 1;
 		return NULL;
+	}
 
 	ret = s->buffer + s->len;
 	s->len += len;
@@ -233,8 +270,14 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 {
 	unsigned char *p;
 
-	if (s->len >= (PAGE_SIZE - 1))
+	if (s->full)
+		return 0;
+
+	if (s->len >= (PAGE_SIZE - 1)) {
+		s->full = 1;
 		return 0;
+	}
+
 	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
 	if (!IS_ERR(p)) {
 		p = mangle_path(s->buffer + s->len, p, "\n");
@@ -247,6 +290,7 @@ int trace_seq_path(struct trace_seq *s, struct path *path)
 		return 1;
 	}
 
+	s->full = 1;
 	return 0;
 }
 
@@ -373,6 +417,9 @@ int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
 	unsigned long vmstart = 0;
 	int ret = 1;
 
+	if (s->full)
+		return 0;
+
 	if (mm) {
 		const struct vm_area_struct *vma;
 
