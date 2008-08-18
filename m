Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbYHREDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbYHREDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbYHREDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:03:47 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:41690 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYHREDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:03:46 -0400
Date: Sun, 17 Aug 2008 23:03:40 -0500
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818040340.GB17528@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 17 Aug 2008 23:03:44 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/power/cpu_32.c __save_processor_state calls read_cr4()
only a i486 CPU doesn't have the CR4 register.  Trying to read it
produces an invalid opcode oops during suspend to disk.

Added the check (boot_cpu_data.x86 >= 5) before reading the
register.  If the value to be written is zero the write is
skipped.

arch/x86/power/hibernate_asm_32.S
done: swapped the use of %eax and %ecx to use jecxz for
the zero test and jump over store to %cr4.
restore_image: s/%ecx/%eax/ to be consistent with done:

In addition to __save_processor_state, acpi_save_state_mem,
efi_call_phys_prelog, and efi_call_phys_epilog had checks added
(acpi restore was in assembly and already had a check for
non-zero).  There were other reads and writes of CR4, but MCE and
virtualization shouldn't be executed on a i486 anyway.

Signed-off-by: David Fries <david@fries.net>
---
 arch/x86/kernel/acpi/sleep.c      |    4 +++-
 arch/x86/kernel/efi_32.c          |    6 ++++--
 arch/x86/power/cpu_32.c           |    8 ++++++--
 arch/x86/power/hibernate_asm_32.S |   26 +++++++++++++++-----------
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 81e5ab6..bd0f2a3 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -86,7 +86,9 @@ int acpi_save_state_mem(void)
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4();
+	/* cr4 was introduced in the Pentium CPU */
+	if (boot_cpu_data.x86 >= 5)
+		header->pmode_cr4 = read_cr4();
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
 
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index 4b63c8e..ad62d31 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -53,7 +53,8 @@ void efi_call_phys_prelog(void)
 	 * directory. If I have PAE, I just need to duplicate one entry in
 	 * page directory.
 	 */
-	cr4 = read_cr4();
+	/* cr4 was introduced in the Pentium CPU */
+	cr4 = boot_cpu_data.x86 >= 5 ? read_cr4() : 0;
 
 	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
@@ -91,7 +92,8 @@ void efi_call_phys_epilog(void)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
-	cr4 = read_cr4();
+	/* cr4 was introduced in the Pentium CPU */
+	cr4 = boot_cpu_data.x86 >= 5 ? read_cr4() : 0;
 
 	if (cr4 & X86_CR4_PAE) {
 		swapper_pg_dir[pgd_index(0)].pgd =
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index 7dc5d5c..c5647ea 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -45,7 +45,9 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr0 = read_cr0();
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
-	ctxt->cr4 = read_cr4();
+	/* cr4 was introduced in the Pentium CPU */
+	if (boot_cpu_data.x86 >= 5)
+		ctxt->cr4 = read_cr4();
 }
 
 /* Needed by apm.c */
@@ -98,7 +100,9 @@ static void __restore_processor_state(struct saved_context *ctxt)
 	/*
 	 * control registers
 	 */
-	write_cr4(ctxt->cr4);
+	/* cr4 was introduced in the Pentium CPU */
+	if (ctxt->cr4)
+		write_cr4(ctxt->cr4);
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
 	write_cr0(ctxt->cr0);
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index b95aa6c..4fc7e87 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -28,9 +28,9 @@ ENTRY(swsusp_arch_suspend)
 	ret
 
 ENTRY(restore_image)
-	movl	resume_pg_dir, %ecx
-	subl	$__PAGE_OFFSET, %ecx
-	movl	%ecx, %cr3
+	movl	resume_pg_dir, %eax
+	subl	$__PAGE_OFFSET, %eax
+	movl	%eax, %cr3
 
 	movl	restore_pblist, %edx
 	.p2align 4,,7
@@ -52,17 +52,21 @@ copy_loop:
 
 done:
 	/* go back to the original page tables */
-	movl	$swapper_pg_dir, %ecx
-	subl	$__PAGE_OFFSET, %ecx
-	movl	%ecx, %cr3
+	movl	$swapper_pg_dir, %eax
+	subl	$__PAGE_OFFSET, %eax
+	movl	%eax, %cr3
 	/* Flush TLB, including "global" things (vmalloc) */
-	movl	mmu_cr4_features, %eax
-	movl	%eax, %edx
+	movl	mmu_cr4_features, %ecx
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	movl	%ecx, %edx
 	andl	$~(1<<7), %edx;  # PGE
 	movl	%edx, %cr4;  # turn off PGE
-	movl	%cr3, %ecx;  # flush TLB
-	movl	%ecx, %cr3
-	movl	%eax, %cr4;  # turn PGE back on
+1:
+	movl	%cr3, %eax;  # flush TLB
+	movl	%eax, %cr3
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	movl	%ecx, %cr4;  # turn PGE back on
+1:
 
 	movl saved_context_esp, %esp
 	movl saved_context_ebp, %ebp
-- 
1.4.4.4

