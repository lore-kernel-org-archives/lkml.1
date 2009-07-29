Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZG2RNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZG2RNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbZG2RNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:13:40 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:63379 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZG2RNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tIc0t0BeiLuj4kFOImeAKIJx4zQ5cpA05npJi/oLY6FZSJYslIZaAJY6Qe1DVOAmLH
         tuClWdzNW8e57w/VE6sQfqLJtXWZAZ5tzkGiIX/KCSLVTXzVvvvEmRbQ7VUbF46cI5Ev
         oxiv8aeoZ+wP6IBHp8ehg4RsSDa9bIjKdRYC8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/6] tracing/core: Make the stack entry helpers global
Date: Wed, 29 Jul 2009 19:13:27 +0200
Message-Id: <1248887609-5147-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
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
index 769d5cf..d126c88 100644
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
@@ -978,11 +974,11 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
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
@@ -1003,12 +999,10 @@ static void __ftrace_trace_stack(struct trace_array *tr,
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
@@ -1016,17 +1010,14 @@ static void ftrace_trace_stack(struct trace_array *tr,
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
@@ -1051,7 +1042,6 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	save_stack_trace_user(&trace);
 	if (!filter_check_discard(call, entry, tr->buffer, event))
 		ring_buffer_unlock_commit(tr->buffer, event);
-#endif
 }
 
 #ifdef UNUSED
@@ -1061,6 +1051,8 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 }
 #endif /* UNUSED */
 
+#endif /* CONFIG_STACKTRACE */
+
 static void
 ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 186543a..e5802a2 100644
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

