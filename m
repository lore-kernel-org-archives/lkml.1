Return-Path: <linux-kernel-owner+w=401wt.eu-S1751639AbXCLSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbXCLSqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbXCLSqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:46:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33733 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbXCLSqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:46:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 12 Mar 2007 11:46:27 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v3 - timerfd core ...
In-Reply-To: <1173694763.13341.81.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703121142120.6936@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.5031.1173654242.6>
 <1173694763.13341.81.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Thomas Gleixner wrote:

> Davide,
> 
> On Sun, 2007-03-11 at 16:04 -0700, Davide Libenzi wrote:
> > +static int timerfd_setup(struct timerfd_ctx *ctx, int clockid, int tmrtype,
> > +			 const struct itimerspec *ktmr)
> > +{
> > +	enum hrtimer_mode htmode;
> > +	ktime_t texp, tintv;
> > +
> > +	if (clockid != CLOCK_MONOTONIC &&
> > +	    clockid != CLOCK_REALTIME)
> > +		return -EINVAL;
> 
> Please move the validation for clockid, tmrtype and the timerspec into
> sys_timerfd. Do it before anything else. Also please validate both
> it_value and it_interval unconditionally. Userspace should not send
> uninitialized stuff at all.

Ok.


> The TFD_TIMER_SEQ thing is quite different to all other timer interfaces
> which POSIX provides. Both itimers and posixtimers use the it_interval
> value to distinguish between one shot and periodic timers.
> 
> I think we should keep this new interface analogous, so programmers
> don't get more confused, than they are already. :)

Yeah, this was already suggested by  Nicholas Miell and was already in my 
code.



> This also allows relative and absolute starting points for both one shot
> and sequential timers.
> 
> Please use it_value == 0 to stop the timer. This is the same as for
> itimers and posixtimers. Right now you have to close the fd to stop a
> timer, but that's not necessarily what you want. 

This too.



> If you do the validation right in sys_timerfd and get rid of
> TFD_TIMER_SEQ and the various useless fields, then timerfd_setup() boils
> down to
> 
> 	ctx->ticks = 0;
> 	ctx->tintv = tintv;
> 	hrtimer_init(&ctx->tmr, clockid, htmode);
> 	ctx->tmr.function = timerfd_tmrproc;
> 
> 	if (texp.tv64 != 0)
> 		hrtimer_start(&ctx->tmr, texp, htmode);
> 
> and in the timer function you simply check for
> 
> 	if (ctx->tintv.tv64 != 0) 
> 
> instead of the TIMER_SEQ mode.

This was done too, although I did not know I could reference the tv64 
member directly, so I had a macro checking the timespec.



> > +	if (ufd == -1) {
> > +		error = -ENOMEM;
> > +		ctx = kmem_cache_alloc(timerfd_ctx_cachep, GFP_KERNEL);
> > +		if (!ctx)
> > +			goto err_exit;
> 
> 	return -ENOMEM;

Ok.



> > +		}
> > +		/*
> > +		 * We need to stop the exiting timer before.
> > +		 */
> 
> 	-ENOPARSE. You probably mean: We need to stop an already running timer
> before we do a new setup.

Bad description :)



- Davide


