Return-Path: <linux-kernel-owner+w=401wt.eu-S1759599AbZFXSnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599AbZFXSnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbZFXSmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:42:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbZFXSmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:42:51 -0400
Date: Wed, 24 Jun 2009 11:42:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <20090624113037.7d72ed59.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi>
 <20090624113037.7d72ed59.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Andrew Morton wrote:
> 
> hm, I didn't know that slub could fall back to lower-order allocations
> like that.  Neat.

Slab doesn't do it, though. So we still need to get rid of the "order-1" 
warning, at least (slab_break_gfp_order).

> What's the expected value of s->min in allocate_slab()?  In what
> situations would it be >0?

For slub, s->min has an order of just "get_order(size)" (ie the minimum 
order to fit an object).

For slab, the logic is different, but if I read the code correctly it 
boils down to the minimum order, except that order-1 is accepted instead 
of order-0 (strictly speaking, that only happens if you have more than 
64MB of RAM). With no fallback.

And it's quite reasonable to expect to be able to do small kmalloc's 
without failing.

So I'd suggest just doing this..

			Linus
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index aecc9cd..5d714f8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1153,10 +1153,10 @@ again:
 			 * properly detect and handle allocation failures.
 			 *
 			 * We most definitely don't want callers attempting to
-			 * allocate greater than single-page units with
+			 * allocate greater than order-1 page units with
 			 * __GFP_NOFAIL.
 			 */
-			WARN_ON_ONCE(order > 0);
+			WARN_ON_ONCE(order > 1);
 		}
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
