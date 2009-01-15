Return-Path: <linux-kernel-owner+w=401wt.eu-S1763934AbZAOKil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763934AbZAOKil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763437AbZAOKi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:38:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41595 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbZAOKi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:38:26 -0500
Date: Thu, 15 Jan 2009 11:38:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tracing: trace_stat.c cleanup
Message-ID: <20090115103806.GC29296@elte.hu>
References: <alpine.DEB.1.10.0901142056470.22004@gandalf.stny.rr.com> <alpine.DEB.1.10.0901150524340.716@gandalf.stny.rr.com> <20090115102800.GB29296@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115102800.GB29296@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., while looking into the kernel/trace/trace_stat.c file to fix this 
build bug i also did the cleanups below.

	Ingo

------------>
>From 55922173f1f63903b6de03711ab8ff980cbe58d2 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 15 Jan 2009 11:31:21 +0100
Subject: [PATCH] tracing: trace_stat.c cleanup

Impact: cleanup

- whitespace / code alignment cleanups
- avoid unnecessary forward prototype by reordering functions

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_stat.c |  147 ++++++++++++++++++++++-----------------------
 1 files changed, 71 insertions(+), 76 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 2110cea..eae9cef 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -17,16 +17,16 @@
 
 /* List of stat entries from a tracer */
 struct trace_stat_list {
-	struct list_head 	list;
-	void 			*stat;
+	struct list_head	list;
+	void			*stat;
 };
 
 /* A stat session is the stats output in one file */
 struct tracer_stat_session {
 	struct list_head	session_list;
-	struct tracer_stat 	*ts;
-	struct list_head 	stat_list;
-	struct mutex 		stat_mutex;
+	struct tracer_stat	*ts;
+	struct list_head	stat_list;
+	struct mutex		stat_mutex;
 	struct dentry		*file;
 };
 
@@ -35,7 +35,7 @@ static LIST_HEAD(all_stat_sessions);
 static DEFINE_MUTEX(all_stat_sessions_mutex);
 
 /* The root directory for all stat files */
-static struct dentry *stat_dir;
+static struct dentry		*stat_dir;
 
 
 static void reset_stat_session(struct tracer_stat_session *session)
@@ -56,71 +56,6 @@ static void destroy_session(struct tracer_stat_session *session)
 	kfree(session);
 }
 
-
-static int init_stat_file(struct tracer_stat_session *session);
-
-int register_stat_tracer(struct tracer_stat *trace)
-{
-	struct tracer_stat_session *session, *node, *tmp;
-	int ret;
-
-	if (!trace)
-		return -EINVAL;
-
-	if (!trace->stat_start || !trace->stat_next || !trace->stat_show)
-		return -EINVAL;
-
-	/* Already registered? */
-	mutex_lock(&all_stat_sessions_mutex);
-	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
-		if (node->ts == trace) {
-			mutex_unlock(&all_stat_sessions_mutex);
-			return -EINVAL;
-		}
-	}
-	mutex_unlock(&all_stat_sessions_mutex);
-
-	/* Init the session */
-	session = kmalloc(sizeof(struct tracer_stat_session), GFP_KERNEL);
-	if (!session)
-		return -ENOMEM;
-
-	session->ts = trace;
-	INIT_LIST_HEAD(&session->session_list);
-	INIT_LIST_HEAD(&session->stat_list);
-	mutex_init(&session->stat_mutex);
-	session->file = NULL;
-
-	ret = init_stat_file(session);
-	if (ret) {
-		destroy_session(session);
-		return ret;
-	}
-
-	/* Register */
-	mutex_lock(&all_stat_sessions_mutex);
-	list_add_tail(&session->session_list, &all_stat_sessions);
-	mutex_unlock(&all_stat_sessions_mutex);
-
-	return 0;
-}
-
-void unregister_stat_tracer(struct tracer_stat *trace)
-{
-	struct tracer_stat_session *node, *tmp;
-
-	mutex_lock(&all_stat_sessions_mutex);
-	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
-		if (node->ts == trace) {
-			list_del(&node->session_list);
-			destroy_session(node);
-			break;
-		}
-	}
-	mutex_unlock(&all_stat_sessions_mutex);
-}
-
-
 /*
  * For tracers that don't provide a stat_cmp callback.
  * This one will force an immediate insertion on tail of
@@ -252,10 +187,10 @@ static int stat_seq_show(struct seq_file *s, void *v)
 }
 
 static const struct seq_operations trace_stat_seq_ops = {
-	.start = stat_seq_start,
-	.next = stat_seq_next,
-	.stop = stat_seq_stop,
-	.show = stat_seq_show
+	.start		= stat_seq_start,
+	.next		= stat_seq_next,
+	.stop		= stat_seq_stop,
+	.show		= stat_seq_show
 };
 
 /* The session stat is refilled and resorted at each stat file opening */
@@ -275,7 +210,6 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-
 /*
  * Avoid consuming memory with our now useless list.
  */
@@ -322,3 +256,64 @@ static int init_stat_file(struct tracer_stat_session *session)
 		return -ENOMEM;
 	return 0;
 }
+
+int register_stat_tracer(struct tracer_stat *trace)
+{
+	struct tracer_stat_session *session, *node, *tmp;
+	int ret;
+
+	if (!trace)
+		return -EINVAL;
+
+	if (!trace->stat_start || !trace->stat_next || !trace->stat_show)
+		return -EINVAL;
+
+	/* Already registered? */
+	mutex_lock(&all_stat_sessions_mutex);
+	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
+		if (node->ts == trace) {
+			mutex_unlock(&all_stat_sessions_mutex);
+			return -EINVAL;
+		}
+	}
+	mutex_unlock(&all_stat_sessions_mutex);
+
+	/* Init the session */
+	session = kmalloc(sizeof(struct tracer_stat_session), GFP_KERNEL);
+	if (!session)
+		return -ENOMEM;
+
+	session->ts = trace;
+	INIT_LIST_HEAD(&session->session_list);
+	INIT_LIST_HEAD(&session->stat_list);
+	mutex_init(&session->stat_mutex);
+	session->file = NULL;
+
+	ret = init_stat_file(session);
+	if (ret) {
+		destroy_session(session);
+		return ret;
+	}
+
+	/* Register */
+	mutex_lock(&all_stat_sessions_mutex);
+	list_add_tail(&session->session_list, &all_stat_sessions);
+	mutex_unlock(&all_stat_sessions_mutex);
+
+	return 0;
+}
+
+void unregister_stat_tracer(struct tracer_stat *trace)
+{
+	struct tracer_stat_session *node, *tmp;
+
+	mutex_lock(&all_stat_sessions_mutex);
+	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
+		if (node->ts == trace) {
+			list_del(&node->session_list);
+			destroy_session(node);
+			break;
+		}
+	}
+	mutex_unlock(&all_stat_sessions_mutex);
+}
