Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZFBUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZFBUTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZFBUSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:18:24 -0400
Received: from www.tglx.de ([62.245.132.106]:36754 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZFBUSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:18:23 -0400
Date: Tue, 2 Jun 2009 22:17:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
In-Reply-To: <1243928495.23657.5642.camel@twins>
Message-ID: <alpine.LFD.2.00.0906022216230.3419@localhost.localdomain>
References: <20090602071718.GA17710@linux-sh.org>  <1243927502.23657.5619.camel@twins>  <20090602073515.GB17710@linux-sh.org> <1243928495.23657.5642.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009, Peter Zijlstra wrote:

> On Tue, 2009-06-02 at 16:35 +0900, Paul Mundt wrote:
> > 
> > We already do via select_clocksource(), if we are unregistering the
> > current one then a new one with the flag set is selected. Before that,
> > the override is likewise given preference, and we fall back on jiffies if
> > there is nothing else. I suppose we could try and find the "best" one,
> > but I think the override and manual clocksource selection should be fine
> > for this.
> 
> Ah, ok. So unregister calls select_clocksource again? That does leave us
> a small window with jiffies, but I guess that's ok.
> 
> > Now that you mention it though, the sched_clocksource() assignment within
> > select_clocksource() happens underneath the clocksource_lock, but is not
> > using rcu_assign_pointer().
> 
> Right, that would want fixing indeed.
> 
> >  If the assignment there needs to use
> > rcu_assign_pointer() then presumably all of the unlock paths that do
> > select_clocksource() will have to synchronize_rcu()?
> 
> No, you only have to do sync_rcu() when stuff that could have referenced
> is going away and you cannot use call_rcu().
> 
> So when selecting a new clocksource, you don't need synchonization
> because stuff doesn't go away (I think :-)

Hmm, no. In the unregister case stuff _IS_ going away. That's why you
unregister in the first place, right ?

Thanks,

	tglx


