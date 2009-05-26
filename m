Return-Path: <linux-kernel-owner+w=401wt.eu-S1754319AbZEZCG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbZEZCG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZEZCFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:05:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:27600 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZEZCFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vS2/Gn+sOrSSMLth6bv5mnDqpenxhF3d5mPK11rUTM7J2XFYatJgUVDnGKW3rjEG0L
         /QTzMHr9td53tqt1muGFz7+OBXEKipZisvJxyiwd/tOh45DwZJ7USyiFCsspZtU27+P2
         wvEw9zOsirkCBpQCooARJL0zBlc0FZGMY7XPo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] ftrace: clean up of using ftrace_event_enable_disable()
Date: Tue, 26 May 2009 04:04:50 +0200
Message-Id: <1243303490-8019-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Always use ftrace_event_enable_disable() to enable/disable an event
so that we can factorize out the event toggling code.

[ Impact: factorize and cleanup event tracing code ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <4A14FDFE.2080402@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3

