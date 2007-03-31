Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbXCaBJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbXCaBJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbXCaBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:09:16 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58053 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbXCaBJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:09:15 -0400
Date: Fri, 30 Mar 2007 18:09:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/13] signal/timer/event fds v8 - timerfd core ...
Message-Id: <20070330180910.dd16a52f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703301734390.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415837.6>
	<20070330124005.0ec31aa6.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703301734390.3721@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 17:47:28 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Fri, 30 Mar 2007, Andrew Morton wrote:
> 
> > > +struct timerfd_ctx {
> > > +	struct hrtimer tmr;
> > > +	ktime_t tintv;
> > > +	spinlock_t lock;
> > > +	wait_queue_head_t wqh;
> > > +	unsigned long ticks;
> > > +};
> > 
> > Did you consider using the (presently unused) lock inside wqh instead of
> > adding a new one?  That's a little bit rude, poking into waitqueue
> > internals like that, but we do it elsewhere and tricks like that are
> > acceptable in core-kernel, I guess.
> 
> Please, no. Gain is not worth the plug into the structure design IMO.
> 

The decision is not that obvious - your patch's main use of
timerfd_ctx.lock is to provide locking for wqh - ie: to duplicate the
function of the existing lock which is there for that purpose.

So I think it's a legitimate optimisation to borrow it.

> 
> > > +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
> > > +{
> > > +	struct timerfd_ctx *ctx = container_of(htmr, struct timerfd_ctx, tmr);
> > > +	enum hrtimer_restart rval = HRTIMER_NORESTART;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&ctx->lock, flags);
> > > +	ctx->ticks++;
> > > +	wake_up_locked(&ctx->wqh);
> > > +	if (ctx->tintv.tv64 != 0) {
> > > +		hrtimer_forward(htmr, hrtimer_cb_get_time(htmr), ctx->tintv);
> > > +		rval = HRTIMER_RESTART;
> > > +	}
> > > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > > +
> > > +	return rval;
> > > +}
> > 
> > What's this do?
> 
> Really, do we need to comment such trivial code? There is *nothing* that 
> is worth a line of comment in there. IMO useless comment are more annoying 
> than blank lines.
> 

Look at it from the point of view of someone who knows kernel code but does
not specifically know this subsystem.  That describes the great majority of
people who will be reading your code.

> 
> 
> > > +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> > > +			  const struct itimerspec *ktmr)
> > > +{
> > > +	enum hrtimer_mode htmode;
> > > +	ktime_t texp;
> > > +
> > > +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
> > > +
> > > +	texp = timespec_to_ktime(ktmr->it_value);
> > > +	ctx->ticks = 0;
> > > +	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> > > +	hrtimer_init(&ctx->tmr, clockid, htmode);
> > > +	ctx->tmr.expires = texp;
> > > +	ctx->tmr.function = timerfd_tmrproc;
> > > +	if (texp.tv64 != 0)
> > > +		hrtimer_start(&ctx->tmr, texp, htmode);
> > > +}
> > 
> > What does the special case texp.tv64 == 0 signify?  Is that obvious to
> > anyone who understands hrtimers?  Is it something which we can expect
> > Micheal to immediately understand?  Should it be documented somewhere?
> 
> Michael should not read the code, but the patch description that comes 
> with it ;)
> 

To some extent, yes - there's a lot of material which is relevant to a
complex system call like this which isn't appropriate to code comments.

But a descrition of the role of texp.tv64 in here is an aid to
understanding the implementation and hence is appropriate and needed.

> 
> > > +asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
> > > +			    const struct itimerspec __user *utmr)
> > 
> > Somehow we need to get from this to a manpage.
> 
> Again, the patch description describes (modulo returned errno's) the API 
> pretty well.
> 

A basic description of the inputs, outputs and return value is appropriate
to most high-level kernel funtions.  One here won't hurt.

> 
> 
> > OK, this is briefly documented in the patch changelog.  That interface
> > documentation should be fleshed out and moved into the .c file.  a) because
> > it is easier to find and b) if we change it, it's a bit hard to go back and
> > alter that changelog!
> 
> I think it's better to leave it out of the code, and keep it in the patch 
> header.
> 

Patch headers are not maintainable.

Nobody wants to have to go off and waddle though the git repo to understand
the design intent behind each function.


Look, I'm just providing feedback as an experienced kernel developer who is
reading your code for the first time.  I had questions, and I saw things
which I felt were not adequately communicated.  You are the last person who
can judge what is obvious and what is not, because you already understand
it!

I do err on the make-it-easy-for-them side, but that's not a bad thing, I
think.  Very large numbers of people read core kernel code and the actual
change rate of this code will be low.  So we can afford to put the effort
into making these peoples' code-reading as productive as we can.


