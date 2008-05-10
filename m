Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYEJCW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYEJCW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYEJCWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:22:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42372 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYEJCWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:22:50 -0400
Date: Sat, 10 May 2008 04:23:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [patch 6/6] x86: Add checks for virtual addresses in __phys_addr()
Message-ID: <20080510022325.GA25712@uranus.ravnborg.org>
References: <20080510020947.803480649@sgi.com> <20080510021021.472932504@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510021021.472932504@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 07:09:53PM -0700, Christoph Lameter wrote:
> Add checks to insure that virtual addresses are not used in invalid contexts.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  arch/x86/mm/ioremap.c     |   15 +++++++--------
>  include/asm-x86/page_32.h |    7 ++++++-
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/arch/x86/mm/ioremap.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/ioremap.c	2008-05-07 16:27:09.792659191 -0700
> +++ linux-2.6/arch/x86/mm/ioremap.c	2008-05-07 19:46:34.733509101 -0700
> @@ -21,29 +21,28 @@
>  #include <asm/pgalloc.h>
>  #include <asm/pat.h>
>  
> -#ifdef CONFIG_X86_64
>  
> +#if defined(CONFIG_DEBUG_VM) || defined(CONFIG_X86_64)
>  unsigned long __phys_addr(unsigned long x)
>  {
> +	VM_BUG_ON(is_vmalloc_addr((void *)x));
> +#ifdef CONFIG_X86_64
>  	if (x >= __START_KERNEL_map)
>  		return x - __START_KERNEL_map + phys_base;
> +#endif
>  	return x - PAGE_OFFSET;
>  }
>  EXPORT_SYMBOL(__phys_addr);
> +#endif
>  
>  static inline int phys_addr_valid(unsigned long addr)
>  {
> +#ifdef CONFIG_X86_64
>  	return addr < (1UL << boot_cpu_data.x86_phys_bits);
> -}
> -
>  #else
> -
> -static inline int phys_addr_valid(unsigned long addr)
> -{
>  	return 1;
> -}
> -
>  #endif
> +}
>  
>  int page_is_ram(unsigned long pagenr)
>  {
> Index: linux-2.6/include/asm-x86/page_32.h
> ===================================================================
> --- linux-2.6.orig/include/asm-x86/page_32.h	2008-05-07 16:27:12.191419001 -0700
> +++ linux-2.6/include/asm-x86/page_32.h	2008-05-07 19:30:46.444980299 -0700
> @@ -64,7 +64,12 @@ typedef struct page *pgtable_t;
>  #endif
>  
>  #ifndef __ASSEMBLY__
> -#define __phys_addr(x)		((x) - PAGE_OFFSET)
> +#ifdef CONFIG_DEBUG_VM
> +unsigned long __phys_addr(unsigned long x)

Should this have read:
> +extern unsigned long __phys_addr(unsigned long x);
?

Looks like a prototype with a missing ';'.
And x86 uses extern for prototypes in .h files (most of the time).

	Sam
