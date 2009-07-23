Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZGWDbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZGWDbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZGWDbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:31:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZGWDbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:31:19 -0400
Message-ID: <4A67D92B.4060704@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 11:29:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] tracing/stat: Fix seqfile memory leak
References: <4A67D8CB.4040909@cn.fujitsu.com>
In-Reply-To: <4A67D8CB.4040909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every time we cat a trace_stat file, we leak memory allocated by
seq_open().

Also fix memory leak in a failure path in tracing_stat_open().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_stat.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index f069461..07c60b0 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -76,7 +76,7 @@ static struct rb_node *release_next(struct tracer_stat *ts,
 	}
 }
 
-static void reset_stat_session(struct stat_session *session)
+static void __reset_stat_session(struct stat_session *session)
 {
 	struct rb_node *node = session->stat_root.rb_node;
 
@@ -86,10 +86,17 @@ static void reset_stat_session(struct stat_session *session)
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
@@ -153,7 +160,7 @@ static int stat_seq_init(struct stat_session *session)
 	int i;
 
 	mutex_lock(&session->stat_mutex);
-	reset_stat_session(session);
+	__reset_stat_session(session);
 
 	if (!ts->stat_cmp)
 		ts->stat_cmp = dummy_cmp;
@@ -186,7 +193,7 @@ exit:
 	return ret;
 
 exit_free_rbtree:
-	reset_stat_session(session);
+	__reset_stat_session(session);
 	mutex_unlock(&session->stat_mutex);
 	return ret;
 }
@@ -253,16 +260,21 @@ static const struct seq_operations trace_stat_seq_ops = {
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
 
@@ -273,11 +285,9 @@ static int tracing_stat_release(struct inode *i, struct file *f)
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
1.6.3

