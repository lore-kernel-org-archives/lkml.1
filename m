Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab0BEVHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:07:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:57861 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933834Ab0BEVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:07:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=huO1RqMDR7TGXepcd1w6s3nSNDfkWPxwtFEB1wWnRnFsMVgGfIaF+ex6bwEwfB41C
	nlwQLnvIbjbMPBc0jfTdA==
Date: Fri, 5 Feb 2010 13:06:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in
 fallback_alloc()
In-Reply-To: <20100203213912.D3081B1620@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002051251390.2376@chino.kir.corp.google.com>
References: <201002031039.710275915@firstfloor.org> <20100203213912.D3081B1620@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Andi Kleen wrote:

> When fallback_alloc() runs the node of the CPU might not be initialized yet.
> Handle this case by allocating in another node.
> 

That other node must be allowed by current's cpuset, otherwise 
kmem_getpages() will fail when get_page_from_freelist() iterates only over 
unallowed nodes.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/slab.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.33-rc3-ak/mm/slab.c
> ===================================================================
> --- linux-2.6.33-rc3-ak.orig/mm/slab.c
> +++ linux-2.6.33-rc3-ak/mm/slab.c
> @@ -3210,7 +3210,24 @@ retry:
>  		if (local_flags & __GFP_WAIT)
>  			local_irq_enable();
>  		kmem_flagcheck(cache, flags);
> -		obj = kmem_getpages(cache, local_flags, numa_node_id());
> +
> +		/*
> +		 * Node not set up yet? Try one that the cache has been set up
> +		 * for.
> +		 */
> +		nid = numa_node_id();
> +		if (cache->nodelists[nid] == NULL) {
> +			for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
> +				nid = zone_to_nid(zone);
> +				if (cache->nodelists[nid])
> +					break;

If you set a bit in a nodemask_t everytime ____cache_alloc_node() fails in 
the previous for_each_zone_zonelist() iteration, you could just iterate 
that nodemask here without duplicating the zone_to_nid() and 
cache->nodelists[nid] != NULL check.

	nid = numa_node_id();
	if (!cache->nodelists[nid])
		for_each_node_mask(nid, allowed_nodes) {
			obj = kmem_getpages(cache, local_flags, nid);
			if (obj)
				break;
		}
	else
		obj = kmem_getpages(cache, local_flags, nid);

This way you can try all allowed nodes for memory instead of just one when 
cache->nodelists[numa_node_id()] == NULL.

> +			}
> +			if (!cache->nodelists[nid])
> +				return NULL;
> +		}
> +
> +
> +		obj = kmem_getpages(cache, local_flags, nid);
>  		if (local_flags & __GFP_WAIT)
>  			local_irq_disable();
>  		if (obj) {
