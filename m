Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbXCKS2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbXCKS2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbXCKS2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:28:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33115 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977AbXCKS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:28:12 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Mar 2007 11:28:10 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd - timerfd core ...
In-Reply-To: <1173627447.24738.1243.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703111115050.12947@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703101822340.3613@alien.or.mcafeemobile.com>
 <1173627447.24738.1243.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, Thomas Gleixner wrote:

> Davide,
> 
> On Sat, 2007-03-10 at 18:22 -0800, Davide Libenzi wrote:
> 
> Some remarks:
> 
> > +
> > +asmlinkage long sys_timerfd(int ufd, int clockid, int tmrtype,
> > +			    const struct timespec __user *utmr)
> > +{
> > +	int error;
> > +	struct timerfd_ctx *ctx;
> > +	struct file *file;
> > +	struct inode *inode;
> > +	ktime_t tval, tnow;
> > +	struct timespec ktmr, tmrnow;
> > +
> > +	error = -EFAULT;
> > +	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> > +		goto err_exit;
> 
> Please do not use goto for a simple
> 		return -EFAULT;
> 
> Please validate the timespec before converting it.
> 
>         if (!timespec_valid(&ktmr))
>                 return -EINVAL;

Ack.


> > +	tval = timespec_to_ktime(ktmr);
> > +	error = -EINVAL;
> > +	if (clockid != CLOCK_MONOTONIC &&
> > +	    clockid != CLOCK_REALTIME)
> > +		goto err_exit;
> > +	switch (tmrtype) {
> > +	case TFD_TIMER_REL:
> > +	case TFD_TIMER_SEQ:
> > +		break;
> > +	case TFD_TIMER_ABS:
> > +		getnstimeofday(&tmrnow);
> > +		tnow = timespec_to_ktime(tmrnow);
> 
> 		tnow = ktime_get();

Ok, I think this is the wierd function that is declared static, whose 
symbol is exported, but is not declared in any .h file :)
I used that before, because I saw it inside the hrtimer.c file, but then 
gcc was puking on me, and I noticd the wierdness.



> > +		if (ktime_to_ns(tval) <= ktime_to_ns(tnow))
> > +			goto err_exit;
> > +		tval = ktime_sub(tval, tnow);
> 
> Why do you want to do that ? hrtimers handle relative and absolute
> expiry times. You break down everything to relative time and lose the
> accuracy for absolute timers. 

Yes. Those was in need of fixing. The first code I had was not working 
correctly with abs timers. Didn't have time to dig into it yet.
Will verify and fix today...



> > +
> > +		hrtimer_start(&ctx->tmr, ctx->tval, HRTIMER_REL);
> > +
> > +		/*
> > +		 * When we call this, the initialization must be complete, since
> > +		 * aino_getfd() will install the fd.
> > +		 */
> > +		error = aino_getfd(&ufd, &inode, &file, "[timerfd]",
> > +				   &timerfd_fops, ctx);
> > +		if (error)
> > +			goto err_fdalloc;
> 
> Why is the timer started before we have everything in place ? 

I simplify the error path. The fd does not need to be in place for the 
timer function to be correctly triggered.


> Also if you turn it around then the (re)programming part of the timer
> can be shared.

The two error/exit paths are different. One need to free the ctx, while 
the other one simply to do an fput().



> Please use hrtimer_try_to_cancel()
> 
> retry:
> 	spin_lock_irq(....):
> 	if (hrtimer_try_to_cancel(&ctx->tmr) < 0) {
> 		spin_unlock_irq();
> 		cpu_relax();
> 		goto retry;
> 	}

Ok, I will.



> > +static unsigned int timerfd_poll(struct file *file, poll_table *wait)
> > +{
> > +	struct timerfd_ctx *ctx = file->private_data;
> > +
> > +	poll_wait(file, &ctx->wqh, wait);
> > +
> > +	return ctx->ticks ? POLLIN: 0;
> 
> This is racy:
> 
> 	timer is set up (non periodic)
> 	timer expires
> 	poll 
> 
> 	now poll is stuck for ever !

Duh, yeah. I use the locked version of wakeups. Will fix.



- Davide


