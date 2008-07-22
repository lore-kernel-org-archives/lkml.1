Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYGVCm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYGVCm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYGVCmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:42:18 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:34676 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753866AbYGVCmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:42:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BryVxdfYGrN5qSxhG/RSxATyG6curzu7x/gt8pbPoA1HLCZRxyqxIizKwU7LeGgG+tmetoc72ZKJzdIvDFQ+zIbn996J/4nPWN/UZCsqvG9G8hn3lc5CeZVgZypIgG62zoLpzIPluZqoFqejNRUYxp5aao80f1ZY8GSqc+eJNvc=  ;
X-YMail-OSG: jtjDpbkVM1nz3aodUtJIGmoL29O6AhhTDw18Os3Q9w4fXXeOLWKE1UzMyUHUeKugagshcIPkq5VVLxGs6hMbeXUXObnfvcsyvcMxaQjOOw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 1/2] mm: Avoid putting a bad page back on the LRU v7
Date: Tue, 22 Jul 2008 12:42:10 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, tglx@linutronix.de, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
References: <20080718203606.GE29621@sgi.com>
In-Reply-To: <20080718203606.GE29621@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221242.10552.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 July 2008 06:36, Russ Anderson wrote:
> [PATCH 1/2] mm: Avoid putting a bad page back on the LRU v7
>
> Prevent a page with a physical memory error from being placed back
> on the LRU.  A new page flag (PG_memerror) is added if
> CONFIG_PAGEFLAGS_EXTENDED is defined.
>
> Signed-off-by: Russ Anderson <rja@sgi.com>
> Reviewed-by: Christoph Lameter <clameter@sgi.com>
>
> ---
>  include/linux/page-flags.h |   18 ++++++++++++++++--
>  mm/migrate.c               |   31 ++++++++++++++++++++++++++++++-
>  mm/page_alloc.c            |   13 ++++++++-----
>  3 files changed, 54 insertions(+), 8 deletions(-)
>
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c	2008-07-18 15:15:48.000000000 -0500
> +++ linux/mm/page_alloc.c	2008-07-18 15:16:09.000000000 -0500
> @@ -602,10 +602,10 @@ static int prep_new_page(struct page *pa
>  		bad_page(page);
>
>  	/*
> -	 * For now, we report if PG_reserved was found set, but do not
> -	 * clear it, and do not allocate the page: as a safety net.
> +	 * For now, we report if PG_reserved or PG_memerror was found set, but
> +	 * do not clear it, and do not allocate the page: as a safety net.
>  	 */
> -	if (PageReserved(page))
> +	if (PageReserved(page) || PageMemError(page))
>  		return 1;
>
>  	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
> @@ -2475,8 +2475,11 @@ static void setup_zone_migrate_reserve(s
>  			continue;
>  		page = pfn_to_page(pfn);
>
> -		/* Blocks with reserved pages will never free, skip them. */
> -		if (PageReserved(page))
> +		/*
> +		 * Blocks with reserved pages or memory errors will never
> +		 * free, skip them.
> +		 */
> +		if (PageReserved(page) || PageMemError(page))
>  			continue;
>
>  		block_migratetype = get_pageblock_migratetype(page);

I don't like adding more branches like this into fastpaths like this. It
would make a lot more sense to me if you just had some private module that
does the job of isolating the page from the lru and/or elevating their
refcount so that they do not get put back on freelists.

Migration may need something to perhaps allow migrations of pages not on
LRU lists but have PageMemError set which is OK, but I really don't like
adding code and branches to page_alloc.c if possible....

Thanks,
Nick
