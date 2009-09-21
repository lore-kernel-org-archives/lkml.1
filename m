Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbZIUSCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbZIUSCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZIUSCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:02:30 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:39480 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbZIUSC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:02:29 -0400
X-Trace: 260713487/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.55.31/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.55.31
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAHZct0pPRTcf/2dsb2JhbACBU9B+hBsF
X-IronPort-AV: E=Sophos;i="4.44,425,1249254000"; 
   d="scan'208";a="260713487"
Date: Mon, 21 Sep 2009 19:02:29 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: a patch drop request in -mm
In-Reply-To: <20090921173338.GA2578@cmpxchg.org>
Message-ID: <Pine.LNX.4.64.0909211857140.25639@sister.anvils>
References: <2f11576a0909210800l639560e4jad6cfc2e7f74538f@mail.gmail.com>
 <2f11576a0909210808r7912478cyd7edf3550fe5ce6@mail.gmail.com>
 <20090921173338.GA2578@cmpxchg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Johannes Weiner wrote:
> 
> This calls unmap_mapping_range() before actually munlocking the page.
> 
> Other unmappers like do_munmap() and exit_mmap() munlock explicitely
> before unmapping.
> 
> We could do the same here but I would argue that mlock lifetime
> depends on actual userspace mappings and then move the munlocking a
> few levels down into the unmapping guts to make this implicit.
> 
> Because truncation makes sure pages get unmapped, this is handled too.
> 
> Below is roughly outlined and untested demonstration patch.  What do
> you think?

That certainly looks appealing, but is it actually correct?

I'm thinking that munlock_vma_pages_range() clears VM_LOCKED
from vm_flags, which would be incorrect in the truncation case;
and that the VM_NONLINEAR truncation case only zaps certain
pages in the larger range that it is applied to.

Hugh

> diff --git a/mm/internal.h b/mm/internal.h
> index f290c4d..0d3c6c6 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -67,10 +67,6 @@ extern long mlock_vma_pages_range(struct vm_area_struct *vma,
>  			unsigned long start, unsigned long end);
>  extern void munlock_vma_pages_range(struct vm_area_struct *vma,
>  			unsigned long start, unsigned long end);
> -static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
> -{
> -	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
> -}
>  #endif
>  
>  /*
> diff --git a/mm/memory.c b/mm/memory.c
> index aede2ce..f8c5ac6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -971,7 +971,7 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
>  
>  	mmu_notifier_invalidate_range_start(mm, start_addr, end_addr);
>  	for ( ; vma && vma->vm_start < end_addr; vma = vma->vm_next) {
> -		unsigned long end;
> +		unsigned long end, nr_pages;
>  
>  		start = max(vma->vm_start, start_addr);
>  		if (start >= vma->vm_end)
> @@ -980,8 +980,15 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
>  		if (end <= vma->vm_start)
>  			continue;
>  
> +		nr_pages = (end - start) >> PAGE_SHIFT;
> +
> +		if (vma->vm_flags & VM_LOCKED) {
> +			mm->locked_vm -= nr_pages;
> +			munlock_vma_pages_range(vma, start, end);
> +		}
> +
>  		if (vma->vm_flags & VM_ACCOUNT)
> -			*nr_accounted += (end - start) >> PAGE_SHIFT;
> +			*nr_accounted += nr_pages;
>  
>  		if (unlikely(is_pfn_mapping(vma)))
>  			untrack_pfn_vma(vma, 0, 0);
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8101de4..02189f3 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1921,20 +1921,6 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
>  	vma = prev? prev->vm_next: mm->mmap;
>  
>  	/*
> -	 * unlock any mlock()ed ranges before detaching vmas
> -	 */
> -	if (mm->locked_vm) {
> -		struct vm_area_struct *tmp = vma;
> -		while (tmp && tmp->vm_start < end) {
> -			if (tmp->vm_flags & VM_LOCKED) {
> -				mm->locked_vm -= vma_pages(tmp);
> -				munlock_vma_pages_all(tmp);
> -			}
> -			tmp = tmp->vm_next;
> -		}
> -	}
> -
> -	/*
>  	 * Remove the vma's, and unmap the actual pages
>  	 */
>  	detach_vmas_to_be_unmapped(mm, vma, prev, end);
> @@ -2089,15 +2075,6 @@ void exit_mmap(struct mm_struct *mm)
>  	/* mm's last user has gone, and its about to be pulled down */
>  	mmu_notifier_release(mm);
>  
> -	if (mm->locked_vm) {
> -		vma = mm->mmap;
> -		while (vma) {
> -			if (vma->vm_flags & VM_LOCKED)
> -				munlock_vma_pages_all(vma);
> -			vma = vma->vm_next;
> -		}
> -	}
> -
>  	arch_exit_mmap(mm);
>  
>  	vma = mm->mmap;
> diff --git a/mm/truncate.c b/mm/truncate.c
> index ccc3ecf..a4e3b8f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -104,7 +104,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
>  
>  	cancel_dirty_page(page, PAGE_CACHE_SIZE);
>  
> -	clear_page_mlock(page);
>  	remove_from_page_cache(page);
>  	ClearPageMappedToDisk(page);
>  	page_cache_release(page);	/* pagecache ref */
> @@ -129,7 +128,6 @@ invalidate_complete_page(struct address_space *mapping, struct page *page)
>  	if (page_has_private(page) && !try_to_release_page(page, 0))
>  		return 0;
>  
> -	clear_page_mlock(page);
>  	ret = remove_mapping(mapping, page);
>  
>  	return ret;
> @@ -348,7 +346,6 @@ invalidate_complete_page2(struct address_space *mapping, struct page *page)
>  	if (PageDirty(page))
>  		goto failed;
>  
> -	clear_page_mlock(page);
>  	BUG_ON(page_has_private(page));
>  	__remove_from_page_cache(page);
>  	spin_unlock_irq(&mapping->tree_lock);
> 
