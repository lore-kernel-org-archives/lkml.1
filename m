Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYFBGBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYFBGBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYFBGBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:01:47 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:46575 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbYFBGBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:01:46 -0400
Date: Mon, 2 Jun 2008 14:59:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <20080602055922.GA24626@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	akpm@linux-foundation.org, mpm@selenic.com
References: <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi> <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi> <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI> <20080601082427.GC25429@linux-sh.org> <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI> <20080601102401.GD25429@linux-sh.org> <48427A13.7050704@cs.helsinki.fi> <20080601112137.GE25429@linux-sh.org> <Pine.LNX.4.64.0806011426150.17742@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806011426150.17742@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 02:30:28PM +0300, Pekka J Enberg wrote:
> On Sun, Jun 01, 2008 at 01:29:39PM +0300, Pekka Enberg wrote:
> > > Oh, almost, you had this bit in ksize() of SLAB:
> > > 
> > > +	page = virt_to_head_page(objp);
> > > +	if (unlikely(!PageSlab(page)))
> > > +		return PAGE_SIZE << compound_order(page);
> > > 
> > > Did you actually need it for something?
>  
> On Sun, 1 Jun 2008, Paul Mundt wrote:
> > Not that I recall, it was just for consistency with SLUB. I'll have to
> > re-test though, as I'm not sure if it was necessary or not.
> 
> OK. If we do need it, then something like this should work. But I don't 
> see how we could have these "arbitrary pointers" (meaning not returned 
> by kmalloc()) to compound pages; otherwise the BUG_ON would trigger with 
> SLAB as well. I also don't see any call-sites that do this (but I'm not an 
> expert on nommu).
> 
In the kmem_cache_alloc() case calling ksize() there is bogus, the
previous semantics for kobjsize() just defaulted to returning PAGE_SIZE
for these, since page->index was typically 0. Presently if we ksize()
those objects, we get bogus size results that are smaller than the
minimum alignment size. So we still need a way to handle that, even if
it's not frightfully accurate.

If we go back and apply your PG_slab patch for SLUB + SLOB, then
kobjsize() can just become:

diff --git a/mm/nommu.c b/mm/nommu.c
index dca93fc..3abd084 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -104,21 +104,43 @@ EXPORT_SYMBOL(vmtruncate);
 unsigned int kobjsize(const void *objp)
 {
 	struct page *page;
+	int order = 0;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
+	if (!objp)
 		return 0;
 
+	if ((unsigned long)objp >= memory_end)
+		return 0;
+
+	page = virt_to_head_page(objp);
+	if (!page)
+		return 0;
+
+	/*
+	 * If the allocator sets PageSlab, we know the pointer came from
+	 * kmalloc().
+	 */
 	if (PageSlab(page))
 		return ksize(objp);
 
-	BUG_ON(page->index < 0);
-	BUG_ON(page->index >= MAX_ORDER);
+	/*
+	 * The ksize() function is only guaranteed to work for pointers
+	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
+	 * always to be compound pages, here.
+	 */
+	if (PageCompound(page))
+		order = compound_order(page);
 
-	return (PAGE_SIZE << page->index);
+	/*
+	 * Finally, handle arbitrary pointers that don't set PageSlab.
+	 * Default to 0-order in the case when we're unable to ksize()
+	 * the object.
+	 */
+	return PAGE_SIZE << order;
 }
 
 /*
