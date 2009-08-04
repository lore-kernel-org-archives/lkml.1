Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbZHDVzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbZHDVzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933191AbZHDVxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:53:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43941 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933085AbZHDVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:53:04 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908041152.240876191@firstfloor.org>
In-Reply-To: <200908041152.240876191@firstfloor.org>
To: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: [PATCH] [5/15] HWPOISON: Add basic support for poisoned pages in fault handler v3
Message-Id: <20090804215304.4AFB3B15D8@basil.firstfloor.org>
Date: Tue,  4 Aug 2009 23:53:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Add a new VM_FAULT_HWPOISON error code to handle_mm_fault. Right now
architectures have to explicitely enable poison page support, so
this is forward compatible to all architectures. They only need
to add it when they enable poison page support.
- Add poison page handling in swap in fault code

v2: Add missing delayacct_clear_flag (Hidehiro Kawai)
v3: Really use delayacct_clear_flag (Hidehiro Kawai)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/mm.h |    3 ++-
 mm/memory.c        |   18 +++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

Index: linux/mm/memory.c
===================================================================
--- linux.orig/mm/memory.c
+++ linux/mm/memory.c
@@ -1319,7 +1319,8 @@ int __get_user_pages(struct task_struct
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
 						return i ? i : -ENOMEM;
-					else if (ret & VM_FAULT_SIGBUS)
+					if (ret &
+					    (VM_FAULT_HWPOISON|VM_FAULT_SIGBUS))
 						return i ? i : -EFAULT;
 					BUG();
 				}
@@ -2511,8 +2512,15 @@ static int do_swap_page(struct mm_struct
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
@@ -2536,6 +2544,10 @@ static int do_swap_page(struct mm_struct
 		/* Had to read the page from swap area: Major fault */
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
+	} else if (PageHWPoison(page)) {
+		ret = VM_FAULT_HWPOISON;
+		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+		goto out;
 	}
 
 	lock_page(page);
Index: linux/include/linux/mm.h
===================================================================
--- linux.orig/include/linux/mm.h
+++ linux/include/linux/mm.h
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
