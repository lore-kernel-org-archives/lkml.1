Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZIGINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZIGINk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZIGINj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 04:13:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53069 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZIGINj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 04:13:39 -0400
Message-ID: <4AA4C066.90205@cn.fujitsu.com>
Date: Mon, 07 Sep 2009 16:12:22 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] tracing/filters: refactor subsystem filter code
References: <4AA4C04D.1050201@cn.fujitsu.com>
In-Reply-To: <4AA4C04D.1050201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change:
	for_each_pred
		for_each_subsystem
To:
	for_each_subsystem
		for_each_pred

This change also prepares for the next patch.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h               |    1 -
 kernel/trace/trace_events_filter.c |  124 +++++++++++++-----------------------
 2 files changed, 45 insertions(+), 80 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea7e0bc..2b47eba 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -790,7 +790,6 @@ struct event_filter {
 	int			n_preds;
 	struct filter_pred	**preds;
 	char			*filter_string;
-	bool			no_reset;
 };
 
 struct event_subsystem {
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 93660fb..f9afbdf 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -458,14 +458,7 @@ static int init_subsystem_preds(struct event_subsystem *system)
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
 
@@ -476,14 +469,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system,
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
@@ -657,44 +642,6 @@ add_pred_fn:
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
@@ -1048,8 +995,7 @@ static int check_preds(struct filter_parse_state *ps)
 	return 0;
 }
 
-static int replace_preds(struct event_subsystem *system,
-			 struct ftrace_event_call *call,
+static int replace_preds(struct ftrace_event_call *call,
 			 struct filter_parse_state *ps,
 			 char *filter_string,
 			 bool dry_run)
@@ -1096,11 +1042,7 @@ static int replace_preds(struct event_subsystem *system,
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
@@ -1111,6 +1053,44 @@ add_pred:
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
@@ -1145,7 +1125,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		goto out;
 	}
 
-	err = replace_preds(NULL, call, ps, filter_string, false);
+	err = replace_preds(call, ps, filter_string, false);
 	if (err)
 		append_filter_err(ps, call->filter);
 
@@ -1173,7 +1153,7 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		goto out_unlock;
 
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_free_subsystem_preds(system, FILTER_DISABLE_ALL);
+		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
 		mutex_unlock(&event_mutex);
 		return 0;
@@ -1193,23 +1173,9 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
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
-- 
1.6.3

