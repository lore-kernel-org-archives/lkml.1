Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbZDUJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbZDUJDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZDUJDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 05:03:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60035 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZDUJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 05:03:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 10/25] Calculate the alloc_flags for allocation only once
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-11-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-11-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421165022.F13F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 18:03:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Factor out the mapping between GFP and alloc_flags only once. Once factored
> out, it only needs to be calculated once but some care must be taken.
> 
> [neilb@suse.de says]
> As the test:
> 
> -       if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> -                       && !in_interrupt()) {
> -               if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> 
> has been replaced with a slightly weaker one:
> 
> +       if (alloc_flags & ALLOC_NO_WATERMARKS) {
> 
> we need to ensure we don't recurse when PF_MEMALLOC is set.

It seems good idea.




> +static inline int
> +gfp_to_alloc_flags(gfp_t gfp_mask)
> +{
> +	struct task_struct *p = current;
> +	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
> +	const gfp_t wait = gfp_mask & __GFP_WAIT;
> +
> +	/*
> +	 * The caller may dip into page reserves a bit more if the caller
> +	 * cannot run direct reclaim, or if the caller has realtime scheduling
> +	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
> +	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
> +	 */
> +	if (gfp_mask & __GFP_HIGH)
> +		alloc_flags |= ALLOC_HIGH;
> +
> +	if (!wait) {
> +		alloc_flags |= ALLOC_HARDER;
> +		/*
> +		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
> +		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> +		 */
> +		alloc_flags &= ~ALLOC_CPUSET;
> +	} else if (unlikely(rt_task(p)) && !in_interrupt())

wait==1 and in_interrupt==1 is never occur.
I think in_interrupt check can be removed.


>  	/* Atomic allocations - we can't balance anything */
>  	if (!wait)
>  		goto nopage;
>  
> +	/* Avoid recursion of direct reclaim */
> +	if (p->flags & PF_MEMALLOC)
> +		goto nopage;
> +

Again. old code doesn't only check PF_MEMALLOC, but also check TIF_MEMDIE.


>  	/* Try direct reclaim and then allocating */
>  	page = __alloc_pages_direct_reclaim(gfp_mask, order,
>  					zonelist, high_zoneidx,
> -- 
> 1.5.6.5
> 



