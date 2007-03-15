Return-Path: <linux-kernel-owner+w=401wt.eu-S1751060AbXCOVvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060AbXCOVvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXCOVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:51:44 -0400
Received: from www.osadl.org ([213.239.205.134]:44755 "EHLO mail.tglx.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbXCOVvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:51:43 -0400
Subject: Re: [patch 6/13] signalfd/timerfd/asyncfd v5 - timerfd core ...
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <send-serie.davidel@xmailserver.org.13805.1173910766.6>
References: <send-serie.davidel@xmailserver.org.13805.1173910766.6>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 22:58:09 +0100
Message-Id: <1173995889.13341.217.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide,

On Wed, 2007-03-14 at 15:19 -0700, Davide Libenzi wrote:

> +static int timerfd_tmrproc(struct hrtimer *htmr)
> +{
> +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> +	int rval = HRTIMER_NORESTART;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctx->lock, flags);
> +	ctx->ticks++;
> +	wake_up_locked(&ctx->wqh);
> +	if (ctx->tintv.tv64 != 0) {
> +		hrtimer_forward(htmr, htmr->base->softirq_time, ctx->tintv);

Sorry, I missed that in the first reviews. Please use
hrtimer_cb_get_time(htmr) instead of htmr->base->softirq_time, so this
is high res timer safe.

> +		rval = HRTIMER_RESTART;
> +	}
> +	spin_unlock_irqrestore(&ctx->lock, flags);
> +
> +	return rval;
> +}
> +
> +
> +static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> +			 const struct itimerspec *ktmr)
> +{

Make this void, returns 0 anyway

> +	enum hrtimer_mode htmode;
> +
> +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_ABS: HRTIMER_REL;
> +
> +	ctx->ticks = 0;
> +	ctx->clockid = clockid;
> +	ctx->flags = flags;
> +	ctx->texp = timespec_to_ktime(ktmr->it_value);

clockid is stored in the timer on setup, so no need to store it again.
expiry time and flags are not used after setup.

Please remove those fields.

> +	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> +	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
> +	ctx->tmr.expires = ctx->texp;
> +	ctx->tmr.function = timerfd_tmrproc;
> +	if (ctx->texp.tv64 != 0)
> +		hrtimer_start(&ctx->tmr, ctx->texp, htmode);
> +
> +	return 0;
> +}
> +
> +	if (ufd == -1) {
> +		ctx = kmem_cache_alloc(timerfd_ctx_cachep, GFP_KERNEL);
> +		if (!ctx)
> +			return -ENOMEM;
> +
> +		init_waitqueue_head(&ctx->wqh);
> +		spin_lock_init(&ctx->lock);
> +		ctx->clockid = -1;
> +
> +		error = timerfd_setup(ctx, clockid, flags, &ktmr);
> +		if (error)
> +			goto err_ctxfree;

Timer setup can not fail

> +		/*
> +		 * When we call this, the initialization must be complete, since
> +		 * aino_getfd() will install the fd.
> +		 */
> +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> +				   &timerfd_fops, ctx);
> +		if (error)
> +			goto err_ctxfree;

Again: Please turn this around. No need to start the timer before we
know, that everything works. 

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
> +		error = timerfd_setup(ctx, clockid, flags, &ktmr);

Timer setup can not fail

> +		spin_unlock_irq(&ctx->lock);
> +		fput(file);
> +		if (error)
> +			return error;
> +	}
> +
> +	return ufd;
> +
> +err_ctxfree:
> +	timerfd_cleanup(ctx);
> +	return error;
> +}
> +
> +
> +static void timerfd_cleanup(struct timerfd_ctx *ctx)
> +{
> +	if (ctx->clockid >= 0)
> +		hrtimer_cancel(&ctx->tmr);

You don't have a file descriptor, when the setup failed. So the timer is
always initialized.

> +	kmem_cache_free(timerfd_ctx_cachep, ctx);
> +}
> +
> +
> +static int timerfd_close(struct inode *inode, struct file *file)
> +{
> +	timerfd_cleanup(file->private_data);
> +	return 0;
> +}
> +

Please move the timerfd_cleanup code into close(). 

	tglx


