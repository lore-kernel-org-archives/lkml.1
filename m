Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbYKWKrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbYKWKrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYKWKrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:47:03 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59965 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbYKWKrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:47:01 -0500
Date: Sun, 23 Nov 2008 11:46:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: hskinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] arch/avr32: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0811231146250.28343@ask.diku.dk>
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

 arch/avr32/mm/init.c                |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index fa92ff6..e819fa6 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -97,7 +97,6 @@ void __init paging_init(void)
 
 	mem_map = NODE_DATA(0)->node_mem_map;
 
-	memset(zero_page, 0, PAGE_SIZE);
 	empty_zero_page = virt_to_page(zero_page);
 	flush_dcache_page(empty_zero_page);
 }
