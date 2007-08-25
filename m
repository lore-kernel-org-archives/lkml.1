Return-Path: <linux-kernel-owner+w=401wt.eu-S934726AbXHYUbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934726AbXHYUbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 16:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934337AbXHYUbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 16:31:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38267 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932960AbXHYUbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 16:31:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on x86_64 (updated)
Date: Sat, 25 Aug 2007 22:42:05 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
References: <200708241206.57178.rjw@sisk.pl> <20070824204632.GA5008@ucw.cz> <200708252027.26721.rjw@sisk.pl>
In-Reply-To: <200708252027.26721.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708252242.06197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 August 2007 20:27, Rafael J. Wysocki wrote:
> On Friday, 24 August 2007 22:46, Pavel Machek wrote:
> > Hi!
> > 
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Make it possible to restore a hibernation image on x86_64 with the help of a
> > > kernel different from the one in the image.
> > > 
> > > The idea is to split the core restoration code into two separate parts and to
> > > place each of them in a different page.  The first part belongs to the boot
> > 
> > What happens in case where both parts want to be
> > at the same place? (Like kernel being restored is 4KB smaller, so that
> > routines now collide?)
> 
> Bad things, but I can't see how to avoid that reliably.

Below is an analogous patch without this problem.  The slightly ugly thing
about it is that all pages in the temporary mapping have the NX bit cleard
now, so that we can run some code out of one of them.  Still, IMO, that isn't
really important, because the temporary page tables are dropped as soon as
we jump to restore_registers.

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to restore a hibernation image on x86_64 with the help of a
kernel different from the one in the image.

The idea is to split the core restoration code into two separate parts and to
place each of them in a different page.  The first part belongs to the boot
kernel and is executed as the last step of the image kernel's memory restoration
procedure.  Before being executed, it is relocated to a safe page that won't be
overwritten while copying the image kernel pages.

The final operation performed by it is a jump to the second part of the core
restoration code that belongs to the image kernel and has just been restored.
This code makes the CPU switch to the image kernel's page tables and
restores the state of general purpose registers (including the stack pointer)
from before the hibernation.

The main issue with this idea is that in order to jump to the second part of the
core restoration code the boot kernel needs to know its address.  However, this
address may be passed to it in the image header.  Namely, the part of the image
header previously used for checking if the version of the image kernel is
correct can be replaced with some architecture specific data that will allow
the boot kernel to jump to the right address within the image kernel.  These
data should also be used for checking if the image kernel is compatible with
the boot kernel (as far as the memory restroration procedure is concerned).
It can be done, for example, with the help of a "magic" value that has to be
equal in both kernels, so that they can be regarded as compatible.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86_64/Kconfig              |    5 +++
 arch/x86_64/kernel/suspend.c     |   54 ++++++++++++++++++++++++++++++++++++++-
 arch/x86_64/kernel/suspend_asm.S |   41 ++++++++++++++++++++++++-----
 include/asm-x86_64/suspend.h     |    3 ++
 4 files changed, 95 insertions(+), 8 deletions(-)

Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend_asm.S
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend_asm.S	2007-08-25 22:09:53.000000000 +0200
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend_asm.S	2007-08-25 22:10:25.000000000 +0200
@@ -2,8 +2,8 @@
  *
  * Distribute under GPLv2.
  *
- * swsusp_arch_resume may not use any stack, nor any variable that is
- * not "NoSave" during copying pages:
+ * swsusp_arch_resume must not use any stack or any nonlocal variables while
+ * copying pages:
  *
  * Its rewriting one kernel image with another. What is stack in "old"
  * image could very well be data page in "new" image, and overwriting
@@ -36,6 +36,10 @@ ENTRY(swsusp_arch_suspend)
 	pushfq
 	popq	pt_regs_eflags(%rax)
 
+	/* save the address of restore_registers */
+	movq	$restore_registers, %rax
+	movq	%rax, restore_jump_address(%rip)
+
 	call swsusp_save
 	ret
 
@@ -54,7 +58,16 @@ ENTRY(restore_image)
 	movq	%rcx, %cr3;
 	movq	%rax, %cr4;  # turn PGE back on
 
+	/* prepare to jump to the image kernel */
+	movq	restore_jump_address(%rip), %rax
+
+	/* prepare to copy image data to their original locations */
 	movq	restore_pblist(%rip), %rdx
+	movq	relocated_restore_code(%rip), %rcx
+	jmpq	*%rcx
+
+	/* code below has been relocated to a safe page */
+ENTRY(core_restore_code)
 loop:
 	testq	%rdx, %rdx
 	jz	done
@@ -62,7 +75,7 @@ loop:
 	/* get addresses from the pbe and copy the page */
 	movq	pbe_address(%rdx), %rsi
 	movq	pbe_orig_address(%rdx), %rdi
-	movq	$512, %rcx
+	movq	$(PAGE_SIZE >> 3), %rcx
 	rep
 	movsq
 
@@ -70,6 +83,20 @@ loop:
 	movq	pbe_next(%rdx), %rdx
 	jmp	loop
 done:
+	/* jump to the restore_registers address from the image header */
+	jmpq	*%rax
+	/*
+	 * NOTE: This assumes that the boot kernel's text mapping covers the
+	 * image kernel's page containing restore_registers and the address of
+	 * this page is the same as in the image kernel's text mapping (it
+	 * should always be true, because the text mapping is linear, starting
+	 * from 0, and is supposed to cover the entire kernel text for every
+	 * kernel).
+	 *
+	 * code below belongs to the image kernel
+	 */
+
+ENTRY(restore_registers)
 	/* go back to the original page tables */
 	movq    $(init_level4_pgt - __START_KERNEL_map), %rax
 	addq    phys_base(%rip), %rax
@@ -84,10 +111,7 @@ done:
 	movq	%rcx, %cr3
 	movq	%rax, %cr4;  # turn PGE back on
 
-	movl	$24, %eax
-	movl	%eax, %ds
-
-	/* We don't restore %rax, it must be 0 anyway */
+	/* restore GPRs (we don't restore %rax, it must be 0 anyway) */
 	movq	$saved_context, %rax
 	movq	pt_regs_rsp(%rax), %rsp
 	movq	pt_regs_rbp(%rax), %rbp
@@ -109,4 +133,7 @@ done:
 
 	xorq	%rax, %rax
 
+	/* tell the hibernation core that we've just restored the memory */
+	movq	%rax, in_suspend(%rip)
+
 	ret
Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend.c	2007-08-25 22:09:53.000000000 +0200
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c	2007-08-25 22:11:43.000000000 +0200
@@ -144,8 +144,16 @@ void fix_processor_context(void)
 /* Defined in arch/x86_64/kernel/suspend_asm.S */
 extern int restore_image(void);
 
+/*
+ * Address to jump to in the last phase of restore in order to get to the image
+ * kernel's text (this value is passed in the image header).
+ */
+unsigned long restore_jump_address;
+
 pgd_t *temp_level4_pgt;
 
+void *relocated_restore_code;
+
 static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
 {
 	long i, j;
@@ -169,7 +177,7 @@ static int res_phys_pud_init(pud_t *pud,
 
 			if (paddr >= end)
 				break;
-			pe = _PAGE_NX | _PAGE_PSE | _KERNPG_TABLE | paddr;
+			pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
 			pe &= __supported_pte_mask;
 			set_pmd(pmd, __pmd(pe));
 		}
@@ -216,6 +224,13 @@ int swsusp_arch_resume(void)
 	/* We have got enough memory and from now on we cannot recover */
 	if ((error = set_up_temporary_mappings()))
 		return error;
+
+	relocated_restore_code = (void *)get_safe_page(GFP_ATOMIC);
+	if (!relocated_restore_code)
+		return -ENOMEM;
+	memcpy(relocated_restore_code, &core_restore_code,
+	       &restore_registers - &core_restore_code);
+
 	restore_image();
 	return 0;
 }
@@ -230,4 +245,41 @@ int pfn_is_nosave(unsigned long pfn)
 	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
 	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
 }
+
+struct restore_data_record {
+	unsigned long jump_address;
+	unsigned long control;
+};
+
+#define RESTORE_MAGIC	0x0123456789ABCDEFUL
+
+/**
+ *	arch_hibernation_header_save - populate the architecture specific part
+ *		of a hibernation image header
+ *	@addr: address to save the data at
+ */
+int arch_hibernation_header_save(void *addr, unsigned int max_size)
+{
+	struct restore_data_record *rdr = addr;
+
+	if (max_size < sizeof(struct restore_data_record))
+		return -EOVERFLOW;
+	rdr->jump_address = restore_jump_address;
+	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
+	return 0;
+}
+
+/**
+ *	arch_hibernation_header_restore - read the architecture specific data
+ *		from the hibernation image header
+ *	@addr: address to read the data from
+ */
+int arch_hibernation_header_restore(void *addr)
+{
+	struct restore_data_record *rdr = addr;
+
+	restore_jump_address = rdr->jump_address;
+	return (rdr->control == (restore_jump_address ^ RESTORE_MAGIC)) ?
+			0 : -EINVAL;
+}
 #endif /* CONFIG_HIBERNATION */
Index: linux-2.6.23-rc3/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/Kconfig	2007-08-25 22:09:53.000000000 +0200
+++ linux-2.6.23-rc3/arch/x86_64/Kconfig	2007-08-25 22:10:25.000000000 +0200
@@ -710,6 +710,11 @@ menu "Power management options"
 
 source kernel/power/Kconfig
 
+config ARCH_HIBERNATION_HEADER
+	bool
+	depends on HIBERNATION
+	default y
+
 source "drivers/acpi/Kconfig"
 
 source "arch/x86_64/kernel/cpufreq/Kconfig"
Index: linux-2.6.23-rc3/include/asm-x86_64/suspend.h
===================================================================
--- linux-2.6.23-rc3.orig/include/asm-x86_64/suspend.h	2007-08-25 22:09:53.000000000 +0200
+++ linux-2.6.23-rc3/include/asm-x86_64/suspend.h	2007-08-25 22:10:25.000000000 +0200
@@ -43,4 +43,7 @@ extern void fix_processor_context(void);
 /* routines for saving/restoring kernel state */
 extern int acpi_save_state_mem(void);
 
+extern char core_restore_code;
+extern char restore_registers;
+
 #endif /* __ASM_X86_64_SUSPEND_H */
