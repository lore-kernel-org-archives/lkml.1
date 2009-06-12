Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbZFLNmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbZFLNmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbZFLNbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:14 -0400
Received: from ozlabs.org ([203.10.76.45]:55304 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764734AbZFLNbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:06 -0400
CC: linux-kernel@vger.kernel.org
To: Hirokazu Takata <takata@linux-m32r.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 2/7] cpumask: arch_send_call_function_ipi_mask: m32r
Message-Id: <20090612133108.71A63DDDA1@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're weaning the core code off handing cpumask's around on-stack.
This introduces arch_send_call_function_ipi_mask(), and by defining
it, the old arch_send_call_function_ipi is defined by the core code.

We also take the chance to wean the implementations off the
obsolescent for_each_cpu_mask(): making send_ipi_mask take the pointer
seemed the most natural way to ensure all implementations used
for_each_cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/m32r/include/asm/smp.h |    3 ++-
 arch/m32r/kernel/smp.c      |   22 +++++++++++-----------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -85,7 +85,7 @@ void smp_local_timer_interrupt(void);
 void smp_local_timer_interrupt(void);
 
 static void send_IPI_allbutself(int, int);
-static void send_IPI_mask(cpumask_t, int, int);
+static void send_IPI_mask(const struct cpumask *, int, int);
 unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
@@ -113,7 +113,7 @@ void smp_send_reschedule(int cpu_id)
 void smp_send_reschedule(int cpu_id)
 {
 	WARN_ON(cpu_is_offline(cpu_id));
-	send_IPI_mask(cpumask_of_cpu(cpu_id), RESCHEDULE_IPI, 1);
+	send_IPI_mask(cpumask_of(cpu_id), RESCHEDULE_IPI, 1);
 }
 
 /*==========================================================================*
@@ -168,7 +168,7 @@ void smp_flush_cache_all(void)
 	spin_lock(&flushcache_lock);
 	mask=cpus_addr(cpumask);
 	atomic_set_mask(*mask, (atomic_t *)&flushcache_cpumask);
-	send_IPI_mask(cpumask, INVALIDATE_CACHE_IPI, 0);
+	send_IPI_mask(&cpumask, INVALIDATE_CACHE_IPI, 0);
 	_flush_cache_copyback_all();
 	while (flushcache_cpumask)
 		mb();
@@ -424,7 +424,7 @@ static void flush_tlb_others(cpumask_t c
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_IPI, 0);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_IPI, 0);
 
 	while (!cpus_empty(flush_cpumask)) {
 		/* nothing. lockup detection does not belong here */
@@ -546,14 +546,14 @@ static void stop_this_cpu(void *dummy)
 	for ( ; ; );
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	send_IPI_mask(mask, CALL_FUNCTION_IPI, 0);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNC_SINGLE_IPI, 0);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_SINGLE_IPI, 0);
 }
 
 /*==========================================================================*
@@ -729,7 +729,7 @@ static void send_IPI_allbutself(int ipi_
 	cpumask = cpu_online_map;
 	cpu_clear(smp_processor_id(), cpumask);
 
-	send_IPI_mask(cpumask, ipi_num, try);
+	send_IPI_mask(&cpumask, ipi_num, try);
 }
 
 /*==========================================================================*
@@ -752,7 +752,7 @@ static void send_IPI_allbutself(int ipi_
  * ---------- --- --------------------------------------------------------
  *
  *==========================================================================*/
-static void send_IPI_mask(cpumask_t cpumask, int ipi_num, int try)
+static void send_IPI_mask(const struct cpumask *cpumask, int ipi_num, int try)
 {
 	cpumask_t physid_mask, tmp;
 	int cpu_id, phys_id;
@@ -761,11 +761,11 @@ static void send_IPI_mask(cpumask_t cpum
 	if (num_cpus <= 1)	/* NO MP */
 		return;
 
-	cpus_and(tmp, cpumask, cpu_online_map);
-	BUG_ON(!cpus_equal(cpumask, tmp));
+	cpumask_and(&tmp, cpumask, cpu_online_mask);
+	BUG_ON(!cpumask_equal(cpumask, &tmp));
 
 	physid_mask = CPU_MASK_NONE;
-	for_each_cpu_mask(cpu_id, cpumask){
+	for_each_cpu(cpu_id, cpumask) {
 		if ((phys_id = cpu_to_physid(cpu_id)) != -1)
 			cpu_set(phys_id, physid_mask);
 	}
diff --git a/arch/m32r/include/asm/smp.h b/arch/m32r/include/asm/smp.h
--- a/arch/m32r/include/asm/smp.h
+++ b/arch/m32r/include/asm/smp.h
@@ -88,7 +88,8 @@ extern unsigned long send_IPI_mask_phys(
 extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif	/* not __ASSEMBLY__ */
 

