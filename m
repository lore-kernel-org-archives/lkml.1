Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbZCTKVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbZCTKVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbZCTKUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:20:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:49058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760337AbZCTKUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:20:32 -0400
Date: Fri, 20 Mar 2009 10:19:51 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319194233.557364871@chello.nl>
References: <20090319194233.557364871@chello.nl>
Subject: [tip:tracing/ftrace] ftrace: event profile hooks
Message-ID: <tip-ac199db0189c091f2863312061c0575937f68810@git.kernel.org>
Git-Commit-ID: ac199db0189c091f2863312061c0575937f68810
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:19:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac199db0189c091f2863312061c0575937f68810
Gitweb:     http://git.kernel.org/tip/ac199db0189c091f2863312061c0575937f68810
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 19 Mar 2009 20:26:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:17:07 +0100

ftrace: event profile hooks

Impact: new tracing infrastructure feature

Provide infrastructure to generate software perf counter events
from tracepoints.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090319194233.557364871@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/Makefile               |    1 +
 kernel/trace/events.c               |    1 -
 kernel/trace/trace.h                |   11 ++++++++
 kernel/trace/trace_event_profile.c  |   31 ++++++++++++++++++++++++
 kernel/trace/trace_events.c         |    9 +-----
 kernel/trace/trace_events_stage_3.h |   44 +++++++++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index c3feea0..0e45c20 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -44,5 +44,6 @@ obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 obj-$(CONFIG_EVENT_TRACER) += events.o
 obj-$(CONFIG_EVENT_TRACER) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
+obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/events.c b/kernel/trace/events.c
index 9fc918d..246f2aa 100644
--- a/kernel/trace/events.c
+++ b/kernel/trace/events.c
@@ -12,4 +12,3 @@
 #include "trace_events_stage_2.h"
 #include "trace_events_stage_3.h"
 
-#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7c9a0cb..7cfb741 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -785,12 +785,23 @@ struct ftrace_event_call {
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
 
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
new file mode 100644
index 0000000..22cba99
--- /dev/null
+++ b/kernel/trace/trace_event_profile.c
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
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7763db8..3047b56 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
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
@@ -90,7 +85,7 @@ static int ftrace_set_clr_event(char *buf, int set)
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
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 4c26d97..6b3261c 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
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
@@ -147,6 +181,7 @@ static int ftrace_init_event_##call(void)				\
 #undef TRACE_FORMAT
 #define TRACE_FORMAT(call, proto, args, fmt)				\
 _TRACE_FORMAT(call, PARAMS(proto), PARAMS(args), PARAMS(fmt))		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
@@ -155,6 +190,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= ftrace_init_event_##call,		\
 	.regfunc		= ftrace_reg_event_##call,		\
 	.unregfunc		= ftrace_unreg_event_##call,		\
+	_TRACE_PROFILE_INIT(call)					\
 }
 
 #undef __entry
@@ -162,6 +198,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
+_TRACE_PROFILE(call, PARAMS(proto), PARAMS(args))			\
 									\
 static struct ftrace_event_call event_##call;				\
 									\
@@ -227,4 +264,11 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
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
