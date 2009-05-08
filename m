Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZEHEt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZEHEt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZEHEtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:49:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:10706 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbZEHEtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,315,1239001200"; 
   d="scan'208";a="140549096"
Message-ID: <4A03B9C3.9090607@intel.com>
Date: Thu, 07 May 2009 21:49:07 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org
CC: chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, joseph.cihula@intel.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux support for Intel(R) Trusted Execution Technology.

 Documentation/intel_txt.txt      |  187 ++++++++++++++++++++++++
 Documentation/x86/zero-page.txt  |    1
 arch/x86/include/asm/bootparam.h |    3
 arch/x86/include/asm/fixmap.h    |    3
 arch/x86/include/asm/tboot.h     |  154 +++++++++++++++++++
 arch/x86/kernel/Makefile         |    1
 arch/x86/kernel/reboot.c         |   14 +
 arch/x86/kernel/setup.c          |    4
 arch/x86/kernel/smpboot.c        |    6
 arch/x86/kernel/tboot.c          |  302 +++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/hwsleep.c    |   33 ++++
 drivers/pci/dmar.c               |    6
 drivers/pci/intel-iommu.c        |   26 +++
 init/main.c                      |    3
 kernel/cpu.c                     |    6
 security/Kconfig                 |   22 ++
 16 files changed, 764 insertions(+), 7 deletions(-)

Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Gang Wei <gang.wei@intel.com>

---

diff -uprN linux-2.6.30-rc4/arch/x86/include/asm/bootparam.h linux-2.6.30-rc4-lkml/arch/x86/include/asm/bootparam.h
--- linux-2.6.30-rc4/arch/x86/include/asm/bootparam.h	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/arch/x86/include/asm/bootparam.h	2009-05-07 08:07:17.000000000 -0700
@@ -84,7 +84,8 @@ struct efi_info {
 struct boot_params {
 	struct screen_info screen_info;			/* 0x000 */
 	struct apm_bios_info apm_bios_info;		/* 0x040 */
-	__u8  _pad2[12];				/* 0x054 */
+	__u8  _pad2[4];					/* 0x054 */
+	__u64  tboot_shared_addr;			/* 0x058 */
 	struct ist_info ist_info;			/* 0x060 */
 	__u8  _pad3[16];				/* 0x070 */
 	__u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
diff -uprN linux-2.6.30-rc4/arch/x86/include/asm/fixmap.h linux-2.6.30-rc4-lkml/arch/x86/include/asm/fixmap.h
--- linux-2.6.30-rc4/arch/x86/include/asm/fixmap.h	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/arch/x86/include/asm/fixmap.h	2009-05-07 08:07:17.000000000 -0700
@@ -132,6 +132,9 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_WP_TEST,
 #endif
+#ifdef CONFIG_INTEL_TXT
+	FIX_TBOOT_SHARED_BASE,
+#endif
 	__end_of_fixed_addresses
 };
 
diff -uprN linux-2.6.30-rc4/arch/x86/include/asm/tboot.h linux-2.6.30-rc4-lkml/arch/x86/include/asm/tboot.h
--- linux-2.6.30-rc4/arch/x86/include/asm/tboot.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.30-rc4-lkml/arch/x86/include/asm/tboot.h	2009-05-07 08:07:17.000000000 -0700
@@ -0,0 +1,154 @@
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
+/* combines Sx info from FADT and FACS tables per ACPI 2.0+ spec
+   (http://www.acpi.info/) */
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
+extern void tboot_create_trampoline(void);
+extern void tboot_shutdown(u32 shutdown_type);
+extern void tboot_sleep(u8 sleep_state);
+extern void tboot_wait_for_aps(int num_aps);
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
+static inline void tboot_create_trampoline(void)
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
+static inline struct acpi_table_header *tboot_get_dmar_table(void)
+{
+	return NULL;
+}
+
+#endif /* !CONFIG_INTEL_TXT */
+
+#endif /* _ASM_TBOOT_H */
diff -uprN linux-2.6.30-rc4/arch/x86/kernel/Makefile linux-2.6.30-rc4-lkml/arch/x86/kernel/Makefile
--- linux-2.6.30-rc4/arch/x86/kernel/Makefile	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/arch/x86/kernel/Makefile	2009-05-07 08:07:17.000000000 -0700
@@ -47,6 +47,7 @@ obj-$(CONFIG_X86_DS)		+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
+obj-$(CONFIG_INTEL_TXT)		+= tboot.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff -uprN linux-2.6.30-rc4/arch/x86/kernel/reboot.c linux-2.6.30-rc4-lkml/arch/x86/kernel/reboot.c
--- linux-2.6.30-rc4/arch/x86/kernel/reboot.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/arch/x86/kernel/reboot.c	2009-05-07 08:07:17.000000000 -0700
@@ -24,6 +24,8 @@
 # include <asm/iommu.h>
 #endif
 
+#include <asm/tboot.h>
+
 /*
  * Power off function, if any
  */
@@ -443,6 +445,8 @@ static void native_machine_emergency_res
 	if (reboot_emergency)
 		emergency_vmx_disable_all();
 
+	tboot_shutdown(TB_SHUTDOWN_REBOOT);
+
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
 
@@ -508,11 +512,13 @@ static void native_machine_emergency_res
 
 void native_machine_shutdown(void)
 {
-	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-
 	/* The boot cpu is always logical cpu 0 */
 	int reboot_cpu_id = 0;
+#endif
+
+	/* Stop the cpus and apics */
+#ifdef CONFIG_SMP
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
@@ -569,6 +575,8 @@ static void native_machine_halt(void)
 	/* stop other cpus and apics */
 	machine_shutdown();
 
+	tboot_shutdown(TB_SHUTDOWN_HALT);
+
 	/* stop this cpu */
 	stop_this_cpu(NULL);
 }
@@ -580,6 +588,8 @@ static void native_machine_power_off(voi
 			machine_shutdown();
 		pm_power_off();
 	}
+	/* a fallback in case there is no PM info available */
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
 struct machine_ops machine_ops = {
diff -uprN linux-2.6.30-rc4/arch/x86/kernel/setup.c linux-2.6.30-rc4-lkml/arch/x86/kernel/setup.c
--- linux-2.6.30-rc4/arch/x86/kernel/setup.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/arch/x86/kernel/setup.c	2009-05-07 08:07:17.000000000 -0700
@@ -137,6 +137,8 @@ struct boot_params __initdata boot_param
 struct boot_params boot_params;
 #endif
 
+#include <asm/tboot.h>
+
 /*
  * Machine setup..
  */
@@ -939,6 +941,8 @@ void __init setup_arch(char **cmdline_p)
 	paravirt_pagetable_setup_done(swapper_pg_dir);
 	paravirt_post_allocator_init();
 
+	tboot_probe();
+
 #ifdef CONFIG_X86_64
 	map_vsyscall();
 #endif
diff -uprN linux-2.6.30-rc4/arch/x86/kernel/smpboot.c linux-2.6.30-rc4-lkml/arch/x86/kernel/smpboot.c
--- linux-2.6.30-rc4/arch/x86/kernel/smpboot.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/arch/x86/kernel/smpboot.c	2009-05-07 08:07:17.000000000 -0700
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
diff -uprN linux-2.6.30-rc4/arch/x86/kernel/tboot.c linux-2.6.30-rc4-lkml/arch/x86/kernel/tboot.c
--- linux-2.6.30-rc4/arch/x86/kernel/tboot.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.30-rc4-lkml/arch/x86/kernel/tboot.c	2009-05-07 10:05:04.000000000 -0700
@@ -0,0 +1,302 @@
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
+#include <asm/e820.h>
+#include <asm/tboot.h>
+
+/* Global pointer to shared data; NULL means no measured launch. */
+struct tboot_shared *tboot_shared __read_mostly;
+
+void __init tboot_probe(void)
+{
+	/* Look for valid page-aligned address for shared page. */
+	if (boot_params.tboot_shared_addr == 0)
+		return;
+	/* also verify that it is mapped as we expect it before calling
+	   set_fixmap(), to reduce chance of garbage value causing crash */
+	if (!e820_any_mapped(boot_params.tboot_shared_addr,
+			     boot_params.tboot_shared_addr, E820_UNUSABLE)) {
+		printk(KERN_WARNING "TXT: non-0 tboot_shared_addr but it is not of type E820_UNUSABLE\n");
+		return;
+	}
+
+	/* only a natively booted kernel should be using TXT */
+	if (paravirt_enabled()) {
+		printk(KERN_WARNING "TXT: non-0 tboot_shared_addr but pv_ops is enabled\n");
+		return;
+	}
+
+	/* Map and check for tboot UUID. */
+	set_fixmap(FIX_TBOOT_SHARED_BASE, boot_params.tboot_shared_addr);
+	tboot_shared = (struct tboot_shared *)
+				fix_to_virt(FIX_TBOOT_SHARED_BASE);
+	if (memcmp(&TBOOT_SHARED_UUID, &tboot_shared->uuid,
+		   sizeof(struct tboot_uuid))) {
+		printk(KERN_WARNING "TXT: tboot_shared at 0x%lx is invalid\n",
+		       (unsigned long)boot_params.tboot_shared_addr);
+		tboot_shared = NULL;
+		return;
+	}
+	if (tboot_shared->version < 5) {
+		printk(KERN_WARNING "TXT: tboot_shared version is invalid: %u\n",
+		       tboot_shared->version);
+		tboot_shared = NULL;
+		return;
+	}
+
+	printk(KERN_INFO "TXT: found shared page at phys addr 0x%lx:\n",
+	       (unsigned long)boot_params.tboot_shared_addr);
+	printk(KERN_DEBUG "TXT:  version: %d\n", tboot_shared->version);
+	printk(KERN_DEBUG "TXT:  log_addr: 0x%08x\n", tboot_shared->log_addr);
+	printk(KERN_DEBUG "TXT:  shutdown_entry: 0x%x\n",
+	       tboot_shared->shutdown_entry);
+	printk(KERN_DEBUG "TXT:  tboot_base: 0x%08x\n",
+	       tboot_shared->tboot_base);
+	printk(KERN_DEBUG "TXT:  tboot_size: 0x%x\n",
+	       tboot_shared->tboot_size);
+}
+
+static pgd_t *tboot_pg_dir;
+static struct mm_struct tboot_mm = INIT_MM(tboot_mm);
+
+static inline void switch_to_tboot_pt(void)
+{
+	write_cr3(virt_to_phys(tboot_pg_dir));
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
+void tboot_create_trampoline(void)
+{
+	u32 map_base, map_size;
+
+	if (!tboot_in_measured_env())
+		return;
+
+	/* Create identity map for tboot shutdown code. */
+	map_base = PFN_DOWN(tboot_shared->tboot_base);
+	map_size = PFN_UP(tboot_shared->tboot_size);
+	if (map_pages_for_tboot(map_base << PAGE_SHIFT, map_base,
+				map_size))
+		panic(KERN_ERR "TXT: Error mapping tboot pages (mfns) @ 0x%x, 0x%x\n", map_base, map_size);
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
+	/* if we're being called before the 1:1 mapping is set up then just
+	   return and let the normal shutdown happen; this should only be
+	   due to very early panic() */
+	if (!tboot_pg_dir)
+		return;
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
+	/* should not reach here */
+	while (1)
+		halt();
+}
+
+void tboot_sleep(u8 sleep_state)
+{
+	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
+		/* S0,1,2: */ -1, -1, -1,
+		/* S3: */ TB_SHUTDOWN_S3,
+		/* S4: */ TB_SHUTDOWN_S4,
+		/* S5: */ TB_SHUTDOWN_S5 };
+
+	if (sleep_state >= ACPI_S_STATE_COUNT ||
+	    acpi_shutdown_map[sleep_state] == -1) {
+		printk(KERN_WARNING "TXT: unsupported sleep state 0x%x\n",
+		       sleep_state);
+		return;
+	}
+
+	tboot_shutdown(acpi_shutdown_map[sleep_state]);
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
+	heap_ptr = heap_base + *(u64 *)heap_base;
+	/* skip OsMleData */
+	heap_ptr += *(u64 *)heap_ptr;
+	/* skip OsSinitData */
+	heap_ptr += *(u64 *)heap_ptr;
+	/* now points to SinitMleDataSize; set to SinitMleData */
+	heap_ptr += sizeof(u64);
+	/* get addr of DMAR table */
+	dmar_table = (struct acpi_table_header *)(heap_ptr +
+			((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
+			  sizeof(u64));
+
+	/* don't unmap heap because dmar.c needs access to this */
+
+	return dmar_table;
+}
diff -uprN linux-2.6.30-rc4/Documentation/intel_txt.txt linux-2.6.30-rc4-lkml/Documentation/intel_txt.txt
--- linux-2.6.30-rc4/Documentation/intel_txt.txt	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.30-rc4-lkml/Documentation/intel_txt.txt	2009-05-07 08:31:37.000000000 -0700
@@ -0,0 +1,187 @@
+Intel(R) TXT Overview:
+=====================
+
+Intel's technology for safer computing, Intel(R) Trusted Execution Technology
+(Intel(R) TXT), defines platform-level enhancements that provide the building
+blocks for creating trusted platforms.
+
+Intel TXT was formerly known by the code name LaGrande Technology (LT).
+
+Intel TXT in Brief:
+o  Provides dynamic root of trust for measurement (DRTM)
+o  Data protection in case of improper shutdown
+o  Measurement and verification of launched environment
+
+Intel TXT is part of the vPro(TM) brand and is also available some non-vPro
+systems.  It is currently available on desktop systems based on the Q35, X38,
+Q45, and Q43 Express chipsets (e.g. Dell Optiplex 755, HP dc7800, etc.) and
+mobile systems based on the GM45, PM45, and GS45 Express chipsets.
+
+For more information, see http://www.intel.com/technology/security/.
+This site also has a link to the Intel TXT MLE Developers Manual, which has
+been updated for the new released platforms.
+
+Intel TXT has been presented at various events over the past few years, some
+of which are:
+      LinuxTAG 2008:
+          http://www.linuxtag.org/2008/en/conf/events/vp-donnerstag/details.html?talkid=110
+      TRUST2008:
+          http://www.trust2008.eu/downloads/Keynote-Speakers/3_David-Grawrock_The-Front-Door-of-Trusted-Computing.pdf
+      IDF 2008, Shanghai:
+          http://inteldeveloperforum.com.edgesuite.net/shanghai_2008/aep/PROS003/index.html
+      IDFs 2006, 2007 (I'm not sure if/where they are online)
+
+Trusted Boot Project Overview:
+=============================
+
+Trusted Boot (tboot) is an open source, pre- kernel/VMM module that uses Intel
+TXT to perform a measured and verified launch of an OS kernel/VMM.
+
+It is hosted on SourceForge at http://sourceforge.net/projects/tboot.  The
+mercurial source repo is available at http://www.bughost.org/repos.hg/tboot.hg.
+
+Tboot currently supports launching Xen (open source VMM/hypervisor w/ TXT
+support since v3.2), and now Linux kernels.
+
+
+Value Proposition for Linux or "Why should you care?"
+=====================================================
+
+While there are many products and technologies that attempt to measure or
+protect the integrity of a running kernel, they all assume the kernel is
+"good" to begin with.  The Integrity Measurement Architecture (IMA) and Linux
+Integrity Module interface are examples of such solutions.
+
+To get trust in the initial kernel without using Intel TXT, a static root of
+trust must be used.  This bases trust in BIOS starting at system reset and
+requires measurement of all code executed between system reset through the
+completion of the kernel boot as well as data objects used by that code.  In
+the case of a Linux kernel, this means all of BIOS, any option ROMs, the
+bootloader and the boot config.  In practice, this is a lot of code/data, much
+of which is subject to change from boot to boot (e.g. changing NICs may change
+option ROMs).  Without reference hashes, these measurement changes are
+difficult to assess or confirm as benign.  This process also does not provide
+DMA protection, memory configuration/alias checks and locks, crash protection,
+or policy support.
+
+By using the hardware-based root of trust that Intel TXT provides, many of
+these issues can be mitigated.  Specifically: many pre-launch components can
+be removed from the trust chain, DMA protection is provided to all launched
+components, a large number of platform configuration checks are performed and
+values locked, protection is provided for any data in the event of an improper
+shutdown, and there is support for policy-based execution/verification.  This
+provides a more stable measurement and a higher assurance of system
+configuration and initial state than would be otherwise possible.  Since the
+tboot project is open source, source code for almost all parts of the trust
+chain is available (excepting SMM and Intel-provided firmware).
+
+How Does it Work?
+=================
+
+o  Tboot is an executable that is launched by the bootloader as the "kernel"
+   (the binary the bootloader executes).
+o  It performs all of the work necessary to determine if the platform supports
+   Intel TXT and, if so, executes the GETSEC[SENTER] processor instruction
+   that initiates the dynamic root of trust.
+   -  If tboot determines that the system does not support Intel TXT or is not
+      configured correctly (e.g. the SINIT AC Module was incorrect), it will
+      directly launch the kernel with no changes to any state.
+   -  Tboot will output various information about its progress to the terminal,
+      serial port, and/or an in-memory log; the output locations can be
+      configured with a command line switch.
+o  The GETSEC[SENTER] instruction will return control to tboot and tboot then
+   verifies certain aspects of the environment (e.g. TPM NV lock, e820 table
+   does not have invalid entries, etc.).
+o  It will wake the APs from the special sleep state the GETSEC[SENTER]
+   instruction had put them in and place them into a wait-for-SIPI state.
+   -  Because the processors will not respond to an INIT or SIPI when in the
+      TXT environment, it is necessary to create a small VT-x guest for the
+      APs.  When they run in this guest, they will simply wait for the
+      INIT-SIPI-SIPI sequence, which will cause VMEXITs, and then disable VT
+      and jump to the SIPI vector.  This approach seemed like a better choice
+      than having to insert special code into the kernel's MP wakeup sequence.
+o  Tboot then applies an (optional) user-defined launch policy to verify the
+   kernel and initrd.
+   -  This policy is rooted in TPM NV and is described in the tboot project.
+      The tboot project also contains code for tools to create and provision
+      the policy.
+   -  Policies are completely under user control and if not present then any
+      kernel will be launched.
+   -  Policy action is flexible and can include halting on failures or simply
+      logging them and continuing.
+o  Tboot adjusts the e820 table provided by the bootloader to reserve its own
+   location in memory as well as to reserve certain other TXT-related regions.
+o  As part of it's launch, tboot DMA protects all of RAM (using the VT-d PMRs).
+   Thus, the kernel must be booted with 'intel_iommu=on' in order to remove
+   this blanket protection and use VT-d's page-level protection.
+o  Tboot will populate a shared page with some data about itself and pass this
+   to the Linux kernel as it transfers control.
+   -  The location of the shared page is passed via the boot_params struct as
+      a physical address.
+o  The kernel will look for the tboot shared page address and, if it exists,
+   map it.
+o  As one of the checks/protections provided by TXT, it makes a copy of the
+   VT-d DMARs in a DMA-protected region of memory and verifies them for
+   correctness.  The VT-d code will detect if the kernel was launched with
+   tboot and use this copy instead of the one in the ACPI table.
+o  At this point, tboot and TXT are out of the picture until a shutdown (S<n>)
+o  In order to put a system into any of the sleep states after a TXT launch,
+   TXT must first be exited.  This is to prevent attacks that attempt to crash
+   the system to gain control on reboot and steal data left in memory.
+   -  The kernel will perform all of its sleep preparation and populate the
+      shared page with the ACPI data needed to put the platform in the desired
+      sleep state.
+   -  Then the kernel jumps into tboot via the vector specified in the shared
+      page.
+   -  Tboot will clean up the environment and disable TXT, then use the
+      kernel-provided ACPI information to actually place the platform into the
+      desired sleep state.
+   -  In the case of S3, tboot will also register itself as the resume vector.
+      This is necessary because it must re-establish the measured environment
+      upon resume.  Once the TXT environment has been restored, it will
+      restore the TPM PCRs and then transfer control back to the kernel's S3
+      resume vector.
+      In order to preserve system integrity across S3, the kernel provides
+      tboot with a set of memory ranges (kernel code/data/bss, S3 resume code,
+      and AP trampoline) that tboot will calculate a MAC (message
+      authentication code) over and then seal with the TPM.  On resume and
+      once the measured environment has been re-established, tboot will
+      re-calculate the MAC and verify it against the sealed value.  Tboot's
+      policy determines what happens if the verification fails.
+
+That's pretty much it for TXT support.
+
+
+Configuring the System:
+======================
+
+This code works with 32bit, 32bit PAE, and 64bit (x86_64) kernels.
+
+In BIOS, the user must enable:  TPM, TXT, VT-x, VT-d.  Not all BIOSes allow
+these to be individually enabled/disabled and the screens in which to find
+them are BIOS-specific.
+
+grub.conf needs to be modified as follows:
+        title Linux 2.6.29-tip w/ tboot
+          root (hd0,0)
+                kernel /tboot.gz logging=serial,vga,memory
+                module /vmlinuz-2.6.29-tip intel_iommu=on ro root=LABEL=/ rhgb console=ttyS0,115200 3
+                module /initrd-2.6.29-tip.img
+                module /Q35_SINIT_17.BIN
+
+The kernel option for enabling Intel TXT support is found under the Security
+top-level menu and is called "Enable Intel(R) Trusted Execution
+Technology (TXT)".  It is marked as EXPERIMENTAL and depends on the
+generic x86 support (to allow maximum flexibility in kernel build options),
+since the tboot code will detect whether the platform actually supports
+Intel TXT and thus whether any of the kernel code is executed.
+
+The Q35_SINIT_17.BIN file is what Intel TXT refers to as an Authenticated Code
+Module.  It is specific to the chipset in the system and can also be found on
+the Trusted Boot site.  It is an (unencrypted) module signed by Intel that is
+used as part of the DRTM process to verify and configure the system.  It is
+signed because it operates at a higher privilege level in the system than any
+other macrocode and its correct operation is critical to the establishment of
+the DRTM.  The process for determining the correct SINIT ACM for a system is
+documented in the SINIT-guide.txt file that is on the tboot SourceForge site
+under the SINIT ACM downloads.
diff -uprN linux-2.6.30-rc4/Documentation/x86/zero-page.txt linux-2.6.30-rc4-lkml/Documentation/x86/zero-page.txt
--- linux-2.6.30-rc4/Documentation/x86/zero-page.txt	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/Documentation/x86/zero-page.txt	2009-05-07 08:07:17.000000000 -0700
@@ -12,6 +12,7 @@ Offset	Proto	Name		Meaning
 000/040	ALL	screen_info	Text mode or frame buffer information
 				(struct screen_info)
 040/014	ALL	apm_bios_info	APM BIOS information (struct apm_bios_info)
+058/008	ALL	tboot_shared_addr Physical address of tboot shared page
 060/010	ALL	ist_info	Intel SpeedStep (IST) BIOS support information
 				(struct ist_info)
 080/010	ALL	hd0_info	hd0 disk parameter, OBSOLETE!!
diff -uprN linux-2.6.30-rc4/drivers/acpi/acpica/hwsleep.c linux-2.6.30-rc4-lkml/drivers/acpi/acpica/hwsleep.c
--- linux-2.6.30-rc4/drivers/acpi/acpica/hwsleep.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/drivers/acpi/acpica/hwsleep.c	2009-05-07 08:07:17.000000000 -0700
@@ -45,6 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "actables.h"
+#include <asm/tboot.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
@@ -342,6 +343,38 @@ acpi_status asmlinkage acpi_enter_sleep_
 
 	ACPI_FLUSH_CPU_CACHE();
 
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
+		tboot_shared->acpi_sinfo.pm1a_cnt_val = pm1a_control;
+		tboot_shared->acpi_sinfo.pm1b_cnt_val = pm1b_control;
+		/* we need phys addr of waking vector, but can't use
+		   virt_to_phys() on &acpi_gbl_FACS because it is ioremap'ed,
+		   so calc from FACS phys addr */
+		tboot_shared->acpi_sinfo.wakeup_vector = acpi_gbl_FADT.facs +
+		     offsetof(struct acpi_table_facs, firmware_waking_vector);
+		tboot_shared->acpi_sinfo.vector_width = 32;
+		tboot_shared->acpi_sinfo.kernel_s3_resume_vector =
+				acpi_wakeup_address;
+
+		tboot_sleep(sleep_state);
+	}
+#endif
+
 	/* Write #2: Write both SLP_TYP + SLP_EN */
 
 	status = acpi_hw_write_pm1_control(pm1a_control, pm1b_control);
diff -uprN linux-2.6.30-rc4/drivers/pci/dmar.c linux-2.6.30-rc4-lkml/drivers/pci/dmar.c
--- linux-2.6.30-rc4/drivers/pci/dmar.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/drivers/pci/dmar.c	2009-05-07 08:07:17.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <asm/tboot.h>
 
 #undef PREFIX
 #define PREFIX "DMAR:"
@@ -329,6 +330,11 @@ parse_dmar_table(void)
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
diff -uprN linux-2.6.30-rc4/drivers/pci/intel-iommu.c linux-2.6.30-rc4-lkml/drivers/pci/intel-iommu.c
--- linux-2.6.30-rc4/drivers/pci/intel-iommu.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/drivers/pci/intel-iommu.c	2009-05-07 08:07:17.000000000 -0700
@@ -38,6 +38,7 @@
 #include <linux/intel-iommu.h>
 #include <linux/sysdev.h>
 #include <asm/cacheflush.h>
+#include <asm/tboot.h>
 #include <asm/iommu.h>
 #include "pci.h"
 
@@ -2775,12 +2776,31 @@ static int __init init_iommu_sysfs(void)
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
+	int force_on = 0;
 
-	if (dmar_table_init())
+	/* VT-d is required for a TXT/tboot launch, so enforce that */
+	if (tboot_in_measured_env()) {
+		if (no_iommu || swiotlb || dmar_disabled)
+			printk(KERN_WARNING "TXT: Forcing Intel-IOMMU to enabled\n");
+		dmar_disabled = 0;
+#ifdef CONFIG_SWIOTLB
+		swiotlb = 0;
+#endif
+		no_iommu = 0;
+		force_on = 1;
+	}
+
+	if (dmar_table_init()) {
+		if (force_on)
+			panic("TXT: Failed to initialize DMAR table\n");
 		return 	-ENODEV;
+	}
 
-	if (dmar_dev_scope_init())
+	if (dmar_dev_scope_init()) {
+		if (force_on)
+			panic("TXT: Failed to initialize DMAR device scope\n");
 		return 	-ENODEV;
+	}
 
 	/*
 	 * Check the need for DMA-remapping initialization now.
@@ -2796,6 +2816,8 @@ int __init intel_iommu_init(void)
 
 	ret = init_dmars();
 	if (ret) {
+		if (force_on)
+			panic("TXT: Failed to initialize DMARs\n");
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
 		put_iova_domain(&reserved_iova_list);
 		iommu_exit_mempool();
diff -uprN linux-2.6.30-rc4/init/main.c linux-2.6.30-rc4-lkml/init/main.c
--- linux-2.6.30-rc4/init/main.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/init/main.c	2009-05-07 08:07:17.000000000 -0700
@@ -69,6 +69,7 @@
 #include <asm/io.h>
 #include <asm/bugs.h>
 #include <asm/setup.h>
+#include <asm/tboot.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 #include <trace/kmemtrace.h>
@@ -696,6 +697,8 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
+	tboot_create_trampoline();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
diff -uprN linux-2.6.30-rc4/kernel/cpu.c linux-2.6.30-rc4-lkml/kernel/cpu.c
--- linux-2.6.30-rc4/kernel/cpu.c	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/kernel/cpu.c	2009-05-07 08:07:17.000000000 -0700
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
diff -uprN linux-2.6.30-rc4/security/Kconfig linux-2.6.30-rc4-lkml/security/Kconfig
--- linux-2.6.30-rc4/security/Kconfig	2009-04-29 21:48:16.000000000 -0700
+++ linux-2.6.30-rc4-lkml/security/Kconfig	2009-05-07 08:32:07.000000000 -0700
@@ -133,6 +133,28 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  /proc/sys/vm/mmap_min_addr tunable.
 
 
+config INTEL_TXT
+        bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
+        depends on EXPERIMENTAL && X86 && DMAR
+        help
+          This option enables support for booting the kernel with the
+	  Trusted Boot (tboot) module. This will utilize
+          Intel(R) Trusted Execution Technology to perform a measured launch
+	  of the kernel. If the system does not support Intel(R) TXT, this
+	  will have no effect.
+
+	  Intel TXT will provide higher assurance of sysem configuration and
+	  initial state as well as data reset protection.  This is used to
+	  create a robust initial kernel measurement and verification.
+
+          See <http://www.intel.com/technology/security/> for more information
+	  about Intel(R) TXT.
+          See <http://tboot.sourceforge.net> for more information about tboot.
+	  See Documentation/intel_txt.txt for a description of how to enable
+	  Intel TXT support in a kernel boot.
+
+          If you are unsure as to whether this is required, answer N.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig


