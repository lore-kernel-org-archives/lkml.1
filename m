Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbYFXIX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbYFXIX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbYFXIXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:23:11 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50045 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbYFXIXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:23:09 -0400
Date: Tue, 24 Jun 2008 10:23:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/14] arch/m68k/mm/Sun3mmu.c: Eliminate NULL test and memset
 after alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241022410.26777@ask.diku.dk>
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

 arch/m68k/mm/sun3mmu.c |    1 -
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

diff -u -p a/arch/m68k/mm/sun3mmu.c b/arch/m68k/mm/sun3mmu.c
--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -53,7 +53,6 @@ void __init paging_init(void)
 	wp_works_ok = 0;
 #endif
 	empty_zero_page = alloc_bootmem_pages(PAGE_SIZE);
-	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	address = PAGE_OFFSET;
 	pg_dir = swapper_pg_dir;
