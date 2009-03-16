Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZCPEQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZCPEQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZCPEOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:46 -0400
Received: from ozlabs.org ([203.10.76.45]:57333 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZCPEOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:43 -0400
Subject: [PULL] cpumask updates for parisc
From: Rusty Russell <rusty@rustcorp.com.au>
To: Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, travis@sgi.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:35 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.36219.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-parisc.git master

Rusty Russell (3):
      cpumask: arch_send_call_function_ipi_mask: parisc
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: parisc
      cpumask: Use accessors code.: parisc

 arch/parisc/include/asm/smp.h  |    3 ++-
 arch/parisc/kernel/irq.c       |    4 ++--
 arch/parisc/kernel/processor.c |    6 +++---
 arch/parisc/kernel/smp.c       |   18 +++++++++---------
 4 files changed, 16 insertions(+), 15 deletions(-)

commit 9bc181d8d7cb6462de0c315e364780ad275f7c57
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:19:38 2009 +1030

    cpumask: Use accessors code.: parisc
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but it is mostly straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor.c
index 44a1a50..bdbabfb 100644
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -214,7 +214,7 @@ static int __cpuinit processor_probe(struct parisc_device *dev)
 	 */
 #ifdef CONFIG_SMP
 	if (cpuid) {
-		cpu_set(cpuid, cpu_present_map);
+		set_cpu_present(cpuid, true);
 		cpu_up(cpuid);
 	}
 #endif
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index ba9b680..8691979 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -113,7 +113,7 @@ halt_processor(void)
 {
 	/* REVISIT : redirect I/O Interrupts to another CPU? */
 	/* REVISIT : does PM *know* this CPU isn't available? */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	local_irq_disable();
 	for (;;)
 		;
@@ -296,13 +296,14 @@ smp_cpu_init(int cpunum)
 	mb();
 
 	/* Well, support 2.4 linux scheme as well. */
-	if (cpu_test_and_set(cpunum, cpu_online_map))
+	if (cpu_isset(cpunum, cpu_online_map))
 	{
 		extern void machine_halt(void); /* arch/parisc.../process.c */
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
 		machine_halt();
 	}  
+	set_cpu_online(cpunum, true);
 
 	/* Initialise the idle task for this CPU */
 	atomic_inc(&init_mm.mm_count);
@@ -424,8 +425,8 @@ void __init smp_prepare_boot_cpu(void)
 	/* Setup BSP mappings */
 	printk(KERN_INFO "SMP: bootstrap CPU ID is %d\n", bootstrap_processor);
 
-	cpu_set(bootstrap_processor, cpu_online_map);
-	cpu_set(bootstrap_processor, cpu_present_map);
+	set_cpu_online(bootstrap_processor, true);
+	set_cpu_present(bootstrap_processor, true);
 }
 
 
@@ -436,8 +437,7 @@ void __init smp_prepare_boot_cpu(void)
 */
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	cpus_clear(cpu_present_map);
-	cpu_set(0, cpu_present_map);
+	init_cpu_present(cpumask_of(0));
 
 	parisc_max_cpus = max_cpus;
 	if (!max_cpus)

commit bd071e1a371d31db243edc4714ff9e8d1ea1309e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:19:37 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: parisc
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 29e70e1..103752a 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -311,12 +311,12 @@ unsigned long txn_alloc_addr(unsigned int virt_irq)
 	next_cpu++; /* assign to "next" CPU we want this bugger on */
 
 	/* validate entry */
-	while ((next_cpu < NR_CPUS) &&
+	while ((next_cpu < nr_cpu_ids) &&
 		(!per_cpu(cpu_data, next_cpu).txn_addr ||
 		 !cpu_online(next_cpu)))
 		next_cpu++;
 
-	if (next_cpu >= NR_CPUS) 
+	if (next_cpu >= nr_cpu_ids) 
 		next_cpu = 0;	/* nothing else, assign monarch */
 
 	return txn_affinity_addr(virt_irq, next_cpu);
diff --git a/arch/parisc/kernel/processor.c b/arch/parisc/kernel/processor.c
index ecb6093..44a1a50 100644
--- a/arch/parisc/kernel/processor.c
+++ b/arch/parisc/kernel/processor.c
@@ -100,8 +100,8 @@ static int __cpuinit processor_probe(struct parisc_device *dev)
 	struct cpuinfo_parisc *p;
 
 #ifdef CONFIG_SMP
-	if (num_online_cpus() >= NR_CPUS) {
-		printk(KERN_INFO "num_online_cpus() >= NR_CPUS\n");
+	if (num_online_cpus() >= nr_cpu_ids) {
+		printk(KERN_INFO "num_online_cpus() >= nr_cpu_ids\n");
 		return 1;
 	}
 #else

commit 91887a362984324e254473e92820758c8e658f78
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:19:37 2009 +1030

    cpumask: arch_send_call_function_ipi_mask: parisc
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask(), and by defining
    it, the old arch_send_call_function_ipi is defined by the core code.
    
    We also take the chance to change send_IPI_mask() and use the new
    for_each_cpu() iterator.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
index 6ef4b78..21eb45a 100644
--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -29,7 +29,8 @@ extern void smp_send_reschedule(int cpu);
 extern void smp_send_all_nop(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* !ASSEMBLY */
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 9995d7e..ba9b680 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -214,11 +214,11 @@ ipi_send(int cpu, enum ipi_message_type op)
 }
 
 static void
-send_IPI_mask(cpumask_t mask, enum ipi_message_type op)
+send_IPI_mask(const struct cpumask *mask, enum ipi_message_type op)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, mask)
 		ipi_send(cpu, op);
 }
 
@@ -257,7 +257,7 @@ smp_send_all_nop(void)
 	send_IPI_allbutself(IPI_NOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	send_IPI_mask(mask, IPI_CALL_FUNC);
 }

