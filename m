Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXHNHDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXHNHDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbXHNHDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:03:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:33565 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXHNHDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:03:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,258,1183359600"; 
   d="scan'208";a="117252410"
Date: Mon, 13 Aug 2007 23:56:57 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, lethal@linux-sh.org,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] slab: revert "slab: fix alien cache handling"
Message-ID: <20070814065657.GF10033@linux-os.sc.intel.com>
References: <20070813175824.GB12874@linux-os.sc.intel.com> <Pine.LNX.4.64.0708131349100.27728@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708131349100.27728@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 01:58:48PM -0700, Christoph Lameter wrote:
> On Mon, 13 Aug 2007, Siddha, Suresh B wrote:
> 
> > Can we revert git commit 3cdc0ed0cea50ea08dd146c1bbc82b1bcc2e1b80 ?
> 
> Only if you find another way to fix the bug that is addressed there.

Does the appended version fix both the issues? Name alien in cache_free_alien
is confusing, as the function does two things. free through alien caches
or direct remote free..

thanks,
suresh
---

Skip calling cache_free_alien() when the platform is not numa capable.
This will avoid cache misses that happen while accessing slabp (which
is per page memory  reference) to get nodeid. Instead use a global
variable to skip the call, which is mostly likely to be present in the
cache.

This gives a 0.8% performance boost with the database oltp workload
on a quad-core SMP platform and by any means the number is not small :)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/mm/slab.c b/mm/slab.c
index a684778..6f6abef 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -883,6 +883,7 @@ static void __slab_error(const char *function, struct kmem_cache *cachep,
   */
 
 static int use_alien_caches __read_mostly = 1;
+static int numa_platform __read_mostly = 1;
 static int __init noaliencache_setup(char *s)
 {
 	use_alien_caches = 0;
@@ -1399,8 +1400,10 @@ void __init kmem_cache_init(void)
 	int order;
 	int node;
 
-	if (num_possible_nodes() == 1)
+	if (num_possible_nodes() == 1) {
 		use_alien_caches = 0;
+		numa_platform = 0;
+	}
 
 	for (i = 0; i < NUM_INIT_LISTS; i++) {
 		kmem_list3_init(&initkmem_list3[i]);
@@ -3558,7 +3561,14 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (cache_free_alien(cachep, objp))
+	/*
+	 * Skip calling cache_free_alien() when the platform is not numa.
+	 * This will avoid cache misses that happen while accessing slabp (which
+	 * is per page memory  reference) to get nodeid. Instead use a global
+	 * variable to skip the call, which is mostly likely to be present in
+	 * the cache.
+	 */
+	if (numa_platform && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
