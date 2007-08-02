Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbXHBUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbXHBUpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXHBUpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:45:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36069 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751850AbXHBUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:45:24 -0400
Date: Thu, 2 Aug 2007 13:45:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@linux-foundation.org, pj@sgi.com, Lee.Schermerhorn@hp.com,
       kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Apply memory policies to top two highest zones when
 highest zone is ZONE_MOVABLE
In-Reply-To: <20070802172118.GD23133@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708021343420.10244@schroedinger.engr.sgi.com>
References: <20070802172118.GD23133@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Mel Gorman wrote:

> +#ifdef CONFIG_NUMA
> +/*
> + * Only custom zonelists like MPOL_BIND need to be filtered as part of
> + * policies. As described in the comment for struct zonelist_cache, these
> + * zonelists will not have a zlcache so zlcache_ptr will not be set. Use
> + * that to determine if the zonelists needs to be filtered or not.
> + */
> +static inline int alloc_should_filter_zonelist(struct zonelist *zonelist)
> +{
> +	return !zonelist->zlcache_ptr;
> +}

I guess Paul needs to have a look at this one.

Otherwise

Acked-by: Christoph Lameter <clameter@sgi.com>

> @@ -1166,6 +1167,18 @@ zonelist_scan:
>  	z = zonelist->zones;
>  
>  	do {
> +		/*
> +		 * In NUMA, this could be a policy zonelist which contains
> +		 * zones that may not be allowed by the current gfp_mask.
> +		 * Check the zone is allowed by the current flags
> +		 */
> +		if (unlikely(alloc_should_filter_zonelist(zonelist))) {
> +			if (highest_zoneidx == -1)
> +				highest_zoneidx = gfp_zone(gfp_mask);
> +			if (zone_idx(*z) > highest_zoneidx)
> +				continue;
> +		}
> +
>  		if (NUMA_BUILD && zlc_active &&

Hotpath. Sigh.
