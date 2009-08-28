Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZH1E3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZH1E3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZH1E3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:29:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56338 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZH1E3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:29:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 13:27:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 4/5] memcg: per-cpu charge stock
Message-Id: <20090828132706.e35caf80.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For avoiding frequent access to res_counter at charge, add per-cpu
local charge. Comparing with modifing res_coutner (with percpu_counter),
this approach
Pros.
	- we don't have to touch res_counter's cache line
	- we don't have to chase res_counter's hierarchy
	- we don't have to call res_counter function.
Cons.
	- we need our own code.

Considering trade-off, I think this is worth to do.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   46 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
+++ mmotm-2.6.31-Aug27/mm/memcontrol.c
@@ -71,7 +71,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
-
+	MEM_CGROUP_STAT_STOCK, /* # of private charges pre-allocated */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
@@ -1266,6 +1266,32 @@ done:
 	unlock_page_cgroup(pc);
 }
 
+#define CHARGE_SIZE	(4 * ((NR_CPUS >> 5) + 1) * PAGE_SIZE)
+
+bool consume_local_stock(struct mem_cgroup *mem)
+{
+	struct mem_cgroup_stat_cpu *cstat;
+	int cpu = get_cpu();
+	bool ret = true;
+
+	cstat = &mem->stat.cpustat[cpu];
+	if (cstat->count[MEM_CGROUP_STAT_STOCK])
+		cstat->count[MEM_CGROUP_STAT_STOCK] -= PAGE_SIZE;
+	else
+		ret = false;
+	put_cpu();
+	return ret;
+}
+
+void do_local_stock(struct mem_cgroup *mem, int val)
+{
+	struct mem_cgroup_stat_cpu *cstat;
+	int cpu = get_cpu();
+	cstat = &mem->stat.cpustat[cpu];
+	__mem_cgroup_stat_add_safe(cstat, MEM_CGROUP_STAT_STOCK, val);
+	put_cpu();
+}
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -1297,28 +1323,30 @@ static int __mem_cgroup_try_charge(struc
 	} else {
 		css_get(&mem->css);
 	}
-	if (unlikely(!mem))
+	/* css_get() against root cgroup is NOOP. we can ignore it */
+	if (!mem || mem_cgroup_is_root(mem))
 		return 0;
 
 	VM_BUG_ON(css_is_removed(&mem->css));
 
+	if (consume_local_stock(mem))
+		goto got;
+
 	while (1) {
 		int ret = 0;
 		unsigned long flags = 0;
 
-		if (mem_cgroup_is_root(mem))
-			goto done;
-		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res);
+		ret = res_counter_charge(&mem->res, CHARGE_SIZE, &fail_res);
 
 		if (likely(!ret)) {
 			if (!do_swap_account)
 				break;
-			ret = res_counter_charge(&mem->memsw, PAGE_SIZE,
+			ret = res_counter_charge(&mem->memsw, CHARGE_SIZE,
 						&fail_res);
 			if (likely(!ret))
 				break;
 			/* mem+swap counter fails */
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			res_counter_uncharge(&mem->res, CHARGE_SIZE);
 			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									memsw);
@@ -1356,7 +1384,8 @@ static int __mem_cgroup_try_charge(struc
 			goto nomem;
 		}
 	}
-
+	do_local_stock(mem, CHARGE_SIZE - PAGE_SIZE);
+got:
 	/*
 	 * check hierarchy root's event counter and modify softlimit-tree
 	 * if necessary.
@@ -1364,7 +1393,6 @@ static int __mem_cgroup_try_charge(struc
 	mem_over_soft_limit = mem_cgroup_soft_limit_check(mem);
 	if (mem_over_soft_limit)
 		mem_cgroup_update_tree(mem_over_soft_limit, page);
-done:
 	return 0;
 nomem:
 	css_put(&mem->css);

