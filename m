Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYISRnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYISRnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYISRnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:43:43 -0400
Received: from 8bytes.org ([88.198.83.132]:38801 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYISRnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:43:42 -0400
Date: Fri, 19 Sep 2008 19:43:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, muli@il.ibm.com
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080919174339.GA29039@8bytes.org>
References: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com> <20080918041104K.fujita.tomonori@lab.ntt.co.jp> <20080917192827.GA18515@8bytes.org> <20080918102931Z.fujita.tomonori@lab.ntt.co.jp> <20080918140350.GE24392@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080918140350.GE24392@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

FUJITA mentioned that I forgot to discuss this patch with you guys, the
implementers and maintainers for Intel VT-d and Calgary IOMMU drivers. I
would like to hear your opinion on that patch. He is right with that.
The patch is already in tip/iommu but can easily be reverted if there
are fundamental objections.
The patch basically moves the iommu=fullflush and iommu=nofullflush
option from the GART code to pci-dma.c. So we can use these parameters
in other IOMMU implementations too. Since Intel VT-d is implementing
also lazy IO/TLB flushing it would benefit from this generic parameter
too. I am not so sure about Calgary, but we have other parameters for
iommu= which doesn't affect all hardware IOMMUs.

Joerg

On Thu, Sep 18, 2008 at 04:03:50PM +0200, Joerg Roedel wrote:
> On Thu, Sep 18, 2008 at 10:29:24AM +0900, FUJITA Tomonori wrote:
> > On Wed, 17 Sep 2008 21:28:27 +0200
> > Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > > On Thu, Sep 18, 2008 at 04:20:18AM +0900, FUJITA Tomonori wrote:
> > > > On Wed, 17 Sep 2008 18:52:37 +0200
> > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > 
> > > > > The IO/TLB flushing on every unmaping operation is the most expensive
> > > > > part there and not strictly necessary. It is sufficient to do the flush
> > > > > before any entries are reused. This is patch implements lazy IO/TLB
> > > > > flushing which does exactly this.
> > > > > 
> > > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > > ---
> > > > >  Documentation/kernel-parameters.txt |    5 +++++
> > > > >  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
> > > > >  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
> > > > >  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
> > > > >  4 files changed, 45 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > > index c2e00ee..5f0aefe 100644
> > > > > --- a/Documentation/kernel-parameters.txt
> > > > > +++ b/Documentation/kernel-parameters.txt
> > > > > @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > > > >  			isolate - enable device isolation (each device, as far
> > > > >  			          as possible, will get its own protection
> > > > >  			          domain)
> > > > > +			unmap_flush - enable flushing of IO/TLB entries when
> > > > > +			              they are unmapped. Otherwise they are
> > > > > +				      flushed before they will be reused, which
> > > > > +				      is a lot of faster
> > > > > +
> > > > 
> > > > Would it be nice to have consistency of IOMMU parameters?
> > > 
> > > True. We should merge common parameters across IOMMUs into the
> > > iommu= parameter some time in the future, I think. It would also be the
> > > place for the IOMMU size parameter.
> > 
> > Hmm, now is better than the future? I think that now you can add
> > something like 'disable_batching_flush' as a common parameter and
> > change AMD IOMMU to use it.
> 
> Ok, I queued the following patch in the AMD IOMMU updates and changed
> this patch to use iommu_fullflush instead. Is this patch ok? It changes
> the behavior of GART to use lazy flushing by default. But I don't think
> that this is a problem.
> 
> commit 9769771290fddcfc0362c5d30242151d4eb1cc46
> Author: Joerg Roedel <joerg.roedel@amd.com>
> Date:   Thu Sep 18 15:23:43 2008 +0200
> 
>     x86: move GART TLB flushing options to generic code
>     
>     The GART currently implements the iommu=[no]fullflush command line
>     parameters which influence its IO/TLB flushing strategy. This patch
>     makes these parameters generic so that they can be used by the AMD IOMMU
>     too.
>     
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c2e00ee..569527e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  		nomerge
>  		forcesac
>  		soft
> +		fullflush
> +			Flush IO/TLB at every deallocation
> +		nofullflush
> +			Flush IO/TLB only when addresses are reused (default)
>  
>  
>  	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
> diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> index 72ffb53..42c887b 100644
> --- a/Documentation/x86/x86_64/boot-options.txt
> +++ b/Documentation/x86/x86_64/boot-options.txt
> @@ -229,8 +229,6 @@ IOMMU (input/output memory management unit)
>    iommu options only relevant to the AMD GART hardware IOMMU:
>      <size>             Set the size of the remapping area in bytes.
>      allowed            Overwrite iommu off workarounds for specific chipsets.
> -    fullflush          Flush IOMMU on each allocation (default).
> -    nofullflush        Don't use IOMMU fullflush.
>      leak               Turn on simple iommu leak tracing (only when
>                         CONFIG_IOMMU_LEAK is on). Default number of leak pages
>                         is 20.
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 23882c4..6dae123 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -16,6 +16,15 @@ EXPORT_SYMBOL(dma_ops);
>  
>  static int iommu_sac_force __read_mostly;
>  
> +/*
> + * If this is disabled the IOMMU will use an optimized flushing strategy
> + * of only flushing when an mapping is reused. With it true the GART is
> + * flushed for every mapping. Problem is that doing the lazy flush seems
> + * to trigger bugs with some popular PCI cards, in particular 3ware (but
> + * has been also also seen with Qlogic at least).
> + */
> +int iommu_fullflush;
> +
>  #ifdef CONFIG_IOMMU_DEBUG
>  int panic_on_overflow __read_mostly = 1;
>  int force_iommu __read_mostly = 1;
> @@ -171,6 +180,10 @@ static __init int iommu_setup(char *p)
>  		}
>  		if (!strncmp(p, "nomerge", 7))
>  			iommu_merge = 0;
> +		if (!strncmp(p, "fullflush", 8))
> +			iommu_fullflush = 1;
> +		if (!strncmp(p, "nofullflush", 11))
> +			iommu_fullflush = 0;
>  		if (!strncmp(p, "forcesac", 8))
>  			iommu_sac_force = 1;
>  		if (!strncmp(p, "allowdac", 8))
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index 9739d56..508ef47 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -45,15 +45,6 @@ static unsigned long iommu_pages;	/* .. and in pages */
>  
>  static u32 *iommu_gatt_base;		/* Remapping table */
>  
> -/*
> - * If this is disabled the IOMMU will use an optimized flushing strategy
> - * of only flushing when an mapping is reused. With it true the GART is
> - * flushed for every mapping. Problem is that doing the lazy flush seems
> - * to trigger bugs with some popular PCI cards, in particular 3ware (but
> - * has been also also seen with Qlogic at least).
> - */
> -int iommu_fullflush = 1;
> -
>  /* Allocation bitmap for the remapping area: */
>  static DEFINE_SPINLOCK(iommu_bitmap_lock);
>  /* Guarded by iommu_bitmap_lock: */
> @@ -901,10 +892,6 @@ void __init gart_parse_options(char *p)
>  #endif
>  	if (isdigit(*p) && get_option(&p, &arg))
>  		iommu_size = arg;
> -	if (!strncmp(p, "fullflush", 8))
> -		iommu_fullflush = 1;
> -	if (!strncmp(p, "nofullflush", 11))
> -		iommu_fullflush = 0;
>  	if (!strncmp(p, "noagp", 5))
>  		no_agp = 1;
>  	if (!strncmp(p, "noaperture", 10))
> diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
> index 546ad31..bcebc37 100644
> --- a/include/asm-x86/iommu.h
> +++ b/include/asm-x86/iommu.h
> @@ -7,6 +7,7 @@ extern struct dma_mapping_ops nommu_dma_ops;
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
>  extern int dmar_disabled;
> +extern int iommu_fullflush;
>  
>  extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
>  
> 
> -- 
>            |           AMD Saxony Limited Liability Company & Co. KG
>  Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
>  System    |                  Register Court Dresden: HRA 4896
>  Research  |              General Partner authorized to represent:
>  Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
>            | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
