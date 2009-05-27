Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbZE0WhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbZE0WhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZE0WgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:36:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:57647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761519AbZE0WgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:36:19 -0400
Date: Wed, 27 May 2009 22:35:10 GMT
From: tip-bot for Zhaolei <zhaolei@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, zhaolei@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, rostedt@goodmis.org,
       zhaolei@cn.fujitsu.com, tglx@linutronix.de
In-Reply-To: <4A14FDFE.2080402@cn.fujitsu.com>
References: <4A14FDFE.2080402@cn.fujitsu.com>
Subject: [tip:tracing/core] ftrace: clean up of using ftrace_event_enable_disable()
Message-ID: <tip-0e907c99391362385c8e3af2c43b904dd1fd5d73@git.kernel.org>
Git-Commit-ID: 0e907c99391362385c8e3af2c43b904dd1fd5d73
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 22:35:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e907c99391362385c8e3af2c43b904dd1fd5d73
Gitweb:     http://git.kernel.org/tip/0e907c99391362385c8e3af2c43b904dd1fd5d73
Author:     Zhaolei <zhaolei@cn.fujitsu.com>
AuthorDate: Mon, 25 May 2009 18:13:59 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 26 May 2009 03:30:31 +0200

ftrace: clean up of using ftrace_event_enable_disable()

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
