Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZCXWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZCXWCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZCXWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:01:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZCXWBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:01:44 -0400
Date: Tue, 24 Mar 2009 23:01:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, r.schwebel@pengutronix.de,
       torvalds@linux-foundation.org, blaschka@linux.vnet.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash",
Message-ID: <20090324220111.GC29509@elte.hu>
References: <20090324160241.GA11060@elte.hu> <20090324191900.GA24595@elte.hu> <20090324205444.GA11693@elte.hu> <20090324.141702.206697701.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324.141702.206697701.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 24 Mar 2009 21:54:44 +0100
> 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > Same forcedeth box i reported before. Config below. (note: if 
> > > > you want to use it you need to run it through 'make oldconfig', 
> > > > with all defaults accepted)
> > > 
> > > Hm, i just had a test failure (hung interface) with this too.
> > > 
> > > I'll go back to the original straight revert of "303c6a0: gro: Fix 
> > > legacy path napi_complete crash", and will test it overnight - to 
> > > establish a baseline of stability again. (to make sure there are 
> > > no other bugs interacting)
> > 
> > FYI, this plain revert is holding up fine in my tests so far - 50 
> > random iterations - the previous one failed after 5 iterations.
> 
> Something must be up with respect to letting interrupts in during 
> certain windows of time, or similar.
> 
> I'll take a look at this and hopefully Herbert or myself will be 
> able to figure it out.

It definitely did not show usual patterns of bug behavior - i'd have 
found it yesterday morning if it did.

I spent most of the time trying to find a reliable reproducer 
.config and system. Sometimes the bug went away with a minor change 
in the .config. Until today i didnt even suspect a mainline change 
causing this.

Also, note that i have reduced the probability of UP kernels in my 
randconfigs artificially to about 12.5% (it is 50% upstream). Still, 
despite that measure, the 'best' .config i found was an UP config - 
i dont think that's an accident. Also, i had to fully saturate the 
target CPU over gigabit to hit the bug best.

Which suggests to me (empirically) that it's indeed a race and that 
it needs a saturated system with lots of IRQs to trigger, and 
perhaps that it needs saturated/overloaded network device queues and 
complex userspace/softirq/hardirq interactions.

	Ingo
