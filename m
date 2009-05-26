Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbZEZXnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbZEZXnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbZEZXnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:43:14 -0400
Received: from www.tglx.de ([62.245.132.106]:38500 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505AbZEZXnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:43:14 -0400
Date: Wed, 27 May 2009 01:39:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <1243378835.3275.30.camel@localhost>
Message-ID: <alpine.LFD.2.00.0905270129210.1762@localhost.localdomain>
References: <20090526061532.GD9188@linux-sh.org>  <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>  <1243348681.23657.14.camel@twins>  <1243369423.3275.5.camel@localhost>  <1243369815.6600.2.camel@laptop>  <1243370439.3275.13.camel@localhost> 
 <1243371309.6600.8.camel@laptop> <1243378835.3275.30.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, john stultz wrote:
w> > > Is latency all we care about? How bad would
> > > the TSC have to be before we wouldn't want to use it?
> > 
> > Anything better than jiffies ;-)
> 
> Except HPET thought, right? :)

Eeek. HPET access serializes across cores. That's orders of magnitudes
worse than the granularity loss of jiffies.

> > For sched_clock() we want something high-res that is monotonic per cpu
> > and has a bounded drift between cpus in the order of jiffies.
> > 
> > Look at kernel/sched_clock.c for what we do to make really shitty TSC
> > conform to the above requirements.
> 
> Sure, I guess what I'm trying to pull out here is that should we try to
> create some OK_FOR_SCHED_CLOCK flag for clocksources, and then we try to
> make this generic so other arches can add that flag and be done, what is
> the guidance we want to give to arch maintainers for setting that flag?
> 
> 1) Has to be very very fast. Can we put a number on this? 50ns to read?
> 
> 2) How long does it have to be monotonic for? Is it ok if it wraps every
> few seconds?
> 
> If get_cycles() || jiffies is what we want, then lets leave it there. I
> just want to avoid mixing the clocksource code into the sched clock code
> until we really get this sort of definition sorted.

The criterion is simple. If arch maintainer decides that the access to
the particular clock source is the best compromise between granularity
and access speed vs. jiffies then he can express that by setting the
flag.

Where is the difference between that flag and an arch specific
sched_clock() implementation which overrides the weak generic one ?

That arch specific function will probably do the same thing:

     return cyc2ns(whathever_clocksource_the_maintainer_thinks_is_the_best);

So let's get rid of those sched_clock() overrrides which do nothing
else than the generic version.

Thanks,

	tglx
