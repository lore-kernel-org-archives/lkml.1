Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbZCWIfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbZCWIfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbZCWIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:34:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:51728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbZCWIeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:34:14 -0400
Date: Mon, 23 Mar 2009 08:33:35 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237796808.7527.40.camel@charm-linux>
References: <1237796808.7527.40.camel@charm-linux>
Subject: [tip:tracing/filters] tracing/filters: clean up filter_add_subsystem_pred()
Message-ID: <tip-c4cff064be678f1e8344d907499f2a81282edc19@git.kernel.org>
Git-Commit-ID: c4cff064be678f1e8344d907499f2a81282edc19
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 08:33:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4cff064be678f1e8344d907499f2a81282edc19
Gitweb:     http://git.kernel.org/tip/c4cff064be678f1e8344d907499f2a81282edc19
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Mon, 23 Mar 2009 03:26:48 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 09:30:37 +0100

tracing/filters: clean up filter_add_subsystem_pred()

Impact: cleanup, memory leak fix

This patch cleans up filter_add_subsystem_pred():

- searches for the field before creating a copy of the pred

- fixes memory leak in the case a predicate isn't applied

- if -ENOMEM, makes sure there's no longer a reference to the
  pred so the caller can free the half-finished filter

- changes the confusing i == MAX_FILTER_PRED - 1 comparison
  previously remarked upon

This affects only per-subsystem event filtering.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237796808.7527.40.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_events.c        |    1 +
 kernel/trace/trace_events_filter.c |   31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 19f61dd..fdab30d 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -585,6 +585,7 @@ subsystem_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 
 	if (filter_add_subsystem_pred(system, pred)) {
+		filter_free_subsystem_preds(system);
 		filter_free_pred(pred);
 		return -EINVAL;
 	}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index fd01d80..4117c2e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -318,22 +318,39 @@ int filter_add_subsystem_pred(struct event_subsystem *system,
 			system->preds[i] = pred;
 			break;
 		}
-		if (i == MAX_FILTER_PRED - 1)
-			return -EINVAL;
 	}
 
+	if (i == MAX_FILTER_PRED)
+		return -EINVAL;
+
 	events_for_each(call) {
+		int err;
+
 		if (!call->name || !call->regfunc)
 			continue;
 
-		if (!strcmp(call->system, system->name)) {
-			event_pred = copy_pred(pred);
-			if (event_pred)
-				filter_add_pred(call, event_pred);
-		}
+		if (strcmp(call->system, system->name))
+			continue;
+
+		if (!find_event_field(call, pred->field_name))
+			continue;
+
+		event_pred = copy_pred(pred);
+		if (!event_pred)
+			goto oom;
+
+		err = filter_add_pred(call, event_pred);
+		if (err)
+			filter_free_pred(event_pred);
+		if (err == -ENOMEM)
+			goto oom;
 	}
 
 	return 0;
+
+oom:
+	system->preds[i] = NULL;
+	return -ENOMEM;
 }
 
 int filter_parse(char **pbuf, struct filter_pred *pred)
