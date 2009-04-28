Return-Path: <linux-kernel-owner+w=401wt.eu-S932292AbZD1IFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbZD1IFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZD1IEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:04:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:60877 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbZD1IEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:04:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=mY5hUxlaIr+QLh5s8NPQfx4X6yHQPWXKn7I6ZooEghseoKIWYyKbAk8JseLINjhPfp
         8tc/KuOoOVFiVKHvJCZIjN0pRyyJmGt/vjtvsNSBwW5lOLHB+yRqg0GuhgMr97a13wa/
         rfKqyCmv7hHVuaN50D5W3MFpp9r4aa2ASlrvQ=
Subject: [PATCH 1/3] tracing/filters: move preds into event_filter object
From: Tom Zanussi <tzanussi@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 03:04:47 -0500
Message-Id: <1240905887.6416.119.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new event_filter object, and move the pred-related members
out of the call and subsystem objects and into the filter object - the
details of the filter implementation don't need to be exposed in the
call and subsystem in any case, and it will also help make the new
parser implementation a little cleaner.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 include/linux/ftrace_event.h       |    4 +-
 kernel/trace/trace.h               |   10 ++-
 kernel/trace/trace_events.c        |    3 +-
 kernel/trace/trace_events_filter.c |  107 ++++++++++++++++++++++--------------
 4 files changed, 76 insertions(+), 48 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 78a9ba2..46a27f2 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -101,8 +101,8 @@ struct ftrace_event_call {
 	int			(*show_format)(struct trace_seq *s);
 	int			(*define_fields)(void);
 	struct list_head	fields;
-	int			n_preds;
-	struct filter_pred	**preds;
+	int			filter_active;
+	void			*filter;
 	void			*mod;
 
 #ifdef CONFIG_EVENT_PROFILE
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3e5c664..11ef8ec 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -733,12 +733,16 @@ struct ftrace_event_field {
 	int			size;
 };
 
+struct event_filter {
+	int			n_preds;
+	struct filter_pred	**preds;
+};
+
 struct event_subsystem {
 	struct list_head	list;
 	const char		*name;
 	struct dentry		*entry;
-	int			n_preds;
-	struct filter_pred	**preds;
+	void			*filter;
 };
 
 struct filter_pred;
@@ -776,7 +780,7 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->n_preds) && !filter_match_preds(call, rec)) {
+	if (unlikely(call->filter_active) && !filter_match_preds(call, rec)) {
 		ring_buffer_discard_commit(buffer, event);
 		return 1;
 	}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cc0ecb9..2de652d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -757,8 +757,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	list_add(&system->list, &event_subsystems);
 
-	system->preds = NULL;
-	system->n_preds = 0;
+	system->filter = NULL;
 
 	entry = debugfs_create_file("filter", 0644, system->entry, system,
 				    &ftrace_subsystem_filter_fops);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 6541828..1e861ec 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -93,11 +93,12 @@ static int filter_pred_none(struct filter_pred *pred, void *event)
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct ftrace_event_call *call, void *rec)
 {
+	struct event_filter *filter = call->filter;
 	int i, matched, and_failed = 0;
 	struct filter_pred *pred;
 
-	for (i = 0; i < call->n_preds; i++) {
-		pred = call->preds[i];
+	for (i = 0; i < filter->n_preds; i++) {
+		pred = filter->preds[i];
 		if (and_failed && !pred->or)
 			continue;
 		matched = pred->fn(pred, rec);
@@ -115,20 +116,20 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
-static void __filter_print_preds(struct filter_pred **preds, int n_preds,
+static void __filter_print_preds(struct event_filter *filter,
 				 struct trace_seq *s)
 {
-	char *field_name;
 	struct filter_pred *pred;
+	char *field_name;
 	int i;
 
-	if (!n_preds) {
+	if (!filter || !filter->n_preds) {
 		trace_seq_printf(s, "none\n");
 		return;
 	}
 
-	for (i = 0; i < n_preds; i++) {
-		pred = preds[i];
+	for (i = 0; i < filter->n_preds; i++) {
+		pred = filter->preds[i];
 		field_name = pred->field_name;
 		if (i)
 			trace_seq_printf(s, pred->or ? "|| " : "&& ");
@@ -144,7 +145,7 @@ static void __filter_print_preds(struct filter_pred **preds, int n_preds,
 void filter_print_preds(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	mutex_lock(&filter_mutex);
-	__filter_print_preds(call->preds, call->n_preds, s);
+	__filter_print_preds(call->filter, s);
 	mutex_unlock(&filter_mutex);
 }
 
@@ -152,7 +153,7 @@ void filter_print_subsystem_preds(struct event_subsystem *system,
 				  struct trace_seq *s)
 {
 	mutex_lock(&filter_mutex);
-	__filter_print_preds(system->preds, system->n_preds, s);
+	__filter_print_preds(system->filter, s);
 	mutex_unlock(&filter_mutex);
 }
 
@@ -200,12 +201,14 @@ static int filter_set_pred(struct filter_pred *dest,
 
 static void __filter_disable_preds(struct ftrace_event_call *call)
 {
+	struct event_filter *filter = call->filter;
 	int i;
 
-	call->n_preds = 0;
+	call->filter_active = 0;
+	filter->n_preds = 0;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++)
-		call->preds[i]->fn = filter_pred_none;
+		filter->preds[i]->fn = filter_pred_none;
 }
 
 void filter_disable_preds(struct ftrace_event_call *call)
@@ -217,32 +220,39 @@ void filter_disable_preds(struct ftrace_event_call *call)
 
 int init_preds(struct ftrace_event_call *call)
 {
+	struct event_filter *filter;
 	struct filter_pred *pred;
 	int i;
 
-	call->n_preds = 0;
-
-	call->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
-	if (!call->preds)
+	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (!call->filter)
 		return -ENOMEM;
 
+	call->filter_active = 0;
+	filter->n_preds = 0;
+
+	filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
+	if (!filter->preds)
+		goto oom;
+
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
 		pred = kzalloc(sizeof(*pred), GFP_KERNEL);
 		if (!pred)
 			goto oom;
 		pred->fn = filter_pred_none;
-		call->preds[i] = pred;
+		filter->preds[i] = pred;
 	}
 
 	return 0;
 
 oom:
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (call->preds[i])
-			filter_free_pred(call->preds[i]);
+		if (filter->preds[i])
+			filter_free_pred(filter->preds[i]);
 	}
-	kfree(call->preds);
-	call->preds = NULL;
+	kfree(filter->preds);
+	kfree(call->filter);
+	call->filter = NULL;
 
 	return -ENOMEM;
 }
@@ -250,15 +260,16 @@ EXPORT_SYMBOL_GPL(init_preds);
 
 static void __filter_free_subsystem_preds(struct event_subsystem *system)
 {
+	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 	int i;
 
-	if (system->n_preds) {
-		for (i = 0; i < system->n_preds; i++)
-			filter_free_pred(system->preds[i]);
-		kfree(system->preds);
-		system->preds = NULL;
-		system->n_preds = 0;
+	if (filter && filter->n_preds) {
+		for (i = 0; i < filter->n_preds; i++)
+			filter_free_pred(filter->preds[i]);
+		kfree(filter->preds);
+		kfree(filter);
+		system->filter = NULL;
 	}
 
 	list_for_each_entry(call, &ftrace_events, list) {
@@ -281,21 +292,23 @@ static int filter_add_pred_fn(struct ftrace_event_call *call,
 			      struct filter_pred *pred,
 			      filter_pred_fn_t fn)
 {
+	struct event_filter *filter = call->filter;
 	int idx, err;
 
-	if (call->n_preds && !pred->compound)
+	if (filter->n_preds && !pred->compound)
 		__filter_disable_preds(call);
 
-	if (call->n_preds == MAX_FILTER_PRED)
+	if (filter->n_preds == MAX_FILTER_PRED)
 		return -ENOSPC;
 
-	idx = call->n_preds;
-	filter_clear_pred(call->preds[idx]);
-	err = filter_set_pred(call->preds[idx], pred, fn);
+	idx = filter->n_preds;
+	filter_clear_pred(filter->preds[idx]);
+	err = filter_set_pred(filter->preds[idx], pred, fn);
 	if (err)
 		return err;
 
-	call->n_preds++;
+	filter->n_preds++;
+	call->filter_active = 1;
 
 	return 0;
 }
@@ -366,29 +379,41 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
 int filter_add_subsystem_pred(struct event_subsystem *system,
 			      struct filter_pred *pred)
 {
+	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 
 	mutex_lock(&filter_mutex);
 
-	if (system->n_preds && !pred->compound)
+	if (filter && filter->n_preds && !pred->compound) {
 		__filter_free_subsystem_preds(system);
+		filter = NULL;
+	}
 
-	if (!system->n_preds) {
-		system->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
+	if (!filter) {
+		system->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+		if (!system->filter) {
+			mutex_unlock(&filter_mutex);
+			return -ENOMEM;
+		}
+		filter = system->filter;
+		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
 					GFP_KERNEL);
-		if (!system->preds) {
+
+		if (!filter->preds) {
+			kfree(system->filter);
+			system->filter = NULL;
 			mutex_unlock(&filter_mutex);
 			return -ENOMEM;
 		}
 	}
 
-	if (system->n_preds == MAX_FILTER_PRED) {
+	if (filter->n_preds == MAX_FILTER_PRED) {
 		mutex_unlock(&filter_mutex);
 		return -ENOSPC;
 	}
 
-	system->preds[system->n_preds] = pred;
-	system->n_preds++;
+	filter->preds[filter->n_preds] = pred;
+	filter->n_preds++;
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		int err;
@@ -401,8 +426,8 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 
 		err = __filter_add_pred(call, pred);
 		if (err == -ENOMEM) {
-			system->preds[system->n_preds] = NULL;
-			system->n_preds--;
+			filter->preds[filter->n_preds] = NULL;
+			filter->n_preds--;
 			mutex_unlock(&filter_mutex);
 			return err;
 		}
-- 
1.5.6.3



