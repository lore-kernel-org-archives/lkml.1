Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYIFXyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYIFXyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYIFXut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:49 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59427 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235038.421559000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:47 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 11/13] genapic: reduce stack pressuge in io_apic.c step 3 target_cpus
Content-Disposition: inline; filename=stack-hogs-io_apic_c-step-3-target_cpus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Step 3 "target_cpus" of cleaning up io_apic.c modifies the TARGET_CPUS
    interface to pass a pointer to the returned mask for arch X86_64,
    removing yet another "cpumask_t variable on the stack".

	target_cpus = TARGET_CPUS;

    becomes:

	TARGET_CPUS(target_cpus);

    For x86_32 this is expanded to:

	target_cpus = (genapic->target_cpus());

    For x86_64 this is expanded to:

	target_cpus = (genapic->target_cpus)(&(target_cpus));

  * All the appropriate genapic "target_cpus" functions are modified
    to use this new interface.

  * Note that arch-i386-gcc had trouble with the name of the variables
    being "target_cpus" (conflicted with the macro TARGET_CPUS expanding
    to (target_cpus()), so they are now "tgt_cpus".

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genapic_flat_64.c        |    8 ++++----
 arch/x86/kernel/genx2apic_cluster.c      |    4 ++--
 arch/x86/kernel/genx2apic_phys.c         |    4 ++--
 arch/x86/kernel/genx2apic_uv_x.c         |    4 ++--
 arch/x86/kernel/io_apic.c                |   16 ++++++++--------
 include/asm-x86/genapic_64.h             |    2 +-
 include/asm-x86/mach-default/mach_apic.h |   28 +++++++++++++++++-----------
 include/asm-x86/mach-generic/mach_apic.h |    6 +++++-
 8 files changed, 41 insertions(+), 31 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6.tip/arch/x86/kernel/genapic_flat_64.c
@@ -31,9 +31,9 @@ static int __init flat_acpi_madt_oem_che
 	return 1;
 }
 
-static cpumask_t flat_target_cpus(void)
+static void flat_target_cpus(cpumask_t *retmask)
 {
-	return cpu_online_map;
+	*retmask = cpu_online_map;
 }
 
 static cpumask_t flat_vector_allocation_domain(int cpu)
@@ -194,9 +194,9 @@ static int __init physflat_acpi_madt_oem
 	return 0;
 }
 
-static cpumask_t physflat_target_cpus(void)
+static void physflat_target_cpus(cpumask_t *retmask)
 {
-	return cpu_online_map;
+	*retmask = cpu_online_map;
 }
 
 static cpumask_t physflat_vector_allocation_domain(int cpu)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_cluster.c
@@ -23,9 +23,9 @@ static int __init x2apic_acpi_madt_oem_c
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static void x2apic_target_cpus(cpumask_t *retmask)
 {
-	return cpumask_of_cpu(0);
+	*retmask = cpumask_of_cpu(0);
 }
 
 /*
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_phys.c
@@ -29,9 +29,9 @@ static int __init x2apic_acpi_madt_oem_c
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static void x2apic_target_cpus(cpumask_t *retmask)
 {
-	return cpumask_of_cpu(0);
+	*retmask = cpumask_of_cpu(0);
 }
 
 static cpumask_t x2apic_vector_allocation_domain(int cpu)
--- linux-2.6.tip.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6.tip/arch/x86/kernel/genx2apic_uv_x.c
@@ -77,9 +77,9 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t uv_target_cpus(void)
+static uv_target_cpus(cpumask_t *retmask)
 {
-	return cpumask_of_cpu(0);
+	*retmask = cpumask_of_cpu(0);
 }
 
 static cpumask_t uv_vector_allocation_domain(int cpu)
--- linux-2.6.tip.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6.tip/arch/x86/kernel/io_apic.c
@@ -1532,7 +1532,7 @@ static void setup_IO_APIC_irq(int apic, 
 	cfg = irq_cfg(irq);
 
 	get_cpumask_var(mask, cpumask_irq_level_3);
-	*mask = TARGET_CPUS;
+	TARGET_CPUS(*mask);
 	if (assign_irq_vector(irq, mask))
 		goto out;
 
@@ -1618,7 +1618,7 @@ static void __init setup_timer_IRQ0_pin(
 
 	memset(&entry, 0, sizeof(entry));
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_1);
-	*tgt_cpus = TARGET_CPUS;
+	TARGET_CPUS(*tgt_cpus);
 
 	/*
 	 * We use logical delivery to get the timer IRQ
@@ -2825,7 +2825,7 @@ static inline void __init check_timer(vo
 	 */
 	disable_8259A_irq(0);
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
-	*tgt_cpus = TARGET_CPUS;
+	TARGET_CPUS(*tgt_cpus);
 	assign_irq_vector(0, tgt_cpus);
 	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 
@@ -3135,7 +3135,7 @@ unsigned int create_irq_nr(unsigned int 
 
 	irq = 0;
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_2);
-	*tgt_cpus = TARGET_CPUS;
+	TARGET_CPUS(*tgt_cpus);
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new > 0; new--) {
 		if (platform_legacy_irq(new))
@@ -3197,7 +3197,7 @@ static int msi_compose_msg(struct pci_de
 	cpumask_ptr tgt_cpus;
 
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
-	*tgt_cpus = TARGET_CPUS;
+	TARGET_CPUS(*tgt_cpus);
 	err = assign_irq_vector(irq, tgt_cpus);
 	if (err)
 		return err;
@@ -3671,7 +3671,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 	cpumask_ptr tgt_cpus;
 
 	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
-	*tgt_cpus = TARGET_CPUS;
+	TARGET_CPUS(*tgt_cpus);
 	err = assign_irq_vector(irq, tgt_cpus);
 	if (!err) {
 		struct ht_irq_msg msg;
@@ -3910,12 +3910,12 @@ void __init setup_ioapic_dest(void)
 						  irq_polarity(irq_entry));
 #ifdef CONFIG_INTR_REMAP
 			else if (intr_remapping_enabled) {
-				*tgt_cpus = TARGET_CPUS;
+				TARGET_CPUS(*tgt_cpus);
 				set_ir_ioapic_affinity_irq_p(irq, tgt_cpus);
 			}
 #endif
 			else {
-				*tgt_cpus = TARGET_CPUS;
+				TARGET_CPUS(*tgt_cpus);
 				set_ioapic_affinity_irq_p(irq, tgt_cpus);
 			}
 		}
--- linux-2.6.tip.orig/include/asm-x86/genapic_64.h
+++ linux-2.6.tip/include/asm-x86/genapic_64.h
@@ -20,7 +20,7 @@ struct genapic {
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
-	cpumask_t (*target_cpus)(void);
+	void (*target_cpus)(cpumask_t *retmask);
 	cpumask_t (*vector_allocation_domain)(int cpu);
 	void (*init_apic_ldr)(void);
 	/* ipi */
--- linux-2.6.tip.orig/include/asm-x86/mach-default/mach_apic.h
+++ linux-2.6.tip/include/asm-x86/mach-default/mach_apic.h
@@ -7,24 +7,22 @@
 #include <asm/smp.h>
 
 #define APIC_DFR_VALUE	(APIC_DFR_FLAT)
+#define NO_BALANCE_IRQ (0)
+#define esr_disable (0)
 
-static inline cpumask_t target_cpus(void)
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+static inline void target_cpus(cpumask_t *retmask)
 { 
 #ifdef CONFIG_SMP
-	return cpu_online_map;
+	*retmask = cpu_online_map;
 #else
-	return cpumask_of_cpu(0);
+	*retmask = cpumask_of_cpu(0);
 #endif
 } 
-
-#define NO_BALANCE_IRQ (0)
-#define esr_disable (0)
-
-#ifdef CONFIG_X86_64
-#include <asm/genapic.h>
 #define INT_DELIVERY_MODE (genapic->int_delivery_mode)
 #define INT_DEST_MODE (genapic->int_dest_mode)
-#define TARGET_CPUS	  (genapic->target_cpus())
+#define TARGET_CPUS(retval) (genapic->target_cpus)(&(retval))
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
@@ -34,9 +32,17 @@ static inline cpumask_t target_cpus(void
 #define send_IPI_self (genapic->send_IPI_self)
 extern void setup_apic_routing(void);
 #else
+static inline cpumask_t target_cpus(void)
+{
+#ifdef CONFIG_SMP
+	return cpu_online_map;
+#else
+	return cpumask_of_cpu(0);
+#endif
+}
 #define INT_DELIVERY_MODE dest_LowestPrio
 #define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
-#define TARGET_CPUS (target_cpus())
+#define TARGET_CPUS(retval)	retval = (target_cpus())
 /*
  * Set up the logical destination ID.
  *
--- linux-2.6.tip.orig/include/asm-x86/mach-generic/mach_apic.h
+++ linux-2.6.tip/include/asm-x86/mach-generic/mach_apic.h
@@ -3,13 +3,17 @@
 
 #include <asm/genapic.h>
 
+#ifdef CONFIG_X86_64
+#define TARGET_CPUS(retval)	  (genapic->target_cpus)(&(retval))
+#else
+#define TARGET_CPUS(retval)	  retval = (genapic->target_cpus())
+#endif
 #define esr_disable (genapic->ESR_DISABLE)
 #define NO_BALANCE_IRQ (genapic->no_balance_irq)
 #define INT_DELIVERY_MODE (genapic->int_delivery_mode)
 #define INT_DEST_MODE (genapic->int_dest_mode)
 #undef APIC_DEST_LOGICAL
 #define APIC_DEST_LOGICAL (genapic->apic_destination_logical)
-#define TARGET_CPUS	  (genapic->target_cpus())
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
 #define ioapic_phys_id_map (genapic->ioapic_phys_id_map)

-- 
