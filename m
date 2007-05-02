Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbXEBFgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbXEBFgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992750AbXEBFfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:35:30 -0400
Received: from haxent.com ([65.99.219.155]:2196 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624AbXEBFe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:56 -0400
Message-Id: <20070502053427.123392000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:49 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 14/22] pollfs: pollable futex
Content-Disposition: inline; filename=pollfs-futex.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Asynchronously wait for FUTEX_WAKE operation on a futex if it still contains
a given value. There can be only one futex wait per file descriptor. However,
it can be rearmed (possibly at a different address) anytime.

The pollable futex approach is far superior (send and receive events from
userspace or kernel) to eventfd and fixes (supercedes) FUTEX_FD at the same time.

Building block for pollable semaphores and user-defined events.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/pollfs/Makefile |    1 
 fs/pollfs/futex.c  |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |    7 ++
 3 files changed, 162 insertions(+)

Index: linux-2.6/fs/pollfs/Makefile
===================================================================
--- linux-2.6.orig/fs/pollfs/Makefile
+++ linux-2.6/fs/pollfs/Makefile
@@ -3,3 +3,4 @@ pollfs-y := file.o
 
 pollfs-$(CONFIG_POLLFS_SIGNAL) += signal.o
 pollfs-$(CONFIG_POLLFS_TIMER) += timer.o
+pollfs-$(CONFIG_POLLFS_FUTEX) += futex.o
Index: linux-2.6/fs/pollfs/futex.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/futex.c
@@ -0,0 +1,154 @@
+/*
+ * pollable futex
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
+#include <linux/poll.h>
+#include <linux/pollfs_fs.h>
+#include <linux/futex.h>
+
+struct futex_event {
+	union {
+		void __user *addr;
+		u64 padding;
+	};
+	int val;
+};
+
+struct pfs_futex {
+	struct futex_q q;
+	struct futex_event fevt;
+	struct mutex mutex;
+	unsigned volatile queued;
+	struct pfs_file file;
+};
+
+static ssize_t read(struct pfs_futex *evs, struct futex_event __user *ufevt)
+{
+	int ret;
+	struct futex_event fevt;
+
+	mutex_lock(&evs->mutex);
+
+	fevt = evs->fevt;
+
+	ret = -EAGAIN;
+
+	if (!evs->queued)
+		ret = -EINVAL;
+	else if (list_empty(&evs->q.list))
+		ret = futex_wait_unqueue(&evs->q);
+
+	switch (ret) {
+	case 1:
+		ret = -EAGAIN;
+	case 0:
+		evs->queued = 0;
+	}
+
+	mutex_unlock(&evs->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(ufevt, &fevt, sizeof(fevt)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static ssize_t write(struct pfs_futex *evs,
+		     const struct futex_event __user *ufevt)
+{
+	int ret;
+	struct futex_event fevt;
+
+	if (copy_from_user(&fevt, ufevt, sizeof(fevt)))
+		return -EFAULT;
+
+	mutex_lock(&evs->mutex);
+
+	if (evs->queued)
+		futex_wait_unqueue(&evs->q);
+
+	ret = futex_wait_queue(&evs->q, fevt.addr, fevt.val);
+
+	if (ret)
+		evs->queued = 0;
+	else {
+		evs->queued = 1;
+		evs->fevt = fevt;
+	}
+
+	mutex_unlock(&evs->mutex);
+
+	return ret;
+}
+
+static int poll(struct pfs_futex *evs)
+{
+	int ret;
+
+	while (!mutex_trylock(&evs->mutex))
+		cpu_relax();
+
+	ret = evs->queued && list_empty(&evs->q.list) ? POLLIN : 0;
+
+	mutex_unlock(&evs->mutex);
+
+	return ret;
+}
+
+static int release(struct pfs_futex *evs)
+{
+	if (evs->queued)
+		futex_wait_unqueue(&evs->q);
+
+	mutex_destroy(&evs->mutex);
+
+	kfree(evs);
+
+	return 0;
+}
+
+static const struct pfs_operations futex_ops = {
+	.read = PFS_READ(read, struct pfs_futex, struct futex_event),
+	.write = PFS_WRITE(write, struct pfs_futex, struct futex_event),
+	.poll = PFS_POLL(poll, struct pfs_futex),
+	.release = PFS_RELEASE(release, struct pfs_futex),
+	.rsize = sizeof(struct futex_event),
+	.wsize = sizeof(struct futex_event),
+};
+
+asmlinkage long sys_plfutex(void)
+{
+	long error;
+	struct pfs_futex *evs;
+
+	evs = kzalloc(sizeof(*evs), GFP_KERNEL);
+	if (!evs)
+		return -ENOMEM;
+
+	mutex_init(&evs->mutex);
+	init_waitqueue_head(&evs->q.waiters);
+
+	evs->file.data = evs;
+	evs->file.fops = &futex_ops;
+	evs->file.wait = &evs->q.waiters;
+
+	error = pfs_open(&evs->file);
+
+	if (error < 0)
+		release(evs);
+
+	return error;
+}
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -483,6 +483,13 @@ config POLLFS_TIMER
 	help
 	 Pollable timer support
 
+config POLLFS_FUTEX
+	bool "Enable pollfs futex" if EMBEDDED
+	default y
+	depends on POLLFS && FUTEX
+	help
+	 Pollable futex support
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y

--
