Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbXD0Jr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbXD0Jr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbXD0Jr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:47:27 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44223 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbXD0Jr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:47:26 -0400
Message-ID: <4631C7B1.1070406@sw.ru>
Date: Fri, 27 Apr 2007 13:51:45 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, Kirill Korotaev <dev@sw.ru>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RSS Container, make page_referenced() container aware
References: <4630F75F.9060206@linux.vnet.ibm.com>
In-Reply-To: <4630F75F.9060206@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Hi, Pavel,
> 
> This patch should help with the shared page issue of one container
> holding shared pages in a another container (the container that
> brought in the page -- by first touch) hostage.

The shared pages accounting is tricky.
Actually we planned not to do it right now, but later,
when (if) this will be accepted and we'll move forward
to the fractions accounting.

> 
> ------------------------------------------------------------------------
> 
> 
> 
> Make page_referenced() container aware. Without this patch, page_referenced()
> can cause a page to be skipped while reclaiming pages. This patch
> ensures that other containers do not hold pages in a particular container
> hostage. It is required to ensure that shared pages are freed from a container
> when they are not actively referenced from the container that brought
> them in
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
> 
>  include/linux/rmap.h |    5 +++--
>  mm/rmap.c            |   26 ++++++++++++++++++++------
>  mm/vmscan.c          |    4 ++--
>  3 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff -puN mm/vmscan.c~rss-implement-per-container-page-referenced mm/vmscan.c
> --- linux-2.6.20/mm/vmscan.c~rss-implement-per-container-page-referenced	2007-04-26 23:28:44.000000000 +0530
> +++ linux-2.6.20-balbir/mm/vmscan.c	2007-04-27 00:04:38.000000000 +0530
> @@ -489,7 +489,7 @@ static unsigned long shrink_page_list(st
>  		if (PageWriteback(page))
>  			goto keep_locked;
>  
> -		referenced = page_referenced(page, 1);
> +		referenced = page_referenced(page, 1, sc->cnt);
>  		/* In active use or really unfreeable?  Activate it. */
>  		if (referenced && page_mapping_inuse(page))
>  			goto activate_locked;
> @@ -852,7 +852,7 @@ force_reclaim_mapped:
>  		if (page_mapped(page)) {
>  			if (!reclaim_mapped ||
>  			    (total_swap_pages == 0 && PageAnon(page)) ||
> -			    page_referenced(page, 0)) {
> +			    page_referenced(page, 0, sc->cnt)) {
>  				list_add(&page->lru, &l_active);
>  				continue;
>  			}
> diff -puN mm/rmap.c~rss-implement-per-container-page-referenced mm/rmap.c
> --- linux-2.6.20/mm/rmap.c~rss-implement-per-container-page-referenced	2007-04-26 23:28:44.000000000 +0530
> +++ linux-2.6.20-balbir/mm/rmap.c	2007-04-26 23:33:41.000000000 +0530
> @@ -318,7 +318,7 @@ out:
>  	return referenced;
>  }
>  
> -static int page_referenced_anon(struct page *page)
> +static int page_referenced_anon(struct page *page, struct rss_container *cnt)
>  {
>  	unsigned int mapcount;
>  	struct anon_vma *anon_vma;
> @@ -331,6 +331,13 @@ static int page_referenced_anon(struct p
>  
>  	mapcount = page_mapcount(page);
>  	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
> +		/*
> +		 * If we are reclaiming on behalf of a container, skip
> +		 * counting on behalf of references from different
> +		 * containers
> +		 */
> +		if (cnt && (vma->vm_mm->rss_container != cnt))
> +			continue;

An #ifdef missed - mm->rss_container makes sense with 
the CONFIG_RSS_COUNTAINER set only.

>  		referenced += page_referenced_one(page, vma, &mapcount);
>  		if (!mapcount)
>  			break;
> @@ -350,7 +357,7 @@ static int page_referenced_anon(struct p
>   *
>   * This function is only called from page_referenced for object-based pages.
>   */
> -static int page_referenced_file(struct page *page)
> +static int page_referenced_file(struct page *page, struct rss_container *cnt)
>  {
>  	unsigned int mapcount;
>  	struct address_space *mapping = page->mapping;
> @@ -383,6 +390,13 @@ static int page_referenced_file(struct p
>  	mapcount = page_mapcount(page);
>  
>  	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> +		/*
> +		 * If we are reclaiming on behalf of a container, skip
> +		 * counting on behalf of references from different
> +		 * containers
> +		 */
> +		if (cnt && (vma->vm_mm->rss_container != cnt))
> +			continue;
>  		if ((vma->vm_flags & (VM_LOCKED|VM_MAYSHARE))
>  				  == (VM_LOCKED|VM_MAYSHARE)) {
>  			referenced++;
> @@ -405,7 +419,7 @@ static int page_referenced_file(struct p
>   * Quick test_and_clear_referenced for all mappings to a page,
>   * returns the number of ptes which referenced the page.
>   */
> -int page_referenced(struct page *page, int is_locked)
> +int page_referenced(struct page *page, int is_locked, struct rss_container *cnt)
>  {
>  	int referenced = 0;
>  
> @@ -417,14 +431,14 @@ int page_referenced(struct page *page, i
>  
>  	if (page_mapped(page) && page->mapping) {
>  		if (PageAnon(page))
> -			referenced += page_referenced_anon(page);
> +			referenced += page_referenced_anon(page, cnt);
>  		else if (is_locked)
> -			referenced += page_referenced_file(page);
> +			referenced += page_referenced_file(page, cnt);
>  		else if (TestSetPageLocked(page))
>  			referenced++;
>  		else {
>  			if (page->mapping)
> -				referenced += page_referenced_file(page);
> +				referenced += page_referenced_file(page, cnt);
>  			unlock_page(page);
>  		}
>  	}
> diff -puN include/linux/rmap.h~rss-implement-per-container-page-referenced include/linux/rmap.h
> --- linux-2.6.20/include/linux/rmap.h~rss-implement-per-container-page-referenced	2007-04-26 23:28:44.000000000 +0530
> +++ linux-2.6.20-balbir/include/linux/rmap.h	2007-04-26 23:29:31.000000000 +0530
> @@ -8,6 +8,7 @@
>  #include <linux/slab.h>
>  #include <linux/mm.h>
>  #include <linux/spinlock.h>
> +#include <linux/rss_container.h>
>  
>  /*
>   * The anon_vma heads a list of private "related" vmas, to scan if
> @@ -93,7 +94,7 @@ static inline void page_dup_rmap(struct 
>  /*
>   * Called from mm/vmscan.c to handle paging out
>   */
> -int page_referenced(struct page *, int is_locked);
> +int page_referenced(struct page *, int is_locked, struct rss_container *cnt);
>  int try_to_unmap(struct page *, int ignore_refs);
>  
>  /*
> @@ -121,7 +122,7 @@ int page_mkclean(struct page *);
>  #define anon_vma_prepare(vma)	(0)
>  #define anon_vma_link(vma)	do {} while (0)
>  
> -#define page_referenced(page,l) TestClearPageReferenced(page)
> +#define page_referenced(page,l,cnt) TestClearPageReferenced(page)
>  #define try_to_unmap(page, refs) SWAP_FAIL
>  
>  static inline int page_mkclean(struct page *page)
> _

