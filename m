Return-Path: <linux-kernel-owner+w=401wt.eu-S966032AbXDBWs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966032AbXDBWs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966002AbXDBWrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:47:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50533 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966038AbXDBWqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:46:36 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 02 Apr 2007 15:46:31 -0700
Subject: [patch 6/13] signal/timer/event fds v10 - timerfd core ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.10599.1175553994.6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog:

v10 - Renamed from "aino" to "anon_inode"
    - Prevented DoS by re-arming the timer on read (Thomas Gleixner)

--
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



Index: linux-2.6.21-rc5.fds/fs/timerfd.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc5.fds/fs/timerfd.c	2007-04-02 15:06:37.000000000 -0700
@@ -0,0 +1,233 @@
+/*
+ *  fs/timerfd.c
+ *
+ *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *
+ *
+ *  Thanks to Thomas Gleixner for code reviews and useful comments.
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
+struct timerfd_ctx {
+	struct hrtimer tmr;
+	ktime_t tintv;
+	spinlock_t lock;
+	wait_queue_head_t wqh;
+	int expired;
+};
+
+/*
+ * This gets called when the timer event triggers. We set the "expired"
+ * flag, but we do not re-arm the timer (in case it's necessary,
+ * tintv.tv64 != 0) until the timer is read.
+ */
+static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
+{
+	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->expired = 1;
+	wake_up_locked(&ctx->wqh);
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return HRTIMER_NORESTART;
+}
+
+static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+			  const struct itimerspec *ktmr)
+{
+	enum hrtimer_mode htmode;
+	ktime_t texp;
+
+	htmode = (flags & TFD_TIMER_ABSTIME) ?
+		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
+
+	texp = timespec_to_ktime(ktmr->it_value);
+	ctx->expired = 0;
+	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
+	hrtimer_init(&ctx->tmr, clockid, htmode);
+	ctx->tmr.expires = texp;
+	ctx->tmr.function = timerfd_tmrproc;
+	if (texp.tv64 != 0)
+		hrtimer_start(&ctx->tmr, texp, htmode);
+}
+
+static int timerfd_release(struct inode *inode, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+
+	hrtimer_cancel(&ctx->tmr);
+	kfree(ctx);
+	return 0;
+}
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
+	if (ctx->expired)
+		events |= POLLIN;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	return events;
+}
+
+static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
+			    loff_t *ppos)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	ssize_t res;
+	u32 ticks = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (count < sizeof(ticks))
+		return -EINVAL;
+	spin_lock_irq(&ctx->lock);
+	res = -EAGAIN;
+	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
+		__add_wait_queue(&ctx->wqh, &wait);
+		for (res = 0;;) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (ctx->expired) {
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
+	if (ctx->expired) {
+		ctx->expired = 0;
+		if (ctx->tintv.tv64 != 0) {
+			/*
+			 * If tintv.tv64 != 0, this is a periodic timer that
+			 * needs to be re-armed. We avoid doing it in the timer
+			 * callback to avoid DoS attacks specifying a very
+			 * short timer period.
+			 */
+			ticks = (u32)
+				hrtimer_forward(&ctx->tmr,
+						hrtimer_cb_get_time(&ctx->tmr),
+						ctx->tintv);
+			hrtimer_restart(&ctx->tmr);
+		} else
+			ticks = 1;
+	}
+	spin_unlock_irq(&ctx->lock);
+	if (ticks)
+		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
+	return res;
+}
+
+static const struct file_operations timerfd_fops = {
+	.release	= timerfd_release,
+	.poll		= timerfd_poll,
+	.read		= timerfd_read,
+};
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
+		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
+		if (!ctx)
+			return -ENOMEM;
+
+		init_waitqueue_head(&ctx->wqh);
+		spin_lock_init(&ctx->lock);
+
+		timerfd_setup(ctx, clockid, flags, &ktmr);
+
+		/*
+		 * When we call this, the initialization must be complete, since
+		 * anon_inode_getfd() will install the fd.
+		 */
+		error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
+					 &timerfd_fops, ctx);
+		if (error)
+			goto err_tmrcancel;
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
+		timerfd_setup(ctx, clockid, flags, &ktmr);
+
+		spin_unlock_irq(&ctx->lock);
+		fput(file);
+	}
+
+	return ufd;
+
+err_tmrcancel:
+	hrtimer_cancel(&ctx->tmr);
+	kfree(ctx);
+	return error;
+}
+
Index: linux-2.6.21-rc5.fds/include/linux/timerfd.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc5.fds/include/linux/timerfd.h	2007-04-02 15:06:37.000000000 -0700
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
Index: linux-2.6.21-rc5.fds/include/linux/syscalls.h
===================================================================
--- linux-2.6.21-rc5.fds.orig/include/linux/syscalls.h	2007-04-02 15:06:29.000000000 -0700
+++ linux-2.6.21-rc5.fds/include/linux/syscalls.h	2007-04-02 15:06:37.000000000 -0700
@@ -603,6 +603,8 @@
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
+asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
+			    const struct itimerspec __user *utmr);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
Index: linux-2.6.21-rc5.fds/fs/Makefile
===================================================================
--- linux-2.6.21-rc5.fds.orig/fs/Makefile	2007-04-02 15:06:29.000000000 -0700
+++ linux-2.6.21-rc5.fds/fs/Makefile	2007-04-02 15:06:37.000000000 -0700
@@ -24,6 +24,7 @@
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-$(CONFIG_ANON_INODES)	+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
+obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
Index: linux-2.6.21-rc5.fds/init/Kconfig
===================================================================
--- linux-2.6.21-rc5.fds.orig/init/Kconfig	2007-04-02 15:06:29.000000000 -0700
+++ linux-2.6.21-rc5.fds/init/Kconfig	2007-04-02 15:06:37.000000000 -0700
@@ -483,6 +483,16 @@
 
 	  If unsure, say Y.
 
+config TIMERFD
+	bool "Enable timerfd() system call" if EMBEDDED
+	depends on ANON_INODES
+	default y
+	help
+	  Enable the timerfd() system call that allows to receive timer
+	  events on a file descriptor.
+
+	  If unsure, say Y.
+
 config SHMEM
 	bool "Use full shmem filesystem" if EMBEDDED
 	default y

