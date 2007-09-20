Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXITS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXITS07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXITS0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:26:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40652 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbXITS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:26:51 -0400
Date: Thu, 20 Sep 2007 11:26:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       ricknu-0@student.ltu.se
Subject: Re: [RFC][PATCH] page->mapping clarification [1/3] base functions
In-Reply-To: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0709201120510.8801@schroedinger.engr.sgi.com>
References: <20070919164308.281f9960.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, KAMEZAWA Hiroyuki wrote:

> Any comments are welcome.

I am still a bit confused as to what the benefit of this is.

> Following functions are added
> 
>  * page_mapping_cache() ... returns address space if a page is page cache
>  * page_mapping_anon()  ... returns anon_vma if a page is anonymous page.
>  * page_is_pagecache()  ... returns true if a page is page-cache.
>  * page_inode()         ... returns inode which a page-cache belongs to.
>  * is_page_consistent() ... returns true if a page is still valid page cache 

Ok this could make the code more readable.

> +/*
> + * On an anonymous page mapped into a user virtual memory area,
> + * page->mapping points to its anon_vma, not to a struct address_space;
> + * with the PAGE_MAPPING_ANON bit set to distinguish it.
> + *
> + * Please note that, confusingly, "page_mapping" refers to the inode
> + * address_space which maps the page from disk; whereas "page_mapped"
> + * refers to user virtual address space into which the page is mapped.
> + */
> +#define PAGE_MAPPING_ANON       1
> +
> +static inline bool PageAnon(struct page *page)

bool??? That is unusual?

> +static inline struct address_space *page_mapping_cache(struct page *page)
> +{
> +	if (!page->mapping || PageAnon(page))
> +		return NULL;
> +	return page->mapping;
> +}

That is confusing.

if (PageAnon(page))
	return NULL;
return page->mapping;


> +static inline struct address_space *page_mapping(struct page *page)
> +{
> +	struct address_space *mapping = page->mapping;
> +
> +	VM_BUG_ON(PageSlab(page));
> +	if (unlikely(PageSwapCache(page)))
> +		mapping = &swapper_space;
> +#ifdef CONFIG_SLUB
> +	else if (unlikely(PageSlab(page)))
> +		mapping = NULL;
> +#endif

The #ifdef does not exist in rc6-mm1. No need to reintroduce it.

> +static inline bool
> +is_page_consistent(struct page *page, struct address_space *mapping)
> +{
> +	struct address_space *check = page_mapping_cache(page);
> +	return (check == mapping);
> +}

Why do we need a special function? Why is it safer?

