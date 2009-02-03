Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZBCBaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZBCBaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZBCBag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:30:36 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49037 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbZBCBad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:30:33 -0500
Date: Tue, 3 Feb 2009 10:29:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Greg KH <greg@kroah.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Message-Id: <20090203102920.684e7b67.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090202220856.GY20323@random.random>
References: <20090128213322.GA15789@kroah.com>
	<20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090130061714.GC31209@kroah.com>
	<20090202220856.GY20323@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009 23:08:56 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Hi Greg!
> 
> > Thanks for the pointers, I'll go read the thread and follow up there.
> 
> If you also run into this final fix is attached below. Porting to
> mainline is a bit hard because of gup-fast... Perhaps we can use mmu
> notifiers to fix gup-fast... need to think more about it then I'll
> post something.
> 
> Please help testing the below on pre-gup-fast kernels, thanks!
> 
I commented in FJ-Redhat Path but not forwared from unknown reason ;)
I comment again.

1. Why TestSetLockPage() is necessary ?
   It seems not necesary.

2. This patch doesn't cover HugeTLB.

3. Why "follow_page() successfully finds a page" case only ?
 not necessary to insert SetPageGUP() in following path ?

 - handle_mm_fault()
           => do_anonymos/swap/wp_page()
           or some.

BTW, when you write a patch against upstream, please CC me or linux-mm.
I'll have to add a hook for memory-cgroup.

Thanks,
-Kame


> From: Andrea Arcangeli <aarcange@redhat.com>
> Subject: fork-o_direct-race
> 
> Think a thread writing constantly to the last 512bytes of a page, while another
> thread read and writes to/from the first 512bytes of the page. We can lose
> O_DIRECT reads (or any other get_user_pages write=1 I/O not just bio/O_DIRECT),
> the very moment we mark any pte wrprotected because a third unrelated thread
> forks off a child.
> 
> This fixes it by never wprotecting anon ptes if there can be any direct I/O in
> flight to the page, and by instantiating a readonly pte and triggering a COW in
> the child. The only trouble here are O_DIRECT reads (writes to memory, read
> from disk). Checking the page_count under the PT lock guarantees no
> get_user_pages could be running under us because if somebody wants to write to
> the page, it has to break any cow first and that requires taking the PT lock in
> follow_page before increasing the page count. We are guaranteed mapcount is 1 if
> fork is writeprotecting the pte so the PT lock is enough to serialize against
> get_user_pages->get_page.
> 
> The COW triggered inside fork will run while the parent pte is readonly to
> provide as usual the per-page atomic copy from parent to child during fork.
> However timings will be altered by having to copy the pages that might be under
> O_DIRECT.
> 
> The pagevec code calls get_page while the page is sitting in the pagevec
> (before it becomes PageLRU) and doing so it can generate false positives, so to
> avoid slowing down fork all the time even for pages that could never possibly
> be under O_DIRECT write=1, the PG_gup bitflag is added, this eliminates
> most overhead of the fix in fork.
> 
> Patch doesn't break kABI despite introducing a new page flag.
> 
> Fixed version of original patch from Nick Piggin.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff -ur 2/include/linux/page-flags.h 1/include/linux/page-flags.h
> --- 2/include/linux/page-flags.h	2008-07-10 17:26:44.000000000 +0200
> +++ 1/include/linux/page-flags.h	2009-02-02 05:33:42.000000000 +0100
> @@ -86,6 +86,7 @@
>  #define PG_reclaim		17	/* To be reclaimed asap */
>  #define PG_nosave_free		18	/* Free, should not be written */
>  #define PG_buddy		19	/* Page is free, on buddy lists */
> +#define PG_gup			20	/* Page pin may be because of gup */
>  
>  /* PG_owner_priv_1 users should have descriptive aliases */
>  #define PG_checked              PG_owner_priv_1 /* Used by some filesystems */
> @@ -238,6 +239,10 @@
>  #define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
>  #define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
>  
> +#define SetPageGUP(page)	set_bit(PG_gup, &(page)->flags)
> +#define PageGUP(page)		test_bit(PG_gup, &(page)->flags)
> +#define __ClearPageGUP(page)	__clear_bit(PG_gup, &(page)->flags)
> +
>  /*
>   * PG_reclaim is used in combination with PG_compound to mark the
>   * head and tail of a compound page
> diff -ur 2/kernel/fork.c 1/kernel/fork.c
> --- 2/kernel/fork.c	2008-07-10 17:26:43.000000000 +0200
> +++ 1/kernel/fork.c	2009-02-02 05:24:17.000000000 +0100
> @@ -368,7 +368,7 @@
>  		rb_parent = &tmp->vm_rb;
>  
>  		mm->map_count++;
> -		retval = copy_page_range(mm, oldmm, mpnt);
> +		retval = copy_page_range(mm, oldmm, tmp);
>  
>  		if (tmp->vm_ops && tmp->vm_ops->open)
>  			tmp->vm_ops->open(tmp);
> Only in 1: ldtest7557.out
> diff -ur 2/mm/memory.c 1/mm/memory.c
> --- 2/mm/memory.c	2008-07-10 17:26:44.000000000 +0200
> +++ 1/mm/memory.c	2009-02-02 06:17:05.000000000 +0100
> @@ -426,7 +426,7 @@
>   * covered by this vma.
>   */
>  
> -static inline void
> +static inline int
>  copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pte_t *dst_pte, pte_t *src_pte, struct vm_area_struct *vma,
>  		unsigned long addr, int *rss)
> @@ -434,6 +434,7 @@
>  	unsigned long vm_flags = vma->vm_flags;
>  	pte_t pte = *src_pte;
>  	struct page *page;
> +	int forcecow = 0;
>  
>  	/* pte contains position in swap or file, so copy. */
>  	if (unlikely(!pte_present(pte))) {
> @@ -464,15 +465,6 @@
>  	}
>  
>  	/*
> -	 * If it's a COW mapping, write protect it both
> -	 * in the parent and the child
> -	 */
> -	if (is_cow_mapping(vm_flags)) {
> -		ptep_set_wrprotect(src_mm, addr, src_pte);
> -		pte = *src_pte;
> -	}
> -
> -	/*
>  	 * If it's a shared mapping, mark it clean in
>  	 * the child
>  	 */
> @@ -484,13 +476,41 @@
>  	if (page) {
>  		get_page(page);
>  		page_dup_rmap(page);
> +		if (is_cow_mapping(vm_flags) && PageAnon(page) &&
> +		    PageGUP(page)) {
> +			if (unlikely(TestSetPageLocked(page)))
> +				forcecow = 1;
> +			else {
> +				if (unlikely(page_count(page) !=
> +					     page_mapcount(page)
> +					     + !!PageSwapCache(page)))
> +					forcecow = 1;
> +				unlock_page(page);
> +			}
> +		}
>  		rss[!!PageAnon(page)]++;
>  	}
>  
> +	/*
> +	 * If it's a COW mapping, write protect it both
> +	 * in the parent and the child.
> +	 */
> +	if (is_cow_mapping(vm_flags)) {
> +		ptep_set_wrprotect(src_mm, addr, src_pte);
> +		pte = pte_wrprotect(pte);
> +	}
> +
>  out_set_pte:
>  	set_pte_at(dst_mm, addr, dst_pte, pte);
> +
> +	return forcecow;
>  }
>  
> +static void fork_pre_cow(struct mm_struct *mm, struct vm_area_struct *vma,
> +			 unsigned long address,
> +			 pte_t *src_pte, pte_t *dst_pte,
> +			 struct page *pre_cow_page);
> +
>  static int copy_pte_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pmd_t *dst_pmd, pmd_t *src_pmd, struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long end)
> @@ -499,17 +519,30 @@
>  	spinlock_t *src_ptl, *dst_ptl;
>  	int progress = 0;
>  	int rss[2];
> +	int forcecow;
> +	struct page *pre_cow_page = NULL;
>  
>  again:
> +	if (!pre_cow_page) {
> +		pre_cow_page = alloc_page_vma(GFP_HIGHUSER, vma, addr);
> +		if (!pre_cow_page)
> +			return -ENOMEM;
> +	}
> +	forcecow = 0;
>  	rss[1] = rss[0] = 0;
>  	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
> -	if (!dst_pte)
> +	if (!dst_pte) {
> +		page_cache_release(pre_cow_page);
>  		return -ENOMEM;
> +	}
>  	src_pte = pte_offset_map_nested(src_pmd, addr);
>  	src_ptl = pte_lockptr(src_mm, src_pmd);
>  	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>  
>  	do {
> +		if (forcecow)
> +			break;
> +
>  		/*
>  		 * We are holding two locks at this point - either of them
>  		 * could generate latencies in another task on another CPU.
> @@ -525,10 +558,26 @@
>  			progress++;
>  			continue;
>  		}
> -		copy_one_pte(dst_mm, src_mm, dst_pte, src_pte, vma, addr, rss);
> +		forcecow = copy_one_pte(dst_mm, src_mm, dst_pte, src_pte, vma, addr, rss);
>  		progress += 8;
>  	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr != end);
>  
> +	if (unlikely(forcecow)) {
> +		/*
> +		 * Try to COW the child page as direct I/O is working
> +		 * on the parent page, and so we've to mark the parent
> +		 * pte read-write before dropping the PT lock to avoid
> +		 * the page to be cowed in the parent and any direct
> +		 * I/O to get lost.
> +		 */
> +		fork_pre_cow(dst_mm, vma, addr-PAGE_SIZE,
> +			     src_pte-1, dst_pte-1, pre_cow_page);
> +		/* after the page copy set the parent pte writeable */
> +		set_pte_at(src_mm, addr-PAGE_SIZE, src_pte-1,
> +			   pte_mkwrite(*(src_pte-1)));
> +		pre_cow_page = NULL;
> +	}
> +
>  	spin_unlock(src_ptl);
>  	pte_unmap_nested(src_pte - 1);
>  	add_mm_rss(dst_mm, rss[0], rss[1]);
> @@ -536,6 +585,8 @@
>  	cond_resched();
>  	if (addr != end)
>  		goto again;
> +	if (pre_cow_page)
> +		page_cache_release(pre_cow_page);
>  	return 0;
>  }
>  
> @@ -956,8 +1007,11 @@
>  	if (unlikely(!page))
>  		goto unlock;
>  
> -	if (flags & FOLL_GET)
> +	if (flags & FOLL_GET) {
>  		get_page(page);
> +		if ((flags & FOLL_WRITE) && PageAnon(page) && !PageGUP(page))
> +			SetPageGUP(page);
> +	}
>  	if (flags & FOLL_TOUCH) {
>  		if ((flags & FOLL_WRITE) &&
>  		    !pte_dirty(pte) && !PageDirty(page))
> @@ -1607,6 +1661,30 @@
>  	copy_user_highpage(dst, src, va);
>  }
>  
> +static void fork_pre_cow(struct mm_struct *mm, struct vm_area_struct *vma,
> +			 unsigned long address,
> +			 pte_t *src_pte, pte_t *dst_pte,
> +			 struct page *pre_cow_page)
> +{
> +	pte_t entry;
> +	struct page *old_page;
> +
> +	old_page = vm_normal_page(vma, address, *src_pte);
> +	BUG_ON(!old_page);
> +	cow_user_page(pre_cow_page, old_page, address);
> +	page_remove_rmap(old_page);
> +	page_cache_release(old_page);
> +
> +	flush_cache_page(vma, address, pte_pfn(*src_pte));
> +	entry = mk_pte(pre_cow_page, vma->vm_page_prot);
> +	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> +	page_add_new_anon_rmap(pre_cow_page, vma, address);
> +	lru_cache_add_active(pre_cow_page);
> +	set_pte_at(mm, address, dst_pte, entry);
> +	update_mmu_cache(vma, address, entry);
> +	lazy_mmu_prot_update(entry);
> +}
> +
>  /*
>   * This routine handles present pages, when users try to write
>   * to a shared page. It is done by copying the page to a new address
> diff -ur 2/mm/page_alloc.c 1/mm/page_alloc.c
> --- 2/mm/page_alloc.c	2008-07-10 17:26:44.000000000 +0200
> +++ 1/mm/page_alloc.c	2009-02-02 05:33:18.000000000 +0100
> @@ -154,6 +154,7 @@
>  			1 << PG_slab    |
>  			1 << PG_swapcache |
>  			1 << PG_writeback |
> +			1 << PG_gup |
>  			1 << PG_buddy );
>  	set_page_count(page, 0);
>  	reset_page_mapcount(page);
> @@ -400,6 +401,8 @@
>  		bad_page(page);
>  	if (PageDirty(page))
>  		__ClearPageDirty(page);
> +	if (PageGUP(page))
> +		__ClearPageGUP(page);
>  	/*
>  	 * For now, we report if PG_reserved was found set, but do not
>  	 * clear it, and do not free the page.  But we shall soon need
> @@ -546,6 +549,7 @@
>  			1 << PG_swapcache |
>  			1 << PG_writeback |
>  			1 << PG_reserved |
> +			1 << PG_gup |
>  			1 << PG_buddy ))))
>  		bad_page(page);
>  
> 

