Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbZFBIAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbZFBIAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbZFBIAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:00:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53751 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbZFBIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:00:22 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090602075409.GA19294@linux-sh.org>
References: <20090602071718.GA17710@linux-sh.org>
	 <1243927502.23657.5619.camel@twins> <20090602073515.GB17710@linux-sh.org>
	 <1243928495.23657.5642.camel@twins>  <20090602075409.GA19294@linux-sh.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 10:00:03 +0200
Message-Id: <1243929603.23657.5662.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 16:54 +0900, Paul Mundt wrote:
> On Tue, Jun 02, 2009 at 09:41:35AM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-06-02 at 16:35 +0900, Paul Mundt wrote:
> > > 
> > > We already do via select_clocksource(), if we are unregistering the
> > > current one then a new one with the flag set is selected. Before that,
> > > the override is likewise given preference, and we fall back on jiffies if
> > > there is nothing else. I suppose we could try and find the "best" one,
> > > but I think the override and manual clocksource selection should be fine
> > > for this.
> > 
> > Ah, ok. So unregister calls select_clocksource again? That does leave us
> > a small window with jiffies, but I guess that's ok.
> > 
> A synchronize_rcu() would fix that up, but I think a small window with
> jiffies is less painful than sorting out RCU ordering and synchronization
> for a corner case of a corner case ;-)
> 
> > > Now that you mention it though, the sched_clocksource() assignment within
> > > select_clocksource() happens underneath the clocksource_lock, but is not
> > > using rcu_assign_pointer().
> > 
> > Right, that would want fixing indeed.
> > 
> > >  If the assignment there needs to use
> > > rcu_assign_pointer() then presumably all of the unlock paths that do
> > > select_clocksource() will have to synchronize_rcu()?
> > 
> > No, you only have to do sync_rcu() when stuff that could have referenced
> > is going away and you cannot use call_rcu().
> > 
> > So when selecting a new clocksource, you don't need synchonization
> > because stuff doesn't go away (I think :-)
> 
> Ok, that keeps things more simplified then. How does this look?


Looks fine to me,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
