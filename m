Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbZFBHfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbZFBHfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZFBHfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:35:40 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33990 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbZFBHfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:35:39 -0400
Date: Tue, 2 Jun 2009 16:35:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
Message-ID: <20090602073515.GB17710@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Daniel Walker <dwalker@fifo99.com>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Stultz <johnstul@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090602071718.GA17710@linux-sh.org> <1243927502.23657.5619.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243927502.23657.5619.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:25:02AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-06-02 at 16:17 +0900, Paul Mundt wrote:
> 
> > @@ -362,6 +364,9 @@ static struct clocksource *select_clocksource(void)
> >  	if (next == curr_clocksource)
> >  		return NULL;
> >  
> > +	if (next->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK)
> > +		sched_clocksource = next;
> > +
> >  	return next;
> >  }
> >  
> > @@ -440,7 +445,21 @@ void clocksource_unregister(struct clocksource *cs)
> >  	list_del(&cs->list);
> >  	if (clocksource_override == cs)
> >  		clocksource_override = NULL;
> > +
> >  	next_clocksource = select_clocksource();
> > +
> > +	/*
> > +	 * If select_clocksource() fails to find another suitable
> > +	 * clocksource for sched_clocksource and we are unregistering
> > +	 * it, switch back to jiffies.
> > +	 */
> > +	if (sched_clocksource == cs) {
> > +		rcu_assign_pointer(sched_clocksource, &clocksource_jiffies);
> > +		spin_unlock_irqrestore(&clocksource_lock, flags);
> > +		synchronize_rcu();
> > +		return;
> > +	}
> > +
> >  	spin_unlock_irqrestore(&clocksource_lock, flags);
> >  }
> 
> 
> What if there's multiple CLOCK_SOURCE_USER_FOR_SCHED_CLOCK [ damn, thats
> a long name to type :-) ] ?
> 
> That is, should we have logic in select_clocksource that does:
> 
>   if ((next->flags & ..) && next->prio > sched_clocksource->prio)
> 
> or whatever, so that it picks the best one?
> 
> Same for unregister, should we re-evaluate all clocksources before
> falling back to basic?

We already do via select_clocksource(), if we are unregistering the
current one then a new one with the flag set is selected. Before that,
the override is likewise given preference, and we fall back on jiffies if
there is nothing else. I suppose we could try and find the "best" one,
but I think the override and manual clocksource selection should be fine
for this.

Now that you mention it though, the sched_clocksource() assignment within
select_clocksource() happens underneath the clocksource_lock, but is not
using rcu_assign_pointer(). If the assignment there needs to use
rcu_assign_pointer() then presumably all of the unlock paths that do
select_clocksource() will have to synchronize_rcu()?
