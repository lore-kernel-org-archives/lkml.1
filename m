Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYJ2Qf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYJ2Qf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYJ2Qft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:35:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYJ2Qfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:35:48 -0400
Date: Wed, 29 Oct 2008 12:35:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Arjan van de Ven <arjan@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: [PATCH 1/2 v2][RFC] trace: profile likely and unlikely annotations
In-Reply-To: <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu>
 <20081028074816.04193e04@infradead.org> <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton recently suggested having an in-kernel way to profile
likely and unlikely macros. This patch achieves that goal.

When configured, every(*) likely and unlikely macro gets a counter attached
to it. When the condition is hit, the hit and misses of that condition
are recorded. These numbers can later be retrieved by:

  /debugfs/tracing/profile_likely    - All likely markers
  /debugfs/tracing/profile_unlikely  - All unlikely markers.

# cat /debug/tracing/profile_unlikely | \
   awk '{if (($1 || $2) && (($2+0.1)/($1+0.1) > 0.25)) { print $0; }}' | \
   head -20
 correct  incorrect       Function                      File              Line
 -------  ---------       --------                      ----              ----
    46894    38216    __switch_to                    process_64.c         624
    11951    73138    __switch_to                    process_64.c         594
    11951    73097    __switch_to                    process_64.c         590
   117873    35049    need_resched                   sched.h              2103
     1345      711    syscall_get_error              syscall.h            51
        0     2510    syscall_trace_leave            ptrace.c             1568
        0        1    native_smp_prepare_cpus        smpboot.c            1231
    91635   276125    calc_delta_fair                sched_fair.c         411
   219028   113449    calc_delta_mine                sched.c              1279
        0    58048    sched_info_queued              sched_stats.h        222
    55449    71591    pick_next_task_fair            sched_fair.c         1394
       10        5    yield_task_fair                sched_fair.c         983
     7117     2553    rt_policy                      sched.c              144
        0     1220    pre_schedule_rt                sched_rt.c           1260
     1216    52402    pick_next_task_rt              sched_rt.c           884
        0    48009    sched_info_dequeued            sched_stats.h        177
        0       14    sched_move_task                sched.c              8707
        0       14    sched_move_task                sched.c              8697


# cat /debug/tracing/profile_likely | \
  awk '{if (($1 || $2) && (($2+0.1)/($1+0.1) > 0.25)) { print $0; }}'
 correct  incorrect       Function                      File              Line
 -------  ---------       --------                      ----              ----
    42987    40240    pick_next_task                 sched.c              4407
    21419    18103    switch_mm                      mmu_context_64.h     18
        0        7    __cancel_work_timer            workqueue.c          560
      861     3960    clocksource_adjust             timekeeping.c        456
      390     1913    clocksource_adjust             timekeeping.c        450
        0   363683    audit_syscall_exit             auditsc.c            1570
       30   364573    audit_get_context              auditsc.c            732
        0   362744    audit_syscall_entry            auditsc.c            1541
       30      879    audit_free                     auditsc.c            1446
        0      952    audit_alloc                    auditsc.c            862
     2606      952    audit_alloc                    auditsc.c            858
        0        6    move_masked_irq                migration.c          20
     4465     2091    __grab_cache_page              filemap.c            2212
     9495     2787    iov_iter_advance               filemap.c            1884
     3121      899    __set_page_dirty               page-writeback.c     1134
    12874   221371    mapping_unevictable            pagemap.h            50
        4       10    __flush_cpu_slab               slub.c               1466
   635239   320760    slab_free                      slub.c               1731
     3105    61055    dentry_lru_del_init            dcache.c             153
      942     1156    load_elf_binary                binfmt_elf.c         904
      102       82    disk_put_part                  genhd.h              206
        0        1    tcp_mss_split_point            tcp_output.c         1126



As you can see by the above, there's a bit of work to do in rethinking
the use of some unlikelys and likelys. Note: the unlikely case had 76 hits
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
 arch/x86/kernel/vsyscall_64.c     |    8 +
 include/asm-generic/vmlinux.lds.h |   14 +++
 include/linux/compiler.h          |   61 ++++++++++++++
 kernel/trace/Kconfig              |   16 +++
 kernel/trace/Makefile             |    2 
 kernel/trace/trace_unlikely.c     |  157 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 255 insertions(+), 3 deletions(-)

Index: linux-tip.git/kernel/trace/Makefile
===================================================================
--- linux-tip.git.orig/kernel/trace/Makefile	2008-10-29 11:30:05.000000000 -0400
+++ linux-tip.git/kernel/trace/Makefile	2008-10-29 12:32:40.000000000 -0400
@@ -25,4 +25,6 @@ obj-$(CONFIG_STACK_TRACER) += trace_stac
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 
+obj-$(CONFIG_TRACE_UNLIKELY_PROFILE) += trace_unlikely.o
+
 libftrace-y := ftrace.o
Index: linux-tip.git/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/vsyscall_64.c	2008-10-29 11:30:05.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/vsyscall_64.c	2008-10-29 11:30:12.000000000 -0400
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
Index: linux-tip.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-tip.git.orig/include/asm-generic/vmlinux.lds.h	2008-10-29 11:30:06.000000000 -0400
+++ linux-tip.git/include/asm-generic/vmlinux.lds.h	2008-10-29 11:30:12.000000000 -0400
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
Index: linux-tip.git/include/linux/compiler.h
===================================================================
--- linux-tip.git.orig/include/linux/compiler.h	2008-10-29 11:30:06.000000000 -0400
+++ linux-tip.git/include/linux/compiler.h	2008-10-29 11:32:05.000000000 -0400
@@ -59,8 +59,65 @@ extern void __chk_io_ptr(const volatile 
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
Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-29 11:30:10.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-29 12:32:40.000000000 -0400
@@ -138,6 +138,22 @@ config BOOT_TRACER
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
Index: linux-tip.git/kernel/trace/trace_unlikely.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-tip.git/kernel/trace/trace_unlikely.c	2008-10-29 12:32:40.000000000 -0400
@@ -0,0 +1,157 @@
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
+
+	if (v == (void *)1) {
+		seq_printf(m, " correct  incorrect"
+			      "       Function                 "
+			      "     File              Line\n"
+			      " -------  ---------"
+			      "       --------                 "
+			      "     ----              ----\n");
+		return 0;
+	}
+
+	/* Only print the file, not the path */
+	f = p->file + strlen(p->file);
+	while (f >= p->file && *f != '/')
+		f--;
+	f++;
+
+	seq_printf(m, " %8lu %8lu    ", p->correct, p->incorrect);
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


