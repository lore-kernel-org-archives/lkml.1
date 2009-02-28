Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZB1JLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZB1JLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZB1JJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:09:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60046 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbZB1JJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:09:40 -0500
Message-Id: <20090228090937.335053911@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 28 Feb 2009 04:06:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 03/10] tracing: make the set_event and available_events subsystem aware
Content-Disposition: inline; filename=0003-tracing-make-the-set_event-and-available_events-sub.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch makes the event files, set_event and available_events
aware of the subsystem.

Now you can enable an entire subsystem with:

  echo 'irq:*' > set_event

Note: the '*' is not needed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |   45 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1933220..b811eb3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -12,6 +12,8 @@
 
 #include "trace_events.h"
 
+#define TRACE_SYSTEM "TRACE_SYSTEM"
+
 #define events_for_each(event)						\
 	for (event = __start_ftrace_events;				\
 	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
@@ -45,14 +47,47 @@ static void ftrace_clear_events(void)
 static int ftrace_set_clr_event(char *buf, int set)
 {
 	struct ftrace_event_call *call = __start_ftrace_events;
+	char *event = NULL, *sub = NULL, *match;
+	int ret = -EINVAL;
+
+	/*
+	 * The buf format can be <subsystem>:<event-name>
+	 *  *:<event-name> means any event by that name.
+	 *  :<event-name> is the same.
+	 *
+	 *  <subsystem>:* means all events in that subsystem
+	 *  <subsystem>: means the same.
+	 *
+	 *  <name> (no ':') means all events in a subsystem with
+	 *  the name <name> or any event that matches <name>
+	 */
+
+	match = strsep(&buf, ":");
+	if (buf) {
+		sub = match;
+		event = buf;
+		match = NULL;
 
+		if (!strlen(sub) || strcmp(sub, "*") == 0)
+			sub = NULL;
+		if (!strlen(event) || strcmp(event, "*") == 0)
+			event = NULL;
+	}
 
 	events_for_each(call) {
 
 		if (!call->name)
 			continue;
 
-		if (strcmp(buf, call->name) != 0)
+		if (match &&
+		    strcmp(match, call->name) != 0 &&
+		    strcmp(match, call->system) != 0)
+			continue;
+
+		if (sub && strcmp(sub, call->system) != 0)
+			continue;
+
+		if (event && strcmp(event, call->name) != 0)
 			continue;
 
 		if (set) {
@@ -68,9 +103,9 @@ static int ftrace_set_clr_event(char *buf, int set)
 			call->enabled = 0;
 			call->unregfunc();
 		}
-		return 0;
+		ret = 0;
 	}
-	return -EINVAL;
+	return ret;
 }
 
 /* 128 should be much more than enough */
@@ -200,6 +235,8 @@ static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_event_call *call = v;
 
+	if (strcmp(call->system, TRACE_SYSTEM) != 0)
+		seq_printf(m, "%s:", call->system);
 	seq_printf(m, "%s\n", call->name);
 
 	return 0;
-- 
1.5.6.5

-- 
