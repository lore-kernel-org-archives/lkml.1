Return-Path: <linux-kernel-owner+w=401wt.eu-S1030702AbXCHV4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030702AbXCHV4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030698AbXCHV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:56:54 -0500
Received: from mail.screens.ru ([213.234.233.54]:37275 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030702AbXCHV4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:56:53 -0500
Date: Fri, 9 Mar 2007 00:56:53 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Message-ID: <20070308215653.GA6744@tv-sign.ru>
References: <20070308204353.GA6733@tv-sign.ru> <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Davide Libenzi wrote:
>
> On Thu, 8 Mar 2007, Oleg Nesterov wrote:
> 
> > Davide Libenzi wrote:
> > >
> > > +int signalfd_deliver(struct sighand_struct *sighand, int sig, struct siginfo *info)
> > > +{
> > > +	int nsig = 0;
> > > +	struct list_head *pos;
> > > +	struct signalfd_ctx *ctx;
> > > +	struct signalfd_sq *sq;
> > > +
> > > +	list_for_each(pos, &sighand->sfdlist) {
> > > +		ctx = list_entry(pos, struct signalfd_ctx, lnk);
> > > +		/*
> > > +		 * We use a negative signal value as a way to broadcast that the
> > > +		 * sighand has been orphaned, so that we can notify all the
> > > +		 * listeners about this.
> > > +		 */
> > > +		if (sig < 0)
> > > +			__wake_up_locked(&ctx->wqh, TASK_UNINTERRUPTIBLE | TASK_INTERRUPTIBLE);
> > > +		else if (sigismember(&ctx->sigmask, sig) &&
> > > +			 (sig >= SIGRTMIN || !sigismember(&ctx->pending, sig))) {
> > > +			sigaddset(&ctx->pending, sig);
> > 
> > I don't understand the "(sig >= SIGRTMIN || !sigismember(&ctx->pending, sig))"
> > check. This mimics the LEGACY_QUEUE() check, but seems strange. The signal may
> > be pending in ctx->pending just because it was not signalfd_fetchsig()ed, yes?
> 
> Logic is, if it's not an RT signal, queue only one, otherwise multiple.
> The bit on the ->pending mask is clealer only when the queue slot becomes empty.

Yes, I see what the code does, but I don't undestand why. For example, SIGCHLD was
delivered to the process _and_ handled several times, then sys_signalfd_dequeue()
comes and finds only one siginfo. Isn't this strange?

> > > @@ -780,6 +785,11 @@
> > >  	BUG_ON(!irqs_disabled());
> > >  	assert_spin_locked(&t->sighand->siglock);
> > >  
> > > +	/*
> > > +	 * Deliver the signal to listening signalfds ...
> > > +	 */
> > > +	signalfd_notify(t->sighand, sig, info);
> > > +
> > >  	/* Short-circuit ignored signals.  */
> > >  	if (sig_ignored(t, sig))
> > >  		goto out;
> > > @@ -968,6 +978,11 @@
> > >  	assert_spin_locked(&p->sighand->siglock);
> > >  	handle_stop_signal(sig, p);
> > >  
> > > +	/*
> > > +	 * Deliver the signal to listening signalfds ...
> > > +	 */
> > > +	signalfd_notify(p->sighand, sig, info);
> > > +
> > >  	/* Short-circuit ignored signals.  */
> > >  	if (sig_ignored(p, sig))
> > >  		return ret;
> > 
> > It is strange that we are doing signalfd_notify() even if the signal is ignored.
> > Isn't it better to shift signalfd_notify() into send_signal() ? This way we do
> > not need the special check in signalfd_deliver() above.
> 
> The two trasports can rely on different masks. The signalfd_notify() does 
> not even go in signalfd_deliver() if no signalfds are attached to the 
> sighand.

Sorry, I don't understand. The masks are different, yes, but ->sighand is the
same? How this can make any difference for "if no signalfds are attached" ?

OK. What is the purpose of signalfd? Should it record the signals which were
sent to the process, or only those which were delivered? The latter looks
more natural for me. But inn any case, I don't see a reason to check ->pending
mask in signalfd_deliver().

BTW, sys_signalfd_dequeue() re-queues signalfd_sq if copy_siginfo_to_user()
fails. Why not -EFAULT?

Also. A malicious user can eat all memory, signalfd_deliver()->kmem_cache_alloc()
doesn't check any limits.

> > Also, this patch doesn't take send_sigqueue/send_group_sigqueue into account.
> 
> I added that too. but I noticed something strange, dunno if intentional or 
> not. In send_sigqueue and send_group_sigqueue, the check for the 
> timer-special and the ignored is inverted. This lead to two different 
> behaviours. Is there a reason for that?

I was wondering about that too.

Oleg.

