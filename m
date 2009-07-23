Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZGWTV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZGWTV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZGWTVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:21:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48199 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZGWTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:21:16 -0400
Message-Id: <20090723191956.941061118@chello.nl>
References: <20090723191642.780643661@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 21:16:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 04/13] ftrace: perf_counter intergration
Content-Disposition: inline; filename=ftrace-perf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds possible second part to the assign argument of TP_EVENT().

  TP_perf_assign(
	__perf_count(foo);
	__perf_addr(bar);
  )

Which, when specified make the swcounter increment with @foo instead
of the usual 1, and report @bar for PERF_SAMPLE_ADDR (data address
associated with the event) when this triggers a counter overflow.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/trace/ftrace.h |  110 +++++++++++++++++++++++++++++++++++++------------
 kernel/perf_counter.c  |    6 +-
 2 files changed, 88 insertions(+), 28 deletions(-)

Index: linux-2.6/include/trace/ftrace.h
===================================================================
--- linux-2.6.orig/include/trace/ftrace.h
+++ linux-2.6/include/trace/ftrace.h
@@ -144,6 +144,9 @@
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
 
+#undef TP_perf_assign
+#define TP_perf_assign(args...)
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 static int								\
@@ -345,6 +348,88 @@ static inline int ftrace_get_offsets_##c
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#ifdef CONFIG_EVENT_PROFILE
+
+/*
+ * Generate the functions needed for tracepoint perf_counter support.
+ *
+ * static void ftrace_profile_<call>(proto)
+ * {
+ * 	extern void perf_tpcounter_event(int, u64, u64);
+ * 	u64 addr = 0, count = 1;
+ *
+ * 	<assign>   <-- here we expand the TP_perf_assign() macro
+ *
+ * 	perf_tpcounter_event(event_<call>.id, addr, count);
+ * }
+ *
+ * static int ftrace_profile_enable_<call>(struct ftrace_event_call *event_call)
+ * {
+ * 	int ret = 0;
+ *
+ * 	if (!atomic_inc_return(&event_call->profile_count))
+ * 		ret = register_trace_<call>(ftrace_profile_<call>);
+ *
+ * 	return ret;
+ * }
+ *
+ * static void ftrace_profile_disable_<call>(struct ftrace_event_call *event_call)
+ * {
+ * 	if (atomic_add_negative(-1, &event->call->profile_count))
+ * 		unregister_trace_<call>(ftrace_profile_<call>);
+ * }
+ *
+ */
+
+#undef TP_fast_assign
+#define TP_fast_assign(args...)
+
+#undef TP_perf_assign
+#define TP_perf_assign(args...) args
+
+#undef __perf_addr
+#define __perf_addr(a) addr = (a)
+
+#undef __perf_count
+#define __perf_count(c) count = (c)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+									\
+static void ftrace_profile_##call(proto)				\
+{									\
+	extern void perf_tpcounter_event(int, u64, u64);		\
+	u64 addr = 0, count = 1;					\
+	{ assign; }							\
+	perf_tpcounter_event(event_##call.id, addr, count);		\
+}									\
+									\
+static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
+{									\
+	int ret = 0;							\
+									\
+	if (!atomic_inc_return(&event_call->profile_count))		\
+		ret = register_trace_##call(ftrace_profile_##call);	\
+									\
+	return ret;							\
+}									\
+									\
+static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
+{									\
+	if (atomic_add_negative(-1, &event_call->profile_count))	\
+		unregister_trace_##call(ftrace_profile_##call);		\
+}
+
+#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
+
+#undef TP_fast_assign
+#define TP_fast_assign(args...) args
+
+#undef TP_perf_assign
+#define TP_perf_assign(args...)
+
+#endif
+
 /*
  * Stage 4 of the trace events.
  *
@@ -447,28 +532,6 @@ static inline int ftrace_get_offsets_##c
 #define TP_FMT(fmt, args...)	fmt "\n", ##args
 
 #ifdef CONFIG_EVENT_PROFILE
-#define _TRACE_PROFILE(call, proto, args)				\
-static void ftrace_profile_##call(proto)				\
-{									\
-	extern void perf_tpcounter_event(int);				\
-	perf_tpcounter_event(event_##call.id);				\
-}									\
-									\
-static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
-{									\
-	int ret = 0;							\
-									\
-	if (!atomic_inc_return(&event_call->profile_count))		\
-		ret = register_trace_##call(ftrace_profile_##call);	\
-									\
-	return ret;							\
-}									\
-									\
-static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
-{									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
-		unregister_trace_##call(ftrace_profile_##call);		\
-}
 
 #define _TRACE_PROFILE_INIT(call)					\
 	.profile_count = ATOMIC_INIT(-1),				\
@@ -476,7 +539,6 @@ static void ftrace_profile_disable_##cal
 	.profile_disable = ftrace_profile_disable_##call,
 
 #else
-#define _TRACE_PROFILE(call, proto, args)
 #define _TRACE_PROFILE_INIT(call)
 #endif
 
@@ -502,7 +564,6 @@ static void ftrace_profile_disable_##cal
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
-_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
 									\
 static struct ftrace_event_call event_##call;				\
 									\
@@ -586,6 +647,5 @@ __attribute__((section("_ftrace_events")
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#undef _TRACE_PROFILE
 #undef _TRACE_PROFILE_INIT
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3680,17 +3680,17 @@ static const struct pmu perf_ops_task_cl
 };
 
 #ifdef CONFIG_EVENT_PROFILE
-void perf_tpcounter_event(int event_id)
+void perf_tpcounter_event(int event_id, u64 addr, u64 count)
 {
 	struct perf_sample_data data = {
 		.regs = get_irq_regs(),
-		.addr = 0,
+		.addr = addr,
 	};
 
 	if (!data.regs)
 		data.regs = task_pt_regs(current);
 
-	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, &data);
+	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1, &data);
 }
 EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 

-- 

