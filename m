Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYFMJYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYFMJYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbYFMJYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:24:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44400 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbYFMJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:24:37 -0400
Date: Fri, 13 Jun 2008 18:30:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Subject: [PATCH 2/6] memcg: handle limit change
Message-Id: <20080613183015.e2b67415.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add callback for resize_limit().

After this patch, memcg's usage will be reduced to new limit.
If it cannot, -EBUSY will be return to write() syscall.

And this patch tries to free all pages at force_empty by reusing
shrink function.

Change log: xxx -> v4
 - cut out from memcg hierarhcy patch set.
 - added retry_count as new arguments.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 Documentation/controllers/memory.txt |    3 --
 mm/memcontrol.c                      |   47 ++++++++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 5 deletions(-)

Index: linux-2.6.26-rc5-mm3/mm/memcontrol.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/mm/memcontrol.c
+++ linux-2.6.26-rc5-mm3/mm/memcontrol.c
@@ -779,6 +779,44 @@ int mem_cgroup_shrink_usage(struct mm_st
 }
 
 /*
+ * A callback for shrinking limit, Always GFP_KERNEL.
+ */
+int mem_cgroup_shrink_usage_to(struct res_counter *res, unsigned long long val,
+			 int retry_count)
+{
+	struct mem_cgroup *memcg = container_of(res, struct mem_cgroup, res);
+
+	if (retry_count > MEM_CGROUP_RECLAIM_RETRIES)
+		return -EBUSY;
+
+retry:
+	if (res_counter_check_under_val(res, val))
+		return 0;
+
+	cond_resched();
+	if (try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL) == 0)
+		return 0; /* no progress...*/
+
+	goto retry;
+}
+
+/*
+ * Must be called under there is no users on this cgroup.
+ */
+static void memcg_shrink_usage_all(struct mem_cgroup *memcg)
+{
+	int retry_count = 0;
+	int ret = 0;
+
+	while (!ret && !res_counter_check_under_val(&memcg->res, 0)) {
+		ret = mem_cgroup_shrink_usage_to(&memcg->res, 0, retry_count);
+		retry_count++;
+	}
+
+	return;
+}
+
+/*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
@@ -835,9 +873,10 @@ static int mem_cgroup_force_empty(struct
 	 * active_list <-> inactive_list while we don't take a lock.
 	 * So, we have to do loop here until all lists are empty.
 	 */
-	while (mem->res.usage > 0) {
+	while (!res_counter_check_under_val(&mem->res, 0)) {
 		if (atomic_read(&mem->css.cgroup->count) > 0)
 			goto out;
+		memcg_shrink_usage_all(mem);
 		for_each_node_state(node, N_POSSIBLE)
 			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				struct mem_cgroup_per_zone *mz;
@@ -1046,13 +1085,15 @@ static void mem_cgroup_free(struct mem_c
 		vfree(mem);
 }
 
+struct res_counter_ops root_ops = {
+	.shrink_usage = mem_cgroup_shrink_usage_to,
+};
 
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem;
 	int node;
-
 	if (unlikely((cont->parent) == NULL)) {
 		mem = &init_mem_cgroup;
 		page_cgroup_cache = KMEM_CACHE(page_cgroup, SLAB_PANIC);
@@ -1062,7 +1103,7 @@ mem_cgroup_create(struct cgroup_subsys *
 			return ERR_PTR(-ENOMEM);
 	}
 
-	res_counter_init(&mem->res);
+	res_counter_init_ops(&mem->res, &root_ops);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
Index: linux-2.6.26-rc5-mm3/Documentation/controllers/memory.txt
===================================================================
--- linux-2.6.26-rc5-mm3.orig/Documentation/controllers/memory.txt
+++ linux-2.6.26-rc5-mm3/Documentation/controllers/memory.txt
@@ -242,8 +242,7 @@ rmdir() if there are no tasks.
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
 3. Teach controller to account for shared-pages
-4. Start reclamation when the limit is lowered
-5. Start reclamation in the background when the limit is
+4. Start reclamation in the background when the limit is
    not yet hit but the usage is getting closer
 
 Summary

