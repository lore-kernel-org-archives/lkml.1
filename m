Return-Path: <linux-kernel-owner+w=401wt.eu-S1761838AbYCGSgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838AbYCGSgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbYCGSgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:36:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:48412 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbYCGSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Np3MiJFc1msmGRUAUNrDC/dl601DxiP9lOzBSpmdZQ0E8m/KO1D2t1uxWoXjLmy/tkfycxiJtviCWifvVtIy/NUBfPquLw5ZipCYJbLSzGh+1I38Kp/ICtMxhrkqkboAXbqiewGz6FpiuRZ8G29im/hnb73hnXJGUTnMyeT/mG4=
Date: Fri, 7 Mar 2008 21:36:05 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [4/13] Prepare page_alloc for the maskable allocator
Message-ID: <20080307183605.GC7589@cvg>
References: <200803071007.493903088@firstfloor.org> <20080307090714.9493F1B419C@basil.firstfloor.org> <20080307181943.GA14779@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307181943.GA14779@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Fri, Mar 07, 2008 at 07:19:43PM +0100]
| Hi Andi.
| 
| > Index: linux/mm/internal.h
| > ===================================================================
| > --- linux.orig/mm/internal.h
| > +++ linux/mm/internal.h
| > @@ -12,6 +12,7 @@
| >  #define __MM_INTERNAL_H
| >  
| >  #include <linux/mm.h>
| > +#include <linux/memcontrol.h>
| >  
| >  static inline void set_page_count(struct page *page, int v)
| >  {
| > @@ -48,6 +49,72 @@ static inline unsigned long page_order(s
| >  	return page_private(page);
| >  }
| >  
| > +extern void bad_page(struct page *page);
| > +
| > +static inline int free_pages_check(struct page *page, unsigned long addflags)
| > +{
| > +	if (unlikely(page_mapcount(page) |
| > +		(page->mapping != NULL)  |
| > +		(page_get_page_cgroup(page) != NULL) |
| > +		(page_count(page) != 0)  |
| > +		(page->flags & (
| > +			addflags |
| > +			1 << PG_lru	|
| > +			1 << PG_private |
| > +			1 << PG_locked	|
| > +			1 << PG_active	|
| > +			1 << PG_slab	|
| > +			1 << PG_swapcache |
| > +			1 << PG_writeback |
| > +			1 << PG_reserved |
| > +			1 << PG_buddy))))
| > +		bad_page(page);
| > +	if (PageDirty(page))
| > +		__ClearPageDirty(page);
| > +	/*
| > +	 * For now, we report if PG_reserved was found set, but do not
| > +	 * clear it, and do not free the page.  But we shall soon need
| > +	 * to do more, for when the ZERO_PAGE count wraps negative.
| > +	 */
| > +	return PageReserved(page);
| > +}
| Looks a bit too big for an inline in a header (~9 lines of code)?
| 

well, it will not be that big in compiled form 'cause in real it is

	page->flags & (addflags | (precompiled constant))

| > +
| > +/* Set up a struc page for business during allocation */
| > +static inline int page_prep_struct(struct page *page)
| > +{
| > +	if (unlikely(page_mapcount(page) |
| > +		(page->mapping != NULL)  |
| > +		(page_get_page_cgroup(page) != NULL) |
| > +		(page_count(page) != 0)  |
| > +		(page->flags & (
| > +			1 << PG_lru	|
| > +			1 << PG_private	|
| > +			1 << PG_locked	|
| > +			1 << PG_active	|
| > +			1 << PG_dirty	|
| > +			1 << PG_slab    |
| > +			1 << PG_swapcache |
| > +			1 << PG_writeback |
| > +			1 << PG_reserved |
| > +			1 << PG_buddy))))
| > +		bad_page(page);
| > +
| > +	/*
| > +	 * For now, we report if PG_reserved was found set, but do not
| > +	 * clear it, and do not allocate the page: as a safety net.
| > +	 */
| > +	if (PageReserved(page))
| > +		return 1;
| > +
| > +	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_readahead |
| > +			1 << PG_referenced | 1 << PG_arch_1 |
| > +			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
| > +	set_page_private(page, 0);
| > +	set_page_refcounted(page);
| > +
| > +	return 0;
| > +}
| Again - looks too big to inline..
| 
| But for both I do not know where they are used and how often.
| 
| 	Sam
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
| 
		- Cyrill -
