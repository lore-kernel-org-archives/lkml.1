Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580Ab0AMVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0AMVUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518Ab0AMVU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:20:29 -0500
Received: from ms01.sssup.it ([193.205.80.99]:45919 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755504Ab0AMVU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:20:29 -0500
Date: Wed, 13 Jan 2010 22:30:55 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: fork and terminate task logic
Message-ID: <20100113213055.GB4126@gandalf.sssup.it>
References: <1255707324.6228.448.camel@Palantir>
 <1255707661.6228.455.camel@Palantir>
 <1262100041.7135.157.camel@laptop>
 <1263381067.3853.103.camel@Palantir>
 <1263399311.4244.230.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263399311.4244.230.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, Jan 13, 2010 05:15:11PM +0100
>
> On Wed, 2010-01-13 at 12:11 +0100, Raistlin wrote:
> 
> > > > +       } else if (rt_prio(p->prio))
> > > > +               p->sched_class = &rt_sched_class;
> > > > +       else
> > > >                 p->sched_class = &fair_sched_class;
> > > >  
> > > >  #ifdef CONFIG_SMP
> > > > @@ -2744,6 +2756,10 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
> > > >         if (mm)
> > > >                 mmdrop(mm);
> > > >         if (unlikely(prev_state == TASK_DEAD)) {
> > > > +               /* a deadline task is dying: stop the bandwidth timer */
> > > > +               if (deadline_task(prev))
> > > > +                       hrtimer_cancel(&prev->dl.dl_timer);
> > > > +
> > > >                 /*
> > > >                  * Remove function-return probe instances associated with this
> > > >                  * task and put them back on the free list. 
> > > 
> > > Shouldn't this be done in the ->dequeue_task() callback?
> > >
> > Not sure of this snippet... Actually, it is one of the most disturbing
> > piece of code of this whole scheduler. :-(
> > 
> > The reason why it is here is that I think it is needed to call
> > hrtimer_cancel() _without_ holding the rq->lock, is that correct?
> 
> I think we can nest the hrtimer base lock inside the rq->lock these
> days, so it should be safe to call while holding it, anyway, lockdep
> will quickly tell you if you try ;-)
> 

I may be wrong, but the race here should be between the hrtimer_cancel()
and the handler itself (which takes rq->lock): if the timer handler is
running on a different cpu and still it has not entered its critical section
we may end up here waiting for it to terminate, but that will never happen.

If we are able to enforce that both hrtimer_cancel() and the timer
handler are always executed on the same cpu then we should be safe, because
this code would never be executed with a running handler.
