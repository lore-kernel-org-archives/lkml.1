Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYFXVC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYFXVC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYFXVCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:02:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYFXVCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:02:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] x86 ACPI: normalize segment descriptor register on resume
Date: Tue, 24 Jun 2008 23:03:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242303.49498.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch below fixes the regression described at
http://bugzilla.kernel.org/show_bug.cgi?id=10927
which is caused by the fact that some BIOSes call the kernel's resume code with
post-protected mode garbage in segment registers.

Apart from Dell laptops referred to in the chagelog it has a potential to fix
some other systems on which resume from suspend to RAM fails in a mysterious
way and the probability of it breaking things is rather small, so IMO it would
be nice to have in 2.6.26.

Thanks,
Rafael


---
From: H. Peter Anvin <hpa@zytor.com>

x86 ACPI: normalize segment descriptor register on resume

Some Dell laptops enter resume with apparent garbage in the segment
descriptor registers (almost certainly the result of a botched
transition from protected to real mode.)  The only way to clean that
up is to enter protected mode ourselves and clean out the descriptor
registers.

This fixes resume on Dell XPS M1210 and Dell D620.

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=10927

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Tested-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/realmode/wakeup.S |   38 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/acpi/realmode/wakeup.h |    5 ++++
 arch/x86/kernel/acpi/sleep.c           |   16 +++++++++++++
 drivers/acpi/sleep/main.c              |    5 +---
 4 files changed, 59 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/wakeup.S
+++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -5,6 +5,7 @@
 #include <asm/msr-index.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/processor-flags.h>
 
 	.code16
 	.section ".header", "a"
@@ -24,6 +25,11 @@ pmode_gdt:	.quad	0
 realmode_flags:	.long	0
 real_magic:	.long	0
 trampoline_segment:	.word 0
+_pad1:		.byte	0
+wakeup_jmp:	.byte	0xea	/* ljmpw */
+wakeup_jmp_off:	.word	3f
+wakeup_jmp_seg:	.word	0
+wakeup_gdt:	.quad	0, 0, 0
 signature:	.long	0x51ee1111
 
 	.text
@@ -34,11 +40,34 @@ _start:
 	cli
 	cld
 
+	/* Apparently some dimwit BIOS programmers don't know how to
+	   program a PM to RM transition, and we might end up here with
+	   junk in the data segment descriptor registers.  The only way
+	   to repair that is to go into PM and fix it ourselves... */
+	movw	$16, %cx
+	lgdtl	%cs:wakeup_gdt
+	movl	%cr0, %eax
+	orb	$X86_CR0_PE, %al
+	movl	%eax, %cr0
+	jmp	1f
+1:	ljmpw	$8, $2f
+2:
+	movw	%cx, %ds
+	movw	%cx, %es
+	movw	%cx, %ss
+	movw	%cx, %fs
+	movw	%cx, %gs
+
+	andb	$~X86_CR0_PE, %al
+	movl	%eax, %cr0
+	jmp	wakeup_jmp
+3:
 	/* Set up segments */
 	movw	%cs, %ax
 	movw	%ax, %ds
 	movw	%ax, %es
 	movw	%ax, %ss
+	lidtl	wakeup_idt
 
 	movl	$wakeup_stack_end, %esp
 
@@ -98,7 +127,14 @@ bogus_real_magic:
 	jmp	1b
 
 	.data
-	.balign	4
+	.balign	8
+
+	/* This is the standard real-mode IDT */
+wakeup_idt:
+	.word	0xffff		/* limit */
+	.long	0		/* address */
+	.word	0
+
 	.globl	HEAP, heap_end
 HEAP:
 	.long	wakeup_heap
Index: linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/wakeup.h
+++ linux-2.6/arch/x86/kernel/acpi/realmode/wakeup.h
@@ -24,6 +24,11 @@ struct wakeup_header {
 	u32 realmode_flags;
 	u32 real_magic;
 	u16 trampoline_segment;	/* segment with trampoline code, 64-bit only */
+	u8  _pad1;
+	u8  wakeup_jmp;
+	u16 wakeup_jmp_off;
+	u16 wakeup_jmp_seg;
+	u64 wakeup_gdt[3];
 	u32 signature;		/* To check we have correct structure */
 } __attribute__((__packed__));
 
Index: linux-2.6/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/sleep.c
+++ linux-2.6/arch/x86/kernel/acpi/sleep.c
@@ -50,6 +50,20 @@ int acpi_save_state_mem(void)
 
 	header->video_mode = saved_video_mode;
 
+	header->wakeup_jmp_seg = acpi_wakeup_address >> 4;
+	/* GDT[0]: GDT self-pointer */
+	header->wakeup_gdt[0] =
+		(u64)(sizeof(header->wakeup_gdt) - 1) +
+		((u64)(acpi_wakeup_address +
+			((char *)&header->wakeup_gdt - (char *)acpi_realmode))
+				<< 16);
+	/* GDT[1]: real-mode-like code segment */
+	header->wakeup_gdt[1] = (0x009bULL << 40) +
+		((u64)acpi_wakeup_address << 16) + 0xffff;
+	/* GDT[2]: real-mode-like data segment */
+	header->wakeup_gdt[2] = (0x0093ULL << 40) +
+		((u64)acpi_wakeup_address << 16) + 0xffff;
+
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
@@ -111,7 +125,7 @@ void __init acpi_reserve_bootmem(void)
 		return;
 	}
 
-	acpi_wakeup_address = acpi_realmode;
+	acpi_wakeup_address = virt_to_phys((void *)acpi_realmode);
 }
 
 
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -32,9 +32,8 @@ static int acpi_sleep_prepare(u32 acpi_s
 		if (!acpi_wakeup_address) {
 			return -EFAULT;
 		}
-		acpi_set_firmware_waking_vector((acpi_physical_address)
-						virt_to_phys((void *)
-							     acpi_wakeup_address));
+		acpi_set_firmware_waking_vector(
+				(acpi_physical_address)acpi_wakeup_address);
 
 	}
 	ACPI_FLUSH_CPU_CACHE();
