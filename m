Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYHSIb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYHSIb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYHSIbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:31:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42623 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYHSIbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:31:13 -0400
Date: Tue, 19 Aug 2008 17:37:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [1/9]
Message-Id: <20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replasce res_counter with new mem_counter to do complex counting.
This patch is for mem+swap controller.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memcontrol.c |  160 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 139 insertions(+), 21 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -116,12 +116,20 @@ struct mem_cgroup_lru_info {
  * no reclaim occurs from a cgroup at it's low water mark, this is
  * a feature that will be implemented much later in the future.
  */
+struct mem_counter {
+	unsigned long   pages_limit;
+	unsigned long   pages;
+	unsigned long   failcnt;
+	unsigned long   max_usage;
+	spinlock_t	lock;
+};
+
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 	/*
 	 * the counter to account for memory usage
 	 */
-	struct res_counter res;
+	struct mem_counter res;
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
@@ -181,6 +189,16 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_FORCE,	/* used by force_empty */
 };
 
+/* Private File ID for memcg */
+enum {
+	MEMCG_FILE_TYPE_PAGE_LIMIT,
+	MEMCG_FILE_TYPE_PAGE_USAGE,
+	MEMCG_FILE_TYPE_FAILCNT,
+	MEMCG_FILE_TYPE_MAX_USAGE,
+};
+
+
+
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
  */
@@ -279,6 +297,74 @@ static void unlock_page_cgroup(struct pa
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
+/*
+ * counter for memory resource accounting.
+ *
+ */
+static void mem_counter_init(struct mem_cgroup *memcg)
+{
+	spin_lock_init(&memcg->res.lock);
+	memcg->res.pages = 0;
+	memcg->res.pages_limit = ~0UL;
+	memcg->res.failcnt = 0;
+}
+
+static int mem_counter_charge(struct mem_cgroup *memcg, long num)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	if (memcg->res.pages + num > memcg->res.pages_limit) {
+		memcg->res.failcnt++;
+		spin_unlock_irqrestore(&memcg->res.lock, flags);
+		return -EBUSY;
+	}
+	memcg->res.pages += num;
+	if (memcg->res.pages > memcg->res.max_usage)
+		memcg->res.max_usage = memcg->res.pages;
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+	return 0;
+}
+
+static inline void mem_counter_uncharge(struct mem_cgroup *memcg, long num)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	memcg->res.pages -= num;
+	BUG_ON(memcg->res.pages < 0);
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+}
+
+static int mem_counter_set_pages_limit(struct mem_cgroup *memcg,
+		unsigned long lim)
+{
+	unsigned long flags;
+	int ret = -EBUSY;
+
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	if (memcg->res.pages < lim) {
+		memcg->res.pages_limit = lim;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+
+	return ret;
+}
+
+static int __mem_counter_check_under_limit(struct mem_cgroup *memcg)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&memcg->res.lock, flags);
+	if (memcg->res.pages < memcg->res.pages_limit)
+		ret = 1;
+	spin_unlock_irqrestore(&memcg->res.lock, flags);
+
+	return ret;
+}
+
 static void __mem_cgroup_remove_list(struct mem_cgroup_per_zone *mz,
 			struct page_cgroup *pc)
 {
@@ -402,7 +488,7 @@ int mem_cgroup_calc_mapped_ratio(struct 
 	 * usage is recorded in bytes. But, here, we assume the number of
 	 * physical pages can be represented by "long" on any arch.
 	 */
-	total = (long) (mem->res.usage >> PAGE_SHIFT) + 1L;
+	total = (long) (mem->res.pages >> PAGE_SHIFT) + 1L;
 	rss = (long)mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_RSS);
 	return (int)((rss * 100L) / total);
 }
@@ -544,7 +630,7 @@ static int mem_cgroup_charge_common(stru
 		css_get(&memcg->css);
 	}
 
-	while (res_counter_charge(&mem->res, PAGE_SIZE)) {
+	while (mem_counter_charge(mem, 1)) {
 		if (!(gfp_mask & __GFP_WAIT))
 			goto out;
 
@@ -558,7 +644,7 @@ static int mem_cgroup_charge_common(stru
 		 * Check the limit again to see if the reclaim reduced the
 		 * current usage of the cgroup before giving up
 		 */
-		if (res_counter_check_under_limit(&mem->res))
+		if (__mem_counter_check_under_limit(mem))
 			continue;
 
 		if (!nr_retries--) {
@@ -585,7 +671,7 @@ static int mem_cgroup_charge_common(stru
 	lock_page_cgroup(page);
 	if (unlikely(page_get_page_cgroup(page))) {
 		unlock_page_cgroup(page);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		mem_counter_uncharge(mem, 1);
 		css_put(&mem->css);
 		kmem_cache_free(page_cgroup_cache, pc);
 		goto done;
@@ -701,7 +787,7 @@ __mem_cgroup_uncharge_common(struct page
 	unlock_page_cgroup(page);
 
 	mem = pc->mem_cgroup;
-	res_counter_uncharge(&mem->res, PAGE_SIZE);
+	mem_counter_uncharge(mem, 1);
 	css_put(&mem->css);
 
 	kmem_cache_free(page_cgroup_cache, pc);
@@ -807,8 +893,9 @@ int mem_cgroup_resize_limit(struct mem_c
 	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
 	int progress;
 	int ret = 0;
+	unsigned long pages = (unsigned long)(val >> PAGE_SHIFT);
 
-	while (res_counter_set_limit(&memcg->res, val)) {
+	while (mem_counter_set_pages_limit(memcg, pages)) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
@@ -882,7 +969,7 @@ static int mem_cgroup_force_empty(struct
 	 * active_list <-> inactive_list while we don't take a lock.
 	 * So, we have to do loop here until all lists are empty.
 	 */
-	while (mem->res.usage > 0) {
+	while (mem->res.pages > 0) {
 		if (atomic_read(&mem->css.cgroup->count) > 0)
 			goto out;
 		for_each_node_state(node, N_POSSIBLE)
@@ -902,13 +989,44 @@ out:
 
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
-	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
-				    cft->private);
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	unsigned long long ret;
+
+	switch (cft->private) {
+	case MEMCG_FILE_TYPE_PAGE_USAGE:
+		ret = memcg->res.pages << PAGE_SHIFT;
+		break;
+	case MEMCG_FILE_TYPE_MAX_USAGE:
+		ret = memcg->res.max_usage << PAGE_SHIFT;
+		break;
+	case MEMCG_FILE_TYPE_PAGE_LIMIT:
+		ret = memcg->res.pages_limit << PAGE_SHIFT;
+		break;
+	case MEMCG_FILE_TYPE_FAILCNT:
+		ret = memcg->res.failcnt << PAGE_SHIFT;
+		break;
+	default:
+		BUG();
+	}
+	return ret;
 }
+
 /*
  * The user of this function is...
  * RES_LIMIT.
  */
+
+static int call_memparse(const char *buf, unsigned long long *val)
+{
+	char *end;
+
+	*val = memparse((char *)buf, &end);
+	if (*end != '\0')
+		return -EINVAL;
+	*val = PAGE_ALIGN(*val);
+	return 0;
+}
+
 static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 			    const char *buffer)
 {
@@ -917,9 +1035,9 @@ static int mem_cgroup_write(struct cgrou
 	int ret;
 
 	switch (cft->private) {
-	case RES_LIMIT:
+	case MEMCG_FILE_TYPE_PAGE_LIMIT:
 		/* This function does all necessary parse...reuse it */
-		ret = res_counter_memparse_write_strategy(buffer, &val);
+		ret = call_memparse(buffer, &val);
 		if (!ret)
 			ret = mem_cgroup_resize_limit(memcg, val);
 		break;
@@ -936,11 +1054,11 @@ static int mem_cgroup_reset(struct cgrou
 
 	mem = mem_cgroup_from_cont(cont);
 	switch (event) {
-	case RES_MAX_USAGE:
-		res_counter_reset_max(&mem->res);
+	case MEMCG_FILE_TYPE_MAX_USAGE:
+		mem->res.max_usage = 0;
 		break;
-	case RES_FAILCNT:
-		res_counter_reset_failcnt(&mem->res);
+	case MEMCG_FILE_TYPE_FAILCNT:
+		mem->res.failcnt = 0;
 		break;
 	}
 	return 0;
@@ -1005,24 +1123,24 @@ static int mem_control_stat_show(struct 
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
-		.private = RES_USAGE,
+		.private = MEMCG_FILE_TYPE_PAGE_USAGE,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "max_usage_in_bytes",
-		.private = RES_MAX_USAGE,
+		.private = MEMCG_FILE_TYPE_MAX_USAGE,
 		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "limit_in_bytes",
-		.private = RES_LIMIT,
+		.private = MEMCG_FILE_TYPE_PAGE_LIMIT,
 		.write_string = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "failcnt",
-		.private = RES_FAILCNT,
+		.private = MEMCG_FILE_TYPE_FAILCNT,
 		.trigger = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read,
 	},
@@ -1111,7 +1229,7 @@ mem_cgroup_create(struct cgroup_subsys *
 			return ERR_PTR(-ENOMEM);
 	}
 
-	res_counter_init(&mem->res);
+	mem_counter_init(mem);
 
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))

