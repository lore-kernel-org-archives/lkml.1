Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZERKr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZERKr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZERKqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:46:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:39850 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbZERKqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:46:40 -0400
Date: Mon, 18 May 2009 19:45:04 +0900
To: arnd@arndb.de
Cc: jgarzik@pobox.com, hancockrwd@gmail.com, htejun@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, schmitz@biophys.uni-duesseldorf.de,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200905172245.23774.arnd@arndb.de>
References: <200905172138.55145.arnd@arndb.de>
	<4A106E22.1010705@pobox.com>
	<200905172245.23774.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090518194443R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 18 May 2009 19:45:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 May 2009 22:45:21 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> h8300 and m32r currently do not provide a DMA mapping API
> and therefore cannot use the ATA drivers. This adds a
> generic version of dma-mapping.h for architectures that
> have none or very minimal actual support for DMA in hardware
> and makes the two architectures use it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> On Sunday 17 May 2009 20:05:54 Jeff Garzik wrote:
> 
> > That's what needs to happen.  We provide no-op functions for e.g. PCI 
> > and x86 DMI, for platforms where this support does not exist.
> > 
> > Pretty much all architectures support some form of ATA.  m68k, m32r, 
> > h8300 and microblaze all have IDE interface, which means that libata 
> > needs to work on that platform.
> > 
> > The only !ATA arch in the entire kernel is s390, AFAICT.
> 
> m68k only defines NO_DMA for Sun3 and Dragonball. Sun3 does
> not have ATA, Dragonball could probably just enable HAS_DMA.
> 
> ---
>  arch/h8300/Kconfig                   |    2 +-
>  arch/h8300/include/asm/dma-mapping.h |    1 +
>  arch/m32r/Kconfig                    |    2 +-
>  arch/m32r/include/asm/dma-mapping.h  |    1 +
>  include/asm-generic/dma-mapping.h    |  399 ++++++++++++++++++++++++++++++++++
>  5 files changed, 403 insertions(+), 2 deletions(-)
>  create mode 100644 arch/h8300/include/asm/dma-mapping.h
>  create mode 100644 arch/m32r/include/asm/dma-mapping.h
>  create mode 100644 include/asm-generic/dma-mapping.h
> 
> diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
> index 9420648..36a037d 100644
> --- a/arch/h8300/Kconfig
> +++ b/arch/h8300/Kconfig
> @@ -74,7 +74,7 @@ config NO_IOPORT
>  	def_bool y
>  
>  config NO_DMA
> -	def_bool y
> +	def_bool n
>  
>  config ISA
>  	bool
> diff --git a/arch/h8300/include/asm/dma-mapping.h b/arch/h8300/include/asm/dma-mapping.h
> new file mode 100644
> index 0000000..e7e1690
> --- /dev/null
> +++ b/arch/h8300/include/asm/dma-mapping.h
> @@ -0,0 +1 @@
> +#include <asm-generic/dma-mapping.h>
> diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
> index cabba33..57ad603 100644
> --- a/arch/m32r/Kconfig
> +++ b/arch/m32r/Kconfig
> @@ -35,7 +35,7 @@ config NO_IOPORT
>  	def_bool y
>  
>  config NO_DMA
> -	def_bool y
> +	def_bool n
>  
>  config HZ
>  	int
> diff --git a/arch/m32r/include/asm/dma-mapping.h b/arch/m32r/include/asm/dma-mapping.h
> new file mode 100644
> index 0000000..e7e1690
> --- /dev/null
> +++ b/arch/m32r/include/asm/dma-mapping.h
> @@ -0,0 +1 @@
> +#include <asm-generic/dma-mapping.h>
> diff --git a/include/asm-generic/dma-mapping.h b/include/asm-generic/dma-mapping.h
> new file mode 100644
> index 0000000..5a14fed
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
> +	return 0;
> +}
> +#endif

NACK'ed, sorry.

- these idndef tricks are really ugly and wrong.

- these functions are not generic at all.

- it's confusing to have two ways to handle this issue;
dma-mapping-broken.h and dma-mapping.h.
