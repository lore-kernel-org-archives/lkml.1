Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbXCEGZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbXCEGZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 01:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXCEGZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 01:25:31 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8580 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXCEGZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 01:25:30 -0500
Date: Mon, 05 Mar 2007 00:25:09 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: data corruption with nvidia chipsets and IDE/SATA drives (k8 cpu
 errata needed?)
In-reply-to: <fa.lphwLNvMksoBFaqfqCzMG1UVhsA@ifi.uio.no>
To: linux-kernel@vger.kernel.org
Cc: Chip Coldwell <coldwell@redhat.com>, Andi Kleen <ak@suse.de>
Message-id: <45EBB7C5.2010407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Tb2r8Il/2H8l9dhmsGAAQB2WEZg@ifi.uio.no>
 <fa.MydhQJqKsehLS9lIc2JSZC8Q77A@ifi.uio.no>
 <fa.M9SCVAz1qZ6vrR9HTrRb95KdBSY@ifi.uio.no>
 <fa.5WKg4jbSxjbUXedux14VStNyV+8@ifi.uio.no>
 <fa.lphwLNvMksoBFaqfqCzMG1UVhsA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chip Coldwell wrote:
> On Wed, 17 Jan 2007, Andi Kleen wrote:
> 
>> On Wednesday 17 January 2007 07:31, Chris Wedgwood wrote:
>>> On Tue, Jan 16, 2007 at 08:52:32PM +0100, Christoph Anton Mitterer wrote:
>>>> I agree,... it seems drastic, but this is the only really secure
>>>> solution.
>>> I'd like to here from Andi how he feels about this?  It seems like a
>>> somewhat drastic solution in some ways given a lot of hardware doesn't
>>> seem to be affected (or maybe in those cases it's just really hard to
>>> hit, I don't know).
>> AMD is looking at the issue. Only Nvidia chipsets seem to be affected,
>> although there were similar problems on VIA in the past too.
>> Unless a good workaround comes around soon I'll probably default
>> to iommu=soft on Nvidia.
> 
> We (Sun, AMD, Nvidia and Red Hat) have been testing a patch that seems
> to solve the problem.  AMD and Nvidia analyzed an HDT trace that
> seemed to indicate that CPU updates of the GATT were still in cache
> when a subsequent table walk caused by a device load used a stale GATT
> PTE.  That analysis inspired this patch, submitted to this list as an
> RFC.  It is not obvious (to me, at least) why this problem has only
> shown up on Nvidia SATA controllers.
> 
> We are continuing to investigate.
> 
> diff --git a/arch/x86_64/kernel/pci-gart.c b/arch/x86_64/kernel/pci-gart.c
> index 030eb37..1dd461a 100644
> --- a/arch/x86_64/kernel/pci-gart.c
> +++ b/arch/x86_64/kernel/pci-gart.c
> @@ -69,6 +69,8 @@ static u32 gart_unmapped_entry;
>  #define AGPEXTERN
>  #endif
>  
> +#define GATT_CLFLUSH(i) asm volatile ("clflush (%0)" :: "r" (iommu_gatt_base + (i)))
> +
>  /* backdoor interface to AGP driver */
>  AGPEXTERN int agp_memory_reserved;
>  AGPEXTERN __u32 *agp_gatt_table;
> @@ -221,6 +223,7 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
>  	for (i = 0; i < npages; i++) {
>  		iommu_gatt_base[iommu_page + i] = GPTE_ENCODE(phys_mem);
>  		SET_LEAK(iommu_page + i);
> +		GATT_CLFLUSH(iommu_page + i);
>  		phys_mem += PAGE_SIZE;
>  	}
>  	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
> @@ -348,6 +351,7 @@ static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
>  		while (pages--) { 
>  			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr); 
>  			SET_LEAK(iommu_page);
> +			GATT_CLFLUSH(iommu_page);
>  			addr += PAGE_SIZE;
>  			iommu_page++;
>  		}
> 
> 

Andi, have you had a look at this? I'm a bit surprised at the lack of 
reaction to this find..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

