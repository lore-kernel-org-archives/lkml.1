Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYEVQJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYEVQJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYEVQJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:09:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57540 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbYEVQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:09:07 -0400
Date: Thu, 22 May 2008 19:09:04 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: dhowells@redhat.com
cc: clameter@sgi.com, mpm@selenic.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
Message-ID: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

As reported by Paul Mundt, kobjsize() does not work properly with SLOB and SLUB
that re-use parts of struct page for their own purposes. Fix it up by using
compound_order() for compound pages that don't have PageSlab set.

Reported-by: Paul Mundt <lethal@linux-sh.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
I kept the original object size calculation for non-compound pages in this 
version. It looks like the nommu code uses kobjsize() for all sorts of 
interesting things.

 mm/nommu.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

Index: slab-2.6/mm/nommu.c
===================================================================
--- slab-2.6.orig/mm/nommu.c	2008-05-22 18:59:01.000000000 +0300
+++ slab-2.6/mm/nommu.c	2008-05-22 19:00:36.000000000 +0300
@@ -109,12 +109,22 @@
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
+	if (!objp)
+		return 0;
+
+	if ((unsigned long) objp >= memory_end)
+		return 0;
+
+	page = virt_to_head_page(objp);
+	if (!page)
 		return 0;
 
 	if (PageSlab(page))
 		return ksize(objp);
 
+	if (PageCompound(page))
+		return PAGE_SIZE << compound_order(page);
+
 	BUG_ON(page->index < 0);
 	BUG_ON(page->index >= MAX_ORDER);
 
