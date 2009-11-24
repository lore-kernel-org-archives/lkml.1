Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbZKXKno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbZKXKno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932762AbZKXKnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:43:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:36511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbZKXKnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:43:41 -0500
Message-ID: <4B0BB892.9080401@kernel.org>
Date: Tue, 24 Nov 2009 02:42:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix gart iommu using for amd 64 bit system
References: <4B0BA519.9090100@kernel.org>	<20091124183439J.fujita.tomonori@lab.ntt.co.jp>	<4B0BAC06.1000905@kernel.org> <20091124193031P.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091124193031P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 24 Nov 2009 01:48:54 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Tue, 24 Nov 2009 01:19:21 -0800
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> FUJITA Tomonori wrote:
>>>>> On Sat, 21 Nov 2009 20:24:52 -0800
>>>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>>>
>>>>>> amd 64 systems that
>>>>>> 1. do not have  AGP
>>>>>> 2. do not have IOMMU
>>>>>> 3. mem > 4g
>>>>>> 4. BIOS do not allocate  correct gart in NB.
>>>>>> will leave them to use SWIOTLB forcely.
>>>>> Sorry, I forgot about this GART workaround.
>>>>>
>>>>>
>>>>>> Index: linux-2.6/arch/x86/kernel/pci-dma.c
>>>>>> ===================================================================
>>>>>> --- linux-2.6.orig/arch/x86/kernel/pci-dma.c
>>>>>> +++ linux-2.6/arch/x86/kernel/pci-dma.c
>>>>>> @@ -124,11 +124,12 @@ void __init pci_iommu_alloc(void)
>>>>>>  	/* free the range so iommu could get some range less than 4G */
>>>>>>  	dma32_free_bootmem();
>>>>>>  #endif
>>>>>> +	if (!swiotlb_force)
>>>>>> +		gart_iommu_hole_init();
>>>>>> +
>>>>>>  	if (pci_swiotlb_init())
>>>>>>  		return;
>>>>>>  
>>>>>> -	gart_iommu_hole_init();
>>>>>> -
>>>>>>  	detect_calgary();
>>>>>>  
>>>>>>  	detect_intel_iommu();
>>>>> I prefer to detect all the IOMMU drivers in a consistent way;
>>>>> detecting only GART before swioltb doesn't look nice.
>>>>>
>>>>> As we did before, we could detect all the IOMMU driver before
>>>>> swiotlb. However, I think that it's better to simply change
>>>>> pci_swiotlb_init() not to steal the preallocate GART workaround memory.
>>>>>
>>>>> btw, initializing swiotlb before IOMMU detection is useful to GART
>>>>> too? If GART can't allocate the workaround memory, then the kernel
>>>>> panic now. We can use swiotlb instead in that case?
>>>>>
>>>>> =
>>>>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>>>> Subject: [PATCH] x86: stop swiotlb stealing the GART workaround memory
>>>>>
>>>>> swiotlb wrongly uses the GART workaround memory (for bad BIOS) that
>>>>> dma32_reserv_bootmem allocates. We need to initialize swiotlb before
>>>>> dma32_free_bootmem().
>>>>>
>>>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>>>> ---
>>>>>  arch/x86/kernel/pci-dma.c |    6 +++++-
>>>>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
>>>>> index afcc58b..26fe2cd 100644
>>>>> --- a/arch/x86/kernel/pci-dma.c
>>>>> +++ b/arch/x86/kernel/pci-dma.c
>>>>> @@ -120,11 +120,15 @@ static void __init dma32_free_bootmem(void)
>>>>>  
>>>>>  void __init pci_iommu_alloc(void)
>>>>>  {
>>>>> +	int use_swiotlb;
>>>>> +
>>>>> +	use_swiotlb = pci_swiotlb_init();
>>>>> +
>>>>>  #ifdef CONFIG_X86_64
>>>>>  	/* free the range so iommu could get some range less than 4G */
>>>>>  	dma32_free_bootmem();
>>>>>  #endif
>>>>> -	if (pci_swiotlb_init())
>>>>> +	if (use_swiotlb)
>>>>>  		return;
>>>>>  
>>>>>  	gart_iommu_hole_init();
>>>> pci_swiotlb_init need be called after dma32_free_bootmem
>>>> otherwise it could fail for system with lots of memory and numa=off
>>> Why? swiotlb needs just 64MB (and some) in DMA32.
>>>
>>> swiotlb had been worked fine without that hack until 2.6.26?
>>>
>>> Only broken GART needs that hack (and I think that it's better to move
>>> that hack to GART code).
>> gart iommu workaround will allocate 64M by default.
>>
>> fail config: like system with 512g and sparse mem, and vmmap.
> 
> Well, some systems could fail but they can use swiotlb. If users
> configures their systems not to use swioltb by boot option, it's fair
> that systems don't work.
i mean when 512g and numa = off, even swiotlb could have chance not to get that 64M ram
> 
> We are talking about a rare broken GART BIOS issue. I think that it's
> much better to remove this hack completely. As VT-d does, we can use
> swiotlb instead of this GART specific hack. I think that that's saner
> approach to handle broken IOMMU hardware.

your second patch could break swiotlb...

at GART iommu workaround : it is not rare. a lot of systems have this problem.
and that workaround works well for several years.
don't think user will like to use SWIOTLB instead of swiotlb.

that gart iommu hardware is not broken, just those BIOS guys just forget to program it.

here intel vt-d is different, it seems can not make it work just program some hardware register...

please check my v2 patch, to see if it breaks your setup.

YH

