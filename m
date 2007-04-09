Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXDISJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXDISJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXDISJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:09:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:38559 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXDISJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:09:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="70845947:sNHT20940552"
Date: Mon, 9 Apr 2007 11:07:44 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: akpm@linux-foundation.org
Cc: christoph@lameter.com, Andi Kleen <andi@firstfloor.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: [patch 2/2] slab, x86_64: skip cache_free_alien() on non NUMA
Message-ID: <20070409180743.GB3948@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com> <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com> <20070323141210.GA20548@one.firstfloor.org> <20070402225512.GA31026@linux-os.sc.intel.com> <Pine.LNX.4.64.0704021722300.20493@graphe.net> <20070409180145.GA3948@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409180145.GA3948@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

set use_alien_caches to 0 on non NUMA platforms. And avoid calling
the cache_free_alien() when use_alien_caches is not set. This will avoid
the cache miss that happens while dereferencing slabp to get nodeid.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/mm/slab.c b/mm/slab.c
index 8fdaffa..146082d 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1146,7 +1146,7 @@ static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
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
@@ -3563,7 +3566,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (cache_free_alien(cachep, objp))
+	if (use_alien_caches && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
