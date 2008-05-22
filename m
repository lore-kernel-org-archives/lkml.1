Return-Path: <linux-kernel-owner+w=401wt.eu-S933357AbYEVM44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357AbYEVM44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759827AbYEVM4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:56:45 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55060 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227AbYEVM4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:56:44 -0400
Date: Thu, 22 May 2008 15:55:53 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it is queued
Message-ID: <20080522115553.GB117@tv-sign.ru>
References: <20080517151420.GA9496@tv-sign.ru> <20080521022046.1501F26FA1C@magilla.localdomain> <20080521115414.GA147@tv-sign.ru> <20080521184245.5BABF26FA24@magilla.localdomain> <alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org> <20080521193348.64E8C26FA24@magilla.localdomain> <alpine.LFD.1.10.0805211245131.3081@woody.linux-foundation.org> <20080521230135.BF65A26FA24@magilla.localdomain> <20080522111211.GA117@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522111211.GA117@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22, Oleg Nesterov wrote:
>
> On 05/21, Roland McGrath wrote:
> >
> > -void flush_sigqueue(struct sigpending *queue)
> > +static void __flush_sigqueue(struct sigpending *queue, int timers)
> >  {
> >  	struct sigqueue *q;
> >  
> >  	sigemptyset(&queue->signal);
> >  	while (!list_empty(&queue->list)) {
> >  		q = list_entry(queue->list.next, struct sigqueue , list);
> > +		if (timers && q->info.si_code != SI_TIMER)
> > +			continue;
> >  		list_del_init(&q->list);
> >  		__sigqueue_free(q);
> >  	}
> >  }
> 
> This is not enough. Again, we remove and free sigqueue but don't discard
> the pending signal. (and we must take into account other rt signals with
> the same si_signo if we want to discard the signal).
> 
> Oh, this problem is unexpectedly nasty. It is trivial and minor, we can
> solve it in may ways, but personally I can't find a simple/clean way.
> 
> Let's look at my first attempt,
> 
> 	http://marc.info/?l=linux-kernel&m=120888210417700
> 
> the patch was "almost" correct.
> We can add the "bool cancel" parameter to sigqueue_free(), true when
> called from exec (or exit_itimers). In that case SIGQUEUE_SHARED_PENDING
> is enough: the pending signal was either sent to current, or it is group
> wide. Not nice too of course, but afaics a bit simpler.

I take my words back. It is not simpler. How about

	void xxx(struct sigpending *pending)
	{
		struct sigqueue *q;
		sigset_t drop, retain;

		sigemptyset(&drop);
		sigemptyset(&retain);

		list_for_each_entry_safe(q) {
			int sig = q->info.si_signo;

			// it is better to add another SIGQUEUE_ flag...
			if (q->info.si_code == SI_TIMER) {
				list_del_init(&q->list);
				__sigqueue_free(q);
				sigaddset(&drop, sig);
			} else
				sigaddset(&retain, sig);
		}

		// pseudo code
		pending->signal &= ~(drop & ~retain);
	}

?

This helper is called somewhere near flush_signal_handlers() or
de_thread()->exit_itimers().

We still need the "sigqueue_free: don't free sigqueue if it is queued"
patch of course.

Oleg.

