Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbZFDFM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbZFDFM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZFDFMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:12:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44953 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZFDFMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:12:15 -0400
Date: Thu, 4 Jun 2009 14:10:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH] remove memory.limit v.s. memsw.limit comparison.
Message-Id: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Removes memory.limit < memsw.limit at setting limit check completely.

The limitation "memory.limit <= memsw.limit" was added just because
it seems sane ...if memory.limit > memsw.limit, only memsw.limit works.

But To implement this limitation, we needed to use private mutex and make
the code a bit complated.
As Nishimura pointed out, in real world, there are people who only want
to use memsw.limit.

Then, this patch removes the check. user-land library or middleware can check
this in userland easily if this really concerns.

And this is a good change to charge-and-reclaim.

Now, memory.limit is always checked before memsw.limit
and it may do swap-out. But, if memory.limit == memsw.limit, swap-out is
finally no help and hits memsw.limit again. So, let's allow the condition
memory.limit > memsw.limit. Then we can skip unnecesary swap-out.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/memory.txt |   15 +++++++++++----
 mm/memcontrol.c                  |   33 +--------------------------------
 2 files changed, 12 insertions(+), 36 deletions(-)

Index: mmotm-2.6.30-Jun3/mm/memcontrol.c
===================================================================
--- mmotm-2.6.30-Jun3.orig/mm/memcontrol.c
+++ mmotm-2.6.30-Jun3/mm/memcontrol.c
@@ -1713,14 +1713,11 @@ int mem_cgroup_shmem_charge_fallback(str
 	return ret;
 }
 
-static DEFINE_MUTEX(set_limit_mutex);
-
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				unsigned long long val)
 {
 	int retry_count;
 	int progress;
-	u64 memswlimit;
 	int ret = 0;
 	int children = mem_cgroup_count_children(memcg);
 	u64 curusage, oldusage;
@@ -1739,20 +1736,7 @@ static int mem_cgroup_resize_limit(struc
 			ret = -EINTR;
 			break;
 		}
-		/*
-		 * Rather than hide all in some function, I do this in
-		 * open coded manner. You see what this really does.
-		 * We have to guarantee mem->res.limit < mem->memsw.limit.
-		 */
-		mutex_lock(&set_limit_mutex);
-		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-		if (memswlimit < val) {
-			ret = -EINVAL;
-			mutex_unlock(&set_limit_mutex);
-			break;
-		}
 		ret = res_counter_set_limit(&memcg->res, val);
-		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
 			break;
@@ -1774,7 +1758,7 @@ static int mem_cgroup_resize_memsw_limit
 					unsigned long long val)
 {
 	int retry_count;
-	u64 memlimit, oldusage, curusage;
+	u64 oldusage, curusage;
 	int children = mem_cgroup_count_children(memcg);
 	int ret = -EBUSY;
 
@@ -1786,24 +1770,9 @@ static int mem_cgroup_resize_memsw_limit
 			ret = -EINTR;
 			break;
 		}
-		/*
-		 * Rather than hide all in some function, I do this in
-		 * open coded manner. You see what this really does.
-		 * We have to guarantee mem->res.limit < mem->memsw.limit.
-		 */
-		mutex_lock(&set_limit_mutex);
-		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-		if (memlimit > val) {
-			ret = -EINVAL;
-			mutex_unlock(&set_limit_mutex);
-			break;
-		}
 		ret = res_counter_set_limit(&memcg->memsw, val);
-		mutex_unlock(&set_limit_mutex);
-
 		if (!ret)
 			break;
-
 		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true, true);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		/* Usage is reduced ? */
Index: mmotm-2.6.30-Jun3/Documentation/cgroups/memory.txt
===================================================================
--- mmotm-2.6.30-Jun3.orig/Documentation/cgroups/memory.txt
+++ mmotm-2.6.30-Jun3/Documentation/cgroups/memory.txt
@@ -155,11 +155,18 @@ usage of mem+swap is limited by memsw.li
 Note: why 'mem+swap' rather than swap.
 The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
 to move account from memory to swap...there is no change in usage of
-mem+swap.
+mem+swap. In other words, when we want to limit the usage of swap
+without affecting global LRU, mem+swap limit is better than just limiting
+swap from OS point of view.
+
+
+memory.limit v.s. memsw.limit
+
+There are no guarantee that memsw.limit is bigger than memory.limit
+in the kernel. The user should notice what he really wants and use
+proper size for limitation. Of course, if memsw.limit < memory.limit,
+only memsw.limit works sane.
 
-In other words, when we want to limit the usage of swap without affecting
-global LRU, mem+swap limit is better than just limiting swap from OS point
-of view.
 
 2.5 Reclaim
 

