Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbZE3TRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbZE3TRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 15:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbZE3TRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 15:17:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60915 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466AbZE3TRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 15:17:22 -0400
Date: Sat, 30 May 2009 21:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Carl Love <cel@us.ibm.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] comments on Performance Counters for Linux (PCL)
Message-ID: <20090530191629.GA3105@elte.hu>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com> <1243527919.6645.75.camel@laptop> <4A1EFCC2.80805@linux.vnet.ibm.com> <20090528213532.GA8589@elte.hu> <18975.7470.792842.173625@cargo.ozlabs.ibm.com> <20090529071914.GB3157@elte.hu> <alpine.LRH.2.00.0905291020200.21748@vixen.sonytel.be> <1243608160.6534.46.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243608160.6534.46.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Carl Love <cel@us.ibm.com> wrote:

> 
> On Fri, 2009-05-29 at 10:21 +0200, Geert Uytterhoeven wrote:
> > On Fri, 29 May 2009, Ingo Molnar wrote:
> > > * Paul Mackerras <paulus@samba.org> wrote:
> > > > Ingo Molnar writes:
> > > > > * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> > > > > >> So you're suggesting to artificually strech periods by say 
> > > > > >> composing a single overflow from smaller ones, ignoring the 
> > > > > >> intermediate overflow events?
> > > > > >>
> > > > > >> That sounds doable, again, patch welcome.
> > > > > >
> > > > > > I definitely agree with Stephane's point on this one.  I had 
> > > > > > assumed that long irq_periods (longer than the width of the 
> > > > > > counter) would be synthesized as you suggest.  If this is not the 
> > > > > > case, PCL should be changed so that it does, -or- at a minimum, 
> > > > > > the user should get an error back stating that the period is too 
> > > > > > long for the hardware counter.
> > > > > 
> > > > > this looks somewhat academic - at least on x86, even the fastest 
> > > > > events (say cycles) with a 32 bit overflow means one event per 
> > > > > second on 4GB. That's not a significant event count in practice. 
> > > > > What's the minimum width we are talking about on Power?
> > > > 
> > > > 32 bits, but since the top bit is effectively a level-sensitive 
> > > > interrupt request, the maximum period in hardware is 2^31 counts.
> > > > 
> > > > However, I already support 64-bit interrupt periods (well, 63-bit 
> > > > actually) on powerpc by only calling perf_counter_overflow() when 
> > > > counter->hw.period_left becomes <= 0, and arranging to set the 
> > > > hardware counter to 0 if counter->hw.period_left is >= 0x80000000. 
> > > > It's a tiny amount of code to handle it, really.
> > > 
> > > No argument about that - just wanted to know whether there's any 
> > > real practical effect beyond the nitpicking factor ;-)
> > 
> > I never really dived into this stuff, but ISTR there are some 16-bit counters
> > on CELL? Is that correct?
> 
> FYI, the counters on CELL are configurable.  You can have up to 
> eight 16 bit count counters or you can combine counters i and i=1 
> (where i=0,2,4,6) into 32 bit counters.  This allows you to have 
> some 16 and some 32 bit counters at the same time.

If 16-bit counters are exposed then this can be solved like the 
PowerPC perfcounters code does it: by not propagating 'early' IRQs 
back to the generic layer but continuing it until the real threshold 
has been reached.

	Ingo
