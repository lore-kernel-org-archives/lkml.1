Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYKKGWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYKKGWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYKKGVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:21:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48632 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYKKGVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:21:48 -0500
Date: Tue, 11 Nov 2008 15:21:47 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Q] Why does dma_alloc_coherent() of ia64 GFP_DMA?
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com
In-Reply-To: <20081111144212F.fujita.tomonori@lab.ntt.co.jp>
References: <20081110121123.F82A.E1E9C6FF@jp.fujitsu.com> <20081111144212F.fujita.tomonori@lab.ntt.co.jp>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081111151827.D5D3.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 10 Nov 2008 13:47:51 +0900
> Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> 
> > I have a (may be dumb) question about dma_alloc_coherent() for ia64.
> > 
> > 
> > Why does dma_alloc_coherent() of ia64 force GFP_DMA yet?
> > And why is swiotlb_dma_alloc_coherent() default routine of
> > platform_dma_alloc_coherent()?
> > 
> > -------
> > #define dma_alloc_coherent(dev, size, handle, gfp)      \
> >         platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)
> > --------
> > 
> > Even if a device allows over 4G access and the driver doesn't specify
> > GFP_DMA, dma_alloc_coherent() returns under 4G area.
> > I guess many people think this is not so big issue because drivers require
> > very small memory generally.
> > 
> > However, I think this has the possibility of a finishing blow of OOM.
> > For example,
> > 
> >   1) Page caches occupy normal zone, and DMA zone is free.
> >   2) A user's application requires a few GB memory and mlock it.
> >      All DMA zone is occupied by it.
> >   3) A device which allows over 4GB is hot-added.
> >      But dma_alloc_coherent() try to allocate DMA zone.
> >      Then OOM occurs because there is no freeable pages.
> > 
> > I heard there are some users who require a few GB mlock.
> > There are similar trouble in past. 
> > 
> > 
> > If GFP_DMA is removed from above definition of dma_alloc_coherent(),
> > what will happen?
> 
> Probably, it breaks swiotlb with devices that don't have
> DMA_64BIT_MASK coherent_dma_mask.
> 
> 
> > If it is not allowed, how is followings?
> > 
> > dma_alloc_coherent()
> >   -> platform_dma_alloc_coherent()
> >        -> normal_alloc_coherent()
> >           {
> >                  if (dma_mask allow over 4G)
> >                         ret = __get_free_pages();
> > 				:
> >                         (check validation of returned address)
> > 				:
> >                  else 
> >                         swiotlb_alloc_coherent();
> >           }
> > }
> > 
> > If I'm something misunderstanding, please let me know.
> 
> Hmm, platform_dma_alloc_coherent is supposed to handle multiple dma
> ops, swiotlb, hardware IOMMUs like VT-d and sba, etc?
> 
> In IA64, the gfp zone flag matters for only swiotlb, I think.
> 
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] IA64: use GFP_DMA in dma_alloc_coherent only when necessary
> 
> For swiotlb, we need to set GFP_DMA if a device doesn't have
> DMA_64BIT_MASK coherent_dma_mask. hardware IOMMUs like VT-d and sba
> should ignore gfp zone flag.
> 
> diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
> index bbab7e2..d4de41b 100644
> --- a/arch/ia64/include/asm/dma-mapping.h
> +++ b/arch/ia64/include/asm/dma-mapping.h
> @@ -52,7 +52,9 @@ extern struct ia64_machine_vector ia64_mv;
>  extern void set_iommu_machvec(void);
>  
>  #define dma_alloc_coherent(dev, size, handle, gfp)	\
> -	platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)
> +	platform_dma_alloc_coherent(dev, size, handle,	\
> +				(dev)->coherent_dma_mask != DMA_64BIT_MASK ?  \
> +				(gfp) | GFP_DMA : gfp)
>  
>  /* coherent mem. is cheap */
>  static inline void *

Wao! Seems reasonable! Ack Ack!

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Thanks a lot!

-- 
Yasunori Goto 


