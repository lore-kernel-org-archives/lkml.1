Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYHKWWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYHKWWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYHKWV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:21:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56564 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYHKWV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:21:56 -0400
Date: Tue, 12 Aug 2008 00:21:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes for -rc3
Message-ID: <20080811222141.GA22169@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Alok Kataria (1):
      x86: Fix broken VMI in 2.6.27-rc..

Eric W. Biederman (2):
      x86: Restore proper vector locking during cpu hotplug
      x86_64: restore the proper NR_IRQS define so larger systems work.

Jeremy Fitzhardinge (1):
      x86: work around gcc 3.4.x bug

Krzysztof Helt (1):
      x86: fdiv bug detection fix

Randy Dunlap (2):
      x86, pci-calgary: fix function declaration
      EFI, x86: fix function prototype

Rene Herman (3):
      x86, debug: tone down arch/x86/kernel/mpparse.c debugging printk
      x86: make "apic" an early_param() on 32-bit
      x86: make "apic" an early_param() on 32-bit, NULL check

Yinghai Lu (1):
      x86: fix 2.6.27rc1 cannot boot more than 8CPUs


 arch/x86/kernel/apic_32.c        |   14 +++++++++-----
 arch/x86/kernel/cpu/bugs.c       |    6 +++++-
 arch/x86/kernel/io_apic_32.c     |    6 +-----
 arch/x86/kernel/io_apic_64.c     |   25 +++++++++++++++----------
 arch/x86/kernel/mpparse.c        |   11 ++++++-----
 arch/x86/kernel/pci-calgary_64.c |    2 +-
 arch/x86/kernel/setup.c          |   22 ++++++++--------------
 arch/x86/kernel/smpboot.c        |   22 +++++++++++++++++++---
 arch/x86/kernel/vmi_32.c         |    3 ++-
 arch/x86/mm/pgtable.c            |    3 +++
 include/asm-x86/efi.h            |    2 +-
 include/asm-x86/hw_irq.h         |   12 ++++++++++--
 include/asm-x86/irq_vectors.h    |   10 +++++++++-
 13 files changed, 89 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d6c8983..039a8d4 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1720,15 +1720,19 @@ static int __init parse_lapic_timer_c2_ok(char *arg)
 }
 early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
 
-static int __init apic_set_verbosity(char *str)
+static int __init apic_set_verbosity(char *arg)
 {
-	if (strcmp("debug", str) == 0)
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "debug") == 0)
 		apic_verbosity = APIC_DEBUG;
-	else if (strcmp("verbose", str) == 0)
+	else if (strcmp(arg, "verbose") == 0)
 		apic_verbosity = APIC_VERBOSE;
-	return 1;
+
+	return 0;
 }
-__setup("apic=", apic_set_verbosity);
+early_param("apic", apic_set_verbosity);
 
 static int __init lapic_insert_resource(void)
 {
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c9b58a8..c8e315f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -50,6 +50,8 @@ static double __initdata y = 3145727.0;
  */
 static void __init check_fpu(void)
 {
+	s32 fdiv_bug;
+
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
@@ -74,8 +76,10 @@ static void __init check_fpu(void)
 		"fistpl %0\n\t"
 		"fwait\n\t"
 		"fninit"
-		: "=m" (*&boot_cpu_data.fdiv_bug)
+		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
+
+	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk("Hmm, FPU with FDIV bug.\n");
 }
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index de9aa0e..09cddb5 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -57,7 +57,7 @@ atomic_t irq_mis_count;
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 static DEFINE_SPINLOCK(ioapic_lock);
-static DEFINE_SPINLOCK(vector_lock);
+DEFINE_SPINLOCK(vector_lock);
 
 int timer_through_8259 __initdata;
 
@@ -1209,10 +1209,6 @@ static int assign_irq_vector(int irq)
 	return vector;
 }
 
-void setup_vector_irq(int cpu)
-{
-}
-
 static struct irq_chip ioapic_chip;
 
 #define IOAPIC_AUTO	-1
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 8269434..61a83b7 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -101,7 +101,7 @@ int timer_through_8259 __initdata;
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
 
 static DEFINE_SPINLOCK(ioapic_lock);
-DEFINE_SPINLOCK(vector_lock);
+static DEFINE_SPINLOCK(vector_lock);
 
 /*
  * # of IRQ routing registers
@@ -697,6 +697,19 @@ static int pin_2_irq(int idx, int apic, int pin)
 	return irq;
 }
 
+void lock_vector_lock(void)
+{
+	/* Used to the online set of cpus does not change
+	 * during assign_irq_vector.
+	 */
+	spin_lock(&vector_lock);
+}
+
+void unlock_vector_lock(void)
+{
+	spin_unlock(&vector_lock);
+}
+
 static int __assign_irq_vector(int irq, cpumask_t mask)
 {
 	/*
@@ -802,7 +815,7 @@ static void __clear_irq_vector(int irq)
 	cpus_clear(cfg->domain);
 }
 
-static void __setup_vector_irq(int cpu)
+void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
 	/* This function must be called with vector_lock held */
@@ -825,14 +838,6 @@ static void __setup_vector_irq(int cpu)
 	}
 }
 
-void setup_vector_irq(int cpu)
-{
-	spin_lock(&vector_lock);
-	__setup_vector_irq(smp_processor_id());
-	spin_unlock(&vector_lock);
-}
-
-
 static struct irq_chip ioapic_chip;
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6ae005c..6780905 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -83,7 +83,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 	if (x86_quirks->mpc_oem_bus_info)
 		x86_quirks->mpc_oem_bus_info(m, str);
 	else
-		printk(KERN_INFO "Bus #%d is %s\n", m->mpc_busid, str);
+		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->mpc_busid, str);
 
 #if MAX_MP_BUSSES < 256
 	if (m->mpc_busid >= MAX_MP_BUSSES) {
@@ -154,7 +154,7 @@ static void __init MP_ioapic_info(struct mpc_config_ioapic *m)
 
 static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
 {
-	printk(KERN_CONT "Int: type %d, pol %d, trig %d, bus %02x,"
+	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
@@ -163,7 +163,7 @@ static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
 
 static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
 {
-	printk(KERN_CONT "Int: type %d, pol %d, trig %d, bus %02x,"
+	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
 		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
@@ -235,7 +235,7 @@ static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 
 static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
 {
-	printk(KERN_INFO "Lint: type %d, pol %d, trig %d, bus %02x,"
+	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbusid,
@@ -695,7 +695,8 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	printk(KERN_DEBUG "Scan SMP from %p for %ld bytes.\n", bp, length);
+	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
+			bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index b67a4b1..02d1932 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1350,7 +1350,7 @@ static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
  * Function for kdump case. Get the tce tables from first kernel
  * by reading the contents of the base adress register of calgary iommu
  */
-static void get_tce_space_from_tar()
+static void get_tce_space_from_tar(void)
 {
 	int bus;
 	void __iomem *target;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2d88858..68b48e3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -604,6 +604,14 @@ void __init setup_arch(char **cmdline_p)
 	early_cpu_init();
 	early_ioremap_init();
 
+#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
+	/*
+	 * Must be before kernel pagetables are setup
+	 * or fixmap area is touched.
+	 */
+	vmi_init();
+#endif
+
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
 	screen_info = boot_params.screen_info;
 	edid_info = boot_params.edid_info;
@@ -817,14 +825,6 @@ void __init setup_arch(char **cmdline_p)
 	kvmclock_init();
 #endif
 
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_32)
-	/*
-	 * Must be after max_low_pfn is determined, and before kernel
-	 * pagetables are setup.
-	 */
-	vmi_init();
-#endif
-
 	paravirt_pagetable_setup_start(swapper_pg_dir);
 	paging_init();
 	paravirt_pagetable_setup_done(swapper_pg_dir);
@@ -861,12 +861,6 @@ void __init setup_arch(char **cmdline_p)
 	init_apic_mappings();
 	ioapic_init_mappings();
 
-#if defined(CONFIG_SMP) && defined(CONFIG_X86_PC) && defined(CONFIG_X86_32)
-	if (def_to_bigsmp)
-		printk(KERN_WARNING "More than 8 CPUs detected and "
-			"CONFIG_X86_PC cannot handle it.\nUse "
-			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
-#endif
 	kvm_guest_init();
 
 	e820_reserve_resources();
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3325127..91055d7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -326,12 +326,16 @@ static void __cpuinit start_secondary(void *unused)
 	 * for which cpus receive the IPI. Holding this
 	 * lock helps us to not include this cpu in a currently in progress
 	 * smp_call_function().
+	 *
+	 * We need to hold vector_lock so there the set of online cpus
+	 * does not change while we are assigning vectors to cpus.  Holding
+	 * this lock ensures we don't half assign or remove an irq from a cpu.
 	 */
 	ipi_call_lock_irq();
-#ifdef CONFIG_X86_IO_APIC
-	setup_vector_irq(smp_processor_id());
-#endif
+	lock_vector_lock();
+	__setup_vector_irq(smp_processor_id());
 	cpu_set(smp_processor_id(), cpu_online_map);
+	unlock_vector_lock();
 	ipi_call_unlock_irq();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
@@ -990,7 +994,17 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	flush_tlb_all();
 	low_mappings = 1;
 
+#ifdef CONFIG_X86_PC
+	if (def_to_bigsmp && apicid > 8) {
+		printk(KERN_WARNING
+			"More than 8 CPUs detected - skipping them.\n"
+			"Use CONFIG_X86_GENERICARCH and CONFIG_X86_BIGSMP.\n");
+		err = -1;
+	} else
+		err = do_boot_cpu(apicid, cpu);
+#else
 	err = do_boot_cpu(apicid, cpu);
+#endif
 
 	zap_low_mappings();
 	low_mappings = 0;
@@ -1336,7 +1350,9 @@ int __cpu_disable(void)
 	remove_siblinginfo(cpu);
 
 	/* It's now safe to remove this processor from the online map */
+	lock_vector_lock();
 	remove_cpu_from_maps(cpu);
+	unlock_vector_lock();
 	fixup_irqs(cpu_online_map);
 	return 0;
 }
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 0a1b1a9..6ca515d 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -37,6 +37,7 @@
 #include <asm/timer.h>
 #include <asm/vmi_time.h>
 #include <asm/kmap_types.h>
+#include <asm/setup.h>
 
 /* Convenient for calling VMI functions indirectly in the ROM */
 typedef u32 __attribute__((regparm(1))) (VROMFUNC)(void);
@@ -683,7 +684,7 @@ void vmi_bringup(void)
 {
  	/* We must establish the lowmem mapping for MMU ops to work */
 	if (vmi_ops.set_linear_mapping)
-		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, max_low_pfn, 0);
+		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, MAXMEM_PFN, 0);
 }
 
 /*
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 557b2ab..d503027 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -207,6 +207,9 @@ static void pgd_prepopulate_pmd(struct mm_struct *mm, pgd_t *pgd, pmd_t *pmds[])
 	unsigned long addr;
 	int i;
 
+	if (PREALLOCATED_PMDS == 0) /* Work around gcc-3.4.x bug */
+		return;
+
 	pud = pud_offset(pgd, 0);
 
  	for (addr = i = 0; i < PREALLOCATED_PMDS;
diff --git a/include/asm-x86/efi.h b/include/asm-x86/efi.h
index 7ed2bd7..d4f2b0a 100644
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -86,7 +86,7 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void *efi_ioremap(unsigned long addr, unsigned long size);
+extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
 
 #endif /* CONFIG_X86_32 */
 
diff --git a/include/asm-x86/hw_irq.h b/include/asm-x86/hw_irq.h
index 77ba51d..edd0b95 100644
--- a/include/asm-x86/hw_irq.h
+++ b/include/asm-x86/hw_irq.h
@@ -98,9 +98,17 @@ extern void (*const interrupt[NR_IRQS])(void);
 #else
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
-extern spinlock_t vector_lock;
 #endif
-extern void setup_vector_irq(int cpu);
+
+#if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_X86_64)
+extern void lock_vector_lock(void);
+extern void unlock_vector_lock(void);
+extern void __setup_vector_irq(int cpu);
+#else
+static inline void lock_vector_lock(void) {}
+static inline void unlock_vector_lock(void) {}
+static inline void __setup_vector_irq(int cpu) {}
+#endif
 
 #endif /* !ASSEMBLY_ */
 
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index 90b1d1f..b95d167 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -109,7 +109,15 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#if !defined(CONFIG_X86_VOYAGER)
+#ifdef CONFIG_X86_64
+# if NR_CPUS < MAX_IO_APICS
+#  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
+# else
+#  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
+# endif
+# define NR_IRQ_VECTORS NR_IRQS
+
+#elif !defined(CONFIG_X86_VOYAGER)
 
 # if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
