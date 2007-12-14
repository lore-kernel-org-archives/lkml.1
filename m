Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXLND1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXLND1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 22:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbXLND1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 22:27:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:43982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764585AbXLND1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 22:27:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,164,1196668800"; 
   d="scan'208";a="295648492"
Subject: [PATCH -mm] i386 EFI runtime service support : fixes in sync with
	x86_64 support
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Dec 2007 11:26:08 +0800
Message-Id: <1197602768.12999.9.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 14 Dec 2007 03:26:23.0509 (UTC) FILETIME=[1A2CC450:01C83E01]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes several issues of i386 EFI basic runtime service
support according to fixes of x86_64 support.

- Delete efi_rt_lock because it is used during system early boot,
  before SMP is initialized.

- Change local_flush_tlb() to __flush_tlb_all() to flush global page
  mapping.

- Clean up includes.

- Revise Kconfig description.

- Enable noefi kernel parameter on i386.


This patch has been tested against 2.6.24-rc5-mm1 kernel on Intel
platforms with 32-bit EFI1.10 and UEFI2.0 firmware.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/kernel-parameters.txt   |    2 ++
 Documentation/x86_64/boot-options.txt |    4 ----
 arch/x86/Kconfig                      |   19 ++++++++-----------
 arch/x86/kernel/efi.c                 |    7 +++++++
 arch/x86/kernel/efi_32.c              |   25 +++++--------------------
 arch/x86/kernel/efi_64.c              |    7 -------
 arch/x86/kernel/setup_32.c            |    6 +++---
 7 files changed, 25 insertions(+), 45 deletions(-)

--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -20,27 +20,15 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/mm.h>
 #include <linux/types.h>
-#include <linux/time.h>
-#include <linux/spinlock.h>
-#include <linux/bootmem.h>
 #include <linux/ioport.h>
-#include <linux/module.h>
 #include <linux/efi.h>
-#include <linux/kexec.h>
 
-#include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/desc.h>
 #include <asm/tlbflush.h>
 
-#define PFX 		"EFI: "
-
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
  * prelog/epilog before/after the invocation to disable interrupt, to
@@ -49,16 +37,14 @@
  */
 
 static unsigned long efi_rt_eflags;
-static DEFINE_SPINLOCK(efi_rt_lock);
 static pgd_t efi_bak_pg_dir_pointer[2];
 
-void efi_call_phys_prelog(void) __acquires(efi_rt_lock)
+void efi_call_phys_prelog(void)
 {
 	unsigned long cr4;
 	unsigned long temp;
 	struct Xgt_desc_struct gdt_descr;
 
-	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
 
 	/*
@@ -88,14 +74,14 @@ void efi_call_phys_prelog(void) __acquir
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	local_flush_tlb();
+	__flush_tlb_all();
 
 	gdt_descr.address = __pa(get_cpu_gdt_table(0));
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 }
 
-void efi_call_phys_epilog(void) __releases(efi_rt_lock)
+void efi_call_phys_epilog(void)
 {
 	unsigned long cr4;
 	struct Xgt_desc_struct gdt_descr;
@@ -119,10 +105,9 @@ void efi_call_phys_epilog(void) __releas
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	local_flush_tlb();
+	__flush_tlb_all();
 
 	local_irq_restore(efi_rt_eflags);
-	spin_unlock(&efi_rt_lock);
 }
 
 /*
@@ -135,7 +120,7 @@ void __init efi_map_memmap(void)
 	memmap.map = bt_ioremap((unsigned long) memmap.phys_map,
 			(memmap.nr_map * memmap.desc_size));
 	if (memmap.map == NULL)
-		printk(KERN_ERR PFX "Could not remap the EFI memmap!\n");
+		printk(KERN_ERR "Could not remap the EFI memmap!\n");
 
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 }
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -55,6 +55,13 @@ struct efi_memory_map memmap;
 struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static int __init setup_noefi(char *arg)
+{
+	efi_enabled = 0;
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	return efi_call_virt2(get_time, tm, tc);
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -40,13 +40,6 @@
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
-static int __init setup_noefi(char *arg)
-{
-	efi_enabled = 0;
-	return 0;
-}
-early_param("noefi", setup_noefi);
-
 static void __init early_mapping_set_exec(unsigned long start,
 					  unsigned long end,
 					  int executable)
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -651,9 +651,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	print_memory_map(memory_setup());
 
-	if (efi_enabled)
-		efi_init();
-
 	copy_edd();
 
 	if (!boot_params.hdr.root_flags)
@@ -680,6 +677,9 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	if (efi_enabled)
+		efi_init();
+
 	max_low_pfn = setup_memory();
 
 #ifdef CONFIG_VMI
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1001,21 +1001,18 @@ config MTRR
 
 config EFI
 	def_bool n
-	prompt "Boot from EFI support"
+	prompt "EFI runtime service support"
 	depends on ACPI
 	---help---
-	This enables the kernel to boot on EFI platforms using
-	system configuration information passed to it from the firmware.
-	This also enables the kernel to use any EFI runtime services that are
+	This enables the kernel to use EFI runtime services that are
 	available (such as the EFI variable services).
 
-	This option is only useful on systems that have EFI firmware
-	and will result in a kernel image that is ~8k larger.  In addition,
-	you must use the latest ELILO loader available at
-	<http://elilo.sourceforge.net> in order to take advantage of
-	kernel initialization using EFI information (neither GRUB nor LILO know
-	anything about EFI).  However, even with this option, the resultant
-	kernel should continue to boot on existing non-EFI platforms.
+	This option is only useful on systems that have EFI firmware.
+  	In addition, you should use the latest ELILO loader available
+  	at <http://elilo.sourceforge.net> in order to take advantage
+  	of EFI runtime services. However, even with this option, the
+  	resultant kernel should continue to boot on existing non-EFI
+  	platforms.
 
 config IRQBALANCE
 	def_bool y
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1145,6 +1145,8 @@ and is between 256 and 4096 characters. 
 
 	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
 
+	noefi		[X86-32,X86-64] Disable EFI runtime services support.
+
 	noexec		[IA-64]
 
 	noexec		[X86-32,X86-64]
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -306,8 +306,4 @@ Debugging
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
-EFI
-
-  noefi		Disable EFI support
-
 Miscellaneous

