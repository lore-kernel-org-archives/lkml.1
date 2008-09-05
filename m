Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYIEHwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYIEHwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYIEHv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:51:59 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57122 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYIEHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:51:58 -0400
Date: Fri, 5 Sep 2008 16:50:17 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh@veritas.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp
Subject: [PATCH][mmotm]memcg: handle null dereference of mm->owner
Message-Id: <20080905165017.b2715fe4.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

mm_update_next_owner() may clear mm->owner to NULL
if it races with swapoff, page migration, etc.
(This behavior was introduced by mm-owner-fix-race-between-swap-and-exit.patch.)

But memcg doesn't take account of this situation, and causes:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000630

This fixes it.


Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2979d22..ec2c16b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -244,6 +244,14 @@ static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
+	/*
+	 * mm_update_next_owner() may clear mm->owner to NULL
+	 * if it races with swapoff, page migration, etc.
+	 * So this can be called with p == NULL.
+	 */
+	if (unlikely(!p))
+		return NULL;
+
 	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
 				struct mem_cgroup, css);
 }
@@ -534,6 +542,11 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 	if (likely(!memcg)) {
 		rcu_read_lock();
 		mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+		if (unlikely(!mem)) {
+			rcu_read_unlock();
+			kmem_cache_free(page_cgroup_cache, pc);
+			return 0;
+		}
 		/*
 		 * For every charge from the cgroup, increment reference count
 		 */
@@ -790,6 +803,10 @@ int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
 
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (unlikely(!mem)) {
+		rcu_read_unlock();
+		return 0;
+	}
 	css_get(&mem->css);
 	rcu_read_unlock();
 
