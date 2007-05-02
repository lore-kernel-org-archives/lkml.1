Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXEBFmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXEBFmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992765AbXEBFmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:42:21 -0400
Received: from haxent.com ([65.99.219.155]:2165 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXEBFen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:43 -0400
Message-Id: <20070502053424.789588000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:39 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 04/22] pollfs: pollable signal
Content-Disposition: inline; filename=pollfs-signal.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieve multiple per-process signals through a file descriptor. The mask
of signals can be changed at any time. Also, the compat code can be kept
very simple.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/pollfs/Makefile |    2 
 fs/pollfs/signal.c |  144 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |    7 ++
 3 files changed, 153 insertions(+)

Index: linux-2.6/fs/pollfs/signal.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/signal.c
@@ -0,0 +1,144 @@
+/*
+ * sigtimedwait4, retrieve multiple signals with one call.
+ *
+ * Copyright (C) 2007 Davi E. M. Arnaut
+ *
+ * Licensed under the GNU GPL. See the file COPYING for details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/wait.h>
+#include <asm/uaccess.h>
+#include <linux/poll.h>
+#include <linux/pollfs_fs.h>
+#include <linux/signal.h>
+
+struct pfs_signal {
+	sigset_t set;
+	spinlock_t lock;
+	struct task_struct *task;
+	struct pfs_file file;
+};
+
+static void inline sigset_adjust(sigset_t *set)
+{
+	/* SIGKILL and SIGSTOP cannot be caught, blocked, or ignored */
+	sigdelsetmask(set, sigmask(SIGKILL) | sigmask(SIGSTOP));
+
+	/* Signals we don't want to dequeue */
+	signotset(set);
+}
+
+static ssize_t read(struct pfs_signal *evs, siginfo_t __user *infoup)
+{
+	int signo;
+	siginfo_t info;
+
+	signo = dequeue_signal_lock(evs->task, &evs->set, &info);
+	if (!signo)
+		return -EAGAIN;
+
+	if (copy_siginfo_to_user(infoup, &info))
+		return -EFAULT;
+
+	return 0;
+}
+
+static ssize_t write(struct pfs_signal *evs, const sigset_t __user *uset)
+{
+	sigset_t set;
+
+	if (copy_from_user(&set, uset, sizeof(sigset_t)))
+		return -EFAULT;
+
+	sigset_adjust(&set);
+
+	spin_lock_irq(&evs->lock);
+	sigemptyset(&evs->set);
+	sigorsets(&evs->set, &evs->set, &set);
+	spin_unlock_irq(&evs->lock);
+
+	return 0;
+}
+
+static int poll(struct pfs_signal *evs)
+{
+	int ret = 0;
+	sigset_t pending;
+	unsigned long flags;
+
+	rcu_read_lock();
+
+	if (!lock_task_sighand(evs->task, &flags))
+		goto out_unlock;
+
+	sigorsets(&pending, &evs->task->pending.signal,
+		  &evs->task->signal->shared_pending.signal);
+
+	unlock_task_sighand(evs->task, &flags);
+
+	spin_lock_irqsave(&evs->lock, flags);
+	signandsets(&pending, &pending, &evs->set);
+	spin_unlock_irqrestore(&evs->lock, flags);
+
+	if (!sigisemptyset(&pending))
+		ret = POLLIN;
+
+out_unlock:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int release(struct pfs_signal *evs)
+{
+	put_task_struct(evs->task);
+	kfree(evs);
+
+	return 0;
+}
+
+static const struct pfs_operations signal_ops = {
+	.read		= PFS_READ(read, struct pfs_signal, siginfo_t),
+	.write		= PFS_WRITE(write, struct pfs_signal, sigset_t),
+	.poll		= PFS_POLL(poll, struct pfs_signal),
+	.release	= PFS_RELEASE(release, struct pfs_signal),
+	.rsize		= sizeof(siginfo_t),
+	.wsize		= sizeof(sigset_t),
+};
+
+asmlinkage long sys_plsignal(const sigset_t __user *uset)
+{
+	long error;
+	struct pfs_signal *evs;
+
+	evs = kmalloc(sizeof(*evs), GFP_KERNEL);
+	if (!evs)
+		return -ENOMEM;
+
+	if (copy_from_user(&evs->set, uset, sizeof(sigset_t))) {
+		kfree(evs);
+		return -EFAULT;
+	}
+
+	spin_lock_init(&evs->lock);
+
+	evs->task = current;
+	get_task_struct(current);
+
+	sigset_adjust(&evs->set);
+
+	evs->file.data = evs;
+	evs->file.fops = &signal_ops;
+	evs->file.wait = &evs->task->sigwait;
+
+	error = pfs_open(&evs->file);
+	if (error < 0)
+		release(evs);
+
+	return error;
+}
Index: linux-2.6/fs/pollfs/Makefile
===================================================================
--- linux-2.6.orig/fs/pollfs/Makefile
+++ linux-2.6/fs/pollfs/Makefile
@@ -1,2 +1,4 @@
 obj-$(CONFIG_POLLFS) += pollfs.o
 pollfs-y := file.o
+
+pollfs-$(CONFIG_POLLFS_SIGNAL) += signal.o
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -469,6 +469,13 @@ config POLLFS
 	help
 	 Pollfs support
 
+config POLLFS_SIGNAL
+	bool "Enable pollfs signal" if EMBEDDED
+	default y
+	depends on POLLFS
+	help
+	 Pollable signal support
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y

--
