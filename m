Return-Path: <linux-kernel-owner+w=401wt.eu-S964952AbZLGUWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952AbZLGUWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934468AbZLGUWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:22:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61325 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885AbZLGUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:22:04 -0500
Message-Id: <20091207202209.046451439@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Dec 2009 15:19:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] [PATCH 2/4] tracing: Buffer the output of seq_file in case of filled buffer
References: <20091207201903.864817226@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Buffer-the-output-of-seq_file-in-case-of-fil.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the seq_read fills the buffer it will call s_start again on the next
itertation with the same position. This causes a problem with the
function_graph tracer because it consumes the iteration in order to
determine leaf functions.

What happens is that the iterator stores the entry, and the function
graph plugin will look at the next entry. If that next entry is a return
of the same function and task, then the function is a leaf and the
function_graph plugin calls ring_buffer_read which moves the ring buffer
iterator forward (the trace iterator still points to the function start
entry).

The copying of the trace_seq to the seq_file buffer will fail if the
seq_file buffer is full. The seq_read will not show this entry.
The next read by userspace will cause seq_read to again call s_start
which will reuse the trace iterator entry (the function start entry).
But the function return entry was already consumed. The function graph
plugin will think that this entry is a nested function and not a leaf.

To solve this, the trace code now checks the return status of the
seq_printf (trace_print_seq). If the writing to the seq_file buffer
fails, we set a flag in the iterator (leftover) and we do not reset
the trace_seq buffer. On the next call to s_start, we check the leftover
flag, and if it is set, we just reuse the trace_seq buffer and do not
call into the plugin print functions.

Before this patch:

 2)               |      fput() {
 2)               |        __fput() {
 2)   0.550 us    |          inotify_inode_queue_event();
 2)               |          __fsnotify_parent() {
 2)   0.540 us    |          inotify_dentry_parent_queue_event();

After the patch:

 2)               |      fput() {
 2)               |        __fput() {
 2)   0.550 us    |          inotify_inode_queue_event();
 2)   0.548 us    |          __fsnotify_parent();
 2)   0.540 us    |          inotify_dentry_parent_queue_event();

Reported-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 include/linux/trace_seq.h    |    4 ++--
 kernel/trace/trace.c         |   35 ++++++++++++++++++++++++++++++++---
 kernel/trace/trace_output.c  |   14 +++++++++++---
 4 files changed, 46 insertions(+), 8 deletions(-)

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
index 09077f6..48d81df 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -33,7 +33,7 @@ extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 2, 0)));
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
-extern void trace_print_seq(struct seq_file *m, struct trace_seq *s);
+extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
 extern int trace_seq_puts(struct trace_seq *s, const char *str);
@@ -55,7 +55,7 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 	return 0;
 }
 
-static inline void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
 }
 static inline ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f804b40..596dcf2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1516,6 +1516,8 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 	int i = (int)*pos;
 	void *ent;
 
+	WARN_ON_ONCE(iter->leftover);
+
 	(*pos)++;
 
 	/* can't go backwards */
@@ -1614,8 +1616,16 @@ static void *s_start(struct seq_file *m, loff_t *pos)
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
@@ -1923,6 +1933,7 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
+	int ret;
 
 	if (iter->ent == NULL) {
 		if (iter->tr) {
@@ -1942,9 +1953,27 @@ static int s_show(struct seq_file *m, void *v)
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
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b6c12c6..e5cf90f 100644
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
-- 
1.6.5


