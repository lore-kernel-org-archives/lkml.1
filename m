Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbXIVVIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbXIVVIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbXIVVHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 17:07:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59394 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbXIVVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 17:07:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 22 Sep 2007 14:07:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: Ulrich Drepper <drepper@redhat.com>, geoff@gclare.org.uk,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@xenotime.net>,
       vda.linux@googlemail.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       =?X-UNKNOWN?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Subject: Re: RFC: A revised timerfd API
In-Reply-To: <46F514C9.5010208@gmx.net>
Message-ID: <Pine.LNX.4.64.0709221359190.22085@alien.or.mcafeemobile.com>
References: <46EF7DDA.2070401@gmx.net> <Pine.LNX.4.64.0709180936480.22956@alien.or.mcafeemobile.com>
 <46F514C9.5010208@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2007, Michael Kerrisk wrote:

> So I'm inclined to implement option (b), unless someone has strong
> objections.  Davide, could I persuade you to help?

I guess I better do, otherwise you'll continue to stress me ;)

int timerfd_create(int clockid);
int timerfd_settime(int ufd, int flags,
                    const struct itimerspec *utmr,
                    struct itimerspec *otmr);
int timerfd_gettime(int ufd, struct itimerspec *otmr);

Patch below. Builds, not tested yet (you need to remove the "broken" 
status from CONFIG_TIMERFD in case you want to test - and plug the new 
syscall to arch/xxx).
May that work for you?
Thomas-san, hrtimer_try_to_cancel() does not touch ->expires and I assume
it'll never do, granted?



- Davide



---
 fs/compat.c              |   32 ++++++++--
 fs/timerfd.c             |  144 +++++++++++++++++++++++++++++------------------
 include/linux/compat.h   |    7 +-
 include/linux/syscalls.h |    7 +-
 4 files changed, 126 insertions(+), 64 deletions(-)

Index: linux-2.6.mod/fs/timerfd.c
===================================================================
--- linux-2.6.mod.orig/fs/timerfd.c	2007-09-22 12:22:19.000000000 -0700
+++ linux-2.6.mod/fs/timerfd.c	2007-09-22 13:21:21.000000000 -0700
@@ -23,6 +23,7 @@
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
+	int clockid;
 	ktime_t tintv;
 	wait_queue_head_t wqh;
 	int expired;
@@ -46,7 +47,7 @@
 	return HRTIMER_NORESTART;
 }
 
-static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
+static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			  const struct itimerspec *ktmr)
 {
 	enum hrtimer_mode htmode;
@@ -58,7 +59,7 @@
 	texp = timespec_to_ktime(ktmr->it_value);
 	ctx->expired = 0;
 	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
-	hrtimer_init(&ctx->tmr, clockid, htmode);
+	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
 	ctx->tmr.expires = texp;
 	ctx->tmr.function = timerfd_tmrproc;
 	if (texp.tv64 != 0)
@@ -150,76 +151,109 @@
 	.read		= timerfd_read,
 };
 
-asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr)
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
+	file = fget(ufd);
+	if (!file)
+		return -EBADF;
+	ctx = file->private_data;
+	if (file->f_op != &timerfd_fops) {
+		fput(file);
+		return -EINVAL;
+	}
 
+	/*
+	 * We need to stop the existing timer before reprogramming
+	 * it to the new values.
+	 */
+	for (;;) {
+		spin_lock_irq(&ctx->wqh.lock);
+		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+			break;
 		spin_unlock_irq(&ctx->wqh.lock);
+		cpu_relax();
+	}
+
+	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
+
+	/*
+	 * Re-program the timer to the new value ...
+	 */
+	timerfd_setup(ctx, flags, &ktmr);
+
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
+	file = fget(ufd);
+	if (!file)
+		return -EBADF;
+	ctx = file->private_data;
+	if (file->f_op != &timerfd_fops) {
 		fput(file);
+		return -EINVAL;
 	}
 
-	return ufd;
+	spin_lock_irq(&ctx->wqh.lock);
+	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+	fput(file);
 
-err_tmrcancel:
-	hrtimer_cancel(&ctx->tmr);
-	kfree(ctx);
-	return error;
+	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
 }
 
Index: linux-2.6.mod/include/linux/syscalls.h
===================================================================
--- linux-2.6.mod.orig/include/linux/syscalls.h	2007-09-22 12:23:08.000000000 -0700
+++ linux-2.6.mod/include/linux/syscalls.h	2007-09-22 13:08:49.000000000 -0700
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
--- linux-2.6.mod.orig/fs/compat.c	2007-09-22 13:31:41.000000000 -0700
+++ linux-2.6.mod/fs/compat.c	2007-09-22 13:47:02.000000000 -0700
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
--- linux-2.6.mod.orig/include/linux/compat.h	2007-09-22 13:47:57.000000000 -0700
+++ linux-2.6.mod/include/linux/compat.h	2007-09-22 13:48:41.000000000 -0700
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
