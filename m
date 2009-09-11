Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZIKN43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZIKN43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZIKN42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:56:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33629 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZIKN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:56:27 -0400
Message-Id: <20090911135626.421489476@goodmis.org>
References: <20090911135452.866274568@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 09:54:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 2/3] tracing/profile: add ref count for registering profile events
Content-Disposition: inline; filename=0002-tracing-profile-add-ref-count-for-registering-profil.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Li Zefan discovered that doing the following:

 # insmod trace-events-sample.ko
 # perf record -f -a -e sample:foo_bar sleep 3 &
 # sleep 1
 # rmmod trace_events_sample
 # insmod trace-events-sample.ko

Would cause an OOPS. This was because the registering of the profiler
registers inside the module and does not unregister when unloaded.

This patch adds an increment of the module refcount when a profile
registers a tracepoint, to prevent a module from being unloaded
while being profiled.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A9214E3.2070807@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 308bafd..59e09f9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -400,6 +400,20 @@ static inline int ftrace_get_offsets_##call(				\
  *
  */
 
+#ifdef MODULE
+# define event_trace_up_ref()					\
+	do {							\
+		if (!try_module_get(THIS_MODULE)) {		\
+			atomic_dec(&event_call->profile_count);	\
+			return -ENOENT;				\
+		}						\
+	} while (0)
+# define event_trace_down_ref() module_put(THIS_MODULE)
+#else
+# define event_trace_up_ref() do { } while (0)
+# define event_trace_down_ref() do { } while (0)
+#endif
+
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
 									\
@@ -409,16 +423,20 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
 {									\
 	int ret = 0;							\
 									\
-	if (!atomic_inc_return(&event_call->profile_count))		\
+	if (!atomic_inc_return(&event_call->profile_count)) {		\
+		event_trace_up_ref();					\
 		ret = register_trace_##call(ftrace_profile_##call);	\
+	}								\
 									\
 	return ret;							\
 }									\
 									\
 static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 {									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
+	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
 		unregister_trace_##call(ftrace_profile_##call);		\
+		event_trace_down_ref();					\
+	}								\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-- 
1.6.3.3

-- 
