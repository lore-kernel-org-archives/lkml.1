Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZIGIOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZIGIOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZIGIOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:14:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52989 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbZIGIOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:14:09 -0400
Message-ID: <4AA4C085.5050006@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:12:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] tracing/profile: Add filter support
References: <4AA4C04D.1050201@cn.fujitsu.com>
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add ftrace_profile_set_filter(), to set filter for a profile event

- filter is enabled when profile probe is registered

- filter is disabled when profile probe is unregistered

- in ftrace_profile_##call(), record events only when
  filter_match_preds() returns 1

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |   19 +++++-
 include/trace/ftrace.h             |   10 ++-
 kernel/trace/trace.h               |    8 ++-
 kernel/trace/trace_event_profile.c |   18 +++++
 kernel/trace/trace_events_filter.c |  135 ++++++++++++++++++++++++++++--------
 5 files changed, 156 insertions(+), 34 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 23f7179..44a7183 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -129,6 +129,10 @@ struct ftrace_event_call {
 	void			*mod;
 	void			*data;
 
+#ifdef CONFIG_EVENT_PROFILE
+	int			profile_filter_active;
+	struct event_filter	*profile_filter;
+#endif
 	atomic_t		profile_count;
 	int			(*profile_enable)(struct ftrace_event_call *);
 	void			(*profile_disable)(struct ftrace_event_call *);
@@ -138,12 +142,25 @@ struct ftrace_event_call {
 #define MAX_FILTER_STR_VAL	128
 
 extern void destroy_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_match_preds(struct event_filter *filter, void *rec);
 extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
 
+#ifdef CONFIG_EVENT_PROFILE
+extern void destroy_profile_preds(struct ftrace_event_call *call);
+
+static inline int
+profile_filter_check(struct ftrace_event_call *call, void *rec)
+{
+	if (likely(!call->profile_filter_active) ||
+	    filter_match_preds(call->profile_filter, rec))
+		return 1;
+	return 0;
+}
+#endif
+
 enum {
 	FILTER_OTHER = 0,
 	FILTER_STATIC_STRING,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 308bafd..da95201 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -417,8 +417,11 @@ static int ftrace_profile_enable_##call(struct ftrace_event_call *event_call) \
 									\
 static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
 {									\
-	if (atomic_add_negative(-1, &event_call->profile_count))	\
+	if (atomic_add_negative(-1, &event_call->profile_count)) {	\
 		unregister_trace_##call(ftrace_profile_##call);		\
+		tracepoint_synchronize_unregister();			\
+		destroy_profile_preds(event_call);			\
+	}								\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
@@ -742,8 +745,9 @@ static void ftrace_profile_##call(proto)				\
 									\
 		{ assign; }						\
 									\
-		perf_tpcounter_event(event_call->id, __addr, __count, entry,\
-			     __entry_size);				\
+		if (profile_filter_check(event_call, entry))		\
+			perf_tpcounter_event(event_call->id, __addr, __count, \
+					     entry, __entry_size);	\
 	} while (0);							\
 									\
 }
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2b47eba..751f996 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -817,6 +817,11 @@ struct filter_pred {
 	int pop_n;
 };
 
+#ifdef CONFIG_EVENT_PROFILE
+extern int apply_profile_filter(struct ftrace_event_call *call,
+				char *filter_string);
+#endif
+
 extern void print_event_filter(struct ftrace_event_call *call,
 			       struct trace_seq *s);
 extern int apply_event_filter(struct ftrace_event_call *call,
@@ -832,7 +837,8 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->filter_active) && !filter_match_preds(call, rec)) {
+	if (unlikely(call->filter_active)
+		&& !filter_match_preds(call->filter, rec)) {
 		ring_buffer_discard_commit(buffer, event);
 		return 1;
 	}
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 11ba5bb..ec6d4b0 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -37,3 +37,21 @@ void ftrace_profile_disable(int event_id)
 	}
 	mutex_unlock(&event_mutex);
 }
+
+int ftrace_profile_set_filter(int event_id, char *filter)
+{
+	struct ftrace_event_call *event;
+	int ret = -EINVAL;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(event, &ftrace_events, list) {
+		if (event->id == event_id) {
+			ret = apply_profile_filter(event, filter);
+			break;
+		}
+	}
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f9afbdf..1ab36b7 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -210,9 +210,8 @@ static int filter_pred_none(struct filter_pred *pred, void *event,
 }
 
 /* return 1 if event matches, 0 otherwise (discard) */
-int filter_match_preds(struct ftrace_event_call *call, void *rec)
+int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	struct event_filter *filter = call->filter;
 	int match, top = 0, val1 = 0, val2 = 0;
 	int stack[MAX_FILTER_PRED];
 	struct filter_pred *pred;
@@ -385,14 +384,10 @@ static void filter_disable_preds(struct ftrace_event_call *call)
 		filter->preds[i]->fn = filter_pred_none;
 }
 
-void destroy_preds(struct ftrace_event_call *call)
+static void __free_preds(struct event_filter *filter)
 {
-	struct event_filter *filter = call->filter;
 	int i;
 
-	if (!filter)
-		return;
-
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
 		if (filter->preds[i])
 			filter_free_pred(filter->preds[i]);
@@ -400,21 +395,27 @@ void destroy_preds(struct ftrace_event_call *call)
 	kfree(filter->preds);
 	kfree(filter->filter_string);
 	kfree(filter);
+}
+
+void destroy_preds(struct ftrace_event_call *call)
+{
+	if (!call->filter)
+		return;
+
+	__free_preds(call->filter);
 	call->filter = NULL;
+	call->filter_active = 0;
 }
 
-static int init_preds(struct ftrace_event_call *call)
+static struct event_filter *__alloc_preds(void)
 {
 	struct event_filter *filter;
 	struct filter_pred *pred;
 	int i;
 
-	if (call->filter)
-		return 0;
-
-	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
-	if (!call->filter)
-		return -ENOMEM;
+	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
+	if (!filter)
+		return ERR_PTR(-ENOMEM);
 
 	filter->n_preds = 0;
 
@@ -430,12 +431,23 @@ static int init_preds(struct ftrace_event_call *call)
 		filter->preds[i] = pred;
 	}
 
-	return 0;
+	return filter;
 
 oom:
-	destroy_preds(call);
+	__free_preds(filter);
+	return ERR_PTR(-ENOMEM);
+}
+
+static int init_preds(struct ftrace_event_call *call)
+{
+	if (call->filter)
+		return 0;
 
-	return -ENOMEM;
+	call->filter_active = 0;
+	call->filter = __alloc_preds();
+	if (IS_ERR(call->filter))
+		return PTR_ERR(call->filter);
+	return 0;
 }
 
 static int init_subsystem_preds(struct event_subsystem *system)
@@ -476,10 +488,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 
 static int filter_add_pred_fn(struct filter_parse_state *ps,
 			      struct ftrace_event_call *call,
+			      struct event_filter *filter,
 			      struct filter_pred *pred,
 			      filter_pred_fn_t fn)
 {
-	struct event_filter *filter = call->filter;
 	int idx, err;
 
 	if (filter->n_preds == MAX_FILTER_PRED) {
@@ -494,7 +506,6 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 		return err;
 
 	filter->n_preds++;
-	call->filter_active = 1;
 
 	return 0;
 }
@@ -570,6 +581,7 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 
 static int filter_add_pred(struct filter_parse_state *ps,
 			   struct ftrace_event_call *call,
+			   struct event_filter *filter,
 			   struct filter_pred *pred,
 			   bool dry_run)
 {
@@ -638,7 +650,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 add_pred_fn:
 	if (!dry_run)
-		return filter_add_pred_fn(ps, call, pred, fn);
+		return filter_add_pred_fn(ps, call, filter, pred, fn);
 	return 0;
 }
 
@@ -996,6 +1008,7 @@ static int check_preds(struct filter_parse_state *ps)
 }
 
 static int replace_preds(struct ftrace_event_call *call,
+			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
 			 char *filter_string,
 			 bool dry_run)
@@ -1042,7 +1055,7 @@ static int replace_preds(struct ftrace_event_call *call,
 add_pred:
 		if (!pred)
 			return -ENOMEM;
-		err = filter_add_pred(ps, call, pred, dry_run);
+		err = filter_add_pred(ps, call, filter, pred, dry_run);
 		filter_free_pred(pred);
 		if (err)
 			return err;
@@ -1058,10 +1071,12 @@ static int replace_system_preds(struct event_subsystem *system,
 				char *filter_string)
 {
 	struct ftrace_event_call *call;
+	struct event_filter *filter;
 	int err;
 	bool fail = true;
 
 	list_for_each_entry(call, &ftrace_events, list) {
+		filter = call->filter;
 
 		if (!call->define_fields)
 			continue;
@@ -1070,17 +1085,19 @@ static int replace_system_preds(struct event_subsystem *system,
 			continue;
 
 		/* try to see if the filter can be applied */
-		err = replace_preds(call, ps, filter_string, true);
+		err = replace_preds(call, filter, ps, filter_string, true);
 		if (err)
 			continue;
 
 		/* really apply the filter */
 		filter_disable_preds(call);
-		err = replace_preds(call, ps, filter_string, false);
+		err = replace_preds(call, filter, ps, filter_string, false);
 		if (err)
 			filter_disable_preds(call);
-		else
-			replace_filter_string(call->filter, filter_string);
+		else {
+			call->filter_active = 1;
+			replace_filter_string(filter, filter_string);
+		}
 		fail = false;
 	}
 
@@ -1094,7 +1111,6 @@ static int replace_system_preds(struct event_subsystem *system,
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
 	int err;
-
 	struct filter_parse_state *ps;
 
 	mutex_lock(&event_mutex);
@@ -1125,10 +1141,11 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		goto out;
 	}
 
-	err = replace_preds(call, ps, filter_string, false);
+	err = replace_preds(call, call->filter, ps, filter_string, false);
 	if (err)
 		append_filter_err(ps, call->filter);
-
+	else
+		call->filter_active = 1;
 out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
@@ -1143,7 +1160,6 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 				 char *filter_string)
 {
 	int err;
-
 	struct filter_parse_state *ps;
 
 	mutex_lock(&event_mutex);
@@ -1187,3 +1203,64 @@ out_unlock:
 	return err;
 }
 
+#ifdef CONFIG_EVENT_PROFILE
+
+void destroy_profile_preds(struct ftrace_event_call *call)
+{
+	if (!call->profile_filter)
+		return;
+
+	__free_preds(call->profile_filter);
+	call->profile_filter = NULL;
+	call->profile_filter_active = 0;
+}
+EXPORT_SYMBOL_GPL(destroy_profile_preds);
+
+static int init_profile_preds(struct ftrace_event_call *call)
+{
+	if (call->profile_filter)
+		return 0;
+
+	call->profile_filter_active = 0;
+
+	call->profile_filter = __alloc_preds();
+	if (IS_ERR(call->profile_filter))
+		return PTR_ERR(call->profile_filter);
+	return 0;
+}
+
+/* Should be called with event_mutex held */
+int apply_profile_filter(struct ftrace_event_call *call, char *filter_string)
+{
+	int err;
+	struct filter_parse_state *ps;
+
+	err = init_profile_preds(call);
+	if (err)
+		return err;
+
+	err = -ENOMEM;
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		return err;
+
+	parse_init(ps, filter_ops, filter_string);
+	err = filter_parse(ps);
+	if (err)
+		goto out;
+
+	err = replace_preds(call, call->profile_filter, ps,
+			    filter_string, false);
+	if (!err)
+		call->profile_filter_active = 1;
+
+out:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+	return err;
+}
+
+#endif /* CONFIG_EVENT_PROFILE */
+
-- 
1.6.3

