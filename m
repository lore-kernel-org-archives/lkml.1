Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYFFEFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYFFEFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYFFEFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:05:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:47359 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbYFFEFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:05:42 -0400
Subject: Re: [patch 6/7] powerpc: implement pte_special
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: npiggin@suse.de
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20080605094826.023234000@nick.local0.net>
References: <20080605094300.295184000@nick.local0.net>
	 <20080605094826.023234000@nick.local0.net>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 14:04:53 +1000
Message-Id: <1212725093.12464.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 19:43 +1000, npiggin@suse.de wrote:
> plain text document attachment (powerpc-implement-pte_special.patch)
> Implement PTE_SPECIAL for powerpc. At the moment I only have a spare bit for
> the 4k pages config, but Ben has freed up another one for 64k pages that I
> can use, so this patch should include that before it goes upstream.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>

Ack that bit. _PAGE_SPECIAL will replace _PAGE_HASHPTE on 64K (ie.
0x400). The patch that frees that bit should get into powerpc.git (and
from there -mm) as soon as paulus catches up with his backlog :-)

Cheers,
Ben.

> ---
> Index: linux-2.6/include/asm-powerpc/pgtable-ppc64.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/pgtable-ppc64.h
> +++ linux-2.6/include/asm-powerpc/pgtable-ppc64.h
> @@ -239,7 +239,7 @@ static inline int pte_write(pte_t pte) {
>  static inline int pte_dirty(pte_t pte) { return pte_val(pte) & _PAGE_DIRTY;}
>  static inline int pte_young(pte_t pte) { return pte_val(pte) & _PAGE_ACCESSED;}
>  static inline int pte_file(pte_t pte) { return pte_val(pte) & _PAGE_FILE;}
> -static inline int pte_special(pte_t pte) { return 0; }
> +static inline int pte_special(pte_t pte) { return pte_val(pte) & _PAGE_SPECIAL; }
>  
>  static inline void pte_uncache(pte_t pte) { pte_val(pte) |= _PAGE_NO_CACHE; }
>  static inline void pte_cache(pte_t pte)   { pte_val(pte) &= ~_PAGE_NO_CACHE; }
> @@ -259,7 +259,7 @@ static inline pte_t pte_mkyoung(pte_t pt
>  static inline pte_t pte_mkhuge(pte_t pte) {
>  	return pte; }
>  static inline pte_t pte_mkspecial(pte_t pte) {
> -	return pte; }
> +	pte_val(pte) |= _PAGE_SPECIAL; return pte; }
>  
>  /* Atomic PTE updates */
>  static inline unsigned long pte_update(struct mm_struct *mm,
> Index: linux-2.6/include/asm-powerpc/pgtable-4k.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/pgtable-4k.h
> +++ linux-2.6/include/asm-powerpc/pgtable-4k.h
> @@ -45,6 +45,8 @@
>  #define _PAGE_GROUP_IX  0x7000 /* software: HPTE index within group */
>  #define _PAGE_F_SECOND  _PAGE_SECONDARY
>  #define _PAGE_F_GIX     _PAGE_GROUP_IX
> +#define _PAGE_SPECIAL	0x10000 /* software: special page */
> +#define __HAVE_ARCH_PTE_SPECIAL
>  
>  /* PTE flags to conserve for HPTE identification */
>  #define _PAGE_HPTEFLAGS (_PAGE_BUSY | _PAGE_HASHPTE | \
> Index: linux-2.6/include/asm-powerpc/pgtable-64k.h
> ===================================================================
> --- linux-2.6.orig/include/asm-powerpc/pgtable-64k.h
> +++ linux-2.6/include/asm-powerpc/pgtable-64k.h
> @@ -74,6 +74,7 @@ static inline struct subpage_prot_table 
>  #define _PAGE_HPTE_SUB0	0x08000000 /* combo only: first sub page */
>  #define _PAGE_COMBO	0x10000000 /* this is a combo 4k page */
>  #define _PAGE_4K_PFN	0x20000000 /* PFN is for a single 4k page */
> +#define _PAGE_SPECIAL	0x0	   /* don't have enough room for this yet */
>  
>  /* Note the full page bits must be in the same location as for normal
>   * 4k pages as the same asssembly will be used to insert 64K pages
> 

