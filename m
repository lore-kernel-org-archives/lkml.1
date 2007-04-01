Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXDAQGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXDAQGc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXDAQDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:03:50 -0400
Received: from haxent.com ([65.99.219.155]:2925 "EHLO haxent.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbXDAQDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:03:36 -0400
Message-Id: <20070401160312.760011000@haxent.com.br>
References: <20070401155810.277757000@haxent.com.br>
User-Agent: quilt/0.46-1
Date: Sun, 01 Apr 2007 12:58:22 -0300
From: davi@haxent.com.br
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 12/12] pollfs: pollable fsync
Content-Disposition: inline; filename=pollfs-sync-file.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pollable asynchronous fsync() using a global workqueue. Maybe a sync_file_range
in the future.

Signed-off-by: Davi E. M. Arnaut <davi@haxent.com.br>
---

Index: linux-2.6/fs/pollfs/Makefile
===================================================================
--- linux-2.6.orig/fs/pollfs/Makefile
+++ linux-2.6/fs/pollfs/Makefile
@@ -5,3 +5,4 @@ pollfs-$(CONFIG_POLLFS_SIGNAL) += signal
 pollfs-$(CONFIG_POLLFS_TIMER) += timer.o
 pollfs-$(CONFIG_POLLFS_FUTEX) += futex.o
 pollfs-$(CONFIG_POLLFS_AIO) += aio.o
+pollfs-$(CONFIG_POLLFS_SYNC) += sync.o
Index: linux-2.6/fs/pollfs/sync.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/pollfs/sync.c
@@ -0,0 +1,173 @@
+/*
+ * pollable fsync
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
+#include <linux/workqueue.h>
+#include <linux/file.h>
+
+struct sync_file {
+	int fd;
+	int datasync;
+	long result;
+};
+
+struct pfs_sync {
+	struct file *filp;
+	struct sync_file sync;
+	struct work_struct work;
+	struct mutex mutex;
+	enum {
+		WORK_REST,
+		WORK_BUSY,
+		WORK_DONE,
+	} status;
+	wait_queue_head_t wait;
+	struct pfs_file file;
+};
+
+static struct workqueue_struct *sync_wq;
+
+static void sync_file_work(struct work_struct *work)
+{
+	struct pfs_sync *evs = container_of(work, struct pfs_sync, work);
+
+	evs->sync.result = do_fsync(evs->filp, evs->sync.datasync);
+
+	fput(evs->filp);
+	evs->status = WORK_DONE;
+
+	wake_up_all(&evs->wait);
+}
+
+static ssize_t read(struct pfs_sync *evs, struct sync_file __user *usync)
+{
+	int ret = 0;
+	struct sync_file sync = {};
+
+	mutex_lock(&evs->mutex);
+	switch (evs->status) {
+	case WORK_REST:
+		ret = -EINVAL; break;
+	case WORK_BUSY:
+		ret = -EAGAIN; break;
+	case WORK_DONE:
+		evs->status = WORK_REST;
+		sync = evs->sync;
+		break;
+	}
+	mutex_unlock(&evs->mutex);
+
+	if (ret)
+		return ret;
+
+	if (copy_to_user(usync, &sync, sizeof(sync)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static ssize_t write(struct pfs_sync *evs, const struct sync_file __user *usync)
+{
+	int ret = 0;
+	struct file *filp;
+	struct sync_file sync;
+
+	if (copy_from_user(&sync, usync, sizeof(sync)))
+		return -EFAULT;
+
+	filp = fget(sync.fd);
+	if (!filp)
+		return -EINVAL;
+
+	mutex_lock(&evs->mutex);
+	if (evs->status != WORK_REST)
+		ret = -EAGAIN;
+	else {
+		evs->filp = filp;
+		evs->status = WORK_BUSY;
+		queue_async_work(sync_wq, &evs->work);
+	}
+	mutex_unlock(&evs->mutex);
+
+	return ret;
+}
+
+static int poll(struct pfs_sync *evs)
+{
+	int ret = 0;
+
+	if (evs->status == WORK_DONE)
+		ret = POLLIN;
+	else if (evs->status == WORK_REST)
+		ret = POLLOUT;
+
+	return ret;
+}
+
+static int release(struct pfs_sync *evs)
+{
+	wait_event(evs->wait, evs->status != WORK_BUSY);
+
+	kfree(evs);
+
+	return 0;
+}
+
+static const struct pfs_operations sync_ops = {
+	.read = PFS_READ(read, struct pfs_sync, struct sync_file),
+	.write = PFS_WRITE(write, struct pfs_sync, struct sync_file),
+	.poll = PFS_POLL(poll, struct pfs_sync),
+	.release = PFS_RELEASE(release, struct pfs_sync),
+	.rsize = sizeof(struct sync_file),
+	.wsize = sizeof(struct sync_file),
+};
+
+asmlinkage long sys_plsync(void)
+{
+	long error;
+	struct pfs_sync *evs;
+
+	if (!sync_wq)
+		return -ENOSYS;
+
+	evs = kzalloc(sizeof(*evs), GFP_KERNEL);
+	if (!evs)
+		return -ENOMEM;
+
+	evs->status = WORK_REST;
+	mutex_init(&evs->mutex);
+	init_waitqueue_head(&evs->wait);
+	INIT_WORK(&evs->work, sync_file_work);
+
+	evs->file.data = evs;
+	evs->file.fops = &sync_ops;
+	evs->file.wait = &evs->wait;
+
+	error = pfs_open(&evs->file);
+
+	if (error < 0)
+		release(evs);
+
+	return error;
+}
+
+static int __init init(void)
+{
+	sync_wq = create_workqueue("syncd");
+	WARN_ON(!sync_wq);
+	return 0;
+}
+
+__initcall(init);
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -497,6 +497,13 @@ config POLLFS_AIO
 	help
 	 Pollable aio support
 
+config POLLFS_SYNC
+	bool "Enable pollfs file sync" if EMBEDDED
+	default y
+	depends on POLLFS
+	help
+	 Pollable file sync support
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y

-- 
