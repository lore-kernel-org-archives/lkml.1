Return-Path: <linux-kernel-owner+w=401wt.eu-S1751693AbZH1EaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbZH1EaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZH1EaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:30:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57827 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZH1EaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:30:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 13:28:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 5/5] memcg: drain per cpu stock
Message-Id: <20090828132809.ad7cfebc.kamezawa.hiroyu@jp.fujitsu.com>
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


Add function for dropping per-cpu stock of charges.
This is called when
	- cpu is unplugged.
	- force_empty
	- recalim seems to be not easy.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
+++ mmotm-2.6.31-Aug27/mm/memcontrol.c
@@ -38,6 +38,8 @@
 #include <linux/vmalloc.h>
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -77,6 +79,8 @@ enum mem_cgroup_stat_index {
 
 struct mem_cgroup_stat_cpu {
 	s64 count[MEM_CGROUP_STAT_NSTATS];
+	struct work_struct work;
+	struct mem_cgroup *mem;
 } ____cacheline_aligned_in_smp;
 
 struct mem_cgroup_stat {
@@ -277,6 +281,7 @@ enum charge_type {
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
+static void schedule_drain_stock_all(struct mem_cgroup *mem, bool sync);
 
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
@@ -1195,6 +1200,9 @@ static int mem_cgroup_hierarchical_recla
 				return total;
 		} else if (mem_cgroup_check_under_limit(root_mem))
 			return 1 + total;
+
+		if (loop > 0)
+			schedule_drain_stock_all(victim, false);
 	}
 	return total;
 }
@@ -1292,6 +1300,48 @@ void do_local_stock(struct mem_cgroup *m
 	put_cpu();
 }
 
+/* called by cpu hotplug and workqueue */
+int force_drain_local_stock(struct mem_cgroup *mem, void *data)
+{
+	struct mem_cgroup_stat_cpu *cstat;
+	int cpu = *(unsigned long *)data;
+	unsigned long stock;
+
+	cstat = &mem->stat.cpustat[cpu];
+	stock = cstat->count[MEM_CGROUP_STAT_STOCK];
+	cstat->count[MEM_CGROUP_STAT_STOCK] = 0;
+	res_counter_uncharge(&mem->res, stock);
+	return 0;
+}
+
+
+void drain_local_stock(struct work_struct *work)
+{
+	struct mem_cgroup_stat_cpu *cstat;
+	struct mem_cgroup *mem;
+	unsigned long cpu;
+
+	cpu = get_cpu();
+	cstat = container_of(work, struct mem_cgroup_stat_cpu, work);
+	mem = cstat->mem;
+	force_drain_local_stock(mem, &cpu);
+	put_cpu();
+}
+
+
+void schedule_drain_stock_all(struct mem_cgroup *mem, bool sync)
+{
+	struct mem_cgroup_stat_cpu *cstat;
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		cstat = &mem->stat.cpustat[cpu];
+		schedule_work_on(cpu, &cstat->work);
+		if (sync)
+			flush_work(&cstat->work);
+	}
+}
+
 /*
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
@@ -2471,6 +2521,7 @@ move_account:
 		if (signal_pending(current))
 			goto out;
 		/* This is for making all *used* pages to be on LRU. */
+		schedule_drain_stock_all(mem, true);
 		lru_add_drain_all();
 		ret = 0;
 		for_each_node_state(node, N_HIGH_MEMORY) {
@@ -3081,6 +3132,7 @@ static struct mem_cgroup *mem_cgroup_all
 {
 	struct mem_cgroup *mem;
 	int size = mem_cgroup_size();
+	int i;
 
 	if (size < PAGE_SIZE)
 		mem = kmalloc(size, GFP_KERNEL);
@@ -3089,9 +3141,26 @@ static struct mem_cgroup *mem_cgroup_all
 
 	if (mem)
 		memset(mem, 0, size);
+	for (i = 0; i < nr_cpu_ids; i++)
+		INIT_WORK(&mem->stat.cpustat[i].work, drain_local_stock);
+
 	return mem;
 }
 
+static int __cpuinit percpu_memcg_hotcpu_callback(struct notifier_block *nb,
+		unsigned long  action, void *hcpu)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	if (action != CPU_DEAD)
+		return NOTIFY_OK;
+	if (!root_mem_cgroup)
+		return NOTIFY_OK;
+	mem_cgroup_walk_tree(root_mem_cgroup, hcpu, force_drain_local_stock);
+#endif
+	return NOTIFY_OK;
+}
+
+
 /*
  * At destroying mem_cgroup, references from swap_cgroup can remain.
  * (scanning all at force_empty is too costly...)
@@ -3203,7 +3272,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		root_mem_cgroup = mem;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
-
+		hotcpu_notifier(percpu_memcg_hotcpu_callback, 0);
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;

