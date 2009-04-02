Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbZDBG3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbZDBG3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZDBG2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:28:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:52355 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZDBG2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=m7d662rh75xiOtWXlW4turTXJY2IW5cZbp/zoRVJyPO6bFZFXBKW2vK1LgmwYrqblh
         zDP7WiPMTz0MFMXHFl9xWvJmu4mYWtWPLnRulxi+8BJ5t+sIjmZbKTojy5dsGkdx0jpQ
         18FCjcfT8zjO58Jg+4m41Ywlt7qP5DyJjAvAs=
Subject: [PATCH] tracing/filters: protect current event filter users from
 filter removal
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Content-Type: text/plain
Date: Thu, 02 Apr 2009 01:28:47 -0500
Message-Id: <1238653727.6655.61.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows event filters to be removed even if tracing is active.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace.h                |    9 +++++++--
 kernel/trace/trace_events_filter.c  |   15 +++++++++------
 kernel/trace/trace_events_stage_3.h |    3 +--
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9dcbc97..6bd728f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -847,7 +847,7 @@ extern int filter_parse(char **pbuf, struct filter_pred *pred);
 extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_free_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_match_preds(struct filter_pred **preds, void *rec);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
@@ -856,8 +856,13 @@ static inline void
 filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->preds) && !filter_match_preds(call, rec))
+	struct filter_pred **preds;
+
+	rcu_read_lock();
+	preds = rcu_dereference(call->preds);
+	if (unlikely(preds) && !filter_match_preds(preds, rec))
 		ring_buffer_event_discard(event);
+	rcu_read_unlock();
 }
 
 #define __common_field(type, item)					\
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 470ad94..f7f8469 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -83,14 +83,14 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
 }
 
 /* return 1 if event matches, 0 otherwise (discard) */
-int filter_match_preds(struct ftrace_event_call *call, void *rec)
+int filter_match_preds(struct filter_pred **preds, void *rec)
 {
 	int i, matched, and_failed = 0;
 	struct filter_pred *pred;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (call->preds[i]) {
-			pred = call->preds[i];
+		if (preds[i]) {
+			pred = preds[i];
 			if (and_failed && !pred->or)
 				continue;
 			matched = pred->fn(pred, rec);
@@ -162,13 +162,16 @@ void filter_free_pred(struct filter_pred *pred)
 
 void filter_free_preds(struct ftrace_event_call *call)
 {
+	struct filter_pred **preds;
 	int i;
 
 	if (call->preds) {
+		preds = call->preds;
+		rcu_assign_pointer(call->preds, NULL);
+		synchronize_rcu();
 		for (i = 0; i < MAX_FILTER_PRED; i++)
-			filter_free_pred(call->preds[i]);
-		kfree(call->preds);
-		call->preds = NULL;
+			filter_free_pred(preds[i]);
+		kfree(preds);
 	}
 }
 
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 9d2fa78..cca3843 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -222,8 +222,7 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	if (call->preds && !filter_match_preds(call, entry))		\
-		ring_buffer_event_discard(event);			\
+	filter_check_discard(call, entry, event);			\
 									\
 	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
 									\
-- 
1.5.6.3



