Return-Path: <linux-kernel-owner+w=401wt.eu-S1766887AbXEBUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766887AbXEBUDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766898AbXEBUDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:03:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:35663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766887AbXEBUDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:03:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,482,1170662400"; 
   d="scan'208";a="82825064"
Message-Id: <20070501190110.770881000@em64tdvp.jf.intel.com>
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
Date: Tue, 01 May 2007 11:59:46 -0700
From: Chandramouli Narayanan <mouli@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: [PATCH 2.6.21 1/3] x86_64: EFI64 support 
Content-Disposition: inline; filename=patch1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

General note on EFI x86_64 support
----------------------------------

The following set of patches implements EFI x86_64 Linux kernel support.
References to EFI and UEFI (Unified Extensible Firmware Interface) are used
interchangeably in the text below.

UEFI specification can be found here: http://www.uefi.org

UEFI x86_64 support is implemented in the following 3 kernel patches.
For booting the UEFI x86_64 enabled kernel, bootloader support is required.
ELILO with x86_64 support has been submitted to the ELILO project.
Please visit the ELILO source link for boot loader source and instructions.

Testing
-------
The x86_64 UEFI kernel patches below have been applied against 2.6.21
and tested with x86_64 ELILO bootloader on Intel platforms with EFI1.10 and
UEFI 2.0 firmware. The EFI firmware that I have tested also had CSM supporting
compatibility for legacy operating systems.

With this said, the patches require wider testing on systems with EFI64
firmware support. 

Mechanics:
---------

- Create a VFAT partition on the disk
- Copy the following to the VFAT partition:
	elilo bootloader with x86_64 support and elilo configuration file
	efi64 kernel image, initrd
- Boot to EFI shell and invoke elilo choosing efi64 kernel image
- On UEFI2.0 firmware systems, pass vga=fbcon for boot messages to appear
  on console.

Issues noted:
-------------
1. With the patches applied to 2.6.21rc5-git3 kernel, KDE desktop did not get
repainted when the system was woken up from sleep. This happened when the
screen lock was in effect due to inactivity and the system went to sleep.
Following the key press, the system was woken up but KMenu did not show up.
The mouse click around the desktop did not have the desired effect, although
windows that were open before sleep showed up and keyboard input was taken and
the system was operational. Taking the system down to 'init 3' and back to
'init 5' restored the desktop and mouse control.

This behavior did not manifest with the patches applied against 2.6.21rc7-git2
and the final 2.6.21 release. 

2. With CALGARY_IOMMU=y in the kernel configuration, the Calgary detection fails
with the message "Calgary: Unable to locate Rio Grande Table in EBDA - bailing".
However, the legacy kernel has no such error.

3. On some x86_64 systems with EFI1.10 firmware, early boot messages
did not appear on console. However, I didn't encounter this behavior on
x86_64 systems with UEFI2.0 firmware. This does not appear to be kernel issue
but rather firmware/bootloader issue. I will post an update on the status
of this issue as I learn more.

EFI x86_64 support Patch 1 of 3
-------------------------------
The main file of this patch is the addition of efi.c for x86_64.
This file is modelled after the EFI IA32 avatar. Some x86_64 specifics are
worth noting here. EFI initialization and EFI service mapping are
implemented in efi.c. NX bit is turned off for EFI runtime service area so 
that EFI runtime code is executable. On x86_64, parameters passed to
UEFI firmware services need to follow the UEFI calling convention.
For this purpose, a uefi_call_wrapper() is implemented. EFI calls
are wrapped before calling the firmware service. An efi_stub.S to make
EFI calls in physical mode with interrupts turned off is added for x86_64.

Boot parameter setup file is updated for x86_64 EFI support. x86_64 EFI boot
loader must conform to the EFI boot parameter offsets defined in the file
include/asm-x86_64/bootsetup.h (and x86_64 patches submitted to ELILO
bootloader conforms to this).

EFI x86_64 build option is added to the kernel configuration.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/Kconfig linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/Kconfig
--- linux-2.6.21rc7-git2-orig/arch/x86_64/Kconfig	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/Kconfig	2007-04-19 13:01:02.000000000 -0700
@@ -254,6 +254,20 @@ config X86_HT
 	depends on SMP && !MK8
 	default y
 
+config EFI
+	bool "Boot from EFI support (EXPERIMENTAL)"
+	default n
+	---help---
+
+	This enables the the kernel to boot on EFI platforms using
+	system configuration information passed to it from the firmware.
+	This also enables the kernel to use any EFI runtime services that are
+	available (such as the EFI variable services).
+	This option is only useful on systems that have EFI firmware
+	and will result in a kernel image that is ~8k larger. However,
+	even with this option, the resultant kernel should continue to
+	boot on existing non-EFI platforms.
+
 config MATH_EMULATION
 	bool
 
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/drivers/char/Kconfig linux-2.6.21rc7-git2-uefi-finaltest/drivers/char/Kconfig
--- linux-2.6.21rc7-git2-orig/drivers/char/Kconfig	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/drivers/char/Kconfig	2007-04-19 13:01:02.000000000 -0700
@@ -837,7 +837,7 @@ config GEN_RTC_X
 
 config EFI_RTC
 	bool "EFI Real Time Clock Services"
-	depends on IA64
+	depends on IA64 || X86_64
 
 config DS1302
 	tristate "DS1302 RTC support"
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/include/asm-x86_64/bootsetup.h linux-2.6.21rc7-git2-uefi-finaltest/include/asm-x86_64/bootsetup.h
--- linux-2.6.21rc7-git2-orig/include/asm-x86_64/bootsetup.h	2007-04-19 12:39:40.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/include/asm-x86_64/bootsetup.h	2007-04-19 13:01:02.000000000 -0700
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
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi.c
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi.c	2007-04-19 13:01:02.000000000 -0700
@@ -0,0 +1,824 @@
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
+
+#include <asm/setup.h>
+#include <asm/bootsetup.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/proto.h>
+
+#define EFI_DEBUG	0
+#define PFX 		"EFI: "
+
+#define EFI_ARG_NUM_GET_TIME			2
+#define EFI_ARG_NUM_SET_TIME			1
+#define EFI_ARG_NUM_GET_WAKEUP_TIME		3
+#define EFI_ARG_NUM_SET_WAKEUP_TIME		2
+#define EFI_ARG_NUM_GET_VARIABLE		5
+#define EFI_ARG_NUM_GET_NEXT_VARIABLE		3
+#define EFI_ARG_NUM_SET_VARIABLE		5
+#define EFI_ARG_NUM_GET_NEXT_HIGH_MONO_COUNT	1
+#define EFI_ARG_NUM_RESET_SYSTEM		4
+#define EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP	4
+
+#define EFI_ARG_NUM_MAX 10
+#define EFI_REG_ARG_NUM 4
+
+extern unsigned long efi_call_phys(void *fp, u64 arg_num, ...);
+struct efi efi;
+EXPORT_SYMBOL(efi);
+struct efi efi_phys __initdata;
+struct efi_memory_map memmap ;
+static efi_system_table_t efi_systab __initdata;
+
+static unsigned long efi_rt_eflags;
+static spinlock_t efi_rt_lock = SPIN_LOCK_UNLOCKED;
+static pgd_t save_pgd;
+
+/* Convert SysV calling convention to EFI x86_64 calling convention */
+
+static efi_status_t uefi_call_wrapper(void *fp, unsigned long va_num, ...)
+{
+	va_list ap;
+	int i;
+	unsigned long args[EFI_ARG_NUM_MAX];
+	unsigned int arg_size,stack_adjust_size;
+	efi_status_t status;
+
+	if (va_num > EFI_ARG_NUM_MAX || va_num<0)	{
+		return EFI_LOAD_ERROR;
+	}
+	if (va_num==0)
+		/* There is no need to convert arguments for void argument. */
+		__asm__ __volatile__("call *%0;ret;"::"r"(fp));
+
+	/* The EFI arguments is stored in an array. Then later on it will be 
+	 * pushed into stack or passed to registers according to MS ABI.
+	 */
+	va_start(ap, va_num);
+	for (i = 0; i < va_num; i++) {
+		args[i] = va_arg(ap, unsigned long);
+	}
+	va_end(ap);
+	arg_size = va_num*8;
+	stack_adjust_size = (va_num > EFI_REG_ARG_NUM? EFI_REG_ARG_NUM : va_num)*8;
+
+	/* Starting from here, assembly code makes sure all registers used are
+	 * under controlled by our code itself instead of by gcc.
+	 */
+	/* Start converting SysV calling convention to MS calling convention. */
+	__asm__ __volatile__(
+		/* 0. Save preserved registers. EFI call may clobbered them. */
+		"		pushq %%rbp;pushq %%rbx;pushq %%r12;"
+		"		pushq %%r13;pushq %%r14;pushq %%r15;"
+		/* 1. Push arguments passed by stack into stack. */
+		"		mov %1, %%r12;"
+		"		mov %3, %%r13;"
+		"		mov %1, %%rax;"
+		"		dec %%rax;"
+		"		mov $8, %%bl;"
+		"		mul %%bl;"
+		"		add %%rax, %%r13;"
+		"lstack:"
+		"		cmp $4, %%r12;"
+		"		jle lregister;" 
+		"		pushq (%%r13);"
+		"		sub $8, %%r13;"
+		"		dec %%r12;" 
+		"		jmp lstack;"
+		/* 2. Move arguments passed by registers into registers.
+		 *    rdi->rcx, rsi->rdx, rdx->r8, rcx->r9.
+		 */
+		"lregister:"	
+		"		mov %3, %%r14;"
+		"		mov $0, %%r12;"
+		"lloadregister:"
+		"		cmp %1, %%r12;"
+		"		jge lcall;"
+		"		mov (%%r14), %%rcx;"
+		"		inc %%r12;"
+		"		cmp %1, %%r12;"
+		"		jge lcall;"
+		"		mov 8(%%r14), %%rdx;"
+		"		inc %%r12;"
+		"		cmp %1, %%r12;"
+		"		jge lcall;"
+		"		mov 0x10(%%r14), %%r8;"
+		"		inc %%r12;"
+		"		cmp %1, %%r12;"
+		"		jge lcall;"
+		"		mov 0x18(%%r14), %%r9;"
+		/* 3. Save stack space for those register arguments. */
+		"lcall:				"
+		"		sub %2, %%rsp;"
+		/* 4. Save arg_size to r12 which is preserved in EFI call. */
+		"		mov %4, %%r12;"
+		/* 5. Call EFI function. */
+		"		call *%5;"
+		"		mov %%rax, %0;"
+		/* 6. Restore stack space reserved for those register
+		 * arguments.
+		 */
+		"		add %%r12, %%rsp;"
+		/* 7. Restore preserved registers. */
+		"		popq %%r15;popq %%r14;popq %%r13;"
+		"		popq %%r12;popq %%rbx;popq %%rbp;"
+		: "=r"(status)
+		:"r"((unsigned long)va_num),
+		 "r"((unsigned long)stack_adjust_size),
+		 "r"(args),
+		 "r"((unsigned long)arg_size),
+		 "r"(fp)
+		:"rsp","rbx","rax","r11","r12","r13","r14","rcx","rdx","r8","r9" 
+		);
+	return status;
+}
+
+static efi_status_t _efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->get_time,
+					EFI_ARG_NUM_GET_TIME,
+					(u64)tm,
+					(u64)tc); 
+}
+
+static efi_status_t _efi_set_time(efi_time_t *tm)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->set_time,
+					EFI_ARG_NUM_SET_TIME, 
+					(u64)tm); 
+}
+
+static efi_status_t
+_efi_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
+                                            efi_time_t *tm)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->get_wakeup_time,
+					EFI_ARG_NUM_GET_WAKEUP_TIME, 
+					(u64)enabled,
+					(u64)pending,
+					(u64)tm); 
+}
+
+static efi_status_t _efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->set_wakeup_time,
+					EFI_ARG_NUM_SET_WAKEUP_TIME, 
+					(u64)enabled,
+					(u64)(tm)); 
+}
+
+static efi_status_t
+_efi_get_variable(efi_char16_t *name, efi_guid_t *vendor, u32 *attr,
+                                         unsigned long *data_size, void *data)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->get_variable,
+					EFI_ARG_NUM_GET_VARIABLE, 
+					(u64)name,
+					(u64)vendor,
+					(u64)attr,
+					(u64)data_size,
+					(u64)data); 
+}
+
+static efi_status_t
+_efi_get_next_variable(unsigned long *name_size, efi_char16_t *name,
+                                              efi_guid_t *vendor)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->get_next_variable,
+					EFI_ARG_NUM_GET_NEXT_VARIABLE, 
+					(u64)name_size,
+					(u64)name,
+					(u64)vendor); 
+}
+
+static efi_status_t _efi_set_variable(efi_char16_t *name, efi_guid_t *vendor,
+					u64 attr, u64 data_size,
+					void *data)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->set_variable,
+					EFI_ARG_NUM_SET_VARIABLE, 
+					(u64)name,
+					(u64)vendor,
+					(u64)attr,
+					(u64)data_size,
+					(u64)data); 
+}
+
+static efi_status_t _efi_get_next_high_mono_count(u32 *count)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->get_next_high_mono_count,
+					EFI_ARG_NUM_GET_NEXT_HIGH_MONO_COUNT,
+					(u64)count); 
+}
+
+static efi_status_t _efi_reset_system(int reset_type, efi_status_t status,
+                                 unsigned long data_size, efi_char16_t *data)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->reset_system,
+					EFI_ARG_NUM_RESET_SYSTEM, 
+					(u64)reset_type,
+					(u64)status,
+					(u64)data_size,
+					(u64)data); 
+}
+
+static efi_status_t _efi_set_virtual_address_map(unsigned long memory_map_size,
+                                                unsigned long descriptor_size,
+                                                u32 descriptor_version,
+                                                efi_memory_desc_t *virtual_map)
+{
+	return uefi_call_wrapper((void*)efi.systab->runtime->set_virtual_address_map,
+					EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP, 
+					(u64)memory_map_size,
+					(u64)descriptor_size,
+					(u64)descriptor_version,
+					(u64)virtual_map); 
+}
+
+static void efi_call_phys_prelog(void)
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
+	local_flush_tlb();
+}
+
+static void efi_call_phys_epilog(void)
+{
+	/*
+	 * After the lock is released, the original page table is restored.
+	 */
+	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	local_flush_tlb();
+	local_irq_restore(efi_rt_eflags);
+	spin_unlock(&efi_rt_lock);
+}
+
+static efi_status_t
+phys_efi_set_virtual_address_map(unsigned long memory_map_size,
+				 unsigned long descriptor_size,
+				 u32 descriptor_version,
+				 efi_memory_desc_t *virtual_map)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = efi_call_phys(efi_phys.set_virtual_address_map,
+					EFI_ARG_NUM_SET_VIRTUAL_ADDRESS_MAP,
+					(unsigned long)memory_map_size,
+					(unsigned long)descriptor_size,
+					(unsigned long)descriptor_version, 
+					(unsigned long)virtual_map);
+	efi_call_phys_epilog();
+	return status;
+}
+
+efi_status_t
+phys_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = efi_call_phys(efi_phys.get_time,
+					EFI_ARG_NUM_GET_TIME,
+					(unsigned long)tm,
+					(unsigned long)tc);
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
+		printk("Ooops: efitime: can't read time!\n");
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
+		printk("Ooops: efitime: can't write time!\n");
+		return -1;
+	}
+	return 0;
+}
+/*
+ * This should only be used during kernel init and before runtime
+ * services have been remapped, therefore, we'll need to call in physical
+ * mode.  Note, this call isn't used later, so mark it __init.
+ */
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
+		printk("Oops: efitime: can't read time status: 0x%lx\n",status);
+
+	return mktime(eft.year, eft.month, eft.day, eft.hour,
+			eft.minute, eft.second);
+}
+
+inline int is_available_memory(efi_memory_desc_t * md)
+{
+	if (!(md->attribute & EFI_MEMORY_WB))
+		return 0;
+
+	switch (md->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			return 1;
+	}
+	return 0;
+}
+
+/* Make EFI runtime code executable */
+static void
+phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
+{
+	int i = pmd_index(address);
+
+	for (; i < PTRS_PER_PMD && address < end; i++, address += PMD_SIZE) {
+		unsigned long entry;
+		pmd_t *pmd = pmd_page + pmd_index(address);
+
+		entry = pmd_val(*pmd);
+			entry &= ~_PAGE_NX;
+		set_pmd(pmd, __pmd(entry));
+	}
+}
+
+static void
+phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
+{ 
+	int i = pud_index(addr);
+
+	for (; i < PTRS_PER_PUD && addr < end; i++, addr += PUD_SIZE ) {
+		pud_t *pud = pud_page + pud_index(addr);
+		pmd_t *pmd;
+
+		if (pud_val(*pud)) {
+			pmd = pmd_offset(pud,0);
+			phys_pmd_init(pmd, addr, end);
+		}
+	}
+}
+
+static void change_rt_pmd(unsigned long start, unsigned long end)
+{ 
+	unsigned long next; 
+
+	start = (unsigned long)__va(start);
+	end = (unsigned long)__va(end);
+
+	for (; start < end; start = next) {
+		pgd_t *pgd = pgd_offset_k(start);
+		pud_t *pud;
+
+		pud = pud_offset(pgd, start & PGDIR_MASK);
+		next = start + PGDIR_SIZE;
+		if (next > end) 
+			next = end; 
+		phys_pud_init(pud, __pa(start), __pa(next));
+	} 
+	__flush_tlb_all();
+}
+/*
+ * We need to map the EFI memory map again after paging_init().
+ */
+void __init efi_map_memmap(void)
+{
+        efi_memory_desc_t *md;
+        void *p;
+
+	memmap.map = __va((unsigned long) memmap.phys_map);
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+
+	/* Make EFI runtime code executable */
+        for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+                md = p;
+               if (md->type == EFI_RUNTIME_SERVICES_CODE && 
+			(__supported_pte_mask & _PAGE_NX))
+			change_rt_pmd(md->phys_addr, md->phys_addr + 
+					(md->num_pages << EFI_PAGE_SHIFT));
+	}
+}
+
+#if EFI_DEBUG
+void __init print_efi_memmap(void)
+{
+	efi_memory_desc_t *md;
+	void *p;
+	int i;
+
+	for (p = memmap.map, i = 0; p < memmap.map_end; p += memmap.desc_size, i++) {
+		md = p;
+		early_printk("mem%02u: type=%u, attr=0x%lx, "
+				"range=[0x%016lx-0x%016lx) (%luMB)\n",
+				i, md->type, md->attribute, md->phys_addr,
+				md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+				(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+	}
+}
+#endif  /*  EFI_DEBUG  */
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
+	if (c16) {
+		for (i = 0; i < sizeof(vendor) && *c16; ++i) 
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	} else
+		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
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
+
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
+#if EFI_DEBUG
+	print_efi_memmap();
+#endif
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
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Since x86_64 EFI follows MS calling convention, we can not call
+	 * the services directly. We put a wrapper around the real service
+	 * calls and call the wrapper directly.
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
+void __init
+efi_initialize_iomem_resources(struct resource *code_resource,
+			       struct resource *data_resource)
+{
+	struct resource *res;
+	efi_memory_desc_t *md;
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+
+		if ((md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT)) >
+		    0x100000000ULL)
+			continue;
+		res = alloc_bootmem_low(sizeof(struct resource));
+		switch (md->type) {
+		case EFI_RESERVED_TYPE:
+			res->name = "Reserved Memory";
+			break;
+		case EFI_LOADER_CODE:
+			res->name = "Loader Code";
+			break;
+		case EFI_LOADER_DATA:
+			res->name = "Loader Data";
+			break;
+		case EFI_BOOT_SERVICES_DATA:
+			res->name = "BootServices Data";
+			break;
+		case EFI_BOOT_SERVICES_CODE:
+			res->name = "BootServices Code";
+			break;
+		case EFI_RUNTIME_SERVICES_CODE:
+			res->name = "Runtime Service Code";
+			break;
+		case EFI_RUNTIME_SERVICES_DATA:
+			res->name = "Runtime Service Data";
+			break;
+		case EFI_CONVENTIONAL_MEMORY:
+			res->name = "Conventional Memory";
+			break;
+		case EFI_UNUSABLE_MEMORY:
+			res->name = "Unusable Memory";
+			break;
+		case EFI_ACPI_RECLAIM_MEMORY:
+			res->name = "ACPI Reclaim";
+			break;
+		case EFI_ACPI_MEMORY_NVS:
+			res->name = "ACPI NVS";
+			break;
+		case EFI_MEMORY_MAPPED_IO:
+			res->name = "Memory Mapped IO";
+			break;
+		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
+			res->name = "Memory Mapped IO Port Space";
+			break;
+		default:
+			res->name = "Reserved";
+			break;
+		}
+		res->start = md->phys_addr;
+		res->end = res->start + ((md->num_pages << EFI_PAGE_SHIFT) - 1);
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		if (request_resource(&iomem_resource, res) < 0)
+			printk(KERN_ERR PFX "Failed to allocate res %s : 0x%llx-0x%llx\n",
+				res->name, res->start, res->end);
+		/*
+		 * We don't know which region contains kernel data so we try
+		 * it repeatedly and let the resource manager test it.
+		 */
+		if (md->type == EFI_CONVENTIONAL_MEMORY) {
+			request_resource(res, code_resource);
+			request_resource(res, data_resource);
+		}
+	}
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
+
+__init void reserve_efi_runtime(void)
+{
+	efi_memory_desc_t *md;
+	unsigned long start, end;
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		start = md->phys_addr;
+		end = start + (md->num_pages << EFI_PAGE_SHIFT);
+		if (is_available_memory(md))
+			continue;
+		reserve_bootmem_generic(start, md->num_pages << EFI_PAGE_SHIFT);
+	}
+}
+
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi_stub.S linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi_stub.S
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/efi_stub.S	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/efi_stub.S	2007-04-19 13:01:02.000000000 -0700
@@ -0,0 +1,101 @@
+/*
+ * EFI call stub for x86_64.
+ *
+ * This stub allows us to make EFI calls in physical mode with interrupts
+ * turned off.
+ *
+ *  Copyright (C) 2006 Fenghua Yu <fenghua.yu@intel.com>
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/page.h>
+
+/*
+ * efi_call_phys(void *,unsigned long, ...) 
+ * is a function with variable parameters.
+ *	argument 0: funtion pointer to EFI runtime service funtion.
+ *	argument 1: number of arguments passed to EFI runtme service funtion.
+ *	argument 2,...: arguments passed to EFI runtime service funtion.
+ * All the callers of this function assure that all the parameters are 8-bytes.
+ * Currently there are only two runtime services are called in kernel: 
+ *	get_time - passes 2 arguments
+ *	set_virtual_address_map -  passes 4 arguments.
+ * Conversion from SysV calling convention to UEFI calling convention
+ * is needed to call x86_64 EFI:
+ *    For 2 arguments:	rdx->rcx, r10->rdx
+ *    For 4 arguments:	rdx->rcx, r10->rdx, r8->r8, r9->r9
+ *
+ * The current efi_call_phys() only considers these two cases to simplify
+ * situation. In the future, if other runtime services are called and other
+ * number of arguments than 2 and 4 are passed, this code may be changed
+ * correspondingly.
+ *
+ */
+
+/*
+ * In gcc calling convention, EBX, ESP, EBP, ESI and EDI are all callee save.
+ * So we'd better save all of them at the beginning of this function and restore
+ * at the end no matter how many we use, because we can not assure EFI runtime
+ * service functions will comply with gcc calling convention, too.
+ */
+
+.text
+ENTRY(efi_call_phys)
+	/*
+	 * 0. The function can only be called in Linux kernel. So CS has been
+	 * set to 0x0010, DS and SS have been set to 0x0018. In EFI, I found
+	 * the values of these registers are the same. And, the corresponding
+	 * GDT entries are identical. So I will do nothing about segment reg
+	 * and GDT, but change GDT base register in prelog and epilog.
+	 */
+
+	/*
+	 * 1. Arguments conversion.
+	 */
+	mov %rcx, %r12
+	mov %rdx, %rcx
+	mov %r12, %rdx
+
+	/*
+	 * 2. Adjust stack pointer.
+	 */
+	/* Reserve stack space for arguments. Save the register stack size
+	 * into efi_reg_stack_size which will be used after callee.
+	 */
+	mov	%rsi, %rax
+	mov	$8, %bl
+	mul	%bl
+	mov	%rax, efi_reg_stack_size
+	sub	%rax, %rsp
+	/* Make physical address */
+	mov	$__START_KERNEL_map, %rsi
+	sub	%rsi, %rsp
+
+	/* set up return address from EFI callee. */
+	mov	$1f, %r12
+	push	%r12
+
+	/*
+	 * 3. Call the physical function.
+	 */
+	xor	%rax, %rax
+	jmp	*%rdi
+
+1:
+	/*
+	 * 4. After EFI runtime service returns, control will return to
+	 * following instruction. We'd better readjust stack pointer first.
+	 */
+	/* Restore stack space for arguments */
+	add	efi_reg_stack_size, %rsp
+	/* Make virtual address */
+	mov	$__START_KERNEL_map, %rsi
+	add	%rsi, %rsp
+
+	ret
+.previous
+
+.data
+efi_reg_stack_size:
+	.long 0
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/head.S linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/head.S
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/head.S	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/head.S	2007-04-19 13:01:02.000000000 -0700
@@ -94,12 +94,29 @@ startup_32:
 	 * EFER.LMA = 1). Now we want to jump in 64bit mode, to do that we use
 	 * the new gdt/idt that has __KERNEL_CS with CS.L = 1.
 	 */
-	ljmp	$__KERNEL_CS, $(startup_64 - __START_KERNEL_map)
+	ljmp	$__KERNEL_CS, $(long64 - __START_KERNEL_map)
 
 	.code64
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
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/Makefile linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/Makefile
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/Makefile	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/Makefile	2007-04-19 13:01:02.000000000 -0700
@@ -37,6 +37,7 @@ obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
+obj-$(CONFIG_EFI)              += efi.o efi_stub.o
 
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o

--
