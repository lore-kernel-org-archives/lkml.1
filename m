Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYJWCKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYJWCKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYJWCIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43357 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752667AbYJWCI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:27 -0400
Message-Id: <20081023020827.114132000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:30 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/35] cpumask: centralize cpu_online_map and cpu_possible_map
Content-Disposition: inline; filename=cpumask:centralize-common-maps.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each SMP arch defines these themselves.  Move them to a central
location.

Two twists:
1) Some archs set possible_map to all 1, so we add a
   CONFIG_INIT_ALL_POSSIBLE for this rather than break them.

2) mips and sparc32 '#define cpu_possible_map phys_cpu_present_map'.
   Those archs simply have phys_cpu_present_map replaced everywhere.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/alpha/kernel/smp.c             |    5 -----
 arch/arm/kernel/smp.c               |   10 ----------
 arch/cris/arch-v32/kernel/smp.c     |    4 ----
 arch/ia64/kernel/smpboot.c          |    6 ------
 arch/m32r/Kconfig                   |    1 +
 arch/m32r/kernel/smpboot.c          |    6 ------
 arch/mips/include/asm/smp.h         |    3 ---
 arch/mips/kernel/smp-cmp.c          |    2 +-
 arch/mips/kernel/smp-mt.c           |    2 +-
 arch/mips/kernel/smp.c              |    7 +------
 arch/mips/kernel/smtc.c             |    6 +++---
 arch/mips/pmc-sierra/yosemite/smp.c |    6 +++---
 arch/mips/sgi-ip27/ip27-smp.c       |    2 +-
 arch/mips/sibyte/bcm1480/smp.c      |    8 ++++----
 arch/mips/sibyte/sb1250/smp.c       |    8 ++++----
 arch/parisc/Kconfig                 |    1 +
 arch/parisc/kernel/smp.c            |   15 ---------------
 arch/powerpc/kernel/smp.c           |    4 ----
 arch/s390/Kconfig                   |    1 +
 arch/s390/kernel/smp.c              |    6 ------
 arch/sh/kernel/smp.c                |    6 ------
 arch/sparc/include/asm/smp_32.h     |    2 --
 arch/sparc/kernel/smp.c             |    6 ++----
 arch/sparc/kernel/sparc_ksyms.c     |    4 ----
 arch/sparc64/kernel/smp.c           |    4 ----
 arch/um/kernel/smp.c                |    7 -------
 arch/x86/kernel/smpboot.c           |    6 ------
 arch/x86/mach-voyager/voyager_smp.c |    7 -------
 init/Kconfig                        |    9 +++++++++
 kernel/cpu.c                        |   11 ++++++-----
 30 files changed, 38 insertions(+), 127 deletions(-)

--- linux-2.6.28.orig/arch/alpha/kernel/smp.c
+++ linux-2.6.28/arch/alpha/kernel/smp.c
@@ -70,11 +70,6 @@ enum ipi_message_type {
 /* Set to a secondary's cpuid when it comes online.  */
 static int smp_secondary_alive __devinitdata = 0;
 
-/* Which cpus ids came online.  */
-cpumask_t cpu_online_map;
-
-EXPORT_SYMBOL(cpu_online_map);
-
 int smp_num_probed;		/* Internal processor count */
 int smp_num_cpus = 1;		/* Number that came online.  */
 EXPORT_SYMBOL(smp_num_cpus);
--- linux-2.6.28.orig/arch/arm/kernel/smp.c
+++ linux-2.6.28/arch/arm/kernel/smp.c
@@ -34,16 +34,6 @@
 #include <asm/ptrace.h>
 
 /*
- * bitmask of present and online CPUs.
- * The present bitmask indicates that the CPU is physically present.
- * The online bitmask indicates that the CPU is up and running.
- */
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-
-/*
  * as from 2.5, kernels no longer have an init_tasks structure
  * so we need some other way of telling a new secondary core
  * where to place its SVC stack
--- linux-2.6.28.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6.28/arch/cris/arch-v32/kernel/smp.c
@@ -29,11 +29,7 @@
 spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
 
 /* CPU masks */
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_online_map);
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_SYMBOL(phys_cpu_present_map);
 
 /* Variables used during SMP boot */
--- linux-2.6.28.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6.28/arch/ia64/kernel/smpboot.c
@@ -131,12 +131,6 @@ struct task_struct *task_for_booting_cpu
  */
 DEFINE_PER_CPU(int, cpu_state);
 
-/* Bitmasks of currently online, and possible CPUs */
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_possible_map);
-
 cpumask_t cpu_core_map[NR_CPUS] __cacheline_aligned;
 EXPORT_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(cpumask_t, cpu_sibling_map);
--- linux-2.6.28.orig/arch/m32r/Kconfig
+++ linux-2.6.28/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	default y
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select INIT_ALL_POSSIBLE
 
 config SBUS
 	bool
--- linux-2.6.28.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6.28/arch/m32r/kernel/smpboot.c
@@ -73,17 +73,11 @@ static unsigned int bsp_phys_id = -1;
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
-/* Bitmask of currently online CPUs */
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-
 cpumask_t cpu_bootout_map;
 cpumask_t cpu_bootin_map;
 static cpumask_t cpu_callin_map;
 cpumask_t cpu_callout_map;
 EXPORT_SYMBOL(cpu_callout_map);
-cpumask_t cpu_possible_map = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
 
 /* Per CPU bogomips and other parameters */
 struct cpuinfo_m32r cpu_data[NR_CPUS] __cacheline_aligned;
--- linux-2.6.28.orig/arch/mips/include/asm/smp.h
+++ linux-2.6.28/arch/mips/include/asm/smp.h
@@ -38,9 +38,6 @@ extern int __cpu_logical_map[NR_CPUS];
 #define SMP_RESCHEDULE_YOURSELF	0x1	/* XXX braindead */
 #define SMP_CALL_FUNCTION	0x2
 
-extern cpumask_t phys_cpu_present_map;
-#define cpu_possible_map	phys_cpu_present_map
-
 extern void asmlinkage smp_bootstrap(void);
 
 /*
--- linux-2.6.28.orig/arch/mips/kernel/smp-cmp.c
+++ linux-2.6.28/arch/mips/kernel/smp-cmp.c
@@ -226,7 +226,7 @@ void __init cmp_smp_setup(void)
 
 	for (i = 1; i < NR_CPUS; i++) {
 		if (amon_cpu_avail(i)) {
-			cpu_set(i, phys_cpu_present_map);
+			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i]	= ++ncpu;
 			__cpu_logical_map[ncpu]	= i;
 		}
--- linux-2.6.28.orig/arch/mips/kernel/smp-mt.c
+++ linux-2.6.28/arch/mips/kernel/smp-mt.c
@@ -70,7 +70,7 @@ static unsigned int __init smvp_vpe_init
 		write_vpe_c0_vpeconf0(tmp);
 
 		/* Record this as available CPU */
-		cpu_set(tc, phys_cpu_present_map);
+		cpu_set(tc, cpu_possible_map);
 		__cpu_number_map[tc]	= ++ncpu;
 		__cpu_logical_map[ncpu]	= tc;
 	}
--- linux-2.6.28.orig/arch/mips/kernel/smp.c
+++ linux-2.6.28/arch/mips/kernel/smp.c
@@ -44,15 +44,10 @@
 #include <asm/mipsmtregs.h>
 #endif /* CONFIG_MIPS_MT_SMTC */
 
-cpumask_t phys_cpu_present_map;		/* Bitmask of available CPUs */
 volatile cpumask_t cpu_callin_map;	/* Bitmask of started secondaries */
-cpumask_t cpu_online_map;		/* Bitmask of currently online CPUs */
 int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
 int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
 
-EXPORT_SYMBOL(phys_cpu_present_map);
-EXPORT_SYMBOL(cpu_online_map);
-
 extern void cpu_idle(void);
 
 /* Number of TCs (or siblings in Intel speak) per CPU core */
@@ -199,7 +194,7 @@ void __devinit smp_prepare_boot_cpu(void
 	 */
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
-	cpu_set(0, phys_cpu_present_map);
+	cpu_set(0, cpu_possible_map);
 	cpu_set(0, cpu_online_map);
 	cpu_set(0, cpu_callin_map);
 }
--- linux-2.6.28.orig/arch/mips/kernel/smtc.c
+++ linux-2.6.28/arch/mips/kernel/smtc.c
@@ -290,7 +290,7 @@ static void smtc_configure_tlb(void)
  * possibly leave some TCs/VPEs as "slave" processors.
  *
  * Use c0_MVPConf0 to find out how many TCs are available, setting up
- * phys_cpu_present_map and the logical/physical mappings.
+ * cpu_possible_map and the logical/physical mappings.
  */
 
 int __init smtc_build_cpu_map(int start_cpu_slot)
@@ -304,7 +304,7 @@ int __init smtc_build_cpu_map(int start_
 	 */
 	ntcs = ((read_c0_mvpconf0() & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1;
 	for (i=start_cpu_slot; i<NR_CPUS && i<ntcs; i++) {
-		cpu_set(i, phys_cpu_present_map);
+		cpu_set(i, cpu_possible_map);
 		__cpu_number_map[i] = i;
 		__cpu_logical_map[i] = i;
 	}
@@ -521,7 +521,7 @@ void smtc_prepare_cpus(int cpus)
 	 * Pull any physically present but unused TCs out of circulation.
 	 */
 	while (tc < (((val & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1)) {
-		cpu_clear(tc, phys_cpu_present_map);
+		cpu_clear(tc, cpu_possible_map);
 		cpu_clear(tc, cpu_present_map);
 		tc++;
 	}
--- linux-2.6.28.orig/arch/mips/pmc-sierra/yosemite/smp.c
+++ linux-2.6.28/arch/mips/pmc-sierra/yosemite/smp.c
@@ -141,7 +141,7 @@ static void __cpuinit yos_boot_secondary
 }
 
 /*
- * Detect available CPUs, populate phys_cpu_present_map before smp_init
+ * Detect available CPUs, populate cpu_possible_map before smp_init
  *
  * We don't want to start the secondary CPU yet nor do we have a nice probing
  * feature in PMON so we just assume presence of the secondary core.
@@ -150,10 +150,10 @@ static void __init yos_smp_setup(void)
 {
 	int i;
 
-	cpus_clear(phys_cpu_present_map);
+	cpus_clear(cpu_possible_map);
 
 	for (i = 0; i < 2; i++) {
-		cpu_set(i, phys_cpu_present_map);
+		cpu_set(i, cpu_possible_map);
 		__cpu_number_map[i]	= i;
 		__cpu_logical_map[i]	= i;
 	}
--- linux-2.6.28.orig/arch/mips/sgi-ip27/ip27-smp.c
+++ linux-2.6.28/arch/mips/sgi-ip27/ip27-smp.c
@@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, n
 			/* Only let it join in if it's marked enabled */
 			if ((acpu->cpu_info.flags & KLINFO_ENABLE) &&
 			    (tot_cpus_found != NR_CPUS)) {
-				cpu_set(cpuid, phys_cpu_present_map);
+				cpu_set(cpuid, cpu_possible_map);
 				alloc_cpupda(cpuid, tot_cpus_found);
 				cpus_found++;
 				tot_cpus_found++;
--- linux-2.6.28.orig/arch/mips/sibyte/bcm1480/smp.c
+++ linux-2.6.28/arch/mips/sibyte/bcm1480/smp.c
@@ -136,7 +136,7 @@ static void __cpuinit bcm1480_boot_secon
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
- * phys_cpu_present_map and the logical/physical mappings.
+ * cpu_possible_map and the logical/physical mappings.
  * XXXKW will the boot CPU ever not be physical 0?
  *
  * Common setup before any secondaries are started
@@ -145,14 +145,14 @@ static void __init bcm1480_smp_setup(voi
 {
 	int i, num;
 
-	cpus_clear(phys_cpu_present_map);
-	cpu_set(0, phys_cpu_present_map);
+	cpus_clear(cpu_possible_map);
+	cpu_set(0, cpu_possible_map);
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, phys_cpu_present_map);
+			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
--- linux-2.6.28.orig/arch/mips/sibyte/sb1250/smp.c
+++ linux-2.6.28/arch/mips/sibyte/sb1250/smp.c
@@ -124,7 +124,7 @@ static void __cpuinit sb1250_boot_second
 
 /*
  * Use CFE to find out how many CPUs are available, setting up
- * phys_cpu_present_map and the logical/physical mappings.
+ * cpu_possible_map and the logical/physical mappings.
  * XXXKW will the boot CPU ever not be physical 0?
  *
  * Common setup before any secondaries are started
@@ -133,14 +133,14 @@ static void __init sb1250_smp_setup(void
 {
 	int i, num;
 
-	cpus_clear(phys_cpu_present_map);
-	cpu_set(0, phys_cpu_present_map);
+	cpus_clear(cpu_possible_map);
+	cpu_set(0, cpu_possible_map);
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
 	for (i = 1, num = 0; i < NR_CPUS; i++) {
 		if (cfe_cpu_stop(i) == 0) {
-			cpu_set(i, phys_cpu_present_map);
+			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i] = ++num;
 			__cpu_logical_map[num] = i;
 		}
--- linux-2.6.28.orig/arch/parisc/Kconfig
+++ linux-2.6.28/arch/parisc/Kconfig
@@ -11,6 +11,7 @@ config PARISC
 	select HAVE_OPROFILE
 	select RTC_CLASS
 	select RTC_DRV_PARISC
+	select INIT_ALL_POSSIBLE
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
 	  in many of their workstations & servers (HP9000 700 and 800 series,
--- linux-2.6.28.orig/arch/parisc/kernel/smp.c
+++ linux-2.6.28/arch/parisc/kernel/smp.c
@@ -67,21 +67,6 @@ static volatile int cpu_now_booting __re
 
 static int parisc_max_cpus __read_mostly = 1;
 
-/* online cpus are ones that we've managed to bring up completely
- * possible cpus are all valid cpu 
- * present cpus are all detected cpu
- *
- * On startup we bring up the "possible" cpus. Since we discover
- * CPUs later, we add them as hotplug, so the possible cpu mask is
- * empty in the beginning.
- */
-
-cpumask_t cpu_online_map   __read_mostly = CPU_MASK_NONE;	/* Bitmap of online CPUs */
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;	/* Bitmap of Present CPUs */
-
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_possible_map);
-
 DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
 
 enum ipi_message_type {
--- linux-2.6.28.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6.28/arch/powerpc/kernel/smp.c
@@ -60,13 +60,9 @@
 int smp_hw_index[NR_CPUS];
 struct thread_info *secondary_ti;
 
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-cpumask_t cpu_online_map = CPU_MASK_NONE;
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 DEFINE_PER_CPU(cpumask_t, cpu_core_map) = CPU_MASK_NONE;
 
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
--- linux-2.6.28.orig/arch/s390/Kconfig
+++ linux-2.6.28/arch/s390/Kconfig
@@ -75,6 +75,7 @@ config S390
 	select HAVE_KRETPROBES
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
+	select INIT_ALL_POSSIBLE
 
 source "init/Kconfig"
 
--- linux-2.6.28.orig/arch/s390/kernel/smp.c
+++ linux-2.6.28/arch/s390/kernel/smp.c
@@ -52,12 +52,6 @@
 struct _lowcore *lowcore_ptr[NR_CPUS];
 EXPORT_SYMBOL(lowcore_ptr);
 
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_online_map);
-
-cpumask_t cpu_possible_map = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_possible_map);
-
 static struct task_struct *current_set[NR_CPUS];
 
 static u8 smp_cpu_type;
--- linux-2.6.28.orig/arch/sh/kernel/smp.c
+++ linux-2.6.28/arch/sh/kernel/smp.c
@@ -30,12 +30,6 @@
 int __cpu_number_map[NR_CPUS];		/* Map physical to logical */
 int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
 
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
-
-cpumask_t cpu_online_map;
-EXPORT_SYMBOL(cpu_online_map);
-
 static inline void __init smp_store_cpu_info(unsigned int cpu)
 {
 	struct sh_cpuinfo *c = cpu_data + cpu;
--- linux-2.6.28.orig/arch/sparc/include/asm/smp_32.h
+++ linux-2.6.28/arch/sparc/include/asm/smp_32.h
@@ -29,8 +29,6 @@
  */
 
 extern unsigned char boot_cpu_id;
-extern cpumask_t phys_cpu_present_map;
-#define cpu_possible_map phys_cpu_present_map
 
 typedef void (*smpfunc_t)(unsigned long, unsigned long, unsigned long,
 		       unsigned long, unsigned long);
--- linux-2.6.28.orig/arch/sparc/kernel/smp.c
+++ linux-2.6.28/arch/sparc/kernel/smp.c
@@ -39,8 +39,6 @@ volatile unsigned long cpu_callin_map[NR
 unsigned char boot_cpu_id = 0;
 unsigned char boot_cpu_id4 = 0; /* boot_cpu_id << 2 */
 
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
 cpumask_t smp_commenced_mask = CPU_MASK_NONE;
 
 /* The only guaranteed locking primitive available on all Sparc
@@ -334,7 +332,7 @@ void __init smp_setup_cpu_possible_map(v
 	instance = 0;
 	while (!cpu_find_by_instance(instance, NULL, &mid)) {
 		if (mid < NR_CPUS) {
-			cpu_set(mid, phys_cpu_present_map);
+			cpu_set(mid, cpu_possible_map);
 			cpu_set(mid, cpu_present_map);
 		}
 		instance++;
@@ -354,7 +352,7 @@ void __init smp_prepare_boot_cpu(void)
 
 	current_thread_info()->cpu = cpuid;
 	cpu_set(cpuid, cpu_online_map);
-	cpu_set(cpuid, phys_cpu_present_map);
+	cpu_set(cpuid, cpu_possible_map);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu)
--- linux-2.6.28.orig/arch/sparc/kernel/sparc_ksyms.c
+++ linux-2.6.28/arch/sparc/kernel/sparc_ksyms.c
@@ -113,10 +113,6 @@ EXPORT_PER_CPU_SYMBOL(__cpu_data);
 #ifdef CONFIG_SMP
 /* IRQ implementation. */
 EXPORT_SYMBOL(synchronize_irq);
-
-/* CPU online map and active count. */
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(phys_cpu_present_map);
 #endif
 
 EXPORT_SYMBOL(__udelay);
--- linux-2.6.28.orig/arch/sparc64/kernel/smp.c
+++ linux-2.6.28/arch/sparc64/kernel/smp.c
@@ -49,14 +49,10 @@
 
 int sparc64_multi_core __read_mostly;
 
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_NONE;
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_NONE;
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map) = CPU_MASK_NONE;
 cpumask_t cpu_core_map[NR_CPUS] __read_mostly =
 	{ [0 ... NR_CPUS-1] = CPU_MASK_NONE };
 
-EXPORT_SYMBOL(cpu_possible_map);
-EXPORT_SYMBOL(cpu_online_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 EXPORT_SYMBOL(cpu_core_map);
 
--- linux-2.6.28.orig/arch/um/kernel/smp.c
+++ linux-2.6.28/arch/um/kernel/smp.c
@@ -25,13 +25,6 @@ DEFINE_PER_CPU(struct mmu_gather, mmu_ga
 #include "irq_user.h"
 #include "os.h"
 
-/* CPU online map, set by smp_boot_cpus */
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-
-EXPORT_SYMBOL(cpu_online_map);
-EXPORT_SYMBOL(cpu_possible_map);
-
 /* Per CPU bogomips and other parameters
  * The only piece used here is the ipi pipe, which is set before SMP is
  * started and never changed.
--- linux-2.6.28.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.28/arch/x86/kernel/smpboot.c
@@ -101,14 +101,8 @@ EXPORT_SYMBOL(smp_num_siblings);
 /* Last level cache ID of each logical CPU */
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
 
-/* bitmap of online cpus */
-cpumask_t cpu_online_map __read_mostly;
-EXPORT_SYMBOL(cpu_online_map);
-
 cpumask_t cpu_callin_map;
 cpumask_t cpu_callout_map;
-cpumask_t cpu_possible_map;
-EXPORT_SYMBOL(cpu_possible_map);
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
--- linux-2.6.28.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-2.6.28/arch/x86/mach-voyager/voyager_smp.c
@@ -62,11 +62,6 @@ static int voyager_extended_cpus = 1;
 /* Used for the invalidate map that's also checked in the spinlock */
 static volatile unsigned long smp_invalidate_needed;
 
-/* Bitmask of currently online CPUs - used by setup.c for
-   /proc/cpuinfo, visible externally but still physical */
-cpumask_t cpu_online_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_online_map);
-
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
 cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
@@ -216,8 +211,6 @@ static cpumask_t smp_commenced_mask = CP
 /* This is for the new dynamic CPU boot code */
 cpumask_t cpu_callin_map = CPU_MASK_NONE;
 cpumask_t cpu_callout_map = CPU_MASK_NONE;
-cpumask_t cpu_possible_map = CPU_MASK_NONE;
-EXPORT_SYMBOL(cpu_possible_map);
 
 /* The per processor IRQ masks (these are usually kept in sync) */
 static __u16 vic_irq_mask[NR_CPUS] __cacheline_aligned;
--- linux-2.6.28.orig/init/Kconfig
+++ linux-2.6.28/init/Kconfig
@@ -911,6 +911,15 @@ config KMOD
 
 endif # MODULES
 
+config INIT_ALL_POSSIBLE
+	bool
+	help
+	  Back when each arch used to define their own cpu_online_map and
+	  cpu_possible_map, some of them chose to initialize cpu_possible_map
+	  with all 1s, and others with all 0s.  When they were centralised,
+	  it was better to provide this option than to break all the archs
+	  and have several arch maintainers persuing me down dark alleys.
+
 config STOP_MACHINE
 	bool
 	default y
--- linux-2.6.28.orig/kernel/cpu.c
+++ linux-2.6.28/kernel/cpu.c
@@ -24,19 +24,20 @@
 cpumask_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
-#ifndef CONFIG_SMP
-
 /*
  * Represents all cpu's that are currently online.
  */
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
+cpumask_t cpu_online_map __read_mostly;
 EXPORT_SYMBOL(cpu_online_map);
 
+#ifdef CONFIG_INIT_ALL_POSSIBLE
 cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
+#else
+cpumask_t cpu_possible_map __read_mostly;
+#endif
 EXPORT_SYMBOL(cpu_possible_map);
 
-#else /* CONFIG_SMP */
-
+#ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 

-- 
