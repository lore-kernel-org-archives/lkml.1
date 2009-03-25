Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbZCYSFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbZCYSFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbZCYSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:05:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42565 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbZCYSFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:05:41 -0400
Subject: Latest mm tracepoints patch merged to your tip tree
From: Larry Woodman <lwoodman@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
References: <1233306324.11332.11.camel@nigel-laptop>
	 <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>
	 <20090306105627.3EF0.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com>
	 <20090306110423.GD21168@elte.hu>
	 <1236342797.3154.1.camel@dhcp47-138.lab.bos.redhat.com>
	 <20090306135547.GB21907@elte.hu>
	 <1236358657.1476.56.camel@dhcp-100-19-198.bos.redhat.com>
Content-Type: multipart/mixed; boundary="=-klGgT/77byJk5gC9yx+d"
Date: Wed, 25 Mar 2009 14:09:31 -0400
Message-Id: <1238004571.1476.188.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-klGgT/77byJk5gC9yx+d
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Ingo, attached is the latest mm tracepoints patch I sent to lkml
yesterday merged up to your latest tip tree in
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

--------------------------------------------------------------------

I've implemented several mm tracepoints to track page allocation and
freeing, various types of pagefaults and unmaps, and critical page
reclamation routines.  This is useful for debugging memory allocation
issues and system performance problems under heavy memory loads.

I have also addressed Rik van Riel's comments:

>It looks mostly good.
>
>I believe that the vmscan.c tracepoints could be a little
>more verbose though, it would be useful to know whether we
>are scanning anon or file pages and whether or not we're
>doing lumpy reclaim.  Possibly the priority level, too.

----------------------------------------------------------------------


# tracer: mm
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
         pdflush-624   [004]   184.293169: wb_kupdate:
(mm_pdflush_kupdate) count=3e48
         pdflush-624   [004]   184.293439: get_page_from_freelist:
(mm_page_allocation) pfn=447c27 zone_free=1940910
        events/6-33    [006]   184.962879: free_hot_cold_page:
(mm_page_free) pfn=44bba9
      irqbalance-8313  [001]   188.042951: unmap_vmas:
(mm_anon_userfree) mm=ffff88044a7300c0 address=7f9a2eb70000 pfn=24c29a
             cat-9122  [005]   191.141173: filemap_fault:
(mm_filemap_fault) primary fault: mm=ffff88024c9d8f40 address=3cea2dd000
pfn=44d68e
             cat-9122  [001]   191.143036: handle_mm_fault:
(mm_anon_fault) mm=ffff88024c8beb40 address=7fffbde99f94 pfn=24ce22
...



Signed-off-by: Larry Woodman <lwoodman@redhat.com>

--=-klGgT/77byJk5gC9yx+d
Content-Disposition: attachment; filename=mm_tracepoints.patch
Content-Type: text/x-patch; name=mm_tracepoints.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/include/trace/mm.h b/include/trace/mm.h
new file mode 100644
index 0000000..c44658d
--- /dev/null
+++ b/include/trace/mm.h
@@ -0,0 +1,9 @@
+#ifndef _TRACE_MM_H
+#define _TRACE_MM_H
+
+#include <linux/mm.h>
+#include <linux/tracepoint.h>
+
+#include <trace/mm_event_types.h>
+
+#endif
diff --git a/include/trace/mm_event_types.h b/include/trace/mm_event_types.h
new file mode 100644
index 0000000..dffbd75
--- /dev/null
+++ b/include/trace/mm_event_types.h
@@ -0,0 +1,503 @@
+/* use <trace/mm.h> instead */
+#ifndef TRACE_FORMAT
+# error Do not include this file directly.
+# error Unless you know what you are doing.
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mm
+
+TRACE_EVENT(mm_anon_fault,
+
+	TP_PROTO(struct mm_struct *mm,
+			unsigned long address, unsigned long pfn),
+
+	TP_ARGS(mm, address, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("mm=%lx address=%lx pfn=%lx",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+);
+
+TRACE_EVENT(mm_anon_pgin,
+
+	TP_PROTO(struct mm_struct *mm,
+			unsigned long address, unsigned long pfn),
+
+	TP_ARGS(mm, address, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("mm=%lx address=%lx pfn=%lx",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+	);
+
+TRACE_EVENT(mm_anon_cow,
+
+	TP_PROTO(struct mm_struct *mm,
+			unsigned long address, unsigned long pfn),
+
+	TP_ARGS(mm, address, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("mm=%lx address=%lx pfn=%lx",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+	);
+
+TRACE_EVENT(mm_anon_userfree,
+
+	TP_PROTO(struct mm_struct *mm,
+			unsigned long address, unsigned long pfn),
+
+	TP_ARGS(mm, address, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("mm=%lx address=%lx pfn=%lx",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+	);
+
+TRACE_EVENT(mm_anon_unmap,
+
+	TP_PROTO(unsigned long pfn, int success),
+
+	TP_ARGS(pfn, success),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, success)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->success = success;
+	),
+
+	TP_printk("%s: pfn=%lx",
+		__entry->success ? "succeeded" : "failed", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_filemap_fault,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long address,
+			unsigned long pfn, int flag),
+	TP_ARGS(mm, address, pfn, flag),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+		__field(int, flag)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+		__entry->flag = flag;
+	),
+
+	TP_printk("%s: mm=%lx address=%lx pfn=%lx",
+		__entry->flag ? "pagein" : "primary fault",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+	);
+
+TRACE_EVENT(mm_filemap_cow,
+
+	TP_PROTO(struct mm_struct *mm,
+			unsigned long address, unsigned long pfn),
+
+	TP_ARGS(mm, address, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("mm=%lx address=%lx pfn=%lx",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+	);
+
+TRACE_EVENT(mm_filemap_unmap,
+
+	TP_PROTO(unsigned long pfn, int success),
+
+	TP_ARGS(pfn, success),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, success)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->success = success;
+	),
+
+	TP_printk("%s: pfn=%lx",
+		__entry->success ? "succeeded" : "failed", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_filemap_userunmap,
+
+	TP_PROTO(struct mm_struct *mm,
+			unsigned long address, unsigned long pfn),
+
+	TP_ARGS(mm, address, pfn),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long, address)
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->address = address;
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("mm=%lx address=%lx pfn=%lx",
+		(unsigned long)__entry->mm, __entry->address, __entry->pfn)
+	);
+
+TRACE_EVENT(mm_pagereclaim_pgout,
+
+	TP_PROTO(unsigned long pfn, int anon),
+
+	TP_ARGS(pfn, anon),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, anon)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->anon = anon;
+	),
+
+	TP_printk("%s: pfn=%lx",
+		__entry->anon ? "anonymous" : "pagecache", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_pagereclaim_free,
+
+	TP_PROTO(unsigned long pfn, int anon),
+
+	TP_ARGS(pfn, anon),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(int, anon)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->anon = anon;
+	),
+
+	TP_printk("%s: pfn=%lx",
+		__entry->anon ? "anonymous" : "pagecache", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_pdflush_bgwriteout,
+
+	TP_PROTO(unsigned long count),
+
+	TP_ARGS(count),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, count)
+	),
+
+	TP_fast_assign(
+		__entry->count = count;
+	),
+
+	TP_printk("count=%lx", __entry->count)
+	);
+
+TRACE_EVENT(mm_pdflush_kupdate,
+
+	TP_PROTO(unsigned long count),
+
+	TP_ARGS(count),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, count)
+	),
+
+	TP_fast_assign(
+		__entry->count = count;
+	),
+
+	TP_printk("count=%lx", __entry->count)
+	);
+
+TRACE_EVENT(mm_page_allocation,
+
+	TP_PROTO(unsigned long pfn, unsigned long free),
+
+	TP_ARGS(pfn, free),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(unsigned long, free)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->free = free;
+	),
+
+	TP_printk("pfn=%lx zone_free=%ld", __entry->pfn, __entry->free)
+	);
+
+TRACE_EVENT(mm_kswapd_runs,
+
+	TP_PROTO(unsigned long reclaimed),
+
+	TP_ARGS(reclaimed),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->reclaimed = reclaimed;
+	),
+
+	TP_printk("reclaimed=%lx", __entry->reclaimed)
+	);
+
+TRACE_EVENT(mm_directreclaim_reclaimall,
+
+	TP_PROTO(unsigned long priority),
+
+	TP_ARGS(priority),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, priority)
+	),
+
+	TP_fast_assign(
+		__entry->priority = priority;
+	),
+
+	TP_printk("priority=%lx", __entry->priority)
+	);
+
+TRACE_EVENT(mm_directreclaim_reclaimzone,
+
+	TP_PROTO(unsigned long reclaimed),
+
+	TP_ARGS(reclaimed),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->reclaimed = reclaimed;
+	),
+
+	TP_printk("reclaimed=%lx", __entry->reclaimed)
+	);
+TRACE_EVENT(mm_pagereclaim_shrinkzone,
+
+	TP_PROTO(unsigned long reclaimed),
+
+	TP_ARGS(reclaimed),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->reclaimed = reclaimed;
+	),
+
+	TP_printk("reclaimed=%lx", __entry->reclaimed)
+	);
+
+TRACE_EVENT(mm_pagereclaim_shrinkactive,
+
+	TP_PROTO(unsigned long scanned, int file, int priority),
+
+	TP_ARGS(scanned, file, priority),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, scanned)
+		__field(int, file)
+		__field(int, priority)
+	),
+
+	TP_fast_assign(
+		__entry->scanned = scanned;
+		__entry->file = file;
+		__entry->priority = priority;
+	),
+
+	TP_printk("scanned=%lx, %s, priority=%d",
+		__entry->scanned, __entry->file ? "anonymous" : "pagecache",
+		__entry->priority)
+	);
+
+TRACE_EVENT(mm_pagereclaim_shrinkactive_a2a,
+
+	TP_PROTO(unsigned long pfn),
+
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn=%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_pagereclaim_shrinkactive_a2i,
+
+	TP_PROTO(unsigned long pfn),
+
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn=%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_pagereclaim_shrinkinactive,
+
+	TP_PROTO(unsigned long scanned, int file, int priority),
+
+	TP_ARGS(scanned, file, priority),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, scanned)
+		__field(int, file)
+		__field(int, priority)
+	),
+
+	TP_fast_assign(
+		__entry->scanned = scanned;
+		__entry->file = file;
+		__entry->priority = priority;
+	),
+
+	TP_printk("scanned=%lx, %s, priority=%d",
+		__entry->scanned, __entry->file ? "anonymous" : "pagecache",
+		__entry->priority)
+	);
+
+TRACE_EVENT(mm_pagereclaim_shrinkinactive_i2a,
+
+	TP_PROTO(unsigned long pfn),
+
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn=%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_pagereclaim_shrinkinactive_i2i,
+
+	TP_PROTO(unsigned long pfn),
+
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn=%lx", __entry->pfn)
+	);
+
+TRACE_EVENT(mm_page_free,
+
+	TP_PROTO(unsigned long pfn),
+
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn=%lx", __entry->pfn)
+	);
+#undef TRACE_SYSTEM
diff --git a/include/trace/trace_event_types.h b/include/trace/trace_event_types.h
index df56f56..153d262 100644
--- a/include/trace/trace_event_types.h
+++ b/include/trace/trace_event_types.h
@@ -3,3 +3,4 @@
 #include <trace/sched_event_types.h>
 #include <trace/irq_event_types.h>
 #include <trace/lockdep_event_types.h>
+#include <trace/mm_event_types.h>
diff --git a/include/trace/trace_events.h b/include/trace/trace_events.h
index fd13750..2752e7f 100644
--- a/include/trace/trace_events.h
+++ b/include/trace/trace_events.h
@@ -3,3 +3,4 @@
 #include <trace/sched.h>
 #include <trace/irq.h>
 #include <trace/lockdep.h>
+#include <trace/mm.h>
diff --git a/mm/filemap.c b/mm/filemap.c
index 126d397..9c68755 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -34,6 +34,7 @@
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h> /* for page_is_file_cache() */
+#include <trace/mm.h>
 #include "internal.h"
 
 /*
@@ -1436,6 +1437,7 @@ static int page_cache_read(struct file *file, pgoff_t offset)
 
 #define MMAP_LOTSAMISS  (100)
 
+DEFINE_TRACE(mm_filemap_fault);
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1547,6 +1549,8 @@ retry_find:
 	 */
 	ra->prev_pos = (loff_t)page->index << PAGE_CACHE_SHIFT;
 	vmf->page = page;
+	trace_mm_filemap_fault(vma->vm_mm, (unsigned long)vmf->virtual_address,
+			page_to_pfn(page), vmf->flags&FAULT_FLAG_NONLINEAR);
 	return ret | VM_FAULT_LOCKED;
 
 no_cached_page:
diff --git a/mm/memory.c b/mm/memory.c
index ef11ac6..b007dea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -57,6 +57,7 @@
 #include <linux/kallsyms.h>
 #include <linux/swapops.h>
 #include <linux/elf.h>
+#include <trace/mm.h>
 
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h>
@@ -760,6 +761,8 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	return ret;
 }
 
+DEFINE_TRACE(mm_anon_userfree);
+DEFINE_TRACE(mm_filemap_userunmap);
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -814,15 +817,19 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 						addr) != page->index)
 				set_pte_at(mm, addr, pte,
 					   pgoff_to_pte(page->index));
-			if (PageAnon(page))
+			if (PageAnon(page)) {
 				anon_rss--;
-			else {
+				trace_mm_anon_userfree(mm, addr,
+							page_to_pfn(page));
+			} else {
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent) &&
 				    likely(!VM_SequentialReadHint(vma)))
 					mark_page_accessed(page);
 				file_rss--;
+				trace_mm_filemap_userunmap(mm, addr,
+							page_to_pfn(page));
 			}
 			page_remove_rmap(page);
 			if (unlikely(page_mapcount(page) < 0))
@@ -1871,6 +1878,8 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
 		copy_user_highpage(dst, src, va, vma);
 }
 
+DEFINE_TRACE(mm_anon_cow);
+DEFINE_TRACE(mm_filemap_cow);
 /*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
@@ -1893,7 +1902,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		spinlock_t *ptl, pte_t orig_pte)
 {
-	struct page *old_page, *new_page;
+	struct page *old_page, *new_page = NULL;
 	pte_t entry;
 	int reuse = 0, ret = 0;
 	int page_mkwrite = 0;
@@ -2023,9 +2032,14 @@ gotten:
 			if (!PageAnon(old_page)) {
 				dec_mm_counter(mm, file_rss);
 				inc_mm_counter(mm, anon_rss);
+				trace_mm_filemap_cow(mm, address,
+					page_to_pfn(new_page));
 			}
-		} else
+		} else {
 			inc_mm_counter(mm, anon_rss);
+			trace_mm_anon_cow(mm, address,
+					page_to_pfn(new_page));
+		}
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2390,6 +2404,7 @@ int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
 	return 0;
 }
 
+DEFINE_TRACE(mm_anon_pgin);
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -2503,6 +2518,7 @@ static int do_swap_page(struct mm_struct *mm, struct vm_area_struct *vma,
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 out:
+	trace_mm_anon_pgin(mm, address, page_to_pfn(page));
 	return ret;
 out_nomap:
 	mem_cgroup_cancel_charge_swapin(ptr);
@@ -2512,6 +2528,7 @@ out_nomap:
 	return ret;
 }
 
+DEFINE_TRACE(mm_anon_fault);
 /*
  * We enter with non-exclusive mmap_sem (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -2535,6 +2552,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto oom;
 	__SetPageUptodate(page);
 
+	trace_mm_anon_fault(mm, address, page_to_pfn(page));
 	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
 		goto oom_free_page;
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 74dc57c..7ebd33c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -34,6 +34,7 @@
 #include <linux/syscalls.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <trace/mm.h>
 
 /*
  * The maximum number of pages to writeout in a single bdflush/kupdate
@@ -677,6 +678,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
         }
 }
 
+DEFINE_TRACE(mm_pdflush_bgwriteout);
 /*
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
@@ -716,6 +718,7 @@ static void background_writeout(unsigned long _min_pages)
 				break;
 		}
 	}
+	trace_mm_pdflush_bgwriteout(_min_pages);
 }
 
 /*
@@ -737,6 +740,7 @@ static void laptop_timer_fn(unsigned long unused);
 static DEFINE_TIMER(wb_timer, wb_timer_fn, 0, 0);
 static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
 
+DEFINE_TRACE(mm_pdflush_kupdate);
 /*
  * Periodic writeback of "old" data.
  *
@@ -776,6 +780,7 @@ static void wb_kupdate(unsigned long arg)
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+	trace_mm_pdflush_kupdate(nr_to_write);
 	while (nr_to_write > 0) {
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a699952..a1ff16b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -47,6 +47,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <trace/mm.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -994,6 +995,7 @@ void mark_free_pages(struct zone *zone)
 }
 #endif /* CONFIG_PM */
 
+DEFINE_TRACE(mm_page_free);
 /*
  * Free a 0-order page
  */
@@ -1010,6 +1012,7 @@ static void free_hot_cold_page(struct page *page, int cold)
 	if (free_pages_check(page))
 		return;
 
+	trace_mm_page_free(page_to_pfn(page));
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
 		debug_check_no_obj_freed(page_address(page), PAGE_SIZE);
@@ -1399,6 +1402,7 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
 }
 #endif	/* CONFIG_NUMA */
 
+DEFINE_TRACE(mm_page_allocation);
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -1453,8 +1457,11 @@ zonelist_scan:
 		}
 
 		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
-		if (page)
+		if (page) {
+			trace_mm_page_allocation(page_to_pfn(page),
+					zone_page_state(zone, NR_FREE_PAGES));
 			break;
+		}
 this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);
diff --git a/mm/rmap.c b/mm/rmap.c
index 1652166..39a4876 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -50,6 +50,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
+#include <trace/mm.h>
 
 #include <asm/tlbflush.h>
 
@@ -978,6 +979,7 @@ static int try_to_mlock_page(struct page *page, struct vm_area_struct *vma)
 	return mlocked;
 }
 
+DEFINE_TRACE(mm_anon_unmap);
 /**
  * try_to_unmap_anon - unmap or unlock anonymous page using the object-based
  * rmap method
@@ -1034,9 +1036,11 @@ static int try_to_unmap_anon(struct page *page, int unlock, int migration)
 	else if (ret == SWAP_MLOCK)
 		ret = SWAP_AGAIN;	/* saw VM_LOCKED vma */
 
+	trace_mm_anon_unmap(page_to_pfn(page), ret == SWAP_SUCCESS);
 	return ret;
 }
 
+DEFINE_TRACE(mm_filemap_unmap);
 /**
  * try_to_unmap_file - unmap/unlock file page using the object-based rmap method
  * @page: the page to unmap/unlock
@@ -1170,6 +1174,7 @@ out:
 		ret = SWAP_MLOCK;	/* actually mlocked the page */
 	else if (ret == SWAP_MLOCK)
 		ret = SWAP_AGAIN;	/* saw VM_LOCKED vma */
+	trace_mm_filemap_unmap(page_to_pfn(page), ret == SWAP_SUCCESS);
 	return ret;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f74a61e..2b7e130 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -40,6 +40,7 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
+#include <trace/mm.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -329,6 +330,7 @@ typedef enum {
 	PAGE_CLEAN,
 } pageout_t;
 
+DEFINE_TRACE(mm_pagereclaim_pgout);
 /*
  * pageout is called by shrink_page_list() for each dirty page.
  * Calls ->writepage().
@@ -407,6 +409,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 			ClearPageReclaim(page);
 		}
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
+		trace_mm_pagereclaim_pgout(page_to_pfn(page), PageAnon(page));
 		return PAGE_SUCCESS;
 	}
 
@@ -570,6 +573,9 @@ void putback_lru_page(struct page *page)
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 
+DEFINE_TRACE(mm_pagereclaim_free);
+DEFINE_TRACE(mm_pagereclaim_shrinkinactive_i2a);
+DEFINE_TRACE(mm_pagereclaim_shrinkinactive_i2i);
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -758,6 +764,7 @@ free_it:
 			__pagevec_free(&freed_pvec);
 			pagevec_reinit(&freed_pvec);
 		}
+		trace_mm_pagereclaim_free(page_to_pfn(page), PageAnon(page));
 		continue;
 
 cull_mlocked:
@@ -774,10 +781,12 @@ activate_locked:
 		VM_BUG_ON(PageActive(page));
 		SetPageActive(page);
 		pgactivate++;
+		trace_mm_pagereclaim_shrinkinactive_i2a(page_to_pfn(page));
 keep_locked:
 		unlock_page(page);
 keep:
 		list_add(&page->lru, &ret_pages);
+		trace_mm_pagereclaim_shrinkinactive_i2i(page_to_pfn(page));
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 	list_splice(&ret_pages, page_list);
@@ -1036,6 +1045,7 @@ int isolate_lru_page(struct page *page)
 	return ret;
 }
 
+DEFINE_TRACE(mm_pagereclaim_shrinkinactive);
 /*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
@@ -1170,6 +1180,7 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
 done:
 	local_irq_enable();
 	pagevec_release(&pvec);
+	trace_mm_pagereclaim_shrinkinactive(nr_reclaimed, file, priority);
 	return nr_reclaimed;
 }
 
@@ -1187,6 +1198,9 @@ static inline void note_zone_scanning_priority(struct zone *zone, int priority)
 		zone->prev_priority = priority;
 }
 
+DEFINE_TRACE(mm_pagereclaim_shrinkactive);
+DEFINE_TRACE(mm_pagereclaim_shrinkactive_a2a);
+DEFINE_TRACE(mm_pagereclaim_shrinkactive_a2i);
 /*
  * This moves pages from the active list to the inactive list.
  *
@@ -1247,6 +1261,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 
 		if (unlikely(!page_evictable(page, NULL))) {
 			putback_lru_page(page);
+			trace_mm_pagereclaim_shrinkactive_a2a(page_to_pfn(page));
 			continue;
 		}
 
@@ -1256,6 +1271,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			pgmoved++;
 
 		list_add(&page->lru, &l_inactive);
+		trace_mm_pagereclaim_shrinkactive_a2i(page_to_pfn(page));
 	}
 
 	/*
@@ -1310,6 +1326,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 		pagevec_swap_free(&pvec);
 
 	pagevec_release(&pvec);
+	trace_mm_pagereclaim_shrinkactive(pgscanned, file, priority);
 }
 
 static int inactive_anon_is_low_global(struct zone *zone)
@@ -1450,6 +1467,7 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 }
 
 
+DEFINE_TRACE(mm_pagereclaim_shrinkzone);
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
@@ -1510,6 +1528,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	}
 
 	sc->nr_reclaimed = nr_reclaimed;
+	trace_mm_pagereclaim_shrinkzone(nr_reclaimed);
 
 	/*
 	 * Even if we did not try to evict anon pages at all, we want to
@@ -1521,6 +1540,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	throttle_vm_writeout(sc->gfp_mask);
 }
 
+DEFINE_TRACE(mm_directreclaim_reclaimall);
 /*
  * This is the direct reclaim path, for page-allocating processes.  We only
  * try to reclaim pages from zones which will satisfy the caller's allocation
@@ -1569,6 +1589,7 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 							priority);
 		}
 
+		trace_mm_directreclaim_reclaimall(priority);
 		shrink_zone(priority, zone, sc);
 	}
 }
@@ -1732,6 +1753,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 }
 #endif
 
+DEFINE_TRACE(mm_kswapd_runs);
 /*
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at pages_high.
@@ -1938,6 +1960,7 @@ out:
 		goto loop_again;
 	}
 
+	trace_mm_kswapd_runs(sc.nr_reclaimed);
 	return sc.nr_reclaimed;
 }
 
@@ -2280,6 +2303,7 @@ int sysctl_min_unmapped_ratio = 1;
  */
 int sysctl_min_slab_ratio = 5;
 
+DEFINE_TRACE(mm_directreclaim_reclaimzone);
 /*
  * Try to free up some pages from this zone through reclaim.
  */
@@ -2323,6 +2347,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		do {
 			note_zone_scanning_priority(zone, priority);
 			shrink_zone(priority, zone, &sc);
+			trace_mm_directreclaim_reclaimzone(priority);
 			priority--;
 		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
 	}
@@ -2354,6 +2379,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	trace_mm_directreclaim_reclaimzone(sc.nr_reclaimed);
 	return sc.nr_reclaimed >= nr_pages;
 }
 

--=-klGgT/77byJk5gC9yx+d--

