Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbZDCKyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbZDCKyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbZDCKyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:54:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:41772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757323AbZDCKyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:54:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="127479991"
Date: Fri, 3 Apr 2009 18:53:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mikew@google.com,
       rientjes@google.com, rohitseth@google.com, hugh@veritas.com,
       a.p.zijlstra@chello.nl, hpa@zytor.com, edwintorok@gmail.com,
       lee.schermerhorn@hp.com, npiggin@suse.de
Subject: Re: [PATCH] vfs: reduce page fault retry code
Message-ID: <20090403105350.GA9689@localhost>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com> <20090331150046.16539218.akpm@linux-foundation.org> <20090403082230.GA6084@localhost> <20090403083559.GB6084@localhost> <20090403085503.GC6084@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403085503.GC6084@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 04:55:03PM +0800, Wu Fengguang wrote:
> find_lock_page_retry() works the same way as find_lock_page()
> when retry_flag=0. And their return value handling shall work
> (almost) in the same way, or it will already be a bug.
> 
> So the !retry_flag special casing can be eliminated.
> 
> Cc: Ying Han <yinghan@google.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/filemap.c |    7 -------
>  1 file changed, 7 deletions(-)
> 
> --- mm.orig/mm/filemap.c
> +++ mm/mm/filemap.c
> @@ -1663,13 +1663,6 @@ no_cached_page:
>  	 * meantime, we'll just come back here and read it again.
>  	 */
>  	if (error >= 0) {
> -		/*
> -		 * If caller cannot tolerate a retry in the ->fault path
> -		 * go back to check the page again.
> -		 */
> -		if (!retry_flag)
> -			goto retry_find;
> -
>  		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
>  					vma, &page, retry_flag);
>  		if (retry_ret == VM_FAULT_RETRY)

In fact I guess we can shrink the code more aggressively. 
The only difference is the extra ra->mmap_miss--, which will
be moved to other place in another planned patch.

Thanks,
Fengguang
---
 mm/filemap.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

--- mm.orig/mm/filemap.c
+++ mm/mm/filemap.c
@@ -1565,7 +1565,6 @@ int filemap_fault(struct vm_area_struct 
 retry_find:
 	page = find_lock_page(mapping, vmf->pgoff);
 
-retry_find_nopage:
 	/*
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
@@ -1615,6 +1614,7 @@ retry_find_nopage:
 				start = vmf->pgoff - ra_pages / 2;
 			do_page_cache_readahead(mapping, file, start, ra_pages);
 		}
+retry_find_retry:
 		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
 				vma, &page, retry_flag);
 		if (retry_ret == VM_FAULT_RETRY)
@@ -1626,7 +1626,6 @@ retry_find_nopage:
 	if (!did_readaround)
 		ra->mmap_miss--;
 
-retry_page_update:
 	/*
 	 * We have a locked page in the page cache, now we need to check
 	 * that it's up-to-date. If not, it is going to be due to an error.
@@ -1662,23 +1661,8 @@ no_cached_page:
 	 * In the unlikely event that someone removed it in the
 	 * meantime, we'll just come back here and read it again.
 	 */
-	if (error >= 0) {
-		/*
-		 * If caller cannot tolerate a retry in the ->fault path
-		 * go back to check the page again.
-		 */
-		if (!retry_flag)
-			goto retry_find;
-
-		retry_ret = find_lock_page_retry(mapping, vmf->pgoff,
-					vma, &page, retry_flag);
-		if (retry_ret == VM_FAULT_RETRY)
-			return retry_ret;
-		if (!page)
-			goto retry_find_nopage;
-		else
-			goto retry_page_update;
-	}
+	if (error >= 0)
+		goto retry_find_retry;
 
 	/*
 	 * An error return from page_cache_read can result if the
