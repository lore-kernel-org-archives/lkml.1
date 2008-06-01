Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYFALaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYFALaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 07:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYFALab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 07:30:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48332 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbYFALab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 07:30:31 -0400
Date: Sun, 1 Jun 2008 14:30:28 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Paul Mundt <lethal@linux-sh.org>
cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <20080601112137.GE25429@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0806011426150.17742@sbz-30.cs.Helsinki.FI>
References: <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com>
 <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
 <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi>
 <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI>
 <20080601082427.GC25429@linux-sh.org> <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI>
 <20080601102401.GD25429@linux-sh.org> <48427A13.7050704@cs.helsinki.fi>
 <20080601112137.GE25429@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 01:29:39PM +0300, Pekka Enberg wrote:
> > Oh, almost, you had this bit in ksize() of SLAB:
> > 
> > +	page = virt_to_head_page(objp);
> > +	if (unlikely(!PageSlab(page)))
> > +		return PAGE_SIZE << compound_order(page);
> > 
> > Did you actually need it for something?
 
On Sun, 1 Jun 2008, Paul Mundt wrote:
> Not that I recall, it was just for consistency with SLUB. I'll have to
> re-test though, as I'm not sure if it was necessary or not.

OK. If we do need it, then something like this should work. But I don't 
see how we could have these "arbitrary pointers" (meaning not returned 
by kmalloc()) to compound pages; otherwise the BUG_ON would trigger with 
SLAB as well. I also don't see any call-sites that do this (but I'm not an 
expert on nommu).

		Pekka

diff --git a/mm/nommu.c b/mm/nommu.c
index dca93fc..604e7de 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -109,16 +109,39 @@ unsigned int kobjsize(const void *objp)
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
+	 * kmalloc(). The allocator, however, is not guaranteed to set PageSlab
+	 * so the pointer might still have come from kmalloc() (see the comments
+	 * below).
+	 */
 	if (PageSlab(page))
 		return ksize(objp);
 
-	BUG_ON(page->index < 0);
-	BUG_ON(page->index >= MAX_ORDER);
+	/*
+	 * The ksize() function is only guaranteed to work for pointers
+	 * returned by kmalloc(). So handle arbitrary pointers, that we expect
+	 * always to be compound pages, here. Note: we also handle pointers to
+	 * compound pages that came from kmalloc() here.
+	 */
+	if (PageCompound(page))
+		return PAGE_SIZE << compound_order(page);
 
-	return (PAGE_SIZE << page->index);
+	/*
+	 * Finally, handle pointers that came from kmalloc() that don't have
+	 * PageSlab set.
+	 */
+	return ksize(objp);
 }
 
 /*
