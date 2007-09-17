Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbXIQIZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbXIQIZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXIQIYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:24:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:58768 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203AbXIQIYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:24:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,263,1186383600"; 
   d="scan'208";a="280593395"
Subject: [RFC -mm 0/2] i386/x86_64 boot: 32-bit boot protocol
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Sep 2007 16:26:12 +0800
Message-Id: <1190017572.5866.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 17 Sep 2007 08:24:18.0513 (UTC) FILETIME=[2427EC10:01C7F904]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For machine with some new BIOS other than legacy BIOS, such as EFI,
LinuxBIOS, etc, and kexec, the 16-bit real mode setup code in kernel
based on legacy BIOS can not be used, so a 32-bit boot protocol need
to be defined.

This patchset defines a 32-bit boot protocol for i386 and x86_64. A
linked list based boot parameters pass mechanism is also added to
improve the extensibility.

The patchset has been tested against 2.6.23-rc4-mm1 kernel on x86_64.

This patchset is based on the proposal of Peter Anvin.

Known Issues:

1. Where is safe to place the linked list of setup_data?

Because the length of the linked list of setup_data is variable, it
can not be copied into BSS segment of kernel as that of "zero
page". We must find a safe place for it, where it will not be
overwritten by kernel during booting up. The i386 kernel will
overwrite some pages after _end. The x86_64 kernel will overwrite some
pages from 0x1000 on.

EFI64 runtime service is the first user of 32-bit boot protocol and
boot parameters passing mechanism. To demonstrate their usage, the
EFI64 runtime service patch is also appended with the mail.

Best Regards,
Huang Ying

---

 Documentation/i386/boot.txt            |   15 
 Documentation/x86_64/boot-options.txt  |   12 
 arch/x86_64/Kconfig                    |   11 
 arch/x86_64/kernel/Makefile            |    1 
 arch/x86_64/kernel/efi.c               |  597 +++++++++++++++++++++++++++++++++
 arch/x86_64/kernel/efi_callwrap.S      |   69 +++
 arch/x86_64/kernel/reboot.c            |   20 -
 arch/x86_64/kernel/setup.c             |   14 
 arch/x86_64/kernel/time.c              |   48 +-
 include/asm-i386/bootparam.h           |   10 
 include/asm-x86_64/efi.h               |   18 
 include/asm-x86_64/eficallwrap.h       |   33 +
 include/asm-x86_64/emergency-restart.h |    9 
 include/asm-x86_64/fixmap.h            |    3 
 include/asm-x86_64/time.h              |    7 
 15 files changed, 842 insertions(+), 25 deletions(-)

Index: linux-2.6.23-rc4/include/asm-x86_64/eficallwrap.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc4/include/asm-x86_64/eficallwrap.h	2007-09-17 15:03:47.000000000 +0800
@@ -0,0 +1,33 @@
+/*
+ *  Copyright (C) 2007 Intel Corp
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ *  Function calling ABI conversion from SYSV to Windows for x86_64
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM_X86_64_EFICALLWRAP_H
+#define __ASM_X86_64_EFICALLWRAP_H
+
+extern efi_status_t lin2win0(void *fp);
+extern efi_status_t lin2win1(void *fp, u64 arg1);
+extern efi_status_t lin2win2(void *fp, u64 arg1, u64 arg2);
+extern efi_status_t lin2win3(void *fp, u64 arg1, u64 arg2, u64 arg3);
+extern efi_status_t lin2win4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
+extern efi_status_t lin2win5(void *fp, u64 arg1, u64 arg2, u64 arg3,
+			     u64 arg4, u64 arg5);
+extern efi_status_t lin2win6(void *fp, u64 arg1, u64 arg2, u64 arg3,
+			     u64 arg4, u64 arg5, u64 arg6);
+
+#endif
Index: linux-2.6.23-rc4/arch/x86_64/kernel/efi.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc4/arch/x86_64/kernel/efi.c	2007-09-17 15:03:47.000000000 +0800
@@ -0,0 +1,597 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 1.0
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ *	Stephane Eranian <eranian@hpl.hp.com>
+ * Copyright (C) 2005-2008 Intel Co.
+ *	Fenghua Yu <fenghua.yu@intel.com>
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Chandramouli Narayanan <mouli@linux.intel.com>
+ *
+ * Code to convert EFI to E820 map has been implemented in elilo bootloader
+ * based on a EFI patch by Edgar Hucek. Based on the E820 map, the page table
+ * is setup appropriately for EFI runtime code.
+ * - mouli 06/14/2007.
+ *
+ * All EFI Runtime Services are not implemented yet as EFI only
+ * supports physical mode addressing on SoftSDV. This is to be fixed
+ * in a future version.  --drummond 1999-07-20
+ *
+ * Implemented EFI runtime services and virtual mode calls.  --davidm
+ *
+ * Goutham Rao: <goutham.rao@intel.com>
+ *	Skip non-WB memory and ignore empty memory ranges.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/time.h>
+#include <linux/spinlock.h>
+#include <linux/bootmem.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/efi.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/reboot.h>
+
+#include <asm/setup.h>
+#include <asm/bootparam.h>
+#include <asm/page.h>
+#include <asm/e820.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
+#include <asm/proto.h>
+#include <asm/eficallwrap.h>
+#include <asm/efi.h>
+#include <asm/time.h>
+
+int efi_enabled;
+EXPORT_SYMBOL(efi_enabled);
+
+struct efi efi;
+EXPORT_SYMBOL(efi);
+
+struct efi_memory_map memmap;
+
+struct efi efi_phys __initdata;
+static efi_system_table_t efi_systab __initdata;
+static unsigned long efi_flags __initdata;
+/* efi_lock protects efi physical mode call */
+static spinlock_t efi_lock __initdata = SPIN_LOCK_UNLOCKED;
+static pgd_t save_pgd __initdata;
+static int noefi_time __initdata;
+
+static int __init setup_noefi(char *arg)
+{
+	efi_enabled = 0;
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
+static int __init setup_noefi_time(char *arg)
+{
+	noefi_time = 1;
+	return 0;
+}
+early_param("noefi_time", setup_noefi_time);
+
+static efi_status_t _efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return lin2win2((void *)efi.systab->runtime->get_time,
+			(u64)tm, (u64)tc);
+}
+
+static efi_status_t _efi_set_time(efi_time_t *tm)
+{
+	return lin2win1((void *)efi.systab->runtime->set_time, (u64)tm);
+}
+
+static efi_status_t _efi_get_wakeup_time(efi_bool_t *enabled,
+					 efi_bool_t *pending,
+					 efi_time_t *tm)
+{
+	return lin2win3((void *)efi.systab->runtime->get_wakeup_time,
+			(u64)enabled, (u64)pending, (u64)tm);
+}
+
+static efi_status_t _efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	return lin2win2((void *)efi.systab->runtime->set_wakeup_time,
+			(u64)enabled, (u64)tm);
+}
+
+static efi_status_t _efi_get_variable(efi_char16_t *name,
+				      efi_guid_t *vendor,
+				      u32 *attr,
+				      unsigned long *data_size,
+				      void *data)
+{
+	return lin2win5((void *)efi.systab->runtime->get_variable,
+			(u64)name, (u64)vendor, (u64)attr,
+			(u64)data_size, (u64)data);
+}
+
+static efi_status_t _efi_get_next_variable(unsigned long *name_size,
+					   efi_char16_t *name,
+					   efi_guid_t *vendor)
+{
+	return lin2win3((void *)efi.systab->runtime->get_next_variable,
+			(u64)name_size, (u64)name, (u64)vendor);
+}
+
+static efi_status_t _efi_set_variable(
+			efi_char16_t *name, efi_guid_t *vendor,
+			u64 attr, u64 data_size, void *data)
+{
+	return lin2win5((void *)efi.systab->runtime->set_variable,
+			(u64)name, (u64)vendor, (u64)attr,
+			(u64)data_size, (u64)data);
+}
+
+static efi_status_t _efi_get_next_high_mono_count(u32 *count)
+{
+	return lin2win1((void *)efi.systab->runtime->get_next_high_mono_count,
+			(u64)count);
+}
+
+static efi_status_t _efi_reset_system(int reset_type,
+				      efi_status_t status,
+				      unsigned long data_size,
+				      efi_char16_t *data)
+{
+	return lin2win4((void *)efi.systab->runtime->reset_system,
+			(u64)reset_type, (u64)status,
+			(u64)data_size, (u64)data);
+}
+
+static efi_status_t _efi_set_virtual_address_map(
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	return lin2win4((void *)efi.systab->runtime->set_virtual_address_map,
+			(u64)memory_map_size, (u64)descriptor_size,
+			(u64)descriptor_version, (u64)virtual_map);
+}
+
+static void __init early_mapping_set_exec(unsigned long start,
+					  unsigned long end,
+					  int executable)
+{
+	pte_t *kpte;
+
+	while (start < end) {
+		kpte = lookup_address((unsigned long)__va(start));
+		BUG_ON(!kpte);
+		if (executable)
+			set_pte(kpte, pte_mkexec(*kpte));
+		else
+			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
+					    __supported_pte_mask));
+		if (pte_huge(*kpte))
+			start = (start + PMD_SIZE) & PMD_MASK;
+		else
+			start = (start + PAGE_SIZE) & PAGE_MASK;
+	}
+}
+
+static void __init early_runtime_code_mapping_set_exec(int executable)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	/* Make EFI runtime service code area executable */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
+			unsigned long end;
+			end = md->phys_addr + (md->num_pages << PAGE_SHIFT);
+			early_mapping_set_exec(md->phys_addr, end, executable);
+		}
+	}
+}
+
+static void __init efi_call_phys_prelog(void) __acquires(efi_lock)
+{
+	unsigned long vaddress;
+
+	/*
+	 * Lock sequence is different from normal case because
+	 * efi_flags is global
+	 */
+	spin_lock(&efi_lock);
+	local_irq_save(efi_flags);
+	early_runtime_code_mapping_set_exec(1);
+	vaddress = (unsigned long)__va(0x0UL);
+	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
+	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
+	global_flush_tlb();
+}
+
+static void __init efi_call_phys_epilog(void) __releases(efi_lock)
+{
+	/*
+	 * After the lock is released, the original page table is restored.
+	 */
+	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	early_runtime_code_mapping_set_exec(0);
+	global_flush_tlb();
+	local_irq_restore(efi_flags);
+	spin_unlock(&efi_lock);
+}
+
+static efi_status_t __init phys_efi_set_virtual_address_map(
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = lin2win4((void *)efi_phys.set_virtual_address_map,
+			  (u64)memory_map_size, (u64)descriptor_size,
+			  (u64)descriptor_version, (u64)virtual_map);
+	efi_call_phys_epilog();
+	return status;
+}
+
+static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
+					     efi_time_cap_t *tc)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = lin2win2((void *)efi_phys.get_time, (u64)tm, (u64)tc);
+	efi_call_phys_epilog();
+	return status;
+}
+
+/*
+ * To call this function, the irq must be disabled and rtc_lock in
+ * time.c must be held.
+ */
+int efi_set_rtc_mmss(unsigned long nowtime)
+{
+	int real_seconds, real_minutes;
+	efi_status_t 	status;
+	efi_time_t 	eft;
+	efi_time_cap_t 	cap;
+
+	status = efi.get_time(&eft, &cap);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		return -1;
+	}
+
+	real_seconds = nowtime % 60;
+	real_minutes = nowtime / 60;
+	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
+		real_minutes += 30;
+	real_minutes %= 60;
+	eft.minute = real_minutes;
+	eft.second = real_seconds;
+
+	status = efi.set_time(&eft);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR "Oops: efitime: can't write time!\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * To call this function, the irq must be disabled and rtc_lock in
+ * time.c must be held.
+ */
+unsigned long efi_get_time(void)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+
+	status = efi.get_time(&eft, &cap);
+	if (status != EFI_SUCCESS)
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+
+	return mktime(eft.year, eft.month, eft.day, eft.hour,
+		      eft.minute, eft.second);
+}
+
+void __init efi_reserve_bootmem(void)
+{
+	reserve_bootmem_generic((unsigned long)memmap.phys_map,
+				memmap.nr_map * memmap.desc_size);
+}
+
+void __init parse_efi64_info(struct setup_data *setup_data,
+			     unsigned long pa_setup_data)
+{
+	struct efi64_info *efi64_info = (struct efi64_info *)setup_data->data;
+
+	memset(&efi, 0, sizeof(efi));
+	memset(&efi_phys, 0, sizeof(efi_phys));
+
+	efi_phys.systab = (efi_system_table_t *)efi64_info->efi_systab;
+	memmap.phys_map = (void *)pa_setup_data +
+		((char *)efi64_info->efi_memmap - (char *)setup_data);
+	memmap.nr_map = efi64_info->efi_memmap_size /
+		efi64_info->efi_memdesc_size;
+	memmap.desc_version = efi64_info->efi_memdesc_version;
+	memmap.desc_size = efi64_info->efi_memdesc_size;
+
+	efi_enabled = 1;
+}
+
+void __init efi_init(void)
+{
+	efi_config_table_t *config_tables;
+	efi_runtime_services_t *runtime;
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i = 0;
+
+	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
+				   sizeof(efi_system_table_t));
+	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
+	efi.systab = &efi_systab;
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		printk(KERN_ERR "Woah! EFI system table "
+		       "signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_ERR "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff);
+
+	/*
+	 * Show what we know for posterity
+	 */
+	c16 = early_ioremap(efi.systab->fw_vendor, 2);
+	if (!probe_kernel_address(c16, i)) {
+		for (i = 0; i < sizeof(vendor) && *c16; ++i)
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	}
+
+	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = early_ioremap(
+		efi.systab->tables,
+		efi.systab->nr_tables * sizeof(efi_config_table_t));
+	if (config_tables == NULL)
+		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
+
+	printk(KERN_INFO);
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
+			efi.mps = config_tables[i].table;
+			printk(" MPS=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					ACPI_20_TABLE_GUID)) {
+			efi.acpi20 = config_tables[i].table;
+			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					ACPI_TABLE_GUID)) {
+			efi.acpi = config_tables[i].table;
+			printk(" ACPI=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					SMBIOS_TABLE_GUID)) {
+			efi.smbios = config_tables[i].table;
+			printk(" SMBIOS=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					HCDP_TABLE_GUID)) {
+			efi.hcdp = config_tables[i].table;
+			printk(" HCDP=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					UGA_IO_PROTOCOL_GUID)) {
+			efi.uga = config_tables[i].table;
+			printk(" UGA=0x%lx ", config_tables[i].table);
+		}
+	}
+	printk("\n");
+
+	/*
+	 * Check out the runtime services table. We need to map
+	 * the runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
+	 */
+	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+				sizeof(efi_runtime_services_t));
+	if (runtime != NULL) {
+		/*
+		 * We will only need *early* access to the following
+		 * two EFI runtime services before set_virtual_address_map
+		 * is invoked.
+		 */
+		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
+		efi_phys.set_virtual_address_map =
+			(efi_set_virtual_address_map_t *)runtime->set_virtual_address_map;
+		/*
+		 * Make efi_get_time can be called before entering
+		 * virtual mode.
+		 */
+		efi.get_time = phys_efi_get_time;
+	} else
+		printk(KERN_ERR "Could not map the EFI runtime service "
+		       "table!\n");
+
+	/* Map the EFI memory map */
+	memmap.map = __va((unsigned long)memmap.phys_map);
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+	if (memmap.desc_size != sizeof(efi_memory_desc_t))
+		printk(KERN_WARNING "Kernel-defined memdesc"
+		       "doesn't match the one from EFI!\n");
+
+	/* Setup for EFI runtime service */
+	reboot_type = BOOT_EFI;
+
+	if (!noefi_time) {
+		get_wallclock = efi_get_time;
+		set_wallclock = efi_set_rtc_mmss;
+	}
+}
+
+static void __init runtime_code_page_mkexec(void)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	/* Make EFI runtime service code area executable */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			change_page_attr_addr(md->virt_addr,
+					      md->num_pages,
+					      PAGE_KERNEL_EXEC);
+	}
+	global_flush_tlb();
+}
+
+static void __iomem * __init efi_ioremap(unsigned long offset,
+					 unsigned long size)
+{
+	static unsigned pages_mapped;
+	unsigned long last_addr;
+	unsigned i, pages;
+
+	last_addr = offset + size - 1;
+	offset &= PAGE_MASK;
+	pages = (PAGE_ALIGN(last_addr) - offset) >> PAGE_SHIFT;
+	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
+		return NULL;
+
+	for (i = 0; i < pages; i++) {
+		set_fixmap_nocache(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
+				   offset);
+		offset += PAGE_SIZE;
+		pages_mapped++;
+	}
+
+	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
+					     (pages_mapped - pages));
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor and update
+ * that memory descriptor with the virtual address obtained from ioremap().
+ * This enables the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_memory_desc_t *md;
+	efi_status_t status;
+	unsigned long end;
+	void *p;
+
+	efi.systab = NULL;
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->attribute & EFI_MEMORY_WB)
+			md->virt_addr = (unsigned long)__va(md->phys_addr);
+		else if (md->attribute & (EFI_MEMORY_UC | EFI_MEMORY_WC))
+			md->virt_addr = (unsigned long)
+				efi_ioremap(md->phys_addr,
+					    md->num_pages << EFI_PAGE_SHIFT);
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
+		    ((unsigned long)efi_phys.systab < end))
+			efi.systab = (efi_system_table_t *)
+				(md->virt_addr - md->phys_addr +
+				 (unsigned long)efi_phys.systab);
+	}
+
+	BUG_ON(!efi.systab);
+
+	status = phys_efi_set_virtual_address_map(
+		memmap.desc_size * memmap.nr_map,
+		memmap.desc_size,
+		memmap.desc_version,
+		memmap.phys_map);
+
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ALERT "You are screwed! "
+		       "Unable to switch EFI into virtual mode "
+		       "(status=%lx)\n", status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
+	}
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+	efi.get_time = (efi_get_time_t *)_efi_get_time;
+	efi.set_time = (efi_set_time_t *)_efi_set_time;
+	efi.get_wakeup_time = (efi_get_wakeup_time_t *)_efi_get_wakeup_time;
+	efi.set_wakeup_time = (efi_set_wakeup_time_t *)_efi_set_wakeup_time;
+	efi.get_variable = (efi_get_variable_t *)_efi_get_variable;
+	efi.get_next_variable = (efi_get_next_variable_t *)
+		_efi_get_next_variable;
+	efi.set_variable = (efi_set_variable_t *)_efi_set_variable;
+	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
+		_efi_get_next_high_mono_count;
+	efi.reset_system = (efi_reset_system_t *)_efi_reset_system;
+	efi.set_virtual_address_map = (efi_set_virtual_address_map_t *)
+		_efi_set_virtual_address_map;
+
+	runtime_code_page_mkexec();
+}
+
+/*
+ * Convenience functions to obtain memory types and attributes
+ */
+u32 efi_mem_type(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->type;
+	}
+	return 0;
+}
+
+u64 efi_mem_attributes(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->attribute;
+	}
+	return 0;
+}
Index: linux-2.6.23-rc4/arch/x86_64/kernel/efi_callwrap.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc4/arch/x86_64/kernel/efi_callwrap.S	2007-09-17 15:03:47.000000000 +0800
@@ -0,0 +1,69 @@
+/*
+ * linux/arch/x86_64/kernel/efi_callwrap.S -- Function calling ABI
+ *	conversion from SYSV to Windows for x86_64
+ *
+ * Copyright (C) 2007 Intel Corp
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ */
+
+#include <linux/linkage.h>
+
+ENTRY(lin2win0)
+	subq $40, %rsp
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win1)
+	subq $40, %rsp
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win2)
+	subq $40, %rsp
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win3)
+	subq $40, %rsp
+	mov  %rcx, %r8
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win4)
+	subq $40, %rsp
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win5)
+	subq $40, %rsp
+	mov %r9, 32(%rsp)
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win6)
+	subq $56, %rsp
+	mov 56+8(%rsp), %rax
+	mov %r9, 32(%rsp)
+	mov %rax, 40(%rsp)
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $56, %rsp
+	ret
Index: linux-2.6.23-rc4/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.23-rc4.orig/arch/x86_64/kernel/setup.c	2007-09-17 15:02:33.000000000 +0800
+++ linux-2.6.23-rc4/arch/x86_64/kernel/setup.c	2007-09-17 15:03:47.000000000 +0800
@@ -44,6 +44,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/efi.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -63,6 +64,7 @@
 #include <asm/numa.h>
 #include <asm/sections.h>
 #include <asm/dmi.h>
+#include <asm/efi.h>
 
 /*
  * Machine setup..
@@ -230,6 +232,9 @@
 	while (pa_setup_data) {
 		setup_data = early_ioremap(pa_setup_data, PAGE_SIZE);
 		switch (setup_data->type) {
+		case SETUP_EFI64_INFO:
+			parse_efi64_info(setup_data, pa_setup_data);
+			break;
 		default:
 			break;
 		}
@@ -292,6 +297,8 @@
 	discover_ebda();
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	if (efi_enabled)
+		efi_init();
 
 	dmi_scan_machine();
 
@@ -384,6 +391,10 @@
         */
        acpi_reserve_bootmem();
 #endif
+
+	if (efi_enabled)
+		efi_reserve_bootmem();
+
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
@@ -459,7 +470,8 @@
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
Index: linux-2.6.23-rc4/include/asm-x86_64/fixmap.h
===================================================================
--- linux-2.6.23-rc4.orig/include/asm-x86_64/fixmap.h	2007-09-17 15:02:33.000000000 +0800
+++ linux-2.6.23-rc4/include/asm-x86_64/fixmap.h	2007-09-17 15:03:47.000000000 +0800
@@ -15,6 +15,7 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
+#include <asm/efi.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
@@ -41,6 +42,8 @@
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS-1,
+	FIX_EFI_IO_MAP_LAST_PAGE,
+	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE+MAX_EFI_IO_PAGES-1,
 	__end_of_fixed_addresses
 };
 
Index: linux-2.6.23-rc4/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.23-rc4.orig/arch/x86_64/Kconfig	2007-09-17 15:02:33.000000000 +0800
+++ linux-2.6.23-rc4/arch/x86_64/Kconfig	2007-09-17 15:03:47.000000000 +0800
@@ -280,6 +280,17 @@
 	depends on SMP && !MK8
 	default y
 
+config EFI
+	bool "EFI runtime service support (EXPERIMENTAL)"
+	---help---
+	  This enables the kernel to use any EFI runtime services that are
+	  available (such as the EFI variable services).
+	  This option is only useful on systems that have EFI firmware
+	  and will result in a kernel image that is ~8k larger. However,
+	  even with this option, the resultant kernel should continue to
+	  boot on existing non-EFI platforms. For more information on
+	  how to set up [U]EFI64 system, see Documentation/x86_64/uefi.txt.
+
 config MATH_EMULATION
 	bool
 
Index: linux-2.6.23-rc4/arch/x86_64/kernel/Makefile
===================================================================
--- linux-2.6.23-rc4.orig/arch/x86_64/kernel/Makefile	2007-09-17 15:02:33.000000000 +0800
+++ linux-2.6.23-rc4/arch/x86_64/kernel/Makefile	2007-09-17 15:03:47.000000000 +0800
@@ -39,6 +39,7 @@
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 obj-$(CONFIG_STACK_UNWIND)	+= unwind.o
+obj-$(CONFIG_EFI)		+= efi.o efi_callwrap.o
 
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
Index: linux-2.6.23-rc4/include/asm-i386/bootparam.h
===================================================================
--- linux-2.6.23-rc4.orig/include/asm-i386/bootparam.h	2007-09-17 15:02:33.000000000 +0800
+++ linux-2.6.23-rc4/include/asm-i386/bootparam.h	2007-09-17 15:03:47.000000000 +0800
@@ -11,6 +11,7 @@
 
 /* setup data types */
 #define SETUP_NONE			0
+#define SETUP_EFI64_INFO		1
 
 /* extensible setup data list node */
 struct setup_data {
@@ -101,4 +102,13 @@
 	u8  _pad9[276];					/* 0xeec */
 } __attribute__((packed));
 
+struct efi64_info {
+	u64 efi_systab;
+	u32 efi_memmap_size;
+	u32 efi_memdesc_size;
+	u32 efi_memdesc_version;
+	u32 _pad1;
+	u8  efi_memmap[0];
+} __attribute__((packed));
+
 #endif /* _ASM_BOOTPARAM_H */
Index: linux-2.6.23-rc4/include/asm-x86_64/efi.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc4/include/asm-x86_64/efi.h	2007-09-17 15:03:47.000000000 +0800
@@ -0,0 +1,18 @@
+#ifndef __ASM_X86_64_EFI_H
+#define __ASM_X86_64_EFI_H
+
+#include <asm/bootparam.h>
+
+#define MAX_EFI_IO_PAGES	100
+
+extern void efi_reserve_bootmem(void);
+#ifdef CONFIG_EFI
+extern void parse_efi64_info(struct setup_data *setup_data,
+			     unsigned long pa_setup_data);
+#else
+static inline void parse_efi64_info(struct setup_data *setup_data,
+				    unsigned long pa_setup_data)
+{ }
+#endif
+
+#endif
Index: linux-2.6.23-rc4/arch/x86_64/kernel/reboot.c
===================================================================
--- linux-2.6.23-rc4.orig/arch/x86_64/kernel/reboot.c	2007-09-17 15:02:32.000000000 +0800
+++ linux-2.6.23-rc4/arch/x86_64/kernel/reboot.c	2007-09-17 15:03:47.000000000 +0800
@@ -9,6 +9,7 @@
 #include <linux/pm.h>
 #include <linux/kdebug.h>
 #include <linux/sched.h>
+#include <linux/efi.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/delay.h>
@@ -27,20 +28,17 @@
 EXPORT_SYMBOL(pm_power_off);
 
 static long no_idt[3];
-static enum { 
-	BOOT_TRIPLE = 't',
-	BOOT_KBD = 'k',
-	BOOT_ACPI = 'a'
-} reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_KBD;
 static int reboot_mode = 0;
 int reboot_force;
 
-/* reboot=t[riple] | k[bd] [, [w]arm | [c]old]
+/* reboot=t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
    acpi   Use the RESET_REG in the FADT
+   efi    Use efi reset_system runtime service
    force  Avoid anything that could hang.
  */ 
 static int __init reboot_setup(char *str)
@@ -59,6 +57,7 @@
 		case 'a':
 		case 'b':
 		case 'k':
+		case 'e':
 			reboot_type = *str;
 			break;
 		case 'f':
@@ -151,7 +150,14 @@
 			acpi_reboot();
 			reboot_type = BOOT_KBD;
 			break;
-		}      
+
+		case BOOT_EFI:
+			if (efi_enabled)
+				efi.reset_system(reboot_mode ? EFI_RESET_WARM : EFI_RESET_COLD,
+						 EFI_SUCCESS, 0, NULL);
+			reboot_type = BOOT_KBD;
+			break;
+		}
 	}      
 }
 
Index: linux-2.6.23-rc4/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.23-rc4.orig/arch/x86_64/kernel/time.c	2007-09-17 15:02:32.000000000 +0800
+++ linux-2.6.23-rc4/arch/x86_64/kernel/time.c	2007-09-17 15:03:47.000000000 +0800
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #include <linux/clockchips.h>
 
@@ -47,12 +48,19 @@
 #include <asm/mpspec.h>
 #include <asm/nmi.h>
 #include <asm/vgtod.h>
+#include <asm/time.h>
 
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
 volatile unsigned long __jiffies __section_jiffies = INITIAL_JIFFIES;
 
+static int set_rtc_mmss(unsigned long nowtime);
+static unsigned long read_cmos_clock(void);
+
+unsigned long (*get_wallclock)(void) = read_cmos_clock;
+int (*set_wallclock)(unsigned long nowtime) = set_rtc_mmss;
+
 unsigned long profile_pc(struct pt_regs *regs)
 {
 	unsigned long pc = instruction_pointer(regs);
@@ -86,13 +94,6 @@
 	unsigned char control, freq_select;
 
 /*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
- */
-
-	spin_lock(&rtc_lock);
-
-/*
  * Tell the clock it's being set and stop it.
  */
 
@@ -140,14 +141,23 @@
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
-
 	return retval;
 }
 
 int update_persistent_clock(struct timespec now)
 {
-	return set_rtc_mmss(now.tv_sec);
+	int retval;
+
+/*
+ * IRQs are disabled when we're called from the timer interrupt,
+ * no need for spin_lock_irqsave()
+ */
+
+	spin_lock(&rtc_lock);
+	retval = set_wallclock(now.tv_sec);
+	spin_unlock(&rtc_lock);
+
+	return retval;
 }
 
 static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
@@ -157,14 +167,11 @@
 	return IRQ_HANDLED;
 }
 
-unsigned long read_persistent_clock(void)
+static unsigned long read_cmos_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
-	unsigned long flags;
 	unsigned century = 0;
 
-	spin_lock_irqsave(&rtc_lock, flags);
-
 	do {
 		sec = CMOS_READ(RTC_SECONDS);
 		min = CMOS_READ(RTC_MINUTES);
@@ -179,8 +186,6 @@
 #endif
 	} while (sec != CMOS_READ(RTC_SECONDS));
 
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
 	/*
 	 * We know that x86-64 always uses BCD format, no need to check the
 	 * config register.
@@ -208,6 +213,17 @@
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+unsigned long read_persistent_clock(void)
+{
+	unsigned long flags, retval;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	retval = get_wallclock();
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
+	return retval;
+}
+
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
Index: linux-2.6.23-rc4/include/asm-x86_64/emergency-restart.h
===================================================================
--- linux-2.6.23-rc4.orig/include/asm-x86_64/emergency-restart.h	2007-09-17 15:02:32.000000000 +0800
+++ linux-2.6.23-rc4/include/asm-x86_64/emergency-restart.h	2007-09-17 15:03:47.000000000 +0800
@@ -1,6 +1,15 @@
 #ifndef _ASM_EMERGENCY_RESTART_H
 #define _ASM_EMERGENCY_RESTART_H
 
+enum reboot_type {
+	BOOT_TRIPLE = 't',
+	BOOT_KBD = 'k',
+	BOOT_ACPI = 'a',
+	BOOT_EFI = 'e'
+};
+
+extern enum reboot_type reboot_type;
+
 extern void machine_emergency_restart(void);
 
 #endif /* _ASM_EMERGENCY_RESTART_H */
Index: linux-2.6.23-rc4/include/asm-x86_64/time.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc4/include/asm-x86_64/time.h	2007-09-17 15:03:47.000000000 +0800
@@ -0,0 +1,7 @@
+#ifndef __ASM_X86_64_TIME_H
+#define __ASM_X86_64_TIME_H
+
+extern unsigned long (*get_wallclock)(void);
+extern int (*set_wallclock)(unsigned long nowtime);
+
+#endif
Index: linux-2.6.23-rc4/Documentation/x86_64/boot-options.txt
===================================================================
--- linux-2.6.23-rc4.orig/Documentation/x86_64/boot-options.txt	2007-09-17 15:02:31.000000000 +0800
+++ linux-2.6.23-rc4/Documentation/x86_64/boot-options.txt	2007-09-17 15:03:47.000000000 +0800
@@ -110,7 +110,7 @@
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] | a[cpi] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | a[cpi] | e[fi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
@@ -119,6 +119,9 @@
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
           the keyboard controller.
+   efi    Use efi reset_system runtime service. If EFI is not configured or the
+          EFI reset does not work, the reboot path attempts the reset using
+          the keyboard controller.
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
@@ -303,4 +306,11 @@
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
+EFI
+
+  noefi		Disable EFI support
+
+  noefi_time	Disable EFI time runtime service, programming CMOS
+  		hardware directly
+
 Miscellaneous
Index: linux-2.6.23-rc4/Documentation/i386/boot.txt
===================================================================
--- linux-2.6.23-rc4.orig/Documentation/i386/boot.txt	2007-09-17 15:03:46.000000000 +0800
+++ linux-2.6.23-rc4/Documentation/i386/boot.txt	2007-09-17 15:03:47.000000000 +0800
@@ -793,6 +793,21 @@
 
 **** SETUP DATA TYPES
 
+Type name:	UEFI 64 information
+Protocol:	2.07+
+
+  The UEFI 64 firmware information, including UEFI system table and memory map
+  information. The definition is as follow:
+
+  struct efi64_info {
+          u64 efi_systab;		/* EFI system table pointer */
+          u32 efi_memmap_size;		/* EFI memory descriptor map size */
+          u32 efi_memdesc_size;		/* EFI memory descriptor size */
+          u32 efi_memdesc_version;	/* EFI memory descriptor version */
+          u32 _pad1;
+          u8  efi_memmap[0];		/* EFI memory descriptor map */
+  } __attribute__((packed));
+
 
 **** 32-bit BOOT PROTOCOL
 
