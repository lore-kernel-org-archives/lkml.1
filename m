Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZDUHV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZDUHV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZDUHVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:21:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47360 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDUHVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:21:15 -0400
Subject: Re: [PATCH 07/25] Check in advance if the zonelist needs
 additional filtering
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-8-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-8-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 10:21:12 +0300
Message-Id: <1240298472.771.29.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> Zonelist are filtered based on nodemasks for memory policies normally.
> It can be additionally filters on cpusets if they exist as well as
> noting when zones are full. These simple checks are expensive enough to
> be noticed in profiles. This patch checks in advance if zonelist
> filtering will ever be needed. If not, then the bulk of the checks are
> skipped.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> @@ -1401,6 +1405,7 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
>  	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
>  	int zlc_active = 0;		/* set if using zonelist_cache */
>  	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
> +	int zonelist_filter = 0;
>  
>  	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
>  							&preferred_zone);
> @@ -1411,6 +1416,10 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
>  
>  	VM_BUG_ON(order >= MAX_ORDER);
>  
> +	/* Determine in advance if the zonelist needs filtering */
> +	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
> +		zonelist_filter = 1;
> +
>  zonelist_scan:
>  	/*
>  	 * Scan zonelist, looking for a zone with enough free.
> @@ -1418,12 +1427,16 @@ zonelist_scan:
>  	 */
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  						high_zoneidx, nodemask) {
> -		if (NUMA_BUILD && zlc_active &&
> -			!zlc_zone_worth_trying(zonelist, z, allowednodes))
> -				continue;
> -		if ((alloc_flags & ALLOC_CPUSET) &&
> -			!cpuset_zone_allowed_softwall(zone, gfp_mask))
> -				goto try_next_zone;
> +
> +		/* Ignore the additional zonelist filter checks if possible */
> +		if (zonelist_filter) {
> +			if (NUMA_BUILD && zlc_active &&
> +				!zlc_zone_worth_trying(zonelist, z, allowednodes))
> +					continue;
> +			if ((alloc_flags & ALLOC_CPUSET) &&

The above expression is always true here because of the earlier
zonelists_filter check, no?

> +				!cpuset_zone_allowed_softwall(zone, gfp_mask))
> +					goto try_next_zone;
> +		}
>  
>  		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
>  			unsigned long mark;


