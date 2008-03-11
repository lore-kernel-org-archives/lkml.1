Return-Path: <linux-kernel-owner+w=401wt.eu-S1756468AbYCKEcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468AbYCKEcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYCKEcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:32:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49545 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYCKEcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:32:02 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 11 Mar 2008 10:01:49 +0530
Message-Id: <20080311043149.20251.50059.sendpatchset@localhost.localdomain>
Subject: [PATCH] Move memory controller allocations to their own slabs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Move the memory controller data structures page_cgroup and
mem_cgroup_per_zone to their own slab caches. It saves space on the system,
allocations are not necessarily pushed to order of 2 and should provide
performance benefits. Users who disable the memory controller can also double
check that the memory controller is not allocating page_cgroup's.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 linux/memcontrol.h |    0 
 mm/memcontrol.c    |   21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-move-to-own-slab mm/memcontrol.c
--- linux-2.6.25-rc4/mm/memcontrol.c~memory-controller-move-to-own-slab	2008-03-10 23:22:34.000000000 +0530
+++ linux-2.6.25-rc4-balbir/mm/memcontrol.c	2008-03-10 23:34:42.000000000 +0530
@@ -26,6 +26,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/slab.h>
 #include <linux/swap.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
@@ -35,6 +36,8 @@
 
 struct cgroup_subsys mem_cgroup_subsys;
 static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
+static struct kmem_cache *page_cgroup_cache;
+static struct kmem_cache *mem_cgroup_per_zone_cache;
 
 /*
  * Statistics for memory cgroup.
@@ -560,7 +563,7 @@ retry:
 	}
 	unlock_page_cgroup(page);
 
-	pc = kzalloc(sizeof(struct page_cgroup), gfp_mask);
+	pc = kmem_cache_zalloc(page_cgroup_cache, gfp_mask);
 	if (pc == NULL)
 		goto err;
 
@@ -622,7 +625,7 @@ retry:
 		 */
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
-		kfree(pc);
+		kmem_cache_free(page_cgroup_cache, pc);
 		goto retry;
 	}
 	page_assign_page_cgroup(page, pc);
@@ -637,7 +640,7 @@ done:
 	return 0;
 out:
 	css_put(&mem->css);
-	kfree(pc);
+	kmem_cache_free(page_cgroup_cache, pc);
 err:
 	return -ENOMEM;
 }
@@ -695,7 +698,7 @@ void mem_cgroup_uncharge_page(struct pag
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
 
-		kfree(pc);
+		kmem_cache_free(page_cgroup_cache, pc);
 		return;
 	}
 
@@ -988,9 +991,10 @@ static int alloc_mem_cgroup_per_zone_inf
 	 *       function.
 	 */
 	if (node_state(node, N_HIGH_MEMORY))
-		pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, node);
+		pn = kmem_cache_alloc_node(mem_cgroup_per_zone_cache,
+						GFP_KERNEL, node);
 	else
-		pn = kmalloc(sizeof(*pn), GFP_KERNEL);
+		pn = kmem_cache_alloc(mem_cgroup_per_zone_cache, GFP_KERNEL);
 	if (!pn)
 		return 1;
 
@@ -1008,7 +1012,7 @@ static int alloc_mem_cgroup_per_zone_inf
 
 static void free_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 {
-	kfree(mem->info.nodeinfo[node]);
+	kmem_cache_free(mem_cgroup_per_zone_cache, mem->info.nodeinfo[node]);
 }
 
 static struct cgroup_subsys_state *
@@ -1020,6 +1024,9 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (unlikely((cont->parent) == NULL)) {
 		mem = &init_mem_cgroup;
 		init_mm.mem_cgroup = mem;
+		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
+		mem_cgroup_per_zone_cache = KMEM_CACHE(mem_cgroup_per_zone,
+							SLAB_PANIC);
 	} else
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
diff -puN include/linux/memcontrol.h~memory-controller-move-to-own-slab include/linux/memcontrol.h
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
