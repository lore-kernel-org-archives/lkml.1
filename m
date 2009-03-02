Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZCBUcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZCBUcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZCBUac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34227 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302203024.566861575@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] tracing: add format file to describe event struct fields
Content-Disposition: inline; filename=0004-tracing-add-format-file-to-describe-event-struct-fi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds the "format" file to the trace point event directory.
This is based off of work by Tom Zanussi, in which a file is exported
to be tread from user land such that a user space app may read the
binary record stored in the ring buffer.

 # cat /debug/tracing/events/sched/sched_switch/format
        field:pid_t prev_pid;   offset:12;      size:4;
        field:int prev_prio;    offset:16;      size:4;
        field special:char next_comm[TASK_COMM_LEN];    offset:20;      size:16;
        field:pid_t next_pid;   offset:36;      size:4;
        field:int next_prio;    offset:40;      size:4;

Idea-from: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.h                |    1 +
 kernel/trace/trace_events.c         |   56 ++++++++++++++++++++++++++++++++++-
 kernel/trace/trace_events_stage_2.h |   52 ++++++++++++++++++++++++++++++++
 kernel/trace/trace_events_stage_3.h |    2 +
 4 files changed, 110 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cf6ba41..e606633 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -754,6 +754,7 @@ struct ftrace_event_call {
 	int		(*raw_init)(void);
 	int		(*raw_reg)(void);
 	void		(*raw_unreg)(void);
+	int		(*show_format)(struct trace_seq *s);
 };
 
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 26069fa..d57a772 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -3,6 +3,9 @@
  *
  * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
+ *  - Added format output of fields of the trace point.
+ *    This was based off of work by Tom Zanussi <tzanussi@gmail.com>.
+ *
  */
 
 #include <linux/debugfs.h>
@@ -444,6 +447,42 @@ event_available_types_read(struct file *filp, char __user *ubuf, size_t cnt,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
+static ssize_t
+event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
+		  loff_t *ppos)
+{
+	struct ftrace_event_call *call = filp->private_data;
+	struct trace_seq *s;
+	char *buf;
+	int r;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	trace_seq_init(s);
+
+	if (*ppos)
+		return 0;
+
+	r = call->show_format(s);
+	if (!r) {
+		/*
+		 * ug!  The format output is bigger than a PAGE!!
+		 */
+		buf = "FORMAT TOO BIG\n";
+		r = simple_read_from_buffer(ubuf, cnt, ppos,
+					      buf, strlen(buf));
+		goto out;
+	}
+
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, s->len);
+ out:
+	kfree(s);
+	return r;
+}
+
 static const struct seq_operations show_event_seq_ops = {
 	.start = t_start,
 	.next = t_next,
@@ -490,6 +529,11 @@ static const struct file_operations ftrace_available_types_fops = {
 	.read = event_available_types_read,
 };
 
+static const struct file_operations ftrace_event_format_fops = {
+	.open = tracing_open_generic,
+	.read = event_format_read,
+};
+
 static struct dentry *event_trace_events_dir(void)
 {
 	static struct dentry *d_tracer;
@@ -602,7 +646,17 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				    &ftrace_available_types_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
-			   "'%s/type' available_types\n", call->name);
+			   "'%s/available_types' entry\n", call->name);
+
+	/* A trace may not want to export its format */
+	if (!call->show_format)
+		return 0;
+
+	entry = debugfs_create_file("format", 0444, call->dir, call,
+				    &ftrace_event_format_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'%s/format' entry\n", call->name);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index dc79fe3..3a80ea4 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -74,3 +74,55 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 }
 
 #include <trace/trace_event_types.h>
+
+/*
+ * Setup the showing format of trace point.
+ *
+ * int
+ * ftrace_format_##call(struct trace_seq *s)
+ * {
+ * 	struct ftrace_raw_##call field;
+ * 	int ret;
+ *
+ * 	ret = trace_seq_printf(s, #type " " #item ";"
+ * 			       " size:%d; offset:%d;\n",
+ * 			       sizeof(field.type),
+ * 			       offsetof(struct ftrace_raw_##call,
+ * 					item));
+ *
+ * }
+ */
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%lu;\tsize:%lu;\n",		\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item));			\
+	if (!ret)							\
+		return 0;
+
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
+	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
+			       "offset:%lu;\tsize:%lu;\n",		\
+			       offsetof(typeof(field), item),		\
+			       sizeof(field.item));			\
+	if (!ret)							\
+		return 0;
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+int									\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct ftrace_raw_##call field;					\
+	int ret;							\
+									\
+	tstruct;							\
+									\
+	return ret;							\
+}
+
+#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 2ab65e9..c62a4d2 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -101,6 +101,7 @@
  * 	.raw_init		= ftrace_raw_init_event_<call>,
  * 	.raw_reg		= ftrace_raw_reg_event_<call>,
  * 	.raw_unreg		= ftrace_raw_unreg_event_<call>,
+ *	.show_format		= ftrace_format_<call>,
  * }
  *
  */
@@ -230,4 +231,5 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
 	.raw_reg		= ftrace_raw_reg_event_##call,		\
 	.raw_unreg		= ftrace_raw_unreg_event_##call,	\
+	.show_format		= ftrace_format_##call,			\
 }
-- 
1.5.6.5

-- 
