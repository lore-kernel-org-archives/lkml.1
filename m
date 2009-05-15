Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbZEODGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbZEODGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZEODGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:06:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbZEODGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:06:21 -0400
Message-ID: <4A0CDC6F.7070200@cn.fujitsu.com>
Date: Fri, 15 May 2009 11:07:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/filters: add missing unlock in a failure path
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Impact: fix deadlock in a rare case we fail to allocate memory ]

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.5.4.rc3


