Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYLFE4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYLFE4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 23:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYLFE4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 23:56:25 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:54816 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYLFE4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 23:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=C+VdXpQN5elJTuvfx+AL6vuUtU7mgTDqBaZW4wVef0OelTyX5PrAZ8no3+hfvuvYIe
         Ij+W3F4dcRSgl71AeR2xmgOZG13yBzHqqq4BnEhlI5s/oJysoPQPCO3uxWCE+icZ08OR
         XgHnCN+g12Qphyh+ozqAZvA823SUyKu1euqLw=
Message-ID: <86802c440812052056r6b08fd0dpfae41dee8ee9ac65@mail.gmail.com>
Date: Fri, 5 Dec 2008 20:56:23 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "John Keller" <jpk@sgi.com>
Subject: Re: genirq regression - CONFIG_AUTO_IRQ_AFFINITY
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200812051640.mB5Ge2U1122172@fcbayern.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812051640.mB5Ge2U1122172@fcbayern.americas.sgi.com>
X-Google-Sender-Auth: a4c93410f54d4693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 8:40 AM, John Keller <jpk@sgi.com> wrote:
> The addition of the generic affinity autoselector has introduced
> a regression in SN2 Altix.
>
> In the past, request_irq()'s call to select_smp_affinity() was
> essentially a noop.
>
> #ifdef CONFIG_AUTO_IRQ_AFFINITY
> extern int select_smp_affinity(unsigned int irq);
> #else
> static inline int select_smp_affinity(unsigned int irq)
> {
>        return 1;
> }
>
>
> Now changes have created do_irq_select_affinity(), which is
> executed by a call to request_irq().
>
>  request_irq()
>   __setup_irq()
>    do_irq_select_affinity()
>
> do_irq_select_affinity() will call the set_affinity() routine,
> with a default mask. On SN2 (and possibly all ia64 platforms),
> this will retarget all device interrupts to the same CPU, most
> likely CPU0.

> I'm looking at a patch that makes use of the new IRQ_AFFINITY_SET
> flag in the irq_desc to get around this.
>

that bit only be set in irq_set_affinity(),

arch/mips/kernel/cevt-bcm1480.c:        irq_set_affinity(irq,
cpumask_of_cpu(cpu));
arch/mips/kernel/cevt-sb1250.c: irq_set_affinity(irq, cpumask_of_cpu(cpu));
arch/sparc64/kernel/of_device.c:                irq_set_affinity(irq,
numa_mask);
arch/sparc64/kernel/pci_msi.c:          irq_set_affinity(irq, numa_mask);
arch/x86/kernel/hpet.c:                 irq_set_affinity(hdev->irq,
cpumask_of_cpu(hdev->cpu));
arch/x86/kernel/hpet.c: irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
drivers/xen/events.c:   irq_set_affinity(irq, cpumask_of_cpu(0));

kernel/irq/proc.c:      irq_set_affinity(irq, new_value);

kernel/time/tick-common.c:              irq_set_affinity(newdev->irq, *cpumask);

so you may need to call it in your arch code. like
setup_IO_APIC_irq(),  create_irq()...

YH
