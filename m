Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZCJFAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZCJFAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZCJE6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:58:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42450 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZCJE6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:58:15 -0400
Message-Id: <20090310045811.279394388@goodmis.org>
References: <20090310045710.286915983@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 00:57:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] tracing: new format for specialized trace points
Content-Disposition: inline; filename=0004-tracing-new-format-for-specialized-trace-points.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up and enhancement

The TRACE_EVENT_FORMAT macro looks quite ugly and is limited in its
ability to save data as well as to print the record out. Working with
Ingo Molnar, we came up with a new format that is much more pleasing to
the eye of C developers. This new macro is more C style than the old
macro, and is more obvious to what it does.

Here's the example. The only updated macro in this patch is the
sched_switch trace point.

The old method looked like this:

 TRACE_EVENT_FORMAT(sched_switch,
        TP_PROTO(struct rq *rq, struct task_struct *prev,
                struct task_struct *next),
        TP_ARGS(rq, prev, next),
        TP_FMT("task %s:%d ==> %s:%d",
              prev->comm, prev->pid, next->comm, next->pid),
        TRACE_STRUCT(
                TRACE_FIELD(pid_t, prev_pid, prev->pid)
                TRACE_FIELD(int, prev_prio, prev->prio)
                TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
                                    next_comm,
                                    TP_CMD(memcpy(TRACE_ENTRY->next_comm,
                                                 next->comm,
                                                 TASK_COMM_LEN)))
                TRACE_FIELD(pid_t, next_pid, next->pid)
                TRACE_FIELD(int, next_prio, next->prio)
        ),
        TP_RAW_FMT("prev %d:%d ==> next %s:%d:%d")
        );

The above method is hard to read and requires two format fields.

The new method:

 /*
  * Tracepoint for task switches, performed by the scheduler:
  *
  * (NOTE: the 'rq' argument is not used by generic trace events,
  *        but used by the latency tracer plugin. )
  */
 TRACE_EVENT(sched_switch,

	TP_PROTO(struct rq *rq, struct task_struct *prev,
		 struct task_struct *next),

	TP_ARGS(rq, prev, next),

	TP_STRUCT__entry(
		__array(	char,	prev_comm,	TASK_COMM_LEN	)
		__field(	pid_t,	prev_pid			)
		__field(	int,	prev_prio			)
		__array(	char,	next_comm,	TASK_COMM_LEN	)
		__field(	pid_t,	next_pid			)
		__field(	int,	next_prio			)
	),

	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
		__entry->next_comm, __entry->next_pid, __entry->next_prio),

	TP_fast_assign(
		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
		__entry->prev_pid	= prev->pid;
		__entry->prev_prio	= prev->prio;
		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
		__entry->next_pid	= next->pid;
		__entry->next_prio	= next->prio;
	)
 );

This macro is called TRACE_EVENT, it is broken up into 5 parts:

 TP_PROTO:        the proto type of the trace point
 TP_ARGS:         the arguments of the trace point
 TP_STRUCT_entry: the structure layout of the entry in the ring buffer
 TP_printk:       the printk format
 TP_fast_assign:  the method used to write the entry into the ring buffer

The structure is the definition of how the event will be saved in the
ring buffer. The printk is used by the internal tracing in case of
an oops, and the kernel needs to print out the format of the record
to the console. This the TP_printk gives a means to show the records
in a human readable format. It is also used to print out the data
from the trace file.

The TP_fast_assign is executed directly. It is basically like a C function,
where the __entry is the handle to the record.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/tracepoint.h          |    3 +
 include/trace/sched_event_types.h   |   48 +++++++----
 kernel/trace/trace.h                |    5 -
 kernel/trace/trace_event_types.h    |    3 +-
 kernel/trace/trace_events.c         |  159 +----------------------------------
 kernel/trace/trace_events_stage_1.h |   28 ++++---
 kernel/trace/trace_events_stage_2.h |   89 ++++++++++++++++----
 kernel/trace/trace_events_stage_3.h |   34 ++-----
 kernel/trace/trace_export.c         |   23 +++++-
 9 files changed, 159 insertions(+), 233 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 3bcc3e1..6b4f1bb 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -160,4 +160,7 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_EVENT_FORMAT(name, proto, args, fmt, struct, tpfmt)	\
 	TRACE_FORMAT(name, PARAMS(proto), PARAMS(args), PARAMS(fmt))
 
+#define TRACE_EVENT(name, proto, args, struct, print, assign)	\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+
 #endif
diff --git a/include/trace/sched_event_types.h b/include/trace/sched_event_types.h
index 71b1482..aa77fb7 100644
--- a/include/trace/sched_event_types.h
+++ b/include/trace/sched_event_types.h
@@ -62,25 +62,41 @@ TRACE_EVENT_FORMAT(sched_wakeup_new,
 	TP_RAW_FMT("task %d success=%d")
 	);
 
-TRACE_EVENT_FORMAT(sched_switch,
+/*
+ * Tracepoint for task switches, performed by the scheduler:
+ *
+ * (NOTE: the 'rq' argument is not used by generic trace events,
+ *        but used by the latency tracer plugin. )
+ */
+TRACE_EVENT(sched_switch,
+
 	TP_PROTO(struct rq *rq, struct task_struct *prev,
-		struct task_struct *next),
+		 struct task_struct *next),
+
 	TP_ARGS(rq, prev, next),
-	TP_FMT("task %s:%d ==> %s:%d",
-	      prev->comm, prev->pid, next->comm, next->pid),
-	TRACE_STRUCT(
-		TRACE_FIELD(pid_t, prev_pid, prev->pid)
-		TRACE_FIELD(int, prev_prio, prev->prio)
-		TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
-				    next_comm,
-				    TP_CMD(memcpy(TRACE_ENTRY->next_comm,
-						 next->comm,
-						 TASK_COMM_LEN)))
-		TRACE_FIELD(pid_t, next_pid, next->pid)
-		TRACE_FIELD(int, next_prio, next->prio)
+
+	TP_STRUCT__entry(
+		__array(	char,	prev_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	prev_pid			)
+		__field(	int,	prev_prio			)
+		__array(	char,	next_comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	next_pid			)
+		__field(	int,	next_prio			)
 	),
-	TP_RAW_FMT("prev %d:%d ==> next %s:%d:%d")
-	);
+
+	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
+		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
+		__entry->next_comm, __entry->next_pid, __entry->next_prio),
+
+	TP_fast_assign(
+		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
+		__entry->prev_pid	= prev->pid;
+		__entry->prev_prio	= prev->prio;
+		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
+		__entry->next_pid	= next->pid;
+		__entry->next_prio	= next->prio;
+	)
+);
 
 TRACE_EVENT_FORMAT(sched_migrate_task,
 	TP_PROTO(struct task_struct *p, int orig_cpu, int dest_cpu),
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2bfb7d1..c5e1d88 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -751,12 +751,7 @@ struct ftrace_event_call {
 	int		(*regfunc)(void);
 	void		(*unregfunc)(void);
 	int		id;
-	struct dentry	*raw_dir;
-	int		raw_enabled;
-	int		type;
 	int		(*raw_init)(void);
-	int		(*raw_reg)(void);
-	void		(*raw_unreg)(void);
 	int		(*show_format)(struct trace_seq *s);
 };
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index d94179a..5cca4c9 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -106,9 +106,10 @@ TRACE_EVENT_FORMAT(print, TRACE_PRINT, print_entry, ignore,
 	TRACE_STRUCT(
 		TRACE_FIELD(unsigned long, ip, ip)
 		TRACE_FIELD(unsigned int, depth, depth)
+		TRACE_FIELD(char *, fmt, fmt)
 		TRACE_FIELD_ZERO_CHAR(buf)
 	),
-	TP_RAW_FMT("%08lx (%d) %s")
+	TP_RAW_FMT("%08lx (%d) fmt:%p %s")
 );
 
 TRACE_EVENT_FORMAT(branch, TRACE_BRANCH, trace_branch, ignore,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index fa32ca3..1880a64 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -59,22 +59,12 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 			call->enabled = 0;
 			call->unregfunc();
 		}
-		if (call->raw_enabled) {
-			call->raw_enabled = 0;
-			call->raw_unreg();
-		}
 		break;
 	case 1:
-		if (!call->enabled &&
-		    (call->type & TRACE_EVENT_TYPE_PRINTF)) {
+		if (!call->enabled) {
 			call->enabled = 1;
 			call->regfunc();
 		}
-		if (!call->raw_enabled &&
-		    (call->type & TRACE_EVENT_TYPE_RAW)) {
-			call->raw_enabled = 1;
-			call->raw_reg();
-		}
 		break;
 	}
 }
@@ -300,7 +290,7 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 	struct ftrace_event_call *call = filp->private_data;
 	char *buf;
 
-	if (call->enabled || call->raw_enabled)
+	if (call->enabled)
 		buf = "1\n";
 	else
 		buf = "0\n";
@@ -346,107 +336,6 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	return cnt;
 }
 
-static ssize_t
-event_type_read(struct file *filp, char __user *ubuf, size_t cnt,
-		loff_t *ppos)
-{
-	struct ftrace_event_call *call = filp->private_data;
-	char buf[16];
-	int r = 0;
-
-	if (call->type & TRACE_EVENT_TYPE_PRINTF)
-		r += sprintf(buf, "printf\n");
-
-	if (call->type & TRACE_EVENT_TYPE_RAW)
-		r += sprintf(buf+r, "raw\n");
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-event_type_write(struct file *filp, const char __user *ubuf, size_t cnt,
-		 loff_t *ppos)
-{
-	struct ftrace_event_call *call = filp->private_data;
-	char buf[64];
-
-	/*
-	 * If there's only one type, we can't change it.
-	 * And currently we always have printf type, and we
-	 * may or may not have raw type.
-	 *
-	 * This is a redundant check, the file should be read
-	 * only if this is the case anyway.
-	 */
-
-	if (!call->raw_init)
-		return -EPERM;
-
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	if (!strncmp(buf, "printf", 6) &&
-	    (!buf[6] || isspace(buf[6]))) {
-
-		call->type = TRACE_EVENT_TYPE_PRINTF;
-
-		/*
-		 * If raw enabled, the disable it and enable
-		 * printf type.
-		 */
-		if (call->raw_enabled) {
-			call->raw_enabled = 0;
-			call->raw_unreg();
-
-			call->enabled = 1;
-			call->regfunc();
-		}
-
-	} else if (!strncmp(buf, "raw", 3) &&
-	    (!buf[3] || isspace(buf[3]))) {
-
-		call->type = TRACE_EVENT_TYPE_RAW;
-
-		/*
-		 * If printf enabled, the disable it and enable
-		 * raw type.
-		 */
-		if (call->enabled) {
-			call->enabled = 0;
-			call->unregfunc();
-
-			call->raw_enabled = 1;
-			call->raw_reg();
-		}
-	} else
-		return -EINVAL;
-
-	*ppos += cnt;
-
-	return cnt;
-}
-
-static ssize_t
-event_available_types_read(struct file *filp, char __user *ubuf, size_t cnt,
-			   loff_t *ppos)
-{
-	struct ftrace_event_call *call = filp->private_data;
-	char buf[16];
-	int r = 0;
-
-	r += sprintf(buf, "printf\n");
-
-	if (call->raw_init)
-		r += sprintf(buf+r, "raw\n");
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
 #undef FIELD
 #define FIELD(type, name)						\
 	#type, #name, (unsigned int)offsetof(typeof(field), name),	\
@@ -470,6 +359,7 @@ static int trace_write_header(struct trace_seq *s)
 				FIELD(int, pid),
 				FIELD(int, tgid));
 }
+
 static ssize_t
 event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
@@ -527,13 +417,6 @@ static const struct seq_operations show_set_event_seq_ops = {
 	.stop = t_stop,
 };
 
-static const struct file_operations ftrace_avail_fops = {
-	.open = ftrace_event_seq_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = seq_release,
-};
-
 static const struct file_operations ftrace_set_event_fops = {
 	.open = ftrace_event_seq_open,
 	.read = seq_read,
@@ -548,17 +431,6 @@ static const struct file_operations ftrace_enable_fops = {
 	.write = event_enable_write,
 };
 
-static const struct file_operations ftrace_type_fops = {
-	.open = tracing_open_generic,
-	.read = event_type_read,
-	.write = event_type_write,
-};
-
-static const struct file_operations ftrace_available_types_fops = {
-	.open = tracing_open_generic,
-	.read = event_available_types_read,
-};
-
 static const struct file_operations ftrace_event_format_fops = {
 	.open = tracing_open_generic,
 	.read = event_format_read,
@@ -647,9 +519,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 		}
 	}
 
-	/* default the output to printf */
-	call->type = TRACE_EVENT_TYPE_PRINTF;
-
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
 		pr_warning("Could not create debugfs "
@@ -665,21 +534,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				   "'%s/enable' entry\n", call->name);
 	}
 
-	/* Only let type be writable, if we can change it */
-	entry = debugfs_create_file("type",
-				    call->raw_init ? 0644 : 0444,
-				    call->dir, call,
-				    &ftrace_type_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/type' entry\n", call->name);
-
-	entry = debugfs_create_file("available_types", 0444, call->dir, call,
-				    &ftrace_available_types_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'%s/available_types' entry\n", call->name);
-
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
@@ -704,13 +558,6 @@ static __init int event_trace_init(void)
 	if (!d_tracer)
 		return 0;
 
-	entry = debugfs_create_file("available_events", 0444, d_tracer,
-				    (void *)&show_event_seq_ops,
-				    &ftrace_avail_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'available_events' entry\n");
-
 	entry = debugfs_create_file("set_event", 0644, d_tracer,
 				    (void *)&show_set_event_seq_ops,
 				    &ftrace_set_event_fops);
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
index 3830a73..edfcbd3 100644
--- a/kernel/trace/trace_events_stage_1.h
+++ b/kernel/trace/trace_events_stage_1.h
@@ -18,19 +18,23 @@
 #define TRACE_FORMAT(call, proto, args, fmt)
 
 #undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(name, proto, args, fmt, tstruct, tpfmt)	\
-	struct ftrace_raw_##name {					\
-		struct trace_entry	ent;				\
-		tstruct							\
-	};								\
-	static struct ftrace_event_call event_##name
+#define TRACE_EVENT_FORMAT(name, proto, args, fmt, tstruct, tpfmt)
+
+#undef __array
+#define __array(type, item, len)	type	item[len];
 
-#undef TRACE_STRUCT
-#define TRACE_STRUCT(args...) args
+#undef __field
+#define __field(type, item)		type	item;
 
-#define TRACE_FIELD(type, item, assign) \
-	type item;
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
-	type_item;
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, args, tstruct, print, assign)	\
+	struct ftrace_raw_##name {				\
+		struct trace_entry	ent;			\
+		tstruct						\
+	};							\
+	static struct ftrace_event_call event_##name
 
 #include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 8e2e0f5..d91bf4c 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -32,23 +32,14 @@
  * in binary.
  */
 
-#undef TRACE_STRUCT
-#define TRACE_STRUCT(args...) args
+#undef __entry
+#define __entry field
 
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign) \
-	field->item,
+#undef TP_printk
+#define TP_printk(fmt, args...) fmt "\n", args
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
-	field->item,
-
-
-#undef TP_RAW_FMT
-#define TP_RAW_FMT(args...)	args
-
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, print, assign)		\
 enum print_line_t							\
 ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 {									\
@@ -66,14 +57,76 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	field = (typeof(field))entry;					\
 									\
-	ret = trace_seq_printf(s, tpfmt "%s", tstruct "\n");		\
+	ret = trace_seq_printf(s, print);				\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
 	return TRACE_TYPE_HANDLED;					\
 }
-
+	
 #include <trace/trace_event_types.h>
 
-#include "trace_format.h"
+/*
+ * Setup the showing format of trace point.
+ *
+ * int
+ * ftrace_format_##call(struct trace_seq *s)
+ * {
+ *	struct ftrace_raw_##call field;
+ *	int ret;
+ *
+ *	ret = trace_seq_printf(s, #type " " #item ";"
+ *			       " size:%d; offset:%d;\n",
+ *			       sizeof(field.type),
+ *			       offsetof(struct ftrace_raw_##call,
+ *					item));
+ *
+ * }
+ */
+
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+
+#undef __field
+#define __field(type, item)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+#undef __array
+#define __array(type, item, len)						\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+#undef __entry
+#define __entry "REC"
+
+#undef TP_printk
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, #args
+
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, print, func)		\
+static int								\
+ftrace_format_##call(struct trace_seq *s)				\
+{									\
+	struct ftrace_raw_##call field;					\
+	int ret;							\
+									\
+	tstruct;							\
+									\
+	trace_seq_printf(s, "\nprint fmt: " print);			\
+									\
+	return ret;							\
+}
+
 #include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 41b82b9..8e398d8 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -144,27 +144,15 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
 }
 
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)\
-	entry->item = assign;
-
-#undef TRACE_FIELD
-#define TRACE_FIELD(type, item, assign)\
-	entry->item = assign;
-
-#undef TP_CMD
-#define TP_CMD(cmd...)	cmd
-
-#undef TRACE_ENTRY
-#define TRACE_ENTRY	entry
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, raw)	\
+	TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))
 
-#undef TRACE_FIELD_SPECIAL
-#define TRACE_FIELD_SPECIAL(type_item, item, cmd) \
-	cmd;
+#undef __entry
+#define __entry entry
 
-#undef TRACE_EVENT_FORMAT
-#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, print, assign)		\
 									\
 static struct ftrace_event_call event_##call;				\
 									\
@@ -185,7 +173,7 @@ static void ftrace_raw_event_##call(proto)				\
 		return;							\
 	entry	= ring_buffer_event_data(event);			\
 									\
-	tstruct;							\
+	assign;								\
 									\
 	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
 }									\
@@ -226,10 +214,8 @@ __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name 			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
-	.regfunc		= ftrace_reg_event_##call,		\
-	.unregfunc		= ftrace_unreg_event_##call,		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
-	.raw_reg		= ftrace_raw_reg_event_##call,		\
-	.raw_unreg		= ftrace_raw_unreg_event_##call,	\
+	.regfunc		= ftrace_raw_reg_event_##call,		\
+	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
 }
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index e62bc10..23ae784 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -15,7 +15,28 @@
 
 #include "trace_output.h"
 
-#include "trace_format.h"
+
+#undef TRACE_STRUCT
+#define TRACE_STRUCT(args...) args
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)					\
+	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
+
+
+#undef TRACE_FIELD_SPECIAL
+#define TRACE_FIELD_SPECIAL(type_item, item, cmd)			\
+	ret = trace_seq_printf(s, "\tfield special:" #type_item ";\t"	\
+			       "offset:%u;\tsize:%u;\n",		\
+			       (unsigned int)offsetof(typeof(field), item), \
+			       (unsigned int)sizeof(field.item));	\
+	if (!ret)							\
+		return 0;
 
 #undef TRACE_FIELD_ZERO_CHAR
 #define TRACE_FIELD_ZERO_CHAR(item)					\
-- 
1.6.1.3

-- 
