Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYHSIhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYHSIhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbYHSIhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:37:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56281 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYHSIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:36:58 -0400
Date: Tue, 19 Aug 2008 17:43:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [7/9]
Message-Id: <20080819174318.6b4cbfce.kamezawa.hiroyu@jp.fujitsu.com>
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

mem_cgroup_charge() common has to take lock but the place of lock can
be calculated in early stage. This patch tries to prefetch lock line.
(Have some good effect on my host.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc1-mm1/mm/memcontrol.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/mm/memcontrol.c
+++ linux-2.6.27-rc1-mm1/mm/memcontrol.c
@@ -707,11 +707,14 @@ static int mem_cgroup_charge_common(stru
 	struct page_cgroup *pc;
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	unsigned long flags;
+	int nid, zid;
 
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
 		goto err;
 
+	nid = page_to_nid(page);
+	zid = page_zonenum(page);
 	/*
 	 * We always charge the cgroup the mm_struct belongs to.
 	 * The mm_struct's mem_cgroup changes on task migration if the
@@ -753,6 +756,8 @@ static int mem_cgroup_charge_common(stru
 			goto out;
 		}
 	}
+	mz = mem_cgroup_zoneinfo(mem, nid, zid);
+	prefetchw(mz);
 
 	pc->mem_cgroup = mem;
 	pc->page = page;
@@ -773,7 +778,6 @@ static int mem_cgroup_charge_common(stru
 
 	VM_BUG_ON(page->page_cgroup);
 	page_assign_page_cgroup(page, pc);
-	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_add_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);

