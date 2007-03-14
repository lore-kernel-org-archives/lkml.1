Return-Path: <linux-kernel-owner+w=401wt.eu-S1422626AbXCNW1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422626AbXCNW1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933282AbXCNWZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:25:12 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42396 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbXCNWY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:24:26 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 14 Mar 2007 15:19:21 -0700
Subject: [patch 6/13] signalfd/timerfd/asyncfd v5 - timerfd core ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.13805.1173910766.6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new system call for timers events delivered
though file descriptors. This allows timer event to be used with
standard POSIX poll(2), select(2) and read(2). As a consequence of
supporting the Linux f_op->poll subsystem, they can be used with
epoll(2) too.
The system call is defined as:

int timerfd(int ufd, int clockid, int flags, const struct itimerspec *utmr);

The "ufd" parameter allows for re-use (re-programming) of an existing
timerfd w/out going through the close/open cycle (same as signalfd).
If "ufd" is -1, s new file descriptor will be created, otherwise the
existing "ufd" will be re-programmed.
The "clockid" parameter is either CLOCK_MONOTONIC or CLOCK_REALTIME.
The time specified in the "utmr->it_value" parameter is the expiry
time for the timer.
If the TFD_TIMER_ABSTIME flag is set in "flags", this is an absolute
time, otherwise it's a relative time.
If the time specified in the "utmr->it_interval" is not zero (.tv_sec == 0,
tv_nsec == 0), this is the period at which the following ticks should
be generated.
The "utmr->it_interval" should be set to zero if only one tick is requested.
Setting the "utmr->it_value" to zero will disable the timer, or will create
a timerfd without the timer enabled.
The function returns the new (or same, in case "ufd" is a valid timerfd
descriptor) file, or -1 in case of error.
As stated before, the timerfd file descriptor supports poll(2), select(2)
and epoll(2). When a timer event happened on the timerfd, a POLLIN mask
will be returned.
The read(2) call can be used, and it will return a u32 variable holding
the number of "ticks" that happened on the interface since the last call
to read(2). The read(2) call supportes the O_NONBLOCK flag too, and EAGAIN
will be returned if no ticks happened.
A quick test program, shows timerfd working correctly on my amd64 box:

http://www.xmailserver.org/timerfd-test.c




Signed-off-by: Davide Libenzi <davidel@xmailserver.org>



- Davide



Index: linux-2.6.20.ep2/fs/timerfd.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/fs/timerfd.c	2007-03-12 11:47:01.000000000 -0700
@@ -0,0 +1,273 @@
+/*
+ *  fs/timerfd.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *
+ *  Thanks to Thomas Gleixner for code review and useful comments.
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
+#include <linux/signal.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/jiffies.h>
+#include <linux/anon_inodes.h>
+#include <linux/timerfd.h>
+
+#include <asm/uaccess.h>
+
+
+
+struct timerfd_ctx {
+	struct hrtimer tmr;
+	int clockid;
+	int flags;
+	ktime_t texp, tintv;
+	spinlock_t lock;
+	wait_queue_head_t wqh;
+	unsigned long ticks;
+};
+
+
+static int timerfd_tmrproc(struct hrtimer *htmr);
+static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+			 const struct itimerspec *ktmr);
+static void timerfd_cleanup(struct timerfd_ctx *ctx);
+static int timerfd_close(struct inode *inode, struct file *file);
+static unsigned int timerfd_poll(struct file *file, poll_table *wait);
+static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos);
+
+
+
+static const struct file_operations timerfd_fops = {
+	.release	= timerfd_close,
+	.poll		= timerfd_poll,
+	.read		= timerfd_read,
+};
+static struct kmem_cache *timerfd_ctx_cachep;
+
+
+
+static int timerfd_tmrproc(struct hrtimer *htmr)
+{
+	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
+	int rval = HRTIMER_NORESTART;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->ticks++;
+	wake_up_locked(&ctx->wqh);
+	if (ctx->tintv.tv64 != 0) {
+		hrtimer_forward(htmr, htmr->base->softirq_time, ctx->tintv);
+		rval = HRTIMER_RESTART;
+	}
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return rval;
+}
+
+
+static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+			 const struct itimerspec *ktmr)
+{
+	enum hrtimer_mode htmode;
+
+	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_ABS: HRTIMER_REL;
+
+	ctx->ticks = 0;
+	ctx->clockid = clockid;
+	ctx->flags = flags;
+	ctx->texp = timespec_to_ktime(ktmr->it_value);
+	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
+	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
+	ctx->tmr.expires = ctx->texp;
+	ctx->tmr.function = timerfd_tmrproc;
+	if (ctx->texp.tv64 != 0)
+		hrtimer_start(&ctx->tmr, ctx->texp, htmode);
+
+	return 0;
+}
+
+
+asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
+			    const struct itimerspec __user *utmr)
+{
+	int error;
+	struct timerfd_ctx *ctx;
+	struct file *file;
+	struct inode *inode;
+	struct itimerspec ktmr;
+
+	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
+		return -EFAULT;
+
+	if (clockid != CLOCK_MONOTONIC &&
+	    clockid != CLOCK_REALTIME)
+		return -EINVAL;
+	if (!timespec_valid(&ktmr.it_value) ||
+	    !timespec_valid(&ktmr.it_interval))
+		return -EINVAL;
+
+	if (ufd == -1) {
+		ctx = kmem_cache_alloc(timerfd_ctx_cachep, GFP_KERNEL);
+		if (!ctx)
+			return -ENOMEM;
+
+		init_waitqueue_head(&ctx->wqh);
+		spin_lock_init(&ctx->lock);
+		ctx->clockid = -1;
+
+		error = timerfd_setup(ctx, clockid, flags, &ktmr);
+		if (error)
+			goto err_ctxfree;
+
+		/*
+		 * When we call this, the initialization must be complete, since
+		 * aino_getfd() will install the fd.
+		 */
+		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
+				   &timerfd_fops, ctx);
+		if (error)
+			goto err_ctxfree;
+	} else {
+		file = fget(ufd);
+		if (!file)
+			return -EBADF;
+		ctx = file->private_data;
+		if (file->f_op != &timerfd_fops) {
+			fput(file);
+			return -EINVAL;
+		}
+		/*
+		 * We need to stop the existing timer before reprogramming
+		 * it to the new values.
+		 */
+		for (;;) {
+			spin_lock_irq(&ctx->lock);
+			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+				break;
+			spin_unlock_irq(&ctx->lock);
+			cpu_relax();
+		}
+		/*
+		 * Re-program the timer to the new value ...
+		 */
+		error = timerfd_setup(ctx, clockid, flags, &ktmr);
+
+		spin_unlock_irq(&ctx->lock);
+		fput(file);
+		if (error)
+			return error;
+	}
+
+	return ufd;
+
+err_ctxfree:
+	timerfd_cleanup(ctx);
+	return error;
+}
+
+
+static void timerfd_cleanup(struct timerfd_ctx *ctx)
+{
+	if (ctx->clockid >= 0)
+		hrtimer_cancel(&ctx->tmr);
+	kmem_cache_free(timerfd_ctx_cachep, ctx);
+}
+
+
+static int timerfd_close(struct inode *inode, struct file *file)
+{
+	timerfd_cleanup(file->private_data);
+	return 0;
+}
+
+
+static unsigned int timerfd_poll(struct file *file, poll_table *wait)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	unsigned int events = 0;
+	unsigned long flags;
+
+	poll_wait(file, &ctx->wqh, wait);
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ctx->ticks)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return events;
+}
+
+
+static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	u32 ticks;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ticks))
+		return -EINVAL;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	if ((ticks = (u32) ctx->ticks) == 0 &&
+	    !(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if ((ticks = (u32) ctx->ticks) != 0) {
+				res = 0;
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
+	if (ticks)
+		ctx->ticks = 0;
+	spin_unlock_irq(&ctx->lock);
+	if (ticks)
+		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+	return res;
+}
+
+
+static int __init timerfd_init(void)
+{
+	timerfd_ctx_cachep = kmem_cache_create("timerfd_ctx_cache",
+						sizeof(struct timerfd_ctx),
+						0, SLAB_PANIC, NULL, NULL);
+	return 0;
+}
+
+
+static void __exit timerfd_exit(void)
+{
+	kmem_cache_destroy(timerfd_ctx_cachep);
+}
+
+module_init(timerfd_init);
+module_exit(timerfd_exit);
+
+MODULE_LICENSE("GPL");
Index: linux-2.6.20.ep2/include/linux/timerfd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20.ep2/include/linux/timerfd.h	2007-03-11 17:05:37.000000000 -0700
@@ -0,0 +1,17 @@
+/*
+ *  include/linux/timerfd.h
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ */
+
+#ifndef _LINUX_TIMERFD_H
+#define _LINUX_TIMERFD_H
+
+
+#define TFD_TIMER_ABSTIME (1 << 0)
+
+
+
+#endif /* _LINUX_TIMERFD_H */
+
Index: linux-2.6.20.ep2/fs/Makefile
===================================================================
--- linux-2.6.20.ep2.orig/fs/Makefile	2007-03-11 14:28:37.000000000 -0700
+++ linux-2.6.20.ep2/fs/Makefile	2007-03-12 11:27:58.000000000 -0700
@@ -11,7 +11,7 @@
 		attr.o bad_inode.o file.o filesystems.o namespace.o aio.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o anon_inodes.o signalfd.o
+		stack.o anon_inodes.o signalfd.o timerfd.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
Index: linux-2.6.20.ep2/include/linux/syscalls.h
===================================================================
--- linux-2.6.20.ep2.orig/include/linux/syscalls.h	2007-03-11 14:28:37.000000000 -0700
+++ linux-2.6.20.ep2/include/linux/syscalls.h	2007-03-11 17:04:48.000000000 -0700
@@ -603,6 +603,8 @@
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
+asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
+			    const struct itimerspec __user *utmr);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 

