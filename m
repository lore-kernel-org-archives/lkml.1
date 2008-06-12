Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYFLHcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYFLHcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYFLHcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:32:36 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:35515 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750834AbYFLHcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:32:35 -0400
Date: Thu, 12 Jun 2008 16:29:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Bryan Wu <cooloney@kernel.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: Correct kobjsize() page validity checks.
Message-ID: <20080612072955.GA8097@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <clameter@sgi.com>,
	Bryan Wu <cooloney@kernel.org>, David Howells <dhowells@redhat.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements a few changes on top of the recent kobjsize() refactoring
introduced by commit 6cfd53fc03670c7a544a56d441eb1a6cc800d72b.

As Christoph points out:

	virt_to_head_page cannot return NULL. virt_to_page also
	does not return NULL. pfn_valid() needs to be used to
	figure out if a page is valid.  Otherwise the page struct
	reference that was returned may have PageReserved() set
	to indicate that it is not a valid page.

As discussed further in the thread, virt_addr_valid() is the preferable
way to validate the object pointer in this case. In addition to fixing
up the reserved page case, it also has the benefit of encapsulating the
hack introduced by commit 4016a1390d07f15b267eecb20e76a48fd5c524ef on
the impacted platforms, allowing us to get rid of the extra checking in
kobjsize() for the platforms that don't perform this type of bizarre
memory_end abuse (every nommu platform that isn't blackfin). If blackfin
decides to get in line with every other platform and use PageReserved
for the DMA pages in question, kobjsize() will also continue to work
fine.

It also turns out that compound_order() will give us back 0-order for
non-head pages, so we can get rid of the PageCompound check and just
use compound_order() directly. Clean that up while we're at it.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Christoph Lameter <clameter@sgi.com>

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
