Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbZDKHze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbZDKHze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZDKHzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:55:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53494 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756837AbZDKHzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:55:07 -0400
Message-ID: <49E04D02.2080505@cn.fujitsu.com>
Date: Sat, 11 Apr 2009 15:55:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] tracing/filters: make filter preds RCU safe
References: <49E04C22.4040608@cn.fujitsu.com>
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed ftrace_event_call->preds and ->preds[*] are not protected
by any lock, and I can manage to trigger kernel oops.

This patch adds filter_mutex to protect concurrent access to
event_subsystem->preds/preds[i] or ftrace_event_call->preds/preds[i],
and make the fast-path filter_match_preds() RCU safe.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h                |    6 +-
 kernel/trace/trace_events.c         |    4 +-
 kernel/trace/trace_events_filter.c  |  104 +++++++++++++++++++++++++---------
 kernel/trace/trace_events_stage_3.h |   10 +++-
 4 files changed, 91 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e685ac2..ae05fbb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -847,13 +847,15 @@ struct filter_pred {
 int trace_define_field(struct ftrace_event_call *call, char *type,
 		       char *name, int offset, int size);
 extern void filter_free_pred(struct filter_pred *pred);
-extern void filter_print_preds(struct filter_pred **preds,
+extern void filter_print_preds(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int filter_parse(char **pbuf, struct filter_pred *pred);
 extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_free_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_match_preds(struct filter_pred **preds, void *rec);
+extern void filter_print_subsystem_preds(struct event_subsystem *system,
+					 struct trace_seq *s);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 576f4fa..ca1a2b0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -481,7 +481,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(call->preds, s);
+	filter_print_preds(call, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -549,7 +549,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(system->preds, s);
+	filter_print_subsystem_preds(system, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f16a921..8e32dd8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -22,10 +22,14 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
 
 #include "trace.h"
 #include "trace_output.h"
 
+static DEFINE_MUTEX(filter_mutex);
+
 static int filter_pred_64(struct filter_pred *pred, void *event)
 {
 	u64 *addr = (u64 *)(event + pred->offset);
@@ -82,15 +86,19 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
 	return match;
 }
 
-/* return 1 if event matches, 0 otherwise (discard) */
-int filter_match_preds(struct ftrace_event_call *call, void *rec)
+/*
+ * return 1 if event matches, 0 otherwise (discard)
+ *
+ * should be protected by rcu_read_lock()
+ * */
+int filter_match_preds(struct filter_pred **preds, void *rec)
 {
 	int i, matched, and_failed = 0;
 	struct filter_pred *pred;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (call->preds[i]) {
-			pred = call->preds[i];
+		pred = rcu_dereference(preds[i]);
+		if (pred) {
 			if (and_failed && !pred->or)
 				continue;
 			matched = pred->fn(pred, rec);
@@ -109,7 +117,8 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
 	return 1;
 }
 
-void filter_print_preds(struct filter_pred **preds, struct trace_seq *s)
+static void __filter_print_preds(struct filter_pred **preds,
+				 struct trace_seq *s)
 {
 	char *field_name;
 	struct filter_pred *pred;
@@ -137,6 +146,21 @@ void filter_print_preds(struct filter_pred **preds, struct trace_seq *s)
 	}
 }
 
+void filter_print_preds(struct ftrace_event_call *call, struct trace_seq *s)
+{
+	mutex_lock(&filter_mutex);
+	__filter_print_preds(call->preds, s);
+	mutex_unlock(&filter_mutex);
+}
+
+void filter_print_subsystem_preds(struct event_subsystem *system,
+				  struct trace_seq *s)
+{
+	mutex_lock(&filter_mutex);
+	__filter_print_preds(system->preds, s);
+	mutex_unlock(&filter_mutex);
+}
+
 static struct ftrace_event_field *
 find_event_field(struct ftrace_event_call *call, char *name)
 {
@@ -160,29 +184,37 @@ void filter_free_pred(struct filter_pred *pred)
 	kfree(pred);
 }
 
-void filter_free_preds(struct ftrace_event_call *call)
+static void __filter_free_preds(struct filter_pred **preds)
 {
 	int i;
 
-	if (call->preds) {
-		for (i = 0; i < MAX_FILTER_PRED; i++)
-			filter_free_pred(call->preds[i]);
-		kfree(call->preds);
-		call->preds = NULL;
-	}
+	if (!preds)
+		return;
+
+	for (i = 0; i < MAX_FILTER_PRED; i++)
+		filter_free_pred(preds[i]);
+	kfree(preds);
+}
+
+void filter_free_preds(struct ftrace_event_call *call)
+{
+	struct filter_pred **preds = call->preds;
+
+	mutex_lock(&filter_mutex);
+	rcu_assign_pointer(call->preds, NULL);
+	mutex_unlock(&filter_mutex);
+
+	synchronize_rcu();
+	__filter_free_preds(preds);
 }
 
 void filter_free_subsystem_preds(struct event_subsystem *system)
 {
 	struct ftrace_event_call *call = __start_ftrace_events;
-	int i;
 
-	if (system->preds) {
-		for (i = 0; i < MAX_FILTER_PRED; i++)
-			filter_free_pred(system->preds[i]);
-		kfree(system->preds);
-		system->preds = NULL;
-	}
+	mutex_lock(&filter_mutex);
+	__filter_free_preds(system->preds);
+	mutex_unlock(&filter_mutex);
 
 	events_for_each(call) {
 		if (!call->name || !call->regfunc)
@@ -197,25 +229,35 @@ static int __filter_add_pred(struct ftrace_event_call *call,
 			     struct filter_pred *pred)
 {
 	int i;
+	int ret = 0;
+	struct filter_pred **preds;
 
-	if (call->preds && !pred->compound)
+	if (!pred->compound)
 		filter_free_preds(call);
 
+	mutex_lock(&filter_mutex);
+
 	if (!call->preds) {
-		call->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
-				      GFP_KERNEL);
-		if (!call->preds)
-			return -ENOMEM;
+		preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
+				GFP_KERNEL);
+		if (!preds) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+		rcu_assign_pointer(call->preds, preds);
 	}
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
 		if (!call->preds[i]) {
-			call->preds[i] = pred;
-			return 0;
+			rcu_assign_pointer(call->preds[i], pred);
+			goto unlock;
 		}
 	}
+	ret = -ENOSPC;
 
-	return -ENOSPC;
+unlock:
+	mutex_unlock(&filter_mutex);
+	return ret;
 }
 
 static int is_string_field(const char *type)
@@ -304,11 +346,15 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 	if (system->preds && !pred->compound)
 		filter_free_subsystem_preds(system);
 
+	mutex_lock(&filter_mutex);
+
 	if (!system->preds) {
 		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
 					GFP_KERNEL);
-		if (!system->preds)
+		if (!system->preds) {
+			mutex_unlock(&filter_mutex);
 			return -ENOMEM;
+		}
 	}
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
@@ -318,6 +364,8 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 		}
 	}
 
+	mutex_unlock(&filter_mutex);
+
 	if (i == MAX_FILTER_PRED)
 		return -ENOSPC;
 
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 9d2fa78..973941d 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -207,8 +207,10 @@ static void ftrace_raw_event_##call(proto)				\
 	struct ftrace_event_call *call = &event_##call;			\
 	struct ring_buffer_event *event;				\
 	struct ftrace_raw_##call *entry;				\
+	struct filter_pred **preds;					\
 	unsigned long irq_flags;					\
 	int pc;								\
+	int matched = 1;						\
 									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
@@ -222,7 +224,13 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	if (call->preds && !filter_match_preds(call, entry))		\
+	rcu_read_lock();						\
+	preds = rcu_dereference(call->preds);				\
+	if (preds)							\
+		matched = filter_match_preds(preds, entry);		\
+	rcu_read_unlock();						\
+									\
+	if (!matched)							\
 		ring_buffer_event_discard(event);			\
 									\
 	trace_nowake_buffer_unlock_commit(event, irq_flags, pc);	\
-- 
1.5.4.rc3

