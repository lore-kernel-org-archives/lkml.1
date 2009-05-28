Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZE1XYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZE1XYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZE1XYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:24:36 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:58460 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZE1XYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:24:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18975.7470.792842.173625@cargo.ozlabs.ibm.com>
Date: Fri, 29 May 2009 09:24:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, Philip Mucci <mucci@eecs.utk.edu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] comments on Performance Counters for Linux (PCL)
In-Reply-To: <20090528213532.GA8589@elte.hu>
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com>
	<1243527919.6645.75.camel@laptop>
	<4A1EFCC2.80805@linux.vnet.ibm.com>
	<20090528213532.GA8589@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> >> So you're suggesting to artificually strech periods by say 
> >> composing a single overflow from smaller ones, ignoring the 
> >> intermediate overflow events?
> >>
> >> That sounds doable, again, patch welcome.
> >
> > I definitely agree with Stephane's point on this one.  I had 
> > assumed that long irq_periods (longer than the width of the 
> > counter) would be synthesized as you suggest.  If this is not the 
> > case, PCL should be changed so that it does, -or- at a minimum, 
> > the user should get an error back stating that the period is too 
> > long for the hardware counter.
> 
> this looks somewhat academic - at least on x86, even the fastest 
> events (say cycles) with a 32 bit overflow means one event per 
> second on 4GB. That's not a significant event count in practice. 
> What's the minimum width we are talking about on Power?

32 bits, but since the top bit is effectively a level-sensitive
interrupt request, the maximum period in hardware is 2^31 counts.

However, I already support 64-bit interrupt periods (well, 63-bit
actually) on powerpc by only calling perf_counter_overflow() when
counter->hw.period_left becomes <= 0, and arranging to set the
hardware counter to 0 if counter->hw.period_left is >= 0x80000000.
It's a tiny amount of code to handle it, really.

Paul.
