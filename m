Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZHaJBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZHaJBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZHaJBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:01:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:60952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZHaJBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:01:11 -0400
Date: Mon, 31 Aug 2009 09:00:39 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
In-Reply-To: <4A9B8EA5.6020700@cn.fujitsu.com>
References: <4A9B8EA5.6020700@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/filters: Defer pred allocation
Message-ID: <tip-8e254c1d183f0225ad21f9049641529e56cce4da@git.kernel.org>
Git-Commit-ID: 8e254c1d183f0225ad21f9049641529e56cce4da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 09:00:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e254c1d183f0225ad21f9049641529e56cce4da
Gitweb:     http://git.kernel.org/tip/8e254c1d183f0225ad21f9049641529e56cce4da
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 31 Aug 2009 16:49:41 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 10:58:08 +0200

tracing/filters: Defer pred allocation

init_preds() allocates about 5392 bytes of memory (on x86_32) for
a TRACE_EVENT. With my config, at system boot total memory occupied
is:

	5392 * (642 + 15) == 3459KB

642 == cat available_events | wc -l
15 == number of dirs in events/ftrace

That's quite a lot, so we'd better defer memory allocation util
it's needed, that's when filter is used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <4A9B8EA5.6020700@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h       |    1 -
 include/linux/syscalls.h           |    2 -
 include/trace/ftrace.h             |    1 -
 kernel/trace/trace_events_filter.c |   50 +++++++++++++++++++++++++++++------
 kernel/trace/trace_export.c        |    1 -
 5 files changed, 41 insertions(+), 14 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index ace2da9..7554804 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -133,7 +133,6 @@ struct ftrace_event_call {
 #define MAX_FILTER_PRED		32
 #define MAX_FILTER_STR_VAL	128
 
-extern int init_preds(struct ftrace_event_call *call);
 extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
 extern int filter_current_check_discard(struct ftrace_event_call *call,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f124c89..a8e3782 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -177,7 +177,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		event_enter_##sname.id = id;				\
 		set_syscall_enter_id(num, id);				\
 		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
-		init_preds(&event_enter_##sname);			\
 		return 0;						\
 	}								\
 	TRACE_SYS_ENTER_PROFILE(sname);					\
@@ -214,7 +213,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		event_exit_##sname.id = id;				\
 		set_syscall_exit_id(num, id);				\
 		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
-		init_preds(&event_exit_##sname);			\
 		return 0;						\
 	}								\
 	TRACE_SYS_EXIT_PROFILE(sname);					\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 57c56a9..bfbc842 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -622,7 +622,6 @@ static int ftrace_raw_init_event_##call(void)				\
 		return -ENODEV;						\
 	event_##call.id = id;						\
 	INIT_LIST_HEAD(&event_##call.fields);				\
-	init_preds(&event_##call);					\
 	return 0;							\
 }									\
 									\
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9f03082..c6b2edf 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -309,7 +309,7 @@ void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 	struct event_filter *filter = call->filter;
 
 	mutex_lock(&event_mutex);
-	if (filter->filter_string)
+	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
@@ -322,7 +322,7 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 	struct event_filter *filter = system->filter;
 
 	mutex_lock(&event_mutex);
-	if (filter->filter_string)
+	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
@@ -390,6 +390,9 @@ void destroy_preds(struct ftrace_event_call *call)
 	struct event_filter *filter = call->filter;
 	int i;
 
+	if (!filter)
+		return;
+
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
 		if (filter->preds[i])
 			filter_free_pred(filter->preds[i]);
@@ -400,7 +403,7 @@ void destroy_preds(struct ftrace_event_call *call)
 	call->filter = NULL;
 }
 
-int init_preds(struct ftrace_event_call *call)
+static int init_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter;
 	struct filter_pred *pred;
@@ -410,7 +413,6 @@ int init_preds(struct ftrace_event_call *call)
 	if (!call->filter)
 		return -ENOMEM;
 
-	call->filter_active = 0;
 	filter->n_preds = 0;
 
 	filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
@@ -432,7 +434,28 @@ oom:
 
 	return -ENOMEM;
 }
-EXPORT_SYMBOL_GPL(init_preds);
+
+static int init_subsystem_preds(struct event_subsystem *system)
+{
+	struct ftrace_event_call *call;
+	int err;
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		if (!call->define_fields)
+			continue;
+
+		if (strcmp(call->system, system->name) != 0)
+			continue;
+
+		if (!call->filter) {
+			err = init_preds(call);
+			if (err)
+				return err;
+		}
+	}
+
+	return 0;
+}
 
 enum {
 	FILTER_DISABLE_ALL,
@@ -449,6 +472,9 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
 		if (!call->define_fields)
 			continue;
 
+		if (strcmp(call->system, system->name) != 0)
+			continue;
+
 		if (flag == FILTER_INIT_NO_RESET) {
 			call->filter->no_reset = false;
 			continue;
@@ -457,10 +483,8 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
 		if (flag == FILTER_SKIP_NO_RESET && call->filter->no_reset)
 			continue;
 
-		if (!strcmp(call->system, system->name)) {
-			filter_disable_preds(call);
-			remove_filter_string(call->filter);
-		}
+		filter_disable_preds(call);
+		remove_filter_string(call->filter);
 	}
 }
 
@@ -1094,6 +1118,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	mutex_lock(&event_mutex);
 
+	err = init_preds(call);
+	if (err)
+		goto out_unlock;
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable_preds(call);
 		remove_filter_string(call->filter);
@@ -1139,6 +1167,10 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	mutex_lock(&event_mutex);
 
+	err = init_subsystem_preds(system);
+	if (err)
+		goto out_unlock;
+
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system, FILTER_DISABLE_ALL);
 		remove_filter_string(system->filter);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 029a91f..df1bf6e 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -135,7 +135,6 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 static int ftrace_raw_init_event_##call(void)				\
 {									\
 	INIT_LIST_HEAD(&event_##call.fields);				\
-	init_preds(&event_##call);					\
 	return 0;							\
 }									\
 
