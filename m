Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZFOJm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZFOJm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZFOJmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:42:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51771 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZFOJmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:42:44 -0400
Date: Mon, 15 Jun 2009 18:41:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mel Gorman <mel@csn.ul.ie>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 10/22] HWPOISON: check and isolate corrupted free pages
 v2
Message-Id: <20090615184112.ed8e2f03.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090615031253.715406280@intel.com>
References: <20090615024520.786814520@intel.com>
	<20090615031253.715406280@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 10:45:30 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> From: Wu Fengguang <fengguang.wu@intel.com>
> 
> If memory corruption hits the free buddy pages, we can safely ignore them.
> No one will access them until page allocation time, then prep_new_page()
> will automatically check and isolate PG_hwpoison page for us (for 0-order
> allocation).
> 
> This patch expands prep_new_page() to check every component page in a high
> order page allocation, in order to completely stop PG_hwpoison pages from
> being recirculated.
> 
> Note that the common case -- only allocating a single page, doesn't
> do any more work than before. Allocating > order 0 does a bit more work,
> but that's relatively uncommon.
> 
> This simple implementation may drop some innocent neighbor pages, hopefully
> it is not a big problem because the event should be rare enough.
> 
> This patch adds some runtime costs to high order page users.
> 
> [AK: Improved description]
> 
> v2: Andi Kleen:
> Port to -mm code
> Move check into separate function.
> Don't dump stack in bad_pages for hwpoisoned pages.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/page_alloc.c |   20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> --- sound-2.6.orig/mm/page_alloc.c
> +++ sound-2.6/mm/page_alloc.c
> @@ -233,6 +233,12 @@ static void bad_page(struct page *page)
>  	static unsigned long nr_shown;
>  	static unsigned long nr_unshown;
>  
> +	/* Don't complain about poisoned pages */
> +	if (PageHWPoison(page)) {
> +		__ClearPageBuddy(page);
> +		return;
> +	}

Hmm ? why __ClearPageBuddy() is necessary ?

Thanks,
-Kame


> +
>  	/*
>  	 * Allow a burst of 60 reports, then keep quiet for that minute;
>  	 * or allow a steady drip of one report per second.
> @@ -646,7 +652,7 @@ static inline void expand(struct zone *z
>  /*
>   * This page is about to be returned from the page allocator
>   */
> -static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
> +static inline int check_new_page(struct page *page)
>  {
>  	if (unlikely(page_mapcount(page) |
>  		(page->mapping != NULL)  |
> @@ -655,6 +661,18 @@ static int prep_new_page(struct page *pa
>  		bad_page(page);
>  		return 1;
>  	}
> +	return 0;
> +}
> +
> +static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
> +{
> +	int i;
> +
> +	for (i = 0; i < (1 << order); i++) {
> +		struct page *p = page + i;
> +		if (unlikely(check_new_page(p)))
> +			return 1;
> +	}
>  
>  	set_page_private(page, 0);
>  	set_page_refcounted(page);
> 
> -- 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

