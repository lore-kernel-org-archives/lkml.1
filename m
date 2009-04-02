Return-Path: <linux-kernel-owner+w=401wt.eu-S934638AbZDBFgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934638AbZDBFgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761553AbZDBFf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:35:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZDBFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:35:25 -0400
Message-Id: <20090402053522.834546042@goodmis.org>
References: <20090402052721.013878388@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 01:27:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/4] tracing/filters: use ring_buffer_discard_commit for discarded events
Content-Disposition: inline; filename=0004-tracing-filters-use-ring_buffer_discard_commit-for.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ring_buffer_discard_commit makes better usage of the ring_buffer
when an event has been discarded. It tries to remove it completely if
possible.

This patch converts the trace event filtering to use
ring_buffer_discard_commit instead of the ring_buffer_event_discard.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c                |    9 +++++++--
 kernel/trace/trace.h                |    1 +
 kernel/trace/trace_events_stage_3.h |    6 +++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8c27ac4..d89489c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -893,13 +893,18 @@ trace_current_buffer_lock_reserve(unsigned char type, unsigned long len,
 void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	return __trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
+	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 1);
 }
 
 void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc)
 {
-	return __trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
+	__trace_buffer_unlock_commit(&global_trace, event, flags, pc, 0);
+}
+
+void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
+{
+	ring_buffer_discard_commit(global_trace.buffer, event);
 }
 
 void
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 12316e3..c0d7a12 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -491,6 +491,7 @@ void trace_current_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc);
 void trace_nowake_buffer_unlock_commit(struct ring_buffer_event *event,
 					unsigned long flags, int pc);
+void trace_current_buffer_discard_commit(struct ring_buffer_event *event);
 
 struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 						struct trace_array_cpu *data);
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 9d2fa78..d2f34bf 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -223,9 +223,9 @@ static void ftrace_raw_event_##call(proto)				\
 	assign;								\
 									\
 	if (call->preds && !filter_match_preds(call, entry))		\
-		ring_buffer_event_discard(event);			\
-									\
-	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
+		trace_current_buffer_discard_commit(event);		\
+	else								\
+		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
 									\
 }									\
 									\
-- 
1.6.2.1

-- 
