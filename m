Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbZLJHiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbZLJHiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760566AbZLJHiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:38:07 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57078 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760565AbZLJHiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:38:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 16:34:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, mm's counter information is updated by atomic_long_xxx() functions if
USE_SPLIT_PTLOCKS is defined. This causes cache-miss when page faults happens
simultaneously in prural cpus. (Almost all process-shared objects is...)

Considering accounting per-mm page usage more, one of problems is cost of
this counter.

This patch implements per-cpu mm cache. This per-cpu cache is loosely
synchronized with mm's counter. Current design is..

  - prepare per-cpu object curr_mmc. curr_mmc containes pointer to mm and
    array of counters.
  - At page fault,
     * if curr_mmc.mm != NULL, update curr_mmc.mm counter.
     * if curr_mmc.mm == NULL, fill curr_mmc.mm = current->mm and account 1.
  - At schedule()
     * if curr_mm.mm != NULL, synchronize and invalidate cached information.
     * if curr_mmc.mm == NULL, nothing to do.

By this.
  - no atomic ops, which tends to cache-miss, under page table lock.
  - mm->counters are synchronized when schedule() is called.
  - No bad thing to read-side.

Concern:
  - added cost to schedule().

Micro Benchmark:
  measured the number of page faults with 2 threads on 2 sockets.

 Before:
   Performance counter stats for './multi-fault 2' (5 runs):

       45122351  page-faults                ( +-   1.125% )
      989608571  cache-references           ( +-   1.198% )
      205308558  cache-misses               ( +-   0.159% )
   29263096648639268  bus-cycles                 ( +-   0.004% )

   60.003427500  seconds time elapsed   ( +-   0.003% )

 After:
    Performance counter stats for './multi-fault 2' (5 runs):

       46997471  page-faults                ( +-   0.720% )
     1004100076  cache-references           ( +-   0.734% )
      180959964  cache-misses               ( +-   0.374% )
   29263437363580464  bus-cycles                 ( +-   0.002% )

   60.003315683  seconds time elapsed   ( +-   0.004% )

   cachemiss/page faults is reduced from 4.55 miss/faults to be 3.85miss/faults

   This microbencmark doesn't do usual behavior (page fault ->madvise(DONTNEED)
   but reducing cache-miss cost sounds good to me even if it's very small.

Changelog 2009/12/09:
 - loosely update curr_mmc.mm at the 1st page fault.
 - removed hooks in tick.(update_process_times)
 - exported curr_mmc and check curr_mmc.mm directly.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/mm.h       |   37 ++++++++++++++++++++++++++++
 include/linux/mm_types.h |   12 +++++++++
 kernel/exit.c            |    3 +-
 kernel/sched.c           |    6 ++++
 mm/memory.c              |   60 ++++++++++++++++++++++++++++++++++++++++-------
 5 files changed, 108 insertions(+), 10 deletions(-)

Index: mmotm-2.6.32-Dec8/include/linux/mm_types.h
===================================================================
--- mmotm-2.6.32-Dec8.orig/include/linux/mm_types.h
+++ mmotm-2.6.32-Dec8/include/linux/mm_types.h
@@ -297,4 +297,16 @@ struct mm_struct {
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 #define mm_cpumask(mm) (&(mm)->cpu_vm_mask)
 
+#if USE_SPLIT_PTLOCKS
+/*
+ * percpu object used for caching thread->mm information.
+ */
+struct pcp_mm_cache {
+	struct mm_struct *mm;
+	unsigned long counters[NR_MM_COUNTERS];
+};
+
+DECLARE_PER_CPU(struct pcp_mm_cache, curr_mmc);
+#endif
+
 #endif /* _LINUX_MM_TYPES_H */
Index: mmotm-2.6.32-Dec8/include/linux/mm.h
===================================================================
--- mmotm-2.6.32-Dec8.orig/include/linux/mm.h
+++ mmotm-2.6.32-Dec8/include/linux/mm.h
@@ -883,7 +883,16 @@ static inline void set_mm_counter(struct
 
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return (unsigned long)atomic_long_read(&(mm)->counters[member]);
+	long ret;
+	/*
+	 * Because this counter is loosely synchronized with percpu cached
+ 	 * information, it's possible that value gets to be minus. For user's
+ 	 * convenience/sanity, avoid returning minus.
+ 	 */
+	ret = atomic_long_read(&(mm)->counters[member]);
+	if (unlikely(ret < 0))
+		return 0;
+	return (unsigned long)ret;
 }
 
 static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
@@ -900,6 +909,25 @@ static inline void dec_mm_counter(struct
 {
 	atomic_long_dec(&(mm)->counters[member]);
 }
+extern void __sync_mm_counters(struct mm_struct *mm);
+/* Called under non-preemptable context, for syncing cached information */
+static inline void sync_mm_counters_atomic(void)
+{
+	struct mm_struct *mm;
+
+	mm = percpu_read(curr_mmc.mm);
+	if (mm) {
+		__sync_mm_counters(mm);
+		percpu_write(curr_mmc.mm, NULL);
+	}
+}
+/* called at thread exit */
+static inline void exit_mm_counters(void)
+{
+	preempt_disable();
+	sync_mm_counters_atomic();
+	preempt_enable();
+}
 
 #else  /* !USE_SPLIT_PTLOCKS */
 /*
@@ -931,6 +959,13 @@ static inline void dec_mm_counter(struct
 	mm->counters[member]--;
 }
 
+static inline void sync_mm_counters_atomic(void)
+{
+}
+
+static inline void exit_mm_counters(void)
+{
+}
 #endif /* !USE_SPLIT_PTLOCKS */
 
 #define get_mm_rss(mm)					\
Index: mmotm-2.6.32-Dec8/mm/memory.c
===================================================================
--- mmotm-2.6.32-Dec8.orig/mm/memory.c
+++ mmotm-2.6.32-Dec8/mm/memory.c
@@ -121,6 +121,50 @@ static int __init init_zero_pfn(void)
 }
 core_initcall(init_zero_pfn);
 
+#if USE_SPLIT_PTLOCKS
+
+DEFINE_PER_CPU(struct pcp_mm_cache, curr_mmc);
+
+void __sync_mm_counters(struct mm_struct *mm)
+{
+	struct pcp_mm_cache *mmc = &per_cpu(curr_mmc, smp_processor_id());
+	int i;
+
+	for (i = 0; i < NR_MM_COUNTERS; i++) {
+		if (mmc->counters[i] != 0) {
+			atomic_long_add(mmc->counters[i], &mm->counters[i]);
+			mmc->counters[i] = 0;
+		}
+	}
+	return;
+}
+/*
+ * This add_mm_counter_fast() works well only when it's expexted that
+ * mm == current->mm. So, use of this function is limited under memory.c
+ * This add_mm_counter_fast() is called under page table lock.
+ */
+static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
+{
+	struct mm_struct *cached = percpu_read(curr_mmc.mm);
+
+	if (likely(cached == mm)) { /* fast path */
+		percpu_add(curr_mmc.counters[member], val);
+	} else if (mm == current->mm) { /* 1st page fault in this period */
+		percpu_write(curr_mmc.mm, mm);
+		percpu_write(curr_mmc.counters[member], val);
+	} else /* page fault via side-path context (get_user_pages()) */
+		add_mm_counter(mm, member, val);
+}
+
+#define inc_mm_counter_fast(mm, member)	add_mm_counter_fast(mm, member, 1)
+#define dec_mm_counter_fast(mm, member)	add_mm_counter_fast(mm, member, -1)
+#else
+
+#define inc_mm_counter_fast(mm, member)	inc_mm_counter(mm, member)
+#define dec_mm_counter_fast(mm, member)	dec_mm_counter(mm, member)
+
+#endif
+
 /*
  * If a p?d_bad entry is found while walking page tables, report
  * the error, before resetting entry to p?d_none.  Usually (but
@@ -1541,7 +1585,7 @@ static int insert_page(struct vm_area_st
 
 	/* Ok, finally just insert the thing.. */
 	get_page(page);
-	inc_mm_counter(mm, MM_FILEPAGES);
+	inc_mm_counter_fast(mm, MM_FILEPAGES);
 	page_add_file_rmap(page);
 	set_pte_at(mm, addr, pte, mk_pte(page, prot));
 
@@ -2177,11 +2221,11 @@ gotten:
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
 			if (!PageAnon(old_page)) {
-				dec_mm_counter(mm, MM_FILEPAGES);
-				inc_mm_counter(mm, MM_ANONPAGES);
+				dec_mm_counter_fast(mm, MM_FILEPAGES);
+				inc_mm_counter_fast(mm, MM_ANONPAGES);
 			}
 		} else
-			inc_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter_fast(mm, MM_ANONPAGES);
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = mk_pte(new_page, vma->vm_page_prot);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
@@ -2614,7 +2658,7 @@ static int do_swap_page(struct mm_struct
 	 * discarded at swap_free().
 	 */
 
-	inc_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if ((flags & FAULT_FLAG_WRITE) && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
@@ -2698,7 +2742,7 @@ static int do_anonymous_page(struct mm_s
 	if (!pte_none(*page_table))
 		goto release;
 
-	inc_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter_fast(mm, MM_ANONPAGES);
 	page_add_new_anon_rmap(page, vma, address);
 setpte:
 	set_pte_at(mm, address, page_table, entry);
@@ -2852,10 +2896,10 @@ static int __do_fault(struct mm_struct *
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		if (anon) {
-			inc_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter_fast(mm, MM_ANONPAGES);
 			page_add_new_anon_rmap(page, vma, address);
 		} else {
-			inc_mm_counter(mm, MM_FILEPAGES);
+			inc_mm_counter_fast(mm, MM_FILEPAGES);
 			page_add_file_rmap(page);
 			if (flags & FAULT_FLAG_WRITE) {
 				dirty_page = page;
Index: mmotm-2.6.32-Dec8/kernel/sched.c
===================================================================
--- mmotm-2.6.32-Dec8.orig/kernel/sched.c
+++ mmotm-2.6.32-Dec8/kernel/sched.c
@@ -2858,6 +2858,7 @@ context_switch(struct rq *rq, struct tas
 	trace_sched_switch(rq, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
+
 	/*
 	 * For paravirt, this is coupled with an exit in switch_to to
 	 * combine the page table reload and the switch backend into
@@ -5477,6 +5478,11 @@ need_resched_nonpreemptible:
 
 	if (sched_feat(HRTICK))
 		hrtick_clear(rq);
+	/*
+	 * sync/invaldidate per-cpu cached mm related information
+	 * before taling rq->lock. (see include/linux/mm.h)
+	 */
+	sync_mm_counters_atomic();
 
 	spin_lock_irq(&rq->lock);
 	update_rq_clock(rq);
Index: mmotm-2.6.32-Dec8/kernel/exit.c
===================================================================
--- mmotm-2.6.32-Dec8.orig/kernel/exit.c
+++ mmotm-2.6.32-Dec8/kernel/exit.c
@@ -942,7 +942,8 @@ NORET_TYPE void do_exit(long code)
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
 				current->comm, task_pid_nr(current),
 				preempt_count());
-
+	/* synchronize per-cpu cached mm related information before account */
+	exit_mm_counters();
 	acct_update_integrals(tsk);
 
 	group_dead = atomic_dec_and_test(&tsk->signal->live);

