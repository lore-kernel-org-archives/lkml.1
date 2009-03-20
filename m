Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbZCTUk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbZCTUk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZCTUkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:40:15 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39908 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZCTUkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:40:13 -0400
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer
 support, selfmod code
From: john stultz <johnstul@us.ibm.com>
To: monstr@monstr.eu
Cc: Thomas Gleixner 1 <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com
In-Reply-To: <49C34558.6030006@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
	 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
	 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
	 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
	 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
	 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
	 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
	 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
	 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
	 <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain>
	 <49C2AB09.9040300@monstr.eu>
	 <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain>
	 <1237515861.7106.215.camel@jstultz-laptop>  <49C34558.6030006@monstr.eu>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 13:40:07 -0700
Message-Id: <1237581607.7191.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 08:27 +0100, Michal Simek wrote:
> Hi John S,
> 
> > On Thu, 2009-03-19 at 22:47 +0100, Thomas Gleixner wrote:
> >> On Thu, 19 Mar 2009, Michal Simek wrote:
> >>> And the second question is about shift and rating values.
> >>> I wrote one message in past http://lkml.org/lkml/2009/1/11/291
> >>> Here is the important of part of that message.
> >>>
> >>> ...
> >>>
> >>> And the second part is about shift and rating values. Rating is
> >>> describe(linux/clocksource.h) and seems to me that should be
> >>> corresponded with CONFIG_HZ value,right?
> > 
> > Not sure where the idea of correspondence w/ CONFIG_HZ came from. The
> > rating value just provides a relative ordering of preferences between
> > possible clocksources. Since different hardware may have a number of
> > different clocksources available, we just need to have a method of
> > selecting a preferred clocksource, and the rating value is used for
> > that.
> > 
> > The guide in linux/clocksource.h is just a guide. Most arches, which
> > only have one or two clocksource options probably won't need much care,
> > and a rating of 200 or 300 will probably suffice. Or if there really
> > isn't any option about it and there is only one which is a must-use
> > clocksource, 400.
> 
> ok. That mean that for my case (only one clocksource) I should set rating to 400
>  - I have one clocksource and is perfect for me.

As long as there will never be another clocksource used on that
architecture, 400 is probably ok. Since its sometimes hard to tell, you
might want to pick a more moderate 300. 

But again, its a relative scale and doesn't matter all that much, as
long as the right clocksource is always selected at boot for the
hardware.


> >>> And I found any explanation of shift value -> max value for equation
> >>> (2-5) * freq << shift / NSEC_PER_SEC should be for my case still 32bit
> >>> number, where (2-5s) are because of NTP
> >> @John, can you explain the shift vlaue please ?
> > 
> > The shift value is a bit more difficult to explain. The algorithm you
> > describe above is used by sparc to generate shift, and I think it will
> > work, but may not be optimal.
> > 
> > This question comes up over and over, so I figured I should sit down and
> > really solve it. 
> > 
> > Basically the constraint is you want to calculate a mult value using the
> > highest shift possible. However we have to be careful not to overflow
> > 64bits when we multiply ~5second worth of cycles times the mult value.
> > 
> > So I finally put this down into code and here it is. No promises that it
> > is 100% right, but from my simple test examples it worked ok.
> 
> OK. Please check my case of that value.
> MB can run from 5Mhz till 150MHz I think.
> I need generic approach that's why I have to calculate with max value (150MHz).
> My timer can tick on that freq too. (There is no different time bases in HW).
> 
> I need to find out how many ticks takes ~5s.
> 150MHz means that I need for 1sec 150 000 000 timer ticks.

I think you mean counter cycles instead of timer ticks.  Timer tick
terminology usually describes a timer based interrupt.

> One tick takes 1/150MHz = ~6-7ns - in the best case I can recognize and set
> 6-7ns (this is only theoretical value because of overhead)
> 
> ~5s takes 750 000 000 ticks = 0x2CB4 1780. And I have 32bit counter.
> 
> That my question is how big could be a shift of value above till overflow.
> 0x2CB4 1780 << shift not exceed 0xffff ffff ffff ffff.

Almost.  Its not the shift that causes the problem right off, but the
resulting mult value calculated from a shift. Again, the key points are,
you want to make sure that:

1) that mult value for the given shift fits in 32 bits. 
and
2) mult * 5sec of cycles doesn't overflow 64bits (really is only an
issue for very very fast counters that run faster then 1Ghz).


So let's follow my algorithm and start by picking a shift value of 32.

We calculate the mult, which would be (using clocksource_khz2mult()):

	(1Million * 2^32) / 150,000 = 28633115307 which overflows 32bits.
BZZZZZZ.

	1Million * 2^31 / 150,000 = 14316557653 (to big. BZZZZZZZ)
	

	1Million * 2^30 / 150,000 = 7158278827 (to big. BZZZZZZZ)


	1Million * 2^29 / 150,000 = 3579139413 (BING! it fits!)

Now the test:
	(750000000 * 3579139413)>>29 ?= 5 seconds
	2684354559750000000 (doesn't overflow!) >> 29
	4999999999ns ?= 5seconds (within the error range, so we're good!)


Now take care, because the slower the clocksource, often the lower the
shift value we can use, because the nsecs per cycle value that mult
approximates is much larger.


So for 5mhz (using 

	1Million * 2^29 / 5,000 = 107374182400 (32bit overflow!)
	...
	1Million * 2^24 / 5,000 = 3355443200 (fits!)

Now the test:
	(25000000 * 3355443200)>>24 ?= 5 seconds
	83886080000000000 (doesn't overflow!) >> 24 ?=
	5000000000ns ?= 5seconds (BING!)


So you can either dynamically calculate the best shift value for the
actual freq using the helper functions I provided, or just use 24 and be
safe, your pick.



> For example avr has shift 16, rating 50 (arch/avr32/kernel/time.c) (BTW: Sets
> time from 2007 too)

Most arches probably low ball the shift to be safe. Mainly because
explaining how to calculate the optimal shift was hard and there weren't
helper functions.

As an aside (feel free to ignore for the microblaze bits):
	Some complexity may grow here as well, since 5 seconds of cycles may
prove too short as folks become more interested running w/ NOHZ and
avoiding interrupts for extreme lengths of time (I've heard 30
minutes!?). For those situations we will need lower shift values, since
30 minutes of cycles * a large mult value close to (1<<32) will likely
overflow 64bits. But that trades off how finely we can tweak the clock
steering. Probably converting folks to use the helper functions will be
the best approach, as it will allow us to configure that depending on
NOHZ or not.

thanks
-john


