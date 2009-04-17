Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbZDQRHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbZDQRHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbZDQRHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:07:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:37217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761194AbZDQRH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:07:28 -0400
Date: Fri, 17 Apr 2009 17:06:35 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239946028.6639.13.camel@tropicana>
References: <1239946028.6639.13.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: add filter_mutex to protect filter predicates
Message-ID: <tip-ac1adc55fc71c7515caa2eb0e63e49b3d1c6a47c@git.kernel.org>
Git-Commit-ID: ac1adc55fc71c7515caa2eb0e63e49b3d1c6a47c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 17:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac1adc55fc71c7515caa2eb0e63e49b3d1c6a47c
Gitweb:     http://git.kernel.org/tip/ac1adc55fc71c7515caa2eb0e63e49b3d1c6a47c
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Fri, 17 Apr 2009 00:27:08 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 18:28:27 +0200

tracing/filters: add filter_mutex to protect filter predicates

This patch adds a filter_mutex to prevent the filter predicates from
being accessed concurrently by various external functions.

It's based on a previous patch by Li Zefan:
        "[PATCH 7/7] tracing/filters: make filter preds RCU safe"

v2 changes:

- fixed wrong value returned in a add_subsystem_pred() failure case
  noticed by Li Zefan.

[ Impact: fix trace filter corruption/crashes on parallel access ]

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com
LKML-Reference: <1239946028.6639.13.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.h               |    4 +-
 kernel/trace/trace_events.c        |    4 +-
 kernel/trace/trace_events_filter.c |   90 ++++++++++++++++++++++++++++--------
 3 files changed, 75 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8817c18..247948e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -757,13 +757,15 @@ struct filter_pred {
 };
 
 extern void filter_free_pred(struct filter_pred *pred);
-extern void filter_print_preds(struct filter_pred **preds, int n_preds,
+extern void filter_print_preds(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int filter_parse(char **pbuf, struct filter_pred *pred);
 extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_disable_preds(struct ftrace_event_call *call);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
+extern void filter_print_subsystem_preds(struct event_subsystem *system,
+					 struct trace_seq *s);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1137f95..64f9d6d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -488,7 +488,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(call->preds, call->n_preds, s);
+	filter_print_preds(call, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
@@ -558,7 +558,7 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	filter_print_preds(system->preds, system->n_preds, s);
+	filter_print_subsystem_preds(system, s);
 	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f8e5eab..e0fcfd2 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -22,10 +22,13 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
+#include <linux/mutex.h>
 
 #include "trace.h"
 #include "trace_output.h"
 
+static DEFINE_MUTEX(filter_mutex);
+
 static int filter_pred_64(struct filter_pred *pred, void *event)
 {
 	u64 *addr = (u64 *)(event + pred->offset);
@@ -112,8 +115,8 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
-void filter_print_preds(struct filter_pred **preds, int n_preds,
-			struct trace_seq *s)
+static void __filter_print_preds(struct filter_pred **preds, int n_preds,
+				 struct trace_seq *s)
 {
 	char *field_name;
 	struct filter_pred *pred;
@@ -138,6 +141,21 @@ void filter_print_preds(struct filter_pred **preds, int n_preds,
 	}
 }
 
+void filter_print_preds(struct ftrace_event_call *call, struct trace_seq *s)
+{
+	mutex_lock(&filter_mutex);
+	__filter_print_preds(call->preds, call->n_preds, s);
+	mutex_unlock(&filter_mutex);
+}
+
+void filter_print_subsystem_preds(struct event_subsystem *system,
+				  struct trace_seq *s)
+{
+	mutex_lock(&filter_mutex);
+	__filter_print_preds(system->preds, system->n_preds, s);
+	mutex_unlock(&filter_mutex);
+}
+
 static struct ftrace_event_field *
 find_event_field(struct ftrace_event_call *call, char *name)
 {
@@ -180,7 +198,7 @@ static int filter_set_pred(struct filter_pred *dest,
 	return 0;
 }
 
-void filter_disable_preds(struct ftrace_event_call *call)
+static void __filter_disable_preds(struct ftrace_event_call *call)
 {
 	int i;
 
@@ -190,6 +208,13 @@ void filter_disable_preds(struct ftrace_event_call *call)
 		call->preds[i]->fn = filter_pred_none;
 }
 
+void filter_disable_preds(struct ftrace_event_call *call)
+{
+	mutex_lock(&filter_mutex);
+	__filter_disable_preds(call);
+	mutex_unlock(&filter_mutex);
+}
+
 int init_preds(struct ftrace_event_call *call)
 {
 	struct filter_pred *pred;
@@ -223,7 +248,7 @@ oom:
 }
 EXPORT_SYMBOL_GPL(init_preds);
 
-void filter_free_subsystem_preds(struct event_subsystem *system)
+static void __filter_free_subsystem_preds(struct event_subsystem *system)
 {
 	struct ftrace_event_call *call;
 	int i;
@@ -241,18 +266,25 @@ void filter_free_subsystem_preds(struct event_subsystem *system)
 			continue;
 
 		if (!strcmp(call->system, system->name))
-			filter_disable_preds(call);
+			__filter_disable_preds(call);
 	}
 }
 
-static int __filter_add_pred(struct ftrace_event_call *call,
-			     struct filter_pred *pred,
-			     filter_pred_fn_t fn)
+void filter_free_subsystem_preds(struct event_subsystem *system)
+{
+	mutex_lock(&filter_mutex);
+	__filter_free_subsystem_preds(system);
+	mutex_unlock(&filter_mutex);
+}
+
+static int filter_add_pred_fn(struct ftrace_event_call *call,
+			      struct filter_pred *pred,
+			      filter_pred_fn_t fn)
 {
 	int idx, err;
 
 	if (call->n_preds && !pred->compound)
-		filter_disable_preds(call);
+		__filter_disable_preds(call);
 
 	if (call->n_preds == MAX_FILTER_PRED)
 		return -ENOSPC;
@@ -276,7 +308,8 @@ static int is_string_field(const char *type)
 	return 0;
 }
 
-int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
+static int __filter_add_pred(struct ftrace_event_call *call,
+			     struct filter_pred *pred)
 {
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
@@ -293,7 +326,7 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 			return -EINVAL;
 		fn = filter_pred_string;
 		pred->str_len = field->size;
-		return __filter_add_pred(call, pred, fn);
+		return filter_add_pred_fn(call, pred, fn);
 	} else {
 		if (pred->str_len)
 			return -EINVAL;
@@ -316,7 +349,18 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 		return -EINVAL;
 	}
 
-	return __filter_add_pred(call, pred, fn);
+	return filter_add_pred_fn(call, pred, fn);
+}
+
+int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
+{
+	int err;
+
+	mutex_lock(&filter_mutex);
+	err = __filter_add_pred(call, pred);
+	mutex_unlock(&filter_mutex);
+
+	return err;
 }
 
 int filter_add_subsystem_pred(struct event_subsystem *system,
@@ -324,20 +368,27 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 {
 	struct ftrace_event_call *call;
 
+	mutex_lock(&filter_mutex);
+
 	if (system->n_preds && !pred->compound)
-		filter_free_subsystem_preds(system);
+		__filter_free_subsystem_preds(system);
 
 	if (!system->n_preds) {
 		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
 					GFP_KERNEL);
-		if (!system->preds)
+		if (!system->preds) {
+			mutex_unlock(&filter_mutex);
 			return -ENOMEM;
+		}
 	}
 
-	if (system->n_preds == MAX_FILTER_PRED)
+	if (system->n_preds == MAX_FILTER_PRED) {
+		mutex_unlock(&filter_mutex);
 		return -ENOSPC;
+	}
 
 	system->preds[system->n_preds] = pred;
+	system->n_preds++;
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		int err;
@@ -348,17 +399,16 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 		if (strcmp(call->system, system->name))
 			continue;
 
-		if (!find_event_field(call, pred->field_name))
-			continue;
-
-		err = filter_add_pred(call, pred);
+		err = __filter_add_pred(call, pred);
 		if (err == -ENOMEM) {
 			system->preds[system->n_preds] = NULL;
+			system->n_preds--;
+			mutex_unlock(&filter_mutex);
 			return err;
 		}
 	}
 
-	system->n_preds++;
+	mutex_unlock(&filter_mutex);
 
 	return 0;
 }
