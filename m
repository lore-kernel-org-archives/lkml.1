Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbZE1VGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbZE1VGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852AbZE1VGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:06:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41663 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZE1VGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:06:30 -0400
Message-ID: <4A1EFCC2.80805@linux.vnet.ibm.com>
Date: Thu, 28 May 2009 14:06:10 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: eranian@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] comments on Performance Counters for Linux (PCL)
References: <7c86c4470905280758y6d359823h2a7517dfecb115e6@mail.gmail.com> <1243527919.6645.75.camel@laptop>
In-Reply-To: <1243527919.6645.75.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few comments below on some excerpts from this very good discussion.

Peter Zijlstra wrote:
> On Thu, 2009-05-28 at 16:58 +0200, stephane eranian wrote:
>>      - uint64_t irq_period
>>
>>        IRQ is an x86 related name. Why not use smpl_period instead?
> 
> don't really care, but IRQ seems used throughout linux, we could name
> the thing interrupt or sample period.

I agree with Stephane, the name irq_period struck me as somewhat strange for 
what it does.  sample_period would be much better.

> 
>>      - uint32_t record_type
>>
>>        This field is a bitmask. I believe 32-bit is too small to accommodate
>>        future record formats.
> 
> It currently controls 8 aspects of the overflow entry, do you really
> forsee the need for more than 32?

record_type is probably not the best name for this either.  Maybe 
"record_layout" or "sample_layout" or "sample_format" (to go along with read_format)


>>        I would assume that on the read() side, counts are accumulated as
>>        64-bit integers. But if it is the case, then it seems there is an
>>        asymmetry between period and counts.
>>
>>        Given that your API is high level, I don't think tools should have to
>>        worry about the actual width of a counter. This is especially true
>>        because they don't know which counters the event is going to go into
>>        and if I recall correctly, on some PMU models, different counters can
>>        have different width (Power, I think).
>>
>>        It is rather convenient for tools to always manipulate counters as
>>        64-bit integers. You should provide a consistent view between counts
>>        and periods.
> 
> So you're suggesting to artificually strech periods by say composing a
> single overflow from smaller ones, ignoring the intermediate overflow
> events?
> 
> That sounds doable, again, patch welcome.

I definitely agree with Stephane's point on this one.  I had assumed that long 
irq_periods (longer than the width of the counter) would be synthesized as you 
suggest.  If this is not the case, PCL should be changed so that it does,  -or- 
at a minimum, the user should get an error back stating that the period is too 
long for the hardware counter.

>>  4/ Grouping
>>
>>        By design, an event can only be part of one group at a time. Events in
>>        a group are guaranteed to be active on the PMU at the same time. That
>>        means a group cannot have more events than there are available counters
>>        on the PMU. Tools may want to know the number of counters available in
>>        order to group their events accordingly, such that reliable ratios
>>        could be computed. It seems the only way to know this is by trial and
>>        error. This is not practical.
> 
> Got a proposal to ammend this?

I think counters in a group are guaranteed to be active at the same time iff the 
pinned bit is set for that group, right?

I don't get the problem with reliable ratios here.  If each counter has its own 
time values, time enabled vs. time on counter, reliable ratios should always be 
available.

> 
>>  5/ Multiplexing and scaling
>>
>>        The PMU can be shared by multiple programs each controlling a variable
>>        number of events. Multiplexing occurs by default unless pinned is
>>        requested. The exclusive option only guarantees the group does not
>>        share the PMU with other groups while it is active, at least this is
>>        my understanding.
> 
> We have pinned and exclusive. pinned means always on the PMU, exclusive
> means when on the PMU no-one else can be.

The use of the exclusive bit has been unclear to me.  Let's say I have 4 
hardware counters, and two groups of two events each.  As long as there's no 
interference from one group to the other, is there a reason I'd want the 
"exclusive" bit on?

Is it used only in the case where the kernel would otherwise not be able to 
schedule both groups onto counters at the same time and you want to ensure that 
your group doesn't get preempted by another group waiting to get onto the PMU?

>> III/ Requests
>>   2/ Sampling period randomization
>>
>>        It is our experience (on Itanium, for instance), that for certain
>>        sampling measurements, it is beneficial to randomize the sampling
>>        period a bit. This is in particular the case when sampling on an
>>        event that happens very frequently and which is not related to
>>        timing, e.g., branch_instructions_retired. Randomization helps mitigate
>>        the bias. You do not need anything sophisticated.. But when you are using
>>        a kernel-level sampling buffer, you need to have to kernel randomize.
>>        Randomization needs to be supported per event.
> 
> Corey raised this a while back, I asked what kind of parameters were
> needed and if a specific (p)RNG was specified.
> 
> Is something with an (avg,std) good enough? Do you have an
> implementation that I can borrow, or even better a patch? :-)

For how it's done in perfmon2, take a look at Section 3.4.2 (page 74) of 
http://www.hpl.hp.com/techreports/2004/HPL-2004-200R1.pdf

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

