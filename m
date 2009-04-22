Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZDVAUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZDVAUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZDVAUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:20:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60634 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZDVAUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:20:43 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 20/25] Do not check for compound pages during the page allocator sanity checks
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-21-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-21-git-send-email-mel@csn.ul.ie>
Message-Id: <20090422091456.626E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 22 Apr 2009 09:20:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A number of sanity checks are made on each page allocation and free
> including that the page count is zero. page_count() checks for
> compound pages and checks the count of the head page if true. However,
> in these paths, we do not care if the page is compound or not as the
> count of each tail page should also be zero.
> 
> This patch makes two changes to the use of page_count() in the free path. It
> converts one check of page_count() to a VM_BUG_ON() as the count should
> have been unconditionally checked earlier in the free path. It also avoids
> checking for compound pages.
> 
> [mel@csn.ul.ie: Wrote changelog]
> Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> ---
>  mm/page_alloc.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ec01d8f..376d848 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -425,7 +425,7 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
>  		return 0;
>  
>  	if (PageBuddy(buddy) && page_order(buddy) == order) {
> -		BUG_ON(page_count(buddy) != 0);
> +		VM_BUG_ON(page_count(buddy) != 0);
>  		return 1;
>  	}
>  	return 0;
>

Looks good.


> @@ -501,7 +501,7 @@ static inline int free_pages_check(struct page *page)
>  {
>  	if (unlikely(page_mapcount(page) |
>  		(page->mapping != NULL)  |
> -		(page_count(page) != 0)  |
> +		(atomic_read(&page->_count) != 0) |
>  		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
>  		bad_page(page);
>  		return 1;
> @@ -646,7 +646,7 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
>  {
>  	if (unlikely(page_mapcount(page) |
>  		(page->mapping != NULL)  |
> -		(page_count(page) != 0)  |
> +		(atomic_read(&page->_count) != 0)  |
>  		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
>  		bad_page(page);
>  		return 1;


inserting VM_BUG_ON(PageTail(page)) is better?





