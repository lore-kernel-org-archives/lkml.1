Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXH3RNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXH3RNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbXH3RNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:13:08 -0400
Received: from verein.lst.de ([213.95.11.210]:56137 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbXH3RNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:13:06 -0400
Date: Thu, 30 Aug 2007 19:12:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [patch 0/4] Linux Kernel Markers
Message-ID: <20070830171240.GA20240@lst.de>
References: <20070827160540.007809201@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827160540.007809201@polymtl.ca>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 12:05:40PM -0400, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> Here are the Linux Kernel Markers for 2.6.23-rc3-mm1. It depends on the
> "immediate values" and on the "sorted module list" patches.

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


Index: linux-2.6/arch/powerpc/platforms/cell/spufs/Makefile
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/Makefile	2007-08-30 18:46:07.000000000 +0200
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/Makefile	2007-08-30 18:46:40.000000000 +0200
@@ -4,6 +4,8 @@ obj-$(CONFIG_SPU_FS) += spufs.o
 spufs-y += inode.o file.o context.o syscalls.o coredump.o
 spufs-y += sched.o backing_ops.o hw_ops.o run.o gang.o
 
+obj-m += sputrace.o
+
 # Rules to build switch.o with the help of SPU tool chain
 SPU_CROSS	:= spu-
 SPU_CC		:= $(SPU_CROSS)gcc
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/sched.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/sched.c	2007-08-30 18:46:38.000000000 +0200
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/sched.c	2007-08-30 18:46:40.000000000 +0200
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
@@ -718,6 +725,8 @@ static int __spu_deactivate(struct spu_c
 		if (new || force) {
 			int node = spu->node;
 
+			spu_context_trace(__spu_deactivate__unload, ctx, spu);
+
 			mutex_lock(&cbe_spu_info[node].list_mutex);
 			spu_unbind_context(spu, ctx);
 			spu->alloc_state = SPU_FREE;
@@ -745,6 +754,7 @@ static int __spu_deactivate(struct spu_c
  */
 void spu_deactivate(struct spu_context *ctx)
 {
+	spu_context_nospu_trace(spu_deactivate__enter, ctx);
 	__spu_deactivate(ctx, 1, MAX_PRIO);
 }
 
@@ -758,6 +768,7 @@ void spu_deactivate(struct spu_context *
  */
 void spu_yield(struct spu_context *ctx)
 {
+	spu_context_nospu_trace(spu_yield__enter, ctx);
 	if (!(ctx->flags & SPU_CREATE_NOSCHED)) {
 		mutex_lock(&ctx->state_mutex);
 		__spu_deactivate(ctx, 0, MAX_PRIO);
@@ -784,6 +795,8 @@ static noinline void spusched_tick(struc
 		struct spu *spu = ctx->spu;
 		struct spu_context *new;
 
+		spu_context_trace(spusched_tick__preempt, ctx, spu);
+
 		new = grab_runnable_context(ctx->prio + 1, spu->node);
 		if (new) {
 			spu_unbind_context(spu, ctx);
@@ -798,10 +811,14 @@ static noinline void spusched_tick(struc
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
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/sputrace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/sputrace.c	2007-08-30 19:08:00.000000000 +0200
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
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c	2007-08-30 18:46:07.000000000 +0200
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/file.c	2007-08-30 18:46:40.000000000 +0200
@@ -29,6 +29,7 @@
 #include <linux/poll.h>
 #include <linux/ptrace.h>
 #include <linux/seq_file.h>
+#include <linux/marker.h>
 
 #include <asm/io.h>
 #include <asm/semaphore.h>
@@ -237,6 +238,8 @@ static unsigned long spufs_ps_nopfn(stru
 	struct spu_context *ctx = vma->vm_file->private_data;
 	unsigned long area, offset = address - vma->vm_start;
 
+	spu_context_nospu_trace(spufs_ps_nopfn__enter, ctx);
+
 	offset += vma->vm_pgoff << PAGE_SHIFT;
 	if (offset >= ps_size)
 		return NOPFN_SIGBUS;
@@ -252,7 +255,9 @@ static unsigned long spufs_ps_nopfn(stru
 	spu_acquire(ctx);
 	if (ctx->state == SPU_STATE_SAVED) {
 		up_read(&current->mm->mmap_sem);
+		spu_context_nospu_trace(spufs_ps_nopfn__sleep, ctx);
 		spufs_wait(ctx->run_wq, ctx->state == SPU_STATE_RUNNABLE);
+		spu_context_nospu_trace(spufs_ps_nopfn__wake, ctx);
 		down_read(&current->mm->mmap_sem);
 		goto out;
 	}
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/spufs.h
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/spufs.h	2007-08-30 18:46:07.000000000 +0200
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/spufs.h	2007-08-30 19:08:00.000000000 +0200
@@ -339,4 +339,9 @@ static inline void spuctx_switch_state(s
 	}
 }
 
+#define spu_context_trace(name, ctx, spu) \
+	trace_mark(name, "%p %p", ctx, spu);
+#define spu_context_nospu_trace(name, ctx) \
+	trace_mark(name, "%p", ctx);
+
 #endif
