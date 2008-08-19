Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbYHSIfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbYHSIfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYHSIfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:35:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42811 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbYHSIfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:35:13 -0400
Date: Tue, 19 Aug 2008 17:41:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [5/9]
Message-Id: <20080819174132.3fb69e31.kamezawa.hiroyu@jp.fujitsu.com>
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

Making freeing of page_cgroup to be rcu routine.

This patch avoid directly freeing per-cpu page_cgroup free and
pass freeq to RCU routine.

This patch is a base patch for removing lock_page_cgroup().

By this, page_cgroup object is valid while rcu_read_lock() is taken.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/memcontrol.c |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -638,21 +638,25 @@ unsigned long mem_cgroup_isolate_pages(u
 	return nr_taken;
 }
 
-void __mem_cgroup_drop_lru(void)
+struct memcg_rcu_work {
+	struct rcu_head	head;
+	struct page_cgroup *list;
+};
+
+
+void __mem_cgroup_drop_lru(struct rcu_head *head)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc, *next;
 	struct mem_cgroup_per_zone *mz, *page_mz;
-	struct mem_cgroup_lazy_lru *mll;
 	unsigned long flags;
+	struct memcg_rcu_work *work;
 
-	mll = &get_cpu_var(memcg_lazy_lru);
-	next = mll->next;
-	mll->next = NULL;
-	mll->count = 0;
-	put_cpu_var(memcg_lazy_lru);
+	work = container_of(head, struct memcg_rcu_work, head);
 
+	next = work->list;
 	mz = NULL;
+	kfree(work);
 
 	local_irq_save(flags);
 	while (next) {
@@ -678,6 +682,27 @@ void __mem_cgroup_drop_lru(void)
 	return;
 }
 
+static int mem_cgroup_drop_lru_rcu(void)
+{
+	struct mem_cgroup_lazy_lru *mll;
+	struct memcg_rcu_work *work;
+
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (!work)
+		return 1;
+
+	INIT_RCU_HEAD(&work->head);
+
+	mll = &get_cpu_var(memcg_lazy_lru);
+	work->list = mll->next;
+	mll->next = NULL;
+	mll->count = 0;
+	put_cpu_var(memcg_lazy_lru);
+	call_rcu(&work->head, __mem_cgroup_drop_lru);
+
+	return 0;
+}
+
 static void mem_cgroup_drop_lru(struct page_cgroup *pc)
 {
 	int count;
@@ -690,14 +715,17 @@ static void mem_cgroup_drop_lru(struct p
 	put_cpu_var(memcg_lazy_lru);
 
 	if (count >= MEMCG_LRU_THRESH)
-		__mem_cgroup_drop_lru();
+		mem_cgroup_drop_lru_rcu();
 }
 
 
 static DEFINE_MUTEX(memcg_force_drain_mutex);
 static void mem_cgroup_local_force_drain(struct work_struct *work)
 {
-	__mem_cgroup_drop_lru();
+	int ret;
+	do {
+		ret = mem_cgroup_drop_lru_rcu();
+	} while (ret);
 }
 
 static void mem_cgroup_all_force_drain(struct mem_cgroup *memcg)
@@ -705,6 +733,7 @@ static void mem_cgroup_all_force_drain(s
 	mutex_lock(&memcg_force_drain_mutex);
 	schedule_on_each_cpu(mem_cgroup_local_force_drain);
 	mutex_unlock(&memcg_force_drain_mutex);
+	synchronize_rcu();
 }
 
 /*

