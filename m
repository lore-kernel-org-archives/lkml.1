Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbZISPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbZISPxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZISPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:53:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54030 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbZISPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:52:45 -0400
Message-Id: <20090919155248.378508620@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 19 Sep 2009 11:52:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/3] [PATCH 3/3] tracing/events: use list_for_entry_continue
References: <20090919155203.005861436@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-events-use-list_for_entry_continue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Simplify s_next() and t_next().

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4AB32389.1030005@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   49 +++++++++++++-----------------------------
 1 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 56c260b..6f03c8a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -271,42 +271,32 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
 static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct list_head *list = m->private;
-	struct ftrace_event_call *call;
+	struct ftrace_event_call *call = v;
 
 	(*pos)++;
 
-	for (;;) {
-		if (list == &ftrace_events)
-			return NULL;
-
-		call = list_entry(list, struct ftrace_event_call, list);
-
+	list_for_each_entry_continue(call, &ftrace_events, list) {
 		/*
 		 * The ftrace subsystem is for showing formats only.
 		 * They can not be enabled or disabled via the event files.
 		 */
 		if (call->regfunc)
-			break;
-
-		list = list->next;
+			return call;
 	}
 
-	m->private = list->next;
-
-	return call;
+	return NULL;
 }
 
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct ftrace_event_call *call = NULL;
+	struct ftrace_event_call *call;
 	loff_t l;
 
 	mutex_lock(&event_mutex);
 
-	m->private = ftrace_events.next;
+	call = list_entry(&ftrace_events, struct ftrace_event_call, list);
 	for (l = 0; l <= *pos; ) {
-		call = t_next(m, NULL, &l);
+		call = t_next(m, call, &l);
 		if (!call)
 			break;
 	}
@@ -316,37 +306,28 @@ static void *t_start(struct seq_file *m, loff_t *pos)
 static void *
 s_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct list_head *list = m->private;
-	struct ftrace_event_call *call;
+	struct ftrace_event_call *call = v;
 
 	(*pos)++;
 
- retry:
-	if (list == &ftrace_events)
-		return NULL;
-
-	call = list_entry(list, struct ftrace_event_call, list);
-
-	if (!call->enabled) {
-		list = list->next;
-		goto retry;
+	list_for_each_entry_continue(call, &ftrace_events, list) {
+		if (call->enabled)
+			return call;
 	}
 
-	m->private = list->next;
-
-	return call;
+	return NULL;
 }
 
 static void *s_start(struct seq_file *m, loff_t *pos)
 {
-	struct ftrace_event_call *call = NULL;
+	struct ftrace_event_call *call;
 	loff_t l;
 
 	mutex_lock(&event_mutex);
 
-	m->private = ftrace_events.next;
+	call = list_entry(&ftrace_events, struct ftrace_event_call, list);
 	for (l = 0; l <= *pos; ) {
-		call = s_next(m, NULL, &l);
+		call = s_next(m, call, &l);
 		if (!call)
 			break;
 	}
-- 
1.6.3.3


