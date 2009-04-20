Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZDTU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZDTU0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZDTU0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:26:10 -0400
Received: from cmpxchg.org ([85.214.51.133]:47559 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZDTU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:26:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [patch 1/3] mm: fix pageref leak in do_swap_page()
Date: Mon, 20 Apr 2009 22:24:43 +0200
Message-Id: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.2.1.135.gde769
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the time the memory cgroup code is notified about a swapin we
already hold a reference on the fault page.

If the cgroup callback fails make sure to unlock AND release the page
or we leak the reference.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 mm/memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 366dab5..db126b6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2536,8 +2536,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
-		unlock_page(page);
-		goto out;
+		goto out_page;
 	}
 
 	/*
@@ -2599,6 +2598,7 @@ out:
 out_nomap:
 	mem_cgroup_cancel_charge_swapin(ptr);
 	pte_unmap_unlock(page_table, ptl);
+out_page:
 	unlock_page(page);
 	page_cache_release(page);
 	return ret;
-- 
1.6.2.1.135.gde769

