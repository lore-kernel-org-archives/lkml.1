Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbZIRGIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbZIRGIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZIRGIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:08:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59272 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbZIRGIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:08:16 -0400
Message-ID: <4AB32389.1030005@cn.fujitsu.com>
Date: Fri, 18 Sep 2009 14:07:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/events: use list_for_entry_continue
References: <4AB32364.7020602@cn.fujitsu.com>
In-Reply-To: <4AB32364.7020602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify s_next() and t_next().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
1.6.3

