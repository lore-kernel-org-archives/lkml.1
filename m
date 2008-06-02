Return-Path: <linux-kernel-owner+w=401wt.eu-S1757497AbYFBH3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497AbYFBH3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYFBH3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:29:40 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:20933 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbYFBH3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:29:39 -0400
Date: Mon, 2 Jun 2008 16:27:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Howells <dhowells@redhat.com>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       mpm@selenic.com
Subject: [PATCH] nommu: fix kobjsize() for SLOB and SLUB, v2.
Message-ID: <20080602072706.GB28268@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	David Howells <dhowells@redhat.com>,
	Christoph Lameter <clameter@sgi.com>,
	LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
	mpm@selenic.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobjsize() has been abusing page->index as a method for sorting out
compound order, which blows up both for page cache pages, and SLOB's
reuse of the index in struct slob_page.

Presently we are not able to accurately size arbitrary pointers that
don't come from kmalloc(), so the best we can do is sort out the
compound order from the head page if it's a compound page, or default
to 0-order if it's impossible to ksize() the object.

Obviously this leaves quite a bit to be desired in terms of object
sizing accuracy, but the behaviour is unchanged over the existing
implementation, while fixing the page->index oopses originally reported
here:

	http://marc.info/?l=linux-mm&m=121127773325245&w=2

Accuracy could also be improved by having SLUB and SLOB both set PG_slab
on ksizeable pages, rather than just handling the __GFP_COMP cases
irregardless of the PG_slab setting, as made possibly with Pekka's
patches:

	http://marc.info/?l=linux-kernel&m=121139439900534&w=2
	http://marc.info/?l=linux-kernel&m=121139440000537&w=2
	http://marc.info/?l=linux-kernel&m=121139440000540&w=2

This is primarily a bugfix for nommu systems for 2.6.26, with the aim
being to gradually kill off kobjsize() and its particular brand of
object abuse entirely.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 mm/nommu.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

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
