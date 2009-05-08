Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbZEHOex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbZEHOex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZEHOen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:34:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57847 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZEHOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:34:42 -0400
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
 allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, riel@redhat.com, rientjes@google.com,
       xemul@openvz.org
In-Reply-To: <alpine.DEB.1.10.0905081026210.21690@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>
	 <20090504131638.GJ4173@lenovo>
	 <alpine.DEB.1.10.0905040940490.9553@qirst.com>
	 <20090504115335.9bc08587.akpm@linux-foundation.org>
	 <20090504192117.GB31176@lenovo>
	 <20090504123453.d130a6cf.akpm@linux-foundation.org>
	 <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081018130.23875@qirst.com>
	 <1241792580.28600.41.camel@penberg-laptop>
	 <alpine.DEB.1.10.0905081026210.21690@qirst.com>
Date: Fri, 08 May 2009 17:34:41 +0300
Message-Id: <1241793281.28600.43.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 10:29 -0400, Christoph Lameter wrote:
> On Fri, 8 May 2009, Pekka Enberg wrote:
> 
> > On Fri, 8 May 2009, Pekka Enberg wrote:
> > > > +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY | __GFP_NOMEMALLOC)
> >
> > On Fri, 2009-05-08 at 10:20 -0400, Christoph Lameter wrote:
> > > So this means not retrying the allocation a couple of times? Not delving
> > > into reserve pools? Such behavior is good for a allocation that causes a
> > > panic if it fails?
> >
> > If you do GFP_KERNEL|GFP_PANIC, we will cond_resched() and retry if we
> > made some progress. So yes, I think the behavior is good for early-boot
> > call-sites that can't really fail anyway.
> 
> Better make sure that GFP_PANIC is only used during early boot then.
> 
> If memory is low on boot (due to node hotplug or some such thing, powerpc
> may do evil tricks here) then the panic may trigger after the patch.
> We would have just delved into the reserves a bit before.

Nah, it's probably better to drop __GFP_NOMEMALLOC instead. Does this
look better?

			Pekka

>From c91c70265545f2fcc727b4a0d37162b5aa0f5ecf Mon Sep 17 00:00:00 2001
From: Cyrill Gorcunov <gorcunov@openvz.org>
Date: Fri, 8 May 2009 15:44:50 +0300
Subject: [PATCH] mm: Introduce GFP_PANIC for non-failing allocations

This patch introduces a GFP_PANIC flag that can be used as an annotation
that a call to kmalloc() or alloc_pages() is expected to never fail.
This is useful in early boot code, for example.

To save one GFP flag bit, use a combination of __GFP_NOFAIL,
__GFP_NOREPEAT, and __GFP_NOMEMALLOC to make sure we always end up in
the "nopage" path of the page allocator if an allocation fails.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/gfp.h |    1 +
 mm/page_alloc.c     |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..b34e6e5 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -70,6 +70,7 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
+#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2f2699..de7f666 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1556,7 +1556,8 @@ nofail_alloc:
 				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);
 			if (page)
 				goto got_pg;
-			if (gfp_mask & __GFP_NOFAIL) {
+			/* GFP_PANIC sets both flags */
+			if ((gfp_mask & __GFP_NOFAIL) && !(gfp_mask & __GFP_NORETRY)) {
 				congestion_wait(WRITE, HZ/50);
 				goto nofail_alloc;
 			}
@@ -1670,6 +1671,9 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
+	if (unlikely(gfp_mask & GFP_PANIC))
+		panic("Out of memory: %s order: %d, gfp_mask:0x%x\n",
+			p->comm, order, gfp_mask);
 got_pg:
 	return page;
 }
-- 
1.5.6.3



