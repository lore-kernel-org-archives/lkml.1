Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYGCQr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYGCQr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 12:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYGCQrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 12:47:12 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47895 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbYGCQrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 12:47:09 -0400
Message-Id: <20080703161103.039448773@polymtl.ca>
References: <20080703160526.637679319@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 12:05:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC patch 2/3] LTTng tracepoint instrumentation fs
Content-Disposition: inline; filename=lttng-instrumentation-fs.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  3 Jul 2008 16:11:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core filesystem tracepoints.

Tracepoints added :

fs_buffer_wait_end
fs_buffer_wait_start
fs_close
fs_exec
fs_ioctl
fs_llseek
fs_lseek
fs_open
fs_poll
fs_pread64
fs_pwrite64
fs_read
fs_readv
fs_select
fs_write
fs_writev

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Alexander Viro <viro@zeniv.linux.org.uk>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
---
 fs/buffer.c     |    3 +++
 fs/compat.c     |    2 ++
 fs/exec.c       |    2 ++
 fs/fs-trace.h   |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ioctl.c      |    3 +++
 fs/open.c       |    3 +++
 fs/read_write.c |   19 +++++++++++++++++--
 fs/select.c     |    3 +++
 8 files changed, 87 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/fs/buffer.c
===================================================================
--- linux-2.6-lttng.orig/fs/buffer.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/buffer.c	2008-07-03 11:59:50.000000000 -0400
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
+#include "fs-trace.h"
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
 
@@ -89,7 +90,9 @@ void unlock_buffer(struct buffer_head *b
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
+	trace_fs_buffer_wait_start(bh);
 	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
+	trace_fs_buffer_wait_end(bh);
 }
 
 static void
Index: linux-2.6-lttng/fs/compat.c
===================================================================
--- linux-2.6-lttng.orig/fs/compat.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/compat.c	2008-07-03 11:59:50.000000000 -0400
@@ -51,6 +51,7 @@
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/eventpoll.h>
+#include "fs-trace.h"
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1402,6 +1403,7 @@ int compat_do_execve(char * filename,
 
 	retval = search_binary_handler(bprm, regs);
 	if (retval >= 0) {
+		trace_fs_exec(filename);
 		/* execve success */
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
Index: linux-2.6-lttng/fs/ioctl.c
===================================================================
--- linux-2.6-lttng.orig/fs/ioctl.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/ioctl.c	2008-07-03 11:59:50.000000000 -0400
@@ -13,6 +13,7 @@
 #include <linux/security.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include "fs-trace.h"
 
 #include <asm/ioctls.h>
 
@@ -201,6 +202,8 @@ asmlinkage long sys_ioctl(unsigned int f
 	if (!filp)
 		goto out;
 
+	trace_fs_ioctl(fd, cmd, arg);
+
 	error = security_file_ioctl(filp, cmd, arg);
 	if (error)
 		goto out_fput;
Index: linux-2.6-lttng/fs/open.c
===================================================================
--- linux-2.6-lttng.orig/fs/open.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/open.c	2008-07-03 11:59:50.000000000 -0400
@@ -28,6 +28,7 @@
 #include <linux/rcupdate.h>
 #include <linux/audit.h>
 #include <linux/falloc.h>
+#include "fs-trace.h"
 
 int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
@@ -1090,6 +1091,7 @@ long do_sys_open(int dfd, const char __u
 				fsnotify_open(f->f_path.dentry);
 				fd_install(fd, f);
 			}
+			trace_fs_open(fd, tmp);
 		}
 		putname(tmp);
 	}
@@ -1179,6 +1181,7 @@ asmlinkage long sys_close(unsigned int f
 	filp = fdt->fd[fd];
 	if (!filp)
 		goto out_unlock;
+	trace_fs_close(fd);
 	rcu_assign_pointer(fdt->fd[fd], NULL);
 	FD_CLR(fd, fdt->close_on_exec);
 	__put_unused_fd(files, fd);
Index: linux-2.6-lttng/fs/read_write.c
===================================================================
--- linux-2.6-lttng.orig/fs/read_write.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/read_write.c	2008-07-03 11:59:50.000000000 -0400
@@ -16,6 +16,7 @@
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
 #include <linux/splice.h>
+#include "fs-trace.h"
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -146,6 +147,9 @@ asmlinkage off_t sys_lseek(unsigned int 
 		if (res != (loff_t)retval)
 			retval = -EOVERFLOW;	/* LFS: should only happen on 32 bit platforms */
 	}
+
+	trace_fs_lseek(fd, offset, origin);
+
 	fput_light(file, fput_needed);
 bad:
 	return retval;
@@ -173,6 +177,8 @@ asmlinkage long sys_llseek(unsigned int 
 	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
 			origin);
 
+	trace_fs_llseek(fd, offset, origin);
+
 	retval = (int)offset;
 	if (offset >= 0) {
 		retval = -EFAULT;
@@ -359,6 +365,7 @@ asmlinkage ssize_t sys_read(unsigned int
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_fs_read(fd, count);
 		ret = vfs_read(file, buf, count, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -376,6 +383,7 @@ asmlinkage ssize_t sys_write(unsigned in
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_fs_write(fd, count);
 		ret = vfs_write(file, buf, count, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -397,8 +405,11 @@ asmlinkage ssize_t sys_pread64(unsigned 
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
-		if (file->f_mode & FMODE_PREAD)
+		if (file->f_mode & FMODE_PREAD) {
+			trace_fs_pread64(fd, count, pos);
 			ret = vfs_read(file, buf, count, &pos);
+		}
+
 		fput_light(file, fput_needed);
 	}
 
@@ -418,8 +429,10 @@ asmlinkage ssize_t sys_pwrite64(unsigned
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		ret = -ESPIPE;
-		if (file->f_mode & FMODE_PWRITE)  
+		if (file->f_mode & FMODE_PWRITE) {
+			trace_fs_pwrite64(fd, count, pos);
 			ret = vfs_write(file, buf, count, &pos);
+		}
 		fput_light(file, fput_needed);
 	}
 
@@ -663,6 +676,7 @@ sys_readv(unsigned long fd, const struct
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_fs_readv(fd, vlen);
 		ret = vfs_readv(file, vec, vlen, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
@@ -684,6 +698,7 @@ sys_writev(unsigned long fd, const struc
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);
+		trace_fs_writev(fd, vlen);
 		ret = vfs_writev(file, vec, vlen, &pos);
 		file_pos_write(file, pos);
 		fput_light(file, fput_needed);
Index: linux-2.6-lttng/fs/select.c
===================================================================
--- linux-2.6-lttng.orig/fs/select.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/select.c	2008-07-03 11:59:50.000000000 -0400
@@ -24,6 +24,7 @@
 #include <linux/fdtable.h>
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
+#include "fs-trace.h"
 
 #include <asm/uaccess.h>
 
@@ -232,6 +233,7 @@ int do_select(int n, fd_set_bits *fds, s
 				file = fget_light(i, &fput_needed);
 				if (file) {
 					f_op = file->f_op;
+					trace_fs_select(i, *timeout);
 					mask = DEFAULT_POLLMASK;
 					if (f_op && f_op->poll)
 						mask = (*f_op->poll)(file, retval ? NULL : wait);
@@ -560,6 +562,7 @@ static inline unsigned int do_pollfd(str
 		file = fget_light(fd, &fput_needed);
 		mask = POLLNVAL;
 		if (file != NULL) {
+			trace_fs_poll(fd);
 			mask = DEFAULT_POLLMASK;
 			if (file->f_op && file->f_op->poll)
 				mask = file->f_op->poll(file, pwait);
Index: linux-2.6-lttng/fs/exec.c
===================================================================
--- linux-2.6-lttng.orig/fs/exec.c	2008-07-03 11:53:39.000000000 -0400
+++ linux-2.6-lttng/fs/exec.c	2008-07-03 11:59:50.000000000 -0400
@@ -51,6 +51,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include "fs-trace.h"
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1330,6 +1331,7 @@ int do_execve(char * filename,
 
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
+		trace_fs_exec(filename);
 		/* execve success */
 		security_bprm_free(bprm);
 		acct_update_integrals(current);
Index: linux-2.6-lttng/fs/fs-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/fs/fs-trace.h	2008-07-03 11:59:50.000000000 -0400
@@ -0,0 +1,54 @@
+#ifndef _FS_TRACE_H
+#define _FS_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(fs_buffer_wait_start,
+	TPPROTO(struct buffer_head *bh),
+	TPARGS(bh));
+DEFINE_TRACE(fs_buffer_wait_end,
+	TPPROTO(struct buffer_head *bh),
+	TPARGS(bh));
+DEFINE_TRACE(fs_exec,
+	TPPROTO(char *filename),
+	TPARGS(filename));
+DEFINE_TRACE(fs_ioctl,
+	TPPROTO(unsigned int fd, unsigned int cmd, unsigned long arg),
+	TPARGS(fd, cmd, arg));
+DEFINE_TRACE(fs_open,
+	TPPROTO(unsigned int fd, char *filename),
+	TPARGS(fd, filename));
+DEFINE_TRACE(fs_close,
+	TPPROTO(unsigned int fd),
+	TPARGS(fd));
+DEFINE_TRACE(fs_lseek,
+	TPPROTO(unsigned int fd, unsigned long offset, unsigned int origin),
+	TPARGS(fd, offset, origin));
+DEFINE_TRACE(fs_llseek,
+	TPPROTO(unsigned int fd, loff_t offset, unsigned int origin),
+	TPARGS(fd, offset, origin));
+DEFINE_TRACE(fs_read,
+	TPPROTO(unsigned int fd, size_t count),
+	TPARGS(fd, count));
+DEFINE_TRACE(fs_write,
+	TPPROTO(unsigned int fd, size_t count),
+	TPARGS(fd, count));
+DEFINE_TRACE(fs_pread64,
+	TPPROTO(unsigned int fd, size_t count, loff_t pos),
+	TPARGS(fd, count, pos));
+DEFINE_TRACE(fs_pwrite64,
+	TPPROTO(unsigned int fd, size_t count, loff_t pos),
+	TPARGS(fd, count, pos));
+DEFINE_TRACE(fs_readv,
+	TPPROTO(unsigned long fd, unsigned long vlen),
+	TPARGS(fd, vlen));
+DEFINE_TRACE(fs_writev,
+	TPPROTO(unsigned long fd, unsigned long vlen),
+	TPARGS(fd, vlen));
+DEFINE_TRACE(fs_select,
+	TPPROTO(int fd, s64 timeout),
+	TPARGS(fd, timeout));
+DEFINE_TRACE(fs_poll,
+	TPPROTO(int fd),
+	TPARGS(fd));
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
