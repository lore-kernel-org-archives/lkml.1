Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbZJWBAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbZJWBAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZJWBAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:00:03 -0400
Received: from kroah.org ([198.145.64.141]:39505 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbZJWA7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 20:59:46 -0400
Date: Thu, 22 Oct 2009 17:49:37 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] tracefs
Message-ID: <20091023004937.GA24035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

At LinuxCon this year, Steven and I talked about moving the debugfs
usage in the tracing core to a stand-alone filesystem to give the
ability to start to lock down the api so that people an count on what is
going on in the tracing userspace interface.

So, on the flight to Tokyo for the kernel summit, I wrote up tracefs.
Here's the first very rough cut at it below.  I've run it here on my
laptop, and all seems well, but I do have a few questions:
  - I've made the mount point be /sys/kernel/trace/  Is that ok?  Should
    it be /sys/kernel/tracing/?  Or something else?  You get to pick the
    mount point now, so I don't want to hear any more grumblings about
    the location in the future :)
  - the block tracing code was not changed, as it uses
    /sys/kernel/debug/block/ at the moment, not the
    /sys/kernel/debug/tracing/ directory.  To change the block tracing
    code, it would require us to change the userspace tools as well,
    which I don't know if we want to do.  Thanks to Jens for
    straightening this all out for me, originally I thought it was a bug
    in the block tracing code.
  - is this type of conversion to a custom virtual filesystem acceptable
    to the other tracing developers?  Any objection to not using debugfs
    calls anymore?  The operation is identical, but it keeps the rest of
    the kernel from intruding on your space now.

Again, this is a very rough cut, I know I can make this smaller, and
actually make the code in the tracing core a bit simpler when calling
tracefs, as it does not need to support all the different options that
debugfs did.

Also, the init path for tracefs needs to be reworked, as it's a bit too
complex now.  This will reduce the usage of the "is this initialized"
type mess that the patch below currently has.

Oh, and yes, I will split this up properly as well for a real
submission :)

thanks,

greg k-h

------------

Subject: tracefs

This replaces the debugfs usage in the tracing core with a custom
virtual filesystem for its use only.

Not-Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

 include/linux/magic.h                |    3 
 kernel/trace/Makefile                |    1 
 kernel/trace/blktrace.c              |   20 -
 kernel/trace/ftrace.c                |   43 +--
 kernel/trace/kmemtrace.c             |    1 
 kernel/trace/ring_buffer.c           |   12 
 kernel/trace/trace.c                 |   99 ++-----
 kernel/trace/trace.h                 |    5 
 kernel/trace/trace_boot.c            |    1 
 kernel/trace/trace_branch.c          |    1 
 kernel/trace/trace_events.c          |   41 +-
 kernel/trace/trace_events_filter.c   |    1 
 kernel/trace/trace_export.c          |    1 
 kernel/trace/trace_functions.c       |    1 
 kernel/trace/trace_functions_graph.c |    1 
 kernel/trace/trace_hw_branches.c     |    1 
 kernel/trace/trace_irqsoff.c         |    1 
 kernel/trace/trace_nop.c             |    1 
 kernel/trace/trace_printk.c          |   11 
 kernel/trace/trace_sched_switch.c    |    1 
 kernel/trace/trace_sched_wakeup.c    |    1 
 kernel/trace/trace_stack.c           |   11 
 kernel/trace/trace_stat.c            |   14 -
 kernel/trace/trace_sysprof.c         |    5 
 kernel/trace/tracefs.c               |  482 +++++++++++++++++++++++++++++++++++
 kernel/trace/tracefs.h               |   33 ++
 26 files changed, 621 insertions(+), 171 deletions(-)

diff --git a/include/linux/magic.h b/include/linux/magic.h
index 76285e0..75682d0 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -8,7 +8,8 @@
 #define CODA_SUPER_MAGIC	0x73757245
 #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
 #define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
-#define DEBUGFS_MAGIC          0x64626720
+#define DEBUGFS_MAGIC		0x64626720
+#define TRACEFS_MAGIC		0x74726365
 #define SYSFS_MAGIC		0x62656572
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 26f03ac..afe2f04 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_TRACING) += trace.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
+obj-$(CONFIG_TRACING) += tracefs.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d9d6206..e071e4e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -21,7 +21,6 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
-#include <linux/debugfs.h>
 #include <linux/smp_lock.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
@@ -29,6 +28,7 @@
 #include <trace/events/block.h>
 
 #include "trace_output.h"
+#include "tracefs.h"
 
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 
@@ -269,10 +269,10 @@ static DEFINE_MUTEX(blk_tree_mutex);
 
 static void blk_trace_free(struct blk_trace *bt)
 {
-	debugfs_remove(bt->msg_file);
-	debugfs_remove(bt->dropped_file);
+	tracefs_remove(bt->msg_file);
+	tracefs_remove(bt->dropped_file);
 	relay_close(bt->rchan);
-	debugfs_remove(bt->dir);
+	tracefs_remove(bt->dir);
 	free_percpu(bt->sequence);
 	free_percpu(bt->msg_data);
 	kfree(bt);
@@ -382,7 +382,7 @@ static int blk_subbuf_start_callback(struct rchan_buf *buf, void *subbuf,
 
 static int blk_remove_buf_file_callback(struct dentry *dentry)
 {
-	debugfs_remove(dentry);
+	tracefs_remove(dentry);
 
 	return 0;
 }
@@ -393,7 +393,7 @@ static struct dentry *blk_create_buf_file_callback(const char *filename,
 						   struct rchan_buf *buf,
 						   int *is_global)
 {
-	return debugfs_create_file(filename, mode, parent, buf,
+	return tracefs_create_file(filename, mode, parent, buf,
 					&relay_file_operations);
 }
 
@@ -462,7 +462,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 
 	mutex_lock(&blk_tree_mutex);
 	if (!blk_tree_root) {
-		blk_tree_root = debugfs_create_dir("block", NULL);
+		blk_tree_root = tracefs_create_dir("block", NULL);
 		if (!blk_tree_root) {
 			mutex_unlock(&blk_tree_mutex);
 			goto err;
@@ -470,7 +470,7 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	}
 	mutex_unlock(&blk_tree_mutex);
 
-	dir = debugfs_create_dir(buts->name, blk_tree_root);
+	dir = tracefs_create_dir(buts->name, blk_tree_root);
 
 	if (!dir)
 		goto err;
@@ -480,12 +480,12 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 	atomic_set(&bt->dropped, 0);
 
 	ret = -EIO;
-	bt->dropped_file = debugfs_create_file("dropped", 0444, dir, bt,
+	bt->dropped_file = tracefs_create_file("dropped", 0444, dir, bt,
 					       &blk_dropped_fops);
 	if (!bt->dropped_file)
 		goto err;
 
-	bt->msg_file = debugfs_create_file("msg", 0222, dir, bt, &blk_msg_fops);
+	bt->msg_file = tracefs_create_file("msg", 0222, dir, bt, &blk_msg_fops);
 	if (!bt->msg_file)
 		goto err;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 37ba67e..bb221ba 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -18,7 +18,6 @@
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
 #include <linux/suspend.h>
-#include <linux/debugfs.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
@@ -36,6 +35,7 @@
 
 #include "trace_output.h"
 #include "trace_stat.h"
+#include "tracefs.h"
 
 #define FTRACE_WARN_ON(cond)			\
 	do {					\
@@ -772,7 +772,7 @@ static struct tracer_stat function_stats __initdata = {
 	.stat_show	= function_stat_show
 };
 
-static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_tracefs(void)
 {
 	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
@@ -808,15 +808,15 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 		}
 	}
 
-	entry = debugfs_create_file("function_profile_enabled", 0644,
-				    d_tracer, NULL, &ftrace_profile_fops);
+	entry = tracefs_create_file("function_profile_enabled", 0644,
+				    NULL, NULL, &ftrace_profile_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'function_profile_enabled' entry\n");
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
-static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_tracefs(void)
 {
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
@@ -2600,23 +2600,22 @@ static const struct file_operations ftrace_graph_fops = {
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
+static __init int ftrace_init_dyn_tracefs(void)
 {
-
 	trace_create_file("available_filter_functions", 0444,
-			d_tracer, NULL, &ftrace_avail_fops);
+			NULL, NULL, &ftrace_avail_fops);
 
 	trace_create_file("failures", 0444,
-			d_tracer, NULL, &ftrace_failures_fops);
+			NULL, NULL, &ftrace_failures_fops);
 
-	trace_create_file("set_ftrace_filter", 0644, d_tracer,
+	trace_create_file("set_ftrace_filter", 0644, NULL,
 			NULL, &ftrace_filter_fops);
 
-	trace_create_file("set_ftrace_notrace", 0644, d_tracer,
+	trace_create_file("set_ftrace_notrace", 0644, NULL,
 				    NULL, &ftrace_notrace_fops);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	trace_create_file("set_graph_function", 0444, d_tracer,
+	trace_create_file("set_graph_function", 0444, NULL,
 				    NULL,
 				    &ftrace_graph_fops);
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
@@ -2769,7 +2768,7 @@ static int __init ftrace_nodyn_init(void)
 }
 device_initcall(ftrace_nodyn_init);
 
-static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
+static inline int ftrace_init_dyn_tracefs(void) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 /* Keep as macros so we do not need to define the commands */
 # define ftrace_startup(command)	do { } while (0)
@@ -2933,24 +2932,20 @@ static const struct file_operations ftrace_pid_fops = {
 	.write = ftrace_pid_write,
 };
 
-static __init int ftrace_init_debugfs(void)
+static __init int ftrace_init_tracefs(void)
 {
-	struct dentry *d_tracer;
-
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return 0;
+	tracefs_init();
 
-	ftrace_init_dyn_debugfs(d_tracer);
+	ftrace_init_dyn_tracefs();
 
-	trace_create_file("set_ftrace_pid", 0644, d_tracer,
+	trace_create_file("set_ftrace_pid", 0644, NULL,
 			    NULL, &ftrace_pid_fops);
 
-	ftrace_profile_debugfs(d_tracer);
+	ftrace_profile_tracefs();
 
 	return 0;
 }
-fs_initcall(ftrace_init_debugfs);
+fs_initcall(ftrace_init_tracefs);
 
 /**
  * ftrace_kill - kill ftrace
diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index a91da69..5553890 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -8,7 +8,6 @@
 
 #include <linux/tracepoint.h>
 #include <linux/seq_file.h>
-#include <linux/debugfs.h>
 #include <linux/dcache.h>
 #include <linux/fs.h>
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d4ff019..8041979 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7,7 +7,6 @@
 #include <linux/trace_clock.h>
 #include <linux/ftrace_irq.h>
 #include <linux/spinlock.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <linux/kmemcheck.h>
@@ -21,6 +20,7 @@
 #include <linux/fs.h>
 
 #include "trace.h"
+#include "tracefs.h"
 
 /*
  * The ring buffer header is special. We must manually up keep it.
@@ -3820,19 +3820,17 @@ static const struct file_operations rb_simple_fops = {
 };
 
 
-static __init int rb_init_debugfs(void)
+static __init int rb_init_tracefs(void)
 {
-	struct dentry *d_tracer;
+	tracefs_init();
 
-	d_tracer = tracing_init_dentry();
-
-	trace_create_file("tracing_on", 0644, d_tracer,
+	trace_create_file("tracing_on", 0644, NULL,
 			    &ring_buffer_flags, &rb_simple_fops);
 
 	return 0;
 }
 
-fs_initcall(rb_init_debugfs);
+fs_initcall(rb_init_tracefs);
 #endif
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c820b03..3d2f56a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -20,7 +20,6 @@
 #include <linux/smp_lock.h>
 #include <linux/notifier.h>
 #include <linux/irqflags.h>
-#include <linux/debugfs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
 #include <linux/linkage.h>
@@ -39,6 +38,7 @@
 #include <linux/fs.h>
 
 #include "trace.h"
+#include "tracefs.h"
 #include "trace_output.h"
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
@@ -2453,7 +2453,7 @@ static const struct file_operations tracing_iter_fops = {
 
 static const char readme_msg[] =
 	"tracing mini-HOWTO:\n\n"
-	"# mount -t debugfs nodev /sys/kernel/debug\n\n"
+	"# mount -t tracefs nodev /sys/trace/\n\n"
 	"# cat /sys/kernel/debug/tracing/available_tracers\n"
 	"wakeup preemptirqsoff preemptoff irqsoff function sched_switch nop\n\n"
 	"# cat /sys/kernel/debug/tracing/current_tracer\n"
@@ -3792,56 +3792,29 @@ static const struct file_operations tracing_dyn_info_fops = {
 };
 #endif
 
-static struct dentry *d_tracer;
-
-struct dentry *tracing_init_dentry(void)
-{
-	static int once;
-
-	if (d_tracer)
-		return d_tracer;
-
-	if (!debugfs_initialized())
-		return NULL;
-
-	d_tracer = debugfs_create_dir("tracing", NULL);
-
-	if (!d_tracer && !once) {
-		once = 1;
-		pr_warning("Could not create debugfs directory 'tracing'\n");
-		return NULL;
-	}
-
-	return d_tracer;
-}
-
 static struct dentry *d_percpu;
 
 struct dentry *tracing_dentry_percpu(void)
 {
 	static int once;
-	struct dentry *d_tracer;
 
 	if (d_percpu)
 		return d_percpu;
 
-	d_tracer = tracing_init_dentry();
-
-	if (!d_tracer)
-		return NULL;
+	tracefs_init();
 
-	d_percpu = debugfs_create_dir("per_cpu", d_tracer);
+	d_percpu = tracefs_create_dir("per_cpu", NULL);
 
 	if (!d_percpu && !once) {
 		once = 1;
-		pr_warning("Could not create debugfs directory 'per_cpu'\n");
+		pr_warning("Could not create tracefs directory 'per_cpu'\n");
 		return NULL;
 	}
 
 	return d_percpu;
 }
 
-static void tracing_init_debugfs_percpu(long cpu)
+static void tracing_init_tracefs_percpu(long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu();
 	struct dentry *d_cpu;
@@ -3852,9 +3825,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 		return;
 
 	sprintf(cpu_dir, "cpu%ld", cpu);
-	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
+	d_cpu = tracefs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
-		pr_warning("Could not create debugfs '%s' entry\n", cpu_dir);
+		pr_warning("Could not create tracefs '%s' entry\n", cpu_dir);
 		return;
 	}
 
@@ -4026,9 +3999,9 @@ struct dentry *trace_create_file(const char *name,
 {
 	struct dentry *ret;
 
-	ret = debugfs_create_file(name, mode, parent, data, fops);
+	ret = tracefs_create_file(name, mode, parent, data, fops);
 	if (!ret)
-		pr_warning("Could not create debugfs '%s' entry\n", name);
+		pr_warning("Could not create tracefs '%s' entry\n", name);
 
 	return ret;
 }
@@ -4036,19 +4009,16 @@ struct dentry *trace_create_file(const char *name,
 
 static struct dentry *trace_options_init_dentry(void)
 {
-	struct dentry *d_tracer;
 	static struct dentry *t_options;
 
 	if (t_options)
 		return t_options;
 
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return NULL;
+	tracefs_init();
 
-	t_options = debugfs_create_dir("options", d_tracer);
+	t_options = tracefs_create_dir("options", NULL);
 	if (!t_options) {
-		pr_warning("Could not create debugfs directory 'options'\n");
+		pr_warning("Could not create tracefs directory 'options'\n");
 		return NULL;
 	}
 
@@ -4116,7 +4086,7 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
 
 	for (cnt = 0; topts[cnt].opt; cnt++) {
 		if (topts[cnt].entry)
-			debugfs_remove(topts[cnt].entry);
+			tracefs_remove(topts[cnt].entry);
 	}
 
 	kfree(topts);
@@ -4148,69 +4118,68 @@ static __init void create_trace_options_dir(void)
 		create_trace_option_core_file(trace_options[i], i);
 }
 
-static __init int tracer_init_debugfs(void)
+static __init int tracer_init_tracefs(void)
 {
-	struct dentry *d_tracer;
 	int cpu;
 
-	d_tracer = tracing_init_dentry();
+	tracefs_init();
 
-	trace_create_file("tracing_enabled", 0644, d_tracer,
+	trace_create_file("tracing_enabled", 0644, NULL,
 			&global_trace, &tracing_ctrl_fops);
 
-	trace_create_file("trace_options", 0644, d_tracer,
+	trace_create_file("trace_options", 0644, NULL,
 			NULL, &tracing_iter_fops);
 
-	trace_create_file("tracing_cpumask", 0644, d_tracer,
+	trace_create_file("tracing_cpumask", 0644, NULL,
 			NULL, &tracing_cpumask_fops);
 
-	trace_create_file("trace", 0644, d_tracer,
+	trace_create_file("trace", 0644, NULL,
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_fops);
 
-	trace_create_file("available_tracers", 0444, d_tracer,
+	trace_create_file("available_tracers", 0444, NULL,
 			&global_trace, &show_traces_fops);
 
-	trace_create_file("current_tracer", 0644, d_tracer,
+	trace_create_file("current_tracer", 0644, NULL,
 			&global_trace, &set_tracer_fops);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	trace_create_file("tracing_max_latency", 0644, d_tracer,
+	trace_create_file("tracing_max_latency", 0644, NULL,
 			&tracing_max_latency, &tracing_max_lat_fops);
 
-	trace_create_file("tracing_thresh", 0644, d_tracer,
+	trace_create_file("tracing_thresh", 0644, NULL,
 			&tracing_thresh, &tracing_max_lat_fops);
 #endif
 
-	trace_create_file("README", 0444, d_tracer,
+	trace_create_file("README", 0444, NULL,
 			NULL, &tracing_readme_fops);
 
-	trace_create_file("trace_pipe", 0444, d_tracer,
+	trace_create_file("trace_pipe", 0444, NULL,
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
 
-	trace_create_file("buffer_size_kb", 0644, d_tracer,
+	trace_create_file("buffer_size_kb", 0644, NULL,
 			&global_trace, &tracing_entries_fops);
 
-	trace_create_file("trace_marker", 0220, d_tracer,
+	trace_create_file("trace_marker", 0220, NULL,
 			NULL, &tracing_mark_fops);
 
-	trace_create_file("saved_cmdlines", 0444, d_tracer,
+	trace_create_file("saved_cmdlines", 0444, NULL,
 			NULL, &tracing_saved_cmdlines_fops);
 
-	trace_create_file("trace_clock", 0644, d_tracer, NULL,
+	trace_create_file("trace_clock", 0644, NULL, NULL,
 			  &trace_clock_fops);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
+	trace_create_file("dyn_ftrace_total_info", 0444, NULL,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
 #ifdef CONFIG_SYSPROF_TRACER
-	init_tracer_sysprof_debugfs(d_tracer);
+	init_tracer_sysprof_tracefs();
 #endif
 
 	create_trace_options_dir();
 
 	for_each_tracing_cpu(cpu)
-		tracing_init_debugfs_percpu(cpu);
+		tracing_init_tracefs_percpu(cpu);
 
 	return 0;
 }
@@ -4476,5 +4445,5 @@ __init static int clear_boot_tracer(void)
 }
 
 early_initcall(tracer_alloc_buffers);
-fs_initcall(tracer_init_debugfs);
+fs_initcall(tracer_init_tracefs);
 late_initcall(clear_boot_tracer);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 405cb85..f9c4639 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -236,7 +236,7 @@ struct tracer_flags {
 
 
 /**
- * struct tracer - a specific tracer and its callbacks to interact with debugfs
+ * struct tracer - a specific tracer and its callbacks to interact with tracefs
  * @name: the name chosen to select it on the available_tracers file
  * @init: called when one switches to this tracer (echo name > current_tracer)
  * @reset: called when one switches to another tracer
@@ -303,8 +303,7 @@ struct dentry *trace_create_file(const char *name,
 				 void *data,
 				 const struct file_operations *fops);
 
-struct dentry *tracing_init_dentry(void);
-void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
+void init_tracer_sysprof_tracefs(void);
 
 struct ring_buffer_event;
 
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index c21d5f3..a2235f4 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/init.h>
-#include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/kallsyms.h>
 #include <linux/time.h>
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 4a194f0..8a5cb65 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -7,7 +7,6 @@
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/irqflags.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d128f65..06b4e4b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -11,7 +11,6 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
@@ -20,6 +19,7 @@
 #include <asm/setup.h>
 
 #include "trace_output.h"
+#include "tracefs.h"
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM "TRACE_SYSTEM"
@@ -800,19 +800,15 @@ static const struct file_operations ftrace_show_header_fops = {
 
 static struct dentry *event_trace_events_dir(void)
 {
-	static struct dentry *d_tracer;
 	static struct dentry *d_events;
 
 	if (d_events)
 		return d_events;
 
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return NULL;
-
-	d_events = debugfs_create_dir("events", d_tracer);
+	tracefs_init();
+	d_events = tracefs_create_dir("events", NULL);
 	if (!d_events)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'events' directory\n");
 
 	return d_events;
@@ -842,7 +838,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 		return d_events;
 	}
 
-	system->entry = debugfs_create_dir(name, d_events);
+	system->entry = tracefs_create_dir(name, d_events);
 	if (!system->entry) {
 		pr_warning("Could not create event subsystem %s\n",
 			   name);
@@ -853,7 +849,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	system->nr_events = 1;
 	system->name = kstrdup(name, GFP_KERNEL);
 	if (!system->name) {
-		debugfs_remove(system->entry);
+		tracefs_remove(system->entry);
 		kfree(system);
 		return d_events;
 	}
@@ -869,12 +865,12 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 		return system->entry;
 	}
 
-	entry = debugfs_create_file("filter", 0644, system->entry, system,
+	entry = tracefs_create_file("filter", 0644, system->entry, system,
 				    &ftrace_subsystem_filter_fops);
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'%s/filter' entry\n", name);
 	}
 
@@ -902,9 +898,9 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	if (strcmp(call->system, TRACE_SYSTEM) != 0)
 		d_events = event_subsystem_dir(call->system, d_events);
 
-	call->dir = debugfs_create_dir(call->name, d_events);
+	call->dir = tracefs_create_dir(call->name, d_events);
 	if (!call->dir) {
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'%s' directory\n", call->name);
 		return -1;
 	}
@@ -972,7 +968,7 @@ static void remove_subsystem_dir(const char *name)
 			if (!--system->nr_events) {
 				struct event_filter *filter = system->filter;
 
-				debugfs_remove_recursive(system->entry);
+				tracefs_remove_recursive(system->entry);
 				list_del(&system->list);
 				if (filter) {
 					kfree(filter->filter_string);
@@ -1081,7 +1077,7 @@ static void trace_module_remove_events(struct module *mod)
 			ftrace_event_enable_disable(call, 0);
 			if (call->event)
 				__unregister_ftrace_event(call->event);
-			debugfs_remove_recursive(call->dir);
+			tracefs_remove_recursive(call->dir);
 			list_del(&call->list);
 			trace_destroy_fields(call);
 			destroy_preds(call);
@@ -1157,29 +1153,26 @@ __setup("trace_event=", setup_trace_event);
 static __init int event_trace_init(void)
 {
 	struct ftrace_event_call *call;
-	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
 	int ret;
 	char *buf = bootup_event_buf;
 	char *token;
 
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return 0;
+	tracefs_init();
 
-	entry = debugfs_create_file("available_events", 0444, d_tracer,
+	entry = tracefs_create_file("available_events", 0444, NULL,
 				    (void *)&show_event_seq_ops,
 				    &ftrace_avail_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'available_events' entry\n");
 
-	entry = debugfs_create_file("set_event", 0644, d_tracer,
+	entry = tracefs_create_file("set_event", 0644, NULL,
 				    (void *)&show_set_event_seq_ops,
 				    &ftrace_set_event_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'set_event' entry\n");
 
 	d_events = event_trace_events_dir();
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 98a6cc5..db194f4 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -18,7 +18,6 @@
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  */
 
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 9753fcc..18a4a76 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -6,7 +6,6 @@
 #include <linux/stringify.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b3f3776..e1fb56f 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -10,7 +10,6 @@
  *  Copyright (C) 2004 William Lee Irwin III
  */
 #include <linux/ring_buffer.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/fs.h>
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 45e6c01..3538256 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -6,7 +6,6 @@
  * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
  *
  */
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/fs.h>
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 69543a9..6238d9d 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -5,7 +5,6 @@
  * Markus Metzger <markus.t.metzger@gmail.com>, 2008-2009
  */
 #include <linux/kallsyms.h>
-#include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 3aa7eaa..9762b1f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -10,7 +10,6 @@
  *  Copyright (C) 2004 William Lee Irwin III
  */
 #include <linux/kallsyms.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 394f944..00f08f6 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -7,7 +7,6 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/debugfs.h>
 #include <linux/ftrace.h>
 
 #include "trace.h"
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2547d88..e02bb05 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -5,7 +5,6 @@
  *
  */
 #include <linux/seq_file.h>
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
@@ -18,6 +17,7 @@
 #include <linux/fs.h>
 
 #include "trace.h"
+#include "tracefs.h"
 
 #ifdef CONFIG_MODULES
 
@@ -229,13 +229,8 @@ static const struct file_operations ftrace_formats_fops = {
 
 static __init int init_trace_printk_function_export(void)
 {
-	struct dentry *d_tracer;
-
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return 0;
-
-	trace_create_file("printk_formats", 0444, d_tracer,
+	tracefs_init();
+	trace_create_file("printk_formats", 0444, NULL,
 				    NULL, &ftrace_formats_fops);
 
 	return 0;
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 5fca0f5..29313cd 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -6,7 +6,6 @@
  */
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 26185d7..b9021fa 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -11,7 +11,6 @@
  */
 #include <linux/module.h>
 #include <linux/fs.h>
-#include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 8504ac7..1da4e52 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -7,13 +7,14 @@
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
-#include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+
 #include "trace.h"
+#include "tracefs.h"
 
 #define STACK_TRACE_ENTRIES 500
 
@@ -331,14 +332,12 @@ __setup("stacktrace", enable_stacktrace);
 
 static __init int stack_trace_init(void)
 {
-	struct dentry *d_tracer;
-
-	d_tracer = tracing_init_dentry();
+	tracefs_init();
 
-	trace_create_file("stack_max_size", 0644, d_tracer,
+	trace_create_file("stack_max_size", 0644, NULL,
 			&max_stack_size, &stack_max_size_fops);
 
-	trace_create_file("stack_trace", 0444, d_tracer,
+	trace_create_file("stack_trace", 0444, NULL,
 			NULL, &stack_trace_fops);
 
 	if (stack_tracer_enabled)
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index a4bb239..4ee62a0 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -11,8 +11,8 @@
 
 #include <linux/list.h>
 #include <linux/rbtree.h>
-#include <linux/debugfs.h>
 #include "trace_stat.h"
+#include "tracefs.h"
 #include "trace.h"
 
 
@@ -95,7 +95,7 @@ static void reset_stat_session(struct stat_session *session)
 
 static void destroy_session(struct stat_session *session)
 {
-	debugfs_remove(session->file);
+	tracefs_remove(session->file);
 	__reset_stat_session(session);
 	mutex_destroy(&session->stat_mutex);
 	kfree(session);
@@ -303,13 +303,11 @@ static const struct file_operations tracing_stat_fops = {
 
 static int tracing_stat_init(void)
 {
-	struct dentry *d_tracing;
+	tracefs_init();
 
-	d_tracing = tracing_init_dentry();
-
-	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
+	stat_dir = tracefs_create_dir("trace_stat", NULL);
 	if (!stat_dir)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'trace_stat' entry\n");
 	return 0;
 }
@@ -319,7 +317,7 @@ static int init_stat_file(struct stat_session *session)
 	if (!stat_dir && tracing_stat_init())
 		return -ENODEV;
 
-	session->file = debugfs_create_file(session->ts->name, 0644,
+	session->file = tracefs_create_file(session->ts->name, 0644,
 					    stat_dir,
 					    session, &tracing_stat_fops);
 	if (!session->file)
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index f669396..6f970fe 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -6,7 +6,6 @@
  * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
  */
 #include <linux/kallsyms.h>
-#include <linux/debugfs.h>
 #include <linux/hrtimer.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
@@ -320,9 +319,9 @@ static const struct file_operations sysprof_sample_fops = {
 	.write		= sysprof_sample_write,
 };
 
-void init_tracer_sysprof_debugfs(struct dentry *d_tracer)
+void init_tracer_sysprof_tracefs(void)
 {
 
 	trace_create_file("sysprof_sample_period", 0644,
-			d_tracer, NULL, &sysprof_sample_fops);
+			NULL, NULL, &sysprof_sample_fops);
 }
diff --git a/kernel/trace/tracefs.c b/kernel/trace/tracefs.c
new file mode 100644
index 0000000..8ac9394
--- /dev/null
+++ b/kernel/trace/tracefs.c
@@ -0,0 +1,482 @@
+/*
+ *  tracefs - a virtual filesystem for the tracing subsystem.
+ *
+ *  Copyright (C) 2004,2009 Greg Kroah-Hartman <greg@kroah.com>
+ *  Copyright (C) 2004 IBM Inc.
+ *  Copyright (C) 2009 Novell Inc.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License version
+ *	2 as published by the Free Software Foundation.
+ *
+ */
+
+/* #define DEBUG */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/pagemap.h>
+#include <linux/init.h>
+#include <linux/kobject.h>
+#include <linux/namei.h>
+#include <linux/fsnotify.h>
+#include <linux/string.h>
+#include <linux/magic.h>
+#include <linux/module.h>
+#include "tracefs.h"
+
+static struct vfsmount *tracefs_mount;
+static int tracefs_mount_count;
+static bool tracefs_registered;
+
+static ssize_t default_read_file(struct file *file, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t default_write_file(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+static int default_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+const struct file_operations tracefs_file_operations = {
+	.read =		default_read_file,
+	.write =	default_write_file,
+	.open =		default_open,
+};
+
+static void *tracefs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	nd_set_link(nd, dentry->d_inode->i_private);
+	return NULL;
+}
+
+const struct inode_operations tracefs_link_operations = {
+	.readlink       = generic_readlink,
+	.follow_link    = tracefs_follow_link,
+};
+
+static struct inode *tracefs_get_inode(struct super_block *sb, int mode, dev_t dev)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_mode = mode;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		default:
+			init_special_inode(inode, mode, dev);
+			break;
+		case S_IFREG:
+			inode->i_fop = &tracefs_file_operations;
+			break;
+		case S_IFLNK:
+			inode->i_op = &tracefs_link_operations;
+			break;
+		case S_IFDIR:
+			inode->i_op = &simple_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+
+			/* directory inodes start off with i_nlink == 2
+			 * (for "." entry) */
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
+/* SMP-safe */
+static int tracefs_mknod(struct inode *dir, struct dentry *dentry,
+			 int mode, dev_t dev)
+{
+	struct inode *inode;
+	int error = -EPERM;
+
+	if (dentry->d_inode)
+		return -EEXIST;
+
+	inode = tracefs_get_inode(dir->i_sb, mode, dev);
+	if (inode) {
+		d_instantiate(dentry, inode);
+		dget(dentry);
+		error = 0;
+	}
+	return error;
+}
+
+static int tracefs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int res;
+
+	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
+	res = tracefs_mknod(dir, dentry, mode, 0);
+	if (!res) {
+		inc_nlink(dir);
+		fsnotify_mkdir(dir, dentry);
+	}
+	return res;
+}
+
+static int tracefs_link(struct inode *dir, struct dentry *dentry, int mode)
+{
+	mode = (mode & S_IALLUGO) | S_IFLNK;
+	return tracefs_mknod(dir, dentry, mode, 0);
+}
+
+static int tracefs_create(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int res;
+
+	mode = (mode & S_IALLUGO) | S_IFREG;
+	res = tracefs_mknod(dir, dentry, mode, 0);
+	if (!res)
+		fsnotify_create(dir, dentry);
+	return res;
+}
+
+static inline int tracefs_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
+static int trace_fill_super(struct super_block *sb, void *data, int silent)
+{
+	static struct tree_descr trace_files[] = {{""}};
+
+	return simple_fill_super(sb, TRACEFS_MAGIC, trace_files);
+}
+
+static int trace_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data, struct vfsmount *mnt)
+{
+	return get_sb_single(fs_type, flags, data, trace_fill_super, mnt);
+}
+
+static struct file_system_type trace_fs_type = {
+	.owner =	THIS_MODULE,
+	.name =		"tracefs",
+	.get_sb =	trace_get_sb,
+	.kill_sb =	kill_litter_super,
+};
+
+static int tracefs_create_by_name(const char *name, mode_t mode,
+				  struct dentry *parent,
+				  struct dentry **dentry)
+{
+	int error = 0;
+
+	/* If the parent is not specified, we create it in the root.
+	 * We need the root dentry to do this, which is in the super 
+	 * block. A pointer to that is in the struct vfsmount that we
+	 * have around.
+	 */
+	if (!parent) {
+		if (tracefs_mount && tracefs_mount->mnt_sb) {
+			parent = tracefs_mount->mnt_sb->s_root;
+		}
+	}
+	if (!parent) {
+		pr_debug("tracefs: Ah! can not find a parent!\n");
+		return -EFAULT;
+	}
+
+	*dentry = NULL;
+	mutex_lock(&parent->d_inode->i_mutex);
+	*dentry = lookup_one_len(name, parent, strlen(name));
+	if (!IS_ERR(*dentry)) {
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			error = tracefs_mkdir(parent->d_inode, *dentry, mode);
+			break;
+		case S_IFLNK:
+			error = tracefs_link(parent->d_inode, *dentry, mode);
+			break;
+		default:
+			error = tracefs_create(parent->d_inode, *dentry, mode);
+			break;
+		}
+		dput(*dentry);
+	} else
+		error = PTR_ERR(*dentry);
+	mutex_unlock(&parent->d_inode->i_mutex);
+
+	return error;
+}
+
+/**
+ * tracefs_create_file - create a file in the tracefs filesystem
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          file will be created in the root of the tracefs filesystem.
+ * @data: a pointer to something that the caller will want to get to later
+ *        on.  The inode.i_private pointer will point to this value on
+ *        the open() call.
+ * @fops: a pointer to a struct file_operations that should be used for
+ *        this file.
+ *
+ * This is the basic "create a file" function for tracefs.  It allows for a
+ * wide range of flexibility in createing a file, or a directory (if you
+ * want to create a directory, the tracefs_create_dir() function is
+ * recommended to be used instead.)
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the tracefs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If tracefs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *tracefs_create_file(const char *name, mode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops)
+{
+	struct dentry *dentry = NULL;
+	int error;
+
+	pr_debug("tracefs: creating file '%s'\n",name);
+
+	error = simple_pin_fs(&trace_fs_type, &tracefs_mount,
+			      &tracefs_mount_count);
+	if (error)
+		goto exit;
+
+	error = tracefs_create_by_name(name, mode, parent, &dentry);
+	if (error) {
+		dentry = NULL;
+		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+		goto exit;
+	}
+
+	if (dentry->d_inode) {
+		if (data)
+			dentry->d_inode->i_private = data;
+		if (fops)
+			dentry->d_inode->i_fop = fops;
+	}
+exit:
+	return dentry;
+}
+EXPORT_SYMBOL_GPL(tracefs_create_file);
+
+/**
+ * tracefs_create_dir - create a directory in the tracefs filesystem
+ * @name: a pointer to a string containing the name of the directory to
+ *        create.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          directory will be created in the root of the tracefs filesystem.
+ *
+ * This function creates a directory in tracefs with the given name.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the tracefs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If tracefs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *tracefs_create_dir(const char *name, struct dentry *parent)
+{
+	return tracefs_create_file(name, 
+				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+				   parent, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(tracefs_create_dir);
+
+static void __tracefs_remove(struct dentry *dentry, struct dentry *parent)
+{
+	int ret = 0;
+
+	if (tracefs_positive(dentry)) {
+		if (dentry->d_inode) {
+			dget(dentry);
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
+				ret = simple_rmdir(parent->d_inode, dentry);
+				break;
+			case S_IFLNK:
+				kfree(dentry->d_inode->i_private);
+				/* fall through */
+			default:
+				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
+			if (!ret)
+				d_delete(dentry);
+			dput(dentry);
+		}
+	}
+}
+
+/**
+ * tracefs_remove - removes a file or directory from the tracefs filesystem
+ * @dentry: a pointer to a the dentry of the file or directory to be
+ *          removed.
+ *
+ * This function removes a file or directory in tracefs that was previously
+ * created with a call to another tracefs function (like
+ * tracefs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void tracefs_remove(struct dentry *dentry)
+{
+	struct dentry *parent;
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	__tracefs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+}
+EXPORT_SYMBOL_GPL(tracefs_remove);
+
+/**
+ * tracefs_remove_recursive - recursively removes a directory
+ * @dentry: a pointer to a the dentry of the directory to be removed.
+ *
+ * This function recursively removes a directory tree in tracefs that
+ * was previously created with a call to another tracefs function
+ * (like tracefs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void tracefs_remove_recursive(struct dentry *dentry)
+{
+	struct dentry *child;
+	struct dentry *parent;
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	parent = dentry;
+	mutex_lock(&parent->d_inode->i_mutex);
+
+	while (1) {
+		/*
+		 * When all dentries under "parent" has been removed,
+		 * walk up the tree until we reach our starting point.
+		 */
+		if (list_empty(&parent->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			if (parent == dentry)
+				break;
+			parent = parent->d_parent;
+			mutex_lock(&parent->d_inode->i_mutex);
+		}
+		child = list_entry(parent->d_subdirs.next, struct dentry,
+				d_u.d_child);
+ next_sibling:
+
+		/*
+		 * If "child" isn't empty, walk down the tree and
+		 * remove all its descendants first.
+		 */
+		if (!list_empty(&child->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			parent = child;
+			mutex_lock(&parent->d_inode->i_mutex);
+			continue;
+		}
+		__tracefs_remove(child, parent);
+		if (parent->d_subdirs.next == &child->d_u.d_child) {
+			/*
+			 * Try the next sibling.
+			 */
+			if (child->d_u.d_child.next != &parent->d_subdirs) {
+				child = list_entry(child->d_u.d_child.next,
+						   struct dentry,
+						   d_u.d_child);
+				goto next_sibling;
+			}
+
+			/*
+			 * Avoid infinite loop if we fail to remove
+			 * one dentry.
+			 */
+			mutex_unlock(&parent->d_inode->i_mutex);
+			break;
+		}
+		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+	}
+
+	parent = dentry->d_parent;
+	mutex_lock(&parent->d_inode->i_mutex);
+	__tracefs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+}
+EXPORT_SYMBOL_GPL(tracefs_remove_recursive);
+
+/**
+ * tracefs_initialized - Tells whether tracefs has been registered
+ */
+bool tracefs_initialized(void)
+{
+	return tracefs_registered;
+}
+
+static struct kobject *trace_kobj;
+
+int tracefs_init(void)
+{
+	int retval;
+
+	if (tracefs_initialized())
+		return 0;
+
+	trace_kobj = kobject_create_and_add("trace", kernel_kobj);
+	if (!trace_kobj)
+		return -EINVAL;
+
+	retval = register_filesystem(&trace_fs_type);
+	if (retval)
+		kobject_put(trace_kobj);
+	else
+		tracefs_registered = true;
+
+	return retval;
+}
+
+static void tracefs_exit(void)
+{
+	tracefs_registered = false;
+
+	simple_release_fs(&tracefs_mount, &tracefs_mount_count);
+	unregister_filesystem(&trace_fs_type);
+	kobject_put(trace_kobj);
+}
+
+core_initcall(tracefs_init);
+module_exit(tracefs_exit);
+
diff --git a/kernel/trace/tracefs.h b/kernel/trace/tracefs.h
new file mode 100644
index 0000000..7618221
--- /dev/null
+++ b/kernel/trace/tracefs.h
@@ -0,0 +1,33 @@
+/*
+ *  Copyright (C) 2004,2009 Greg Kroah-Hartman <greg@kroah.com>
+ *  Copyright (C) 2004 IBM Inc.
+ *  Copyright (C) 2009 Novell Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef _TRACEFS_H_
+#define _TRACEFS_H_
+
+#include <linux/fs.h>
+#include <linux/types.h>
+
+struct file_operations;
+
+struct dentry *tracefs_create_file(const char *name, mode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops);
+
+struct dentry *tracefs_create_dir(const char *name, struct dentry *parent);
+
+void tracefs_remove(struct dentry *dentry);
+
+void tracefs_remove_recursive(struct dentry *dentry);
+
+bool tracefs_initialized(void);
+
+int tracefs_init(void);
+
+#endif
