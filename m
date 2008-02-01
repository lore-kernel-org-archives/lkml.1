Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYBAXQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYBAXQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbYBAXQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:16:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbYBAXQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:16:02 -0500
Date: Fri, 1 Feb 2008 15:15:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-Id: <20080201151541.8e3e0359.akpm@linux-foundation.org>
In-Reply-To: <20071112144009.831296895@de.ibm.com>
References: <20071112143009.425807965@de.ibm.com>
	<20071112144009.831296895@de.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007 15:30:11 +0100
schwidefsky@de.ibm.com wrote:

> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Background: I've implemented 1K/2K page tables for s390. These sub-page
> page tables are required to properly support the s390 virtualization
> instruction with KVM. The SIE instruction requires that the page tables
> have 256 page table entries (pte) followed by 256 page status table
> entries (pgste). The pgstes are only required if the process is using
> the SIE instruction. The pgstes are updated by the hardware and by the
> hypervisor for a number of reasons, one of them is dirty and reference
> bit tracking. To avoid wasting memory the standard pte table allocation
> should return 1K/2K (31/64 bit) and 2K/4K if the process is using SIE.
> 
> Problem: Page size on s390 is 4K, page table size is 1K or 2K. That
> means the s390 version for pte_alloc_one cannot return a pointer to
> a struct page. Trouble is that with the CONFIG_HIGHPTE feature on x86
> pte_alloc_one cannot return a pointer to a pte either, since that would
> require more than 32 bit for the return value of pte_alloc_one (and the
> pte * would not be accessible since its not kmapped).
> 
> Solution: The only solution I found to this dilemma is a new typedef:
> a pgtable_t. For s390 pgtable_t will be a (pte *) - to be introduced
> with a later patch. For everybody else it will be a (struct page *).
> The additional problem with the initialization of the ptl lock and the
> NR_PAGETABLE accounting is solved with a constructor pgtable_page_ctor
> and a destructor pgtable_page_dtor. The page table allocation and free
> functions need to call these two whenever a page table page is allocated
> or freed. pmd_populate will get a pgtable_t instead of a struct page
> pointer. To get the pgtable_t back from a pmd entry that has been
> installed with pmd_populate a new function pmd_pgtable is added. It
> replaces the pmd_page call in free_pte_range and apply_to_pte_range.

Sorry, I'm going to drop this.  And I guess the whole series.

On my 7000th fix-it-for-git-x86-changes I ended up with this:

static inline struct page *pmd_pgtable(pmd_t *pmd)
{
	return pmd_page(pmd);
}

expanding to this:

static inline __attribute__((always_inline)) struct page *pmd_pgtable(pmd_t *pmd)
{
	return ((mem_map + ((((native_pgd_val(((pmd).pud).pgd))) >> 12) - (0UL))));
}

and producing this:

In file included from include/asm/pgalloc.h:2,
                 from include/asm/mmu_context_32.h:6,
                 from include/asm/mmu_context.h:2,
                 from arch/x86/kernel/ldt.c:20:
include/asm/pgalloc_32.h: In function 'pmd_pgtable':
include/asm/pgalloc_32.h:37: error: request for member 'pud' in something not a structure or union

it was a revolting experience picking through the mess we've made, trying
to work out when we're using ptes/pmds/puds/pgds versus when we're using
*pointers* to those things.  The obsessional use type-free macros, the
liberal avoidance of comments and the general spaghettiness of it all makes
this far harder than it should be.

The reason why I chose to drop the patch rather than keep poking away at it
was:

> +#define pmd_pgtable(pmd) pmd_page(pmd)
> +#define pmd_pgtable(pmd) pmd_page(pmd)
> +#define __pte_free_tlb(tlb,pte)				\
> +do {							\
> +	pgtable_page_dtor(pte);				\
> +	tlb_remove_page((tlb), pte);			\
> +} while (0)
> +#define __pte_free_tlb(tlb,pte)				\
> +do {							\
> +	pgtable_page_dtor(pte);				\
> +	tlb_remove_page((tlb),(pte));			\
> +} while (0)
> +#define pmd_pgtable(pmd) pmd_page(pmd)
> +#define pmd_pgtable(pmd) pmd_page(pmd)
> +#define __pte_free_tlb(tlb,pte)				\
> +do {							\
> +	pgtable_page_dtor(pte);				\
> +	tlb_remove_page((tlb), pte);			\
> +} while (0)
>
> etcetera

This is just making a bad situation worse.  Please only use macros as a
last resort.  Please prefer to code in typesafe, self-documenting C.  

