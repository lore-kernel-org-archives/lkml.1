Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZCRIxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZCRIxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZCRIxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:53:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:44508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZCRIxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:53:06 -0400
Date: Wed, 18 Mar 2009 08:51:26 GMT
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com, npiggin@suse.de,
       paulmck@linux.vnet.ibm.com, steiner@sgi.com, rostedt@goodmis.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, jens.axboe@oracle.com,
       paulmck@linux.vnet.ibm.com, npiggin@suse.de, rostedt@goodmis.org,
       steiner@sgi.com, suresh.b.siddha@intel.com, oleg@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237313814.27006.203.camel@localhost.localdomain>
References: <1237313814.27006.203.camel@localhost.localdomain>
Subject: [tip:x86/x2apic] x86: add x2apic_wrmsr_fence() to x2apic flush tlb paths
Message-ID: <tip-ce4e240c279a31096f74afa6584a62d64a1ba8c8@git.kernel.org>
Git-Commit-ID: ce4e240c279a31096f74afa6584a62d64a1ba8c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 08:51:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce4e240c279a31096f74afa6584a62d64a1ba8c8
Gitweb:     http://git.kernel.org/tip/ce4e240c279a31096f74afa6584a62d64a1ba8c8
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 17 Mar 2009 10:16:54 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 09:36:14 +0100

x86: add x2apic_wrmsr_fence() to x2apic flush tlb paths

Impact: optimize APIC IPI related barriers

Uncached MMIO accesses for xapic are inherently serializing and hence
we don't need explicit barriers for xapic IPI paths.

x2apic MSR writes/reads don't have serializing semantics and hence need
a serializing instruction or mfence, to make all the previous memory
stores globally visisble before the x2apic msr write for IPI.

Add x2apic_wrmsr_fence() in flush tlb path to x2apic specific paths.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "steiner@sgi.com" <steiner@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>
LKML-Reference: <1237313814.27006.203.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h           |   10 ++++++++++
 arch/x86/kernel/apic/x2apic_cluster.c |    6 ++++++
 arch/x86/kernel/apic/x2apic_phys.c    |    6 ++++++
 arch/x86/mm/tlb.c                     |    5 -----
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 6d5b6f0..00f5962 100644
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
+	asm volatile("mfence" : : : "memory");
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
