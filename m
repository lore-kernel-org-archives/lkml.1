Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZERGD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZERGD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 02:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbZERGDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 02:03:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:31630 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZERGDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 02:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lctZDXzeY3jrS7BVyezEjj0GpU6kKuPIfyoMia7/MYyzF2nejn6KnZ3ep9vWcd2K9l
         MLVs865t3qCVv/RrgGy+uGdsFytSX2ldE16HLfZI0qYsO1NhjELl9l8UoPDAjsFZSIH/
         zOvje5NKSHdxxLRbXiNQKex+CCRagLdprEiT4=
MIME-Version: 1.0
In-Reply-To: <200905172245.23774.arnd@arndb.de>
References: <20090513043409.GA13577@cynthia.pants.nu>
	 <200905172138.55145.arnd@arndb.de> <4A106E22.1010705@pobox.com>
	 <200905172245.23774.arnd@arndb.de>
Date: Mon, 18 May 2009 08:03:12 +0200
X-Google-Sender-Auth: e93f008b3ea838d5
Message-ID: <10f740e80905172303n4ef3cfc2j9922e19c281d471b@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, Robert Hancock <hancockrwd@gmail.com>,
       Tejun Heo <htejun@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 00:45, Arnd Bergmann <arnd@arndb.de> wrote:
> --- /dev/null
> +++ b/include/asm-generic/dma-mapping.h
> @@ -0,0 +1,399 @@
> +#ifndef _ASM_GENERIC_DMA_MAPPING_H
> +#define _ASM_GENERIC_DMA_MAPPING_H
> +/*
> + * This provides a no-op variant of the DMA mapping API,
> + * for use by architectures that do not actually support
> + * DMA, or that are fully consistent and linear-mapped
> + * in their DMA implementation.
> + */
> +
> +#include <asm/scatterlist.h>
> +
> +/*
> + * If any driver asks for DMA, it's not supported.
> + */
> +#ifndef dma_supported
> +static inline int
> +dma_supported(struct device *dev, u64 mask)
> +{
> +       return 0;
> +}
> +#endif
> +
> +#ifndef dma_set_mask
> +static inline int
> +dma_set_mask(struct device *dev, u64 dma_mask)
> +{
> +       if (!dev->dma_mask || !dma_supported(dev, dma_mask))
> +               return -EIO;
> +
> +       *dev->dma_mask = dma_mask;
> +       return 0;
> +}
> +#endif
> +
> +/**
> + * dma_alloc_coherent - allocate consistent memory for DMA
> + * @dev: valid struct device pointer, or NULL for ISA and EISA-like devices
> + * @size: required memory size
> + * @handle: bus-specific DMA address
> + *
> + * Allocate some uncached, unbuffered memory for a device for
> + * performing DMA.  This function allocates pages, and will
> + * return the CPU-viewed address, and sets @handle to be the
> + * device-viewed address.
> + */
> +#ifndef dma_alloc_coherent
> +static inline void *
> +dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> +                  gfp_t flag)
> +{
> +       void *virt = kmalloc(size, flag);

kmalloc() may fail.

> +       *dma_handle = virt_to_phys(virt);

Not all variants of virt_to_phys() may handle the NULL case very well.
I took a statistically invalid sample: some just cast to unsigned
long, other subtract PAGE_OFFSET.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
