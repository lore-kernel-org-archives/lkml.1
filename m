Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZCQSRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZCQSRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbZCQSR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:17:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:51515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZCQSRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:17:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,380,1233561600"; 
   d="scan'208";a="121223074"
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
 ipi fallback for smp_call_function_many())
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "steiner@sgi.com" <steiner@sgi.com>
In-Reply-To: <20090225033230.GA4611@wotan.suse.de>
References: <20090217112657.GE26402@wotan.suse.de>
	 <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de>
	 <1234982620.29823.22.camel@vayu> <20090218191757.GD8889@elte.hu>
	 <1235001314.14523.2.camel@vayu> <20090219122031.GC1703@elte.hu>
	 <1235080824.14523.19.camel@vayu> <20090220105640.GE28581@elte.hu>
	 <1235156214.14523.54.camel@vayu>  <20090225033230.GA4611@wotan.suse.de>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 17 Mar 2009 10:16:54 -0800
Message-Id: <1237313814.27006.203.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 19:32 -0800, Nick Piggin wrote:
> Just if I may add something -- I would probably slightly prefer if
> you explicitly used an sfence or other serializing instruction rather
> than smp_mb(). Maybe call it wrmsr_fence() or something.

I was planning to send a cleanup patch doing this, but looks like Ingo
never took the original patch. Here it is appended. Ingo, please
consider.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: Add x2apic_wrmsr_fence() to x2apic flush tlb paths

uncached MMIO accesses for xapic are inherently serializing and hence
we don't need explicit barriers for xapic IPI paths.

x2apic MSR writes/reads don't have serializing semantics and hence need
a serializing instruction or mfence, to make all the previous memory
stores globally visisble before the x2apic msr write for IPI.

Add x2apic_wrmsr_fence() in flush tlb path to x2apic specific paths.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 394d177..cfc0871 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -108,6 +108,16 @@ extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
 
 #ifdef CONFIG_X86_X2APIC
+/*
+ * Make previous memory operations globally visible before
+ * sending the IPI through x2apic wrmsr. We need a serializing instruction or
+ * mfence for this.
+ */
+static inline void x2apic_wrmsr_fence(void)
+{
+	asm volatile("mfence":::"memory");
+}
+
 static inline void native_apic_msr_write(u32 reg, u32 v)
 {
 	if (reg == APIC_DFR || reg == APIC_ID || reg == APIC_LDR ||
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 8fb87b6..4a903e2 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -57,6 +57,8 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	x2apic_wrmsr_fence();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(
@@ -73,6 +75,8 @@ static void
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	x2apic_wrmsr_fence();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		if (query_cpu == this_cpu)
@@ -90,6 +94,8 @@ static void x2apic_send_IPI_allbutself(int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	x2apic_wrmsr_fence();
+
 	local_irq_save(flags);
 	for_each_online_cpu(query_cpu) {
 		if (query_cpu == this_cpu)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 23625b9..a284359 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -58,6 +58,8 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	x2apic_wrmsr_fence();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
@@ -73,6 +75,8 @@ static void
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	x2apic_wrmsr_fence();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		if (query_cpu != this_cpu)
@@ -89,6 +93,8 @@ static void x2apic_send_IPI_allbutself(int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	x2apic_wrmsr_fence();
+
 	local_irq_save(flags);
 	for_each_online_cpu(query_cpu) {
 		if (query_cpu == this_cpu)
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a654d59..821e970 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -187,11 +187,6 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 		       cpumask, cpumask_of(smp_processor_id()));
 
 	/*
-	 * Make the above memory operations globally visible before
-	 * sending the IPI.
-	 */
-	smp_mb();
-	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */


