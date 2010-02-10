Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0BJX2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:28:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7578 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0BJX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:28:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5888"; a="33909447"
Message-ID: <4B734111.6070206@codeaurora.org>
Date: Wed, 10 Feb 2010 15:28:17 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-msm@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org> <20100210212156.GB30854@n2100.arm.linux.org.uk>
In-Reply-To: <20100210212156.GB30854@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Feb 10, 2010 at 12:37:28PM -0800, adharmap@codeaurora.org wrote:
>> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
>>
>> Please refer to the post here
>> http://lkml.org/lkml/2010/1/4/347
>>
>> These changes are to introduce barrierless dma_map_area and dma_unmap_area and
>> use them to map the buffers in the scatterlist. For the last buffer, call
>> the normal dma_map_area(aka with barriers) effectively executing the barrier
>> at the end of the operation.
> 
> What if we make dma_map_area and dma_unmap_area both be barrier-less,
> and instead have a separate dma_barrier method - eg, something like the
> attached?
> 
> This might allow for better I-cache usage by not having to duplicate the
> DMA cache coherence functions.

Agree, thanks for pointing this and for the patch.


> 
> @@ -369,6 +372,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
>  	BUG_ON(!valid_dma_direction(dir));
>  
>  	__dma_page_cpu_to_dev(page, offset, size, dir);
> +	__dma_barrier(dir);
>  
>  	return page_to_dma(dev, page) + offset;
>  }

dma_map_page is going to execute the barrier here.


>  /**
>   * dma_map_sg - map a set of SG buffers for streaming mode DMA
>   * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> @@ -537,6 +544,9 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  		if (dma_mapping_error(dev, s->dma_address))
>  			goto bad_mapping;
>  	}
> +
> +	__dma_barrier(dir);
> +
>  	return nents;

This would call the barrier in addition to the ones executed by 
dma_map_page.

We would need to call __dma_page_cpu_to_dev instead of dma_map_page and 
do the barrier before returning.
