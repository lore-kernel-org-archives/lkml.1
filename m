Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZHCJkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZHCJkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZHCJkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:40:37 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:61329 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZHCJkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:40:36 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 04/13] ftrace: perf_counter intergration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090802144242.GB22659@elte.hu>
References: <20090723191642.780643661@chello.nl>
	 <20090723191956.941061118@chello.nl>
	 <alpine.DEB.2.00.0907231741060.2498@gandalf.stny.rr.com>
	 <20090802144242.GB22659@elte.hu>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 11:40:24 +0200
Message-Id: <1249292424.7924.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 16:42 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Thu, 23 Jul 2009, Peter Zijlstra wrote:
> > 
> > > Adds possible second part to the assign argument of TP_EVENT().
> > > 
> > >   TP_perf_assign(
> > > 	__perf_count(foo);
> > > 	__perf_addr(bar);
> > >   )
> > > 
> > > Which, when specified make the swcounter increment with @foo instead
> > > of the usual 1, and report @bar for PERF_SAMPLE_ADDR (data address
> > > associated with the event) when this triggers a counter overflow.
> > 
> > Looks good,
> > 
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> looks good to me too - but i skipped it for now because it has build 
> failures:
> 
>  In file included from include/trace/ftrace.h:424,
>                   from include/trace/define_trace.h:57,
>                   from include/trace/events/ext4.h:678,
>                   from fs/ext4/super.c:51:
>  include/trace/events/ext4.h: In function ftrace_profile_ext4_discard_blocks:
>  include/trace/events/ext4.h:345: error: count redeclared as different kind of symbol
>  include/trace/events/ext4.h:345: error: previous definition of count was here

Hehe, obviously I'm not on the ext4 train...

let me go fix that, the below seems to compile with ext4 enabled.

---
Subject: ftrace: perf_counter intergration
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jul 21 17:34:57 CEST 2009

Adds possible second part to the assign argument of TP_EVENT().

  TP_perf_assign(
	__perf_count(foo);
	__perf_addr(bar);
  )

Which, when specified make the swcounter increment with @foo instead
of the usual 1, and report @bar for PERF_SAMPLE_ADDR (data address
associated with the event) when this triggers a counter overflow.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
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
+ * 	u64 __addr = 0, __count = 1;
+ *
+ * 	<assign>   <-- here we expand the TP_perf_assign() macro
+ *
+ * 	perf_tpcounter_event(event_<call>.id, __addr, __count);
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
+#define __perf_addr(a) __addr = (a)
+
+#undef __perf_count
+#define __perf_count(c) __count = (c)
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+									\
+static void ftrace_profile_##call(proto)				\
+{									\
+	extern void perf_tpcounter_event(int, u64, u64);		\
+	u64 __addr = 0, __count = 1;					\
+	{ assign; }							\
+	perf_tpcounter_event(event_##call.id, __addr, __count);		\
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
 


