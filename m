Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZGJKmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZGJKmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZGJKm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:42:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:53434 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbZGJKmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:42:25 -0400
Date: Fri, 10 Jul 2009 10:41:39 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A55A83C.1030005@cn.fujitsu.com>
References: <4A55A83C.1030005@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/filter: Remove preds from struct event_subsystem
Message-ID: <tip-c5cb183608167c744cb28bbd85884be5a4ce875d@git.kernel.org>
Git-Commit-ID: c5cb183608167c744cb28bbd85884be5a4ce875d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:41:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5cb183608167c744cb28bbd85884be5a4ce875d
Gitweb:     http://git.kernel.org/tip/c5cb183608167c744cb28bbd85884be5a4ce875d
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Thu, 9 Jul 2009 16:20:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:55:27 +0200

tracing/filter: Remove preds from struct event_subsystem

No need to save preds to event_subsystem, because it's not used.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Tom Zanussi <tzanussi@gmail.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A55A83C.1030005@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
