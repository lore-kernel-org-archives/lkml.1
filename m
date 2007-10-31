Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbXJaE71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbXJaE71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXJaE7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:59:18 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:29795 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752979AbXJaE7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:59:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5xUNaSNXZ/nfMm9494NQ1CLr0bIht9eX/eBDffu5cHEZEODGZTQYethBUm0XleaIJ57I41ntMKKWRoiwuhNE50jG6JjzuqeXCGe3Xn0rVm4BB9N20RSoc0qBgQ2/2BhURsoAYP/eE+iwLoHW4cSgk8nFCzLfwaJ7hWvx//nCeJw=  ;
X-YMail-OSG: pm9y8LwVM1lTP_gwNiXzr9o6_d4Z2X5tR8aVcbh8oxnUa6nApPIBhJxkWUOFUsOaGNNdbomoGhAbc8hahh5PDOp4WVK22hG5Ne9WZWIQ6h02FVoVv4g-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 09/33] mm: system wide ALLOC_NO_WATERMARK
Date: Wed, 31 Oct 2007 14:52:35 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <20071030160912.283002000@chello.nl>
In-Reply-To: <20071030160912.283002000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311452.36239.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> Change ALLOC_NO_WATERMARK page allocation such that the reserves are system
> wide - which they are per setup_per_zone_pages_min(), when we scrape the
> barrel, do it properly.
>

IIRC it's actually not too uncommon to have allocations coming here via
page reclaim. It's not exactly clear that you want to break mempolicies
at this point.


> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/page_alloc.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -1638,6 +1638,12 @@ restart:
>  rebalance:
>  	if (alloc_flags & ALLOC_NO_WATERMARKS) {
>  nofail_alloc:
> +		/*
> +		 * break out of mempolicy boundaries
> +		 */
> +		zonelist = NODE_DATA(numa_node_id())->node_zonelists +
> +			gfp_zone(gfp_mask);
> +
>  		/* go through the zonelist yet again, ignoring mins */
>  		page = get_page_from_freelist(gfp_mask, order, zonelist,
>  				ALLOC_NO_WATERMARKS);
>
> --
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
