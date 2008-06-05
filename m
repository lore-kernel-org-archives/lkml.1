Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYFEKJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYFEKJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYFEKI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:08:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:16824 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYFEKIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=espwumXuc6ZLfPUiX1FxsT21i3O4k1cuNO+aRQSLkWDPoPTsw77n89H+csoBNqH8jT
         BSb7duFu5H+LfCL1vAenPoM0crmvKtkUD7BqMjE+MnsPyBG2EnHBXxdjEAST8gfyGIcI
         3HLW4hiuzqfGktC6IeYEeZivDoyJDOFpsSG7Q=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RFC [PATCH] x86: make generic arch support NUMAQ
Date: Thu, 5 Jun 2008 03:09:10 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806050309.11197.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so it could fallback to normal numa.

also decouple genericarch numa with acpi.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3105e40..ef48cb9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,12 +310,12 @@ config X86_VISWS
 	  and vice versa. See <file:Documentation/sgi-visws.txt> for details.
 
 config X86_GENERICARCH
-       bool "Generic architecture (Summit, bigsmp, ES7000, default)"
+       bool "Generic architecture (NUMAQ, Summit, bigsmp, ES7000, default)"
 	depends on X86_32
        help
-          This option compiles in the Summit, bigsmp, ES7000, default subarchitectures.
-	  It is intended for a generic binary kernel.
-	  If you want a NUMA kernel, select ACPI.   We need SRAT for NUMA.
+          This option compiles in the NUMAQ, Summit, bigsmp, ES7000, default
+	  subarchitectures.  It is intended for a generic binary kernel.
+	  You need enable NUMA, otherwise NUMAQ is skipped.
 
 config X86_ES7000
 	bool "Support for Unisys ES7000 IA32 series"
@@ -911,9 +911,9 @@ config X86_PAE
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
 	depends on SMP
-	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_GENERICARCH || X86_SUMMIT && ACPI) && EXPERIMENTAL)
 	default n if X86_PC
-	default y if (X86_NUMAQ || X86_SUMMIT)
+	default y if (X86_NUMAQ || X86_SUMMIT || X86_GENERICARCH)
 	help
 	  Enable NUMA (Non Uniform Memory Access) support.
 	  The kernel will try to allocate memory used by a CPU on the
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index d10e727..1b12ac1 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -217,7 +217,7 @@ static char *vidmem;
 static int vidport;
 static int lines, cols;
 
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 void *xquad_portio;
 #endif
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 882298d..adbf1ab 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,7 +67,15 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
-obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
+
+ifeq ($(CONFIG_X86_NUMAQ), y)
+obj-y				+= numaq_32.o
+else
+ifeq ($(CONFIG_X86_GENERICARCH), y)
+obj-$(CONFIG_NUMA)		+= numaq_32.o
+endif
+endif
+
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
 obj-y				+= vsmp_64.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index 9dbe7e9..db9efcd 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1715,7 +1715,6 @@ void disable_IO_APIC(void)
  * by Matt Domsch <Matt_Domsch@dell.com>  Tue Dec 21 12:25:05 CST 1999
  */
 
-#ifndef CONFIG_X86_NUMAQ
 static void __init setup_ioapic_ids_from_mpc(void)
 {
 	union IO_APIC_reg_00 reg_00;
@@ -1725,6 +1724,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
 	unsigned char old_id;
 	unsigned long flags;
 
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
+	if (found_numaq)
+		return;
+#endif
+
 	/*
 	 * Don't check I/O APIC IDs for xAPIC systems.  They have
 	 * no meaning without the serial APIC bus.
@@ -1821,9 +1825,6 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			apic_printk(APIC_VERBOSE, " ok.\n");
 	}
 }
-#else
-static void __init setup_ioapic_ids_from_mpc(void) { }
-#endif
 
 int no_timer_check __initdata;
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index b4a950d..83673bc 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -48,16 +48,74 @@ static int __init mpf_checksum(unsigned char *mp, int len)
 	return sum & 0xFF;
 }
 
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
+int found_numaq;
 /*
  * Have to match translation table entries to main table entries by counter
  * hence the mpc_record variable .... can't see a less disgusting way of
  * doing this ....
  */
+struct mpc_config_translation {
+	unsigned char mpc_type;
+	unsigned char trans_len;
+	unsigned char trans_type;
+	unsigned char trans_quad;
+	unsigned char trans_global;
+	unsigned char trans_local;
+	unsigned short trans_reserved;
+};
+
 
 static int mpc_record;
 static struct mpc_config_translation *translation_table[MAX_MPC_ENTRY]
     __cpuinitdata;
+
+static inline int generate_logical_apicid(int quad, int phys_apicid)
+{
+	return (quad << 4) + (phys_apicid ? phys_apicid << 1 : 1);
+}
+
+
+static inline int mpc_apic_id(struct mpc_config_processor *m, 
+			struct mpc_config_translation *translation_record)
+{
+	int quad = translation_record->trans_quad;
+	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
+
+	printk("Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
+	       m->mpc_apicid,
+	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
+	       m->mpc_apicver, quad, logical_apicid);
+	return logical_apicid;
+}
+
+int mp_bus_id_to_node[MAX_MP_BUSSES];
+
+int mp_bus_id_to_local[MAX_MP_BUSSES];
+
+static void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
+	struct mpc_config_translation *translation)
+{
+	int quad = translation->trans_quad;
+	int local = translation->trans_local;
+
+	mp_bus_id_to_node[m->mpc_busid] = quad;
+	mp_bus_id_to_local[m->mpc_busid] = local;
+	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
+	       m->mpc_busid, name, quad);
+}
+
+int quad_local_to_mp_bus_id [NR_CPUS/4][4];
+static void mpc_oem_pci_bus(struct mpc_config_bus *m,
+	struct mpc_config_translation *translation)
+{
+	int quad = translation->trans_quad;
+	int local = translation->trans_local;
+
+	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
+}
+
 #endif
 
 static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
@@ -69,7 +127,7 @@ static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
 		disabled_cpus++;
 		return;
 	}
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 	if (found_numaq)
 		apicid = mpc_apic_id(m, translation_table[mpc_record]);
 	else
@@ -93,7 +151,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 	memcpy(str, m->mpc_bustype, 6);
 	str[6] = 0;
 
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 	if (found_numaq)
 		mpc_oem_bus_info(m, str, translation_table[mpc_record]);
 #else
@@ -115,7 +173,7 @@ static void __init MP_bus_info(struct mpc_config_bus *m)
 		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 		if (found_numaq)
 			mpc_oem_pci_bus(m, translation_table[mpc_record]);
 #endif
@@ -258,7 +316,7 @@ static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
 		m->mpc_srcbusirq, m->mpc_destapic, m->mpc_destapiclint);
 }
 
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 static void __init MP_translation_info(struct mpc_config_translation *m)
 {
 	printk(KERN_INFO
@@ -333,7 +391,7 @@ static inline void mps_oem_check(struct mp_config_table *mpc, char *oem,
 		smp_read_mpc_oem((struct mp_config_oemtable *)mpc->mpc_oemptr,
 				 mpc->mpc_oemsize);
 }
-#endif /* CONFIG_X86_NUMAQ */
+#endif /* CONFIG_X86_NUMAQ || CONFIG_X86_GENERICARCH */
 
 /*
  * Read/parse the MPC
@@ -401,7 +459,7 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 	/*
 	 *      Now process the configuration blocks.
 	 */
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 	mpc_record = 0;
 #endif
 	while (count < mpc->mpc_length) {
@@ -469,7 +527,7 @@ static int __init smp_read_mpc(struct mp_config_table *mpc, unsigned early)
 			count = mpc->mpc_length;
 			break;
 		}
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 		++mpc_record;
 #endif
 	}
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 56f5d07..44ab680 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -94,7 +94,6 @@ static inline unsigned int get_timer_irqs(int cpu)
 #endif
 }
 
-#ifdef CONFIG_X86_64
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
 {
@@ -102,7 +101,6 @@ void nmi_watchdog_default(void)
 		return;
 	nmi_watchdog = NMI_NONE;
 }
-#endif
 
 #ifdef CONFIG_SMP
 /*
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 66c43c2..74e81bf 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -36,8 +36,6 @@
 
 #define	MB_TO_PAGES(addr) ((addr) << (20 - PAGE_SHIFT))
 
-int found_numaq;
-
 /*
  * Function: smp_dump_qct()
  *
@@ -105,13 +103,3 @@ static int __init numaq_tsc_disable(void)
 }
 arch_initcall(numaq_tsc_disable);
 
-#ifdef CONFIG_ACPI
-/*
- * Dummy implementation:
- */
-struct pci_bus * __devinit
-pci_acpi_scan_root(struct acpi_device *device, int domain, int busnum)
-{
-	return NULL;
-}
-#endif
diff --git a/arch/x86/mach-generic/Makefile b/arch/x86/mach-generic/Makefile
index 19d6d40..dc3a205 100644
--- a/arch/x86/mach-generic/Makefile
+++ b/arch/x86/mach-generic/Makefile
@@ -5,4 +5,5 @@
 EXTRA_CFLAGS	:= -Iarch/x86/kernel
 
 obj-y		:= probe.o summit.o bigsmp.o es7000.o default.o 
+obj-$(CONFIG_NUMA) += numaq.o
 obj-y		+= ../../x86/mach-es7000/
diff --git a/arch/x86/mach-generic/probe.c b/arch/x86/mach-generic/probe.c
index c5ae751..bd1c195 100644
--- a/arch/x86/mach-generic/probe.c
+++ b/arch/x86/mach-generic/probe.c
@@ -16,6 +16,9 @@
 #include <asm/apicdef.h>
 #include <asm/genapic.h>
 
+#ifdef CONFIG_NUMA
+extern struct genapic apic_numaq;
+#endif
 extern struct genapic apic_summit;
 extern struct genapic apic_bigsmp;
 extern struct genapic apic_es7000;
@@ -24,6 +27,9 @@ extern struct genapic apic_default;
 struct genapic *genapic = &apic_default;
 
 static struct genapic *apic_probe[] __initdata = {
+#ifdef CONFIG_NUMA
+	&apic_numaq,
+#endif
 	&apic_summit,
 	&apic_bigsmp,
 	&apic_es7000,
diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
index 89ec35d..88d6fcc 100644
--- a/arch/x86/pci/Makefile_32
+++ b/arch/x86/pci/Makefile_32
@@ -16,7 +16,13 @@ pci-y				+= legacy.o irq.o
 # Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
 # therefor correct. This needs a proper fix by distangling the code.
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
-pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
+
+ifeq ($(CONFIG_X86_NUMAQ), y)
+pci-y				:= numa.o irq.o
+endif
+ifeq ($(CONFIG_X86_GENERICARCH), y)
+pci-y				+= numa.o
+endif
 
 # Necessary for NUMAQ as well
 pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
index d9afbae..a4ff536 100644
--- a/arch/x86/pci/numa.c
+++ b/arch/x86/pci/numa.c
@@ -11,38 +11,18 @@
 #define XQUAD_PORTIO_BASE 0xfe400000
 #define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
 
-int mp_bus_id_to_node[MAX_MP_BUSSES];
+extern int mp_bus_id_to_node[MAX_MP_BUSSES];
 #define BUS2QUAD(global) (mp_bus_id_to_node[global])
 
-int mp_bus_id_to_local[MAX_MP_BUSSES];
+extern int mp_bus_id_to_local[MAX_MP_BUSSES];
 #define BUS2LOCAL(global) (mp_bus_id_to_local[global])
 
-void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
-	struct mpc_config_translation *translation)
-{
-	int quad = translation->trans_quad;
-	int local = translation->trans_local;
-
-	mp_bus_id_to_node[m->mpc_busid] = quad;
-	mp_bus_id_to_local[m->mpc_busid] = local;
-	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
-	       m->mpc_busid, name, quad);
-}
-
-int quad_local_to_mp_bus_id [NR_CPUS/4][4];
+extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];
 #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
-void mpc_oem_pci_bus(struct mpc_config_bus *m,
-	struct mpc_config_translation *translation)
-{
-	int quad = translation->trans_quad;
-	int local = translation->trans_local;
-
-	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
-}
 
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
 void *xquad_portio;
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 EXPORT_SYMBOL(xquad_portio);
 #endif
 
diff --git a/include/asm-x86/mach-generic/mach_apic.h b/include/asm-x86/mach-generic/mach_apic.h
index 6eff343..4a7c1af 100644
--- a/include/asm-x86/mach-generic/mach_apic.h
+++ b/include/asm-x86/mach-generic/mach_apic.h
@@ -27,6 +27,7 @@
 #define enable_apic_mode (genapic->enable_apic_mode)
 #define phys_pkg_id (genapic->phys_pkg_id)
 
+extern int found_numaq;
 extern void generic_bigsmp_probe(void);
 
 #endif /* __ASM_MACH_APIC_H */
diff --git a/include/asm-x86/mach-generic/mach_mpparse.h b/include/asm-x86/mach-generic/mach_mpparse.h
index 0d0b5ba..1f2d4cf 100644
--- a/include/asm-x86/mach-generic/mach_mpparse.h
+++ b/include/asm-x86/mach-generic/mach_mpparse.h
@@ -1,7 +1,6 @@
 #ifndef _MACH_MPPARSE_H
 #define _MACH_MPPARSE_H 1
 
-int mps_oem_check(struct mp_config_table *mpc, char *oem, char *productid); 
 int acpi_madt_oem_check(char *oem_id, char *oem_table_id); 
 
 #endif
diff --git a/include/asm-x86/mach-numaq/mach_apic.h b/include/asm-x86/mach-numaq/mach_apic.h
index 75a56e5..d802465 100644
--- a/include/asm-x86/mach-numaq/mach_apic.h
+++ b/include/asm-x86/mach-numaq/mach_apic.h
@@ -20,8 +20,14 @@ static inline cpumask_t target_cpus(void)
 #define INT_DELIVERY_MODE dest_LowestPrio
 #define INT_DEST_MODE 0     /* physical delivery on LOCAL quad */
  
-#define check_apicid_used(bitmap, apicid) physid_isset(apicid, bitmap)
-#define check_apicid_present(bit) physid_isset(bit, phys_cpu_present_map)
+static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return physid_isset(apicid, bitmap);
+}
+static inline unsigned long check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
 #define apicid_cluster(apicid) (apicid & 0xF0)
 
 static inline int apic_id_registered(void)
@@ -77,11 +83,6 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 		return BAD_APICID;
 }
 
-static inline int generate_logical_apicid(int quad, int phys_apicid)
-{
-	return (quad << 4) + (phys_apicid ? phys_apicid << 1 : 1);
-}
-
 static inline int apicid_to_node(int logical_apicid) 
 {
 	return logical_apicid >> 4;
@@ -95,30 +96,6 @@ static inline physid_mask_t apicid_to_cpu_present(int logical_apicid)
 	return physid_mask_of_physid(cpu + 4*node);
 }
 
-struct mpc_config_translation {
-	unsigned char mpc_type;
-	unsigned char trans_len;
-	unsigned char trans_type;
-	unsigned char trans_quad;
-	unsigned char trans_global;
-	unsigned char trans_local;
-	unsigned short trans_reserved;
-};
-
-static inline int mpc_apic_id(struct mpc_config_processor *m, 
-			struct mpc_config_translation *translation_record)
-{
-	int quad = translation_record->trans_quad;
-	int logical_apicid = generate_logical_apicid(quad, m->mpc_apicid);
-
-	printk("Processor #%d %u:%u APIC version %d (quad %d, apic %d)\n",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver, quad, logical_apicid);
-	return logical_apicid;
-}
-
 extern void *xquad_portio;
 
 static inline void setup_portio_remap(void)
diff --git a/include/asm-x86/mach-numaq/mach_mpparse.h b/include/asm-x86/mach-numaq/mach_mpparse.h
index 459b124..e0bab65 100644
--- a/include/asm-x86/mach-numaq/mach_mpparse.h
+++ b/include/asm-x86/mach-numaq/mach_mpparse.h
@@ -1,11 +1,6 @@
 #ifndef __ASM_MACH_MPPARSE_H
 #define __ASM_MACH_MPPARSE_H
 
-extern void mpc_oem_bus_info(struct mpc_config_bus *m, char *name,
-			     struct mpc_config_translation *translation);
-extern void mpc_oem_pci_bus(struct mpc_config_bus *m,
-	struct mpc_config_translation *translation);
-
 /* Hook from generic ACPI tables.c */
 static inline void acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
diff --git a/include/asm-x86/mmzone_32.h b/include/asm-x86/mmzone_32.h
index ab00128..9c56ba9 100644
--- a/include/asm-x86/mmzone_32.h
+++ b/include/asm-x86/mmzone_32.h
@@ -12,9 +12,10 @@
 extern struct pglist_data *node_data[];
 #define NODE_DATA(nid)	(node_data[nid])
 
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 	#include <asm/numaq.h>
-#elif defined(CONFIG_ACPI_SRAT)/* summit or generic arch */
+#endif
+#if defined(CONFIG_ACPI_SRAT)/* summit or generic arch */
 	#include <asm/srat.h>
 #endif
 
@@ -26,10 +27,12 @@ extern int get_memcfg_numa_flat(void);
  */
 static inline void get_memcfg_numa(void)
 {
-#ifdef CONFIG_X86_NUMAQ
+
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 	if (get_memcfg_numaq())
 		return;
-#elif defined(CONFIG_ACPI_SRAT)
+#endif
+#if defined(CONFIG_ACPI_SRAT)
 	if (get_memcfg_from_srat())
 		return;
 #endif
@@ -42,7 +45,6 @@ extern int early_pfn_to_nid(unsigned long pfn);
 #else /* !CONFIG_NUMA */
 
 #define get_memcfg_numa get_memcfg_numa_flat
-#define get_zholes_size(n) (0)
 
 #endif /* CONFIG_NUMA */
 
@@ -83,9 +85,6 @@ static inline int pfn_to_nid(unsigned long pfn)
 	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
 })
 
-#ifdef CONFIG_X86_NUMAQ            /* we have contiguous memory on NUMA-Q */
-#define pfn_valid(pfn)          ((pfn) < num_physpages)
-#else
 static inline int pfn_valid(int pfn)
 {
 	int nid = pfn_to_nid(pfn);
@@ -94,7 +93,6 @@ static inline int pfn_valid(int pfn)
 		return (pfn < node_end_pfn(nid));
 	return 0;
 }
-#endif /* CONFIG_X86_NUMAQ */
 
 #endif /* CONFIG_DISCONTIGMEM */
 
diff --git a/include/asm-x86/numaq.h b/include/asm-x86/numaq.h
index 739d164..76e0b13 100644
--- a/include/asm-x86/numaq.h
+++ b/include/asm-x86/numaq.h
@@ -26,7 +26,7 @@
 #ifndef NUMAQ_H
 #define NUMAQ_H
 
-#ifdef CONFIG_X86_NUMAQ
+#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
 
 extern int found_numaq;
 extern int get_memcfg_numaq(void);
@@ -157,10 +157,6 @@ struct sys_cfg_data {
 	struct		eachquadmem eq[MAX_NUMNODES];	/* indexed by quad id */
 };
 
-static inline unsigned long *get_zholes_size(int nid)
-{
-	return NULL;
-}
-#endif /* CONFIG_X86_NUMAQ */
+#endif /* CONFIG_X86_NUMAQ || CONFIG_X86_GENERICARCH */
 #endif /* NUMAQ_H */
 
diff --git a/include/asm-x86/srat.h b/include/asm-x86/srat.h
index f4bba13..ad1f502 100644
--- a/include/asm-x86/srat.h
+++ b/include/asm-x86/srat.h
@@ -32,6 +32,5 @@
 #endif
 
 extern int get_memcfg_from_srat(void);
-extern unsigned long *get_zholes_size(int);
 
 #endif /* _ASM_SRAT_H_ */
--- /dev/null	2007-09-21 12:12:45.000000000 -0700
+++ b/arch/x86/mach-generic/numaq.c	2008-06-05 00:11:51.000000000 -0700
@@ -0,0 +1,35 @@
+/*
+ * APIC driver for the IBM NUMAQ chipset.
+ */
+#define APIC_DEFINITION 1
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <asm/smp.h>
+#include <asm/mpspec.h>
+#include <asm/genapic.h>
+#include <asm/fixmap.h>
+#include <asm/apicdef.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <asm/mach-numaq/mach_apic.h>
+#include <asm/mach-numaq/mach_apicdef.h>
+#include <asm/mach-numaq/mach_ipi.h>
+#include <asm/mach-numaq/mach_mpparse.h>
+#include <asm/mach-numaq/mach_wakecpu.h>
+#include <asm/numaq.h>
+
+static int mps_oem_check(struct mp_config_table *mpc, char *oem,
+		char *productid)
+{
+	return 0;
+}
+
+static int probe_numaq(void)
+{
+	/* already know from get_memcfg_numaq() */
+	return found_numaq;
+}
+
+struct genapic apic_numaq = APIC_INIT("NUMAQ", probe_numaq);
