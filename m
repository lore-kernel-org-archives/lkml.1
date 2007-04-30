Return-Path: <linux-kernel-owner+w=401wt.eu-S1423488AbXD3PuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423488AbXD3PuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423486AbXD3PuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:50:17 -0400
Received: from ns1.suse.de ([195.135.220.2]:45059 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423478AbXD3PuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:50:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: suresh.b.siddha@intel.com, andi@firstfloor.org, dada1@cosmosbay.com,
       rientjes@google.com, clameter@engr.sgi.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [25/34] x86_64: skip cache_free_alien() on non NUMA
Message-Id: <20070430154958.51788151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Set use_alien_caches to 0 on non NUMA platforms.  And avoid calling the
cache_free_alien() when use_alien_caches is not set.  This will avoid the
cache miss that happens while dereferencing slabp to get nodeid.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/mm/slab.c
===================================================================
--- linux.orig/mm/slab.c
+++ linux/mm/slab.c
@@ -1146,7 +1146,7 @@ static inline int cache_free_alien(struc
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(slabp->nodeid == node) || unlikely(!use_alien_caches))
+	if (likely(slabp->nodeid == node))
 		return 0;
 
 	l3 = cachep->nodelists[node];
@@ -1394,6 +1394,9 @@ void __init kmem_cache_init(void)
 	int order;
 	int node;
 
+	if (num_possible_nodes() == 1)
+		use_alien_caches = 0;
+
 	for (i = 0; i < NUM_INIT_LISTS; i++) {
 		kmem_list3_init(&initkmem_list3[i]);
 		if (i < MAX_NUMNODES)
@@ -3563,7 +3566,7 @@ static inline void __cache_free(struct k
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (cache_free_alien(cachep, objp))
+	if (use_alien_caches && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
