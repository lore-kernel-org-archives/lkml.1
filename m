Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZCSUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZCSUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZCSUCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200159.932486704@goodmis.org>
References: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7] tracing: give easy way to clear trace buffer
Content-Disposition: inline; filename=0001-tracing-give-easy-way-to-clear-trace-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There is currently no easy way to clear the trace buffer. Currently
the only way is to change the current tracer.

This patch lets the user clear the trace buffer by simply writing
into the trace files.

 echo > /debug/tracing/trace

or to clear a single cpu (i.e. for CPU 1):

 echo > /debug/tracing/per_cpu/cpu1/trace

Requested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   41 +++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a2d13e8..8d981ab 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1941,9 +1941,14 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
-	struct trace_iterator *iter = m->private;
+	struct trace_iterator *iter;
 	int cpu;
 
+	if (!(file->f_mode & FMODE_READ))
+		return 0;
+
+	iter = m->private;
+
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
 		if (iter->buffer_iter[cpu])
@@ -1969,12 +1974,24 @@ static int tracing_open(struct inode *inode, struct file *file)
 	struct trace_iterator *iter;
 	int ret = 0;
 
-	iter = __tracing_open(inode, file);
-	if (IS_ERR(iter))
-		ret = PTR_ERR(iter);
-	else if (trace_flags & TRACE_ITER_LATENCY_FMT)
-		iter->iter_flags |= TRACE_FILE_LAT_FMT;
+	/* If this file was open for write, then erase contents */
+	if ((file->f_mode & FMODE_WRITE) &&
+	    !(file->f_flags & O_APPEND)) {
+		long cpu = (long) inode->i_private;
+
+		if (cpu == TRACE_PIPE_ALL_CPU)
+			tracing_reset_online_cpus(&global_trace);
+		else
+			tracing_reset(&global_trace, cpu);
+	}
 
+	if (file->f_mode & FMODE_READ) {
+		iter = __tracing_open(inode, file);
+		if (IS_ERR(iter))
+			ret = PTR_ERR(iter);
+		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
+			iter->iter_flags |= TRACE_FILE_LAT_FMT;
+	}
 	return ret;
 }
 
@@ -2049,9 +2066,17 @@ static int show_traces_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
+static ssize_t
+tracing_write_stub(struct file *filp, const char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	return count;
+}
+
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.write		= tracing_write_stub,
 	.llseek		= seq_lseek,
 	.release	= tracing_release,
 };
@@ -3576,7 +3601,7 @@ static void tracing_init_debugfs_percpu(long cpu)
 		pr_warning("Could not create debugfs 'trace_pipe' entry\n");
 
 	/* per cpu trace */
-	entry = debugfs_create_file("trace", 0444, d_cpu,
+	entry = debugfs_create_file("trace", 0644, d_cpu,
 				(void *) cpu, &tracing_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace' entry\n");
@@ -3890,7 +3915,7 @@ static __init int tracer_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'tracing_cpumask' entry\n");
 
-	entry = debugfs_create_file("trace", 0444, d_tracer,
+	entry = debugfs_create_file("trace", 0644, d_tracer,
 				 (void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace' entry\n");
-- 
1.6.2

-- 
