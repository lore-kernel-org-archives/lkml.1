Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZG3Tzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZG3Tzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbZG3Tzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:55:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:32891 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZG3Tzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:55:49 -0400
Date: Thu, 30 Jul 2009 19:55:25 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A67D92B.4060704@cn.fujitsu.com>
References: <4A67D92B.4060704@cn.fujitsu.com>
Subject: [tip:tracing/urgent] tracing/stat: Fix seqfile memory leak
Message-ID: <tip-636eacee3b0c76915151db37203cc624becb6d7b@git.kernel.org>
Git-Commit-ID: 636eacee3b0c76915151db37203cc624becb6d7b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Jul 2009 19:55:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  636eacee3b0c76915151db37203cc624becb6d7b
Gitweb:     http://git.kernel.org/tip/636eacee3b0c76915151db37203cc624becb6d7b
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Thu, 23 Jul 2009 11:29:47 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 09:53:55 -0400

tracing/stat: Fix seqfile memory leak

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
