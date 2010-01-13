Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958Ab0AMQPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0AMQPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896Ab0AMQPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:15:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab0AMQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:15:43 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: fork and terminate task logic
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
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
In-Reply-To: <1263381067.3853.103.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707661.6228.455.camel@Palantir>  <1262100041.7135.157.camel@laptop>
	 <1263381067.3853.103.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jan 2010 17:15:11 +0100
Message-ID: <1263399311.4244.230.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 12:11 +0100, Raistlin wrote:

> > > +       } else if (rt_prio(p->prio))
> > > +               p->sched_class = &rt_sched_class;
> > > +       else
> > >                 p->sched_class = &fair_sched_class;
> > >  
> > >  #ifdef CONFIG_SMP
> > > @@ -2744,6 +2756,10 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
> > >         if (mm)
> > >                 mmdrop(mm);
> > >         if (unlikely(prev_state == TASK_DEAD)) {
> > > +               /* a deadline task is dying: stop the bandwidth timer */
> > > +               if (deadline_task(prev))
> > > +                       hrtimer_cancel(&prev->dl.dl_timer);
> > > +
> > >                 /*
> > >                  * Remove function-return probe instances associated with this
> > >                  * task and put them back on the free list. 
> > 
> > Shouldn't this be done in the ->dequeue_task() callback?
> >
> Not sure of this snippet... Actually, it is one of the most disturbing
> piece of code of this whole scheduler. :-(
> 
> The reason why it is here is that I think it is needed to call
> hrtimer_cancel() _without_ holding the rq->lock, is that correct?

I think we can nest the hrtimer base lock inside the rq->lock these
days, so it should be safe to call while holding it, anyway, lockdep
will quickly tell you if you try ;-)

> It is 

Is that a stmt or an unfinished sentence?

