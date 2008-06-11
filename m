Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYFKHgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYFKHgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYFKHgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:36:06 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36823 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752932AbYFKHgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:36:05 -0400
Date: Wed, 11 Jun 2008 16:33:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
Message-ID: <20080611073330.GB30983@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Christoph Lameter <clameter@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	mpm@selenic.com
References: <20080602072706.GB28268@linux-sh.org> <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806101027220.17093@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 10:30:36AM -0700, Christoph Lameter wrote:
> On Mon, 2 Jun 2008, Paul Mundt wrote:
> 
> > +	page = virt_to_head_page(objp);
> > +	if (!page)
> > +		return 0;
> 
> virt_to_head_page cannot return NULL. virt_to_page also does not return 
> NULL. pfn_valid() needs to be used to figure out if a page is valid. 
> Otherwise the page struct reference that was returned may have 
> PageReserved() set to indicate that it is not a valid page.
> 
> > +	 * The ksize() function is only guaranteed to work for pointers
> > +	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
> > +	 * always to be compound pages, here.
> > +	 */
> > +	if (PageCompound(page))
> > +		order = compound_order(page);
> 
> compund order returns 0 if you use compound_order() on a 
> non compound page. No need for the PageCompound test.
> 

Thanks for the review. Using virt_addr_valid() we can also get rid of
blackfin's idiotic > memory_end test for its DMA addresses, as the same
logic is encapsulated there. How does this look?

---

 mm/nommu.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 3abd084..4462b6a 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -104,21 +104,15 @@ EXPORT_SYMBOL(vmtruncate);
 unsigned int kobjsize(const void *objp)
 {
 	struct page *page;
-	int order = 0;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp)
-		return 0;
-
-	if ((unsigned long)objp >= memory_end)
+	if (!objp || !virt_addr_valid(objp))
 		return 0;
 
 	page = virt_to_head_page(objp);
-	if (!page)
-		return 0;
 
 	/*
 	 * If the allocator sets PageSlab, we know the pointer came from
@@ -129,18 +123,9 @@ unsigned int kobjsize(const void *objp)
 
 	/*
 	 * The ksize() function is only guaranteed to work for pointers
-	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
-	 * always to be compound pages, here.
-	 */
-	if (PageCompound(page))
-		order = compound_order(page);
-
-	/*
-	 * Finally, handle arbitrary pointers that don't set PageSlab.
-	 * Default to 0-order in the case when we're unable to ksize()
-	 * the object.
+	 * returned by kmalloc(). So handle arbitrary pointers here.
 	 */
-	return PAGE_SIZE << order;
+	return PAGE_SIZE << compound_order(page);
 }
 
 /*
