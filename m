Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZJVK64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZJVK64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZJVK6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:58:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34760 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZJVK6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:58:54 -0400
Date: Thu, 22 Oct 2009 11:59:02 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephan von Krawczynski <skraw@ithnet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: page allocation failure message kernel 2.6.31.4 (tty-related)
Message-ID: <20091022105902.GM11778@csn.ul.ie>
References: <20091020153838.665bc39c.skraw@ithnet.com> <alpine.LRH.2.00.0910211848510.20992@twin.jikos.cz> <alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 02:16:56PM -0700, David Rientjes wrote:
> On Wed, 21 Oct 2009, Jiri Kosina wrote:
> 
> > [ tty related CCs added ]
> > 
> 
> I think this is probably a duplicate of the GFP_ATOMIC page allocator 
> issue at http://bugzilla.kernel.org/show_bug.cgi?id=14141 more than a tty 
> issue.
> 

Probably.

> Have we tried rolling back the refactored page allocator changes in 2.6.31 
> to see if the logic has changed in other ways unrelated to kswapd?  

No, but bisects around that area were inconclusive at best and there
are dependants that made backing it out problematic.

> There's subtleties like where rt tasks are given ALLOC_HARDER even when 
> in_interrupt() that are different from previous kernels and could reduce 
> the amount of ALLOC_HIGH and ALLOC_HARDER memory that can be allocated.
> 

/me checks again

I think you're right. Correct it with something like?

==== CUT HERE ====
>From bca71e94e10cd93771ec5b17eccb817dd0c85360 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mel@csn.ul.ie>
Date: Thu, 22 Oct 2009 11:55:14 +0100
Subject: [PATCH] page allocator: Do not allow interrupts to use ALLOC_HARDER

Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
slightly by allowing rt_tasks that are handling an interrupt to set
ALLOC_HARDER. This patch brings the watermark logic more in line with
2.6.30.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a3e5fed..3ecf819 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1769,7 +1769,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)))
+	} else if (unlikely(rt_task(p)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
