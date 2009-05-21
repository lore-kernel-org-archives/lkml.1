Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbZEUOTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbZEUOTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 10:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbZEUOTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 10:19:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbZEUOTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 10:19:14 -0400
Message-Id: <20090521141914.483312939@goodmis.org>
References: <20090521141813.123165156@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 21 May 2009 10:18:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] ftrace: clean up of using ftrace_event_enable_disable()
Content-Disposition: inline; filename=0002-ftrace-clean-up-of-using-ftrace_event_enable_disabl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Always use tracing_stop_cmdline_record() to enable/disable a event.

Impact: cleanup, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
LKML-Reference: <4A14FE45.6070308@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   44 +++++++++++++-----------------------------
 1 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9b246eb..6c81f9c 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -76,26 +76,9 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
 
 #endif /* CONFIG_MODULES */
 
-static void ftrace_clear_events(void)
-{
-	struct ftrace_event_call *call;
-
-	mutex_lock(&event_mutex);
-	list_for_each_entry(call, &ftrace_events, list) {
-
-		if (call->enabled) {
-			call->enabled = 0;
-			tracing_stop_cmdline_record();
-			call->unregfunc();
-		}
-	}
-	mutex_unlock(&event_mutex);
-}
-
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
-
 	switch (enable) {
 	case 0:
 		if (call->enabled) {
@@ -114,6 +97,17 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 	}
 }
 
+static void ftrace_clear_events(void)
+{
+	struct ftrace_event_call *call;
+
+	mutex_lock(&event_mutex);
+	list_for_each_entry(call, &ftrace_events, list) {
+		ftrace_event_enable_disable(call, 0);
+	}
+	mutex_unlock(&event_mutex);
+}
+
 /*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
@@ -1059,11 +1053,7 @@ static void trace_module_remove_events(struct module *mod)
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
 			found = true;
-			if (call->enabled) {
-				call->enabled = 0;
-				tracing_stop_cmdline_record();
-				call->unregfunc();
-			}
+			ftrace_event_enable_disable(call, 0);
 			if (call->event)
 				unregister_ftrace_event(call->event);
 			debugfs_remove_recursive(call->dir);
@@ -1265,15 +1255,9 @@ static __init void event_trace_self_tests(void)
 			continue;
 		}
 
-		call->enabled = 1;
-		tracing_start_cmdline_record();
-		call->regfunc();
-
+		ftrace_event_enable_disable(call, 1);
 		event_test_stuff();
-
-		call->unregfunc();
-		tracing_stop_cmdline_record();
-		call->enabled = 0;
+		ftrace_event_enable_disable(call, 0);
 
 		pr_cont("OK\n");
 	}
-- 
1.6.2.4

-- 
