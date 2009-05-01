Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZEAXS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZEAXS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZEAXSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:18:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbZEAXSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:18:47 -0400
Date: Fri, 1 May 2009 16:14:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] PM/Hibernate: Use memory allocations to free memory
Message-Id: <20090501161423.94b37d5b.akpm@linux-foundation.org>
In-Reply-To: <200905020029.39181.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<20090422131943.69288af3.akpm@linux-foundation.org>
	<200905020026.19027.rjw@sisk.pl>
	<200905020029.39181.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009 00:29:38 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Modify the hibernation memory shrinking code so that it will make
> memory allocations to free memory instead of using an artificial
> memory shrinking mechanism for that.  Remove the shrinking of
> memory from the suspend-to-RAM code, where it is not really
> necessary.  Finally, remove the no longer used memory shrinking
> functions from mm/vmscan.c .
> 
> ...
>
> +static long alloc_and_mark_pages(struct memory_bitmap *bm, long nr_pages)
>  {
> -	if (tmp > SHRINK_BITE)
> -		tmp = SHRINK_BITE;
> -	return shrink_all_memory(tmp);
> +	long nr_normal = 0;
> +
> +	while (nr_pages-- > 0) {
> +		struct page *page;
> +
> +		page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
> +		if (!page)
> +			return -ENOMEM;
> +		memory_bm_set_bit(bm, page_to_pfn(page));
> +		if (!PageHighMem(page))
> +			nr_normal++;
> +	}
> +
> +	return nr_normal;
>  }

Do we need the bitmap?  I expect we can just string all these pages
onto a local list via page.lru.  Would need to check that - the
pageframe fields are quite overloaded.


> ...
>
> +#define SHRINK_BITE	10000
> +		long size, highmem_size, ret;
> +
> +		highmem_size = count_highmem_pages() - 2 * alloc_highmem;
> +		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES
> +			- 2 * alloc_normal;

It'd be nice if this head-spinning arithmetic were spelled out in a
comment somewhere.  There are rather a lot of magic-number heuristics
in here.

>  		tmp = size;
>  		size += highmem_size;
>  		for_each_populated_zone(zone) {
> @@ -621,27 +671,39 @@ int swsusp_shrink_memory(void)

All looks pretty sane to me.
