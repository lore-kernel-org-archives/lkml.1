Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbXBFI6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbXBFI6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXBFI6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:58:48 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45319 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXBFI6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:58:47 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
Date: Tue, 06 Feb 2007 01:57:42 -0700
In-Reply-To: <20070206073616.GA15016@elte.hu> (Ingo Molnar's message of "Tue,
	6 Feb 2007 08:36:16 +0100")
Message-ID: <m1zm7ru0hl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo thanks for the review.

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> When making the interrupt vectors per cpu I failed to handle a case 
>> during irq migration.  If the same interrupt comes in while we are 
>> servicing the irq but before we migrate it the pending bit in the 
>> local apic IRR register will be set for that irq.
>
> hm. I think this needs more work. For example this part of the fix looks 
> quite ugly to me:

I'm not at all certain I can make an ugly reality look beautiful.

>> +static unsigned apic_in_service_vector(void)
>> +{
>> +	unsigned isr, vector;
>> +	/* Figure out which vector we are servicing */
>> + for (vector = FIRST_EXTERNAL_VECTOR; vector < FIRST_SYSTEM_VECTOR; vector +=
> 32) {
>> +		isr = apic_read(APIC_ISR + ((vector/32) * 0x10));
>> +		if (isr)
>> +			break;
>> +	}
>> +	/* Find the low bits of the vector we are servicing */
>> +	vector += __ffs(isr);
>> +	return vector;
>
> so we read the hardware to figure out what the hell we are doing. The 
> problem is - why doesnt the kernel know at this point what it is doing? 
> It knows the CPU and it should know all the vector numbers. It also has 
> an irq number.

Yes.  And by adding a percpu global I can do this.  If figured since this
should be a rare case it would be equally simple to read this from
the hardware, as it already has the information stored in roughly the
form I would need to store it in.  If there errata in this area and I
am likely to hit them then it is probably a good idea to look at a
different implementation.


>> +	/* If the irq we are servicing has moved and is not pending
>> +	 * free it's vector.
>> +	 */
>> +	irr = apic_read(APIC_IRR + ((vector/32) * 0x10));
>
> the IRR is quite fragile. It's a rarely used hardware field and it has 
> erratums attached to it. Again, it seems like this function too tries to 
> recover information it /should/ already have.

If I am servicing an interrupt and that same interrupt comes in again
before I acknowledge it how /should/ I know that?

The only way I know to find that information is to ask the hardware.

>> @@ -1400,19 +1439,24 @@ static int ioapic_retrigger_irq(unsigned int irq)
>>  
>>  static void ack_apic_edge(unsigned int irq)
>>  {
>> -	move_native_irq(irq);
>> +	if (unlikely(irq_desc[irq].status & IRQ_MOVE_PENDING)) {
>> +		move_native_irq(irq);
>> +		apic_handle_pending_vector(apic_in_service_vector());
>> +	}
>>  	ack_APIC_irq();
>
> this looks a bit ugly and a bit fragile. We had a simple 
> 'move_native_irq()' call for IRQ balancing, which is straightforward, 
> but now we've got this complex condition open coded.

Well the condition is testing a single bit so I don't think it is that
complex.  Maybe taking it out of line will help or maybe that will obscure
things.  I'm inclined to believe hiding the irq migration logic will
obscure things and make it harder to debug.

Now part of the reason I did it this way is I have at least 3
set_affinity implementations and this issue really has nothing to do
with the external interrupt controller but everything to do with the
cpu local interrupt controller, so this did not seem like something
that was reasonably buried in set_affinity.

> If then this should be done in some sort of helper - but even then, the 
> whole approach looks a bit erroneous.
>
> To me the cleanest way to migrate an IRQ between two different vectors 
> on two different CPUs would be to first mask the IRQ source in the PIC, 
> then to do the migration /atomically/ (no intermediary state), and then 
> unmask. If the PIC loses edges while masked then that's a problem of the 
> irq chip implementation of the PIC: its ->set_affinity() method should 
> refuse to migrate edge-triggered IRQs if it can lose edges while 
> unmasked!

Ingo I believe what you have described is essentially what we are
doing before my patches, or what we were doing in even older versions
that had other races and problems. 

To some extent I have inherited the current design that mostly works.  The
only known reliable way to block and edge triggered irq is to be servicing it.
The practical problem there is that when we sit on an irq the irq can come
in again and queue up in irr.  Which means that once we have updated the
data structures acked the irq and returned the irq will come in again
in the old location because the io_apic has a 1 deep queue for each
irq.  Of course for the irq controllers that can be masked safely your
proposed change to disable irq is unfortunate.

You appear to be lobbying for disabling the irq asynchronously to all
of the irq reception activity.  That would seem to me to require
running on the cpu where the irq is currently programmed to be
delivered disabling local interrupts, as well as disabling the irq in
the interrupt controller before reprogramming it.  For the irqs that
applies to there does seem to be some merit in that. 

Of course the irq will queue in irr so it can be delivered when the
irqs are enabled again and therefore we have to be very careful about
data structure changes and not removing them if we have the specified
irq pending on the current cpu.  So I don't see how this changes the
solution domain in any meaningful way, except by reducing the set
of interrupt controllers we can support with it, because it requires
masking.

The core question:  How do I know when all interrupts messages that
have sent have been serviced and acknowledged?

If you have the guarantee that the irq is disabled and queuing in the
interrupt controller and all interrupt messages that have been sent
have been serviced and acknowledged.   Then the reprogramming problem
is simple.  Otherwise we have to cope with interrupts in the cpu local
queue.

Dropping support for the more difficult cases when we know how to
migrate them and they are in fact some of our most common interrupts
like the timer interrupt seems an irresponsible thing to do.  Now
if you can make the case that we cannot migrate them safely that
is another issue.

I'm open to suggestions and with my simple patch we at least won't
hang the kernel when this happens.

Eric
