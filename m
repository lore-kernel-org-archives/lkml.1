Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYHDTfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYHDTfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbYHDTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:34:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53864 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754426AbYHDTez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:34:55 -0400
Message-ID: <48975A75.4010609@sgi.com>
Date: Mon, 04 Aug 2008 14:37:25 -0500
From: Alan Mayer <ajm@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cliff Wickman <cpw@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>
Subject: Re: [PATCH] x86_64:  Dynamically allocate arch specific system vectors
References: <48922D16.1080704@sgi.com> <m13alp1z8w.fsf@frodo.ebiederm.org>	<20080801155120.GA21706@sgi.com> <m18wvgv4bj.fsf@frodo.ebiederm.org>	<4893856D.6060909@sgi.com> <m11w18tmb1.fsf@frodo.ebiederm.org>
In-Reply-To: <m11w18tmb1.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric W. Biederman wrote:
> Alan Mayer <ajm@sgi.com> writes:
> 
>> Okay, I think we have it now.  assign_irq_vector *almost* does what we need.
>> One minor thing is that assign_irq_vector ANDs against cpu_online_map.  We would
>> need cpu_possible_map, so we get the vector on offline cpus that may come
>> online.  The other thing is that assign_irq_vector doesn't allow the
>> specification of interrupt priorities.  It would need to be modified to handle
>> returning either a high priority vector or a low priority vector.  Would
>> modifying the api for assign_irq_vector be the proper approach?
> 
> I don't know if it makes sense to modify assign_irq_vector or to 
> have a companion function that uses the same data structures.
> 
> I think I would work on the companion function and if the code
> can be made sufficiently similar merge the two functions.
> 
Okay, If I understand you, here's what we can do.  We currently have 
this function that does pretty much what the combination of create_irq() 
and __assign_irq_vector() do.  We can accomplish the same thing that our
routine does using create_irq() and __assign_irq_vector() do if we make 
the following changes:

__assign_irq_vector(int irq, cpumask_t mask) ==>
	__assign_irq_vector(int irq, cpumask_t mask, int priority);

priority has three values:  priority_none, priority_low, priority_high
priority_none means do everything the way it is done now.
priority_low means do everything the way its is done now, except use 
cpu_possible_map rather than cpu_online_map.
priority_high means search the interrupt vectors from the top down, 
rather than from the bottom up and use cpu_possible_map rather than 
cpu_online_map.

create_irq(void) ==> create_irq(int priority, cpumask_t *mask)
priority_none, means do everything the way it is done now, passing in 
TARGET_CPUS as the mask, but also sending the priority arg. into 
__assign_irq_vector().
priority_low and priority_high means use create_irq()'s mask arg. as the
mask passed to __assign_irq_vector).

We would add an additional small routine on top of create_irq() to do 
any massaging of the irq_desc, etc. that we need for these system vectors.

Is that what you were thinking about?

			--ajm

>> The interrupts don't necessarily fire on all cpus, it's just that they *can*
>> fire on any cpu.  For example, the GRU triggers an interrupt (it is very
>> IPI'ish) to a particular cpu in the event of a GRU TLB fault. That cpu handles
>> the fault and returns.  But the fault can happen on any cpu, so all cpus need to
>> be registered for the same vector and irq. This is probably splitting hairs; it
>> is certainly no different in principal from timer interrupts or processor TLB
>> faults.
> 
> Reasonable.  As long as you don't need to read a status register to figure
> out what to do that sounds reasonable.  This does sound very much like
> splitting hairs on a very platform specific capability.
> 
> If we can generalize the mechanism to things like per cpu timer
> interrupts and such so that we reduced the total amount of code we
> have to maintain I would find it a very compelling mechanism.
> 
>> As far as kernel_stat is concerned.  I see you're point.  NR_CPUS on our
>> machines is going to be big (4K? 8K? something like that).  NR_IRQS is also
>> going to big because of that.  It's unfortunate since the actual number of
>> interrupt sources is going to be an order of magnitude smaller, at least.
> 
> The number of interrupts sources is going to be smaller only because
> SGI machines have or at least appear to have poor I/O compared to most
> of the rest of machines in existence.  NR_CPUS*16 is a fairly
> reasonable estimate on most machines in existence.  In the short term
> it is going to get worse in the presence of MSI-X.  I was talking to a
> developer at Intel last week about 256 irqs for one card.  I keep
> having dreams about finding a way to just keep stats for a few cpus
> but alas I don't think that is going to happen.  Silly us.
> 
> Eric
> 

-- 
It's getting to the point
Where I'm no fun anymore.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--
