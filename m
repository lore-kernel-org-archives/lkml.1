Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbZLOJRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbZLOJRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbZLOJRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:17:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48530 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbZLOJRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:17:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 18:14:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, minchan.kim@gmail.com, Lee.Schermerhorn@hp.com
Subject: [mmotm][PATCH 3/5] mm: count swap usage
Message-Id: <20091215181413.5ae4e2ad.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of frequent questions from users about memory management is
what numbers of swap ents are user for processes. And this information will
give some hints to oom-killer.

Besides we can count the number of swapents per a process by scanning
/proc/<pid>/smaps, this is very slow and not good for usual process information
handler which works like 'ps' or 'top'.
(ps or top is now enough slow..)

This patch adds a counter of swapents to mm_counter and update is at 
each swap events. Information is exported via /proc/<pid>/status file as

[kamezawa@bluextal memory]$ cat /proc/self/status
Name:   cat
State:  R (running)
Tgid:   2910
Pid:    2910
PPid:   2823
TracerPid:      0
Uid:    500     500     500     500
Gid:    500     500     500     500
FDSize: 256
Groups: 500
VmPeak:    82696 kB
VmSize:    82696 kB
VmLck:         0 kB
VmHWM:       432 kB
VmRSS:       432 kB
VmData:      172 kB
VmStk:        84 kB
VmExe:        48 kB
VmLib:      1568 kB
VmPTE:        40 kB
VmSwap:        0 kB <=============== this.

Changelog: 2009/12/14
 - removed a bad comment.
 - Added Documentation

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/filesystems/proc.txt |    2 ++
 fs/proc/task_mmu.c                 |    9 ++++++---
 include/linux/mm_types.h           |    1 +
 mm/memory.c                        |   16 ++++++++++++----
 mm/rmap.c                          |    1 +
 mm/swapfile.c                      |    1 +
 6 files changed, 23 insertions(+), 7 deletions(-)

Index: mmotm-2.6.32-Dec8-pth/include/linux/mm_types.h
===================================================================
--- mmotm-2.6.32-Dec8-pth.orig/include/linux/mm_types.h
+++ mmotm-2.6.32-Dec8-pth/include/linux/mm_types.h
@@ -196,6 +196,7 @@ struct core_state {
 enum {
 	MM_FILEPAGES,
 	MM_ANONPAGES,
+	MM_SWAPENTS,
 	NR_MM_COUNTERS
 };
 
Index: mmotm-2.6.32-Dec8-pth/mm/memory.c
===================================================================
--- mmotm-2.6.32-Dec8-pth.orig/mm/memory.c
+++ mmotm-2.6.32-Dec8-pth/mm/memory.c
@@ -679,7 +679,9 @@ copy_one_pte(struct mm_struct *dst_mm, s
 						 &src_mm->mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			if (is_write_migration_entry(entry) &&
+			if (likely(!non_swap_entry(entry)))
+				rss[MM_SWAPENTS]++;
+			else if (is_write_migration_entry(entry) &&
 					is_cow_mapping(vm_flags)) {
 				/*
 				 * COW mappings require pages in both parent
@@ -974,9 +976,14 @@ static unsigned long zap_pte_range(struc
 		if (pte_file(ptent)) {
 			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
 				print_bad_pte(vma, addr, ptent, NULL);
-		} else if
-		  (unlikely(!free_swap_and_cache(pte_to_swp_entry(ptent))))
-			print_bad_pte(vma, addr, ptent, NULL);
+		} else {
+			swp_entry_t entry = pte_to_swp_entry(ptent);
+
+			if (!non_swap_entry(entry))
+				rss[MM_SWAPENTS]--;
+		  	if (unlikely(!free_swap_and_cache(entry)))
+				print_bad_pte(vma, addr, ptent, NULL);
+		}
 		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
 	} while (pte++, addr += PAGE_SIZE, (addr != end && *zap_work > 0));
 
@@ -2688,6 +2695,7 @@ static int do_swap_page(struct mm_struct
 	 */
 
 	inc_mm_counter_fast(mm, MM_ANONPAGES);
+	dec_mm_counter_fast(mm, MM_SWAPENTS);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
Index: mmotm-2.6.32-Dec8-pth/mm/rmap.c
===================================================================
--- mmotm-2.6.32-Dec8-pth.orig/mm/rmap.c
+++ mmotm-2.6.32-Dec8-pth/mm/rmap.c
@@ -840,6 +840,7 @@ int try_to_unmap_one(struct page *page, 
 				spin_unlock(&mmlist_lock);
 			}
 			dec_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter(mm, MM_SWAPENTS);
 		} else if (PAGE_MIGRATION) {
 			/*
 			 * Store the pfn of the page in a special migration
Index: mmotm-2.6.32-Dec8-pth/mm/swapfile.c
===================================================================
--- mmotm-2.6.32-Dec8-pth.orig/mm/swapfile.c
+++ mmotm-2.6.32-Dec8-pth/mm/swapfile.c
@@ -840,6 +840,7 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
+	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
Index: mmotm-2.6.32-Dec8-pth/fs/proc/task_mmu.c
===================================================================
--- mmotm-2.6.32-Dec8-pth.orig/fs/proc/task_mmu.c
+++ mmotm-2.6.32-Dec8-pth/fs/proc/task_mmu.c
@@ -16,7 +16,7 @@
 
 void task_mem(struct seq_file *m, struct mm_struct *mm)
 {
-	unsigned long data, text, lib;
+	unsigned long data, text, lib, swap;
 	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
 
 	/*
@@ -36,6 +36,7 @@ void task_mem(struct seq_file *m, struct
 	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
 	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
 	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
+	swap = get_mm_counter(mm, MM_SWAPENTS);
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
+		swap << (PAGE_SHIFT-10));
 }
 
 unsigned long task_vsize(struct mm_struct *mm)
Index: mmotm-2.6.32-Dec8-pth/Documentation/filesystems/proc.txt
===================================================================
--- mmotm-2.6.32-Dec8-pth.orig/Documentation/filesystems/proc.txt
+++ mmotm-2.6.32-Dec8-pth/Documentation/filesystems/proc.txt
@@ -164,6 +164,7 @@ read the file /proc/PID/status:
   VmExe:        68 kB
   VmLib:      1412 kB
   VmPTE:        20 kb
+  VmSwap:        0 kB
   Threads:        1
   SigQ:   0/28578
   SigPnd: 0000000000000000
@@ -220,6 +221,7 @@ Table 1-2: Contents of the statm files (
  VmExe                       size of text segment
  VmLib                       size of shared library code
  VmPTE                       size of page table entries
+ VmSwap                      size of swap usage (the number of referred swapents)
  Threads                     number of threads
  SigQ                        number of signals queued/max. number for queue
  SigPnd                      bitmap of pending signals for the thread

