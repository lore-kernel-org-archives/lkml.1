Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbZIZMYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbZIZMYH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZIZMYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:24:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34293 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZIZMYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:24:05 -0400
Date: Sat, 26 Sep 2009 14:23:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090926122354.GA8324@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Anton Blanchard (1):
      tracing/workqueue: Use %pf in workqueue trace events

Ingo Molnar (1):
      modules, tracing: Remove stale struct marker signature from module_layout()

Li Hong (1):
      tracing: Fix a comment and a trivial format issue in tracepoint.h

Li Zefan (4):
      tracing: Fix off-by-one in trace_get_user()
      tracing: Check the return value of trace_get_user()
      tracing: Fix failure path in ftrace_graph_write()
      tracing: Fix failure path in ftrace_regex_open()


 include/linux/tracepoint.h       |    4 ++--
 include/trace/events/workqueue.h |    4 ++--
 kernel/module.c                  |    1 -
 kernel/trace/ftrace.c            |   23 +++++++++++++----------
 kernel/trace/trace.c             |    2 +-
 kernel/trace/trace_events.c      |    7 +++----
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..2aac8a8 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -4,7 +4,7 @@
 /*
  * Kernel Tracepoint API.
  *
- * See Documentation/tracepoint.txt.
+ * See Documentation/trace/tracepoints.txt.
  *
  * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -36,7 +36,7 @@ struct tracepoint {
 #ifndef DECLARE_TRACE
 
 #define TP_PROTO(args...)	args
-#define TP_ARGS(args...)		args
+#define TP_ARGS(args...)	args
 
 #ifdef CONFIG_TRACEPOINTS
 
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index fcfd9a1..e4612db 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -26,7 +26,7 @@ TRACE_EVENT(workqueue_insertion,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->func)
 );
 
@@ -48,7 +48,7 @@ TRACE_EVENT(workqueue_execution,
 		__entry->func		= work->func;
 	),
 
-	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+	TP_printk("thread=%s:%d func=%pf", __entry->thread_comm,
 		__entry->thread_pid, __entry->func)
 );
 
diff --git a/kernel/module.c b/kernel/module.c
index b6ee424..392eb3d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2947,7 +2947,6 @@ void module_layout(struct module *mod,
 		   struct modversion_info *ver,
 		   struct kernel_param *kp,
 		   struct kernel_symbol *ks,
-		   struct marker *marker,
 		   struct tracepoint *tp)
 {
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c71e91b..e70af98 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1621,8 +1621,10 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 		if (!ret) {
 			struct seq_file *m = file->private_data;
 			m->private = iter;
-		} else
+		} else {
+			trace_parser_put(&iter->parser);
 			kfree(iter);
+		}
 	} else
 		file->private_data = iter;
 	mutex_unlock(&ftrace_regex_lock);
@@ -2202,7 +2204,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	struct trace_parser *parser;
 	ssize_t ret, read;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	mutex_lock(&ftrace_regex_lock);
@@ -2216,7 +2218,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	parser = &iter->parser;
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
-	if (trace_parser_loaded(parser) &&
+	if (read >= 0 && trace_parser_loaded(parser) &&
 	    !trace_parser_cont(parser)) {
 		ret = ftrace_process_regex(parser->buffer,
 					   parser->idx, enable);
@@ -2552,8 +2554,7 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
-	size_t read = 0;
-	ssize_t ret;
+	ssize_t read, ret;
 
 	if (!cnt || cnt < 0)
 		return 0;
@@ -2562,29 +2563,31 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 
 	if (ftrace_graph_count >= FTRACE_GRAPH_MAX_FUNCS) {
 		ret = -EBUSY;
-		goto out;
+		goto out_unlock;
 	}
 
 	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
-	if (trace_parser_loaded((&parser))) {
+	if (read >= 0 && trace_parser_loaded((&parser))) {
 		parser.buffer[parser.idx] = 0;
 
 		/* we allow only one expression at a time */
 		ret = ftrace_set_func(ftrace_graph_funcs, &ftrace_graph_count,
 					parser.buffer);
 		if (ret)
-			goto out;
+			goto out_free;
 	}
 
 	ret = read;
- out:
+
+out_free:
 	trace_parser_put(&parser);
+out_unlock:
 	mutex_unlock(&graph_lock);
 
 	return ret;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a35925d..ae17453 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -415,7 +415,7 @@ int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
 
 	/* read the non-space input */
 	while (cnt && !isspace(ch)) {
-		if (parser->idx < parser->size)
+		if (parser->idx < parser->size - 1)
 			parser->buffer[parser->idx++] = ch;
 		else {
 			ret = -EINVAL;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6f03c8a..d128f65 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -232,10 +232,9 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
 	struct trace_parser parser;
-	size_t read = 0;
-	ssize_t ret;
+	ssize_t read, ret;
 
-	if (!cnt || cnt < 0)
+	if (!cnt)
 		return 0;
 
 	ret = tracing_update_buffers();
@@ -247,7 +246,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 
 	read = trace_get_user(&parser, ubuf, cnt, ppos);
 
-	if (trace_parser_loaded((&parser))) {
+	if (read >= 0 && trace_parser_loaded((&parser))) {
 		int set = 1;
 
 		if (*parser.buffer == '!')
