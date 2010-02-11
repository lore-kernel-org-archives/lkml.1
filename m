Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0BKVgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:36:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11737 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab0BKVgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:36:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5889"; a="33979805"
Message-ID: <4B74785B.8040809@codeaurora.org>
Date: Thu, 11 Feb 2010 13:36:27 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-msm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
References: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>	<20100210212156.GB30854@n2100.arm.linux.org.uk>	<4B734111.6070206@codeaurora.org> <20100210235700.GD30854@n2100.arm.linux.org.uk>
In-Reply-To: <20100210235700.GD30854@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  }
> @@ -363,7 +366,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
>   * The device owns this memory once this call has completed.  The CPU
>   * can regain ownership by calling dma_unmap_page().
>   */
> -static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
> +static inline dma_addr_t __dma_map_page(struct device *dev, struct page *page,
>  	     unsigned long offset, size_t size, enum dma_data_direction dir)
>  {
>  	BUG_ON(!valid_dma_direction(dir));
> @@ -373,6 +376,14 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
>  	return page_to_dma(dev, page) + offset;
>  }
>  
> +static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
> +	     unsigned long offset, size_t size, enum dma_data_direction dir)
> +{
> +	dma_addr_t addr = __dma_map_page(page, offset, size, dir);
> +	__dma_barrier(dir);
> +	return addr;
> +}
> +
>  /**
.
.
.
.
>  /**
>   * dma_map_sg - map a set of SG buffers for streaming mode DMA
>   * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> @@ -532,11 +539,14 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
>  	int i, j;
>  
>  	for_each_sg(sg, s, nents, i) {
> -		s->dma_address = dma_map_page(dev, sg_page(s), s->offset,
> +		s->dma_address = __dma_map_page(dev, sg_page(s), s->offset,
>  						s->length, dir);
>  		if (dma_mapping_error(dev, s->dma_address))
>  			goto bad_mapping;
>  	}
> +
> +	__dma_barrier(dir);
> +
>  	return nents;
>  
>   bad_mapping:
> @@ -564,6 +574,8 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nents,
>  
>  	for_each_sg(sg, s, nents, i)
>  		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
> +
> +	__dma_barrier(dir);
>  }
>  EXPORT_SYMBOL(dma_unmap_sg);

dma_unmap_sg too could use indirection like dma_map_sg.

Thanks for the patch.
Abhijeet

