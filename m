Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYJZAzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYJZAzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYJZAzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:55:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYJZAzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:55:09 -0400
Date: Sat, 25 Oct 2008 20:55:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2][RFC] ftrace: function oprofiler
In-Reply-To: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810252049020.7650@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Still not ready for inclussion. (well, not tested enough)

  Changes since v1:

   I took a more casual look over the code and realized how bad
   I can write when I'm half asleep. I fixed several nasty
   (and stupid) race conditions.  I still did not spend that
   much time on this code, but it should be much safer.

   One of the changes was to turn the counter into an atomic
   int. This means that we can overflow after a function was hit
   over 4 billion times. I added a check for this and the hash
   will add a '!' if the overflow happens. The final version of
   this code will probably use atomic_long, but that is still
   only 32bits on a i386.

   Also fixed the cut and paste error that Frederic pointed out.
]


This is a function profiler to count the number of times a function is hit.
It creates two files:

  /debugfs/tracing/ftrace_profile_enable
  /debugfs/tracing/ftrace_profile

For example, to run this I did this as soon as I was able to log in.

# echo 1 > /debug/tracing/ftrace_profile_enable

 [ waited a while for the rest of the boot process to run. ]

# echo 0 > /debug/tracing/ftrace_profile_enable

And then I was able to get a list of counts functions were hit.

# cat /debug/tracing/ftrace_profile | head
entries: 2274
overruns: 0
  COUNT       FUNCTION
     7628  : dnotify_parent+0xd/0x78
    10101  : hrtimer_get_next_event+0x11/0xc7
    17937  : inotify_dentry_parent_queue_event+0x11/0x94
    17952  : inotify_inode_queue_event+0x11/0xe1
    10103  : rcu_needs_cpu+0x4/0x53
        1  : printk_needs_cpu+0x4/0x27
     7314  : printk_needs_cpu+0x4/0x27


I preallocate 5000 entries (later this needs to be configurable).
If we hit more than 5000 functions, they are counted in the overruns.

I'm also able to use sort to get the top 20 hits:

# cat /debug/tracing/ftrace_profile | sort -brn | head -20
   280075  : __rcu_read_unlock+0xb/0xa2
   280065  : __rcu_read_lock+0x11/0xb3
   262811  : dput+0x7/0x162
   138868  : path_put+0x9/0x35
   117843  : __phys_addr+0x4/0x39
   116320  : current_kernel_time+0x8/0x34
   111272  : kfree+0x11/0xda
   101832  : unroll_tree_refs+0x11/0xb4
   101769  : audit_syscall_exit+0x11/0x312
   101702  : audit_syscall_entry+0x11/0x181
    90910  : set_normalized_timespec+0x4/0x38
    88359  : getnstimeofday+0x7/0x9e
    88309  : ktime_get_ts+0x7/0x53
    85135  : kmem_cache_free+0x11/0xb9
    83917  : ktime_get+0x8/0x47
    51756  : fget+0x7/0x83
    48623  : mntput_no_expire+0x11/0x140
    46224  : vm_normal_page+0x4/0x2c
    41200  : put_page+0xd/0xf5
    39938  : sys_fcntl+0x11/0x344


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig          |   11 +
 kernel/trace/Makefile         |    1 
 kernel/trace/trace_oprofile.c |  361 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 373 insertions(+)

Index: linux-tip.git/kernel/trace/trace_oprofile.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-tip.git/kernel/trace/trace_oprofile.c	2008-10-25 20:48:03.000000000 -0400
@@ -0,0 +1,361 @@
+/*
+ * Function profiler
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
+#define FTRACE_PROFILE_HASHBITS	10
+#define FTRACE_PROFILE_HASHSIZE	(1<<FTRACE_PROFILE_HASHBITS)
+
+static DEFINE_PER_CPU(local_t, trace_active);
+static int ftrace_profile_enabled;
+
+struct ftrace_node {
+	struct hlist_node node;
+	unsigned long	  ip;
+	atomic_t	  count;
+	int		  overflow;
+};
+
+static struct hlist_head function_hash[FTRACE_PROFILE_HASHSIZE];
+
+/* TODO: make user configurable */
+static int ftrace_hash_size = 5000;
+static int ftrace_hash_occupied;
+static int ftrace_hash_overrun;
+
+static struct ftrace_node *ftrace_node_list;
+static struct ftrace_node *ftrace_free_node;
+
+static raw_spinlock_t ftrace_profile_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+static int
+ftrace_profile_alloc_hash_list(void)
+{
+	/* FIXME: size may be too much for kmalloc */
+	ftrace_node_list = kzalloc(sizeof(struct ftrace_node) *
+				   ftrace_hash_size, GFP_KERNEL);
+	if (!ftrace_node_list)
+		return -ENOMEM;
+
+	ftrace_free_node = ftrace_node_list;
+
+	return 0;
+}
+
+static void
+ftrace_profile_init_hash(void)
+{
+	ftrace_free_node = ftrace_node_list;
+	memset(ftrace_node_list, 0, sizeof(*ftrace_node_list) *
+	       ftrace_hash_size);
+	memset(function_hash, 0, sizeof(function_hash));
+}
+
+static void
+ftrace_profile_free_hash_list(void)
+{
+	kfree(ftrace_node_list);
+
+	ftrace_node_list = ftrace_free_node = NULL;
+}
+
+static struct ftrace_node *
+ftrace_profile_alloc_node(void)
+{
+	if (ftrace_hash_occupied >= ftrace_hash_size)
+		return NULL;
+
+	ftrace_hash_occupied++;
+
+	return ftrace_free_node++;
+}
+
+static struct ftrace_node *
+ftrace_ip_in_hash(unsigned long ip, unsigned long key)
+{
+	struct ftrace_node *p;
+	struct hlist_node *t;
+
+	hlist_for_each_entry_rcu(p, t, &function_hash[key], node) {
+		if (p->ip == ip)
+			return p;
+	}
+
+	return NULL;
+}
+
+static inline void
+ftrace_add_hash(struct ftrace_node *node, unsigned long key)
+{
+	hlist_add_head_rcu(&node->node, &function_hash[key]);
+}
+
+static void
+ftrace_profile_trace_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ftrace_node *p;
+	int cpu, resched;
+	unsigned long key;
+	unsigned long before, after;
+
+	if (unlikely(!ftrace_enabled || !ftrace_profile_enabled))
+		return;
+
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	if (local_inc_return(&per_cpu(trace_active, cpu)) != 1)
+		goto out;
+
+	key = hash_long(ip, FTRACE_PROFILE_HASHBITS);
+	p = ftrace_ip_in_hash(ip, key);
+
+	if (!p) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		__raw_spin_lock(&ftrace_profile_lock);
+
+		/* Make sure it was not added on another CPU */
+		p = ftrace_ip_in_hash(ip, key);
+		if (p)
+			goto unlock;
+
+		p = ftrace_profile_alloc_node();
+		if (!p) {
+			ftrace_hash_overrun++;
+			__raw_spin_unlock(&ftrace_profile_lock);
+			local_irq_restore(flags);
+			goto out;
+		}
+		p->ip = ip;
+		ftrace_add_hash(p, key);
+
+	unlock:
+		__raw_spin_unlock(&ftrace_profile_lock);
+		local_irq_restore(flags);
+	}
+
+	if (p->overflow)
+		goto out;
+
+	before = atomic_read(&p->count);
+	after = atomic_inc_return(&p->count);
+	if (before > after)
+		p->overflow = 1;
+
+ out:
+	local_dec(&per_cpu(trace_active, cpu));
+	/* prevent recursion in schedule */
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
+}
+
+static struct ftrace_ops trace_ops __read_mostly =
+{
+	.func = ftrace_profile_trace_call,
+};
+
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	long i = (long)m->private;
+
+	(*pos)++;
+
+	i++;
+
+	if (i >= ftrace_hash_occupied)
+		return NULL;
+
+	m->private = (void *)i;
+
+	return &m->private;
+}
+
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
+	void *t = &m->private;
+	loff_t l = 0;
+
+	local_irq_disable();
+
+	for (; t && l < *pos; t = t_next(m, t, &l))
+		;
+
+	return t;
+}
+
+static void t_stop(struct seq_file *m, void *p)
+{
+	local_irq_enable();
+}
+
+static int trace_lookup_hash(struct seq_file *m, long i)
+{
+	unsigned long addr = ftrace_node_list[i].ip;
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(str, addr);
+
+	return seq_printf(m, "%s\n", str);
+#else
+	return seq_printf(m, "%p\n", (void*)addr);
+#endif
+}
+
+static int t_show(struct seq_file *m, void *v)
+{
+	long i = *(long *)v;
+
+	if (i < 0) {
+		seq_printf(m, "entries: %d\n", ftrace_hash_occupied);
+		seq_printf(m, "overruns: %d\n", ftrace_hash_overrun);
+
+		seq_printf(m, "  COUNT       FUNCTION\n");
+		return 0;
+	}
+
+	if (i >= ftrace_hash_occupied)
+		return 0;
+
+	seq_printf(m, " %8u%c : ",
+		   atomic_read(&ftrace_node_list[i].count),
+		   ftrace_node_list[i].overflow ? '!' : ' ');
+	trace_lookup_hash(m, i);
+
+	return 0;
+}
+
+static struct seq_operations ftrace_profile_seq_ops = {
+	.start		= t_start,
+	.next		= t_next,
+	.stop		= t_stop,
+	.show		= t_show,
+};
+
+static int ftrace_profile_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = seq_open(file, &ftrace_profile_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = (void *)-1;
+	}
+
+	return ret;
+}
+
+static struct file_operations ftrace_profile_fops = {
+	.open		= ftrace_profile_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
+static ssize_t
+ftrace_profile_enable_read(struct file *filp, char __user *ubuf,
+			   size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+
+	r = sprintf(buf, "%d\n", ftrace_profile_enabled);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+ftrace_profile_enable_write(struct file *filp, const char __user *ubuf,
+			    size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	long val;
+	int ret;
+
+	if (!ftrace_node_list)
+		return -ENODEV;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	val = !!val;
+
+	if (val == ftrace_profile_enabled)
+		goto out;
+
+	if (val) {
+		/* start it up */
+		ftrace_profile_init_hash();
+		register_ftrace_function(&trace_ops);
+		ftrace_profile_enabled = 1;
+	} else {
+		ftrace_profile_enabled = 0;
+		unregister_ftrace_function(&trace_ops);
+	}
+
+ out:
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static struct file_operations ftrace_profile_enable_fops = {
+	.open		= tracing_open_generic,
+	.read		= ftrace_profile_enable_read,
+	.write		= ftrace_profile_enable_write,
+};
+
+
+static __init int ftrace_profile_init(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+	int ret;
+
+	ret = ftrace_profile_alloc_hash_list();
+	if (ret)
+		return ret;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("ftrace_profile_enable", 0644, d_tracer,
+				    NULL, &ftrace_profile_enable_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'ftrace_profile_enable' entry\n");
+
+	entry = debugfs_create_file("ftrace_profile", 0444, d_tracer,
+				    NULL, &ftrace_profile_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'ftrace_profile' entry\n");
+
+
+	return 0;
+}
+
+device_initcall(ftrace_profile_init);
Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-10-23 12:55:37.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-10-25 11:50:18.000000000 -0400
@@ -156,6 +156,17 @@ config STACK_TRACER
 
 	  Say N if unsure.
 
+config FUNCTION_PROFILER
+	bool "Trace function profiler"
+	depends on HAVE_FUNCTION_TRACER
+	depends on DEBUG_KERNEL
+	select FUNCTION_TRACER
+	help
+	  This special tracer that makes a histogram of all the functions
+	  that it encounters.
+
+	  Say N if unsure.
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
Index: linux-tip.git/kernel/trace/Makefile
===================================================================
--- linux-tip.git.orig/kernel/trace/Makefile	2008-10-23 12:55:37.000000000 -0400
+++ linux-tip.git/kernel/trace/Makefile	2008-10-25 00:58:07.000000000 -0400
@@ -22,6 +22,7 @@ obj-$(CONFIG_PREEMPT_TRACER) += trace_ir
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
 obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
+obj-$(CONFIG_FUNCTION_PROFILER) += trace_oprofile.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 


