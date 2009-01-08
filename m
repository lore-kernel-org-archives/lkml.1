Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbZAHTDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbZAHTDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbZAHTDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:03:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZAHTDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:03:14 -0500
Date: Thu, 8 Jan 2009 14:03:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH] tracing/ftrace: handle more than one stat file per tracer
Message-ID: <alpine.DEB.1.10.0901081401270.24688@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Frederic Weisbecker (1):
      tracing/ftrace: handle more than one stat file per tracer

----
 kernel/trace/trace.h        |   35 ++++---
 kernel/trace/trace_branch.c |   69 +++++--------
 kernel/trace/trace_stat.c   |  230 +++++++++++++++++++++++++++++++------------
 3 files changed, 217 insertions(+), 117 deletions(-)
---------------------------
commit c119202210ceea67d037bb190e1bf5f5476dbf98
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Jan 8 10:03:56 2009 -0800

    tracing/ftrace: handle more than one stat file per tracer
    
    Impact: new API for tracers
    
    Make the stat tracing API reentrant. And also provide the new directory
    /debugfs/tracing/trace_stat which will contain all the stat files for the
    current active tracer.
    
    Now a tracer will, if desired, want to provide a zero terminated array of
    tracer_stat structures.
    Each one contains the callbacks necessary for one stat file.
    It have to provide at least a name for its stat file, an iterator with
    stat_start/start_next callback and an output callback for one stat entry.
    
    Also adapt the branch tracer to this new API.
    We create two files "all" and "annotated" inside the /debugfs/tracing/trace_stat
    directory, making the both stats simultaneously available instead of needing
    to change an option to switch from one stat file to another.
    
    The output of these stats haven't changed.
    
    Changes in v2:
    
    _ Apply the previous memory leak fix (rebase against tip/master)
    
    Changes in v3:
    
    _ Merge the patch that adapted the branch tracer to this Api in this patch to
      not break the kernel build.
    
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 94ed45e..b3f9ad1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -335,6 +335,25 @@ struct tracer_flags {
 #define TRACER_OPT(s, b)	.name = #s, .bit = b
 
 /*
+ * If you want to provide a stat file (one-shot statistics), fill
+ * an iterator with stat_start/stat_next and a stat_show callbacks.
+ * The others callbacks are optional.
+ */
+struct tracer_stat {
+	/* The name of your stat file */
+	const char		*name;
+	/* Iteration over statistic entries */
+	void			*(*stat_start)(void);
+	void			*(*stat_next)(void *prev, int idx);
+	/* Compare two entries for sorting (optional) for stats */
+	int			(*stat_cmp)(void *p1, void *p2);
+	/* Print a stat entry */
+	int			(*stat_show)(struct seq_file *s, void *p);
+	/* Print the headers of your stat entries */
+	int			(*stat_headers)(struct seq_file *s);
+};
+
+/*
  * A specific tracer, represented by methods that operate on a trace array:
  */
 struct tracer {
@@ -361,21 +380,7 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags 	*flags;
-
-	/*
-	 * If you change one of the following on tracing runtime, recall
-	 * init_tracer_stat()
-	 */
-
-	/* Iteration over statistic entries */
-	void			*(*stat_start)(void);
-	void			*(*stat_next)(void *prev, int idx);
-	/* Compare two entries for sorting (optional) for stats */
-	int			(*stat_cmp)(void *p1, void *p2);
-	/* Print a stat entry */
-	int			(*stat_show)(struct seq_file *s, void *p);
-	/* Print the headers of your stat entries */
-	int			(*stat_headers)(struct seq_file *s);
+	struct tracer_stat	*stats;
 };
 
 struct trace_seq {
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 4785a3b..da5cf3e 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -306,19 +306,6 @@ static int annotated_branch_stat_cmp(void *p1, void *p2)
 }
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-enum {
-	TRACE_BRANCH_OPT_ALL = 0x1
-};
-
-static struct tracer_opt branch_opts[] = {
-	{ TRACER_OPT(stat_all_branch, TRACE_BRANCH_OPT_ALL) },
-	{ }
-};
-
-static struct tracer_flags branch_flags = {
-	.val = 0,
-	.opts = branch_opts
-};
 
 extern unsigned long __start_branch_profile[];
 extern unsigned long __stop_branch_profile[];
@@ -352,28 +339,36 @@ all_branch_stat_next(void *v, int idx)
 	return p;
 }
 
-static int branch_set_flag(u32 old_flags, u32 bit, int set)
-{
-	if (bit == TRACE_BRANCH_OPT_ALL) {
-		if (set) {
-			branch_trace.stat_headers = all_branch_stat_headers;
-			branch_trace.stat_start = all_branch_stat_start;
-			branch_trace.stat_next = all_branch_stat_next;
-			branch_trace.stat_cmp = NULL;
-		} else {
-			branch_trace.stat_headers =
-				annotated_branch_stat_headers;
-			branch_trace.stat_start = annotated_branch_stat_start;
-			branch_trace.stat_next = annotated_branch_stat_next;
-			branch_trace.stat_cmp = annotated_branch_stat_cmp;
-		}
-		init_tracer_stat(&branch_trace);
-	}
-	return 0;
-}
+static struct tracer_stat branch_stats[] = {
+	{.name = "annotated",
+	.stat_start = annotated_branch_stat_start,
+	.stat_next = annotated_branch_stat_next,
+	.stat_cmp = annotated_branch_stat_cmp,
+	.stat_headers = annotated_branch_stat_headers,
+	.stat_show = branch_stat_show},
 
+	{.name = "all",
+	.stat_start = all_branch_stat_start,
+	.stat_next = all_branch_stat_next,
+	.stat_headers = all_branch_stat_headers,
+	.stat_show = branch_stat_show},
+
+	{ }
+};
+#else
+static struct tracer_stat branch_stats[] = {
+	{.name = "annotated",
+	.stat_start = annotated_branch_stat_start,
+	.stat_next = annotated_branch_stat_next,
+	.stat_cmp = annotated_branch_stat_cmp,
+	.stat_headers = annotated_branch_stat_headers,
+	.stat_show = branch_stat_show},
+
+	{ }
+};
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
 
+
 static struct tracer branch_trace __read_mostly =
 {
 	.name		= "branch",
@@ -383,16 +378,8 @@ static struct tracer branch_trace __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_branch,
 #endif /* CONFIG_FTRACE_SELFTEST */
-#endif /* CONFIG_BRANCH_TRACER */
-	.stat_start	=	annotated_branch_stat_start,
-	.stat_next	= annotated_branch_stat_next,
-	.stat_show	= branch_stat_show,
-	.stat_headers	= annotated_branch_stat_headers,
-	.stat_cmp	= annotated_branch_stat_cmp,
-#ifdef CONFIG_PROFILE_ALL_BRANCHES
-	.flags	= &branch_flags,
-	.set_flag	= branch_set_flag,
 #endif
+	.stats		= branch_stats
 };
 
 __init static int init_branch_trace(void)
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index f110ce9..1515f9e 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -21,37 +21,87 @@ struct trace_stat_list {
 	void *stat;
 };
 
-static LIST_HEAD(stat_list);
-
-/*
- * This is a copy of the current tracer to avoid racy
- * and dangerous output while the current tracer is
- * switched.
- */
-static struct tracer current_tracer;
+/* A stat session is the stats output in one file */
+struct tracer_stat_session {
+	struct tracer_stat *ts;
+	struct list_head stat_list;
+	struct mutex stat_mutex;
+};
 
-/*
- * Protect both the current tracer and the global
- * stat list.
- */
-static DEFINE_MUTEX(stat_list_mutex);
+/* All of the sessions currently in use. Each stat file embeed one session */
+static struct tracer_stat_session **all_stat_sessions;
+static int nb_sessions;
+static struct dentry *stat_dir, **stat_files;
 
 
-static void reset_stat_list(void)
+static void reset_stat_session(struct tracer_stat_session *session)
 {
 	struct trace_stat_list *node, *next;
 
-	list_for_each_entry_safe(node, next, &stat_list, list)
+	list_for_each_entry_safe(node, next, &session->stat_list, list)
 		kfree(node);
 
-	INIT_LIST_HEAD(&stat_list);
+	INIT_LIST_HEAD(&session->stat_list);
 }
 
-void init_tracer_stat(struct tracer *trace)
+/* Called when a tracer is initialized */
+static int init_all_sessions(int nb, struct tracer_stat *ts)
 {
-	mutex_lock(&stat_list_mutex);
-	current_tracer = *trace;
-	mutex_unlock(&stat_list_mutex);
+	int i, j;
+	struct tracer_stat_session *session;
+
+	nb_sessions = 0;
+
+	if (all_stat_sessions) {
+		for (i = 0; i < nb_sessions; i++) {
+			session = all_stat_sessions[i];
+			reset_stat_session(session);
+			mutex_destroy(&session->stat_mutex);
+			kfree(session);
+		}
+	}
+	all_stat_sessions = kmalloc(sizeof(struct tracer_stat_session *) * nb,
+				    GFP_KERNEL);
+	if (!all_stat_sessions)
+		return -ENOMEM;
+
+	for (i = 0; i < nb; i++) {
+		session = kmalloc(sizeof(struct tracer_stat_session) * nb,
+				  GFP_KERNEL);
+		if (!session)
+			goto free_sessions;
+
+		INIT_LIST_HEAD(&session->stat_list);
+		mutex_init(&session->stat_mutex);
+		session->ts = &ts[i];
+		all_stat_sessions[i] = session;
+	}
+	nb_sessions = nb;
+	return 0;
+
+free_sessions:
+
+	for (j = 0; j < i; j++)
+		kfree(all_stat_sessions[i]);
+
+	kfree(all_stat_sessions);
+	all_stat_sessions = NULL;
+
+	return -ENOMEM;
+}
+
+static int basic_tracer_stat_checks(struct tracer_stat *ts)
+{
+	int i;
+
+	if (!ts)
+		return 0;
+
+	for (i = 0; ts[i].name; i++) {
+		if (!ts[i].stat_start || !ts[i].stat_next || !ts[i].stat_show)
+			return -EBUSY;
+	}
+	return i;
 }
 
 /*
@@ -69,22 +119,19 @@ static int dummy_cmp(void *p1, void *p2)
  * All of these copies and sorting are required on all opening
  * since the stats could have changed between two file sessions.
  */
-static int stat_seq_init(void)
+static int stat_seq_init(struct tracer_stat_session *session)
 {
 	struct trace_stat_list *iter_entry, *new_entry;
+	struct tracer_stat *ts = session->ts;
 	void *prev_stat;
 	int ret = 0;
 	int i;
 
-	mutex_lock(&stat_list_mutex);
-	reset_stat_list();
-
-	if (!current_tracer.stat_start || !current_tracer.stat_next ||
-					!current_tracer.stat_show)
-		goto exit;
+	mutex_lock(&session->stat_mutex);
+	reset_stat_session(session);
 
-	if (!current_tracer.stat_cmp)
-		current_tracer.stat_cmp = dummy_cmp;
+	if (!ts->stat_cmp)
+		ts->stat_cmp = dummy_cmp;
 
 	/*
 	 * The first entry. Actually this is the second, but the first
@@ -97,9 +144,10 @@ static int stat_seq_init(void)
 	}
 
 	INIT_LIST_HEAD(&new_entry->list);
-	list_add(&new_entry->list, &stat_list);
-	new_entry->stat = current_tracer.stat_start();
 
+	list_add(&new_entry->list, &session->stat_list);
+
+	new_entry->stat = ts->stat_start();
 	prev_stat = new_entry->stat;
 
 	/*
@@ -114,15 +162,16 @@ static int stat_seq_init(void)
 		}
 
 		INIT_LIST_HEAD(&new_entry->list);
-		new_entry->stat = current_tracer.stat_next(prev_stat, i);
+		new_entry->stat = ts->stat_next(prev_stat, i);
 
 		/* End of insertion */
 		if (!new_entry->stat)
 			break;
 
-		list_for_each_entry(iter_entry, &stat_list, list) {
+		list_for_each_entry(iter_entry, &session->stat_list, list) {
+
 			/* Insertion with a descendent sorting */
-			if (current_tracer.stat_cmp(new_entry->stat,
+			if (ts->stat_cmp(new_entry->stat,
 						iter_entry->stat) > 0) {
 
 				list_add_tail(&new_entry->list,
@@ -131,7 +180,7 @@ static int stat_seq_init(void)
 
 			/* The current smaller value */
 			} else if (list_is_last(&iter_entry->list,
-						&stat_list)) {
+						&session->stat_list)) {
 				list_add(&new_entry->list, &iter_entry->list);
 				break;
 			}
@@ -140,49 +189,49 @@ static int stat_seq_init(void)
 		prev_stat = new_entry->stat;
 	}
 exit:
-	mutex_unlock(&stat_list_mutex);
+	mutex_unlock(&session->stat_mutex);
 	return ret;
 
 exit_free_list:
-	reset_stat_list();
-	mutex_unlock(&stat_list_mutex);
+	reset_stat_session(session);
+	mutex_unlock(&session->stat_mutex);
 	return ret;
 }
 
 
 static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct list_head *l = (struct list_head *)s->private;
+	struct tracer_stat_session *session = s->private;
 
 	/* Prevent from tracer switch or stat_list modification */
-	mutex_lock(&stat_list_mutex);
+	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && current_tracer.stat_headers)
-		current_tracer.stat_headers(s);
+	if (!*pos && session->ts->stat_headers)
+		session->ts->stat_headers(s);
 
-	return seq_list_start(l, *pos);
+	return seq_list_start(&session->stat_list, *pos);
 }
 
 static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
-	struct list_head *l = (struct list_head *)s->private;
+	struct tracer_stat_session *session = s->private;
 
-	return seq_list_next(p, l, pos);
+	return seq_list_next(p, &session->stat_list, pos);
 }
 
-static void stat_seq_stop(struct seq_file *m, void *p)
+static void stat_seq_stop(struct seq_file *s, void *p)
 {
-	mutex_unlock(&stat_list_mutex);
+	struct tracer_stat_session *session = s->private;
+	mutex_unlock(&session->stat_mutex);
 }
 
 static int stat_seq_show(struct seq_file *s, void *v)
 {
-	struct trace_stat_list *entry;
-
-	entry =	list_entry(v, struct trace_stat_list, list);
+	struct tracer_stat_session *session = s->private;
+	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
 
-	return current_tracer.stat_show(s, entry->stat);
+	return session->ts->stat_show(s, l->stat);
 }
 
 static const struct seq_operations trace_stat_seq_ops = {
@@ -192,15 +241,18 @@ static const struct seq_operations trace_stat_seq_ops = {
 	.show = stat_seq_show
 };
 
+/* The session stat is refilled and resorted at each stat file opening */
 static int tracing_stat_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
+	struct tracer_stat_session *session = inode->i_private;
+
 	ret = seq_open(file, &trace_stat_seq_ops);
 	if (!ret) {
 		struct seq_file *m = file->private_data;
-		m->private = &stat_list;
-		ret = stat_seq_init();
+		m->private = session;
+		ret = stat_seq_init(session);
 	}
 
 	return ret;
@@ -212,9 +264,12 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
  */
 static int tracing_stat_release(struct inode *i, struct file *f)
 {
-	mutex_lock(&stat_list_mutex);
-	reset_stat_list();
-	mutex_unlock(&stat_list_mutex);
+	struct tracer_stat_session *session = i->i_private;
+
+	mutex_lock(&session->stat_mutex);
+	reset_stat_session(session);
+	mutex_unlock(&session->stat_mutex);
+
 	return 0;
 }
 
@@ -225,17 +280,70 @@ static const struct file_operations tracing_stat_fops = {
 	.release	= tracing_stat_release
 };
 
+
+static void destroy_trace_stat_files(void)
+{
+	int i;
+
+	if (stat_files) {
+		for (i = 0; i < nb_sessions; i++)
+			debugfs_remove(stat_files[i]);
+		kfree(stat_files);
+		stat_files = NULL;
+	}
+}
+
+static void init_trace_stat_files(void)
+{
+	int i;
+
+	if (!stat_dir || !nb_sessions)
+		return;
+
+	stat_files = kmalloc(sizeof(struct dentry *) * nb_sessions, GFP_KERNEL);
+
+	if (!stat_files) {
+		pr_warning("trace stat: not enough memory\n");
+		return;
+	}
+
+	for (i = 0; i < nb_sessions; i++) {
+		struct tracer_stat_session *session = all_stat_sessions[i];
+		stat_files[i] = debugfs_create_file(session->ts->name, 0644,
+						stat_dir,
+						session, &tracing_stat_fops);
+		if (!stat_files[i])
+			pr_warning("cannot create %s entry\n",
+				   session->ts->name);
+	}
+}
+
+void init_tracer_stat(struct tracer *trace)
+{
+	int nb = basic_tracer_stat_checks(trace->stats);
+
+	destroy_trace_stat_files();
+
+	if (nb < 0) {
+		pr_warning("stat tracing: missing stat callback on %s\n",
+			   trace->name);
+		return;
+	}
+	if (!nb)
+		return;
+
+	init_all_sessions(nb, trace->stats);
+	init_trace_stat_files();
+}
+
 static int __init tracing_stat_init(void)
 {
 	struct dentry *d_tracing;
-	struct dentry *entry;
 
 	d_tracing = tracing_init_dentry();
 
-	entry = debugfs_create_file("trace_stat", 0444, d_tracing,
-					NULL,
-				    &tracing_stat_fops);
-	if (!entry)
+	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
+	if (!stat_dir)
 		pr_warning("Could not create debugfs "
 			   "'trace_stat' entry\n");
 	return 0;

