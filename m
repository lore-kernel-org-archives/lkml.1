Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZDNP4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZDNP4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbZDNPv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46022 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbZDNPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:55 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 14/14] [VOYAGER] x86/Voyager: Plumb voyager back into the build
Date: Tue, 14 Apr 2009 10:51:40 -0500
Message-Id: <1239724300-16371-15-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-14-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-12-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-13-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-14-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Voyager can now be converted over to using x86 quirks thanks to the
prior additions.  Most of the internal voyager code is made static and
the rest has a voyager_ prefix to avoid symbol clashes.

The TLB flushing functions still have an apic entanglement, so give
voyager a temporary work around which can be removed when they're all
converted to smp_call_function().

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/Kconfig                       |    4 +-
 arch/x86/Makefile                      |    2 +
 arch/x86/include/asm/voyager.h         |   19 +-
 arch/x86/kernel/setup.c                |    2 +
 arch/x86/mach-voyager/setup.c          |   57 +++--
 arch/x86/mach-voyager/voyager_basic.c  |   95 +++---
 arch/x86/mach-voyager/voyager_smp.c    |  520 ++++++++++----------------------
 arch/x86/mach-voyager/voyager_thread.c |    5 +-
 8 files changed, 262 insertions(+), 442 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 972c7c5..358bec1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -437,8 +437,8 @@ config X86_ES7000
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
-	depends on SMP && !PCI && BROKEN
-	depends on X86_32_NON_STANDARD
+	depends on SMP && X86_32_NON_STANDARD
+	select MCA
 	---help---
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f05d8c9..5cd8bb2 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -127,6 +127,8 @@ core-$(CONFIG_XEN) += arch/x86/xen/
 # lguest paravirtualization support
 core-$(CONFIG_LGUEST_GUEST) += arch/x86/lguest/
 
+core-$(CONFIG_X86_VOYAGER) += arch/x86/mach-voyager/
+
 core-y += arch/x86/kernel/
 core-y += arch/x86/mm/
 
diff --git a/arch/x86/include/asm/voyager.h b/arch/x86/include/asm/voyager.h
index b38a241..a652890 100644
--- a/arch/x86/include/asm/voyager.h
+++ b/arch/x86/include/asm/voyager.h
@@ -503,22 +503,19 @@ extern struct voyager_status voyager_status;
 /* functions exported by the voyager and voyager_smp modules */
 extern int voyager_cat_readb(__u8 module, __u8 asic, int reg);
 extern void voyager_cat_init(void);
-extern void voyager_detect(struct voyager_bios_info *);
-extern void voyager_trap_init(void);
-extern void voyager_setup_irqs(void);
+extern void voyager_early_detect(void);
+extern void voyager_detect(void);
 extern int voyager_memory_detect(int region, __u32 *addr, __u32 *length);
-extern void voyager_smp_intr_init(void);
 extern __u8 voyager_extended_cmos_read(__u16 cmos_address);
 extern void voyager_smp_dump(void);
 extern void voyager_timer_interrupt(void);
-extern void smp_local_timer_interrupt(void);
 extern void voyager_power_off(void);
-extern void smp_voyager_power_off(void *dummy);
 extern void voyager_restart(void);
 extern void voyager_cat_power_off(void);
 extern void voyager_cat_do_common_interrupt(void);
 extern void voyager_handle_nmi(void);
 extern void voyager_smp_intr_init(void);
+
 /* Commands for the following are */
 #define	VOYAGER_PSI_READ	0
 #define VOYAGER_PSI_WRITE	1
@@ -535,12 +532,22 @@ extern asmlinkage void qic_reschedule_interrupt(void);
 extern asmlinkage void qic_enable_irq_interrupt(void);
 extern asmlinkage void qic_call_function_interrupt(void);
 
+#ifdef CONFIG_SMP
+extern void voyager_smp_detect(struct x86_quirks *);
+#else
+static inline void voyager_smp_detect(struct x86_quirks *) { }
+#endif
+
 #else /* CONFIG_X86_VOYAGER */
 
 static inline void voyager_timer_interrupt(void)
 {
 }
 
+static inline void voyager_early_detect(void)
+{
+}
+
 #endif /* CONFIG_X86_VOYAGER */
 
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 13779e2..29f1279 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -99,6 +99,7 @@
 
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
+#include <asm/voyager.h>
 
 #include <asm/percpu.h>
 #include <asm/topology.h>
@@ -676,6 +677,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
+	voyager_early_detect();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index e4516a8..3fc2df7 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -4,23 +4,22 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <asm/arch_hooks.h>
+#include <asm/apic.h>
 #include <asm/voyager.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/timer.h>
 #include <asm/cpu.h>
 
-void __init pre_intr_init_hook(void)
-{
-	init_ISA_irqs();
-}
-
-void __init intr_init_hook(void)
+static int __init voyager_intr_init(void)
 {
 #ifdef CONFIG_SMP
 	voyager_smp_intr_init();
 #endif
+
+	/* need to do the irq2 cascade setup */
+	return 0;
 }
 
 static void voyager_disable_tsc(void)
@@ -30,18 +29,10 @@ static void voyager_disable_tsc(void)
 	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
 
-void __init pre_setup_arch_hook(void)
+int __init voyager_pre_time_init(void)
 {
 	voyager_disable_tsc();
-}
-
-void __init pre_time_init_hook(void)
-{
-	voyager_disable_tsc();
-}
-
-void __init trap_init_hook(void)
-{
+	return 0;
 }
 
 static struct irqaction irq0 = {
@@ -51,18 +42,20 @@ static struct irqaction irq0 = {
 	.name = "timer"
 };
 
-void __init time_init_hook(void)
+static int __init voyager_time_init(void)
 {
 	irq0.mask = cpumask_of_cpu(safe_smp_processor_id());
 	setup_irq(0, &irq0);
+
+	/* return 1 to not do standard timer setup */
+	return 1;
 }
 
 /* Hook for machine specific memory setup. */
 
-char *__init machine_specific_memory_setup(void)
+static char *__init voyager_memory_setup(void)
 {
 	char *who;
-	int new_nr;
 
 	who = "NOT VOYAGER";
 
@@ -104,5 +97,27 @@ char *__init machine_specific_memory_setup(void)
 		return who;
 	}
 
-	return default_machine_specific_memory_setup();
+	return NULL;
+}
+
+static struct x86_quirks voyager_x86_quirks __initdata = {
+	.arch_time_init		= voyager_time_init,
+	.arch_intr_init		= voyager_intr_init,
+	.arch_pre_time_init	= voyager_pre_time_init,
+	.arch_memory_setup	= voyager_memory_setup,
+};
+
+void __init voyager_early_detect(void)
+{
+	if (!is_voyager())
+		return;
+
+	voyager_detect();
+
+	skip_ioapic_setup = 1;
+	voyager_disable_tsc();
+	disable_APIC();
+	voyager_smp_detect(&voyager_x86_quirks);
+	x86_quirks = &voyager_x86_quirks;
+
 }
diff --git a/arch/x86/mach-voyager/voyager_basic.c b/arch/x86/mach-voyager/voyager_basic.c
index 5d37967..5e05334 100644
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -22,24 +22,26 @@
 #include <linux/sysrq.h>
 #include <linux/smp.h>
 #include <linux/nodemask.h>
+#include <linux/mca.h>
 #include <asm/io.h>
 #include <asm/voyager.h>
 #include <asm/vic.h>
 #include <linux/pm.h>
 #include <asm/tlbflush.h>
-#include <asm/arch_hooks.h>
+#include <asm/hpet.h>
 #include <asm/i8253.h>
-
-/*
- * Power off function, if any
- */
-void (*pm_power_off) (void);
-EXPORT_SYMBOL(pm_power_off);
+#include <asm/setup.h>
+#include <asm/timer.h>
+#include <asm/reboot.h>
 
 int voyager_level = 0;
 
 struct voyager_SUS *voyager_SUS = NULL;
 
+static void voyager_machine_emergency_restart(void);
+static void voyager_machine_restart(char *);
+static void voyager_mca_nmi_hook(void);
+
 #ifdef CONFIG_SMP
 static void voyager_dump(int dummy1, struct tty_struct *dummy3)
 {
@@ -54,33 +56,41 @@ static struct sysrq_key_op sysrq_voyager_dump_op = {
 };
 #endif
 
-void voyager_detect(struct voyager_bios_info *bios)
+static void voyager_machine_shutdown(void)
 {
-	if (bios->len != NOT_VOYAGER_BIOS_SIG) {
-		int class = (bios->class_1 << 8)
-		    | (bios->class_2 & 0xff);
-
-		printk("Voyager System detected.\n"
-		       "        Class %x, Revision %d.%d\n",
-		       class, bios->major, bios->minor);
-		if (class == VOYAGER_LEVEL4)
-			voyager_level = 4;
-		else if (class < VOYAGER_LEVEL5_AND_ABOVE)
-			voyager_level = 3;
-		else
-			voyager_level = 5;
-		printk("        Architecture Level %d\n", voyager_level);
-		if (voyager_level < 4)
-			printk
-			    ("\n**WARNING**: Voyager HAL only supports Levels 4 and 5 Architectures at the moment\n\n");
-		/* install the power off handler */
-		pm_power_off = voyager_power_off;
+	/* Need to skip the usual x86 shutdown */
+}
+
+void voyager_detect(void)
+{
+	struct voyager_bios_info *bios = &boot_params.voyager_bios_info;
+
+	int class = (bios->class_1 << 8)
+		| (bios->class_2 & 0xff);
+
+	printk("Voyager System detected.\n"
+	       "        Class %x, Revision %d.%d\n",
+	       class, bios->major, bios->minor);
+	if (class == VOYAGER_LEVEL4)
+		voyager_level = 4;
+	else if (class < VOYAGER_LEVEL5_AND_ABOVE)
+		voyager_level = 3;
+	else
+		voyager_level = 5;
+	printk("        Architecture Level %d\n", voyager_level);
+	if (voyager_level < 4)
+		printk
+			("\n**WARNING**: Voyager HAL only supports Levels 4 and 5 Architectures at the moment\n\n");
+	/* install the power off handler */
+	pm_power_off = voyager_power_off;
+	machine_ops.emergency_restart = voyager_machine_emergency_restart;
+	machine_ops.restart = voyager_machine_restart;
+	machine_ops.shutdown = voyager_machine_shutdown;
+	mca_nmi_hook = voyager_mca_nmi_hook;
+	timer_ack = 0;
 #ifdef CONFIG_SMP
-		register_sysrq_key('v', &sysrq_voyager_dump_op);
+	register_sysrq_key('v', &sysrq_voyager_dump_op);
 #endif
-	} else {
-		printk("\n\n**WARNING**: No Voyager Subsystem Found\n");
-	}
 }
 
 void voyager_system_interrupt(int cpl, void *dev_id)
@@ -235,12 +245,7 @@ static inline void kb_wait(void)
 			break;
 }
 
-void machine_shutdown(void)
-{
-	/* Architecture specific shutdown needed before a kexec */
-}
-
-void machine_restart(char *cmd)
+static void voyager_machine_restart(char *cmd)
 {
 	printk("Voyager Warm Restart\n");
 	kb_wait();
@@ -265,13 +270,13 @@ void machine_restart(char *cmd)
 		halt();
 }
 
-void machine_emergency_restart(void)
+static void voyager_machine_emergency_restart(void)
 {
 	/*for now, just hook this to a warm restart */
 	machine_restart(NULL);
 }
 
-void mca_nmi_hook(void)
+static void voyager_mca_nmi_hook(void)
 {
 	__u8 dumpval __maybe_unused = inb(0xf823);
 	__u8 swnmi __maybe_unused = inb(0xf813);
@@ -297,15 +302,3 @@ void mca_nmi_hook(void)
 	show_stack(NULL, NULL);
 	show_state();
 }
-
-void machine_halt(void)
-{
-	/* treat a halt like a power off */
-	machine_power_off();
-}
-
-void machine_power_off(void)
-{
-	if (pm_power_off)
-		pm_power_off();
-}
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index d7c2a6a..9714975 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -19,30 +19,20 @@
 #include <linux/kernel.h>
 #include <linux/bootmem.h>
 #include <linux/completion.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
+#include <asm/hardirq.h>
 #include <asm/voyager.h>
 #include <asm/vic.h>
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
-#include <asm/arch_hooks.h>
 #include <asm/trampoline.h>
 
-/* TLB state -- visible externally, indexed physically */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate) = { &init_mm, 0 };
-
 /* CPU IRQ affinity -- set to all ones initially */
 static unsigned long cpu_irq_affinity[NR_CPUS] __cacheline_aligned =
 	{[0 ... NR_CPUS-1]  = ~0UL };
 
-/* per CPU data structure (for /proc/cpuinfo et al), visible externally
- * indexed physically */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
-EXPORT_PER_CPU_SYMBOL(cpu_info);
-
-/* physical ID of the CPU used to boot the system */
-unsigned char boot_cpu_id;
-
 /* The memory line addresses for the Quad CPIs */
 struct voyager_qic_cpi *voyager_quad_cpi_addr[NR_CPUS] __cacheline_aligned;
 
@@ -60,12 +50,9 @@ __u32 voyager_quad_processors = 0;
  * activity count.  Finally exported by i386_ksyms.c */
 static int voyager_extended_cpus = 1;
 
-/* Used for the invalidate map that's also checked in the spinlock */
-static volatile unsigned long smp_invalidate_needed;
-
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+static cpumask_t voyager_cpu_present_map = CPU_MASK_NONE;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
@@ -87,9 +74,22 @@ static void vic_enable_cpi(void);
 static void do_boot_cpu(__u8 cpuid);
 static void do_quad_bootstrap(void);
 static void initialize_secondary(void);
+static void smp_local_timer_interrupt(void);
 
-int hard_smp_processor_id(void);
-int safe_smp_processor_id(void);
+static int voyager_hard_smp_processor_id(void)
+{
+	__u8 i;
+	__u8 cpumask = inb(VIC_PROC_WHO_AM_I);
+	if ((cpumask & QUAD_IDENTIFIER) == QUAD_IDENTIFIER)
+		return cpumask & 0x1F;
+
+	for (i = 0; i < 8; i++) {
+		if (cpumask & (1 << i))
+			return i;
+	}
+	printk(KERN_ERR "** WARNING ** Illegal cpuid returned by VIC: %d", cpumask);
+	return 0;
+}
 
 /* Inline functions */
 static inline void send_one_QIC_CPI(__u8 cpu, __u8 cpi)
@@ -108,14 +108,15 @@ static inline void send_QIC_CPI(__u32 cpuset, __u8 cpi)
 			if (!cpu_online(cpu))
 				VDEBUG(("CPU%d sending cpi %d to CPU%d not in "
 					"cpu_online_map\n",
-					hard_smp_processor_id(), cpi, cpu));
+					voyager_hard_smp_processor_id(), cpi, cpu));
 #endif
+
 			send_one_QIC_CPI(cpu, cpi - QIC_CPI_OFFSET);
 		}
 	}
 }
 
-static inline void wrapper_smp_local_timer_interrupt(void)
+static inline void voyager_local_timer_interrupt(void)
 {
 	irq_enter();
 	smp_local_timer_interrupt();
@@ -145,14 +146,14 @@ static inline int is_cpu_quad(void)
 
 static inline int is_cpu_extended(void)
 {
-	__u8 cpu = hard_smp_processor_id();
+	__u8 cpu = voyager_hard_smp_processor_id();
 
 	return (voyager_extended_vic_processors & (1 << cpu));
 }
 
 static inline int is_cpu_vic_boot(void)
 {
-	__u8 cpu = hard_smp_processor_id();
+	__u8 cpu = voyager_hard_smp_processor_id();
 
 	return (voyager_extended_vic_processors
 		& voyager_allowed_boot_processors & (1 << cpu));
@@ -198,11 +199,6 @@ static struct irq_chip vic_chip = {
 /* used to count up as CPUs are brought on line (starts at 0) */
 static int cpucount = 0;
 
-/* The per cpu profile stuff - used in smp_local_timer_interrupt */
-static DEFINE_PER_CPU(int, prof_multiplier) = 1;
-static DEFINE_PER_CPU(int, prof_old_multiplier) = 1;
-static DEFINE_PER_CPU(int, prof_counter) = 1;
-
 /* the map used to check if a CPU has booted */
 static __u32 cpu_booted_map;
 
@@ -316,7 +312,7 @@ static void do_quad_bootstrap(void)
 	if (is_cpu_quad() && is_cpu_vic_boot()) {
 		int i;
 		unsigned long flags;
-		__u8 cpuid = hard_smp_processor_id();
+		__u8 cpuid = voyager_hard_smp_processor_id();
 
 		local_irq_save(flags);
 
@@ -337,28 +333,23 @@ static void do_quad_bootstrap(void)
 	}
 }
 
-void prefill_possible_map(void)
-{
-	/* This is empty on voyager because we need a much
-	 * earlier detection which is done in find_smp_config */
-}
-
 /* Set up all the basic stuff: read the SMP config and make all the
  * SMP information reflect only the boot cpu.  All others will be
  * brought on-line later. */
-void __init find_smp_config(void)
+static int __init voyager_find_smp_config(unsigned int early)
 {
 	int i;
 
-	boot_cpu_id = hard_smp_processor_id();
+	if (!early)
+		return 1;
+
+	boot_cpu_id = voyager_hard_smp_processor_id();
 
 	printk("VOYAGER SMP: Boot cpu is %d\n", boot_cpu_id);
 
 	/* initialize the CPU structures (moved from smp_boot_cpus) */
 	for (i = 0; i < nr_cpu_ids; i++)
 		cpu_irq_affinity[i] = ~0;
-	cpu_online_map = cpumask_of_cpu(boot_cpu_id);
-
 	/* The boot CPU must be extended */
 	voyager_extended_vic_processors = 1 << boot_cpu_id;
 	/* initially, all of the first 8 CPUs can boot */
@@ -366,19 +357,18 @@ void __init find_smp_config(void)
 	/* set up everything for just this CPU, we can alter
 	 * this as we start the other CPUs later */
 	/* now get the CPU disposition from the extended CMOS */
-	cpus_addr(phys_cpu_present_map)[0] =
+	cpus_addr(voyager_cpu_present_map)[0] =
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK);
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK + 1) << 8;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       2) << 16;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	init_cpu_possible(&phys_cpu_present_map);
-	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
-	       cpus_addr(phys_cpu_present_map)[0]);
+	printk("VOYAGER SMP: voyager_cpu_present_map = 0x%lx\n",
+	       cpus_addr(voyager_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
 	/* enable the CPIs by writing the base vector to their register */
 	outb(VIC_DEFAULT_CPI_BASE, VIC_CPI_BASE_REGISTER);
@@ -399,27 +389,13 @@ void __init find_smp_config(void)
 	outb(inb(VOYAGER_SUS_IN_CONTROL_PORT) | VOYAGER_IN_CONTROL_FLAG,
 	     VOYAGER_SUS_IN_CONTROL_PORT);
 
-	current_thread_info()->cpu = boot_cpu_id;
-	percpu_write(cpu_number, boot_cpu_id);
-}
-
-/*
- *	The bootstrap kernel entry code has set these up. Save them
- *	for a given CPU, id is physical */
-void __init smp_store_cpu_info(int id)
-{
-	struct cpuinfo_x86 *c = &cpu_data(id);
-
-	*c = boot_cpu_data;
-	c->cpu_index = id;
-
-	identify_secondary_cpu(c);
+	return 1;
 }
 
 /* Routine initially called when a non-boot CPU is brought online */
 static void __init start_secondary(void *unused)
 {
-	__u8 cpuid = hard_smp_processor_id();
+	__u8 cpuid = voyager_hard_smp_processor_id();
 
 	cpu_init();
 
@@ -442,8 +418,6 @@ static void __init start_secondary(void *unused)
 
 	VDEBUG(("VOYAGER SMP: CPU%d, stack at about %p\n", cpuid, &cpuid));
 
-	notify_cpu_starting(cpuid);
-
 	/* enable interrupts */
 	local_irq_enable();
 
@@ -453,6 +427,8 @@ static void __init start_secondary(void *unused)
 	/* save our processor parameters */
 	smp_store_cpu_info(cpuid);
 
+	set_cpu_sibling_map(cpuid);
+
 	/* if we're a quad, we may need to bootstrap other CPUs */
 	do_quad_bootstrap();
 
@@ -461,18 +437,21 @@ static void __init start_secondary(void *unused)
 	 * permission to proceed.  Without this, the new per CPU stuff
 	 * in the softirqs will fail */
 	local_irq_disable();
-	cpu_set(cpuid, cpu_callin_map);
+	cpumask_set_cpu(cpuid, cpu_callin_mask);
 
 	/* signal that we're done */
 	cpu_booted_map = 1;
 
 	while (!cpu_isset(cpuid, smp_commenced_mask))
 		rep_nop();
+
+	notify_cpu_starting(cpuid);
+
 	local_irq_enable();
 
 	local_flush_tlb();
 
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 	wmb();
 	cpu_idle();
 }
@@ -594,8 +573,8 @@ static void __init do_boot_cpu(__u8 cpu)
 		printk("CPU%d: ", cpu);
 		print_cpu_info(&cpu_data(cpu));
 		wmb();
-		cpu_set(cpu, cpu_callout_map);
-		cpu_set(cpu, cpu_present_map);
+		cpumask_set_cpu(cpu, cpu_callout_mask);
+		set_cpu_present(cpu, true);
 	} else {
 		printk("CPU%d FAILED TO BOOT: ", cpu);
 		if (readb(phys_to_virt(start_phys_address)) == 0xA5)
@@ -607,7 +586,7 @@ static void __init do_boot_cpu(__u8 cpu)
 	}
 }
 
-void __init smp_boot_cpus(void)
+static void __init smp_boot_cpus(void)
 {
 	int i;
 
@@ -620,15 +599,15 @@ void __init smp_boot_cpus(void)
 		/* now that the cat has probed the Voyager System Bus, sanity
 		 * check the cpu map */
 		if (((voyager_quad_processors | voyager_extended_vic_processors)
-		     & cpus_addr(phys_cpu_present_map)[0]) !=
-		    cpus_addr(phys_cpu_present_map)[0]) {
+		     & cpus_addr(voyager_cpu_present_map)[0]) !=
+		    cpus_addr(voyager_cpu_present_map)[0]) {
 			/* should panic */
 			printk("\n\n***WARNING*** "
 			       "Sanity check of CPU present map FAILED\n");
 		}
 	} else if (voyager_level == 4)
 		voyager_extended_vic_processors =
-		    cpus_addr(phys_cpu_present_map)[0];
+		    cpus_addr(voyager_cpu_present_map)[0];
 
 	/* this sets up the idle task to run on the current cpu */
 	voyager_extended_cpus = 1;
@@ -641,6 +620,7 @@ void __init smp_boot_cpus(void)
 	 smp_tune_scheduling();
 	 */
 	smp_store_cpu_info(boot_cpu_id);
+	set_cpu_sibling_map(boot_cpu_id);
 	/* setup the jump vector */
 	initial_code = (unsigned long)initialize_secondary;
 	printk("CPU%d: ", boot_cpu_id);
@@ -656,13 +636,10 @@ void __init smp_boot_cpus(void)
 	/* enable our own CPIs */
 	vic_enable_cpi();
 
-	cpu_set(boot_cpu_id, cpu_online_map);
-	cpu_set(boot_cpu_id, cpu_callout_map);
-
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
 	for (i = 0; i < nr_cpu_ids; i++) {
-		if (i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
+		if (i == boot_cpu_id || !cpu_isset(i, voyager_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
 		/* This udelay seems to be needed for the Quad boots
@@ -755,166 +732,13 @@ void smp_vic_cmn_interrupt(struct pt_regs *regs)
 /*
  * Reschedule call back. Nothing to do, all the work is done
  * automatically when we return from the interrupt.  */
-static void smp_reschedule_interrupt(void)
-{
-	/* do nothing */
-}
-
-static struct mm_struct *flush_mm;
-static unsigned long flush_va;
-static DEFINE_SPINLOCK(tlbstate_lock);
-
-/*
- * We cannot call mmdrop() because we are in interrupt context,
- * instead update mm->cpu_vm_mask.
- *
- * We need to reload %cr3 since the page tables may be going
- * away from under us..
- */
-static inline void voyager_leave_mm(unsigned long cpu)
+static void voyager_reschedule_interrupt(void)
 {
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
+	inc_irq_stat(irq_resched_count);
 }
 
-/*
- * Invalidate call-back
- */
-static void smp_invalidate_interrupt(void)
-{
-	__u8 cpu = smp_processor_id();
-
-	if (!test_bit(cpu, &smp_invalidate_needed))
-		return;
-	/* This will flood messages.  Don't uncomment unless you see
-	 * Problems with cross cpu invalidation
-	 VDEBUG(("VOYAGER SMP: CPU%d received INVALIDATE_CPI\n",
-	 smp_processor_id()));
-	 */
-
-	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
-		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush_va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(flush_va);
-		} else
-			voyager_leave_mm(cpu);
-	}
-	smp_mb__before_clear_bit();
-	clear_bit(cpu, &smp_invalidate_needed);
-	smp_mb__after_clear_bit();
-}
-
-/* All the new flush operations for 2.4 */
-
-/* This routine is called with a physical cpu mask */
-static void
-voyager_flush_tlb_others(unsigned long cpumask, struct mm_struct *mm,
-			 unsigned long va)
-{
-	int stuck = 50000;
-
-	if (!cpumask)
-		BUG();
-	if ((cpumask & cpus_addr(cpu_online_map)[0]) != cpumask)
-		BUG();
-	if (cpumask & (1 << smp_processor_id()))
-		BUG();
-	if (!mm)
-		BUG();
-
-	spin_lock(&tlbstate_lock);
-
-	flush_mm = mm;
-	flush_va = va;
-	atomic_set_mask(cpumask, &smp_invalidate_needed);
-	/*
-	 * We have to send the CPI only to
-	 * CPUs affected.
-	 */
-	send_CPI(cpumask, VIC_INVALIDATE_CPI);
-
-	while (smp_invalidate_needed) {
-		mb();
-		if (--stuck == 0) {
-			printk("***WARNING*** Stuck doing invalidate CPI "
-			       "(CPU%d)\n", smp_processor_id());
-			break;
-		}
-	}
-
-	/* Uncomment only to debug invalidation problems
-	   VDEBUG(("VOYAGER SMP: Completed invalidate CPI (CPU%d)\n", cpu));
-	 */
-
-	flush_mm = NULL;
-	flush_va = 0;
-	spin_unlock(&tlbstate_lock);
-}
-
-void flush_tlb_current_task(void)
-{
-	struct mm_struct *mm = current->mm;
-	unsigned long cpu_mask;
-
-	preempt_disable();
-
-	cpu_mask = cpus_addr(mm->cpu_vm_mask)[0] & ~(1 << smp_processor_id());
-	local_flush_tlb();
-	if (cpu_mask)
-		voyager_flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_mm(struct mm_struct *mm)
-{
-	unsigned long cpu_mask;
-
-	preempt_disable();
-
-	cpu_mask = cpus_addr(mm->cpu_vm_mask)[0] & ~(1 << smp_processor_id());
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			voyager_leave_mm(smp_processor_id());
-	}
-	if (cpu_mask)
-		voyager_flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long cpu_mask;
-
-	preempt_disable();
-
-	cpu_mask = cpus_addr(mm->cpu_vm_mask)[0] & ~(1 << smp_processor_id());
-	if (current->active_mm == mm) {
-		if (current->mm)
-			__flush_tlb_one(va);
-		else
-			voyager_leave_mm(smp_processor_id());
-	}
-
-	if (cpu_mask)
-		voyager_flush_tlb_others(cpu_mask, mm, va);
-
-	preempt_enable();
-}
-
-EXPORT_SYMBOL(flush_tlb_page);
-
 /* enable the requested IRQs */
-static void smp_enable_irq_interrupt(void)
+static void voyager_enable_irq_interrupt(void)
 {
 	__u8 irq;
 	__u8 cpu = get_cpu();
@@ -939,7 +763,7 @@ static void smp_enable_irq_interrupt(void)
 static void smp_stop_cpu_function(void *dummy)
 {
 	VDEBUG(("VOYAGER SMP: CPU%d is STOPPING\n", smp_processor_id()));
-	cpu_clear(smp_processor_id(), cpu_online_map);
+	set_cpu_online(smp_processor_id(), false);
 	local_irq_disable();
 	for (;;)
 		halt();
@@ -949,80 +773,59 @@ static void smp_stop_cpu_function(void *dummy)
  * previously set up.  This is used to schedule a function for
  * execution on all CPUs - set up the function then broadcast a
  * function_interrupt CPI to come here on each CPU */
-static void smp_call_function_interrupt(void)
+static void voyager_call_function_interrupt(void)
 {
 	irq_enter();
 	generic_smp_call_function_interrupt();
-	__get_cpu_var(irq_stat).irq_call_count++;
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
 
-static void smp_call_function_single_interrupt(void)
+static void voyager_call_function_single_interrupt(void)
 {
 	irq_enter();
 	generic_smp_call_function_single_interrupt();
-	__get_cpu_var(irq_stat).irq_call_count++;
+	inc_irq_stat(irq_call_count);
 	irq_exit();
 }
 
-/* Sorry about the name.  In an APIC based system, the APICs
- * themselves are programmed to send a timer interrupt.  This is used
- * by linux to reschedule the processor.  Voyager doesn't have this,
- * so we use the system clock to interrupt one processor, which in
- * turn, broadcasts a timer CPI to all the others --- we receive that
- * CPI here.  We don't use this actually for counting so losing
- * ticks doesn't matter
- *
- * FIXME: For those CPUs which actually have a local APIC, we could
- * try to use it to trigger this interrupt instead of having to
- * broadcast the timer tick.  Unfortunately, all my pentium DYADs have
- * no local APIC, so I can't do this
- *
- * This function is currently a placeholder and is unused in the code */
-void smp_apic_timer_interrupt(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-	wrapper_smp_local_timer_interrupt();
-	set_irq_regs(old_regs);
-}
-
 /* All of the QUAD interrupt GATES */
 void smp_qic_timer_interrupt(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	ack_QIC_CPI(QIC_TIMER_CPI);
-	wrapper_smp_local_timer_interrupt();
+	voyager_local_timer_interrupt();
 	set_irq_regs(old_regs);
 }
 
 void smp_qic_invalidate_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_INVALIDATE_CPI);
-	smp_invalidate_interrupt();
+	smp_invalidate_interrupt(regs);
 }
 
 void smp_qic_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_RESCHEDULE_CPI);
-	smp_reschedule_interrupt();
+	voyager_reschedule_interrupt();
 }
 
 void smp_qic_enable_irq_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_ENABLE_IRQ_CPI);
-	smp_enable_irq_interrupt();
+	voyager_enable_irq_interrupt();
 }
 
 void smp_qic_call_function_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_CALL_FUNCTION_CPI);
-	smp_call_function_interrupt();
+	voyager_call_function_interrupt();
 }
 
 void smp_qic_call_function_single_interrupt(struct pt_regs *regs)
 {
 	ack_QIC_CPI(QIC_CALL_FUNCTION_SINGLE_CPI);
-	smp_call_function_single_interrupt();
+	voyager_call_function_single_interrupt();
 }
 
 void smp_vic_cpi_interrupt(struct pt_regs *regs)
@@ -1036,61 +839,26 @@ void smp_vic_cpi_interrupt(struct pt_regs *regs)
 		ack_VIC_CPI(VIC_CPI_LEVEL0);
 
 	if (test_and_clear_bit(VIC_TIMER_CPI, &vic_cpi_mailbox[cpu]))
-		wrapper_smp_local_timer_interrupt();
+		voyager_local_timer_interrupt();
 	if (test_and_clear_bit(VIC_INVALIDATE_CPI, &vic_cpi_mailbox[cpu]))
-		smp_invalidate_interrupt();
+		smp_invalidate_interrupt(regs);
 	if (test_and_clear_bit(VIC_RESCHEDULE_CPI, &vic_cpi_mailbox[cpu]))
-		smp_reschedule_interrupt();
+		voyager_reschedule_interrupt();
 	if (test_and_clear_bit(VIC_ENABLE_IRQ_CPI, &vic_cpi_mailbox[cpu]))
-		smp_enable_irq_interrupt();
+		voyager_enable_irq_interrupt();
 	if (test_and_clear_bit(VIC_CALL_FUNCTION_CPI, &vic_cpi_mailbox[cpu]))
-		smp_call_function_interrupt();
+		voyager_call_function_interrupt();
 	if (test_and_clear_bit(VIC_CALL_FUNCTION_SINGLE_CPI, &vic_cpi_mailbox[cpu]))
-		smp_call_function_single_interrupt();
+		voyager_call_function_single_interrupt();
 	set_irq_regs(old_regs);
 }
 
-static void do_flush_tlb_all(void *info)
-{
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
-		voyager_leave_mm(cpu);
-}
-
-/* flush the TLB of every active CPU in the system */
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, 0, 1);
-}
-
 /* send a reschedule CPI to one CPU by physical CPU number*/
 static void voyager_smp_send_reschedule(int cpu)
 {
 	send_one_CPI(cpu, VIC_RESCHEDULE_CPI);
 }
 
-int hard_smp_processor_id(void)
-{
-	__u8 i;
-	__u8 cpumask = inb(VIC_PROC_WHO_AM_I);
-	if ((cpumask & QUAD_IDENTIFIER) == QUAD_IDENTIFIER)
-		return cpumask & 0x1F;
-
-	for (i = 0; i < 8; i++) {
-		if (cpumask & (1 << i))
-			return i;
-	}
-	printk("** WARNING ** Illegal cpuid returned by VIC: %d", cpumask);
-	return 0;
-}
-
-int safe_smp_processor_id(void)
-{
-	return hard_smp_processor_id();
-}
-
 /* broadcast a halt to all other CPUs */
 static void voyager_smp_send_stop(void)
 {
@@ -1113,31 +881,14 @@ void smp_vic_timer_interrupt(void)
  * multiplier is 1 and it can be changed by writing the new multiplier
  * value into /proc/profile.
  */
-void smp_local_timer_interrupt(void)
+static void smp_local_timer_interrupt(void)
 {
 	int cpu = smp_processor_id();
 	long weight;
 
+	inc_irq_stat(apic_timer_irqs);
 	profile_tick(CPU_PROFILING);
-	if (--per_cpu(prof_counter, cpu) <= 0) {
-		/*
-		 * The multiplier may have changed since the last time we got
-		 * to this point as a result of the user writing to
-		 * /proc/profile. In this case we need to adjust the APIC
-		 * timer accordingly.
-		 *
-		 * Interrupts are already masked off at this point.
-		 */
-		per_cpu(prof_counter, cpu) = per_cpu(prof_multiplier, cpu);
-		if (per_cpu(prof_counter, cpu) !=
-		    per_cpu(prof_old_multiplier, cpu)) {
-			/* FIXME: need to update the vic timer tick here */
-			per_cpu(prof_old_multiplier, cpu) =
-			    per_cpu(prof_counter, cpu);
-		}
-
-		update_process_times(user_mode_vm(get_irq_regs()));
-	}
+	update_process_times(user_mode(get_irq_regs()));
 
 	if (((1 << cpu) & voyager_extended_vic_processors) == 0)
 		/* only extended VIC processors participate in
@@ -1203,25 +954,6 @@ void smp_local_timer_interrupt(void)
 #endif
 }
 
-/* setup the profiling timer */
-int setup_profiling_timer(unsigned int multiplier)
-{
-	int i;
-
-	if ((!multiplier))
-		return -EINVAL;
-
-	/*
-	 * Set the new multiplier for each CPU. CPUs don't start using the
-	 * new values until the next timer interrupt in which they do process
-	 * accounting.
-	 */
-	for (i = 0; i < nr_cpu_ids; ++i)
-		per_cpu(prof_multiplier, i) = multiplier;
-
-	return 0;
-}
-
 /* This is a bit of a mess, but forced on us by the genirq changes
  * there's no genirq handler that really does what voyager wants
  * so hack it up with the simple IRQ handler */
@@ -1262,12 +994,17 @@ void __init voyager_smp_intr_init(void)
 	QIC_SET_GATE(QIC_CALL_FUNCTION_SINGLE_CPI,
 		     qic_call_function_single_interrupt);
 
-	/* now put the VIC descriptor into the first 48 IRQs
+	/* now put the VIC descriptor into the first 16 IRQs
+	 *
+	 * This is for later: first 16 correspond to PC IRQs;
 	 *
-	 * This is for later: first 16 correspond to PC IRQs; next 16
-	 * are Primary MC IRQs and final 16 are Secondary MC IRQs */
-	for (i = 0; i < 48; i++)
-		set_irq_chip_and_handler(i, &vic_chip, handle_vic_irq);
+	 * Should have next 16 as Primary MC IRQs and final 16 as
+	 * Secondary MC IRQs but in order to fit into the Linux
+	 * scheme, we start each of the separate MC interrupts in the
+	 * same 0-16 legacy space */
+	for (i = 0; i < 16; i++)
+		set_irq_chip_and_handler_name(i, &vic_chip, handle_vic_irq,
+					      "level");
 }
 
 /* send a CPI at level cpi to a set of cpus in cpuset (set 1 bit per
@@ -1280,7 +1017,7 @@ static void send_CPI(__u32 cpuset, __u8 cpi)
 	if (cpi < VIC_START_FAKE_CPI) {
 		/* fake CPI are only used for booting, so send to the
 		 * extended quads as well---Quads must be VIC booted */
-		outb((__u8) (cpuset), VIC_CPI_Registers[cpi]);
+		outb((__u8) cpuset, VIC_CPI_Registers[cpi]);
 		return;
 	}
 	if (quad_cpuset)
@@ -1293,8 +1030,7 @@ static void send_CPI(__u32 cpuset, __u8 cpi)
 		if (cpuset & (1 << cpu))
 			set_bit(cpi, &vic_cpi_mailbox[cpu]);
 	}
-	if (cpuset)
-		outb((__u8) cpuset, VIC_CPI_Registers[VIC_CPI_LEVEL0]);
+	outb((__u8) cpuset, VIC_CPI_Registers[VIC_CPI_LEVEL0]);
 }
 
 /* Acknowledge receipt of CPI in the QIC, clear in QIC hardware and
@@ -1302,7 +1038,7 @@ static void send_CPI(__u32 cpuset, __u8 cpi)
  * */
 static inline void ack_QIC_CPI(__u8 cpi)
 {
-	__u8 cpu = hard_smp_processor_id();
+	__u8 cpu = voyager_hard_smp_processor_id();
 
 	cpi &= 7;
 
@@ -1588,7 +1324,7 @@ static void after_handle_vic_irq(unsigned int irq)
  * change the mask and then do an interrupt enable CPI to re-enable on
  * the selected processors */
 
-void set_vic_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static void set_vic_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	/* Only extended processors handle interrupts */
 	unsigned long real_mask;
@@ -1720,7 +1456,7 @@ void voyager_smp_dump()
 	}
 }
 
-void smp_voyager_power_off(void *dummy)
+static void smp_voyager_power_off(void)
 {
 	if (smp_processor_id() == boot_cpu_id)
 		voyager_power_off();
@@ -1734,16 +1470,23 @@ static void __init voyager_smp_prepare_cpus(unsigned int max_cpus)
 	smp_boot_cpus();
 }
 
+static void __init voyager_prefill_possible_map(void)
+{
+	/* present map is initialised in voyager_find_smp_config */
+	init_cpu_possible(&voyager_cpu_present_map);
+}
+
 static void __cpuinit voyager_smp_prepare_boot_cpu(void)
 {
 	int cpu = smp_processor_id();
 	switch_to_new_gdt(cpu);
 
-	cpu_set(cpu, cpu_online_map);
-	cpu_set(cpu, cpu_callout_map);
-	cpu_set(cpu, cpu_possible_map);
-	cpu_set(cpu, cpu_present_map);
+	init_cpu_online(&cpumask_of_cpu(cpu));
+
+	cpumask_copy(cpu_callout_mask, &cpumask_of_cpu(cpu));
+	cpumask_copy(cpu_callin_mask, &CPU_MASK_NONE);
 
+	init_cpu_present(&cpumask_of_cpu(cpu));
 }
 
 static int __cpuinit voyager_cpu_up(unsigned int cpu)
@@ -1753,7 +1496,7 @@ static int __cpuinit voyager_cpu_up(unsigned int cpu)
 		return -ENOSYS;
 
 	/* In case one didn't come up */
-	if (!cpu_isset(cpu, cpu_callin_map))
+	if (!cpumask_test_cpu(cpu, cpu_callin_mask))
 		return -EIO;
 	/* Unleash the CPU! */
 	cpu_set(cpu, smp_commenced_mask);
@@ -1769,7 +1512,12 @@ static void __init voyager_smp_cpus_done(unsigned int max_cpus)
 
 void __init smp_setup_processor_id(void)
 {
-	current_thread_info()->cpu = hard_smp_processor_id();
+	if (is_voyager()) {
+		int cpu = voyager_hard_smp_processor_id();
+
+		current_thread_info()->cpu = cpu;
+		percpu_write(cpu_number, cpu);
+	}
 }
 
 static void voyager_send_call_func(const struct cpumask *callmask)
@@ -1783,7 +1531,7 @@ static void voyager_send_call_func_single(int cpu)
 	send_CPI(1 << cpu, VIC_CALL_FUNCTION_SINGLE_CPI);
 }
 
-struct smp_ops smp_ops = {
+static struct smp_ops voyager_smp_ops = {
 	.smp_prepare_boot_cpu = voyager_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = voyager_smp_prepare_cpus,
 	.cpu_up = voyager_cpu_up,
@@ -1794,4 +1542,54 @@ struct smp_ops smp_ops = {
 
 	.send_call_func_ipi = voyager_send_call_func,
 	.send_call_func_single_ipi = voyager_send_call_func_single,
+	.hard_smp_processor_id = voyager_hard_smp_processor_id,
+	.safe_smp_processor_id = voyager_hard_smp_processor_id,
 };
+
+static int __init voyager_get_smp_config(unsigned int early)
+{
+	/* Don't do any MP parsing ... we'll crash */
+	return 1;
+}
+
+/*
+ * FIXME: Voyager shouldn't be using apics, so this is temporary
+ * until mm/tlb.c gets sorted out (probably by using smp_call_function)
+ *
+ * What we currently do is hijack apic->send_IPI_mask to send the
+ * flush function (via smp_call_function_many) and apic->write (so
+ * that the entangled ack_APIC_irq also doesn't crash.
+ */
+
+static void voyager_IPI_flush(void *data)
+{
+	unsigned int vector = (unsigned int)(unsigned long)data;
+	struct pt_regs regs;
+
+	regs.orig_ax = ~vector;
+
+	smp_invalidate_interrupt(&regs);
+}
+
+static void voyager_IPI_mask_for_tlb(const cpumask_t *mask, int vector)
+{
+	smp_call_function_many(mask, voyager_IPI_flush, (void *)vector, 1);
+}
+
+#include <asm/apic.h>
+
+static void voyager_apic_write(u32 reg, u32 v)
+{
+}
+
+void voyager_smp_detect(struct x86_quirks *voyager_x86_quirks)
+{
+	smp_ops = voyager_smp_ops;
+	nr_ioapics = 0;
+	voyager_x86_quirks->mach_find_smp_config = voyager_find_smp_config;
+	voyager_x86_quirks->mach_get_smp_config = voyager_get_smp_config;
+	voyager_x86_quirks->prefill_possible_map = voyager_prefill_possible_map;
+	pm_power_off = smp_voyager_power_off;
+	apic->send_IPI_mask = voyager_IPI_mask_for_tlb;
+	apic->write = voyager_apic_write;
+}
diff --git a/arch/x86/mach-voyager/voyager_thread.c b/arch/x86/mach-voyager/voyager_thread.c
index 15464a2..217ccc7 100644
--- a/arch/x86/mach-voyager/voyager_thread.c
+++ b/arch/x86/mach-voyager/voyager_thread.c
@@ -110,6 +110,8 @@ static int thread(void *unused)
 
 static int __init voyager_thread_start(void)
 {
+	if (!is_voyager())
+		return 0;
 	voyager_thread = kthread_run(thread, NULL, "kvoyagerd");
 	if (IS_ERR(voyager_thread)) {
 		printk(KERN_ERR
@@ -121,7 +123,8 @@ static int __init voyager_thread_start(void)
 
 static void __exit voyager_thread_stop(void)
 {
-	kthread_stop(voyager_thread);
+	if (is_voyager())
+		kthread_stop(voyager_thread);
 }
 
 module_init(voyager_thread_start);
-- 
1.6.2.1

