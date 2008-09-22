Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYIVKtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYIVKtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYIVKtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:49:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55043 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbYIVKtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:49:35 -0400
Date: Mon, 22 Sep 2008 19:55:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "xemul@openvz.org" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/13] memcg: avoid accounting special mapping
Message-Id: <20080922195544.98a6c368.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080922195159.41a9d2bc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are not-on-LRU pages which can be mapped and they are not worth to
be accounted. (becasue we can't shrink them and need dirty codes to handle
specical case) We don't want to account out-of-vm's-control pages.

When special_mapping_fault() is called, page->mapping is tend to be NULL 
and it's charged as Anonymous page. So avoid account it in __do_fault().
We can know that by checking anon var.
insert_page() also handles some special pages from drivers.

Changelog:
  - new patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 mm/memory.c |   18 ++++++------------
 mm/rmap.c   |    4 ++--
 2 files changed, 8 insertions(+), 14 deletions(-)

Index: mmotm-2.6.27-rc6+/mm/memory.c
===================================================================
--- mmotm-2.6.27-rc6+.orig/mm/memory.c
+++ mmotm-2.6.27-rc6+/mm/memory.c
@@ -1323,18 +1323,14 @@ static int insert_page(struct vm_area_st
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	retval = mem_cgroup_charge(page, mm, GFP_KERNEL);
-	if (retval)
-		goto out;
-
 	retval = -EINVAL;
 	if (PageAnon(page))
-		goto out_uncharge;
+		goto out;
 	retval = -ENOMEM;
 	flush_dcache_page(page);
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
-		goto out_uncharge;
+		goto out;
 	retval = -EBUSY;
 	if (!pte_none(*pte))
 		goto out_unlock;
@@ -1350,8 +1346,6 @@ static int insert_page(struct vm_area_st
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
-out_uncharge:
-	mem_cgroup_uncharge_page(page);
 out:
 	return retval;
 }
@@ -2542,7 +2536,7 @@ static int __do_fault(struct mm_struct *
 
 	}
 
-	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
+	if (anon && mem_cgroup_charge(page, mm, GFP_KERNEL)) {
 		ret = VM_FAULT_OOM;
 		goto out;
 	}
@@ -2584,10 +2578,10 @@ static int __do_fault(struct mm_struct *
 		/* no need to invalidate: a not-present page won't be cached */
 		update_mmu_cache(vma, address, entry);
 	} else {
-		mem_cgroup_uncharge_page(page);
-		if (anon)
+		if (anon) {
+			mem_cgroup_uncharge_page(page);
 			page_cache_release(page);
-		else
+		} else
 			anon = 1; /* no anon but release faulted_page */
 	}
 
Index: mmotm-2.6.27-rc6+/mm/rmap.c
===================================================================
--- mmotm-2.6.27-rc6+.orig/mm/rmap.c
+++ mmotm-2.6.27-rc6+/mm/rmap.c
@@ -725,8 +725,8 @@ void page_remove_rmap(struct page *page,
 			page_clear_dirty(page);
 			set_page_dirty(page);
 		}
-
-		mem_cgroup_uncharge_page(page);
+		if (PageAnon(page))
+			mem_cgroup_uncharge_page(page);
 		__dec_zone_page_state(page,
 			PageAnon(page) ? NR_ANON_PAGES : NR_FILE_MAPPED);
 		/*

