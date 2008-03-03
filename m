Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbYCCKJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbYCCKJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYCCKJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:09:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53713 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbYCCKJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:09:26 -0500
Date: Mon, 3 Mar 2008 10:09:23 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 01/10] Pageflags: Use an enum for the flags
Message-ID: <20080303100923.GC19485@csn.ul.ie>
References: <20080301040534.797979115@sgi.com> <20080301040620.029724488@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080301040620.029724488@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/02/08 20:05), Christoph Lameter didst pronounce:
> Use an enum to ease the maintenance of page flags. This is going to change the
> numbering from 0 to 18.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/page-flags.h |   54 ++++++++++++++++++++-------------------------
>  1 file changed, 24 insertions(+), 30 deletions(-)
> 
> Index: linux-2.6/include/linux/page-flags.h
> ===================================================================
> --- linux-2.6.orig/include/linux/page-flags.h	2008-02-29 14:54:22.000000000 -0800
> +++ linux-2.6/include/linux/page-flags.h	2008-02-29 15:00:00.000000000 -0800
> @@ -67,35 +67,28 @@
>   * FLAGS_RESERVED which defines the width of the fields section
>   * (see linux/mmzone.h).  New flags must _not_ overlap with this area.
>   */
> -#define PG_locked	 	 0	/* Page is locked. Don't touch. */
> -#define PG_error		 1
> -#define PG_referenced		 2
> -#define PG_uptodate		 3
> -
> -#define PG_dirty	 	 4
> -#define PG_lru			 5
> -#define PG_active		 6
> -#define PG_slab			 7	/* slab debug (Suparna wants this) */
> -
> -#define PG_owner_priv_1		 8	/* Owner use. If pagecache, fs may use*/
> -#define PG_arch_1		 9
> -#define PG_reserved		10
> -#define PG_private		11	/* If pagecache, has fs-private data */
> -
> -#define PG_writeback		12	/* Page is under writeback */
> -#define PG_compound		14	/* Part of a compound page */
> -#define PG_swapcache		15	/* Swap page: swp_entry_t in private */
> -
> -#define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
> -#define PG_reclaim		17	/* To be reclaimed asap */
> -#define PG_buddy		19	/* Page is free, on buddy lists */
> -
> -/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
> -#define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
> -
> -/* PG_owner_priv_1 users should have descriptive aliases */
> -#define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
> -#define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */

These two verbose descriptions appear to go missing in the enum below.
It probably is intentional because they are aliases but you can preseve them
being aliases with

PG_checked = PG_owner_priv_1,
PG_pinned = PG_owner_priv_1,

That would keep the comments about flags in one place. I note that you
move the comment to the macro definitions in a later patch but maybe having
comments about some flags in multiple places is not very desirable?

> +enum pageflags {
> +	PG_locked,		/* Page is locked. Don't touch. */
> +	PG_error,
> +	PG_referenced,
> +	PG_uptodate,
> +	PG_dirty,
> +	PG_lru,
> +	PG_active,
> +	PG_slab,
> +	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
> +	PG_arch_1,
> +	PG_reserved,
> +	PG_private,		/* If pagecache, has fs-private data */
> +	PG_writeback,		/* Page is under writeback */
> +	PG_compound,		/* A compound page */
> +	PG_swapcache,		/* Swap page: swp_entry_t in private */
> +	PG_mappedtodisk,	/* Has blocks allocated on-disk */
> +	PG_reclaim,		/* To be reclaimed asap */
> +	/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
> +	PG_readahead = PG_reclaim, /* Reminder to do async read-ahead */
> +	PG_buddy,		/* Page is free, on buddy lists */
> +	NR_PAGEFLAGS,		/* For verification purposes */
>  
>  #if (BITS_PER_LONG > 32)
>  /*
> @@ -105,8 +98,9 @@
>   * 64 bit  |           FIELDS             | ??????         FLAGS         |
>   *         63                            32                              0
>   */
> -#define PG_uncached		31	/* Page has been mapped as uncached */
> +	PG_uncached = 31,		/* Page has been mapped as uncached */
>  #endif
> +};
>  
>  /*
>   * Manipulation of page state flags
> 
> -- 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
