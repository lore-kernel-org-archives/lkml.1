Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZCBUaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZCBUaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCBUa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:30:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZCBUa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:30:27 -0500
Message-Id: <20090302203024.132325230@goodmis.org>
References: <20090302202925.364437449@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 02 Mar 2009 15:29:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/7] tracing: add protection around modify trace event fields
Content-Disposition: inline; filename=0002-tracing-add-protection-around-modify-trace-event-fi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The trace event objects are currently not proctected against
reentrancy. This patch adds a mutex around the modifications of
the trace event fields.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d07f80..26069fa 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -14,6 +14,8 @@
 
 #define TRACE_SYSTEM "TRACE_SYSTEM"
 
+static DEFINE_MUTEX(event_mutex);
+
 #define events_for_each(event)						\
 	for (event = __start_ftrace_events;				\
 	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
@@ -104,6 +106,7 @@ static int ftrace_set_clr_event(char *buf, int set)
 			event = NULL;
 	}
 
+	mutex_lock(&event_mutex);
 	events_for_each(call) {
 
 		if (!call->name)
@@ -124,6 +127,8 @@ static int ftrace_set_clr_event(char *buf, int set)
 
 		ret = 0;
 	}
+	mutex_unlock(&event_mutex);
+
 	return ret;
 }
 
@@ -324,7 +329,9 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	switch (val) {
 	case 0:
 	case 1:
+		mutex_lock(&event_mutex);
 		ftrace_event_enable_disable(call, val);
+		mutex_unlock(&event_mutex);
 		break;
 
 	default:
-- 
1.5.6.5

-- 
