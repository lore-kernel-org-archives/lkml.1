Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbZCaFPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbZCaFPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZCaFO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:14:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:15043 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762072AbZCaFOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:14:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,450,1233561600"; 
   d="scan'208";a="677385853"
Message-ID: <49D1A6AB.5090808@intel.com>
Date: Mon, 30 Mar 2009 22:14:19 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, arjan@linux.intel.com, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       joseph.cihula@intel.com, gang.wei@intel.com, shane.wang@intel.com
Subject: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux support for Intel(R) Trusted Execution Technology.

 arch/x86/configs/i386_defconfig   |    1
 arch/x86/configs/x86_64_defconfig |    1
 arch/x86/include/asm/bootparam.h  |    1
 arch/x86/include/asm/fixmap.h     |    3
 arch/x86/include/asm/tboot.h      |  152 +++++++++++++++
 arch/x86/kernel/Makefile          |    1
 arch/x86/kernel/reboot.c          |   18 +
 arch/x86/kernel/setup.c           |    4
 arch/x86/kernel/smpboot.c         |    6
 arch/x86/kernel/tboot.c           |  371 ++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/hwsleep.c     |   34 +++
 drivers/acpi/sleep.c              |    3
 drivers/pci/dmar.c                |    6
 kernel/cpu.c                      |    6
 kernel/power/disk.c               |    2
 security/Kconfig                  |   17 +
 16 files changed, 622 insertions(+), 4 deletions(-)

Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by:  Gang Wei <gang.wei@intel.com>

---

diff -uprN ../linux.trees.git/arch/x86/configs/i386_defconfig ./arch/x86/configs/i386_defconfig
--- ../linux.trees.git/arch/x86/configs/i386_defconfig	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/configs/i386_defconfig	2009-03-30 13:03:26.000000000 -0700
@@ -51,6 +51,7 @@ CONFIG_X86_BIOS_REBOOT=y
 CONFIG_X86_TRAMPOLINE=y
 CONFIG_KTIME_SCALAR=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+# CONFIG_INTEL_TXT is not set
 
 #
 # General setup
diff -uprN ../linux.trees.git/arch/x86/configs/x86_64_defconfig ./arch/x86/configs/x86_64_defconfig
--- ../linux.trees.git/arch/x86/configs/x86_64_defconfig	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/configs/x86_64_defconfig	2009-03-30 13:03:26.000000000 -0700
@@ -52,6 +52,7 @@ CONFIG_X86_BIOS_REBOOT=y
 CONFIG_X86_TRAMPOLINE=y
 # CONFIG_KTIME_SCALAR is not set
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+# CONFIG_INTEL_TXT is not set
 
 #
 # General setup
diff -uprN ../linux.trees.git/arch/x86/include/asm/bootparam.h ./arch/x86/include/asm/bootparam.h
--- ../linux.trees.git/arch/x86/include/asm/bootparam.h	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/include/asm/bootparam.h	2009-03-30 13:03:25.000000000 -0700
@@ -62,6 +62,7 @@ struct setup_header {
 	__u32	payload_offset;
 	__u32	payload_length;
 	__u64	setup_data;
+	__u32   tboot_shared_addr;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff -uprN ../linux.trees.git/arch/x86/include/asm/fixmap.h ./arch/x86/include/asm/fixmap.h
--- ../linux.trees.git/arch/x86/include/asm/fixmap.h	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/include/asm/fixmap.h	2009-03-30 13:03:25.000000000 -0700
@@ -132,6 +132,9 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif
+#ifdef CONFIG_INTEL_TXT
+	FIX_TBOOT_SHARED_BASE,
+#endif
 	__end_of_fixed_addresses
 };
 
diff -uprN ../linux.trees.git/arch/x86/include/asm/tboot.h ./arch/x86/include/asm/tboot.h
--- ../linux.trees.git/arch/x86/include/asm/tboot.h	1969-12-31 16:00:00.000000000 -0800
+++ ./arch/x86/include/asm/tboot.h	2009-03-30 13:03:26.000000000 -0700
@@ -0,0 +1,152 @@
+/*
+ * tboot.h: shared data structure with tboot and kernel and functions
+ *          used by kernel for runtime support of Intel(R) Trusted
+ *          Execution Technology
+ *
+ * Copyright (c) 2006-2009, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef _ASM_TBOOT_H
+#define _ASM_TBOOT_H
+
+#include <acpi/acpi.h>
+
+#define TB_SHUTDOWN_REBOOT      0
+#define TB_SHUTDOWN_S5          1
+#define TB_SHUTDOWN_S4          2
+#define TB_SHUTDOWN_S3          3
+#define TB_SHUTDOWN_HALT        4
+#define TB_SHUTDOWN_WFS         5
+
+#ifdef CONFIG_INTEL_TXT
+
+struct tboot_uuid {
+	u32    data1;
+	u16    data2;
+	u16    data3;
+	u16    data4;
+	u8     data5[6];
+} __attribute__ ((__packed__));
+
+/* used to communicate between tboot and the launched kernel */
+
+#define TB_KEY_SIZE             64   /* 512 bits */
+
+#define MAX_TB_MAC_REGIONS      32
+struct tboot_mac_region {
+  u64  start;         /* must be 64 byte -aligned */
+  u32  size;          /* must be 64 byte -granular */
+} __attribute__ ((__packed__));
+
+/* GAS - Generic Address Structure (ACPI 2.0+) */
+struct tboot_acpi_generic_address {
+  u8  space_id;
+  u8  bit_width;
+  u8  bit_offset;
+  u8  access_width;
+  u64 address;
+} __attribute__ ((__packed__));
+
+struct tboot_acpi_sleep_info {
+  struct tboot_acpi_generic_address pm1a_cnt_blk;
+  struct tboot_acpi_generic_address pm1b_cnt_blk;
+  struct tboot_acpi_generic_address pm1a_evt_blk;
+  struct tboot_acpi_generic_address pm1b_evt_blk;
+  u16 pm1a_cnt_val;
+  u16 pm1b_cnt_val;
+  u64 wakeup_vector;
+  u32 vector_width;
+  u64 kernel_s3_resume_vector;
+} __attribute__ ((__packed__));
+
+struct tboot_shared {
+	/* version 3+ fields: */
+	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
+	u32  version;      	/* Version number: 5 is current */
+	u32  log_addr;     	/* physical addr of tb_log_t log */
+	u32  shutdown_entry;	/* entry point for tboot shutdown */
+	u32  shutdown_type;	/* type of shutdown (TB_SHUTDOWN_*) */
+	struct tboot_acpi_sleep_info
+		  acpi_sinfo;	/* where kernel put acpi sleep info in Sx */
+	u32  tboot_base;	/* starting addr for tboot */
+	u32  tboot_size;	/* size of tboot */
+	u8   num_mac_regions;   /* number mem regions to MAC on S3 */
+				/* contig regions memory to MAC on S3 */
+	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
+	/* version 4+ fields: */
+				/* populated by tboot; will be encrypted */
+	u8   s3_key[TB_KEY_SIZE];
+	/* version 5+ fields: */
+	u8   reserved_align[3]; /* used to 4byte-align num_in_wfs */
+	u32  num_in_wfs;        /* number of processors in wait-for-SIPI */
+} __attribute__ ((__packed__));
+
+/* UUID for tboot_shared data struct to facilitate matching */
+/* {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} */
+#define TBOOT_SHARED_UUID     \
+		((struct tboot_uuid){ 0x663c8dff, 0xe8b3, 0x4b82, 0xaabf,   \
+				{ 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8 } })
+
+extern struct tboot_shared *tboot_shared;
+
+static inline int tboot_in_measured_env(void)
+{
+	return tboot_shared != NULL;
+}
+
+extern void tboot_probe(void);
+extern void tboot_shutdown(u32 shutdown_type);
+extern void tboot_sleep(u8 sleep_state);
+extern void tboot_wait_for_aps(int num_aps);
+extern void tboot_sx_resume(u32 state);
+extern struct acpi_table_header *tboot_get_dmar_table(void);
+
+#else     /* CONFIG_INTEL_TXT */
+
+static inline int tboot_in_measured_env(void)
+{
+	return 0;
+}
+
+static inline void tboot_probe(void)
+{
+}
+
+static inline void tboot_shutdown(u32 shutdown_type)
+{
+}
+
+static inline void tboot_sleep(u8 sleep_state)
+{
+}
+
+static inline void tboot_wait_for_aps(int num_aps)
+{
+}
+
+static inline void tboot_sx_resume(u32 state)
+{
+}
+
+static inline struct acpi_table_header *tboot_get_dmar_table(void)
+{
+	return NULL;
+}
+
+#endif /* !CONFIG_INTEL_TXT */
+
+#endif /* _ASM_TBOOT_H */
diff -uprN ../linux.trees.git/arch/x86/kernel/Makefile ./arch/x86/kernel/Makefile
--- ../linux.trees.git/arch/x86/kernel/Makefile	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/kernel/Makefile	2009-03-30 13:03:25.000000000 -0700
@@ -47,6 +47,7 @@ obj-$(CONFIG_X86_DS)		+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
+obj-$(CONFIG_INTEL_TXT)		+= tboot.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff -uprN ../linux.trees.git/arch/x86/kernel/reboot.c ./arch/x86/kernel/reboot.c
--- ../linux.trees.git/arch/x86/kernel/reboot.c	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/kernel/reboot.c	2009-03-30 13:03:25.000000000 -0700
@@ -24,6 +24,8 @@
 # include <asm/iommu.h>
 #endif
 
+#include <asm/tboot.h>
+
 /*
  * Power off function, if any
  */
@@ -435,6 +437,8 @@ static void native_machine_emergency_res
 	if (reboot_emergency)
 		emergency_vmx_disable_all();
 
+	tboot_shutdown(TB_SHUTDOWN_REBOOT);
+
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
@@ -500,11 +504,17 @@ static void native_machine_emergency_res
 
 void native_machine_shutdown(void)
 {
-	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
+#endif
+
+	/* TXT requires VMX to be off for all shutdowns */
+	if (tboot_in_measured_env())
+		emergency_vmx_disable_all();
+
+	/* Stop the cpus and apics */
+#ifdef CONFIG_SMP
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
@@ -561,6 +571,8 @@ static void native_machine_halt(void)
 	/* stop other cpus and apics */
 	machine_shutdown();
 
+	tboot_shutdown(TB_SHUTDOWN_HALT);
+
 	/* stop this cpu */
 	stop_this_cpu(NULL);
 }
@@ -572,6 +584,8 @@ static void native_machine_power_off(voi
 			machine_shutdown();
 		pm_power_off();
 	}
+	/* a fallback in case there is no PM info available */
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
 struct machine_ops machine_ops = {
diff -uprN ../linux.trees.git/arch/x86/kernel/setup.c ./arch/x86/kernel/setup.c
--- ../linux.trees.git/arch/x86/kernel/setup.c	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/kernel/setup.c	2009-03-30 13:03:25.000000000 -0700
@@ -137,6 +137,8 @@ struct boot_params __initdata boot_param
 struct boot_params boot_params;
 #endif
 
+#include <asm/tboot.h>
+
 /*
  * Machine setup..
  */
@@ -940,6 +942,8 @@ void __init setup_arch(char **cmdline_p)
 	paravirt_pagetable_setup_done(swapper_pg_dir);
 	paravirt_post_allocator_init();
 
+	tboot_probe();
+
 #ifdef CONFIG_X86_64
 	map_vsyscall();
 #endif
diff -uprN ../linux.trees.git/arch/x86/kernel/smpboot.c ./arch/x86/kernel/smpboot.c
--- ../linux.trees.git/arch/x86/kernel/smpboot.c	2009-03-29 12:12:13.000000000 -0700
+++ ./arch/x86/kernel/smpboot.c	2009-03-30 13:03:25.000000000 -0700
@@ -62,6 +62,7 @@
 #include <asm/vmi.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
+#include <asm/tboot.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
 
@@ -1313,7 +1314,10 @@ void play_dead_common(void)
 void native_play_dead(void)
 {
 	play_dead_common();
-	wbinvd_halt();
+	if (tboot_in_measured_env())
+		tboot_shutdown(TB_SHUTDOWN_WFS);
+	else
+		wbinvd_halt();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
diff -uprN ../linux.trees.git/arch/x86/kernel/tboot.c ./arch/x86/kernel/tboot.c
--- ../linux.trees.git/arch/x86/kernel/tboot.c	1969-12-31 16:00:00.000000000 -0800
+++ ./arch/x86/kernel/tboot.c	2009-03-30 13:03:25.000000000 -0700
@@ -0,0 +1,371 @@
+/*
+ * tboot.c: main implementation of helper functions used by kernel for
+ *          runtime support of Intel(R) Trusted Execution Technology
+ *
+ * Copyright (c) 2006-2009, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/pfn.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/init_task.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/processor.h>
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/tboot.h>
+
+/* Global pointer to shared data; NULL means no measured launch. */
+struct tboot_shared *tboot_shared;
+
+static spinlock_t pgtable_lock;
+
+void __init tboot_probe(void)
+{
+	/* Look for valid page-aligned address for shared page. */
+	if (boot_params.hdr.tboot_shared_addr == 0)
+		return;
+
+	/* Map and check for tboot UUID. */
+	set_fixmap(FIX_TBOOT_SHARED_BASE, boot_params.hdr.tboot_shared_addr);
+	tboot_shared = (struct tboot_shared *)
+				fix_to_virt(FIX_TBOOT_SHARED_BASE);
+	if (memcmp(&TBOOT_SHARED_UUID, &tboot_shared->uuid,
+		   sizeof(struct tboot_uuid))) {
+		printk(KERN_WARNING "tboot_shared at 0x%lx is invalid\n",
+		       (unsigned long)boot_params.hdr.tboot_shared_addr);
+		tboot_shared = NULL;
+		return;
+	}
+	if (tboot_shared->version < 5) {
+		printk(KERN_WARNING "tboot_shared version is invalid: %u\n",
+		       tboot_shared->version);
+		tboot_shared = NULL;
+		return;
+	}
+
+	spin_lock_init(&pgtable_lock);
+
+	printk(KERN_INFO "TBOOT: found shared page at phys addr 0x%lx:\n",
+	       (unsigned long)boot_params.hdr.tboot_shared_addr);
+	printk(KERN_DEBUG "  version: %d\n", tboot_shared->version);
+	printk(KERN_DEBUG "  log_addr: 0x%08x\n", tboot_shared->log_addr);
+	printk(KERN_DEBUG "  shutdown_entry: 0x%x\n",
+	       tboot_shared->shutdown_entry);
+	printk(KERN_DEBUG "  tboot_base: 0x%08x\n", tboot_shared->tboot_base);
+	printk(KERN_DEBUG "  tboot_size: 0x%x\n", tboot_shared->tboot_size);
+}
+
+static pgd_t *tboot_pg_dir;
+static u32 map_base, map_size;
+static struct mm_struct tboot_mm = INIT_MM(tboot_mm);
+
+static inline void switch_to_tboot_pt(void)
+{
+	wbinvd();
+	native_write_cr3(virt_to_phys(tboot_pg_dir));
+}
+
+static void clean_up_tboot_mapping(void)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	unsigned long vaddr, i, j;
+
+	if (!tboot_in_measured_env())
+		return;
+
+	/* The following loop is to release the pages allocated for building
+	 * tboot page table. It releases pte pages, then pmd pages, then pud
+	 * pages and finally the pgd page by using variable i to control
+	 * the process, where
+	 *  i = 0 denotes to release pte,
+	 *  i = 1 denotes to release pmd,
+	 *  i = 2 denotes to release pud,
+	 *  and i > 2 denotes to release pgd
+	 */
+	i = 0;
+	while (tboot_pg_dir) {
+		for (j = 0, vaddr = map_base << PAGE_SHIFT;
+		     j < map_size;
+		     j++, vaddr += PAGE_SIZE) {
+			if (i > 2) {
+				if (tboot_pg_dir)
+					pgd_free(&tboot_mm, tboot_pg_dir);
+				tboot_pg_dir = 0;
+				break;
+			} else {
+				pgd = pgd_offset(&tboot_mm, vaddr);
+				if ((!pgd) || (!pgd_present(*pgd)))
+					continue;
+			}
+
+			if (i == 2) {
+				/* release pud */
+				pud = pud_offset(pgd, 0);
+				if (pud)
+					pud_free(&tboot_mm, pud);
+				pgd_clear(pgd);
+				continue;
+			} else {
+				pud = pud_offset(pgd, vaddr);
+				if ((!pud) || (!pud_present(*pud)))
+					continue;
+			}
+
+			if (i == 1) {
+				/* release pmd */
+				pmd = pmd_offset(pud, 0);
+				if (pmd)
+					pmd_free(&tboot_mm, pmd);
+				pud_clear(pud);
+				continue;
+			}
+
+			pmd = pmd_offset(pud, vaddr);
+			if ((!pmd) || (!pmd_present(*pmd)))
+				continue;
+
+			/* release pte */
+			pte = pte_offset_kernel(pmd, 0);
+			if (pte)
+				pte_free_kernel(&tboot_mm, pte);
+			pmd_clear(pmd);
+		}
+		i++;
+	}
+}
+
+static int map_page_for_tboot(unsigned long vaddr, unsigned long pfn,
+			      pgprot_t prot)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(&tboot_mm, vaddr);
+	pud = pud_alloc(&tboot_mm, pgd, vaddr);
+	if (!pud)
+		return -1;
+	pmd = pmd_alloc(&tboot_mm, pud, vaddr);
+	if (!pmd)
+		return -1;
+	pte = pte_alloc_map(&tboot_mm, pmd, vaddr);
+	if (!pte)
+		return -1;
+	set_pte_at(&tboot_mm, vaddr, pte, pfn_pte(pfn, prot));
+	pte_unmap(pte);
+	return 0;
+}
+
+static int map_pages_for_tboot(unsigned long vaddr, unsigned long start_pfn,
+			       unsigned long nr)
+{
+	/* Reuse the original kernel mapping */
+	tboot_pg_dir = pgd_alloc(&tboot_mm);
+	if (!tboot_pg_dir)
+		return -1;
+
+	for (; nr > 0; nr--, vaddr += PAGE_SIZE, start_pfn++) {
+		if (map_page_for_tboot(vaddr, start_pfn, PAGE_KERNEL_EXEC))
+			return -1;
+	}
+
+	return 0;
+}
+
+#include "acpi/realmode/wakeup.h"
+#include <asm/trampoline.h>
+
+void tboot_shutdown(u32 shutdown_type)
+{
+	if (!tboot_in_measured_env())
+		return;
+
+	/* only create the table once */
+	spin_lock(&pgtable_lock);
+	if (!tboot_pg_dir) {
+		/* page alloc routines need interrupts enabled else they */
+		/* generate debug warnings; we'll disable them afterwards */
+		local_irq_enable();
+
+		/* Create identity map for tboot shutdown code. */
+		map_base = PFN_DOWN(tboot_shared->tboot_base);
+		map_size = PFN_UP(tboot_shared->tboot_size);
+		if (map_pages_for_tboot(map_base << PAGE_SHIFT, map_base,
+					map_size)) {
+			printk(KERN_WARNING "error mapping tboot pages (mfns)"
+			       " @ 0x%x, 0x%x\n", map_base, map_size);
+			clean_up_tboot_mapping();
+			BUG();
+		}
+	}
+	spin_unlock(&pgtable_lock);
+
+	local_irq_disable();
+
+	/* if this is S3 then set regions to MAC */
+	if (shutdown_type == TB_SHUTDOWN_S3) {
+		tboot_shared->num_mac_regions = 3;
+		/* S3 resume code */
+		tboot_shared->mac_regions[0].start =
+			PFN_PHYS(PFN_DOWN(acpi_wakeup_address));
+		tboot_shared->mac_regions[0].size =
+			PFN_UP(WAKEUP_SIZE) << PAGE_SHIFT;
+		/* AP trampoline code */
+		tboot_shared->mac_regions[1].start =
+			PFN_PHYS(PFN_DOWN(virt_to_phys(trampoline_base)));
+		tboot_shared->mac_regions[1].size =
+			PFN_UP(TRAMPOLINE_SIZE) << PAGE_SHIFT;
+		/* kernel code + data + bss */
+		tboot_shared->mac_regions[2].start =
+			PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
+		tboot_shared->mac_regions[2].size =
+			PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
+			PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
+	}
+
+	tboot_shared->shutdown_type = shutdown_type;
+
+	switch_to_tboot_pt();
+
+	((void(*)(void))(unsigned long)tboot_shared->shutdown_entry)();
+
+	BUG(); /* should not reach here */
+}
+
+void tboot_sleep(u8 sleep_state)
+{
+	uint32_t shutdown_type;
+
+	switch (sleep_state) {
+	case ACPI_STATE_S3:
+		shutdown_type = TB_SHUTDOWN_S3;
+		break;
+	case ACPI_STATE_S4:
+		shutdown_type = TB_SHUTDOWN_S4;
+		break;
+	case ACPI_STATE_S5:
+		shutdown_type = TB_SHUTDOWN_S5;
+		break;
+	default:
+		return;
+	}
+
+	tboot_shutdown(shutdown_type);
+}
+
+void tboot_wait_for_aps(int num_aps)
+{
+	if (!tboot_in_measured_env())
+		return;
+
+	while (atomic_read((atomic_t *)&tboot_shared->num_in_wfs) != num_aps)
+		cpu_relax();
+}
+
+/*
+ * TXT configuration registers (offsets from TXT_{PUB, PRIV}_CONFIG_REGS_BASE)
+ */
+
+#define TXT_PUB_CONFIG_REGS_BASE       0xfed30000
+#define TXT_PRIV_CONFIG_REGS_BASE      0xfed20000
+
+/* # pages for each config regs space - used by fixmap */
+#define NR_TXT_CONFIG_PAGES     ((TXT_PUB_CONFIG_REGS_BASE -                \
+				  TXT_PRIV_CONFIG_REGS_BASE) >> PAGE_SHIFT)
+
+/* offsets from pub/priv config space */
+#define TXTCR_HEAP_BASE             0x0300
+#define TXTCR_HEAP_SIZE             0x0308
+
+#define SHA1_SIZE      20
+struct sha1_hash {
+	u8 hash[SHA1_SIZE];
+};
+
+struct sinit_mle_data {
+	u32               version;             /* currently 6 */
+	struct sha1_hash  bios_acm_id;
+	u32               edx_senter_flags;
+	u64               mseg_valid;
+	struct sha1_hash  sinit_hash;
+	struct sha1_hash  mle_hash;
+	struct sha1_hash  stm_hash;
+	struct sha1_hash  lcp_policy_hash;
+	u32               lcp_policy_control;
+	u32               rlp_wakeup_addr;
+	u32               reserved;
+	u32               num_mdrs;
+	u32               mdrs_off;
+	u32               num_vtd_dmars;
+	u32               vtd_dmars_off;
+} __attribute__ ((__packed__));
+
+struct acpi_table_header *tboot_get_dmar_table(void)
+{
+	void *heap_base, *heap_ptr, *config;
+	struct acpi_table_header *dmar_table;
+
+	/* ACPI tables may not be DMA protected by tboot, so use DMAR copy */
+	/* SINIT saved in SinitMleData in TXT heap (which is DMA protected) */
+
+	/* map config space in order to get heap addr */
+	config = ioremap(TXT_PUB_CONFIG_REGS_BASE, NR_TXT_CONFIG_PAGES *
+			 PAGE_SIZE);
+	if (config == NULL)
+		return NULL;
+
+	/* now map TXT heap */
+	heap_base = ioremap(*(u64 *)(config + TXTCR_HEAP_BASE),
+			    *(u64 *)(config + TXTCR_HEAP_SIZE));
+	iounmap(config);
+	if (heap_base == NULL)
+		return NULL;
+
+	/* walk heap to SinitMleData */
+	/* skip BiosData */
+	heap_ptr = heap_base + *(uint64_t *)heap_base;
+	/* skip OsMleData */
+	heap_ptr += *(uint64_t *)heap_ptr;
+	/* skip OsSinitData */
+	heap_ptr += *(uint64_t *)heap_ptr;
+	/* now points to SinitMleDataSize; set to SinitMleData */
+	heap_ptr += sizeof(uint64_t);
+	/* get addr of DMAR table */
+	dmar_table = (struct acpi_table_header *)(heap_ptr +
+			((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
+			  sizeof(uint64_t));
+
+	/* don't unmap heap because dmar.c needs access to this */
+
+	return dmar_table;
+}
+
+void tboot_sx_resume(u32 state)
+{
+	/* Clean up memory mapping for tboot range */
+	if (tboot_in_measured_env())
+		clean_up_tboot_mapping();
+}
diff -uprN ../linux.trees.git/drivers/acpi/acpica/hwsleep.c ./drivers/acpi/acpica/hwsleep.c
--- ../linux.trees.git/drivers/acpi/acpica/hwsleep.c	2009-03-29 12:12:13.000000000 -0700
+++ ./drivers/acpi/acpica/hwsleep.c	2009-03-30 13:02:55.000000000 -0700
@@ -45,6 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "actables.h"
+#include <asm/tboot.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
@@ -333,6 +334,39 @@ acpi_status asmlinkage acpi_enter_sleep_
 	PM1Acontrol |= sleep_enable_reg_info->access_bit_mask;
 	PM1Bcontrol |= sleep_enable_reg_info->access_bit_mask;
 
+#ifdef CONFIG_INTEL_TXT
+#define TB_COPY_GAS(tbg, g)                 \
+	tbg.space_id = g.space_id;          \
+	tbg.bit_width = g.bit_width;        \
+	tbg.bit_offset = g.bit_offset;      \
+	tbg.access_width = g.access_width;  \
+	tbg.address = g.address;
+
+	if (tboot_in_measured_env()) {
+		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1a_cnt_blk,
+			    acpi_gbl_FADT.xpm1a_control_block);
+		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1b_cnt_blk,
+			    acpi_gbl_FADT.xpm1b_control_block);
+		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1a_evt_blk,
+			    acpi_gbl_FADT.xpm1a_event_block);
+		TB_COPY_GAS(tboot_shared->acpi_sinfo.pm1b_evt_blk,
+			    acpi_gbl_FADT.xpm1b_event_block);
+		tboot_shared->acpi_sinfo.pm1a_cnt_val = PM1Acontrol;
+		tboot_shared->acpi_sinfo.pm1b_cnt_val = PM1Bcontrol;
+		/* we need phys addr of waking vector, but can't use
+		   virt_to_phys() on &acpi_gbl_FACS because it is ioremap'ed,
+		   so calc from FACS phys addr */
+		tboot_shared->acpi_sinfo.wakeup_vector = acpi_gbl_FADT.facs +
+			((void *)&acpi_gbl_FACS->firmware_waking_vector -
+			 (void *)acpi_gbl_FACS);
+		tboot_shared->acpi_sinfo.vector_width = 32;
+		tboot_shared->acpi_sinfo.kernel_s3_resume_vector =
+				acpi_wakeup_address;
+
+		tboot_sleep(sleep_state);
+	}
+#endif
+
 	/* Write #2: SLP_TYP + SLP_EN */
 
 	ACPI_FLUSH_CPU_CACHE();
diff -uprN ../linux.trees.git/drivers/acpi/sleep.c ./drivers/acpi/sleep.c
--- ../linux.trees.git/drivers/acpi/sleep.c	2009-03-29 12:12:13.000000000 -0700
+++ ./drivers/acpi/sleep.c	2009-03-30 13:02:56.000000000 -0700
@@ -22,6 +22,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
+#include <asm/tboot.h>
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
@@ -246,6 +247,8 @@ static int acpi_suspend_enter(suspend_st
 		break;
 	}
 
+	tboot_sx_resume(acpi_state);
+
 	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
 	if (set_sci_en_on_resume)
 		acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
diff -uprN ../linux.trees.git/drivers/pci/dmar.c ./drivers/pci/dmar.c
--- ../linux.trees.git/drivers/pci/dmar.c	2009-03-29 12:12:15.000000000 -0700
+++ ./drivers/pci/dmar.c	2009-03-30 13:11:08.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <asm/tboot.h>
 
 #undef PREFIX
 #define PREFIX "DMAR:"
@@ -319,6 +320,11 @@ parse_dmar_table(void)
 	 */
 	dmar_table_detect();
 
+	/* ACPI tables may not be DMA protected by tboot, so use DMAR copy */
+	/* SINIT saved in SinitMleData in TXT heap (which is DMA protected) */
+	if (tboot_in_measured_env())
+		dmar_tbl = tboot_get_dmar_table();
+
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
 	if (!dmar)
 		return -ENODEV;
diff -uprN ../linux.trees.git/kernel/cpu.c ./kernel/cpu.c
--- ../linux.trees.git/kernel/cpu.c	2009-03-29 12:12:19.000000000 -0700
+++ ./kernel/cpu.c	2009-03-30 13:03:07.000000000 -0700
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <asm/tboot.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -379,7 +380,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error;
+	int cpu, first_cpu, error, num_cpus = 0;
 
 	error = stop_machine_create();
 	if (error)
@@ -394,6 +395,7 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
+		num_cpus++;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpumask_set_cpu(cpu, frozen_cpus);
@@ -404,6 +406,8 @@ int disable_nonboot_cpus(void)
 			break;
 		}
 	}
+	/* ensure all CPUs have gone into wait-for-SIPI */
+	tboot_wait_for_aps(num_cpus);
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
 		/* Make sure the CPUs won't be enabled by someone else */
diff -uprN ../linux.trees.git/kernel/power/disk.c ./kernel/power/disk.c
--- ../linux.trees.git/kernel/power/disk.c	2009-03-29 12:12:19.000000000 -0700
+++ ./kernel/power/disk.c	2009-03-30 13:03:07.000000000 -0700
@@ -22,6 +22,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <asm/tboot.h>
 
 #include "power.h"
 
@@ -308,6 +309,7 @@ int hibernation_snapshot(int platform_mo
 	}
  Enable_cpus:
 	enable_nonboot_cpus();
+	tboot_sx_resume(ACPI_STATE_S4);
  Finish:
 	platform_finish(platform_mode);
  Resume_devices:
diff -uprN ../linux.trees.git/security/Kconfig ./security/Kconfig
--- ../linux.trees.git/security/Kconfig	2009-03-29 12:12:20.000000000 -0700
+++ ./security/Kconfig	2009-03-30 13:03:07.000000000 -0700
@@ -132,6 +132,23 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  /proc/sys/vm/mmap_min_addr tunable.
 
 
+config INTEL_TXT
+        bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
+        depends on EXPERIMENTAL && X86
+        help
+          This option enables support for booting the kernel with
+          the Trusted Boot (tboot) module. This will utilize
+          Intel(R) Trusted Execution Technology to perform a
+          measured launch of the kernel. If the system does not
+          support Intel(R) TXT, this will have no effect.
+
+          See <http://www.intel.com/technology/security/> for more
+          information about Intel(R) TXT.
+          And see <http://tboot.sourceforge.net> for more information
+          about tboot.
+
+          If you are unsure as to whether this is required, answer N.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 

