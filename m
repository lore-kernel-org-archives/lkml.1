Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZIONFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZIONFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZIONFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:05:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbZIONFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:05:10 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org, lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2] tracing - support multiple pids in set_pid_ftrace file
Date: Tue, 15 Sep 2009 15:04:53 +0200
Message-Id: <1253019893-30131-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/ftrace.c |  231 ++++++++++++++++++++++++++++++++++--------------
 kernel/trace/trace.h  |    4 +-
 2 files changed, 165 insertions(+), 70 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8b23d56..0f388e8 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -60,6 +60,13 @@ static int last_ftrace_enabled;
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
+/* List for set_ftrace_pid's pids */
+LIST_HEAD(ftrace_pids);
+struct ftrace_pid {
+	struct list_head list;
+	struct pid *pid;
+};
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -155,7 +162,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 		else
 			func = ftrace_list_func;
 
-		if (ftrace_pid_trace) {
+		if (!list_empty(&ftrace_pids)) {
 			set_ftrace_pid_function(func);
 			func = ftrace_pid_func;
 		}
@@ -203,7 +210,7 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 		if (ftrace_list->next == &ftrace_list_end) {
 			ftrace_func_t func = ftrace_list->func;
 
-			if (ftrace_pid_trace) {
+			if (!list_empty(&ftrace_pids)) {
 				set_ftrace_pid_function(func);
 				func = ftrace_pid_func;
 			}
@@ -227,7 +234,7 @@ static void ftrace_update_pid_func(void)
 
 	func = ftrace_trace_function;
 
-	if (ftrace_pid_trace) {
+	if (!list_empty(&ftrace_pids)) {
 		set_ftrace_pid_function(func);
 		func = ftrace_pid_func;
 	} else {
@@ -818,7 +825,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 #endif /* CONFIG_FUNCTION_PROFILER */
 
 /* set when tracing only a pid */
-struct pid *ftrace_pid_trace;
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -2795,23 +2801,6 @@ static inline void ftrace_startup_enable(int command) { }
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
@@ -2862,14 +2851,12 @@ static void set_ftrace_pid(struct pid *pid)
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
@@ -2880,11 +2867,138 @@ static void set_ftrace_pid_task(struct pid *pid)
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
@@ -2897,57 +3011,38 @@ ftrace_pid_write(struct file *filp, const char __user *ubuf,
 
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
index e747162..3ec0b1c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -521,12 +521,12 @@ print_graph_function(struct trace_iterator *iter)
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
