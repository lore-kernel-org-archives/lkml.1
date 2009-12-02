Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbZLBH0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbZLBH0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 02:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZLBH0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 02:26:18 -0500
Received: from sh.osrg.net ([192.16.179.4]:59405 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLBH0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 02:26:17 -0500
Date: Wed, 2 Dec 2009 16:25:30 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B160FE1.1090307@kernel.org>
References: <4B14C8C8.9020604@kernel.org>
	<20091202144156N.fujita.tomonori@lab.ntt.co.jp>
	<4B160FE1.1090307@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091202162510Q.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 02 Dec 2009 16:25:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Dec 2009 22:57:37 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 30 Nov 2009 23:42:00 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> On Thu, 26 Nov 2009 23:45:33 -0800
> >>> Yinghai Lu <yinghai@kernel.org> wrote:
> >>>
> >>>>>> when AMD64 mem > 4g, no AGP, BIOS set all gart iommu on all nodes size to 32M, and enable bit are set.
> >>>>> I have such machine (with sane BIOS).
> >>>>>
> >>>>> But if BIOS is broken, early_gart_iommu_check() disables GART_EN bit
> >>>>> (bits 0)?
> >>>> not for 32M small size.
> >>>>
> >>>> that function only clear that bit when different nodes have different setting.
> >>>>
> >>>>>> 1. iommu=soft, will go through POINT A and POINT B
> >>>>> Not always. if aperture_valid() is true, it doesn't go POINT A. My
> >>>>> GART machine doesn't go.
> >>>> maybe your bios set GART iommu set to 64M?
> >>> Yeah, my machine has sane BIOS.
> >>>
> >>>
> >>>>>> 2. no "iommu=soft", will go through POINT A and POINT C
> >>>>> As I said, it's not true about POINT A.
> >>>> maybe your bios set GART iommu set to 64M?
> >>>>
> >>>>>> and all will reach POINT X to make sure ENABLE bit is not set.
> >>>>> POINT X doesn't look make sure ENABLE bit is not set. It just fixes up
> >>>>> (sets) the address and its size.
> >>>>                         write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
> >>>>
> >>>> that bit is that bit 0 of AMD64_GARTAPERTURECTL reg.
> >>> Oops, thanks.
> >>>
> >>> But as I wrote in the previous mail, can you tell me why we need this?
> >>> With 2.6.31 my machine uses swiotlb with GART_EN bit enabled.
> >>>
> >>> My another question is that why can't early_gart_iommu_check()
> >>> _always_ disable GART_EN bit?
> >> please check
> > 
> > Thanks.
> > 
> > As I said, it looks cleaner if early_gart_iommu_check() disables
> > GART_EN bit. So this patch looks better but I still have some
> > questions.
> > 
> > 
> >> [PATCH] x86: fix gart iommu using for amd 64 bit system -v4
> >>
> >> after
> >> |commit 75f1cdf1dda92cae037ec848ae63690d91913eac
> >> |Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >> |Date:   Tue Nov 10 19:46:20 2009 +0900
> >> |
> >> |    x86: Handle HW IOMMU initialization failure gracefully
> >> |    
> >> |    If HW IOMMU initialization fails (Intel VT-d often does this,
> >> |    typically due to BIOS bugs), we fall back to nommu. It doesn't
> >> |    work for the majority since nowadays we have more than 4GB
> >> |    memory so we must use swiotlb instead of nommu.
> >> ...
> >>
> >> amd 64 systems that
> >> 1. do not have  AGP
> >> 2. do not have IOMMU
> >> 3. mem > 4g
> >> 4. BIOS do not allocate  correct gart in NB.
> >> will leave them to use SWIOTLB forcely.
> > 
> > As I asked earlier, can you tell me what dma ops such system is
> > supposed to use?
> 
> gart_dma_ops

How does gart_dma_ops work on systems without IOMMU?


> >> -v2: call shutdown when no agp is there
> > 
> > Is this change related with my above patchset?
> 
> looks like one bug that is exposed by
> commit 338bac527ed0e35b4cb50390972f15d3cbce92ca
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Tue Oct 27 16:34:44 2009 +0900
> 
>     x86: Use x86_platform for iommu_shutdown
>     
>     This patch cleans up pci_iommu_shutdown() a bit to use
>     x86_platform (similar to how IA64 initializes an IOMMU driver).
>     
>     This adds iommu_shutdown() to x86_platform to avoid calling
>     every IOMMUs' shutdown functions in pci_iommu_shutdown() in
>     order. The IOMMU shutdown functions are platform specific (we
>     don't have multiple different IOMMU hardware) so the current way
>     is pointless.
>     
>     An IOMMU driver sets x86_platform.iommu_shutdown to the shutdown
>     function if necessary.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Cc: joerg.roedel@amd.com
>     LKML-Reference: <20091027163358F.fujita.tomonori@lab.ntt.co.jp>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index a7f1b64..a9bcdf7 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -39,6 +39,7 @@
>  #include <asm/swiotlb.h>
>  #include <asm/dma.h>
>  #include <asm/k8.h>
> +#include <asm/x86_init.h>
>  
>  static unsigned long iommu_bus_base;   /* GART remapping area (physical) */
>  static unsigned long iommu_size;       /* size of remapping area bytes */
> @@ -688,12 +689,12 @@ static struct dma_map_ops gart_dma_ops = {
>         .free_coherent                  = gart_free_coherent,
>  };
>  
> -void gart_iommu_shutdown(void)
> +static void gart_iommu_shutdown(void)
>  {
>         struct pci_dev *dev;
>         int i;
>  
> -       if (no_agp && (dma_ops != &gart_dma_ops))
> +       if (no_agp)
>                 return;
>  
>         for (i = 0; i < num_k8_northbridges; i++) {
> @@ -838,6 +839,7 @@ void __init gart_iommu_init(void)
>  
>         flush_gart();
>         dma_ops = &gart_dma_ops;
> +       x86_platform.iommu_shutdown = gart_iommu_shutdown;
>  }
>  
>  void __init gart_parse_options(char *p)
> 
> on system without agp, the gart should be shutdown during system shutdown. so make next kexeced kernel happy.

Ah, I see. Sorry about this mess-up.


> >> -v3: add check_store to restore state for swiotlb
> >>      separate pci_swiotlb_detect and pci_swiotlb_init from FUJITA
> >> -v4: disable translating in early_gart_iommu_check according to FUJITA
> > 
> > Why can't we always disable translation in early_gart_iommu_check? We
> > really need search_agp_bridge() in early_gart_iommu_check()?
> 
> just don't want to messed them up.

Sorry, I can't follow you. What does 'always disabling' mess up?
