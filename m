Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZAHKTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZAHKTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbZAHKSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:18:54 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:44600 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZAHKSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:18:53 -0500
Date: Thu, 8 Jan 2009 19:15:20 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com,
       nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH 4/4] memcg: make oom less frequently
Message-Id: <20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In previous implementation, mem_cgroup_try_charge checked the return
value of mem_cgroup_try_to_free_pages, and just retried if some pages
had been reclaimed.
But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
only checks whether the usage is less than the limit.

This patch tries to change the behavior as before to cause oom less frequently.

To prevent try_charge from getting stuck in infinite loop,
MEM_CGROUP_RECLAIM_RETRIES_MAX is defined.


Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 804c054..fedd76b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -42,6 +42,7 @@
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
+#define MEM_CGROUP_RECLAIM_RETRIES_MAX	32
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 0 */
@@ -770,10 +771,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 	 * but there might be left over accounting, even after children
 	 * have left.
 	 */
-	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
+	ret += try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
 					   get_swappiness(root_mem));
 	if (mem_cgroup_check_under_limit(root_mem))
-		return 0;
+		return 1;	/* indicate reclaim has succeeded */
 	if (!root_mem->use_hierarchy)
 		return ret;
 
@@ -785,10 +786,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 			next_mem = mem_cgroup_get_next_node(root_mem);
 			continue;
 		}
-		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
+		ret += try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
 						   get_swappiness(next_mem));
 		if (mem_cgroup_check_under_limit(root_mem))
-			return 0;
+			return 1;	/* indicate reclaim has succeeded */
 		next_mem = mem_cgroup_get_next_node(root_mem);
 	}
 	return ret;
@@ -820,6 +821,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 {
 	struct mem_cgroup *mem, *mem_over_limit;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	int nr_retries_max = MEM_CGROUP_RECLAIM_RETRIES_MAX;
 	struct res_counter *fail_res;
 
 	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
@@ -871,8 +873,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
+		if (!nr_retries_max--)
+			goto oom;
+
 		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
 							noswap);
+		if (ret)
+			continue;
 
 		/*
 		 * try_to_free_mem_cgroup_pages() might not give us a full
@@ -886,6 +893,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 			continue;
 
 		if (!nr_retries--) {
+oom:
 			if (oom) {
 				mutex_lock(&memcg_tasklist);
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
