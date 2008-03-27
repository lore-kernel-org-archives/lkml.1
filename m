Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbYC0NcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbYC0NcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbYC0NaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:30:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45329 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077AbYC0NaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:30:21 -0400
Message-Id: <20080327133013.183507196@polymtl.ca>
References: <20080327132057.449831367@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 09:20:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [patch for 2.6.26 2/7] LTTng instrumentation fs
Content-Disposition: inline; filename=lttng-instrumentation-fs.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 27 Mar 2008 13:30:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core filesystem events markers.

Markers added :

fs_buffer_wait_end
fs_buffer_wait_start
fs_close
fs_exec
fs_ioctl
fs_llseek
fs_lseek
fs_open
fs_pollfd
fs_pread64
fs_pwrite64
fs_read
fs_readv
fs_select
fs_write
fs_writev

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/buffer.c     |    3 +++
 fs/compat.c     |    2 ++
 fs/exec.c       |    2 ++
 fs/ioctl.c      |    3 +++
 fs/open.c       |    3 +++
 fs/read_write.c |   23 +++++++++++++++++++++--
 fs/select.c     |    5 +++++
 7 files changed, 39 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/fs/buffer.c
===================================================================
--- linux-2.6-lttng.orig/fs/buffer.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/buffer.c	2008-03-27 07:39:57.000000000 -0400
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include <linux/marker.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -89,7 +90,9 @@ void unlock_buffer(struct buffer_head *b
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
+	trace_mark(fs_buffer_wait_start, "bh %p", bh);
 	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
+	trace_mark(fs_buffer_wait_end, "bh %p", bh);
 }
 
 static void
Index: linux-2.6-lttng/fs/compat.c
===================================================================
--- linux-2.6-lttng.orig/fs/compat.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/compat.c	2008-03-27 07:39:57.000000000 -0400
@@ -50,6 +50,7 @@
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/eventpoll.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1401,6 +1402,7 @@ int compat_do_execve(char * filename,
 
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
+		trace_mark(fs_exec, "filename %s", filename);
 		/* execve success */
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
Index: linux-2.6-lttng/fs/ioctl.c
===================================================================
--- linux-2.6-lttng.orig/fs/ioctl.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/ioctl.c	2008-03-27 07:39:57.000000000 -0400
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/marker.h>
 
 #include <asm/ioctls.h>
 
@@ -201,6 +202,8 @@ asmlinkage long sys_ioctl(unsigned int f
 	if (!filp)
 		goto out;
 
+	trace_mark(fs_ioctl, "fd %u cmd %u arg %lu", fd, cmd, arg);
+
 	error = security_file_ioctl(filp, cmd, arg);
 	if (error)
 		goto out_fput;
Index: linux-2.6-lttng/fs/open.c
===================================================================
--- linux-2.6-lttng.orig/fs/open.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/open.c	2008-03-27 07:39:57.000000000 -0400
@@ -27,6 +27,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include <linux/marker.h>
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -1052,6 +1053,7 @@ long do_sys_open(int dfd, const char __u
 				fsnotify_open(f->f_path.dentry);
 				fd_install(fd, f);
 			}
+			trace_mark(fs_open, "fd %d filename %s", fd, tmp);
 		}
 		putname(tmp);
 	}
@@ -1141,6 +1143,7 @@ asmlinkage long sys_close(unsigned int f
 	filp = fdt->fd[fd];
 	if (!filp)
 		goto out_unlock;
+	trace_mark(fs_close, "fd %u", fd);
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	FD_CLR(fd, fdt->close_on_exec);
 	__put_unused_fd(files, fd);
Index: linux-2.6-lttng/fs/read_write.c
===================================================================
--- linux-2.6-lttng.orig/fs/read_write.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/read_write.c	2008-03-27 07:39:57.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include <linux/marker.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -146,6 +147,9 @@ asmlinkage off_t sys_lseek(unsigned int 
 		if (res != (loff_t)retval)
 			retval = -EOVERFLOW;	/* LFS: should only happen on 32 bit platforms */
 	}
+
+	trace_mark(fs_lseek, "fd %u offset %ld origin %u", fd, offset, origin);
+
 	fput_light(file, fput_needed);
 bad:
 	return retval;
@@ -173,6 +177,10 @@ asmlinkage long sys_llseek(unsigned int 
 	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
 			origin);
 
+	trace_mark(fs_llseek, "fd %u offset %llu origin %u", fd,
+			(unsigned long long)offset,
+			origin);
+
 	retval = (int)offset;
 	if (offset >= 0) {
 		retval = -EFAULT;
@@ -359,6 +367,7 @@ asmlinkage ssize_t sys_read(unsigned int
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_read, "fd %u count %zu", fd, count);
 		ret = vfs_read(file, buf, count, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -376,6 +385,7 @@ asmlinkage ssize_t sys_write(unsigned in
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_write, "fd %u count %zu", fd, count);
 		ret = vfs_write(file, buf, count, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -397,8 +407,12 @@ asmlinkage ssize_t sys_pread64(unsigned 
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
-		if (file->f_mode & FMODE_PREAD)
+		if (file->f_mode & FMODE_PREAD) {
+			trace_mark(fs_pread64, "fd %u count %zu pos %llu",
+				fd, count, (unsigned long long)pos);
 			ret = vfs_read(file, buf, count, &pos);
+		}
+
 		fput_light(file, fput_needed);
 	}
 
@@ -418,8 +432,11 @@ asmlinkage ssize_t sys_pwrite64(unsigned
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
-		if (file->f_mode & FMODE_PWRITE)  
+		if (file->f_mode & FMODE_PWRITE) {
+			trace_mark(fs_pwrite64, "fd %u count %zu pos %llu",
+				fd, count, (unsigned long long)pos);
 			ret = vfs_write(file, buf, count, &pos);
+		}
 		fput_light(file, fput_needed);
 	}
 
@@ -663,6 +680,7 @@ sys_readv(unsigned long fd, const struct
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_readv, "fd %lu vlen %lu", fd, vlen);
 		ret = vfs_readv(file, vec, vlen, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -684,6 +702,7 @@ sys_writev(unsigned long fd, const struc
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_writev, "fd %lu vlen %lu", fd, vlen);
 		ret = vfs_writev(file, vec, vlen, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
Index: linux-2.6-lttng/fs/select.c
===================================================================
--- linux-2.6-lttng.orig/fs/select.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/select.c	2008-03-27 07:39:57.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 
@@ -231,6 +232,9 @@ int do_select(int n, fd_set_bits *fds, s
 				file = fget_light(i, &fput_needed);
 				if (file) {
 					f_op = file->f_op;
+					trace_mark(fs_select,
+							"fd %d timeout #8d%lld",
+							i, (long long)*timeout);
 					mask = DEFAULT_POLLMASK;
 					if (f_op && f_op->poll)
 						mask = (*f_op->poll)(file, retval ? NULL : wait);
@@ -559,6 +563,7 @@ static inline unsigned int do_pollfd(str
 		file = fget_light(fd, &fput_needed);
 		mask = POLLNVAL;
 		if (file != NULL) {
+			trace_mark(fs_pollfd, "fd %d", fd);
 			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll)
 				mask = file->f_op->poll(file, pwait);
Index: linux-2.6-lttng/fs/exec.c
===================================================================
--- linux-2.6-lttng.orig/fs/exec.c	2008-03-27 07:39:56.000000000 -0400
+++ linux-2.6-lttng/fs/exec.c	2008-03-27 07:39:57.000000000 -0400
@@ -51,6 +51,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/marker.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1338,6 +1339,7 @@ int do_execve(char * filename,
 
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
+		trace_mark(fs_exec, "filename %s", filename);
 		/* execve success */
 		free_arg_pages(bprm);
 		security_bprm_free(bprm);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
