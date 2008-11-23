Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbYKWKs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbYKWKs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYKWKsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:48:20 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59978 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbYKWKsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:48:19 -0500
Date: Sun, 23 Nov 2008 11:48:14 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] arch/ia64: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0811231147000.28343@ask.diku.dk>
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

 arch/ia64/sn/kernel/setup.c         |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index bb1d249..b683eb3 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -512,7 +512,6 @@ static void __init sn_init_pdas(char **cmdline_p)
 	for_each_online_node(cnode) {
 		nodepdaindr[cnode] =
 		    alloc_bootmem_node(NODE_DATA(cnode), sizeof(nodepda_t));
-		memset(nodepdaindr[cnode], 0, sizeof(nodepda_t));
 		memset(nodepdaindr[cnode]->phys_cpuid, -1,
 		    sizeof(nodepdaindr[cnode]->phys_cpuid));
 		spin_lock_init(&nodepdaindr[cnode]->ptc_lock);
@@ -521,11 +520,9 @@ static void __init sn_init_pdas(char **cmdline_p)
 	/*
 	 * Allocate & initialize nodepda for TIOs.  For now, put them on node 0.
 	 */
-	for (cnode = num_online_nodes(); cnode < num_cnodes; cnode++) {
+	for (cnode = num_online_nodes(); cnode < num_cnodes; cnode++)
 		nodepdaindr[cnode] =
 		    alloc_bootmem_node(NODE_DATA(0), sizeof(nodepda_t));
-		memset(nodepdaindr[cnode], 0, sizeof(nodepda_t));
-	}
 
 	/*
 	 * Now copy the array of nodepda pointers to each nodepda.
