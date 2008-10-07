Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYJGXaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYJGXaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYJGXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:30:11 -0400
Received: from mga12.intel.com ([143.182.124.36]:41908 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754314AbYJGXaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:30:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="56484474"
Message-ID: <48EBF0F4.3050001@linux.intel.com>
Date: Tue, 07 Oct 2008 16:29:56 -0700
From: Joseph Cihula <joseph.cihula@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: shane.wang@intel.com, gang.wei@intel.com, arjan@linux.intel.com,
       asit.k.mallick@intel.com, jun.nakajima@intel.com, chrisw@sous-sol.org,
       jbeulich@novell.com, mingo@elte.hu, tytso@mit.edu,
       linux-kernel@vger.kernel.org, joseph.cihula@intel.com
Subject: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-posted with apologies for formatting and email addresses)


Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>
Signed-off-by:  Gang Wei <gang.wei@intel.com>

---

diff -r 29cfdc52a076 arch/x86/configs/i386_defconfig
--- a/arch/x86/configs/i386_defconfig	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/configs/i386_defconfig	Tue Oct 07 00:13:02 2008 -0700
@@ -54,6 +54,7 @@ CONFIG_X86_TRAMPOLINE=y
 CONFIG_X86_TRAMPOLINE=y
 CONFIG_KTIME_SCALAR=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+# CONFIG_TXT is not set
 
 #
 # General setup
diff -r 29cfdc52a076 arch/x86/configs/x86_64_defconfig
--- a/arch/x86/configs/x86_64_defconfig	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/configs/x86_64_defconfig	Tue Oct 07 00:13:02 2008 -0700
@@ -54,6 +54,7 @@ CONFIG_X86_TRAMPOLINE=y
 CONFIG_X86_TRAMPOLINE=y
 # CONFIG_KTIME_SCALAR is not set
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+# CONFIG_TXT is not set
 
 #
 # General setup
diff -r 29cfdc52a076 arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/kernel/Makefile	Tue Oct 07 00:13:02 2008 -0700
@@ -44,6 +44,7 @@ obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
+obj-$(CONFIG_TXT)		+= tboot.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
diff -r 29cfdc52a076 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/kernel/reboot.c	Tue Oct 07 00:13:02 2008 -0700
@@ -20,6 +20,8 @@
 #else
 # include <asm/iommu.h>
 #endif
+
+#include <asm/tboot.h>
 
 /*
  * Power off function, if any
@@ -456,11 +458,13 @@ static void native_machine_restart(char 
 
 	if (!reboot_force)
 		machine_shutdown();
+	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 	machine_emergency_restart();
 }
 
 static void native_machine_halt(void)
 {
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
 static void native_machine_power_off(void)
@@ -470,6 +474,8 @@ static void native_machine_power_off(voi
 			machine_shutdown();
 		pm_power_off();
 	}
+	/* a fallback in case there is no PM info available */
+	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
 struct machine_ops machine_ops = {
diff -r 29cfdc52a076 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/kernel/setup.c	Tue Oct 07 00:13:02 2008 -0700
@@ -115,6 +115,8 @@ struct boot_params __initdata boot_param
 #else
 struct boot_params boot_params;
 #endif
+
+#include <asm/tboot.h>
 
 /*
  * Machine setup..
@@ -833,6 +835,8 @@ void __init setup_arch(char **cmdline_p)
 	paravirt_pagetable_setup_done(swapper_pg_dir);
 	paravirt_post_allocator_init();
 
+	tboot_probe();
+
 #ifdef CONFIG_X86_64
 	map_vsyscall();
 #endif
diff -r 29cfdc52a076 arch/x86/kernel/tboot.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/arch/x86/kernel/tboot.c	Tue Oct 07 00:13:02 2008 -0700
@@ -0,0 +1,258 @@
+/*
+ * tboot.c: main implementation of helper functions used by kernel for
+ *          runtime support
+ *
+ * Copyright (c) 2006-2008, Intel Corporation
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
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/bootparam.h>
+#include <asm/tboot.h>
+
+/* Global pointer to shared data; NULL means no measured launch. */
+struct tboot_shared *tboot_shared;
+
+void __init tboot_probe(void)
+{
+	extern struct boot_params boot_params;
+
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
+		printk(KERN_WARNING "tboot_shared at %lxP/%pV is invalid\n",
+		       (unsigned long)boot_params.hdr.tboot_shared_addr,
+		       tboot_shared);
+		tboot_shared = NULL;
+		return;
+	}
+	if (tboot_shared->version < 2) {
+		printk(KERN_WARNING "tboot_shared version is invalid: %d\n",
+		       tboot_shared->version);
+		tboot_shared = NULL;
+		return;
+	}
+
+	printk(KERN_INFO "TBOOT: found shared page at phys addr 0x%lx:\n",
+	       (unsigned long)boot_params.hdr.tboot_shared_addr);
+	printk(KERN_DEBUG "  version: %d\n", tboot_shared->version);
+	printk(KERN_DEBUG "  log_addr: 0x%08x\n", tboot_shared->log_addr);
+	printk(KERN_DEBUG "  shutdown_entry32: 0x%08x\n",
+	       tboot_shared->shutdown_entry32);
+	printk(KERN_DEBUG "  shutdown_entry64: 0x%08x\n",
+	       tboot_shared->shutdown_entry64);
+	printk(KERN_DEBUG "  shutdown_type: %d\n", tboot_shared->shutdown_type);
+	printk(KERN_DEBUG "  s3_tb_wakeup_entry: 0x%08x\n",
+	       tboot_shared->s3_tb_wakeup_entry);
+	printk(KERN_DEBUG "  s3_k_wakeup_entry: 0x%08x\n",
+	       tboot_shared->s3_k_wakeup_entry);
+	printk(KERN_DEBUG "  &acpi_sinfo: 0x%p\n", &tboot_shared->acpi_sinfo);
+	printk(KERN_DEBUG "  tboot_base: 0x%08x\n", tboot_shared->tboot_base);
+	printk(KERN_DEBUG "  tboot_size: 0x%x\n", tboot_shared->tboot_size);
+}
+
+static pgd_t *tboot_pg_dir;
+static inline void switch_to_tboot_pt(void)
+{
+	native_write_cr3(__pa(tboot_pg_dir));
+}
+
+struct tboot_pgt_struct {
+	unsigned long ptr;
+	struct tboot_pgt_struct *next;
+};
+static struct tboot_pgt_struct *tboot_pgt;
+
+/* Allocate (and save for later release) a page */
+static unsigned long alloc_tboot_page(void)
+{
+	unsigned long ptr;
+	struct tboot_pgt_struct *pgt;
+
+	ptr = get_zeroed_page(GFP_ATOMIC);
+	if (ptr) {
+		pgt = kmalloc(sizeof(*pgt), GFP_ATOMIC);
+		if (!pgt) {
+			free_page(ptr);
+			return 0;
+		}
+		pgt->ptr = ptr;
+		pgt->next = tboot_pgt;
+		tboot_pgt = pgt;
+	}
+	return ptr;
+}
+
+/* Clean up memory used for tboot mapping */
+void clean_up_tboot_mapping(void)
+{
+	struct tboot_pgt_struct *pgt;
+
+	if (!tboot_in_measured_env())
+		return;
+
+	pgt = tboot_pgt;
+	while (pgt) {
+		free_page(pgt->ptr);
+		tboot_pgt = pgt->next;
+		kfree(pgt);
+		pgt = tboot_pgt;
+	}
+}
+
+static int map_page_for_tboot(unsigned long vaddr, unsigned long pfn,
+				pgprot_t prot)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte, new_pte;
+
+	pgd = tboot_pg_dir + pgd_index(vaddr);
+#ifdef __x86_64__
+	if (!pgd_val(*pgd)) {
+		pud = (pud_t *)alloc_tboot_page();
+		if (!pud)
+			return -1;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+	pud = pud_offset(pgd, vaddr);
+	if (!pud_val(*pud)) {
+		pmd = (pmd_t *)alloc_tboot_page();
+		if (!pmd)
+			return -1;
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+	pmd = pmd_offset(pud, vaddr);
+#else
+#ifdef CONFIG_X86_PAE
+	if (!pgd_val(*pgd)) {
+		pmd = (pmd_t *)alloc_tboot_page();
+		if (!pmd)
+			return -1;
+		set_pgd(pgd, __pgd(__pa(pmd) | _PAGE_PRESENT));
+		pud = pud_offset(pgd, 0);
+	}
+	pud = pud_offset(pgd, 0);
+	pmd = pmd_offset(pud, vaddr);
+#else
+	pud = pud_offset(pgd, 0);
+	pmd = pmd_offset(pud, 0);
+#endif
+#endif
+	if (!pmd_val(*pmd)) {
+		pte = (pte_t *)alloc_tboot_page();
+		if (!pte)
+			return -1;
+		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+	}
+	new_pte = pfn_pte(pfn, prot);
+
+	pte = pte_offset_kernel(pmd, vaddr);
+
+	if (pte_val(*pte) &&
+#if defined(CONFIG_X86_PAE) || defined(__x86_64__)
+	    pte_val(*pte) != (pte_val(new_pte) & __supported_pte_mask)
+#else
+	    pte_val(*pte) != pte_val(new_pte)
+#endif
+	   ) {
+		pte_ERROR(*pte);
+		return -1;
+	}
+
+	set_pte(pte, new_pte);
+
+	return 0;
+}
+
+static int map_pages_for_tboot(unsigned long vaddr, unsigned long start_pfn,
+				unsigned long nr)
+{
+	printk(KERN_DEBUG "map_pages_for_tboot %lx to %lx (%lx)\n",
+		vaddr, start_pfn << PAGE_SHIFT, nr << PAGE_SHIFT);
+
+	/* Reuse the original kernel mapping */
+	tboot_pg_dir = (pgd_t *)alloc_tboot_page();
+	if (!tboot_pg_dir)
+		return -1;
+
+#ifdef __x86_64__
+	set_pgd(tboot_pg_dir + pgd_index(__START_KERNEL_map),
+		swapper_pg_dir[pgd_index(__START_KERNEL_map)]);
+#else
+	memcpy(tboot_pg_dir + KERNEL_PGD_BOUNDARY,
+		swapper_pg_dir + KERNEL_PGD_BOUNDARY,
+		sizeof(swapper_pg_dir[0]) * KERNEL_PGD_PTRS);
+#endif
+
+	for (; nr > 0; nr--, vaddr += PAGE_SIZE, start_pfn++) {
+		if (map_page_for_tboot(vaddr, start_pfn,
+				       __pgprot(__PAGE_KERNEL_EXEC)))
+			return -1;
+	}
+
+	return 0;
+}
+
+void tboot_shutdown(u32 shutdown_type)
+{
+	u32 map_base, map_size;
+
+	if (!tboot_in_measured_env())
+		return;
+
+	tboot_shared->shutdown_type = shutdown_type;
+
+	local_irq_disable();
+
+	/* Create identity map for tboot shutdown code. */
+	if (tboot_shared->version >= 0x02) {
+		map_base = PFN_DOWN(tboot_shared->tboot_base);
+		map_size = PFN_UP(tboot_shared->tboot_size);
+	} else {
+		map_base = 0;
+		map_size = PFN_UP(0xa0000);
+	}
+
+	if (map_pages_for_tboot(map_base << PAGE_SHIFT, map_base, map_size)) {
+		printk(KERN_DEBUG "error mapping tboot pages "
+				  "(mfns) @ 0x%x, 0x%x\n", map_base, map_size);
+		clean_up_tboot_mapping();
+		return;
+	}
+
+	switch_to_tboot_pt();
+
+#ifdef __x86_64__
+	asm volatile ("jmp *%%rdi" : : "D" (tboot_shared->shutdown_entry64));
+#else
+	asm volatile ("jmp *%%edi" : : "D" (tboot_shared->shutdown_entry32));
+#endif
+
+	BUG(); /* should not reach here */
+}
diff -r 29cfdc52a076 arch/x86/power/cpu_32.c
--- a/arch/x86/power/cpu_32.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/power/cpu_32.c	Tue Oct 07 00:13:02 2008 -0700
@@ -11,6 +11,7 @@
 #include <linux/suspend.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/tboot.h>
 
 static struct saved_context saved_context;
 
@@ -136,5 +137,8 @@ void restore_processor_state(void)
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
+
+	/* Clean up memory mapping for tboot range */
+	clean_up_tboot_mapping();
 }
 EXPORT_SYMBOL(restore_processor_state);
diff -r 29cfdc52a076 arch/x86/power/cpu_64.c
--- a/arch/x86/power/cpu_64.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/arch/x86/power/cpu_64.c	Tue Oct 07 00:13:02 2008 -0700
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/tboot.h>
 
 static void fix_processor_context(void);
 
@@ -131,6 +132,9 @@ void restore_processor_state(void)
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
+
+	/* Clean up memory mapping for tboot range */
+	clean_up_tboot_mapping();
 }
 
 static void fix_processor_context(void)
diff -r 29cfdc52a076 drivers/acpi/hardware/hwsleep.c
--- a/drivers/acpi/hardware/hwsleep.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/drivers/acpi/hardware/hwsleep.c	Tue Oct 07 00:13:02 2008 -0700
@@ -44,6 +44,7 @@
 
 #include <acpi/acpi.h>
 #include <acpi/actables.h>
+#include <asm/tboot.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
@@ -77,6 +78,13 @@ acpi_set_firmware_waking_vector(acpi_phy
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
+
+#ifdef CONFIG_TXT
+	if (tboot_in_measured_env()) {
+		tboot_shared->s3_k_wakeup_entry = (uint32_t)physical_address;
+		physical_address = tboot_shared->s3_tb_wakeup_entry;
+	}
+#endif
 
 	/* Set the vector */
 
@@ -238,6 +246,29 @@ acpi_status acpi_enter_sleep_state_prep(
 
 ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
 
+#ifdef CONFIG_TXT
+static void tboot_sleep(u8 sleep_state)
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
+#endif
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_enter_sleep_state
@@ -361,6 +392,20 @@ acpi_status asmlinkage acpi_enter_sleep_
 
 	PM1Acontrol |= sleep_enable_reg_info->access_bit_mask;
 	PM1Bcontrol |= sleep_enable_reg_info->access_bit_mask;
+
+#ifdef CONFIG_TXT
+	if (tboot_in_measured_env()) {
+		tboot_shared->acpi_sinfo.pm1a_cnt =
+			(uint16_t)acpi_gbl_FADT.xpm1a_control_block.address;
+		tboot_shared->acpi_sinfo.pm1b_cnt =
+			(uint16_t)acpi_gbl_FADT.xpm1b_control_block.address;
+		tboot_shared->acpi_sinfo.pm1a_cnt_val = PM1Acontrol;
+		tboot_shared->acpi_sinfo.pm1b_cnt_val = PM1Bcontrol;
+		tboot_sleep(sleep_state);
+		printk(KERN_DEBUG "TBOOT failed entering s3 state\n");
+		return_ACPI_STATUS(AE_ERROR);
+	}
+#endif
 
 	/* Write #2: SLP_TYP + SLP_EN */
 
diff -r 29cfdc52a076 include/asm-x86/bootparam.h
--- a/include/asm-x86/bootparam.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/include/asm-x86/bootparam.h	Tue Oct 07 00:13:02 2008 -0700
@@ -62,6 +62,7 @@ struct setup_header {
 	__u32	payload_offset;
 	__u32	payload_length;
 	__u64	setup_data;
+	__u32   tboot_shared_addr;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff -r 29cfdc52a076 include/asm-x86/fixmap_32.h
--- a/include/asm-x86/fixmap_32.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/include/asm-x86/fixmap_32.h	Tue Oct 07 00:13:02 2008 -0700
@@ -85,6 +85,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
+#ifdef CONFIG_TXT
+	FIX_TBOOT_SHARED_BASE,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
diff -r 29cfdc52a076 include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/include/asm-x86/fixmap_64.h	Tue Oct 07 00:13:02 2008 -0700
@@ -56,6 +56,9 @@ enum fixed_addresses {
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
+#ifdef CONFIG_TXT
+	FIX_TBOOT_SHARED_BASE,
+#endif
 	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
diff -r 29cfdc52a076 include/asm-x86/tboot.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-x86/tboot.h	Tue Oct 07 00:13:02 2008 -0700
@@ -0,0 +1,101 @@
+/*
+ * tboot.h: shared data structure with MLE and kernel and functions
+ *          used by kernel for runtime support
+ *
+ * Copyright (c) 2006-2008, Intel Corporation
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
+#define TB_SHUTDOWN_REBOOT      0
+#define TB_SHUTDOWN_S5          1
+#define TB_SHUTDOWN_S4          2
+#define TB_SHUTDOWN_S3          3
+#define TB_SHUTDOWN_HALT        4
+
+#ifdef CONFIG_TXT
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
+struct tboot_acpi_sleep_info {
+	u16 pm1a_cnt;
+	u16 pm1b_cnt;
+	u16 pm1a_evt;
+	u16 pm1b_evt;
+	u16 pm1a_cnt_val;
+	u16 pm1b_cnt_val;
+}  __attribute__ ((__packed__));
+
+struct tboot_shared {
+	/* version 0x01+ fields: */
+	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
+	u32  version;      	/* Version number: 2 is current */
+	u32  log_addr;     	/* physical addr of tb_log_t log */
+	u32  shutdown_entry32;	/* entry point for tboot shutdown from 32b */
+	u32  shutdown_entry64;	/* entry point for tboot shutdown from 64b */
+	u32  shutdown_type;	/* type of shutdown (TB_SHUTDOWN_*) */
+	u32  s3_tb_wakeup_entry;/* entry point for tboot s3 wake up */
+	u32  s3_k_wakeup_entry;	/* entry point for kernel s3 wake up */
+	struct tboot_acpi_sleep_info
+		  acpi_sinfo;	/* where kernel put acpi sleep info in Sx */
+	u8   reserved[52];	/* this pad is for compat with old field */
+	/* version 0x02+ fields: */
+	u32  tboot_base;	/* starting addr for tboot */
+	u32  tboot_size;	/* size of tboot */
+} __attribute__ ((__packed__));
+
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
+extern void clean_up_tboot_mapping(void);
+extern void tboot_probe(void);
+extern void tboot_shutdown(u32 shutdown_type);
+
+#else     /* CONFIG_TXT */
+
+static inline void clean_up_tboot_mapping(void)
+{
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
+#endif /* !CONFIG_TXT */
+
+#endif /* _ASM_TBOOT_H */
diff -r 29cfdc52a076 security/Kconfig
--- a/security/Kconfig	Mon Oct 06 12:50:47 2008 -0700
+++ b/security/Kconfig	Tue Oct 07 00:13:02 2008 -0700
@@ -115,6 +115,23 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 	  /proc/sys/vm/mmap_min_addr tunable.
 
 
+config TXT
+        bool "Enable Intel(R) Trusted Execution Technology (TXT)"
+        depends on EXPERIMENTAL && X86
+        help
+          This option enables support for booting the kernel with
+          the Trusted Boot (tboot) module. This will utilize
+          Intel(R) Trusted Execution Technology (TXT) to perform a
+          measured launch of the kernel. If the system does not
+          support TXT, this will have no effect.
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
 


