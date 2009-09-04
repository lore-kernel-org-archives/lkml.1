Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbZIDN5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbZIDN5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZIDN5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:57:42 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:46196 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbZIDN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:57:41 -0400
X-SpamScore: -38
X-BigFish: VPS-38(z21eWz1432R98dN4015L179dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KPG9FS-03-T19-01
Date: Fri, 4 Sep 2009 15:56:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [git pull] AMD-IOMMU (AMD-Vi) updates for 2.6.32
Message-ID: <20090904135644.GB4906@amd.com>
References: <20090904100506.GD30765@amd.com>
 <20090904130645.GB9490@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090904130645.GB9490@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Sep 2009 13:56:44.0380 (UTC) FILETIME=[896A31C0:01CA2D67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

thanks for your comments.

On Fri, Sep 04, 2009 at 03:06:45PM +0200, Ingo Molnar wrote:
> +static void dump_dte_entry(u16 devid)
> +{
> +       int i;
> +
> +       for (i = 0; i < 8; ++i)
> +               pr_err("AMD-Vi: DTE[%d]: %08x\n", i,
> +                       amd_iommu_dev_table[devid].data[i]);
> 
> that 8 is not very obvious - it deserves a comment. (we allocate at 
> least one page to amd_iommu_dev_table[] so it's safe - but where the 
> 8 comes from is not very clear.)

Right. I will add a comment.

> Also, we tend to write 'i++' not '++i' in loops. (there's other 
> examples of this too in the iommu files)

Ok, I use ++i for historic reasons from my old c++ times ;-) Is there a
specific reason i++ is prefered?

> This log printing pattern:
> 
>         printk(KERN_ERR "AMD-Vi: Event logged [");
> 
>         switch (type) {
>         case EVENT_TYPE_ILL_DEV:
>                 printk("ILLEGAL_DEV_TABLE_ENTRY device=%02x:%02x.%x "
>                        "address=0x%016llx flags=0x%04x]\n",
> 
> is now broken (produces an unexpected newline) due to:
> 
>   5fd29d6: printk: clean up handling of log-levels and newlines
> 
> you probably want to convert all printk's to pr_*() calls, and use 
> pr_cont() in the above place.

Ok, I will chance this too.

> Similar comments hold for dump_command() as well.
> 
> +++ b/arch/x86/include/asm/amd_iommu_types.h
> @@ -457,4 +457,7 @@ static inline void amd_iommu_stats_init(void) { 
> }
>  
>  #endif /* CONFIG_AMD_IOMMU_STATS */
>  
> +/* some function prototypes */
> +extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
> +
> 
> function prototypes belong into amd_iommu.h, not amd_iommu_types.h.

The plan is to do it the other way around. Currently amd_iommu.h
contains the driver exported function prototypes and the prototypes of
functions only shared between amd_iommu_init.c and amd_iommu.c.
So my plan is to move the prototypes of the functions only shared
between the two driver source files to amd_iommu_types.h.
The prototypes I put into source files should all be forward
declarations of static functions only. Should these be in header files
too?

> there's also a lot of function prototypes declared in the .c file:
> 
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -61,6 +61,7 @@ static u64* alloc_pte(struct protection_domain 
> *dom,
>  static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
>                                       unsigned long start_page,
>                                       unsigned int pages);
> +static void reset_iommu_command_buffer(struct amd_iommu *iommu);
> 
> These can generally be avoided via cleaner ordering: first define 
> simpler functions then more complex ones (which rely on simpler 
> functions).
> 
> +       if (unlikely(i == EXIT_LOOP_COUNT)) {
> +               spin_unlock(&iommu->lock);
> +               reset_iommu_command_buffer(iommu);
> +               spin_lock(&iommu->lock);
> +       }
> 
> What did iommu->lock protect it here, why do we drop it, and why is 
> it necessary to take it again? This pattern shows that either 
> there's too much or too little locking.

This function runs with the iommu->lock held. But
reset_iommu_command_buffer calls functions which take it again. To not
let this dead-lock the lock must be released before calling
reset_iommu_command_buffer. I agree this is not very clean design. The
whole command sending and flushing infrastructure in the driver has
somewhat grown into a little mess and one of my next updates will be to
clean that up to make it easier to maintain.

> 
> +       /* increase reference counter */
> +       domain->dev_cnt += 1;
> 
> use ++?

Hmm, In this case I would prefer the += variant because its a single
instruction and not part of an expression. The compiler should optimize
it to the same instruction as a ++ variant.
I try to use the ++ variant when the result is part of another
expression.

> + * If a device is not yet associated with a domain, this function does
> + * assigns it visible for the hardware
> 
> typo.

Thanks, will fix.
> 
> +static void update_domain(struct protection_domain *domain)
> +{
> +       if (!domain->updated)
> +               return;
> +
> +       update_device_table(domain);
> +       flush_devices_by_domain(domain);
> +       iommu_flush_domain(domain->id);
> +
> +       domain->updated = false;
> +}
> 
> the domain->updated is a bit weird naming. Perhaps 
> domain->update_needed?

update_needed is a bit misleading. The domain _is_ already updated but
we need to inform the IOMMU hardware about it and flush TLBs and device
table entries for that domain. So 'updated' is the better choice here I
think. Or I make it more specific and call it pt_updated to make clear
that the page table changed (such a change means that the pt root
pointer changed).

> 
> +               iommu_unmap_page(domain, iova, PM_MAP_4k);
> 
> small nit: mixed-case letters - PM_MAP_4K is better i guess.

Thanks, will change that.

> +#define PM_ALIGNED(lvl, addr)  ((PM_MAP_MASK(lvl) & (addr)) == (addr))
> 
> macro with two uses of its parameter - this is side-effect-unsafe. 
> Safer would be to turn this into an inline function. That would also 
> do proper type checking.

Ok, I change that too.

> +       /* allocate passthroug domain */
> 
> typo.

Will fix, thanks.

> +/*****************************************************************************
> + *
> + * The next functions do a basic initialization of IOMMU for pass through
> + * mode
> + *
> + * In passthrough mode the IOMMU is initialized and enabled but not used for
> + * DMA-API translation.
> + *
> + 
> *****************************************************************************/
> 
> please use the customary (multi-line) comment style:
> 
>   /*
>    * Comment .....
>    * ...... goes here.
>    */
> 
> specified in Documentation/CodingStyle.
> 
> +#define PD_PASSTHROUGH_MASK    (1UL << 2) /* domain has no page
> +                                             translation */

Right, I will fix this too.

Thanks,
	
	Joerg


