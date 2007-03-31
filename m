Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbXCaTrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbXCaTrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 15:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXCaTrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 15:47:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:48153 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbXCaTrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 15:47:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 31 Mar 2007 12:46:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/13] signal/timer/event fds v8 - timerfd core ...
In-Reply-To: <20070330180910.dd16a52f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703311238230.22390@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415837.6>
 <20070330124005.0ec31aa6.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703301734390.3721@alien.or.mcafeemobile.com>
 <20070330180910.dd16a52f.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> On Fri, 30 Mar 2007 17:47:28 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > On Fri, 30 Mar 2007, Andrew Morton wrote:
> > 
> > > > +struct timerfd_ctx {
> > > > +	struct hrtimer tmr;
> > > > +	ktime_t tintv;
> > > > +	spinlock_t lock;
> > > > +	wait_queue_head_t wqh;
> > > > +	unsigned long ticks;
> > > > +};
> > > 
> > > Did you consider using the (presently unused) lock inside wqh instead of
> > > adding a new one?  That's a little bit rude, poking into waitqueue
> > > internals like that, but we do it elsewhere and tricks like that are
> > > acceptable in core-kernel, I guess.
> > 
> > Please, no. Gain is not worth the plug into the structure design IMO.
> > 
> 
> The decision is not that obvious - your patch's main use of
> timerfd_ctx.lock is to provide locking for wqh - ie: to duplicate the
> function of the existing lock which is there for that purpose.
> 
> So I think it's a legitimate optimisation to borrow it.

As I see it, the lock protects the ticks and the timer structure, and the 
wait queue *happen* to have a lock inside. That's the whole purpose in 
having data modeled by structures with accessor functions.
IMO, given that we'd get by plugging into the wait_queue_head_t lock is 
not much (if at all), it'd be better to to peek at the wait_queue_head_t 
directly.




> > > > +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
> > > > +{
> > > > +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> > > > +	enum hrtimer_restart rval = HRTIMER_NORESTART;
> > > > +	unsigned long flags;
> > > > +
> > > > +	spin_lock_irqsave(&ctx->lock, flags);
> > > > +	ctx->ticks++;
> > > > +	wake_up_locked(&ctx->wqh);
> > > > +	if (ctx->tintv.tv64 != 0) {
> > > > +		hrtimer_forward(htmr, hrtimer_cb_get_time(htmr), ctx->tintv);
> > > > +		rval = HRTIMER_RESTART;
> > > > +	}
> > > > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > > > +
> > > > +	return rval;
> > > > +}
> > > 
> > > What's this do?
> > 
> > Really, do we need to comment such trivial code? There is *nothing* that 
> > is worth a line of comment in there. IMO useless comment are more annoying 
> > than blank lines.
> > 
> 
> Look at it from the point of view of someone who knows kernel code but does
> not specifically know this subsystem.  That describes the great majority of
> people who will be reading your code.

Okie, I added a comment ;)



> Patch headers are not maintainable.
> 
> Nobody wants to have to go off and waddle though the git repo to understand
> the design intent behind each function.

I agree. I thought we were talking about the "poor smuck" having to 
document it, and the patch header is a pretty good start (and maybe 
finish ;).



- Davide


