Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbZH1E5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbZH1E5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZH1E5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:57:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51880 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZH1E5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:57:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 13:55:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
Message-Id: <20090828135552.f09167c2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090828135342.276ac003.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
	<20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
	<20090828135342.276ac003.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reflreshed..
==
In massive parallel enviroment, res_counter can be a performance bottleneck.
This patch is a trial for reducing lock contention.
One strong techinque to reduce lock contention is reducing calls by
batching some amount of calls int one.

Considering charge/uncharge chatacteristic,
	- charge is done one by one via demand-paging.
	- uncharge is done by
		- in chunk at munmap, truncate, exit, execve...
		- one by one via vmscan/paging.

It seems we hace a chance to batched-uncharge.
This patch is a base patch for batched uncharge. For avoiding
scattering memcg's structure, this patch adds memcg batch uncharge
information to the task. please see start/end usage in next patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |   12 +++++++
 include/linux/sched.h      |    7 ++++
 mm/memcontrol.c            |   70 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 83 insertions(+), 6 deletions(-)

Index: mmotm-2.6.31-Aug27/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/memcontrol.h
+++ mmotm-2.6.31-Aug27/include/linux/memcontrol.h
@@ -54,6 +54,10 @@ extern void mem_cgroup_rotate_lru_list(s
 extern void mem_cgroup_del_lru(struct page *page);
 extern void mem_cgroup_move_lists(struct page *page,
 				  enum lru_list from, enum lru_list to);
+
+extern void mem_cgroup_uncharge_batch_start(void);
+extern void mem_cgroup_uncharge_batch_end(void);
+
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
 extern int mem_cgroup_shmem_charge_fallback(struct page *page,
@@ -151,6 +155,14 @@ static inline void mem_cgroup_cancel_cha
 {
 }
 
+static inline void mem_cgroup_uncharge_batch_start(void)
+{
+}
+
+static inline void mem_cgroup_uncharge_batch_start(void)
+{
+}
+
 static inline void mem_cgroup_uncharge_page(struct page *page)
 {
 }
Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
+++ mmotm-2.6.31-Aug27/mm/memcontrol.c
@@ -1837,7 +1837,35 @@ void mem_cgroup_cancel_charge_swapin(str
 	css_put(&mem->css);
 }
 
+static void
+__do_batch_uncharge(struct mem_cgroup *mem, const enum charge_type ctype)
+{
+	struct memcg_batch_info *batch = NULL;
+	bool uncharge_memsw;
+	/* If swapout, usage of swap doesn't decrease */
+	if (do_swap_account && (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
+		uncharge_memsw = false;
+	else
+		uncharge_memsw = true;
 
+	if (current->memcg_batch.do_batch) {
+		batch = &current->memcg_batch;
+		if (batch->memcg == NULL) {
+			batch->memcg = mem;
+			css_get(&mem->css);
+		}
+	}
+	if (!batch || batch->memcg != mem) {
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		if (uncharge_memsw)
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+	} else {
+		batch->pages += PAGE_SIZE;
+		if (uncharge_memsw)
+			batch->memsw += PAGE_SIZE;
+	}
+	return;
+}
 /*
  * uncharge if !page_mapped(page)
  */
@@ -1886,12 +1914,8 @@ __mem_cgroup_uncharge_common(struct page
 		break;
 	}
 
-	if (!mem_cgroup_is_root(mem)) {
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-		if (do_swap_account &&
-				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-	}
+	if (!mem_cgroup_is_root(mem))
+		__do_batch_uncharge(mem, ctype);
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		mem_cgroup_swap_statistics(mem, true);
 	mem_cgroup_charge_statistics(mem, pc, false);
@@ -1938,6 +1962,38 @@ void mem_cgroup_uncharge_cache_page(stru
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
 }
 
+void mem_cgroup_uncharge_batch_start(void)
+{
+	VM_BUG_ON(current->memcg_batch.do_batch);
+	/* avoid batch if killed by OOM */
+	if (test_thread_flag(TIF_MEMDIE))
+		return;
+	current->memcg_batch.do_batch = 1;
+	current->memcg_batch.memcg = NULL;
+	current->memcg_batch.pages = 0;
+	current->memcg_batch.memsw = 0;
+}
+
+void mem_cgroup_uncharge_batch_end(void)
+{
+	struct mem_cgroup *mem;
+
+	if (!current->memcg_batch.do_batch)
+		return;
+
+	current->memcg_batch.do_batch = 0;
+
+	mem = current->memcg_batch.memcg;
+	if (!mem)
+		return;
+	if (current->memcg_batch.pages)
+		res_counter_uncharge(&mem->res, current->memcg_batch.pages);
+	if (current->memcg_batch.memsw)
+		res_counter_uncharge(&mem->memsw, current->memcg_batch.memsw);
+	/* we got css's refcnt */
+	cgroup_release_and_wakeup_rmdir(&mem->css);
+}
+
 #ifdef CONFIG_SWAP
 /*
  * called after __delete_from_swap_cache() and drop "page" account.
Index: mmotm-2.6.31-Aug27/include/linux/sched.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/sched.h
+++ mmotm-2.6.31-Aug27/include/linux/sched.h
@@ -1540,6 +1540,13 @@ struct task_struct {
 	unsigned long trace_recursion;
 #endif /* CONFIG_TRACING */
 	unsigned long stack_start;
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR /* memcg uses this to do batch job */
+	struct memcg_batch_info {
+		bool do_batch;
+		struct mem_cgroup *memcg;
+		long pages, memsw;
+	} memcg_batch;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */

