Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZEZXYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZEZXYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZEZXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:24:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:23404 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757819AbZEZXYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="147202039"
From: "Mangalampalli, JayantX" <jayantx.mangalampalli@intel.com>
To: john stultz <johnstul@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 26 May 2009 16:24:00 -0700
Subject: RE: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
Thread-Topic: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
Thread-Index: AcneVm1oppk/Ghc+TuSpNKxmAY1OzQAAlpwQ
Message-ID: <68887236814FB54BBC1D0E0556DD510D4CCB0F09E2@orsmsx509.amr.corp.intel.com>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>  <1243369423.3275.5.camel@localhost>
	 <1243369815.6600.2.camel@laptop>  <1243370439.3275.13.camel@localhost>
	 <1243371309.6600.8.camel@laptop> <1243378835.3275.30.camel@localhost>
In-Reply-To: <1243378835.3275.30.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't rdtsc inherently dependent on CPU tick rate, which is somewhat variable? Shouldn't HPET be more reliable? Or can constant_tsc be relied on for important things like scheduler?

Thanks
Jayant

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of john stultz
Sent: Tuesday, May 26, 2009 4:01 PM
To: Peter Zijlstra
Cc: Linus Walleij; Paul Mundt; Ingo Molnar; Andrew Victor; Haavard Skinnemoen; Andrew Morton; linux-kernel@vger.kernel.org; linux-sh@vger.kernel.org; linux-arm-kernel@lists.arm.linux.org.uk; John Stultz; Thomas Gleixner
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().

On Tue, 2009-05-26 at 22:55 +0200, Peter Zijlstra wrote:
> On Tue, 2009-05-26 at 13:40 -0700, john stultz wrote:
> > On Tue, 2009-05-26 at 22:30 +0200, Peter Zijlstra wrote:
> > > On Tue, 2009-05-26 at 13:23 -0700, john stultz wrote:
> > > > Overall, I'd probably suggest thinking this through a bit more. At some
> > > > point doing this right will cause sched_clock() to be basically the same
> > > > as ktime_get(). So why not just use that instead of remaking it?
> > > 
> > > simply because we don't require the strict global monotonicy for
> > > scheduling as we do from a regular time source (its nice to have
> > > though).
> > > 
> > > That means that on x86 we can always use TSC for sched_clock(), even
> > > when its quite unsuitable for ktime.
> > 
> > Right, but I guess what I'm asking is can this be a bit better defined? 
> > 
> > If we are going to use clocksources (or cyclecounters - an area I need
> > to clean up soon), it would be good to get an idea of what is expected
> > of the sched_clock() interface.
> > 
> > So TSC good, HPET bad. Why? 
> 
> Because TSC is a few cycles to read, and you can factorize a largish
> prime while doing an HPET read :-)
> 
> > Is latency all we care about? How bad would
> > the TSC have to be before we wouldn't want to use it?
> 
> Anything better than jiffies ;-)

Except HPET thought, right? :)

> For sched_clock() we want something high-res that is monotonic per cpu
> and has a bounded drift between cpus in the order of jiffies.
> 
> Look at kernel/sched_clock.c for what we do to make really shitty TSC
> conform to the above requirements.

Sure, I guess what I'm trying to pull out here is that should we try to
create some OK_FOR_SCHED_CLOCK flag for clocksources, and then we try to
make this generic so other arches can add that flag and be done, what is
the guidance we want to give to arch maintainers for setting that flag?

1) Has to be very very fast. Can we put a number on this? 50ns to read?

2) How long does it have to be monotonic for? Is it ok if it wraps every
few seconds?

If get_cycles() || jiffies is what we want, then lets leave it there. I
just want to avoid mixing the clocksource code into the sched clock code
until we really get this sort of definition sorted.

thanks
-john


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
