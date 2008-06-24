Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYFXIV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYFXIV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFXIVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:21:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40175 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYFXIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:21:11 -0400
Date: Tue, 24 Jun 2008 10:21:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/14] arch/arm: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241020190.26777@ask.diku.dk>
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

 arch/arm/mm/mmu.c |    1 -
 1 file changed, 1 deletion(-)

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

Diff -u -p a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -676,7 +676,6 @@ static void __init devicemaps_init(struc
 	 * Allocate the vector page early.
 	 */
 	vectors = alloc_bootmem_low_pages(PAGE_SIZE);
-	BUG_ON(!vectors);
 
 	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
 		pmd_clear(pmd_off_k(addr));
