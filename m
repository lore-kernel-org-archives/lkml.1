Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbXCNWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbXCNWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbXCNWZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:25:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42422 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379AbXCNWYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:24:37 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Date: Wed, 14 Mar 2007 15:19:21 -0700
Subject: [patch 10/13] signalfd/timerfd/asyncfd v5 - asyncfd core ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.13805.1173910768.10>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the asyncfd implementation. It's a thin and generic file descriptor
that can be used to deliver results to userspace and, at the same time,
supports the Linux f_op->poll subsystem making it able to be used with
POSIX select(2)/poll(2) (and, as a consequence, epoll(2)).
The use for such result delivery fd is to enable KAIO and syslets/threadlets
to work with POSIX select(2)/poll(2) and epoll, hence bridging the wide
range of devices supporting f_op->poll with the ones that are typically not
(like block I/O).
Coupled with syslets/threadlets, this enable results coming from them to
be "pollable" inside an epoll fd, that is a complementary way to the one of
hosting an epoll_wait(2) over a syslet/threadlet.
I have two version of this patch actually. One that uses kernel memory to
buffer results, and exposes a read(2) interface to userspace, and this one,
that uses a buffer (ring) supplied by the user during the asyncfd creation.
Both have Pros&Cons, but I ended up posting this one because of the kernel
memory usage limiting that the former had.
I have no personal preferences between the two, so to me it does not matter.
The asyncfd API at the moment is defined as:

struct asyncfd_uring {
	__u64 ptr;	/* Pointer to a buffer of struct asyncfd_result */
	__u32 iuser;	/* User index */
	__u32 size;	/* Number of struct asyncfd_result in the buffer */
	__u32 ikernel;	/* Kernel index */
};


int asyncfd(int ufd, struct asyncfd_uring *urng);

Like the signalfd and timerfd APIs, it is possible to change the userspace
ring used by the fd, by passing an axisting fd in "ufd". If "ufd" is -1, a
new asyncfd file will be created.
It is possible in that way to replace the existing ring with a larger one,
once the userspace code realizes that the potential number of submitted
requests may not be able to be stored in the previous one. Just:

asyncfd(asfd, &newring);
flush_process(&oldring);

The kernel side asyncfd API is very simple:

struct asyncfd_result {
	__u64 cookie;
	__u64 obj;
	__s64 res;
	__s64 res2;
};

struct file *asyncfd_fget(int fd);
int asyncfd_add_results(struct file *file, const struct asyncfd_result *results,
			int n);

When the user passes an asyncfd to the kernel, by hence telling it to deliver
result to such fd, the kernel should call asyncfd_fget() to get an instance
of the asyncfd file*. The asyncfd_fget() function simply does an fget() and
verifies that this is really an asyncfd (compare f_op pointer).
Then, when results are available to be delivered, the kernel should call the
asyncfd_add_results() function with one or more results to be stored in the
userspace ring. The asyncfd_add_results() function returns the number of stored
results, or an error if the userspace ring is invalid (-EFAULT basically).
It can also return a number lower than "n", if the userspace ring is full.
The asyncfd_add_results() may sleep in this implementation, since it uses
{put,get}_user on non mlocked userspace memory. It should, in theory, not be
a problem, but if it is, we need to either mlock the ring (me no-liky) or
use the buffered results version of the patch.
The struct asyncfd_result tries to include all the members currently necessary
to ship a KAIO result to userspace, but even this, is not set in stone.
As I see it, the asyncfd should be an optional delivery machanism to be
included in the struct async_head_user used by syslets/threadlets, and hence
offer a result transport to them.




Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.20.ep2/fs/Makefile
===================================================================
--- linux-2.6.20.ep2.orig/fs/Makefile	2007-03-12 11:27:58.000000000 -0700
+++ linux-2.6.20.ep2/fs/Makefile	2007-03-12 11:47:47.000000000 -0700
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o anon_inodes.o signalfd.o timerfd.o
+		stack.o anon_inodes.o signalfd.o timerfd.o asyncfd.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.20.ep2/fs/asyncfd.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/fs/asyncfd.c	2007-03-14 09:28:17.000000000 -0700
@@ -0,0 +1,233 @@
+/*
+ *  fs/asyncfd.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/jiffies.h>
+#include <linux/anon_inodes.h>
+#include <linux/asyncfd.h>
+
+#include <asm/uaccess.h>
+
+
+
+struct asyncfd_ctx {
+	struct mutex lock;
+	wait_queue_head_t wqh;
+	struct asyncfd_uring __user *urng;
+};
+
+
+static void asyncfd_cleanup(struct asyncfd_ctx *ctx);
+static int asyncfd_close(struct inode *inode, struct file *file);
+static unsigned int asyncfd_poll(struct file *file, poll_table *wait);
+
+
+
+static const struct file_operations asyncfd_fops = {
+	.release	= asyncfd_close,
+	.poll		= asyncfd_poll,
+};
+static struct kmem_cache *asyncfd_ctx_cachep;
+
+
+
+
+struct file *asyncfd_fget(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &asyncfd_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return file;
+}
+
+
+asmlinkage long sys_asyncfd(int ufd, struct asyncfd_uring __user *urng)
+{
+	int error;
+	__u32 size;
+	__u64 ptr;
+	struct asyncfd_ctx *ctx;
+	struct file *file;
+	struct inode *inode;
+
+	if (!access_ok(VERIFY_WRITE, urng, sizeof(*urng)) ||
+	    get_user(size, &urng->size) ||
+	    get_user(ptr, &urng->ptr) ||
+	    !access_ok(VERIFY_WRITE, (unsigned long) ptr,
+		       size * sizeof(struct asyncfd_result)))
+		return -EFAULT;
+
+	if (ufd == -1) {
+		ctx = kmem_cache_alloc(asyncfd_ctx_cachep, GFP_KERNEL);
+		if (!ctx)
+			return -ENOMEM;
+
+		init_waitqueue_head(&ctx->wqh);
+		mutex_init(&ctx->lock);
+		ctx->urng = urng;
+
+		/*
+		 * When we call this, the initialization must be complete, since
+		 * aino_getfd() will install the fd.
+		 */
+		error = aino_getfd(&ufd, &inode, &file, "[asyncfd]",
+				   &asyncfd_fops, ctx);
+		if (error)
+			goto err_cleanup;
+	} else {
+		file = fget(ufd);
+		if (!file)
+			return -EBADF;
+		ctx = file->private_data;
+		if (file->f_op != &asyncfd_fops) {
+			fput(file);
+			return -EINVAL;
+		}
+		mutex_lock(&ctx->lock);
+		ctx->urng = urng;
+		wake_up_locked(&ctx->wqh);
+		mutex_unlock(&ctx->lock);
+		fput(file);
+	}
+
+	return ufd;
+
+err_cleanup:
+	asyncfd_cleanup(ctx);
+	return error;
+}
+
+
+static void asyncfd_cleanup(struct asyncfd_ctx *ctx)
+{
+	kmem_cache_free(asyncfd_ctx_cachep, ctx);
+}
+
+
+static int asyncfd_close(struct inode *inode, struct file *file)
+{
+	asyncfd_cleanup(file->private_data);
+	return 0;
+}
+
+
+static unsigned int asyncfd_poll(struct file *file, poll_table *wait)
+{
+	struct asyncfd_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+	__u32 iuser, ikernel;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	mutex_lock(&ctx->lock);
+	if (get_user(ikernel, &ctx->urng->ikernel) ||
+	    get_user(iuser, &ctx->urng->iuser)) {
+		events |= POLLERR;
+		goto err_unlock;
+	}
+	if (ikernel != iuser)
+		events |= POLLIN;
+err_unlock:
+	mutex_unlock(&ctx->lock);
+
+	return events;
+}
+
+
+int asyncfd_add_results(struct file *file, const struct asyncfd_result *results,
+			int n)
+{
+	struct asyncfd_ctx *ctx = file->private_data;
+	int res;
+	__u32 ikernel, size;
+	__u64 ptr, cookie;
+	struct asyncfd_result __user *rptr, *cptr;
+
+	/*
+	 * There must be at least two users of this file. Once if the userspace
+	 * fd, and the other one is the asyncfd result submitter (that must have
+	 * done a asyncfd_fget() before). If the use count is lower than two, it
+	 * measn that the userspace has closed the file and that noone is no more
+	 * waiting for results here.
+	 */
+	if (atomic_read(&file->f_count) < 2)
+		return -EBADFD;
+	mutex_lock(&ctx->lock);
+	if (get_user(ikernel, &ctx->urng->ikernel) ||
+	    get_user(size, &ctx->urng->size) ||
+	    get_user(ptr, &ctx->urng->ptr) ||
+	    ikernel >= size)
+		goto err_efault;
+	rptr = (struct asyncfd_result __user *) (unsigned long) ptr;
+	for (res = 0; n > res; res++, results++) {
+		cptr = rptr + ikernel;
+		if (get_user(cookie, &cptr->cookie))
+			goto err_efault;
+		/*
+		 * A slot is free for the kernel, where userspace marks it
+		 * with a zero cookie.
+		 */
+		if (cookie != 0)
+			break;
+		if (put_user(results->cookie, &cptr->cookie) ||
+		    put_user(results->obj, &cptr->obj) ||
+		    put_user(results->res, &cptr->res) ||
+		    put_user(results->res2, &cptr->res2))
+			goto err_efault;
+		if (++ikernel >= size)
+			ikernel = 0;
+	}
+	if (likely(res > 0)) {
+		if (put_user(ikernel, &ctx->urng->ikernel))
+			goto err_efault;
+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked(&ctx->wqh);
+	}
+	mutex_unlock(&ctx->lock);
+	return res;
+
+err_efault:
+	mutex_unlock(&ctx->lock);
+	return -EFAULT;
+
+}
+
+
+static int __init asyncfd_init(void)
+{
+	asyncfd_ctx_cachep = kmem_cache_create("asyncfd_ctx_cache",
+						sizeof(struct asyncfd_ctx),
+						0, SLAB_PANIC, NULL, NULL);
+	return 0;
+}
+
+
+static void __exit asyncfd_exit(void)
+{
+	kmem_cache_destroy(asyncfd_ctx_cachep);
+}
+
+module_init(asyncfd_init);
+module_exit(asyncfd_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6.20.ep2/include/linux/asyncfd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/include/linux/asyncfd.h	2007-03-14 09:22:12.000000000 -0700
@@ -0,0 +1,34 @@
+/*
+ *  include/linux/asyncfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_ASYNCFD_H
+#define _LINUX_ASYNCFD_H
+
+
+
+struct asyncfd_uring {
+	__u64 ptr;
+	__u32 iuser;
+	__u32 size;
+	__u32 ikernel;
+};
+
+struct asyncfd_result {
+	__u64 cookie;
+	__u64 obj;
+	__s64 res;
+	__s64 res2;
+};
+
+
+struct file *asyncfd_fget(int fd);
+int asyncfd_add_results(struct file *file, const struct asyncfd_result *results,
+			int n);
+
+
+#endif /* _LINUX_ASYNCFD_H */
+
Index: linux-2.6.20.ep2/include/linux/syscalls.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/syscalls.h	2007-03-13 16:40:46.000000000 -0700
+++ linux-2.6.20.ep2/include/linux/syscalls.h	2007-03-13 18:56:27.000000000 -0700
@@ -54,6 +54,7 @@
 struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
+struct asyncfd_uring;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -605,6 +606,7 @@
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
+asmlinkage long sys_asyncfd(int ufd, struct asyncfd_uring __user *urng);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 

