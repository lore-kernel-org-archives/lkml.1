Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZCWI1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZCWI1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZCWI0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:26:53 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:25360 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbZCWI0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EucZtG8Jypn+FrThTyVMpGP8eZkODOZJwQx6DT1DQ+i/Zg/vC53oV8Rj8lJUunLc8W
         bxiRd/1sxKcXiseFsAa00TtIgQUrADMinPDRfoJcz0X5iJqLDXjZrZ2U0BmqHq3Re7ho
         kq0QhXaG7TGljhEf97jL1UhMFI+KPJkyB4XGQ=
Subject: [PATCH] tracing/filters: clean up filter_add_subsystem_pred()
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 03:26:48 -0500
Message-Id: <1237796808.7527.40.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up filter_add_subsystem_pred():

- searches for the field before creating a copy of the pred
- fixes memory leak in the case a predicate isn't applied
- if -ENOMEM, makes sure there's no longer a reference to the pred so
the caller can free the half-finished filter
- changes the confusing i == MAX_FILTER_PRED - 1 comparison previously
remarked upon

This affects only per-subsystem event filtering.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace_events.c        |    1 +
 kernel/trace/trace_events_filter.c |   31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 594d78a..ee5e51f 100644
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
-- 
1.5.6.3



