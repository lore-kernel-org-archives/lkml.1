Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZK3AHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZK3AHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 19:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZK3AHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 19:07:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59947 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZK3AHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 19:07:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 30 Nov 2009 09:04:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/9] ksm: share anon page without allocating
Message-Id: <20091130090448.71cf6138.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0911241645460.25288@sister.anvils>
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
	<Pine.LNX.4.64.0911241645460.25288@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for delayed response.

On Tue, 24 Nov 2009 16:48:46 +0000 (GMT)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> When ksm pages were unswappable, it made no sense to include them in
> mem cgroup accounting; but now that they are swappable (although I see
> no strict logical connection)
I asked that for throwing away too complicated but wast of time things.
If not on LRU, its own limitation (ksm's page limit) works enough.

> the principle of least surprise implies
> that they should be accounted (with the usual dissatisfaction, that a
> shared page is accounted to only one of the cgroups using it).
> 
> This patch was intended to add mem cgroup accounting where necessary;
> but turned inside out, it now avoids allocating a ksm page, instead
> upgrading an anon page to ksm - which brings its existing mem cgroup
> accounting with it.  Thus mem cgroups don't appear in the patch at all.
> 
ok. then, what I should see is patch 6.

Thanks,
-Kame
> This upgrade from PageAnon to PageKsm takes place under page lock
> (via a somewhat hacky NULL kpage interface), and audit showed only
> one place which needed to cope with the race - page_referenced() is
> sometimes used without page lock, so page_lock_anon_vma() needs an
> ACCESS_ONCE() to be sure of getting anon_vma and flags together
> (no problem if the page goes ksm an instant after, the integrity
> of that anon_vma list is unaffected).
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  mm/ksm.c  |   67 ++++++++++++++++------------------------------------
>  mm/rmap.c |    6 +++-
>  2 files changed, 25 insertions(+), 48 deletions(-)
> 
> --- ksm4/mm/ksm.c	2009-11-22 20:40:18.000000000 +0000
> +++ ksm5/mm/ksm.c	2009-11-22 20:40:27.000000000 +0000
> @@ -831,7 +831,8 @@ out:
>   * try_to_merge_one_page - take two pages and merge them into one
>   * @vma: the vma that holds the pte pointing to page
>   * @page: the PageAnon page that we want to replace with kpage
> - * @kpage: the PageKsm page that we want to map instead of page
> + * @kpage: the PageKsm page that we want to map instead of page,
> + *         or NULL the first time when we want to use page as kpage.
>   *
>   * This function returns 0 if the pages were merged, -EFAULT otherwise.
>   */
> @@ -864,15 +865,24 @@ static int try_to_merge_one_page(struct
>  	 * ptes are necessarily already write-protected.  But in either
>  	 * case, we need to lock and check page_count is not raised.
>  	 */
> -	if (write_protect_page(vma, page, &orig_pte) == 0 &&
> -	    pages_identical(page, kpage))
> -		err = replace_page(vma, page, kpage, orig_pte);
> +	if (write_protect_page(vma, page, &orig_pte) == 0) {
> +		if (!kpage) {
> +			/*
> +			 * While we hold page lock, upgrade page from
> +			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
> +			 * stable_tree_insert() will update stable_node.
> +			 */
> +			set_page_stable_node(page, NULL);
> +			mark_page_accessed(page);
> +			err = 0;
> +		} else if (pages_identical(page, kpage))
> +			err = replace_page(vma, page, kpage, orig_pte);
> +	}
>  
> -	if ((vma->vm_flags & VM_LOCKED) && !err) {
> +	if ((vma->vm_flags & VM_LOCKED) && kpage && !err) {
>  		munlock_vma_page(page);
>  		if (!PageMlocked(kpage)) {
>  			unlock_page(page);
> -			lru_add_drain();

Is this related to memcg ?

>  			lock_page(kpage);
>  			mlock_vma_page(kpage);
>  			page = kpage;		/* for final unlock */
> @@ -922,7 +932,7 @@ out:
>   * This function returns the kpage if we successfully merged two identical
>   * pages into one ksm page, NULL otherwise.
>   *
> - * Note that this function allocates a new kernel page: if one of the pages
> + * Note that this function upgrades page to ksm page: if one of the pages
>   * is already a ksm page, try_to_merge_with_ksm_page should be used.
>   */
>  static struct page *try_to_merge_two_pages(struct rmap_item *rmap_item,
> @@ -930,10 +940,7 @@ static struct page *try_to_merge_two_pag
>  					   struct rmap_item *tree_rmap_item,
>  					   struct page *tree_page)
>  {
> -	struct mm_struct *mm = rmap_item->mm;
> -	struct vm_area_struct *vma;
> -	struct page *kpage;
> -	int err = -EFAULT;
> +	int err;
>  
>  	/*
>  	 * The number of nodes in the stable tree
> @@ -943,37 +950,10 @@ static struct page *try_to_merge_two_pag
>  	    ksm_max_kernel_pages <= ksm_pages_shared)
>  		return NULL;
>  
> -	kpage = alloc_page(GFP_HIGHUSER);
> -	if (!kpage)
> -		return NULL;
> -
> -	down_read(&mm->mmap_sem);
> -	if (ksm_test_exit(mm))
> -		goto up;
> -	vma = find_vma(mm, rmap_item->address);
> -	if (!vma || vma->vm_start > rmap_item->address)
> -		goto up;
> -
> -	copy_user_highpage(kpage, page, rmap_item->address, vma);
> -
> -	SetPageDirty(kpage);
> -	__SetPageUptodate(kpage);
> -	SetPageSwapBacked(kpage);
> -	set_page_stable_node(kpage, NULL);	/* mark it PageKsm */
> -	lru_cache_add_lru(kpage, LRU_ACTIVE_ANON);
> -
> -	err = try_to_merge_one_page(vma, page, kpage);
> -	if (err)
> -		goto up;
> -
> -	/* Must get reference to anon_vma while still holding mmap_sem */
> -	hold_anon_vma(rmap_item, vma->anon_vma);
> -up:
> -	up_read(&mm->mmap_sem);
> -
> +	err = try_to_merge_with_ksm_page(rmap_item, page, NULL);
>  	if (!err) {
>  		err = try_to_merge_with_ksm_page(tree_rmap_item,
> -							tree_page, kpage);
> +							tree_page, page);
>  		/*
>  		 * If that fails, we have a ksm page with only one pte
>  		 * pointing to it: so break it.
> @@ -981,11 +961,7 @@ up:
>  		if (err)
>  			break_cow(rmap_item);
>  	}
> -	if (err) {
> -		put_page(kpage);
> -		kpage = NULL;
> -	}
> -	return kpage;
> +	return err ? NULL : page;
>  }
>  
>  /*
> @@ -1244,7 +1220,6 @@ static void cmp_and_merge_page(struct pa
>  				stable_tree_append(rmap_item, stable_node);
>  			}
>  			unlock_page(kpage);
> -			put_page(kpage);
>  
>  			/*
>  			 * If we fail to insert the page into the stable tree,
> --- ksm4/mm/rmap.c	2009-11-22 20:40:11.000000000 +0000
> +++ ksm5/mm/rmap.c	2009-11-22 20:40:27.000000000 +0000
> @@ -204,7 +204,7 @@ struct anon_vma *page_lock_anon_vma(stru
>  	unsigned long anon_mapping;
>  
>  	rcu_read_lock();
> -	anon_mapping = (unsigned long) page->mapping;
> +	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
>  	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
>  		goto out;
>  	if (!page_mapped(page))
> @@ -666,7 +666,9 @@ static void __page_check_anon_rmap(struc
>   * @address:	the user virtual address mapped
>   *
>   * The caller needs to hold the pte lock, and the page must be locked in
> - * the anon_vma case: to serialize mapping,index checking after setting.
> + * the anon_vma case: to serialize mapping,index checking after setting,
> + * and to ensure that PageAnon is not being upgraded racily to PageKsm
> + * (but PageKsm is never downgraded to PageAnon).
>   */
>  void page_add_anon_rmap(struct page *page,
>  	struct vm_area_struct *vma, unsigned long address)

