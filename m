Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZBWXBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZBWXBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZBWXBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:01:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbZBWXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:01:05 -0500
Date: Mon, 23 Feb 2009 14:59:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mel@csn.ul.ie, linux-mm@kvack.org, penberg@cs.helsinki.fi, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org,
       hannes@cmpxchg.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] mm: gfp_to_alloc_flags()
Message-Id: <20090223145936.ba2b51e7.akpm@linux-foundation.org>
In-Reply-To: <1235390103.4645.80.camel@laptop>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	<1235390103.4645.80.camel@laptop>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 12:55:03 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> +static int gfp_to_alloc_flags(gfp_t gfp_mask)
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

This could be sped up by making ALLOC_HIGH==__GFP_HIGH (hack)

> +	if (!wait) {
> +		alloc_flags |= ALLOC_HARDER;
> +		/*
> +		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
> +		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> +		 */
> +		alloc_flags &= ~ALLOC_CPUSET;
> +	} else if (unlikely(rt_task(p)) && !in_interrupt())
> +		alloc_flags |= ALLOC_HARDER;
> +
> +	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> +		if (!in_interrupt() &&
> +		    ((p->flags & PF_MEMALLOC) ||
> +		     unlikely(test_thread_flag(TIF_MEMDIE))))
> +			alloc_flags |= ALLOC_NO_WATERMARKS;
> +	}
> +	return alloc_flags;
> +}


But really, the whole function can be elided on the fastpath.  Try the
allocation with the current flags (and __GFP_NOWARN) and only if it
failed will we try altering the flags to try harder?

