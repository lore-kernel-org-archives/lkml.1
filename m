Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbZKWIib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbZKWIib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZKWIia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:38:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZKWIia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:38:30 -0500
Subject: Re: [PATCH 03/15] perf: optimize perf_swevent_ctx_event()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <1258961500.4531.38.camel@laptop>
References: <20091120211942.676891948@chello.nl>
	 <20091120212508.378188589@chello.nl>
	 <19210.8856.446670.786636@cargo.ozlabs.ibm.com>
	 <1258961500.4531.38.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 09:38:32 +0100
Message-ID: <1258965512.4531.113.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 08:31 +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 16:50 +1100, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > We can do away with the system_state check if the machine still boots
> > > after this patch (seems to be the case).
> > 
> > I have a recollection (possible faulty) that the problem we can get
> > into if we don't have this check is that if we take a bad page fault
> > in the kernel (e.g. NULL dereference) early in boot before the perf
> > cpu context has been initialized, we then get another NULL dereference
> > because the pointers in ctx->event_list are NULL, and recurse to
> > death.
> > 
> > So that check was possibly more about debugging than correctness.
> > Possibly also the x86 do_page_fault() is different enough from the
> > powerpc one that the problem can't occur on x86.
> 
> Right, I remembered there was _something_ we added them for, but
> couldn't for the live of me remember what.
> 
> Hmm, maybe we can initialize all the recursion variables to 1, that
> should avoid us ever entering into the swcounter code until we reset
> them.

I think the below patch fixed that..

---

commit f29ac756a40d0f1bb07d682ea521e7b666ff06d5
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jun 19 18:27:26 2009 +0200

    perf_counter: Optimize perf_swcounter_event()
    
    Similar to tracepoints, use an enable variable to reduce
    overhead when unused.
    
    Only look for a counter of a particular event type when we know
    there is at least one in the system.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 89698d8..e7213e4 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -669,7 +669,16 @@ static inline int is_software_counter(struct perf_counter *counter)
 		(counter->attr.type != PERF_TYPE_HW_CACHE);
 }
 
-extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
+extern atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
+
+extern void __perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
+
+static inline void
+perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+{
+	if (atomic_read(&perf_swcounter_enabled[event]))
+		__perf_swcounter_event(event, nr, nmi, regs, addr);
+}
 
 extern void __perf_counter_mmap(struct vm_area_struct *vma);
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 1a933a2..7515c76 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3317,8 +3317,8 @@ out:
 	put_cpu_var(perf_cpu_context);
 }
 
-void
-perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+void __perf_swcounter_event(u32 event, u64 nr, int nmi,
+			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data = {
 		.regs = regs,
@@ -3509,9 +3509,19 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 }
 #endif
 
+atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
+
+static void sw_perf_counter_destroy(struct perf_counter *counter)
+{
+	u64 event = counter->attr.config;
+
+	atomic_dec(&perf_swcounter_enabled[event]);
+}
+
 static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 {
 	const struct pmu *pmu = NULL;
+	u64 event = counter->attr.config;
 
 	/*
 	 * Software counters (currently) can't in general distinguish
@@ -3520,7 +3530,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->attr.config) {
+	switch (event) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
@@ -3541,6 +3551,8 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+		atomic_inc(&perf_swcounter_enabled[event]);
+		counter->destroy = sw_perf_counter_destroy;
 		pmu = &perf_ops_generic;
 		break;
 	}


