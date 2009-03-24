Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZCXMwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZCXMwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZCXMwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:52:30 -0400
Received: from ozlabs.org ([203.10.76.45]:36899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbZCXMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:52:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC] Correct behaviour of irq affinity?
Date: Tue, 24 Mar 2009 23:22:23 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <200903241619.03517.rusty@rustcorp.com.au> <86802c440903240021y20abab87j3a780f8a17574716@mail.gmail.com>
In-Reply-To: <86802c440903240021y20abab87j3a780f8a17574716@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903242322.24943.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009 17:51:43 Yinghai Lu wrote:
> On Mon, Mar 23, 2009 at 10:49 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > The effect of setting desc->affinity (ie. from userspace via sysfs) has varied
> > over time.  In 2.6.27, the 32-bit code anded the value with cpu_online_map,
> > and both 32 and 64-bit did that anding whenever a cpu was unplugged.
> >
> > 2.6.29 consolidated this into one routine (and fixed hotplug) but introduced
> > another variation: anding the affinity with cfg->domain.  Is this right, or
> > should we just set it to what the user said?  Or as now, indicate that we're
> > restricting it.
> >
> > If we should change it, here's what the patch looks like against x86 tip
> > (cpu_mask_to_apicid_and already takes cpu_online_mask into account):
> >
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index 86827d8..30906cd 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -592,10 +592,10 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
> >        if (assign_irq_vector(irq, cfg, mask))
> >                return BAD_APICID;
> >
> > -       cpumask_and(desc->affinity, cfg->domain, mask);
> > +       cpumask_copy(desc->affinity, mask);
> >        set_extra_move_desc(desc, mask);
> >
> > -       return apic->cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
> > +       return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
> >  }
> >
> >  static void
> >
> cfg->domain for logical flat: will be ALL_CPUS
> for phys flat (aka bigsmp on 32bit) will be one cpu set mask.
> 
> so desc->affinity: for logical will be not changed, but
> set_desc_affinity() return will be changed. ( not add with
> cpu_online_mask anymore)

No, internally cpu_mask_to_apicid_and() does and with cpu_online_mask
already, eg in include/asm/bigsmp/apic.h:

static inline unsigned int cpu_mask_to_apicid_and(const struct cpumask *cpumask,
						  const struct cpumask *andmask)
{
	int cpu;

	/*
	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
	 * May as well be the first.
	 */
	for_each_cpu_and(cpu, cpumask, andmask)
		if (cpumask_test_cpu(cpu, cpu_online_mask))
			break;
	if (cpu < nr_cpu_ids)
		return cpu_to_logical_apicid(cpu);

	return BAD_APICID;
}

> when mask is 0x0f
> for phys flat, desc->affinity will be changed to 0x0f from
> 0x01/0x02/0x04/08, return set_desc_affinity is not changed.
> so /proc/irq/xx/smp_affinity will be changed. and it does reflect that
> actually affinity.
> 
> so this patch looks not right.

Only change should be that smp_affinity will reflect actual affinity, not
affinity user set.

Thanks,
Rusty.
