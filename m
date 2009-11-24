Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbZKXQ5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbZKXQ5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933576AbZKXQ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:57:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:60260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933545AbZKXQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:56:59 -0500
Date: Tue, 24 Nov 2009 16:56:22 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B0BB9F2.70907@kernel.org>
References: <4B0BB9F2.70907@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Move find_smp_config() earlier and avoid bootmem usage
Message-ID: <tip-b24c2a925a9837cccf54d50aeac22ba0cbc15455@git.kernel.org>
Git-Commit-ID: b24c2a925a9837cccf54d50aeac22ba0cbc15455
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b24c2a925a9837cccf54d50aeac22ba0cbc15455
Gitweb:     http://git.kernel.org/tip/b24c2a925a9837cccf54d50aeac22ba0cbc15455
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 24 Nov 2009 02:48:18 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 12:10:51 +0100

x86: Move find_smp_config() earlier and avoid bootmem usage

Move the find_smp_config() call to before bootmem is initialized.
Use reserve_early() instead of reserve_bootmem() in it.

This simplifies the code, we only need to call find_smp_config()
once and can remove the now unneeded reserve parameter from
x86_init_mpparse::find_smp_config.

We thus also reduce x86's dependency on bootmem allocations.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B0BB9F2.70907@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mpspec.h   |   11 ++-------
 arch/x86/include/asm/x86_init.h |    2 +-
 arch/x86/kernel/apic/numaq_32.c |    5 ----
 arch/x86/kernel/mpparse.c       |   44 ++++++++++----------------------------
 arch/x86/kernel/setup.c         |   10 ++++----
 arch/x86/kernel/visws_quirks.c  |    2 +-
 arch/x86/mm/k8topology_64.c     |   12 ----------
 7 files changed, 22 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 79c9450..644cf1a 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -71,12 +71,7 @@ static inline void early_get_smp_config(void)
 
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
@@ -89,7 +84,7 @@ extern void default_mpc_oem_bus_info(struct mpc_bus *m, char *str);
 # else
 #  define default_mpc_oem_bus_info NULL
 # endif
-extern void default_find_smp_config(unsigned int reserve);
+extern void default_find_smp_config(void);
 extern void default_get_smp_config(unsigned int early);
 #else
 static inline void early_reserve_e820_mpc_new(void) { }
@@ -97,7 +92,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #define default_mpc_apic_id NULL
 #define default_smp_read_mpc_oem NULL
 #define default_mpc_oem_bus_info NULL
-#define default_find_smp_config x86_init_uint_noop
+#define default_find_smp_config x86_init_noop
 #define default_get_smp_config x86_init_uint_noop
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 024cf3c..97e5fb4 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -26,7 +26,7 @@ struct x86_init_mpparse {
 	void (*smp_read_mpc_oem)(struct mpc_table *mpc);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
-	void (*find_smp_config)(unsigned int reserve);
+	void (*find_smp_config)(void);
 	void (*get_smp_config)(unsigned int early);
 };
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index efa00e2..9c0629c 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -264,11 +264,6 @@ static void __init smp_read_mpc_oem(struct mpc_table *mpc)
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
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5be95ef..35a57c9 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -667,36 +667,18 @@ void __init default_get_smp_config(unsigned int early)
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
@@ -717,12 +699,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
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
@@ -732,7 +712,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	return 0;
 }
 
-void __init default_find_smp_config(unsigned int reserve)
+void __init default_find_smp_config(void)
 {
 	unsigned int address;
 
@@ -744,9 +724,9 @@ void __init default_find_smp_config(unsigned int reserve)
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
@@ -767,7 +747,7 @@ void __init default_find_smp_config(unsigned int reserve)
 
 	address = get_bios_ebda();
 	if (address)
-		smp_scan_config(address, 0x400, reserve);
+		smp_scan_config(address, 0x400);
 }
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e3eae59..cdb6a8a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -913,6 +913,11 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
@@ -927,11 +932,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
-
 #ifdef CONFIG_X86_64
 	/*
 	 * dma32_reserve_bootmem() allocates bootmem which may conflict
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index f068553..1498efa 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -197,7 +197,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	apic_version[m->apicid] = ver;
 }
 
-static void __init visws_find_smp_config(unsigned int reserve)
+static void __init visws_find_smp_config(void)
 {
 	struct mpc_cpu *mp = phys_to_virt(CO_CPU_TAB_PHYS);
 	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index b9e2dbf..970ed57 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -57,18 +57,6 @@ static __init void early_get_boot_cpu_id(void)
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
