Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbYCQUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbYCQUVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbYCQUVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:21:01 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40007 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYCQUVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:21:00 -0400
Subject: Re: [PATCH] [2/18] Add basic support for more than one hstate in
	hugetlbfs
From: Adam Litke <agl@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317015815.D43991B41E0@basil.firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
	 <20080317015815.D43991B41E0@basil.firstfloor.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 17 Mar 2008 20:22:44 +0000
Message-Id: <1205785364.10849.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-17 at 02:58 +0100, Andi Kleen wrote:
> - Convert hstates to an array
> - Add a first default entry covering the standard huge page size
> - Add functions for architectures to register new hstates
> - Add basic iterators over hstates
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
<snip>
> @@ -497,11 +501,34 @@ static int __init hugetlb_init(void)
>  			break;
>  	}
>  	max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
> -	printk("Total HugeTLB memory allocated, %ld\n", h->free_huge_pages);
> +
> +	printk(KERN_INFO "Total HugeTLB memory allocated, %ld %dMB pages\n",
> +			h->free_huge_pages,
> +			1 << (h->order + PAGE_SHIFT - 20));
>  	return 0;
>  }

I'd like to avoid assuming the huge page size is some multiple of MB.
PowerPC will have a 64KB huge page.  Granted, you do fix this in a later
patch, so as long as the whole series goes together this shouldn't cause
a problem.

> +
> +static int __init hugetlb_init(void)
> +{
> +	if (HPAGE_SHIFT == 0)
> +		return 0;
> +	return hugetlb_init_hstate(&global_hstate);
> +}
>  module_init(hugetlb_init);
> 
> +/* Should be called on processing a hugepagesz=... option */
> +void __init huge_add_hstate(unsigned order)
> +{
> +	struct hstate *h;
> +	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
> +	BUG_ON(order <= HPAGE_SHIFT - PAGE_SHIFT);
> +	h = &hstates[max_hstate++];
> +	h->order = order;
> +	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
> +	hugetlb_init_hstate(h);
> +	parsed_hstate = h;
> +}

Since mask can always be derived from order, is there a reason we don't
always calculate it?  I guess it boils down to storage cost vs.
calculation cost and I don't feel too strongly either way.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

