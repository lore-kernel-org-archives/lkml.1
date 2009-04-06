Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZDFQlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZDFQlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZDFQjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:39:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbZDFQjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:39:03 -0400
Message-Id: <20090406163830.773115333@goodmis.org>
References: <20090406163706.097842409@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 12:37:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/10] tracing/ftrace: factorize the tracing files creation
Content-Disposition: inline; filename=0005-tracing-ftrace-factorize-the-tracing-files-creation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Impact: cleanup

Most of the tracing files creation follow the same pattern:

ret = debugfs_create_file(...)
if (!ret)
	pr_warning("Couldn't create ... entry\n")

Unify it!

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1238109938-11840-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c              |   39 ++-------
 kernel/trace/ring_buffer.c         |    7 +-
 kernel/trace/trace.c               |  159 ++++++++++++++----------------------
 kernel/trace/trace.h               |    6 ++
 kernel/trace/trace_event_profile.c |    3 +-
 kernel/trace/trace_printk.c        |    6 +-
 kernel/trace/trace_stack.c         |   13 +--
 kernel/trace/trace_sysprof.c       |    6 +-
 8 files changed, 88 insertions(+), 151 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 678e3d6..6ea5a1a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2698,38 +2698,23 @@ static const struct file_operations ftrace_graph_fops = {
 
 static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 {
-	struct dentry *entry;
 
-	entry = debugfs_create_file("available_filter_functions", 0444,
-				    d_tracer, NULL, &ftrace_avail_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'available_filter_functions' entry\n");
+	trace_create_file("available_filter_functions", 0444,
+			d_tracer, NULL, &ftrace_avail_fops);
 
-	entry = debugfs_create_file("failures", 0444,
-				    d_tracer, NULL, &ftrace_failures_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'failures' entry\n");
+	trace_create_file("failures", 0444,
+			d_tracer, NULL, &ftrace_failures_fops);
 
-	entry = debugfs_create_file("set_ftrace_filter", 0644, d_tracer,
-				    NULL, &ftrace_filter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_ftrace_filter' entry\n");
+	trace_create_file("set_ftrace_filter", 0644, d_tracer,
+			NULL, &ftrace_filter_fops);
 
-	entry = debugfs_create_file("set_ftrace_notrace", 0644, d_tracer,
+	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
 				    NULL, &ftrace_notrace_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_ftrace_notrace' entry\n");
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	entry = debugfs_create_file("set_graph_function", 0444, d_tracer,
+	trace_create_file("set_graph_function", 0444, d_tracer,
 				    NULL,
 				    &ftrace_graph_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_graph_function' entry\n");
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	return 0;
@@ -2987,7 +2972,6 @@ static const struct file_operations ftrace_pid_fops = {
 static __init int ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
@@ -2995,11 +2979,8 @@ static __init int ftrace_init_debugfs(void)
 
 	ftrace_init_dyn_debugfs(d_tracer);
 
-	entry = debugfs_create_file("set_ftrace_pid", 0644, d_tracer,
-				    NULL, &ftrace_pid_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_ftrace_pid' entry\n");
+	trace_create_file("set_ftrace_pid", 0644, d_tracer,
+			    NULL, &ftrace_pid_fops);
 
 	ftrace_profile_debugfs(d_tracer);
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 960cbf4..74a1180 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2845,14 +2845,11 @@ static const struct file_operations rb_simple_fops = {
 static __init int rb_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
-				    &ring_buffer_flags, &rb_simple_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_on' entry\n");
+	trace_create_file("tracing_on", 0644, d_tracer,
+			    &ring_buffer_flags, &rb_simple_fops);
 
 	return 0;
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 6f15d85..d64a162 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3570,7 +3570,7 @@ struct dentry *tracing_dentry_percpu(void)
 static void tracing_init_debugfs_percpu(long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu();
-	struct dentry *entry, *d_cpu;
+	struct dentry *d_cpu;
 	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
 	char cpu_dir[7];
 
@@ -3585,21 +3585,15 @@ static void tracing_init_debugfs_percpu(long cpu)
 	}
 
 	/* per cpu trace_pipe */
-	entry = debugfs_create_file("trace_pipe", 0444, d_cpu,
-				(void *) cpu, &tracing_pipe_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace_pipe' entry\n");
+	trace_create_file("trace_pipe", 0444, d_cpu,
+			(void *) cpu, &tracing_pipe_fops);
 
 	/* per cpu trace */
-	entry = debugfs_create_file("trace", 0644, d_cpu,
-				(void *) cpu, &tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
+	trace_create_file("trace", 0644, d_cpu,
+			(void *) cpu, &tracing_fops);
 
-	entry = debugfs_create_file("trace_pipe_raw", 0444, d_cpu,
-				    (void *) cpu, &tracing_buffers_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace_pipe_raw' entry\n");
+	trace_create_file("trace_pipe_raw", 0444, d_cpu,
+			(void *) cpu, &tracing_buffers_fops);
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -3755,6 +3749,22 @@ static const struct file_operations trace_options_core_fops = {
 	.write = trace_options_core_write,
 };
 
+struct dentry *trace_create_file(const char *name,
+				 mode_t mode,
+				 struct dentry *parent,
+				 void *data,
+				 const struct file_operations *fops)
+{
+	struct dentry *ret;
+
+	ret = debugfs_create_file(name, mode, parent, data, fops);
+	if (!ret)
+		pr_warning("Could not create debugfs '%s' entry\n", name);
+
+	return ret;
+}
+
+
 static struct dentry *trace_options_init_dentry(void)
 {
 	struct dentry *d_tracer;
@@ -3782,7 +3792,6 @@ create_trace_option_file(struct trace_option_dentry *topt,
 			 struct tracer_opt *opt)
 {
 	struct dentry *t_options;
-	struct dentry *entry;
 
 	t_options = trace_options_init_dentry();
 	if (!t_options)
@@ -3791,11 +3800,9 @@ create_trace_option_file(struct trace_option_dentry *topt,
 	topt->flags = flags;
 	topt->opt = opt;
 
-	entry = debugfs_create_file(opt->name, 0644, t_options, topt,
+	topt->entry = trace_create_file(opt->name, 0644, t_options, topt,
 				    &trace_options_fops);
 
-	topt->entry = entry;
-
 }
 
 static struct trace_option_dentry *
@@ -3850,123 +3857,81 @@ static struct dentry *
 create_trace_option_core_file(const char *option, long index)
 {
 	struct dentry *t_options;
-	struct dentry *entry;
 
 	t_options = trace_options_init_dentry();
 	if (!t_options)
 		return NULL;
 
-	entry = debugfs_create_file(option, 0644, t_options, (void *)index,
+	return trace_create_file(option, 0644, t_options, (void *)index,
 				    &trace_options_core_fops);
-
-	return entry;
 }
 
 static __init void create_trace_options_dir(void)
 {
 	struct dentry *t_options;
-	struct dentry *entry;
 	int i;
 
 	t_options = trace_options_init_dentry();
 	if (!t_options)
 		return;
 
-	for (i = 0; trace_options[i]; i++) {
-		entry = create_trace_option_core_file(trace_options[i], i);
-		if (!entry)
-			pr_warning("Could not create debugfs %s entry\n",
-				   trace_options[i]);
-	}
+	for (i = 0; trace_options[i]; i++)
+		create_trace_option_core_file(trace_options[i], i);
 }
 
 static __init int tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 	int cpu;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
-				    &global_trace, &tracing_ctrl_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
+	trace_create_file("tracing_enabled", 0644, d_tracer,
+			&global_trace, &tracing_ctrl_fops);
 
-	entry = debugfs_create_file("trace_options", 0644, d_tracer,
-				    NULL, &tracing_iter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace_options' entry\n");
+	trace_create_file("trace_options", 0644, d_tracer,
+			NULL, &tracing_iter_fops);
 
-	create_trace_options_dir();
+	trace_create_file("tracing_cpumask", 0644, d_tracer,
+			NULL, &tracing_cpumask_fops);
+
+	trace_create_file("trace", 0644, d_tracer,
+			(void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
+
+	trace_create_file("available_tracers", 0444, d_tracer,
+			&global_trace, &show_traces_fops);
+
+	trace_create_file("current_tracer", 0444, d_tracer,
+			&global_trace, &set_tracer_fops);
+
+	trace_create_file("tracing_max_latency", 0644, d_tracer,
+			&tracing_max_latency, &tracing_max_lat_fops);
+
+	trace_create_file("tracing_thresh", 0644, d_tracer,
+			&tracing_thresh, &tracing_max_lat_fops);
 
-	entry = debugfs_create_file("tracing_cpumask", 0644, d_tracer,
-				    NULL, &tracing_cpumask_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_cpumask' entry\n");
-
-	entry = debugfs_create_file("trace", 0644, d_tracer,
-				 (void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
-
-	entry = debugfs_create_file("available_tracers", 0444, d_tracer,
-				    &global_trace, &show_traces_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'available_tracers' entry\n");
-
-	entry = debugfs_create_file("current_tracer", 0444, d_tracer,
-				    &global_trace, &set_tracer_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'current_tracer' entry\n");
-
-	entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
-				    &tracing_max_latency,
-				    &tracing_max_lat_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'tracing_max_latency' entry\n");
-
-	entry = debugfs_create_file("tracing_thresh", 0644, d_tracer,
-				    &tracing_thresh, &tracing_max_lat_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'tracing_thresh' entry\n");
-	entry = debugfs_create_file("README", 0644, d_tracer,
-				    NULL, &tracing_readme_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'README' entry\n");
-
-	entry = debugfs_create_file("trace_pipe", 0444, d_tracer,
+	trace_create_file("README", 0644, d_tracer,
+			NULL, &tracing_readme_fops);
+
+	trace_create_file("trace_pipe", 0444, d_tracer,
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'trace_pipe' entry\n");
-
-	entry = debugfs_create_file("buffer_size_kb", 0644, d_tracer,
-				    &global_trace, &tracing_entries_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'buffer_size_kb' entry\n");
-
-	entry = debugfs_create_file("trace_marker", 0220, d_tracer,
-				    NULL, &tracing_mark_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'trace_marker' entry\n");
+
+	trace_create_file("buffer_size_kb", 0644, d_tracer,
+			&global_trace, &tracing_entries_fops);
+
+	trace_create_file("trace_marker", 0220, d_tracer,
+			NULL, &tracing_mark_fops);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
-				    &ftrace_update_tot_cnt,
-				    &tracing_dyn_info_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'dyn_ftrace_total_info' entry\n");
+	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
+			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
 #ifdef CONFIG_SYSPROF_TRACER
 	init_tracer_sysprof_debugfs(d_tracer);
 #endif
 
+	create_trace_options_dir();
+
 	for_each_tracing_cpu(cpu)
 		tracing_init_debugfs_percpu(cpu);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 47aa6d0..f76a8f8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -470,6 +470,12 @@ void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
 int tracing_open_generic(struct inode *inode, struct file *filp);
+struct dentry *trace_create_file(const char *name,
+				 mode_t mode,
+				 struct dentry *parent,
+				 void *data,
+				 const struct file_operations *fops);
+
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
 
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 22cba99..5d84b28 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -6,7 +6,7 @@
  */
 
 #include "trace.h"
-
+#if 0
 int ftrace_profile_enable(int event_id)
 {
 	struct ftrace_event_call *event;
@@ -29,3 +29,4 @@ void ftrace_profile_disable(int event_id)
 	}
 }
 
+#endif
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index eb81556..9bece96 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -245,17 +245,13 @@ static const struct file_operations ftrace_formats_fops = {
 static __init int init_trace_printk_function_export(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)
 		return 0;
 
-	entry = debugfs_create_file("printk_formats", 0444, d_tracer,
+	trace_create_file("printk_formats", 0444, d_tracer,
 				    NULL, &ftrace_formats_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'printk_formats' entry\n");
 
 	return 0;
 }
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c750f65..1796f00 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -352,19 +352,14 @@ __setup("stacktrace", enable_stacktrace);
 static __init int stack_trace_init(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("stack_max_size", 0644, d_tracer,
-				    &max_stack_size, &stack_max_size_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'stack_max_size' entry\n");
+	trace_create_file("stack_max_size", 0644, d_tracer,
+			&max_stack_size, &stack_max_size_fops);
 
-	entry = debugfs_create_file("stack_trace", 0444, d_tracer,
-				    NULL, &stack_trace_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'stack_trace' entry\n");
+	trace_create_file("stack_trace", 0444, d_tracer,
+			NULL, &stack_trace_fops);
 
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 91fd19c..e04b76c 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -321,11 +321,7 @@ static const struct file_operations sysprof_sample_fops = {
 
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer)
 {
-	struct dentry *entry;
 
-	entry = debugfs_create_file("sysprof_sample_period", 0644,
+	trace_create_file("sysprof_sample_period", 0644,
 			d_tracer, NULL, &sysprof_sample_fops);
-	if (entry)
-		return;
-	pr_warning("Could not create debugfs 'sysprof_sample_period' entry\n");
 }
-- 
1.6.2.1

-- 
