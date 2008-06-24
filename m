Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYFXIW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYFXIW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYFXIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:22:10 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40197 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYFXIWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:22:08 -0400
Date: Tue, 24 Jun 2008 10:22:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/14] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241021360.26777@ask.diku.dk>
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

 arch/ia64/kernel/iosapic.c |    2 --
 1 file changed, 2 deletions(-)

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

diff -u -p a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -558,8 +558,6 @@ static struct iosapic_rte_info * __init_
 	if (!iosapic_kmalloc_ok && list_empty(&free_rte_list)) {
 		rte = alloc_bootmem(sizeof(struct iosapic_rte_info) *
 				    NR_PREALLOCATE_RTE_ENTRIES);
-		if (!rte)
-			return NULL;
 		for (i = 0; i < NR_PREALLOCATE_RTE_ENTRIES; i++, rte++)
 			list_add(&rte->rte_list, &free_rte_list);
 	}
