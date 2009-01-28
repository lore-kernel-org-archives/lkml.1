Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbZA1XoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbZA1XoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757821AbZA1XnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:43:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:37334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbZA1XnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:43:20 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 003/114] x86, genapic: unify struct genapic
Date: Wed, 28 Jan 2009 23:41:09 +0000
Message-Id: <1233186180-29883-4-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:43:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move over the (now identical) struct genapic definitions from
genapic_32/64.h to genapic.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h    |   96 +++++++++++++++++++++++++++
 arch/x86/include/asm/genapic_32.h |   93 --------------------------
 arch/x86/include/asm/genapic_64.h |  129 ++++++-------------------------------
 3 files changed, 115 insertions(+), 203 deletions(-)
 rewrite arch/x86/include/asm/genapic_64.h (84%)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index d48bee6..3dea66a 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -1,5 +1,101 @@
+#ifndef _ASM_X86_GENAPIC_H
+#define _ASM_X86_GENAPIC_H
+
+#include <linux/cpumask.h>
+
+/*
+ * Copyright 2004 James Cleverdon, IBM.
+ * Subject to the GNU Public License, v.2
+ *
+ * Generic APIC sub-arch data struct.
+ *
+ * Hacked for x86-64 by James Cleverdon from i386 architecture code by
+ * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
+ * James Cleverdon.
+ */
+
+struct genapic {
+	char *name;
+
+	int (*probe)(void);
+	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
+	int (*apic_id_registered)(void);
+
+	u32 int_delivery_mode;
+	u32 int_dest_mode;
+
+	const struct cpumask *(*target_cpus)(void);
+
+	int ESR_DISABLE;
+
+	int apic_destination_logical;
+	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
+	unsigned long (*check_apicid_present)(int apicid);
+
+	int no_balance_irq;
+	int no_ioapic_check;
+
+	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
+	void (*init_apic_ldr)(void);
+
+	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
+
+	void (*setup_apic_routing)(void);
+	int (*multi_timer_check)(int apic, int irq);
+	int (*apicid_to_node)(int logical_apicid);
+	int (*cpu_to_logical_apicid)(int cpu);
+	int (*cpu_present_to_apicid)(int mps_cpu);
+	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
+	void (*setup_portio_remap)(void);
+	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
+	void (*enable_apic_mode)(void);
+#ifdef CONFIG_X86_32
+	u32 (*phys_pkg_id)(u32 cpuid_apic, int index_msb);
+#else
+	unsigned int (*phys_pkg_id)(int index_msb);
+#endif
+
+	/*
+	 * When one of the next two hooks returns 1 the genapic
+	 * is switched to this. Essentially they are additional
+	 * probe functions:
+	 */
+	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
+			     char *productid);
+
+	unsigned int (*get_apic_id)(unsigned long x);
+	unsigned long (*set_apic_id)(unsigned int id);
+	unsigned long apic_id_mask;
+
+	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
+	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
+					       const struct cpumask *andmask);
+
+#ifdef CONFIG_SMP
+	/* ipi */
+	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
+	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
+					 int vector);
+	void (*send_IPI_allbutself)(int vector);
+	void (*send_IPI_all)(int vector);
+	void (*send_IPI_self)(int vector);
+#endif
+	/* wakeup_secondary_cpu */
+	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
+
+	int trampoline_phys_low;
+	int trampoline_phys_high;
+	void (*wait_for_init_deassert)(atomic_t *deassert);
+	void (*smp_callin_clear_local_apic)(void);
+	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
+	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
+	void (*inquire_remote_apic)(int apicid);
+};
+
 #ifdef CONFIG_X86_32
 # include "genapic_32.h"
 #else
 # include "genapic_64.h"
 #endif
+
+#endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/genapic_32.h b/arch/x86/include/asm/genapic_32.h
index 5808b7d..a56785e 100644
--- a/arch/x86/include/asm/genapic_32.h
+++ b/arch/x86/include/asm/genapic_32.h
@@ -4,99 +4,6 @@
 #include <asm/mpspec.h>
 #include <asm/atomic.h>
 
-/*
- * Generic APIC driver interface.
- *
- * An straight forward mapping of the APIC related parts of the
- * x86 subarchitecture interface to a dynamic object.
- *
- * This is used by the "generic" x86 subarchitecture.
- *
- * Copyright 2003 Andi Kleen, SuSE Labs.
- */
-
-struct mpc_bus;
-struct mpc_table;
-struct mpc_cpu;
-
-struct genapic {
-	char *name;
-
-	int (*probe)(void);
-	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
-	int (*apic_id_registered)(void);
-
-	u32 int_delivery_mode;
-	u32 int_dest_mode;
-
-	const struct cpumask *(*target_cpus)(void);
-
-	int ESR_DISABLE;
-
-	int apic_destination_logical;
-	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
-	unsigned long (*check_apicid_present)(int apicid);
-
-	int no_balance_irq;
-	int no_ioapic_check;
-
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
-	void (*init_apic_ldr)(void);
-
-	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
-
-	void (*setup_apic_routing)(void);
-	int (*multi_timer_check)(int apic, int irq);
-	int (*apicid_to_node)(int logical_apicid);
-	int (*cpu_to_logical_apicid)(int cpu);
-	int (*cpu_present_to_apicid)(int mps_cpu);
-	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
-	void (*setup_portio_remap)(void);
-	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
-	void (*enable_apic_mode)(void);
-#ifdef CONFIG_X86_32
-	u32 (*phys_pkg_id)(u32 cpuid_apic, int index_msb);
-#else
-	unsigned int (*phys_pkg_id)(int index_msb);
-#endif
-
-	/*
-	 * When one of the next two hooks returns 1 the genapic
-	 * is switched to this. Essentially they are additional
-	 * probe functions:
-	 */
-	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
-			     char *productid);
-
-	unsigned int (*get_apic_id)(unsigned long x);
-	unsigned long (*set_apic_id)(unsigned int id);
-	unsigned long apic_id_mask;
-
-	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
-	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
-					       const struct cpumask *andmask);
-
-#ifdef CONFIG_SMP
-	/* ipi */
-	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
-	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
-					 int vector);
-	void (*send_IPI_allbutself)(int vector);
-	void (*send_IPI_all)(int vector);
-	void (*send_IPI_self)(int vector);
-#endif
-	/* wakeup_secondary_cpu */
-	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
-
-	int trampoline_phys_low;
-	int trampoline_phys_high;
-	void (*wait_for_init_deassert)(atomic_t *deassert);
-	void (*smp_callin_clear_local_apic)(void);
-	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
-	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
-	void (*inquire_remote_apic)(int apicid);
-};
-
 #define APICFUNC(x) .x = x,
 
 /* More functions could be probably marked IPIFUNC and save some space
diff --git a/arch/x86/include/asm/genapic_64.h b/arch/x86/include/asm/genapic_64.h
dissimilarity index 84%
index 0a5f712..c70ca0d 100644
--- a/arch/x86/include/asm/genapic_64.h
+++ b/arch/x86/include/asm/genapic_64.h
@@ -1,110 +1,19 @@
-#ifndef _ASM_X86_GENAPIC_64_H
-#define _ASM_X86_GENAPIC_64_H
-
-#include <linux/cpumask.h>
-
-/*
- * Copyright 2004 James Cleverdon, IBM.
- * Subject to the GNU Public License, v.2
- *
- * Generic APIC sub-arch data struct.
- *
- * Hacked for x86-64 by James Cleverdon from i386 architecture code by
- * Martin Bligh, Andi Kleen, James Bottomley, John Stultz, and
- * James Cleverdon.
- */
-
-struct genapic {
-	char *name;
-
-	int (*probe)(void);
-	int (*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
-	int (*apic_id_registered)(void);
-
-	u32 int_delivery_mode;
-	u32 int_dest_mode;
-
-	const struct cpumask *(*target_cpus)(void);
-
-	int ESR_DISABLE;
-
-	int apic_destination_logical;
-	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
-	unsigned long (*check_apicid_present)(int apicid);
-
-	int no_balance_irq;
-	int no_ioapic_check;
-
-	void (*vector_allocation_domain)(int cpu, struct cpumask *retmask);
-	void (*init_apic_ldr)(void);
-
-	physid_mask_t (*ioapic_phys_id_map)(physid_mask_t map);
-
-	void (*setup_apic_routing)(void);
-	int (*multi_timer_check)(int apic, int irq);
-	int (*apicid_to_node)(int logical_apicid);
-	int (*cpu_to_logical_apicid)(int cpu);
-	int (*cpu_present_to_apicid)(int mps_cpu);
-	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
-	void (*setup_portio_remap)(void);
-	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
-	void (*enable_apic_mode)(void);
-#ifdef CONFIG_X86_32
-	u32 (*phys_pkg_id)(u32 cpuid_apic, int index_msb);
-#else
-	unsigned int (*phys_pkg_id)(int index_msb);
-#endif
-
-	/*
-	 * When one of the next two hooks returns 1 the genapic
-	 * is switched to this. Essentially they are additional
-	 * probe functions:
-	 */
-	int (*mps_oem_check)(struct mpc_table *mpc, char *oem,
-			     char *productid);
-
-	unsigned int (*get_apic_id)(unsigned long x);
-	unsigned long (*set_apic_id)(unsigned int id);
-	unsigned long apic_id_mask;
-
-	unsigned int (*cpu_mask_to_apicid)(const struct cpumask *cpumask);
-	unsigned int (*cpu_mask_to_apicid_and)(const struct cpumask *cpumask,
-					       const struct cpumask *andmask);
-
-#ifdef CONFIG_SMP
-	/* ipi */
-	void (*send_IPI_mask)(const struct cpumask *mask, int vector);
-	void (*send_IPI_mask_allbutself)(const struct cpumask *mask,
-					 int vector);
-	void (*send_IPI_allbutself)(int vector);
-	void (*send_IPI_all)(int vector);
-	void (*send_IPI_self)(int vector);
-#endif
-	/* wakeup_secondary_cpu */
-	int (*wakeup_cpu)(int apicid, unsigned long start_eip);
-
-	int trampoline_phys_low;
-	int trampoline_phys_high;
-	void (*wait_for_init_deassert)(atomic_t *deassert);
-	void (*smp_callin_clear_local_apic)(void);
-	void (*store_NMI_vector)(unsigned short *high, unsigned short *low);
-	void (*restore_NMI_vector)(unsigned short *high, unsigned short *low);
-	void (*inquire_remote_apic)(int apicid);
-};
-
-extern struct genapic *genapic;
-
-extern struct genapic apic_flat;
-extern struct genapic apic_physflat;
-extern struct genapic apic_x2apic_cluster;
-extern struct genapic apic_x2apic_phys;
-extern int acpi_madt_oem_check(char *, char *);
-
-extern void apic_send_IPI_self(int vector);
-
-extern struct genapic apic_x2apic_uv_x;
-DECLARE_PER_CPU(int, x2apic_extra_bits);
-
-extern void setup_apic_routing(void);
-
-#endif /* _ASM_X86_GENAPIC_64_H */
+#ifndef _ASM_X86_GENAPIC_64_H
+#define _ASM_X86_GENAPIC_64_H
+
+extern struct genapic *genapic;
+
+extern struct genapic apic_flat;
+extern struct genapic apic_physflat;
+extern struct genapic apic_x2apic_cluster;
+extern struct genapic apic_x2apic_phys;
+extern int acpi_madt_oem_check(char *, char *);
+
+extern void apic_send_IPI_self(int vector);
+
+extern struct genapic apic_x2apic_uv_x;
+DECLARE_PER_CPU(int, x2apic_extra_bits);
+
+extern void setup_apic_routing(void);
+
+#endif /* _ASM_X86_GENAPIC_64_H */
-- 
1.6.0.2

