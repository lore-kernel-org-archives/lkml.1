Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYK2PNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYK2PNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 10:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYK2PNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 10:13:24 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:38085 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbYK2PNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 10:13:23 -0500
Date: Sun, 30 Nov 2008 00:13:03 +0900
To: tsbogend@alpha.franken.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Fix dma_mapping_error for 32bit x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081129124627.F2ABDFA8C8@solo.franken.de>
References: <20081129124627.F2ABDFA8C8@solo.franken.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081130001152F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 13:46:27 +0100 (CET)
Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote:

> Devices like b44 ethernet can't dma from addresses above 1GB. The driver
> handles this cases by falling back to GFP_DMA allocation. But for detecting
> the problem it needs to get an indication from dma_mapping_error.
> The bug is triggered by using a VMSPLIT option of 2G/2G.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
> 
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

Surely, 2.6.27.4 needs this fix (and all the stable trees need this
too, I think).

This can't be cleanly applied to the current git (dma-mapping.h was
moved). How about just removing the ifdef? I think that it's clean a
bit.


diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 7f225a4..dc22c07 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -71,15 +71,11 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 /* Make sure we keep the same behaviour */
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-#ifdef CONFIG_X86_32
-	return 0;
-#else
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
 	return (dma_addr == bad_dma_address);
-#endif
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
