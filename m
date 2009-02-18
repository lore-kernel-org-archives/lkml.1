Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZBRX4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZBRX4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBRX4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:56:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:7529 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbZBRX4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:56:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,231,1233561600"; 
   d="scan'208";a="112073164"
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
In-Reply-To: <20090218191757.GD8889@elte.hu>
References: <20090216220214.GA10093@redhat.com>
	 <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com>
	 <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de>
	 <1234866453.4744.58.camel@laptop> <20090217112657.GE26402@wotan.suse.de>
	 <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de>
	 <1234982620.29823.22.camel@vayu>  <20090218191757.GD8889@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 18 Feb 2009 15:55:14 -0800
Message-Id: <1235001314.14523.2.camel@vayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 11:17 -0800, Ingo Molnar wrote: 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > > Indeed that could cause problems on some architectures which I
> > > had hoped to avoid. So the patch is probably better off to first
> > > add the smp_mb() to arch_send_call_function_xxx arch code, unless
> > > it is immediately obvious or confirmed by arch maintainer that
> > > such barrier is not required.
> > 
> > For x2apic specific operations we should add the smp_mb() sequence. But
> > we need to make sure that we don't end up doing it twice (once in
> > generic code and another in arch code) for all the ipi paths.
> 
> right now we do have an smp_mb() due to your fix in November.
> 
> So what should happen is to move that smp_mb() from the x86 
> generic IPI path to the x86 x2apic IPI path. (and turn it into 
> an smp_wmb() - that should be enough - we dont care about future 
> reads being done sooner than this point.)

Ingo, smp_wmb() won't help. x2apic register writes can still go ahead of
the sfence. According to the SDM, we need a serializing instruction or
mfence. Our internal experiments also proved this.

Appended is the x86 portion of the patch:
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: move smp_mb() in x86 flush tlb path to x2apic specific IPI
paths

uncached MMIO accesses for xapic are inherently serializing and hence
we don't need explicit barriers for xapic IPI paths.

x2apic MSR writes/reads don't have serializing semantics and hence need
a serializing instruction or mfence, to make all the previous memory
stores
globally visisble before the x2apic msr write for IPI.

And hence move smp_mb() in x86 flush tlb path to x2apic specific paths.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/genx2apic_cluster.c
b/arch/x86/kernel/genx2apic_cluster.c
index 7c87156..b237248 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -60,6 +60,13 @@ static void x2apic_send_IPI_mask(const struct cpumask
*mask, int vector)
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
@@ -76,6 +83,13 @@ static void
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
@@ -93,6 +107,13 @@ static void x2apic_send_IPI_allbutself(int vector)
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
diff --git a/arch/x86/kernel/genx2apic_phys.c
b/arch/x86/kernel/genx2apic_phys.c
index 5cbae8a..f48f282 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -58,6 +58,13 @@ static void x2apic_send_IPI_mask(const struct cpumask
*mask, int vector)
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
index 14c5af4..de14557 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -188,11 +188,6 @@ static void flush_tlb_others_ipi(const struct
cpumask *cpumask,
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


