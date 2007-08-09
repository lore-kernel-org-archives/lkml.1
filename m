Return-Path: <linux-kernel-owner+w=401wt.eu-S939017AbXHILoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939017AbXHILoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbXHILoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:44:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbXHILon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:44:43 -0400
Message-ID: <46BAFE08.5070906@redhat.com>
Date: Thu, 09 Aug 2007 07:44:08 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Herbert Xu <herbert.xu@redhat.com>
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
References: <E1IIwQx-000468-00@gondolin.me.apana.org.au> <46BAC6AD.7050603@redhat.com> <20070809083055.GA19048@gondor.apana.org.au>
In-Reply-To: <20070809083055.GA19048@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, Aug 09, 2007 at 03:47:57AM -0400, Chris Snook wrote:
>> If they're not doing anything, sure.  Plenty of loops actually do some sort 
>> of real work while waiting for their halt condition, possibly even work 
>> which is necessary for their halt condition to occur, and you definitely 
>> don't want to be doing cpu_relax() in this case.  On register-rich 
>> architectures you can do quite a lot of work without needing to reuse the 
>> register containing the result of the atomic_read().  Those are precisely 
>> the architectures where barrier() hurts the most.
> 
> I have a problem with this argument.  The same loop could be
> using a non-atomic as long as the updaters are serialised.  Would
> you suggest that we turn such non-atomics into volatiles too?

No.  I'm simply saying that when people call atomic_read, they expect a read to 
occur.  When this doesn't happen, people get confused.  Merely referencing a 
variable doesn't carry the same connotation.

Anyway, I'm taking Linus's advice and putting the cast in atomic_read(), rather 
than the counter declaration itself.  Everything else uses __asm__ __volatile__, 
or calls atomic_read() with interrupts disabled.  This ensures that 
atomic_read() works as expected across all architectures, without the cruft the 
compiler generates when you declare the variable itself volatile.

> Any loop that's waiting for an external halt condition either
> has to schedule away (which is a barrier) or you'd be busy
> waiting in which case you should use cpu_relax.

Not necessarily.  Some code uses atomic_t for a sort of lightweight semaphore. 
If your loop is actually doing real work, perhaps in a softirq handler 
negotiating shared resources with a hard irq handler, you're not busy-waiting.

> Do you have an example where this isn't the case?

a) No, and that's sort of the point.  We shouldn't have to audit the whole 
kernel to find cases where a misleadingly-named function is doing what its users 
are not expecting.  If we can make it always do the right thing without any 
substantial drawbacks, we should.

b) Loops are just one case, which came to mind because of the IPVS bug recently 
discussed.  I recall seeing some scheduler code recently which does an 
atomic_read() twice on the same variable, with a barrier in between.  It's in a 
very hot path, so if we can remove that barrier, we save a bunch of register 
loads.  When you're context switching every microsecond in SCHED_RR, that really 
matters.

	-- Chris
