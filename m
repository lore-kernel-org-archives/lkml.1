Return-Path: <linux-kernel-owner+w=401wt.eu-S2992602AbXCBQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992602AbXCBQoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992605AbXCBQoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:44:39 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49340 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992602AbXCBQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:44:38 -0500
X-AuditID: d80ac287-a1830bb000002978-25-45e854757055 
Date: Fri, 2 Mar 2007 16:44:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Richard Purdie <rpurdie@openedhand.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Subject: Re: [PATCH 4/9] swap: Simplify shmem_unuse() usage [optional]
In-Reply-To: <1172850884.11149.124.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703021631470.11135@blonde.wat.veritas.com>
References: <1172850884.11149.124.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 02 Mar 2007 16:44:37.0445 (UTC) FILETIME=[10A12F50:01C75CEA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Richard Purdie wrote:

> Simplify shmem_unuse_inode() removing a confusing optimisation which
> requires the caller to call swap_duplicate if the shmem_unuse() call
> doesn't succeed.
> 
> Based on a patch by Nick Piggin and some of my own changes as discussed
> on LKML. 
> 
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

Definite NAK to this one from me: I'm sorry the optimization confuses
you, but it's well commented at both ends, and speeds up shmem swapoff
very significantly e.g. minutes down to seconds.  There may well be a
less confusing way of achieving the same effect, with another return
code from shmem_unuse, and some gotos, but I'm not all that keen.

Your other patches, well, as ever I hope I'll get to look at them,
but there are so many people, all much quicker than me, playing in
mm these days...

Hugh

> 
> ---
>  mm/shmem.c    |   12 +++++-------
>  mm/swapfile.c |   23 ++---------------------
>  2 files changed, 7 insertions(+), 28 deletions(-)
> 
> Index: linux/mm/shmem.c
> ===================================================================
> --- linux.orig/mm/shmem.c	2007-02-28 18:12:34.000000000 +0000
> +++ linux/mm/shmem.c	2007-02-28 18:12:46.000000000 +0000
> @@ -734,7 +734,7 @@ static int shmem_unuse_inode(struct shme
>  	struct page **dir;
>  	struct page *subdir;
>  	swp_entry_t *ptr;
> -	int offset;
> +	int offset, moved;
>  
>  	idx = 0;
>  	ptr = info->i_direct;
> @@ -792,17 +792,15 @@ lost2:
>  found:
>  	idx += offset;
>  	inode = &info->vfs_inode;
> -	if (move_from_swap_cache(page, idx, inode->i_mapping) == 0) {
> +	moved = (move_from_swap_cache(page, idx, inode->i_mapping) == 0);
> +	if (moved) {
>  		info->flags |= SHMEM_PAGEIN;
>  		shmem_swp_set(info, ptr + offset, 0);
>  	}
>  	shmem_swp_unmap(ptr);
>  	spin_unlock(&info->lock);
> -	/*
> -	 * Decrement swap count even when the entry is left behind:
> -	 * try_to_unuse will skip over mms, then reincrement count.
> -	 */
> -	swap_free(entry, page);
> +	if (moved)
> +		swap_free(entry, page);
>  	return 1;
>  }
>  
> Index: linux/mm/swapfile.c
> ===================================================================
> --- linux.orig/mm/swapfile.c	2007-02-28 18:12:41.000000000 +0000
> +++ linux/mm/swapfile.c	2007-02-28 18:13:04.000000000 +0000
> @@ -689,15 +689,6 @@ void try_to_unuse_page_entry(struct page
>  	if (!shmem_unuse(entry, page)) {
>  		try_to_unuse_anon(entry, page);
>  		delete_from_swap_cache(page);
> -	} else if (PageSwapCache(page)) {
> -		/*
> -		 * shmem_unuse deleted a swappage from the swap cache, but the
> -		 * move to filepage failed so it left swappage in cache and
> -		 * lowered its swap count to pass quickly through the loops in
> -		 * try_to_unuse(). We must reincrement the count to try again
> -		 * later (ick).
> -		 */
> -		swap_duplicate(entry);
>  	}
>  }
>  
> @@ -922,12 +913,6 @@ static int try_to_unuse(unsigned int typ
>  		 * read from disk into another page.  Splitting into two
>  		 * pages would be incorrect if swap supported "shared
>  		 * private" pages, but they are handled by tmpfs files.
> -		 *
> -		 * Note shmem_unuse already deleted a swappage from
> -		 * the swap cache, unless the move to filepage failed:
> -		 * in which case it left swappage in cache, lowered its
> -		 * swap count to pass quickly through the loops above,
> -		 * and now we must reincrement count to try again later.
>  		 */
>  		if ((*swap_map > 1) && PageDirty(page) && PageSwapCache(page)) {
>  			struct writeback_control wbc = {
> @@ -938,12 +923,8 @@ static int try_to_unuse(unsigned int typ
>  			lock_page(page);
>  			wait_on_page_writeback(page);
>  		}
> -		if (PageSwapCache(page)) {
> -			if (shmem)
> -				swap_duplicate(entry);
> -			else
> -				delete_from_swap_cache(page);
> -		}
> +		if (PageSwapCache(page) && !shmem)
> +			delete_from_swap_cache(page);
>  
>  		/*
>  		 * So we could skip searching mms once swap count went
