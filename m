Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZBJOAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZBJOAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbZBJOAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:00:00 -0500
Received: from ozlabs.org ([203.10.76.45]:33841 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432AbZBJN76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:59:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PULL] cpumask fixes
Date: Wed, 11 Feb 2009 00:29:49 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Henderson <rth@twiddle.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       James.Bottomley@hansenpartnership.com, Yinghai Lu <yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902110029.50320.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Ingo asked me to send these direct; he's flooded with everything else).

The following changes since commit 4c098bcd55fad34dcf224bf8343db6a9ac58fc68:             
  Linus Torvalds (1):                                                                    
        Merge git://git.kernel.org/.../mason/btrfs-unstable                              

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git master

Rusty Russell (4):
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.
      cpumask: fix powernow-k8: partial revert of 2fdf66b491ac706657946442789ec644cc317e1a
      cpumask: avoid cast-away-const for deprecated cpu_*_map.
      cpumask: Use cpu_*_mask accessors code: alpha

 arch/alpha/kernel/process.c               |    8 ++--
 arch/alpha/kernel/smp.c                   |   12 ++++----
 arch/mips/alchemy/common/time.c           |    2 +-
 arch/sparc/include/asm/topology_64.h      |    2 +-
 arch/x86/include/asm/es7000/apic.h        |    2 +-
 arch/x86/include/asm/numaq/apic.h         |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   12 ++++---
 include/linux/cpumask.h                   |   36 +++++++++++++----------
 init/main.c                               |    7 +----
 kernel/cpu.c                              |   44 +++++++++++++---------------
 kernel/kmod.c                             |    2 +-
 kernel/kthread.c                          |    4 +-
 mm/pdflush.c                              |    2 +-
 13 files changed, 66 insertions(+), 69 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index f238370..8d0097f 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -93,8 +93,8 @@ common_shutdown_1(void *generic_ptr)
 	if (cpuid != boot_cpuid) {
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
-		cpu_clear(cpuid, cpu_present_map);
-		cpu_clear(cpuid, cpu_possible_map);
+		set_cpu_present(cpuid, false);
+		set_cpu_possible(cpuid, false);
 		halt();
 	}
 #endif
@@ -120,8 +120,8 @@ common_shutdown_1(void *generic_ptr)
 
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
-	cpu_clear(boot_cpuid, cpu_present_map);
-	cpu_clear(boot_cpuid, cpu_possible_map);
+	set_cpu_present(boot_cpuid, false);
+	set_cpu_possible(boot_cpuid, false);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 00f1dc3..b1fe567 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -120,12 +120,12 @@ void __cpuinit
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
-	cpumask_t mask = cpu_online_map;
 
-	if (cpu_test_and_set(cpuid, mask)) {
+	if (cpu_online(cpuid)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
+	set_cpu_online(cpuid, true);
 
 	/* Turn on machine checks.  */
 	wrmces(7);
@@ -436,8 +436,8 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
-				cpu_set(i, cpu_possible_map);
-				cpu_set(i, cpu_present_map);
+				set_cpu_possible(i, true);
+				set_cpu_present(i, true);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
 
@@ -470,8 +470,8 @@ smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
-		cpu_possible_map = cpumask_of_cpu(boot_cpuid);
-		cpu_present_map = cpumask_of_cpu(boot_cpuid);
+		init_cpu_possible(cpumask_of(boot_cpuid));
+		init_cpu_present(cpumask_of(boot_cpuid));
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
 	}
diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
index 6fd441d..88a9db8 100644
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -89,7 +89,7 @@ static struct clock_event_device au1x_rtcmatch2_clockdev = {
 	.irq		= AU1000_RTC_MATCH2_INT,
 	.set_next_event	= au1x_rtcmatch2_set_next_event,
 	.set_mode	= au1x_rtcmatch2_set_mode,
-	.cpumask	= CPU_MASK_ALL_PTR,
+	.cpumask	= cpu_all_mask,
 };
 
 static struct irqaction au1x_rtcmatch2_irqaction = {
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 5bc0b8f..bb24a08 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -49,7 +49,7 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	 node_to_cpumask(pcibus_to_node(bus)))
 #define cpumask_of_pcibus(bus)	\
 	(pcibus_to_node(bus) == -1 ? \
-	 CPU_MASK_ALL_PTR : \
+	 cpu_all_mask : \
 	 cpumask_of_node(pcibus_to_node(bus)))
 
 #define SD_NODE_INIT (struct sched_domain) {		\
diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
index c58b9cc..e7216f4 100644
--- a/arch/x86/include/asm/es7000/apic.h
+++ b/arch/x86/include/asm/es7000/apic.h
@@ -13,7 +13,7 @@ static inline int apic_id_registered(void)
 
 static inline const cpumask_t *target_cpus_cluster(void)
 {
-	return &CPU_MASK_ALL;
+	return cpu_all_mask;
 }
 
 static inline const cpumask_t *target_cpus(void)
diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
index bf37bc4..316f196 100644
--- a/arch/x86/include/asm/numaq/apic.h
+++ b/arch/x86/include/asm/numaq/apic.h
@@ -9,7 +9,7 @@
 
 static inline const cpumask_t *target_cpus(void)
 {
-	return &CPU_MASK_ALL;
+	return cpu_all_mask;
 }
 
 #define NO_BALANCE_IRQ (1)
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index fb039cd..6428aa1 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1157,8 +1157,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	data->cpu = pol->cpu;
 	data->currpstate = HW_PSTATE_INVALID;
 
-	rc = powernow_k8_cpu_init_acpi(data);
-	if (rc) {
+	if (powernow_k8_cpu_init_acpi(data)) {
 		/*
 		 * Use the PSB BIOS structure. This is only availabe on
 		 * an UP version, and is deprecated by AMD.
@@ -1176,17 +1175,20 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 			       "ACPI maintainers and complain to your BIOS "
 			       "vendor.\n");
 #endif
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		if (pol->cpu != 0) {
 			printk(KERN_ERR FW_BUG PFX "No ACPI _PSS objects for "
 			       "CPU other than CPU0. Complain to your BIOS "
 			       "vendor.\n");
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		rc = find_psb_table(data);
 		if (rc) {
-			goto err_out;
+			kfree(data);
+			return -ENODEV;
 		}
 		/* Take a crude guess here.
 		 * That guess was in microseconds, so multiply with 1000 */
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9f31538..1846731 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -324,8 +324,6 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
 
-#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
-
 #else
 
 #define CPU_MASK_ALL							\
@@ -334,10 +332,6 @@ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
 } }
 
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
-
 #endif
 
 #define CPU_MASK_NONE							\
@@ -482,16 +476,26 @@ int __next_cpu_nr(int n, const cpumask_t *srcp);
  *    only one CPU.
  */
 
-extern const struct cpumask *const cpu_possible_mask;
-extern const struct cpumask *const cpu_online_mask;
-extern const struct cpumask *const cpu_present_mask;
-extern const struct cpumask *const cpu_active_mask;
-
-/* These strip const, as traditionally they weren't const. */
-#define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
-#define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
-#define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
-#define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
+#define cpu_possible_mask \
+	((const struct cpumask *)to_cpumask(__cpu_possible_bits))
+#define cpu_online_mask \
+	((const struct cpumask *)to_cpumask(__cpu_online_bits))
+#define cpu_present_mask \
+	((const struct cpumask *)to_cpumask(__cpu_present_bits))
+#define cpu_active_mask \
+	((const struct cpumask *)to_cpumask(__cpu_active_bits))
+
+/* Deprecated non-const versions. */
+#define cpu_possible_map	(*to_cpumask(__cpu_possible_bits))
+#define cpu_online_map		(*to_cpumask(__cpu_online_bits))
+#define cpu_present_map		(*to_cpumask(__cpu_present_bits))
+#define cpu_active_map		(*to_cpumask(__cpu_active_bits))
+
+/* Don't use these directly: use cpu_*_mask, set_cpu_* or init_cpu_*. */
+extern unsigned long __cpu_possible_bits[];
+extern unsigned long __cpu_online_bits[];
+extern unsigned long __cpu_present_bits[];
+extern unsigned long __cpu_active_bits[];
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
diff --git a/init/main.c b/init/main.c
index 8442094..730f1a1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -359,11 +359,6 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
 
 #else
 
-#if NR_CPUS > BITS_PER_LONG
-cpumask_t cpu_mask_all __read_mostly = CPU_MASK_ALL;
-EXPORT_SYMBOL(cpu_mask_all);
-#endif
-
 /* Setup number of possible processor ids */
 int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
@@ -834,7 +829,7 @@ static int __init kernel_init(void * unused)
 	/*
 	 * init can run on any cpu.
 	 */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 	/*
 	 * Tell the world that we're going to be the grim
 	 * reaper of innocent orphaned children.
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 79e40f0..a903318 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -499,69 +499,65 @@ const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
 EXPORT_SYMBOL(cpu_all_bits);
 
 #ifdef CONFIG_INIT_ALL_POSSIBLE
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
+DECLARE_BITMAP(__cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
 	= CPU_BITS_ALL;
 #else
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
+DECLARE_BITMAP(__cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
 #endif
-const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
-EXPORT_SYMBOL(cpu_possible_mask);
+EXPORT_SYMBOL(__cpu_possible_bits);
 
-static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
-EXPORT_SYMBOL(cpu_online_mask);
+DECLARE_BITMAP(__cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
+EXPORT_SYMBOL(__cpu_online_bits);
 
-static DECLARE_BITMAP(cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_present_mask = to_cpumask(cpu_present_bits);
-EXPORT_SYMBOL(cpu_present_mask);
+DECLARE_BITMAP(__cpu_present_bits, CONFIG_NR_CPUS) __read_mostly;
+EXPORT_SYMBOL(__cpu_present_bits);
 
-static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
-const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
-EXPORT_SYMBOL(cpu_active_mask);
+DECLARE_BITMAP(__cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
+EXPORT_SYMBOL(__cpu_active_bits);
 
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_possible_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_possible_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_possible_bits));
 }
 
 void set_cpu_present(unsigned int cpu, bool present)
 {
 	if (present)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_present_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_present_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_present_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_present_bits));
 }
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
 	if (online)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_online_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_online_bits));
 }
 
 void set_cpu_active(unsigned int cpu, bool active)
 {
 	if (active)
-		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_set_cpu(cpu, to_cpumask(__cpu_active_bits));
 	else
-		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
+		cpumask_clear_cpu(cpu, to_cpumask(__cpu_active_bits));
 }
 
 void init_cpu_present(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_present_bits), src);
+	cpumask_copy(to_cpumask(__cpu_present_bits), src);
 }
 
 void init_cpu_possible(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_possible_bits), src);
+	cpumask_copy(to_cpumask(__cpu_possible_bits), src);
 }
 
 void init_cpu_online(const struct cpumask *src)
 {
-	cpumask_copy(to_cpumask(cpu_online_bits), src);
+	cpumask_copy(to_cpumask(__cpu_online_bits), src);
 }
diff --git a/kernel/kmod.c b/kernel/kmod.c
index a27a5f6..f0c8f54 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -167,7 +167,7 @@ static int ____call_usermodehelper(void *data)
 	}
 
 	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(current, cpu_all_mask);
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 4fbc456..84bbadd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -110,7 +110,7 @@ static void create_kthread(struct kthread_create_info *create)
 		 */
 		sched_setscheduler(create->result, SCHED_NORMAL, &param);
 		set_user_nice(create->result, KTHREAD_NICE_LEVEL);
-		set_cpus_allowed_ptr(create->result, CPU_MASK_ALL_PTR);
+		set_cpus_allowed_ptr(create->result, cpu_all_mask);
 	}
 	complete(&create->done);
 }
@@ -240,7 +240,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_user_nice(tsk, KTHREAD_NICE_LEVEL);
-	set_cpus_allowed_ptr(tsk, CPU_MASK_ALL_PTR);
+	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
diff --git a/mm/pdflush.c b/mm/pdflush.c
index 15de509..118905e 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -191,7 +191,7 @@ static int pdflush(void *dummy)
 
 	/*
 	 * Some configs put our parent kthread in a limited cpuset,
-	 * which kthread() overrides, forcing cpus_allowed == CPU_MASK_ALL.
+	 * which kthread() overrides, forcing cpus_allowed == cpu_all_mask.
 	 * Our needs are more modest - cut back to our cpusets cpus_allowed.
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
