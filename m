Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYAKAg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYAKAg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYAKAgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:36:49 -0500
Received: from as2.cineca.com ([130.186.84.242]:46137 "EHLO as2.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAKAgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:36:48 -0500
X-Greylist: delayed 6681 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jan 2008 19:36:47 EST
Message-ID: <47869FFE.1050000@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [RFC][PATCH] per-task I/O throttling
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Jan 2008 23:45:19 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to limit the bandwidth of I/O-intensive processes, like backup
tools running in background, large files copy, checksums on huge files,
etc.

This kind of processes can noticeably impact the system responsiveness
for some time and playing with tasks' priority is not always an
acceptable solution.

This patch allows to specify a maximum I/O rate in sectors per second
for each single process via /proc/<PID>/io_throttle (default is zero,
that specify no limit).

Signed-off-by: Andrea Righi <a.righi@cineca.it>
---

diff -urpN linux-2.6.24-rc7/block/ll_rw_blk.c linux-2.6.24-rc7-task-io-throttle/block/ll_rw_blk.c
--- linux-2.6.24-rc7/block/ll_rw_blk.c	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-task-io-throttle/block/ll_rw_blk.c	2008-01-10 23:23:41.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
 #include <linux/scatterlist.h>
+#include <linux/jiffies.h>
 
 /*
  * for max sense size
@@ -3184,6 +3185,41 @@ static inline int bio_check_eod(struct b
 	return 0;
 }
 
+#ifdef CONFIG_TASK_IO_THROTTLE
+static inline void task_io_throttle(int nr_sectors)
+{
+	unsigned long delta;
+	long sleep;
+
+	if (!current->io_throttle) {
+		return;
+	}
+
+	if (!current->io_throttle_timestamp) {
+		current->io_throttle_timestamp = jiffies;
+	}
+	delta = jiffies_to_msecs((long)jiffies -
+			(long)(current->io_throttle_timestamp)) * 1000;
+
+	current->io_throttle_req += nr_sectors;
+
+	sleep = current->io_throttle_req -
+		current->io_throttle * max(delta, (unsigned long)1);
+	if (sleep > 0) {
+		schedule_timeout_uninterruptible(sleep);
+	}
+
+	if (delta) {
+		current->io_throttle_timestamp = jiffies;
+		current->io_throttle_req = 0;
+	}
+}
+#else
+static inline void task_io_throttle(int nr_sectors)
+{
+}
+#endif /* CONFIG_TASK_IO_THROTTLE */
+
 /**
  * generic_make_request: hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -3221,6 +3257,8 @@ static inline void __generic_make_reques
 	if (bio_check_eod(bio, nr_sectors))
 		goto end_io;
 
+	task_io_throttle(nr_sectors);
+
 	/*
 	 * Resolve the mapping until finished. (drivers are
 	 * still free to implement/resolve their own stacking
diff -urpN linux-2.6.24-rc7/fs/proc/base.c linux-2.6.24-rc7-task-io-throttle/fs/proc/base.c
--- linux-2.6.24-rc7/fs/proc/base.c	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-task-io-throttle/fs/proc/base.c	2008-01-10 23:24:43.000000000 +0100
@@ -864,6 +864,56 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
+#ifdef CONFIG_TASK_IO_THROTTLE
+static ssize_t io_throttle_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	unsigned long io_throttle;
+
+	if (!task)
+		return -ESRCH;
+	io_throttle = task->io_throttle;
+	put_task_struct(task);
+
+	len = snprintf(buffer, sizeof(buffer), "%lu\n", io_throttle);
+
+	return simple_read_from_buffer(buf, count, ppos, buffer, len);
+}
+
+static ssize_t io_throttle_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	unsigned long io_throttle;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	io_throttle = simple_strtoul(buffer, &end, 0);
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_path.dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	task->io_throttle = io_throttle;
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
+}
+
+static const struct file_operations proc_io_throttle_operations = {
+	.read		= io_throttle_read,
+	.write		= io_throttle_write,
+};
+#endif /* CONFIG_TASK_IO_THROTTLE */
+
 #ifdef CONFIG_MMU
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
@@ -2250,6 +2300,9 @@ static const struct pid_entry tgid_base_
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, pid_io_accounting),
 #endif
+#ifdef CONFIG_TASK_IO_THROTTLE
+	REG("io_throttle",    S_IRUGO|S_IWUSR, io_throttle),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
diff -urpN linux-2.6.24-rc7/include/linux/sched.h linux-2.6.24-rc7-task-io-throttle/include/linux/sched.h
--- linux-2.6.24-rc7/include/linux/sched.h	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-task-io-throttle/include/linux/sched.h	2008-01-10 23:23:41.000000000 +0100
@@ -1167,6 +1167,15 @@ struct task_struct {
 	atomic_t fs_excl;	/* holding fs exclusive resources */
 	struct rcu_head rcu;
 
+#ifdef CONFIG_TASK_IO_THROTTLE
+	/*
+	 * per-process I/O throttle
+	 */
+	unsigned long io_throttle;
+	unsigned long io_throttle_req;
+	unsigned long io_throttle_timestamp;
+#endif
+
 	/*
 	 * cache last used pipe for splice
 	 */
diff -urpN linux-2.6.24-rc7/init/Kconfig linux-2.6.24-rc7-task-io-throttle/init/Kconfig
--- linux-2.6.24-rc7/init/Kconfig	2008-01-06 22:45:38.000000000 +0100
+++ linux-2.6.24-rc7-task-io-throttle/init/Kconfig	2008-01-10 23:23:41.000000000 +0100
@@ -206,6 +206,14 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
+config TASK_IO_THROTTLE
+	bool "Enable per-task I/O throttling (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Allow to limit the maximum I/O rate for specific process(es).
+
+	  Say N if unsure.
+
 config USER_NS
 	bool "User Namespaces (EXPERIMENTAL)"
 	default n
