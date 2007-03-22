Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbXCVV3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbXCVV3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934247AbXCVV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:29:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:10035 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934243AbXCVV27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,316,1170662400"; 
   d="scan'208"; a="217483802:sNHT29584905"
Date: Thu, 22 Mar 2007 14:28:31 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <christoph@lameter.com>
Cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
Message-ID: <20070322212831.GA25665@linux-os.sc.intel.com>
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703202006230.20568@graphe.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

While we are at this topic, recently I had reports that
cache_free_alien() is costly on non NUMA platforms too (similar
to the cache miss issues that Eric was referring to on NUMA)
and the appended patch seems to fix it for non NUMA atleast.

Appended patch gives a nice 1% perf improvement on non-NUMA platform
with database workload.

Please comment or Ack for mainline :)

thanks,
suresh
---

Subject: [patch] slab: skip cache_free_alien() on non NUMA
From: Suresh Siddha <suresh.b.siddha@intel.com>

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
 
+	if (num_online_nodes() == 1)
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
