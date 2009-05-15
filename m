Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZEOEIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZEOEIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZEOEHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:07:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43594 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZEOEHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:07:47 -0400
Message-Id: <20090515040746.872536450@goodmis.org>
References: <20090515040554.074680910@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 00:05:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/4] tracing/filters: add missing unlock in a failure path
Content-Disposition: inline; filename=0003-tracing-filters-add-missing-unlock-in-a-failure-pat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

[ Impact: fix deadlock in a rare case we fail to allocate memory ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A0CDC6F.7070200@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 85ad6a8..22c2998 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1079,9 +1079,10 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		return 0;
 	}
 
+	err = -ENOMEM;
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
 	if (!ps)
-		return -ENOMEM;
+		goto out_unlock;
 
 	filter_disable_preds(call);
 	replace_filter_string(call->filter, filter_string);
@@ -1101,7 +1102,7 @@ out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
-
+out_unlock:
 	mutex_unlock(&filter_mutex);
 
 	return err;
@@ -1123,9 +1124,10 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 		return 0;
 	}
 
+	err = -ENOMEM;
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
 	if (!ps)
-		return -ENOMEM;
+		goto out_unlock;
 
 	filter_free_subsystem_preds(system);
 	replace_filter_string(system->filter, filter_string);
@@ -1145,7 +1147,7 @@ out:
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
-
+out_unlock:
 	mutex_unlock(&filter_mutex);
 
 	return err;
-- 
1.6.2.4

-- 
