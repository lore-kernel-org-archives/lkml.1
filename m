Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYGQNwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYGQNwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYGQNwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:52:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45605 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515AbYGQNwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:52:33 -0400
Date: Thu, 17 Jul 2008 17:55:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Mark McLoughlin <markmc@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timers: Do not modify an already queued timer signal
Message-ID: <20080717135556.GA770@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com> <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216292911.28332.12.camel@muff>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Mark McLoughlin wrote:
>
> On Wed, 2008-07-16 at 20:21 +0400, Oleg Nesterov wrote:
> > On 07/16, Mark McLoughlin wrote:
> > >
> > > When a timer fires, posix_timer_event() zeroes out its
> > > pre-allocated siginfo structure, initialises it and then
> > > queues up the signal with send_sigqueue().
> > >
> > > However, we may have previously queued up this signal, in
> > > which case we only want to increment si_overrun and
> > > re-initialising the siginfo structure is incorrect.
> >
> > Quoting Roland McGrath:
> > 	>
> > 	> I'm not clear on how the already-queued case could ever happen.  Do we
> > 	> really need that check at all?  It shouldn't be possible for the timer to
> > 	> be firing when it's already queued, because it won't have been reloaded.
> > 	> It only reloads via do_schedule_next_timer after it's dequeued, or because
> > 	> a 1 return value said it never was queued.
>
> The app can reload the timer itself before the signal has been dequeued
> via signalfd ...

Indeed! Thanks Mark.

Thomas, Roland, could you take a look?


> > If we need this fix, perhaps it is better to modify posix_timer_event()
> > to check !list_empty()?
>
> Yeah, I had considered that, but it's a tad more invasive. See below.
>
> I mainly don't like this patch

Agreed, this one looks worse.


I forgot (if ever knew ;) this code completely, but can't we make a simpler
fix? posix_timer_event() can check list_empty() lockless,

	posix_timer_event()
	{
		if (!list_emtpy(sigq->list))
			return 0;

		... fill and send ->sigq...
	}

When the signal will be dequeued, schedule_next_timer() should afaics
set ->it_overrun_last which is copied to ->si_overrun then. Or we can
increment timr->it_overrun before return if I misread hrtimer_forward().

What do you think?


Another possible fix... we can change sys_timer_settime() to do
sigqueue_free() and re-alloc ->sigq when it is pending. Not that
I like this very much though.

Oleg.

