Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXAZLxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXAZLxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933206AbXAZLxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:53:10 -0500
Received: from mail.screens.ru ([213.234.233.54]:54120 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933205AbXAZLxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:53:09 -0500
Date: Fri, 26 Jan 2007 14:52:33 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: S?bastien Dugu? <sebastien.dugue@bull.net>
Cc: Laurent Vivier <laurent.vivier@bull.net>,
       Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: + aio-completion-signal-notification.patch added to -mm tree
Message-ID: <20070126115233.GA142@tv-sign.ru>
References: <20070125162141.GA226@tv-sign.ru> <20070126121407.1437928a@frecb000686>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126121407.1437928a@frecb000686>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, S?bastien Dugu? wrote:
>
> On Thu, 25 Jan 2007 19:21:41 +0300 Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > > +	target = good_sigevent(&event);
> > > +
> > > +	if (unlikely(!target || (target->flags & PF_EXITING)))
> > > +		goto out_unlock;
> > 
> > PF_EXITING check is racy and unneded. In fact, it is wrong. If the main
> > thread is already died, we can only use SIGEV_THREAD_ID signals, because
> > otherwise good_sigevent() returns ->group_leader.
> 
>   Care to explain here please, I'm not following you.

My apologies, I was unclear.

This check is racy, the condition could be changed right after the check.

It is unneeded, it is ok to do send_sigqueue(tsk) if if that task is already
dead. (we hold the reference to task_struct).

Now suppose that the main thread (->group_leader) already exited. This is
normal, the thread group is still alive, it should be ok to send a signal to
it via send_group_sigqueue(). But we can't: without SIGEV_THREAD_ID in
->sigev_notify good_event() returns ->group_leader, and it has PF_EXITING.

Yes, kernel/posix-timers.c needs a cleanup too. But please note that it does
this check for another reason (according to the comment). This reason is not
valid now, the callsite for exit_itimers() was moved from __exit_signal() to
do_exit().

> > > +	if (iocb->ki_notify.notify != SIGEV_NONE) {
> > > +		ret = aio_send_signal(&iocb->ki_notify);
> > > +
> > > +		/* If signal generation failed, release the sigqueue */
> > > +		if (ret)
> > > +			sigqueue_free(iocb->ki_notify.sigq);
> > 
> > We should not use sigqueue_free() here. It takes current->sighand->siglock
> > to remove sigqueue from "struct sigpending". But current is just a "random"
> > process here.
> > 
> > Yes, if I understand this patch correctly, it is not possible that this
> > sigqueue is pending, but still this is bad imho.
> 
>  Yes, in fact the sigqueue is used for a single signal delivery and then
> free. In fact I could have used directly __sigqueue_free() instead here
> except for the fact that it's private to signal.c and I'm reluctant
> to export it to other subsystems.

I personally think it is better to export __sigqueue_free() even if sigqueue_free()
happens to work. It is to fragile imho to reference current->sighand. At least
we need a fat comment.

> > >  static void __sigqueue_free(struct sigqueue *q)
> > >  {
> > > -	if (q->flags & SIGQUEUE_PREALLOC)
> > > +	if (q->flags & SIGQUEUE_PREALLOC && q->info.si_code != SI_ASYNCIO)
> > >  		return;
> > 
> > Oh, this is not nice. Could we change send_sigqueue/send_group_sigqueue
> > instead ?
> 
>   Yep, that's the other solution.
> 
> > 
> > -	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
> > +	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC) && q->info.si_code != SI_ASYNCIO);
> > 
> > This way aio can use __sigqueue_alloc/__sigqueue_free directly and forget
> > about SIGQUEUE_PREALLOC.
> 
>   Well, I don't think it's cleaner. The aio error path calls sigqueue_free()
> directly whereas in case of success sigqueue_free() is called from the signal
> delivery path.

Hmm... now I don't understand you. Of course, the aio error path should use
__sigqueue_free() if we don't use SIGQUEUE_PREALLOC (and imho we should not).

And the signal delivery path uses __sigqueue_free() too.

?

> > I'd suggest to not use this interface. Just use group_send_sig_info() or
> > specific_send_sig_info(). Yes, this way we will do GFP_ATOMIC allocation
> > of sigqueue in interrupt context, but is this so bad in this case?
> 
>   Well, the thihere is that in the past we used group_send_sig_info()
> and specific_send_sig_info() for notification but Zach Brown raised
> the question about reliable signal delivery. IOW an aio submission
> should not succeed if signal delivery is going to fail. Hence the
> use of the preallocated sigqueue.

Ok, I see, thanks.

Oleg.

