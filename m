Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbZCWIb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbZCWIb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbZCWIbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:31:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:51626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbZCWIbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:31:36 -0400
Date: Mon, 23 Mar 2009 08:30:52 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237759847-21025-4-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/filters] tracing/events: don't use wake up for events
Message-ID: <tip-07edf7121374609709ef1b0889f6e7b8d6a62ec1@git.kernel.org>
Git-Commit-ID: 07edf7121374609709ef1b0889f6e7b8d6a62ec1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:30:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07edf7121374609709ef1b0889f6e7b8d6a62ec1
Gitweb:     http://git.kernel.org/tip/07edf7121374609709ef1b0889f6e7b8d6a62ec1
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 23:10:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:22:14 +0100

tracing/events: don't use wake up for events

Impact: fix hard-lockup with sched switch events

Some ftrace events, such as sched wakeup, can be traced
while the runqueue lock is hold. Since they are using
trace_current_buffer_unlock_commit(), they call wake_up()
which can try to grab the runqueue lock too, resulting in
a deadlock.

Now for all event, we call a new helper:
trace_nowake_buffer_unlock_commit() which do pretty the same than
trace_current_buffer_unlock_commit() except than it doesn't call
trace_wake_up().

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237759847-21025-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c                |   26 +++++++++++++++++++++-----
 kernel/trace/trace.h                |    2 ++
 kernel/trace/trace_events_stage_3.h |    2 +-
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e6fac0f..6bad128 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -860,15 +860,25 @@ static void ftrace_trace_stack(struct trace_array *tr,
 static void ftrace_trace_userstack(struct trace_array *tr,
 				   unsigned long flags, int pc);
 
-void trace_buffer_unlock_commit(struct trace_array *tr,
-				struct ring_buffer_event *event,
-				unsigned long flags, int pc)
+static inline void __trace_buffer_unlock_commit(struct trace_array *tr,
+					struct ring_buffer_event *event,
+					unsigned long flags, int pc,
+					int wake)
 {
 	ring_buffer_unlock_commit(tr->buffer, event);
 
 	ftrace_trace_stack(tr, flags, 6, pc);
 	ftrace_trace_userstack(tr, flags, pc);
-	trace_wake_up();
+
+	if (wake)
+		trace_wake_up();
+}
+
+void trace_buffer_unlock_commit(struct trace_array *tr,
+					struct ring_buffer_event *event,
+					unsigned long flags, int pc)
+{
+	__trace_buffer_unlock_commit(tr, event, flags, pc, 1);
 }
 
 struct ring_buffer_event *
@@ -882,7 +892,13 @@ trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
 void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	return trace_buffer_unlock_commit(&global_trace, event, flags, pc);
+	return __trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
+}
+
+void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc)
+{
+	return __trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
 }
 
 void
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f267723..54fd9bc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -483,6 +483,8 @@ trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
 				  unsigned long flags, int pc);
 void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc);
+void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
+					unsigned long flags, int pc);
 
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index ebf215e..9a3bd49 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -222,7 +222,7 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	trace_current_buffer_unlock_commit(event, irq_flags, pc);	\
+	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
 									\
 	if (call->preds && !filter_match_preds(call, entry))		\
 		ring_buffer_event_discard(event);			\
