Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZA2AOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZA2AOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbZA1XqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:53197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430AbZA1XqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:13 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 074/114] x86, summit: consolidate code
Date: Wed, 28 Jan 2009 23:42:20 +0000
Message-Id: <1233186180-29883-75-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:45:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all the Summit code into a single file:
arch/x86/kernel/summit_32.c.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/summit/apic.h    |  195 ---------------
 arch/x86/include/asm/summit/apicdef.h |    9 -
 arch/x86/include/asm/summit/ipi.h     |   26 --
 arch/x86/include/asm/summit/mpparse.h |  109 ---------
 arch/x86/kernel/summit_32.c           |  417 ++++++++++++++++++++++++++++++++-
 arch/x86/mach-generic/Makefile        |    1 -
 arch/x86/mach-generic/summit.c        |   94 --------
 7 files changed, 416 insertions(+), 435 deletions(-)
 delete mode 100644 arch/x86/include/asm/summit/apic.h
 delete mode 100644 arch/x86/include/asm/summit/apicdef.h
 delete mode 100644 arch/x86/include/asm/summit/ipi.h
 delete mode 100644 arch/x86/include/asm/summit/mpparse.h
 delete mode 100644 arch/x86/mach-generic/summit.c

diff --git a/arch/x86/include/asm/summit/apic.h b/arch/x86/include/asm/summit/apic.h
deleted file mode 100644
index 15b8dbd..0000000
--- a/arch/x86/include/asm/summit/apic.h
+++ /dev/null
@@ -1,195 +0,0 @@
-#ifndef __ASM_SUMMIT_APIC_H
-#define __ASM_SUMMIT_APIC_H
-
-#include <asm/smp.h>
-#include <linux/gfp.h>
-
-/* In clustered mode, the high nibble of APIC ID is a cluster number.
- * The low nibble is a 4-bit bitmap. */
-#define XAPIC_DEST_CPUS_SHIFT	4
-#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
-#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
-
-#define APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
-
-static inline const cpumask_t *summit_target_cpus(void)
-{
-	/* CPU_MASK_ALL (0xff) has undefined behaviour with
-	 * dest_LowestPrio mode logical clustered apic interrupt routing
-	 * Just start on cpu 0.  IRQ balancing will spread load
-	 */
-	return &cpumask_of_cpu(0);
-}
-
-static inline unsigned long
-summit_check_apicid_used(physid_mask_t bitmap, int apicid)
-{
-	return 0;
-}
-
-/* we don't use the phys_cpu_present_map to indicate apicid presence */
-static inline unsigned long summit_check_apicid_present(int bit)
-{
-	return 1;
-}
-
-#define apicid_cluster(apicid) ((apicid) & XAPIC_DEST_CLUSTER_MASK)
-
-extern u8 cpu_2_logical_apicid[];
-
-static inline void summit_init_apic_ldr(void)
-{
-	unsigned long val, id;
-	int count = 0;
-	u8 my_id = (u8)hard_smp_processor_id();
-	u8 my_cluster = (u8)apicid_cluster(my_id);
-#ifdef CONFIG_SMP
-	u8 lid;
-	int i;
-
-	/* Create logical APIC IDs by counting CPUs already in cluster. */
-	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
-		lid = cpu_2_logical_apicid[i];
-		if (lid != BAD_APICID && apicid_cluster(lid) == my_cluster)
-			++count;
-	}
-#endif
-	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
-	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
-	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
-	id = my_cluster | (1UL << count);
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(id);
-	apic_write(APIC_LDR, val);
-}
-
-static inline int summit_apic_id_registered(void)
-{
-	return 1;
-}
-
-static inline void summit_setup_apic_routing(void)
-{
-	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
-						nr_ioapics);
-}
-
-static inline int summit_apicid_to_node(int logical_apicid)
-{
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
-#else
-	return 0;
-#endif
-}
-
-/* Mapping from cpu number to logical apicid */
-static inline int summit_cpu_to_logical_apicid(int cpu)
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
-static inline int summit_cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < nr_cpu_ids)
-		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
-	else
-		return BAD_APICID;
-}
-
-static inline physid_mask_t
-summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
-{
-	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0x0F);
-}
-
-static inline physid_mask_t summit_apicid_to_cpu_present(int apicid)
-{
-	return physid_mask_of_physid(0);
-}
-
-static inline void summit_setup_portio_remap(void)
-{
-}
-
-static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return 1;
-}
-
-static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
-{
-	int cpus_found = 0;
-	int num_bits_set;
-	int apicid;
-	int cpu;
-
-	num_bits_set = cpus_weight(*cpumask);
-	/* Return id to all */
-	if (num_bits_set >= nr_cpu_ids)
-		return 0xFF;
-	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of target_cpus():
-	 */
-	cpu = first_cpu(*cpumask);
-	apicid = summit_cpu_to_logical_apicid(cpu);
-
-	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask)) {
-			int new_apicid = summit_cpu_to_logical_apicid(cpu);
-
-			if (apicid_cluster(apicid) !=
-					apicid_cluster(new_apicid)) {
-				printk ("%s: Not a valid mask!\n", __func__);
-
-				return 0xFF;
-			}
-			apicid = apicid | new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-	return apicid;
-}
-
-static inline unsigned int
-summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
-			      const struct cpumask *andmask)
-{
-	int apicid = summit_cpu_to_logical_apicid(0);
-	cpumask_var_t cpumask;
-
-	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
-		return apicid;
-
-	cpumask_and(cpumask, inmask, andmask);
-	cpumask_and(cpumask, cpumask, cpu_online_mask);
-	apicid = summit_cpu_mask_to_apicid(cpumask);
-
-	free_cpumask_var(cpumask);
-
-	return apicid;
-}
-
-/*
- * cpuid returns the value latched in the HW at reset, not the APIC ID
- * register's value.  For any box whose BIOS changes APIC IDs, like
- * clustered APIC systems, we must use hard_smp_processor_id.
- *
- * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
- */
-static inline int summit_phys_pkg_id(int cpuid_apic, int index_msb)
-{
-	return hard_smp_processor_id() >> index_msb;
-}
-
-#endif /* __ASM_SUMMIT_APIC_H */
diff --git a/arch/x86/include/asm/summit/apicdef.h b/arch/x86/include/asm/summit/apicdef.h
deleted file mode 100644
index c24b0df..0000000
--- a/arch/x86/include/asm/summit/apicdef.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_SUMMIT_APICDEF_H
-#define __ASM_SUMMIT_APICDEF_H
-
-static inline unsigned summit_get_apic_id(unsigned long x)
-{
-	return (x >> 24) & 0xFF;
-}
-
-#endif
diff --git a/arch/x86/include/asm/summit/ipi.h b/arch/x86/include/asm/summit/ipi.h
deleted file mode 100644
index f87a43f..0000000
--- a/arch/x86/include/asm/summit/ipi.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifndef __ASM_SUMMIT_IPI_H
-#define __ASM_SUMMIT_IPI_H
-
-void default_send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void default_send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
-
-static inline void summit_send_IPI_mask(const cpumask_t *mask, int vector)
-{
-	default_send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void summit_send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-
-	if (!cpus_empty(mask))
-		summit_send_IPI_mask(&mask, vector);
-}
-
-static inline void summit_send_IPI_all(int vector)
-{
-	summit_send_IPI_mask(&cpu_online_map, vector);
-}
-
-#endif /* __ASM_SUMMIT_IPI_H */
diff --git a/arch/x86/include/asm/summit/mpparse.h b/arch/x86/include/asm/summit/mpparse.h
deleted file mode 100644
index 4bbcce3..0000000
--- a/arch/x86/include/asm/summit/mpparse.h
+++ /dev/null
@@ -1,109 +0,0 @@
-#ifndef __ASM_SUMMIT_MPPARSE_H
-#define __ASM_SUMMIT_MPPARSE_H
-
-#include <asm/tsc.h>
-
-extern int use_cyclone;
-
-#ifdef CONFIG_X86_SUMMIT_NUMA
-extern void setup_summit(void);
-#else
-#define setup_summit()	{}
-#endif
-
-static inline int
-summit_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
-{
-	if (!strncmp(oem, "IBM ENSW", 8) &&
-			(!strncmp(productid, "VIGIL SMP", 9)
-			 || !strncmp(productid, "EXA", 3)
-			 || !strncmp(productid, "RUTHLESS SMP", 12))){
-		mark_tsc_unstable("Summit based system");
-		use_cyclone = 1; /*enable cyclone-timer*/
-		setup_summit();
-		return 1;
-	}
-	return 0;
-}
-
-/* Hook from generic ACPI tables.c */
-static inline int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
-{
-	if (!strncmp(oem_id, "IBM", 3) &&
-	    (!strncmp(oem_table_id, "SERVIGIL", 8)
-	     || !strncmp(oem_table_id, "EXA", 3))){
-		mark_tsc_unstable("Summit based system");
-		use_cyclone = 1; /*enable cyclone-timer*/
-		setup_summit();
-		return 1;
-	}
-	return 0;
-}
-
-struct rio_table_hdr {
-	unsigned char version;      /* Version number of this data structure           */
-	                            /* Version 3 adds chassis_num & WP_index           */
-	unsigned char num_scal_dev; /* # of Scalability devices (Twisters for Vigil)   */
-	unsigned char num_rio_dev;  /* # of RIO I/O devices (Cyclones and Winnipegs)   */
-} __attribute__((packed));
-
-struct scal_detail {
-	unsigned char node_id;      /* Scalability Node ID                             */
-	unsigned long CBAR;         /* Address of 1MB register space                   */
-	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
-	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char port1node;    /* Node ID port connected to: 0xFF = None          */
-	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char port2node;    /* Node ID port connected to: 0xFF = None          */
-	unsigned char port2port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char chassis_num;  /* 1 based Chassis number (1 = boot node)          */
-} __attribute__((packed));
-
-struct rio_detail {
-	unsigned char node_id;      /* RIO Node ID                                     */
-	unsigned long BBAR;         /* Address of 1MB register space                   */
-	unsigned char type;         /* Type of device                                  */
-	unsigned char owner_id;     /* For WPEG: Node ID of Cyclone that owns this WPEG*/
-	                            /* For CYC:  Node ID of Twister that owns this CYC */
-	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
-	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char port1node;    /* Node ID port connected to: 0xFF=None            */
-	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
-	unsigned char first_slot;   /* For WPEG: Lowest slot number below this WPEG    */
-	                            /* For CYC:  0                                     */
-	unsigned char status;       /* For WPEG: Bit 0 = 1 : the XAPIC is used         */
-	                            /*                 = 0 : the XAPIC is not used, ie:*/
-	                            /*                     ints fwded to another XAPIC */
-	                            /*           Bits1:7 Reserved                      */
-	                            /* For CYC:  Bits0:7 Reserved                      */
-	unsigned char WP_index;     /* For WPEG: WPEG instance index - lower ones have */
-	                            /*           lower slot numbers/PCI bus numbers    */
-	                            /* For CYC:  No meaning                            */
-	unsigned char chassis_num;  /* 1 based Chassis number                          */
-	                            /* For LookOut WPEGs this field indicates the      */
-	                            /* Expansion Chassis #, enumerated from Boot       */
-	                            /* Node WPEG external port, then Boot Node CYC     */
-	                            /* external port, then Next Vigil chassis WPEG     */
-	                            /* external port, etc.                             */
-	                            /* Shared Lookouts have only 1 chassis number (the */
-	                            /* first one assigned)                             */
-} __attribute__((packed));
-
-
-typedef enum {
-	CompatTwister = 0,  /* Compatibility Twister               */
-	AltTwister    = 1,  /* Alternate Twister of internal 8-way */
-	CompatCyclone = 2,  /* Compatibility Cyclone               */
-	AltCyclone    = 3,  /* Alternate Cyclone of internal 8-way */
-	CompatWPEG    = 4,  /* Compatibility WPEG                  */
-	AltWPEG       = 5,  /* Second Planar WPEG                  */
-	LookOutAWPEG  = 6,  /* LookOut WPEG                        */
-	LookOutBWPEG  = 7,  /* LookOut WPEG                        */
-} node_type;
-
-static inline int is_WPEG(struct rio_detail *rio){
-	return (rio->type == CompatWPEG || rio->type == AltWPEG ||
-		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
-}
-
-#endif /* __ASM_SUMMIT_MPPARSE_H */
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 7b98785..3b60dd5 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -30,7 +30,364 @@
 #include <linux/init.h>
 #include <asm/io.h>
 #include <asm/bios_ebda.h>
-#include <asm/summit/mpparse.h>
+
+/*
+ * APIC driver for the IBM "Summit" chipset.
+ */
+#define APIC_DEFINITION 1
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <asm/mpspec.h>
+#include <asm/apic.h>
+#include <asm/smp.h>
+#include <asm/genapic.h>
+#include <asm/fixmap.h>
+#include <asm/apicdef.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/gfp.h>
+#include <linux/smp.h>
+
+static inline unsigned summit_get_apic_id(unsigned long x)
+{
+	return (x >> 24) & 0xFF;
+}
+
+void default_send_IPI_mask_sequence(const cpumask_t *mask, int vector);
+void default_send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+
+static inline void summit_send_IPI_mask(const cpumask_t *mask, int vector)
+{
+	default_send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void summit_send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), mask);
+
+	if (!cpus_empty(mask))
+		summit_send_IPI_mask(&mask, vector);
+}
+
+static inline void summit_send_IPI_all(int vector)
+{
+	summit_send_IPI_mask(&cpu_online_map, vector);
+}
+
+#include <asm/tsc.h>
+
+extern int use_cyclone;
+
+#ifdef CONFIG_X86_SUMMIT_NUMA
+extern void setup_summit(void);
+#else
+#define setup_summit()	{}
+#endif
+
+static inline int
+summit_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
+{
+	if (!strncmp(oem, "IBM ENSW", 8) &&
+			(!strncmp(productid, "VIGIL SMP", 9)
+			 || !strncmp(productid, "EXA", 3)
+			 || !strncmp(productid, "RUTHLESS SMP", 12))){
+		mark_tsc_unstable("Summit based system");
+		use_cyclone = 1; /*enable cyclone-timer*/
+		setup_summit();
+		return 1;
+	}
+	return 0;
+}
+
+/* Hook from generic ACPI tables.c */
+static inline int summit_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (!strncmp(oem_id, "IBM", 3) &&
+	    (!strncmp(oem_table_id, "SERVIGIL", 8)
+	     || !strncmp(oem_table_id, "EXA", 3))){
+		mark_tsc_unstable("Summit based system");
+		use_cyclone = 1; /*enable cyclone-timer*/
+		setup_summit();
+		return 1;
+	}
+	return 0;
+}
+
+struct rio_table_hdr {
+	unsigned char version;      /* Version number of this data structure           */
+	                            /* Version 3 adds chassis_num & WP_index           */
+	unsigned char num_scal_dev; /* # of Scalability devices (Twisters for Vigil)   */
+	unsigned char num_rio_dev;  /* # of RIO I/O devices (Cyclones and Winnipegs)   */
+} __attribute__((packed));
+
+struct scal_detail {
+	unsigned char node_id;      /* Scalability Node ID                             */
+	unsigned long CBAR;         /* Address of 1MB register space                   */
+	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
+	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char port1node;    /* Node ID port connected to: 0xFF = None          */
+	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char port2node;    /* Node ID port connected to: 0xFF = None          */
+	unsigned char port2port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char chassis_num;  /* 1 based Chassis number (1 = boot node)          */
+} __attribute__((packed));
+
+struct rio_detail {
+	unsigned char node_id;      /* RIO Node ID                                     */
+	unsigned long BBAR;         /* Address of 1MB register space                   */
+	unsigned char type;         /* Type of device                                  */
+	unsigned char owner_id;     /* For WPEG: Node ID of Cyclone that owns this WPEG*/
+	                            /* For CYC:  Node ID of Twister that owns this CYC */
+	unsigned char port0node;    /* Node ID port connected to: 0xFF=None            */
+	unsigned char port0port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char port1node;    /* Node ID port connected to: 0xFF=None            */
+	unsigned char port1port;    /* Port num port connected to: 0,1,2, or 0xFF=None */
+	unsigned char first_slot;   /* For WPEG: Lowest slot number below this WPEG    */
+	                            /* For CYC:  0                                     */
+	unsigned char status;       /* For WPEG: Bit 0 = 1 : the XAPIC is used         */
+	                            /*                 = 0 : the XAPIC is not used, ie:*/
+	                            /*                     ints fwded to another XAPIC */
+	                            /*           Bits1:7 Reserved                      */
+	                            /* For CYC:  Bits0:7 Reserved                      */
+	unsigned char WP_index;     /* For WPEG: WPEG instance index - lower ones have */
+	                            /*           lower slot numbers/PCI bus numbers    */
+	                            /* For CYC:  No meaning                            */
+	unsigned char chassis_num;  /* 1 based Chassis number                          */
+	                            /* For LookOut WPEGs this field indicates the      */
+	                            /* Expansion Chassis #, enumerated from Boot       */
+	                            /* Node WPEG external port, then Boot Node CYC     */
+	                            /* external port, then Next Vigil chassis WPEG     */
+	                            /* external port, etc.                             */
+	                            /* Shared Lookouts have only 1 chassis number (the */
+	                            /* first one assigned)                             */
+} __attribute__((packed));
+
+
+typedef enum {
+	CompatTwister = 0,  /* Compatibility Twister               */
+	AltTwister    = 1,  /* Alternate Twister of internal 8-way */
+	CompatCyclone = 2,  /* Compatibility Cyclone               */
+	AltCyclone    = 3,  /* Alternate Cyclone of internal 8-way */
+	CompatWPEG    = 4,  /* Compatibility WPEG                  */
+	AltWPEG       = 5,  /* Second Planar WPEG                  */
+	LookOutAWPEG  = 6,  /* LookOut WPEG                        */
+	LookOutBWPEG  = 7,  /* LookOut WPEG                        */
+} node_type;
+
+static inline int is_WPEG(struct rio_detail *rio){
+	return (rio->type == CompatWPEG || rio->type == AltWPEG ||
+		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
+}
+
+
+/* In clustered mode, the high nibble of APIC ID is a cluster number.
+ * The low nibble is a 4-bit bitmap. */
+#define XAPIC_DEST_CPUS_SHIFT	4
+#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
+#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
+
+#define SUMMIT_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
+
+static inline const cpumask_t *summit_target_cpus(void)
+{
+	/* CPU_MASK_ALL (0xff) has undefined behaviour with
+	 * dest_LowestPrio mode logical clustered apic interrupt routing
+	 * Just start on cpu 0.  IRQ balancing will spread load
+	 */
+	return &cpumask_of_cpu(0);
+}
+
+static inline unsigned long
+summit_check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return 0;
+}
+
+/* we don't use the phys_cpu_present_map to indicate apicid presence */
+static inline unsigned long summit_check_apicid_present(int bit)
+{
+	return 1;
+}
+
+#define apicid_cluster(apicid) ((apicid) & XAPIC_DEST_CLUSTER_MASK)
+
+extern u8 cpu_2_logical_apicid[];
+
+static inline void summit_init_apic_ldr(void)
+{
+	unsigned long val, id;
+	int count = 0;
+	u8 my_id = (u8)hard_smp_processor_id();
+	u8 my_cluster = (u8)apicid_cluster(my_id);
+#ifdef CONFIG_SMP
+	u8 lid;
+	int i;
+
+	/* Create logical APIC IDs by counting CPUs already in cluster. */
+	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
+		lid = cpu_2_logical_apicid[i];
+		if (lid != BAD_APICID && apicid_cluster(lid) == my_cluster)
+			++count;
+	}
+#endif
+	/* We only have a 4 wide bitmap in cluster mode.  If a deranged
+	 * BIOS puts 5 CPUs in one APIC cluster, we're hosed. */
+	BUG_ON(count >= XAPIC_DEST_CPUS_SHIFT);
+	id = my_cluster | (1UL << count);
+	apic_write(APIC_DFR, SUMMIT_APIC_DFR_VALUE);
+	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+	val |= SET_APIC_LOGICAL_ID(id);
+	apic_write(APIC_LDR, val);
+}
+
+static inline int summit_apic_id_registered(void)
+{
+	return 1;
+}
+
+static inline void summit_setup_apic_routing(void)
+{
+	printk("Enabling APIC mode:  Summit.  Using %d I/O APICs\n",
+						nr_ioapics);
+}
+
+static inline int summit_apicid_to_node(int logical_apicid)
+{
+#ifdef CONFIG_SMP
+	return apicid_2_node[hard_smp_processor_id()];
+#else
+	return 0;
+#endif
+}
+
+/* Mapping from cpu number to logical apicid */
+static inline int summit_cpu_to_logical_apicid(int cpu)
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
+static inline int summit_cpu_present_to_apicid(int mps_cpu)
+{
+	if (mps_cpu < nr_cpu_ids)
+		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
+	else
+		return BAD_APICID;
+}
+
+static inline physid_mask_t
+summit_ioapic_phys_id_map(physid_mask_t phys_id_map)
+{
+	/* For clustered we don't have a good way to do this yet - hack */
+	return physids_promote(0x0F);
+}
+
+static inline physid_mask_t summit_apicid_to_cpu_present(int apicid)
+{
+	return physid_mask_of_physid(0);
+}
+
+static inline void summit_setup_portio_remap(void)
+{
+}
+
+static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
+{
+	return 1;
+}
+
+static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
+{
+	int cpus_found = 0;
+	int num_bits_set;
+	int apicid;
+	int cpu;
+
+	num_bits_set = cpus_weight(*cpumask);
+	/* Return id to all */
+	if (num_bits_set >= nr_cpu_ids)
+		return 0xFF;
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of target_cpus():
+	 */
+	cpu = first_cpu(*cpumask);
+	apicid = summit_cpu_to_logical_apicid(cpu);
+
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, *cpumask)) {
+			int new_apicid = summit_cpu_to_logical_apicid(cpu);
+
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)) {
+				printk ("%s: Not a valid mask!\n", __func__);
+
+				return 0xFF;
+			}
+			apicid = apicid | new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+static inline unsigned int
+summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
+			      const struct cpumask *andmask)
+{
+	int apicid = summit_cpu_to_logical_apicid(0);
+	cpumask_var_t cpumask;
+
+	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
+		return apicid;
+
+	cpumask_and(cpumask, inmask, andmask);
+	cpumask_and(cpumask, cpumask, cpu_online_mask);
+	apicid = summit_cpu_mask_to_apicid(cpumask);
+
+	free_cpumask_var(cpumask);
+
+	return apicid;
+}
+
+/*
+ * cpuid returns the value latched in the HW at reset, not the APIC ID
+ * register's value.  For any box whose BIOS changes APIC IDs, like
+ * clustered APIC systems, we must use hard_smp_processor_id.
+ *
+ * See Intel's IA-32 SW Dev's Manual Vol2 under CPUID.
+ */
+static inline int summit_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
+static int probe_summit(void)
+{
+	/* probed later in mptable/ACPI hooks */
+	return 0;
+}
+
+static void summit_vector_allocation_domain(int cpu, cpumask_t *retmask)
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
 
 static struct rio_table_hdr *rio_table_hdr __initdata;
 static struct scal_detail   *scal_devs[MAX_NUMNODES] __initdata;
@@ -186,3 +543,61 @@ void __init setup_summit(void)
 			next_wpeg = 0;
 	} while (next_wpeg != 0);
 }
+
+
+struct genapic apic_summit = {
+
+	.name				= "summit",
+	.probe				= probe_summit,
+	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
+	.apic_id_registered		= summit_apic_id_registered,
+
+	.irq_delivery_mode		= dest_LowestPrio,
+	/* logical delivery broadcast to all CPUs: */
+	.irq_dest_mode			= 1,
+
+	.target_cpus			= summit_target_cpus,
+	.disable_esr			= 1,
+	.dest_logical			= APIC_DEST_LOGICAL,
+	.check_apicid_used		= summit_check_apicid_used,
+	.check_apicid_present		= summit_check_apicid_present,
+
+	.vector_allocation_domain	= summit_vector_allocation_domain,
+	.init_apic_ldr			= summit_init_apic_ldr,
+
+	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
+	.setup_apic_routing		= summit_setup_apic_routing,
+	.multi_timer_check		= NULL,
+	.apicid_to_node			= summit_apicid_to_node,
+	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
+	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
+	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
+	.setup_portio_remap		= NULL,
+	.check_phys_apicid_present	= summit_check_phys_apicid_present,
+	.enable_apic_mode		= NULL,
+	.phys_pkg_id			= summit_phys_pkg_id,
+	.mps_oem_check			= summit_mps_oem_check,
+
+	.get_apic_id			= summit_get_apic_id,
+	.set_apic_id			= NULL,
+	.apic_id_mask			= 0xFF << 24,
+
+	.cpu_mask_to_apicid		= summit_cpu_mask_to_apicid,
+	.cpu_mask_to_apicid_and		= summit_cpu_mask_to_apicid_and,
+
+	.send_IPI_mask			= summit_send_IPI_mask,
+	.send_IPI_mask_allbutself	= NULL,
+	.send_IPI_allbutself		= summit_send_IPI_allbutself,
+	.send_IPI_all			= summit_send_IPI_all,
+	.send_IPI_self			= NULL,
+
+	.wakeup_cpu			= NULL,
+	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
+	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
+
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
+
+	.smp_callin_clear_local_apic	= NULL,
+	.store_NMI_vector		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
+};
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
index 6730f4e..78ab573 100644
--- a/arch/x86/mach-generic/Makefile
+++ b/arch/x86/mach-generic/Makefile
@@ -6,6 +6,5 @@ EXTRA_CFLAGS			:= -Iarch/x86/kernel
 
 obj-y				:= probe.o default.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
-obj-$(CONFIG_X86_SUMMIT)	+= summit.o
 obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
 obj-$(CONFIG_X86_ES7000)	+= es7000.o
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
deleted file mode 100644
index 673a64f..0000000
--- a/arch/x86/mach-generic/summit.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * APIC driver for the IBM "Summit" chipset.
- */
-#define APIC_DEFINITION 1
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <asm/mpspec.h>
-#include <asm/genapic.h>
-#include <asm/fixmap.h>
-#include <asm/apicdef.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/init.h>
-#include <asm/summit/apicdef.h>
-#include <linux/smp.h>
-#include <asm/summit/apic.h>
-#include <asm/summit/ipi.h>
-#include <asm/summit/mpparse.h>
-
-static int probe_summit(void)
-{
-	/* probed later in mptable/ACPI hooks */
-	return 0;
-}
-
-static void summit_vector_allocation_domain(int cpu, cpumask_t *retmask)
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
-
-struct genapic apic_summit = {
-
-	.name				= "summit",
-	.probe				= probe_summit,
-	.acpi_madt_oem_check		= summit_acpi_madt_oem_check,
-	.apic_id_registered		= summit_apic_id_registered,
-
-	.irq_delivery_mode		= dest_LowestPrio,
-	/* logical delivery broadcast to all CPUs: */
-	.irq_dest_mode			= 1,
-
-	.target_cpus			= summit_target_cpus,
-	.disable_esr			= 1,
-	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= summit_check_apicid_used,
-	.check_apicid_present		= summit_check_apicid_present,
-
-	.vector_allocation_domain	= summit_vector_allocation_domain,
-	.init_apic_ldr			= summit_init_apic_ldr,
-
-	.ioapic_phys_id_map		= summit_ioapic_phys_id_map,
-	.setup_apic_routing		= summit_setup_apic_routing,
-	.multi_timer_check		= NULL,
-	.apicid_to_node			= summit_apicid_to_node,
-	.cpu_to_logical_apicid		= summit_cpu_to_logical_apicid,
-	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
-	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
-	.setup_portio_remap		= NULL,
-	.check_phys_apicid_present	= summit_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= summit_phys_pkg_id,
-	.mps_oem_check			= summit_mps_oem_check,
-
-	.get_apic_id			= summit_get_apic_id,
-	.set_apic_id			= NULL,
-	.apic_id_mask			= 0xFF << 24,
-
-	.cpu_mask_to_apicid		= summit_cpu_mask_to_apicid,
-	.cpu_mask_to_apicid_and		= summit_cpu_mask_to_apicid_and,
-
-	.send_IPI_mask			= summit_send_IPI_mask,
-	.send_IPI_mask_allbutself	= NULL,
-	.send_IPI_allbutself		= summit_send_IPI_allbutself,
-	.send_IPI_all			= summit_send_IPI_all,
-	.send_IPI_self			= NULL,
-
-	.wakeup_cpu			= NULL,
-	.trampoline_phys_low		= DEFAULT_TRAMPOLINE_PHYS_LOW,
-	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
-
-	.wait_for_init_deassert		= default_wait_for_init_deassert,
-
-	.smp_callin_clear_local_apic	= NULL,
-	.store_NMI_vector		= NULL,
-	.inquire_remote_apic		= default_inquire_remote_apic,
-};
-- 
1.6.0.2

