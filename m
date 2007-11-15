Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbXKOL2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbXKOL2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbXKOL2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:28:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50927 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXKOL2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:28:41 -0500
Date: Thu, 15 Nov 2007 12:28:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Message-ID: <20071115112820.GA18228@elte.hu>
References: <20071114225335.GV19691@waste.org> <20071114.154143.112110604.davem@davemloft.net> <20071115104331.GA11390@elte.hu> <200711152157.59409.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711152157.59409.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Thursday 15 November 2007 21:43, Ingo Molnar wrote:
> > * David Miller <davem@davemloft.net> wrote:
> > > From: Matt Mackall <mpm@selenic.com>
> > > Date: Wed, 14 Nov 2007 17:37:13 -0600
> > >
> > > > No, the usual strategy for debugging problems -outside- SLOB is to
> > > > switch to another allocator with more extensive debugging facilities.
> > >
> > > Ok, so the thing we still can do is do a dump_stack() at the list
> > > debugging assertion trigger points.
> >
> > ok, i'll first try to trigger it again.
> 
> I had implemented SLOB in userspace, so I resynched and think I found 
> your problem. Sorry for the attachment format -- this mailer isn't the 
> best. I'm really computer illiterate when it comes to userspace...

thx, i'll try your fix in a minute.

> Anyway, I'm really happy to see you're testing and using SLOB upstream
> :) Is there any particular reason that you're using it?

i sometimes test SLOB for -rt, but this time it's the result of my 
"automated random QA" effort, as part of arch/x86 maintainance/QA.

the main trick is to build and booting random "make randconfig" 
bzImages. That finds build bugs and a good deal of boot hang and crash 
bugs as well. (it also found a compiler bug already) I can build and 
boot about 1000 random kernels in 24 hours, and it's all fully 
automated. I usually run it overnight - when a kernel does not come up 
due to a bootup hang or crash (or the kernel log signals any exception 
condition) then the script stops and i can fix it in the morning.

The first step towards this was to get allyesconfig bzImage kernels to 
build and boot fine. That effort took months (we had many problems in 
this area) - i think you saw bugreports and fixes from me about that on 
lkml.

Once that worked reasonably well i made a small Kconfig patch that 
forcibly selects a "minimum set" of drivers and kernel subsystems that 
are needed to boot up a testsystem. Once a "make allnoconfig" and a 
"make allyesconfig" bzImage kernel boots up fine on the testbox all 
randconfig configs "inbetween" are supposed to build and boot fine as 
well.

I also have a patch that adds all the x86 boot options like nosmp, 
maxcpus=1, nohz=off, hpet=disable to be selectable as .config options - 
so those boot options are randomized as well.

I also have a small patch that disables half a dozen drivers/features 
that are not expected to work out of box in a bzImage kernel. (such as 
ISA drivers that assume the presence of hardware, or root filesystem 
features such as NFSROOT)

the resulting make randconfig kernel still has 99% of the degrees of 
freedom that a stock make randconfig kernel has, so by all practical 
purposes it's a fully random kernel - it just happens to boot on my 
testsystem all the time.

A successful bootup means the test system is able to boot up into a 
stock Fedora 8 userspace and is able to bring up its network interfaces 
and ssh out (automatically) to the build box to signal the completion of 
a successful test cycle. The logs are also analyzed for lockdep 
assertions (if lockdep is enabled - which it is in about 20% of the 
randconfig kernels) and other kernel bugs.

(just in case you were wondering about one of the reasons why the 
arch/x86 unification merge went so smoothly, with nary a regression ;-) 
Thomas is doing other types of automated QA of the x86 queue as well.)

this method found the SG-list corruption bugs the following night after 
Linus committed Jen's SG-list changes, so it's pretty good at finding 
regressions as early as possible.

	Ingo
