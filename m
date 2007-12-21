Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXLUJj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXLUJj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 04:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXLUJjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 04:39:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbXLUJjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 04:39:49 -0500
Date: Fri, 21 Dec 2007 09:39:05 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rdreier@cisco.com, linux-scsi@vger.kernel.org, davem@davemloft.net,
       james.bottomley@steeleye.com, ralf@linux-mips.org
Subject: Re: [PATCH 1/2] DMA buffer alignment annotations
Message-ID: <20071221093905.GB31115@flint.arm.linux.org.uk>
References: <20071221023010.C56B7DDDF3@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221023010.C56B7DDDF3@ozlabs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 01:30:07PM +1100, Benjamin Herrenschmidt wrote:
> The current patch only enables such alignment for some PowerPC
> platforms that do not have coherent caches. Other platforms such
> as ARM, MIPS, etc... can define ARCH_MIN_DMA_ALIGNMENT if they
> want to benefit from this, I don't know them well enough to do
> it myself.

Great.  We were talking about having something like this recently on
the ARM lists.  ARCH_MIN_DMA_ALIGNMENT for ARM would always be
L1_CACHE_BYTES on current CPUs.

> --- linux-merge.orig/include/asm-generic/page.h	2007-07-27 13:44:45.000000000 +1000
> +++ linux-merge/include/asm-generic/page.h	2007-12-21 13:07:28.000000000 +1100
> @@ -20,6 +20,16 @@ static __inline__ __attribute_const__ in
>  	return order;
>  }
>  
> +#ifndef ARCH_MIN_DMA_ALIGNMENT
> +#define __dma_aligned
> +#define __dma_buffer
> +#else
> +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
> +#define __dma_buffer		__dma_buffer_line(__LINE__)
> +#define __dma_buffer_line(line)	__dma_aligned;\
> +				char __dma_pad_##line[0] __dma_aligned

You introduce __dma_buffer_line() if ARCH_MIN_DMA_ALIGNMENT is set but
not if it isn't...

> +Note that on non-cache-coherent architectures, having a DMA buffer
> +that shares a cache line with other data can lead to memory
> +corruption.
> +
> +The __dma_buffer macro exists to allow safe DMA buffers to be declared
> +easily and portably as part of larger structures without causing bloat
> +on cache-coherent architectures. To get this macro, architectures have
> +to define ARCH_MIN_DMA_ALIGNMENT to the requested alignment value in
> +their asm/page.h before including asm-generic/page.h
> +
> +Of course these structures must be contained in memory that can be
> +used for DMA as described above.
> +
> +To use __dma_buffer, just declare a struct like:
> +
> +	struct mydevice {
> +		    int field1;
> +		    char buffer[BUFFER_SIZE] __dma_buffer;
> +		    int field2;
> +	};
> +
> +If this is used in code like:
> +
> +	struct mydevice *dev;
> +	dev = kmalloc(sizeof *dev, GFP_KERNEL);
> +
> +then dev->buffer will be safe for DMA on all architectures.  On a
> +cache-coherent architecture the members of dev will be aligned exactly
> +as they would have been without __dma_buffer; on a non-cache-coherent
> +architecture buffer and field2 will be aligned so that buffer does not
> +share a cache line with any other data.
> +

... but it's not described.  What's the purpose of it, and why would it
only be used on CPUs with ARCH_MIN_DMA_ALIGNMENT set?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
