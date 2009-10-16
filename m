Return-Path: <linux-kernel-owner+w=401wt.eu-S935628AbZJPAlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628AbZJPAlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932823AbZJPAlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:41:47 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64924 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbZJPAlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:41:45 -0400
Date: Fri, 16 Oct 2009 09:32:52 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       h-shimamoto@ct.jp.nec.com, linux-kernel@vger.kernel.org,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][PATCH -mmotm] memcg: don't do INIT_WORK() repeatedly
 against the same work_struct
Message-Id: <20091016093252.30d78e4b.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091014160237.1ac8d1b8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091009165826.59c6f6e3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091009170105.170e025f.kamezawa.hiroyu@jp.fujitsu.com>
	<20091009165002.629a91d2.akpm@linux-foundation.org>
	<72e9a96ea399491948f396dab01b4c77.squirrel@webmail-b.css.fujitsu.com>
	<20091013165719.c5781bfa.nishimura@mxp.nes.nec.co.jp>
	<20091013170545.3af1cf7b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091014154211.08f33001.nishimura@mxp.nes.nec.co.jp>
	<20091014160237.1ac8d1b8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix for memcg-coalesce-charging-via-percpu-storage.patch,
and can be applied after memcg-coalesce-charging-via-percpu-storage-fix.patch.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Don't do INIT_WORK() repeatedly against the same work_struct.
It can actually lead to a BUG.

Just do it once in initialization.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f850941..bf02bea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1349,8 +1349,8 @@ static void drain_all_stock_async(void)
 	/* This function is for scheduling "drain" in asynchronous way.
 	 * The result of "drain" is not directly handled by callers. Then,
 	 * if someone is calling drain, we don't have to call drain more.
-	 * Anyway, work_pending() will catch if there is a race. We just do
-	 * loose check here.
+	 * Anyway, WORK_STRUCT_PENDING check in queue_work_on() will catch if
+	 * there is a race. We just do loose check here.
 	 */
 	if (atomic_read(&memcg_drain_count))
 		return;
@@ -1359,9 +1359,6 @@ static void drain_all_stock_async(void)
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (work_pending(&stock->work))
-			continue;
-		INIT_WORK(&stock->work, drain_local_stock);
 		schedule_work_on(cpu, &stock->work);
 	}
  	put_online_cpus();
@@ -3327,11 +3324,17 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 
 	/* root ? */
 	if (cont->parent == NULL) {
+		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
 		root_mem_cgroup = mem;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		for_each_possible_cpu(cpu) {
+			struct memcg_stock_pcp *stock =
+						&per_cpu(memcg_stock, cpu);
+			INIT_WORK(&stock->work, drain_local_stock);
+		}
 		hotcpu_notifier(memcg_stock_cpu_callback, 0);
 
 	} else {
-- 
1.5.6.1

