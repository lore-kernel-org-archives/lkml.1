Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZEBHKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZEBHKr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbZEBHKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:10:37 -0400
Received: from in.cluded.net ([195.159.98.120]:47246 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZEBHKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:10:36 -0400
Message-ID: <49FBF00F.5030700@uw.no>
Date: Sat, 02 May 2009 07:02:39 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 17/35] sparc: create ptemap.h
References: <20090501144201.D31EF417@kernel> <20090501144227.3FFE505C@kernel>
In-Reply-To: <20090501144227.3FFE505C@kernel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/arch/sparc/include/asm/pgtable_32.h |   15 --------
>  linux-2.6.git-dave/arch/sparc/include/asm/pgtable_64.h |    5 --
>  linux-2.6.git-dave/arch/sparc/include/asm/ptemap.h     |   29 +++++++++++++++++
>  3 files changed, 31 insertions(+), 18 deletions(-)
> 
> diff -puN arch/sparc/include/asm/pgtable_32.h~sparc-ptemaph arch/sparc/include/asm/pgtable_32.h
> --- linux-2.6.git/arch/sparc/include/asm/pgtable_32.h~sparc-ptemaph	2009-04-30 15:11:02.000000000 -0700
> +++ linux-2.6.git-dave/arch/sparc/include/asm/pgtable_32.h	2009-04-30 15:11:02.000000000 -0700
> @@ -300,20 +300,7 @@ BTFIXUPDEF_CALL(pmd_t *, pmd_offset, pgd
>  BTFIXUPDEF_CALL(pte_t *, pte_offset_kernel, pmd_t *, unsigned long)
>  #define pte_offset_kernel(dir,addr) BTFIXUP_CALL(pte_offset_kernel)(dir,addr)
>  
> -/*
> - * This shortcut works on sun4m (and sun4d) because the nocache area is static,
> - * and sun4c is guaranteed to have no highmem anyway.
> - */
> -#define pte_offset_map(d, a)		pte_offset_kernel(d,a)
> -#define pte_offset_map_nested(d, a)	pte_offset_kernel(d,a)
> -
> -#define pte_unmap(pte)		do{}while(0)
> -#define pte_unmap_nested(pte)	do{}while(0)
> -
> -/* Certain architectures need to do special things when pte's
> - * within a page table are directly modified.  Thus, the following
> - * hook is made available.
> - */

This is FUBAR'ed, The comment refers to the BTFIXUPDEF_CALL below, and should not
be moved to asm/ptemap.h 

> +#include <asm/ptemap.h>
>  
>  BTFIXUPDEF_CALL(void, set_pte, pte_t *, pte_t)
>  
> diff -puN arch/sparc/include/asm/pgtable_64.h~sparc-ptemaph arch/sparc/include/asm/pgtable_64.h
> --- linux-2.6.git/arch/sparc/include/asm/pgtable_64.h~sparc-ptemaph	2009-04-30 15:11:02.000000000 -0700
> +++ linux-2.6.git-dave/arch/sparc/include/asm/pgtable_64.h	2009-04-30 15:11:02.000000000 -0700
> @@ -652,10 +652,7 @@ static inline int pte_special(pte_t pte)
>  /* Find an entry in the third-level page table.. */
>  #define pte_offset_kernel(dir, address)	\
>  	((pte_t *)pmd_page_vaddr(*(dir)) + pte_index(address))
> -#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
> -#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
> -#define pte_unmap(pte)			do { } while (0)
> -#define pte_unmap_nested(pte)		do { } while (0)
> +#include <asm/ptemap.h>
>  
>  /* Actual page table PTE updates.  */
>  extern void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t orig);
> diff -puN /dev/null arch/sparc/include/asm/ptemap.h
> --- /dev/null	2008-09-02 09:40:19.000000000 -0700
> +++ linux-2.6.git-dave/arch/sparc/include/asm/ptemap.h	2009-04-30 15:11:02.000000000 -0700
> @@ -0,0 +1,29 @@
> +#ifndef _SPARC_ASM_PTEMAP_H
> +#define _SPARC_ASM_PTEMAP_H
> +
> +#if defined(__sparc__) && defined(__arch64__)
> +
> +/* Certain architectures need to do special things when pte's
> + * within a page table are directly modified.  Thus, the following
> + * hook is made available.
> + */
> +
> +#define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
> +#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
> +#define pte_unmap(pte)			do { } while (0)
> +#define pte_unmap_nested(pte)		do { } while (0)
> +
> +#else
> +
> + * This shortcut works on sun4m (and sun4d) because the nocache area is static,
> + * and sun4c is guaranteed to have no highmem anyway.
> + */

Broken comment.

> +#define pte_offset_map(d, a)		pte_offset_kernel(d,a)
> +#define pte_offset_map_nested(d, a)	pte_offset_kernel(d,a)
> +
> +#define pte_unmap(pte)		do{}while(0)
> +#define pte_unmap_nested(pte)	do{}while(0)
> +
> +#endif
> +
> +#endif /* _SPARC_ASM_PTEMAP_H *//*

Broken comment.

I realize this is going away in the end, but all the interim steps should
compile, to aid bisection.


Daniel K.
