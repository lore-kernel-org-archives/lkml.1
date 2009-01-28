Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbZA2ANY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbZA2ANY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbZA1XqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:53172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758348AbZA1XqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:04 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 075/114] x86: remove mach_apic.h
Date: Wed, 28 Jan 2009 23:42:21 +0000
Message-Id: <1233186180-29883-76-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spread mach_apic.h definitions into genapic.h. (with some knock-on effects
on smp.h and apic.h.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h                   |    2 +-
 arch/x86/include/asm/genapic.h                |  139 ++++++++++++++++++++++++
 arch/x86/include/asm/mach-default/mach_apic.h |  144 -------------------------
 arch/x86/include/asm/mach-generic/mach_apic.h |    8 --
 arch/x86/include/asm/smp.h                    |   19 ----
 arch/x86/kernel/acpi/boot.c                   |   14 +---
 arch/x86/kernel/apic.c                        |   22 ++++-
 arch/x86/kernel/cpu/addon_cpuid_features.c    |    2 +-
 arch/x86/kernel/cpu/amd.c                     |    2 +-
 arch/x86/kernel/cpu/common.c                  |    2 +-
 arch/x86/kernel/cpu/intel.c                   |    2 +-
 arch/x86/kernel/io_apic.c                     |    2 +-
 arch/x86/kernel/ipi.c                         |    2 +-
 arch/x86/kernel/irq_32.c                      |    2 +-
 arch/x86/kernel/mpparse.c                     |    3 +-
 arch/x86/kernel/setup.c                       |    2 +-
 arch/x86/kernel/smp.c                         |    2 +-
 arch/x86/kernel/smpboot.c                     |    2 +-
 arch/x86/kernel/tlb_uv.c                      |    2 +-
 arch/x86/kernel/visws_quirks.c                |    2 +-
 arch/x86/mach-generic/default.c               |    2 +-
 arch/x86/mach-generic/probe.c                 |    5 -
 22 files changed, 175 insertions(+), 207 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-default/mach_apic.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_apic.h

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3a32020..6a77068 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -215,7 +215,7 @@ static inline void disable_local_APIC(void) { }
 #define	SET_APIC_ID(x)		(apic->set_apic_id(x))
 #else
 
-static inline unsigned default_get_apic_id(unsigned long x) 
+static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
 
diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 1772dad..ce3655a 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -120,4 +120,143 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
+extern void generic_bigsmp_probe(void);
+
+
+#ifdef CONFIG_X86_LOCAL_APIC
+
+#include <asm/smp.h>
+
+#define APIC_DFR_VALUE	(APIC_DFR_FLAT)
+
+static inline const struct cpumask *default_target_cpus(void)
+{
+#ifdef CONFIG_SMP
+	return cpu_online_mask;
+#else
+	return cpumask_of(0);
+#endif
+}
+
+DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
+
+
+static inline unsigned int read_apic_id(void)
+{
+	unsigned int reg;
+
+	reg = *(u32 *)(APIC_BASE + APIC_ID);
+
+	return apic->get_apic_id(reg);
+}
+
+#ifdef CONFIG_X86_64
+extern void default_setup_apic_routing(void);
+#else
+
+/*
+ * Set up the logical destination ID.
+ *
+ * Intel recommends to set DFR, LDR and TPR before enabling
+ * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
+ * document number 292116).  So here it goes...
+ */
+extern void default_init_apic_ldr(void);
+
+static inline int default_apic_id_registered(void)
+{
+	return physid_isset(read_apic_id(), phys_cpu_present_map);
+}
+
+static inline unsigned int
+default_cpu_mask_to_apicid(const struct cpumask *cpumask)
+{
+	return cpumask_bits(cpumask)[0];
+}
+
+static inline unsigned int
+default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			       const struct cpumask *andmask)
+{
+	unsigned long mask1 = cpumask_bits(cpumask)[0];
+	unsigned long mask2 = cpumask_bits(andmask)[0];
+	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
+
+	return (unsigned int)(mask1 & mask2 & mask3);
+}
+
+static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
+static inline void default_setup_apic_routing(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
+					"Flat", nr_ioapics);
+#endif
+}
+
+extern int default_apicid_to_node(int logical_apicid);
+
+#endif
+
+static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return physid_isset(apicid, bitmap);
+}
+
+static inline unsigned long default_check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	return phys_map;
+}
+
+/* Mapping from cpu number to logical apicid */
+static inline int default_cpu_to_logical_apicid(int cpu)
+{
+	return 1 << cpu;
+}
+
+static inline int __default_cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
+		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
+	else
+		return BAD_APICID;
+}
+
+static inline int
+__default_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
+}
+
+#ifdef CONFIG_X86_32
+static inline int default_cpu_present_to_apicid(int mps_cpu)
+{
+	return __default_cpu_present_to_apicid(mps_cpu);
+}
+
+static inline int
+default_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return __default_check_phys_apicid_present(boot_cpu_physical_apicid);
+}
+#else
+extern int default_cpu_present_to_apicid(int mps_cpu);
+extern int default_check_phys_apicid_present(int boot_cpu_physical_apicid);
+#endif
+
+static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
+{
+	return physid_mask_of_physid(phys_apicid);
+}
+
+#endif /* CONFIG_X86_LOCAL_APIC */
 #endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/mach-default/mach_apic.h b/arch/x86/include/asm/mach-default/mach_apic.h
deleted file mode 100644
index bae053c..0000000
--- a/arch/x86/include/asm/mach-default/mach_apic.h
+++ /dev/null
@@ -1,144 +0,0 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_APIC_H
-#define _ASM_X86_MACH_DEFAULT_MACH_APIC_H
-
-#ifdef CONFIG_X86_LOCAL_APIC
-
-#include <asm/smp.h>
-
-#define APIC_DFR_VALUE	(APIC_DFR_FLAT)
-
-static inline const struct cpumask *default_target_cpus(void)
-{ 
-#ifdef CONFIG_SMP
-	return cpu_online_mask;
-#else
-	return cpumask_of(0);
-#endif
-} 
-
-#ifdef CONFIG_X86_64
-#include <asm/genapic.h>
-#define read_apic_id()  (apic->get_apic_id(apic_read(APIC_ID)))
-extern void default_setup_apic_routing(void);
-#else
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static inline void default_init_apic_ldr(void)
-{
-	unsigned long val;
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
-	apic_write(APIC_LDR, val);
-}
-
-static inline int default_apic_id_registered(void)
-{
-	return physid_isset(read_apic_id(), phys_cpu_present_map);
-}
-
-static inline unsigned int
-default_cpu_mask_to_apicid(const struct cpumask *cpumask)
-{
-	return cpumask_bits(cpumask)[0];
-}
-
-static inline unsigned int
-default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			       const struct cpumask *andmask)
-{
-	unsigned long mask1 = cpumask_bits(cpumask)[0];
-	unsigned long mask2 = cpumask_bits(andmask)[0];
-	unsigned long mask3 = cpumask_bits(cpu_online_mask)[0];
-
-	return (unsigned int)(mask1 & mask2 & mask3);
-}
-
-static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-static inline void default_setup_apic_routing(void)
-{
-#ifdef CONFIG_X86_IO_APIC
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
-					"Flat", nr_ioapics);
-#endif
-}
-
-static inline int default_apicid_to_node(int logical_apicid)
-{
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
-#else
-	return 0;
-#endif
-}
-
-#endif
-
-static inline unsigned long default_check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return physid_isset(apicid, bitmap);
-}
-
-static inline unsigned long default_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
-static inline physid_mask_t default_ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	return phys_map;
-}
-
-/* Mapping from cpu number to logical apicid */
-static inline int default_cpu_to_logical_apicid(int cpu)
-{
-	return 1 << cpu;
-}
-
-static inline int __default_cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
-		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
-	else
-		return BAD_APICID;
-}
-
-static inline int
-__default_check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
-}
-
-#ifdef CONFIG_X86_32
-static inline int default_cpu_present_to_apicid(int mps_cpu)
-{
-	return __default_cpu_present_to_apicid(mps_cpu);
-}
-
-static inline int
-default_check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return __default_check_phys_apicid_present(boot_cpu_physical_apicid);
-}
-#else
-extern int default_cpu_present_to_apicid(int mps_cpu);
-extern int default_check_phys_apicid_present(int boot_cpu_physical_apicid);
-#endif
-
-static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
-{
-	return physid_mask_of_physid(phys_apicid);
-}
-
-#endif /* CONFIG_X86_LOCAL_APIC */
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_APIC_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_apic.h b/arch/x86/include/asm/mach-generic/mach_apic.h
deleted file mode 100644
index 96f217f..0000000
--- a/arch/x86/include/asm/mach-generic/mach_apic.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_APIC_H
-#define _ASM_X86_MACH_GENERIC_MACH_APIC_H
-
-#include <asm/genapic.h>
-
-extern void generic_bigsmp_probe(void);
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index d4ac4de..47d0e21 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -173,8 +173,6 @@ extern int safe_smp_processor_id(void);
 
 #endif
 
-#include <asm/genapic.h>
-
 #ifdef CONFIG_X86_LOCAL_APIC
 
 #ifndef CONFIG_X86_64
@@ -184,26 +182,9 @@ static inline int logical_smp_processor_id(void)
 	return GET_APIC_LOGICAL_ID(*(u32 *)(APIC_BASE + APIC_LDR));
 }
 
-static inline unsigned int read_apic_id(void)
-{
-	unsigned int reg;
-
-	reg = *(u32 *)(APIC_BASE + APIC_ID);
-
-	return apic->get_apic_id(reg);
-}
 #endif
 
-
-# if defined(APIC_DEFINITION) || defined(CONFIG_X86_64)
 extern int hard_smp_processor_id(void);
-# else
-static inline int hard_smp_processor_id(void)
-{
-	/* we don't want to mark this access volatile - bad code generation */
-	return read_apic_id();
-}
-# endif /* APIC_DEFINITION */
 
 #else /* CONFIG_X86_LOCAL_APIC */
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 7b02a1c..cb8b527 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -42,10 +42,6 @@
 #include <asm/mpspec.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_X86_LOCAL_APIC
-# include <mach_apic.h>
-#endif
-
 static int __initdata acpi_force = 0;
 u32 acpi_rsdt_forced;
 #ifdef	CONFIG_ACPI
@@ -56,15 +52,7 @@ int acpi_disabled = 1;
 EXPORT_SYMBOL(acpi_disabled);
 
 #ifdef	CONFIG_X86_64
-
-#include <asm/proto.h>
-
-#else				/* X86 */
-
-#ifdef	CONFIG_X86_LOCAL_APIC
-#include <mach_apic.h>
-#endif				/* CONFIG_X86_LOCAL_APIC */
-
+# include <asm/proto.h>
 #endif				/* X86 */
 
 #define BAD_MADT_ENTRY(entry, end) (					    \
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index e622080..41a0ba3 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -49,7 +49,6 @@
 #include <asm/i8259.h>
 #include <asm/smp.h>
 
-#include <mach_apic.h>
 #include <mach_ipi.h>
 
 /*
@@ -1910,11 +1909,30 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	set_cpu_present(cpu, true);
 }
 
-#ifdef CONFIG_X86_64
 int hard_smp_processor_id(void)
 {
 	return read_apic_id();
 }
+
+void default_init_apic_ldr(void)
+{
+	unsigned long val;
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
+	apic_write(APIC_LDR, val);
+}
+
+#ifdef CONFIG_X86_32
+int default_apicid_to_node(int logical_apicid)
+{
+#ifdef CONFIG_SMP
+	return apicid_2_node[hard_smp_processor_id()];
+#else
+	return 0;
+#endif
+}
 #endif
 
 /*
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index e8bb892..4a48bb4 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -7,7 +7,7 @@
 #include <asm/pat.h>
 #include <asm/processor.h>
 
-#include <mach_apic.h>
+#include <asm/genapic.h>
 
 struct cpuid_bit {
 	u16 feature;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c878f6..ff4d7b9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -12,7 +12,7 @@
 # include <asm/cacheflush.h>
 #endif
 
-#include <mach_apic.h>
+#include <asm/genapic.h>
 
 #include "cpu.h"
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 055b9c3..c4bdc7f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -26,7 +26,7 @@
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
-#include <mach_apic.h>
+#include <asm/genapic.h>
 #include <asm/genapic.h>
 #include <asm/uv/uv.h>
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5deefae..1cef0aa 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -24,7 +24,7 @@
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
-#include <mach_apic.h>
+#include <asm/genapic.h>
 #endif
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index abae819..e0744ea 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -63,7 +63,7 @@
 #include <asm/uv/uv_irq.h>
 
 #include <mach_ipi.h>
-#include <mach_apic.h>
+#include <asm/genapic.h>
 
 #define __apicdebuginit(type) static type __init
 
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index e16c41b..50076d9 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -19,7 +19,7 @@
 #include <asm/proto.h>
 
 #ifdef CONFIG_X86_32
-#include <mach_apic.h>
+#include <asm/genapic.h>
 #include <mach_ipi.h>
 
 /*
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index e0f29be..d802c84 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -231,7 +231,7 @@ unsigned int do_IRQ(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-#include <mach_apic.h>
+#include <asm/genapic.h>
 
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a1452a5..94fe710 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -29,8 +29,7 @@
 #include <asm/setup.h>
 #include <asm/smp.h>
 
-#include <mach_apic.h>
-
+#include <asm/genapic.h>
 /*
  * Checksum an MP configuration block.
  */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6b27f6d..92e4293 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -97,7 +97,7 @@
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 
-#include <mach_apic.h>
+#include <asm/genapic.h>
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index c48ba6c..892e7c3 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -27,7 +27,7 @@
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <mach_ipi.h>
-#include <mach_apic.h>
+#include <asm/genapic.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3fed177..489fde9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -65,7 +65,7 @@
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
-#include <mach_apic.h>
+#include <asm/genapic.h>
 #include <smpboot_hooks.h>
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 89fce1b..755ede0 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -20,7 +20,7 @@
 #include <asm/tsc.h>
 #include <asm/irq_vectors.h>
 
-#include <mach_apic.h>
+#include <asm/genapic.h>
 
 static struct bau_control	**uv_bau_table_bases __read_mostly;
 static int			uv_bau_retry_limit __read_mostly;
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 2ed5bdf..3bd7f47 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -34,7 +34,7 @@
 
 #include <mach_ipi.h>
 
-#include "mach_apic.h"
+#include <asm/genapic.h>
 
 #include <linux/kernel_stat.h>
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 07817b2..7d5123e 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -12,7 +12,7 @@
 #include <linux/string.h>
 #include <linux/smp.h>
 #include <linux/init.h>
-#include <asm/mach-default/mach_apic.h>
+#include <asm/genapic.h>
 #include <asm/mach-default/mach_ipi.h>
 
 static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index ab68c6e..c03c722 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -154,8 +154,3 @@ int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	}
 	return 0;
 }
-
-int hard_smp_processor_id(void)
-{
-	return apic->get_apic_id(*(unsigned long *)(APIC_BASE+APIC_ID));
-}
-- 
1.6.0.2

