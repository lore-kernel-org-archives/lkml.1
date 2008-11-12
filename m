Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbYKLFQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbYKLFQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 00:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYKLFPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 00:15:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYKLFPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 00:15:20 -0500
Message-Id: <20081112051518.277009700@goodmis.org>
References: <20081112051438.843792214@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 00:14:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] trace: profile likely and unlikely annotations
Content-Disposition: inline; filename=0001-trace-profile-likely-and-unlikely-annotations.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: new unlikely/likely profiler

Andrew Morton recently suggested having an in-kernel way to profile
likely and unlikely macros. This patch achieves that goal.

When configured, every(*) likely and unlikely macro gets a counter attached
to it. When the condition is hit, the hit and misses of that condition
are recorded. These numbers can later be retrieved by:

  /debugfs/tracing/profile_likely    - All likely markers
  /debugfs/tracing/profile_unlikely  - All unlikely markers.

# cat /debug/tracing/profile_unlikely | head
 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
    2167        0   0 do_arch_prctl                  process_64.c         832
       0        0   0 do_arch_prctl                  process_64.c         804
    2670        0   0 IS_ERR                         err.h                34
   71230     5693   7 __switch_to                    process_64.c         673
   76919        0   0 __switch_to                    process_64.c         639
   43184    33743  43 __switch_to                    process_64.c         624
   12740    64181  83 __switch_to                    process_64.c         594
   12740    64174  83 __switch_to                    process_64.c         590

# cat /debug/tracing/profile_unlikely | \
  awk '{ if ($3 > 25) print $0; }' |head -20
   44963    35259  43 __switch_to                    process_64.c         624
   12762    67454  84 __switch_to                    process_64.c         594
   12762    67447  84 __switch_to                    process_64.c         590
    1478      595  28 syscall_get_error              syscall.h            51
       0     2821 100 syscall_trace_leave            ptrace.c             1567
       0        1 100 native_smp_prepare_cpus        smpboot.c            1237
   86338   265881  75 calc_delta_fair                sched_fair.c         408
  210410   108540  34 calc_delta_mine                sched.c              1267
       0    54550 100 sched_info_queued              sched_stats.h        222
   51899    66435  56 pick_next_task_fair            sched_fair.c         1422
       6       10  62 yield_task_fair                sched_fair.c         982
    7325     2692  26 rt_policy                      sched.c              144
       0     1270 100 pre_schedule_rt                sched_rt.c           1261
    1268    48073  97 pick_next_task_rt              sched_rt.c           884
       0    45181 100 sched_info_dequeued            sched_stats.h        177
       0       15 100 sched_move_task                sched.c              8700
       0       15 100 sched_move_task                sched.c              8690
   53167    33217  38 schedule                       sched.c              4457
       0    80208 100 sched_info_switch              sched_stats.h        270
   30585    49631  61 context_switch                 sched.c              2619

# cat /debug/tracing/profile_likely | awk '{ if ($3 > 25) print $0; }'
   39900    36577  47 pick_next_task                 sched.c              4397
   20824    15233  42 switch_mm                      mmu_context_64.h     18
       0        7 100 __cancel_work_timer            workqueue.c          560
     617    66484  99 clocksource_adjust             timekeeping.c        456
       0   346340 100 audit_syscall_exit             auditsc.c            1570
      38   347350  99 audit_get_context              auditsc.c            732
       0   345244 100 audit_syscall_entry            auditsc.c            1541
      38     1017  96 audit_free                     auditsc.c            1446
       0     1090 100 audit_alloc                    auditsc.c            862
    2618     1090  29 audit_alloc                    auditsc.c            858
       0        6 100 move_masked_irq                migration.c          9
       1      198  99 probe_sched_wakeup             trace_sched_switch.c 58
       2        2  50 probe_wakeup                   trace_sched_wakeup.c 227
       0        2 100 probe_wakeup_sched_switch      trace_sched_wakeup.c 144
    4514     2090  31 __grab_cache_page              filemap.c            2149
   12882   228786  94 mapping_unevictable            pagemap.h            50
       4       11  73 __flush_cpu_slab               slub.c               1466
  627757   330451  34 slab_free                      slub.c               1731
    2959    61245  95 dentry_lru_del_init            dcache.c             153
     946     1217  56 load_elf_binary                binfmt_elf.c         904
     102       82  44 disk_put_part                  genhd.h              206
       1        1  50 dst_gc_task                    dst.c                82
       0       19 100 tcp_mss_split_point            tcp_output.c         1126

As you can see by the above, there's a bit of work to do in rethinking
the use of some unlikelys and likelys. Note: the unlikely case had 71 hits
that were more than 25%.

Note:  After submitting my first version of this patch, Andrew Morton
  showed me a version written by Daniel Walker, where I picked up
  the following ideas from:

  1)  Using __builtin_constant_p to avoid profiling fixed values.
  2)  Using __FILE__ instead of instruction pointers.
  3)  Using the preprocessor to stop all profiling of likely
       annotations from vsyscall_64.c.

Thanks to Andrew Morton, Arjan van de Ven, Theodore Tso and Ingo Molnar
for their feed back on this patch.

(*) Not ever unlikely is recorded, those that are used by vsyscalls
 (a few of them) had to have profiling disabled.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c     |    8 ++
 include/asm-generic/vmlinux.lds.h |   14 +++-
 include/linux/compiler.h          |   61 +++++++++++++-
 kernel/trace/Kconfig              |   16 ++++
 kernel/trace/Makefile             |    1 +
 kernel/trace/trace_unlikely.c     |  164 +++++++++++++++++++++++++++++++++++++
 6 files changed, 261 insertions(+), 3 deletions(-)
 create mode 100644 kernel/trace/trace_unlikely.c

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ebf2f12..1f2e7c6 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -17,6 +17,14 @@
  *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
  */
 
+/* Protect userspace from profiling */
+#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
+# undef likely
+# undef unlikely
+# define likely(x)		likely_notrace(x)
+# define unlikely(x)		unlikely_notrace(x)
+#endif
+
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 63709a5..2110312 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -45,6 +45,17 @@
 #define MCOUNT_REC()
 #endif
 
+#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
+#define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_likely_profile) = .;   \
+				*(_ftrace_likely)			      \
+				VMLINUX_SYMBOL(__stop_likely_profile) = .;    \
+				VMLINUX_SYMBOL(__start_unlikely_profile) = .; \
+				*(_ftrace_unlikely)			      \
+				VMLINUX_SYMBOL(__stop_unlikely_profile) = .;
+#else
+#define LIKELY_PROFILE()
+#endif
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
@@ -62,7 +73,8 @@
 	VMLINUX_SYMBOL(__stop___markers) = .;				\
 	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
 	*(__tracepoints)						\
-	VMLINUX_SYMBOL(__stop___tracepoints) = .;
+	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
+	LIKELY_PROFILE()
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 98115d9..935e30c 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -59,8 +59,65 @@ extern void __chk_io_ptr(const volatile void __iomem *);
  * specific implementations come from the above header files
  */
 
-#define likely(x)	__builtin_expect(!!(x), 1)
-#define unlikely(x)	__builtin_expect(!!(x), 0)
+#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
+struct ftrace_likely_data {
+	const char *func;
+	const char *file;
+	unsigned line;
+	unsigned long correct;
+	unsigned long incorrect;
+};
+void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect);
+
+#define likely_notrace(x)	__builtin_expect(!!(x), 1)
+#define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
+
+#define likely_check(x) ({						\
+			int ______r;					\
+			static struct ftrace_likely_data		\
+				__attribute__((__aligned__(4)))		\
+				__attribute__((section("_ftrace_likely"))) \
+				______f = {				\
+				.func = __func__,			\
+				.file = __FILE__,			\
+				.line = __LINE__,			\
+			};						\
+			______f.line = __LINE__;			\
+			______r = likely_notrace(x);			\
+			ftrace_likely_update(&______f, ______r, 1);	\
+			______r;					\
+		})
+#define unlikely_check(x) ({						\
+			int ______r;					\
+			static struct ftrace_likely_data		\
+				__attribute__((__aligned__(4)))		\
+				__attribute__((section("_ftrace_unlikely"))) \
+				______f = {				\
+				.func = __func__,			\
+				.file = __FILE__,			\
+				.line = __LINE__,			\
+			};						\
+			______f.line = __LINE__;			\
+			______r = unlikely_notrace(x);			\
+			ftrace_likely_update(&______f, ______r, 0);	\
+			______r;					\
+		})
+
+/*
+ * Using __builtin_constant_p(x) to ignore cases where the return
+ * value is always the same.  This idea is taken from a similar patch
+ * written by Daniel Walker.
+ */
+# ifndef likely
+#  define likely(x)	(__builtin_constant_p(x) ? !!(x) : likely_check(x))
+# endif
+# ifndef unlikely
+#  define unlikely(x)	(__builtin_constant_p(x) ? !!(x) : unlikely_check(x))
+# endif
+#else
+# define likely(x)	__builtin_expect(!!(x), 1)
+# define unlikely(x)	__builtin_expect(!!(x), 0)
+#endif
 
 /* Optimization barrier */
 #ifndef barrier
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d986216..a604f24 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -159,6 +159,22 @@ config BOOT_TRACER
 	    selected, because the self-tests are an initcall as well and that
 	    would invalidate the boot trace. )
 
+config TRACE_UNLIKELY_PROFILE
+	bool "Trace likely/unlikely profiler"
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer profiles all the the likely and unlikely macros
+	  in the kernel. It will display the results in:
+
+	  /debugfs/tracing/profile_likely
+	  /debugfs/tracing/profile_unlikely
+
+	  Note: this will add a significant overhead, only turn this
+	  on if you need to profile the system's use of these macros.
+
+	  Say N if unsure.
+
 config STACK_TRACER
 	bool "Trace max stack"
 	depends on HAVE_FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 3e1f361..98e70ee 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -25,5 +25,6 @@ obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_RET_TRACER) += trace_functions_return.o
+obj-$(CONFIG_TRACE_UNLIKELY_PROFILE) += trace_unlikely.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_unlikely.c b/kernel/trace/trace_unlikely.c
new file mode 100644
index 0000000..9493269
--- /dev/null
+++ b/kernel/trace/trace_unlikely.c
@@ -0,0 +1,164 @@
+/*
+ * unlikely profiler
+ *
+ * Copyright (C) 2008 Steven Rostedt <srostedt@redhat.com>
+ */
+#include <linux/kallsyms.h>
+#include <linux/seq_file.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/ftrace.h>
+#include <linux/hash.h>
+#include <linux/fs.h>
+#include <asm/local.h>
+#include "trace.h"
+
+void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect)
+{
+	/* FIXME: Make this atomic! */
+	if (val == expect)
+		f->correct++;
+	else
+		f->incorrect++;
+}
+EXPORT_SYMBOL(ftrace_likely_update);
+
+struct ftrace_pointer {
+	void		*start;
+	void		*stop;
+};
+
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct ftrace_pointer *f = m->private;
+	struct ftrace_likely_data *p = v;
+
+	(*pos)++;
+
+	if (v == (void *)1)
+		return f->start;
+
+	++p;
+
+	if ((void *)p >= (void *)f->stop)
+		return NULL;
+
+	return p;
+}
+
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
+	void *t = (void *)1;
+	loff_t l = 0;
+
+	for (; t && l < *pos; t = t_next(m, t, &l))
+		;
+
+	return t;
+}
+
+static void t_stop(struct seq_file *m, void *p)
+{
+}
+
+static int t_show(struct seq_file *m, void *v)
+{
+	struct ftrace_likely_data *p = v;
+	const char *f;
+	unsigned long percent;
+
+	if (v == (void *)1) {
+		seq_printf(m, " correct incorrect  %% "
+			      "       Function                "
+			      "  File              Line\n"
+			      " ------- ---------  - "
+			      "       --------                "
+			      "  ----              ----\n");
+		return 0;
+	}
+
+	/* Only print the file, not the path */
+	f = p->file + strlen(p->file);
+	while (f >= p->file && *f != '/')
+		f--;
+	f++;
+
+	if (p->correct) {
+		percent = p->incorrect * 100;
+		percent /= p->correct + p->incorrect;
+	} else
+		percent = p->incorrect ? 100 : 0;
+
+	seq_printf(m, "%8lu %8lu %3lu ", p->correct, p->incorrect, percent);
+	seq_printf(m, "%-30.30s %-20.20s %d\n", p->func, f, p->line);
+	return 0;
+}
+
+static struct seq_operations tracing_likely_seq_ops = {
+	.start		= t_start,
+	.next		= t_next,
+	.stop		= t_stop,
+	.show		= t_show,
+};
+
+static int tracing_likely_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open(file, &tracing_likely_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = (void *)inode->i_private;
+	}
+
+	return ret;
+}
+
+static struct file_operations tracing_likely_fops = {
+	.open		= tracing_likely_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+extern unsigned long __start_likely_profile[];
+extern unsigned long __stop_likely_profile[];
+extern unsigned long __start_unlikely_profile[];
+extern unsigned long __stop_unlikely_profile[];
+
+static struct ftrace_pointer ftrace_likely_pos = {
+	.start			= __start_likely_profile,
+	.stop			= __stop_likely_profile,
+};
+
+static struct ftrace_pointer ftrace_unlikely_pos = {
+	.start			= __start_unlikely_profile,
+	.stop			= __stop_unlikely_profile,
+};
+
+static __init int ftrace_unlikely_init(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("profile_likely", 0444, d_tracer,
+				    &ftrace_likely_pos,
+				    &tracing_likely_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'profile_likely' entry\n");
+
+	entry = debugfs_create_file("profile_unlikely", 0444, d_tracer,
+				    &ftrace_unlikely_pos,
+				    &tracing_likely_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs"
+			   " 'profile_unlikely' entry\n");
+
+	return 0;
+}
+
+device_initcall(ftrace_unlikely_init);
-- 
1.5.6.5

-- 
