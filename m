Return-Path: <linux-kernel-owner+w=401wt.eu-S932635AbZKXM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbZKXM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbZKXM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:57:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbZKXM5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:57:44 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tracing - fix function graph trace to properly display failed entries
Date: Tue, 24 Nov 2009 13:57:38 +0100
Message-Id: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there's a case where the graph tracer might get confused and omits
display of a single record.  This applies for both destructive
(trace_pipe) and nondestructive (trace) cases.


<issue description>

The issue description for nondestructive case (trace) follows:

As the function_graph tracer goes through the trace entries (using "trace" file)
it keeps pointer to the current record and the next one:

current ->  func1 ENTRY
   next ->  func2 ENTRY
            func2 RETURN
            func1 RETURN

If it spots adjacent ENTRY and RETURN trace entries of the same function
and pid, it displays the "func2();" trace

            func1 ENTRY
current ->  func2 ENTRY 
   next ->  func2 RETURN
            func1 RETURN

and moves the next trace entry pointer behind the RETURN entry

            func1 ENTRY
current ->  func2 ENTRY 
            func2 RETURN
   next ->  func1 RETURN

so the next record peek will skip the RETURN entry and continue with
whatever is next.

It works ok but for one case. 

If the "func2()" trace does not make it to the seq_file read buffer, it needs
to be processed again in the next read.  And here comes the issue: 
the next read will see following pointers setup for func2 processing:

            func1 ENTRY
current ->  func2 ENTRY 
            func2 RETURN
   next ->  func1 RETURN

which will turn to displaying the func2 entry like: "func2() {", since the
next entry is not RETURN of the same type.  Generaly it is whatever entry 
that follows, but definitelly not the RETURN entry of the same function.

The destructive case (trace_pipe) suffers from the similar issue,
although it keeps only the current pointer.

</issue description>


The following patch propose generic solution for both cases.
It keeps the last read entry/return in the tracer private
iterator storage and keeps track of the failed output.
Whenever the output fails, next read will output previous
'not displayed' entry before processing next entry.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/trace_seq.h            |    5 +-
 kernel/trace/trace.c                 |   10 ++-
 kernel/trace/trace_functions_graph.c |  152 ++++++++++++++++++++++++++++++----
 kernel/trace/trace_output.c          |   26 ++++--
 4 files changed, 162 insertions(+), 31 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 09077f6..33ab410 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -14,6 +14,7 @@ struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
 	unsigned int		len;
 	unsigned int		readpos;
+	int			failed;
 };
 
 static inline void
@@ -33,7 +34,7 @@ extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
-extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
+extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern int trace_seq_puts(struct trace_seq *s, const char *str);
@@ -55,7 +56,7 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	return 0;
 }
 
-static inline void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 }
 static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 874f289..ca52715 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3049,10 +3049,14 @@ waitagain:
 	if (cnt >= PAGE_SIZE)
 		cnt = PAGE_SIZE - 1;
 
-	/* reset all but tr, trace, and overruns */
-	memset(&iter->seq, 0,
+	/*
+	 * Reset all but tr, trace, and overruns. Preserve 'failed'
+	 * field in the trace_seq structure.
+	 */
+	trace_seq_init(&iter->seq);
+	memset(&iter->ent, 0,
 	       sizeof(struct trace_iterator) -
-	       offsetof(struct trace_iterator, seq));
+	       offsetof(struct trace_iterator, ent));
 	iter->pos = -1;
 
 	trace_event_read_lock();
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..bcdfde4 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -14,11 +14,21 @@
 #include "trace.h"
 #include "trace_output.h"
 
-struct fgraph_data {
+struct fgraph_data_cpu {
 	pid_t		last_pid;
 	int		depth;
 };
 
+struct fgraph_data {
+	struct fgraph_data_cpu *data_cpu;
+
+	/* Place to preserve last processed entry. */
+	struct ftrace_graph_ent_entry ent;
+	struct ftrace_graph_ret_entry ret;
+	int    is_entry;
+	int    is_leaf;
+};
+
 #define TRACE_GRAPH_INDENT	2
 
 /* Flag options */
@@ -384,7 +394,7 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 	if (!data)
 		return TRACE_TYPE_HANDLED;
 
-	last_pid = &(per_cpu_ptr(data, cpu)->last_pid);
+	last_pid = &(per_cpu_ptr(data->data_cpu, cpu)->last_pid);
 
 	if (*last_pid == pid)
 		return TRACE_TYPE_HANDLED;
@@ -431,6 +441,27 @@ verif_pid(struct trace_seq *s, pid_t pid, int cpu, struct fgraph_data *data)
 	return TRACE_TYPE_HANDLED;
 }
 
+static void set_private_entry(struct trace_iterator *iter,
+				struct ftrace_graph_ent_entry *ent,
+				struct ftrace_graph_ret_entry *ret)
+{
+	struct fgraph_data *data = iter->private;
+	data->ent = *ent;
+	data->ret = *ret;
+}
+
+static void set_private_isleaf(struct trace_iterator *iter, int leaf)
+{
+	struct fgraph_data *data = iter->private;
+	data->is_leaf = leaf;
+}
+
+static void set_private_isentry(struct trace_iterator *iter, int entry)
+{
+	struct fgraph_data *data = iter->private;
+	data->is_entry = entry;
+}
+
 static struct ftrace_graph_ret_entry *
 get_return_for_leaf(struct trace_iterator *iter,
 		struct ftrace_graph_ent_entry *curr)
@@ -456,6 +487,13 @@ get_return_for_leaf(struct trace_iterator *iter,
 
 	next = ring_buffer_event_data(event);
 
+	/*
+	 * Save current and next entries for later reference
+	 * if the output failes.
+	 */
+	set_private_entry(iter, curr, next);
+	set_private_isentry(iter, 1);
+
 	if (next->ent.type != TRACE_GRAPH_RET)
 		return NULL;
 
@@ -467,6 +505,9 @@ get_return_for_leaf(struct trace_iterator *iter,
 	if (ring_iter)
 		ring_buffer_read(ring_iter, NULL);
 
+	/* Now we are completely sure this one is a leaf, mark it. */
+	set_private_isleaf(iter, 1);
+
 	return next;
 }
 
@@ -640,7 +681,7 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->data_cpu, cpu)->depth);
 
 		/*
 		 * Comments display at + 1 to depth. Since
@@ -688,7 +729,7 @@ print_graph_entry_nested(struct trace_iterator *iter,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->data_cpu, cpu)->depth);
 
 		*depth = call->depth;
 	}
@@ -779,17 +820,16 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 }
 
 static enum print_line_t
-print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
-			struct trace_iterator *iter)
+print_graph_entry(struct ftrace_graph_ent_entry *field,
+		  struct ftrace_graph_ret_entry *leaf_ret,
+		  struct trace_seq *s, struct trace_iterator *iter)
 {
 	int cpu = iter->cpu;
 	struct ftrace_graph_ent *call = &field->graph_ent;
-	struct ftrace_graph_ret_entry *leaf_ret;
 
 	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	leaf_ret = get_return_for_leaf(iter, field);
 	if (leaf_ret)
 		return print_graph_entry_leaf(iter, field, leaf_ret, s);
 	else
@@ -798,6 +838,17 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 }
 
 static enum print_line_t
+handle_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
+			struct trace_iterator *iter)
+{
+	struct ftrace_graph_ret_entry *leaf_ret;
+
+	leaf_ret = get_return_for_leaf(iter, field);
+
+	return print_graph_entry(field, leaf_ret, s, iter);
+}
+
+static enum print_line_t
 print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		   struct trace_entry *ent, struct trace_iterator *iter)
 {
@@ -810,7 +861,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 
 	if (data) {
 		int cpu = iter->cpu;
-		int *depth = &(per_cpu_ptr(data, cpu)->depth);
+		int *depth = &(per_cpu_ptr(data->data_cpu, cpu)->depth);
 
 		/*
 		 * Comments display at + 1 to depth. This is the
@@ -873,7 +924,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 	int i;
 
 	if (data)
-		depth = per_cpu_ptr(data, iter->cpu)->depth;
+		depth = per_cpu_ptr(data->data_cpu, iter->cpu)->depth;
 
 	if (print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -938,12 +989,68 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 }
 
 
+static int print_failed_entry(struct trace_iterator *iter)
+{
+	struct fgraph_data *data = iter->private;
+	struct trace_seq *s = &iter->seq;
+	struct ftrace_graph_ent_entry *ent = &data->ent;
+	struct ftrace_graph_ret_entry *ret = &data->ret;
+
+	/*
+	 * Only entries suffer from the ahead jump,
+	 * returns are ok.
+	 */
+	if (!data->is_entry)
+		return 0;
+
+	/*
+	 * Last data was a leaf. Trace it out and let's read
+	 * another one, regardless of the consuming or iter
+	 * processing way.
+	 */
+	if (data->is_leaf) {
+		struct ftrace_graph_ent *call = &ent->graph_ent;
+
+		print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func);
+		print_graph_entry_leaf(iter, ent, ret, s);
+		return 1;
+	}
+
+	/*
+	 * Last entry was not a leaf.
+	 *
+	 * If this is iter processing, let it
+	 * handle the usual way.
+	 */
+	if (iter->buffer_iter[iter->cpu])
+		return 0;
+
+	/*
+	 * Last data was not a leaf and we have consuming
+	 * processing. Trace it out and let the usual way
+	 * to pick up on the current entry.
+	 */
+	print_graph_entry(ent, NULL, s, iter);
+	return 0;
+}
+
 enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
 
+	/*
+	 * If the last output failed, there's a possibility we need
+	 * to print out the missing entry which would never go out.
+	 */
+	if (iter->seq.failed &&
+	    print_failed_entry(iter))
+		return TRACE_TYPE_HANDLED;
+
+	set_private_isleaf(iter, 0);
+	set_private_isentry(iter, 0);
+
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
 		/*
@@ -955,7 +1062,7 @@ print_graph_function(struct trace_iterator *iter)
 		struct ftrace_graph_ent_entry *field, saved;
 		trace_assign_type(field, entry);
 		saved = *field;
-		return print_graph_entry(&saved, s, iter);
+		return handle_graph_entry(&saved, s, iter);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;
@@ -1030,30 +1137,41 @@ static void print_graph_headers(struct seq_file *s)
 static void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
-	struct fgraph_data *data = alloc_percpu(struct fgraph_data);
+	struct fgraph_data *data;
+	struct fgraph_data_cpu *data_cpu;
 	int cpu;
 
-	if (!data)
+	data = kzalloc(sizeof(struct fgraph_data), GFP_KERNEL);
+	data_cpu = alloc_percpu(struct fgraph_data_cpu);
+
+	if (!data || !data_cpu)
 		pr_warning("function graph tracer: not enough memory\n");
-	else
+	else {
 		for_each_possible_cpu(cpu) {
-			pid_t *pid = &(per_cpu_ptr(data, cpu)->last_pid);
-			int *depth = &(per_cpu_ptr(data, cpu)->depth);
+			pid_t *pid = &(per_cpu_ptr(data_cpu, cpu)->last_pid);
+			int *depth = &(per_cpu_ptr(data_cpu, cpu)->depth);
 			*pid = -1;
 			*depth = 0;
 		}
 
+		data->data_cpu = data_cpu;
+	}
+
 	iter->private = data;
 }
 
 static void graph_trace_close(struct trace_iterator *iter)
 {
-	free_percpu(iter->private);
+	struct fgraph_data *data = iter->private;
+
+	free_percpu(data->data_cpu);
+	kfree(iter->private);
 }
 
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
+	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
 	.wait_pipe	= poll_wait_pipe,
 	.init		= graph_trace_init,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6c12c6..63e9d4d 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -23,13 +23,15 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
-void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
+	int ret;
 	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
 
-	seq_write(m, s->buffer, len);
-
+	ret = s->failed = seq_write(m, s->buffer, len);
 	trace_seq_init(s);
+
+	return ret;
 }
 
 enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
@@ -93,7 +95,8 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	s->failed = ret >= len;
+	if (s->failed)
 		return 0;
 
 	s->len += ret;
@@ -125,7 +128,8 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	s->failed = ret >= len;
+	if (s->failed)
 		return 0;
 
 	s->len += ret;
@@ -145,7 +149,8 @@ int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
+	s->failed = ret >= len;
+	if (s->failed)
 		return 0;
 
 	s->len += ret;
@@ -167,7 +172,8 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 {
 	int len = strlen(str);
 
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	s->failed = len > ((PAGE_SIZE - 1) - s->len);
+	if (s->failed)
 		return 0;
 
 	memcpy(s->buffer + s->len, str, len);
@@ -178,7 +184,8 @@ int trace_seq_puts(struct trace_seq *s, const char *str)
 
 int trace_seq_putc(struct trace_seq *s, unsigned char c)
 {
-	if (s->len >= (PAGE_SIZE - 1))
+	s->failed = s->len >= (PAGE_SIZE - 1);
+	if (s->failed)
 		return 0;
 
 	s->buffer[s->len++] = c;
@@ -188,7 +195,8 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
 
 int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
 {
-	if (len > ((PAGE_SIZE - 1) - s->len))
+	s->failed = len > ((PAGE_SIZE - 1) - s->len);
+	if (s->failed)
 		return 0;
 
 	memcpy(s->buffer + s->len, mem, len);
