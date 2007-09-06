Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbXIFUka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbXIFUka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXIFUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:40:13 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50915 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXIFUkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:40:10 -0400
Message-Id: <20070906200827.452767571@polymtl.ca>
References: <20070906200733.194442762@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 06 Sep 2007 16:07:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 6/6] Linux Kernel Markers - Port SPU to markers
Content-Disposition: inline; filename=linux-kernel-markers-port-spu-to-markers.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Sep 2007 20:40:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, any chance to get this into -mm ASAP so we can have it in
2.6.24?

Just in case anyone wonders what this is usefulfor I've ported my
hacking spu tracing code to it, and if markers get in I'd push a cleaned
up version of this in the tree of the benefit of everyone trying to
follow what's going on in the spufs code.  Similarly I'd like to port
the xfs tracing code over to it which is very helpful in trying to
debug filesystem issues.

Note that in this patch the actual logging code is rather nasty
hand-crafted code lifted from the tcp probe in tree which would benefit
of going away in favour of more general tracing code aswell.

Changelog:
- Porting to 2.6.23-rc4-mm1 gave a reject (a trace point location disappeared)
  from spufs_ps_nopfn() : spufs_ps_nopfn__sleep and spufs_ps_nopfn__wake.
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/powerpc/platforms/cell/spufs/Makefile   |    2 
 arch/powerpc/platforms/cell/spufs/file.c     |    3 
 arch/powerpc/platforms/cell/spufs/sched.c    |   29 ++-
 arch/powerpc/platforms/cell/spufs/spufs.h    |    5 
 arch/powerpc/platforms/cell/spufs/sputrace.c |  246 +++++++++++++++++++++++++++
 5 files changed, 279 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/Makefile	2007-09-04 11:49:31.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/Makefile	2007-09-04 14:53:32.000000000 -0400
@@ -4,6 +4,8 @@ obj-$(CONFIG_SPU_FS) += spufs.o
 spufs-y += inode.o file.o context.o syscalls.o coredump.o
 spufs-y += sched.o backing_ops.o hw_ops.o run.o gang.o
 
+obj-m += sputrace.o
+
 # Rules to build switch.o with the help of SPU tool chain
 SPU_CROSS	:= spu-
 SPU_CC		:= $(SPU_CROSS)gcc
Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/sched.c	2007-09-04 11:49:31.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sched.c	2007-09-04 14:53:32.000000000 -0400
@@ -39,6 +39,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/marker.h>
 
 #include <asm/io.h>
 #include <asm/mmu_context.h>
@@ -224,8 +225,8 @@ EXPORT_SYMBOL_GPL(spu_switch_event_unreg
  */
 static void spu_bind_context(struct spu *spu, struct spu_context *ctx)
 {
-	pr_debug("%s: pid=%d SPU=%d NODE=%d\n", __FUNCTION__, current->pid,
-		 spu->number, spu->node);
+	spu_context_trace(spu_bind_context__enter, ctx, spu);
+
 	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
 
 	if (ctx->flags & SPU_CREATE_NOSCHED)
@@ -412,8 +413,8 @@ static int has_affinity(struct spu_conte
  */
 static void spu_unbind_context(struct spu *spu, struct spu_context *ctx)
 {
-	pr_debug("%s: unbind pid=%d SPU=%d NODE=%d\n", __FUNCTION__,
-		 spu->pid, spu->number, spu->node);
+	spu_context_trace(spu_unbind_context__enter, ctx, spu);
+
 	spuctx_switch_state(ctx, SPU_UTIL_SYSTEM);
 
  	if (spu->ctx->flags & SPU_CREATE_NOSCHED)
@@ -514,6 +515,8 @@ static struct spu *spu_get_idle(struct s
 	struct spu *spu;
 	int node, n;
 
+	spu_context_nospu_trace(spu_get_idle__enter, ctx);
+
 	if (has_affinity(ctx)) {
 		node = ctx->gang->aff_ref_spu->node;
 
@@ -522,7 +525,7 @@ static struct spu *spu_get_idle(struct s
 		if (spu && spu->alloc_state == SPU_FREE)
 			goto found;
 		mutex_unlock(&cbe_spu_info[node].list_mutex);
-		return NULL;
+		goto not_found;
 	}
 
 	node = cpu_to_node(raw_smp_processor_id());
@@ -539,12 +542,14 @@ static struct spu *spu_get_idle(struct s
 		mutex_unlock(&cbe_spu_info[node].list_mutex);
 	}
 
+ not_found:
+	spu_context_nospu_trace(spu_get_idle__not_found, ctx);
 	return NULL;
 
  found:
 	spu->alloc_state = SPU_USED;
 	mutex_unlock(&cbe_spu_info[node].list_mutex);
-	pr_debug("Got SPU %d %d\n", spu->number, spu->node);
+	spu_context_trace(spu_get_idle__found, ctx, spu);
 	spu_init_channels(spu);
 	return spu;
 }
@@ -561,6 +566,8 @@ static struct spu *find_victim(struct sp
 	struct spu *spu;
 	int node, n;
 
+	spu_context_nospu_trace(spu_find_vitim__enter, ctx);
+
 	/*
 	 * Look for a possible preemption candidate on the local node first.
 	 * If there is no candidate look at the other nodes.  This isn't
@@ -717,6 +724,8 @@ static int __spu_deactivate(struct spu_c
 		if (new || force) {
 			int node = spu->node;
 
+			spu_context_trace(__spu_deactivate__unload, ctx, spu);
+
 			mutex_lock(&cbe_spu_info[node].list_mutex);
 			spu_unbind_context(spu, ctx);
 			spu->alloc_state = SPU_FREE;
@@ -744,6 +753,7 @@ static int __spu_deactivate(struct spu_c
  */
 void spu_deactivate(struct spu_context *ctx)
 {
+	spu_context_nospu_trace(spu_deactivate__enter, ctx);
 	__spu_deactivate(ctx, 1, MAX_PRIO);
 }
 
@@ -757,6 +767,7 @@ void spu_deactivate(struct spu_context *
  */
 void spu_yield(struct spu_context *ctx)
 {
+	spu_context_nospu_trace(spu_yield__enter, ctx);
 	if (!(ctx->flags & SPU_CREATE_NOSCHED)) {
 		mutex_lock(&ctx->state_mutex);
 		__spu_deactivate(ctx, 0, MAX_PRIO);
@@ -783,6 +794,8 @@ static noinline void spusched_tick(struc
 		struct spu *spu = ctx->spu;
 		struct spu_context *new;
 
+		spu_context_trace(spusched_tick__preempt, ctx, spu);
+
 		new = grab_runnable_context(ctx->prio + 1, spu->node);
 		if (new) {
 			spu_unbind_context(spu, ctx);
@@ -797,10 +810,14 @@ static noinline void spusched_tick(struc
 			 * gets put on the runqueue again ASAP.
 			 */
 			wake_up(&ctx->stop_wq);
+		} else {
+			spu_context_trace(spusched_tick__preempt_failed,
+						ctx, spu);
 		}
 		spu_set_timeslice(ctx);
 		mutex_unlock(&ctx->state_mutex);
 	} else {
+		spu_context_nospu_trace(spusched_tick__newslice, ctx);
 		ctx->time_slice++;
 	}
 }
Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/sputrace.c	2007-09-04 14:53:32.000000000 -0400
@@ -0,0 +1,246 @@
+/*
+ * Copyright (C) 2007 IBM Deutschland Entwicklung GmbH
+ *	Released under GPL v2.
+ *
+ * Partially based on net/ipv4/tcp_probe.c.
+ *
+ * Simple tracing facility for spu contexts.
+ */
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/marker.h>
+#include <linux/proc_fs.h>
+#include <linux/wait.h>
+#include <asm/atomic.h>
+#include <asm/uaccess.h>
+#include "spufs.h"
+
+struct spu_probe {
+	const char *name;
+	const char *format;
+	marker_probe_func *probe_func;
+};
+
+struct sputrace {
+	ktime_t tstamp;
+	struct spu_context *ctx;
+	const char *name;
+	int tid;
+	int number;
+};
+
+static int bufsize __read_mostly = 4096;
+
+
+static DEFINE_SPINLOCK(sputrace_lock);
+static DECLARE_WAIT_QUEUE_HEAD(sputrace_wait);
+static ktime_t sputrace_start;
+static unsigned long sputrace_head, sputrace_tail;
+static struct sputrace *sputrace_log;
+
+static int sputrace_used(void)
+{
+	return (sputrace_head - sputrace_tail) % bufsize;
+}
+
+static inline int sputrace_avail(void)
+{
+	return bufsize - sputrace_used();
+}
+
+static int sputrace_sprint(char *tbuf, int n)
+{
+        const struct sputrace *t = sputrace_log + sputrace_tail % bufsize;
+	struct timespec tv =
+		ktime_to_timespec(ktime_sub(t->tstamp, sputrace_start));
+
+	return snprintf(tbuf, n,
+		"[%lu.%09lu] %p: %s (tid = %d, spu = %d)\n",
+		(unsigned long) tv.tv_sec,
+		(unsigned long) tv.tv_nsec,
+		t->ctx,
+		t->name,
+		t->tid,
+		t->number);
+}
+
+static ssize_t sputrace_read(struct file *file, char __user *buf,
+		size_t len, loff_t *ppos)
+{
+	int error = 0, cnt = 0;
+
+	if (!buf || len < 0)
+		return -EINVAL;
+
+	while (cnt < len) {
+		char tbuf[128];
+		int width;
+
+		error = wait_event_interruptible(sputrace_wait,
+						 sputrace_used() > 0);
+		if (error)
+			break;
+
+		spin_lock(&sputrace_lock);
+		if (sputrace_head == sputrace_tail) {
+			spin_unlock(&sputrace_lock);
+			continue;
+		}
+
+		width = sputrace_sprint(tbuf, sizeof(tbuf));
+		if (width < len)
+			sputrace_tail = (sputrace_tail + 1) % bufsize;
+		spin_unlock(&sputrace_lock);
+
+		if (width >= len)
+			break;
+
+		error = copy_to_user(buf + cnt, tbuf, width);
+		if (error)
+			break;
+		cnt += width;
+	}
+
+	return cnt == 0 ? error : cnt;
+}
+
+static int tcpprobe_open(struct inode * inode, struct file * file)
+{
+	spin_lock(&sputrace_lock);
+	sputrace_head = sputrace_tail = 0;
+	sputrace_start = ktime_get();
+	spin_unlock(&sputrace_lock);
+
+	return 0;
+}
+
+static const struct file_operations sputrace_fops = {
+	.owner	= THIS_MODULE,
+	.open	= tcpprobe_open,
+	.read	= sputrace_read,
+};
+
+static void sputrace_log_item(const char *name, struct spu_context *ctx,
+		struct spu *spu)
+{
+	spin_lock(&sputrace_lock);
+	if (sputrace_avail() > 1) {
+		struct sputrace *t = sputrace_log + sputrace_head;
+
+		t->tstamp = ktime_get();
+		t->ctx = ctx;
+		t->name = name;
+		t->tid = ctx->tid;
+		t->number = spu ? spu->number : -1;
+
+		sputrace_head = (sputrace_head + 1) % bufsize;
+	} else {
+		printk(KERN_WARNING
+		       "sputrace: lost samples due to full buffer.\n");
+	}
+	spin_unlock(&sputrace_lock);
+
+	wake_up(&sputrace_wait);
+}
+
+static void spu_context_event(const struct __mark_marker *mdata,
+		void *private, const char *format, ...)
+{
+	struct spu_probe *p = mdata->pdata;
+	va_list ap;
+	struct spu_context *ctx;
+	struct spu *spu;
+
+	va_start(ap, format);
+	ctx = va_arg(ap, struct spu_context *);
+	spu = va_arg(ap, struct spu *);
+
+	sputrace_log_item(p->name, ctx, spu);
+	va_end(ap);
+}
+
+static void spu_context_nospu_event(const struct __mark_marker *mdata,
+		void *private, const char *format, ...)
+{
+	struct spu_probe *p = mdata->pdata;
+	va_list ap;
+	struct spu_context *ctx;
+
+	va_start(ap, format);
+	ctx = va_arg(ap, struct spu_context *);
+
+	sputrace_log_item(p->name, ctx, NULL);
+	va_end(ap);
+}
+
+struct spu_probe spu_probes[] = {
+	{ "spu_bind_context__enter", "%p %p", spu_context_event },
+	{ "spu_unbind_context__enter", "%p %p", spu_context_event },
+	{ "spu_get_idle__enter", "%p", spu_context_nospu_event },
+	{ "spu_get_idle__found", "%p %p", spu_context_event },
+	{ "spu_get_idle__not_found", "%p", spu_context_nospu_event },
+	{ "spu_find_victim__enter", "%p", spu_context_nospu_event },
+	{ "spusched_tick__preempt", "%p %p", spu_context_event },
+	{ "spusched_tick__preempt_failed", "%p %p", spu_context_event },
+	{ "spusched_tick__newslice", "%p", spu_context_nospu_event },
+	{ "spu_yield__enter", "%p", spu_context_nospu_event },
+	{ "spu_deactivate__enter", "%p", spu_context_nospu_event },
+	{ "__spu_deactivate__unload", "%p %p", spu_context_event },
+	{ "spufs_ps_nopfn__enter", "%p", spu_context_nospu_event },
+	{ "spufs_ps_nopfn__sleep", "%p", spu_context_nospu_event },
+	{ "spufs_ps_nopfn__wake", "%p", spu_context_nospu_event },
+};
+
+static int __init sputrace_init(void)
+{
+	struct proc_dir_entry *entry;
+	int error = -ENOMEM, i;
+
+	sputrace_log = kcalloc(sizeof(struct sputrace),
+				bufsize, GFP_KERNEL);
+	if (!sputrace_log)
+		goto out;
+
+	entry = create_proc_entry("sputrace", S_IRUSR, NULL);
+	if (!entry)
+		goto out_free_log;
+	entry->proc_fops = &sputrace_fops;
+
+	for (i = 0; i < ARRAY_SIZE(spu_probes); i++) {
+		struct spu_probe *p = &spu_probes[i];
+
+		error = marker_probe_register(p->name, p->format,
+					      p->probe_func, p);
+		if (error)
+			printk(KERN_INFO "Unable to register probe %s\n",
+					p->name);
+
+		error = marker_arm(p->name);
+		if (error)
+			printk(KERN_INFO "Unable to arm probe %s\n", p->name);
+	}
+
+	return 0;
+
+ out_free_log:
+ 	kfree(sputrace_log);
+ out:
+ 	return -ENOMEM;
+}
+
+static void __exit sputrace_exit(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(spu_probes); i++)
+		marker_probe_unregister(spu_probes[i].name);
+
+ 	remove_proc_entry("sputrace", NULL);
+	kfree(sputrace_log);
+}
+
+module_init(sputrace_init);
+module_exit(sputrace_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/file.c	2007-09-04 11:49:31.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/file.c	2007-09-04 14:53:32.000000000 -0400
@@ -29,6 +29,7 @@
 #include <linux/poll.h>
 #include <linux/ptrace.h>
 #include <linux/seq_file.h>
+#include <linux/marker.h>
 
 #include <asm/io.h>
 #include <asm/semaphore.h>
@@ -238,6 +239,8 @@ static unsigned long spufs_ps_nopfn(stru
 	unsigned long area, offset = address - vma->vm_start;
 	int ret;
 
+	spu_context_nospu_trace(spufs_ps_nopfn__enter, ctx);
+
 	offset += vma->vm_pgoff << PAGE_SHIFT;
 	if (offset >= ps_size)
 		return NOPFN_SIGBUS;
Index: linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2007-09-04 11:49:31.000000000 -0400
+++ linux-2.6-lttng/arch/powerpc/platforms/cell/spufs/spufs.h	2007-09-04 14:53:32.000000000 -0400
@@ -338,4 +338,9 @@ static inline void spuctx_switch_state(s
 	}
 }
 
+#define spu_context_trace(name, ctx, spu) \
+	trace_mark(name, "%p %p", ctx, spu);
+#define spu_context_nospu_trace(name, ctx) \
+	trace_mark(name, "%p", ctx);
+
 #endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
