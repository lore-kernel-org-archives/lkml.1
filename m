Return-Path: <linux-kernel-owner+w=401wt.eu-S1759938AbZEFMUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938AbZEFMUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbZEFMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:20:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:36010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499AbZEFMUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:20:11 -0400
Date: Wed, 6 May 2009 12:19:32 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A00F6E0.3040503@cn.fujitsu.com>
References: <4A00F6E0.3040503@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/events: fix memory leak when unloading module
Message-ID: <tip-2df75e415709ad12862028916c772c1f377f6a7c@git.kernel.org>
Git-Commit-ID: 2df75e415709ad12862028916c772c1f377f6a7c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 12:19:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2df75e415709ad12862028916c772c1f377f6a7c
Gitweb:     http://git.kernel.org/tip/2df75e415709ad12862028916c772c1f377f6a7c
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 6 May 2009 10:33:04 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 10:38:19 +0200

tracing/events: fix memory leak when unloading module

When unloading a module, memory allocated by init_preds() and
trace_define_field() is not freed.

[ Impact: fix memory leak ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4A00F6E0.3040503@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace_events.c        |   18 ++++++++++++++++++
 kernel/trace/trace_events_filter.c |   22 +++++++++++++++-------
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5fff40c..662c1be 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -116,6 +116,7 @@ struct ftrace_event_call {
 #define MAX_FILTER_STR_VAL	128
 
 extern int init_preds(struct ftrace_event_call *call);
+extern void destroy_preds(struct ftrace_event_call *call);
 extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
 extern int filter_current_check_discard(struct ftrace_event_call *call,
 					void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f789ca5..f251a15 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -60,6 +60,22 @@ err:
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
+#ifdef CONFIG_MODULES
+
+static void trace_destroy_fields(struct ftrace_event_call *call)
+{
+	struct ftrace_event_field *field, *next;
+
+	list_for_each_entry_safe(field, next, &call->fields, link) {
+		list_del(&field->link);
+		kfree(field->type);
+		kfree(field->name);
+		kfree(field);
+	}
+}
+
+#endif /* CONFIG_MODULES */
+
 static void ftrace_clear_events(void)
 {
 	struct ftrace_event_call *call;
@@ -925,6 +941,8 @@ static void trace_module_remove_events(struct module *mod)
 				unregister_ftrace_event(call->event);
 			debugfs_remove_recursive(call->dir);
 			list_del(&call->list);
+			trace_destroy_fields(call);
+			destroy_preds(call);
 		}
 	}
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f494866..ce07b81 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -346,6 +346,20 @@ static void filter_disable_preds(struct ftrace_event_call *call)
 		filter->preds[i]->fn = filter_pred_none;
 }
 
+void destroy_preds(struct ftrace_event_call *call)
+{
+	struct event_filter *filter = call->filter;
+	int i;
+
+	for (i = 0; i < MAX_FILTER_PRED; i++) {
+		if (filter->preds[i])
+			filter_free_pred(filter->preds[i]);
+	}
+	kfree(filter->preds);
+	kfree(filter);
+	call->filter = NULL;
+}
+
 int init_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter;
@@ -374,13 +388,7 @@ int init_preds(struct ftrace_event_call *call)
 	return 0;
 
 oom:
-	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (filter->preds[i])
-			filter_free_pred(filter->preds[i]);
-	}
-	kfree(filter->preds);
-	kfree(call->filter);
-	call->filter = NULL;
+	destroy_preds(call);
 
 	return -ENOMEM;
 }
