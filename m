Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZDXC5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZDXC5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZDXC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:57:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40781 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZDXC5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:57:08 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 02/22] Do not sanity check order in the fast path
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240508211.10627.139.camel@nimitz>
References: <20090423095821.GA25102@csn.ul.ie> <1240508211.10627.139.camel@nimitz>
Message-Id: <20090424115601.1061.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 24 Apr 2009 11:57:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2009-04-23 at 10:58 +0100, Mel Gorman wrote:
> > > How about this:  I'll go and audit the use of order in page_alloc.c to
> > > make sure that having an order>MAX_ORDER-1 floating around is OK and
> > > won't break anything. 
> > 
> > Great. Right now, I think it's ok but I haven't audited for this
> > explicily and a second set of eyes never hurts.
> 
> OK, after looking through this, I have a couple of ideas.  One is that
> we do the MAX_ORDER check in __alloc_pages_internal(), but *after* the
> first call to get_page_from_freelist().  That's because I'm worried if
> we ever got into the reclaim code with a >MAX_ORDER 'order'.  Such as:
> 
> void wakeup_kswapd(struct zone *zone, int order)
> {
> ...
>         if (pgdat->kswapd_max_order < order)
>                 pgdat->kswapd_max_order = order;
>         if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>                 return;
>         if (!waitqueue_active(&pgdat->kswapd_wait))
>                 return;
>         wake_up_interruptible(&pgdat->kswapd_wait);
> }
> 
> unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>                                 gfp_t gfp_mask, nodemask_t *nodemask)
> {
>         struct scan_control sc = {
> ...
>                 .order = order,
>                 .mem_cgroup = NULL,
>                 .isolate_pages = isolate_pages_global,
>                 .nodemask = nodemask,
>         };
> 
>         return do_try_to_free_pages(zonelist, &sc);
> }
> 
> This will keep us only checking 'order' once for each
> alloc_pages_internal() call.  It is an extra branch, but it is out of
> the really, really hot path since we're about to start reclaim here
> anyway.
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e2f2699..1e3a01e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1498,6 +1498,13 @@ restart:
>  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
>  	if (page)
>  		goto got_pg;
> +	/*
> +	 * We're out of the rocket-hot area above, so do a quick sanity
> +	 * check.  We do this here to avoid ever trying to do any reclaim
> +	 * of >=MAX_ORDER areas which can never succeed, of course.
> +	 */
> +	if (order >= MAX_ORDER)
> +		goto nopage;
>  
>  	/*
>  	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and

Good point.
if (WARN_ON_ONCE(order >= MAX_ORDER)) is better?



