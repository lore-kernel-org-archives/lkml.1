Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYIVK5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYIVK5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYIVK5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:57:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53479 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYIVK5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:57:24 -0400
Date: Mon, 22 Sep 2008 20:03:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/13] memcg: optimze per cpu accounting for memcg
Message-Id: <20080922200311.154bb49d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
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

Changelog v3->v4:
 - merged with an other leaf patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memcontrol.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: mmotm-2.6.27-rc6+/mm/memcontrol.c
===================================================================
--- mmotm-2.6.27-rc6+.orig/mm/memcontrol.c
+++ mmotm-2.6.27-rc6+/mm/memcontrol.c
@@ -67,11 +67,10 @@ struct mem_cgroup_stat {
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
@@ -238,18 +237,21 @@ static void mem_cgroup_charge_statistics
 {
 	int val = (charge)? 1 : -1;
 	struct mem_cgroup_stat *stat = &mem->stat;
+	struct mem_cgroup_stat_cpu *cpustat;
 
 	VM_BUG_ON(!irqs_disabled());
+
+	cpustat = &stat->cpustat[smp_processor_id()];
 	if (PageCgroupCache(pc))
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
 
@@ -681,7 +683,7 @@ static int mem_cgroup_charge_common(stru
 		css_get(&memcg->css);
 	}
 
-	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
+	while (unlikely(res_counter_charge(&mem->res, PAGE_SIZE))) {
 		if (!(gfp_mask & __GFP_WAIT))
 			goto out;
 

