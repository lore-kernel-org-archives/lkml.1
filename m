Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbYBSHHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbYBSHHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760500AbYBSHHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:07:06 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59484 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761922AbYBSHHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:07:03 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hugh@veritas.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Herbert Poetzl <herbert@13thfloor.at>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik Van Riel <riel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 19 Feb 2008 12:32:58 +0530
Message-Id: <20080219070258.25349.25994.sendpatchset@localhost.localdomain>
In-Reply-To: <20080219070232.25349.21196.sendpatchset@localhost.localdomain>
References: <20080219070232.25349.21196.sendpatchset@localhost.localdomain>
Subject: [mm] [PATCH 2/4] Add the soft limit interface v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A new configuration file called soft_limit_in_bytes is added. The parsing
and configuration rules remain the same as for the limit_in_bytes user
interface.

A global list of all memory cgroups over their soft limit is maintained.
This list is then used to reclaim memory on global pressure. A cgroup is
removed from the list when the cgroup is deleted.

The global list is protected with a read-write spinlock.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memory-controller-add-soft-limit-interface mm/memcontrol.c
--- linux-2.6.25-rc2/mm/memcontrol.c~memory-controller-add-soft-limit-interface	2008-02-19 12:31:49.000000000 +0530
+++ linux-2.6.25-rc2-balbir/mm/memcontrol.c	2008-02-19 12:31:49.000000000 +0530
@@ -35,6 +35,10 @@
 
 struct cgroup_subsys mem_cgroup_subsys;
 static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
+static spinlock_t mem_cgroup_sl_list_lock;	/* spin lock that protects */
+						/* the list of cgroups over*/
+						/* their soft limit */
+static struct list_head mem_cgroup_sl_exceeded_list;
 
 /*
  * Statistics for memory cgroup.
@@ -136,6 +140,10 @@ struct mem_cgroup {
 	 * statistics.
 	 */
 	struct mem_cgroup_stat stat;
+	/*
+	 * List of all mem_cgroup's that exceed their soft limit
+	 */
+	struct list_head sl_exceeded_list;
 };
 
 /*
@@ -679,6 +687,18 @@ retry:
 		goto retry;
 	}
 
+	/*
+	 * If we exceed our soft limit, we get added to the list of
+	 * cgroups over their soft limit
+	 */
+	if (!res_counter_check_under_limit(&mem->res, RES_SOFT_LIMIT)) {
+		spin_lock_irqsave(&mem_cgroup_sl_list_lock, flags);
+		if (list_empty(&mem->sl_exceeded_list))
+			list_add_tail(&mem->sl_exceeded_list,
+						&mem_cgroup_sl_exceeded_list);
+		spin_unlock_irqrestore(&mem_cgroup_sl_list_lock, flags);
+	}
+
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	/* Update statistics vector */
@@ -736,13 +756,14 @@ void mem_cgroup_uncharge(struct page_cgr
 	if (atomic_dec_and_test(&pc->ref_cnt)) {
 		page = pc->page;
 		mz = page_cgroup_zoneinfo(pc);
+		mem = pc->mem_cgroup;
 		/*
 		 * get page->cgroup and clear it under lock.
 		 * force_empty can drop page->cgroup without checking refcnt.
 		 */
 		unlock_page_cgroup(page);
+
 		if (clear_page_cgroup(page, pc) == pc) {
-			mem = pc->mem_cgroup;
 			css_put(&mem->css);
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			spin_lock_irqsave(&mz->lru_lock, flags);
@@ -1046,6 +1067,12 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.open = mem_control_stat_open,
 	},
+	{
+		.name = "soft_limit_in_bytes",
+		.private = RES_SOFT_LIMIT,
+		.write = mem_cgroup_write,
+		.read = mem_cgroup_read,
+	},
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
@@ -1097,6 +1124,9 @@ mem_cgroup_create(struct cgroup_subsys *
 	if (unlikely((cont->parent) == NULL)) {
 		mem = &init_mem_cgroup;
 		init_mm.mem_cgroup = mem;
+		INIT_LIST_HEAD(&mem->sl_exceeded_list);
+		spin_lock_init(&mem_cgroup_sl_list_lock);
+		INIT_LIST_HEAD(&mem_cgroup_sl_exceeded_list);
 	} else
 		mem = kzalloc(sizeof(struct mem_cgroup), GFP_KERNEL);
 
@@ -1104,6 +1134,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		return NULL;
 
 	res_counter_init(&mem->res);
+	INIT_LIST_HEAD(&mem->sl_exceeded_list);
 
 	memset(&mem->info, 0, sizeof(mem->info));
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
