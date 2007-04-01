Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXDARAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXDARAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXDARAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:00:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48850 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbXDARAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:00:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 1 Apr 2007 10:00:13 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/13] signal/timer/event fds v9 - timerfd core ...
In-Reply-To: <1175418341.28263.64.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0704010941490.26331@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.16816.1175371772.6>
 <1175418341.28263.64.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Thomas Gleixner wrote:

> On Sat, 2007-03-31 at 13:09 -0700, Davide Libenzi wrote:
> > +/*
> > + * This gets called when the timer event triggers. We increment the
> > + * tick count and wake the possible waiters. If the timer in a
> > + * sequential one (->tintv.tv64 != 0), we re-arm it with hrtimer_forward().
> > + */
> > +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
> > +{
> > +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> > +	enum hrtimer_restart rval = HRTIMER_NORESTART;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&ctx->lock, flags);
> > +	ctx->ticks++;
> > +	wake_up_locked(&ctx->wqh);
> > +	if (ctx->tintv.tv64 != 0) {
> > +		hrtimer_forward(htmr, hrtimer_cb_get_time(htmr), ctx->tintv);
> > +		rval = HRTIMER_RESTART;
> > +	}
> > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > +
> > +	return rval;
> > +}
> 
> For periodic timers we probably want to know also about missed ticks,
> i.e. when the timer was delayed.
> 
> I changed recently the rearm handling code of itimers to prevent DoS
> attacks. See commit 8bfd9a7a229b5f3d3eda5d7d45c2eebec5b4ba16. The posix
> timer code has a similar mechanism.
> 
> Probably we should do the same here. That means that we defer the
> restart of the timer to the process context.

But timerfd has that implicit, in the ticks counter. So if you get ticks > 1
it means you did not read-out (miss) one or more.
By re-arming the timer whenever you read it, that may be some time after 
it expired. IMO the behaviour is better as it is now, and if you want the 
new timer sequence start at a new timeframe, you just use timerfd with the 
same fd.
I do not know about DoS on timers (did not follow the thread), but I could 
easily implement it here, by capping the counter to some value, and return 
POLLERR in poll().
I'd prefer that instead of the re-arm on read thing.


- Davide


