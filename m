Return-Path: <linux-kernel-owner+w=401wt.eu-S936201AbXJTCDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936201AbXJTCDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbXJTCD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:03:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:4084 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbXJTCDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hoUcur6X8hBhym+vTH+tohP+5M4vhfME+wR+exQZCt2MgfZWFclDJ9CUm/z7rcTrXVx1XMigU0eyqgqWDkY464fE7dBslNcqyxqD39AMy2y02m9jaVd/BXJr5ilw8X/sQpeNum1s2IUp/741z+6q8PsYHlng0kB3DUC9OE82FH0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] synchronize_irq needs a barrier
Date: Sat, 20 Oct 2007 04:02:42 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
References: <1192670742.12879.5.camel@pasglop>
In-Reply-To: <1192670742.12879.5.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710200402.43106.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 03:25:42 Benjamin Herrenschmidt wrote:
> synchronize_irq needs at the very least a compiler barrier and a
> read barrier on SMP, but there are enough cases around where a
> write barrier is also needed and it's not a hot path so I prefer
> using a full smp_mb() here.
> 
> It will degrade to a compiler barrier on !SMP.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Index: linux-work/kernel/irq/manage.c
> ===================================================================
> --- linux-work.orig/kernel/irq/manage.c	2007-10-18 11:22:16.000000000 +1000
> +++ linux-work/kernel/irq/manage.c	2007-10-18 11:22:20.000000000 +1000
> @@ -33,6 +33,7 @@ void synchronize_irq(unsigned int irq)
>  	if (irq >= NR_IRQS)
>  		return;
>  
> +	smp_mb();
>  	while (desc->status & IRQ_INPROGRESS)
>  		cpu_relax();
>  }
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Hi,

I have read this thread and I concluded few things:

1) It is impossible to know that the card won't send more interrupts:
Even if I do a read from the device, the IRQ can be pending in the bus/APIC
It is even possible (and likely) that the IRQ line will be shared, thus the 
handler can be called by non-relevant device.

2) the synchronize_irq(); in .suspend is useless:
an IRQ can happen immediately after this synchronize_irq();
and interrupt even the .suspend()
(At least theoretically)


Thus I now understand that .suspend() should do:

	saa_writel(SAA7134_IRQ1, 0);
	saa_writel(SAA7134_IRQ2, 0);
	saa_writel(SAA7134_MAIN_CTRL, 0);

	dev->insuspend = 1;
	smp_wmb();

	/* at that point the _request to disable card's IRQs was issued, we don't know 
	   that there will be no irqs anymore.
	   the smp_mb(); guaranties that the IRQ handler will bail out in that case. */
	
	/* .......*/

	pci_save_state(pci_dev);
	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
	return 0;

and the interrupt handler:

	smp_rmb();
	if (dev->insuspend)
		goto out;

Am I right?
	Best regards,
		Maxim Levitsky
