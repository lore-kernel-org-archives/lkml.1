Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbYARRnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbYARRnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbYARRm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:42:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846AbYARRm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:42:57 -0500
Date: Fri, 18 Jan 2008 09:42:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/3] LatencyTOP instrumentations part 2
Message-ID: <20080118094216.1bf78ff3@laptopd505.fenrus.org>
In-Reply-To: <4790E3A6.7060807@linux.intel.com>
References: <4790E3A6.7060807@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more high level annotations for LatencyTOP;
split into a separate patch since they're at a higher level
than the first part (and thus hide some lower level details
potentially, but could also obsolete several other low level
instrumentations)
---
 fs/read_write.c   |    7 ++++++-
 fs/readdir.c      |    4 +++-
 lib/kernel_lock.c |    3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc7/fs/read_write.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/read_write.c
+++ linux-2.6.24-rc7/fs/read_write.c
@@ -255,6 +255,7 @@ EXPORT_SYMBOL(do_sync_read);
 
 ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
 {
+	struct latency_entry reason;
 	ssize_t ret;
 
 	if (!(file->f_mode & FMODE_READ))
@@ -264,6 +265,7 @@ ssize_t vfs_read(struct file *file, char
 	if (unlikely(!access_ok(VERIFY_WRITE, buf, count)))
 		return -EFAULT;
 
+	set_latency_reason("Reading from file", &reason);
 	ret = rw_verify_area(READ, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
@@ -281,6 +283,7 @@ ssize_t vfs_read(struct file *file, char
 		}
 	}
 
+	restore_latency_reason(&reason);
 	return ret;
 }
 
@@ -314,6 +317,7 @@ EXPORT_SYMBOL(do_sync_write);
 ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
 {
 	ssize_t ret;
+	struct latency_entry reason;
 
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
@@ -322,6 +326,7 @@ ssize_t vfs_write(struct file *file, con
 	if (unlikely(!access_ok(VERIFY_READ, buf, count)))
 		return -EFAULT;
 
+	set_latency_reason("Writing to file", &reason);
 	ret = rw_verify_area(WRITE, file, pos, count);
 	if (ret >= 0) {
 		count = ret;
@@ -338,7 +343,7 @@ ssize_t vfs_write(struct file *file, con
 			inc_syscw(current);
 		}
 	}
-
+	restore_latency_reason(&reason);
 	return ret;
 }
 
Index: linux-2.6.24-rc7/fs/readdir.c
===================================================================
--- linux-2.6.24-rc7.orig/fs/readdir.c
+++ linux-2.6.24-rc7/fs/readdir.c
@@ -21,6 +21,7 @@
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
+	struct latency_entry reason;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
 	if (!file->f_op || !file->f_op->readdir)
@@ -29,7 +30,7 @@ int vfs_readdir(struct file *file, filld
 	res = security_file_permission(file, MAY_READ);
 	if (res)
 		goto out;
-
+	set_latency_reason("Unlinking file", &reason);
 	mutex_lock(&inode->i_mutex);
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
@@ -37,6 +38,7 @@ int vfs_readdir(struct file *file, filld
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
+	restore_latency_reason(&reason);
 out:
 	return res;
 }
Index: linux-2.6.24-rc7/lib/kernel_lock.c
===================================================================
--- linux-2.6.24-rc7.orig/lib/kernel_lock.c
+++ linux-2.6.24-rc7/lib/kernel_lock.c
@@ -64,15 +64,18 @@ void __lockfunc __release_kernel_lock(vo
  */
 void __lockfunc lock_kernel(void)
 {
+	struct latency_entry reason;
 	struct task_struct *task = current;
 	int depth = task->lock_depth + 1;
 
+	set_latency_reason("Big kernel lock contention", &reason);
 	if (likely(!depth))
 		/*
 		 * No recursion worries - we set up lock_depth _after_
 		 */
 		down(&kernel_sem);
 
+	restore_latency_reason(&reason);
 	task->lock_depth = depth;
 }
 
