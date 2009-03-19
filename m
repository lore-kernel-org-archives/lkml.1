Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZCSTph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZCSTph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZCSTnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbZCSTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:20 -0400
Message-Id: <20090319194233.557364871@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:15 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/10] ftrace: event profile hooks
Content-Disposition: inline; filename=ftrace_event_profile.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide infrastructure to generate software perf counter events from
tracepoints.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/trace/Makefile               |    1 
 kernel/trace/events.c               |    1 
 kernel/trace/trace.h                |   11 +++++++++
 kernel/trace/trace_event_profile.c  |   31 +++++++++++++++++++++++++
 kernel/trace/trace_events.c         |    9 +------
 kernel/trace/trace_events_stage_3.h |   44 ++++++++++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/trace/trace.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace.h
+++ linux-2.6/kernel/trace/trace.h
@@ -786,12 +786,23 @@ struct ftrace_event_call {
 	int		id;
 	int		(*raw_init)(void);
 	int		(*show_format)(struct trace_seq *s);
+
+#ifdef CONFIG_EVENT_PROFILE
+	atomic_t	profile_count;
+	int		(*profile_enable)(struct ftrace_event_call *);
+	void		(*profile_disable)(struct ftrace_event_call *);
+#endif
 };
 
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
 
+#define for_each_event(event)						\
+	for (event = __start_ftrace_events;				\
+	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
+	     event++)
+
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
Index: linux-2.6/kernel/trace/trace_event_profile.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/trace/trace_event_profile.c
@@ -0,0 +1,31 @@
+/*
+ * trace event based perf counter profiling
+ *
+ * Copyright (C) 2009 Red Hat Inc, Peter Zijlstra <pzijlstr@redhat.com>
+ *
+ */
+
+#include "trace.h"
+
+int ftrace_profile_enable(int event_id)
+{
+	struct ftrace_event_call *event;
+
+	for_each_event(event) {
+		if (event->id == event_id)
+			return event->profile_enable(event);
+	}
+
+	return -EINVAL;
+}
+
+void ftrace_profile_disable(int event_id)
+{
+	struct ftrace_event_call *event;
+
+	for_each_event(event) {
+		if (event->id == event_id)
+			return event->profile_disable(event);
+	}
+}
+
Index: linux-2.6/kernel/trace/trace_events.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_events.c
+++ linux-2.6/kernel/trace/trace_events.c
@@ -19,11 +19,6 @@
 
 static DEFINE_MUTEX(event_mutex);
 
-#define events_for_each(event)						\
-	for (event = __start_ftrace_events;				\
-	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
-	     event++)
-
 static void ftrace_clear_events(void)
 {
 	struct ftrace_event_call *call = (void *)__start_ftrace_events;
@@ -90,7 +85,7 @@ static int ftrace_set_clr_event(char *bu
 	}
 
 	mutex_lock(&event_mutex);
-	events_for_each(call) {
+	for_each_event(call) {
 
 		if (!call->name || !call->regfunc)
 			continue;
@@ -628,7 +623,7 @@ static __init int event_trace_init(void)
 	if (!d_events)
 		return 0;
 
-	events_for_each(call) {
+	for_each_event(call) {
 		/* The linker may leave blanks */
 		if (!call->name)
 			continue;
Index: linux-2.6/kernel/trace/trace_events_stage_3.h
===================================================================
--- linux-2.6.orig/kernel/trace/trace_events_stage_3.h
+++ linux-2.6/kernel/trace/trace_events_stage_3.h
@@ -109,6 +109,40 @@
 #undef TP_FMT
 #define TP_FMT(fmt, args...)	fmt "\n", ##args
 
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
 #define _TRACE_FORMAT(call, proto, args, fmt)				\
 static void ftrace_event_##call(proto)					\
 {									\
@@ -147,6 +181,7 @@ static int ftrace_init_event_##call(void
 #undef TRACE_FORMAT
 #define TRACE_FORMAT(call, proto, args, fmt)				\
 _TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
@@ -155,6 +190,7 @@ __attribute__((section("_ftrace_events")
 	.raw_init		= ftrace_init_event_##call,		\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
+	_TRACE_PROFILE_INIT(call)					\
 }
 
 #undef __entry
@@ -162,6 +198,7 @@ __attribute__((section("_ftrace_events")
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
 									\
 static struct ftrace_event_call event_##call;				\
 									\
@@ -227,4 +264,11 @@ __attribute__((section("_ftrace_events")
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
+	_TRACE_PROFILE_INIT(call)					\
 }
+
+#include <trace/trace_event_types.h>
+
+#undef _TRACE_PROFILE
+#undef _TRACE_PROFILE_INIT
+
Index: linux-2.6/kernel/trace/Makefile
===================================================================
--- linux-2.6.orig/kernel/trace/Makefile
+++ linux-2.6/kernel/trace/Makefile
@@ -44,5 +44,6 @@ obj-$(CONFIG_EVENT_TRACER) += trace_even
 obj-$(CONFIG_EVENT_TRACER) += events.o
 obj-$(CONFIG_EVENT_TRACER) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
+obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 
 libftrace-y := ftrace.o
Index: linux-2.6/kernel/trace/events.c
===================================================================
--- linux-2.6.orig/kernel/trace/events.c
+++ linux-2.6/kernel/trace/events.c
@@ -12,4 +12,3 @@
 #include "trace_events_stage_2.h"
 #include "trace_events_stage_3.h"
 
-#include <trace/trace_event_types.h>

-- 

