Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbYEBBWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbYEBBWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbYEBBWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:22:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53285 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753676AbYEBBW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:22:29 -0400
Date: Thu, 1 May 2008 18:22:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v2
In-Reply-To: <20080502004425.GD12006@sgi.com>
Message-ID: <Pine.LNX.4.64.0805011818100.13527@schroedinger.engr.sgi.com>
References: <20080502004425.GD12006@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Russ Anderson wrote:

> +int
> +freeOneBadPage(unsigned long paddr)
> +{
> +	struct page *page, *page2, *target;
> +
> +	/*
> +	 * Verify page address
> +	 */
> +	target = phys_to_page(paddr);
> +	list_for_each_entry_safe(page, page2, &badpagelist, lru) {
> +		if (page != target)
> +			continue;
> +
> +		ClearPageMemError(page);        /* Mark the page as good */
> +		move_to_lru(page);
> +		list_del(&page->lru);

This is the wrong order. move_to_lru() uses the lru field. So do the 
list_del first then the move. Note that there is a function 
putback_lru_pages() that is used to put a list of pages back to the lru if 
migration has failed and we give up on them. Could you use 
putback_lru_pages() and then avoid the exporting of move_to_lru()?


> +
> +int
> +freeAllBadPages(void)
> +{
> +	struct page *page, *page2;
> +
> +	list_for_each_entry_safe(page, page2, &badpagelist, lru) {
> +		ClearPageMemError(page);        /* Mark the page as good */
> +		totalbad_pages--;
> +	}
> +	putback_lru_pages(&badpagelist);
> +	return 0;
> +}

Ahh.. Here you use it.

> Index: linus/include/asm-ia64/page.h
> ===================================================================
> --- linus.orig/include/asm-ia64/page.h	2008-05-01 19:36:40.000000000 -0500
> +++ linus/include/asm-ia64/page.h	2008-05-01 19:36:49.000000000 -0500
> @@ -122,6 +122,7 @@ extern unsigned long max_low_pfn;
>  #endif
>  
>  #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
> +#define	phys_to_page(kaddr)	(pfn_to_page(kaddr >> PAGE_SHIFT))

#define phys_to_page virt_to_page ?

