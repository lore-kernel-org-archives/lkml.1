Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbYCGSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbYCGSTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYCGST3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:19:29 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:45943 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbYCGST2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:19:28 -0500
Date: Fri, 7 Mar 2008 19:19:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [4/13] Prepare page_alloc for the maskable allocator
Message-ID: <20080307181943.GA14779@uranus.ravnborg.org>
References: <200803071007.493903088@firstfloor.org> <20080307090714.9493F1B419C@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307090714.9493F1B419C@basil.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi.

> Index: linux/mm/internal.h
> ===================================================================
> --- linux.orig/mm/internal.h
> +++ linux/mm/internal.h
> @@ -12,6 +12,7 @@
>  #define __MM_INTERNAL_H
>  
>  #include <linux/mm.h>
> +#include <linux/memcontrol.h>
>  
>  static inline void set_page_count(struct page *page, int v)
>  {
> @@ -48,6 +49,72 @@ static inline unsigned long page_order(s
>  	return page_private(page);
>  }
>  
> +extern void bad_page(struct page *page);
> +
> +static inline int free_pages_check(struct page *page, unsigned long addflags)
> +{
> +	if (unlikely(page_mapcount(page) |
> +		(page->mapping != NULL)  |
> +		(page_get_page_cgroup(page) != NULL) |
> +		(page_count(page) != 0)  |
> +		(page->flags & (
> +			addflags |
> +			1 << PG_lru	|
> +			1 << PG_private |
> +			1 << PG_locked	|
> +			1 << PG_active	|
> +			1 << PG_slab	|
> +			1 << PG_swapcache |
> +			1 << PG_writeback |
> +			1 << PG_reserved |
> +			1 << PG_buddy))))
> +		bad_page(page);
> +	if (PageDirty(page))
> +		__ClearPageDirty(page);
> +	/*
> +	 * For now, we report if PG_reserved was found set, but do not
> +	 * clear it, and do not free the page.  But we shall soon need
> +	 * to do more, for when the ZERO_PAGE count wraps negative.
> +	 */
> +	return PageReserved(page);
> +}
Looks a bit too big for an inline in a header (~9 lines of code)?

> +
> +/* Set up a struc page for business during allocation */
> +static inline int page_prep_struct(struct page *page)
> +{
> +	if (unlikely(page_mapcount(page) |
> +		(page->mapping != NULL)  |
> +		(page_get_page_cgroup(page) != NULL) |
> +		(page_count(page) != 0)  |
> +		(page->flags & (
> +			1 << PG_lru	|
> +			1 << PG_private	|
> +			1 << PG_locked	|
> +			1 << PG_active	|
> +			1 << PG_dirty	|
> +			1 << PG_slab    |
> +			1 << PG_swapcache |
> +			1 << PG_writeback |
> +			1 << PG_reserved |
> +			1 << PG_buddy))))
> +		bad_page(page);
> +
> +	/*
> +	 * For now, we report if PG_reserved was found set, but do not
> +	 * clear it, and do not allocate the page: as a safety net.
> +	 */
> +	if (PageReserved(page))
> +		return 1;
> +
> +	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
> +			1 << PG_referenced | 1 << PG_arch_1 |
> +			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
> +	set_page_private(page, 0);
> +	set_page_refcounted(page);
> +
> +	return 0;
> +}
Again - looks too big to inline..

But for both I do not know where they are used and how often.

	Sam
