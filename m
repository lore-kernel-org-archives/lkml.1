Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbXKGCUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbXKGCUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbXKGCUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:20:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36024 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755153AbXKGCUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:20:44 -0500
Date: Tue, 6 Nov 2007 18:20:44 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/10] free swap space entries if vm_swap_full()
In-Reply-To: <20071103185447.358b9c4a@bree.surriel.com>
Message-ID: <Pine.LNX.4.64.0711061818360.5249@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
 <20071103185447.358b9c4a@bree.surriel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Rik van Riel wrote:

> @@ -1142,14 +1145,13 @@ force_reclaim_mapped:
>  		}
>  	}
>  	__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
> +	spin_unlock_irq(&zone->lru_lock);
>  	pgdeactivate += pgmoved;
> -	if (buffer_heads_over_limit) {
> -		spin_unlock_irq(&zone->lru_lock);
> -		pagevec_strip(&pvec);
> -		spin_lock_irq(&zone->lru_lock);
> -	}
>  
> +	if (buffer_heads_over_limit)
> +		pagevec_strip(&pvec);
>  	pgmoved = 0;
> +	spin_lock_irq(&zone->lru_lock);
>  	while (!list_empty(&l_active)) {
>  		page = lru_to_page(&l_active);
>  		prefetchw_prev_lru_page(page, &l_active, flags);

Why are we dropping the lock here now? There would be less activity
on the lru_lock if we would only drop it if necessary.

> @@ -1163,6 +1165,8 @@ force_reclaim_mapped:
>  			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
>  			pgmoved = 0;
>  			spin_unlock_irq(&zone->lru_lock);
> +			if (vm_swap_full())
> +				pagevec_swap_free(&pvec);
>  			__pagevec_release(&pvec);
>  			spin_lock_irq(&zone->lru_lock);
>  		}

Same here. Maybe the spin_unlock and the spin_lock can go into
pagevec_swap_free?
