Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0BOGEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:04:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab0BOGEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:04:08 -0500
Date: Mon, 15 Feb 2010 17:04:00 +1100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in
 fallback_alloc() v2
Message-ID: <20100215060400.GG5723@laptop>
References: <20100211953.850854588@firstfloor.org>
 <20100211205401.002CFB1978@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211205401.002CFB1978@basil.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 09:54:00PM +0100, Andi Kleen wrote:
> 
> When fallback_alloc() runs the node of the CPU might not be initialized yet.
> Handle this case by allocating in another node.
> 
> v2: Try to allocate from all nodes (David Rientjes)
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  mm/slab.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.32-memhotadd/mm/slab.c
> ===================================================================
> --- linux-2.6.32-memhotadd.orig/mm/slab.c
> +++ linux-2.6.32-memhotadd/mm/slab.c
> @@ -3188,7 +3188,24 @@ retry:
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
> +				if (cache->nodelists[nid]) {
> +					obj = kmem_getpages(cache, local_flags, nid);
> +					if (obj)
> +						break;
> +				}
> +			}
> +		} else
> +			obj = kmem_getpages(cache, local_flags, nid);
> +
>  		if (local_flags & __GFP_WAIT)
>  			local_irq_disable();
>  		if (obj) {

This is a better way to go anyway because it really is a proper
"fallback" alloc. I think that possibly used to work (ie. kmem_getpages
would be able to pass -1 for the node there) but got broken along the
line.

Although it's not such a hot path to begin with, care to put a branch
annotation there?

Acked-by: Nick Piggin <npiggin@suse.de>
