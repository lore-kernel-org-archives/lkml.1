Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYLALfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYLALfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYLALey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:34:54 -0500
Received: from 8bytes.org ([88.198.83.132]:45239 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYLALey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:34:54 -0500
Date: Mon, 1 Dec 2008 12:34:51 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
Message-ID: <20081201113451.GA24323@8bytes.org>
References: <20081129124627.F2ABDFA8C8@solo.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129124627.F2ABDFA8C8@solo.franken.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 01:46:27PM +0100, Thomas Bogendoerfer wrote:
> Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> handles this cases by falling back to GFP_DMA allocation. But for detecting
> the problem it needs to get an indication from dma_mapping_error.
> The bug is triggered by using a VMSPLIT option of 2G/2G.

Looks like your system uses swiotlb as the dma_ops backend. Its the only
implementation providing the ops->mapping_error callback and does not
use bad_dma_address as the error value.

> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Acked-by: Joerg Roedel <joro@8bytes.org>

> 
> diff -ru orig/linux-2.6.27.4/include/asm-x86/dma-mapping.h linux-2.6.27.4/include/asm-x86/dma-mapping.h
> --- orig/linux-2.6.27.4/include/asm-x86/dma-mapping.h	2008-10-26 00:05:07.000000000 +0200
> +++ linux-2.6.27.4/include/asm-x86/dma-mapping.h	2008-10-26 11:06:14.000000000 +0100
> @@ -74,15 +74,13 @@
>  /* Make sure we keep the same behaviour */
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> -#ifdef CONFIG_X86_32
> -	return 0;
> -#else
> +#ifdef CONFIG_X86_64
>  	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  	if (ops->mapping_error)
>  		return ops->mapping_error(dev, dma_addr);
>  
> -	return (dma_addr == bad_dma_address);
>  #endif
> +	return (dma_addr == bad_dma_address);
>  }
>  
>  #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
