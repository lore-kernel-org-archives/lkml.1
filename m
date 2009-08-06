Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZHFG17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZHFG17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbZHFG15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:27:57 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:38906 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZHFG1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:27:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t2dgXAE4WR8F0BXZTl7QVS3GzGmLRrESC9vKq25/RaBJFpsf4+/s/APPpJA7g46aC4
         eDXMG6bdeVyIrgtFdC7MpvXC6WGVdEz5gpQHwTLndU8kXdXX0OKctvZXlEFYnR3fEFgF
         uAE7PMx85U4r02UjPqMf5AVknbOqjn7JYIvzQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/7] tracing/core: Make the stack entry helpers global
Date: Thu,  6 Aug 2009 08:27:35 +0200
Message-Id: <1249540058-5528-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090802195312.GA18598@elte.hu>
References: <20090802195312.GA18598@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the stacktrace event insertion helpers globals.
This has two effects:

- Prepare for moving the sched events insertion helpers to
  the sched switch tracer file.
- Move some ifdef outside function definitions

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   24 ++++++++----------------
 kernel/trace/trace.h |   28 +++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b6211d6..d6059a4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -866,10 +866,6 @@ struct ring_buffer_event *trace_buffer_lock_reserve(struct trace_array *tr,
 
 	return event;
 }
-static void ftrace_trace_stack(struct trace_array *tr,
-			       unsigned long flags, int skip, int pc);
-static void ftrace_trace_userstack(struct trace_array *tr,
-				   unsigned long flags, int pc);
 
 static inline void __trace_buffer_unlock_commit(struct trace_array *tr,
 					struct ring_buffer_event *event,
@@ -1003,11 +999,11 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 		trace_function(tr, ip, parent_ip, flags, pc);
 }
 
+#ifdef CONFIG_STACKTRACE
 static void __ftrace_trace_stack(struct trace_array *tr,
 				 unsigned long flags,
 				 int skip, int pc)
 {
-#ifdef CONFIG_STACKTRACE
 	struct ftrace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
 	struct stack_entry *entry;
@@ -1028,12 +1024,10 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	save_stack_trace(&trace);
 	if (!filter_check_discard(call, entry, tr->buffer, event))
 		ring_buffer_unlock_commit(tr->buffer, event);
-#endif
 }
 
-static void ftrace_trace_stack(struct trace_array *tr,
-			       unsigned long flags,
-			       int skip, int pc)
+void ftrace_trace_stack(struct trace_array *tr, unsigned long flags, int skip,
+			int pc)
 {
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
@@ -1041,17 +1035,14 @@ static void ftrace_trace_stack(struct trace_array *tr,
 	__ftrace_trace_stack(tr, flags, skip, pc);
 }
 
-void __trace_stack(struct trace_array *tr,
-		   unsigned long flags,
-		   int skip, int pc)
+void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
+		   int pc)
 {
 	__ftrace_trace_stack(tr, flags, skip, pc);
 }
 
-static void ftrace_trace_userstack(struct trace_array *tr,
-				   unsigned long flags, int pc)
+void ftrace_trace_userstack(struct trace_array *tr, unsigned long flags, int pc)
 {
-#ifdef CONFIG_STACKTRACE
 	struct ftrace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
@@ -1076,7 +1067,6 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	save_stack_trace_user(&trace);
 	if (!filter_check_discard(call, entry, tr->buffer, event))
 		ring_buffer_unlock_commit(tr->buffer, event);
-#endif
 }
 
 #ifdef UNUSED
@@ -1086,6 +1076,8 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 }
 #endif /* UNUSED */
 
+#endif /* CONFIG_STACKTRACE */
+
 static void
 ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c7e9273..116524d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -489,9 +489,31 @@ void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
 
-void __trace_stack(struct trace_array *tr,
-		   unsigned long flags,
-		   int skip, int pc);
+#ifdef CONFIG_STACKTRACE
+void ftrace_trace_stack(struct trace_array *tr, unsigned long flags,
+			int skip, int pc);
+
+void ftrace_trace_userstack(struct trace_array *tr, unsigned long flags,
+			    int pc);
+
+void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
+		   int pc);
+#else
+static inline void ftrace_trace_stack(struct trace_array *tr,
+				      unsigned long flags, int skip, int pc)
+{
+}
+
+static inline void ftrace_trace_userstack(struct trace_array *tr,
+					  unsigned long flags, int pc)
+{
+}
+
+static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
+				 int skip, int pc)
+{
+}
+#endif /* CONFIG_STACKTRACE */
 
 extern cycle_t ftrace_now(int cpu);
 
-- 
1.6.2.3

