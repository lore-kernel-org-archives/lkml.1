Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZDXKra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZDXKra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZDXKrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:47:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38793 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbZDXKrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:47:21 -0400
Date: Fri, 24 Apr 2009 11:47:17 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com,
       peterz@infradead.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 09/22] Calculate the alloc_flags for allocation only
	once
Message-ID: <20090424104716.GE14283@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-10-git-send-email-mel@csn.ul.ie> <20090423155216.07ef773e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090423155216.07ef773e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:52:16PM -0700, Andrew Morton wrote:
> On Wed, 22 Apr 2009 14:53:14 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Factor out the mapping between GFP and alloc_flags only once. Once factored
> > out, it only needs to be calculated once but some care must be taken.
> > 
> > [neilb@suse.de says]
> > As the test:
> > 
> > -       if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
> > -                       && !in_interrupt()) {
> > -               if (!(gfp_mask & __GFP_NOMEMALLOC)) {
> > 
> > has been replaced with a slightly weaker one:
> > 
> > +       if (alloc_flags & ALLOC_NO_WATERMARKS) {
> > 
> > Without care, this would allow recursion into the allocator via direct
> > reclaim. This patch ensures we do not recurse when PF_MEMALLOC is set
> > but TF_MEMDIE callers are now allowed to directly reclaim where they
> > would have been prevented in the past.
> > 
> > ...
> >
> > +static inline int
> > +gfp_to_alloc_flags(gfp_t gfp_mask)
> > +{
> > +	struct task_struct *p = current;
> > +	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
> > +	const gfp_t wait = gfp_mask & __GFP_WAIT;
> > +
> > +	/*
> > +	 * The caller may dip into page reserves a bit more if the caller
> > +	 * cannot run direct reclaim, or if the caller has realtime scheduling
> > +	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
> > +	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
> > +	 */
> > +	if (gfp_mask & __GFP_HIGH)
> > +		alloc_flags |= ALLOC_HIGH;
> > +
> > +	if (!wait) {
> > +		alloc_flags |= ALLOC_HARDER;
> > +		/*
> > +		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
> > +		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
> > +		 */
> > +		alloc_flags &= ~ALLOC_CPUSET;
> > +	} else if (unlikely(rt_task(p)))
> > +		alloc_flags |= ALLOC_HARDER;
> > +
> > +	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> > +		if (!in_interrupt() &&
> > +		    ((p->flags & PF_MEMALLOC) ||
> > +		     unlikely(test_thread_flag(TIF_MEMDIE))))
> > +			alloc_flags |= ALLOC_NO_WATERMARKS;
> > +	}
> > +
> > +	return alloc_flags;
> > +}
> 
> hm.  Was there a particular reason for the explicit inline?
> 

Only because it was known there was only one caller.

> It's OK as it stands, but might become suboptimal if we later add a
> second caller?
> 

This is true. As it is also in the slowpath and only called once, the
following patch should make no difference to performance but potentially
avoid a mistake later.

=======
Uninline gfp_to_alloc_flags() in the page allocator slow path

gfp_to_alloc_flags() is in the slowpath but inlined. While there is only one
caller now, a future second call would add suprising text-bloat. Uninline
it now to avoid surprises later as it should have no performance impact.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1c60141..f08b4cb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1639,7 +1639,7 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
 		wakeup_kswapd(zone, order);
 }
 
-static inline int
+static int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	struct task_struct *p = current;
