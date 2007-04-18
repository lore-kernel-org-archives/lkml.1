Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXDRApx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXDRApx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 20:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbXDRApx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 20:45:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:35272 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXDRApw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 20:45:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="215144436:sNHT20189246"
Date: Tue, 17 Apr 2007 17:44:18 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] slab: resize the alien caches too
Message-ID: <20070418004418.GA30721@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

While going through the slab code, I observed that alien caches are
not getting resized, when user changes the slab tunables. Appended patch
tries to fix this. Please review and let me know if I missed anything.

thanks,
suresh
---

Resize the alien caches too based on the slab tunables.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/mm/slab.c b/mm/slab.c
index 4cbac24..e0dd9af 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3823,6 +3823,7 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 		l3 = cachep->nodelists[node];
 		if (l3) {
 			struct array_cache *shared = l3->shared;
+			struct array_cache **alien = l3->alien;
 
 			spin_lock_irq(&l3->list_lock);
 
@@ -3831,15 +3832,15 @@ static int alloc_kmemlist(struct kmem_cache *cachep)
 						shared->avail, node);
 
 			l3->shared = new_shared;
-			if (!l3->alien) {
-				l3->alien = new_alien;
-				new_alien = NULL;
-			}
+			l3->alien = new_alien;
 			l3->free_limit = (1 + nr_cpus_node(node)) *
 					cachep->batchcount + cachep->num;
 			spin_unlock_irq(&l3->list_lock);
 			kfree(shared);
-			free_alien_cache(new_alien);
+			if (alien) {
+				drain_alien_cache(cachep, alien);
+				free_alien_cache(alien);
+			}
 			continue;
 		}
 		l3 = kmalloc_node(sizeof(struct kmem_list3), GFP_KERNEL, node);
