Return-Path: <linux-kernel-owner+w=401wt.eu-S1762603AbZJOJlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762603AbZJOJlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762593AbZJOJlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:41:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:57361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZJOJlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:41:42 -0400
Date: Thu, 15 Oct 2009 09:40:16 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AD69546.8050401@cn.fujitsu.com>
References: <4AD69546.8050401@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/profile: Add filter support
Message-ID: <tip-6fb2915df7f0747d9044da9dbff5b46dc2e20830@git.kernel.org>
Git-Commit-ID: 6fb2915df7f0747d9044da9dbff5b46dc2e20830
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:40:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6fb2915df7f0747d9044da9dbff5b46dc2e20830
Gitweb:     http://git.kernel.org/tip/6fb2915df7f0747d9044da9dbff5b46dc2e20830
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 15 Oct 2009 11:21:42 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:35:23 +0200

tracing/profile: Add filter support

- Add an ioctl to allocate a filter for a perf event.

- Free the filter when the associated perf event is to be freed.

- Do the filtering in perf_swevent_match().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4AD69546.8050401@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace_event.h       |   11 +++-
 include/linux/perf_counter.h       |    1 +
 include/linux/perf_event.h         |    6 ++
 kernel/perf_event.c                |   80 ++++++++++++++++++++--
 kernel/trace/trace.h               |    3 +-
 kernel/trace/trace_events_filter.c |  133 +++++++++++++++++++++++++++++-------
 6 files changed, 199 insertions(+), 35 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4ec5e67..d117704 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,7 +144,7 @@ extern char			*trace_profile_buf_nmi;
 #define MAX_FILTER_STR_VAL	256	/* Should handle KSYM_SYMBOL_LEN */
 
 extern void destroy_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_match_preds(struct event_filter *filter, void *rec);
 extern int filter_current_check_discard(struct ring_buffer *buffer,
 					struct ftrace_event_call *call,
 					void *rec,
@@ -186,4 +186,13 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+#ifdef CONFIG_EVENT_PROFILE
+struct perf_event;
+extern int ftrace_profile_enable(int event_id);
+extern void ftrace_profile_disable(int event_id);
+extern int ftrace_profile_set_filter(struct perf_event *event, int event_id,
+				     char *filter_str);
+extern void ftrace_profile_free_filter(struct perf_event *event);
+#endif
+
 #endif /* _LINUX_FTRACE_EVENT_H */
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 7b7fbf4..91a2b43 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -225,6 +225,7 @@ struct perf_counter_attr {
 #define PERF_COUNTER_IOC_RESET		_IO ('$', 3)
 #define PERF_COUNTER_IOC_PERIOD		_IOW('$', 4, u64)
 #define PERF_COUNTER_IOC_SET_OUTPUT	_IO ('$', 5)
+#define PERF_COUNTER_IOC_SET_FILTER	_IOW('$', 6, char *)
 
 enum perf_counter_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e6d95f..df9d964 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -221,6 +221,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_RESET		_IO ('$', 3)
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
+#define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -633,7 +634,12 @@ struct perf_event {
 
 	struct pid_namespace		*ns;
 	u64				id;
+
+#ifdef CONFIG_EVENT_PROFILE
+	struct event_filter		*filter;
 #endif
+
+#endif /* CONFIG_PERF_EVENTS */
 };
 
 /**
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 9d0b5c6..12b5ec3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -28,6 +28,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
+#include <linux/ftrace_event.h>
 
 #include <asm/irq_regs.h>
 
@@ -1658,6 +1659,8 @@ static struct perf_event_context *find_get_context(pid_t pid, int cpu)
 	return ERR_PTR(err);
 }
 
+static void perf_event_free_filter(struct perf_event *event);
+
 static void free_event_rcu(struct rcu_head *head)
 {
 	struct perf_event *event;
@@ -1665,6 +1668,7 @@ static void free_event_rcu(struct rcu_head *head)
 	event = container_of(head, struct perf_event, rcu_head);
 	if (event->ns)
 		put_pid_ns(event->ns);
+	perf_event_free_filter(event);
 	kfree(event);
 }
 
@@ -1974,7 +1978,8 @@ unlock:
 	return ret;
 }
 
-int perf_event_set_output(struct perf_event *event, int output_fd);
+static int perf_event_set_output(struct perf_event *event, int output_fd);
+static int perf_event_set_filter(struct perf_event *event, void __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -2002,6 +2007,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_OUTPUT:
 		return perf_event_set_output(event, arg);
 
+	case PERF_EVENT_IOC_SET_FILTER:
+		return perf_event_set_filter(event, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -3806,9 +3814,14 @@ static int perf_swevent_is_counting(struct perf_event *event)
 	return 1;
 }
 
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data);
+
 static int perf_swevent_match(struct perf_event *event,
 				enum perf_type_id type,
-				u32 event_id, struct pt_regs *regs)
+				u32 event_id,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
 {
 	if (!perf_swevent_is_counting(event))
 		return 0;
@@ -3826,6 +3839,10 @@ static int perf_swevent_match(struct perf_event *event,
 			return 0;
 	}
 
+	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
+	    !perf_tp_event_match(event, data))
+		return 0;
+
 	return 1;
 }
 
@@ -3842,7 +3859,7 @@ static void perf_swevent_ctx_event(struct perf_event_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
-		if (perf_swevent_match(event, type, event_id, regs))
+		if (perf_swevent_match(event, type, event_id, data, regs))
 			perf_swevent_add(event, nr, nmi, data, regs);
 	}
 	rcu_read_unlock();
@@ -4086,6 +4103,7 @@ static const struct pmu perf_ops_task_clock = {
 };
 
 #ifdef CONFIG_EVENT_PROFILE
+
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
@@ -4109,8 +4127,15 @@ void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 }
 EXPORT_SYMBOL_GPL(perf_tp_event);
 
-extern int ftrace_profile_enable(int);
-extern void ftrace_profile_disable(int);
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	void *record = data->raw->data;
+
+	if (likely(!event->filter) || filter_match_preds(event->filter, record))
+		return 1;
+	return 0;
+}
 
 static void tp_perf_event_destroy(struct perf_event *event)
 {
@@ -4135,12 +4160,53 @@ static const struct pmu *tp_perf_event_init(struct perf_event *event)
 
 	return &perf_ops_generic;
 }
+
+static int perf_event_set_filter(struct perf_event *event, void __user *arg)
+{
+	char *filter_str;
+	int ret;
+
+	if (event->attr.type != PERF_TYPE_TRACEPOINT)
+		return -EINVAL;
+
+	filter_str = strndup_user(arg, PAGE_SIZE);
+	if (IS_ERR(filter_str))
+		return PTR_ERR(filter_str);
+
+	ret = ftrace_profile_set_filter(event, event->attr.config, filter_str);
+
+	kfree(filter_str);
+	return ret;
+}
+
+static void perf_event_free_filter(struct perf_event *event)
+{
+	ftrace_profile_free_filter(event);
+}
+
 #else
+
+static int perf_tp_event_match(struct perf_event *event,
+				struct perf_sample_data *data)
+{
+	return 1;
+}
+
 static const struct pmu *tp_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
-#endif
+
+static int perf_event_set_filter(struct perf_event *event, void __user *arg)
+{
+	return -ENOENT;
+}
+
+static void perf_event_free_filter(struct perf_event *event)
+{
+}
+
+#endif /* CONFIG_EVENT_PROFILE */
 
 atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
@@ -4394,7 +4460,7 @@ err_size:
 	goto out;
 }
 
-int perf_event_set_output(struct perf_event *event, int output_fd)
+static int perf_event_set_output(struct perf_event *event, int output_fd)
 {
 	struct perf_event *output_event = NULL;
 	struct file *output_file = NULL;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ffe53dd..4959ada 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -743,7 +743,8 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 		     struct ring_buffer *buffer,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->filter_active) && !filter_match_preds(call, rec)) {
+	if (unlikely(call->filter_active) &&
+	    !filter_match_preds(call->filter, rec)) {
 		ring_buffer_discard_commit(buffer, event);
 		return 1;
 	}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 273845f..e27bb6a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/mutex.h>
+#include <linux/perf_event.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -363,9 +364,8 @@ static void filter_build_regex(struct filter_pred *pred)
 }
 
 /* return 1 if event matches, 0 otherwise (discard) */
-int filter_match_preds(struct ftrace_event_call *call, void *rec)
+int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	struct event_filter *filter = call->filter;
 	int match, top = 0, val1 = 0, val2 = 0;
 	int stack[MAX_FILTER_PRED];
 	struct filter_pred *pred;
@@ -538,9 +538,8 @@ static void filter_disable_preds(struct ftrace_event_call *call)
 		filter->preds[i]->fn = filter_pred_none;
 }
 
-void destroy_preds(struct ftrace_event_call *call)
+static void __free_preds(struct event_filter *filter)
 {
-	struct event_filter *filter = call->filter;
 	int i;
 
 	if (!filter)
@@ -553,21 +552,24 @@ void destroy_preds(struct ftrace_event_call *call)
 	kfree(filter->preds);
 	kfree(filter->filter_string);
 	kfree(filter);
+}
+
+void destroy_preds(struct ftrace_event_call *call)
+{
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
 
@@ -583,12 +585,24 @@ static int init_preds(struct ftrace_event_call *call)
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
+
+	call->filter_active = 0;
+	call->filter = __alloc_preds();
+	if (IS_ERR(call->filter))
+		return PTR_ERR(call->filter);
 
-	return -ENOMEM;
+	return 0;
 }
 
 static int init_subsystem_preds(struct event_subsystem *system)
@@ -629,10 +643,10 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 
 static int filter_add_pred_fn(struct filter_parse_state *ps,
 			      struct ftrace_event_call *call,
+			      struct event_filter *filter,
 			      struct filter_pred *pred,
 			      filter_pred_fn_t fn)
 {
-	struct event_filter *filter = call->filter;
 	int idx, err;
 
 	if (filter->n_preds == MAX_FILTER_PRED) {
@@ -647,7 +661,6 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 		return err;
 
 	filter->n_preds++;
-	call->filter_active = 1;
 
 	return 0;
 }
@@ -726,6 +739,7 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 
 static int filter_add_pred(struct filter_parse_state *ps,
 			   struct ftrace_event_call *call,
+			   struct event_filter *filter,
 			   struct filter_pred *pred,
 			   bool dry_run)
 {
@@ -795,7 +809,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 add_pred_fn:
 	if (!dry_run)
-		return filter_add_pred_fn(ps, call, pred, fn);
+		return filter_add_pred_fn(ps, call, filter, pred, fn);
 	return 0;
 }
 
@@ -1154,6 +1168,7 @@ static int check_preds(struct filter_parse_state *ps)
 }
 
 static int replace_preds(struct ftrace_event_call *call,
+			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
 			 char *filter_string,
 			 bool dry_run)
@@ -1200,7 +1215,7 @@ static int replace_preds(struct ftrace_event_call *call,
 add_pred:
 		if (!pred)
 			return -ENOMEM;
-		err = filter_add_pred(ps, call, pred, dry_run);
+		err = filter_add_pred(ps, call, filter, pred, dry_run);
 		filter_free_pred(pred);
 		if (err)
 			return err;
@@ -1216,6 +1231,7 @@ static int replace_system_preds(struct event_subsystem *system,
 				char *filter_string)
 {
 	struct ftrace_event_call *call;
+	struct event_filter *filter;
 	int err;
 	bool fail = true;
 
@@ -1228,17 +1244,19 @@ static int replace_system_preds(struct event_subsystem *system,
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
 
@@ -1252,7 +1270,6 @@ static int replace_system_preds(struct event_subsystem *system,
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
 	int err;
-
 	struct filter_parse_state *ps;
 
 	mutex_lock(&event_mutex);
@@ -1283,10 +1300,11 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
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
@@ -1301,7 +1319,6 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 				 char *filter_string)
 {
 	int err;
-
 	struct filter_parse_state *ps;
 
 	mutex_lock(&event_mutex);
@@ -1345,3 +1362,67 @@ out_unlock:
 	return err;
 }
 
+#ifdef CONFIG_EVENT_PROFILE
+
+void ftrace_profile_free_filter(struct perf_event *event)
+{
+	struct event_filter *filter = event->filter;
+
+	event->filter = NULL;
+	__free_preds(filter);
+}
+
+int ftrace_profile_set_filter(struct perf_event *event, int event_id,
+			      char *filter_str)
+{
+	int err;
+	struct event_filter *filter;
+	struct filter_parse_state *ps;
+	struct ftrace_event_call *call = NULL;
+
+	mutex_lock(&event_mutex);
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (call->id == event_id)
+			break;
+	}
+	if (!call)
+		return -EINVAL;
+
+	if (event->filter)
+		return -EEXIST;
+
+	filter = __alloc_preds();
+	if (IS_ERR(filter))
+		return PTR_ERR(filter);
+
+	err = -ENOMEM;
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto free_preds;
+
+	parse_init(ps, filter_ops, filter_str);
+	err = filter_parse(ps);
+	if (err)
+		goto free_ps;
+
+	err = replace_preds(call, filter, ps, filter_str, false);
+	if (!err)
+		event->filter = filter;
+
+free_ps:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+free_preds:
+	if (err)
+		__free_preds(filter);
+
+	mutex_unlock(&event_mutex);
+
+	return err;
+}
+
+#endif /* CONFIG_EVENT_PROFILE */
+
