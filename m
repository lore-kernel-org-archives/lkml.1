Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZHDTBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZHDTBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZHDTBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:01:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58056 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096AbZHDTBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:01:49 -0400
Date: Tue, 4 Aug 2009 21:01:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] tracing fixes
Message-ID: <20090804190134.GA341@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Lai Jiangshan (2):
      tracing: Fix invalid function_graph entry
      tracing: Fix missing function_graph events when we splice_read from trace_pipe

Li Zefan (3):
      trace_stack: Fix seqfile memory leak
      function-graph: Fix seqfile memory leak
      tracing/stat: Fix seqfile memory leak

Matt Fleming (2):
      ftrace: Fix the conditional that updates $ref_func
      ftrace: Only update $offset when we update $ref_func

Mel Gorman (1):
      profile: Suppress warning about large allocations when profile=1 is specified

Steven Rostedt (2):
      tracing: show proper address for trace-printk format
      tracing: only truncate ftrace files when O_TRUNC is set

Thomas Gleixner (1):
      trace: stop tracer in oops_enter()


 kernel/panic.c                       |    1 +
 kernel/profile.c                     |    5 +++--
 kernel/trace/ftrace.c                |   19 ++++++++++++++-----
 kernel/trace/trace.c                 |   12 ++++++++----
 kernel/trace/trace_events.c          |    2 +-
 kernel/trace/trace_functions_graph.c |   11 +++++++++--
 kernel/trace/trace_printk.c          |    2 +-
 kernel/trace/trace_stack.c           |    7 ++-----
 kernel/trace/trace_stat.c            |   34 ++++++++++++++++++++++------------
 scripts/recordmcount.pl              |    5 +++--
 10 files changed, 64 insertions(+), 34 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 984b3ec..512ab73 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -301,6 +301,7 @@ int oops_may_print(void)
  */
 void oops_enter(void)
 {
+	tracing_off();
 	/* can't trust the integrity of the kernel anymore: */
 	debug_locks_off();
 	do_oops_enter_exit();
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
index 4521c77..1e1d23c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1662,7 +1662,7 @@ ftrace_regex_open(struct inode *inode, struct file *file, int enable)
 
 	mutex_lock(&ftrace_regex_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND))
+	    (file->f_flags & O_TRUNC))
 		ftrace_filter_reset(enable);
 
 	if (file->f_mode & FMODE_READ) {
@@ -2577,7 +2577,7 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 
 	mutex_lock(&graph_lock);
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND)) {
+	    (file->f_flags & O_TRUNC)) {
 		ftrace_graph_count = 0;
 		memset(ftrace_graph_funcs, 0, sizeof(ftrace_graph_funcs));
 	}
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
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8bc8d8a..8930e39 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2031,7 +2031,7 @@ static int tracing_open(struct inode *inode, struct file *file)
 
 	/* If this file was open for write, then erase contents */
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND)) {
+	    (file->f_flags & O_TRUNC)) {
 		long cpu = (long) inode->i_private;
 
 		if (cpu == TRACE_PIPE_ALL_CPU)
@@ -3085,7 +3085,8 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 			break;
 		}
 
-		trace_consume(iter);
+		if (ret != TRACE_TYPE_NO_CONSUME)
+			trace_consume(iter);
 		rem -= count;
 		if (!find_next_entry_inc(iter))	{
 			rem = 0;
@@ -4233,8 +4234,11 @@ static void __ftrace_dump(bool disable_tracing)
 		iter.pos = -1;
 
 		if (find_next_entry_inc(&iter) != NULL) {
-			print_trace_line(&iter);
-			trace_consume(&iter);
+			int ret;
+
+			ret = print_trace_line(&iter);
+			if (ret != TRACE_TYPE_NO_CONSUME)
+				trace_consume(&iter);
 		}
 
 		trace_printk_seq(&iter.seq);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 53c8fd3..23d2972 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -376,7 +376,7 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
 	const struct seq_operations *seq_ops;
 
 	if ((file->f_mode & FMODE_WRITE) &&
-	    !(file->f_flags & O_APPEND))
+	    (file->f_flags & O_TRUNC))
 		ftrace_clear_events();
 
 	seq_ops = inode->i_private;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index d2249ab..420ec34 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -843,9 +843,16 @@ print_graph_function(struct trace_iterator *iter)
 
 	switch (entry->type) {
 	case TRACE_GRAPH_ENT: {
-		struct ftrace_graph_ent_entry *field;
+		/*
+		 * print_graph_entry() may consume the current event,
+		 * thus @field may become invalid, so we need to save it.
+		 * sizeof(struct ftrace_graph_ent_entry) is very small,
+		 * it can be safely saved at the stack.
+		 */
+		struct ftrace_graph_ent_entry *field, saved;
 		trace_assign_type(field, entry);
-		return print_graph_entry(field, s, iter);
+		saved = *field;
+		return print_graph_entry(&saved, s, iter);
 	}
 	case TRACE_GRAPH_RET: {
 		struct ftrace_graph_ret_entry *field;
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 7b62781..687699d 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -176,7 +176,7 @@ static int t_show(struct seq_file *m, void *v)
 	const char *str = *fmt;
 	int i;
 
-	seq_printf(m, "0x%lx : \"", (unsigned long)fmt);
+	seq_printf(m, "0x%lx : \"", *(unsigned long *)fmt);
 
 	/*
 	 * Tabs and new lines need to be converted.
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
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7109e2b..d29baa2 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -403,7 +403,6 @@ while (<IN>) {
     # section found, now is this a start of a function?
     } elsif ($read_function && /$function_regex/) {
 	$text_found = 1;
-	$offset = hex $1;
 	$text = $2;
 
 	# if this is either a local function or a weak function
@@ -412,10 +411,12 @@ while (<IN>) {
 	if (!defined($locals{$text}) && !defined($weak{$text})) {
 	    $ref_func = $text;
 	    $read_function = 0;
+	    $offset = hex $1;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) || !defined($weak{$text})) {
+	    if (!defined($ref_func) && !defined($weak{$text})) {
 		$ref_func = $text;
+		$offset = hex $1;
 	    }
 	}
     } elsif ($read_headers && /$mcount_section/) {
