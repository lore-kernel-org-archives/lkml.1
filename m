Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbZCPEOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbZCPEOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZCPEOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:07 -0400
Received: from ozlabs.org ([203.10.76.45]:57300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbZCPEOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:06 -0400
Subject: [PULL] cpumask updates for alpha
From: Rusty Russell <rusty@rustcorp.com.au>
To: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, travis@sgi.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:43:56 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161443.57265.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-alpha.git master

Rusty Russell (3):
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): alpha
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: alpha
      cpumask: arch_send_call_function_ipi_mask: alpha

 arch/alpha/include/asm/smp.h      |    3 ++-
 arch/alpha/include/asm/topology.h |    1 -
 arch/alpha/kernel/irq.c           |    2 +-
 arch/alpha/kernel/smp.c           |   31 +++++++++++++++----------------
 4 files changed, 18 insertions(+), 19 deletions(-)

commit 16b8b2042882f1270754cf6ba30d5bc1441c541d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:10:43 2009 +1030

    cpumask: arch_send_call_function_ipi_mask: alpha
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask().
    
    We also take the chance to wean the send_ipi_message off the
    obsolescent for_each_cpu_mask(): making it take a pointer seemed the
    most natural way to do this.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/alpha/include/asm/smp.h b/arch/alpha/include/asm/smp.h
index 547e909..8818a1b 100644
--- a/arch/alpha/include/asm/smp.h
+++ b/arch/alpha/include/asm/smp.h
@@ -47,7 +47,8 @@ extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 extern int smp_num_cpus;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #else /* CONFIG_SMP */
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 286597e..aa77864 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -547,16 +547,16 @@ setup_profiling_timer(unsigned int multiplier)
 
 
 static void
-send_ipi_message(cpumask_t to_whom, enum ipi_message_type operation)
+send_ipi_message(const struct cpumask *to_whom, enum ipi_message_type operation)
 {
 	int i;
 
 	mb();
-	for_each_cpu_mask(i, to_whom)
+	for_each_cpu(i, to_whom)
 		set_bit(operation, &ipi_data[i].bits);
 
 	mb();
-	for_each_cpu_mask(i, to_whom)
+	for_each_cpu(i, to_whom)
 		wripir(i);
 }
 
@@ -623,7 +623,7 @@ smp_send_reschedule(int cpu)
 		printk(KERN_WARNING
 		       "smp_send_reschedule: Sending IPI to self.\n");
 #endif
-	send_ipi_message(cpumask_of_cpu(cpu), IPI_RESCHEDULE);
+	send_ipi_message(cpumask_of(cpu), IPI_RESCHEDULE);
 }
 
 void
@@ -635,17 +635,17 @@ smp_send_stop(void)
 	if (hard_smp_processor_id() != boot_cpu_id)
 		printk(KERN_WARNING "smp_send_stop: Not on boot cpu.\n");
 #endif
-	send_ipi_message(to_whom, IPI_CPU_STOP);
+	send_ipi_message(&to_whom, IPI_CPU_STOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	send_ipi_message(mask, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
+	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
 static void

commit 8dfa51d38b49cb5e724d0a30aac113744a0eb971
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:10:42 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: alpha
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 703731a..b6e2b86 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -52,7 +52,7 @@ int irq_select_affinity(unsigned int irq)
 
 	while (!cpu_possible(cpu) ||
 	       !cpumask_test_cpu(cpu, irq_default_affinity))
-		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
+		cpu = (cpu < (nr_cpu_ids-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
 	irq_desc[irq].affinity = cpumask_of_cpu(cpu);
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index b1fe567..286597e 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -500,9 +500,8 @@ smp_cpus_done(unsigned int max_cpus)
 	int cpu;
 	unsigned long bogosum = 0;
 
-	for(cpu = 0; cpu < NR_CPUS; cpu++) 
-		if (cpu_online(cpu))
-			bogosum += cpu_data[cpu].loops_per_jiffy;
+	for_each_online_cpu(cpu)
+		bogosum += cpu_data[cpu].loops_per_jiffy;
 	
 	printk(KERN_INFO "SMP: Total of %d processors activated "
 	       "(%lu.%02lu BogoMIPS).\n",
@@ -701,8 +700,8 @@ flush_tlb_mm(struct mm_struct *mm)
 		flush_tlb_current(mm);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
-				if (!cpu_online(cpu) || cpu == this_cpu)
+			for_each_online_cpu(cpu) {
+				if (cpu == this_cpu)
 					continue;
 				if (mm->context[cpu])
 					mm->context[cpu] = 0;
@@ -750,8 +749,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
-				if (!cpu_online(cpu) || cpu == this_cpu)
+			for_each_online_cpu(cpu) {
+				if (cpu == this_cpu)
 					continue;
 				if (mm->context[cpu])
 					mm->context[cpu] = 0;
@@ -806,8 +805,8 @@ flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 		__load_new_mm_context(mm);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-			for (cpu = 0; cpu < NR_CPUS; cpu++) {
-				if (!cpu_online(cpu) || cpu == this_cpu)
+			for_each_online_cpu(cpu) {
+				if (cpu == this_cpu)
 					continue;
 				if (mm->context[cpu])
 					mm->context[cpu] = 0;

commit 61ed3414a45c445426216a7c9ebbcf027d806499
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:10:42 2009 +1030

    cpumask: remove the now-obsoleted pcibus_to_cpumask(): alpha
    
    Impact: reduce stack usage for large NR_CPUS
    
    cpumask_of_pcibus() is the new version.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
index b4f284c..f5bd6cd 100644
--- a/arch/alpha/include/asm/topology.h
+++ b/arch/alpha/include/asm/topology.h
@@ -55,7 +55,6 @@ static const struct cpumask *cpumask_of_node(int node)
 	return &node_to_cpumask_map[node];
 }
 
-#define pcibus_to_cpumask(bus)	(cpu_online_map)
 #define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 #endif /* !CONFIG_NUMA */

