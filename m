Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYHAVte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYHAVte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYHAVt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:49:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58279 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752238AbYHAVtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:49:25 -0400
Message-ID: <4893856D.6060909@sgi.com>
Date: Fri, 01 Aug 2008 16:51:41 -0500
From: Alan Mayer <ajm@sgi.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cliff Wickman <cpw@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>
Subject: Re: [PATCH] x86_64:  Dynamically allocate arch specific system vectors
References: <48922D16.1080704@sgi.com> <m13alp1z8w.fsf@frodo.ebiederm.org>	<20080801155120.GA21706@sgi.com> <m18wvgv4bj.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wvgv4bj.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I think we have it now.  assign_irq_vector *almost* does what we 
need.  One minor thing is that assign_irq_vector ANDs against 
cpu_online_map.  We would need cpu_possible_map, so we get the vector on 
offline cpus that may come online.  The other thing is that 
assign_irq_vector doesn't allow the specification of interrupt 
priorities.  It would need to be modified to handle returning either a 
high priority vector or a low priority vector.  Would modifying the api 
for assign_irq_vector be the proper approach?

The interrupts don't necessarily fire on all cpus, it's just that they 
*can* fire on any cpu.  For example, the GRU triggers an interrupt (it 
is very IPI'ish) to a particular cpu in the event of a GRU TLB fault. 
That cpu handles the fault and returns.  But the fault can happen on any 
cpu, so all cpus need to be registered for the same vector and irq. 
This is probably splitting hairs; it is certainly no different in 
principal from timer interrupts or processor TLB faults.

As far as kernel_stat is concerned.  I see you're point.  NR_CPUS on our 
machines is going to be big (4K? 8K? something like that).  NR_IRQS is 
also going to big because of that.  It's unfortunate since the actual 
number of interrupt sources is going to be an order of magnitude 
smaller, at least.

		--ajm

Eric W. Biederman wrote:
> Cliff Wickman <cpw@sgi.com> writes:
>> I assume you mean create_irq() and destroy_irq().
>> They are close to what we need.
> 
> Actually that isn't quite what I was thinking.
> 
>> However for any given system use:
>> - we need to request a high priority vector for some irq's, rather than
>>   one randomly allocated as per __assign_irq_vector().
> 
> Well I was actually thinking mostly about reusing assign_irq_vector.
> 
> The high priority vector seems to be the place where we would need
> to reexamine the vector allocator.
> 
>> - we want the irq/vector to be targeted to all cpu's (as specified in a
>>   mask,
>>   and can include currently offline cpu's) rather than a single cpu. 
> 
> __assign_irq_vector should be able to handle that case.
> 
>> I suppose those abilities could be added to create_irq(), but we didn't
>> want to intrude into that interface.
> 
> Right.  That part gets custom and there is no intersection.
> 
>> A smaller consideration is simplicity of use.  We want any such user to
>> use
>> the generic do_IRQ() flow (not alloc_intr_gate()).
> 
> My primary concern is that you are generalizing an interface that is
> designed for alloc_intr_gate consumers.  In particular for people
> who wish to allocate vectors that can be triggered by software to
> do this.
> 
> If this is normal irq handling I would really prefer to use the
> normal data structures that we use for allocating vectors to irqs,
> because that is what you are doing.
> 
>> But make it easy to set
>> up the irq/vector, irq_chip and irq_desc without getting intimate with
>> the details.
>> I suppose some other wrapper for an enhanced create_irq() could be done.
>>
>> We are going to need such irq/vector pairs for a couple of UV drivers
>> (drivers/misc/sgi-gru/ and sgi-xp/).  And would prefer it for the UV TLB
>> shootdown (x86/kernel/tlb.uv.c) rather than using alloc_intr_gate().
> 
> I also want to ask why do you need an irq that fires on every cpu?
> 
> That concept seems to be responsible for one of the nastiest data
> structures in the kernel.  Where we track how many times any irq has
> occurred on any cpu.  Look at the percpu variable kernel_stat.  It
> seems to be one of the nastiest variables I know of.  Of size:
> NR_CPUS*NR_CPUS*32  Assuming you have a machine with a reasonable
> number of irqs per cpu.
> 
> Eric

-- 
Make me an angel
That flies from Montgomery.
--
Alan J. Mayer
SGI
ajm@sgi.com
WORK: 651-683-3131
HOME: 651-407-0134
--
