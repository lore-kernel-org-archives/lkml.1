Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZHHPt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZHHPt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZHHPt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:49:56 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:42867 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZHHPty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=L5a2rUEVwUf4o82XhF9usHJT35y5tvWefJw1cVITyvTJlNc7nq+TVJzLFLydIp24fl
         GTTr5Tl8UX+BpXEKEKaoT0BiqH23kC1i5aJd/9YzkbcdmM74MNstu2TbOv74sMOP9z78
         4tQpJubVhiWaMVrJZwok/jDfgdhLKwg4xuty4=
Subject: [2.6.31 PATCH] tracing/filters: always free pred on
 filter_add_subsystem_pred() failure
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 10:49:53 -0500
Message-Id: <1249746593.6453.32.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If filter_add_subsystem_pred() fails due to ENOSPC or ENOMEM, the pred
doesn't get freed, while as a side effect it does for other errors.
Make it so the caller always frees the pred for any error.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
 
-- 
1.5.6.3



