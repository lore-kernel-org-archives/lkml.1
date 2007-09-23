Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXIWWtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXIWWtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 18:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXIWWtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 18:49:12 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:44338 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbXIWWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 18:49:11 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Sep 2007 15:49:09 -0700
Subject: [patch 1/3] new timerfd API - new timerfd API
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.19354.1190587749.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the new timerfd API as it is implemented by the following patch:

int timerfd_create(int clockid);
int timerfd_settime(int ufd, int flags,
		    const struct itimerspec *utmr,
		    struct itimerspec *otmr);
int timerfd_gettime(int ufd, struct itimerspec *otmr);

The timerfd_create() API creates an un-programmed timerfd fd. The "clockid"
parameter can be either CLOCK_MONOTONIC or CLOCK_REALTIME.
The timerfd_settime() API give new settings by the timerfd fd, by optionally
retrieving the previous expiration time (in case the "otmr" parameter is not NULL).
The time value specified in "utmr" is absolute, if the TFD_TIMER_ABSTIME bit
is set in the "flags" parameter. Otherwise it's a relative time.
The timerfd_gettime() API returns the next expiration time of the timer, or {0, 0}
if the timerfd has not been set yet.
Like the previous timerfd API implementation, read(2) and poll(2) are supported
(with the same interface).
Here's a simple test program I used to exercise the new timerfd APIs:

http://www.xmailserver.org/timerfd-test2.c



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/compat.c              |   32 ++++++-
 fs/timerfd.c             |  199 ++++++++++++++++++++++++++++++-----------------
 include/linux/compat.h   |    7 +
 include/linux/syscalls.h |    7 +
 4 files changed, 168 insertions(+), 77 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2007-09-23 15:18:09.000000000 -0700
+++ linux-2.6.mod/fs/timerfd.c	2007-09-23 15:25:55.000000000 -0700
@@ -23,15 +23,17 @@
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
+	int clockid;
 	ktime_t tintv;
 	wait_queue_head_t wqh;
 	int expired;
+	u64 ticks;
 };
 
 /*
  * This gets called when the timer event triggers. We set the "expired"
  * flag, but we do not re-arm the timer (in case it's necessary,
- * tintv.tv64 != 0) until the timer is read.
+ * tintv.tv64 != 0) until the timer is accessed.
  */
 static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
 {
@@ -40,13 +42,14 @@
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	ctx->expired = 1;
+	ctx->ticks++;
 	wake_up_locked(&ctx->wqh);
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return HRTIMER_NORESTART;
 }
 
-static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			  const struct itimerspec *ktmr)
 {
 	enum hrtimer_mode htmode;
@@ -57,8 +60,9 @@
 
 	texp = timespec_to_ktime(ktmr->it_value);
 	ctx->expired = 0;
+	ctx->ticks = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
-	hrtimer_init(&ctx->tmr, clockid, htmode);
+	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
 	ctx->tmr.expires = texp;
 	ctx->tmr.function = timerfd_tmrproc;
 	if (texp.tv64 != 0)
@@ -83,7 +87,7 @@
 	poll_wait(file, &ctx->wqh, wait);
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	if (ctx->expired)
+	if (ctx->ticks)
 		events |= POLLIN;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
@@ -102,11 +106,11 @@
 		return -EINVAL;
 	spin_lock_irq(&ctx->wqh.lock);
 	res = -EAGAIN;
-	if (!ctx->expired && !(file->f_flags & O_NONBLOCK)) {
+	if (!ctx->ticks && !(file->f_flags & O_NONBLOCK)) {
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (ctx->expired) {
+			if (ctx->ticks) {
 				res = 0;
 				break;
 			}
@@ -121,22 +125,23 @@
 		__remove_wait_queue(&ctx->wqh, &wait);
 		__set_current_state(TASK_RUNNING);
 	}
-	if (ctx->expired) {
-		ctx->expired = 0;
-		if (ctx->tintv.tv64 != 0) {
+	if (ctx->ticks) {
+		ticks = ctx->ticks;
+		if (ctx->expired && ctx->tintv.tv64) {
 			/*
 			 * If tintv.tv64 != 0, this is a periodic timer that
 			 * needs to be re-armed. We avoid doing it in the timer
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks = (u64)
+			ticks += (u64)
 				hrtimer_forward(&ctx->tmr,
 						hrtimer_cb_get_time(&ctx->tmr),
-						ctx->tintv);
+						ctx->tintv) - 1;
 			hrtimer_restart(&ctx->tmr);
-		} else
-			ticks = 1;
+		}
+		ctx->expired = 0;
+		ctx->ticks = 0;
 	}
 	spin_unlock_irq(&ctx->wqh.lock);
 	if (ticks)
@@ -150,76 +155,134 @@
 	.read		= timerfd_read,
 };
 
-asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr)
+static struct file *timerfd_fget(int fd)
+{
+	struct file *file;
+
+	file = fget(fd);
+	if (!file)
+		return ERR_PTR(-EBADF);
+	if (file->f_op != &timerfd_fops) {
+		fput(file);
+		return ERR_PTR(-EINVAL);
+	}
+	return file;
+}
+
+asmlinkage long sys_timerfd_create(int clockid)
 {
-	int error;
+	int error, ufd;
 	struct timerfd_ctx *ctx;
 	struct file *file;
 	struct inode *inode;
-	struct itimerspec ktmr;
-
-	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
-		return -EFAULT;
 
 	if (clockid != CLOCK_MONOTONIC &&
 	    clockid != CLOCK_REALTIME)
 		return -EINVAL;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	init_waitqueue_head(&ctx->wqh);
+	ctx->clockid = clockid;
+	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
+
+	error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
+				 &timerfd_fops, ctx);
+	if (error)
+		goto err_kfree_ctx;
+
+	return ufd;
+
+err_kfree_ctx:
+	kfree(ctx);
+	return error;
+}
+
+asmlinkage long sys_timerfd_settime(int ufd, int flags,
+				    const struct itimerspec __user *utmr,
+				    struct itimerspec __user *otmr)
+{
+	struct file *file;
+	struct timerfd_ctx *ctx;
+	struct itimerspec ktmr, kotmr;
+
+	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
+		return -EFAULT;
+
 	if (!timespec_valid(&ktmr.it_value) ||
 	    !timespec_valid(&ktmr.it_interval))
 		return -EINVAL;
 
-	if (ufd == -1) {
-		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
-		if (!ctx)
-			return -ENOMEM;
-
-		init_waitqueue_head(&ctx->wqh);
-
-		timerfd_setup(ctx, clockid, flags, &ktmr);
-
-		/*
-		 * When we call this, the initialization must be complete, since
-		 * anon_inode_getfd() will install the fd.
-		 */
-		error = anon_inode_getfd(&ufd, &inode, &file, "[timerfd]",
-					 &timerfd_fops, ctx);
-		if (error)
-			goto err_tmrcancel;
-	} else {
-		file = fget(ufd);
-		if (!file)
-			return -EBADF;
-		ctx = file->private_data;
-		if (file->f_op != &timerfd_fops) {
-			fput(file);
-			return -EINVAL;
-		}
-		/*
-		 * We need to stop the existing timer before reprogramming
-		 * it to the new values.
-		 */
-		for (;;) {
-			spin_lock_irq(&ctx->wqh.lock);
-			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
-				break;
-			spin_unlock_irq(&ctx->wqh.lock);
-			cpu_relax();
-		}
-		/*
-		 * Re-program the timer to the new value ...
-		 */
-		timerfd_setup(ctx, clockid, flags, &ktmr);
-
+	file = timerfd_fget(ufd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ctx = file->private_data;
+
+	/*
+	 * We need to stop the existing timer before reprogramming
+	 * it to the new values.
+	 */
+	for (;;) {
+		spin_lock_irq(&ctx->wqh.lock);
+		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+			break;
 		spin_unlock_irq(&ctx->wqh.lock);
-		fput(file);
+		cpu_relax();
 	}
 
-	return ufd;
+	/*
+	 * If the timer is expired and it's periodic, we need to advance it
+	 * because the caller may want to know the previous expiration time.
+	 * We do not update "ticks" and "expired" since the timer will be
+	 * re-programmed again in the following timerfd_setup() call.
+	 */
+	if (ctx->expired && ctx->tintv.tv64)
+		hrtimer_forward(&ctx->tmr, hrtimer_cb_get_time(&ctx->tmr),
+				ctx->tintv);
+
+	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
+
+	/*
+	 * Re-program the timer to the new value ...
+	 */
+	timerfd_setup(ctx, flags, &ktmr);
 
-err_tmrcancel:
-	hrtimer_cancel(&ctx->tmr);
-	kfree(ctx);
-	return error;
+	spin_unlock_irq(&ctx->wqh.lock);
+	fput(file);
+	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
+		return -EFAULT;
+
+	return 0;
+}
+
+asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr)
+{
+	struct file *file;
+	struct timerfd_ctx *ctx;
+	struct itimerspec kotmr;
+
+	file = timerfd_fget(ufd);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ctx = file->private_data;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	if (ctx->expired && ctx->tintv.tv64) {
+		ctx->expired = 0;
+		ctx->ticks += (u64)
+			hrtimer_forward(&ctx->tmr,
+					hrtimer_cb_get_time(&ctx->tmr),
+					ctx->tintv) - 1;
+		hrtimer_restart(&ctx->tmr);
+	}
+	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+	fput(file);
+
+	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
 }
 
Index: linux-2.6.mod/include/linux/syscalls.h
===================================================================
--- linux-2.6.mod.orig/include/linux/syscalls.h	2007-09-23 15:18:09.000000000 -0700
+++ linux-2.6.mod/include/linux/syscalls.h	2007-09-23 15:18:13.000000000 -0700
@@ -607,8 +607,11 @@
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
-asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr);
+asmlinkage long sys_timerfd_create(int clockid);
+asmlinkage long sys_timerfd_settime(int ufd, int flags,
+				    const struct itimerspec __user *utmr,
+				    struct itimerspec __user *otmr);
+asmlinkage long sys_timerfd_gettime(int ufd, struct itimerspec __user *otmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
 
Index: linux-2.6.mod/fs/compat.c
===================================================================
--- linux-2.6.mod.orig/fs/compat.c	2007-09-23 15:18:09.000000000 -0700
+++ linux-2.6.mod/fs/compat.c	2007-09-23 15:18:13.000000000 -0700
@@ -2210,19 +2210,41 @@
 
 #ifdef CONFIG_TIMERFD
 
-asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
-				   const struct compat_itimerspec __user *utmr)
+asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
+				   const struct compat_itimerspec __user *utmr,
+				   struct compat_itimerspec __user *otmr)
 {
+	int error;
 	struct itimerspec t;
 	struct itimerspec __user *ut;
 
 	if (get_compat_itimerspec(&t, utmr))
 		return -EFAULT;
-	ut = compat_alloc_user_space(sizeof(*ut));
-	if (copy_to_user(ut, &t, sizeof(t)))
+	ut = compat_alloc_user_space(2 * sizeof(struct itimerspec));
+	if (copy_to_user(&ut[0], &t, sizeof(t)))
 		return -EFAULT;
+	error = sys_timerfd_settime(ufd, flags, &ut[0], &ut[1]);
+	if (!error && otmr)
+		error = (copy_from_user(&t, &ut[1], sizeof(struct itimerspec)) ||
+			 put_compat_itimerspec(otmr, &t)) ? -EFAULT: 0;
 
-	return sys_timerfd(ufd, clockid, flags, ut);
+	return error;
+}
+
+asmlinkage long compat_sys_timerfd_gettime(int ufd,
+				   struct compat_itimerspec __user *otmr)
+{
+	int error;
+	struct itimerspec t;
+	struct itimerspec __user *ut;
+
+	ut = compat_alloc_user_space(sizeof(struct itimerspec));
+	error = sys_timerfd_gettime(ufd, ut);
+	if (!error)
+		error = (copy_from_user(&t, ut, sizeof(struct itimerspec)) ||
+			 put_compat_itimerspec(otmr, &t)) ? -EFAULT: 0;
+
+	return error;
 }
 
 #endif /* CONFIG_TIMERFD */
Index: linux-2.6.mod/include/linux/compat.h
===================================================================
--- linux-2.6.mod.orig/include/linux/compat.h	2007-09-23 15:18:09.000000000 -0700
+++ linux-2.6.mod/include/linux/compat.h	2007-09-23 15:18:13.000000000 -0700
@@ -264,8 +264,11 @@
 asmlinkage long compat_sys_signalfd(int ufd,
 				const compat_sigset_t __user *sigmask,
                                 compat_size_t sigsetsize);
-asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
-				const struct compat_itimerspec __user *utmr);
+asmlinkage long compat_sys_timerfd_settime(int ufd, int flags,
+				   const struct compat_itimerspec __user *utmr,
+				   struct compat_itimerspec __user *otmr);
+asmlinkage long compat_sys_timerfd_gettime(int ufd,
+				   struct compat_itimerspec __user *otmr);
 
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */

