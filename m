Return-Path: <linux-kernel-owner+w=401wt.eu-S1759843AbZBKAtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843AbZBKAtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757939AbZBKAaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:30:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757972AbZBKAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:30:00 -0500
Date: Tue, 10 Feb 2009 16:29:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: initialize sc.order in indirect shrink_list()
 users
Message-Id: <20090210162948.bd20d853.akpm@linux-foundation.org>
In-Reply-To: <20090210165134.GA2457@cmpxchg.org>
References: <20090210165134.GA2457@cmpxchg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 17:51:35 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> shrink_all_memory() and __zone_reclaim() currently don't initialize
> the .order field of their scan control.
> 
> Both of them call into functions which use that field and make certain
> decisions based on a random value.
> 
> The functions depending on the .order field are marked with a star,
> the faulty entry points are marked with a percentage sign:
> 
> * shrink_page_list()
>   * shrink_inactive_list()
>   * shrink_active_list()
>     shrink_list()
>       shrink_all_zones()
>         % shrink_all_memory()
>       shrink_zone()
>         % __zone_reclaim()
> 
> Initialize .order to zero in shrink_all_memory().  Initialize .order
> to the order parameter in __zone_reclaim().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4422301..9ce85ea 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2112,6 +2112,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
>  		.may_unmap = 0,
>  		.swap_cluster_max = nr_pages,
>  		.may_writepage = 1,
> +		.order = 0,
>  		.isolate_pages = isolate_pages_global,
>  	};
>  
> @@ -2294,6 +2295,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  					SWAP_CLUSTER_MAX),
>  		.gfp_mask = gfp_mask,
>  		.swappiness = vm_swappiness,
> +		.order = order,
>  		.isolate_pages = isolate_pages_global,
>  	};
>  	unsigned long slab_reclaimable;

The second hunk might fix something, but it would need a correcter
changelog, and some thought about what its runtimes effects are likely
to be, please.

