Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbZLOJM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbZLOJM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZLOJMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:12:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:33425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759377AbZLOJMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:12:17 -0500
Message-ID: <4B2752A9.10903@kernel.org>
Date: Tue, 15 Dec 2009 01:11:05 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: rdreier@cisco.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: bisected crash due to "x86: Move swiotlb initialization before
 dma32_free_bootmem"
References: <ada8wd4brwk.fsf@roland-alpha.cisco.com> <20091215175439V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091215175439V.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 14 Dec 2009 23:47:07 -0800
> Roland Dreier <rdreier@cisco.com> wrote:
> 
>> I have a big box (64 threads, 256GB memory) that is crashing early in
>> boot as below.  I bisected it down to f4780ca0 ("x86: Move swiotlb
>> initialization before dma32_free_bootmem"); reverting just this commit
>> from the latest git (3ea6b3d0 is what I tested) fixes things.
> 
> Ah, really sorry about that.
> 
> 
>> I haven't tried to debug this yet, but I guess on such a huge box there
>> is not enough memory below 4GB for swiotlb if we don't free the 
> 
> Yeah, Yinghai also hit this (his box has more memory than yours).
> 
> 
>> stuff allocated earlier?  I don't know why that would be, since the
>> bootmem is grabbing 512MB and I have pretty close to 4GB below 4GB.
>> Anyway, I'm going to go to bed soon, but if you need more information or
>> have anything you want me to try, I will do it tomorrow morning.
> 
> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/0001-x86-two-stage-swiotlb-initialization.patch
> 
> It makes the swiotlb initialization into two stages. I don't like it
> much since I like to avoid complicating the initialization.
> 
> dma32_reserve_bootmem() allocates 128MB for broken GART IOMMU but I
> think 64MB should be enough since broken GART IOMMU allocates
> 64MB. The following simple patch might work too because swiotlb uses
> 64MB.
> 
> With coming huge memory boxes, we might need to work on ZONE_DMA32
> shortage issue anyway (sparse-vmemmap, anything else)?

maybe just revert f4780ca0... for now

actually dma32_free_bootmem will also make sure it will give some buffer to pci_swiotlb_init...

YH

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index fcc2f2b..afcc58b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -120,14 +120,11 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
-	int use_swiotlb;
-
-	use_swiotlb = pci_swiotlb_init();
 #ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 #endif
-	if (use_swiotlb)
+	if (pci_swiotlb_init())
 		return;
 
 	gart_iommu_hole_init();

