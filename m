Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYHSIim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYHSIim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYHSIi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:38:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48366 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYHSIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:38:24 -0400
Date: Tue, 19 Aug 2008 17:44:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [9/9]
Message-Id: <20080819174436.db09de1c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
	<20080819173721.750d489e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add control files to mem+swap controller.

This patch adds following 2 files.
  - memory.memsw_limit_in_bytes ..... limit for mem+swap usage.
  - memory.swap_usage_in_bytes  ..... usage for swap_entry.

Following rules must be kept.
	memory.memsw_limit_in_bytes >= memory.limit_in_bytes.

If not, -EINVAL will return.

TODO:
  - add Documentation.
  - add function/file to force swap-in for reducing swap usage.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 7 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -268,10 +268,11 @@ enum {
 	MEMCG_FILE_TYPE_PAGE_USAGE,
 	MEMCG_FILE_TYPE_FAILCNT,
 	MEMCG_FILE_TYPE_MAX_USAGE,
+	MEMCG_FILE_TYPE_MEMSW_LIMIT,
+	MEMCG_FILE_TYPE_SWAP_USAGE,
 };
 
 
-
 /*
  * Always modified under lru lock. Then, not necessary to preempt_disable()
  * "flags" passed to this function is a copy of pc->flags but flags checked
@@ -415,11 +416,11 @@ mem_counter_recharge_swapout(struct mem_
 }
 
 static inline void
-mem_counter_uncharge_swap(struct mem_cgroup *memcg, long num)
+mem_counter_uncharge_swap(struct mem_cgroup *memcg)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&memcg->res.lock, flags);
-	memcg->res.swaps -= num;
+	memcg->res.swaps -= 1;
 	spin_unlock_irqrestore(&memcg->res.lock, flags);
 }
 
@@ -430,7 +431,9 @@ static int mem_counter_set_pages_limit(s
 	int ret = -EBUSY;
 
 	spin_lock_irqsave(&memcg->res.lock, flags);
-	if (memcg->res.pages < lim) {
+	if (lim > memcg->res.memsw_limit)
+		ret = -EINVAL;
+	else if (memcg->res.pages < lim) {
 		memcg->res.pages_limit = lim;
 		ret = 0;
 	}
@@ -568,6 +571,25 @@ void mem_cgroup_move_lists(struct page *
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+
+static int mem_cgroup_set_memsw_limit(struct mem_cgroup *memcg,
+		unsigned long lim)
+{
+	unsigned long flags;
+	int ret = -EBUSY;
+
+        spin_lock_irqsave(&memcg->res.lock, flags);
+        if (memcg->res.pages_limit > lim)
+                ret = -EINVAL;
+        else if (memcg->res.pages + memcg->res.swaps < lim) {
+		memcg->res.memsw_limit = lim;
+		ret = 0;
+	}
+        spin_unlock_irqrestore(&memcg->res.lock, flags);
+
+        return ret;
+
+}
 /*
  * Create a space for remember swap_entry.
  * Called from get_swap_page().
@@ -666,7 +688,7 @@ static void swap_cgroup_uncharge_swap(st
 
 	if (!swap_accounted(sc))
 		return;
-	mem_counter_uncharge_swap(mem, 1);
+	mem_counter_uncharge_swap(mem);
 	clear_swap_accounted(sc);
 }
 
@@ -686,7 +708,7 @@ static void swap_cgroup_delete_swap(swp_
 		list_del(&sc->list);
 		spin_unlock_irqrestore(&memcg->swap_list_lock, flags);
 		if (swap_accounted(sc))
-			mem_counter_uncharge_swap(memcg, 1);
+			mem_counter_uncharge_swap(memcg);
 		css_put(&memcg->css);
 		kfree(sc);
 	}
@@ -1294,7 +1316,10 @@ int mem_cgroup_resize_limit(struct mem_c
 	int ret = 0;
 	unsigned long pages = (unsigned long)(val >> PAGE_SHIFT);
 
-	while (mem_counter_set_pages_limit(memcg, pages)) {
+	while (1) {
+		ret = mem_counter_set_pages_limit(memcg, pages);
+		if (!ret || ret == -EINVAL)
+			break;
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
@@ -1310,6 +1335,43 @@ int mem_cgroup_resize_limit(struct mem_c
 	return ret;
 }
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static int
+mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg, unsigned long long val)
+{
+	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
+	int progress;
+	int ret = 0;
+	unsigned long pages = (unsigned long)(val >> PAGE_SHIFT);
+
+	while (1) {
+        	ret = mem_cgroup_set_memsw_limit(memcg, pages);
+		if (!ret || ret == -EINVAL)
+			break;
+                if (signal_pending(current)) {
+                        ret = -EINTR;
+                        break;
+                }
+                if (!retry_count) {
+                        ret = -EBUSY;
+                        break;
+                }
+                progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL);
+                if (!progress)
+                        retry_count--;
+        }
+        return ret;
+
+}
+#else
+static int
+mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg, unsigned long long val)
+{
+	return -EINVAL;
+}
+#endif
+
+
 
 /*
  * This routine traverse page_cgroup in given list and drop them all.
@@ -1405,6 +1467,12 @@ static u64 mem_cgroup_read(struct cgroup
 	case MEMCG_FILE_TYPE_FAILCNT:
 		ret = memcg->res.failcnt << PAGE_SHIFT;
 		break;
+	case MEMCG_FILE_TYPE_SWAP_USAGE:
+		ret = memcg->res.swaps << PAGE_SHIFT;
+		break;
+	case MEMCG_FILE_TYPE_MEMSW_LIMIT:
+		ret = memcg->res.memsw_limit << PAGE_SHIFT;
+		break;
 	default:
 		BUG();
 	}
@@ -1441,6 +1509,11 @@ static int mem_cgroup_write(struct cgrou
 		if (!ret)
 			ret = mem_cgroup_resize_limit(memcg, val);
 		break;
+	case MEMCG_FILE_TYPE_MEMSW_LIMIT:
+		ret = call_memparse(buffer, &val);
+		if (!ret)
+			ret = mem_cgroup_resize_memsw_limit(memcg, val);
+		break;
 	default:
 		ret = -EINVAL; /* should be BUG() ? */
 		break;
@@ -1552,6 +1625,19 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.read_map = mem_control_stat_show,
 	},
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+	{
+		.name = "memsw_limit_in_bytes",
+		.private = MEMCG_FILE_TYPE_MEMSW_LIMIT,
+		.read_u64 = mem_cgroup_read,
+		.write_string = mem_cgroup_write,
+	},
+	{
+		.name = "swap_usage_in_bytes",
+		.private = MEMCG_FILE_TYPE_SWAP_USAGE,
+		.read_u64 = mem_cgroup_read,
+	}
+#endif
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)

