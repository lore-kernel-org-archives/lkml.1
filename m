Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab0BEVG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:06:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:39583 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab0BEVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:06:55 -0500
Date: Fri, 5 Feb 2010 13:05:34 -0800
From: Brandon Philips <bphilips@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: keep chip_data in create_irq_nr
Message-ID: <20100205210534.GD4930@jenkins.home.ifup.org>
References: <20100203033109.GA17985@jenkins.home.ifup.org>
 <4B694DEF.70301@kernel.org>
 <20100203174216.GB17985@jenkins.home.ifup.org>
 <4B6BDAC0.3090900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6BDAC0.3090900@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:45 Fri 05 Feb 2010, Yinghai Lu wrote:
> Brodon found:
> race happened when two drivers were setting up MSI-X at the same
> time via pci_enable_msix(). See this dmesg excerpt:
> 
> [   85.170610] ixgbe 0000:02:00.1: irq 97 for MSI/MSI-X
> [   85.170611]   alloc irq_desc for 99 on node -1
> [   85.170613] igb 0000:08:00.1: irq 98 for MSI/MSI-X
> [   85.170614]   alloc kstat_irqs on node -1
> [   85.170616] alloc irq_2_iommu on node -1
> [   85.170617]   alloc irq_desc for 100 on node -1
> [   85.170619]   alloc kstat_irqs on node -1
> [   85.170621] alloc irq_2_iommu on node -1
> [   85.170625] ixgbe 0000:02:00.1: irq 99 for MSI/MSI-X
> [   85.170626]   alloc irq_desc for 101 on node -1
> [   85.170628] igb 0000:08:00.1: irq 100 for MSI/MSI-X
> [   85.170630]   alloc kstat_irqs on node -1
> [   85.170631] alloc irq_2_iommu on node -1
> [   85.170635]   alloc irq_desc for 102 on node -1
> [   85.170636]   alloc kstat_irqs on node -1
> [   85.170639] alloc irq_2_iommu on node -1
> [   85.170646] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000088
> 
> As you can see igb and ixgbe are both alternating on create_irq_nr()
> via pci_enable_msix() in their probe function.
> 
> ixgbe: While looping through irq_desc_ptrs[] via create_irq_nr() ixgbe
> choses irq_desc_ptrs[102] and exits the loop, drops vector_lock and
> calls dynamic_irq_init. Then it sets irq_desc_ptrs[102]->chip_data =
> NULL via dynamic_irq_init().
> 
> igb: Grabs the vector_lock now and starts looping over irq_desc_ptrs[]
> via create_irq_nr(). It gets to irq_desc_ptrs[102] and does this:
> 
> 	cfg_new = irq_desc_ptrs[102]->chip_data;
> 	if (cfg_new->vector != 0)
> 		continue;
> 
> This hits the NULL deref.
> 
> so let remove the save and restore code.
> just don't clear it in that path
>
> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> @@ -3280,12 +3280,9 @@ unsigned int create_irq_nr(unsigned int
>  	}
>  	spin_unlock_irqrestore(&vector_lock, flags);
>  
> -	if (irq > 0) {
> -		dynamic_irq_init(irq);
> -		/* restore it, in case dynamic_irq_init clear it */
> -		if (desc_new)
> -			desc_new->chip_data = cfg_new;
> -	}
> +	if (irq > 0)
> +		dynamic_irq_init_keep_chip_data(irq);
> +
>  	return irq;
>  }

Nearly every function in kernel/irq/chip.c takes the desc->lock when
manipulating the fields of the irq_desc including chip_data. Should
create_irq_nr() do the same when getting the chip_data field?

I am just a bit confused on what protects the chip_data field now.

Actually, while looking at your patch there is a related race in
destroy_irq() that I just noticed. This race could happen via
pci_disable_msix() in a driver or in the number of error paths that
call free_msi_irqs():

destroy_irq()
dynamic_irq_cleanup() which sets desc->chip_data = NULL
...race window...
desc->chip_data = cfg;

It could race with create_irq_nr() in the same way in the irq destroy
path.

So, I will reply after this with a combined patch fixing this
potential race along with the minor things below.

Cheers,

	Brandon

>  
> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -400,6 +400,7 @@ static inline int irq_has_action(unsigne
>  
>  /* Dynamic irq helper functions */
>  extern void dynamic_irq_init(unsigned int irq);
> +void dynamic_irq_init_keep_chip_data(unsigned int irq);
>  extern void dynamic_irq_cleanup(unsigned int irq);

Missing extern?

>  /* Set/get chip/data for an IRQ: */
> Index: linux-2.6/kernel/irq/chip.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/chip.c
> +++ linux-2.6/kernel/irq/chip.c
> @@ -22,7 +22,7 @@
>   *	dynamic_irq_init - initialize a dynamically allocated irq
>   *	@irq:	irq number to initialize

Update kerndoc?

> +static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
>  {
>  	struct irq_desc *desc;
>  	unsigned long flags;
> @@ -41,7 +41,8 @@ void dynamic_irq_init(unsigned int irq)
>  	desc->depth = 1;
>  	desc->msi_desc = NULL;
>  	desc->handler_data = NULL;
> -	desc->chip_data = NULL;
> +	if (!keep_chip_data)
> +		desc->chip_data = NULL;
>  	desc->action = NULL;
>  	desc->irq_count = 0;
>  	desc->irqs_unhandled = 0;
> @@ -54,6 +55,16 @@ void dynamic_irq_init(unsigned int irq)
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
>  }
>  
> +void dynamic_irq_init(unsigned int irq)
> +{
> +	dynamic_irq_init_x(irq, false);
> +}
> +
> +void dynamic_irq_init_keep_chip_data(unsigned int irq)
> +{
> +	dynamic_irq_init_x(irq, true);
> +}
> +
>  /**
>   *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
>   *	@irq:	irq number to initialize
