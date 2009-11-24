Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZKXIrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZKXIrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZKXIre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:47:34 -0500
Received: from sh.osrg.net ([192.16.179.4]:53790 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbZKXIre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:47:34 -0500
Date: Tue, 24 Nov 2009 17:46:33 +0900
To: yinghai@kernel.org
Cc: mingo@elte.hu, hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4B08BD14.9060102@kernel.org>
References: <1257849980-22640-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<tip-75f1cdf1dda92cae037ec848ae63690d91913eac@git.kernel.org>
	<4B08BD14.9060102@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091124174608Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 24 Nov 2009 17:46:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Nov 2009 20:24:52 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> amd 64 systems that
> 1. do not have  AGP
> 2. do not have IOMMU
> 3. mem > 4g
> 4. BIOS do not allocate  correct gart in NB.
> will leave them to use SWIOTLB forcely.

Sorry, I forgot about this GART workaround.


> Index: linux-2.6/arch/x86/kernel/pci-dma.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/pci-dma.c
> +++ linux-2.6/arch/x86/kernel/pci-dma.c
> @@ -124,11 +124,12 @@ void __init pci_iommu_alloc(void)
>  	/* free the range so iommu could get some range less than 4G */
>  	dma32_free_bootmem();
>  #endif
> +	if (!swiotlb_force)
> +		gart_iommu_hole_init();
> +
>  	if (pci_swiotlb_init())
>  		return;
>  
> -	gart_iommu_hole_init();
> -
>  	detect_calgary();
>  
>  	detect_intel_iommu();

I prefer to detect all the IOMMU drivers in a consistent way;
detecting only GART before swioltb doesn't look nice.

As we did before, we could detect all the IOMMU driver before
swiotlb. However, I think that it's better to simply change
pci_swiotlb_init() not to steal the preallocate GART workaround memory.

btw, initializing swiotlb before IOMMU detection is useful to GART
too? If GART can't allocate the workaround memory, then the kernel
panic now. We can use swiotlb instead in that case?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: stop swiotlb stealing the GART workaround memory

swiotlb wrongly uses the GART workaround memory (for bad BIOS) that
dma32_reserv_bootmem allocates. We need to initialize swiotlb before
dma32_free_bootmem().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index afcc58b..26fe2cd 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -120,11 +120,15 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	int use_swiotlb;
+
+	use_swiotlb = pci_swiotlb_init();
+
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (pci_swiotlb_init())
+	if (use_swiotlb)
 		return;
 
 	gart_iommu_hole_init();
-- 
1.5.6.5

