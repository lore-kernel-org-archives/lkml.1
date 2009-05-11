Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbZEKWR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbZEKWR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbZEKWRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:17:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756878AbZEKWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:17:17 -0400
Date: Mon, 11 May 2009 15:11:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090511151130.9a949cb7.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com>
	<20090511142936.dd68005b.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 14:45:18 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 11 May 2009, Andrew Morton wrote:
> 
> > > The oom killer must be invoked regardless of the order if the allocation
> > > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > > free some memory.
> > 
> > We should discourage callers from using __GFP_NOFAIL at all.  We should
> > electrocute callers for using __GFP_NOFAIL on large allocations.  How's about
> > 
> > 	WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER &&	
> > 			(gfp_mask & __GFP_NOFAIL));
> > or, preferably:
> > 
> > 	WARN_ON_ONCE(order > 0 && (gfp_mask & __GFP_NOFAIL));
> > 
> 
> Not sure it would help since the oom killer will be now be called for such 
> an allocation and that dumps the stack (and will actually show the order 
> and gfp flags as well).

No, the intent of that warning is to find all call sites which use
__GFP_NOFAIL on order>0 so we can hunt down and eliminate them.


please review...

From: Andrew Morton <akpm@linux-foundation.org>

__GFP_NOFAIL is a bad fiction.  Allocations _can_ fail, and callers should
detect and suitably handle this (and not by lamely moving the infinite
loop up to the caller level either).

Attempting to use __GFP_NOFAIL for a higher-order allocation is even
worse, so add a once-off runtime check for this to slap people around for
even thinking about trying it.

Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~a mm/page_alloc.c
--- a/mm/page_alloc.c~a
+++ a/mm/page_alloc.c
@@ -1201,8 +1201,19 @@ static int should_fail_alloc_page(gfp_t 
 {
 	if (order < fail_page_alloc.min_order)
 		return 0;
-	if (gfp_mask & __GFP_NOFAIL)
+	if (gfp_mask & __GFP_NOFAIL) {
+		/*
+		 * __GFP_NOFAIL is not to be used in new code.
+		 *
+		 * All __GFP_NOFAIL callers should be fixed so that they
+		 * properly detect and handle allocation failures.
+		 *
+		 * We most definitely don't want callers attempting to allocate
+		 * greater than single-page units with __GFP_NOFAIL.
+		 */
+		WARN_ON_ONCE(order > 0);
 		return 0;
+	}
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return 0;
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
_


