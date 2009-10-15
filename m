Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbZJOJlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbZJOJlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZJOJlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:41:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:57334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbZJOJlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:41:11 -0400
Date: Thu, 15 Oct 2009 09:39:46 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4AD69502.8060903@cn.fujitsu.com>
References: <4AD69502.8060903@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/filters: Refactor subsystem filter code
Message-ID: <tip-fce29d15b59245597f7f320db4a9f2be0f5fb512@git.kernel.org>
Git-Commit-ID: fce29d15b59245597f7f320db4a9f2be0f5fb512
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:40:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fce29d15b59245597f7f320db4a9f2be0f5fb512
Gitweb:     http://git.kernel.org/tip/fce29d15b59245597f7f320db4a9f2be0f5fb512
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 15 Oct 2009 11:20:34 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Oct 2009 11:35:22 +0200

tracing/filters: Refactor subsystem filter code

Change:
	for_each_pred
		for_each_subsystem
To:
	for_each_subsystem
		for_each_pred

This change also prepares for later patches.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4AD69502.8060903@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.h               |    1 -
 kernel/trace/trace_events_filter.c |  124 +++++++++++++-----------------------
 2 files changed, 45 insertions(+), 80 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index acef8b4..6286145 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -683,7 +683,6 @@ struct event_filter {
 	int			n_preds;
 	struct filter_pred	**preds;
 	char			*filter_string;
-	bool			no_reset;
 };
 
 struct event_subsystem {
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 9267201..9c4f9a0 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -615,14 +615,7 @@ static int init_subsystem_preds(struct event_subsystem *system)
 	return 0;
 }
 
-enum {
-	FILTER_DISABLE_ALL,
-	FILTER_INIT_NO_RESET,
-	FILTER_SKIP_NO_RESET,
-};
-
-static void filter_free_subsystem_preds(struct event_subsystem *system,
-					int flag)
+static void filter_free_subsystem_preds(struct event_subsystem *system)
 {
 	struct ftrace_event_call *call;
 
@@ -633,14 +626,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
 		if (strcmp(call->system, system->name) != 0)
 			continue;
 
-		if (flag == FILTER_INIT_NO_RESET) {
-			call->filter->no_reset = false;
-			continue;
-		}
-
-		if (flag == FILTER_SKIP_NO_RESET && call->filter->no_reset)
-			continue;
-
 		filter_disable_preds(call);
 		remove_filter_string(call->filter);
 	}
@@ -817,44 +802,6 @@ add_pred_fn:
 	return 0;
 }
 
-static int filter_add_subsystem_pred(struct filter_parse_state *ps,
-				     struct event_subsystem *system,
-				     struct filter_pred *pred,
-				     char *filter_string,
-				     bool dry_run)
-{
-	struct ftrace_event_call *call;
-	int err = 0;
-	bool fail = true;
-
-	list_for_each_entry(call, &ftrace_events, list) {
-
-		if (!call->define_fields)
-			continue;
-
-		if (strcmp(call->system, system->name))
-			continue;
-
-		if (call->filter->no_reset)
-			continue;
-
-		err = filter_add_pred(ps, call, pred, dry_run);
-		if (err)
-			call->filter->no_reset = true;
-		else
-			fail = false;
-
-		if (!dry_run)
-			replace_filter_string(call->filter, filter_string);
-	}
-
-	if (fail) {
-		parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
-		return err;
-	}
-	return 0;
-}
-
 static void parse_init(struct filter_parse_state *ps,
 		       struct filter_op *ops,
 		       char *infix_string)
@@ -1209,8 +1156,7 @@ static int check_preds(struct filter_parse_state *ps)
 	return 0;
 }
 
-static int replace_preds(struct event_subsystem *system,
-			 struct ftrace_event_call *call,
+static int replace_preds(struct ftrace_event_call *call,
 			 struct filter_parse_state *ps,
 			 char *filter_string,
 			 bool dry_run)
@@ -1257,11 +1203,7 @@ static int replace_preds(struct event_subsystem *system,
 add_pred:
 		if (!pred)
 			return -ENOMEM;
-		if (call)
-			err = filter_add_pred(ps, call, pred, false);
-		else
-			err = filter_add_subsystem_pred(ps, system, pred,
-						filter_string, dry_run);
+		err = filter_add_pred(ps, call, pred, dry_run);
 		filter_free_pred(pred);
 		if (err)
 			return err;
@@ -1272,6 +1214,44 @@ add_pred:
 	return 0;
 }
 
+static int replace_system_preds(struct event_subsystem *system,
+				struct filter_parse_state *ps,
+				char *filter_string)
+{
+	struct ftrace_event_call *call;
+	int err;
+	bool fail = true;
+
+	list_for_each_entry(call, &ftrace_events, list) {
+
+		if (!call->define_fields)
+			continue;
+
+		if (strcmp(call->system, system->name) != 0)
+			continue;
+
+		/* try to see if the filter can be applied */
+		err = replace_preds(call, ps, filter_string, true);
+		if (err)
+			continue;
+
+		/* really apply the filter */
+		filter_disable_preds(call);
+		err = replace_preds(call, ps, filter_string, false);
+		if (err)
+			filter_disable_preds(call);
+		else
+			replace_filter_string(call->filter, filter_string);
+		fail = false;
+	}
+
+	if (fail) {
+		parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
+		return err;
+	}
+	return 0;
+}
+
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
 	int err;
@@ -1306,7 +1286,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		goto out;
 	}
 
-	err = replace_preds(NULL, call, ps, filter_string, false);
+	err = replace_preds(call, ps, filter_string, false);
 	if (err)
 		append_filter_err(ps, call->filter);
 
@@ -1334,7 +1314,7 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		goto out_unlock;
 
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_free_subsystem_preds(system, FILTER_DISABLE_ALL);
+		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
 		mutex_unlock(&event_mutex);
 		return 0;
@@ -1354,23 +1334,9 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		goto out;
 	}
 
-	filter_free_subsystem_preds(system, FILTER_INIT_NO_RESET);
-
-	/* try to see the filter can be applied to which events */
-	err = replace_preds(system, NULL, ps, filter_string, true);
-	if (err) {
-		append_filter_err(ps, system->filter);
-		goto out;
-	}
-
-	filter_free_subsystem_preds(system, FILTER_SKIP_NO_RESET);
-
-	/* really apply the filter to the events */
-	err = replace_preds(system, NULL, ps, filter_string, false);
-	if (err) {
+	err = replace_system_preds(system, ps, filter_string);
+	if (err)
 		append_filter_err(ps, system->filter);
-		filter_free_subsystem_preds(system, 2);
-	}
 
 out:
 	filter_opstack_clear(ps);
