Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZFEHRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZFEHRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZFEHRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:17:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZFEHRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:17:05 -0400
Date: Fri, 5 Jun 2009 16:15:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] memcg: fix behavior under memory.limit equals to
 memsw.limit
Message-Id: <20090605161530.485c6262.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090604141043.9a1064fd.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe memory.limit==memsw.limit is an important special case and should
be handled properly.

-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A user can set memcg.limit_in_bytes == memcg.memsw.limit_in_bytes when
the user just want to limit the total size of applications, in other words,
not very interested in memory usage itself.
In this case, swap-out will be done only by global-LRU.

But, under current implementation, memory.limit_in_bytes is checked at first
and try_to_free_page() may do swap-out. But, that swap-out is useless for
memsw.limit_in_bytes and the thread may hit limit again.

This patch tries to fix the current behavior at memory.limit == memsw.limit
case. And documentation is updated to explain the behavior of this special
case.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
Index: mmotm-2.6.30-Jun4/Documentation/cgroups/memory.txt
===================================================================
--- mmotm-2.6.30-Jun4.orig/Documentation/cgroups/memory.txt
+++ mmotm-2.6.30-Jun4/Documentation/cgroups/memory.txt
@@ -152,14 +152,19 @@ When swap is accounted, following files 
 
 usage of mem+swap is limited by memsw.limit_in_bytes.
 
-Note: why 'mem+swap' rather than swap.
+* why 'mem+swap' rather than swap.
 The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
 to move account from memory to swap...there is no change in usage of
-mem+swap.
-
-In other words, when we want to limit the usage of swap without affecting
-global LRU, mem+swap limit is better than just limiting swap from OS point
-of view.
+mem+swap. In other words, when we want to limit the usage of swap without
+affecting global LRU, mem+swap limit is better than just limiting swap from
+OS point of view.
+
+* What happens when a cgroup hits memory.memsw.limit_in_bytes
+When a cgroup his memory.memsw.limit_in_bytes, it's useless to do swap-out
+in this cgroup. Then, swap-out will not be done by cgroup routine and file
+caches are dropped. But as mentioned above, global LRU can do swapout memory
+from it for sanity of the system's memory management state. You can't forbid
+it by cgroup.
 
 2.5 Reclaim
 
Index: mmotm-2.6.30-Jun4/mm/memcontrol.c
===================================================================
--- mmotm-2.6.30-Jun4.orig/mm/memcontrol.c
+++ mmotm-2.6.30-Jun4/mm/memcontrol.c
@@ -177,6 +177,9 @@ struct mem_cgroup {
 
 	unsigned int	swappiness;
 
+	/* set when res.limit == memsw.limit */
+	bool		memsw_is_minimum;
+
 	/*
 	 * statistics. This must be placed at the end of memcg.
 	 */
@@ -847,6 +850,10 @@ static int mem_cgroup_hierarchical_recla
 	int ret, total = 0;
 	int loop = 0;
 
+	/* If memsw_is_minimum==1, swap-out is of-no-use. */
+	if (root_mem->memsw_is_minimum)
+		noswap = true;
+
 	while (loop < 2) {
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem)
@@ -1752,6 +1759,12 @@ static int mem_cgroup_resize_limit(struc
 			break;
 		}
 		ret = res_counter_set_limit(&memcg->res, val);
+		if (!ret) {
+			if (memswlimit == val)
+				memcg->memsw_is_minimum = true;
+			else
+				memcg->memsw_is_minimum = false;
+		}
 		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
@@ -1799,6 +1812,12 @@ static int mem_cgroup_resize_memsw_limit
 			break;
 		}
 		ret = res_counter_set_limit(&memcg->memsw, val);
+		if (!ret) {
+			if (memlimit == val)
+				memcg->memsw_is_minimum = true;
+			else
+				memcg->memsw_is_minimum = false;
+		}
 		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)

