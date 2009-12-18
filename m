Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZLRAtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZLRAtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZLRAtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:49:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40124 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZLRAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:49:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 18 Dec 2009 09:46:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: [RFC 4/4] speculative pag fault
Message-Id: <20091218094602.3dcd5a02.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091218093849.8ba69ad9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216101107.GA15031@basil.fritz.box>
	<20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216102806.GC15031@basil.fritz.box>
	<28c262360912160231r18db8478sf41349362360cab8@mail.gmail.com>
	<20091216193315.14a508d5.kamezawa.hiroyu@jp.fujitsu.com>
	<20091218093849.8ba69ad9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lookup vma in lockless style, do page fault, and check mm's version
after takine page table lock. If racy, mm's version is invalid .
Then, retry page fault.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/x86/mm/fault.c |   28 +++++++++++++++++++++++++---
 mm/memory.c         |   21 ++++++++++++++-------
 2 files changed, 39 insertions(+), 10 deletions(-)

Index: mmotm-mm-accessor/arch/x86/mm/fault.c
===================================================================
--- mmotm-mm-accessor.orig/arch/x86/mm/fault.c
+++ mmotm-mm-accessor/arch/x86/mm/fault.c
@@ -11,6 +11,7 @@
 #include <linux/kprobes.h>		/* __kprobes, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
 #include <linux/perf_event.h>		/* perf_sw_event		*/
+#include <linux/hugetlb.h>		/* is_vm_hugetlb...*/
 
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
@@ -952,6 +953,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	struct mm_struct *mm;
 	int write;
 	int fault;
+	int speculative;
 
 	tsk = current;
 	mm = tsk->mm;
@@ -1040,6 +1042,17 @@ do_page_fault(struct pt_regs *regs, unsi
 		return;
 	}
 
+	if ((error_code & PF_USER) && mm_version_check(mm)) {
+		vma = lookup_vma_cache(mm, address);
+		if (vma && mm_version_check(mm) &&
+		   (vma->vm_start <= address) && (address < vma->vm_end)) {
+			speculative = 1;
+			goto found_vma;
+		}
+		if (vma)
+			vma_release(vma);
+	}
+
 	/*
 	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in
@@ -1056,6 +1069,8 @@ do_page_fault(struct pt_regs *regs, unsi
 	 * validate the source. If this is invalid we can skip the address
 	 * space check, thus avoiding the deadlock:
 	 */
+retry_with_lock:
+	speculative = 0;
 	if (unlikely(!mm_read_trylock(mm))) {
 		if ((error_code & PF_USER) == 0 &&
 		    !search_exception_tables(regs->ip)) {
@@ -1073,6 +1088,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	}
 
 	vma = find_vma(mm, address);
+found_vma:
 	if (unlikely(!vma)) {
 		bad_area(regs, error_code, address);
 		return;
@@ -1119,6 +1135,7 @@ good_area:
 	 */
 	fault = handle_mm_fault(mm, vma, address, write ? FAULT_FLAG_WRITE : 0);
 
+
 	if (unlikely(fault & VM_FAULT_ERROR)) {
 		mm_fault_error(regs, error_code, address, fault);
 		return;
@@ -1128,13 +1145,18 @@ good_area:
 		tsk->maj_flt++;
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
 				     regs, address);
-	} else {
+	} else if (!speculative || mm_version_check(mm)) {
 		tsk->min_flt++;
 		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
 				     regs, address);
+	} else {
+		vma_release(vma);
+		goto retry_with_lock;
 	}
 
 	check_v8086_mode(regs, address, tsk);
-
-	mm_read_unlock(mm);
+	if (!speculative)
+		mm_read_unlock(mm);
+	else
+		vma_release(vma);
 }
Index: mmotm-mm-accessor/mm/memory.c
===================================================================
--- mmotm-mm-accessor.orig/mm/memory.c
+++ mmotm-mm-accessor/mm/memory.c
@@ -121,6 +121,13 @@ static int __init init_zero_pfn(void)
 }
 core_initcall(init_zero_pfn);
 
+static bool test_valid_pte(struct mm_struct *mm, pte_t pte, pte_t orig)
+{
+	if (likely(mm_version_check(mm) && pte_same(pte, orig)))
+		return true;
+	return false;
+}
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but
@@ -2044,7 +2051,7 @@ static int do_wp_page(struct mm_struct *
 			lock_page(old_page);
 			page_table = pte_offset_map_lock(mm, pmd, address,
 							 &ptl);
-			if (!pte_same(*page_table, orig_pte)) {
+			if (!test_valid_pte(mm, *page_table, orig_pte)) {
 				unlock_page(old_page);
 				page_cache_release(old_page);
 				goto unlock;
@@ -2105,7 +2112,7 @@ static int do_wp_page(struct mm_struct *
 			 */
 			page_table = pte_offset_map_lock(mm, pmd, address,
 							 &ptl);
-			if (!pte_same(*page_table, orig_pte)) {
+			if (!test_valid_pte(mm, *page_table, orig_pte)) {
 				unlock_page(old_page);
 				page_cache_release(old_page);
 				goto unlock;
@@ -2169,7 +2176,7 @@ gotten:
 	 * Re-check the pte - we dropped the lock
 	 */
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (likely(pte_same(*page_table, orig_pte))) {
+	if (test_valid_pte(mm, *page_table, orig_pte)) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
 				dec_mm_counter(mm, file_rss);
@@ -2555,7 +2562,7 @@ static int do_swap_page(struct mm_struct
 			 * while we released the pte lock.
 			 */
 			page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-			if (likely(pte_same(*page_table, orig_pte)))
+			if (pte_same(*page_table, orig_pte))
 				ret = VM_FAULT_OOM;
 			delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 			goto unlock;
@@ -2588,7 +2595,7 @@ static int do_swap_page(struct mm_struct
 	 * Back out if somebody else already faulted in this pte.
 	 */
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (unlikely(!pte_same(*page_table, orig_pte)))
+	if (unlikely(!test_valid_pte(mm, *page_table, orig_pte)))
 		goto out_nomap;
 
 	if (unlikely(!PageUptodate(page))) {
@@ -2844,7 +2851,7 @@ static int __do_fault(struct mm_struct *
 	 * handle that later.
 	 */
 	/* Only go through if we didn't race with anybody else... */
-	if (likely(pte_same(*page_table, orig_pte))) {
+	if (likely(test_valid_pte(mm, *page_table, orig_pte))) {
 		flush_icache_page(vma, page);
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (flags & FAULT_FLAG_WRITE)
@@ -2991,7 +2998,7 @@ static inline int handle_pte_fault(struc
 
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
-	if (unlikely(!pte_same(*pte, entry)))
+	if (unlikely(!test_valid_pte(mm, *pte, entry)))
 		goto unlock;
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!pte_write(entry))

