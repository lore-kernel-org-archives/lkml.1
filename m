Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbYFWIBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbYFWIBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYFWIAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:00:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39871 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYFWIAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:00:51 -0400
Date: Mon, 23 Jun 2008 09:00:48 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] hugetlb reservations: fix hugetlb MAP_PRIVATE reservations across vma splits
Message-ID: <20080623080048.GJ21597@csn.ul.ie>
References: <1213989474-5586-1-git-send-email-apw@shadowen.org> <1213989474-5586-3-git-send-email-apw@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1213989474-5586-3-git-send-email-apw@shadowen.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typical. I spotted this after I pushed send.....

> <SNIP>

> @@ -266,14 +326,19 @@ static void decrement_hugepage_resv_vma(struct hstate *h,
>  		 * private mappings.
>  		 */
>  		if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
> -			unsigned long flags, reserve;
> +			unsigned long idx = vma_pagecache_offset(h,
> +							vma, address);
> +			struct resv_map *reservations = vma_resv_map(vma);
> +
>  			h->resv_huge_pages--;
> -			flags = (unsigned long)vma->vm_private_data &
> -							HPAGE_RESV_MASK;
> -			reserve = (unsigned long)vma->vm_private_data - 1;
> -			vma->vm_private_data = (void *)(reserve | flags);
> +
> +			/* Mark this page used in the map. */
> +			if (region_chg(&reservations->regions, idx, idx + 1) < 0)
> +				return -1;
> +			region_add(&reservations->regions, idx, idx + 1);
>  		}

decrement_hugepage_resv_vma() is called with hugetlb_lock held and region_chg
calls kmalloc(GFP_KERNEL).  Hence it's possible we would sleep with that
spinlock held which is a bit uncool. The allocation needs to happen outside
the lock. Right?

> <SNIP>

-- 
Mel Gorman
