Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZDYE1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZDYE1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZDYE0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:26:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZDYE0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:26:33 -0400
Message-Id: <20090425042631.379140147@goodmis.org>
References: <20090425042030.431477667@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 00:20:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/5] tracing: remove deprecated TRACE_FORMAT
Content-Disposition: inline; filename=0003-tracing-remove-deprecated-TRACE_FORMAT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The TRACE_FORMAT macro has been deprecated by the TRACE_EVENT macro.
There are no more users. All new users must use the TRACE_EVENT macro.

[ Impact: remove old functionality ]

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h   |    5 ---
 include/trace/define_trace.h |    4 --
 include/trace/ftrace.h       |   66 ------------------------------------------
 3 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 4353f3f..14df7e6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -158,11 +158,6 @@ static inline void tracepoint_synchronize_unregister(void)
 
 #define PARAMS(args...) args
 
-#ifndef TRACE_FORMAT
-#define TRACE_FORMAT(name, proto, args, fmt)		\
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-#endif
-
 #ifndef TRACE_EVENT
 /*
  * For use with the TRACE_EVENT macro:
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index abc611f..f7a7ae1 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -26,10 +26,6 @@
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
 	DEFINE_TRACE(name)
 
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(name, proto, args, print)	\
-	DEFINE_TRACE(name)
-
 #undef DECLARE_TRACE
 #define DECLARE_TRACE(name, proto, args)	\
 	DEFINE_TRACE(name)
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a77f71a..1e68114 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -18,9 +18,6 @@
 
 #include <linux/ftrace_event.h>
 
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)
-
 #undef __array
 #define __array(type, item, len)	type	item[len];
 
@@ -62,9 +59,6 @@
  *
  */
 
-#undef TRACE_FORMAT
-#define TRACE_FORMAT(call, proto, args, fmt)
-
 #undef __array
 #define __array(type, item, len)
 
@@ -298,16 +292,6 @@ ftrace_define_fields_##call(void)					\
  *	unregister_trace_<call>(ftrace_event_<call>);
  * }
  *
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
  *
  * For those macros defined with TRACE_EVENT:
  *
@@ -417,56 +401,6 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *call) \
 #define _TRACE_PROFILE_INIT(call)
 #endif
 
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
 #undef __entry
 #define __entry entry
 
-- 
1.6.2.1

-- 
