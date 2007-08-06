Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXHFKsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXHFKsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763584AbXHFKpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:45:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763505AbXHFKpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:45:04 -0400
Message-Id: <20070806103658.107883000@chello.nl>
References: <20070806102922.907530000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 06 Aug 2007 12:29:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Content-Disposition: inline; filename=global-ALLOC_NO_WATERMARKS.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change ALLOC_NO_WATERMARK page allocation such that dipping into the reserves
becomes a system wide event.

This has the advantage that logic dealing with reserve pages need not be node
aware (when we're this low on memory speed is usually not an issue).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
---
 mm/page_alloc.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6-2/mm/page_alloc.c
===================================================================
--- linux-2.6-2.orig/mm/page_alloc.c
+++ linux-2.6-2/mm/page_alloc.c
@@ -1311,6 +1311,21 @@ restart:
 rebalance:
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 nofail_alloc:
+		/*
+		 * break out of mempolicy boundaries
+		 */
+		zonelist = NODE_DATA(numa_node_id())->node_zonelists +
+			gfp_zone(gfp_mask);
+
+		/*
+		 * Before going bare metal, try to get a page above the
+		 * critical threshold - ignoring CPU sets.
+		 */
+		page = get_page_from_freelist(gfp_mask, order, zonelist,
+				ALLOC_WMARK_MIN|ALLOC_HIGH|ALLOC_HARDER);
+		if (page)
+			goto got_pg;
+
 		/* go through the zonelist yet again, ignoring mins */
 		page = get_page_from_freelist(gfp_mask, order, zonelist,
 				ALLOC_NO_WATERMARKS);

--

