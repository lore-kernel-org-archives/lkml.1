Return-Path: <linux-kernel-owner+w=401wt.eu-S1762109AbXKMTma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762109AbXKMTma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbXKMTlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:41:16 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47664 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937AbXKMTlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:41:11 -0500
Message-Id: <20071113194024.213740052@polymtl.ca>
References: <20071113193349.214098508@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:33:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [RFC 2/7] LTTng instrumentation fs
Content-Disposition: inline; filename=lttng-instrumentation-fs.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:40:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Core filesystem events markers.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/buffer.c     |    2 ++
 fs/compat.c     |    1 +
 fs/exec.c       |    1 +
 fs/ioctl.c      |    2 ++
 fs/open.c       |    2 ++
 fs/read_write.c |   21 +++++++++++++++++++--
 fs/select.c     |    4 ++++
 7 files changed, 31 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/fs/buffer.c
===================================================================
--- linux-2.6-lttng.orig/fs/buffer.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/buffer.c	2007-11-13 09:49:29.000000000 -0500
@@ -89,7 +89,9 @@ void fastcall unlock_buffer(struct buffe
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
--- linux-2.6-lttng.orig/fs/compat.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/compat.c	2007-11-13 09:49:29.000000000 -0500
@@ -1408,6 +1408,7 @@ int compat_do_execve(char * filename,
 
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
+		trace_mark(fs_exec, "filename %s", filename);
 		/* execve success */
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
Index: linux-2.6-lttng/fs/ioctl.c
===================================================================
--- linux-2.6-lttng.orig/fs/ioctl.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/ioctl.c	2007-11-13 09:49:29.000000000 -0500
@@ -164,6 +164,8 @@ asmlinkage long sys_ioctl(unsigned int f
 	if (!filp)
 		goto out;
 
+	trace_mark(fs_ioctl, "fd %u cmd %u arg %lu", fd, cmd, arg);
+
 	error = security_file_ioctl(filp, cmd, arg);
 	if (error)
 		goto out_fput;
Index: linux-2.6-lttng/fs/open.c
===================================================================
--- linux-2.6-lttng.orig/fs/open.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/open.c	2007-11-13 09:49:29.000000000 -0500
@@ -1043,6 +1043,7 @@ long do_sys_open(int dfd, const char __u
 				fsnotify_open(f->f_path.dentry);
 				fd_install(fd, f);
 			}
+			trace_mark(fs_open, "fd %d filename %s", fd, tmp);
 		}
 		putname(tmp);
 	}
@@ -1133,6 +1134,7 @@ asmlinkage long sys_close(unsigned int f
 	filp = fdt->fd[fd];
 	if (!filp)
 		goto out_unlock;
+	trace_mark(fs_close, "fd %u", fd);
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	FD_CLR(fd, fdt->close_on_exec);
 	__put_unused_fd(files, fd);
Index: linux-2.6-lttng/fs/read_write.c
===================================================================
--- linux-2.6-lttng.orig/fs/read_write.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/read_write.c	2007-11-13 09:49:29.000000000 -0500
@@ -146,6 +146,9 @@ asmlinkage off_t sys_lseek(unsigned int 
 		if (res != (loff_t)retval)
 			retval = -EOVERFLOW;	/* LFS: should only happen on 32 bit platforms */
 	}
+
+	trace_mark(fs_lseek, "fd %u offset %ld origin %u", fd, offset, origin);
+
 	fput_light(file, fput_needed);
 bad:
 	return retval;
@@ -173,6 +176,9 @@ asmlinkage long sys_llseek(unsigned int 
 	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
 			origin);
 
+	trace_mark(fs_llseek, "fd %u offset %lld origin %u", fd, offset,
+			origin);
+
 	retval = (int)offset;
 	if (offset >= 0) {
 		retval = -EFAULT;
@@ -363,6 +369,7 @@ asmlinkage ssize_t sys_read(unsigned int
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_read, "fd %u count %zu", fd, count);
 		ret = vfs_read(file, buf, count, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -381,6 +388,7 @@ asmlinkage ssize_t sys_write(unsigned in
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_write, "fd %u count %zu", fd, count);
 		ret = vfs_write(file, buf, count, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -402,8 +410,12 @@ asmlinkage ssize_t sys_pread64(unsigned 
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
-		if (file->f_mode & FMODE_PREAD)
+		if (file->f_mode & FMODE_PREAD) {
+			trace_mark(fs_pread64, "fd %u count %zu pos %lld",
+				fd, count, pos);
 			ret = vfs_read(file, buf, count, &pos);
+		}
+
 		fput_light(file, fput_needed);
 	}
 
@@ -423,8 +435,11 @@ asmlinkage ssize_t sys_pwrite64(unsigned
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
-		if (file->f_mode & FMODE_PWRITE)  
+		if (file->f_mode & FMODE_PWRITE) {
+			trace_mark(fs_pwrite64, "fd %u count %zu pos %lld",
+				fd, count, pos);
 			ret = vfs_write(file, buf, count, &pos);
+		}
 		fput_light(file, fput_needed);
 	}
 
@@ -670,6 +685,7 @@ sys_readv(unsigned long fd, const struct
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_readv, "fd %lu vlen %lu", fd, vlen);
 		ret = vfs_readv(file, vec, vlen, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -691,6 +707,7 @@ sys_writev(unsigned long fd, const struc
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_mark(fs_writev, "fd %lu vlen %lu", fd, vlen);
 		ret = vfs_writev(file, vec, vlen, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
Index: linux-2.6-lttng/fs/select.c
===================================================================
--- linux-2.6-lttng.orig/fs/select.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/select.c	2007-11-13 09:49:29.000000000 -0500
@@ -231,6 +231,9 @@ int do_select(int n, fd_set_bits *fds, s
 				file = fget_light(i, &fput_needed);
 				if (file) {
 					f_op = file->f_op;
+					trace_mark(fs_select,
+							"fd %d timeout #8d%llu",
+							i, *timeout);
 					mask = DEFAULT_POLLMASK;
 					if (f_op && f_op->poll)
 						mask = (*f_op->poll)(file, retval ? NULL : wait);
@@ -559,6 +562,7 @@ static inline unsigned int do_pollfd(str
 		file = fget_light(fd, &fput_needed);
 		mask = POLLNVAL;
 		if (file != NULL) {
+			trace_mark(fs_pollfd, "fd %d", fd);
 			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll)
 				mask = file->f_op->poll(file, pwait);
Index: linux-2.6-lttng/fs/exec.c
===================================================================
--- linux-2.6-lttng.orig/fs/exec.c	2007-11-13 09:49:27.000000000 -0500
+++ linux-2.6-lttng/fs/exec.c	2007-11-13 09:49:29.000000000 -0500
@@ -1351,6 +1351,7 @@ int do_execve(char * filename,
 
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
