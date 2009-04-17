Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbZDQF1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbZDQF1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZDQF1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:27:13 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:47282 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZDQF1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kkQa805bzKKsypup0RVUh2LGjdEHBIjThNt/SfhNKZCGpOLxjpgcV7heFswfhsMeFG
         uMD8pWA44n4jnfC5FmH2y0yVc6bzSNJMxeh7jCIe4/nwBlVxnt3w5BA124Rp1GMwqwUn
         4Iqw3dG1+xcBPSFosI6373x9Vv1HApWzo8+Rk=
Subject: [PATCH v2] tracing/filters: add filter_mutex to protect filter
 predicates
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com
Content-Type: text/plain
Date: Fri, 17 Apr 2009 00:27:08 -0500
Message-Id: <1239946028.6639.13.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a filter_mutex to prevent the filter predicates from
being accessed concurrently by various external functions.

It's based on a previous patch by Li Zefan:
        "[PATCH 7/7] tracing/filters: make filter preds RCU safe"

v2 changes:

- fixed wrong value returned in a add_subsystem_pred() failure case
noticed by Li Zefan.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace.h               |    4 +-
 kernel/trace/trace_events.c        |    4 +-
 kernel/trace/trace_events_filter.c |   90 ++++++++++++++++++++++++++++--------
 3 files changed, 75 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index eb92307..8750e83 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -759,13 +759,15 @@ struct filter_pred {
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
index 8af3534..e6d6404 100644
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
-- 
1.5.6.3



