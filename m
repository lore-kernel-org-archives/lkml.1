Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbXF2Vuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbXF2Vuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbXF2Vtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:49:40 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2543 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbXF2Vth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:49:37 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 29 Jun 2007 14:48:52 -0700
Subject: [patch 3/6] sys_indirect RFC - sys_indirect core
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.28360.1183153736.3>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the core skeleton for the new sys_indirect() system call.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide



---
 include/linux/indirect.h |   32 +++++++++++++
 include/linux/syscalls.h |    5 ++
 kernel/Makefile          |    2 
 kernel/sys_indirect.c    |  109 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 147 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/include/linux/syscalls.h
===================================================================
--- linux-2.6.mod.orig/include/linux/syscalls.h	2007-06-29 12:12:41.000000000 -0700
+++ linux-2.6.mod/include/linux/syscalls.h	2007-06-29 12:12:51.000000000 -0700
@@ -65,6 +65,7 @@
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
+#include <linux/indirect.h>
 
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
@@ -608,6 +609,10 @@
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
 asmlinkage long sys_eventfd(unsigned int count);
+asmlinkage long sys_indirect(unsigned int nr,
+			     const struct indirect_ctx __user * __user *ctxs,
+			     unsigned int nctxs,
+			     const unsigned long __user *params);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.mod/kernel/Makefile
===================================================================
--- linux-2.6.mod.orig/kernel/Makefile	2007-06-29 12:12:41.000000000 -0700
+++ linux-2.6.mod/kernel/Makefile	2007-06-29 12:12:51.000000000 -0700
@@ -5,7 +5,7 @@
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
-	    signal.o sys.o kmod.o workqueue.o pid.o \
+	    signal.o sys.o sys_indirect.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o
Index: linux-2.6.mod/kernel/sys_indirect.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/kernel/sys_indirect.c	2007-06-29 12:57:56.000000000 -0700
@@ -0,0 +1,109 @@
+/*
+ *  kernel/sys_indirect.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/fs.h>
+#include <linux/resource.h>
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <linux/fsalloc.h>
+#include <linux/indirect.h>
+
+#include <asm/uaccess.h>
+#include <asm/unistd.h>
+
+struct indirect_procs {
+	int (*set)(struct fsa_context *, const struct indirect_ctx __user *,
+		   struct indirect_op **);
+	void (*unset)(struct indirect_op *);
+};
+
+static const struct indirect_procs inprocs[] =
+{
+	{ NULL, NULL },
+};
+
+/**
+ * indirect_set_context - Walks through the user-specified context-set operations
+ *                        and sets the new task context according to it
+ *
+ * @ator:   [in]  Pointer the the allocator to be used to allocate context
+ *                operation nodes
+ * @ctxs:   [in]  Pointer to context data to be set before the syscall
+ * @nctxs:  [in]  Number of valid contexts in @ictxs and @ctxs
+ * @first:  [out] Pointer to the head of the operation chain
+ *
+ * Returns zero in case of success, or a negative error code in case of error.
+ */
+int indirect_set_context(struct fsa_context *ator,
+			 const struct indirect_ctx __user * __user *ctxs,
+			 unsigned int nctxs, struct indirect_op **first)
+{
+	unsigned int i;
+	int error;
+	u32 ctx;
+	const struct indirect_ctx __user *pctx;
+	struct indirect_op *new;
+
+	*first = NULL;
+	for (i = 0; i < nctxs; i++) {
+		if (get_user(pctx, &ctxs[i]) || get_user(ctx, &pctx->ctx))
+			return -EFAULT;
+		if (unlikely(ctx >= ARRAY_SIZE(inprocs) || !inprocs[ctx].set))
+			return -EINVAL;
+		error = (*inprocs[ctx].set)(ator, pctx, &new);
+		if (unlikely(error))
+			return error;
+		new->next = *first;
+		*first = new;
+	}
+
+	return 0;
+}
+
+/**
+ * indirect_unset_context - Undo the chain of task context set operations
+ *                          done by a previous call to indirect_set_context()
+ *
+ * @curr:  [in] Pointer to the head of the operations chain
+ *
+ */
+void indirect_unset_context(struct indirect_op *curr)
+{
+	for (; curr; curr = curr->next)
+		if (likely(inprocs[curr->ctx].unset))
+			(*inprocs[curr->ctx].unset)(curr);
+}
+
+asmlinkage long sys_indirect(unsigned int nr,
+			     const struct indirect_ctx __user * __user *ctxs,
+			     unsigned int nctxs,
+			     const unsigned long __user *params)
+{
+	long res;
+	struct indirect_op *iops = NULL;
+	unsigned long kparams[6];
+	struct fsa_context ator;
+	char ator_cache[128];
+
+	if (!indirect_call_ok(nr))
+		return -EINVAL;
+	if (copy_from_user(kparams, params, 6 * sizeof(unsigned long)))
+		return -EFAULT;
+	fsa_init(&ator, ator_cache, sizeof(ator_cache));
+	res = indirect_set_context(&ator, ctxs, nctxs, &iops);
+	if (likely(res == 0)) {
+		res = call_syscall(nr, kparams);
+		indirect_unset_context(iops);
+	}
+	fsa_cleanup(&ator);
+
+	return res;
+}
+
Index: linux-2.6.mod/include/linux/indirect.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.mod/include/linux/indirect.h	2007-06-29 12:57:56.000000000 -0700
@@ -0,0 +1,32 @@
+/*
+ *  include/linux/indirect.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_INDIRECT_H
+#define _LINUX_INDIRECT_H
+
+struct indirect_ctx {
+	__u32 ctx;
+};
+
+#ifdef __KERNEL__
+
+#include <linux/fsalloc.h>
+
+struct indirect_op {
+	struct indirect_op *next;
+	unsigned int ctx;
+};
+
+int indirect_set_context(struct fsa_context *ator,
+			 const struct indirect_ctx __user * __user *ctxs,
+			 unsigned int nctxs, struct indirect_op **first);
+void indirect_unset_context(struct indirect_op *curr);
+
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_INDIRECT_H */
+

