Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbYDCJdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbYDCJdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYDCJd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:33:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47466 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYDCJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:33:25 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 03 Apr 2008 15:02:53 +0530
Message-Id: <20080403093253.8944.10168.sendpatchset@localhost.localdomain>
Subject: [-mm] Make the memory controller more desktop responsive
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch makes the memory controller more responsive on my desktop.

Here is what the patch does

1. Reduces the number of retries to 2. We had 5 earlier, since we
   were controlling swap cache as well. We pushed data from mappings
   to swap cache and we needed additional passes to clear out the cache.
2. It sets all cached pages as inactive. We were by default marking
   all pages as active, thus forcing us to go through two passes for
   reclaiming pages
3. Removes congestion_wait(), since we already have that logic in
   do_try_to_free_pages()

Comments? Flames?

The patch is against 2.6.25-rc8-mm1

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-improve-responsiveness mm/memcontrol.c
--- linux-2.6.25-rc8/mm/memcontrol.c~memory-controller-improve-responsiveness	2008-04-03 13:07:17.000000000 +0530
+++ linux-2.6.25-rc8-balbir/mm/memcontrol.c	2008-04-03 14:02:27.000000000 +0530
@@ -35,7 +35,7 @@
 #include <asm/uaccess.h>
 
 struct cgroup_subsys mem_cgroup_subsys;
-static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
+static const int MEM_CGROUP_RECLAIM_RETRIES = 2;
 static struct kmem_cache *page_cgroup_cache;
 
 /*
@@ -604,7 +604,6 @@ retry:
 			mem_cgroup_out_of_memory(mem, gfp_mask);
 			goto out;
 		}
-		congestion_wait(WRITE, HZ/10);
 	}
 
 	pc->ref_cnt = 1;
@@ -612,7 +611,7 @@ retry:
 	pc->page = page;
 	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
-		pc->flags |= PAGE_CGROUP_FLAG_CACHE;
+		pc->flags = PAGE_CGROUP_FLAG_CACHE;
 
 	lock_page_cgroup(page);
 	if (page_get_page_cgroup(page)) {
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
