Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZCVWMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZCVWMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbZCVWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:10:56 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53444 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbZCVWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oCmVPqOWqjk7iMgymH6gI9SSPS7woYXD440dBHlzg2DxYjuYWNQMiBq0M+YMo+Nttu
         t1CVGTR0sOJ7GGsRoE8Kq/AiaxErnGRpaJICZN6nX11kVYN/u52JlNdxes/KFxtUpzs1
         26kZjwtG7lzrINTuQWBh3ERQ6aCACY9RHvS8g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] tracing/events: don't use wake up for events
Date: Sun, 22 Mar 2009 23:10:46 +0100
Message-Id: <1237759847-21025-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix hard lockup with sched switch events

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
---
 kernel/trace/trace.c                |   26 +++++++++++++++++++++-----
 kernel/trace/trace.h                |    2 ++
 kernel/trace/trace_events_stage_3.h |    2 +-
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f0e1337..8dddb42 100644
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
-- 
1.6.1

