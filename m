Return-Path: <linux-kernel-owner+w=401wt.eu-S1760483AbYD2SSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483AbYD2SSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYD2SSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:18:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbYD2SSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:18:07 -0400
Date: Tue, 29 Apr 2008 11:17:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, ajackson@redhat.com, airlied@redhat.com,
       benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/3] powerpc ioremap_prot
Message-Id: <20080429111734.b4bc93fc.akpm@linux-foundation.org>
In-Reply-To: <20080429113348.3f132ebc@cuia.boston.redhat.com>
References: <20080429113348.3f132ebc@cuia.boston.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 11:33:48 -0400
Rik van Riel <riel@redhat.com> wrote:

> This adds ioremap_prot and pte_pgprot() so that one can extract
> protection bits from a PTE and use them to ioremap_prot() (in
> order to support ptrace of VM_IO | VM_PFNMAP as per Rik's patch).
> 
> This moves a couple of flag checks around in the ioremap
> implementations of arch/powerpc. There's a side effect of allowing
> non-cacheable and non-guarded mappings on ppc32 which before would
> always have _PAGE_GUARDED set whenever _PAGE_NO_CACHE is.
> 
> (standard ioremap will still set _PAGE_GUARDED, but ioremap_prot
> will be capable of setting such a non guarded mapping).
>
> ...

This depends upon [patch 1/3].  I assume that [3/3] does as well.  With a
suitable ack from Paul I can merge all three in one hit when the time
comes, save some paperwork?

> --- linux-work.orig/include/asm-powerpc/io.h	2008-04-29 10:08:39.000000000 +1000
> +++ linux-work/include/asm-powerpc/io.h	2008-04-29 13:21:00.000000000 +1000
> @@ -585,7 +585,8 @@ static inline void iosync(void)
>   *   and can be hooked by the platform via ppc_md
>   *
>   * * ioremap_flags allows to specify the page flags as an argument and can
> - *   also be hooked by the platform via ppc_md
> + *   also be hooked by the platform via ppc_md. ioremap_prot is the exact
> + *   same thing as ioremap_flags.
>   *
>   * * ioremap_nocache is identical to ioremap
>   *
> @@ -607,6 +608,9 @@ extern void __iomem *ioremap(phys_addr_t
>  extern void __iomem *ioremap_flags(phys_addr_t address, unsigned long size,
>  				   unsigned long flags);
>  #define ioremap_nocache(addr, size)	ioremap((addr), (size))
> +#define ioremap_prot(addr, size, prot)	ioremap_flags((addr), (size), (prot))
> +#define _HAVE_ARCH_IOREMAP_PROT		1

Given that x86 implements ioremap_prot() as a regular C function, it would
be nicer to require that all architectures do that.  Especially as macros
suck.

Your powerpc implementation of ioremap_prot() has a different signature
from the x86 one: `phys_addr_t address' versus `resource_size_t phys_addr'.
Can that be improved?

>  extern void iounmap(volatile void __iomem *addr);
>  
>  extern void __iomem *__ioremap(phys_addr_t, unsigned long size,
> Index: linux-work/include/asm-powerpc/pgtable-ppc32.h
> ===================================================================
> --- linux-work.orig/include/asm-powerpc/pgtable-ppc32.h	2008-04-29 10:08:39.000000000 +1000
> +++ linux-work/include/asm-powerpc/pgtable-ppc32.h	2008-04-29 13:04:03.000000000 +1000
> @@ -381,6 +381,12 @@ extern int icache_44x_need_flush;
>  #ifndef _PAGE_EXEC
>  #define _PAGE_EXEC	0
>  #endif
> +#ifndef _PAGE_ENDIAN
> +#define _PAGE_ENDIAN	0
> +#endif
> +#ifndef _PAGE_COHERENT
> +#define _PAGE_COHERENT	0
> +#endif
>  #ifndef _PMD_PRESENT_MASK
>  #define _PMD_PRESENT_MASK	_PMD_PRESENT
>  #endif
> @@ -391,6 +397,12 @@ extern int icache_44x_need_flush;
>  
>  #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
>  
> +
> +#define PAGE_PROT_BITS	__pgprot(_PAGE_GUARDED | _PAGE_COHERENT | _PAGE_NO_CACHE | \
> +				 _PAGE_WRITETHRU | _PAGE_ENDIAN | \
> +				 _PAGE_USER | _PAGE_ACCESSED | \
> +				 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | \
> +				 _PAGE_EXEC | _PAGE_HWEXEC)
>  /*
>   * Note: the _PAGE_COHERENT bit automatically gets set in the hardware
>   * PTE if CONFIG_SMP is defined (hash_page does this); there is no need
> @@ -524,6 +536,8 @@ static inline pte_t pte_mkyoung(pte_t pt
>  	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
>  static inline pte_t pte_mkspecial(pte_t pte) {
>  	return pte; }
> +static inline unsigned long pte_pgprot(pte_t pte) {
> +	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }

ick.  \n's are cheap.

> +static inline unsigned long pte_pgprot(pte_t pte) {
> +	return __pgprot(pte_val(pte)) & PAGE_PROT_BITS; }

