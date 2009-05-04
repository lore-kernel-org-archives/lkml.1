Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZEDIQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZEDIQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZEDIPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:15:01 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:3350 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087AbZEDIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J1qhNgDl58eTF0poFkmxeEuNQNp4v/CqaRAd3Y5y6aInNa235CxzVccwaVZ0z5oD9K
         DE/vticuojjV894SNvJcGSCLrGVUjoTkqAzwPGWsY9yD3cBpcfXACgxEJ0UdxsO1NibZ
         7duhg62SMFLaM0pp0FCGAa4I1hv5RCv5cAvrs=
Date: Mon, 4 May 2009 12:14:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: introducing __GFP_PANIC
Message-ID: <20090504081454.GA4173@lenovo>
References: <alpine.DEB.2.00.0905030203520.16287@chino.kir.corp.google.com> <84144f020905030259i59ea304ftdc9224e6a9b5c285@mail.gmail.com> <20090503121228.GC4615@lenovo> <1241353621.27683.3.camel@penberg-laptop> <20090503143824.GF4615@lenovo> <84144f020905030954m434d0550l3ed7ef7436c803df@mail.gmail.com> <20090503172338.GG4615@lenovo> <84144f020905031038n751b48afsaefc3765ed632f82@mail.gmail.com> <20090503204542.GJ4615@lenovo> <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905031357140.17811@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Sun, May 03, 2009 at 01:58:49PM -0700]
| On Mon, 4 May 2009, Cyrill Gorcunov wrote:
| 
| > @@ -1685,7 +1687,9 @@ nopage:
| >  		dump_stack();
| >  		show_mem();
| >  	}
| > -	return page;
| > +	if (unlikely(gfp_mask & __GFP_PANIC))
| > +		panic("Out of memory: panic due to __GFP_PANIC\n");
| > +	return NULL;
| >  got_pg:
| >  	if (kmemcheck_enabled)
| >  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
| > 
| 
| If we really want a __GFP_PANIC flag for this purpose, I'd recommend also 
| emitting the order and gfpmask in the panic() message since it may not be 
| immediately obvious from the caller.
|

Thanks for note, David!

Here is an updated version for review. I hope I've covered
all cases. Complains are welcome :)
 
	-- Cyrill
---
mm: introduce __GFP_PANIC

Sometime we need that memory obtained via kmalloc
should always be granted. If there is no enough
memory we just can't go further.

For such a case we introduce __GFP_PANIC panic
modificator. If memory can't be granted -- we just
panic.

Note that __GFP_PANIC implicitly turn off failslab
facility on such kind calls.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/linux/gfp.h      |   13 ++++++++++---
 include/linux/slab_def.h |    1 +
 mm/failslab.c            |    3 +++
 mm/page_alloc.c          |   17 +++++++++++++++--
 4 files changed, 29 insertions(+), 5 deletions(-)

Index: linux-2.6.git/include/linux/gfp.h
=====================================================================
--- linux-2.6.git.orig/include/linux/gfp.h
+++ linux-2.6.git/include/linux/gfp.h
@@ -7,6 +7,7 @@
 #include <linux/topology.h>
 
 struct vm_area_struct;
+void oom_panic(gfp_t gfp_mask, unsigned int order);
 
 /*
  * GFP bitmasks..
@@ -58,7 +59,9 @@ struct vm_area_struct;
 #define __GFP_NOTRACK	((__force gfp_t)0)
 #endif
 
-#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
+#define __GFP_PANIC	((__force gfp_t)0x400000u) /* Panic on page alloction failure */
+
+#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
@@ -196,8 +199,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	if (unlikely(order >= MAX_ORDER))
+	if (unlikely(order >= MAX_ORDER)) {
+		oom_panic(gfp_mask, order);
 		return NULL;
+	}
 
 	/* Unknown node is current node */
 	if (nid < 0)
@@ -212,8 +217,10 @@ extern struct page *alloc_pages_current(
 static inline struct page *
 alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
-	if (unlikely(order >= MAX_ORDER))
+	if (unlikely(order >= MAX_ORDER)) {
+		oom_panic(gfp_mask, order);
 		return NULL;
+	}
 
 	return alloc_pages_current(gfp_mask, order);
 }
Index: linux-2.6.git/include/linux/slab_def.h
=====================================================================
--- linux-2.6.git.orig/include/linux/slab_def.h
+++ linux-2.6.git/include/linux/slab_def.h
@@ -143,6 +143,7 @@ static __always_inline void *kmalloc(siz
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
+		oom_panic(flags, get_order(size));
 		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
Index: linux-2.6.git/mm/failslab.c
=====================================================================
--- linux-2.6.git.orig/mm/failslab.c
+++ linux-2.6.git/mm/failslab.c
@@ -17,6 +17,9 @@ bool should_failslab(size_t size, gfp_t 
 	if (gfpflags & __GFP_NOFAIL)
 		return false;
 
+	if (gfpflags & __GFP_PANIC)
+		return false;
+
         if (failslab.ignore_gfp_wait && (gfpflags & __GFP_WAIT))
 		return false;
 
Index: linux-2.6.git/mm/page_alloc.c
=====================================================================
--- linux-2.6.git.orig/mm/page_alloc.c
+++ linux-2.6.git/mm/page_alloc.c
@@ -1185,6 +1185,8 @@ static int should_fail_alloc_page(gfp_t 
 		return 0;
 	if (gfp_mask & __GFP_NOFAIL)
 		return 0;
+	if (gfp_mask & __GFP_PANIC)
+		return 0;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
 		return 0;
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
@@ -1472,6 +1474,16 @@ try_next_zone:
 	return page;
 }
 
+void oom_panic(gfp_t gfp_mask, unsigned int order)
+{
+	if (likely(!(gfp_mask & __GFP_PANIC)))
+		return;
+
+	panic("Out of memory: panic due to __GFP_PANIC.\n"
+		"%s order:%d, mode:0x%x\n", current->comm,
+		order, gfp_mask);
+}
+
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
@@ -1506,7 +1518,7 @@ restart:
 		 * Happens if we have an empty zonelist as a result of
 		 * GFP_THISNODE being used on a memoryless node
 		 */
-		return NULL;
+		goto nopage;
 	}
 
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
@@ -1685,7 +1697,8 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
-	return page;
+	oom_panic(gfp_mask, order);
+	return NULL;
 got_pg:
 	if (kmemcheck_enabled)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
