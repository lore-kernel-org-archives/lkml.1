Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYK1JeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYK1JeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYK1Jdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:33:54 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:52354 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYK1Jdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:33:53 -0500
Date: Fri, 28 Nov 2008 18:09:37 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH -mmotm 2/2] avoid oom
Message-Id: <20081128180937.5d7b16c5.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
References: <20081128180252.b7a73c86.nishimura@mxp.nes.nec.co.jp>
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
I see oom easily in some tests which didn't cause oom before.

This patch tries to change the behavior as before.

I've tested this patch with only one (except root) mem cgroup directory,
and a mem cgroup directory(use_hierarchy=1) which has 4 children with running
test programs on itself and each children's directories.

Of course, even after this patch is applied, oom happens if trying to use
too much memory.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---

 mm/memcontrol.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e7806fc..ab134b7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -592,6 +592,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 {
 	struct mem_cgroup *next_mem;
 	int ret = 0;
+	int child = 0;
 
 	/*
 	 * Reclaim unconditionally and don't check for return value.
@@ -600,9 +601,9 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 	 * but there might be left over accounting, even after children
 	 * have left.
 	 */
-	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
+	ret += try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
 	if (mem_cgroup_check_under_limit(root_mem))
-		return 0;
+		return 1;	/* indicate success of reclaim */
 
 	next_mem = mem_cgroup_get_first_node(root_mem);
 
@@ -614,14 +615,17 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 			cgroup_unlock();
 			continue;
 		}
-		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
+		child++;
+		ret += try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
 		if (mem_cgroup_check_under_limit(root_mem))
-			return 0;
+			return 1;	/* indicate success of reclaim */
 		cgroup_lock();
 		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
 		cgroup_unlock();
 	}
-	return ret;
+
+	/* reclaimed at least one page on average from root and each child */
+	return ret > child;
 }
 
 /*
@@ -684,8 +688,9 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 		if (!(gfp_mask & __GFP_WAIT))
 			goto nomem;
 
-		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
-							noswap);
+		if (mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
+							noswap))
+			continue;
 
 		/*
 		 * try_to_free_mem_cgroup_pages() might not give us a full
