Return-Path: <linux-kernel-owner+w=401wt.eu-S965122AbXCOERj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122AbXCOERj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 00:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXCOERT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 00:17:19 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42655 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082AbXCOERP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 00:17:15 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Date: Wed, 14 Mar 2007 21:12:26 -0700
Subject: [patch 2/5] eventfd+KAIO - eventfd core ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5447.1173931946.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a very simple and light file descriptor, that can be used as
event wait/dispatch by userspace (both wait and dispatch) and by the
kernel (dispatch only). When used in the kernel, it can offer an fd-bridge
to enable functionalities like KAIO or syslets/threadlets to signal to
an fd the completion of certain operations.
The API is:

int eventfd(unsigned int count);

The eventfd API accepts an initial "count" parameter, and returns an
eventfd fd. It supports poll(2) (POLLIN), read(2) and write(2).
The read(2) function reads the __u64 counter value, and reset the internal
value to zero. The write(2) call writes an __u64 count value, and adds it
to the current counter. The eventfd fd supports O_NONBLOCK also.
On the kernel side, we have:

struct file *eventfd_fget(int fd);
int eventfd_signal(struct file *file, unsigned int n);

The eventfd_fget() should be called to get a struct file* from an eventfd
fd (this is an fget() + check of f_op being an eventfd fops pointer).
The kernel can then call eventfd_signal() every time it wants to post
an event to userspace. The eventfd_signal() function can be called from any
context.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.20.ep2/fs/Makefile
===================================================================
--- linux-2.6.20.ep2.orig/fs/Makefile	2007-03-12 11:27:58.000000000 -0700
+++ linux-2.6.20.ep2/fs/Makefile	2007-03-14 17:31:35.000000000 -0700
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o anon_inodes.o signalfd.o timerfd.o
+		stack.o anon_inodes.o signalfd.o timerfd.o eventfd.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.20.ep2/include/linux/syscalls.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/syscalls.h	2007-03-13 16:40:46.000000000 -0700
+++ linux-2.6.20.ep2/include/linux/syscalls.h	2007-03-14 19:31:56.000000000 -0700
@@ -605,6 +605,7 @@
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
 			    const struct itimerspec __user *utmr);
+asmlinkage long sys_eventfd(unsigned int count);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.20.ep2/fs/eventfd.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/fs/eventfd.c	2007-03-14 20:42:33.000000000 -0700
@@ -0,0 +1,259 @@
+/*
+ *  fs/eventfd.c
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
+#include <linux/eventfd.h>
+
+#include <asm/uaccess.h>
+
+
+
+struct eventfd_ctx {
+	spinlock_t lock;
+	wait_queue_head_t wqh;
+	__u64 count;
+};
+
+
+static void eventfd_cleanup(struct eventfd_ctx *ctx);
+static int eventfd_close(struct inode *inode, struct file *file);
+static unsigned int eventfd_poll(struct file *file, poll_table *wait);
+static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos);
+static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
+			     loff_t *ppos);
+
+
+
+static const struct file_operations eventfd_fops = {
+	.release	= eventfd_close,
+	.poll		= eventfd_poll,
+	.read		= eventfd_read,
+	.write		= eventfd_write,
+};
+static struct kmem_cache *eventfd_ctx_cachep;
+
+
+
+
+struct file *eventfd_fget(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &eventfd_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return file;
+}
+
+
+int eventfd_signal(struct file *file, unsigned int n)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	int res = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ULLONG_MAX - ctx->count <= n)
+		res = -EINVAL;
+	else
+		ctx->count += n;
+	if (waitqueue_active(&ctx->wqh))
+		wake_up_locked(&ctx->wqh);
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return res;
+}
+
+
+asmlinkage long sys_eventfd(unsigned int count)
+{
+	int error, fd;
+	struct eventfd_ctx *ctx;
+	struct file *file;
+	struct inode *inode;
+
+	ctx = kmem_cache_alloc(eventfd_ctx_cachep, GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	init_waitqueue_head(&ctx->wqh);
+	spin_lock_init(&ctx->lock);
+	ctx->count = count;
+
+	/*
+	 * When we call this, the initialization must be complete, since
+	 * aino_getfd() will install the fd.
+	 */
+	error = aino_getfd(&fd, &inode, &file, "[eventfd]",
+			   &eventfd_fops, ctx);
+	if (!error)
+		return fd;
+
+	eventfd_cleanup(ctx);
+	return error;
+}
+
+
+static void eventfd_cleanup(struct eventfd_ctx *ctx)
+{
+	kmem_cache_free(eventfd_ctx_cachep, ctx);
+}
+
+
+static int eventfd_close(struct inode *inode, struct file *file)
+{
+	eventfd_cleanup(file->private_data);
+	return 0;
+}
+
+
+static unsigned int eventfd_poll(struct file *file, poll_table *wait)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ctx->count > 0)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return events;
+}
+
+
+static ssize_t eventfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	__u64 ucnt;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ucnt))
+		return -EINVAL;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	ucnt = ctx->count;
+	if (ucnt > 0)
+		res = sizeof(ucnt);
+	else if (!(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ctx->count > 0) {
+				ucnt = ctx->count;
+				res = sizeof(ucnt);
+				break;
+			}
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			spin_unlock_irq(&ctx->lock);
+			schedule();
+			spin_lock_irq(&ctx->lock);
+		}
+		__remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (res > 0) {
+		ctx->count = 0;
+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked(&ctx->wqh);
+	}
+	spin_unlock_irq(&ctx->lock);
+	if (res > 0 && put_user(ucnt, (__u64 __user *) buf))
+		return -EFAULT;
+
+	return res;
+}
+
+
+static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
+			     loff_t *ppos)
+{
+	struct eventfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	__u64 ucnt;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ucnt))
+		return -EINVAL;
+	if (get_user(ucnt, (const __u64 __user *) buf))
+		return -EFAULT;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	if (ULLONG_MAX - ctx->count > ucnt)
+		res = sizeof(ucnt);
+	else if (!(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ULLONG_MAX - ctx->count > ucnt) {
+				res = sizeof(ucnt);
+				break;
+			}
+			if (signal_pending(current)) {
+				res = -ERESTARTSYS;
+				break;
+			}
+			spin_unlock_irq(&ctx->lock);
+			schedule();
+			spin_lock_irq(&ctx->lock);
+		}
+		__remove_wait_queue(&ctx->wqh, &wait);
+		__set_current_state(TASK_RUNNING);
+	}
+	if (res > 0) {
+		ctx->count += ucnt;
+		if (waitqueue_active(&ctx->wqh))
+			wake_up_locked(&ctx->wqh);
+	}
+	spin_unlock_irq(&ctx->lock);
+
+	return res;
+}
+
+
+static int __init eventfd_init(void)
+{
+	eventfd_ctx_cachep = kmem_cache_create("eventfd_ctx_cache",
+						sizeof(struct eventfd_ctx),
+						0, SLAB_PANIC, NULL, NULL);
+	return 0;
+}
+
+
+static void __exit eventfd_exit(void)
+{
+	kmem_cache_destroy(eventfd_ctx_cachep);
+}
+
+module_init(eventfd_init);
+module_exit(eventfd_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6.20.ep2/include/linux/eventfd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/include/linux/eventfd.h	2007-03-14 19:12:35.000000000 -0700
@@ -0,0 +1,18 @@
+/*
+ *  include/linux/eventfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_EVENTFD_H
+#define _LINUX_EVENTFD_H
+
+
+
+struct file *eventfd_fget(int fd);
+int eventfd_signal(struct file *file, unsigned int n);
+
+
+#endif /* _LINUX_EVENTFD_H */
+

