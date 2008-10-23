Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbYJWCT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbYJWCT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYJWCI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:59 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754820AbYJWCId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:33 -0400
Message-Id: <20081023020833.097412000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:09:00 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 34/35] cpumask: Use accessors code. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:use-cpumap-accessors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the accessors rather than frobbing bits directly.  Most of this is
in arch code I haven't even compiled, but it is mostly straightforward.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/alpha/kernel/process.c                  |    4 +--
 arch/alpha/kernel/smp.c                      |    7 +++---
 arch/arm/kernel/smp.c                        |    6 ++---
 arch/arm/mach-realview/platsmp.c             |    4 +--
 arch/cris/arch-v32/kernel/smp.c              |   10 ++++-----
 arch/ia64/kernel/acpi.c                      |    6 ++---
 arch/ia64/kernel/setup.c                     |    2 -
 arch/ia64/kernel/smp.c                       |    2 -
 arch/ia64/kernel/smpboot.c                   |   30 +++++++++++----------------
 arch/m32r/kernel/smp.c                       |    2 -
 arch/m32r/kernel/smpboot.c                   |    6 ++---
 arch/mips/kernel/smp-cmp.c                   |    8 ++++---
 arch/mips/kernel/smp-mt.c                    |    2 -
 arch/mips/kernel/smp.c                       |   10 ++++-----
 arch/mips/kernel/smtc.c                      |    6 ++---
 arch/mips/pmc-sierra/yosemite/smp.c          |    5 +---
 arch/mips/sgi-ip27/ip27-smp.c                |    2 -
 arch/mips/sibyte/bcm1480/smp.c               |    5 +---
 arch/mips/sibyte/sb1250/smp.c                |    5 +---
 arch/parisc/kernel/processor.c               |    2 -
 arch/parisc/kernel/smp.c                     |   12 +++++-----
 arch/powerpc/kernel/setup-common.c           |    6 ++---
 arch/powerpc/kernel/smp.c                    |    6 ++---
 arch/powerpc/platforms/powermac/setup.c      |    2 -
 arch/powerpc/platforms/powermac/smp.c        |    4 +--
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    6 ++---
 arch/s390/kernel/smp.c                       |   19 ++++++++---------
 arch/sh/kernel/cpu/sh4a/smp-shx3.c           |    5 +---
 arch/sh/kernel/smp.c                         |   10 ++++-----
 arch/sparc/kernel/smp.c                      |    8 +++----
 arch/sparc/kernel/sun4d_smp.c                |    2 -
 arch/sparc/kernel/sun4m_smp.c                |    2 -
 arch/sparc64/kernel/mdesc.c                  |    4 +--
 arch/sparc64/kernel/prom.c                   |    4 +--
 arch/sparc64/kernel/smp.c                    |    6 ++---
 arch/um/kernel/skas/process.c                |    2 -
 arch/um/kernel/smp.c                         |   10 ++++-----
 arch/x86/kernel/acpi/boot.c                  |    2 -
 arch/x86/kernel/apic.c                       |    4 +--
 arch/x86/kernel/smp.c                        |    2 -
 arch/x86/kernel/smpboot.c                    |   12 +++++-----
 arch/x86/mach-voyager/voyager_smp.c          |   16 +++++++-------
 arch/x86/xen/smp.c                           |    8 +++----
 init/main.c                                  |    6 ++---
 44 files changed, 138 insertions(+), 144 deletions(-)

--- linux-2.6.28.orig/arch/alpha/kernel/process.c
+++ linux-2.6.28/arch/alpha/kernel/process.c
@@ -93,7 +93,7 @@ common_shutdown_1(void *generic_ptr)
 	if (cpuid != boot_cpuid) {
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
-		cpu_clear(cpuid, cpu_present_map);
+		set_cpu_present(cpuid, false);
 		halt();
 	}
 #endif
@@ -119,7 +119,7 @@ common_shutdown_1(void *generic_ptr)
 
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
-	cpu_clear(boot_cpuid, cpu_present_map);
+	set_cpu_present(boot_cpuid, false);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
--- linux-2.6.28.orig/arch/alpha/kernel/smp.c
+++ linux-2.6.28/arch/alpha/kernel/smp.c
@@ -121,10 +121,11 @@ smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
 
-	if (cpu_test_and_set(cpuid, cpu_online_map)) {
+	if (cpu_isset(cpuid, cpu_online_map)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
+	set_cpu_online(cpuid, true);
 
 	/* Turn on machine checks.  */
 	wrmces(7);
@@ -435,7 +436,7 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
-				cpu_set(i, cpu_present_map);
+				set_cpu_present(i, true);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
 
@@ -468,7 +469,7 @@ smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
-		cpu_present_map = cpumask_of_cpu(boot_cpuid);
+		init_cpu_present(cpumask_of(boot_cpuid));
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
 	}
--- linux-2.6.28.orig/arch/arm/kernel/smp.c
+++ linux-2.6.28/arch/arm/kernel/smp.c
@@ -161,7 +161,7 @@ int __cpuexit __cpu_disable(void)
 	 * Take this CPU offline.  Once we clear this, we can't return,
 	 * and we must not schedule until we're ready to give up the cpu.
 	 */
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 
 	/*
 	 * OK - migrate IRQs away from this CPU
@@ -283,7 +283,7 @@ asmlinkage void __cpuinit secondary_star
 	/*
 	 * OK, now it's safe to let the boot CPU continue
 	 */
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 
 	/*
 	 * OK, it's off to the idle thread for us
@@ -415,7 +415,7 @@ static void ipi_cpu_stop(unsigned int cp
 	dump_stack();
 	spin_unlock(&stop_lock);
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 
 	local_fiq_disable();
 	local_irq_disable();
--- linux-2.6.28.orig/arch/arm/mach-realview/platsmp.c
+++ linux-2.6.28/arch/arm/mach-realview/platsmp.c
@@ -193,7 +193,7 @@ void __init smp_init_cpus(void)
 	unsigned int i, ncores = get_core_count();
 
 	for (i = 0; i < ncores; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
@@ -242,7 +242,7 @@ void __init smp_prepare_cpus(unsigned in
 	 * actually populated at the present time.
 	 */
 	for (i = 0; i < max_cpus; i++)
-		cpu_set(i, cpu_present_map);
+		set_cpu_present(i, true);
 
 	/*
 	 * Initialise the SCU if there are more than one CPU and let
--- linux-2.6.28.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6.28/arch/cris/arch-v32/kernel/smp.c
@@ -98,9 +98,9 @@ void __devinit smp_prepare_boot_cpu(void
 	SUPP_BANK_SEL(2);
 	SUPP_REG_WR(RW_MM_TLB_PGD, pgd);
 
-	cpu_set(0, cpu_online_map);
+	set_cpu_online(0, true);
 	cpu_set(0, phys_cpu_present_map);
-	cpu_set(0, cpu_possible_map);
+	set_cpu_possible(0, true);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
@@ -126,10 +126,10 @@ smp_boot_one_cpu(int cpuid)
 	cpu_now_booting = cpuid;
 
 	/* Kick it */
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	cpu_set(cpuid, cpu_mask);
 	send_ipi(IPI_BOOT, 0, cpu_mask);
-	cpu_clear(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, false);
 
 	/* Wait for CPU to come online */
 	for (timeout = 0; timeout < 10000; timeout++) {
@@ -177,7 +177,7 @@ void __init smp_callin(void)
 	notify_cpu_starting(cpu);
 	local_irq_enable();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	cpu_idle();
 }
 
--- linux-2.6.28.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6.28/arch/ia64/kernel/acpi.c
@@ -845,7 +845,7 @@ __init void prefill_possible_map(void)
 		possible, max((possible - available_cpus), 0));
 
 	for (i = 0; i < possible; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 }
 
 int acpi_map_lsapic(acpi_handle handle, int *pcpu)
@@ -890,7 +890,7 @@ int acpi_map_lsapic(acpi_handle handle, 
 
 	acpi_map_cpu2node(handle, cpu, physid);
 
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_present(cpu, true);
 	ia64_cpu_to_sapicid[cpu] = physid;
 
 	*pcpu = cpu;
@@ -902,7 +902,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 int acpi_unmap_lsapic(int cpu)
 {
 	ia64_cpu_to_sapicid[cpu] = -1;
-	cpu_clear(cpu, cpu_present_map);
+	set_cpu_present(cpu, false);
 
 #ifdef CONFIG_ACPI_NUMA
 	/* NUMA specific cleanup's */
--- linux-2.6.28.orig/arch/ia64/kernel/setup.c
+++ linux-2.6.28/arch/ia64/kernel/setup.c
@@ -466,7 +466,7 @@ mark_bsp_online (void)
 {
 #ifdef CONFIG_SMP
 	/* If we register an early console, allow CPU 0 to printk */
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 #endif
 }
 
--- linux-2.6.28.orig/arch/ia64/kernel/smp.c
+++ linux-2.6.28/arch/ia64/kernel/smp.c
@@ -76,7 +76,7 @@ stop_this_cpu(void)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	max_xtp();
 	local_irq_disable();
 	cpu_halt();
--- linux-2.6.28.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6.28/arch/ia64/kernel/smpboot.c
@@ -396,7 +396,7 @@ smp_callin (void)
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	notify_cpu_starting(cpuid);
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
 	ipi_call_unlock_irq();
@@ -550,7 +550,7 @@ do_rest:
 	if (!cpu_isset(cpu, cpu_callin_map)) {
 		printk(KERN_ERR "Processor 0x%x/0x%x is stuck.\n", cpu, sapicid);
 		ia64_cpu_to_sapicid[cpu] = -1;
-		cpu_clear(cpu, cpu_online_map);  /* was set in smp_callin() */
+		set_cpu_online(cpu, false);  /* was set in smp_callin() */
 		return -EINVAL;
 	}
 	return 0;
@@ -580,15 +580,14 @@ smp_build_cpu_map (void)
 	}
 
 	ia64_cpu_to_sapicid[0] = boot_cpu_id;
-	cpus_clear(cpu_present_map);
-	cpu_set(0, cpu_present_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_present(cpumask_of(0));
+	set_cpu_possible(0, true);
 	for (cpu = 1, i = 0; i < smp_boot_data.cpu_count; i++) {
 		sapicid = smp_boot_data.cpu_phys_id[i];
 		if (sapicid == boot_cpu_id)
 			continue;
-		cpu_set(cpu, cpu_present_map);
-		cpu_set(cpu, cpu_possible_map);
+		set_cpu_present(cpu, true);
+		set_cpu_possible(cpu, true);
 		ia64_cpu_to_sapicid[cpu] = sapicid;
 		cpu++;
 	}
@@ -611,7 +610,7 @@ smp_prepare_cpus (unsigned int max_cpus)
 	/*
 	 * We have the boot CPU online for sure.
 	 */
-	cpu_set(0, cpu_online_map);
+	set_cpu_online(0, true);
 	cpu_set(0, cpu_callin_map);
 
 	local_cpu_data->loops_per_jiffy = loops_per_jiffy;
@@ -626,19 +625,16 @@ smp_prepare_cpus (unsigned int max_cpus)
 	 */
 	if (!max_cpus) {
 		printk(KERN_INFO "SMP mode deactivated.\n");
-		cpus_clear(cpu_online_map);
-		cpus_clear(cpu_present_map);
-		cpus_clear(cpu_possible_map);
-		cpu_set(0, cpu_online_map);
-		cpu_set(0, cpu_present_map);
-		cpu_set(0, cpu_possible_map);
+		init_cpu_online(cpumask_of(0));
+		init_cpu_present(cpumask_of(0));
+		init_cpu_possible(cpumask_of(0));
 		return;
 	}
 }
 
 void __devinit smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 	cpu_set(smp_processor_id(), cpu_callin_map);
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	paravirt_post_smp_prepare_boot_cpu();
@@ -737,13 +733,13 @@ int __cpu_disable(void)
 	}
 
 	if (migrate_platform_irqs(cpu)) {
-		cpu_set(cpu, cpu_online_map);
+		set_cpu_online(cpu, true);
 		return (-EBUSY);
 	}
 
 	remove_siblinginfo(cpu);
 	fixup_irqs();
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	local_flush_tlb_all();
 	cpu_clear(cpu, cpu_callin_map);
 	return 0;
--- linux-2.6.28.orig/arch/m32r/kernel/smp.c
+++ linux-2.6.28/arch/m32r/kernel/smp.c
@@ -531,7 +531,7 @@ static void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(cpu_id, cpu_online_map);
+	set_cpu_online(cpu_id, false);
 
 	/*
 	 * PSW IE = 1;
--- linux-2.6.28.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6.28/arch/m32r/kernel/smpboot.c
@@ -135,7 +135,7 @@ void __devinit smp_prepare_boot_cpu(void
 {
 	bsp_phys_id = hard_smp_processor_id();
 	physid_set(bsp_phys_id, phys_cpu_present_map);
-	cpu_set(0, cpu_online_map);	/* BSP's cpu_id == 0 */
+	set_cpu_online(0, true);	/* BSP's cpu_id == 0 */
 	cpu_set(0, cpu_callout_map);
 	cpu_set(0, cpu_callin_map);
 
@@ -178,7 +178,7 @@ void __init smp_prepare_cpus(unsigned in
 	for (phys_id = 0 ; phys_id < nr_cpu ; phys_id++)
 		physid_set(phys_id, phys_cpu_present_map);
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 
 	show_mp_info(nr_cpu);
@@ -503,7 +503,7 @@ static void __init smp_online(void)
 	/* Save our processor parameters */
  	smp_store_cpu_info(cpu_id);
 
-	cpu_set(cpu_id, cpu_online_map);
+	set_cpu_online(cpu_id, true);
 }
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
--- linux-2.6.28.orig/arch/mips/kernel/smp-cmp.c
+++ linux-2.6.28/arch/mips/kernel/smp-cmp.c
@@ -52,8 +52,10 @@ static int __init allowcpus(char *str)
 
 	cpus_clear(cpu_allow_map);
 	if (cpulist_parse(str, &cpu_allow_map) == 0) {
-		cpu_set(0, cpu_allow_map);
-		cpus_and(cpu_possible_map, cpu_possible_map, cpu_allow_map);
+		unsigned int i;
+		for (i = 1; i < nr_cpu_ids; i++)
+			if (!cpumask_test_cpu(i, cpu_allow_map))
+				set_cpu_possible(i, false);
 		len = cpulist_scnprintf(buf, sizeof(buf)-1, &cpu_possible_map);
 		buf[len] = '\0';
 		pr_debug("Allowable CPUs: %s\n", buf);
@@ -226,7 +228,7 @@ void __init cmp_smp_setup(void)
 
 	for (i = 1; i < nr_cpu_ids; i++) {
 		if (amon_cpu_avail(i)) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i]	= ++ncpu;
 			__cpu_logical_map[ncpu]	= i;
 		}
--- linux-2.6.28.orig/arch/mips/kernel/smp-mt.c
+++ linux-2.6.28/arch/mips/kernel/smp-mt.c
@@ -70,7 +70,7 @@ static unsigned int __init smvp_vpe_init
 		write_vpe_c0_vpeconf0(tmp);
 
 		/* Record this as available CPU */
-		cpu_set(tc, cpu_possible_map);
+		set_cpu_possible(tc, true);
 		__cpu_number_map[tc]	= ++ncpu;
 		__cpu_logical_map[ncpu]	= tc;
 	}
--- linux-2.6.28.orig/arch/mips/kernel/smp.c
+++ linux-2.6.28/arch/mips/kernel/smp.c
@@ -157,7 +157,7 @@ static void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	local_irq_enable();	/* May need to service _machine_restart IPI */
 	for (;;);		/* Wait if available. */
 }
@@ -181,7 +181,7 @@ void __init smp_prepare_cpus(unsigned in
 	mp_ops->prepare_cpus(max_cpus);
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 }
 
@@ -194,8 +194,8 @@ void __devinit smp_prepare_boot_cpu(void
 	 */
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
-	cpu_set(0, cpu_possible_map);
-	cpu_set(0, cpu_online_map);
+	set_cpu_possible(0, true);
+	set_cpu_online(0, true);
 	cpu_set(0, cpu_callin_map);
 }
 
@@ -225,7 +225,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	while (!cpu_isset(cpu, cpu_callin_map))
 		udelay(100);
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 
 	return 0;
 }
--- linux-2.6.28.orig/arch/mips/kernel/smtc.c
+++ linux-2.6.28/arch/mips/kernel/smtc.c
@@ -304,7 +304,7 @@ int __init smtc_build_cpu_map(int start_
 	 */
 	ntcs = ((read_c0_mvpconf0() & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1;
 	for (i = start_cpu_slot; i < nr_cpu_ids && i < ntcs; i++) {
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 		__cpu_number_map[i] = i;
 		__cpu_logical_map[i] = i;
 	}
@@ -521,8 +521,8 @@ void smtc_prepare_cpus(int cpus)
 	 * Pull any physically present but unused TCs out of circulation.
 	 */
 	while (tc < (((val & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1)) {
-		cpu_clear(tc, cpu_possible_map);
-		cpu_clear(tc, cpu_present_map);
+		set_cpu_possible(tc, false);
+		set_cpu_present(tc, false);
 		tc++;
 	}
 
--- linux-2.6.28.orig/arch/mips/pmc-sierra/yosemite/smp.c
+++ linux-2.6.28/arch/mips/pmc-sierra/yosemite/smp.c
@@ -150,10 +150,9 @@ static void __init yos_smp_setup(void)
 {
 	int i;
 
-	cpus_clear(cpu_possible_map);
-
+	init_cpu_possible(cpumask_of(0));
 	for (i = 0; i < 2; i++) {
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 		__cpu_number_map[i]	= i;
 		__cpu_logical_map[i]	= i;
 	}
--- linux-2.6.28.orig/arch/mips/sgi-ip27/ip27-smp.c
+++ linux-2.6.28/arch/mips/sgi-ip27/ip27-smp.c
@@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, n
 			/* Only let it join in if it's marked enabled */
 			if ((acpu->cpu_info.flags & KLINFO_ENABLE) &&
 			    (tot_cpus_found != NR_CPUS)) {
-				cpu_set(cpuid, cpu_possible_map);
+				set_cpu_possible(cpuid, true);
 				alloc_cpupda(cpuid, tot_cpus_found);
 				cpus_found++;
 				tot_cpus_found++;
--- linux-2.6.28.orig/arch/mips/sibyte/bcm1480/smp.c
+++ linux-2.6.28/arch/mips/sibyte/bcm1480/smp.c
@@ -145,14 +145,13 @@ static void __init bcm1480_smp_setup(voi
 {
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_possible(cpumask_of(0));
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < nr_cpu_ids; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
--- linux-2.6.28.orig/arch/mips/sibyte/sb1250/smp.c
+++ linux-2.6.28/arch/mips/sibyte/sb1250/smp.c
@@ -133,14 +133,13 @@ static void __init sb1250_smp_setup(void
 {
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(0, cpu_possible_map);
+	init_cpu_possible(cpumask_of(0));
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < nr_cpu_ids; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
--- linux-2.6.28.orig/arch/parisc/kernel/processor.c
+++ linux-2.6.28/arch/parisc/kernel/processor.c
@@ -200,7 +200,7 @@ static int __cpuinit processor_probe(str
 	 */
 #ifdef CONFIG_SMP
 	if (cpuid) {
-		cpu_set(cpuid, cpu_present_map);
+		set_cpu_present(cpuid, true);
 		cpu_up(cpuid);
 	}
 #endif
--- linux-2.6.28.orig/arch/parisc/kernel/smp.c
+++ linux-2.6.28/arch/parisc/kernel/smp.c
@@ -112,7 +112,7 @@ halt_processor(void) 
 {
 	/* REVISIT : redirect I/O Interrupts to another CPU? */
 	/* REVISIT : does PM *know* this CPU isn't available? */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	local_irq_disable();
 	for (;;)
 		;
@@ -298,13 +298,14 @@ smp_cpu_init(int cpunum)
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
@@ -426,8 +427,8 @@ void __devinit smp_prepare_boot_cpu(void
 	/* Setup BSP mappings */
 	printk("SMP: bootstrap CPU ID is %d\n",bootstrap_processor);
 
-	cpu_set(bootstrap_processor, cpu_online_map);
-	cpu_set(bootstrap_processor, cpu_present_map);
+	set_cpu_online(bootstrap_processor, true);
+	set_cpu_present(bootstrap_processor, true);
 }
 
 
@@ -438,8 +439,7 @@ void __devinit smp_prepare_boot_cpu(void
 */
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	cpus_clear(cpu_present_map);
-	cpu_set(0, cpu_present_map);
+	init_cpu_present(cpumask_of(0));
 
 	parisc_max_cpus = max_cpus;
 	if (!max_cpus)
--- linux-2.6.28.orig/arch/powerpc/kernel/setup-common.c
+++ linux-2.6.28/arch/powerpc/kernel/setup-common.c
@@ -424,9 +424,9 @@ void __init smp_setup_cpu_maps(void)
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, intserv[j]);
-			cpu_set(cpu, cpu_present_map);
+			set_cpu_present(cpu, true);
 			set_hard_smp_processor_id(cpu, intserv[j]);
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 			cpu++;
 		}
 	}
@@ -472,7 +472,7 @@ void __init smp_setup_cpu_maps(void)
 			       maxcpus);
 
 		for (cpu = 0; cpu < maxcpus; cpu++)
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 	out:
 		of_node_put(dn);
 	}
--- linux-2.6.28.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6.28/arch/powerpc/kernel/smp.c
@@ -225,7 +225,7 @@ void __devinit smp_prepare_boot_cpu(void
 {
 	BUG_ON(smp_processor_id() != boot_cpuid);
 
-	cpu_set(boot_cpuid, cpu_online_map);
+	set_cpu_online(boot_cpuid, true);
 	cpu_set(boot_cpuid, per_cpu(cpu_sibling_map, boot_cpuid));
 	cpu_set(boot_cpuid, per_cpu(cpu_core_map, boot_cpuid));
 #ifdef CONFIG_PPC64
@@ -245,7 +245,7 @@ int generic_cpu_disable(void)
 	if (cpu == boot_cpuid)
 		return -EBUSY;
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 #ifdef CONFIG_PPC64
 	vdso_data->processorCount--;
 	fixup_irqs(cpu_online_map);
@@ -299,7 +299,7 @@ void generic_mach_cpu_die(void)
 	smp_wmb();
 	while (__get_cpu_var(cpu_state) != CPU_UP_PREPARE)
 		cpu_relax();
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	local_irq_enable();
 }
 #endif
--- linux-2.6.28.orig/arch/powerpc/platforms/powermac/setup.c
+++ linux-2.6.28/arch/powerpc/platforms/powermac/setup.c
@@ -366,7 +366,7 @@ static void __init pmac_setup_arch(void)
 		int cpu;
 
 		for (cpu = 1; cpu < 4 && cpu < nr_cpu_ids; ++cpu)
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 		smp_ops = &psurge_smp_ops;
 	}
 #endif
--- linux-2.6.28.orig/arch/powerpc/platforms/powermac/smp.c
+++ linux-2.6.28/arch/powerpc/platforms/powermac/smp.c
@@ -317,7 +317,7 @@ static int __init smp_psurge_probe(void)
 	if (ncpus > nr_cpu_ids)
 		ncpus = nr_cpu_ids;
 	for (i = 1; i < ncpus ; ++i) {
-		cpu_set(i, cpu_present_map);
+		set_cpu_present(i, true);
 		set_hard_smp_processor_id(i, i);
 	}
 
@@ -861,7 +861,7 @@ static void __devinit smp_core99_setup_c
 
 int smp_core99_cpu_disable(void)
 {
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 
 	/* XXX reset cpu affinity here */
 	mpic_cpu_set_priority(0xf);
--- linux-2.6.28.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ linux-2.6.28/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -94,7 +94,7 @@ static int pseries_cpu_disable(void)
 {
 	int cpu = smp_processor_id();
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	vdso_data->processorCount--;
 
 	/*fix boot_cpuid here*/
@@ -185,7 +185,7 @@ static int pseries_add_processor(struct 
 
 	for_each_cpu_mask(cpu, tmp) {
 		BUG_ON(cpu_isset(cpu, cpu_present_map));
-		cpu_set(cpu, cpu_present_map);
+		set_cpu_present(cpu, true);
 		set_hard_smp_processor_id(cpu, *intserv++);
 	}
 	err = 0;
@@ -217,7 +217,7 @@ static void pseries_remove_processor(str
 			if (get_hard_smp_processor_id(cpu) != intserv[i])
 				continue;
 			BUG_ON(cpu_online(cpu));
-			cpu_clear(cpu, cpu_present_map);
+			set_cpu_present(cpu, false);
 			set_hard_smp_processor_id(cpu, -1);
 			break;
 		}
--- linux-2.6.28.orig/arch/s390/kernel/smp.c
+++ linux-2.6.28/arch/s390/kernel/smp.c
@@ -451,7 +451,7 @@ static int smp_rescan_cpus_sigp(cpumask_
 		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
 		if (!cpu_stopped(logical_cpu))
 			continue;
-		cpu_set(logical_cpu, cpu_present_map);
+		set_cpu_present(logical_cpu, true);
 		smp_cpu_state[logical_cpu] = CPU_STATE_CONFIGURED;
 		logical_cpu = next_cpu(logical_cpu, avail);
 		if (logical_cpu >= nr_cpu_ids)
@@ -483,7 +483,7 @@ static int smp_rescan_cpus_sclp(cpumask_
 			continue;
 		__cpu_logical_map[logical_cpu] = cpu_id;
 		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
-		cpu_set(logical_cpu, cpu_present_map);
+		set_cpu_present(logical_cpu, true);
 		if (cpu >= info->configured)
 			smp_cpu_state[logical_cpu] = CPU_STATE_STANDBY;
 		else
@@ -587,7 +587,7 @@ int __cpuinit start_secondary(void *cpuv
 	notify_cpu_starting(smp_processor_id());
 	/* Mark this cpu as online */
 	spin_lock(&call_lock);
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 	spin_unlock(&call_lock);
 	/* Switch on interrupts */
 	local_irq_enable();
@@ -730,9 +730,8 @@ static int __init setup_possible_cpus(ch
 	int pcpus, cpu;
 
 	pcpus = simple_strtoul(s, NULL, 0);
-	cpu_possible_map = cpumask_of_cpu(0);
-	for (cpu = 1; cpu < pcpus && cpu < nr_cpu_ids; cpu++)
-		cpu_set(cpu, cpu_possible_map);
+	for (cpu = 0; cpu < pcpus && cpu < nr_cpu_ids; cpu++)
+		set_cpu_possible(cpu, true);
 	return 0;
 }
 early_param("possible_cpus", setup_possible_cpus);
@@ -744,7 +743,7 @@ int __cpu_disable(void)
 	struct ec_creg_mask_parms cr_parms;
 	int cpu = smp_processor_id();
 
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 
 	/* Disable pfault pseudo page faults on this cpu. */
 	pfault_fini();
@@ -838,8 +837,8 @@ void __init smp_prepare_boot_cpu(void)
 	BUG_ON(smp_processor_id() != 0);
 
 	current_thread_info()->cpu = 0;
-	cpu_set(0, cpu_present_map);
-	cpu_set(0, cpu_online_map);
+	set_cpu_present(0, true);
+	set_cpu_online(0, true);
 	S390_lowcore.percpu_offset = __per_cpu_offset[0];
 	current_set[0] = current;
 	smp_cpu_state[0] = CPU_STATE_CONFIGURED;
@@ -1106,7 +1105,7 @@ int __ref smp_rescan_cpus(void)
 	for_each_cpu_mask(cpu, newcpus) {
 		rc = smp_add_present_cpu(cpu);
 		if (rc)
-			cpu_clear(cpu, cpu_present_map);
+			set_cpu_present(cpu, false);
 	}
 	rc = 0;
 out:
--- linux-2.6.28.orig/arch/sh/kernel/cpu/sh4a/smp-shx3.c
+++ linux-2.6.28/arch/sh/kernel/cpu/sh4a/smp-shx3.c
@@ -35,8 +35,7 @@ void __init plat_smp_setup(void)
 	unsigned int cpu = 0;
 	int i, num;
 
-	cpus_clear(cpu_possible_map);
-	cpu_set(cpu, cpu_possible_map);
+	init_cpu_possible(cpumask_of(cpu));
 
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
@@ -46,7 +45,7 @@ void __init plat_smp_setup(void)
 	 * for the total number of cores.
 	 */
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 		__cpu_number_map[i] = ++num;
 		__cpu_logical_map[num] = i;
 	}
--- linux-2.6.28.orig/arch/sh/kernel/smp.c
+++ linux-2.6.28/arch/sh/kernel/smp.c
@@ -46,7 +46,7 @@ void __init smp_prepare_cpus(unsigned in
 	plat_prepare_cpus(max_cpus);
 
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 }
 
@@ -57,8 +57,8 @@ void __devinit smp_prepare_boot_cpu(void
 	__cpu_number_map[0] = cpu;
 	__cpu_logical_map[0] = cpu;
 
-	cpu_set(cpu, cpu_online_map);
-	cpu_set(cpu, cpu_possible_map);
+	set_cpu_online(cpu, true);
+	set_cpu_possible(cpu, true);
 }
 
 asmlinkage void __cpuinit start_secondary(void)
@@ -88,7 +88,7 @@ asmlinkage void __cpuinit start_secondar
 
 	smp_store_cpu_info(cpu);
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 
 	cpu_idle();
 }
@@ -158,7 +158,7 @@ void smp_send_reschedule(int cpu)
 
 static void stop_this_cpu(void *unused)
 {
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	local_irq_disable();
 
 	for (;;)
--- linux-2.6.28.orig/arch/sparc/kernel/smp.c
+++ linux-2.6.28/arch/sparc/kernel/smp.c
@@ -331,8 +331,8 @@ void __init smp_setup_cpu_possible_map(v
 	instance = 0;
 	while (!cpu_find_by_instance(instance, NULL, &mid)) {
 		if (mid < NR_CPUS) {
-			cpu_set(mid, cpu_possible_map);
-			cpu_set(mid, cpu_present_map);
+			set_cpu_possible(mid, true);
+			set_cpu_present(mid, true);
 		}
 		instance++;
 	}
@@ -350,8 +350,8 @@ void __init smp_prepare_boot_cpu(void)
 		printk("boot cpu id != 0, this could work but is untested\n");
 
 	current_thread_info()->cpu = cpuid;
-	cpu_set(cpuid, cpu_online_map);
-	cpu_set(cpuid, cpu_possible_map);
+	set_cpu_online(cpuid, true);
+	set_cpu_possible(cpuid, true);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu)
--- linux-2.6.28.orig/arch/sparc/kernel/sun4d_smp.c
+++ linux-2.6.28/arch/sparc/kernel/sun4d_smp.c
@@ -150,7 +150,7 @@ void __init smp4d_callin(void)
 	spin_lock_irqsave(&sun4d_imsk_lock, flags);
 	cc_set_imsk(cc_get_imsk() & ~0x4000); /* Allow PIL 14 as well */
 	spin_unlock_irqrestore(&sun4d_imsk_lock, flags);
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 
 }
 
--- linux-2.6.28.orig/arch/sparc/kernel/sun4m_smp.c
+++ linux-2.6.28/arch/sparc/kernel/sun4m_smp.c
@@ -112,7 +112,7 @@ void __cpuinit smp4m_callin(void)
 
 	local_irq_enable();
 
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 }
 
 /*
--- linux-2.6.28.orig/arch/sparc64/kernel/mdesc.c
+++ linux-2.6.28/arch/sparc64/kernel/mdesc.c
@@ -566,7 +566,7 @@ static void __init report_platform_prope
 			max_cpu = NR_CPUS;
 		}
 		for (i = 0; i < max_cpu; i++)
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 	}
 #endif
 
@@ -826,7 +826,7 @@ void __cpuinit mdesc_fill_in_cpu_data(cp
 		}
 
 #ifdef CONFIG_SMP
-		cpu_set(cpuid, cpu_present_map);
+		set_cpu_present(cpuid, true);
 #endif
 
 		c->core_id = 0;
--- linux-2.6.28.orig/arch/sparc64/kernel/prom.c
+++ linux-2.6.28/arch/sparc64/kernel/prom.c
@@ -1601,8 +1601,8 @@ static void __init of_fill_in_cpu_data(v
 		}
 
 #ifdef CONFIG_SMP
-		cpu_set(cpuid, cpu_present_map);
-		cpu_set(cpuid, cpu_possible_map);
+		set_cpu_present(cpuid, true);
+		set_cpu_possible(cpuid, true);
 #endif
 	}
 
--- linux-2.6.28.orig/arch/sparc64/kernel/smp.c
+++ linux-2.6.28/arch/sparc64/kernel/smp.c
@@ -119,7 +119,7 @@ void __cpuinit smp_callin(void)
 		rmb();
 
 	ipi_call_lock();
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	ipi_call_unlock();
 
 	/* idle thread is expected to have preempt disabled */
@@ -1313,7 +1313,7 @@ int __cpu_disable(void)
 	local_irq_disable();
 
 	ipi_call_lock();
-	cpu_clear(cpu, cpu_online_map);
+	set_cpu_online(cpu, false);
 	ipi_call_unlock();
 
 	return 0;
@@ -1339,7 +1339,7 @@ void __cpu_die(unsigned int cpu)
 		do {
 			hv_err = sun4v_cpu_stop(cpu);
 			if (hv_err == HV_EOK) {
-				cpu_clear(cpu, cpu_present_map);
+				set_cpu_present(cpu, false);
 				break;
 			}
 		} while (--limit > 0);
--- linux-2.6.28.orig/arch/um/kernel/skas/process.c
+++ linux-2.6.28/arch/um/kernel/skas/process.c
@@ -41,7 +41,7 @@ static int __init start_kernel_proc(void
 	cpu_tasks[0].pid = pid;
 	cpu_tasks[0].task = current;
 #ifdef CONFIG_SMP
-	cpu_online_map = cpumask_of_cpu(0);
+	init_cpu_online(cpumask_of(0));
 #endif
 	start_kernel();
 	return 0;
--- linux-2.6.28.orig/arch/um/kernel/smp.c
+++ linux-2.6.28/arch/um/kernel/smp.c
@@ -79,7 +79,7 @@ static int idle_proc(void *cpup)
 		cpu_relax();
 
 	notify_cpu_starting(cpu);
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	default_idle();
 	return 0;
 }
@@ -111,10 +111,10 @@ void smp_prepare_cpus(unsigned int maxcp
 	int i;
 
 	for (i = 0; i < ncpus; ++i)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 
-	cpu_clear(me, cpu_online_map);
-	cpu_set(me, cpu_online_map);
+	set_cpu_online(me, false);
+	set_cpu_online(me, true);
 	cpu_set(me, cpu_callin_map);
 
 	err = os_pipe(cpu_data[me].ipi_pipe, 1, 1);
@@ -141,7 +141,7 @@ void smp_prepare_cpus(unsigned int maxcp
 
 void smp_prepare_boot_cpu(void)
 {
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 }
 
 int __cpu_up(unsigned int cpu)
--- linux-2.6.28.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6.28/arch/x86/kernel/acpi/boot.c
@@ -597,7 +597,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 int acpi_unmap_lsapic(int cpu)
 {
 	per_cpu(x86_cpu_to_apicid, cpu) = -1;
-	cpu_clear(cpu, cpu_present_map);
+	set_cpu_present(cpu, false);
 	num_processors--;
 
 	return (0);
--- linux-2.6.28.orig/arch/x86/kernel/apic.c
+++ linux-2.6.28/arch/x86/kernel/apic.c
@@ -1903,8 +1903,8 @@ void __cpuinit generic_processor_info(in
 	}
 #endif
 
-	cpu_set(cpu, cpu_possible_map);
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_possible(cpu, true);
+	set_cpu_present(cpu, true);
 }
 
 #ifdef CONFIG_X86_64
--- linux-2.6.28.orig/arch/x86/kernel/smp.c
+++ linux-2.6.28/arch/x86/kernel/smp.c
@@ -146,7 +146,7 @@ static void stop_this_cpu(void *dummy)
 	/*
 	 * Remove this CPU:
 	 */
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	disable_local_APIC();
 	if (hlt_works(smp_processor_id()))
 		for (;;) halt();
--- linux-2.6.28.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.28/arch/x86/kernel/smpboot.c
@@ -941,7 +941,7 @@ restore_state:
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
-		cpu_clear(cpu, cpu_present_map);
+		set_cpu_present(cpu, false);
 		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
@@ -1030,8 +1030,8 @@ int __cpuinit native_cpu_up(unsigned int
  */
 static __init void disable_smp(void)
 {
-	cpu_present_map = cpumask_of_cpu(0);
-	cpu_possible_map = cpumask_of_cpu(0);
+	init_cpu_present(cpumask_of(0));
+	init_cpu_possible(cpumask_of(0));
 	smpboot_clear_io_apic_irqs();
 
 	if (smp_found_config)
@@ -1062,14 +1062,14 @@ static int __init smp_sanity_check(unsig
 		nr = 0;
 		for_each_present_cpu(cpu) {
 			if (nr >= 8)
-				cpu_clear(cpu, cpu_present_map);
+				set_cpu_present(cpu, false);
 			nr++;
 		}
 
 		nr = 0;
 		for_each_possible_cpu(cpu) {
 			if (nr >= 8)
-				cpu_clear(cpu, cpu_possible_map);
+				set_cpu_possible(cpu, false);
 			nr++;
 		}
 
@@ -1288,7 +1288,7 @@ __init void prefill_possible_map(void)
 		possible, max_t(int, possible - num_processors, 0));
 
 	for (i = 0; i < possible; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 
 	nr_cpu_ids = possible;
 }
--- linux-2.6.28.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6.28/arch/x86/mach-voyager/voyager_smp.c
@@ -371,7 +371,7 @@ void __init find_smp_config(void)
 	cpus_addr(phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	cpu_possible_map = phys_cpu_present_map;
+	init_cpu_possible(&phys_cpu_present_map);
 	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
 	       cpus_addr(phys_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
@@ -471,7 +471,7 @@ static void __init start_secondary(void 
 
 	local_flush_tlb();
 
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	wmb();
 	cpu_idle();
 }
@@ -595,7 +595,7 @@ static void __init do_boot_cpu(__u8 cpu)
 		print_cpu_info(&cpu_data(cpu));
 		wmb();
 		cpu_set(cpu, cpu_callout_map);
-		cpu_set(cpu, cpu_present_map);
+		set_cpu_present(cpu, true);
 	} else {
 		printk("CPU%d FAILED TO BOOT: ", cpu);
 		if (*
@@ -656,7 +656,7 @@ void __init smp_boot_cpus(void)
 	/* enable our own CPIs */
 	vic_enable_cpi();
 
-	cpu_set(boot_cpu_id, cpu_online_map);
+	set_cpu_online(boot_cpu_id, true);
 	cpu_set(boot_cpu_id, cpu_callout_map);
 
 	/* loop over all the extended VIC CPUs and boot them.  The
@@ -939,7 +939,7 @@ static void smp_enable_irq_interrupt(voi
 static void smp_stop_cpu_function(void *dummy)
 {
 	VDEBUG(("VOYAGER SMP: CPU%d is STOPPING\n", smp_processor_id()));
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	local_irq_disable();
 	for (;;)
 		halt();
@@ -1740,10 +1740,10 @@ static void __cpuinit voyager_smp_prepar
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
 
-	cpu_set(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), true);
 	cpu_set(smp_processor_id(), cpu_callout_map);
-	cpu_set(smp_processor_id(), cpu_possible_map);
-	cpu_set(smp_processor_id(), cpu_present_map);
+	set_cpu_possible(smp_processor_id(), true);
+	set_cpu_present(smp_processor_id(), true);
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
--- linux-2.6.28.orig/arch/x86/xen/smp.c
+++ linux-2.6.28/arch/x86/xen/smp.c
@@ -77,7 +77,7 @@ static __cpuinit void cpu_bringup(void)
 
 	xen_setup_cpu_clockevents();
 
-	cpu_set(cpu, cpu_online_map);
+	set_cpu_online(cpu, true);
 	x86_write_percpu(cpu_state, CPU_ONLINE);
 	wmb();
 
@@ -162,7 +162,7 @@ static void __init xen_fill_possible_map
 		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
 		if (rc >= 0) {
 			num_processors++;
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 		}
 	}
 }
@@ -198,7 +198,7 @@ static void __init xen_smp_prepare_cpus(
 	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
 		for (cpu = nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
 			continue;
-		cpu_clear(cpu, cpu_possible_map);
+		set_cpu_possible(cpu, false);
 	}
 
 	for_each_possible_cpu (cpu) {
@@ -211,7 +211,7 @@ static void __init xen_smp_prepare_cpus(
 		if (IS_ERR(idle))
 			panic("failed fork for CPU %d", cpu);
 
-		cpu_set(cpu, cpu_present_map);
+		set_cpu_present(cpu, true);
 	}
 }
 
--- linux-2.6.28.orig/init/main.c
+++ linux-2.6.28/init/main.c
@@ -529,9 +529,9 @@ static void __init boot_cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
-	cpu_set(cpu, cpu_online_map);
-	cpu_set(cpu, cpu_present_map);
-	cpu_set(cpu, cpu_possible_map);
+	set_cpu_online(cpu, true);
+	set_cpu_present(cpu, true);
+	set_cpu_possible(cpu, true);
 }
 
 void __init __weak smp_setup_processor_id(void)

-- 
