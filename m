Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYJ1KPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYJ1KPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYJ1KPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:15:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37440 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbYJ1KPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:15:21 -0400
Date: Tue, 28 Oct 2008 19:14:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: [PATCH 3/4][mmotm] memcg: fix gfp_mask of callers of charge
Message-Id: <20081028191449.22a79033.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081028190911.6857b0a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081028190911.6857b0a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix misuse of gfp_kernel.

Now, most of callers of mem_cgroup_charge_xxx functions uses GFP_KERNEL.

I think that this is from the fact that page_cgroup *was* dynamically allocated.

But now, we allocate all page_cgroup at boot. And mem_cgroup_try_to_free_pages()
reclaim memory from GFP_HIGHUSER_MOVABLE + specified GFP_RECLAIM_MASK.
  * This is because we just want to reduce memory usage.
    "Where we should reclaim from ?" is not a problem in memcg.

This patch modifies gfp masks to be GFP_HIGUSER_MOVABLE if possible.
Note: This patch is not for fixing behavior but for showing sane information
      in source code.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/memcontrol.c |    8 +++++---
 mm/memory.c     |    9 +++++----
 mm/shmem.c      |    6 +++---
 mm/swapfile.c   |    2 +-
 4 files changed, 14 insertions(+), 11 deletions(-)

Index: mmotm-2.6.28rc2+/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28rc2+.orig/mm/memcontrol.c
+++ mmotm-2.6.28rc2+/mm/memcontrol.c
@@ -808,8 +808,9 @@ int mem_cgroup_prepare_migration(struct 
 	}
 	unlock_page_cgroup(pc);
 	if (mem) {
-		ret = mem_cgroup_charge_common(newpage, NULL, GFP_KERNEL,
-			ctype, mem);
+		ret = mem_cgroup_charge_common(newpage, NULL,
+					GFP_HIGHUSER_MOVABLE,
+					ctype, mem);
 		css_put(&mem->css);
 	}
 	return ret;
@@ -888,7 +889,8 @@ int mem_cgroup_resize_limit(struct mem_c
 			ret = -EBUSY;
 			break;
 		}
-		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL);
+		progress = try_to_free_mem_cgroup_pages(memcg,
+				GFP_HIGHUSER_MOVABLE);
 		if (!progress)
 			retry_count--;
 	}
Index: mmotm-2.6.28rc2+/mm/memory.c
===================================================================
--- mmotm-2.6.28rc2+.orig/mm/memory.c
+++ mmotm-2.6.28rc2+/mm/memory.c
@@ -1889,7 +1889,7 @@ gotten:
 	cow_user_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
+	if (mem_cgroup_newpage_charge(new_page, mm, GFP_HIGHUSER_MOVABLE))
 		goto oom_free_new;
 
 	/*
@@ -2324,7 +2324,7 @@ static int do_swap_page(struct mm_struct
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
-	if (mem_cgroup_try_charge(mm, GFP_KERNEL, &ptr) == -ENOMEM) {
+	if (mem_cgroup_try_charge(mm, GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
 		ret = VM_FAULT_OOM;
 		unlock_page(page);
 		goto out;
@@ -2405,7 +2405,7 @@ static int do_anonymous_page(struct mm_s
 		goto oom;
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
+	if (mem_cgroup_newpage_charge(page, mm, GFP_HIGHUSER_MOVABLE))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -2498,7 +2498,8 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
+			if (mem_cgroup_newpage_charge(page,
+						mm, GFP_HIGHUSER_MOVABLE)) {
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
Index: mmotm-2.6.28rc2+/mm/swapfile.c
===================================================================
--- mmotm-2.6.28rc2+.orig/mm/swapfile.c
+++ mmotm-2.6.28rc2+/mm/swapfile.c
@@ -535,7 +535,7 @@ static int unuse_pte(struct vm_area_stru
 	pte_t *pte;
 	int ret = 1;
 
-	if (mem_cgroup_try_charge(vma->vm_mm, GFP_KERNEL, &ptr))
+	if (mem_cgroup_try_charge(vma->vm_mm, GFP_HIGHUSER_MOVABLE, &ptr))
 		ret = -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
Index: mmotm-2.6.28rc2+/mm/shmem.c
===================================================================
--- mmotm-2.6.28rc2+.orig/mm/shmem.c
+++ mmotm-2.6.28rc2+/mm/shmem.c
@@ -920,8 +920,8 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	/* Precharge page using GFP_KERNEL while we can wait */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
+	/* Charge page using GFP_HIGHUSER_MOVABLE while we can wait */
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_HIGHUSER_MOVABLE);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1371,7 +1371,7 @@ repeat:
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
-							gfp & ~__GFP_HIGHMEM);
+					GFP_HIGHUSER_MOVABLE);
 			if (error) {
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);

