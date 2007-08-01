Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbXHAGRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbXHAGRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXHAGRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:17:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39067 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbXHAGRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:17:42 -0400
Subject: Re: [PATCH 02/14] FS-Cache: Recruit a couple of page flags for
	cache management
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070731202505.6412.37918.stgit@warthog.cambridge.redhat.com>
References: <20070731202454.6412.88646.stgit@warthog.cambridge.redhat.com>
	 <20070731202505.6412.37918.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 08:17:35 +0200
Message-Id: <1185949055.12034.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 21:25 +0100, David Howells wrote:

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 209d3a4..eaf9854 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -83,19 +83,24 @@
>  #define PG_private		11	/* If pagecache, has fs-private data */
>  
>  #define PG_writeback		12	/* Page is under writeback */
> +#define PG_owner_priv_2		13	/* Owner use. If pagecache, fs may use */
>  #define PG_compound		14	/* Part of a compound page */
>  #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
>  
>  #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
>  #define PG_reclaim		17	/* To be reclaimed asap */
> +#define PG_owner_priv_3		18	/* Owner use. If pagecache, fs may use */
>  #define PG_buddy		19	/* Page is free, on buddy lists */
>  
>  /* PG_readahead is only used for file reads; PG_reclaim is only for writes */
>  #define PG_readahead		PG_reclaim /* Reminder to do async read-ahead */
>  
> -/* PG_owner_priv_1 users should have descriptive aliases */
> +/* PG_owner_priv_1/2/3 users should have descriptive aliases */
>  #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
>  #define PG_pinned		PG_owner_priv_1	/* Xen pinned pagetable */
> +#define PG_fscache		PG_owner_priv_2	/* Backed by local cache */
> +#define PG_fscache_write	PG_owner_priv_3	/* Writing to local cache */
> +

 
> +/**
> + * page_has_private - Determine if page has private stuff
> + * @page: The page to be checked
> + *
> + * Determine if a page has private stuff, indicating that release routines
> + * should be invoked upon it.
> + */
> +#define page_has_private(page)			\
> +	((page)->flags & ((1 << PG_private) |	\
> +			  (1 << PG_fscache)))
> +


Not sure its a good idea to overload page_has_private() with an
overloadable page-flag. What if some future FS wants to use
PG_owner_priv_2 for other purposes?

Obviously filesystems cannot use these two page-flags if they want to be
compatible with FS-cache, but need all filesystems be?


(also, ouch! - 2 pageflags)

