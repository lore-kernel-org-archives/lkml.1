Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZB1JNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZB1JNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbZB1JJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbZB1JJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:41 -0500
Message-Id: <20090228090938.203450528@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/10] tracing: add raw trace point recording infrastructure
Content-Disposition: inline; filename=0007-tracing-add-raw-trace-point-recording-infrastructur.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: lower overhead tracing

The current event tracer can automatically pick up trace points
that are registered with the TRACE_FORMAT macro. But it required
a printf format string and parsing. Although, this adds the ability
to get guaranteed information like task names and such, it took
a hit in overhead processing. This processing can add about 500-1000
nanoseconds overhead, but in some cases that too is considered
too much and we want to shave off as much from this overhead as
possible.

Tom Zanussi recently posted tracing patches to lkml that are based
on a nice idea about capturing the data via C structs using
STRUCT_ENTER, STRUCT_EXIT type of macros.

I liked that method very much, but did not like the implementation
that required a developer to add data/code in several disjoint
locations.

This patch extends the event_tracer macros to do a similar "raw C"
approach that Tom Zanussi did. But instead of having the developers
needing to tweak a bunch of code all over the place, they can do it
all in one macro - preferably placed near the code that it is
tracing. That makes it much more likely that tracepoints will be
maintained on an ongoing basis by the code they modify.

The new macro TRACE_EVENT_FORMAT is created for this approach. (Note,
a developer may still utilize the more low level DECLARE_TRACE macros
if they don't care about getting their traces automatically in the event
tracer.)

They can also use the existing TRACE_FORMAT if they don't need to code
the tracepoint in C, but just want to use the convenience of printf.

So if the developer wants to "hardwire" a tracepoint in the fastest
possible way, and wants to acquire their data via a user space utility
in a raw binary format, or wants to see it in the trace output but not
sacrifice any performance, then they can implement the faster but
more complex TRACE_EVENT_FORMAT macro.

Here's what usage looks like:

  TRACE_EVENT_FORMAT(name,
	TPPROTO(proto),
	TPARGS(args),
	TPFMT(fmt, fmt_args),
	TRACE_STUCT(
		TRACE_FIELD(type1, item1, assign1)
		TRACE_FIELD(type2, item2, assign2)
			[...]
	),
	TPRAWFMT(raw_fmt)
	);

Note name, proto, args, and fmt, are all identical to what TRACE_FORMAT
uses.

 name: is the unique identifier of the trace point
 proto: The proto type that the trace point uses
 args: the args in the proto type
 fmt: printf format to use with the event printf tracer
 fmt_args: the printf argments to match fmt

 TRACE_STRUCT starts the ability to create a structure.
 Each item in the structure is defined with a TRACE_FIELD

  TRACE_FIELD(type, item, assign)

 type: the C type of item.
 item: the name of the item in the stucture
 assign: what to assign the item in the trace point callback

 raw_fmt is a way to pretty print the struct. It must match
  the order of the items are added in TRACE_STUCT

 An example of this would be:

 TRACE_EVENT_FORMAT(sched_wakeup,
	TPPROTO(struct rq *rq, struct task_struct *p, int success),
	TPARGS(rq, p, success),
	TPFMT("task %s:%d %s",
	      p->comm, p->pid, success?"succeeded":"failed"),
	TRACE_STRUCT(
		TRACE_FIELD(pid_t, pid, p->pid)
		TRACE_FIELD(int, success, success)
	),
	TPRAWFMT("task %d success=%d")
	);

 This creates us a unique struct of:

 struct {
	pid_t		pid;
	int		success;
 };

 And the way the call back would assign these values would be:

	entry->pid = p->pid;
	entry->success = success;

The nice part about this is that the creation of the assignent is done
via macro magic in the event tracer.  Once the TRACE_EVENT_FORMAT is
created, the developer will then have a faster method to record
into the ring buffer. They do not need to worry about the tracer itself.

The developer would only need to touch the files in include/trace/*.h

Again, I would like to give special thanks to Tom Zanussi for this
nice idea.

Idea-from: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/events.c               |    6 +-
 kernel/trace/trace.h                |   19 +++
 kernel/trace/trace_events.c         |    2 +-
 kernel/trace/trace_events.h         |   57 ---------
 kernel/trace/trace_events_stage_1.h |   34 ++++++
 kernel/trace/trace_events_stage_2.h |   72 ++++++++++++
 kernel/trace/trace_events_stage_3.h |  219 +++++++++++++++++++++++++++++++++++
 7 files changed, 350 insertions(+), 59 deletions(-)
 delete mode 100644 kernel/trace/trace_events.h
 create mode 100644 kernel/trace/trace_events_stage_1.h
 create mode 100644 kernel/trace/trace_events_stage_2.h
 create mode 100644 kernel/trace/trace_events_stage_3.h

diff --git a/kernel/trace/events.c b/kernel/trace/events.c
index 4e4e458..f2509cb 100644
--- a/kernel/trace/events.c
+++ b/kernel/trace/events.c
@@ -8,6 +8,10 @@
 
 #include <trace/trace_events.h>
 
-#include "trace_events.h"
+#include "trace_output.h"
+
+#include "trace_events_stage_1.h"
+#include "trace_events_stage_2.h"
+#include "trace_events_stage_3.h"
 
 #include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index adf161f..aa1ab0c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -726,4 +726,23 @@ static inline void trace_branch_disable(void)
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
+struct ftrace_event_call {
+	char		*name;
+	char		*system;
+	struct dentry	*dir;
+	int		enabled;
+	int		(*regfunc)(void);
+	void		(*unregfunc)(void);
+	int		id;
+	struct dentry	*raw_dir;
+	int		raw_enabled;
+	int		(*raw_init)(void);
+	int		(*raw_reg)(void);
+	void		(*raw_unreg)(void);
+};
+
+void event_trace_printk(unsigned long ip, const char *fmt, ...);
+extern struct ftrace_event_call __start_ftrace_events[];
+extern struct ftrace_event_call __stop_ftrace_events[];
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b811eb3..77a5c02 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -10,7 +10,7 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 
-#include "trace_events.h"
+#include "trace.h"
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
diff --git a/kernel/trace/trace_events.h b/kernel/trace/trace_events.h
deleted file mode 100644
index b015d7b..0000000
--- a/kernel/trace/trace_events.h
+++ /dev/null
@@ -1,57 +0,0 @@
-#ifndef _LINUX_KERNEL_TRACE_EVENTS_H
-#define _LINUX_KERNEL_TRACE_EVENTS_H
-
-#include <linux/debugfs.h>
-#include <linux/ftrace.h>
-#include "trace.h"
-
-struct ftrace_event_call {
-	char		*name;
-	char		*system;
-	struct dentry	*dir;
-	int		enabled;
-	int		(*regfunc)(void);
-	void		(*unregfunc)(void);
-};
-
-
-#undef TPFMT
-#define TPFMT(fmt, args...)	fmt "\n", ##args
-
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)				\
-static void ftrace_event_##call(proto)					\
-{									\
-	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
-}									\
-									\
-static int ftrace_reg_event_##call(void)				\
-{									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_event_##call);		\
-	if (!ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call);				\
-	return ret;							\
-}									\
-									\
-static void ftrace_unreg_event_##call(void)				\
-{									\
-	unregister_trace_##call(ftrace_event_##call);			\
-}									\
-									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name 			= #call,				\
-	.system			= STR(TRACE_SYSTEM),			\
-	.regfunc		= ftrace_reg_event_##call,		\
-	.unregfunc		= ftrace_unreg_event_##call,		\
-}
-
-void event_trace_printk(unsigned long ip, const char *fmt, ...);
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
-
-#endif /* _LINUX_KERNEL_TRACE_EVENTS_H */
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
new file mode 100644
index 0000000..fd3bf93
--- /dev/null
+++ b/kernel/trace/trace_events_stage_1.h
@@ -0,0 +1,34 @@
+/*
+ * Stage 1 of the trace events.
+ *
+ * Override the macros in <trace/trace_event_types.h> to include the following:
+ *
+ * struct ftrace_raw_<call> {
+ *	struct trace_entry		ent;
+ *	<type>				<item>;
+ *	[...]
+ * };
+ *
+ * The <type> <item> is created by the TRACE_FIELD(type, item, assign)
+ * macro. We simply do "type item;", and that will create the fields
+ * in the structure.
+ */
+
+#undef TRACE_FORMAT
+#define TRACE_FORMAT(call, proto, args, fmt)
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(name, proto, args, fmt, tstruct, tpfmt)	\
+	struct ftrace_raw_##name {					\
+		struct trace_entry	ent;				\
+		tstruct							\
+	};								\
+	static struct ftrace_event_call event_##name
+
+#undef TRACE_STRUCT
+#define TRACE_STRUCT(args...) args
+
+#define TRACE_FIELD(type, item, assign) \
+	type item;
+
+#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
new file mode 100644
index 0000000..3eaaef5
--- /dev/null
+++ b/kernel/trace/trace_events_stage_2.h
@@ -0,0 +1,72 @@
+/*
+ * Stage 2 of the trace events.
+ *
+ * Override the macros in <trace/trace_event_types.h> to include the following:
+ *
+ * enum print_line_t
+ * ftrace_raw_output_<call>(struct trace_iterator *iter, int flags)
+ * {
+ *	struct trace_seq *s = &iter->seq;
+ *	struct ftrace_raw_<call> *field; <-- defined in stage 1
+ *	struct trace_entry *entry;
+ *	int ret;
+ *
+ *	entry = iter->ent;
+ *
+ *	if (entry->type != event_<call>.id) {
+ *		WARN_ON_ONCE(1);
+ *		return TRACE_TYPE_UNHANDLED;
+ *	}
+ *
+ *	field = (typeof(field))entry;
+ *
+ *	ret = trace_seq_printf(s, <TPRAWFMT> "%s", <ARGS> "\n");
+ *	if (!ret)
+ *		return TRACE_TYPE_PARTIAL_LINE;
+ *
+ *	return TRACE_TYPE_HANDLED;
+ * }
+ *
+ * This is the method used to print the raw event to the trace
+ * output format. Note, this is not needed if the data is read
+ * in binary.
+ */
+
+#undef TRACE_STRUCT
+#define TRACE_STRUCT(args...) args
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign) \
+	field->item,
+
+
+#undef TPRAWFMT
+#define TPRAWFMT(args...)	args
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+enum print_line_t							\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
+{									\
+	struct trace_seq *s = &iter->seq;				\
+	struct ftrace_raw_##call *field;				\
+	struct trace_entry *entry;					\
+	int ret;							\
+									\
+	entry = iter->ent;						\
+									\
+	if (entry->type != event_##call.id) {				\
+		WARN_ON_ONCE(1);					\
+		return TRACE_TYPE_UNHANDLED;				\
+	}								\
+									\
+	field = (typeof(field))entry;					\
+									\
+	ret = trace_seq_printf(s, tpfmt "%s", tstruct "\n");		\
+	if (!ret)							\
+		return TRACE_TYPE_PARTIAL_LINE;				\
+									\
+	return TRACE_TYPE_HANDLED;					\
+}
+
+#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
new file mode 100644
index 0000000..7a161c4
--- /dev/null
+++ b/kernel/trace/trace_events_stage_3.h
@@ -0,0 +1,219 @@
+/*
+ * Stage 3 of the trace events.
+ *
+ * Override the macros in <trace/trace_event_types.h> to include the following:
+ *
+ * static void ftrace_event_<call>(proto)
+ * {
+ * 	event_trace_printk(_RET_IP_, "(<call>) " <fmt>);
+ * }
+ *
+ * static int ftrace_reg_event_<call>(void)
+ * {
+ * 	int ret;
+ *
+ * 	ret = register_trace_<call>(ftrace_event_<call>);
+ * 	if (!ret)
+ * 		pr_info("event trace: Could not activate trace point "
+ * 			"probe to  <call>");
+ * 	return ret;
+ * }
+ *
+ * static void ftrace_unreg_event_<call>(void)
+ * {
+ * 	unregister_trace_<call>(ftrace_event_<call>);
+ * }
+ *
+ * For those macros defined with TRACE_FORMAT:
+ *
+ * static struct ftrace_event_call __used
+ * __attribute__((__aligned__(4)))
+ * __attribute__((section("_ftrace_events"))) event_<call> = {
+ * 	.name 			= "<call>",
+ * 	.regfunc		= ftrace_reg_event_<call>,
+ * 	.unregfunc		= ftrace_unreg_event_<call>,
+ * }
+ *
+ *
+ * For those macros defined with TRACE_EVENT_FORMAT:
+ *
+ * static struct ftrace_event_call event_<call>;
+ *
+ * static void ftrace_raw_event_<call>(proto)
+ * {
+ * 	struct ring_buffer_event *event;
+ * 	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ * 	unsigned long irq_flags;
+ * 	int pc;
+ *
+ * 	local_save_flags(irq_flags);
+ * 	pc = preempt_count();
+ *
+ * 	event = trace_current_buffer_lock_reserve(event_<call>.id,
+ * 				  sizeof(struct ftrace_raw_<call>),
+ * 				  irq_flags, pc);
+ * 	if (!event)
+ * 		return;
+ * 	entry	= ring_buffer_event_data(event);
+ *
+ * 	<tstruct>;  <-- Here we assign the entries by the TRACE_FIELD.
+ *
+ * 	trace_current_buffer_unlock_commit(event, irq_flags, pc);
+ * }
+ *
+ * static int ftrace_raw_reg_event_<call>(void)
+ * {
+ * 	int ret;
+ *
+ * 	ret = register_trace_<call>(ftrace_raw_event_<call>);
+ * 	if (!ret)
+ * 		pr_info("event trace: Could not activate trace point "
+ * 			"probe to <call>");
+ * 	return ret;
+ * }
+ *
+ * static void ftrace_unreg_event_<call>(void)
+ * {
+ * 	unregister_trace_<call>(ftrace_raw_event_<call>);
+ * }
+ *
+ * static struct trace_event ftrace_event_type_<call> = {
+ * 	.trace			= ftrace_raw_output_<call>, <-- stage 2
+ * };
+ *
+ * static int ftrace_raw_init_event_<call>(void)
+ * {
+ * 	int id;
+ *
+ * 	id = register_ftrace_event(&ftrace_event_type_<call>);
+ * 	if (!id)
+ * 		return -ENODEV;
+ * 	event_<call>.id = id;
+ * 	return 0;
+ * }
+ *
+ * static struct ftrace_event_call __used
+ * __attribute__((__aligned__(4)))
+ * __attribute__((section("_ftrace_events"))) event_<call> = {
+ * 	.name 			= "<call>",
+ * 	.regfunc		= ftrace_reg_event_<call>,
+ * 	.unregfunc		= ftrace_unreg_event_<call>,
+ * 	.raw_init		= ftrace_raw_init_event_<call>,
+ * 	.raw_reg		= ftrace_raw_reg_event_<call>,
+ * 	.raw_unreg		= ftrace_raw_unreg_event_<call>,
+ * }
+ *
+ */
+
+#undef TPFMT
+#define TPFMT(fmt, args...)	fmt "\n", ##args
+
+#define _TRACE_FORMAT(call, proto, args, fmt)				\
+static void ftrace_event_##call(proto)					\
+{									\
+	event_trace_printk(_RET_IP_, "(" #call ") " fmt);		\
+}									\
+									\
+static int ftrace_reg_event_##call(void)				\
+{									\
+	int ret;							\
+									\
+	ret = register_trace_##call(ftrace_event_##call);		\
+	if (!ret)							\
+		pr_info("event trace: Could not activate trace point "	\
+			"probe to " #call);				\
+	return ret;							\
+}									\
+									\
+static void ftrace_unreg_event_##call(void)				\
+{									\
+	unregister_trace_##call(ftrace_event_##call);			\
+}									\
+
+
+#undef TRACE_FORMAT
+#define TRACE_FORMAT(call, proto, args, fmt)				\
+_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name 			= #call,				\
+	.system			= STR(TRACE_SYSTEM),			\
+	.regfunc		= ftrace_reg_event_##call,		\
+	.unregfunc		= ftrace_unreg_event_##call,		\
+}
+
+#undef TRACE_FIELD
+#define TRACE_FIELD(type, item, assign)\
+	entry->item = assign;
+
+#undef TRACE_EVENT_FORMAT
+#define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
+_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
+									\
+static struct ftrace_event_call event_##call;				\
+									\
+static void ftrace_raw_event_##call(proto)				\
+{									\
+	struct ring_buffer_event *event;				\
+	struct ftrace_raw_##call *entry;				\
+	unsigned long irq_flags;					\
+	int pc;								\
+									\
+	local_save_flags(irq_flags);					\
+	pc = preempt_count();						\
+									\
+	event = trace_current_buffer_lock_reserve(event_##call.id,	\
+				  sizeof(struct ftrace_raw_##call), 	\
+				  irq_flags, pc);			\
+	if (!event)							\
+		return;							\
+	entry	= ring_buffer_event_data(event);			\
+									\
+	tstruct;							\
+									\
+	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
+}									\
+									\
+static int ftrace_raw_reg_event_##call(void)				\
+{									\
+	int ret;							\
+									\
+	ret = register_trace_##call(ftrace_raw_event_##call);		\
+	if (!ret)							\
+		pr_info("event trace: Could not activate trace point "	\
+			"probe to " #call);				\
+	return ret;							\
+}									\
+									\
+static void ftrace_raw_unreg_event_##call(void)				\
+{									\
+	unregister_trace_##call(ftrace_raw_event_##call);		\
+}									\
+									\
+static struct trace_event ftrace_event_type_##call = {			\
+	.trace			= ftrace_raw_output_##call,		\
+};									\
+									\
+static int ftrace_raw_init_event_##call(void)				\
+{									\
+	int id;								\
+									\
+	id = register_ftrace_event(&ftrace_event_type_##call);		\
+	if (!id)							\
+		return -ENODEV;						\
+	event_##call.id = id;						\
+	return 0;							\
+}									\
+									\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name 			= #call,				\
+	.system			= STR(TRACE_SYSTEM),			\
+	.regfunc		= ftrace_reg_event_##call,		\
+	.unregfunc		= ftrace_unreg_event_##call,		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_reg		= ftrace_raw_reg_event_##call,		\
+	.raw_unreg		= ftrace_raw_unreg_event_##call,	\
+}
-- 
1.5.6.5

-- 
