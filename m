Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0BDDSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:18:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0BDDSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:18:34 -0500
Date: Wed, 3 Feb 2010 19:17:34 -0800
From: Brandon Philips <bphilips@suse.de>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: fix race in create_irq_nr on irq_desc
Message-ID: <20100204031734.GA4930@jenkins.home.ifup.org>
References: <20100203033109.GA17985@jenkins.home.ifup.org>
 <4B694DEF.70301@kernel.org>
 <20100203174216.GB17985@jenkins.home.ifup.org>
 <4B69CF1C.7050603@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B69CF1C.7050603@sun.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:31 Wed 03 Feb 2010, Yinghai Lu wrote:
> On 02/03/2010 09:42 AM, Brandon Philips wrote:
> > On 02:20 Wed 03 Feb 2010, Yinghai Lu wrote:
> >> On 02/02/2010 07:31 PM, Brandon Philips wrote:
> >>> Race in create_irq_nr():
> >>>
> >>> - Thread 1 loops through and calls irq_to_desc_alloc_node with new=0x66.
> >>>
> >>> - Thread 2 has exited the loop with irq=0x66 and calls dynamic_irq_init(0x66)
> >>>   setting desc->chip_data = NULL
> >>>
> >>> - Thread 1 then dereferences NULL via desc_new->chip_data->vector
> >>
> >> two threads get same irq?
> > 
> > This race happened when two drivers were setting up MSI-X at the same
> > time via pci_enable_msix(). See this dmesg excerpt:
> > 
> > [   85.170610] ixgbe 0000:02:00.1: irq 97 for MSI/MSI-X
> > [   85.170611]   alloc irq_desc for 99 on node -1
> > [   85.170613] igb 0000:08:00.1: irq 98 for MSI/MSI-X
> > [   85.170614]   alloc kstat_irqs on node -1
> > [   85.170616] alloc irq_2_iommu on node -1
> > [   85.170617]   alloc irq_desc for 100 on node -1
> > [   85.170619]   alloc kstat_irqs on node -1
> > [   85.170621] alloc irq_2_iommu on node -1
> > [   85.170625] ixgbe 0000:02:00.1: irq 99 for MSI/MSI-X
> > [   85.170626]   alloc irq_desc for 101 on node -1
> > [   85.170628] igb 0000:08:00.1: irq 100 for MSI/MSI-X
> > [   85.170630]   alloc kstat_irqs on node -1
> > [   85.170631] alloc irq_2_iommu on node -1
> > [   85.170635]   alloc irq_desc for 102 on node -1
> > [   85.170636]   alloc kstat_irqs on node -1
> > [   85.170639] alloc irq_2_iommu on node -1
> > [   85.170646] BUG: unable to handle kernel NULL pointer dereference
> > at 0000000000000088
> > 
> > As you can see igb and ixgbe are both alternating on create_irq_nr()
> > via pci_enable_msix() in their probe function. So, let me rewrite my
> > explanation using this example:
> > 
> > ixgbe: While looping through irq_desc_ptrs[] via create_irq_nr() ixgbe
> > choses irq_desc_ptrs[102] and exits the loop, drops vector_lock and
> > calls dynamic_irq_init. Then it sets irq_desc_ptrs[102]->chip_data =
> > NULL via dynamic_irq_init().
> > 
> > igb: Grabs the vector_lock now and starts looping over irq_desc_ptrs[]
> > via create_irq_nr(). It gets to irq_desc_ptrs[102] and does this:
> > 
> > 	cfg_new = irq_desc_ptrs[102]->chip_data;
> > 	if (cfg_new->vector != 0)
> > 		continue;
> > 
> > This hits the NULL deref.
> > 
> 
> please try following patch in addition to 
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=37ef2a3029fde884808ff1b369677abc7dd9a79a

How is this commit related to this bug? The NULL deref I am hitting is
from this bit in create_irq_nr():

                 if (cfg_new->vector != 0)
                        continue;

Which comes before the assignment of cfg_new. I don't see how it is
related. Plus, node == -1 in this case so move_irq_desc() is a no-op.

> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 7edafc7..14099ba 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3280,12 +3280,9 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
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

That would solve it too but I don't think it is a great
solution. Keeping the vector_lock until we are completely done setting
up the irq is more straightforward and won't cost much time at all.

I am hesitant to have it tested since it is a really small race
window, reproducing took 40+ reboots initially and looks technically
correct.

Thanks,

	Brandon

