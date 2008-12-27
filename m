Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYL0WrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYL0WrZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 17:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYL0WrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 17:47:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:2404 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYL0WrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 17:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=mQe5/V2bBbL39S0gX2qGM9HPsPak7hGhHuJe5ZEbSmL1U4xolq6STaNoCprTKxRxfP
         e03P4/KoUJNubpmNuN0SaWJ5lId4Hlp8nCKOKDlHl5K/RfEW/1xLaPGH3VOquW18lSST
         Rp4mKY/WO3CA3r2OEry8KfEuLyzeLh4BNRf5A=
Message-ID: <4956b070.0c07560a.2b34.2325@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Date: Sat, 27 Dec 2008 23:25:38 +0100
Subject: [PATCH 2/2] tracing/branch-tracer: adapt to the stat tracing API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adapts the branch tracer to the tracing API.
This is not really for inclusion but more likely a proof of concept because
the branch tracer implements two "stat tracing" that were split in two files.

So I added an option to the branch tracer: stat_all_branch.
If it is set, then trace_stat will output all of the branches entries stats.
Otherwise, it will print the annotated branches.

Its is a kind of quick trick, waiting for a better solution.
By default, the annotated branches stat are sorted by incorrect branch prediction
percentage.

Ie:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0        1 100 native_smp_prepare_cpus        smpboot.c            1228
       0        1 100 hpet_rtc_timer_reinit          hpet.c               1057
       0    18032 100 sched_info_queued              sched_stats.h        223
       0      684 100 yield_task_fair                sched_fair.c         984
       0      282 100 pre_schedule_rt                sched_rt.c           1263
       0    13414 100 sched_info_dequeued            sched_stats.h        178
       0    21724 100 sched_info_switch              sched_stats.h        270
       0        1 100 get_signal_to_deliver          signal.c             1820
       0        8 100 __cancel_work_timer            workqueue.c          560
       0      212 100 verify_export_symbols          module.c             1509
       0       17 100 __rmqueue_fallback             page_alloc.c         793
       0       43 100 clear_page_mlock               internal.h           129
       0      124 100 try_to_unmap_anon              rmap.c               1021
       0       53 100 try_to_unmap_anon              rmap.c               1013
       0        6 100 vma_address                    rmap.c               232
       0     3301 100 try_to_unmap_file              rmap.c               1082
       0      466 100 try_to_unmap_file              rmap.c               1077
       0        1 100 mem_cgroup_create              memcontrol.c         1090
       0        3 100 inotify_find_update_watch      inotify.c            726
       2    30163  99 perf_counter_task_sched_out    perf_counter.c       385
       1     2935  99 percpu_free                    allocpercpu.c        138
    1544   297672  99 dentry_lru_del_init            dcache.c             153
       8     1074  99 input_pass_event               input.c              86
    1390    76781  98 mapping_unevictable            pagemap.h            50
     280     6665  95 pick_next_task_rt              sched_rt.c           889
     750     4826  86 next_pidmap                    pid.c                194
       2        8  80 blocking_notifier_chain_regist notifier.c           220
      36      130  78 ioremap_pte_range              ioremap.c            22
    1093     3247  74 IS_ERR                         err.h                34
    1023     2908  73 sched_slice                    sched_fair.c         445
      22       60  73 disk_put_part                  genhd.h              206
[...]

It enables a developer to quickly address the source of incorrect branch predictions.
Note that this sorting would be better with a second sort on the number of incorrect
predictions.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_branch.c |  268 +++++++++++++++++++++++--------------------
 1 files changed, 142 insertions(+), 126 deletions(-)

diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index c15222a..4785a3b 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -18,10 +18,13 @@
 #include "trace.h"
 #include "trace_output.h"
 
+static struct tracer branch_trace;
+
 #ifdef CONFIG_BRANCH_TRACER
 
 static int branch_tracing_enabled __read_mostly;
 static DEFINE_MUTEX(branch_tracing_mutex);
+
 static struct trace_array *branch_tracer;
 
 static void
@@ -178,6 +181,7 @@ trace_branch_print(struct trace_seq *s, struct trace_entry *entry, int flags)
 	return 0;
 }
 
+
 static struct trace_event trace_branch_event = {
 	.type	 	= TRACE_BRANCH,
 	.trace		= trace_branch_print,
@@ -187,30 +191,6 @@ static struct trace_event trace_branch_event = {
 	.binary		= trace_nop_print,
 };
 
-struct tracer branch_trace __read_mostly =
-{
-	.name		= "branch",
-	.init		= branch_trace_init,
-	.reset		= branch_trace_reset,
-#ifdef CONFIG_FTRACE_SELFTEST
-	.selftest	= trace_selftest_startup_branch,
-#endif
-};
-
-__init static int init_branch_trace(void)
-{
-	int ret;
-
-	ret = register_ftrace_event(&trace_branch_event);
-	if (!ret) {
-		printk(KERN_WARNING "Warning: could not register branch events\n");
-		return 1;
-	}
-
-	return register_tracer(&branch_trace);
-}
-
-device_initcall(init_branch_trace);
 #else
 static inline
 void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
@@ -236,66 +216,39 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
 }
 EXPORT_SYMBOL(ftrace_likely_update);
 
-struct ftrace_pointer {
-	void		*start;
-	void		*stop;
-	int		hit;
-};
+extern unsigned long __start_annotated_branch_profile[];
+extern unsigned long __stop_annotated_branch_profile[];
 
-static void *
-t_next(struct seq_file *m, void *v, loff_t *pos)
+static int annotated_branch_stat_headers(struct seq_file *m)
 {
-	const struct ftrace_pointer *f = m->private;
-	struct ftrace_branch_data *p = v;
-
-	(*pos)++;
-
-	if (v == (void *)1)
-		return f->start;
-
-	++p;
-
-	if ((void *)p >= (void *)f->stop)
-		return NULL;
-
-	return p;
+	seq_printf(m, " correct incorrect  %% ");
+	seq_printf(m, "       Function                "
+			      "  File              Line\n"
+			      " ------- ---------  - "
+			      "       --------                "
+			      "  ----              ----\n");
+	return 0;
 }
 
-static void *t_start(struct seq_file *m, loff_t *pos)
+static inline long get_incorrect_percent(struct ftrace_branch_data *p)
 {
-	void *t = (void *)1;
-	loff_t l = 0;
-
-	for (; t && l < *pos; t = t_next(m, t, &l))
-		;
+	long percent;
 
-	return t;
-}
+	if (p->correct) {
+		percent = p->incorrect * 100;
+		percent /= p->correct + p->incorrect;
+	} else
+		percent = p->incorrect ? 100 : -1;
 
-static void t_stop(struct seq_file *m, void *p)
-{
+	return percent;
 }
 
-static int t_show(struct seq_file *m, void *v)
+static int branch_stat_show(struct seq_file *m, void *v)
 {
-	const struct ftrace_pointer *fp = m->private;
 	struct ftrace_branch_data *p = v;
 	const char *f;
 	long percent;
 
-	if (v == (void *)1) {
-		if (fp->hit)
-			seq_printf(m, "   miss      hit    %% ");
-		else
-			seq_printf(m, " correct incorrect  %% ");
-		seq_printf(m, "       Function                "
-			      "  File              Line\n"
-			      " ------- ---------  - "
-			      "       --------                "
-			      "  ----              ----\n");
-		return 0;
-	}
-
 	/* Only print the file, not the path */
 	f = p->file + strlen(p->file);
 	while (f >= p->file && *f != '/')
@@ -305,11 +258,7 @@ static int t_show(struct seq_file *m, void *v)
 	/*
 	 * The miss is overlayed on correct, and hit on incorrect.
 	 */
-	if (p->correct) {
-		percent = p->incorrect * 100;
-		percent /= p->correct + p->incorrect;
-	} else
-		percent = p->incorrect ? 100 : -1;
+	percent = get_incorrect_percent(p);
 
 	seq_printf(m, "%8lu %8lu ",  p->correct, p->incorrect);
 	if (percent < 0)
@@ -320,76 +269,143 @@ static int t_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations tracing_likely_seq_ops = {
-	.start		= t_start,
-	.next		= t_next,
-	.stop		= t_stop,
-	.show		= t_show,
-};
+static void *annotated_branch_stat_start(void)
+{
+	return __start_annotated_branch_profile;
+}
 
-static int tracing_branch_open(struct inode *inode, struct file *file)
+static void *
+annotated_branch_stat_next(void *v, int idx)
 {
-	int ret;
+	struct ftrace_branch_data *p = v;
 
-	ret = seq_open(file, &tracing_likely_seq_ops);
-	if (!ret) {
-		struct seq_file *m = file->private_data;
-		m->private = (void *)inode->i_private;
-	}
+	++p;
 
-	return ret;
+	if ((void *)p >= (void *)__stop_annotated_branch_profile)
+		return NULL;
+
+	return p;
 }
 
-static const struct file_operations tracing_branch_fops = {
-	.open		= tracing_branch_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-};
+static int annotated_branch_stat_cmp(void *p1, void *p2)
+{
+	struct ftrace_branch_data *a = p1;
+	struct ftrace_branch_data *b = p2;
+
+	long percent_a, percent_b;
+
+	percent_a = get_incorrect_percent(a);
+	percent_b = get_incorrect_percent(b);
+
+	if (percent_a < percent_b)
+		return -1;
+	if (percent_a > percent_b)
+		return 1;
+	else
+		return 0;
+}
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-extern unsigned long __start_branch_profile[];
-extern unsigned long __stop_branch_profile[];
+enum {
+	TRACE_BRANCH_OPT_ALL = 0x1
+};
 
-static const struct ftrace_pointer ftrace_branch_pos = {
-	.start			= __start_branch_profile,
-	.stop			= __stop_branch_profile,
-	.hit			= 1,
+static struct tracer_opt branch_opts[] = {
+	{ TRACER_OPT(stat_all_branch, TRACE_BRANCH_OPT_ALL) },
+	{ }
 };
 
-#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+static struct tracer_flags branch_flags = {
+	.val = 0,
+	.opts = branch_opts
+};
 
-extern unsigned long __start_annotated_branch_profile[];
-extern unsigned long __stop_annotated_branch_profile[];
+extern unsigned long __start_branch_profile[];
+extern unsigned long __stop_branch_profile[];
 
-static const struct ftrace_pointer ftrace_annotated_branch_pos = {
-	.start			= __start_annotated_branch_profile,
-	.stop			= __stop_annotated_branch_profile,
-};
+static int all_branch_stat_headers(struct seq_file *m)
+{
+	seq_printf(m, "   miss      hit    %% ");
+	seq_printf(m, "       Function                "
+			      "  File              Line\n"
+			      " ------- ---------  - "
+			      "       --------                "
+			      "  ----              ----\n");
+	return 0;
+}
 
-static __init int ftrace_branch_init(void)
+static void *all_branch_stat_start(void)
 {
-	struct dentry *d_tracer;
-	struct dentry *entry;
+	return __start_branch_profile;
+}
+
+static void *
+all_branch_stat_next(void *v, int idx)
+{
+	struct ftrace_branch_data *p = v;
 
-	d_tracer = tracing_init_dentry();
+	++p;
 
-	entry = debugfs_create_file("profile_annotated_branch", 0444, d_tracer,
-				    (void *)&ftrace_annotated_branch_pos,
-				    &tracing_branch_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'profile_annotatet_branch' entry\n");
+	if ((void *)p >= (void *)__stop_branch_profile)
+		return NULL;
 
-#ifdef CONFIG_PROFILE_ALL_BRANCHES
-	entry = debugfs_create_file("profile_branch", 0444, d_tracer,
-				    (void *)&ftrace_branch_pos,
-				    &tracing_branch_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs"
-			   " 'profile_branch' entry\n");
-#endif
+	return p;
+}
 
+static int branch_set_flag(u32 old_flags, u32 bit, int set)
+{
+	if (bit == TRACE_BRANCH_OPT_ALL) {
+		if (set) {
+			branch_trace.stat_headers = all_branch_stat_headers;
+			branch_trace.stat_start = all_branch_stat_start;
+			branch_trace.stat_next = all_branch_stat_next;
+			branch_trace.stat_cmp = NULL;
+		} else {
+			branch_trace.stat_headers =
+				annotated_branch_stat_headers;
+			branch_trace.stat_start = annotated_branch_stat_start;
+			branch_trace.stat_next = annotated_branch_stat_next;
+			branch_trace.stat_cmp = annotated_branch_stat_cmp;
+		}
+		init_tracer_stat(&branch_trace);
+	}
 	return 0;
 }
 
-device_initcall(ftrace_branch_init);
+#endif /* CONFIG_PROFILE_ALL_BRANCHES */
+
+static struct tracer branch_trace __read_mostly =
+{
+	.name		= "branch",
+#ifdef CONFIG_BRANCH_TRACER
+	.init		= branch_trace_init,
+	.reset		= branch_trace_reset,
+#ifdef CONFIG_FTRACE_SELFTEST
+	.selftest	= trace_selftest_startup_branch,
+#endif /* CONFIG_FTRACE_SELFTEST */
+#endif /* CONFIG_BRANCH_TRACER */
+	.stat_start	=	annotated_branch_stat_start,
+	.stat_next	= annotated_branch_stat_next,
+	.stat_show	= branch_stat_show,
+	.stat_headers	= annotated_branch_stat_headers,
+	.stat_cmp	= annotated_branch_stat_cmp,
+#ifdef CONFIG_PROFILE_ALL_BRANCHES
+	.flags	= &branch_flags,
+	.set_flag	= branch_set_flag,
+#endif
+};
+
+__init static int init_branch_trace(void)
+{
+#ifdef CONFIG_BRANCH_TRACER
+	int ret;
+	ret = register_ftrace_event(&trace_branch_event);
+	if (!ret) {
+		printk(KERN_WARNING "Warning: could not register branch events\n");
+		return 1;
+	}
+#endif
+
+	return register_tracer(&branch_trace);
+}
+device_initcall(init_branch_trace);
-- 
1.6.0.4


