Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXC3TkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXC3TkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXC3TkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:40:17 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbXC3TkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:40:11 -0400
Date: Fri, 30 Mar 2007 12:40:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/13] signal/timer/event fds v8 - timerfd core ...
Message-Id: <20070330124005.0ec31aa6.akpm@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.28743.1174415837.6>
References: <send-serie.davidel@xmailserver.org.28743.1174415837.6>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 11:37:14 -0700
Davide Libenzi <davidel@xmailserver.org> wrote:

> This patch introduces a new system call for timers events delivered
> though file descriptors. This allows timer event to be used with
> standard POSIX poll(2), select(2) and read(2). As a consequence of
> supporting the Linux f_op->poll subsystem, they can be used with
> epoll(2) too.
> The system call is defined as:
> 
> int timerfd(int ufd, int clockid, int flags, const struct itimerspec *utmr);
> 
> The "ufd" parameter allows for re-use (re-programming) of an existing
> timerfd w/out going through the close/open cycle (same as signalfd).
> If "ufd" is -1, s new file descriptor will be created, otherwise the
> existing "ufd" will be re-programmed.
> The "clockid" parameter is either CLOCK_MONOTONIC or CLOCK_REALTIME.
> The time specified in the "utmr->it_value" parameter is the expiry
> time for the timer.
> If the TFD_TIMER_ABSTIME flag is set in "flags", this is an absolute
> time, otherwise it's a relative time.
> If the time specified in the "utmr->it_interval" is not zero (.tv_sec == 0,
> tv_nsec == 0), this is the period at which the following ticks should
> be generated.
> The "utmr->it_interval" should be set to zero if only one tick is requested.
> Setting the "utmr->it_value" to zero will disable the timer, or will create
> a timerfd without the timer enabled.
> The function returns the new (or same, in case "ufd" is a valid timerfd
> descriptor) file, or -1 in case of error.
> As stated before, the timerfd file descriptor supports poll(2), select(2)
> and epoll(2). When a timer event happened on the timerfd, a POLLIN mask
> will be returned.
> The read(2) call can be used, and it will return a u32 variable holding
> the number of "ticks" that happened on the interface since the last call
> to read(2). The read(2) call supportes the O_NONBLOCK flag too, and EAGAIN
> will be returned if no ticks happened.
> A quick test program, shows timerfd working correctly on my amd64 box:
> 
> http://www.xmailserver.org/timerfd-test.c
> 
> ...
>
> 
> Index: linux-2.6.21-rc3.quilt/fs/timerfd.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.21-rc3.quilt/fs/timerfd.c	2007-03-19 19:01:52.000000000 -0700
> @@ -0,0 +1,233 @@
> +/*
> + *  fs/timerfd.c
> + *
> + *  Copyright (C) 2007  Davide Libenzi <davidel@xmailserver.org>
> + *
> + *
> + *  Thanks to Thomas Gleixner for code reviews and useful comments.
> + *
> + */
> +
> +#include <linux/file.h>
> +#include <linux/poll.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/mount.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/signal.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/time.h>
> +#include <linux/hrtimer.h>
> +#include <linux/jiffies.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/timerfd.h>
> +
> +#include <asm/uaccess.h>
> +
> +
> +

I see blankness.

> +struct timerfd_ctx {
> +	struct hrtimer tmr;
> +	ktime_t tintv;
> +	spinlock_t lock;
> +	wait_queue_head_t wqh;
> +	unsigned long ticks;
> +};

Did you consider using the (presently unused) lock inside wqh instead of
adding a new one?  That's a little bit rude, poking into waitqueue
internals like that, but we do it elsewhere and tricks like that are
acceptable in core-kernel, I guess.

I find that the key to understanding kernel code is to understand the data
structures and the relationships between them.  Once you have that in your
head, the code tends to just fall out.  Hence there is good maintainability
payoff in putting work into documenting the struct, its fields, the
relationship between this struct and other structs, and any and all locking
requirements.

<wonders wtf "ticks" does>

> +
> +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr);
> +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> +			  const struct itimerspec *ktmr);
> +static int timerfd_close(struct inode *inode, struct file *file);
> +static unsigned int timerfd_poll(struct file *file, poll_table *wait);
> +static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
> +			    loff_t *ppos);

It'd be nice to find a way to make these declarations go away.

> +
> +
> +

blankness.

> +static const struct file_operations timerfd_fops = {
> +	.release	= timerfd_close,

Rename to timerfd_release

> +	.poll		= timerfd_poll,
> +	.read		= timerfd_read,
> +};
> +
> +
> +

scroll, scroll

> +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
> +{
> +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> +	enum hrtimer_restart rval = HRTIMER_NORESTART;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	ctx->ticks++;
> +	wake_up_locked(&ctx->wqh);
> +	if (ctx->tintv.tv64 != 0) {
> +		hrtimer_forward(htmr, hrtimer_cb_get_time(htmr), ctx->tintv);
> +		rval = HRTIMER_RESTART;
> +	}
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	return rval;
> +}

What's this do?

> +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> +			  const struct itimerspec *ktmr)
> +{
> +	enum hrtimer_mode htmode;
> +	ktime_t texp;
> +
> +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
> +
> +	texp = timespec_to_ktime(ktmr->it_value);
> +	ctx->ticks = 0;
> +	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> +	hrtimer_init(&ctx->tmr, clockid, htmode);
> +	ctx->tmr.expires = texp;
> +	ctx->tmr.function = timerfd_tmrproc;
> +	if (texp.tv64 != 0)
> +		hrtimer_start(&ctx->tmr, texp, htmode);
> +}

What does the special case texp.tv64 == 0 signify?  Is that obvious to
anyone who understands hrtimers?  Is it something which we can expect
Micheal to immediately understand?  Should it be documented somewhere?


> +asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
> +			    const struct itimerspec __user *utmr)

Somehow we need to get from this to a manpage.

> +{
> +	int error;
> +	struct timerfd_ctx *ctx;
> +	struct file *file;
> +	struct inode *inode;
> +	struct itimerspec ktmr;
> +
> +	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> +		return -EFAULT;
> +
> +	if (clockid != CLOCK_MONOTONIC &&
> +	    clockid != CLOCK_REALTIME)
> +		return -EINVAL;
> +	if (!timespec_valid(&ktmr.it_value) ||
> +	    !timespec_valid(&ktmr.it_interval))
> +		return -EINVAL;
> +
> +	if (ufd == -1) {
> +		ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> +		if (!ctx)
> +			return -ENOMEM;
> +
> +		init_waitqueue_head(&ctx->wqh);
> +		spin_lock_init(&ctx->lock);
> +
> +		timerfd_setup(ctx, clockid, flags, &ktmr);
> +
> +		/*
> +		 * When we call this, the initialization must be complete, since
> +		 * aino_getfd() will install the fd.
> +		 */
> +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> +				   &timerfd_fops, ctx);
> +		if (error)
> +			goto err_tmrcancel;
> +	} else {
> +		file = fget(ufd);
> +		if (!file)
> +			return -EBADF;
> +		ctx = file->private_data;
> +		if (file->f_op != &timerfd_fops) {
> +			fput(file);
> +			return -EINVAL;
> +		}
> +		/*
> +		 * We need to stop the existing timer before reprogramming
> +		 * it to the new values.
> +		 */
> +		for (;;) {
> +			spin_lock_irq(&ctx->lock);
> +			if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> +				break;
> +			spin_unlock_irq(&ctx->lock);
> +			cpu_relax();
> +		}
> +		/*
> +		 * Re-program the timer to the new value ...
> +		 */
> +		timerfd_setup(ctx, clockid, flags, &ktmr);
> +
> +		spin_unlock_irq(&ctx->lock);
> +		fput(file);
> +	}
> +
> +	return ufd;
> +
> +err_tmrcancel:
> +	hrtimer_cancel(&ctx->tmr);
> +	kfree(ctx);
> +	return error;
> +}
> +
>
> ...
>
> +static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
> +			    loff_t *ppos)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +	ssize_t res;
> +	u32 ticks;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	if (count < sizeof(ticks))
> +		return -EINVAL;
> +	spin_lock_irq(&ctx->lock);
> +	res = -EAGAIN;
> +	if ((ticks = (u32) ctx->ticks) == 0 &&
> +	    !(file->f_flags & O_NONBLOCK)) {
> +		__add_wait_queue(&ctx->wqh, &wait);
> +		for (res = 0;;) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			if ((ticks = (u32) ctx->ticks) != 0) {
> +				res = 0;
> +				break;
> +			}
> +			if (signal_pending(current)) {
> +				res = -ERESTARTSYS;
> +				break;
> +			}
> +			spin_unlock_irq(&ctx->lock);
> +			schedule();
> +			spin_lock_irq(&ctx->lock);
> +		}
> +		__remove_wait_queue(&ctx->wqh, &wait);
> +		__set_current_state(TASK_RUNNING);
> +	}
> +	if (ticks)
> +		ctx->ticks = 0;
> +	spin_unlock_irq(&ctx->lock);
> +	if (ticks)
> +		res = put_user(ticks, buf) ? -EFAULT: sizeof(ticks);
> +	return res;
> +}

OK, this is briefly documented in the patch changelog.  That interface
documentation should be fleshed out and moved into the .c file.  a) because
it is easier to find and b) if we change it, it's a bit hard to go back and
alter that changelog!

How come it's OK to truncate 64-bit timerfd_ctx.ticks to 32-bit like this?


