Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZDGMBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZDGMBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbZDGMAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:00:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:23410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZDGMAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:00:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,337,1235980800"; 
   d="scan'208";a="128748880"
Message-Id: <20090407115233.975503899@intel.com>
References: <20090407115039.780820496@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Apr 2009 19:50:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ying Han <yinghan@google.com>, Wu Fengguang <fengguang.wu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 02/14] mm: fix major/minor fault accounting on retried fault
Content-Disposition: inline; filename=filemap-major-fault-retry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VM_FAULT_RETRY does make major/minor faults accounting a bit twisted..

Cc: Ying Han <yinghan@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 arch/x86/mm/fault.c |    2 ++
 mm/memory.c         |   22 ++++++++++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

--- mm.orig/arch/x86/mm/fault.c
+++ mm/arch/x86/mm/fault.c
@@ -1160,6 +1160,8 @@ good_area:
 	if (fault & VM_FAULT_RETRY) {
 		if (retry_flag) {
 			retry_flag = 0;
+			tsk->maj_flt++;
+			tsk->min_flt--;
 			goto retry;
 		}
 		BUG();
--- mm.orig/mm/memory.c
+++ mm/mm/memory.c
@@ -2882,26 +2882,32 @@ int handle_mm_fault(struct mm_struct *mm
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	int ret;
 
 	__set_current_state(TASK_RUNNING);
 
-	count_vm_event(PGFAULT);
-
-	if (unlikely(is_vm_hugetlb_page(vma)))
-		return hugetlb_fault(mm, vma, address, write_access);
+	if (unlikely(is_vm_hugetlb_page(vma))) {
+		ret = hugetlb_fault(mm, vma, address, write_access);
+		goto out;
+	}
 
+	ret = VM_FAULT_OOM;
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
-		return VM_FAULT_OOM;
+		goto out;
 	pmd = pmd_alloc(mm, pud, address);
 	if (!pmd)
-		return VM_FAULT_OOM;
+		goto out;
 	pte = pte_alloc_map(mm, pmd, address);
 	if (!pte)
-		return VM_FAULT_OOM;
+		goto out;
 
-	return handle_pte_fault(mm, vma, address, pte, pmd, write_access);
+	ret = handle_pte_fault(mm, vma, address, pte, pmd, write_access);
+out:
+	if (!(ret & VM_FAULT_RETRY))
+		count_vm_event(PGFAULT);
+	return ret;
 }
 
 #ifndef __PAGETABLE_PUD_FOLDED

-- 

