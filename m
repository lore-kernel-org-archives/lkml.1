Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZBSWCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZBSWCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZBSWBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:01:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:49259 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZBSWBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:01:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,236,1233561600"; 
   d="scan'208";a="112457539"
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
In-Reply-To: <20090219122031.GC1703@elte.hu>
References: <20090216231946.GA12009@redhat.com>
	 <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de>
	 <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de>
	 <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de>
	 <1234982620.29823.22.camel@vayu> <20090218191757.GD8889@elte.hu>
	 <1235001314.14523.2.camel@vayu>  <20090219122031.GC1703@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 19 Feb 2009 14:00:24 -0800
Message-Id: <1235080824.14523.19.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 04:20 -0800, Ingo Molnar wrote:
> Could you please refresh this patch to latest tip:master? The 
> APIC drivers moved to arch/x86/kernel/apic/.

Appended the refreshed patch. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: move smp_mb() in flush tlb path to x2apic specific paths

uncached MMIO accesses for xapic are inherently serializing and hence
we don't need explicit barriers for xapic IPI paths.

x2apic MSR writes/reads don't have serializing semantics and hence need
a serializing instruction or mfence, to make all the previous memory
stores globally visisble before the x2apic msr write for IPI.

And hence move smp_mb() in x86 flush tlb path to x2apic specific paths.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 3f7df23..c54fffe 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -63,6 +63,13 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	/*
+	 * Make previous memory operations globally visible before
+	 * sending the IPI. We need a serializing instruction or mfence
+	 * for this.
+	 */
+	smp_mb();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(
@@ -79,6 +86,13 @@ static void
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	/*
+	 * Make previous memory operations globally visible before
+	 * sending the IPI. We need a serializing instruction or mfence
+	 * for this.
+	 */
+	smp_mb();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		if (query_cpu == this_cpu)
@@ -96,6 +110,13 @@ static void x2apic_send_IPI_allbutself(int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	/*
+	 * Make previous memory operations globally visible before
+	 * sending the IPI. We need a serializing instruction or mfence
+	 * for this.
+	 */
+	smp_mb();
+
 	local_irq_save(flags);
 	for_each_online_cpu(query_cpu) {
 		if (query_cpu == this_cpu)
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index d2d52eb..84cc2f3 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -58,6 +58,13 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	/*
+	 * Make previous memory operations globally visible before
+	 * sending the IPI. We need a serializing instruction or mfence
+	 * for this.
+	 */
+	smp_mb();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
@@ -73,6 +80,13 @@ static void
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	/*
+	 * Make previous memory operations globally visible before
+	 * sending the IPI. We need a serializing instruction or mfence
+	 * for this.
+	 */
+	smp_mb();
+
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
 		if (query_cpu != this_cpu)
@@ -89,6 +103,13 @@ static void x2apic_send_IPI_allbutself(int vector)
 	unsigned long query_cpu;
 	unsigned long flags;
 
+	/*
+	 * Make previous memory operations globally visible before
+	 * sending the IPI. We need a serializing instruction or mfence
+	 * for this.
+	 */
+	smp_mb();
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


