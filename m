Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYJ1ENB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYJ1ENB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYJ1EMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:12:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYJ1EMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:12:52 -0400
Date: Tue, 28 Oct 2008 00:12:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Mike Snitzer <snitzer@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH][RFC] trace: profile likely and unlikely annotations
In-Reply-To: <20081028001340.GB9797@mit.edu>
Message-ID: <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu>
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
  awk '{ if ((($1 + 1.0)/ ($2 + 1.0)) > 0.5) { print $0; }}' |head -15
      Hit      Missed         Function
      ---      ------         --------
      36278      44749    __switch_to+0x129/0x55d
      70064      10964    __switch_to+0xcd/0x55d
      70060      10964    __switch_to+0x63/0x55d
       2628          0    syscall_trace_leave+0x0/0x154
          1          0    native_smp_prepare_cpus+0x3e9/0x485
     287349      98809    place_entity+0xac/0x11c
     141308     236748    calc_delta_mine+0x8b/0x109
      55091          0    enqueue_task+0x0/0x9b
      71724      52117    pick_next_task_fair+0x0/0xc1
         11          5    yield_task_fair+0x0/0x13b
       1269          0    pre_schedule_rt+0x0/0x98
      46392       1265    pick_next_task_rt+0x0/0x12f
      51523          0    dequeue_task+0x57/0x114

# cat /debug/tracing/profile_likely | \
  awk '{ if ((($2 + 1.0)/ ($1 + 1.0)) > 0.5) { print $0; }}'
      Hit      Missed         Function
      ---      ------         --------
      43316      37700    schedule+0x6e7/0xdb2
      23032      12997    schedule+0xa9b/0xdb2
          0          7    __cancel_work_timer+0x4b/0x292
        885       1683    update_wall_time+0x27b/0x4fd
          0     369948    audit_syscall_exit+0x131/0x403
         19     370851    audit_free+0x0/0x27e
          0     368981    audit_syscall_entry+0x1a4/0x226
         19        900    audit_free+0xf0/0x27e
          0        973    audit_alloc+0xa6/0x13c
          0          6    move_masked_irq+0x2b/0x174
      12878     223023    page_evictable+0x9a/0x1f1
          9          7    flush_cpu_slab+0x0/0x143
     634634     324186    kmem_cache_free+0x79/0x139
       3142      61979    dentry_lru_del_init+0x0/0x89
        948       1166    load_elf_binary+0xa00/0x18ad
        102         82    disk_part_iter_next+0x0/0xf1
          0         11    tcp_mss_split_point+0x0/0xbd


As you can see by the above, there's a bit of work to do in rethinking
the use of some unlikelys and likelys. Note: the unlikely case had 60 hits
that were more than 50%. 

(*) Not ever unlikely is recorded, those that are used by vsyscalls
 (a few of them) had to be marked as unlikely_notrace().

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c     |    5 -
 include/asm-generic/vmlinux.lds.h |   14 +++
 include/linux/compiler.h          |   38 ++++++++
 include/linux/seqlock.h           |    3 
 kernel/trace/Kconfig              |   16 +++
 kernel/trace/Makefile             |    2 
 kernel/trace/trace_unlikely.c     |  163 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 237 insertions(+), 4 deletions(-)

Index: linux-tip.git/kernel/trace/Makefile
===================================================================
--- linux-tip.git.orig/kernel/trace/Makefile	2008-10-27 23:11:52.000000000 -0400
+++ linux-tip.git/kernel/trace/Makefile	2008-10-27 23:12:08.000000000 -0400
@@ -26,4 +26,6 @@ obj-$(CONFIG_FUNCTION_PROFILER) += trace
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 
+obj-$(CONFIG_TRACE_UNLIKELY_PROFILE) += trace_unlikely.o
+
 libftrace-y := ftrace.o
Index: linux-tip.git/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/vsyscall_64.c	2008-10-27 23:11:52.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/vsyscall_64.c	2008-10-27 23:12:44.000000000 -0400
@@ -124,7 +124,8 @@ static __always_inline void do_vgettimeo
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
 
 		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
+		if (unlikely_notrace(!__vsyscall_gtod_data.sysctl_enabled ||
+				     !vread)) {
 			gettimeofday(tv,NULL);
 			return;
 		}
@@ -165,7 +166,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 {
 	struct timeval tv;
 	time_t result;
-	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
+	if (unlikely_notrace(!__vsyscall_gtod_data.sysctl_enabled))
 		return time_syscall(t);
 
 	vgettimeofday(&tv, NULL);
Index: linux-tip.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-tip.git.orig/include/asm-generic/vmlinux.lds.h	2008-10-27 23:11:52.000000000 -0400
+++ linux-tip.git/include/asm-generic/vmlinux.lds.h	2008-10-27 23:12:08.000000000 -0400
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
--- linux-tip.git.orig/include/linux/compiler.h	2008-10-27 23:11:52.000000000 -0400
+++ linux-tip.git/include/linux/compiler.h	2008-10-28 00:00:50.000000000 -0400
@@ -59,8 +59,46 @@ extern void __chk_io_ptr(const volatile 
  * specific implementations come from the above header files
  */
 
+#ifdef CONFIG_TRACE_UNLIKELY_PROFILE
+struct ftrace_likely_data {
+	unsigned long ip;
+	unsigned long hit;
+	unsigned long missed;
+};
+void ftrace_likely_update(struct ftrace_likely_data *f, int val);
+
+#define likely_notrace(x)	__builtin_expect(!!(x), 1)
+#define unlikely_notrace(x)	__builtin_expect(!!(x), 0)
+
+/* Can't use _THIS_IP_ because it screws up header dependencies */
+#define __THIS_IP__  ({ __label__ __here; __here: (unsigned long)&&__here; })
+
+#define likely(x) ({							\
+			int ______r;					\
+			static struct ftrace_likely_data ______f	\
+				__attribute__((__aligned__(4)))		\
+				__attribute__((section("_ftrace_likely"))); \
+			if (unlikely_notrace(!______f.ip))		\
+				______f.ip = __THIS_IP__;		\
+			______r = likely_notrace(x);			\
+			ftrace_likely_update(&______f, ______r);	\
+			______r;					\
+		})
+#define unlikely(x) ({							\
+			int ______r;					\
+			static struct ftrace_likely_data ______f	\
+				__attribute__((__aligned__(4)))		\
+				__attribute__((section("_ftrace_unlikely"))); \
+			if (unlikely_notrace(!______f.ip))		\
+				______f.ip = __THIS_IP__;		\
+			______r = unlikely_notrace(x);			\
+			ftrace_likely_update(&______f, ______r);	\
+			______r;					\
+		})
+#else
 #define likely(x)	__builtin_expect(!!(x), 1)
 #define unlikely(x)	__builtin_expect(!!(x), 0)
+#endif
 
 /* Optimization barrier */
 #ifndef barrier
Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-27 23:11:52.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-27 23:12:08.000000000 -0400
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
+++ linux-tip.git/kernel/trace/trace_unlikely.c	2008-10-27 23:13:53.000000000 -0400
@@ -0,0 +1,163 @@
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
+void ftrace_likely_update(struct ftrace_likely_data *f, int val)
+{
+	/* FIXME: Make this atomic! */
+	if (val)
+		f->hit++;
+	else
+		f->missed++;
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
+static int trace_lookup_sym(struct seq_file *m, unsigned long addr)
+{
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(str, addr);
+
+	return seq_printf(m, "%s\n", str);
+#else
+	return seq_printf(m, "%p\n", (void *)addr);
+#endif
+}
+
+static int t_show(struct seq_file *m, void *v)
+{
+	struct ftrace_likely_data *p = v;
+
+	if (v == (void *)1) {
+		seq_printf(m, "      Hit      Missed         Function\n"
+			      "      ---      ------         --------\n");
+		return 0;
+	}
+
+	/* skip null records */
+	if (!p->ip)
+		return 0;
+
+	seq_printf(m, "   %8lu   %8lu    ", p->hit, p->missed);
+	trace_lookup_sym(m, p->ip);
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
Index: linux-tip.git/include/linux/seqlock.h
===================================================================
--- linux-tip.git.orig/include/linux/seqlock.h	2008-10-27 23:11:52.000000000 -0400
+++ linux-tip.git/include/linux/seqlock.h	2008-10-27 23:12:08.000000000 -0400
@@ -90,7 +90,8 @@ static __always_inline unsigned read_seq
 repeat:
 	ret = sl->sequence;
 	smp_rmb();
-	if (unlikely(ret & 1)) {
+	/* Used in vsyscall, need notrace version */
+	if (unlikely_notrace(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
