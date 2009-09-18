Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZIRBdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZIRBdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 21:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZIRBdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 21:33:44 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42162 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbZIRBdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 21:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=orYZyvz8DdSStHDIu5mYcOM4A6pfdu0sT1MQ6efS7jjnSYgIFAtEAPh6sW7/W6qCX2
         frx7EzJhhGsggATdMk3ACn22UmQlenyWbTl2z5sMHKiMsbig/FpJ6vDXMymOuNjBQmh9
         cAuGLWyiW1B3D5VbjuIi/nPsNhZ4bK1ASqwxw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] tracing: Factorize the events profile accounting
Date: Fri, 18 Sep 2009 03:33:32 +0200
Message-Id: <1253237613-5589-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize the events enabling accounting in a common tracing core
helper. This reduces the size of the profile_enable() and
profile_disable() callbacks for each trace events.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h       |    4 ++--
 include/linux/syscalls.h           |   24 ++++++++----------------
 include/trace/ftrace.h             |   28 ++++++++--------------------
 kernel/trace/trace_event_profile.c |   20 ++++++++++++++++++--
 4 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index bd099ba..bc103d7 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -130,8 +130,8 @@ struct ftrace_event_call {
 	void			*data;
 
 	atomic_t		profile_count;
-	int			(*profile_enable)(struct ftrace_event_call *);
-	void			(*profile_disable)(struct ftrace_event_call *);
+	int			(*profile_enable)(void);
+	void			(*profile_disable)(void);
 };
 
 #define MAX_FILTER_PRED		32
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a8e3782..7d9803c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -100,33 +100,25 @@ struct perf_counter_attr;
 
 #ifdef CONFIG_EVENT_PROFILE
 #define TRACE_SYS_ENTER_PROFILE(sname)					       \
-static int prof_sysenter_enable_##sname(struct ftrace_event_call *event_call)  \
+static int prof_sysenter_enable_##sname(void)				       \
 {									       \
-	int ret = 0;							       \
-	if (!atomic_inc_return(&event_enter_##sname.profile_count))	       \
-		ret = reg_prof_syscall_enter("sys"#sname);		       \
-	return ret;							       \
+	return reg_prof_syscall_enter("sys"#sname);			       \
 }									       \
 									       \
-static void prof_sysenter_disable_##sname(struct ftrace_event_call *event_call)\
+static void prof_sysenter_disable_##sname(void)				       \
 {									       \
-	if (atomic_add_negative(-1, &event_enter_##sname.profile_count))       \
-		unreg_prof_syscall_enter("sys"#sname);			       \
+	unreg_prof_syscall_enter("sys"#sname);				       \
 }
 
 #define TRACE_SYS_EXIT_PROFILE(sname)					       \
-static int prof_sysexit_enable_##sname(struct ftrace_event_call *event_call)   \
+static int prof_sysexit_enable_##sname(void)				       \
 {									       \
-	int ret = 0;							       \
-	if (!atomic_inc_return(&event_exit_##sname.profile_count))	       \
-		ret = reg_prof_syscall_exit("sys"#sname);		       \
-	return ret;							       \
+	return reg_prof_syscall_exit("sys"#sname);			       \
 }									       \
 									       \
-static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
+static void prof_sysexit_disable_##sname(void)				       \
 {                                                                              \
-	if (atomic_add_negative(-1, &event_exit_##sname.profile_count))	       \
-		unreg_prof_syscall_exit("sys"#sname);			       \
+	unreg_prof_syscall_exit("sys"#sname);				       \
 }
 
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 72a3b43..a822087 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -382,20 +382,14 @@ static inline int ftrace_get_offsets_##call(				\
  *
  * NOTE: The insertion profile callback (ftrace_profile_<call>) is defined later
  *
- * static int ftrace_profile_enable_<call>(struct ftrace_event_call *event_call)
+ * static int ftrace_profile_enable_<call>(void)
  * {
- * 	int ret = 0;
- *
- * 	if (!atomic_inc_return(&event_call->profile_count))
- * 		ret = register_trace_<call>(ftrace_profile_<call>);
- *
- * 	return ret;
+ * 	return register_trace_<call>(ftrace_profile_<call>);
  * }
  *
- * static void ftrace_profile_disable_<call>(struct ftrace_event_call *event_call)
+ * static void ftrace_profile_disable_<call>(void)
  * {
- * 	if (atomic_add_negative(-1, &event->call->profile_count))
- * 		unregister_trace_<call>(ftrace_profile_<call>);
+ * 	unregister_trace_<call>(ftrace_profile_<call>);
  * }
  *
  */
@@ -405,20 +399,14 @@ static inline int ftrace_get_offsets_##call(				\
 									\
 static void ftrace_profile_##call(proto);				\
 									\
-static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
+static int ftrace_profile_enable_##call(void)				\
 {									\
-	int ret = 0;							\
-									\
-	if (!atomic_inc_return(&event_call->profile_count))		\
-		ret = register_trace_##call(ftrace_profile_##call);	\
-									\
-	return ret;							\
+	return register_trace_##call(ftrace_profile_##call);		\
 }									\
 									\
-static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
+static void ftrace_profile_disable_##call(void)				\
 {									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
-		unregister_trace_##call(ftrace_profile_##call);		\
+	unregister_trace_##call(ftrace_profile_##call);			\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 55a25c9..df4a74e 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -8,6 +8,14 @@
 #include <linux/module.h>
 #include "trace.h"
 
+static int ftrace_profile_enable_event(struct ftrace_event_call *event)
+{
+	if (atomic_inc_return(&event->profile_count))
+		return 0;
+
+	return event->profile_enable();
+}
+
 int ftrace_profile_enable(int event_id)
 {
 	struct ftrace_event_call *event;
@@ -17,7 +25,7 @@ int ftrace_profile_enable(int event_id)
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id && event->profile_enable &&
 		    try_module_get(event->mod)) {
-			ret = event->profile_enable(event);
+			ret = ftrace_profile_enable_event(event);
 			break;
 		}
 	}
@@ -26,6 +34,14 @@ int ftrace_profile_enable(int event_id)
 	return ret;
 }
 
+static void ftrace_profile_disable_event(struct ftrace_event_call *event)
+{
+	if (!atomic_add_negative(-1, &event->profile_count))
+		return;
+
+	event->profile_disable();
+}
+
 void ftrace_profile_disable(int event_id)
 {
 	struct ftrace_event_call *event;
@@ -33,7 +49,7 @@ void ftrace_profile_disable(int event_id)
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
 		if (event->id == event_id) {
-			event->profile_disable(event);
+			ftrace_profile_disable_event(event);
 			module_put(event->mod);
 			break;
 		}
-- 
1.6.2.3

