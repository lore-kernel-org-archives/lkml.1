Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXKTFkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXKTFkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbXKTFkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:40:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35842 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXKTFkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:40:01 -0500
Date: Mon, 19 Nov 2007 21:37:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071119213727.16d5917b@laptopd505.fenrus.org>
In-Reply-To: <200711201517.16171.nickpiggin@yahoo.com.au>
References: <47425EA5.7000607@rtr.ca>
	<200711201517.16171.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 15:17:15 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 20 November 2007 15:12, Mark Lord wrote:
> > On 32-bit x86, we have CONFIG_IRQBALANCE available,
> > but not on 64-bit x86.  Why not?

because the in-kernel one is actually quite bad.


> > My QuadCore box works very well in 32-bit mode with IRQBALANCE,
> > but responsiveness sucks bigtime when run in 64-bit mode (no
> > IRQBALANCE) during periods of multiple heavy I/O streams (USB flash
> > drives).

please run the userspace irq balancer, see http://www.irqbalance.org
afaik most distros ship that by default anyway.


> > As near as I can tell, when IRQBALANCE is not configured,
> > all I/O device interrupts go to CPU#0.

that depends on your chipset; some chipsets do worse than that.

>
> > I don't think our CPU scheduler takes that into account when
> > assigning tasks to CPUs, so anything sent to CPU0 runs with very
> > high latencies.
> >
> > Or something like that.
> >
> > Why no IRQ_BALANCE in 64-bit mode ?
> 
> For that matter, I'd like to know why it has been decided that the
> best place for IRQ balancing is in userspace. It should be in kernel
> IMO, and it would probably allow better power saving, performance,
> fairness, etc. if it were to be integrated with the task balancer as
> well.

actually.... no. IRQ balancing is not a "fast" decision; every time you
move an interrupt around, you end up causing a really a TON of cache
line bounces, and generally really bad performance (esp if you do it
for networking ones, since you destroy the packet reassembly stuff in
the tcp/ip stack).

Instead, what ends up working is if you do high level categories of
interrupt classes and balance within those (so that no 2 networking
irqs are on the same core/package unless you have more nics than cores)
etc. Balancing on a 10 second scale seems to work quite well; no need
to pull that complexity into the kernel.... 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
