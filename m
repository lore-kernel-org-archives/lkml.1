Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbZA2ALl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbZA2ALl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758695AbZA1Xp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:45:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:53134 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758674AbZA1Xpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:54 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 067/114] x86, ES7000: consolidate the APIC code
Date: Wed, 28 Jan 2009 23:42:13 +0000
Message-Id: <1233186180-29883-68-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all the ES7000 APIC code into arch/x86/mach-generic/es7000.c.

With this ES7000 ceases to rely on any subarchitecture include files.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/es7000/apic.h    |  236 -------------------------
 arch/x86/include/asm/es7000/apicdef.h |    9 -
 arch/x86/include/asm/es7000/ipi.h     |   22 ---
 arch/x86/include/asm/es7000/mpparse.h |   23 ---
 arch/x86/include/asm/es7000/wakecpu.h |   16 --
 arch/x86/mach-generic/es7000.c        |  314 +++++++++++++++++++++++++++++++--
 6 files changed, 295 insertions(+), 325 deletions(-)
 delete mode 100644 arch/x86/include/asm/es7000/apic.h
 delete mode 100644 arch/x86/include/asm/es7000/apicdef.h
 delete mode 100644 arch/x86/include/asm/es7000/ipi.h
 delete mode 100644 arch/x86/include/asm/es7000/mpparse.h
 delete mode 100644 arch/x86/include/asm/es7000/wakecpu.h

diff --git a/arch/x86/include/asm/es7000/apic.h b/arch/x86/include/asm/es7000/apic.h
deleted file mode 100644
index b89b45d..0000000
--- a/arch/x86/include/asm/es7000/apic.h
+++ /dev/null
@@ -1,236 +0,0 @@
-#ifndef __ASM_ES7000_APIC_H
-#define __ASM_ES7000_APIC_H
-
-#include <linux/gfp.h>
-
-#define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
-
-static inline int es7000_apic_id_registered(void)
-{
-	        return 1;
-}
-
-static inline const cpumask_t *target_cpus_cluster(void)
-{
-	return &CPU_MASK_ALL;
-}
-
-static inline const cpumask_t *es7000_target_cpus(void)
-{
-	return &cpumask_of_cpu(smp_processor_id());
-}
-
-#define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
-#define INT_DELIVERY_MODE_CLUSTER	(dest_LowestPrio)
-#define INT_DEST_MODE_CLUSTER		(1) /* logical delivery broadcast to all procs */
-
-#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-
-static inline unsigned long
-es7000_check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return 0;
-}
-static inline unsigned long es7000_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
-extern void es7000_enable_apic_mode(void);
-
-#define apicid_cluster(apicid) (apicid & 0xF0)
-
-static inline unsigned long calculate_ldr(int cpu)
-{
-	unsigned long id;
-	id = xapic_phys_to_log_apicid(cpu);
-	return (SET_APIC_LOGICAL_ID(id));
-}
-
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LdR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static inline void es7000_init_apic_ldr_cluster(void)
-{
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE_CLUSTER);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
-}
-
-static inline void es7000_init_apic_ldr(void)
-{
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
-}
-
-extern int apic_version [MAX_APICS];
-static inline void es7000_setup_apic_routing(void)
-{
-	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
-	printk("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
-		(apic_version[apic] == 0x14) ?
-			"Physical Cluster" : "Logical Cluster",
-			nr_ioapics, cpus_addr(*es7000_target_cpus())[0]);
-}
-
-static inline int es7000_apicid_to_node(int logical_apicid)
-{
-	return 0;
-}
-
-
-static inline int es7000_cpu_present_to_apicid(int mps_cpu)
-{
-	if (!mps_cpu)
-		return boot_cpu_physical_apicid;
-	else if (mps_cpu < nr_cpu_ids)
-		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
-	else
-		return BAD_APICID;
-}
-
-static inline physid_mask_t es7000_apicid_to_cpu_present(int phys_apicid)
-{
-	static int id = 0;
-	physid_mask_t mask;
-	mask = physid_mask_of_physid(id);
-	++id;
-	return mask;
-}
-
-extern u8 cpu_2_logical_apicid[];
-/* Mapping from cpu number to logical apicid */
-static inline int es7000_cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return (int)cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
-static inline physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xff);
-}
-
-extern unsigned int boot_cpu_physical_apicid;
-
-static inline int es7000_check_phys_apicid_present(int cpu_physical_apicid)
-{
-	boot_cpu_physical_apicid = read_apic_id();
-	return (1);
-}
-
-static inline unsigned int
-es7000_cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
-{
-	int cpus_found = 0;
-	int num_bits_set;
-	int apicid;
-	int cpu;
-
-	num_bits_set = cpumask_weight(cpumask);
-	/* Return id to all */
-	if (num_bits_set == nr_cpu_ids)
-		return 0xFF;
-	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of target_cpus():
-	 */
-	cpu = cpumask_first(cpumask);
-	apicid = es7000_cpu_to_logical_apicid(cpu);
-
-	while (cpus_found < num_bits_set) {
-		if (cpumask_test_cpu(cpu, cpumask)) {
-			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
-
-			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)) {
-				printk ("%s: Not a valid mask!\n", __func__);
-
-				return 0xFF;
-			}
-			apicid = new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-	return apicid;
-}
-
-static inline unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
-{
-	int cpus_found = 0;
-	int num_bits_set;
-	int apicid;
-	int cpu;
-
-	num_bits_set = cpus_weight(*cpumask);
-	/* Return id to all */
-	if (num_bits_set == nr_cpu_ids)
-		return es7000_cpu_to_logical_apicid(0);
-	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of target_cpus():
-	 */
-	cpu = first_cpu(*cpumask);
-	apicid = es7000_cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask)) {
-			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
-
-			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)) {
-				printk ("%s: Not a valid mask!\n", __func__);
-
-				return es7000_cpu_to_logical_apicid(0);
-			}
-			apicid = new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-	return apicid;
-}
-
-
-static inline unsigned int
-es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
-			      const struct cpumask *andmask)
-{
-	int apicid = es7000_cpu_to_logical_apicid(0);
-	cpumask_var_t cpumask;
-
-	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
-		return apicid;
-
-	cpumask_and(cpumask, inmask, andmask);
-	cpumask_and(cpumask, cpumask, cpu_online_mask);
-	apicid = es7000_cpu_mask_to_apicid(cpumask);
-
-	free_cpumask_var(cpumask);
-
-	return apicid;
-}
-
-static inline int es7000_phys_pkg_id(int cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_ES7000_APIC_H */
diff --git a/arch/x86/include/asm/es7000/apicdef.h b/arch/x86/include/asm/es7000/apicdef.h
deleted file mode 100644
index c74881a..0000000
--- a/arch/x86/include/asm/es7000/apicdef.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_ES7000_APICDEF_H
-#define __ASM_ES7000_APICDEF_H
-
-static inline unsigned int es7000_get_apic_id(unsigned long x)
-{
-	return (x >> 24) & 0xFF;
-}
-
-#endif
diff --git a/arch/x86/include/asm/es7000/ipi.h b/arch/x86/include/asm/es7000/ipi.h
deleted file mode 100644
index 81e77c8..0000000
--- a/arch/x86/include/asm/es7000/ipi.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __ASM_ES7000_IPI_H
-#define __ASM_ES7000_IPI_H
-
-void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
-static inline void es7000_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void es7000_send_IPI_allbutself(int vector)
-{
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
-}
-
-static inline void es7000_send_IPI_all(int vector)
-{
-	es7000_send_IPI_mask(cpu_online_mask, vector);
-}
-
-#endif /* __ASM_ES7000_IPI_H */
diff --git a/arch/x86/include/asm/es7000/mpparse.h b/arch/x86/include/asm/es7000/mpparse.h
deleted file mode 100644
index 662eb1e..0000000
--- a/arch/x86/include/asm/es7000/mpparse.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef __ASM_ES7000_MPPARSE_H
-#define __ASM_ES7000_MPPARSE_H
-
-#include <linux/acpi.h>
-
-extern int parse_unisys_oem (char *oemptr);
-extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
-extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
-extern void setup_unisys(void);
-
-#ifdef CONFIG_ACPI
-static inline int es7000_check_dsdt(void)
-{
-	struct acpi_table_header header;
-
-	if (ACPI_SUCCESS(acpi_get_table_header(ACPI_SIG_DSDT, 0, &header)) &&
-	    !strncmp(header.oem_id, "UNISYS", 6))
-		return 1;
-	return 0;
-}
-#endif
-
-#endif /* __ASM_MACH_MPPARSE_H */
diff --git a/arch/x86/include/asm/es7000/wakecpu.h b/arch/x86/include/asm/es7000/wakecpu.h
deleted file mode 100644
index 99c72be..0000000
--- a/arch/x86/include/asm/es7000/wakecpu.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef __ASM_ES7000_WAKECPU_H
-#define __ASM_ES7000_WAKECPU_H
-
-#define ES7000_TRAMPOLINE_PHYS_LOW	0x467
-#define ES7000_TRAMPOLINE_PHYS_HIGH	0x469
-
-static inline void es7000_wait_for_init_deassert(atomic_t *deassert)
-{
-#ifndef CONFIG_ES7000_CLUSTERED_APIC
-	while (!atomic_read(deassert))
-		cpu_relax();
-#endif
-	return;
-}
-
-#endif /* __ASM_MACH_WAKECPU_H */
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index be090b2..8b6113e 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -11,13 +11,300 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/es7000/apicdef.h>
+#include <linux/acpi.h>
 #include <linux/smp.h>
-#include <asm/es7000/apic.h>
-#include <asm/es7000/ipi.h>
-#include <asm/es7000/mpparse.h>
+#include <asm/ipi.h>
 #include <asm/mach-default/mach_wakecpu.h>
 
+#define APIC_DFR_VALUE_CLUSTER		(APIC_DFR_CLUSTER)
+#define INT_DELIVERY_MODE_CLUSTER	(dest_LowestPrio)
+#define INT_DEST_MODE_CLUSTER		(1) /* logical delivery broadcast to all procs */
+
+#define APIC_DFR_VALUE			(APIC_DFR_FLAT)
+
+extern void es7000_enable_apic_mode(void);
+extern int apic_version [MAX_APICS];
+extern u8 cpu_2_logical_apicid[];
+extern unsigned int boot_cpu_physical_apicid;
+
+extern int parse_unisys_oem (char *oemptr);
+extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void unmap_unisys_acpi_oem_table(unsigned long oem_addr);
+extern void setup_unisys(void);
+
+#define apicid_cluster(apicid)		(apicid & 0xF0)
+#define xapic_phys_to_log_apicid(cpu)	per_cpu(x86_bios_cpu_apicid, cpu)
+
+static void es7000_vector_allocation_domain(int cpu, cpumask_t *retmask)
+{
+	/* Careful. Some cpus do not strictly honor the set of cpus
+	 * specified in the interrupt destination when using lowest
+	 * priority interrupt delivery mode.
+	 *
+	 * In particular there was a hyperthreading cpu observed to
+	 * deliver interrupts to the wrong hyperthread when only one
+	 * hyperthread was specified in the interrupt desitination.
+	 */
+	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
+}
+
+
+static void es7000_wait_for_init_deassert(atomic_t *deassert)
+{
+#ifndef CONFIG_ES7000_CLUSTERED_APIC
+	while (!atomic_read(deassert))
+		cpu_relax();
+#endif
+	return;
+}
+
+static unsigned int es7000_get_apic_id(unsigned long x)
+{
+	return (x >> 24) & 0xFF;
+}
+
+#ifdef CONFIG_ACPI
+static int es7000_check_dsdt(void)
+{
+	struct acpi_table_header header;
+
+	if (ACPI_SUCCESS(acpi_get_table_header(ACPI_SIG_DSDT, 0, &header)) &&
+	    !strncmp(header.oem_id, "UNISYS", 6))
+		return 1;
+	return 0;
+}
+#endif
+
+static void es7000_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static void es7000_send_IPI_allbutself(int vector)
+{
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+static void es7000_send_IPI_all(int vector)
+{
+	es7000_send_IPI_mask(cpu_online_mask, vector);
+}
+
+static int es7000_apic_id_registered(void)
+{
+	        return 1;
+}
+
+static const cpumask_t *target_cpus_cluster(void)
+{
+	return &CPU_MASK_ALL;
+}
+
+static const cpumask_t *es7000_target_cpus(void)
+{
+	return &cpumask_of_cpu(smp_processor_id());
+}
+
+static unsigned long
+es7000_check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return 0;
+}
+static unsigned long es7000_check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+static unsigned long calculate_ldr(int cpu)
+{
+	unsigned long id = xapic_phys_to_log_apicid(cpu);
+
+	return (SET_APIC_LOGICAL_ID(id));
+}
+
+/*
+ * Set up the logical destination ID.
+ *
+ * Intel recommends to set DFR, LdR and TPR before enabling
+ * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
+ * document number 292116).  So here it goes...
+ */
+static void es7000_init_apic_ldr_cluster(void)
+{
+	unsigned long val;
+	int cpu = smp_processor_id();
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE_CLUSTER);
+	val = calculate_ldr(cpu);
+	apic_write(APIC_LDR, val);
+}
+
+static void es7000_init_apic_ldr(void)
+{
+	unsigned long val;
+	int cpu = smp_processor_id();
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = calculate_ldr(cpu);
+	apic_write(APIC_LDR, val);
+}
+
+static void es7000_setup_apic_routing(void)
+{
+	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
+	printk("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
+		(apic_version[apic] == 0x14) ?
+			"Physical Cluster" : "Logical Cluster",
+			nr_ioapics, cpus_addr(*es7000_target_cpus())[0]);
+}
+
+static int es7000_apicid_to_node(int logical_apicid)
+{
+	return 0;
+}
+
+
+static int es7000_cpu_present_to_apicid(int mps_cpu)
+{
+	if (!mps_cpu)
+		return boot_cpu_physical_apicid;
+	else if (mps_cpu < nr_cpu_ids)
+		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
+	else
+		return BAD_APICID;
+}
+
+static physid_mask_t es7000_apicid_to_cpu_present(int phys_apicid)
+{
+	static int id = 0;
+	physid_mask_t mask;
+
+	mask = physid_mask_of_physid(id);
+	++id;
+
+	return mask;
+}
+
+/* Mapping from cpu number to logical apicid */
+static int es7000_cpu_to_logical_apicid(int cpu)
+{
+#ifdef CONFIG_SMP
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
+	return (int)cpu_2_logical_apicid[cpu];
+#else
+	return logical_smp_processor_id();
+#endif
+}
+
+static physid_mask_t es7000_ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	/* For clustered we don't have a good way to do this yet - hack */
+	return physids_promote(0xff);
+}
+
+static int es7000_check_phys_apicid_present(int cpu_physical_apicid)
+{
+	boot_cpu_physical_apicid = read_apic_id();
+	return (1);
+}
+
+static unsigned int
+es7000_cpu_mask_to_apicid_cluster(const struct cpumask *cpumask)
+{
+	int cpus_found = 0;
+	int num_bits_set;
+	int apicid;
+	int cpu;
+
+	num_bits_set = cpumask_weight(cpumask);
+	/* Return id to all */
+	if (num_bits_set == nr_cpu_ids)
+		return 0xFF;
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of target_cpus():
+	 */
+	cpu = cpumask_first(cpumask);
+	apicid = es7000_cpu_to_logical_apicid(cpu);
+
+	while (cpus_found < num_bits_set) {
+		if (cpumask_test_cpu(cpu, cpumask)) {
+			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)) {
+				printk ("%s: Not a valid mask!\n", __func__);
+
+				return 0xFF;
+			}
+			apicid = new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+static unsigned int es7000_cpu_mask_to_apicid(const cpumask_t *cpumask)
+{
+	int cpus_found = 0;
+	int num_bits_set;
+	int apicid;
+	int cpu;
+
+	num_bits_set = cpus_weight(*cpumask);
+	/* Return id to all */
+	if (num_bits_set == nr_cpu_ids)
+		return es7000_cpu_to_logical_apicid(0);
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of target_cpus():
+	 */
+	cpu = first_cpu(*cpumask);
+	apicid = es7000_cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, *cpumask)) {
+			int new_apicid = es7000_cpu_to_logical_apicid(cpu);
+
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)) {
+				printk ("%s: Not a valid mask!\n", __func__);
+
+				return es7000_cpu_to_logical_apicid(0);
+			}
+			apicid = new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+static unsigned int
+es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
+			      const struct cpumask *andmask)
+{
+	int apicid = es7000_cpu_to_logical_apicid(0);
+	cpumask_var_t cpumask;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
+		return apicid;
+
+	cpumask_and(cpumask, inmask, andmask);
+	cpumask_and(cpumask, cpumask, cpu_online_mask);
+	apicid = es7000_cpu_mask_to_apicid(cpumask);
+
+	free_cpumask_var(cpumask);
+
+	return apicid;
+}
+
+static int es7000_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
 void __init es7000_update_genapic_to_cluster(void)
 {
 	apic->target_cpus = target_cpus_cluster;
@@ -80,18 +367,6 @@ static int __init es7000_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 }
 #endif
 
-static void es7000_vector_allocation_domain(int cpu, cpumask_t *retmask)
-{
-	/* Careful. Some cpus do not strictly honor the set of cpus
-	 * specified in the interrupt destination when using lowest
-	 * priority interrupt delivery mode.
-	 *
-	 * In particular there was a hyperthreading cpu observed to
-	 * deliver interrupts to the wrong hyperthread when only one
-	 * hyperthread was specified in the interrupt desitination.
-	 */
-	*retmask = (cpumask_t){ { [0] = APIC_ALL_CPUS, } };
-}
 
 struct genapic apic_es7000 = {
 
@@ -140,10 +415,11 @@ struct genapic apic_es7000 = {
 	.send_IPI_self			= NULL,
 
 	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
+	.trampoline_phys_low		= 0x467,
+	.trampoline_phys_high		= 0x469,
+
+	.wait_for_init_deassert		= es7000_wait_for_init_deassert,
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
-- 
1.6.0.2

