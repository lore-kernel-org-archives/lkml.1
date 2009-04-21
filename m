Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZDUHiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZDUHiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZDUHhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:37:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54565 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZDUHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:37:40 -0400
Subject: Re: [PATCH 08/25] Calculate the preferred zone for allocation only
 once
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
In-Reply-To: <1240266011-11140-9-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
	 <1240266011-11140-9-git-send-email-mel@csn.ul.ie>
Date: Tue, 21 Apr 2009 10:37:37 +0300
Message-Id: <1240299457.771.42.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> get_page_from_freelist() can be called multiple times for an
> allocation.
> Part of this calculates the preferred_zone which is the first usable
> zone in the zonelist. This patch calculates preferred_zone once.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> @@ -1772,11 +1774,20 @@ __alloc_pages_nodemask(gfp_t gfp_mask,
> unsigned int order,
>  	if (unlikely(!zonelist->_zonerefs->zone))
>  		return NULL;
>  
> +	/* The preferred zone is used for statistics later */
> +	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
> +							&preferred_zone);
> +	if (!preferred_zone)
> +		return NULL;

You might want to add an explanation to the changelog why this change is
safe. It looked like a functional change at first glance and it was
pretty difficult to convince myself that __alloc_pages_slowpath() will
always return NULL when there's no preferred zone because of the other
cleanups in this patch series.

> +
> +	/* First allocation attempt */
>  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> -			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
> +			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
> +			preferred_zone);
>  	if (unlikely(!page))
>  		page = __alloc_pages_slowpath(gfp_mask, order,
> -				zonelist, high_zoneidx, nodemask);
> +				zonelist, high_zoneidx, nodemask,
> +				preferred_zone);
>  
>  	return page;
>  }

