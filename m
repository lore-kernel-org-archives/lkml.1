Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZDNR25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZDNR25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZDNR0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:26:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZDNR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:26:45 -0400
Message-Id: <20090414172641.457760734@goodmis.org>
References: <20090414172337.280621613@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 13:23:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: [PATCH 5/8] tracing/events: move the ftrace event tracing code to core
Content-Disposition: inline; filename=0005-tracing-events-move-the-ftrace-event-tracing-code-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch moves the ftrace creation into include/trace/ftrace.h and
simplifies the work of developers in adding new tracepoints.
Just the act of creating the trace points in include/trace and including
define_trace.h will create the events in the debugfs/tracing/events
directory.

This patch removes the need of include/trace/trace_events.h

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/define_trace.h        |    4 +
 include/trace/ftrace.h              |  492 +++++++++++++++++++++++++++++++++++
 include/trace/trace_events.h        |    7 -
 kernel/trace/Makefile               |    1 -
 kernel/trace/events.c               |   15 -
 kernel/trace/trace_events_stage_1.h |   39 ---
 kernel/trace/trace_events_stage_2.h |  170 ------------
 kernel/trace/trace_events_stage_3.h |  279 --------------------
 8 files changed, 496 insertions(+), 511 deletions(-)
 create mode 100644 include/trace/ftrace.h
 delete mode 100644 include/trace/trace_events.h
 delete mode 100644 kernel/trace/events.c
 delete mode 100644 kernel/trace/trace_events_stage_1.h
 delete mode 100644 kernel/trace/trace_events_stage_2.h
 delete mode 100644 kernel/trace/trace_events_stage_3.h

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index de9dc7d..980eb66 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -56,6 +56,10 @@
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#ifdef CONFIG_EVENT_TRACER
+#include <trace/ftrace.h>
+#endif
+
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
new file mode 100644
index 0000000..955b967
--- /dev/null
+++ b/include/trace/ftrace.h
@@ -0,0 +1,492 @@
+/*
+ * Stage 1 of the trace events.
+ *
+ * Override the macros in <trace/trace_events.h> to include the following:
+ *
+ * struct ftrace_raw_<call> {
+ *	struct trace_entry		ent;
+ *	<type>				<item>;
+ *	<type2>				<item2>[<len>];
+ *	[...]
+ * };
+ *
+ * The <type> <item> is created by the __field(type, item) macro or
+ * the __array(type2, item2, len) macro.
+ * We simply do "type item;", and that will create the fields
+ * in the structure.
+ */
+
+#include <linux/ftrace_event.h>
+
+#undef TRACE_FORMAT
+#define TRACE_FORMAT(call, proto, args, fmt)
+
+#undef __array
+#define __array(type, item, len)	type	item[len];
+
+#undef __field
+#define __field(type, item)		type	item;
+
+#undef TP_STRUCT__entry
+#define TP_STRUCT__entry(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
+	struct ftrace_raw_##name {				\
+		struct trace_entry	ent;			\
+		tstruct						\
+	};							\
+	static struct ftrace_event_call event_##name
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
+ * Stage 2 of the trace events.
+ *
+ * Override the macros in <trace/trace_events.h> to include the following:
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
+ *	ret = trace_seq_printf(s, <TP_printk> "\n");
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
+#undef __entry
+#define __entry field
+
+#undef TP_printk
+#define TP_printk(fmt, args...) fmt "\n", args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
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
+	ret = trace_seq_printf(s, #call ": " print);			\
+	if (!ret)							\
+		return TRACE_TYPE_PARTIAL_LINE;				\
+									\
+	return TRACE_TYPE_HANDLED;					\
+}
+	
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
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
+ *			       " offset:%u; size:%u;\n",
+ *			       offsetof(struct ftrace_raw_##call, item),
+ *			       sizeof(field.type));
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
+#define __entry REC
+
+#undef TP_printk
+#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
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
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#undef __field
+#define __field(type, item)						\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item));			\
+	if (ret)							\
+		return ret;
+
+#undef __array
+#define __array(type, item, len)					\
+	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item));			\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+int									\
+ftrace_define_fields_##call(void)					\
+{									\
+	struct ftrace_raw_##call field;					\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	int ret;							\
+									\
+	__common_field(unsigned char, type);				\
+	__common_field(unsigned char, flags);				\
+	__common_field(unsigned char, preempt_count);			\
+	__common_field(int, pid);					\
+	__common_field(int, tgid);					\
+									\
+	tstruct;							\
+									\
+	return ret;							\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+/*
+ * Stage 3 of the trace events.
+ *
+ * Override the macros in <trace/trace_events.h> to include the following:
+ *
+ * static void ftrace_event_<call>(proto)
+ * {
+ *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
+ * }
+ *
+ * static int ftrace_reg_event_<call>(void)
+ * {
+ *	int ret;
+ *
+ *	ret = register_trace_<call>(ftrace_event_<call>);
+ *	if (!ret)
+ *		pr_info("event trace: Could not activate trace point "
+ *			"probe to  <call>");
+ *	return ret;
+ * }
+ *
+ * static void ftrace_unreg_event_<call>(void)
+ * {
+ *	unregister_trace_<call>(ftrace_event_<call>);
+ * }
+ *
+ * For those macros defined with TRACE_FORMAT:
+ *
+ * static struct ftrace_event_call __used
+ * __attribute__((__aligned__(4)))
+ * __attribute__((section("_ftrace_events"))) event_<call> = {
+ *	.name			= "<call>",
+ *	.regfunc		= ftrace_reg_event_<call>,
+ *	.unregfunc		= ftrace_unreg_event_<call>,
+ * }
+ *
+ *
+ * For those macros defined with TRACE_EVENT:
+ *
+ * static struct ftrace_event_call event_<call>;
+ *
+ * static void ftrace_raw_event_<call>(proto)
+ * {
+ *	struct ring_buffer_event *event;
+ *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
+ *	unsigned long irq_flags;
+ *	int pc;
+ *
+ *	local_save_flags(irq_flags);
+ *	pc = preempt_count();
+ *
+ *	event = trace_current_buffer_lock_reserve(event_<call>.id,
+ *				  sizeof(struct ftrace_raw_<call>),
+ *				  irq_flags, pc);
+ *	if (!event)
+ *		return;
+ *	entry	= ring_buffer_event_data(event);
+ *
+ *	<assign>;  <-- Here we assign the entries by the __field and
+ *			__array macros.
+ *
+ *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
+ * }
+ *
+ * static int ftrace_raw_reg_event_<call>(void)
+ * {
+ *	int ret;
+ *
+ *	ret = register_trace_<call>(ftrace_raw_event_<call>);
+ *	if (!ret)
+ *		pr_info("event trace: Could not activate trace point "
+ *			"probe to <call>");
+ *	return ret;
+ * }
+ *
+ * static void ftrace_unreg_event_<call>(void)
+ * {
+ *	unregister_trace_<call>(ftrace_raw_event_<call>);
+ * }
+ *
+ * static struct trace_event ftrace_event_type_<call> = {
+ *	.trace			= ftrace_raw_output_<call>, <-- stage 2
+ * };
+ *
+ * static int ftrace_raw_init_event_<call>(void)
+ * {
+ *	int id;
+ *
+ *	id = register_ftrace_event(&ftrace_event_type_<call>);
+ *	if (!id)
+ *		return -ENODEV;
+ *	event_<call>.id = id;
+ *	return 0;
+ * }
+ *
+ * static struct ftrace_event_call __used
+ * __attribute__((__aligned__(4)))
+ * __attribute__((section("_ftrace_events"))) event_<call> = {
+ *	.name			= "<call>",
+ *	.system			= "<system>",
+ *	.raw_init		= ftrace_raw_init_event_<call>,
+ *	.regfunc		= ftrace_reg_event_<call>,
+ *	.unregfunc		= ftrace_unreg_event_<call>,
+ *	.show_format		= ftrace_format_<call>,
+ * }
+ *
+ */
+
+#undef TP_FMT
+#define TP_FMT(fmt, args...)	fmt "\n", ##args
+
+#ifdef CONFIG_EVENT_PROFILE
+#define _TRACE_PROFILE(call, proto, args)				\
+static void ftrace_profile_##call(proto)				\
+{									\
+	extern void perf_tpcounter_event(int);				\
+	perf_tpcounter_event(event_##call.id);				\
+}									\
+									\
+static int ftrace_profile_enable_##call(struct ftrace_event_call *call) \
+{									\
+	int ret = 0;							\
+									\
+	if (!atomic_inc_return(&call->profile_count))			\
+		ret = register_trace_##call(ftrace_profile_##call);	\
+									\
+	return ret;							\
+}									\
+									\
+static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
+{									\
+	if (atomic_add_negative(-1, &call->profile_count))		\
+		unregister_trace_##call(ftrace_profile_##call);		\
+}
+
+#define _TRACE_PROFILE_INIT(call)					\
+	.profile_count = ATOMIC_INIT(-1),				\
+	.profile_enable = ftrace_profile_enable_##call,			\
+	.profile_disable = ftrace_profile_disable_##call,
+
+#else
+#define _TRACE_PROFILE(call, proto, args)
+#define _TRACE_PROFILE_INIT(call)
+#endif
+
+#define _TRACE_FORMAT(call, proto, args, fmt)				\
+static void ftrace_event_##call(proto)					\
+{									\
+	event_trace_printk(_RET_IP_, #call ": " fmt);			\
+}									\
+									\
+static int ftrace_reg_event_##call(void)				\
+{									\
+	int ret;							\
+									\
+	ret = register_trace_##call(ftrace_event_##call);		\
+	if (ret)							\
+		pr_info("event trace: Could not activate trace point "	\
+			"probe to " #call "\n");			\
+	return ret;							\
+}									\
+									\
+static void ftrace_unreg_event_##call(void)				\
+{									\
+	unregister_trace_##call(ftrace_event_##call);			\
+}									\
+									\
+static struct ftrace_event_call event_##call;				\
+									\
+static int ftrace_init_event_##call(void)				\
+{									\
+	int id;								\
+									\
+	id = register_ftrace_event(NULL);				\
+	if (!id)							\
+		return -ENODEV;						\
+	event_##call.id = id;						\
+	return 0;							\
+}
+
+#undef TRACE_FORMAT
+#define TRACE_FORMAT(call, proto, args, fmt)				\
+_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.raw_init		= ftrace_init_event_##call,		\
+	.regfunc		= ftrace_reg_event_##call,		\
+	.unregfunc		= ftrace_unreg_event_##call,		\
+	_TRACE_PROFILE_INIT(call)					\
+}
+
+#undef __entry
+#define __entry entry
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
+									\
+static struct ftrace_event_call event_##call;				\
+									\
+static void ftrace_raw_event_##call(proto)				\
+{									\
+	struct ftrace_event_call *call = &event_##call;			\
+	struct ring_buffer_event *event;				\
+	struct ftrace_raw_##call *entry;				\
+	unsigned long irq_flags;					\
+	int pc;								\
+									\
+	local_save_flags(irq_flags);					\
+	pc = preempt_count();						\
+									\
+	event = trace_current_buffer_lock_reserve(event_##call.id,	\
+				  sizeof(struct ftrace_raw_##call),	\
+				  irq_flags, pc);			\
+	if (!event)							\
+		return;							\
+	entry	= ring_buffer_event_data(event);			\
+									\
+	assign;								\
+									\
+	if (!filter_current_check_discard(call, entry, event))		\
+		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
+}									\
+									\
+static int ftrace_raw_reg_event_##call(void)				\
+{									\
+	int ret;							\
+									\
+	ret = register_trace_##call(ftrace_raw_event_##call);		\
+	if (ret)							\
+		pr_info("event trace: Could not activate trace point "	\
+			"probe to " #call "\n");			\
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
+	INIT_LIST_HEAD(&event_##call.fields);				\
+	init_preds(&event_##call);					\
+	return 0;							\
+}									\
+									\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
+	.regfunc		= ftrace_raw_reg_event_##call,		\
+	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
+	_TRACE_PROFILE_INIT(call)					\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#undef _TRACE_PROFILE
+#undef _TRACE_PROFILE_INIT
+
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
deleted file mode 100644
index 13d6b85..0000000
--- a/include/trace/trace_events.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* trace/<type>.h here */
-
-#include <trace/sched.h>
-#include <trace/irq.h>
-#include <trace/lockdep.h>
-#include <trace/skb.h>
-#include <trace/kmem.h>
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 3ad367e..fb9d7f9 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -41,7 +41,6 @@ obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events.o
-obj-$(CONFIG_EVENT_TRACER) += events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
diff --git a/kernel/trace/events.c b/kernel/trace/events.c
deleted file mode 100644
index 5a35a91..0000000
--- a/kernel/trace/events.c
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- * This is the place to register all trace points as events.
- */
-
-#include <linux/stringify.h>
-
-#include <trace/trace_events.h>
-
-#include "trace_output.h"
-
-#define TRACE_HEADER_MULTI_READ
-#include "trace_events_stage_1.h"
-#include "trace_events_stage_2.h"
-#include "trace_events_stage_3.h"
-
diff --git a/kernel/trace/trace_events_stage_1.h b/kernel/trace/trace_events_stage_1.h
deleted file mode 100644
index 475f46a..0000000
--- a/kernel/trace/trace_events_stage_1.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * Stage 1 of the trace events.
- *
- * Override the macros in <trace/trace_events.h> to include the following:
- *
- * struct ftrace_raw_<call> {
- *	struct trace_entry		ent;
- *	<type>				<item>;
- *	<type2>				<item2>[<len>];
- *	[...]
- * };
- *
- * The <type> <item> is created by the __field(type, item) macro or
- * the __array(type2, item2, len) macro.
- * We simply do "type item;", and that will create the fields
- * in the structure.
- */
-
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)
-
-#undef __array
-#define __array(type, item, len)	type	item[len];
-
-#undef __field
-#define __field(type, item)		type	item;
-
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-	struct ftrace_raw_##name {				\
-		struct trace_entry	ent;			\
-		tstruct						\
-	};							\
-	static struct ftrace_event_call event_##name
-
-#include <trace/trace_events.h>
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
deleted file mode 100644
index aa4a67a..0000000
--- a/kernel/trace/trace_events_stage_2.h
+++ /dev/null
@@ -1,170 +0,0 @@
-/*
- * Stage 2 of the trace events.
- *
- * Override the macros in <trace/trace_events.h> to include the following:
- *
- * enum print_line_t
- * ftrace_raw_output_<call>(struct trace_iterator *iter, int flags)
- * {
- *	struct trace_seq *s = &iter->seq;
- *	struct ftrace_raw_<call> *field; <-- defined in stage 1
- *	struct trace_entry *entry;
- *	int ret;
- *
- *	entry = iter->ent;
- *
- *	if (entry->type != event_<call>.id) {
- *		WARN_ON_ONCE(1);
- *		return TRACE_TYPE_UNHANDLED;
- *	}
- *
- *	field = (typeof(field))entry;
- *
- *	ret = trace_seq_printf(s, <TP_printk> "\n");
- *	if (!ret)
- *		return TRACE_TYPE_PARTIAL_LINE;
- *
- *	return TRACE_TYPE_HANDLED;
- * }
- *
- * This is the method used to print the raw event to the trace
- * output format. Note, this is not needed if the data is read
- * in binary.
- */
-
-#undef __entry
-#define __entry field
-
-#undef TP_printk
-#define TP_printk(fmt, args...) fmt "\n", args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-enum print_line_t							\
-ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
-{									\
-	struct trace_seq *s = &iter->seq;				\
-	struct ftrace_raw_##call *field;				\
-	struct trace_entry *entry;					\
-	int ret;							\
-									\
-	entry = iter->ent;						\
-									\
-	if (entry->type != event_##call.id) {				\
-		WARN_ON_ONCE(1);					\
-		return TRACE_TYPE_UNHANDLED;				\
-	}								\
-									\
-	field = (typeof(field))entry;					\
-									\
-	ret = trace_seq_printf(s, #call ": " print);			\
-	if (!ret)							\
-		return TRACE_TYPE_PARTIAL_LINE;				\
-									\
-	return TRACE_TYPE_HANDLED;					\
-}
-	
-#include <trace/trace_events.h>
-
-/*
- * Setup the showing format of trace point.
- *
- * int
- * ftrace_format_##call(struct trace_seq *s)
- * {
- *	struct ftrace_raw_##call field;
- *	int ret;
- *
- *	ret = trace_seq_printf(s, #type " " #item ";"
- *			       " offset:%u; size:%u;\n",
- *			       offsetof(struct ftrace_raw_##call, item),
- *			       sizeof(field.type));
- *
- * }
- */
-
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-
-#undef __field
-#define __field(type, item)					\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item ";\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef __array
-#define __array(type, item, len)						\
-	ret = trace_seq_printf(s, "\tfield:" #type " " #item "[" #len "];\t"	\
-			       "offset:%u;\tsize:%u;\n",		\
-			       (unsigned int)offsetof(typeof(field), item), \
-			       (unsigned int)sizeof(field.item));	\
-	if (!ret)							\
-		return 0;
-
-#undef __entry
-#define __entry REC
-
-#undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
-
-#undef TP_fast_assign
-#define TP_fast_assign(args...) args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-static int								\
-ftrace_format_##call(struct trace_seq *s)				\
-{									\
-	struct ftrace_raw_##call field;					\
-	int ret;							\
-									\
-	tstruct;							\
-									\
-	trace_seq_printf(s, "\nprint fmt: " print);			\
-									\
-	return ret;							\
-}
-
-#include <trace/trace_events.h>
-
-#undef __field
-#define __field(type, item)						\
-	ret = trace_define_field(event_call, #type, #item,		\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
-	if (ret)							\
-		return ret;
-
-#undef __array
-#define __array(type, item, len)					\
-	BUILD_BUG_ON(len > MAX_FILTER_STR_VAL);				\
-	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
-				 offsetof(typeof(field), item),		\
-				 sizeof(field.item));			\
-	if (ret)							\
-		return ret;
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
-int									\
-ftrace_define_fields_##call(void)					\
-{									\
-	struct ftrace_raw_##call field;					\
-	struct ftrace_event_call *event_call = &event_##call;		\
-	int ret;							\
-									\
-	__common_field(unsigned char, type);				\
-	__common_field(unsigned char, flags);				\
-	__common_field(unsigned char, preempt_count);			\
-	__common_field(int, pid);					\
-	__common_field(int, tgid);					\
-									\
-	tstruct;							\
-									\
-	return ret;							\
-}
-
-#include <trace/trace_events.h>
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
deleted file mode 100644
index 45c04e1..0000000
--- a/kernel/trace/trace_events_stage_3.h
+++ /dev/null
@@ -1,279 +0,0 @@
-/*
- * Stage 3 of the trace events.
- *
- * Override the macros in <trace/trace_events.h> to include the following:
- *
- * static void ftrace_event_<call>(proto)
- * {
- *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
- * }
- *
- * static int ftrace_reg_event_<call>(void)
- * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to  <call>");
- *	return ret;
- * }
- *
- * static void ftrace_unreg_event_<call>(void)
- * {
- *	unregister_trace_<call>(ftrace_event_<call>);
- * }
- *
- * For those macros defined with TRACE_FORMAT:
- *
- * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
- * __attribute__((section("_ftrace_events"))) event_<call> = {
- *	.name			= "<call>",
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
- * }
- *
- *
- * For those macros defined with TRACE_EVENT:
- *
- * static struct ftrace_event_call event_<call>;
- *
- * static void ftrace_raw_event_<call>(proto)
- * {
- *	struct ring_buffer_event *event;
- *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
- *	unsigned long irq_flags;
- *	int pc;
- *
- *	local_save_flags(irq_flags);
- *	pc = preempt_count();
- *
- *	event = trace_current_buffer_lock_reserve(event_<call>.id,
- *				  sizeof(struct ftrace_raw_<call>),
- *				  irq_flags, pc);
- *	if (!event)
- *		return;
- *	entry	= ring_buffer_event_data(event);
- *
- *	<assign>;  <-- Here we assign the entries by the __field and
- *			__array macros.
- *
- *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
- * }
- *
- * static int ftrace_raw_reg_event_<call>(void)
- * {
- *	int ret;
- *
- *	ret = register_trace_<call>(ftrace_raw_event_<call>);
- *	if (!ret)
- *		pr_info("event trace: Could not activate trace point "
- *			"probe to <call>");
- *	return ret;
- * }
- *
- * static void ftrace_unreg_event_<call>(void)
- * {
- *	unregister_trace_<call>(ftrace_raw_event_<call>);
- * }
- *
- * static struct trace_event ftrace_event_type_<call> = {
- *	.trace			= ftrace_raw_output_<call>, <-- stage 2
- * };
- *
- * static int ftrace_raw_init_event_<call>(void)
- * {
- *	int id;
- *
- *	id = register_ftrace_event(&ftrace_event_type_<call>);
- *	if (!id)
- *		return -ENODEV;
- *	event_<call>.id = id;
- *	return 0;
- * }
- *
- * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
- * __attribute__((section("_ftrace_events"))) event_<call> = {
- *	.name			= "<call>",
- *	.system			= "<system>",
- *	.raw_init		= ftrace_raw_init_event_<call>,
- *	.regfunc		= ftrace_reg_event_<call>,
- *	.unregfunc		= ftrace_unreg_event_<call>,
- *	.show_format		= ftrace_format_<call>,
- * }
- *
- */
-
-#undef TP_FMT
-#define TP_FMT(fmt, args...)	fmt "\n", ##args
-
-#ifdef CONFIG_EVENT_PROFILE
-#define _TRACE_PROFILE(call, proto, args)				\
-static void ftrace_profile_##call(proto)				\
-{									\
-	extern void perf_tpcounter_event(int);				\
-	perf_tpcounter_event(event_##call.id);				\
-}									\
-									\
-static int ftrace_profile_enable_##call(struct ftrace_event_call *call) \
-{									\
-	int ret = 0;							\
-									\
-	if (!atomic_inc_return(&call->profile_count))			\
-		ret = register_trace_##call(ftrace_profile_##call);	\
-									\
-	return ret;							\
-}									\
-									\
-static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
-{									\
-	if (atomic_add_negative(-1, &call->profile_count))		\
-		unregister_trace_##call(ftrace_profile_##call);		\
-}
-
-#define _TRACE_PROFILE_INIT(call)					\
-	.profile_count = ATOMIC_INIT(-1),				\
-	.profile_enable = ftrace_profile_enable_##call,			\
-	.profile_disable = ftrace_profile_disable_##call,
-
-#else
-#define _TRACE_PROFILE(call, proto, args)
-#define _TRACE_PROFILE_INIT(call)
-#endif
-
-#define _TRACE_FORMAT(call, proto, args, fmt)				\
-static void ftrace_event_##call(proto)					\
-{									\
-	event_trace_printk(_RET_IP_, #call ": " fmt);			\
-}									\
-									\
-static int ftrace_reg_event_##call(void)				\
-{									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_event_##call);		\
-	if (ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
-	return ret;							\
-}									\
-									\
-static void ftrace_unreg_event_##call(void)				\
-{									\
-	unregister_trace_##call(ftrace_event_##call);			\
-}									\
-									\
-static struct ftrace_event_call event_##call;				\
-									\
-static int ftrace_init_event_##call(void)				\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(NULL);				\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	return 0;							\
-}
-
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)				\
-_TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
-_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_init_event_##call,		\
-	.regfunc		= ftrace_reg_event_##call,		\
-	.unregfunc		= ftrace_unreg_event_##call,		\
-	_TRACE_PROFILE_INIT(call)					\
-}
-
-#undef __entry
-#define __entry entry
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
-									\
-static struct ftrace_event_call event_##call;				\
-									\
-static void ftrace_raw_event_##call(proto)				\
-{									\
-	struct ftrace_event_call *call = &event_##call;			\
-	struct ring_buffer_event *event;				\
-	struct ftrace_raw_##call *entry;				\
-	unsigned long irq_flags;					\
-	int pc;								\
-									\
-	local_save_flags(irq_flags);					\
-	pc = preempt_count();						\
-									\
-	event = trace_current_buffer_lock_reserve(event_##call.id,	\
-				  sizeof(struct ftrace_raw_##call),	\
-				  irq_flags, pc);			\
-	if (!event)							\
-		return;							\
-	entry	= ring_buffer_event_data(event);			\
-									\
-	assign;								\
-									\
-	if (!filter_current_check_discard(call, entry, event))		\
-		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
-}									\
-									\
-static int ftrace_raw_reg_event_##call(void)				\
-{									\
-	int ret;							\
-									\
-	ret = register_trace_##call(ftrace_raw_event_##call);		\
-	if (ret)							\
-		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
-	return ret;							\
-}									\
-									\
-static void ftrace_raw_unreg_event_##call(void)				\
-{									\
-	unregister_trace_##call(ftrace_raw_event_##call);		\
-}									\
-									\
-static struct trace_event ftrace_event_type_##call = {			\
-	.trace			= ftrace_raw_output_##call,		\
-};									\
-									\
-static int ftrace_raw_init_event_##call(void)				\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(&ftrace_event_type_##call);		\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	init_preds(&event_##call);					\
-	return 0;							\
-}									\
-									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
-	.name			= #call,				\
-	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
-	.regfunc		= ftrace_raw_reg_event_##call,		\
-	.unregfunc		= ftrace_raw_unreg_event_##call,	\
-	.show_format		= ftrace_format_##call,			\
-	.define_fields		= ftrace_define_fields_##call,		\
-	_TRACE_PROFILE_INIT(call)					\
-}
-
-#include <trace/trace_events.h>
-
-#undef _TRACE_PROFILE
-#undef _TRACE_PROFILE_INIT
-
-- 
1.6.2.1

-- 
