Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKFDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKFDOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 22:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYKFDOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 22:14:05 -0500
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:59975 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbYKFDOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 22:14:04 -0500
From: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 06 Nov 2008 14:06:09 +1100
Message-ID: <49125F21.8010806@cse.unsw.edu.au>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
CC: akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: Panic in multiple kernels: IA64 SBA IOMMU: Culprit commit on
 Mar 28, 2008
References: <490F880E.4000801@cse.unsw.edu.au> <20081106032605J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081106032605J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> Sorry for the delay.
> 
> CC'ed linux-parisc since the same problem could happen to parisc.
> 
> On Tue, 04 Nov 2008 10:23:58 +1100
> Shehjar Tikoo <shehjart@cse.unsw.edu.au> wrote:
> 
>> I've been observing kernel panics for the past week on
>> kernel versions 2.6.26, 2.6.27 but not on 2.6.24 and 2.6.25.
>>
>> The panic message says:
>>
>> arch/ia64/hp/common/sba_iommu.c: I/O MMU is out of mapping resources
>>
>> Using git-bisect, I've zeroed in on the commit that introduced this.
>> Please see the attached file for the commit.
>>
>> The workload consists of 2 tests:
>> 1. Single fio process writing a 1 TB file.
>> 2. 15 fio processes writing 15GB files each.
>>
>> The panic happens on both workloads. There is no stack trace after
>> the above message.
>>
>> Other info:
>> System is HP RX6600(16Gb RAM, 16 processors w/ dual cores and HT)
>> 20 SATA disks under software RAID0 with 6 TB capacity.
>> Silicon Image 3124 controller.
>> File system is XFS.
>>
>> I'd much appreciate some help in fixing this because this panic has
>> basically stalled my own work. I'd be willing to run more tests on my
>> setup to test any patches that possibly fix this issue.
> 
> This patch modified the sba IOMMU driver to support LLDs' segment
> boundary limits properly.
> 
> ATA hardware has poor segment boundary limit, 64KB. In addition, sba
> IOMMU driver uses size-aligned allocation algorithm. It means that
> it's difficult for the IOMMU driver to find an appropriate I/O address
> space. I think that you hit the allocation failure due to this problem
> (of course, it's possible that my change breaks the IOMMU driver but I
> can't find a problem so far).
> 
> To make matters worse, sba IOMMU driver panic when the allocation
> fails. IIRC, only IA64 and parisc IOMMU drivers panic by default in
> the case of the allocation failure. I think that we need to change
> them to handle the failure properly.
> 
> Can you try this? I've not fixed map_single failure yet but I think
> that you hit the failure allocation in map_sg path.
> 

On 2.6.27, this patch seems to prevent the panic from happening for
both the tests I had described earlier. Do you need more info to 
validate this? I will be running more tests with this patch over
the next few days, so we'll find out anyway.

Thanks
Shehjar

> 
> diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
> index d98f0f4..8f44dc8 100644
> --- a/arch/ia64/hp/common/sba_iommu.c
> +++ b/arch/ia64/hp/common/sba_iommu.c
> @@ -676,12 +676,19 @@ sba_alloc_range(struct ioc *ioc, struct device *dev, size_t size)
>  			spin_unlock_irqrestore(&ioc->saved_lock, flags);
>  
>  			pide = sba_search_bitmap(ioc, dev, pages_needed, 0);
> -			if (unlikely(pide >= (ioc->res_size << 3)))
> -				panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n",
> -				      ioc->ioc_hpa);
> +			if (unlikely(pide >= (ioc->res_size << 3))) {
> +				printk(KERN_WARNING "%s: I/O MMU @ %p is"
> +				       "out of mapping resources, %u %u %lx\n",
> +				       __func__, ioc->ioc_hpa, ioc->res_size,
> +				       pages_needed, dma_get_seg_boundary(dev));
> +				return -1;
> +			}
>  #else
> -			panic(__FILE__ ": I/O MMU @ %p is out of mapping resources\n",
> -			      ioc->ioc_hpa);
> +			printk(KERN_WARNING "%s: I/O MMU @ %p is"
> +			       "out of mapping resources, %u %u %lx\n",
> +			       __func__, ioc->ioc_hpa, ioc->res_size,
> +			       pages_needed, dma_get_seg_boundary(dev));
> +			return -1;
>  #endif
>  		}
>  	}
> @@ -962,6 +969,7 @@ sba_map_single_attrs(struct device *dev, void *addr, size_t size, int dir,
>  #endif
>  
>  	pide = sba_alloc_range(ioc, dev, size);
> +	BUG_ON(pide < 0);
>  
>  	iovp = (dma_addr_t) pide << iovp_shift;
>  
> @@ -1304,6 +1312,7 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
>  	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
>  	int n_mappings = 0;
>  	unsigned int max_seg_size = dma_get_max_seg_size(dev);
> +	int idx;
>  
>  	while (nents > 0) {
>  		unsigned long vaddr = (unsigned long) sba_sg_address(startsg);
> @@ -1402,9 +1411,13 @@ sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
>  		vcontig_sg->dma_length = vcontig_len;
>  		dma_len = (dma_len + dma_offset + ~iovp_mask) & iovp_mask;
>  		ASSERT(dma_len <= DMA_CHUNK_SIZE);
> -		dma_sg->dma_address = (dma_addr_t) (PIDE_FLAG
> -			| (sba_alloc_range(ioc, dev, dma_len) << iovp_shift)
> -			| dma_offset);
> +		idx = sba_alloc_range(ioc, dev, dma_len);
> +		if (idx < 0) {
> +			dma_sg->dma_length = 0;
> +			return -1;
> +		}
> +		dma_sg->dma_address = (dma_addr_t)(PIDE_FLAG | (idx << iovp_shift)
> +						   | dma_offset);
>  		n_mappings++;
>  	}
>  
> @@ -1476,6 +1489,10 @@ int sba_map_sg_attrs(struct device *dev, struct scatterlist *sglist, int nents,
>  	** Access to the virtual address is what forces a two pass algorithm.
>  	*/
>  	coalesced = sba_coalesce_chunks(ioc, dev, sglist, nents);
> +	if (coalesced < 0) {
> +		sba_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
> +		return 0;
> +	}
>  
>  	/*
>  	** Program the I/O Pdir

