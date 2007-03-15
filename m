Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbXCOXHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbXCOXHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXCOXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:07:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:46728 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXCOXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:07:14 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 15 Mar 2007 16:02:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/13] signalfd/timerfd/asyncfd v5 - timerfd core ...
In-Reply-To: <1173995889.13341.217.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703151556290.4998@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13805.1173910766.6>
 <1173995889.13341.217.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007, Thomas Gleixner wrote:

> Davide,
> 
> On Wed, 2007-03-14 at 15:19 -0700, Davide Libenzi wrote:
> 
> > +static int timerfd_tmrproc(struct hrtimer *htmr)
> > +{
> > +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> > +	int rval = HRTIMER_NORESTART;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ctx->lock, flags);
> > +	ctx->ticks++;
> > +	wake_up_locked(&ctx->wqh);
> > +	if (ctx->tintv.tv64 != 0) {
> > +		hrtimer_forward(htmr, htmr->base->softirq_time, ctx->tintv);
> 
> Sorry, I missed that in the first reviews. Please use
> hrtimer_cb_get_time(htmr) instead of htmr->base->softirq_time, so this
> is high res timer safe.

Heh, I was actually looking for a function instead of peeking over the 
tiemr strcture, but 2.6.20 did not have. Rebased over 2.6.21-rc3 now, so I 
can use it.




> > +		rval = HRTIMER_RESTART;
> > +	}
> > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > +
> > +	return rval;
> > +}
> > +
> > +
> > +static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> > +			 const struct itimerspec *ktmr)
> > +{
> 
> Make this void, returns 0 anyway

Ack



> > +	enum hrtimer_mode htmode;
> > +
> > +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_ABS: HRTIMER_REL;
> > +
> > +	ctx->ticks = 0;
> > +	ctx->clockid = clockid;
> > +	ctx->flags = flags;
> > +	ctx->texp = timespec_to_ktime(ktmr->it_value);
> 
> clockid is stored in the timer on setup, so no need to store it again.
> expiry time and flags are not used after setup.
> 
> Please remove those fields.

Ack



> > +	if (ufd == -1) {
> > +		ctx = kmem_cache_alloc(timerfd_ctx_cachep, GFP_KERNEL);
> > +		if (!ctx)
> > +			return -ENOMEM;
> > +
> > +		init_waitqueue_head(&ctx->wqh);
> > +		spin_lock_init(&ctx->lock);
> > +		ctx->clockid = -1;
> > +
> > +		error = timerfd_setup(ctx, clockid, flags, &ktmr);
> > +		if (error)
> > +			goto err_ctxfree;
> 
> Timer setup can not fail

Ack, the new version can't.



> > +		/*
> > +		 * When we call this, the initialization must be complete, since
> > +		 * aino_getfd() will install the fd.
> > +		 */
> > +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> > +				   &timerfd_fops, ctx);
> > +		if (error)
> > +			goto err_ctxfree;
> 
> Again: Please turn this around. No need to start the timer before we
> know, that everything works. 

The timerfd_setup() is not locked, so we need to make sure everything is 
setup, before advertising the fd (and aino_getfd does that).



> > +	kmem_cache_free(timerfd_ctx_cachep, ctx);
> > +}
> > +
> > +
> > +static int timerfd_close(struct inode *inode, struct file *file)
> > +{
> > +	timerfd_cleanup(file->private_data);
> > +	return 0;
> > +}
> > +
> 
> Please move the timerfd_cleanup code into close(). 

I usually prefer to have a cleanup function that works on the file's data, 
but I moved the code in the release function now.
Thx for the review! I'll repost a new version based on 2.6.21-rc3 ...




- Davide


