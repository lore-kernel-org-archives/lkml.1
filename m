Return-Path: <linux-kernel-owner+w=401wt.eu-S932358AbZJPTHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbZJPTHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932128AbZJPTHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:07:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbZJPTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:07:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Z/eEyW1TNsgPiURWZfKujvCYm2V4pjO+Qe5jC0EooMawjafwhMXezl+eU4i0Sc5n8
	zQMfwAKE9vE1iIXx1Rr2w==
Date: Fri, 16 Oct 2009 12:07:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] page allocator: Direct reclaim should always obey
 watermarks
In-Reply-To: <1255689446-3858-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.00.0910161204140.21328@chino.kir.corp.google.com>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie> <1255689446-3858-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Mel Gorman wrote:

> ALLOC_NO_WATERMARKS should be cleared when trying to allocate from the
> free-lists after a direct reclaim. If it's not, __GFP_NOFAIL allocations
> from a process that is exiting can ignore watermarks. __GFP_NOFAIL is not
> often used but the journal layer is one of those places. This is suspected of
> causing an increase in the number of GFP_ATOMIC allocation failures reported.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index dfa4362..a3e5fed 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1860,7 +1860,8 @@ rebalance:
>  	page = __alloc_pages_direct_reclaim(gfp_mask, order,
>  					zonelist, high_zoneidx,
>  					nodemask,
> -					alloc_flags, preferred_zone,
> +					alloc_flags & ~ALLOC_NO_WATERMARKS,
> +					preferred_zone,
>  					migratetype, &did_some_progress);
>  	if (page)
>  		goto got_pg;

I don't get it.  __alloc_pages_high_priority() will already loop 
indefinitely if ALLOC_NO_WATERMARKS is set and its a __GFP_NOFAIL 
allocation.  How do we even reach this code in such a condition?
