Return-Path: <linux-kernel-owner+w=401wt.eu-S934393AbZJMVWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbZJMVWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbZJMVWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:22:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761359AbZJMVWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:22:17 -0400
Message-Id: <20091013212019.317531162@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 17:19:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] [PATCH 2/4] tracing: support multiple pids in set_pid_ftrace file
References: <20091013211934.941504044@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-support-multiple-pids-in-set_pid_ftrace-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jolsa@redhat.com <jolsa@redhat.com>

Adding the possibility to set more than 1 pid in the set_pid_ftrace file,
thus allowing to trace more than 1 independent processes.

Usage:

sh-4.0# echo 284 > ./set_ftrace_pid
sh-4.0# cat ./set_ftrace_pid
284
sh-4.0# echo 1 >> ./set_ftrace_pid
sh-4.0# echo 0 >> ./set_ftrace_pid
sh-4.0# cat ./set_ftrace_pid
swapper tasks
1
284
sh-4.0# echo 4 > ./set_ftrace_pid
sh-4.0# cat ./set_ftrace_pid
4
sh-4.0# echo > ./set_ftrace_pid
sh-4.0# cat ./set_ftrace_pid
no pid
sh-4.0#

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1253088900-18506-1-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |  234 ++++++++++++++++++++++++++++++++++---------------
 kernel/trace/trace.h  |    4 +-
 2 files changed, 167 insertions(+), 71 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 45c9659..0c799d1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -60,6 +60,13 @@ static int last_ftrace_enabled;
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
+/* List for set_ftrace_pid's pids. */
+LIST_HEAD(ftrace_pids);
+struct ftrace_pid {
+	struct list_head list;
+	struct pid *pid;
+};
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -159,7 +166,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 		else
 			func = ftrace_list_func;
 
-		if (ftrace_pid_trace) {
+		if (!list_empty(&ftrace_pids)) {
 			set_ftrace_pid_function(func);
 			func = ftrace_pid_func;
 		}
@@ -207,7 +214,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		if (ftrace_list->next == &ftrace_list_end) {
 			ftrace_func_t func = ftrace_list->func;
 
-			if (ftrace_pid_trace) {
+			if (!list_empty(&ftrace_pids)) {
 				set_ftrace_pid_function(func);
 				func = ftrace_pid_func;
 			}
@@ -235,7 +242,7 @@ static void ftrace_update_pid_func(void)
 	func = __ftrace_trace_function;
 #endif
 
-	if (ftrace_pid_trace) {
+	if (!list_empty(&ftrace_pids)) {
 		set_ftrace_pid_function(func);
 		func = ftrace_pid_func;
 	} else {
@@ -825,8 +832,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
 
-/* set when tracing only a pid */
-struct pid *ftrace_pid_trace;
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -2758,23 +2763,6 @@ static inline void ftrace_startup_enable(int command) { }
 # define ftrace_shutdown_sysctl()	do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
-static ssize_t
-ftrace_pid_read(struct file *file, char __user *ubuf,
-		       size_t cnt, loff_t *ppos)
-{
-	char buf[64];
-	int r;
-
-	if (ftrace_pid_trace == ftrace_swapper_pid)
-		r = sprintf(buf, "swapper tasks\n");
-	else if (ftrace_pid_trace)
-		r = sprintf(buf, "%u\n", pid_vnr(ftrace_pid_trace));
-	else
-		r = sprintf(buf, "no pid\n");
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
 static void clear_ftrace_swapper(void)
 {
 	struct task_struct *p;
@@ -2825,14 +2813,12 @@ static void set_ftrace_pid(struct pid *pid)
 	rcu_read_unlock();
 }
 
-static void clear_ftrace_pid_task(struct pid **pid)
+static void clear_ftrace_pid_task(struct pid *pid)
 {
-	if (*pid == ftrace_swapper_pid)
+	if (pid == ftrace_swapper_pid)
 		clear_ftrace_swapper();
 	else
-		clear_ftrace_pid(*pid);
-
-	*pid = NULL;
+		clear_ftrace_pid(pid);
 }
 
 static void set_ftrace_pid_task(struct pid *pid)
@@ -2843,11 +2829,140 @@ static void set_ftrace_pid_task(struct pid *pid)
 		set_ftrace_pid(pid);
 }
 
+static int ftrace_pid_add(int p)
+{
+	struct pid *pid;
+	struct ftrace_pid *fpid;
+	int ret = -EINVAL;
+
+	mutex_lock(&ftrace_lock);
+
+	if (!p)
+		pid = ftrace_swapper_pid;
+	else
+		pid = find_get_pid(p);
+
+	if (!pid)
+		goto out;
+
+	ret = 0;
+
+	list_for_each_entry(fpid, &ftrace_pids, list)
+		if (fpid->pid == pid)
+			goto out_put;
+
+	ret = -ENOMEM;
+
+	fpid = kmalloc(sizeof(*fpid), GFP_KERNEL);
+	if (!fpid)
+		goto out_put;
+
+	list_add(&fpid->list, &ftrace_pids);
+	fpid->pid = pid;
+
+	set_ftrace_pid_task(pid);
+
+	ftrace_update_pid_func();
+	ftrace_startup_enable(0);
+
+	mutex_unlock(&ftrace_lock);
+	return 0;
+
+out_put:
+	if (pid != ftrace_swapper_pid)
+		put_pid(pid);
+
+out:
+	mutex_unlock(&ftrace_lock);
+	return ret;
+}
+
+static void ftrace_pid_reset(void)
+{
+	struct ftrace_pid *fpid, *safe;
+
+	mutex_lock(&ftrace_lock);
+	list_for_each_entry_safe(fpid, safe, &ftrace_pids, list) {
+		struct pid *pid = fpid->pid;
+
+		clear_ftrace_pid_task(pid);
+
+		list_del(&fpid->list);
+		kfree(fpid);
+	}
+
+	ftrace_update_pid_func();
+	ftrace_startup_enable(0);
+
+	mutex_unlock(&ftrace_lock);
+}
+
+static void *fpid_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&ftrace_lock);
+
+	if (list_empty(&ftrace_pids) && (!*pos))
+		return (void *) 1;
+
+	return seq_list_start(&ftrace_pids, *pos);
+}
+
+static void *fpid_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	if (v == (void *)1)
+		return NULL;
+
+	return seq_list_next(v, &ftrace_pids, pos);
+}
+
+static void fpid_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&ftrace_lock);
+}
+
+static int fpid_show(struct seq_file *m, void *v)
+{
+	const struct ftrace_pid *fpid = list_entry(v, struct ftrace_pid, list);
+
+	if (v == (void *)1) {
+		seq_printf(m, "no pid\n");
+		return 0;
+	}
+
+	if (fpid->pid == ftrace_swapper_pid)
+		seq_printf(m, "swapper tasks\n");
+	else
+		seq_printf(m, "%u\n", pid_vnr(fpid->pid));
+
+	return 0;
+}
+
+static const struct seq_operations ftrace_pid_sops = {
+	.start = fpid_start,
+	.next = fpid_next,
+	.stop = fpid_stop,
+	.show = fpid_show,
+};
+
+static int
+ftrace_pid_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_TRUNC))
+		ftrace_pid_reset();
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_open(file, &ftrace_pid_sops);
+
+	return ret;
+}
+
 static ssize_t
 ftrace_pid_write(struct file *filp, const char __user *ubuf,
 		   size_t cnt, loff_t *ppos)
 {
-	struct pid *pid;
 	char buf[64];
 	long val;
 	int ret;
@@ -2860,57 +2975,38 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 
 	buf[cnt] = 0;
 
+	/*
+	 * Allow "echo > set_ftrace_pid" or "echo -n '' > set_ftrace_pid"
+	 * to clean the filter quietly.
+	 */
+	strstrip(buf);
+	if (strlen(buf) == 0)
+		return 1;
+
 	ret = strict_strtol(buf, 10, &val);
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&ftrace_lock);
-	if (val < 0) {
-		/* disable pid tracing */
-		if (!ftrace_pid_trace)
-			goto out;
-
-		clear_ftrace_pid_task(&ftrace_pid_trace);
-
-	} else {
-		/* swapper task is special */
-		if (!val) {
-			pid = ftrace_swapper_pid;
-			if (pid == ftrace_pid_trace)
-				goto out;
-		} else {
-			pid = find_get_pid(val);
-
-			if (pid == ftrace_pid_trace) {
-				put_pid(pid);
-				goto out;
-			}
-		}
-
-		if (ftrace_pid_trace)
-			clear_ftrace_pid_task(&ftrace_pid_trace);
-
-		if (!pid)
-			goto out;
-
-		ftrace_pid_trace = pid;
-
-		set_ftrace_pid_task(ftrace_pid_trace);
-	}
+	ret = ftrace_pid_add(val);
 
-	/* update the function call */
-	ftrace_update_pid_func();
-	ftrace_startup_enable(0);
+	return ret ? ret : cnt;
+}
 
- out:
-	mutex_unlock(&ftrace_lock);
+static int
+ftrace_pid_release(struct inode *inode, struct file *file)
+{
+	if (file->f_mode & FMODE_READ)
+		seq_release(inode, file);
 
-	return cnt;
+	return 0;
 }
 
 static const struct file_operations ftrace_pid_fops = {
-	.read = ftrace_pid_read,
-	.write = ftrace_pid_write,
+	.open		= ftrace_pid_open,
+	.write		= ftrace_pid_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= ftrace_pid_release,
 };
 
 static __init int ftrace_init_debugfs(void)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f22a7ac..acef8b4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -496,12 +496,12 @@ print_graph_function(struct trace_iterator *iter)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-extern struct pid *ftrace_pid_trace;
+extern struct list_head ftrace_pids;
 
 #ifdef CONFIG_FUNCTION_TRACER
 static inline int ftrace_trace_task(struct task_struct *task)
 {
-	if (!ftrace_pid_trace)
+	if (list_empty(&ftrace_pids))
 		return 1;
 
 	return test_tsk_trace_trace(task);
-- 
1.6.3.3


