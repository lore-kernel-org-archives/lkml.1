Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZFPIiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZFPIiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbZFPIiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:38:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbZFPIiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:38:04 -0400
Message-ID: <4A375A4D.6000205@cn.fujitsu.com>
Date: Tue, 16 Jun 2009 16:39:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing/filters: fix race between filter setting and
 module unload
References: <4A375A30.9060802@cn.fujitsu.com>
In-Reply-To: <4A375A30.9060802@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Module unload is protected by event_mutex, while setting filter is
protected by filter_mutex. This leads to the race:

echo 'bar == 0 || bar == 10' \    |
		> sample/filter   |
                                  |  insmod sample.ko
  add_pred("bar == 0")            |
    -> n_preds == 1               |
  add_pred("bar == 100")          |
    -> n_preds == 2               |
                                  |  rmmod sample.ko
                                  |  insmod sample.ko
  add_pred("&&")                  |
    -> n_preds == 1 (should be 3) |

Now event->filter->preds is corrupted. An then when filter_match_preds()
is called, the WARN_ON() in it will be triggered.

To avoid the race, we remove filter_mutex, and replace it with event_mutex.

[ fix race that can cause WARN_ON (even sth worse) when filtering events ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   27 ++++++++++-----------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index d9f01c1..936c621 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -27,8 +27,6 @@
 #include "trace.h"
 #include "trace_output.h"
 
-static DEFINE_MUTEX(filter_mutex);
-
 enum filter_op_ids
 {
 	OP_OR,
@@ -294,12 +292,12 @@ void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	struct event_filter *filter = call->filter;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 	if (filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 }
 
 void print_subsystem_event_filter(struct event_subsystem *system,
@@ -307,12 +305,12 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 {
 	struct event_filter *filter = system->filter;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 	if (filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_printf(s, "none\n");
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 }
 
 static struct ftrace_event_field *
@@ -434,7 +432,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 		filter->n_preds = 0;
 	}
 
-	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
 			continue;
@@ -444,7 +441,6 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
 			remove_filter_string(call->filter);
 		}
 	}
-	mutex_unlock(&event_mutex);
 }
 
 static int filter_add_pred_fn(struct filter_parse_state *ps,
@@ -631,7 +627,6 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 	filter->preds[filter->n_preds] = pred;
 	filter->n_preds++;
 
-	mutex_lock(&event_mutex);
 	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (!call->define_fields)
@@ -642,14 +637,12 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 
 		err = filter_add_pred(ps, call, pred);
 		if (err) {
-			mutex_unlock(&event_mutex);
 			filter_free_subsystem_preds(system);
 			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 			goto out;
 		}
 		replace_filter_string(call->filter, filter_string);
 	}
-	mutex_unlock(&event_mutex);
 out:
 	return err;
 }
@@ -1076,12 +1069,12 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	struct filter_parse_state *ps;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable_preds(call);
 		remove_filter_string(call->filter);
-		mutex_unlock(&filter_mutex);
+		mutex_unlock(&event_mutex);
 		return 0;
 	}
 
@@ -1109,7 +1102,7 @@ out:
 	postfix_clear(ps);
 	kfree(ps);
 out_unlock:
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 
 	return err;
 }
@@ -1121,12 +1114,12 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 
 	struct filter_parse_state *ps;
 
-	mutex_lock(&filter_mutex);
+	mutex_lock(&event_mutex);
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
-		mutex_unlock(&filter_mutex);
+		mutex_unlock(&event_mutex);
 		return 0;
 	}
 
@@ -1154,7 +1147,7 @@ out:
 	postfix_clear(ps);
 	kfree(ps);
 out_unlock:
-	mutex_unlock(&filter_mutex);
+	mutex_unlock(&event_mutex);
 
 	return err;
 }
-- 
1.5.4.rc3

