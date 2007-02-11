Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXBKQQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXBKQQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 11:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXBKQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 11:16:49 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:46546 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXBKQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 11:16:48 -0500
Date: Sun, 11 Feb 2007 08:16:39 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: Re: What are the real ioapic rte programming constraints?
In-reply-to: <m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       Coywolf Qi Hunt <coywolf@lovecn.org>
Message-id: <Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200701221116.13154.luigi.genoni@pirelli.com>
 <200702021848.55921.luigi.genoni@pirelli.com>
 <m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
 <200702021905.39922.luigi.genoni@pirelli.com>
 <m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
 <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com> <20070206073616.GA15016@elte.hu>
 <m1odo7q6cq.fsf@ebiederm.dsl.xmission.com> <20070206222523.GA11602@elte.hu>
 <m1irecamzh.fsf@ebiederm.dsl.xmission.com>
 <m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
 <m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
 <m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
 <Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
 <m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Feb 2007, Eric W. Biederman wrote:

> What I am looking at doing is:
> 
> mask
> read io_apic 
> -- Past this point no more irqs are expected from the io_apic
> -- Now I work to drain any inflight/pending instances of the irq 
> send ipi to all irq destinations cpus and wait for it to return
> read lapic
> disable local irqs
> take irq lock
> -- Now no more irqs are expected to arrive
> reprogram vector and destination
> enable local irqs
> unmask
> 
> What I need to ensure is that I have a point where I will not receive any
> new messages from an ioapic about a particular irq anymore.  Even if
> everything is working perfectly setting the disable bit is not enough
> because there could be an irq message in flight. So I need to give any
> in flight irqs a chance to complete.  
> 
> With a little luck that logic will cover your 7500 disable race as
> well. If not and there is a reasonable work around we should look at
> that.  This is not a speed critical path so we can afford to do a
> little more work.

The 7500 issue isn't actually a race but a disease, if you mask a pending 
irq in its RTE, the PCI hub generates an INTx message corresponding to 
that irq. This apparently was done to support booting OSes without APIC 
support. So the following would occur;

- irqN pending on IOAPIC
- mask
=> INTx message for irqN

Unfortunately it appears the below code would also be affected by this as 
well, the appropriate reference is;

2.15.2 PCI Express* Legacy INTx Support and Boot Interrupt
http://download.intel.com/design/chipsets/datashts/30262802.pdf

> static void mask_get_irq(unsigned int irq)
> {
> 	struct irq_desc *desc = irq_desc + irq;
> 	int cpu;
> 
> 	spin_lock(&vector_lock);
> 
> 	/*
> 	 * Mask the irq so it will no longer occur
> 	 */
> 	desc->chip->mask(irq);
> 
> 	/* If I can run a lower priority vector on another cpu
> 	 * then obviously the irq has completed on that cpu.  SMP call
> 	 * function is lower priority then all of the hardware
> 	 * irqs.
> 	 */
> 	for_each_cpu_mask(cpu, desc->affinity)
> 		smp_call_function_single(cpu, affinity_noop, NULL, 0, 1);
> 
> 	/*
> 	 * Ensure irqs have cleared the local cpu
> 	 */
> 	lapic_sync();
> 	local_irq_disable();
> 	lapic_sync();
> 	spin_lock(&desc->lock);
> }
