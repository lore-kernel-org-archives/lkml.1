Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0BKKpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:45:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38687 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab0BKKpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:45:30 -0500
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: adharmap@codeaurora.org, linux-arm-kernel@lists.infradead.org,
       linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
In-Reply-To: <20100210212156.GB30854@n2100.arm.linux.org.uk>
References: <20100210212156.GB30854@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Feb 2010 10:45:01 +0000
Message-Id: <1265885102.3389.34.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2010 10:45:05.0740 (UTC) FILETIME=[45C8F8C0:01CAAB07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 21:21 +0000, Russell King - ARM Linux wrote:
> On Wed, Feb 10, 2010 at 12:37:28PM -0800, adharmap@codeaurora.org wrote:
> > From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> >
> > Please refer to the post here
> > http://lkml.org/lkml/2010/1/4/347
> >
> > These changes are to introduce barrierless dma_map_area and dma_unmap_area and
> > use them to map the buffers in the scatterlist. For the last buffer, call
> > the normal dma_map_area(aka with barriers) effectively executing the barrier
> > at the end of the operation.
> 
> What if we make dma_map_area and dma_unmap_area both be barrier-less,
> and instead have a separate dma_barrier method - eg, something like the
> attached?

I was just writing the reply when I noticed yours :). Yes, that's a
better approach.

> diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
> index e290885..5928e78 100644
> --- a/arch/arm/include/asm/cacheflush.h
> +++ b/arch/arm/include/asm/cacheflush.h
> @@ -200,6 +200,7 @@ struct cpu_cache_fns {
> 
>         void (*dma_map_area)(const void *, size_t, int);
>         void (*dma_unmap_area)(const void *, size_t, int);
> +       void (*dma_barrier)(void);

Alternatively we could use the dsb() macro. I don't think we need more
than this and we would not (well, not easily) compile ARMv5 and ARMv6 in
the same kernel.

Anyway, an additional branch and return would probably be negligible
compared to the cache flushing operation.

> @@ -345,6 +347,7 @@ static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
>         BUG_ON(!valid_dma_direction(dir));
> 
>         __dma_single_cpu_to_dev(cpu_addr, size, dir);
> +       __dma_barrier(dir);
> 
>         return virt_to_dma(dev, cpu_addr);
>  }

The ___dma_single_cpu_to_dev() covers both inner and outer caches but I
haven't seen it touched by this patch (nor the other you posted). When
you clean the L1 cache, you need to make sure that there is a barrier
(DSB) so that it completes before cleaning the L2, otherwise you clean
the L2 but data keeps coming from L1.

For the *_sg functions, you either use barrier between L1 and L2 for
each page or you do the for_each_sg() loop twice, once for L1 and
another for L2.

-- 
Catalin

