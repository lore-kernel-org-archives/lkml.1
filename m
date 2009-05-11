Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZEKI2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZEKI2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZEKI12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:27:28 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:62698 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178AbZEKI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:27:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.40,327,1238968800";   d="scan'208";a="11399171"
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/4]: affinity-on-next-touch
Date: Mon, 11 May 2009 10:27:28 +0200
Organization: Chair for Operating Systems, RWTH Aachen University
Message-id: <000e01c9d212$5285bb30$f7913190$@rwth-aachen.de>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcnSElI2NpsxeiQMRsKmDfQ98C9GWg==
Content-language: de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch 2/4]: The pte fault handler detects, via a new "untouched bit" inside
of the "page" record, that the page which the thread tried to access uses
"affinity-on-next-touch". Afterwards, the kernel reads the original
permissions from vm_area_struct, restores them in the page tables and
migrates the page to the current node. To accelerate page migration, the
patch avoids unnecessary calls to migrate_prep().


mm/memory.c |   85
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1 files changed, 85 insertions(+), 0 deletions(-)


diff --git a/mm/memory.c b/mm/memory.c
index 4126dd1..cc4b9b7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -55,6 +55,8 @@
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
 #include <linux/elf.h>
+#include <linux/cpuset.h>
+#include <linux/migrate.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -2839,6 +2841,55 @@ static int do_nonlinear_fault(struct mm_struct *mm,
struct vm_area_struct *vma,
        return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+static struct page *new_single_page(struct page *p, unsigned long node, int
**result)
+{
+       *result = NULL;
+       return alloc_pages_node((int)node, GFP_HIGHUSER_MOVABLE |
GFP_THISNODE, 0);
+}
+
+/*
+ * If the page is already on the correct node or the destination node
+ * is not allowed to possess the page, the page will be not migrate
+ * to the current node.
+ *
+ * If the migration failed, we leave the page on the original node. 
+ */
+static inline void migrate_page_to_current_node(struct page* page) 
+{
+       unsigned long source = page_to_nid(page);
+       unsigned long dest = numa_node_id();
+       nodemask_t task_nodes;
+       LIST_HEAD(pagelist);
+
+       if (dest == source)
+               return;
+
+       task_nodes = cpuset_mems_allowed(current);
+       if (!node_isset(dest, task_nodes)) {
+               count_vm_event(AONT_INVALID_NODEMASK);
+               return;
+       }
+
+       if (!PageLRU(page))
+               lru_add_drain();
+
+       if (isolate_lru_page(page) != 0) {
+               count_vm_event(AONT_ISOLATE_BUSY);
+               migrate_prep();
+               if (isolate_lru_page(page) != 0) 
+                       count_vm_event(AONT_ISOLATE_FAILED);
+               else
+                       list_add_tail(&page->lru, &pagelist);
+       } else list_add_tail(&page->lru, &pagelist);
+
+       if (likely(!list_empty(&pagelist))) {
+               if (migrate_pages(&pagelist, new_single_page, dest) != 0)
+                       count_vm_event(AONT_MIGRATION_FAILED);
+       }
+}
+#endif
+
  /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -2851,6 +2902,10 @@ static int do_nonlinear_fault(struct mm_struct *mm,
struct vm_area_struct *vma,
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
  * We return with mmap_sem still held, but pte unmapped and unlocked.
+ *
+ * If the page placement strategy "affinity-on-next-touch" is used,
+ * we migrate the page to the current node and restore the original
+ * access permissions.
  */
 static inline int handle_pte_fault(struct mm_struct *mm,
                struct vm_area_struct *vma, unsigned long address,
@@ -2881,6 +2936,36 @@ static inline int handle_pte_fault(struct mm_struct
*mm,
        spin_lock(ptl);
        if (unlikely(!pte_same(*pte, entry)))
                goto unlock;
+#ifdef CONFIG_AFFINITY_ON_NEXT_TOUCH
+       if (vma_migratable(vma)) {
+               struct page* page = vm_normal_page(vma, address, entry);
+               if (page && !PageReserved(page) 
+                 && TestClearPageUntouched(page)) {
+                       __clear_page_locked(page);
+
+                       /* 
+                        * NOTE! Cache and TLB cache are already flushed in
+                        * the system call madvise
+                        */
+
+                       arch_enter_lazy_mmu_mode();
+
+                       /* restore original access permissions */
+                       entry = ptep_modify_prot_start(mm, address, pte);
+                       entry = pte_modify(entry, vma->vm_page_prot);
+                       ptep_modify_prot_commit(mm, address, pte, entry);
+
+                       arch_leave_lazy_mmu_mode();
+                       pte_unmap_unlock(pte, ptl);
+                       mmu_notifier_invalidate_page(mm,
PAGE_ALIGN(address));
+
+                       /* migrate page */
+                       migrate_page_to_current_node(page);
+
+                       return 0;
+               }
+       }
+#endif
        if (write_access) {
                if (!pte_write(entry))
                        return do_wp_page(mm, vma, address,



