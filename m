Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZDWW6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZDWW6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZDWW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:58:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581AbZDWW6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:58:32 -0400
Date: Thu, 23 Apr 2009 15:52:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mel@csn.ul.ie, linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com,
       peterz@infradead.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 09/22] Calculate the alloc_flags for allocation only
 once
Message-Id: <20090423155216.07ef773e.akpm@linux-foundation.org>
In-Reply-To: <1240408407-21848-10-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	<1240408407-21848-10-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 14:53:14 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

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
> Without care, this would allow recursion into the allocator via direct
> reclaim. This patch ensures we do not recurse when PF_MEMALLOC is set
> but TF_MEMDIE callers are now allowed to directly reclaim where they
> would have been prevented in the past.
> 
> ...
>
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
> +	} else if (unlikely(rt_task(p)))
> +		alloc_flags |= ALLOC_HARDER;
> +
> +	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> +		if (!in_interrupt() &&
> +		    ((p->flags & PF_MEMALLOC) ||
> +		     unlikely(test_thread_flag(TIF_MEMDIE))))
> +			alloc_flags |= ALLOC_NO_WATERMARKS;
> +	}
> +
> +	return alloc_flags;
> +}

hm.  Was there a particular reason for the explicit inline?

It's OK as it stands, but might become suboptimal if we later add a
second caller?

