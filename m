Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbZKXKtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbZKXKtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932729AbZKXKtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:49:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:48505 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728AbZKXKtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:49:18 -0500
Message-ID: <4B0BB9F2.70907@kernel.org>
Date: Tue, 24 Nov 2009 02:48:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move find_smp_config early -v2
References: <4B0900D8.80606@kernel.org>
In-Reply-To: <4B0900D8.80606@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


move find_smp_config calling before bootmem initialized.
use reserve_early instead of reserve_bootmem in it.

so could only call find_smp_config one time and remove unneeded reserve parameter

-v2: make it could be applied to tip after crash_kernel early patch

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h   |   11 ++--------
 arch/x86/include/asm/x86_init.h |    2 -
 arch/x86/kernel/apic/numaq_32.c |    5 ----
 arch/x86/kernel/mpparse.c       |   44 ++++++++++------------------------------
 arch/x86/kernel/setup.c         |   10 ++++-----
 arch/x86/kernel/visws_quirks.c  |    2 -
 arch/x86/mm/k8topology_64.c     |   12 ----------
 7 files changed, 22 insertions(+), 64 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -71,12 +71,7 @@ static inline void early_get_smp_config(
 
 static inline void find_smp_config(void)
 {
-	x86_init.mpparse.find_smp_config(1);
-}
-
-static inline void early_find_smp_config(void)
-{
-	x86_init.mpparse.find_smp_config(0);
+	x86_init.mpparse.find_smp_config();
 }
 
 #ifdef CONFIG_X86_MPPARSE
@@ -89,7 +84,7 @@ extern void default_mpc_oem_bus_info(str
 # else
 #  define default_mpc_oem_bus_info NULL
 # endif
-extern void default_find_smp_config(unsigned int reserve);
+extern void default_find_smp_config(void);
 extern void default_get_smp_config(unsigned int early);
 #else
 static inline void early_reserve_e820_mpc_new(void) { }
@@ -97,7 +92,7 @@ static inline void early_reserve_e820_mp
 #define default_mpc_apic_id NULL
 #define default_smp_read_mpc_oem NULL
 #define default_mpc_oem_bus_info NULL
-#define default_find_smp_config x86_init_uint_noop
+#define default_find_smp_config x86_init_noop
 #define default_get_smp_config x86_init_uint_noop
 #endif
 
Index: linux-2.6/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6/arch/x86/include/asm/x86_init.h
@@ -26,7 +26,7 @@ struct x86_init_mpparse {
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
-	void (*find_smp_config)(unsigned int reserve);
+	void (*find_smp_config)(void);
 	void (*get_smp_config)(unsigned int early);
 };
 
Index: linux-2.6/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/numaq_32.c
+++ linux-2.6/arch/x86/kernel/apic/numaq_32.c
@@ -264,11 +264,6 @@ static void __init smp_read_mpc_oem(stru
 static __init void early_check_numaq(void)
 {
 	/*
-	 * Find possible boot-time SMP configuration:
-	 */
-	early_find_smp_config();
-
-	/*
 	 * get boot-time SMP configuration:
 	 */
 	if (smp_found_config)
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -667,36 +667,18 @@ void __init default_get_smp_config(unsig
 	 */
 }
 
-static void __init smp_reserve_bootmem(struct mpf_intel *mpf)
+static void __init smp_reserve_memory(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
-#ifdef CONFIG_X86_32
-	/*
-	 * We cannot access to MPC table to compute table size yet,
-	 * as only few megabytes from the bottom is mapped now.
-	 * PC-9800's MPC table places on the very last of physical
-	 * memory; so that simply reserving PAGE_SIZE from mpf->physptr
-	 * yields BUG() in reserve_bootmem.
-	 * also need to make sure physptr is below than max_low_pfn
-	 * we don't need reserve the area above max_low_pfn
-	 */
-	unsigned long end = max_low_pfn * PAGE_SIZE;
 
-	if (mpf->physptr < end) {
-		if (mpf->physptr + size > end)
-			size = end - mpf->physptr;
-		reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
-	}
-#else
-	reserve_bootmem_generic(mpf->physptr, size, BOOTMEM_DEFAULT);
-#endif
+	reserve_early(mpf->physptr, mpf->physptr+size, "MP-table mpc");
 }
 
-static int __init smp_scan_config(unsigned long base, unsigned long length,
-				  unsigned reserve)
+static int __init smp_scan_config(unsigned long base, unsigned long length)
 {
 	unsigned int *bp = phys_to_virt(base);
 	struct mpf_intel *mpf;
+	unsigned long mem;
 
 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
 			bp, length);
@@ -717,12 +699,10 @@ static int __init smp_scan_config(unsign
 			printk(KERN_INFO "found SMP MP-table at [%p] %llx\n",
 			       mpf, (u64)virt_to_phys(mpf));
 
-			if (!reserve)
-				return 1;
-			reserve_bootmem_generic(virt_to_phys(mpf), sizeof(*mpf),
-						BOOTMEM_DEFAULT);
+			mem = virt_to_phys(mpf);
+			reserve_early(mem, mem + sizeof(*mpf), "MP-table mpf");
 			if (mpf->physptr)
-				smp_reserve_bootmem(mpf);
+				smp_reserve_memory(mpf);
 
 			return 1;
 		}
@@ -732,7 +712,7 @@ static int __init smp_scan_config(unsign
 	return 0;
 }
 
-void __init default_find_smp_config(unsigned int reserve)
+void __init default_find_smp_config(void)
 {
 	unsigned int address;
 
@@ -744,9 +724,9 @@ void __init default_find_smp_config(unsi
 	 * 2) Scan the top 1K of base RAM
 	 * 3) Scan the 64K of bios
 	 */
-	if (smp_scan_config(0x0, 0x400, reserve) ||
-	    smp_scan_config(639 * 0x400, 0x400, reserve) ||
-	    smp_scan_config(0xF0000, 0x10000, reserve))
+	if (smp_scan_config(0x0, 0x400) ||
+	    smp_scan_config(639 * 0x400, 0x400) ||
+	    smp_scan_config(0xF0000, 0x10000))
 		return;
 	/*
 	 * If it is an SMP machine we should know now, unless the
@@ -767,7 +747,7 @@ void __init default_find_smp_config(unsi
 
 	address = get_bios_ebda();
 	if (address)
-		smp_scan_config(address, 0x400, reserve);
+		smp_scan_config(address, 0x400);
 }
 
 #ifdef CONFIG_X86_IO_APIC
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -921,6 +921,11 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
@@ -935,11 +940,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
-
 #ifdef CONFIG_X86_64
 	/*
 	 * dma32_reserve_bootmem() allocates bootmem which may conflict
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -197,7 +197,7 @@ static void __init MP_processor_info(str
 	apic_version[m->apicid] = ver;
 }
 
-static void __init visws_find_smp_config(unsigned int reserve)
+static void __init visws_find_smp_config(void)
 {
 	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
Index: linux-2.6/arch/x86/mm/k8topology_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/k8topology_64.c
+++ linux-2.6/arch/x86/mm/k8topology_64.c
@@ -57,18 +57,6 @@ static __init void early_get_boot_cpu_id
 	 * need to get boot_cpu_id so can use that to create apicid_to_node
 	 * in k8_scan_nodes()
 	 */
-	/*
-	 * Find possible boot-time SMP configuration:
-	 */
-#ifdef CONFIG_X86_MPPARSE
-	early_find_smp_config();
-#endif
-#ifdef CONFIG_ACPI
-	/*
-	 * Read APIC information from ACPI tables.
-	 */
-	early_acpi_boot_init();
-#endif
 #ifdef CONFIG_X86_MPPARSE
 	/*
 	 * get boot-time SMP configuration:
