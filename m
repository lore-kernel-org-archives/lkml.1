Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXCaArc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXCaArc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 20:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbXCaArb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 20:47:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47593 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213AbXCaArb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 20:47:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Mar 2007 17:47:28 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/13] signal/timer/event fds v8 - timerfd core ...
In-Reply-To: <20070330124005.0ec31aa6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703301734390.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415837.6>
 <20070330124005.0ec31aa6.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> > +struct timerfd_ctx {
> > +	struct hrtimer tmr;
> > +	ktime_t tintv;
> > +	spinlock_t lock;
> > +	wait_queue_head_t wqh;
> > +	unsigned long ticks;
> > +};
> 
> Did you consider using the (presently unused) lock inside wqh instead of
> adding a new one?  That's a little bit rude, poking into waitqueue
> internals like that, but we do it elsewhere and tricks like that are
> acceptable in core-kernel, I guess.

Please, no. Gain is not worth the plug into the structure design IMO.



> I find that the key to understanding kernel code is to understand the data
> structures and the relationships between them.  Once you have that in your
> head, the code tends to just fall out.  Hence there is good maintainability
> payoff in putting work into documenting the struct, its fields, the
> relationship between this struct and other structs, and any and all locking
> requirements.
> 
> <wonders wtf "ticks" does>

Seemed obvious to me, but comment added.



> > +static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr);
> > +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> > +			  const struct itimerspec *ktmr);
> > +static int timerfd_close(struct inode *inode, struct file *file);
> > +static unsigned int timerfd_poll(struct file *file, poll_table *wait);
> > +static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
> > +			    loff_t *ppos);
> 
> It'd be nice to find a way to make these declarations go away.

Gone.


> 
> > +
> > +
> > +
> 
> blankness.

You blank freak! :)



> > +static const struct file_operations timerfd_fops = {
> > +	.release	= timerfd_close,
> 
> Rename to timerfd_release

Done.




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
> What's this do?

Really, do we need to comment such trivial code? There is *nothing* that 
is worth a line of comment in there. IMO useless comment are more annoying 
than blank lines.





> > +static void timerfd_setup(struct timerfd_ctx *ctx, int clockid, int flags,
> > +			  const struct itimerspec *ktmr)
> > +{
> > +	enum hrtimer_mode htmode;
> > +	ktime_t texp;
> > +
> > +	htmode = (flags & TFD_TIMER_ABSTIME) ? HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
> > +
> > +	texp = timespec_to_ktime(ktmr->it_value);
> > +	ctx->ticks = 0;
> > +	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> > +	hrtimer_init(&ctx->tmr, clockid, htmode);
> > +	ctx->tmr.expires = texp;
> > +	ctx->tmr.function = timerfd_tmrproc;
> > +	if (texp.tv64 != 0)
> > +		hrtimer_start(&ctx->tmr, texp, htmode);
> > +}
> 
> What does the special case texp.tv64 == 0 signify?  Is that obvious to
> anyone who understands hrtimers?  Is it something which we can expect
> Micheal to immediately understand?  Should it be documented somewhere?

Michael should not read the code, but the patch description that comes 
with it ;)




> > +asmlinkage long sys_timerfd(int ufd, int clockid, int flags,
> > +			    const struct itimerspec __user *utmr)
> 
> Somehow we need to get from this to a manpage.

Again, the patch description describes (modulo returned errno's) the API 
pretty well.




> OK, this is briefly documented in the patch changelog.  That interface
> documentation should be fleshed out and moved into the .c file.  a) because
> it is easier to find and b) if we change it, it's a bit hard to go back and
> alter that changelog!

I think it's better to leave it out of the code, and keep it in the patch 
header.



> How come it's OK to truncate 64-bit timerfd_ctx.ticks to 32-bit like this?

2^32 ticks should be fine. I could make it a 64 bit thing, but IMO 32 bit 
is OK.



- Davide


