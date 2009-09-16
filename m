Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZIPGWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZIPGWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZIPGWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:22:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57549 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZIPGW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:22:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Sep 2009 15:20:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 3/4] mm: ZERO_PAGE without PTE_SPECIAL
Message-Id: <20090916152021.f76a3721.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909152133060.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
	<Pine.LNX.4.64.0909152127240.22199@sister.anvils>
	<Pine.LNX.4.64.0909152133060.22199@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 21:37:20 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> Reinstate anonymous use of ZERO_PAGE to all architectures, not just
> to those which __HAVE_ARCH_PTE_SPECIAL: as suggested by Nick Piggin.
> 
> Contrary to how I'd imagined it, there's nothing ugly about this, just
> a zero_pfn test built into one or another block of vm_normal_page().
> 
> But the MIPS ZERO_PAGE-of-many-colours case demands is_zero_pfn() and
> my_zero_pfn() inlines.  Reinstate its mremap move_pte() shuffling of
> ZERO_PAGEs we did from 2.6.17 to 2.6.19?  Not unless someone shouts
> for that: it would have to take vm_flags to weed out some cases.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Thank you. I like this way.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
> I've not built and tested the actual MIPS case, just hacked up x86
> definitions to simulate it; had to drop the static from zero_pfn.
> 
>  arch/mips/include/asm/pgtable.h |   14 +++++++++++
>  mm/memory.c                     |   36 ++++++++++++++++++++----------
>  2 files changed, 39 insertions(+), 11 deletions(-)
> 
> --- mm2/arch/mips/include/asm/pgtable.h	2009-09-09 23:13:59.000000000 +0100
> +++ mm3/arch/mips/include/asm/pgtable.h	2009-09-15 17:32:19.000000000 +0100
> @@ -76,6 +76,20 @@ extern unsigned long zero_page_mask;
>  #define ZERO_PAGE(vaddr) \
>  	(virt_to_page((void *)(empty_zero_page + (((unsigned long)(vaddr)) & zero_page_mask))))
>  
> +#define is_zero_pfn is_zero_pfn
> +static inline int is_zero_pfn(unsigned long pfn)
> +{
> +	extern unsigned long zero_pfn;
> +	unsigned long offset_from_zero_pfn = pfn - zero_pfn;
> +	return offset_from_zero_pfn <= (zero_page_mask >> PAGE_SHIFT);
> +}
> +
> +#define my_zero_pfn my_zero_pfn
> +static inline unsigned long my_zero_pfn(unsigned long addr)
> +{
> +	return page_to_pfn(ZERO_PAGE(addr));
> +}
> +
>  extern void paging_init(void);
>  
>  /*
> --- mm2/mm/memory.c	2009-09-14 16:34:37.000000000 +0100
> +++ mm3/mm/memory.c	2009-09-15 17:32:19.000000000 +0100
> @@ -107,7 +107,7 @@ static int __init disable_randmaps(char
>  }
>  __setup("norandmaps", disable_randmaps);
>  
> -static unsigned long zero_pfn __read_mostly;
> +unsigned long zero_pfn __read_mostly;
>  
>  /*
>   * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
> @@ -455,6 +455,20 @@ static inline int is_cow_mapping(unsigne
>  	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
>  }
>  
> +#ifndef is_zero_pfn
> +static inline int is_zero_pfn(unsigned long pfn)
> +{
> +	return pfn == zero_pfn;
> +}
> +#endif
> +
> +#ifndef my_zero_pfn
> +static inline unsigned long my_zero_pfn(unsigned long addr)
> +{
> +	return zero_pfn;
> +}
> +#endif
> +
>  /*
>   * vm_normal_page -- This function gets the "struct page" associated with a pte.
>   *
> @@ -512,7 +526,7 @@ struct page *vm_normal_page(struct vm_ar
>  			goto check_pfn;
>  		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
>  			return NULL;
> -		if (pfn != zero_pfn)
> +		if (!is_zero_pfn(pfn))
>  			print_bad_pte(vma, addr, pte, NULL);
>  		return NULL;
>  	}
> @@ -534,6 +548,8 @@ struct page *vm_normal_page(struct vm_ar
>  		}
>  	}
>  
> +	if (is_zero_pfn(pfn))
> +		return NULL;
>  check_pfn:
>  	if (unlikely(pfn > highest_memmap_pfn)) {
>  		print_bad_pte(vma, addr, pte, NULL);
> @@ -1161,7 +1177,7 @@ struct page *follow_page(struct vm_area_
>  	page = vm_normal_page(vma, address, pte);
>  	if (unlikely(!page)) {
>  		if ((flags & FOLL_DUMP) ||
> -		    pte_pfn(pte) != zero_pfn)
> +		    !is_zero_pfn(pte_pfn(pte)))
>  			goto bad_page;
>  		page = pte_page(pte);
>  	}
> @@ -1444,10 +1460,6 @@ struct page *get_dump_page(unsigned long
>  	if (__get_user_pages(current, current->mm, addr, 1,
>  			FOLL_FORCE | FOLL_DUMP | FOLL_GET, &page, &vma) < 1)
>  		return NULL;
> -	if (page == ZERO_PAGE(0)) {
> -		page_cache_release(page);
> -		return NULL;
> -	}
>  	flush_cache_page(vma, addr, page_to_pfn(page));
>  	return page;
>  }
> @@ -1630,7 +1642,8 @@ int vm_insert_mixed(struct vm_area_struc
>  	 * If we don't have pte special, then we have to use the pfn_valid()
>  	 * based VM_MIXEDMAP scheme (see vm_normal_page), and thus we *must*
>  	 * refcount the page if pfn_valid is true (hence insert_page rather
> -	 * than insert_pfn).
> +	 * than insert_pfn).  If a zero_pfn were inserted into a VM_MIXEDMAP
> +	 * without pte special, it would there be refcounted as a normal page.
>  	 */
>  	if (!HAVE_PTE_SPECIAL && pfn_valid(pfn)) {
>  		struct page *page;
> @@ -2098,7 +2111,7 @@ gotten:
>  	if (unlikely(anon_vma_prepare(vma)))
>  		goto oom;
>  
> -	if (pte_pfn(orig_pte) == zero_pfn) {
> +	if (is_zero_pfn(pte_pfn(orig_pte))) {
>  		new_page = alloc_zeroed_user_highpage_movable(vma, address);
>  		if (!new_page)
>  			goto oom;
> @@ -2613,8 +2626,9 @@ static int do_anonymous_page(struct mm_s
>  	spinlock_t *ptl;
>  	pte_t entry;
>  
> -	if (HAVE_PTE_SPECIAL && !(flags & FAULT_FLAG_WRITE)) {
> -		entry = pte_mkspecial(pfn_pte(zero_pfn, vma->vm_page_prot));
> +	if (!(flags & FAULT_FLAG_WRITE)) {
> +		entry = pte_mkspecial(pfn_pte(my_zero_pfn(address),
> +						vma->vm_page_prot));
>  		ptl = pte_lockptr(mm, pmd);
>  		spin_lock(ptl);
>  		if (!pte_none(*page_table))
> 

