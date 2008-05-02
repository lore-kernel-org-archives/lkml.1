Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYEBBNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYEBBNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbYEBBMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:12:52 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59876 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754211AbYEBBMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:12:51 -0400
Date: Thu, 1 May 2008 18:12:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v2
In-Reply-To: <20080502004248.GC12006@sgi.com>
Message-ID: <Pine.LNX.4.64.0805011810410.13527@schroedinger.engr.sgi.com>
References: <20080502004248.GC12006@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Russ Anderson wrote:

> Index: linus/mm/migrate.c
> ===================================================================
> --- linus.orig/mm/migrate.c	2008-05-01 19:05:33.000000000 -0500
> +++ linus/mm/migrate.c	2008-05-01 19:06:15.000000000 -0500
> @@ -380,6 +380,7 @@ static void migrate_page_copy(struct pag
>  		SetPageChecked(newpage);
>  	if (PageMappedToDisk(page))
>  		SetPageMappedToDisk(newpage);
> +	/* Do not migrate PG_memerror to the new page */

Why is the comment here?

  
>  	if (PageDirty(page)) {
>  		clear_page_dirty_for_io(page);
> @@ -721,6 +722,8 @@ unlock:
>   		 */
>   		list_del(&page->lru);
>   		move_to_lru(page);
> +		if (PageMemError(page))
> +			totalbad_pages++;

Wouldnt this be taken care of by the lru handling?

> +#ifdef CONFIG_PAGEFLAGS_EXTENDED
> +PAGEFLAG(MemError, memerror)
> +#else
> +#define PageMemError(page)	0

Use

PAGEFLAG_FLAGS(MemError)

>  #include <linux/page-flags.h>
>  
> -#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
> +#define PAGE_FLAGS_BASE	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
>  			 1 << PG_buddy | 1 << PG_writeback | \
>  			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
> +
> +#ifdef CONFIG_PAGEFLAGS_EXTENDED
> +#define	PAGE_FLAGS	(PAGE_FLAGS_BASE | 1UL << PG_memerror)
> +#else
> +#define	PAGE_FLAGS	(PAGE_FLAGS_BASE)
> +#endif
>  
>  #define PAGE_FLAGS_RECLAIM      (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
>  #define PAGE_FLAGS_RESERVE	(PAGE_FLAGS | 1 << PG_reserved)

The groups of page flags could also be put into page-flags.h.

