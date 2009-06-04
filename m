Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZFDF1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZFDF1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZFDF0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:26:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZFDF0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:26:13 -0400
Message-Id: <20090604052613.866267085@goodmis.org>
References: <20090604052540.528802957@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 04 Jun 2009 01:25:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/6] tracing/branch-profiler: add option to profile branches per cpu
Content-Disposition: inline; filename=0006-tracing-branch-profiler-add-option-to-profile-branch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The branch profiler increments a variable at every branch, saying
whether the branch was taken or not. The problem with this is that
on large CPU machines, this can cause severe cacheline bouncing.

A way around this is to have per cpu tables.

But having per cpu buffers can also be an issue. The branch profiler
requires a table of all branches, which can be rather large
(looking at my current image, it is 2.2 megs). For machines that have
only 2 to 4 CPUs, the cache line bouncing may not be that much
of an issue. This will needlessly double the amount of memory needed.

This patch creates an option that allows the user to enable or disable
percpu table recording of the branch profiler.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |   16 ++++++++--
 include/linux/kernel.h            |   11 ++++++-
 kernel/trace/Kconfig              |   13 ++++++++
 kernel/trace/trace_branch.c       |   62 +++++++++++++++++++++++++++++++++++-
 4 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f1736ca..ddc78c3 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -56,11 +56,19 @@
 #endif
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
-#define BRANCH_PROFILE()	VMLINUX_SYMBOL(__start_branch_profile) = .;   \
+#define _BRANCH_PROFILE()	VMLINUX_SYMBOL(__start_branch_profile) = .;   \
 				*(_ftrace_branch)			      \
 				VMLINUX_SYMBOL(__stop_branch_profile) = .;
 #else
-#define BRANCH_PROFILE()
+#define _BRANCH_PROFILE()
+#endif
+
+#ifdef CONFIG_PROFILE_BRANCHES_PER_CPU
+# define BRANCH_PROFILE()
+# define BRANCH_PER_CPU_PROFILE()	_BRANCH_PROFILE()
+#else
+# define BRANCH_PROFILE()		_BRANCH_PROFILE()
+# define BRANCH_PER_CPU_PROFILE()
 #endif
 
 #ifdef CONFIG_EVENT_TRACING
@@ -111,7 +119,7 @@
 	*(__verbose)                                                    \
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
 	LIKELY_PROFILE()		       				\
-	BRANCH_PROFILE()						\
+	BRANCH_PROFILE()		       				\
 	TRACE_PRINTKS()							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()
@@ -481,6 +489,7 @@
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
+		BRANCH_PER_CPU_PROFILE()				\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	} phdr								\
 	. = VMLINUX_SYMBOL(__per_cpu_load) + SIZEOF(.data.percpu);
@@ -507,5 +516,6 @@
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
+		BRANCH_PER_CPU_PROFILE()				\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
 	}
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 9372a87..ef821ff 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -78,6 +78,15 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #ifdef CONFIG_PROFILE_ALL_BRANCHES
 extern int sysctl_branch_profiling_enabled;
+#ifdef CONFIG_PROFILE_BRANCHES_PER_CPU
+extern void branch_profiler(struct ftrace_branch_data *data, int cond);
+#else
+static inline void branch_profiler(struct ftrace_branch_data *data, int cond)
+{
+	data->miss_hit[cond]++;
+}
+#endif
+
 /*
  * "Define 'is'", Bill Clinton
  * "Define 'if'", Steven Rostedt
@@ -97,7 +106,7 @@ extern int sysctl_branch_profiling_enabled;
 				.line = __LINE__,			\
 			};						\
 		______r = !!(cond);					\
-		______f.miss_hit[______r]++;				\
+		branch_profiler(&______f, ______r);			\
 		______r;						\
 	}))
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 4a13e5a..309a264 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -283,6 +283,19 @@ config PROFILE_ALL_BRANCHES
 	  is to be analyzed
 endchoice
 
+config PROFILE_BRANCHES_PER_CPU
+	bool "Profile branches on a per cpu basis"
+	depends on PROFILE_ALL_BRANCHES
+	help
+	  When profiling all branches, the system can take a big cache line
+	  bouncing hit. On boxes with lots of CPUs, this can slow the system
+	  down so much that it can live lock.
+
+	  This option solves the issue by making the profiler data per CPU.
+	  This avoids the cache line bouncing, but at the cost of having the
+	  branch table copied for every CPU. This table is quite large and
+	  this option will duplicate it for every CPU.
+
 config TRACING_BRANCHES
 	bool
 	help
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index e4f1465..08e3d90 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -9,6 +9,7 @@
 #include <linux/irqflags.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
+#include <linux/percpu.h>
 #include <linux/module.h>
 #include <linux/ftrace.h>
 #include <linux/hash.h>
@@ -343,6 +344,38 @@ static int __init set_enable_branch_profiler(char *str)
 }
 __setup("enable_branch_profiler", set_enable_branch_profiler);
 
+static unsigned long branch_count;
+
+#ifdef CONFIG_PROFILE_BRANCHES_PER_CPU
+#define branch_percpu(p, cpu)	SHIFT_PERCPU_PTR(p, per_cpu_offset(cpu))
+void branch_profiler(struct ftrace_branch_data *data, int cond)
+{
+	branch_percpu(data, raw_smp_processor_id())->miss_hit[cond]++;
+}
+static void calculate_stat(struct ftrace_branch_data *stat,
+			   struct ftrace_branch_data *p)
+{
+	int rec = 0;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (!rec) {
+			rec++;
+			*stat = *branch_percpu(p, cpu);
+		} else {
+			stat->miss_hit[0] += branch_percpu(p, cpu)->miss_hit[0];
+			stat->miss_hit[1] += branch_percpu(p, cpu)->miss_hit[1];
+		}
+	}
+}
+#else
+static void calculate_stat(struct ftrace_branch_data *stat,
+			   struct ftrace_branch_data *p)
+{
+	*stat = *p;
+}
+#endif
+
 extern unsigned long __start_branch_profile[];
 extern unsigned long __stop_branch_profile[];
 
@@ -357,6 +390,11 @@ static int all_branch_stat_headers(struct seq_file *m)
 	return 0;
 }
 
+struct ftrace_branch_stat {
+	struct tracer_stat		stat;
+	int				cpu;
+};
+
 static void *all_branch_stat_start(struct tracer_stat *trace)
 {
 	return __start_branch_profile;
@@ -369,20 +407,36 @@ all_branch_stat_next(void *v, int idx)
 
 	++p;
 
-	if ((void *)p >= (void *)__stop_branch_profile)
+	if (idx >= branch_count)
 		return NULL;
 
 	return p;
 }
 
+static int all_branch_stat_show(struct seq_file *m, void *v)
+{
+	struct ftrace_branch_data *p = v;
+	struct ftrace_branch_data stat;
+
+	calculate_stat(&stat, p);
+
+	return branch_stat_show(m, &stat);
+}
+
 static struct tracer_stat all_branch_stats = {
 	.name = "branch_all",
 	.stat_start = all_branch_stat_start,
 	.stat_next = all_branch_stat_next,
 	.stat_headers = all_branch_stat_headers,
-	.stat_show = branch_stat_show
+	.stat_show = all_branch_stat_show
 };
 
+static void calculate_branch_count(void)
+{
+	branch_count = ((unsigned long)&__stop_branch_profile -
+			(unsigned long)&__start_branch_profile) /
+		sizeof(struct ftrace_branch_stat);
+}
 __init static int all_annotated_branch_stats(void)
 {
 	int ret;
@@ -393,7 +447,11 @@ __init static int all_annotated_branch_stats(void)
 				    "all branches stats\n");
 		return 1;
 	}
+
+	calculate_branch_count();
+
 	return 0;
 }
+
 fs_initcall(all_annotated_branch_stats);
 #endif /* CONFIG_PROFILE_ALL_BRANCHES */
-- 
1.6.3.1

-- 
