Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYJGKH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYJGKH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756174AbYJGKGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:06:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39866 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbYJGKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:06:53 -0400
Date: Tue, 7 Oct 2008 19:06:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 4/6] memcg: optimize per-cpu statistics
Message-Id: <20081007190609.7e4fa45a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some obvious optimization to memcg.

I found mem_cgroup_charge_statistics() is a little big (in object) and
does unnecessary address calclation.
This patch is for optimization to reduce the size of this function.

And res_counter_charge() is 'likely' to success.

Changlog: v5->v6
 - patch series was reordered and needs some adjustment. no changes in logic.
Changelog v3->v4:
 - merged with an other leaf patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


 mm/memcontrol.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: mmotm-2.6.27-rc7+/mm/memcontrol.c
===================================================================
--- mmotm-2.6.27-rc7+.orig/mm/memcontrol.c
+++ mmotm-2.6.27-rc7+/mm/memcontrol.c
@@ -66,11 +66,10 @@ struct mem_cgroup_stat {
 /*
  * For accounting under irq disable, no need for increment preempt count.
  */
-static void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat *stat,
+static inline void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat_cpu *stat,
 		enum mem_cgroup_stat_index idx, int val)
 {
-	int cpu = smp_processor_id();
-	stat->cpustat[cpu].count[idx] += val;
+	stat->count[idx] += val;
 }
 
 static s64 mem_cgroup_read_stat(struct mem_cgroup_stat *stat,
@@ -190,18 +189,21 @@ static void mem_cgroup_charge_statistics
 {
 	int val = (charge)? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
+	struct mem_cgroup_stat_cpu *cpustat;
 
 	VM_BUG_ON(!irqs_disabled());
+
+	cpustat = &stat->cpustat[smp_processor_id()];
 	if (flags & PAGE_CGROUP_FLAG_CACHE)
-		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_CACHE, val);
 	else
-		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
+		__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_RSS, val);
 
 	if (charge)
-		__mem_cgroup_stat_add_safe(stat,
+		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
 	else
-		__mem_cgroup_stat_add_safe(stat,
+		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
 }
 
@@ -558,7 +560,7 @@ static int mem_cgroup_charge_common(stru
 		css_get(&memcg->css);
 	}
 
-	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
+	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE))) {
 		if (!(gfp_mask & __GFP_WAIT))
 			goto out;
 

