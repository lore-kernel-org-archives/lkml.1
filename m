Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXHIVOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXHIVOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbXHIVNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:13:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:45043 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752079AbXHIVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:13:49 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1+Y068xBweYl3SRILJTWD09nvfjBLo0GAC6jPcDx+
	AeOn9YVR3Q2RK+
Message-ID: <46BB8311.6040702@gmx.net>
Date: Thu, 09 Aug 2007 23:11:45 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Michael Kerrisk <mtk-manpages@gmx.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org, Christoph Hellwig <hch@lst.de>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jan Engelhardt <jengelh@computergmbh.de>, mtk@google.com
Subject: [PATCH] Revised timerfd() interface
References: <46A44B7D.3030700@gmx.net>	<20070722233826.20efa6e5.akpm@linux-foundation.org>	<46A7940B.4070901@gmx.net> <20070725151252.8d2d5141.akpm@linux-foundation.org> <46B81745.9010409@gmx.net>
In-Reply-To: <46B81745.9010409@gmx.net>
Content-Type: multipart/mixed;
 boundary="------------040507070104000103040608"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040507070104000103040608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew,

Here's my first shot at changing the timerfd() interface; patch
is against 2.6.23-rc1-mm2.

I think I got to the bottom of understanding the timer code in
the end, but I may still have missed some things...

This is my first kernel patch of any substance.  Perhaps Randy
or Christoph can give my toes a light toasting for the various
boobs I've likely made.

Thomas, would you please look over this patch to verify my
timer code?

Davide: would you please bless this interface change ;-).
It makes it possible to:

1) Fetch the previous timer settings (i.e., interval, and time
   remaining until next expiration) while installing new settings

2) Retrieve the settings of an existing timer without changing
   the timer.

Both of these features are supported by the older Unix timer APIs
(setitimer/getitimer and timer_create/timer_settime/timer_gettime).

The changes are as follows:

a) A further argument, outmr, can be used to retrieve the interval
   and time remaining before the expiration of a previously created
   timer.  Thus the call signature is now:

   timerfd(int utmr, int clockid, int flags,
           struct itimerspec *utmr,
           struct itimerspec *outmr)

   The outmr argument:

   1) must be NULL for a new timer (ufd == -1).
   2) can be NULL if we are updating an existing
      timer (i.e., utmr != NULL), but we are not
      interested in the previous timer value.
   3) can be used to retrieve the time until next timer
      expiration, without changing the timer.
      (In this case, utmr == NULL and ufd >= 0.)

b) Make the 'clockid' immutable: it can only be set
   if 'ufd' is -1 -- that is, on the timerfd() call that
   first creates a timer.  (This is effectively
   the limitation that is imposed by POSIX timers: the
   clockid is specified when the timer is created with
   timer_create(), and can't be changed.)

   [In the 2.6.22 interface, the clockid of an existing
   timer can be changed with a further call to timerfd()
   that specifies the file descriptor of an existing timer.]

The use cases are as follows:

ufd = timerfd(-1, clockid, flags, utmr, NULL);
to create a new timer with given clockid, flags, and utmr (initial
expiration + interval).  outmr must be NULL.

ufd = timerfd(ufd, -1, flags, utmr, NULL);
to change the flags and timer settings of an existing timer.
(The clockid argument serves no purpose when modifying an
existing timer, and as I've implemented things, the argument
must be specified as -1 for an existing timer.)

ufd = timerfd(ufd, -1, flags, utmr, &outmr);
to change the flags and timer settings of an existing timer, and
retrieve the time until the next expiration of the timer (and
the associated interval).

ufd = timerfd(ufd, -1, 0, NULL, &outmr);
Return the time until the next expiration of the timer (and the
associated interval), without changing the existing timer settings.
The flags argument has no meaning in this case, and must be
specified as 0.

Other changes:

* I've added checks for various combinations of arguments values
  that could be deemed invalid; there is probably room for debate
  about whether we want all of these checks.  Comments in the
  patch describe these checks.

* Appropriate, and possibly even correct, changes made in fs/compat.c.

* Jan Engelhardt noted that a cast could be removed from Davide's
  original code; I've removed it.

The changes are correct as far as I've tested them.  I've attached a
test program.  Davide, could you subject this to further test please?

I'm off on holiday the day after tomorrow, back in two weeks, with
very limited computer access.  I may have time for another pass of
the code if comments come in over(euro)night, otherwise Davide may
be willing to clean up whatever I messed up...

Cheers,

Michael

diff -ruN linux-2.6.23-rc1-mm2-orig/fs/compat.c linux-2.6.23-rc1-mm2/fs/compat.c
--- linux-2.6.23-rc1-mm2-orig/fs/compat.c	2007-08-05 10:43:30.000000000 +0200
+++ linux-2.6.23-rc1-mm2/fs/compat.c	2007-08-07 22:08:15.000000000 +0200
@@ -2211,18 +2211,38 @@
 #ifdef CONFIG_TIMERFD

 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
-				   const struct compat_itimerspec __user *utmr)
+			 const struct compat_itimerspec __user *utmr,
+			 struct compat_itimerspec __user *old_utmr)
 {
 	struct itimerspec t;
 	struct itimerspec __user *ut;
+	long ret;

-	if (get_compat_itimerspec(&t, utmr))
-		return -EFAULT;
-	ut = compat_alloc_user_space(sizeof(*ut));
-	if (copy_to_user(ut, &t, sizeof(t)))
-		return -EFAULT;
+	/*:mtk: Framework taken from compat_sys_mq_getsetattr() */

-	return sys_timerfd(ufd, clockid, flags, ut);
+	ut = compat_alloc_user_space(2 * sizeof(*ut));
+
+	if (utmr) {
+		if (get_compat_itimerspec(&t, utmr))
+			return -EFAULT;
+		if (copy_to_user(ut, &t, sizeof(t)))
+			return -EFAULT;
+	}
+
+	ret = sys_timerfd(ufd, clockid, flags,
+			utmr ? ut : NULL,
+			old_utmr ? ut + 1 : NULL);
+
+	if (ret)
+		return ret;
+
+	if (old_utmr) {
+	    	if (copy_from_user(&t, old_ut, sizeof(t)) ||
+		    put_compat_itimerspec(&t, old_utmr))
+			return -EFAULT;
+	}
+
+	return 0;
 }

 #endif /* CONFIG_TIMERFD */
diff -ruN linux-2.6.23-rc1-mm2-orig/fs/timerfd.c linux-2.6.23-rc1-mm2/fs/timerfd.c
--- linux-2.6.23-rc1-mm2-orig/fs/timerfd.c	2007-08-05 10:44:24.000000000 +0200
+++ linux-2.6.23-rc1-mm2/fs/timerfd.c	2007-08-09 22:11:25.000000000 +0200
@@ -2,6 +2,8 @@
  *  fs/timerfd.c
  *
  *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
+ *  and Copyright (C) 2007 Google, Inc.
+ *      (Author: Michael Kerrisk <mtk@google.com>)
  *
  *
  *  Thanks to Thomas Gleixner for code reviews and useful comments.
@@ -26,6 +28,12 @@
 	ktime_t tintv;
 	wait_queue_head_t wqh;
 	int expired;
+	int clockid;	/* Established when timer is created, then
+			   immutable */
+	int overrun;	/* Number of overruns for this timer so far,
+			   updated on calls to timerfd() that retrieve
+			   settings of an existing timer, reset to zero
+			   by timerfd_read() */
 };

 /*
@@ -61,6 +69,7 @@
 	hrtimer_init(&ctx->tmr, clockid, htmode);
 	ctx->tmr.expires = texp;
 	ctx->tmr.function = timerfd_tmrproc;
+	ctx->overrun = 0;
 	if (texp.tv64 != 0)
 		hrtimer_start(&ctx->tmr, texp, htmode);
 }
@@ -130,10 +139,11 @@
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks = (u64)
+			ticks = ctx->overrun +
 				hrtimer_forward(&ctx->tmr,
 						hrtimer_cb_get_time(&ctx->tmr),
 						ctx->tintv);
+			ctx->overrun = 0;
 			hrtimer_restart(&ctx->tmr);
 		} else
 			ticks = 1;
@@ -151,24 +161,69 @@
 };

 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr)
+			const struct itimerspec __user *utmr,
+			struct itimerspec __user *old_utmr)
 {
 	int error;
 	struct timerfd_ctx *ctx;
 	struct file *file;
 	struct inode *inode;
-	struct itimerspec ktmr;
+	struct itimerspec ktmr, oktmr;

-	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
-		return -EFAULT;
+	/*
+	 * Not sure if we really need the first check below -- it
+	 * relies on all clocks having a non-negative value.  That's
+	 * currently true, but I'm not sure that it is anywhere
+	 * documented as a requirement.
+	 * (The point of the check is that clockid has no meaning if
+	 * we are changing the settings of an existing timer
+	 * (i.e., ufd >= 0), so let's require it to be an otherwise
+	 * unused value.)
+	 */

-	if (clockid != CLOCK_MONOTONIC &&
-	    clockid != CLOCK_REALTIME)
+	if (ufd >= 0) {
+		if (clockid != -1)
+			return -EINVAL;
+	} else if (clockid != CLOCK_MONOTONIC && clockid != CLOCK_REALTIME)
+		return -EINVAL;
+
+	/*
+	 * Disallow any other bits in flags than those we implement.
+	 */
+	if ((flags & ~(TFD_TIMER_ABSTIME)) != 0)
+		return -EINVAL;
+
+	/*
+         * Not sure if this check is strictly necessary, except to stop
+	 * userspace trying to do something silly.  Flags only has meaning
+	 * if we are creating/modifying a timer.
+	 */
+	if (utmr == NULL && flags != 0)
 		return -EINVAL;
-	if (!timespec_valid(&ktmr.it_value) ||
-	    !timespec_valid(&ktmr.it_interval))
+
+	/*
+	 * If we are creating a new timer, then we must supply the setting
+	 * and there is no previous timer setting to retrieve.
+	 */
+	if (ufd == -1 && (utmr == NULL || old_utmr != NULL))
+		return -EINVAL;
+	
+	/*
+	 * Caller must provide a new timer setting, or ask for previous
+	 * setting, or both.
+	 */
+	if (utmr == NULL && old_utmr == NULL)
 		return -EINVAL;

+	if (utmr) {
+		if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
+			return -EFAULT;
+
+		if (!timespec_valid(&ktmr.it_value) ||
+		    !timespec_valid(&ktmr.it_interval))
+			return -EINVAL;
+	}
+
 	if (ufd == -1) {
 		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
 		if (!ctx)
@@ -176,6 +231,11 @@

 		init_waitqueue_head(&ctx->wqh);

+		/*
+		 * Save the clockid since we need it later if we modify
+		 * the timer.
+		 */
+		ctx->clockid = clockid;
 		timerfd_setup(ctx, clockid, flags, &ktmr);

 		/*
@@ -195,23 +255,61 @@
 			fput(file);
 			return -EINVAL;
 		}
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
+
+		if (old_utmr) {
+
+			/*
+			 * Retrieve interval and time remaining before
+			 * next expiration of timer.
+			 */
+
+			struct hrtimer *timer = &ctx->tmr;
+			ktime_t iv = ctx->tintv;
+			ktime_t now, remaining;
+
+			clockid = ctx->clockid;
+
+			memset(&oktmr, 0, sizeof(struct itimerspec));
+			if (iv.tv64)
+				oktmr.it_interval = ktime_to_timespec(iv);
+
+			now = timer->base->get_time();
+			ctx->overrun += hrtimer_forward(&ctx->tmr,
+					hrtimer_cb_get_time(&ctx->tmr),
+					ctx->tintv);
+			remaining = ktime_sub(timer->expires, now);
+			if (remaining.tv64 <= 0)
+				oktmr.it_value.tv_nsec = 1;
+			else
+				oktmr.it_value = ktime_to_timespec(remaining);
+
+			if (copy_to_user(old_utmr, &oktmr, sizeof (oktmr))) {
+				fput(file);
+				return -EFAULT;
+			}
 		}
-		/*
-		 * Re-program the timer to the new value ...
-		 */
-		timerfd_setup(ctx, clockid, flags, &ktmr);

-		spin_unlock_irq(&ctx->wqh.lock);
+		if (utmr) {
+			/*
+			 * Modify settings of existing timer.
+			 * We need to stop the existing timer before
+			 * reprogramming it to the new values.
+			 */
+			for (;;) {
+				spin_lock_irq(&ctx->wqh.lock);
+				if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
+					break;
+				spin_unlock_irq(&ctx->wqh.lock);
+				cpu_relax();
+			}
+
+			/*
+			 * Re-program the timer to the new value ...
+			 */
+			timerfd_setup(ctx, ctx->clockid, flags, &ktmr);
+
+			spin_unlock_irq(&ctx->wqh.lock);
+		}
 		fput(file);
 	}

@@ -222,4 +320,3 @@
 	kfree(ctx);
 	return error;
 }
-
diff -ruN linux-2.6.23-rc1-mm2-orig/include/linux/compat.h linux-2.6.23-rc1-mm2/include/linux/compat.h
--- linux-2.6.23-rc1-mm2-orig/include/linux/compat.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.23-rc1-mm2/include/linux/compat.h	2007-08-05 17:46:33.000000000 +0200
@@ -265,7 +265,8 @@
 				const compat_sigset_t __user *sigmask,
                                 compat_size_t sigsetsize);
 asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
-				const struct compat_itimerspec __user *utmr);
+			const struct compat_itimerspec __user *utmr,
+			struct compat_itimerspec __user *old_utmr);

 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff -ruN linux-2.6.23-rc1-mm2-orig/include/linux/syscalls.h linux-2.6.23-rc1-mm2/include/linux/syscalls.h
--- linux-2.6.23-rc1-mm2-orig/include/linux/syscalls.h	2007-08-05 10:44:32.000000000 +0200
+++ linux-2.6.23-rc1-mm2/include/linux/syscalls.h	2007-08-05 17:47:15.000000000 +0200
@@ -608,7 +608,8 @@
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 asmlinkage long sys_signalfd(int ufd, sigset_t __user *user_mask, size_t sizemask);
 asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
-			    const struct itimerspec __user *utmr);
+			const struct itimerspec __user *utmr,
+			struct itimerspec __user *old_utmr);
 asmlinkage long sys_eventfd(unsigned int count);
 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);



--------------040507070104000103040608
Content-Type: text/x-csrc;
 name="new_timerfd_errors_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="new_timerfd_errors_test.c"

/* new_timerfd_errors_test.c

   Copyright (C) 2007 Google
   Author: Michael Kerrisk <mtk@google.com>

   Run various tests against the revised timerfd() implementation.
*/
/* Link with -lrt */

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <unistd.h>
#include <time.h>
#if defined(__i386__)
#define __NR_timerfd 322
#endif

static int
timerfd(int ufd, int clockid, int flags, struct itimerspec *utmr,
        struct itimerspec *outmr)
{
    return syscall(__NR_timerfd, ufd, clockid, flags, utmr, outmr);
}

#define TFD_TIMER_ABSTIME (1 << 0)

/**********************************************************************/

// #include <sys/timerfd.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <errno.h>

/*
 * die() is for code that unexpectedly fails.
 * test_failed() is for tests where we didn't get a failure when we
 * should have.
*/
#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

static int failures = 0;

#define test_failed(msg) do { \
        fprintf(stderr, "TEST FAILED, because: %s\n", msg); \
        failures++; \
    } while (0);


#define MILLISEC 1000000        /* Expressed in nanonsecs */

static int
make_new_timerfd(int clockid, int flags, int vsecs, int vnsecs,
        int isecs, int insecs)
{
    struct itimerspec utmr;

    utmr.it_value.tv_sec = vsecs;
    utmr.it_value.tv_nsec = vnsecs;
    utmr.it_interval.tv_sec = isecs;
    utmr.it_interval.tv_nsec = insecs;

    return timerfd(-1, clockid, flags, &utmr, NULL);
} /* make_new_timerfd */

int
main(int argc, char *argv[])
{
    struct itimerspec utmr, outmr;
    int ufd, ret;
    struct timespec now;
    uint64_t ticks;
    int j;

    /*
     * All of the following timer creations should succeed.
     */ 
    ufd = make_new_timerfd(CLOCK_REALTIME, 0, 1, 0, 1, 0);
    if (ufd == -1)
        die("timerfd-REALTIME-flags=0");

    if (clock_gettime(CLOCK_REALTIME, &now) == -1)
        die("clock_gettime");
    ufd = make_new_timerfd(CLOCK_REALTIME, TFD_TIMER_ABSTIME, 
                now.tv_sec + 1, now.tv_nsec, 1, 0);
    if (ufd == -1)
        die("timerfd-REALTIME-ABSTIME");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, 1, 0, 1, 0);
    if (ufd == -1)
        die("timerfd-MONOTONIC-flags=0");

    if (clock_gettime(CLOCK_MONOTONIC, &now) == -1)
        die("clock_gettime");
    ufd = make_new_timerfd(CLOCK_MONOTONIC, TFD_TIMER_ABSTIME, 
                now.tv_sec + 1, now.tv_nsec, 1, 0);
    if (ufd == -1)
        die("timerfd-MONOTONIC-ABSTIME");

    ufd = make_new_timerfd(CLOCK_REALTIME, 0, 0, 0, 0, 0);
    if (ufd == -1)
        die("timerfd-MONOTONIC-zero-timer");

    /*
     * Some argument values should not be permitted.
     */
    ufd = make_new_timerfd(-1, 0, 1, 0, 1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-negative-CLOCKID-for-new-timer");

    ufd = make_new_timerfd(99, 0, 1, 0, 1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-bad-clockid");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0xff, 1, 0, 1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-invalid-flags");

    /*
     * Non-canonical utmr values should be disallowed.
     */
    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, -1, 0, 1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-negative-it_value.tv_secs");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, 1, -1, 1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-negative-it_value.tv_nsecs");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, 1, 0, -1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-negative-it_interval.tv_secs");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, 1, 0, 1, -1);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-negative-it_interval.tv_nsecs");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, 1, 2000000000, 1, 0);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-non-canonical-it_value.tv_nsecs");

    ufd = make_new_timerfd(CLOCK_MONOTONIC, 0, 1, 0, 1, 2000000000);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-non-canonical-it_interval.tv_nsecs");

    /*
     * At least one of utmr and outmr must be non-NULL.
     */

    ufd = timerfd(-1, CLOCK_MONOTONIC, 0, NULL, NULL);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-NULL-utmtr-plus-NULL-outmr");

    /*
     * When creating a new timer, a non-NULL outmr is meaningless
     * and disallowed.
     */
    utmr.it_value.tv_sec = 10;
    utmr.it_value.tv_nsec = 1;
    utmr.it_interval.tv_sec = 10;
    utmr.it_interval.tv_nsec = 1;
    ufd = timerfd(-1, CLOCK_MONOTONIC, 0, &utmr, &outmr);
    if (!(ufd == -1 && errno == EINVAL))
        test_failed("allowed-NULL-outmr-for-new-timer");

    /*******************************************************************
     * Various argument combinations are disallowed when modifying an
     * existing timer.
     */
    ufd = timerfd(-1, CLOCK_REALTIME, 0, &utmr, NULL);
    if (ufd == -1)
        die("timerfd: modify setup");

    /*
     * A clockid cannot be changed for an existing timer;
     * therefore it is required to be -1.  (Note: We could not
     * require it to be zero, because CLOCK_REALTIME == 0.)
     */
    ret = timerfd(ufd, 0, 0, &utmr, NULL);
    if (!(ret == -1 && errno == EINVAL))
        test_failed("allowed-clockid-not-neg-1-clockid-for-timer-mod");

    /*
     * If ufd >= 0 and utmr is NULL, then we are retrieving the setting
     * of an existing timer; in this case a non-zero flags value is
     * meaningless and disallowed.
     */
    ret = timerfd(ufd, -1, TFD_TIMER_ABSTIME, NULL, &outmr);
    if (!(ret == -1 && errno == EINVAL))
        test_failed("allowed-non-zero-flags-with-NULL-utmr");

    /*
     * If ufd is not -1, then it must be a valid timerfd file descriptor.
     */
    ret = timerfd(STDOUT_FILENO, -1, 0, &utmr, NULL);
    if (!(ret == -1 && errno == EINVAL))
        test_failed("allowed-non-timerfd-file-descriptor");

    ret = timerfd(99, -1, 0, &utmr, NULL);
    if (!(ret == -1 && errno == EBADF))
        test_failed("allowed-bad-file-descriptor");

    printf("Completed argument tests\n");

    /*
     * Test operation of a single shot timer.
     */
    ufd = make_new_timerfd(CLOCK_REALTIME, 0, 0, 500 * MILLISEC, 0, 0);
    if (ufd == -1)
        die("timerfd-MONOTONIC-ABSTIME");

    if (read(ufd, &ticks, sizeof(ticks)) != sizeof(ticks))
        die("read");

    if (ticks != 1)
        test_failed("ticks-was-not-1")

    /*
     * The following timer should return an overrun count of 5
     * for the read().  The fact that make multiple timerfd()
     * calls to retrieve the current timer settings should not
     * affect the overrun count.
     */
    utmr.it_value.tv_sec = 1;
    utmr.it_value.tv_nsec = 0;
    utmr.it_interval.tv_sec = 2;
    utmr.it_interval.tv_nsec = 0;
    printf("\nMeasuring timer with interval %ld, frequency %ld, "
            "for 10 seconds\n", (long) utmr.it_value.tv_sec,
            (long) utmr.it_interval.tv_sec);
    ufd = timerfd(-1, CLOCK_REALTIME, 0, &utmr, NULL);
    if (ufd == -1)
        die("timerfd-MONOTONIC-ABSTIME");

    for (j = 0; j < 10; j++) {
        sleep(1);
        ret = timerfd(ufd, -1, 0, NULL, &outmr);
        printf("%d - Got: %ld %9ld\n", j,
                (long) outmr.it_value.tv_sec,
                (long) outmr.it_value.tv_nsec);
    }

    if (read(ufd, &ticks, sizeof(ticks)) != sizeof(ticks))
        die("read");

    printf("Read (expiration count): %lld\n", ticks);
    if (ticks != 5)
        test_failed("ticks-was-not-5");

    /*
     * Modify the settings of the previous timer.
     * The following timer should return an overrun count of 3
     * for the read().  Making multiple timerfd() calls
     * to retrieve the current timer settings should not
     * affect the overrun count.
     */
    utmr.it_value.tv_sec = 1;
    utmr.it_value.tv_nsec = 0;
    utmr.it_interval.tv_sec = 4;
    utmr.it_interval.tv_nsec = 0;
    printf("\nMeasuring timer with interval %ld, frequency %ld, "
            "for 10 seconds\n", (long) utmr.it_value.tv_sec,
            (long) utmr.it_interval.tv_sec);
    ret = timerfd(ufd, -1, 0, &utmr, &outmr);
    if (ret == -1)
        die("timerfd-MONOTONIC-ABSTIME");

    for (j = 0; j < 10; j++) {
        sleep(1);
        ret = timerfd(ufd, -1, 0, NULL, &outmr);
        printf("%d - Got: %ld %9ld\n", j,
                (long) outmr.it_value.tv_sec,
                (long) outmr.it_value.tv_nsec);
    }

    if (read(ufd, &ticks, sizeof(ticks)) != sizeof(ticks))
        die("read");

    printf("Read (expiration count): %lld\n", ticks);
    if (ticks != 3)
        test_failed("ticks-was-not-3");

    /*
     * If we set an interval timer to expire in the past, then it
     * the number of overruns should correspond to how far in the
     * past the timer was set.
     */
#define NEG_SECS 20
    if (clock_gettime(CLOCK_REALTIME, &now) == -1)
        die("clock_gettime");
    ufd = make_new_timerfd(CLOCK_REALTIME, TFD_TIMER_ABSTIME, 
                now.tv_sec - NEG_SECS, now.tv_nsec, 1, 0);
    if (ufd == -1)
        die("timerfd-REALTIME-ABSTIME");

    if (read(ufd, &ticks, sizeof(ticks)) != sizeof(ticks))
        die("read");

    printf("Read from already expired timer: %lld\n", ticks);
    if (ticks != (1 + NEG_SECS))
        test_failed("wrong-value-read-from-past-timer");

    if (failures == 0) 
        printf("All tests passed successfully\n");
    else
        printf("%d tests failed\n", failures);
    exit((failures == 0) ? EXIT_SUCCESS : EXIT_FAILURE);
}

--------------040507070104000103040608--
