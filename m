Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZEZU4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZEZU4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZEZU4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:56:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45669 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZEZU4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:56:03 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1243370439.3275.13.camel@localhost>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>  <1243369423.3275.5.camel@localhost>
	 <1243369815.6600.2.camel@laptop>  <1243370439.3275.13.camel@localhost>
Content-Type: text/plain
Date: Tue, 26 May 2009 22:55:09 +0200
Message-Id: <1243371309.6600.8.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 13:40 -0700, john stultz wrote:
> On Tue, 2009-05-26 at 22:30 +0200, Peter Zijlstra wrote:
> > On Tue, 2009-05-26 at 13:23 -0700, john stultz wrote:
> > > Overall, I'd probably suggest thinking this through a bit more. At some
> > > point doing this right will cause sched_clock() to be basically the same
> > > as ktime_get(). So why not just use that instead of remaking it?
> > 
> > simply because we don't require the strict global monotonicy for
> > scheduling as we do from a regular time source (its nice to have
> > though).
> > 
> > That means that on x86 we can always use TSC for sched_clock(), even
> > when its quite unsuitable for ktime.
> 
> Right, but I guess what I'm asking is can this be a bit better defined? 
> 
> If we are going to use clocksources (or cyclecounters - an area I need
> to clean up soon), it would be good to get an idea of what is expected
> of the sched_clock() interface.
> 
> So TSC good, HPET bad. Why? 

Because TSC is a few cycles to read, and you can factorize a largish
prime while doing an HPET read :-)

> Is latency all we care about? How bad would
> the TSC have to be before we wouldn't want to use it?

Anything better than jiffies ;-)

For sched_clock() we want something high-res that is monotonic per cpu
and has a bounded drift between cpus in the order of jiffies.

Look at kernel/sched_clock.c for what we do to make really shitty TSC
conform to the above requirements.

