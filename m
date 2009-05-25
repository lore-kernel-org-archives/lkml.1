Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZEYKR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZEYKR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZEYKRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:17:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZEYKRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:17:19 -0400
Message-ID: <4A1A6F67.1040106@cn.fujitsu.com>
Date: Mon, 25 May 2009 18:13:59 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] ftrace: clean up of using ftrace_event_enable_disable()
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <20090522115108.GA10992@elte.hu> <4A1A6CE8.2050100@cn.fujitsu.com>
In-Reply-To: <4A1A6CE8.2050100@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use tracing_stop_cmdline_record() to enable/disable a event.

Impact: cleanup, no functionality changed

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
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
1.5.5.3

