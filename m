Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZG3T6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZG3T6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZG3T6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:58:44 -0400
Received: from www.tglx.de ([62.245.132.106]:56316 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZG3T6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:58:43 -0400
Date: Thu, 30 Jul 2009 21:58:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] tracing fixes for 2.6.31
Message-ID: <alpine.LFD.2.00.0907302157120.2936@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

Thanks,

	tglx

------------------>
Li Zefan (3):
      trace_stack: Fix seqfile memory leak
      function-graph: Fix seqfile memory leak
      tracing/stat: Fix seqfile memory leak

Mel Gorman (1):
      profile: Suppress warning about large allocations when profile=1 is specified


 kernel/profile.c           |    5 +++--
 kernel/trace/ftrace.c      |   15 ++++++++++++---
 kernel/trace/trace_stack.c |    7 ++-----
 kernel/trace/trace_stat.c  |   34 ++++++++++++++++++++++------------
 4 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 69911b5..419250e 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -117,11 +117,12 @@ int __ref profile_init(void)
 
 	cpumask_copy(prof_cpu_mask, cpu_possible_mask);
 
-	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL);
+	prof_buffer = kzalloc(buffer_bytes, GFP_KERNEL|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = alloc_pages_exact(buffer_bytes, GFP_KERNEL|__GFP_ZERO);
+	prof_buffer = alloc_pages_exact(buffer_bytes,
+					GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN);
 	if (prof_buffer)
 		return 0;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4521c77..1f3ec2a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2596,6 +2596,14 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 }
 
 static int
+ftrace_graph_release(struct inode *inode, struct file *file)
+{
+	if (file->f_mode & FMODE_READ)
+		seq_release(inode, file);
+	return 0;
+}
+
+static int
 ftrace_set_func(unsigned long *array, int *idx, char *buffer)
 {
 	struct dyn_ftrace *rec;
@@ -2724,9 +2732,10 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
 }
 
 static const struct file_operations ftrace_graph_fops = {
-	.open = ftrace_graph_open,
-	.read = seq_read,
-	.write = ftrace_graph_write,
+	.open		= ftrace_graph_open,
+	.read		= seq_read,
+	.write		= ftrace_graph_write,
+	.release	= ftrace_graph_release,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index e644af9..6a2a9d4 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -301,17 +301,14 @@ static const struct seq_operations stack_trace_seq_ops = {
 
 static int stack_trace_open(struct inode *inode, struct file *file)
 {
-	int ret;
-
-	ret = seq_open(file, &stack_trace_seq_ops);
-
-	return ret;
+	return seq_open(file, &stack_trace_seq_ops);
 }
 
 static const struct file_operations stack_trace_fops = {
 	.open		= stack_trace_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
+	.release	= seq_release,
 };
 
 int
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
