Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZFBDvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZFBDvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbZFBDvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:51:14 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:40347 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbZFBDvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lr01pZyhAuDDiR/uJf4MYP6igg/NSB5D2PUfcmVvJiJhr5f0oDNvgAwTspfbFce7fV
         o4Xl5hI9C+h5XcT1OpnUZQu40/90LMHFFujNv2lcYQ9aWeYlvuQAJtN3vKDTSXa9CZ2I
         F75voSRpZk2Fipb2YtvxVvrNX3nS9fC+Gbhuc=
Date: Tue, 2 Jun 2009 05:51:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tracing stat and tracing workqueue bits
Message-ID: <20090602035110.GA4936@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is a rebase of stat and workqueue bits against tracing/core.

- Workqueue tracer bits:

Those are only fixes from -rc1 and exclude the features that were
done on it (worklet tracing, etc...).

The features part are waiting for another cycle to reduce the amount
of code, ie: by using the internal stat hashlist.
The exception is the conversion from existing tracepoints to TRACE_EVENT,
which is a pretty natural evolution of the tracepoints themselves.

- Histogram tracing bits

They are all included, features and fixes (rbtree sort based, etc..).

Thanks,
Frederic.



The following changes since commit f2aebaee653a35b01c3665de2cbb1e31456b8ea8:
  Zhaolei (1):
        ftrace: don't convert function's local variable name in macro

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/fixes

Frederic Weisbecker (3):
      tracing/stat: replace trace_stat_session by stat_session
      tracing/stat: replace linked list by an rbtree for sorting
      tracing/stat: remove unappropriate safe walk on list

Li Zefan (3):
      tracing/stat: change dummpy_cmp() to return -1
      tracing/stat: remember to free root node
      tracing/stat: do some cleanups

Zhaolei (4):
      ftrace, workqueuetrace: make workqueue tracepoints use TRACE_EVENT macro
      trace_workqueue: use list_for_each_entry() instead of list_for_each_entry_safe()
      trace_workqueue: remove cpu_workqueue_stats->first_entry
      trace_workqueue: remove blank line between each cpu

 include/trace/events/workqueue.h |  100 ++++++++++++++++++
 include/trace/workqueue.h        |   25 -----
 kernel/trace/trace_stat.c        |  206 +++++++++++++++++++++++---------------
 kernel/trace/trace_workqueue.c   |   23 +----
 kernel/workqueue.c               |   11 +--
 5 files changed, 234 insertions(+), 131 deletions(-)
 create mode 100644 include/trace/events/workqueue.h
 delete mode 100644 include/trace/workqueue.h

---
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
new file mode 100644
index 0000000..035f1bf
--- /dev/null
+++ b/include/trace/events/workqueue.h
@@ -0,0 +1,100 @@
+#if !defined(_TRACE_WORKQUEUE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_WORKQUEUE_H
+
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM workqueue
+
+TRACE_EVENT(workqueue_insertion,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->func)
+);
+
+TRACE_EVENT(workqueue_execution,
+
+	TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
+
+	TP_ARGS(wq_thread, work),
+
+	TP_STRUCT__entry(
+		__array(char,		thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,		thread_pid)
+		__field(work_func_t,	func)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->func		= work->func;
+	),
+
+	TP_printk("thread=%s:%d func=%pF", __entry->thread_comm,
+		__entry->thread_pid, __entry->func)
+);
+
+/* Trace the creation of one workqueue thread on a cpu */
+TRACE_EVENT(workqueue_creation,
+
+	TP_PROTO(struct task_struct *wq_thread, int cpu),
+
+	TP_ARGS(wq_thread, cpu),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+		__field(int,	cpu)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("thread=%s:%d cpu=%d", __entry->thread_comm,
+		__entry->thread_pid, __entry->cpu)
+);
+
+TRACE_EVENT(workqueue_destruction,
+
+	TP_PROTO(struct task_struct *wq_thread),
+
+	TP_ARGS(wq_thread),
+
+	TP_STRUCT__entry(
+		__array(char,	thread_comm,	TASK_COMM_LEN)
+		__field(pid_t,	thread_pid)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->thread_comm, wq_thread->comm, TASK_COMM_LEN);
+		__entry->thread_pid	= wq_thread->pid;
+	),
+
+	TP_printk("thread=%s:%d", __entry->thread_comm, __entry->thread_pid)
+);
+
+#endif /* _TRACE_WORKQUEUE_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/workqueue.h b/include/trace/workqueue.h
deleted file mode 100644
index 7626523..0000000
--- a/include/trace/workqueue.h
+++ /dev/null
@@ -1,25 +0,0 @@
-#ifndef __TRACE_WORKQUEUE_H
-#define __TRACE_WORKQUEUE_H
-
-#include <linux/tracepoint.h>
-#include <linux/workqueue.h>
-#include <linux/sched.h>
-
-DECLARE_TRACE(workqueue_insertion,
-	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TP_ARGS(wq_thread, work));
-
-DECLARE_TRACE(workqueue_execution,
-	   TP_PROTO(struct task_struct *wq_thread, struct work_struct *work),
-	   TP_ARGS(wq_thread, work));
-
-/* Trace the creation of one workqueue thread on a cpu */
-DECLARE_TRACE(workqueue_creation,
-	   TP_PROTO(struct task_struct *wq_thread, int cpu),
-	   TP_ARGS(wq_thread, cpu));
-
-DECLARE_TRACE(workqueue_destruction,
-	   TP_PROTO(struct task_struct *wq_thread),
-	   TP_ARGS(wq_thread));
-
-#endif /* __TRACE_WORKQUEUE_H */
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index fdde3a4..c006437 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -1,7 +1,7 @@
 /*
  * Infrastructure for statistic tracing (histogram output).
  *
- * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Copyright (C) 2008-2009 Frederic Weisbecker <fweisbec@gmail.com>
  *
  * Based on the code from trace_branch.c which is
  * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
@@ -10,22 +10,27 @@
 
 
 #include <linux/list.h>
+#include <linux/rbtree.h>
 #include <linux/debugfs.h>
 #include "trace_stat.h"
 #include "trace.h"
 
 
-/* List of stat entries from a tracer */
-struct trace_stat_list {
-	struct list_head	list;
+/*
+ * List of stat red-black nodes from a tracer
+ * We use a such tree to sort quickly the stat
+ * entries from the tracer.
+ */
+struct stat_node {
+	struct rb_node		node;
 	void			*stat;
 };
 
 /* A stat session is the stats output in one file */
-struct tracer_stat_session {
+struct stat_session {
 	struct list_head	session_list;
 	struct tracer_stat	*ts;
-	struct list_head	stat_list;
+	struct rb_root		stat_root;
 	struct mutex		stat_mutex;
 	struct dentry		*file;
 };
@@ -37,18 +42,48 @@ static DEFINE_MUTEX(all_stat_sessions_mutex);
 /* The root directory for all stat files */
 static struct dentry		*stat_dir;
 
+/*
+ * Iterate through the rbtree using a post order traversal path
+ * to release the next node.
+ * It won't necessary release one at each iteration
+ * but it will at least advance closer to the next one
+ * to be released.
+ */
+static struct rb_node *release_next(struct rb_node *node)
+{
+	struct stat_node *snode;
+	struct rb_node *parent = rb_parent(node);
+
+	if (node->rb_left)
+		return node->rb_left;
+	else if (node->rb_right)
+		return node->rb_right;
+	else {
+		if (!parent)
+			;
+		else if (parent->rb_left == node)
+			parent->rb_left = NULL;
+		else
+			parent->rb_right = NULL;
+
+		snode = container_of(node, struct stat_node, node);
+		kfree(snode);
+
+		return parent;
+	}
+}
 
-static void reset_stat_session(struct tracer_stat_session *session)
+static void reset_stat_session(struct stat_session *session)
 {
-	struct trace_stat_list *node, *next;
+	struct rb_node *node = session->stat_root.rb_node;
 
-	list_for_each_entry_safe(node, next, &session->stat_list, list)
-		kfree(node);
+	while (node)
+		node = release_next(node);
 
-	INIT_LIST_HEAD(&session->stat_list);
+	session->stat_root = RB_ROOT;
 }
 
-static void destroy_session(struct tracer_stat_session *session)
+static void destroy_session(struct stat_session *session)
 {
 	debugfs_remove(session->file);
 	reset_stat_session(session);
@@ -56,25 +91,60 @@ static void destroy_session(struct tracer_stat_session *session)
 	kfree(session);
 }
 
+typedef int (*cmp_stat_t)(void *, void *);
+
+static int insert_stat(struct rb_root *root, void *stat, cmp_stat_t cmp)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	struct stat_node *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	data->stat = stat;
+
+	/*
+	 * Figure out where to put new node
+	 * This is a descendent sorting
+	 */
+	while (*new) {
+		struct stat_node *this;
+		int result;
+
+		this = container_of(*new, struct stat_node, node);
+		result = cmp(data->stat, this->stat);
+
+		parent = *new;
+		if (result >= 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+	return 0;
+}
+
 /*
  * For tracers that don't provide a stat_cmp callback.
- * This one will force an immediate insertion on tail of
- * the list.
+ * This one will force an insertion as right-most node
+ * in the rbtree.
  */
 static int dummy_cmp(void *p1, void *p2)
 {
-	return 1;
+	return -1;
 }
 
 /*
- * Initialize the stat list at each trace_stat file opening.
+ * Initialize the stat rbtree at each trace_stat file opening.
  * All of these copies and sorting are required on all opening
  * since the stats could have changed between two file sessions.
  */
-static int stat_seq_init(struct tracer_stat_session *session)
+static int stat_seq_init(struct stat_session *session)
 {
-	struct trace_stat_list *iter_entry, *new_entry;
 	struct tracer_stat *ts = session->ts;
+	struct rb_root *root = &session->stat_root;
 	void *stat;
 	int ret = 0;
 	int i;
@@ -89,25 +159,12 @@ static int stat_seq_init(struct tracer_stat_session *session)
 	if (!stat)
 		goto exit;
 
-	/*
-	 * The first entry. Actually this is the second, but the first
-	 * one (the stat_list head) is pointless.
-	 */
-	new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
-	if (!new_entry) {
-		ret = -ENOMEM;
+	ret = insert_stat(root, stat, ts->stat_cmp);
+	if (ret)
 		goto exit;
-	}
-
-	INIT_LIST_HEAD(&new_entry->list);
-
-	list_add(&new_entry->list, &session->stat_list);
-
-	new_entry->stat = stat;
 
 	/*
-	 * Iterate over the tracer stat entries and store them in a sorted
-	 * list.
+	 * Iterate over the tracer stat entries and store them in an rbtree.
 	 */
 	for (i = 1; ; i++) {
 		stat = ts->stat_next(stat, i);
@@ -116,36 +173,16 @@ static int stat_seq_init(struct tracer_stat_session *session)
 		if (!stat)
 			break;
 
-		new_entry = kmalloc(sizeof(struct trace_stat_list), GFP_KERNEL);
-		if (!new_entry) {
-			ret = -ENOMEM;
-			goto exit_free_list;
-		}
-
-		INIT_LIST_HEAD(&new_entry->list);
-		new_entry->stat = stat;
-
-		list_for_each_entry_reverse(iter_entry, &session->stat_list,
-				list) {
-
-			/* Insertion with a descendent sorting */
-			if (ts->stat_cmp(iter_entry->stat,
-					new_entry->stat) >= 0) {
-
-				list_add(&new_entry->list, &iter_entry->list);
-				break;
-			}
-		}
-
-		/* The current larger value */
-		if (list_empty(&new_entry->list))
-			list_add(&new_entry->list, &session->stat_list);
+		ret = insert_stat(root, stat, ts->stat_cmp);
+		if (ret)
+			goto exit_free_rbtree;
 	}
+
 exit:
 	mutex_unlock(&session->stat_mutex);
 	return ret;
 
-exit_free_list:
+exit_free_rbtree:
 	reset_stat_session(session);
 	mutex_unlock(&session->stat_mutex);
 	return ret;
@@ -154,38 +191,51 @@ exit_free_list:
 
 static void *stat_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
+	struct rb_node *node;
+	int i;
 
-	/* Prevent from tracer switch or stat_list modification */
+	/* Prevent from tracer switch or rbtree modification */
 	mutex_lock(&session->stat_mutex);
 
 	/* If we are in the beginning of the file, print the headers */
-	if (!*pos && session->ts->stat_headers)
+	if (!*pos && session->ts->stat_headers) {
+		(*pos)++;
 		return SEQ_START_TOKEN;
+	}
 
-	return seq_list_start(&session->stat_list, *pos);
+	node = rb_first(&session->stat_root);
+	for (i = 0; node && i < *pos; i++)
+		node = rb_next(node);
+
+	(*pos)++;
+
+	return node;
 }
 
 static void *stat_seq_next(struct seq_file *s, void *p, loff_t *pos)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
+	struct rb_node *node = p;
+
+	(*pos)++;
 
 	if (p == SEQ_START_TOKEN)
-		return seq_list_start(&session->stat_list, *pos);
+		return rb_first(&session->stat_root);
 
-	return seq_list_next(p, &session->stat_list, pos);
+	return rb_next(node);
 }
 
 static void stat_seq_stop(struct seq_file *s, void *p)
 {
-	struct tracer_stat_session *session = s->private;
+	struct stat_session *session = s->private;
 	mutex_unlock(&session->stat_mutex);
 }
 
 static int stat_seq_show(struct seq_file *s, void *v)
 {
-	struct tracer_stat_session *session = s->private;
-	struct trace_stat_list *l = list_entry(v, struct trace_stat_list, list);
+	struct stat_session *session = s->private;
+	struct stat_node *l = container_of(v, struct stat_node, node);
 
 	if (v == SEQ_START_TOKEN)
 		return session->ts->stat_headers(s);
@@ -205,7 +255,7 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	struct tracer_stat_session *session = inode->i_private;
+	struct stat_session *session = inode->i_private;
 
 	ret = seq_open(file, &trace_stat_seq_ops);
 	if (!ret) {
@@ -218,11 +268,11 @@ static int tracing_stat_open(struct inode *inode, struct file *file)
 }
 
 /*
- * Avoid consuming memory with our now useless list.
+ * Avoid consuming memory with our now useless rbtree.
  */
 static int tracing_stat_release(struct inode *i, struct file *f)
 {
-	struct tracer_stat_session *session = i->i_private;
+	struct stat_session *session = i->i_private;
 
 	mutex_lock(&session->stat_mutex);
 	reset_stat_session(session);
@@ -251,7 +301,7 @@ static int tracing_stat_init(void)
 	return 0;
 }
 
-static int init_stat_file(struct tracer_stat_session *session)
+static int init_stat_file(struct stat_session *session)
 {
 	if (!stat_dir && tracing_stat_init())
 		return -ENODEV;
@@ -266,7 +316,7 @@ static int init_stat_file(struct tracer_stat_session *session)
 
 int register_stat_tracer(struct tracer_stat *trace)
 {
-	struct tracer_stat_session *session, *node, *tmp;
+	struct stat_session *session, *node;
 	int ret;
 
 	if (!trace)
@@ -277,7 +327,7 @@ int register_stat_tracer(struct tracer_stat *trace)
 
 	/* Already registered? */
 	mutex_lock(&all_stat_sessions_mutex);
-	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
+	list_for_each_entry(node, &all_stat_sessions, session_list) {
 		if (node->ts == trace) {
 			mutex_unlock(&all_stat_sessions_mutex);
 			return -EINVAL;
@@ -286,15 +336,13 @@ int register_stat_tracer(struct tracer_stat *trace)
 	mutex_unlock(&all_stat_sessions_mutex);
 
 	/* Init the session */
-	session = kmalloc(sizeof(struct tracer_stat_session), GFP_KERNEL);
+	session = kzalloc(sizeof(*session), GFP_KERNEL);
 	if (!session)
 		return -ENOMEM;
 
 	session->ts = trace;
 	INIT_LIST_HEAD(&session->session_list);
-	INIT_LIST_HEAD(&session->stat_list);
 	mutex_init(&session->stat_mutex);
-	session->file = NULL;
 
 	ret = init_stat_file(session);
 	if (ret) {
@@ -312,7 +360,7 @@ int register_stat_tracer(struct tracer_stat *trace)
 
 void unregister_stat_tracer(struct tracer_stat *trace)
 {
-	struct tracer_stat_session *node, *tmp;
+	struct stat_session *node, *tmp;
 
 	mutex_lock(&all_stat_sessions_mutex);
 	list_for_each_entry_safe(node, tmp, &all_stat_sessions, session_list) {
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 984b917..97fcea4 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -6,7 +6,7 @@
  */
 
 
-#include <trace/workqueue.h>
+#include <trace/events/workqueue.h>
 #include <linux/list.h>
 #include <linux/percpu.h>
 #include "trace_stat.h"
@@ -16,8 +16,6 @@
 /* A cpu workqueue thread */
 struct cpu_workqueue_stats {
 	struct list_head            list;
-/* Useful to know if we print the cpu headers */
-	bool		            first_entry;
 	int		            cpu;
 	pid_t			    pid;
 /* Can be inserted from interrupt or user context, need to be atomic */
@@ -47,12 +45,11 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-							list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			atomic_inc(&node->inserted);
 			goto found;
@@ -69,12 +66,11 @@ probe_workqueue_execution(struct task_struct *wq_thread,
 			  struct work_struct *work)
 {
 	int cpu = cpumask_first(&wq_thread->cpus_allowed);
-	struct cpu_workqueue_stats *node, *next;
+	struct cpu_workqueue_stats *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
-							list) {
+	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
 		if (node->pid == wq_thread->pid) {
 			node->executed++;
 			goto found;
@@ -105,8 +101,6 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 	cws->pid = wq_thread->pid;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (list_empty(&workqueue_cpu_stat(cpu)->list))
-		cws->first_entry = true;
 	list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
@@ -191,16 +185,9 @@ static void *workqueue_stat_next(void *prev, int idx)
 static int workqueue_stat_show(struct seq_file *s, void *p)
 {
 	struct cpu_workqueue_stats *cws = p;
-	unsigned long flags;
-	int cpu = cws->cpu;
 	struct pid *pid;
 	struct task_struct *tsk;
 
-	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-		seq_printf(s, "\n");
-	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-
 	pid = find_get_pid(cws->pid);
 	if (pid) {
 		tsk = get_pid_task(pid, PIDTYPE_PID);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f71fb2a..0668795 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,7 +33,8 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
-#include <trace/workqueue.h>
+#define CREATE_TRACE_POINTS
+#include <trace/events/workqueue.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -124,8 +125,6 @@ struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-DEFINE_TRACE(workqueue_insertion);
-
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head)
 {
@@ -262,8 +261,6 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
-DEFINE_TRACE(workqueue_execution);
-
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -753,8 +750,6 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	return cwq;
 }
 
-DEFINE_TRACE(workqueue_creation);
-
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
@@ -860,8 +855,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-DEFINE_TRACE(workqueue_destruction);
-
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 {
 	/*

