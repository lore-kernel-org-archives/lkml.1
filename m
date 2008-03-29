Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYC2Uoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYC2Uoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbYC2Uo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:44:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53751 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754168AbYC2Uo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:44:28 -0400
Date: Sat, 29 Mar 2008 13:42:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803291330190.26394@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl>
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803281128480.17805@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803281214580.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Linus Torvalds wrote:

> .. where kmap_atomic() on x86 does:
> 
> 	kmap_atomic() ->
> 	  kmap_atomic_prot() ->
> 	    debug_kmap_atomic_prot() ->
> 	      if (in_irq())
> 	        WARN_ON_ONCE()
> 
> none of which are at all conditional on __GFP_HIGHMEM.

kmap check for PageHighmem and does not do a kmap for regular pages.
So this is actually okay. If the allocation that was performed does not 
allow GFP_HIGHMEM then the kmap will never use a real mapping. The check 
should not trigger.

> > Then clear_highpage calls additional checking functions that have 
> > the effect of generally forbiding zeroing in interrupt context if 
> > CONFIG_HIGHMEM is set. This is wrong and needs to be fixed.
> 
> No. Dammit, the bug is in SLUB.
> 
> If SLUB *ever* calls the page allocator with __GFP_ZERO set, it's a 
> bug, and that has nothing to do with GFP_ATOMIC or anything else. Because 
> SLUB uses its own logic for clearing the result.

Yes it uses its own logic if the object is managed by SLUB but not if the 
object is too big and/or the allocation forwarded to the page allocator 
or for other internal allocations of buffers etc.
 
> Why cannot you just admit it?

Admitting something that is not true is rather difficult.

> Now, _outside_ of SLUB there appear to be other users too, and those users 
> need to either be fixed or we need to allow __GFP_ZERO togethe with 
> GFP_ATOMIC. But the fact is, SLUB had a really stupid bug that it 
> shouldn't have had.

So what you want is to forbid any use of

	alloc_pages(__GFP_ZERO|...)

from an interrupt context? That works fine on most platforms and used to 
work fine on x86 as well until the check was added on January 30th.

If we really want this then the check in prep_zero_page should be changed 
too:

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2008-03-29 13:40:42.166669333 -0700
+++ linux-2.6/mm/page_alloc.c	2008-03-29 13:41:21.039168276 -0700
@@ -317,7 +317,7 @@ static inline void prep_zero_page(struct
 	 * clear_highpage() will use KM_USER0, so it's a bug to use __GFP_ZERO
 	 * and __GFP_HIGHMEM from hard or soft interrupt context.
 	 */
-	VM_BUG_ON((gfp_flags & __GFP_HIGHMEM) && in_interrupt());
+	VM_BUG_ON(in_interrupt());
 	for (i = 0; i < (1 << order); i++)
 		clear_highpage(page + i);
 }
