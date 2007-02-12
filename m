Return-Path: <linux-kernel-owner+w=401wt.eu-S965411AbXBLVGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbXBLVGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965409AbXBLVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:06:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:47532 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXBLVGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:06:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,316,1167638400"; 
   d="scan'208"; a="198819518:sNHT20699007"
Date: Mon, 12 Feb 2007 13:06:04 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akpm@linux-foundation.org, Jeff Garzik <jeff@garzik.org>,
       Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] ia64: Fix noncoherent DMA API so devres builds
Message-ID: <20070212210604.GA12991@intel.com>
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com> <20070211063431.GS10050@ftp.linux.org.uk> <20070211153144.GA11547@osiris.ibm.com> <20070211154131.GW10050@ftp.linux.org.uk> <45CF3AF6.2060203@garzik.org> <adamz3kbarc.fsf@cisco.com> <adalkj49c42.fsf_-_@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adalkj49c42.fsf_-_@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 11, 2007 at 09:30:21PM -0800, Roland Dreier wrote:
> This patch fixes this by converting dma_{alloc,free}_noncoherent()
> into inline functions that call the corresponding coherent functions,
> instead of trying to do this with macros.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Only the "generic" configs were bust, but this patch does the trick
and everything builds and boots again.

Thanks

Acked-by: Tony Luck <tony.luck@intel.com>

> ---
>  include/asm-ia64/dma-mapping.h |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-ia64/dma-mapping.h b/include/asm-ia64/dma-mapping.h
> index ebd5887..6299b51 100644
> --- a/include/asm-ia64/dma-mapping.h
> +++ b/include/asm-ia64/dma-mapping.h
> @@ -8,9 +8,20 @@
>  #include <asm/machvec.h>
>  
>  #define dma_alloc_coherent	platform_dma_alloc_coherent
> -#define dma_alloc_noncoherent	platform_dma_alloc_coherent	/* coherent mem. is cheap */
> +/* coherent mem. is cheap */
> +static inline void *
> +dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> +		      gfp_t flag)
> +{
> +	return dma_alloc_coherent(dev, size, dma_handle, flag);
> +}
>  #define dma_free_coherent	platform_dma_free_coherent
> -#define dma_free_noncoherent	platform_dma_free_coherent
> +static inline void
> +dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
> +		     dma_addr_t dma_handle)
> +{
> +	dma_free_coherent(dev, size, cpu_addr, dma_handle);
> +}
>  #define dma_map_single		platform_dma_map_single
>  #define dma_map_sg		platform_dma_map_sg
>  #define dma_unmap_single	platform_dma_unmap_single
