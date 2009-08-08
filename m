Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbZHHQEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbZHHQEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 12:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZHHQEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 12:04:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZHHQET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 12:04:19 -0400
Date: Sat, 8 Aug 2009 16:03:49 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249746593.6453.32.camel@tropicana>
References: <1249746593.6453.32.camel@tropicana>
Subject: [tip:tracing/core] tracing/filters: Always free pred on filter_add_subsystem_pred() failure
Message-ID: <tip-26528e773ecc74fb1b61b7275f86f761cbb340ec@git.kernel.org>
Git-Commit-ID: 26528e773ecc74fb1b61b7275f86f761cbb340ec
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 16:03:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26528e773ecc74fb1b61b7275f86f761cbb340ec
Gitweb:     http://git.kernel.org/tip/26528e773ecc74fb1b61b7275f86f761cbb340ec
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sat, 8 Aug 2009 10:49:53 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:56:13 +0200

tracing/filters: Always free pred on filter_add_subsystem_pred() failure

If filter_add_subsystem_pred() fails due to ENOSPC or ENOMEM,
the pred doesn't get freed, while as a side effect it does for
other errors. Make it so the caller always frees the pred for
any error.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <1249746593.6453.32.camel@tropicana>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events_filter.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1557148..f32dc9d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -624,9 +624,6 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		return -ENOSPC;
 	}
 
-	filter->preds[filter->n_preds] = pred;
-	filter->n_preds++;
-
 	list_for_each_entry(call, &ftrace_events, list) {
 
 		if (!call->define_fields)
@@ -643,6 +640,9 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
 		}
 		replace_filter_string(call->filter, filter_string);
 	}
+
+	filter->preds[filter->n_preds] = pred;
+	filter->n_preds++;
 out:
 	return err;
 }
@@ -1034,9 +1034,12 @@ static int replace_preds(struct event_subsystem *system,
 			if (call) {
 				err = filter_add_pred(ps, call, pred);
 				filter_free_pred(pred);
-			} else
+			} else {
 				err = filter_add_subsystem_pred(ps, system,
 							pred, filter_string);
+				if (err)
+					filter_free_pred(pred);
+			}
 			if (err)
 				return err;
 
@@ -1055,9 +1058,12 @@ static int replace_preds(struct event_subsystem *system,
 		if (call) {
 			err = filter_add_pred(ps, call, pred);
 			filter_free_pred(pred);
-		} else
+		} else {
 			err = filter_add_subsystem_pred(ps, system, pred,
 							filter_string);
+			if (err)
+				filter_free_pred(pred);
+		}
 		if (err)
 			return err;
 
