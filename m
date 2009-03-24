Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZCXIDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZCXIDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZCXICs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:02:48 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57612 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbZCXICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:02:46 -0400
Date: Tue, 24 Mar 2009 16:57:43 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][PATCH(resend) mmotm] memcg:
 try_get_mem_cgroup_from_swapcache fix (Re: 2.6.30 -mm merge plans)
Message-Id: <20090324165743.bfaefecb.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090323224615.cd29edfd.akpm@linux-foundation.org>
References: <20090323224615.cd29edfd.akpm@linux-foundation.org>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     memcg-use-css-id.patch
>     memcg-hierarchical-stat.patch
>     memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
>     memcg-fix-oom-killer-under-memcg.patch
>     memcg-fix-oom-killer-under-memcg-fix2.patch
>     memcg-fix-oom-killer-under-memcg-fix.patch
>     memcg-show-memcg-information-during-oom.patch
>     memcg-show-memcg-information-during-oom-fix2.patch
>     memcg-show-memcg-information-during-oom-fix.patch
>     memcg-show-memcg-information-during-oom-fix-fix.patch
>     memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
>     memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
>     memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
>     memcg-charge-swapcache-to-proper-memcg.patch
>     cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
>     memcg-remove-redundant-message-at-swapon.patch
> 
>  Merge
> 
This patch is fix for cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch.

I think it would be better to fold them.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

css_tryget can be called twice in !PageCgroupUsed case.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujtsu.com>
---

 mm/memcontrol.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5de6be9..55dea59 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1027,9 +1027,11 @@ static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
 	/*
 	 * Used bit of swapcache is solid under page lock.
 	 */
-	if (PageCgroupUsed(pc))
+	if (PageCgroupUsed(pc)) {
 		mem = pc->mem_cgroup;
-	else {
+		if (mem && !css_tryget(&mem->css))
+			mem = NULL;
+	} else {
 		ent.val = page_private(page);
 		id = lookup_swap_cgroup(ent);
 		rcu_read_lock();
@@ -1038,10 +1040,6 @@ static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
 			mem = NULL;
 		rcu_read_unlock();
 	}
-	if (!mem)
-		return NULL;
-	if (!css_tryget(&mem->css))
-		return NULL;
 	return mem;
 }
 
