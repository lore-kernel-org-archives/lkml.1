Return-Path: <linux-kernel-owner+w=401wt.eu-S2992586AbXDDFCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992586AbXDDFCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992589AbXDDFCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:02:25 -0400
Received: from colo.lackof.org ([198.49.126.79]:48525 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992586AbXDDFCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:02:24 -0400
Date: Tue, 3 Apr 2007 23:02:04 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org
Subject: Re: [parisc-linux] [KJ][PATCH] ROUND_?UP macro cleanup in drivers/parisc
Message-ID: <20070404050204.GC9446@colo.lackof.org>
References: <20070331105746.GA14572@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331105746.GA14572@arun.site>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 04:27:46PM +0530, Milind Arun Choudhary wrote:
> Clean up ROUND_?UP, Use ALIGN where ever appropriate.
> 
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

Milind,
Looks good to me.

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

Kyle,
can you remind me how these patches should be pushed into your tree?
Or do you want to directly apply them yourself?

I have the impression git.parisc-linux.org tree is stale and I should
be using something different. I just don't know what.

thanks,
grant

> 
> ---
>  ccio-dma.c      |    8 ++++----
>  iommu-helpers.h |    4 ++--
>  sba_iommu.c     |    6 ++----
>  3 files changed, 8 insertions(+), 10 deletions(-)
> 
> 
> 
> diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
> index 894fdb9..1459ca8 100644
> --- a/drivers/parisc/ccio-dma.c
> +++ b/drivers/parisc/ccio-dma.c
> @@ -32,6 +32,7 @@
>  */
>  
>  #include <linux/types.h>
> +#include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/mm.h>
>  #include <linux/spinlock.h>
> @@ -292,7 +293,6 @@ static int ioc_count;
>  #define PDIR_INDEX(iovp)    ((iovp)>>IOVP_SHIFT)
>  #define MKIOVP(pdir_idx)    ((long)(pdir_idx) << IOVP_SHIFT)
>  #define MKIOVA(iovp,offset) (dma_addr_t)((long)iovp | (long)offset)
> -#define ROUNDUP(x,y) ((x + ((y)-1)) & ~((y)-1))
>  
>  /*
>  ** Don't worry about the 150% average search length on a miss.
> @@ -668,7 +668,7 @@ ccio_mark_invalid(struct ioc *ioc, dma_addr_t iova, size_t byte_cnt)
>  	size_t saved_byte_cnt;
>  
>  	/* round up to nearest page size */
> -	saved_byte_cnt = byte_cnt = ROUNDUP(byte_cnt, IOVP_SIZE);
> +	saved_byte_cnt = byte_cnt = ALIGN(byte_cnt, IOVP_SIZE);
>  
>  	while(byte_cnt > 0) {
>  		/* invalidate one page at a time */
> @@ -751,7 +751,7 @@ ccio_map_single(struct device *dev, void *addr, size_t size,
>  	offset = ((unsigned long) addr) & ~IOVP_MASK;
>  
>  	/* round up to nearest IOVP_SIZE */
> -	size = ROUNDUP(size + offset, IOVP_SIZE);
> +	size = ALIGN(size + offset, IOVP_SIZE);
>  	spin_lock_irqsave(&ioc->res_lock, flags);
>  
>  #ifdef CCIO_MAP_STATS
> @@ -814,7 +814,7 @@ ccio_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
>  
>  	iova ^= offset;        /* clear offset bits */
>  	size += offset;
> -	size = ROUNDUP(size, IOVP_SIZE);
> +	size = ALIGN(size, IOVP_SIZE);
>  
>  	spin_lock_irqsave(&ioc->res_lock, flags);
>  
> diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
> index 38d9e1a..0a1f99a 100644
> --- a/drivers/parisc/iommu-helpers.h
> +++ b/drivers/parisc/iommu-helpers.h
> @@ -138,7 +138,7 @@ iommu_coalesce_chunks(struct ioc *ioc, struct scatterlist *startsg, int nents,
>  			** exceed DMA_CHUNK_SIZE if we coalesce the
>  			** next entry.
>  			*/   
> -			if(unlikely(ROUNDUP(dma_len + dma_offset + startsg->length,
> +			if(unlikely(ALIGN(dma_len + dma_offset + startsg->length,
>  					    IOVP_SIZE) > DMA_CHUNK_SIZE))
>  				break;
>  
> @@ -158,7 +158,7 @@ iommu_coalesce_chunks(struct ioc *ioc, struct scatterlist *startsg, int nents,
>  		** Allocate space for DMA stream.
>  		*/
>  		sg_dma_len(contig_sg) = dma_len;
> -		dma_len = ROUNDUP(dma_len + dma_offset, IOVP_SIZE);
> +		dma_len = ALIGN(dma_len + dma_offset, IOVP_SIZE);
>  		sg_dma_address(contig_sg) =
>  			PIDE_FLAG 
>  			| (iommu_alloc_range(ioc, dma_len) << IOVP_SHIFT)
> diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
> index 76a29da..7d83d9f 100644
> --- a/drivers/parisc/sba_iommu.c
> +++ b/drivers/parisc/sba_iommu.c
> @@ -113,8 +113,6 @@ module_param(sba_reserve_agpgart, int, 1);
>  MODULE_PARM_DESC(sba_reserve_agpgart, "Reserve half of IO pdir as AGPGART");
>  #endif
>  
> -#define ROUNDUP(x,y) ((x + ((y)-1)) & ~((y)-1))
> -
>  
>  /************************************
>  ** SBA register read and write support
> @@ -352,7 +350,7 @@ sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted)
>  		** SBA HW features in the unmap path.
>  		*/
>  		unsigned long o = 1 << get_order(bits_wanted << PAGE_SHIFT);
> -		uint bitshiftcnt = ROUNDUP(ioc->res_bitshift, o);
> +		uint bitshiftcnt = ALIGN(ioc->res_bitshift, o);
>  		unsigned long mask;
>  
>  		if (bitshiftcnt >= BITS_PER_LONG) {
> @@ -779,7 +777,7 @@ sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
>  	offset = iova & ~IOVP_MASK;
>  	iova ^= offset;        /* clear offset bits */
>  	size += offset;
> -	size = ROUNDUP(size, IOVP_SIZE);
> +	size = ALIGN(size, IOVP_SIZE);
>  
>  	spin_lock_irqsave(&ioc->res_lock, flags);
>  
> 
> -- 
> Milind Arun Choudhary
> _______________________________________________
> parisc-linux mailing list
> parisc-linux@lists.parisc-linux.org
> http://lists.parisc-linux.org/mailman/listinfo/parisc-linux
