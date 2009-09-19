Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZISSFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZISSFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZISSFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:05:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:46132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZISSFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:05:11 -0400
Date: Sat, 19 Sep 2009 18:04:06 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, rostedt@goodmis.org,
       tglx@linutronix.de
In-Reply-To: <4AB32389.1030005@cn.fujitsu.com>
References: <4AB32389.1030005@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/events: use list_for_entry_continue
Message-ID: <tip-30bd39cd6244ffe3258c9203405286ef77b1c4eb@git.kernel.org>
Git-Commit-ID: 30bd39cd6244ffe3258c9203405286ef77b1c4eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 18:04:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30bd39cd6244ffe3258c9203405286ef77b1c4eb
Gitweb:     http://git.kernel.org/tip/30bd39cd6244ffe3258c9203405286ef77b1c4eb
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 18 Sep 2009 14:07:05 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 19 Sep 2009 11:30:40 -0400

tracing/events: use list_for_entry_continue

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
