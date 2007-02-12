Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXBLXLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXBLXLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030469AbXBLXLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:11:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52836 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030468AbXBLXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:11:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21 review I] [11/25] x86: default to physical mode on hotplug CPU kernels
References: <200702101250.142420000@suse.de>
	<20070210115023.D19ED13DCE@wotan.suse.de>
	<m1vei9ymkh.fsf@ebiederm.dsl.xmission.com>
	<200702122336.23826.andi@firstfloor.org>
Date: Mon, 12 Feb 2007 16:10:44 -0700
In-Reply-To: <200702122336.23826.andi@firstfloor.org> (Andi Kleen's message of
	"Mon, 12 Feb 2007 23:36:23 +0100")
Message-ID: <m1k5ynug3v.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:


> What experimental evidence did you have? 
>
> But I'm tempted to drop this unless the hotplug mystery can be cleared
> up. There was past information that logical is unsafe for hotplug.

Basically as I commented in genapic_flat, that at least on hyperthreading
cpus the destination mask is not always honored, and so if you only
allow one hyperthread I have seen the irq show up on the other hyperthread.

Now if the cpu is actually disabled I don't think that is a problem, but
I know early versions of hotplug did actually disable the cpu.

I think the renaming in this patch makes things clearer in a useful way.


The more I look at the hotplug cpu code the more I think it should be
filed under EXPERIMENTAL (as in the code is buggy and not ready for
production use yet).

Trying to see if I can improve the irq migration mess I stumbled upon
the following.  Currently set_affinity needs to be called with
irq_desc[irq].lock held.  It needs to be called from interrupt context.
And 1 millisecond delay appears utterly bogus, although the enable
the irqs do something disable the irqs likely flushes pending irqs.
A problem that cannot occurs differently if the irqs are migrated
from interrupt context.

Looking further this buggy set_affinity usage also appears in
setup_ioapic_dest.  Although it is much less dangerous there,
as the code is largely a noop.

Is it just me or are we crazy for support software controlled irq
migration?

void fixup_irqs(cpumask_t map)
{
	unsigned int irq;
	static int warned;

	for (irq = 0; irq < NR_IRQS; irq++) {
		cpumask_t mask;
		if (irq == 2)
			continue;

		cpus_and(mask, irq_desc[irq].affinity, map);
		if (any_online_cpu(mask) == NR_CPUS) {
			printk("Breaking affinity for irq %i\n", irq);
			mask = map;
		}
		if (irq_desc[irq].chip->set_affinity)
			irq_desc[irq].chip->set_affinity(irq, mask);
		else if (irq_desc[irq].action && !(warned++))
			printk("Cannot set affinity for irq %i\n", irq);
	}

	/* That doesn't seem sufficient.  Give it 1ms. */
	local_irq_enable();
	mdelay(1);
	local_irq_disable();
}

Eric
