Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZFTDYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZFTDYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 23:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZFTDUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 23:20:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:5938 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbZFTDUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 23:20:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,257,1243839600"; 
   d="scan'208";a="156644153"
Message-Id: <20090620031625.292136698@intel.com>
References: <20090620031608.624240019@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 20 Jun 2009 11:16:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>
Cc: Minchan Kim <minchan.kim@gmail.com>
cc: Mel Gorman <mel@csn.ul.ie>
cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 05/15] HWPOISON: Add basic support for poisoned pages in fault handler v3
Content-Disposition: inline; filename=vm-fault-poison
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Add a new VM_FAULT_HWPOISON error code to handle_mm_fault. Right now
architectures have to explicitely enable poison page support, so
this is forward compatible to all architectures. They only need
to add it when they enable poison page support.
- Add poison page handling in swap in fault code

v2: Add missing delayacct_clear_flag (Hidehiro Kawai)
v3: Really use delayacct_clear_flag (Hidehiro Kawai)

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/mm.h |    3 ++-
 mm/memory.c        |   18 +++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

--- sound-2.6.orig/mm/memory.c
+++ sound-2.6/mm/memory.c
@@ -1315,7 +1315,8 @@ int __get_user_pages(struct task_struct 
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
 						return i ? i : -ENOMEM;
-					else if (ret & VM_FAULT_SIGBUS)
+					if (ret &
+					    (VM_FAULT_HWPOISON|VM_FAULT_SIGBUS))
 						return i ? i : -EFAULT;
 					BUG();
 				}
@@ -2595,8 +2596,15 @@ static int do_swap_page(struct mm_struct
 		goto out;
 
 	entry = pte_to_swp_entry(orig_pte);
-	if (is_migration_entry(entry)) {
-		migration_entry_wait(mm, pmd, address);
+	if (unlikely(non_swap_entry(entry))) {
+		if (is_migration_entry(entry)) {
+			migration_entry_wait(mm, pmd, address);
+		} else if (is_hwpoison_entry(entry)) {
+			ret = VM_FAULT_HWPOISON;
+		} else {
+			print_bad_pte(vma, address, pte, NULL);
+			ret = VM_FAULT_OOM;
+		}
 		goto out;
 	}
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
@@ -2620,6 +2628,10 @@ static int do_swap_page(struct mm_struct
 		/* Had to read the page from swap area: Major fault */
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
+	} else if (PageHWPoison(page)) {
+		ret = VM_FAULT_HWPOISON;
+		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+		goto out;
 	}
 
 	lock_page(page);
--- sound-2.6.orig/include/linux/mm.h
+++ sound-2.6/include/linux/mm.h
@@ -700,11 +700,12 @@ static inline int page_mapped(struct pag
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
 #define VM_FAULT_WRITE	0x0008	/* Special case for get_user_pages */
+#define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned page */
 
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 
-#define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS)
+#define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_HWPOISON)
 
 /*
  * Can be called by the pagefault handler when it gets a VM_FAULT_OOM.

-- 

