Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZGWOF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZGWOF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZGWOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:05:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61810 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZGWOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:05:16 -0400
Message-Id: <20090723140514.618865521@goodmis.org>
References: <20090723140259.100790900@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 10:03:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] tracing/stat: Fix seqfile memory leak
Content-Disposition: inline; filename=0003-tracing-stat-Fix-seqfile-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Every time we cat a trace_stat file, we leak memory allocated by
seq_open().

Also fix memory leak in a failure path in tracing_stat_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A67D92B.4060704@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stat.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index e66f5e4..aea321c 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -73,7 +73,7 @@ static struct rb_node *release_next(struct rb_node *node)
 	}
 }
 
-static void reset_stat_session(struct stat_session *session)
+static void __reset_stat_session(struct stat_session *session)
 {
 	struct rb_node *node = session->stat_root.rb_node;
 
@@ -83,10 +83,17 @@ static void reset_stat_session(struct stat_session *session)
 	session->stat_root = RB_ROOT;
 }
 
+static void reset_stat_session(struct stat_session *session)
+{
+	mutex_lock(&session->stat_mutex);
+	__reset_stat_session(session);
+	mutex_unlock(&session->stat_mutex);
+}
+
 static void destroy_session(struct stat_session *session)
 {
 	debugfs_remove(session->file);
-	reset_stat_session(session);
+	__reset_stat_session(session);
 	mutex_destroy(&session->stat_mutex);
 	kfree(session);
 }
@@ -150,7 +157,7 @@ static int stat_seq_init(struct stat_session *session)
 	int i;
 
 	mutex_lock(&session->stat_mutex);
-	reset_stat_session(session);
+	__reset_stat_session(session);
 
 	if (!ts->stat_cmp)
 		ts->stat_cmp = dummy_cmp;
@@ -183,7 +190,7 @@ exit:
 	return ret;
 
 exit_free_rbtree:
-	reset_stat_session(session);
+	__reset_stat_session(session);
 	mutex_unlock(&session->stat_mutex);
 	return ret;
 }
@@ -250,16 +257,21 @@ static const struct seq_operations trace_stat_seq_ops = {
 static int tracing_stat_open(struct inode *inode, struct file *file)
 {
 	int ret;
-
+	struct seq_file *m;
 	struct stat_session *session = inode->i_private;
 
+	ret = stat_seq_init(session);
+	if (ret)
+		return ret;
+
 	ret = seq_open(file, &trace_stat_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = session;
-		ret = stat_seq_init(session);
+	if (ret) {
+		reset_stat_session(session);
+		return ret;
 	}
 
+	m = file->private_data;
+	m->private = session;
 	return ret;
 }
 
@@ -270,11 +282,9 @@ static int tracing_stat_release(struct inode *i, struct file *f)
 {
 	struct stat_session *session = i->i_private;
 
-	mutex_lock(&session->stat_mutex);
 	reset_stat_session(session);
-	mutex_unlock(&session->stat_mutex);
 
-	return 0;
+	return seq_release(i, f);
 }
 
 static const struct file_operations tracing_stat_fops = {
-- 
1.6.3.3

-- 
