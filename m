Return-Path: <linux-kernel-owner+w=401wt.eu-S1765207AbZDHNFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765207AbZDHNFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765303AbZDHNDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54107 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765320AbZDHND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:27 -0400
Message-Id: <20090408130409.394816925@chello.nl>
References: <20090408130124.715559390@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 08 Apr 2009 15:01:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 9/9] perf_counter: allow for data addresses to be recorded
Content-Disposition: inline; filename=perf_counter-data.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul suggested we allow for data addresses to be recorded along with
the traditional IPs as power can provide these.

For now, only the software pagefault events provide data addresses,
but in the future power might as well for some events.

x86 doesn't seem capable of providing this atm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_counter.c |    2 -
 arch/powerpc/mm/fault.c            |    8 ++++--
 arch/x86/kernel/cpu/perf_counter.c |    2 -
 arch/x86/mm/fault.c                |    8 ++++--
 include/linux/perf_counter.h       |   14 ++++++-----
 kernel/perf_counter.c              |   46 +++++++++++++++++++++++--------------
 6 files changed, 49 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_counter.c
+++ linux-2.6/arch/powerpc/kernel/perf_counter.c
@@ -732,7 +732,7 @@ static void record_and_restart(struct pe
 	 * Finally record data if requested.
 	 */
 	if (record)
-		perf_counter_overflow(counter, 1, regs);
+		perf_counter_overflow(counter, 1, regs, 0);
 }
 
 /*
Index: linux-2.6/arch/powerpc/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/fault.c
+++ linux-2.6/arch/powerpc/mm/fault.c
@@ -171,7 +171,7 @@ int __kprobes do_page_fault(struct pt_re
 		die("Weird page fault", regs, SIGSEGV);
 	}
 
-	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs, address);
 
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
@@ -312,7 +312,8 @@ good_area:
 	}
 	if (ret & VM_FAULT_MAJOR) {
 		current->maj_flt++;
-		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0,
+				     regs, address);
 #ifdef CONFIG_PPC_SMLPAR
 		if (firmware_has_feature(FW_FEATURE_CMO)) {
 			preempt_disable();
@@ -322,7 +323,8 @@ good_area:
 #endif
 	} else {
 		current->min_flt++;
-		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0,
+				     regs, address);
 	}
 	up_read(&mm->mmap_sem);
 	return 0;
Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -1033,7 +1033,7 @@ do_page_fault(struct pt_regs *regs, unsi
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
-	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs, address);
 
 	/*
 	 * If we're in an interrupt, have no user context or are running
@@ -1130,10 +1130,12 @@ good_area:
 
 	if (fault & VM_FAULT_MAJOR) {
 		tsk->maj_flt++;
-		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0,
+				     regs, address);
 	} else {
 		tsk->min_flt++;
-		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0,
+				     regs, address);
 	}
 
 	check_v8086_mode(regs, address, tsk);
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -101,8 +101,9 @@ enum perf_counter_record_format {
 	PERF_RECORD_IP		= 1U << 0,
 	PERF_RECORD_TID		= 1U << 1,
 	PERF_RECORD_TIME	= 1U << 2,
-	PERF_RECORD_GROUP	= 1U << 3,
-	PERF_RECORD_CALLCHAIN	= 1U << 4,
+	PERF_RECORD_ADDR	= 1U << 3,
+	PERF_RECORD_GROUP	= 1U << 4,
+	PERF_RECORD_CALLCHAIN	= 1U << 5,
 };
 
 /*
@@ -251,6 +252,7 @@ enum perf_event_type {
 	 * 	{ u64			ip;	  } && PERF_RECORD_IP
 	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
 	 * 	{ u64			time;     } && PERF_RECORD_TIME
+	 * 	{ u64			addr;     } && PERF_RECORD_ADDR
 	 *
 	 * 	{ u64			nr;
 	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
@@ -537,7 +539,7 @@ extern int hw_perf_group_sched_in(struct
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 extern int perf_counter_overflow(struct perf_counter *counter,
-				 int nmi, struct pt_regs *regs);
+				 int nmi, struct pt_regs *regs, u64 addr);
 /*
  * Return 1 for a software counter, 0 for a hardware counter
  */
@@ -547,7 +549,7 @@ static inline int is_software_counter(st
 		perf_event_type(&counter->hw_event) != PERF_TYPE_HARDWARE;
 }
 
-extern void perf_swcounter_event(u32, u64, int, struct pt_regs *);
+extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
 
 extern void perf_counter_mmap(unsigned long addr, unsigned long len,
 			      unsigned long pgoff, struct file *file);
@@ -584,8 +586,8 @@ static inline int perf_counter_task_disa
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
 
 static inline void
-perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs)	{ }
-
+perf_swcounter_event(u32 event, u64 nr, int nmi,
+		     struct pt_regs *regs, u64 addr)			{ }
 
 static inline void
 perf_counter_mmap(unsigned long addr, unsigned long len,
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -800,7 +800,7 @@ void perf_counter_task_sched_out(struct 
 	update_context_time(ctx);
 
 	regs = task_pt_regs(task);
-	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs);
+	perf_swcounter_event(PERF_COUNT_CONTEXT_SWITCHES, 1, 1, regs, 0);
 	__perf_counter_sched_out(ctx, cpuctx);
 
 	cpuctx->task_ctx = NULL;
@@ -1810,7 +1810,7 @@ static void perf_output_end(struct perf_
 }
 
 static void perf_counter_output(struct perf_counter *counter,
-				int nmi, struct pt_regs *regs)
+				int nmi, struct pt_regs *regs, u64 addr)
 {
 	int ret;
 	u64 record_type = counter->hw_event.record_type;
@@ -1860,6 +1860,11 @@ static void perf_counter_output(struct p
 		header.size += sizeof(u64);
 	}
 
+	if (record_type & PERF_RECORD_ADDR) {
+		header.type |= PERF_RECORD_ADDR;
+		header.size += sizeof(u64);
+	}
+
 	if (record_type & PERF_RECORD_GROUP) {
 		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
@@ -1892,6 +1897,9 @@ static void perf_counter_output(struct p
 	if (record_type & PERF_RECORD_TIME)
 		perf_output_put(&handle, time);
 
+	if (record_type & PERF_RECORD_ADDR)
+		perf_output_put(&handle, addr);
+
 	if (record_type & PERF_RECORD_GROUP) {
 		struct perf_counter *leader, *sub;
 		u64 nr = counter->nr_siblings;
@@ -2158,7 +2166,7 @@ void perf_counter_munmap(unsigned long a
  */
 
 int perf_counter_overflow(struct perf_counter *counter,
-			  int nmi, struct pt_regs *regs)
+			  int nmi, struct pt_regs *regs, u64 addr)
 {
 	int events = atomic_read(&counter->event_limit);
 	int ret = 0;
@@ -2175,7 +2183,7 @@ int perf_counter_overflow(struct perf_co
 			perf_counter_disable(counter);
 	}
 
-	perf_counter_output(counter, nmi, regs);
+	perf_counter_output(counter, nmi, regs, addr);
 	return ret;
 }
 
@@ -2240,7 +2248,7 @@ static enum hrtimer_restart perf_swcount
 		regs = task_pt_regs(current);
 
 	if (regs) {
-		if (perf_counter_overflow(counter, 0, regs))
+		if (perf_counter_overflow(counter, 0, regs, 0))
 			ret = HRTIMER_NORESTART;
 	}
 
@@ -2250,11 +2258,11 @@ static enum hrtimer_restart perf_swcount
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct pt_regs *regs)
+				    int nmi, struct pt_regs *regs, u64 addr)
 {
 	perf_swcounter_update(counter);
 	perf_swcounter_set_period(counter);
-	if (perf_counter_overflow(counter, nmi, regs))
+	if (perf_counter_overflow(counter, nmi, regs, addr))
 		/* soft-disable the counter */
 		;
 
@@ -2286,16 +2294,17 @@ static int perf_swcounter_match(struct p
 }
 
 static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct pt_regs *regs)
+			       int nmi, struct pt_regs *regs, u64 addr)
 {
 	int neg = atomic64_add_negative(nr, &counter->hw.count);
 	if (counter->hw.irq_period && !neg)
-		perf_swcounter_overflow(counter, nmi, regs);
+		perf_swcounter_overflow(counter, nmi, regs, addr);
 }
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_event_types type, u32 event,
-				     u64 nr, int nmi, struct pt_regs *regs)
+				     u64 nr, int nmi, struct pt_regs *regs,
+				     u64 addr)
 {
 	struct perf_counter *counter;
 
@@ -2305,7 +2314,7 @@ static void perf_swcounter_ctx_event(str
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
 		if (perf_swcounter_match(counter, type, event, regs))
-			perf_swcounter_add(counter, nr, nmi, regs);
+			perf_swcounter_add(counter, nr, nmi, regs, addr);
 	}
 	rcu_read_unlock();
 }
@@ -2325,7 +2334,8 @@ static int *perf_swcounter_recursion_con
 }
 
 static void __perf_swcounter_event(enum perf_event_types type, u32 event,
-				   u64 nr, int nmi, struct pt_regs *regs)
+				   u64 nr, int nmi, struct pt_regs *regs,
+				   u64 addr)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
@@ -2336,10 +2346,11 @@ static void __perf_swcounter_event(enum 
 	(*recursion)++;
 	barrier();
 
-	perf_swcounter_ctx_event(&cpuctx->ctx, type, event, nr, nmi, regs);
+	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
+				 nr, nmi, regs, addr);
 	if (cpuctx->task_ctx) {
 		perf_swcounter_ctx_event(cpuctx->task_ctx, type, event,
-				nr, nmi, regs);
+					 nr, nmi, regs, addr);
 	}
 
 	barrier();
@@ -2349,9 +2360,10 @@ out:
 	put_cpu_var(perf_cpu_context);
 }
 
-void perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs)
+void
+perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
 {
-	__perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, regs);
+	__perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, regs, addr);
 }
 
 static void perf_swcounter_read(struct perf_counter *counter)
@@ -2548,7 +2560,7 @@ void perf_tpcounter_event(int event_id)
 	if (!regs)
 		regs = task_pt_regs(current);
 
-	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs);
+	__perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, 1, 1, regs, 0);
 }
 
 extern int ftrace_profile_enable(int);
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -800,7 +800,7 @@ again:
 			continue;
 
 		perf_save_and_restart(counter);
-		if (perf_counter_overflow(counter, nmi, regs))
+		if (perf_counter_overflow(counter, nmi, regs, 0))
 			__pmc_generic_disable(counter, &counter->hw, bit);
 	}
 

-- 

