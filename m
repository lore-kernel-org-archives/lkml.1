Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYKWKqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYKWKqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbYKWKq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:46:29 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:47336 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYKWKq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:46:28 -0500
Date: Sun, 23 Nov 2008 11:46:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] arch/arm: Eliminate NULL test and memset after alloc_bootmem
Message-ID: <Pine.LNX.4.64.0811231145370.28343@ask.diku.dk>
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

 arch/arm/mm/mmu.c                   |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 9a17d51..6eb9f26 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -819,7 +819,6 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 	 * Allocate the vector page early.
 	 */
 	vectors = alloc_bootmem_low_pages(PAGE_SIZE);
-	BUG_ON(!vectors);
 
 	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
 		pmd_clear(pmd_off_k(addr));
@@ -904,10 +903,10 @@ void __init paging_init(struct machine_desc *mdesc)
 	top_pmd = pmd_off_k(0xffff0000);
 
 	/*
-	 * allocate the zero page.  Note that we count on this going ok.
+	 * allocate the zero page.  Note that this always succeeds and
+	 * returns a zeroed result.
 	 */
 	zero_page = alloc_bootmem_low_pages(PAGE_SIZE);
-	memset(zero_page, 0, PAGE_SIZE);
 	empty_zero_page = virt_to_page(zero_page);
 	flush_dcache_page(empty_zero_page);
 }
