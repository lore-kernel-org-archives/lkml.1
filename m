Return-Path: <linux-kernel-owner+w=401wt.eu-S1760851AbZE0XR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851AbZE0XR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZE0XRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:17:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753746AbZE0XRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:17:19 -0400
Date: Wed, 27 May 2009 16:15:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com,
       hugh.dickins@tiscali.co.uk
Subject: Re: [patch] mm: release swap slots for actively used pages
Message-Id: <20090527161535.ac2dd1ba.akpm@linux-foundation.org>
In-Reply-To: <1243388859-9760-1-git-send-email-hannes@cmpxchg.org>
References: <1243388859-9760-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 03:47:39 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> For anonymous pages activated by the reclaim scan or faulted from an
> evicted page table entry we should always try to free up swap space.
> 
> Both events indicate that the page is in active use and a possible
> change in the working set.  Thus removing the slot association from
> the page increases the chance of the page being placed near its new
> LRU buddies on the next eviction and helps keeping the amount of stale
> swap cache entries low.
> 
> try_to_free_swap() inherently only succeeds when the last user of the
> swap slot vanishes so it is safe to use from places where that single
> mapping just brought the page back to life.
> 

Seems that this has a risk of worsening swap fragmentation for some
situations.  Or not, I have no way of knowing, really.

> diff --git a/mm/memory.c b/mm/memory.c
> index 8b4e40e..407ebf7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2671,8 +2671,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	mem_cgroup_commit_charge_swapin(page, ptr);
>  
>  	swap_free(entry);
> -	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
> -		try_to_free_swap(page);
> +	try_to_free_swap(page);
>  	unlock_page(page);
>  
>  	if (write_access) {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 621708f..2f0549d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -788,7 +788,7 @@ cull_mlocked:
>  
>  activate_locked:
>  		/* Not a candidate for swapping, so reclaim swap space. */
> -		if (PageSwapCache(page) && vm_swap_full())
> +		if (PageSwapCache(page))
>  			try_to_free_swap(page);
>  		VM_BUG_ON(PageActive(page));
>  		SetPageActive(page);

How are we to know that this is a desirable patch for Linux??
