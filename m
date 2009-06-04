Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZFDEgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZFDEgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 00:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFDEfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 00:35:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:9709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbZFDEfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 00:35:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,302,1241420400"; 
   d="scan'208";a="150464964"
Date: Thu, 4 Jun 2009 12:35:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [9/16] HWPOISON: Handle hardware poisoned pages in
	try_to_unmap
Message-ID: <20090604043541.GC15682@localhost>
References: <20090603846.816684333@firstfloor.org> <20090603184642.BD4B91D0291@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603184642.BD4B91D0291@basil.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 02:46:42AM +0800, Andi Kleen wrote:
> 
> When a page has the poison bit set replace the PTE with a poison entry. 
> This causes the right error handling to be done later when a process runs 
> into it.
> 
> Also add a new flag to not do that (needed for the memory-failure handler
> later)
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/rmap.h |    1 +
>  mm/rmap.c            |    9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> Index: linux/mm/rmap.c
> ===================================================================
> --- linux.orig/mm/rmap.c	2009-06-03 19:36:23.000000000 +0200
> +++ linux/mm/rmap.c	2009-06-03 20:39:49.000000000 +0200
> @@ -943,7 +943,14 @@
>  	/* Update high watermark before we lower rss */
>  	update_hiwater_rss(mm);
>  
> -	if (PageAnon(page)) {
> +	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
> +		if (PageAnon(page))
> +			dec_mm_counter(mm, anon_rss);
> +		else if (!is_migration_entry(pte_to_swp_entry(*pte)))
> +			dec_mm_counter(mm, file_rss);
> +		set_pte_at(mm, address, pte,
> +				swp_entry_to_pte(make_hwpoison_entry(page)));
> +	} else if (PageAnon(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };
>  
>  		if (PageSwapCache(page)) {
> Index: linux/include/linux/rmap.h
> ===================================================================
> --- linux.orig/include/linux/rmap.h	2009-06-03 19:36:23.000000000 +0200
> +++ linux/include/linux/rmap.h	2009-06-03 19:36:23.000000000 +0200
> @@ -93,6 +93,7 @@
>  
>  	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
>  	TTU_IGNORE_ACCESS = (1 << 9),	/* don't age */
> +	TTU_IGNORE_HWPOISON = (1 << 10),/* corrupted page is recoverable */

Or more precisely comment it as "corrupted data is recoverable"?
