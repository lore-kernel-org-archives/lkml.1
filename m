Return-Path: <linux-kernel-owner+w=401wt.eu-S933366AbYD3Vnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366AbYD3Vnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYD3Vnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:43:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:48518 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871AbYD3Vnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:43:42 -0400
Subject: Re: [PATCH v2] [POWERPC] devres: Add devm_ioremap_flags()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, htejun@gmail.com,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Emilian.Medve@Freescale.com, linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net>
Content-Type: text/plain
Date: Thu, 01 May 2008 07:42:30 +1000
Message-Id: <1209591750.18023.233.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 11:08 -0500, Kumar Gala wrote:
> From: Emil Medve <Emilian.Medve@Freescale.com>
> 
> We provide an ioremap_flags so provide a coresphonding devm_ioremap_flags.
> 
> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Forgot to commit the actual implemtation in arch/powerpc/lib/devres.c
> 
> Which tree should this go through, powerpc.git?

Let's call it ioremap_prot instead please. I'm about to change
ioremap_flags to ioremap_prot anyways. Keep the flags/prot argument
unsigned long for now (it can be argued it should be a pgprot but that
hasn't been sorted out completely).

Cheers,
Ben.

> - k
> 
>  arch/powerpc/lib/Makefile |    1 +
>  arch/powerpc/lib/devres.c |   33 +++++++++++++++++++++++++++++++++
>  include/asm-powerpc/io.h  |    8 +++++++-
>  include/linux/io.h        |    1 +
>  lib/devres.c              |    2 +-
>  5 files changed, 43 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/lib/devres.c
> 
> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
> index 4bb023f..f1d2cdc 100644
> --- a/arch/powerpc/lib/Makefile
> +++ b/arch/powerpc/lib/Makefile
> @@ -23,3 +23,4 @@ obj-$(CONFIG_SMP)	+= locks.o
>  endif
> 
>  obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
> +obj-$(CONFIG_HAS_IOMEM)	+= devres.o
> diff --git a/arch/powerpc/lib/devres.c b/arch/powerpc/lib/devres.c
> new file mode 100644
> index 0000000..b73c64b
> --- /dev/null
> +++ b/arch/powerpc/lib/devres.c
> @@ -0,0 +1,33 @@
> +#include <linux/device.h>	/* devres_*(), devm_ioremap_release() */
> +#include <linux/io.h>		/* ioremap_flags() */
> +#include <linux/module.h>	/* EXPORT_SYMBOL() */
> +
> +/**
> + * devm_ioremap_flags - Managed ioremap_flags()
> + * @dev: Generic device to remap IO address for
> + * @offset: BUS offset to map
> + * @size: Size of map
> + * @flags: Page flags
> + *
> + * Managed ioremap_flags().  Map is automatically unmapped on driver
> + * detach.
> + */
> +void __iomem *devm_ioremap_flags(struct device *dev, resource_size_t offset,
> +				 size_t size, unsigned long flags)
> +{
> +	void __iomem **ptr, *addr;
> +
> +	ptr = devres_alloc(devm_ioremap_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	addr = ioremap_flags(offset, size, flags);
> +	if (addr) {
> +		*ptr = addr;
> +		devres_add(dev, ptr);
> +	} else
> +		devres_free(ptr);
> +
> +	return addr;
> +}
> +EXPORT_SYMBOL(devm_ioremap_flags);
> diff --git a/include/asm-powerpc/io.h b/include/asm-powerpc/io.h
> index afae069..3b8c334 100644
> --- a/include/asm-powerpc/io.h
> +++ b/include/asm-powerpc/io.h
> @@ -2,7 +2,7 @@
>  #define _ASM_POWERPC_IO_H
>  #ifdef __KERNEL__
> 
> -/*
> +/*
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
>   * as published by the Free Software Foundation; either version
> @@ -18,6 +18,9 @@ extern int check_legacy_ioport(unsigned long base_port);
>  #define _PNPWRP		0xa79
>  #define PNPBIOS_BASE	0xf000
> 
> +#include <linux/device.h>
> +#include <linux/io.h>
> +
>  #include <linux/compiler.h>
>  #include <asm/page.h>
>  #include <asm/byteorder.h>
> @@ -744,6 +747,9 @@ static inline void * bus_to_virt(unsigned long address)
> 
>  #define clrsetbits_8(addr, clear, set) clrsetbits(8, addr, clear, set)
> 
> +void __iomem *devm_ioremap_flags(struct device *dev, resource_size_t offset,
> +				 size_t size, unsigned long flags);
> +
>  #endif /* __KERNEL__ */
> 
>  #endif /* _ASM_POWERPC_IO_H */
> diff --git a/include/linux/io.h b/include/linux/io.h
> index 831f57c..7a390cf 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -58,6 +58,7 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
>  }
>  #endif
> 
> +void devm_ioremap_release(struct device *dev, void *res);
>  void __iomem * devm_ioremap(struct device *dev, resource_size_t offset,
>  			    unsigned long size);
>  void __iomem * devm_ioremap_nocache(struct device *dev, resource_size_t offset,
> diff --git a/lib/devres.c b/lib/devres.c
> index 26c87c4..72c8909 100644
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -2,7 +2,7 @@
>  #include <linux/io.h>
>  #include <linux/module.h>
> 
> -static void devm_ioremap_release(struct device *dev, void *res)
> +void devm_ioremap_release(struct device *dev, void *res)
>  {
>  	iounmap(*(void __iomem **)res);
>  }

