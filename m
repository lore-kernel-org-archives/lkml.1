Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZKDG04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZKDG04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZKDG04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:26:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56198 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZKDG0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:26:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Nov 2009 15:24:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       cl@linux-foundation.org, akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] show per-process swap usage via procfs
Message-Id: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Passed several tests and one bug was fixed since RFC version.
This patch is against mmotm.
=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, anon_rss and file_rss is counted as RSS and exported via /proc.
RSS usage is important information but one more information which
is often asked by users is "usage of swap".(user support team said.)

This patch counts swap entry usage per process and show it via
/proc/<pid>/status. I think status file is robust against new entry.
Then, it is the first candidate..

 After this, /proc/<pid>/status includes following line
 <snip>
 VmPeak:   315360 kB
 VmSize:   315360 kB
 VmLck:         0 kB
 VmHWM:    180452 kB
 VmRSS:    180452 kB
 VmData:   311624 kB
 VmStk:        84 kB
 VmExe:         4 kB
 VmLib:      1568 kB
 VmPTE:       640 kB
 VmSwap:   131240 kB <=== new information

Note:
  Because this patch catches swap_pte on page table, this will
  not catch shmem's swapout. It's already accounted in per-shmem
  inode and we don't need to do more.

Changelog: 2009/11/03
 - clean up.
 - fixed initialization bug at fork (init_mm())

Acked-by: Acked-by; David Rientjes <rientjes@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/task_mmu.c       |    9 ++++++---
 include/linux/mm_types.h |    1 +
 kernel/fork.c            |    1 +
 mm/memory.c              |   30 +++++++++++++++++++++---------
 mm/rmap.c                |    1 +
 mm/swapfile.c            |    1 +
 6 files changed, 31 insertions(+), 12 deletions(-)

Index: mmotm-2.6.32-Nov2/include/linux/mm_types.h
===================================================================
--- mmotm-2.6.32-Nov2.orig/include/linux/mm_types.h
+++ mmotm-2.6.32-Nov2/include/linux/mm_types.h
@@ -228,6 +228,7 @@ struct mm_struct {
 	 */
 	mm_counter_t _file_rss;
 	mm_counter_t _anon_rss;
+	mm_counter_t _swap_usage;
 
 	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
Index: mmotm-2.6.32-Nov2/mm/memory.c
===================================================================
--- mmotm-2.6.32-Nov2.orig/mm/memory.c
+++ mmotm-2.6.32-Nov2/mm/memory.c
@@ -376,12 +376,15 @@ int __pte_alloc_kernel(pmd_t *pmd, unsig
 	return 0;
 }
 
-static inline void add_mm_rss(struct mm_struct *mm, int file_rss, int anon_rss)
+static inline void
+add_mm_rss(struct mm_struct *mm, int file_rss, int anon_rss, int swap_usage)
 {
 	if (file_rss)
 		add_mm_counter(mm, file_rss, file_rss);
 	if (anon_rss)
 		add_mm_counter(mm, anon_rss, anon_rss);
+	if (swap_usage)
+		add_mm_counter(mm, swap_usage, swap_usage);
 }
 
 /*
@@ -597,7 +600,9 @@ copy_one_pte(struct mm_struct *dst_mm, s
 						 &src_mm->mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			if (is_write_migration_entry(entry) &&
+			if (!is_migration_entry(entry))
+				rss[2]++;
+			else if (is_write_migration_entry(entry) &&
 					is_cow_mapping(vm_flags)) {
 				/*
 				 * COW mappings require pages in both parent
@@ -648,11 +653,11 @@ static int copy_pte_range(struct mm_stru
 	pte_t *src_pte, *dst_pte;
 	spinlock_t *src_ptl, *dst_ptl;
 	int progress = 0;
-	int rss[2];
+	int rss[3];
 	swp_entry_t entry = (swp_entry_t){0};
 
 again:
-	rss[1] = rss[0] = 0;
+	rss[2] = rss[1] = rss[0] = 0;
 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
 	if (!dst_pte)
 		return -ENOMEM;
@@ -688,7 +693,7 @@ again:
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(src_ptl);
 	pte_unmap_nested(orig_src_pte);
-	add_mm_rss(dst_mm, rss[0], rss[1]);
+	add_mm_rss(dst_mm, rss[0], rss[1], rss[2]);
 	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
 
@@ -818,6 +823,7 @@ static unsigned long zap_pte_range(struc
 	spinlock_t *ptl;
 	int file_rss = 0;
 	int anon_rss = 0;
+	int swap_usage = 0;
 
 	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	arch_enter_lazy_mmu_mode();
@@ -887,13 +893,18 @@ static unsigned long zap_pte_range(struc
 		if (pte_file(ptent)) {
 			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
 				print_bad_pte(vma, addr, ptent, NULL);
-		} else if
-		  (unlikely(!free_swap_and_cache(pte_to_swp_entry(ptent))))
-			print_bad_pte(vma, addr, ptent, NULL);
+		} else {
+			swp_entry_t ent = pte_to_swp_entry(ptent);
+
+			if (!is_migration_entry(ent))
+				swap_usage--;
+			if (unlikely(!free_swap_and_cache(ent)))
+				print_bad_pte(vma, addr, ptent, NULL);
+		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, (addr != end && *zap_work > 0));
 
-	add_mm_rss(mm, file_rss, anon_rss);
+	add_mm_rss(mm, file_rss, anon_rss, swap_usage);
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte - 1, ptl);
 
@@ -2595,6 +2606,7 @@ static int do_swap_page(struct mm_struct
 	 */
 
 	inc_mm_counter(mm, anon_rss);
+	dec_mm_counter(mm, swap_usage);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
Index: mmotm-2.6.32-Nov2/mm/swapfile.c
===================================================================
--- mmotm-2.6.32-Nov2.orig/mm/swapfile.c
+++ mmotm-2.6.32-Nov2/mm/swapfile.c
@@ -837,6 +837,7 @@ static int unuse_pte(struct vm_area_stru
 	}
 
 	inc_mm_counter(vma->vm_mm, anon_rss);
+	dec_mm_counter(vma->vm_mm, swap_usage);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
Index: mmotm-2.6.32-Nov2/fs/proc/task_mmu.c
===================================================================
--- mmotm-2.6.32-Nov2.orig/fs/proc/task_mmu.c
+++ mmotm-2.6.32-Nov2/fs/proc/task_mmu.c
@@ -17,7 +17,7 @@
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
 	unsigned long data, text, lib;
-	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
+	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss, swap;
 
 	/*
 	 * Note: to minimize their overhead, mm maintains hiwater_vm and
@@ -36,6 +36,7 @@ void task_mem(struct seq_file *m, struct
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
+	swap = get_mm_counter(mm, swap_usage);
 	seq_printf(m,
 		"VmPeak:\t%8lu kB\n"
 		"VmSize:\t%8lu kB\n"
@@ -46,7 +47,8 @@ void task_mem(struct seq_file *m, struct
 		"VmStk:\t%8lu kB\n"
 		"VmExe:\t%8lu kB\n"
 		"VmLib:\t%8lu kB\n"
-		"VmPTE:\t%8lu kB\n",
+		"VmPTE:\t%8lu kB\n"
+		"VmSwap:\t%8lu kB\n",
 		hiwater_vm << (PAGE_SHIFT-10),
 		(total_vm - mm->reserved_vm) << (PAGE_SHIFT-10),
 		mm->locked_vm << (PAGE_SHIFT-10),
@@ -54,7 +56,8 @@ void task_mem(struct seq_file *m, struct
 		total_rss << (PAGE_SHIFT-10),
 		data << (PAGE_SHIFT-10),
 		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
-		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10);
+		(PTRS_PER_PTE*sizeof(pte_t)*mm->nr_ptes) >> 10,
+		swap << (PAGE_SHIFT - 10));
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
Index: mmotm-2.6.32-Nov2/mm/rmap.c
===================================================================
--- mmotm-2.6.32-Nov2.orig/mm/rmap.c
+++ mmotm-2.6.32-Nov2/mm/rmap.c
@@ -834,6 +834,7 @@ static int try_to_unmap_one(struct page 
 				spin_unlock(&mmlist_lock);
 			}
 			dec_mm_counter(mm, anon_rss);
+			inc_mm_counter(mm, swap_usage);
 		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
Index: mmotm-2.6.32-Nov2/kernel/fork.c
===================================================================
--- mmotm-2.6.32-Nov2.orig/kernel/fork.c
+++ mmotm-2.6.32-Nov2/kernel/fork.c
@@ -454,6 +454,7 @@ static struct mm_struct * mm_init(struct
 	mm->nr_ptes = 0;
 	set_mm_counter(mm, file_rss, 0);
 	set_mm_counter(mm, anon_rss, 0);
+	set_mm_counter(mm, swap_usage, 0);
 	spin_lock_init(&mm->page_table_lock);
 	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	mm->cached_hole_size = ~0UL;

