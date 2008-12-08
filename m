Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYLHOaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYLHOaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYLHOaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:30:01 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60654 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752021AbYLHOaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:30:00 -0500
From: John Keller <jpk@sgi.com>
Message-Id: <200812081429.mB8ETtBO145498@fcbayern.americas.sgi.com>
Subject: Re: genirq regression - CONFIG_AUTO_IRQ_AFFINITY
To: yinghai@kernel.org (Yinghai Lu)
Date: Mon, 8 Dec 2008 08:29:54 -0600 (CST)
Cc: jpk@sgi.com (John Keller), linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu (Ingo Molnar)
In-Reply-To: <86802c440812052056r6b08fd0dpfae41dee8ee9ac65@mail.gmail.com> from "Yinghai Lu" at Dec 05, 2008 08:56:23 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Fri, Dec 5, 2008 at 8:40 AM, John Keller <jpk@sgi.com> wrote:
> > The addition of the generic affinity autoselector has introduced
> > a regression in SN2 Altix.
> >
> > In the past, request_irq()'s call to select_smp_affinity() was
> > essentially a noop.
> >
> > #ifdef CONFIG_AUTO_IRQ_AFFINITY
> > extern int select_smp_affinity(unsigned int irq);
> > #else
> > static inline int select_smp_affinity(unsigned int irq)
> > {
> >        return 1;
> > }
> >
> >
> > Now changes have created do_irq_select_affinity(), which is
> > executed by a call to request_irq().
> >
> >  request_irq()
> >   __setup_irq()
> >    do_irq_select_affinity()
> >
> > do_irq_select_affinity() will call the set_affinity() routine,
> > with a default mask. On SN2 (and possibly all ia64 platforms),
> > this will retarget all device interrupts to the same CPU, most
> > likely CPU0.
> 
> > I'm looking at a patch that makes use of the new IRQ_AFFINITY_SET
> > flag in the irq_desc to get around this.
> >
> 
> that bit only be set in irq_set_affinity(),
> 
> arch/mips/kernel/cevt-bcm1480.c:        irq_set_affinity(irq,
> cpumask_of_cpu(cpu));
> arch/mips/kernel/cevt-sb1250.c: irq_set_affinity(irq, cpumask_of_cpu(cpu));
> arch/sparc64/kernel/of_device.c:                irq_set_affinity(irq,
> numa_mask);
> arch/sparc64/kernel/pci_msi.c:          irq_set_affinity(irq, numa_mask);
> arch/x86/kernel/hpet.c:                 irq_set_affinity(hdev->irq,
> cpumask_of_cpu(hdev->cpu));
> arch/x86/kernel/hpet.c: irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
> drivers/xen/events.c:   irq_set_affinity(irq, cpumask_of_cpu(0));
> 
> kernel/irq/proc.c:      irq_set_affinity(irq, new_value);
> 
> kernel/time/tick-common.c:              irq_set_affinity(newdev->irq, *cpumask);
> 
> so you may need to call it in your arch code. like
> setup_IO_APIC_irq(),  create_irq()...
> 
> YH
> 

Yes, I am planning to set it in SN platform specific code,
sn_irq_fixup().

John
