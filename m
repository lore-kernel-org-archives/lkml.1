Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZFBUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZFBUWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZFBUWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:22:12 -0400
Received: from www.tglx.de ([62.245.132.106]:38017 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZFBUWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:22:11 -0400
Date: Tue, 2 Jun 2009 22:21:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@fifo99.com>
cc: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
In-Reply-To: <1243943366.6592.434.camel@desktop>
Message-ID: <alpine.LFD.2.00.0906022218070.3419@localhost.localdomain>
References: <20090602071718.GA17710@linux-sh.org>  <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org>  <1243928495.23657.5642.camel@twins>  <20090602075409.GA19294@linux-sh.org> <1243943366.6592.434.camel@desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Daniel Walker wrote:
> On Tue, 2009-06-02 at 16:54 +0900, Paul Mundt wrote:
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > -       return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > -                                       * (NSEC_PER_SEC / HZ);
> > +       unsigned long long time;
> > +       struct clocksource *clock;
> > +
> > +       rcu_read_lock();
> > +       clock = rcu_dereference(sched_clocksource);
> > +       time = cyc2ns(clock, clocksource_read(clock));
> > +       rcu_read_unlock();
> > +
> > +       return time;
> >  }
> 
> My concerns with the locking here still stand. Nothing you've said or
> done bolsters the clocksource in modules argument. I think what your

Can you please stop to belabor modules? Again, it is totally
_irrelevant_ whether the clocksource is in a module or not.

unregister_clocksource() can be called from compiled in code as well
to replace a clocksource which is physically shut down. We have to
deal with that modules or not.

Thanks,

	tglx
