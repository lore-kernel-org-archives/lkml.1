Return-Path: <linux-kernel-owner+w=401wt.eu-S934549AbZKYEjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbZKYEjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934500AbZKYEjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:39:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47608 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499AbZKYEjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:39:07 -0500
Message-Id: <20091125043912.696538082@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 Nov 2009 23:38:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] [PATCH 2/3] tracing: Create new DEFINE_EVENT_PRINT
References: <20091125043811.603607335@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Create-new-DEFINE_EVENT_PRINT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

After creating the TRACE_EVENT_TEMPLATE I started to look at other
trace points to see what duplication was made. I noticed that there
are several trace points where they are almost identical except for
the name and the output format. Since TRACE_EVENT_TEMPLATE was successful
in bringing down the size of trace events, I added a DEFINE_EVENT_PRINT.

DEFINE_EVENT_PRINT is used just like DEFINE_EVENT is. That is, the
DEFINE_EVENT_PRINT also uses a TRACE_EVENT_TEMPLATE, but it allows the
developer to overwrite the print format. If there are two or more
TRACE_EVENTS that are identical except for the name and print, then
they can be converted to use a TRACE_EVENT_TEMPLATE. Since the
TRACE_EVENT_TEMPLATE already does the print output, the first trace event
would have its print format held in the TRACE_EVENT_TEMPLATE and
be defined with a DEFINE_EVENT. The rest will use the DEFINE_EVENT_PRINT
and override the print format.

Converting the sched trace points to both DEFINE_EVENT and
DEFINE_EVENT_PRINT. Five were converted to DEFINE_EVENT and two were
converted to DEFINE_EVENT_PRINT.

I was able to get the following:

$ size kernel/sched.o-*
   text	   data	    bss	    dec	    hex	filename
  79299	   6776	   2520	  88595	  15a13	kernel/sched.o-notrace
 101941	  11896	   2584	 116421	  1c6c5	kernel/sched.o-templ
 104779	  11896	   2584	 119259	  1d1db	kernel/sched.o-trace

sched.o-notrace is the scheduler compiled with no trace points.
sched.o-templ is with the use of DEFINE_EVENT and DEFINE_EVENT_PRINT
sched.o-trace is the current trace events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |    2 +
 include/trace/define_trace.h |    5 ++
 include/trace/ftrace.h       |  123 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 88a5b5a..7063383 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -283,6 +283,8 @@ static inline void tracepoint_synchronize_unregister(void)
 #define TRACE_EVENT_TEMPLATE(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 
 #define TRACE_EVENT(name, proto, args, struct, assign, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 2449858..5d7d855 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -35,6 +35,10 @@
 #define DEFINE_EVENT(template, name, proto, args) \
 	DEFINE_TRACE(name)
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_TRACE(name)
+
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
@@ -69,6 +73,7 @@
 #undef TRACE_EVENT_FN
 #undef TRACE_EVENT_TEMPLATE
 #undef DEFINE_EVENT
+#undef DEFINE_EVENT_PRINT
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 2969f65..b046177 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -67,6 +67,10 @@
 #define DEFINE_EVENT(template, name, proto, args)	\
 	static struct ftrace_event_call event_##name
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #undef __cpparg
 #define __cpparg(arg...) arg
 
@@ -120,6 +124,10 @@
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -198,15 +206,28 @@
 #undef TRACE_EVENT_TEMPLATE
 #define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, func, print)	\
 static int								\
-ftrace_format_##call(struct ftrace_event_call *unused,			\
-		      struct trace_seq *s)				\
+ftrace_format_setup_##call(struct ftrace_event_call *unused,		\
+			   struct trace_seq *s)				\
 {									\
 	struct ftrace_raw_##call field __attribute__((unused));		\
 	int ret = 0;							\
 									\
 	tstruct;							\
 									\
-	trace_seq_printf(s, "\nprint fmt: " print);			\
+	return ret;							\
+}									\
+									\
+static int								\
+ftrace_format_##call(struct ftrace_event_call *unused,			\
+		     struct trace_seq *s)				\
+{									\
+	int ret = 0;							\
+									\
+	ret = ftrace_format_setup_##call(unused, s);			\
+	if (!ret)							\
+		return ret;						\
+									\
+	ret = trace_seq_printf(s, "\nprint fmt: " print);		\
 									\
 	return ret;							\
 }
@@ -214,6 +235,23 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)		\
+static int								\
+ftrace_format_##name(struct ftrace_event_call *unused,			\
+		      struct trace_seq *s)				\
+{									\
+	int ret = 0;							\
+									\
+	ret = ftrace_format_setup_##template(unused, s);		\
+	if (!ret)							\
+		return ret;						\
+									\
+	trace_seq_printf(s, "\nprint fmt: " print);			\
+									\
+	return ret;							\
+}
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -325,6 +363,38 @@ ftrace_raw_output_##name(struct trace_iterator *iter, int flags)	\
 					       #name, iter, flags);	\
 }
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
+static enum print_line_t						\
+ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
+{									\
+	struct trace_seq *s = &iter->seq;				\
+	struct ftrace_raw_##template *field;				\
+	struct trace_entry *entry;					\
+	struct trace_seq *p;						\
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
+	p = &get_cpu_var(ftrace_event_seq);				\
+	trace_seq_init(p);						\
+	ret = trace_seq_printf(s, "%s: ", #call);			\
+	if (ret)							\
+		ret = trace_seq_printf(s, print);			\
+	put_cpu();							\
+	if (!ret)							\
+		return TRACE_TYPE_PARTIAL_LINE;				\
+									\
+	return TRACE_TYPE_HANDLED;					\
+}
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 #undef __field_ext
@@ -378,6 +448,10 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -422,6 +496,10 @@ static inline int ftrace_get_offsets_##call(				\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, name, proto, args)
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 #ifdef CONFIG_EVENT_PROFILE
@@ -461,6 +539,10 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
 	unregister_trace_##name(ftrace_profile_##name);			\
 }
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 #endif
@@ -674,7 +756,19 @@ static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
 	event_##call.id = id;						\
 	INIT_LIST_HEAD(&event_##call.fields);				\
 	return 0;							\
-}									\
+}
+
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#undef TRACE_EVENT_TEMPLATE
+#define TRACE_EVENT_TEMPLATE(call, proto, args, tstruct, assign, print)
+
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(template, call, proto, args)			\
 									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
@@ -690,6 +784,23 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	_TRACE_PROFILE_INIT(call)					\
 }
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
+									\
+static struct ftrace_event_call __used					\
+__attribute__((__aligned__(4)))						\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name			= #call,				\
+	.system			= __stringify(TRACE_SYSTEM),		\
+	.event			= &ftrace_event_type_##call,		\
+	.raw_init		= ftrace_raw_init_event_##call,		\
+	.regfunc		= ftrace_raw_reg_event_##call,		\
+	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##template,	\
+	_TRACE_PROFILE_INIT(call)					\
+}
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
 /*
@@ -854,6 +965,10 @@ static void ftrace_profile_##call(proto)			\
 	ftrace_profile_templ_##template(event_call, args);	\
 }
 
+#undef DEFINE_EVENT_PRINT
+#define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_EVENT_PROFILE */
 
-- 
1.6.5


