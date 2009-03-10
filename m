Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbZCJVHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbZCJVHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZCJVFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:05:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbZCJVFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:05:35 -0400
Message-Id: <20090310210530.864799514@goodmis.org>
References: <20090310210408.419131392@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 17:04:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/7] tracing: do not allow modifying the ftrace events via the event files
Content-Disposition: inline; filename=0002-tracing-do-not-allow-modifying-the-ftrace-events-vi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to prevent crash on calling NULL function pointer

The ftrace internal records have their format exported via the event
system under the ftrace subsystem. These are only for exporting the
format to allow binary readers to be able to parse them in a binary
output.

The ftrace subsystem events can only be enabled via the ftrace tracers
and do not have a registering function. The event files expect the
event record to have registering function and will call it directly.
Passing in a ftrace subsystem event will cause the kernel to crash
because it will execute a NULL pointer.

This patch prevents the ftrace subsystem from being viewable to the
event enabling files.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_events.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a0b41cc..85ec10f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -102,7 +102,7 @@ static int ftrace_set_clr_event(char *buf, int set)
 	mutex_lock(&event_mutex);
 	events_for_each(call) {
 
-		if (!call->name)
+		if (!call->name || !call->regfunc)
 			continue;
 
 		if (match &&
@@ -207,8 +207,20 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
-		return NULL;
+	for (;;) {
+		if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+			return NULL;
+
+		/*
+		 * The ftrace subsystem is for showing formats only.
+		 * They can not be enabled or disabled via the event files.
+		 */
+		if (call->regfunc)
+			break;
+
+		call++;
+		next = call;
+	}
 
 	m->private = ++next;
 
-- 
1.6.1.3

-- 
