Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbXBKKXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbXBKKXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbXBKKXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:23:30 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52540 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbXBKKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:23:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Coywolf Qi Hunt <coywolf@lovecn.org>
Subject: Re: What are the real ioapic rte programming constraints?
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
Date: Sun, 11 Feb 2007 03:20:18 -0700
In-Reply-To: <Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com> (Zwane
	Mwaikambo's message of "Sat, 10 Feb 2007 21:57:56 -0800 (PST)")
Message-ID: <m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zwane Mwaikambo <zwane@infradead.org> writes:

> On Sat, 10 Feb 2007, Eric W. Biederman wrote:
>
>> There are not enough details in the justification to really understand
>> the issue so I'm asking to see if someone has some more details.
>> 
>> The description makes the assertion that reprograming the ioapic
>> when an  interrupt is pending is the only safe way to handle this.
>> Since edge triggered interrupts cannot be pending at the ioapic I know
>> it is not talking level triggered interrupts.
>> 
>> However it is not possible to fully reprogram a level triggered
>> interrupt when the interrupt is pending as the ioapic will not
>> receive the interrupt acknowledgement.  So it turns out I have
>> broken this change for several kernel releases without people
>> screaming at me about io_apic problems.
>> 
>> Currently I am disabling the irq on the ioapic before reprogramming
>> it so I do not run into issues.  Does that solve the concerns that
>> were patched around by only reprogramming interrupt redirection
>> table entry in interrupt handlers?
>
> Hi Eric,
> 	Could you outline in pseudocode where you're issuing the mask? If 
> it's done whilst an irq is pending some (intel 7500 based) chipsets will 
> not actually mask it but treat it as a 'legacy' IRQ and deliver it 
> anyway. Using the masked whilst pending logic avoids all of that.

The code currently in the kernel does:

pending
mask
read io_apic
ack
reprogram vector and destination
unmask

So I guess it does retain the bug fix.

What I am looking at doing is:

mask
read io_apic 
-- Past this point no more irqs are expected from the io_apic
-- Now I work to drain any inflight/pending instances of the irq 
send ipi to all irq destinations cpus and wait for it to return
read lapic
disable local irqs
take irq lock
-- Now no more irqs are expected to arrive
reprogram vector and destination
enable local irqs
unmask

What I need to ensure is that I have a point where I will not receive any
new messages from an ioapic about a particular irq anymore.  Even if
everything is working perfectly setting the disable bit is not enough
because there could be an irq message in flight. So I need to give any
in flight irqs a chance to complete.  

With a little luck that logic will cover your 7500 disable race as
well. If not and there is a reasonable work around we should look at
that.  This is not a speed critical path so we can afford to do a
little more work.

The version of this that I am currently testing is below.

Eric

/*
 * Synchronize the local APIC and the CPU by doing
 * a dummy read from the local APIC
 */
static inline void lapic_sync(void)
{
	apic_read(APIC_ID);
}

static void affinity_noop(void *info)
{
	return;
}

static void mask_get_irq(unsigned int irq)
{
	struct irq_desc *desc = irq_desc + irq;
	int cpu;

	spin_lock(&vector_lock);

	/*
	 * Mask the irq so it will no longer occur
	 */
	desc->chip->mask(irq);

	/* If I can run a lower priority vector on another cpu
	 * then obviously the irq has completed on that cpu.  SMP call
	 * function is lower priority then all of the hardware
	 * irqs.
	 */
	for_each_cpu_mask(cpu, desc->affinity)
		smp_call_function_single(cpu, affinity_noop, NULL, 0, 1);

	/*
	 * Ensure irqs have cleared the local cpu
	 */
	lapic_sync();
	local_irq_disable();
	lapic_sync();
	spin_lock(&desc->lock);
}

static void unmask_put_irq(unsigned int irq)
{
	struct irq_desc *desc = irq_desc + irq;

	spin_unlock(&desc->lock);
	local_irq_enable();
	desc->chip->unmask(irq);
	spin_unlock(&vector_lock);
}

static void set_ioapic_affinity_level_irq(unsigned int irq, cpumask_t mask)
{
	unsigned int dest;
	int vector;

	/*
	 * Ensure all of the irq handlers for this irq have completed.
	 * i.e. drain all pending irqs
	 */
	mask_get_irq(irq);

	cpus_and(mask, mask, cpu_online_map);
	if (cpus_empty(mask))
		goto out;

	vector = __assign_irq_vector(irq, mask, &mask);
	if (vector < 0)
		goto out;

	dest = cpu_mask_to_apicid(mask);

	/*
	 * Only the high 8 bits are valid
	 */
	dest = SET_APIC_LOGICAL_ID(dest);

	spin_lock(&ioapic_lock);
	__target_IO_APIC_irq(irq, dest, vector);
	spin_unlock(&ioapic_lock);

	set_native_irq_info(irq, mask);
out:
	unmask_put_irq(irq);
}
