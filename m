Return-Path: <linux-kernel-owner+w=401wt.eu-S1033096AbXHMSYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033096AbXHMSYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934740AbXHMSFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:05:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:49255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966922AbXHMSFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:05:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,256,1183359600"; 
   d="scan'208";a="262532335"
Date: Mon, 13 Aug 2007 10:58:24 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: clameter@sgi.com
Cc: lethal@linux-sh.org, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [patch] slab: revert "slab: fix alien cache handling"
Message-ID: <20070813175824.GB12874@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

Can we revert git commit 3cdc0ed0cea50ea08dd146c1bbc82b1bcc2e1b80 ?
This is introducing a performance regression and nullifies the previous
commit.

commit 62918a036148230ba1ad175dc8a0952e3752ac57
Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
Date:   Wed May 2 19:27:18 2007 +0200

    [PATCH] x86-64: skip cache_free_alien() on non NUMA
    
    Set use_alien_caches to 0 on non NUMA platforms.  And avoid calling the
    cache_free_alien() when use_alien_caches is not set.  This will avoid the
    cache miss that happens while dereferencing slabp to get nodeid.

Looking at the 3cdc0ed0cea50ea08dd146c1bbc82b1bcc2e1b80 changelog, I can't find
enough info of why cache_free_alien() must be called regardless if we use alien
caches or not.

Appended patch fixes the performance regression. Please  comment the need
for 3cdc0ed0cea50ea08dd146c1bbc82b1bcc2e1b80, if I miss something.

thanks,
suresh
---

Skip calling cache_free_alien() when alien caches are not used.
This will avoid cache misses that happen while accessing slabp (which
is per page memory  reference) to get nodeid. Instead use a global
variable to skip the call, which is mostly likely to be present in the
cache.

This gives a 0.8% performance boost with the database oltp workload
on a quad-core SMP platform and by any means the number is not small :)

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/mm/slab.c b/mm/slab.c
index a684778..d6e2251 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3558,7 +3558,14 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	check_irq_off();
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
-	if (cache_free_alien(cachep, objp))
+	/*
+	 * Skip calling cache_free_alien() when alien caches are not used.
+	 * This will avoid cache misses that happen while accessing slabp (which
+	 * is per page memory  reference) to get nodeid. Instead use a global
+	 * variable to skip the call, which is mostly likely to be present in the
+	 * cache.
+	 */
+	if (use_alien_caches && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
