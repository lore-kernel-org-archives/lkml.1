Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbZA2AMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbZA2AMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbZA1XqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:53156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572AbZA1Xp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:45:59 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 073/114] x86, numaq: consolidate code
Date: Wed, 28 Jan 2009 23:42:19 +0000
Message-Id: <1233186180-29883-74-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the NUMAQ subarch definitions into numaq.c. With this it
ceases to depend on build-time subarch features.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/numaq/apic.h    |  122 ------------------------
 arch/x86/include/asm/numaq/apicdef.h |    9 --
 arch/x86/include/asm/numaq/ipi.h     |   22 -----
 arch/x86/include/asm/numaq/mpparse.h |    6 -
 arch/x86/include/asm/numaq/wakecpu.h |   28 ------
 arch/x86/mach-generic/numaq.c        |  171 +++++++++++++++++++++++++++++++++-
 arch/x86/pci/numaq_32.c              |    2 +-
 7 files changed, 167 insertions(+), 193 deletions(-)
 delete mode 100644 arch/x86/include/asm/numaq/apic.h
 delete mode 100644 arch/x86/include/asm/numaq/apicdef.h
 delete mode 100644 arch/x86/include/asm/numaq/ipi.h
 delete mode 100644 arch/x86/include/asm/numaq/mpparse.h
 delete mode 100644 arch/x86/include/asm/numaq/wakecpu.h

diff --git a/arch/x86/include/asm/numaq/apic.h b/arch/x86/include/asm/numaq/apic.h
deleted file mode 100644
index ce95e79..0000000
--- a/arch/x86/include/asm/numaq/apic.h
+++ /dev/null
@@ -1,122 +0,0 @@
-#ifndef __ASM_NUMAQ_APIC_H
-#define __ASM_NUMAQ_APIC_H
-
-#include <asm/io.h>
-#include <linux/mmzone.h>
-#include <linux/nodemask.h>
-
-#define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
-
-static inline const cpumask_t *numaq_target_cpus(void)
-{
-	return &CPU_MASK_ALL;
-}
-
-static inline unsigned long
-numaq_check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return physid_isset(apicid, bitmap);
-}
-static inline unsigned long numaq_check_apicid_present(int bit)
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-#define apicid_cluster(apicid) (apicid & 0xF0)
-
-static inline int numaq_apic_id_registered(void)
-{
-	return 1;
-}
-
-static inline void numaq_init_apic_ldr(void)
-{
-	/* Already done in NUMA-Q firmware */
-}
-
-static inline void numaq_setup_apic_routing(void)
-{
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
-		"NUMA-Q", nr_ioapics);
-}
-
-/*
- * Skip adding the timer int on secondary nodes, which causes
- * a small but painful rift in the time-space continuum.
- */
-static inline int numaq_multi_timer_check(int apic, int irq)
-{
-	return apic != 0 && irq == 0;
-}
-
-static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	/* We don't have a good way to do this yet - hack */
-	return physids_promote(0xFUL);
-}
-
-/* Mapping from cpu number to logical apicid */
-extern u8 cpu_2_logical_apicid[];
-
-static inline int numaq_cpu_to_logical_apicid(int cpu)
-{
-	if (cpu >= nr_cpu_ids)
-		return BAD_APICID;
-	return (int)cpu_2_logical_apicid[cpu];
-}
-
-/*
- * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
- * cpu to APIC ID relation to properly interact with the intelligent
- * mode of the cluster controller.
- */
-static inline int numaq_cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < 60)
-		return ((mps_cpu >> 2) << 4) | (1 << (mps_cpu & 0x3));
-	else
-		return BAD_APICID;
-}
-
-static inline int numaq_apicid_to_node(int logical_apicid) 
-{
-	return logical_apicid >> 4;
-}
-
-static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
-{
-	int node = numaq_apicid_to_node(logical_apicid);
-	int cpu = __ffs(logical_apicid & 0xf);
-
-	return physid_mask_of_physid(cpu + 4*node);
-}
-
-extern void *xquad_portio;
-
-static inline int numaq_check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return 1;
-}
-
-/*
- * We use physical apicids here, not logical, so just return the default
- * physical broadcast to stop people from breaking us
- */
-static inline unsigned int numaq_cpu_mask_to_apicid(const cpumask_t *cpumask)
-{
-	return 0x0F;
-}
-
-static inline unsigned int
-numaq_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
-			     const struct cpumask *andmask)
-{
-	return 0x0F;
-}
-
-/* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
-static inline int numaq_phys_pkg_id(int cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_NUMAQ_APIC_H */
diff --git a/arch/x86/include/asm/numaq/apicdef.h b/arch/x86/include/asm/numaq/apicdef.h
deleted file mode 100644
index cd927d5..0000000
--- a/arch/x86/include/asm/numaq/apicdef.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_NUMAQ_APICDEF_H
-#define __ASM_NUMAQ_APICDEF_H
-
-static inline unsigned int numaq_get_apic_id(unsigned long x)
-{
-	return (x >> 24) & 0x0F;
-}
-
-#endif
diff --git a/arch/x86/include/asm/numaq/ipi.h b/arch/x86/include/asm/numaq/ipi.h
deleted file mode 100644
index 5dbc4b4..0000000
--- a/arch/x86/include/asm/numaq/ipi.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __ASM_NUMAQ_IPI_H
-#define __ASM_NUMAQ_IPI_H
-
-void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-
-static inline void numaq_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void numaq_send_IPI_allbutself(int vector)
-{
-	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
-}
-
-static inline void numaq_send_IPI_all(int vector)
-{
-	numaq_send_IPI_mask(cpu_online_mask, vector);
-}
-
-#endif /* __ASM_NUMAQ_IPI_H */
diff --git a/arch/x86/include/asm/numaq/mpparse.h b/arch/x86/include/asm/numaq/mpparse.h
deleted file mode 100644
index a2eeefc..0000000
--- a/arch/x86/include/asm/numaq/mpparse.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_NUMAQ_MPPARSE_H
-#define __ASM_NUMAQ_MPPARSE_H
-
-extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
-
-#endif /* __ASM_NUMAQ_MPPARSE_H */
diff --git a/arch/x86/include/asm/numaq/wakecpu.h b/arch/x86/include/asm/numaq/wakecpu.h
deleted file mode 100644
index afe8143..0000000
--- a/arch/x86/include/asm/numaq/wakecpu.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef __ASM_NUMAQ_WAKECPU_H
-#define __ASM_NUMAQ_WAKECPU_H
-
-/* This file copes with machines that wakeup secondary CPUs by NMIs */
-
-#define NUMAQ_TRAMPOLINE_PHYS_LOW (0x8)
-#define NUMAQ_TRAMPOLINE_PHYS_HIGH (0xa)
-
-/*
- * Because we use NMIs rather than the INIT-STARTUP sequence to
- * bootstrap the CPUs, the APIC may be in a weird state. Kick it:
- */
-static inline void numaq_smp_callin_clear_local_apic(void)
-{
-	clear_local_APIC();
-}
-
-static inline void
-numaq_store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-	printk("Storing NMI vector\n");
-	*high =
-	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH));
-	*low =
-	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
-}
-
-#endif /* __ASM_NUMAQ_WAKECPU_H */
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index ddb50fb..c221cfb 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -11,14 +11,175 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/numaq/apicdef.h>
+#include <linux/numa.h>
 #include <linux/smp.h>
-#include <asm/numaq/apic.h>
-#include <asm/numaq/ipi.h>
-#include <asm/numaq/mpparse.h>
-#include <asm/numaq/wakecpu.h>
 #include <asm/numaq.h>
+#include <asm/io.h>
+#include <linux/mmzone.h>
+#include <linux/nodemask.h>
 
+#define NUMAQ_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
+
+static inline unsigned int numaq_get_apic_id(unsigned long x)
+{
+	return (x >> 24) & 0x0F;
+}
+
+void default_send_IPI_mask_sequence(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+
+static inline void numaq_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void numaq_send_IPI_allbutself(int vector)
+{
+	default_send_IPI_mask_allbutself(cpu_online_mask, vector);
+}
+
+static inline void numaq_send_IPI_all(int vector)
+{
+	numaq_send_IPI_mask(cpu_online_mask, vector);
+}
+
+extern void numaq_mps_oem_check(struct mpc_table *, char *, char *);
+
+#define NUMAQ_TRAMPOLINE_PHYS_LOW (0x8)
+#define NUMAQ_TRAMPOLINE_PHYS_HIGH (0xa)
+
+/*
+ * Because we use NMIs rather than the INIT-STARTUP sequence to
+ * bootstrap the CPUs, the APIC may be in a weird state. Kick it:
+ */
+static inline void numaq_smp_callin_clear_local_apic(void)
+{
+	clear_local_APIC();
+}
+
+static inline void
+numaq_store_NMI_vector(unsigned short *high, unsigned short *low)
+{
+	printk("Storing NMI vector\n");
+	*high =
+	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_HIGH));
+	*low =
+	  *((volatile unsigned short *)phys_to_virt(NUMAQ_TRAMPOLINE_PHYS_LOW));
+}
+
+static inline const cpumask_t *numaq_target_cpus(void)
+{
+	return &CPU_MASK_ALL;
+}
+
+static inline unsigned long
+numaq_check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return physid_isset(apicid, bitmap);
+}
+
+static inline unsigned long numaq_check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+#define apicid_cluster(apicid) (apicid & 0xF0)
+
+static inline int numaq_apic_id_registered(void)
+{
+	return 1;
+}
+
+static inline void numaq_init_apic_ldr(void)
+{
+	/* Already done in NUMA-Q firmware */
+}
+
+static inline void numaq_setup_apic_routing(void)
+{
+	printk("Enabling APIC mode:  %s.  Using %d I/O APICs\n",
+		"NUMA-Q", nr_ioapics);
+}
+
+/*
+ * Skip adding the timer int on secondary nodes, which causes
+ * a small but painful rift in the time-space continuum.
+ */
+static inline int numaq_multi_timer_check(int apic, int irq)
+{
+	return apic != 0 && irq == 0;
+}
+
+static inline physid_mask_t numaq_ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	/* We don't have a good way to do this yet - hack */
+	return physids_promote(0xFUL);
+}
+
+/* Mapping from cpu number to logical apicid */
+extern u8 cpu_2_logical_apicid[];
+
+static inline int numaq_cpu_to_logical_apicid(int cpu)
+{
+	if (cpu >= nr_cpu_ids)
+		return BAD_APICID;
+	return (int)cpu_2_logical_apicid[cpu];
+}
+
+/*
+ * Supporting over 60 cpus on NUMA-Q requires a locality-dependent
+ * cpu to APIC ID relation to properly interact with the intelligent
+ * mode of the cluster controller.
+ */
+static inline int numaq_cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < 60)
+		return ((mps_cpu >> 2) << 4) | (1 << (mps_cpu & 0x3));
+	else
+		return BAD_APICID;
+}
+
+static inline int numaq_apicid_to_node(int logical_apicid) 
+{
+	return logical_apicid >> 4;
+}
+
+static inline physid_mask_t numaq_apicid_to_cpu_present(int logical_apicid)
+{
+	int node = numaq_apicid_to_node(logical_apicid);
+	int cpu = __ffs(logical_apicid & 0xf);
+
+	return physid_mask_of_physid(cpu + 4*node);
+}
+
+extern void *xquad_portio;
+
+static inline int numaq_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return 1;
+}
+
+/*
+ * We use physical apicids here, not logical, so just return the default
+ * physical broadcast to stop people from breaking us
+ */
+static inline unsigned int numaq_cpu_mask_to_apicid(const cpumask_t *cpumask)
+{
+	return 0x0F;
+}
+
+static inline unsigned int
+numaq_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
+			     const struct cpumask *andmask)
+{
+	return 0x0F;
+}
+
+/* No NUMA-Q box has a HT CPU, but it can't hurt to use the default code. */
+static inline int numaq_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
 static int __numaq_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	numaq_mps_oem_check(mpc, oem, productid);
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 2089354..1b2d773 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -5,7 +5,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/nodemask.h>
-#include <mach_apic.h>
+#include <asm/genapic.h>
 #include <asm/mpspec.h>
 #include <asm/pci_x86.h>
 
-- 
1.6.0.2

