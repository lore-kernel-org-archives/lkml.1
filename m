Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYGET34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYGET34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 15:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYGET3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 15:29:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36775 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYGET3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 15:29:50 -0400
Date: Sat, 5 Jul 2008 21:29:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080705192931.GA20796@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86 ACPI: normalize segment descriptor register on resume

Rafael J. Wysocki (1):
      x86 ACPI: fix resume from suspend to RAM on uniprocessor x86-64

 arch/x86/kernel/acpi/realmode/wakeup.S |   38 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/acpi/realmode/wakeup.h |    5 ++++
 arch/x86/kernel/acpi/sleep.c           |   16 ++++++++++++-
 arch/x86/kernel/head_64.S              |    2 +-
 drivers/acpi/sleep/main.c              |    5 +--
 5 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index f9b77fb..3355973 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
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
diff --git a/arch/x86/kernel/acpi/realmode/wakeup.h b/arch/x86/kernel/acpi/realmode/wakeup.h
index ef8166f..69d38d0 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.h
+++ b/arch/x86/kernel/acpi/realmode/wakeup.h
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
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index afc25ee..36af01f 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
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
 
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 10a1955..b817974 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -128,7 +128,7 @@ ident_complete:
 	/* Fixup phys_base */
 	addq	%rbp, phys_base(%rip)
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_TRAMPOLINE
 	addq	%rbp, trampoline_level4_pgt + 0(%rip)
 	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
 #endif
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c3b0cd8..495c63a 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -36,9 +36,8 @@ static int acpi_sleep_prepare(u32 acpi_state)
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
