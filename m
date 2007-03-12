Return-Path: <linux-kernel-owner+w=401wt.eu-S965525AbXCLKuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525AbXCLKuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 06:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXCLKuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 06:50:19 -0400
Received: from www.osadl.org ([213.239.205.134]:53533 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965525AbXCLKuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 06:50:15 -0400
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 11:19:23 +0100
Message-Id: <1173694763.13341.81.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

On Sun, 2007-03-11 at 16:04 -0700, Davide Libenzi wrote:
> +static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int tmrtype,
> +			 const struct itimerspec *ktmr)
> +{
> +	enum hrtimer_mode htmode;
> +	ktime_t texp, tintv;
> +
> +	if (clockid != CLOCK_MONOTONIC &&
> +	    clockid != CLOCK_REALTIME)
> +		return -EINVAL;

Please move the validation for clockid, tmrtype and the timerspec into
sys_timerfd. Do it before anything else. Also please validate both
it_value and it_interval unconditionally. Userspace should not send
uninitialized stuff at all.

The TFD_TIMER_SEQ thing is quite different to all other timer interfaces
which POSIX provides. Both itimers and posixtimers use the it_interval
value to distinguish between one shot and periodic timers.

I think we should keep this new interface analogous, so programmers
don't get more confused, than they are already. :)

This also allows relative and absolute starting points for both one shot
and sequential timers.

Please use it_value == 0 to stop the timer. This is the same as for
itimers and posixtimers. Right now you have to close the fd to stop a
timer, but that's not necessarily what you want. 

Why do you want to store information, which is only relevant for setup
in ctx ?

If you do the validation right in sys_timerfd and get rid of
TFD_TIMER_SEQ and the various useless fields, then timerfd_setup() boils
down to

	ctx->ticks = 0;
	ctx->tintv = tintv;
	hrtimer_init(&ctx->tmr, clockid, htmode);
	ctx->tmr.function = timerfd_tmrproc;

	if (texp.tv64 != 0)
		hrtimer_start(&ctx->tmr, texp, htmode);

and in the timer function you simply check for

	if (ctx->tintv.tv64 != 0) 

instead of the TIMER_SEQ mode.

> +asmlinkage long sys_timerfd(int ufd, int clockid, int tmrtype,
> +			    const struct itimerspec __user *utmr)
> +{
> +	int error;
> +	struct timerfd_ctx *ctx;
> +	struct file *file;
> +	struct inode *inode;
> +	struct itimerspec ktmr;
> +
> +	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> +		return -EFAULT;

Do validation of clockid, tmrtype and ktmr here.

> +	if (ufd == -1) {
> +		error = -ENOMEM;
> +		ctx = kmem_cache_alloc(timerfd_ctx_cachep, GFP_KERNEL);
> +		if (!ctx)
> +			goto err_exit;

	return -ENOMEM;

> +		init_waitqueue_head(&ctx->wqh);
> +		spin_lock_init(&ctx->lock);
> +		ctx->clockid = -1;
> +
> +		error = timerfd_setup(ctx, clockid, tmrtype, &ktmr);
> +		if (error)
> +			goto err_ctxfree;
> +
> +		/*
> +		 * When we call this, the initialization must be complete, since
> +		 * aino_getfd() will install the fd.
> +		 */
> +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> +				   &timerfd_fops, ctx);
> +		if (error)
> +			goto err_ctxfree;
> +	} else {
> +		error = -EBADF;
> +		file = fget(ufd);
> +		if (!file)
> +			goto err_exit;

	return -EBADF;

> +		ctx = file->private_data;
> +		error = -EINVAL;
> +		if (file->f_op != &timerfd_fops) {
> +			fput(file);
> +			goto err_exit;

	return -EINVAL;

> +		}
> +		/*
> +		 * We need to stop the exiting timer before.
> +		 */

	-ENOPARSE. You probably mean: We need to stop an already running timer
before we do a new setup.

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
> +		error = timerfd_setup(ctx, clockid, tmrtype, &ktmr);
> +
> +		spin_unlock_irq(&ctx->lock);
> +		fput(file);
> +		if (error)
> +			goto err_exit;

		return error;

> +	}
> +
> +	return ufd;
> +
> +err_ctxfree:
> +	timerfd_cleanup(ctx);
> +err_exit:
> +	return error;
> +}
> +

	tglx


