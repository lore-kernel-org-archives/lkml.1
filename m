Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZBCJIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZBCJIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZBCJIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:08:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44946 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZBCJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:08:20 -0500
Date: Tue, 3 Feb 2009 18:07:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 4/6] memcg: fix shrinking memory to return -EBUSY by fixing
 retry algorithm
Message-Id: <20090203180707.dbf23908.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090203180320.9f29aa76.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090203180320.9f29aa76.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

As pointed out, shrinking memcg's limit should return -EBUSY
after reasonable retries. This patch tries to fix the current behavior
of shrink_usage.

Before looking into "shrink should return -EBUSY" problem, we should fix
hierarchical reclaim code. It compares current usage and current limit,
but it only makes sense when the kernel reclaims memory because hit limits.
This is also a problem.

What this patch does are.

  1. add new argument "shrink" to hierarchical reclaim. If "shrink==true",
     hierarchical reclaim returns immediately and the caller checks the kernel
     should shrink more or not.
     (At shrinking memory, usage is always smaller than limit. So check for
      usage < limit is useless.)

  2. For adjusting to above change, 2 changes in "shrink"'s retry path.
     2-a. retry_count depends on # of children because the kernel visits
	  the children under hierarchy one by one.
     2-b. rather than checking return value of hierarchical_reclaim's progress,
	  compares usage-before-shrink and usage-after-shrink.
	  If usage-before-shrink <= usage-after-shrink, retry_count is
	  decremented.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.29-Feb02/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Feb02.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Feb02/mm/memcontrol.c
@@ -702,6 +702,23 @@ static unsigned int get_swappiness(struc
 	return swappiness;
 }
 
+static int mem_cgroup_count_children_cb(struct mem_cgroup *mem, void *data)
+{
+	int *val = data;
+	(*val)++;
+	return 0;
+}
+/*
+ * This function returns the number of memcg under hierarchy tree. Returns
+ * 1(self count) if no children.
+ */
+static int mem_cgroup_count_children(struct mem_cgroup *mem)
+{
+	int num = 0;
+ 	mem_cgroup_walk_tree(mem, &num, mem_cgroup_count_children_cb);
+	return num;
+}
+
 /*
  * Visit the first child (need not be the first child as per the ordering
  * of the cgroup list, since we track last_scanned_child) of @mem and use
@@ -750,9 +767,11 @@ mem_cgroup_select_victim(struct mem_cgro
  *
  * We give up and return to the caller when we visit root_mem twice.
  * (other groups can be removed while we're walking....)
+ *
+ * If shrink==true, for avoiding to free too much, this returns immedieately.
  */
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
-						gfp_t gfp_mask, bool noswap)
+				   gfp_t gfp_mask, bool noswap, bool shrink)
 {
 	struct mem_cgroup *victim;
 	int ret, total = 0;
@@ -771,6 +790,13 @@ static int mem_cgroup_hierarchical_recla
 		ret = try_to_free_mem_cgroup_pages(victim, gfp_mask, noswap,
 						   get_swappiness(victim));
 		css_put(&victim->css);
+		/*
+		 * At shrinking usage, we can't check we should stop here or
+		 * reclaim more. It's depends on callers. last_scanned_child
+		 * will work enough for keeping fairness under tree.
+		 */
+		if (shrink)
+			return ret;
 		total += ret;
 		if (mem_cgroup_check_under_limit(root_mem))
 			return 1 + total;
@@ -856,7 +882,7 @@ static int __mem_cgroup_try_charge(struc
 			goto nomem;
 
 		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
-							noswap);
+							noswap, false);
 		if (ret)
 			continue;
 
@@ -1489,7 +1515,8 @@ int mem_cgroup_shrink_usage(struct page 
 		return 0;
 
 	do {
-		progress = mem_cgroup_hierarchical_reclaim(mem, gfp_mask, true);
+		progress = mem_cgroup_hierarchical_reclaim(mem,
+					gfp_mask, true, false);
 		progress += mem_cgroup_check_under_limit(mem);
 	} while (!progress && --retry);
 
@@ -1504,11 +1531,21 @@ static DEFINE_MUTEX(set_limit_mutex);
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
 				unsigned long long val)
 {
-
-	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
+	int retry_count;
 	int progress;
 	u64 memswlimit;
 	int ret = 0;
+	int children = mem_cgroup_count_children(memcg);
+	u64 curusage, oldusage;
+
+	/*
+	 * For keeping hierarchical_reclaim simple, how long we should retry
+	 * is depends on callers. We set our retry-count to be function
+	 * of # of children which we should visit in this loop.
+	 */
+	retry_count = MEM_CGROUP_RECLAIM_RETRIES * children;
+
+	oldusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 
 	while (retry_count) {
 		if (signal_pending(current)) {
@@ -1534,8 +1571,13 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
-							   false);
-  		if (!progress)			retry_count--;
+						   false, true);
+		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
+		/* Usage is reduced ? */
+  		if (curusage >= oldusage)
+			retry_count--;
+		else
+			oldusage = curusage;
 	}
 
 	return ret;
@@ -1544,13 +1586,16 @@ static int mem_cgroup_resize_limit(struc
 int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
 				unsigned long long val)
 {
-	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
+	int retry_count;
 	u64 memlimit, oldusage, curusage;
-	int ret;
+	int children = mem_cgroup_count_children(memcg);
+	int ret = -EBUSY;
 
 	if (!do_swap_account)
 		return -EINVAL;
-
+	/* see mem_cgroup_resize_res_limit */
+ 	retry_count = children * MEM_CGROUP_RECLAIM_RETRIES;
+	oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 	while (retry_count) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -1574,11 +1619,13 @@ int mem_cgroup_resize_memsw_limit(struct
 		if (!ret)
 			break;
 
-		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
-		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true);
+		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true, true);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		/* Usage is reduced ? */
 		if (curusage >= oldusage)
 			retry_count--;
+		else
+			oldusage = curusage;
 	}
 	return ret;
 }

