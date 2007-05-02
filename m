Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbXEBFi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbXEBFi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXEBFi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:38:29 -0400
Received: from haxent.com ([65.99.219.155]:2176 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbXEBFep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:34:45 -0400
Message-Id: <20070502053428.274515000@haxent.com.br>
References: <20070502052235.914764000@haxent.com.br>
User-Agent: quilt/0.45-1
Date: Wed, 02 May 2007 02:22:54 -0300
From: Davi Arnaut <davi@haxent.com.br>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 19/22] pollfs: pollable aio
Content-Disposition: inline; filename=pollfs-aio.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Submit, retrieve, or poll aio requests for completion through a
file descriptor. User supplies a aio_context_t that is used to
fetch a reference to the kioctx. Once the file descriptor is
closed, the reference is decremented.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>

---
 fs/pollfs/Makefile |    1 
 fs/pollfs/aio.c    |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 init/Kconfig       |    7 +++
 3 files changed, 111 insertions(+)

Index: linux-2.6/fs/pollfs/Makefile
===================================================================
--- linux-2.6.orig/fs/pollfs/Makefile
+++ linux-2.6/fs/pollfs/Makefile
@@ -4,3 +4,4 @@ pollfs-y := file.o
 pollfs-$(CONFIG_POLLFS_SIGNAL) += signal.o
 pollfs-$(CONFIG_POLLFS_TIMER) += timer.o
 pollfs-$(CONFIG_POLLFS_FUTEX) += futex.o
+pollfs-$(CONFIG_POLLFS_AIO) += aio.o
Index: linux-2.6/fs/pollfs/aio.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/aio.c
@@ -0,0 +1,103 @@
+/*
+ * pollable aio
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
+#include <linux/aio.h>
+#include <linux/syscalls.h>
+
+struct pfs_aio {
+	struct kioctx *ioctx;
+	struct pfs_file file;
+};
+
+static ssize_t read(struct pfs_aio *evs, struct io_event __user *uioevt)
+{
+	int ret;
+
+	ret = sys_io_getevents(evs->ioctx->user_id, 0, 1, uioevt, NULL);
+
+	if (!ret)
+		ret = -EAGAIN;
+	else if (ret > 0)
+		ret = 0;
+
+	return ret;
+}
+
+static ssize_t write(struct pfs_aio *evs, const struct iocb __user *uiocb)
+{
+	struct iocb iocb;
+
+	if (copy_from_user(&iocb, uiocb, sizeof(iocb)))
+		return -EFAULT;
+
+	return io_submit_one(evs->ioctx, uiocb, &iocb);
+}
+
+static int poll(struct pfs_aio *evs)
+{
+	int ret;
+
+	ret = aio_ring_empty(evs->ioctx) ? 0 : POLLIN;
+
+	return ret;
+}
+
+static int release(struct pfs_aio *evs)
+{
+	put_ioctx(evs->ioctx);
+
+	kfree(evs);
+
+	return 0;
+}
+
+static const struct pfs_operations aio_ops = {
+	.read = PFS_READ(read, struct pfs_aio, struct io_event),
+	.write = PFS_WRITE(write, struct pfs_aio, struct iocb),
+	.poll = PFS_POLL(poll, struct pfs_aio),
+	.release = PFS_RELEASE(release, struct pfs_aio),
+	.rsize = sizeof(struct io_event),
+	.wsize = sizeof(struct iocb),
+};
+
+asmlinkage long sys_plaio(aio_context_t ctx)
+{
+	long error;
+	struct pfs_aio *evs;
+	struct kioctx *ioctx = lookup_ioctx(ctx);
+
+	if (!ioctx)
+		return -EINVAL;
+
+	evs = kzalloc(sizeof(*evs), GFP_KERNEL);
+	if (!evs) {
+		put_ioctx(ioctx);
+		return -ENOMEM;
+	}
+
+	evs->ioctx = ioctx;
+
+	evs->file.data = evs;
+	evs->file.fops = &aio_ops;
+	evs->file.wait = &ioctx->wait;
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
@@ -490,6 +490,13 @@ config POLLFS_FUTEX
 	help
 	 Pollable futex support
 
+config POLLFS_AIO
+	bool "Enable pollfs aio" if EMBEDDED
+	default y
+	depends on POLLFS
+	help
+	 Pollable aio support
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y

--
