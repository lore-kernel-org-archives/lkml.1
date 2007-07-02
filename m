Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbXGBUg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbXGBUg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbXGBUfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:35:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:10855 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbXGBUf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,488,1175497200"; 
   d="scan'208";a="102273184"
Message-Id: <20070702170707.688670000@em64tdvp.jf.intel.com>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
Date: Mon, 02 Jul 2007 10:06:15 -0700
From: Chandramouli Narayanan <mouli@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: [PATCH 2.6.21 1/3] x86_64 EFI64 support Try #2
Content-Disposition: inline; filename=patch1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EFI x86_64 support Patch 1 of 3 (try #2)
----------------------------------------
- Being experimental, dropped default option for CONFIG_EFI.

- Implemented EFI to E820 memory map conversion. This is based on
  bootloader support. The ELILO bootloader x86_64 support has been
  updated to pass E820 map to kernel. This simplified kernel efi code.
  Also the duplicate code for setting up page table for
  EFI run time is gotten rid of with simpler patch.

  ------------------------------------------------------------------
  NOTE: The ELILO patch to perform EFI to E820 map conversion is being
  submitted to sourceforge project maintainer. 
  ------------------------------------------------------------------

- UEFI wrapper code in earlier patch is now replaced with code adapted from
  NDIS wrapper sourceforge project.

- Parameters in EFI calls are cast to (u64) to rid build warnings.

- Code that is supposed to be __init only in arch/x86_64/kernel/efi.c 
  is prefixed as such.

- Documentation/x86_64/uefi.txt adds instructions on how to set up EFI64
  system.

- Documentation/i386/zero-page.txt notes differences in the boot parameters
  for x86_64. The efi init code uses these parameters passed by the bootloader.

- Added missing KERN_ prefixes in EFI code. probe_kernel_address() used for
  checking firmware vendor in efi init code.

- The dependency on X86_64 in the configuration of EFI_RTC is dropped
  since we have hardware realtime clock support

Issues _not_ addressed (per feedback from Eric Biederman)

- Virtual mode support is still retained in this patch. On looking at the 
  configuration options, the EFI variable support is required at runtime.
  For instance, the firmware driver configuration support with EFI variable
  via sysfs would require this. I'm not sure if virtual mode support
  can be killed altogether. More investigation needed here.

- The variable efi_enabled is used throughout across architecutres if
  CONFIG_EFI option is enabled. The i386 code also uses this variable.
  This is something that can be revisited with code consolidation across
  architectures.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/Documentation/i386/zero-page.txt linux-2.6.21-uefi-finaltest4/Documentation/i386/zero-page.txt
--- linux-2.6.21-orig/Documentation/i386/zero-page.txt	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/Documentation/i386/zero-page.txt	2007-06-21 17:22:49.000000000 -0700
@@ -31,11 +31,11 @@ Offset	Type		Description
  0xb0 - 0x13f		Free. Add more parameters here if you really need them.
  0x140- 0x1be		EDID_INFO Video mode setup
 
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
+0x1c4	unsigned long	EFI system table pointer*
+0x1c8	unsigned long	EFI memory descriptor size*
+0x1cc	unsigned long	EFI memory descriptor version*
 0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
+0x1d4	unsigned long	EFI memory descriptor map size*
 0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
 0x1e8	char		number of entries in E820MAP (below)
 0x1e9	unsigned char	number of entries in EDDBUF (below)
@@ -86,3 +86,13 @@ Offset	Type		Description
 0x2d0 - 0xd00		E820MAP
 0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
 0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+
+Changes for x86_64 implementation:
+---------------------------------
+For alignment purposes, the following parameters are rearranged.
+
+0x1b8	unsigned long	EFI system table pointer
+0x1c0	unsigned long	EFI Loader signature
+0x1c4	unsigned long	EFI memory descriptor size
+0x1c8	unsigned long	EFI memory descriptor version
+0x1cc	unsigned long	EFI memory descriptor map size
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/Documentation/x86_64/uefi.txt linux-2.6.21-uefi-finaltest4/Documentation/x86_64/uefi.txt
--- linux-2.6.21-orig/Documentation/x86_64/uefi.txt	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21-uefi-finaltest4/Documentation/x86_64/uefi.txt	2007-06-25 14:47:24.000000000 -0700
@@ -0,0 +1,42 @@
+General note on [U]EFI x86_64 support
+-------------------------------------
+
+This provides documentation on [U]EFI support for x86_64 architecture.
+The nomenclature EFI and UEFI are used intechangeably in this document.
+
+Although the tools below are _not_ needed for building the kernel,
+the needed bootloader support and associated tools for x86_64 platforms
+with EFI firmware and specifications are listed below.
+
+1. UEFI specification:  http://www.uefi.org
+
+2. Booting EFI64 enabled kernel requires boot loader support.
+Patches to elilo and gnu-efi library with x86_64 support and documentation
+have been submitted to respective project maintainers.
+	elilo: http://sourceforge.net/projects/elilo
+	gnu-efi library: http://sourceforge.net/projects/gnu-efi/
+	gnu-efi-3.0d release now supports [U]EFI x86_64.
+
+3. The tool to convert ELF to PE-COFF image:
+	binutils-2.17.50.0.14 supports Intel64 EFI.
+	see http://www.kernel.org/pub/linux/devel/binutils/
+	[ elilo/gnu-efi with x86_64 support need this binutils support ]
+
+4. x86_64 platform with EFI/UEFI firmware.
+ 
+Mechanics:
+---------
+- Apply the EFI64 kernel patches and build with the following configuration.
+	CONFIG_EFI=y
+	EFI_FB=y
+	CONFIG_FRAMEBUFFER_CONSOLE=y
+	CONFIG_EFI_VARS=y
+  
+- Create a VFAT partition on the disk
+- Copy the following to the VFAT partition:
+	elilo bootloader with x86_64 support and elilo configuration file
+	efi64 kernel image and initrd. Instructions on building elilo
+	and its dependencies can be found in the elilo sourceforge project.
+- Boot to EFI shell and invoke elilo choosing efi64 kernel image
+- On UEFI2.0 firmware systems, pass vga=normal for boot messages to show up
+  console. You can pass along the 'resume' boot option to test suspend/resume.
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/Kconfig linux-2.6.21-uefi-finaltest4/arch/x86_64/Kconfig
--- linux-2.6.21-orig/arch/x86_64/Kconfig	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/Kconfig	2007-06-26 16:55:30.000000000 -0700
@@ -254,6 +254,19 @@ config X86_HT
 	depends on SMP && !MK8
 	default y
 
+config EFI
+	bool "Boot from EFI support (EXPERIMENTAL)"
+	---help---
+	  This enables the the kernel to boot on EFI platforms using
+	  system configuration information passed to it from the firmware.
+	  This also enables the kernel to use any EFI runtime services that are
+	  available (such as the EFI variable services).
+	  This option is only useful on systems that have EFI firmware
+	  and will result in a kernel image that is ~8k larger. However,
+	  even with this option, the resultant kernel should continue to
+	  boot on existing non-EFI platforms. For more information on
+	  how to set up [U]EFI64 system, see Documentation/x86_64/uefi.txt.
+
 config MATH_EMULATION
 	bool
 
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/include/asm-x86_64/bootsetup.h linux-2.6.21-uefi-finaltest4/include/asm-x86_64/bootsetup.h
--- linux-2.6.21-orig/include/asm-x86_64/bootsetup.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/include/asm-x86_64/bootsetup.h	2007-06-12 16:16:12.000000000 -0700
@@ -17,6 +17,12 @@ extern char x86_boot_params[BOOT_PARAM_S
 #define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
 #define DRIVE_INFO (*(struct drive_info_struct *) (PARAM+0x80))
 #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
+#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1b8)))
+#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
+#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
+#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
+#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
+#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
 #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
 #define RAMDISK_FLAGS (*(unsigned short *) (PARAM+0x1F8))
 #define SAVED_VIDEO_MODE (*(unsigned short *) (PARAM+0x1FA))
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/include/asm-x86_64/eficallwrap.h linux-2.6.21-uefi-finaltest4/include/asm-x86_64/eficallwrap.h
--- linux-2.6.21-orig/include/asm-x86_64/eficallwrap.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21-uefi-finaltest4/include/asm-x86_64/eficallwrap.h	2007-06-25 14:36:18.000000000 -0700
@@ -0,0 +1,27 @@
+/*
+ *  Copyright (C) 2006 Giridhar Pemmasani
+ *  Copyright (C) 2007-2010 Intel Corp
+ *  	Contributed by Chandramouli Narayanan<mouli@linux.intel.com>
+ *	Adapted NDIS wrapper macros from http://ndiswrapper.sourceforge.net
+ *	for EFI x86_64 linux support
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
+extern efi_status_t LIN2WIN0(void *fp);
+extern efi_status_t LIN2WIN1(void *fp, u64 arg1);
+extern efi_status_t LIN2WIN2(void *fp, u64 arg1, u64 arg2);
+extern efi_status_t LIN2WIN3(void *fp, u64 arg1, u64 arg2, u64 arg3);
+extern efi_status_t LIN2WIN4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
+extern efi_status_t LIN2WIN5(
+	void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5);
+extern efi_status_t LIN2WIN6(
+	void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5, u64 arg6);
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/include/asm-x86_64/e820.h linux-2.6.21-uefi-finaltest4/include/asm-x86_64/e820.h
--- linux-2.6.21-orig/include/asm-x86_64/e820.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/include/asm-x86_64/e820.h	2007-06-25 13:32:33.000000000 -0700
@@ -21,6 +21,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_RUNTIME_CODE	5	/* efi runtime code */
 
 #ifndef __ASSEMBLY__
 struct e820entry {
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/Makefile linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/Makefile
--- linux-2.6.21-orig/arch/x86_64/kernel/Makefile	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/Makefile	2007-06-21 12:33:43.000000000 -0700
@@ -37,6 +37,7 @@ obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
+obj-$(CONFIG_EFI)              += efi.o efi_callwrap.o
 
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/efi.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/efi.c
--- linux-2.6.21-orig/arch/x86_64/kernel/efi.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/efi.c	2007-06-26 14:39:27.000000000 -0700
@@ -0,0 +1,531 @@
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
+ * is setup appropriately for EFI runtime code. NDIS wrapper code from
+ * sourceforge project is adapted here for UEFI wrapper call.
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
+
+#include <asm/setup.h>
+#include <asm/bootsetup.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/e820.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
+#include <asm/proto.h>
+#include <asm-x86_64/eficallwrap.h>
+
+#define EFI_DEBUG	0
+#define PFX 		"EFI: "
+
+struct efi efi;
+EXPORT_SYMBOL(efi);
+
+extern void (*machine_emergency_restart_func)(void);
+
+struct efi efi_phys __initdata;
+struct efi_memory_map memmap;
+static efi_system_table_t efi_systab __initdata;
+
+static unsigned long efi_rt_eflags;
+/* efi_rt_lock protects efi physical mode call */
+static spinlock_t efi_rt_lock = SPIN_LOCK_UNLOCKED;
+static pgd_t save_pgd;
+
+static efi_status_t _efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return LIN2WIN2((void*)efi.systab->runtime->get_time,
+					(u64)tm,
+					(u64)tc); 
+}
+
+static efi_status_t _efi_set_time(efi_time_t *tm)
+{
+	return LIN2WIN1((void*)efi.systab->runtime->set_time,
+					(u64)tm); 
+}
+
+static efi_status_t _efi_get_wakeup_time(
+	efi_bool_t *enabled, efi_bool_t *pending, efi_time_t *tm)
+{
+	return LIN2WIN3((void*)efi.systab->runtime->get_wakeup_time,
+					(u64)enabled,
+					(u64)pending,
+					(u64)tm); 
+}
+
+static efi_status_t _efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	return LIN2WIN2((void*)efi.systab->runtime->set_wakeup_time,
+					(u64)enabled,
+					(u64)tm); 
+}
+
+static efi_status_t _efi_get_variable(
+	efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+	unsigned long *data_size, void *data)
+{
+	return LIN2WIN5((void*)efi.systab->runtime->get_variable,
+					(u64)name,
+					(u64)vendor,
+					(u64)attr,
+					(u64)data_size,
+					(u64)data); 
+}
+
+static efi_status_t _efi_get_next_variable(
+	unsigned long *name_size, efi_char16_t *name, efi_guid_t *vendor)
+{
+	return LIN2WIN3((void*)efi.systab->runtime->get_next_variable,
+					(u64)name_size,
+					(u64)name,
+					(u64)vendor); 
+}
+
+static efi_status_t _efi_set_variable(
+			efi_char16_t *name, efi_guid_t *vendor,
+			u64 attr, u64 data_size, void *data)
+{
+	return LIN2WIN5((void*)efi.systab->runtime->set_variable,
+					(u64)name,
+					(u64)vendor,
+					(u64)attr,
+					(u64)data_size,
+					(u64)data); 
+}
+
+static efi_status_t _efi_get_next_high_mono_count(u32 *count)
+{
+	return LIN2WIN1((void*)efi.systab->runtime->get_next_high_mono_count,
+					(u64)count); 
+}
+
+static efi_status_t _efi_reset_system(
+			int reset_type, efi_status_t status,
+			unsigned long data_size, efi_char16_t *data)
+{
+	return LIN2WIN4((void*)efi.systab->runtime->reset_system,
+					(u64)reset_type,
+					(u64)status,
+					(u64)data_size,
+					(u64)data); 
+}
+
+static efi_status_t _efi_set_virtual_address_map(
+			unsigned long memory_map_size,
+			unsigned long descriptor_size,
+			u32 descriptor_version, efi_memory_desc_t *virtual_map)
+{
+	return LIN2WIN4((void*)efi.systab->runtime->set_virtual_address_map,
+					(u64)memory_map_size,
+					(u64)descriptor_size,
+					(u64)descriptor_version,
+					(u64)virtual_map); 
+}
+
+static void __init efi_call_phys_prelog(void) __acquires(efi_rt_lock)
+{
+	unsigned long vaddress;
+
+	spin_lock(&efi_rt_lock);
+	local_irq_save(efi_rt_eflags);
+
+	vaddress = (unsigned long)__va(0x0UL);	
+	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
+	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
+	
+	global_flush_tlb();
+}
+
+static void __init efi_call_phys_epilog(void) __releases(efi_rt_lock)
+{
+	/*
+	 * After the lock is released, the original page table is restored.
+	 */
+	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	global_flush_tlb();
+	local_irq_restore(efi_rt_eflags);
+	spin_unlock(&efi_rt_lock);
+}
+
+static efi_status_t __init phys_efi_set_virtual_address_map(
+			unsigned long memory_map_size, 
+			unsigned long descriptor_size,
+			u32 descriptor_version, efi_memory_desc_t *virtual_map)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = LIN2WIN4(efi_phys.set_virtual_address_map,
+					(u64)memory_map_size,
+					(u64)descriptor_size,
+					(u64)descriptor_version, 
+					(u64)virtual_map);
+	efi_call_phys_epilog();
+	return status;
+}
+
+static efi_status_t __init phys_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = LIN2WIN2(efi_phys.get_time,
+					(u64)tm,
+					(u64)tc);
+	efi_call_phys_epilog();
+	return status;
+}
+
+inline int efi_set_rtc_mmss(unsigned long nowtime)
+{
+	int real_seconds, real_minutes;
+	efi_status_t 	status;
+	efi_time_t 	eft;
+	efi_time_cap_t 	cap;
+
+	spin_lock(&efi_rt_lock);
+	status = efi.get_time(&eft, &cap);
+	spin_unlock(&efi_rt_lock);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR PFX "Oops: efitime: can't read time!\n");
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
+	spin_lock(&efi_rt_lock);
+	status = efi.set_time(&eft);
+	spin_unlock(&efi_rt_lock);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR PFX "Oops: efitime: can't write time!\n");
+		return -1;
+	}
+	return 0;
+}
+/*
+ * This is used during kernel init before runtime
+ * services have been remapped and also during suspend, therefore,
+ * we'll need to call both in physical and virtual modes.
+ */
+inline unsigned long efi_get_time(void)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+
+	if (efi.get_time) {
+		/* if we are in virtual mode use remapped function */
+ 		status = efi.get_time(&eft, &cap);
+	} else {
+		/* we are in physical mode */
+		status = phys_efi_get_time(&eft, &cap);
+	}
+	if (status != EFI_SUCCESS)
+		printk(KERN_ERR PFX "Oops: efitime: can't read time status: 0x%lx\n",status);
+
+	return mktime(eft.year, eft.month, eft.day, eft.hour,
+			eft.minute, eft.second);
+}
+
+/*
+ * We need to map the EFI memory map again after paging_init().
+ */
+void __init efi_map_memmap(void)
+{
+	int i;
+
+	memmap.map = __va((unsigned long)memmap.phys_map);
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+
+	/* Make EFI runtime code area executable */
+	for (i = 0; i < e820.nr_map; i++) {
+		switch (e820.map[i].type) {
+		case E820_RUNTIME_CODE:
+			init_memory_mapping(
+				e820.map[i].addr,
+				e820.map[i].addr + e820.map[i].size);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/* Override function for emergency restart on EFI enabled systems */
+static void efi_emergency_restart(void)
+{
+	/* If EFI enabled, reset system through EFI protocol. */
+	efi.reset_system(EFI_RESET_WARM, EFI_SUCCESS, 0, NULL);
+	return;
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
+	memset(&efi, 0, sizeof(efi) );
+	memset(&efi_phys, 0, sizeof(efi_phys));
+
+	efi_phys.systab = (efi_system_table_t *)EFI_SYSTAB;
+	memmap.phys_map = (void*)EFI_MEMMAP;
+	memmap.nr_map = EFI_MEMMAP_SIZE/EFI_MEMDESC_SIZE;
+	memmap.desc_version = EFI_MEMDESC_VERSION;
+	memmap.desc_size = EFI_MEMDESC_SIZE;
+
+	efi.systab = (efi_system_table_t *) early_ioremap(
+						(unsigned long)efi_phys.systab,
+						sizeof(efi_system_table_t));
+	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
+	efi.systab = &efi_systab;
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		printk(KERN_ERR PFX "Woah! EFI system table signature incorrect\n");
+	if ((efi.systab->hdr.revision ^ EFI_SYSTEM_TABLE_REVISION) >> 16 != 0)
+		printk(KERN_ERR PFX
+		       "Warning: EFI system table major version mismatch: "
+		       "got %d.%02d, expected %d.%02d\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff,
+		       EFI_SYSTEM_TABLE_REVISION >> 16,
+		       EFI_SYSTEM_TABLE_REVISION & 0xffff);
+	/*
+	 * Grab some details from the system table
+	 */
+	config_tables = (efi_config_table_t *)efi.systab->tables;
+	runtime = efi.systab->runtime;
+
+	/*
+	 * Show what we know for posterity
+	 */
+	c16 = (efi_char16_t *) early_ioremap(efi.systab->fw_vendor, 2);
+	if (!probe_kernel_address(c16, i)) {
+		for (i = 0; i < sizeof(vendor) && *c16; ++i) 
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	}
+
+	printk(KERN_INFO PFX "EFI v%u.%.02u by %s \n",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = (efi_config_table_t *)early_ioremap( efi.systab->tables,
+			        efi.systab->nr_tables * sizeof(efi_config_table_t));
+	if (config_tables == NULL)
+		printk(KERN_ERR PFX "Could not map EFI Configuration Table!\n");
+
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
+			efi.mps = config_tables[i].table;
+			printk(KERN_INFO " MPS=0x%lx ", config_tables[i].table);
+		} else
+		    if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
+			efi.acpi20 = config_tables[i].table;
+			printk(KERN_INFO " ACPI 2.0=0x%lx ", config_tables[i].table);
+		} else
+		    if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
+			efi.acpi = config_tables[i].table;
+			printk(KERN_INFO " ACPI=0x%lx ", config_tables[i].table);
+		} else
+		    if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
+			efi.smbios = config_tables[i].table;
+			printk(KERN_INFO " SMBIOS=0x%lx ", config_tables[i].table);
+		} else
+		    if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
+			efi.hcdp = config_tables[i].table;
+			printk(KERN_INFO " HCDP=0x%lx ", config_tables[i].table);
+		} else
+		    if (efi_guidcmp(config_tables[i].guid, UGA_IO_PROTOCOL_GUID) == 0) {
+			efi.uga = config_tables[i].table;
+			printk(KERN_INFO " UGA=0x%lx ", config_tables[i].table);
+		}
+	}
+	printk(KERN_INFO "\n");
+
+	/*
+	 * Check out the runtime services table. We need to map
+	 * the runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
+	 */
+	runtime = (efi_runtime_services_t *) early_ioremap((unsigned long)
+						efi.systab->runtime,
+				      		sizeof(efi_runtime_services_t));
+	if (runtime != NULL) {
+		/*
+	 	 * We will only need *early* access to the following
+		 * two EFI runtime services before set_virtual_address_map
+		 * is invoked.
+ 	 	 */
+		efi_phys.get_time = (efi_get_time_t *) runtime->get_time;
+		efi_phys.set_virtual_address_map =
+			(efi_set_virtual_address_map_t *)runtime->set_virtual_address_map;
+	} else
+		printk(KERN_ERR PFX "Could not map the runtime service table!\n");
+	/* Map the EFI memory map for use until paging_init() */
+	memmap.map = (efi_memory_desc_t *) early_ioremap(
+					(unsigned long) EFI_MEMMAP,
+					 EFI_MEMMAP_SIZE);
+	if (memmap.map == NULL)
+		printk(KERN_ERR PFX "Could not map the EFI memory map!\n");
+        if (EFI_MEMDESC_SIZE != sizeof(efi_memory_desc_t)) {
+                printk(KERN_WARNING PFX "Kernel-defined memdesc" 
+			"doesn't match the one from EFI!\n");
+        }
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+	/* Override the emergency restart function */
+	machine_emergency_restart_func = efi_emergency_restart;
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
+			md->virt_addr = (unsigned long)ioremap(md->phys_addr,
+					 md->num_pages << EFI_PAGE_SHIFT);
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
+				((unsigned long)efi_phys.systab < end))
+			efi.systab = (efi_system_table_t *) 
+					(md->virt_addr - md->phys_addr +
+					(unsigned long)efi_phys.systab);
+	}
+
+	if (!efi.systab)
+		BUG();
+
+	status = phys_efi_set_virtual_address_map(
+			memmap.desc_size * memmap.nr_map,
+			memmap.desc_size,
+			memmap.desc_version,
+		       	memmap.phys_map);
+
+	if (status != EFI_SUCCESS) {
+		printk (KERN_ALERT "You are screwed! "
+			"Unable to switch EFI into virtual mode "
+			"(status=%lx)\n", status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
+	}
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+
+	efi.get_time = (efi_get_time_t *)_efi_get_time;
+	efi.set_time = (efi_set_time_t *)_efi_set_time;
+	efi.get_wakeup_time = (efi_get_wakeup_time_t *)_efi_get_wakeup_time;
+	efi.set_wakeup_time = (efi_set_wakeup_time_t *)_efi_set_wakeup_time;
+	efi.get_variable = (efi_get_variable_t *)_efi_get_variable;
+	efi.get_next_variable = (efi_get_next_variable_t *)_efi_get_next_variable;
+	efi.set_variable = (efi_set_variable_t *)_efi_set_variable;
+	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
+					_efi_get_next_high_mono_count;
+	efi.reset_system = (efi_reset_system_t *)_efi_reset_system;
+	efi.set_virtual_address_map = (efi_set_virtual_address_map_t *)
+					_efi_set_virtual_address_map;
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
+		if ((md->phys_addr <= phys_addr) && (phys_addr <
+			(md->phys_addr + (md-> num_pages << EFI_PAGE_SHIFT)) ))
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
+		if ((md->phys_addr <= phys_addr) && (phys_addr <
+			(md->phys_addr + (md-> num_pages << EFI_PAGE_SHIFT))))
+			return md->attribute;
+	}
+	return 0;
+}
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/efi_callwrap.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/efi_callwrap.c
--- linux-2.6.21-orig/arch/x86_64/kernel/efi_callwrap.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/efi_callwrap.c	2007-06-25 14:36:32.000000000 -0700
@@ -0,0 +1,202 @@
+/*
+ *  Copyright (C) 2006 Giridhar Pemmasani
+ *  Copyright (C) 2007-2010 Intel Corp
+ *  	Contributed by Chandramouli Narayanan<mouli@linux.intel.com>
+ *	Adapted NDIS wrapper macros from http://ndiswrapper.sourceforge.net
+ *	for EFI x86_64 linux support
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
+
+#define alloc_win_stack_frame(argc)		\
+	"subq $" #argc "*8, %%rsp\n\t"
+#define free_win_stack_frame(argc)		\
+	"addq $" #argc "*8, %%rsp\n\t"
+
+/* m is index of Windows arg required, n is total number of args to
+ * function Windows arg 1 should be at 0(%rsp), arg 2 at 8(%rsp) and
+ * so on, after stack frame is allocated, which starts at -n*8(%rsp)
+ * when stack frame is allocated. 4 > m >= n.
+*/
+
+#define lin2win_win_arg(m,n) "(" #m "-1-" #n ")*8(%%rsp)"
+
+/* volatile args for Windows function must be in clobber / output list */
+
+efi_status_t LIN2WIN0(void *func)
+{									
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8");
+	register u64 r9 __asm__("r9");
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(					
+		alloc_win_stack_frame(4)				
+		"call *%[fptr]\n\t"					
+		free_win_stack_frame(4)					
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),		
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)		
+		: [fptr] "r" (func));					
+	return ret;								
+}
+
+efi_status_t LIN2WIN1(void *func, u64 arg1)
+{
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8");
+	register u64 r9 __asm__("r9");
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(
+		alloc_win_stack_frame(4)
+		"call *%[fptr]\n\t"
+		free_win_stack_frame(4)	
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
+		: "c" (arg1),
+		  [fptr] "r" (func));
+	return ret;
+}
+
+efi_status_t LIN2WIN2(void *func, u64 arg1, u64 arg2)
+{
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8");
+	register u64 r9 __asm__("r9");
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(
+		alloc_win_stack_frame(4)
+		"call *%[fptr]\n\t"
+		free_win_stack_frame(4)
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
+		: "c" (arg1), "d" (arg2),
+		  [fptr] "r" (func));
+	return ret;
+}
+
+efi_status_t LIN2WIN3(
+	void *func,
+	u64 arg1,
+	u64 arg2,
+	u64 arg3)
+{
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8") = (u64)arg3;
+	register u64 r9 __asm__("r9");
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(
+		alloc_win_stack_frame(4)
+		"call *%[fptr]\n\t"
+		free_win_stack_frame(4)
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
+		: "c" (arg1), "d" (arg2), "r" (r8),
+		  [fptr] "r" (func));
+	return ret;
+}
+
+efi_status_t LIN2WIN4(
+	void *func,
+	u64 arg1,
+	u64 arg2,
+	u64 arg3,
+	u64 arg4)
+{
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8") = (u64)arg3;
+	register u64 r9 __asm__("r9") = (u64)arg4;
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(
+		alloc_win_stack_frame(4)
+		"call *%[fptr]\n\t"
+		free_win_stack_frame(4)
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
+		: "c" (arg1), "d" (arg2), "r" (r8), "r" (r9),
+		  [fptr] "r" (func));
+	return ret;
+}
+
+efi_status_t LIN2WIN5(
+	void *func,
+	u64 arg1,
+	u64 arg2,
+	u64 arg3,
+	u64 arg4,
+	u64 arg5)
+{
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8") = (u64)arg3;
+	register u64 r9 __asm__("r9") = (u64)arg4;
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(
+		"mov %[rarg5], " lin2win_win_arg(5,6) "\n\t"
+		alloc_win_stack_frame(6)
+		"call *%[fptr]\n\t"
+		free_win_stack_frame(6)
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
+		: "c" (arg1), "d" (arg2), "r" (r8), "r" (r9),
+		  [rarg5] "r" ((unsigned long long)arg5),
+		  [fptr] "r" (func));
+	return ret;
+}
+
+efi_status_t LIN2WIN6(
+	void *func,
+	u64 arg1,
+	u64 arg2,
+	u64 arg3,
+	u64 arg4,
+	u64 arg5,
+	u64 arg6)
+{
+	u64 ret, dummy;
+	register u64 r8 __asm__("r8") = (u64)arg3;
+	register u64 r9 __asm__("r9") = (u64)arg4;
+	register u64 r10 __asm__("r10");
+	register u64 r11 __asm__("r11");
+	__asm__ __volatile__(
+		"movq %[rarg5], " lin2win_win_arg(5,6) "\n\t"
+		"movq %[rarg6], " lin2win_win_arg(6,6) "\n\t"
+		alloc_win_stack_frame(6)
+		"call *%[fptr]\n\t"
+		free_win_stack_frame(6)
+		: "=a" (ret), "=c" (dummy), "=d" (dummy),
+		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
+		: "c" (arg1), "d" (arg2), "r" (r8), "r" (r9),
+		  [rarg5] "r" ((u64)arg5), [rarg6] "r" ((u64)arg6),
+		  [fptr] "r" (func));
+	return ret;
+}
+EXPORT_SYMBOL_GPL(LIN2WIN0);
+EXPORT_SYMBOL_GPL(LIN2WIN1);
+EXPORT_SYMBOL_GPL(LIN2WIN2);
+EXPORT_SYMBOL_GPL(LIN2WIN3);
+EXPORT_SYMBOL_GPL(LIN2WIN4);
+EXPORT_SYMBOL_GPL(LIN2WIN5);
+EXPORT_SYMBOL_GPL(LIN2WIN6);
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/head.S linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/head.S
--- linux-2.6.21-orig/arch/x86_64/kernel/head.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/head.S	2007-06-26 16:19:42.000000000 -0700
@@ -100,6 +100,23 @@ startup_32:
 	.org 0x100	
 	.globl startup_64
 startup_64:
+	/*
+	 * At this point the CPU runs in long64 bit with
+	 * paging disabled. First of all, need to load new DS, GDT, and CS.
+	 * There is no stack until we set one up.
+	 */
+
+	/* Initialize the %ds segment register */
+	mov $__KERNEL_DS,%eax
+	mov %eax,%ds
+
+	/* Load new GDT and CS. At this point, BP is in physical mode. */
+	lgdt    cpu_gdt_descr_phys-__START_KERNEL_map
+
+	mov     $(ljumpvector64 - __START_KERNEL_map), %rax
+	ljmp    *(%rax)
+long64:
+
 	/* We come here either from startup_32
 	 * or directly from a 64bit bootloader.
 	 * Since we may have come directly from a bootloader we
@@ -357,6 +374,16 @@ gdt:
 	.endr
 #endif
 
+	.align 16
+	.globl cpu_gdt_descr_phys
+cpu_gdt_descr_phys:
+	.word   gdt_end-cpu_gdt_table-1
+gdt_phys:
+	.quad   cpu_gdt_table-__START_KERNEL_map
+ljumpvector64:
+	.long   long64-__START_KERNEL_map
+	.word   __KERNEL_CS
+
 /* We need valid kernel segments for data and code in long mode too
  * IRET will check the segment types  kkeil 2000/10/28
  * Also sysret mandates a special GDT layout 

--
