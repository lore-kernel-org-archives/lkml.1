Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbZLBFpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbZLBFpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 00:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZLBFpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 00:45:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:59858 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZLBFpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 00:45:12 -0500
Date: Wed, 2 Dec 2009 14:44:26 +0900
To: yinghai@kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: fix iommu=soft boot option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B14C8C8.9020604@kernel.org>
References: <4B0F839D.5050104@kernel.org>
	<20091127170347O.fujita.tomonori@lab.ntt.co.jp>
	<4B14C8C8.9020604@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091202144156N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 02 Dec 2009 14:44:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 23:42:00 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 26 Nov 2009 23:45:33 -0800
> > Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >>>> when AMD64 mem > 4g, no AGP, BIOS set all gart iommu on all nodes size to 32M, and enable bit are set.
> >>> I have such machine (with sane BIOS).
> >>>
> >>> But if BIOS is broken, early_gart_iommu_check() disables GART_EN bit
> >>> (bits 0)?
> >> not for 32M small size.
> >>
> >> that function only clear that bit when different nodes have different setting.
> >>
> >>>> 1. iommu=soft, will go through POINT A and POINT B
> >>> Not always. if aperture_valid() is true, it doesn't go POINT A. My
> >>> GART machine doesn't go.
> >> maybe your bios set GART iommu set to 64M?
> > 
> > Yeah, my machine has sane BIOS.
> > 
> > 
> >>>> 2. no "iommu=soft", will go through POINT A and POINT C
> >>> As I said, it's not true about POINT A.
> >> maybe your bios set GART iommu set to 64M?
> >>
> >>>
> >>>> and all will reach POINT X to make sure ENABLE bit is not set.
> >>> POINT X doesn't look make sure ENABLE bit is not set. It just fixes up
> >>> (sets) the address and its size.
> >>                         write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, aper_order << 1);
> >>
> >> that bit is that bit 0 of AMD64_GARTAPERTURECTL reg.
> > 
> > Oops, thanks.
> > 
> > But as I wrote in the previous mail, can you tell me why we need this?
> > With 2.6.31 my machine uses swiotlb with GART_EN bit enabled.
> > 
> > My another question is that why can't early_gart_iommu_check()
> > _always_ disable GART_EN bit?
> 
> please check

Thanks.

As I said, it looks cleaner if early_gart_iommu_check() disables
GART_EN bit. So this patch looks better but I still have some
questions.


> [PATCH] x86: fix gart iommu using for amd 64 bit system -v4
> 
> after
> |commit 75f1cdf1dda92cae037ec848ae63690d91913eac
> |Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> |Date:   Tue Nov 10 19:46:20 2009 +0900
> |
> |    x86: Handle HW IOMMU initialization failure gracefully
> |    
> |    If HW IOMMU initialization fails (Intel VT-d often does this,
> |    typically due to BIOS bugs), we fall back to nommu. It doesn't
> |    work for the majority since nowadays we have more than 4GB
> |    memory so we must use swiotlb instead of nommu.
> ...
> 
> amd 64 systems that
> 1. do not have  AGP
> 2. do not have IOMMU
> 3. mem > 4g
> 4. BIOS do not allocate  correct gart in NB.
> will leave them to use SWIOTLB forcely.

As I asked earlier, can you tell me what dma ops such system is
supposed to use?


> also in pci_iommu_alloc()
> pci_swiotlb_init is stealing the preallocate range that is for
> gart_iommu_hole workaround.
> 
> so restore the sequence...
> 
> will get back
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
> ...
> [   12.702822] calling  pci_iommu_init+0x0/0x31 @ 1
> [   12.708728] PCI-DMA: Disabling AGP.
> [   12.712812] PCI-DMA: aperture base @ 20000000 size 65536 KB
> [   12.718384] PCI-DMA: using GART IOMMU.
> [   12.722139] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> [   12.736944] initcall pci_iommu_init+0x0/0x31 returned 0 after 28802 usecs
> 
> -v2: call shutdown when no agp is there

Is this change related with my above patchset?


> -v3: add check_store to restore state for swiotlb
>      separate pci_swiotlb_detect and pci_swiotlb_init from FUJITA
> -v4: disable translating in early_gart_iommu_check according to FUJITA

Why can't we always disable translation in early_gart_iommu_check? We
really need search_agp_bridge() in early_gart_iommu_check()?
