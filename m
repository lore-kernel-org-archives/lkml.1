Return-Path: <linux-kernel-owner+w=401wt.eu-S1759649AbZGIIU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbZGIIU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZGIIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:20:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56673 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbZGIIUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:20:13 -0400
Message-ID: <4A55A83C.1030005@cn.fujitsu.com>
Date: Thu, 09 Jul 2009 16:20:12 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/filter: remove preds from struct event_subsystem
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to save preds to event_subsystem, because it's not used.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |   39 +++++------------------------------
 1 files changed, 6 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 936c621..b9aae72 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -420,17 +420,7 @@ EXPORT_SYMBOL_GPL(init_preds);
 
 static void filter_free_subsystem_preds(struct event_subsystem *system)
 {
-	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
-	int i;
-
-	if (filter->n_preds) {
-		for (i = 0; i < filter->n_preds; i++)
-			filter_free_pred(filter->preds[i]);
-		kfree(filter->preds);
-		filter->preds = NULL;
-		filter->n_preds = 0;
-	}
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (!call->define_fields)
@@ -607,26 +597,9 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 				     struct filter_pred *pred,
 				     char *filter_string)
 {
-	struct event_filter *filter = system->filter;
 	struct ftrace_event_call *call;
 	int err = 0;
 
-	if (!filter->preds) {
-		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
-					GFP_KERNEL);
-
-		if (!filter->preds)
-			return -ENOMEM;
-	}
-
-	if (filter->n_preds == MAX_FILTER_PRED) {
-		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
-		return -ENOSPC;
-	}
-
-	filter->preds[filter->n_preds] = pred;
-	filter->n_preds++;
-
 	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (!call->define_fields)
@@ -1029,12 +1002,12 @@ static int replace_preds(struct event_subsystem *system,
 
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
-			if (call) {
+			if (call)
 				err = filter_add_pred(ps, call, pred);
-				filter_free_pred(pred);
-			} else
+			else
 				err = filter_add_subsystem_pred(ps, system,
 							pred, filter_string);
+			filter_free_pred(pred);
 			if (err)
 				return err;
 
@@ -1048,12 +1021,12 @@ static int replace_preds(struct event_subsystem *system,
 		}
 
 		pred = create_pred(elt->op, operand1, operand2);
-		if (call) {
+		if (call)
 			err = filter_add_pred(ps, call, pred);
-			filter_free_pred(pred);
-		} else
+		else
 			err = filter_add_subsystem_pred(ps, system, pred,
 							filter_string);
+		filter_free_pred(pred);
 		if (err)
 			return err;
 
-- 
1.6.1.2

