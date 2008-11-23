Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbYKWKtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbYKWKtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbYKWKtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:49:40 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:47366 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbYKWKtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:49:39 -0500
Date: Sun, 23 Nov 2008 11:49:36 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] mm/page_alloc.c: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0811231148580.28343@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

 mm/page_alloc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8ac014..5040299 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3381,10 +3381,8 @@ static void __init setup_usemap(struct pglist_data *pgdat,
 {
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
-	if (usemapsize) {
+	if (usemapsize)
 		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
-		memset(zone->pageblock_flags, 0, usemapsize);
-	}
 }
 #else
 static void inline setup_usemap(struct pglist_data *pgdat,
