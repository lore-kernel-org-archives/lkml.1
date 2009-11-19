Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZKSRLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZKSRLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZKSRLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:11:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbZKSRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:11:01 -0500
Message-Id: <20091119171106.611553083@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 19 Nov 2009 12:10:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] [PATCH 2/4] tracing: Create new TRACE_EVENT_TEMPLATE
References: <20091119171003.929771398@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Create-new-TRACE_EVENT_TEMPLATE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are some places in the kernel that define several tracepoints and
they are all identical besides the name. The code to enable, disable and
record is created for every trace point even if most of the code is
identical.

This patch adds TRACE_EVENT_TEMPLATE that lets the developer create
a template TRACE_EVENT and create trace points with DEFINE_EVENT, which
is based off of a given template. Each trace point used by this
will share most of the code, and bring down the size of the kernel
when there are several duplicate events.

Usage is:

TRACE_EVENT_TEMPLATE(name, proto, args, tstruct, assign, print);

Which would be the same as defining a normal TRACE_EVENT.

To create the trace events that the trace points will use:

DEFINE_EVENT(template, name, proto, args) is done. The template
is the name of the TRACE_EVENT_TEMPLATE to use. The name is the
name of the trace point. The parameters proto and args must be the same
as the proto and args of the template. If they are not the same,
then a compile error will result. I tried hard removing this duplication
but the C preprocessor is not powerful enough (or my CPP magic
experience points is not at a high enough level) to not need them.

A lot of trace events are coming in with new XFS development. Most of
the trace points are identical except for the name. The following shows
the advantage of having TRACE_EVENT_TEMPLATE:

$ size fs/xfs/xfs.o.*
    text          data     bss     dec     hex filename
  452114          2788    3520  458422   6feb6 fs/xfs/xfs.o.old
  638482         38116    3744  680342   a6196 fs/xfs/xfs.o.template
  996954         38116    4480 1039550   fdcbe fs/xfs/xfs.o.trace

xfs.o.old is without any tracepoints.
xfs.o.template uses the new TRACE_EVENT_TEMPLATE.
xfs.o.trace uses the current TRACE_EVENT macros.

Requested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |    4 +
 include/trace/define_trace.h |    4 +
 include/trace/ftrace.h       |  149 ++++++++++++++++++++++++++++++------------
 3 files changed, 115 insertions(+), 42 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2aac8a8..88a5b5a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -280,6 +280,10 @@ static inline void tracepoint_synchronize_unregister(void)
  * TRACE_EVENT_FN to perform any (un)registration work.
  */
 
+#define TRACE_EVENT_TEMPLATE(name, proto, args, tstruct, assign, print)
+#define DEFINE_EVENT(template, name, proto, args)		\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define TRACE_EVENT_FN(name, proto, args, struct,		\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 2a4b3bf..f4ddec5 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -31,6 +31,10 @@
 		assign, print, reg, unreg)			\
 	DEFINE_TRACE_FN(name, reg, unreg)
 
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args) \
+	DEFINE_TRACE(name)
+
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index cc0d966..0b48e7b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -18,6 +18,26 @@
 
 #include <linux/ftrace_event.h>
 
+/*
+ * TRACE_EVENT_TEMPLATE can be used to add a generic function
+ * handlers for events. That is, if all events have the same
+ * parameters and just have distinct trace points.
+ * Each tracepoint can be defined with DEFINE_EVENT and that
+ * will map the TRACE_EVENT_TEMPLATE to the tracepoint.
+ *
+ * TRACE_EVENT is a one to one mapping between tracepoint and template.
+ */
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, args, tstruct, assign, print) \
+	TRACE_EVENT_TEMPLATE(name,			       \
+			     PARAMS(proto),		       \
+			     PARAMS(args),		       \
+			     PARAMS(tstruct),		       \
+			     PARAMS(assign),		       \
+			     PARAMS(print));		       \
+	DEFINE_EVENT(name, name, PARAMS(proto), PARAMS(args));
+
+
 #undef __field
 #define __field(type, item)		type	item;
 
@@ -36,13 +56,15 @@
 #undef TP_STRUCT__entry
 #define TP_STRUCT__entry(args...) args
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
-	struct ftrace_raw_##name {				\
-		struct trace_entry	ent;			\
-		tstruct						\
-		char			__data[0];		\
-	};							\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(name, proto, args, tstruct, assign, print)	\
+	struct ftrace_raw_##name {					\
+		struct trace_entry	ent;				\
+		tstruct							\
+		char			__data[0];			\
+	};
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call event_##name
 
 #undef __cpparg
@@ -89,12 +111,15 @@
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
 	struct ftrace_data_offsets_##call {				\
 		tstruct;						\
 	};
 
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -167,8 +192,8 @@
 #undef TP_perf_assign
 #define TP_perf_assign(args...)
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, func, print)	\
 static int								\
 ftrace_format_##call(struct ftrace_event_call *unused,			\
 		      struct trace_seq *s)				\
@@ -183,6 +208,9 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 	return ret;							\
 }
 
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -252,10 +280,11 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 		ftrace_print_symbols_seq(p, value, symbols);		\
 	})
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
 static enum print_line_t						\
-ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
+ftrace_raw_output_id_##call(int event_id, const char *name,		\
+			    struct trace_iterator *iter, int flags)	\
 {									\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
@@ -265,7 +294,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	entry = iter->ent;						\
 									\
-	if (entry->type != event_##call.id) {				\
+	if (entry->type != event_id) {					\
 		WARN_ON_ONCE(1);					\
 		return TRACE_TYPE_UNHANDLED;				\
 	}								\
@@ -274,14 +303,25 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 									\
 	p = &get_cpu_var(ftrace_event_seq);				\
 	trace_seq_init(p);						\
-	ret = trace_seq_printf(s, #call ": " print);			\
+	ret = trace_seq_printf(s, "%s: ", name);			\
+	if (ret)							\
+		ret = trace_seq_printf(s, print);			\
 	put_cpu();							\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
 	return TRACE_TYPE_HANDLED;					\
 }
-	
+
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)			\
+static enum print_line_t						\
+ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
+{									\
+	return ftrace_raw_output_id_##template(event_##name.id,		\
+					       #name, iter, flags);	\
+}
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 #undef __field_ext
@@ -315,8 +355,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef __string
 #define __string(item, src) __dynamic_array(char, item, -1)
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, func, print)	\
 static int								\
 ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
@@ -332,6 +372,9 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	return ret;							\
 }
 
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -358,10 +401,10 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)       \
+#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
 static inline int ftrace_get_offsets_##call(				\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
@@ -373,6 +416,9 @@ static inline int ftrace_get_offsets_##call(				\
 	return __data_size;						\
 }
 
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 #ifdef CONFIG_EVENT_PROFILE
@@ -394,19 +440,22 @@ static inline int ftrace_get_offsets_##call(				\
  *
  */
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)
+
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, name, proto, args)			\
 									\
-static void ftrace_profile_##call(proto);				\
+static void ftrace_profile_##name(proto);				\
 									\
-static int ftrace_profile_enable_##call(void)				\
+static int ftrace_profile_enable_##name(void)				\
 {									\
-	return register_trace_##call(ftrace_profile_##call);		\
+	return register_trace_##name(ftrace_profile_##name);		\
 }									\
 									\
-static void ftrace_profile_disable_##call(void)				\
+static void ftrace_profile_disable_##name(void)				\
 {									\
-	unregister_trace_##call(ftrace_profile_##call);			\
+	unregister_trace_##name(ftrace_profile_##name);			\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
@@ -547,15 +596,13 @@ static void ftrace_profile_disable_##call(void)				\
 #define __assign_str(dst, src)						\
 	strcpy(__get_str(dst), src);
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-									\
-static struct ftrace_event_call event_##call;				\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
 									\
-static void ftrace_raw_event_##call(proto)				\
+static void ftrace_raw_event_id_##call(struct ftrace_event_call *event_call, \
+				       proto)				\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
 	struct ring_buffer *buffer;					\
@@ -569,7 +616,7 @@ static void ftrace_raw_event_##call(proto)				\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
 									\
 	event = trace_current_buffer_lock_reserve(&buffer,		\
-				 event_##call.id,			\
+				 event_call->id,			\
 				 sizeof(*entry) + __data_size,		\
 				 irq_flags, pc);			\
 	if (!event)							\
@@ -584,6 +631,14 @@ static void ftrace_raw_event_##call(proto)				\
 	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
 		trace_nowake_buffer_unlock_commit(buffer,		\
 						  event, irq_flags, pc); \
+}
+
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, call, proto, args)			\
+									\
+static void ftrace_raw_event_##call(proto)				\
+{									\
+	ftrace_raw_event_id_##template(&event_##call, args);		\
 }									\
 									\
 static int ftrace_raw_reg_event_##call(void *ptr)			\
@@ -627,8 +682,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= ftrace_raw_init_event_##call,		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
-	.show_format		= ftrace_format_##call,			\
-	.define_fields		= ftrace_define_fields_##call,		\
+	.show_format		= ftrace_format_##template,		\
+	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
 }
 
@@ -704,12 +759,13 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
-#undef TRACE_EVENT
-#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-static void ftrace_profile_##call(proto)				\
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)	\
+static void								\
+ftrace_profile_templ_##call(struct ftrace_event_call *event_call,	\
+			    proto)					\
 {									\
 	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	extern void perf_tp_event(int, u64, u64, void *, int);	\
 	struct ftrace_raw_##call *entry;				\
 	u64 __addr = 0, __count = 1;					\
@@ -763,6 +819,15 @@ end:									\
 									\
 }
 
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, call, proto, args)		\
+static void ftrace_profile_##call(proto)			\
+{								\
+	struct ftrace_event_call *event_call = &event_##call;	\
+								\
+	ftrace_profile_templ_##template(event_call, args);	\
+}
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_EVENT_PROFILE */
 
-- 
1.6.5


