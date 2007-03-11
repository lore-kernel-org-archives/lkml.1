Return-Path: <linux-kernel-owner+w=401wt.eu-S933757AbXCKPbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757AbXCKPbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 11:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933764AbXCKPbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 11:31:03 -0400
Received: from www.osadl.org ([213.239.205.134]:56608 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933757AbXCKPbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 11:31:01 -0400
Subject: Re: [patch 6/9] signalfd/timerfd - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703101822340.3613@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703101822340.3613@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sun, 11 Mar 2007 16:37:26 +0100
Message-Id: <1173627447.24738.1243.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

On Sat, 2007-03-10 at 18:22 -0800, Davide Libenzi wrote:

Some remarks:

> +
> +asmlinkage long sys_timerfd(int ufd, int clockid, int tmrtype,
> +			    const struct timespec __user *utmr)
> +{
> +	int error;
> +	struct timerfd_ctx *ctx;
> +	struct file *file;
> +	struct inode *inode;
> +	ktime_t tval, tnow;
> +	struct timespec ktmr, tmrnow;
> +
> +	error = -EFAULT;
> +	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> +		goto err_exit;

Please do not use goto for a simple
		return -EFAULT;

Please validate the timespec before converting it.

        if (!timespec_valid(&ktmr))
                return -EINVAL;


> +	tval = timespec_to_ktime(ktmr);
> +	error = -EINVAL;
> +	if (clockid != CLOCK_MONOTONIC &&
> +	    clockid != CLOCK_REALTIME)
> +		goto err_exit;
> +	switch (tmrtype) {
> +	case TFD_TIMER_REL:
> +	case TFD_TIMER_SEQ:
> +		break;
> +	case TFD_TIMER_ABS:
> +		getnstimeofday(&tmrnow);
> +		tnow = timespec_to_ktime(tmrnow);

		tnow = ktime_get();

> +		if (ktime_to_ns(tval) <= ktime_to_ns(tnow))
> +			goto err_exit;
> +		tval = ktime_sub(tval, tnow);

Why do you want to do that ? hrtimers handle relative and absolute
expiry times. You break down everything to relative time and lose the
accuracy for absolute timers. 

> +		break;
> +	default:
> +		goto err_exit;
> +	}
> +
> +	if (ufd == -1) {
> +		error = -ENOMEM;
> +		ctx = kmem_cache_alloc(timerfd_ctx_cachep, GFP_KERNEL);
> +		if (!ctx)
> +			goto err_exit;
> +
> +		init_waitqueue_head(&ctx->wqh);
> +		spin_lock_init(&ctx->lock);
> +		ctx->ticks = 0;
> +		ctx->tmrtype = tmrtype;
> +		ctx->clockid = clockid;
> +		ctx->tval = tval;
> +		hrtimer_init(&ctx->tmr, ctx->clockid, HRTIMER_REL);
> +		ctx->tmr.expires = ctx->tval;
> +		ctx->tmr.function = timerfd_tmrproc;
> +
> +		hrtimer_start(&ctx->tmr, ctx->tval, HRTIMER_REL);
> +
> +		/*
> +		 * When we call this, the initialization must be complete, since
> +		 * aino_getfd() will install the fd.
> +		 */
> +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> +				   &timerfd_fops, ctx);
> +		if (error)
> +			goto err_fdalloc;

Why is the timer started before we have everything in place ? 

Also if you turn it around then the (re)programming part of the timer
can be shared.

> +	} else {
> +		error = -EBADF;
> +		file = fget(ufd);
> +		if (!file)
> +			goto err_exit;
> +		ctx = file->private_data;
> +		error = -EINVAL;
> +		if (file->f_op != &timerfd_fops) {
> +			fput(file);
> +			goto err_exit;
> +		}
> +
> +		/*
> +		 * We need to stop the exiting timer before. We call
> +		 * hrtimer_cancel() w/out holding our lock.
> +		 */
> +		spin_lock_irq(&ctx->lock);
> +		while (hrtimer_active(&ctx->tmr)) {
> +			spin_unlock_irq(&ctx->lock);
> +			hrtimer_cancel(&ctx->tmr);
> +			spin_lock_irq(&ctx->lock);
> +		}

Please use hrtimer_try_to_cancel()

retry:
	spin_lock_irq(....):
	if (hrtimer_try_to_cancel(&ctx->tmr) < 0) {
		spin_unlock_irq();
		cpu_relax();
		goto retry;
	}

> +
> +static unsigned int timerfd_poll(struct file *file, poll_table *wait)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +
> +	poll_wait(file, &ctx->wqh, wait);
> +
> +	return ctx->ticks ? POLLIN: 0;

This is racy:

	timer is set up (non periodic)
	timer expires
	poll 

	now poll is stuck for ever !


	tglx


