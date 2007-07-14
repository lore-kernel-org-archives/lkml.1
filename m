Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbXGNFy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbXGNFy7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 01:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbXGNFyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 01:54:52 -0400
Received: from waste.org ([66.93.16.53]:39464 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbXGNFyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 01:54:52 -0400
Date: Sat, 14 Jul 2007 00:54:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH] slob: reduce list scanning
Message-ID: <20070714055434.GQ11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The version of SLOB in -mm always scans its free list from the
beginning, which results in small allocations and free segments
clustering at the beginning of the list over time. This causes the
average search to scan over a large stretch at the beginning on each
allocation.

By starting each page search where the last one left off, we evenly
distribute the allocations and greatly shorten the average search.

Without this patch, kernel compiles on a 1.5G machine take a large
amount of system time for list scanning. With this patch, compiles are
within a few seconds of performance of a SLAB kernel with no notable
change in system time.

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: mm/mm/slob.c
===================================================================
--- mm.orig/mm/slob.c	2007-07-13 17:51:25.000000000 -0500
+++ mm/mm/slob.c	2007-07-13 18:42:59.000000000 -0500
@@ -293,6 +293,7 @@ static void *slob_page_alloc(struct slob
 static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 {
 	struct slob_page *sp;
+	struct list_head *prev;
 	slob_t *b = NULL;
 	unsigned long flags;
 
@@ -307,12 +308,22 @@ static void *slob_alloc(size_t size, gfp
 		if (node != -1 && page_to_nid(&sp->page) != node)
 			continue;
 #endif
+		/* Enough room on this page? */
+		if (sp->units < SLOB_UNITS(size))
+			continue;
 
-		if (sp->units >= SLOB_UNITS(size)) {
-			b = slob_page_alloc(sp, size, align);
-			if (b)
-				break;
-		}
+		/* Attempt to alloc */
+		prev = sp->list.prev;
+		b = slob_page_alloc(sp, size, align);
+		if (!b)
+			continue;
+
+		/* Improve fragment distribution and reduce our average
+		 * search time by starting our next search here. (see
+		 * Knuth vol 1, sec 2.5, pg 449) */
+		if (free_slob_pages.next != prev->next)
+			list_move_tail(&free_slob_pages, prev->next);
+		break;
 	}
 	spin_unlock_irqrestore(&slob_lock, flags);
 


-- 
Mathematics is the supreme nostalgia of our time.
