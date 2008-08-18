Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbYHRN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbYHRN0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYHRN03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:26:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYHRN02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:26:28 -0400
Date: Mon, 18 Aug 2008 15:25:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Fries <david@fries.net>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818132559.GA19578@elte.hu>
References: <20080818040340.GB17528@spacedout.fries.net> <Pine.LNX.4.55.0808180510480.26857@cliff.in.clinika.pl> <20080818125803.GC17528@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818125803.GC17528@spacedout.fries.net>
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


On Mon, Aug 18, 2008 at 05:14:50AM +0100, Maciej W. Rozycki wrote:
> On Sun, 17 Aug 2008, David Fries wrote:
> > +	/* cr4 was introduced in the Pentium CPU */
> 
>  NACK.  Later i486 chips do have CR4 -- for PSE, VME, etc. (the set of 
> features varies across the line).  Use a fixup as elsewhere or 
> something.

the version i committed (reproduced below) should work fine. It uses cr4 
opportunistically (we get a fault if it does not exist), and we write it 
back if the cr4 value is non-zero. (which it must always be on a 
CR4-enabled processor)

agreed?

	Ingo

----------->
>From e532c06f2a835b5cc4f4166f467437d9b09c1d0e Mon Sep 17 00:00:00 2001
From: David Fries <david@fries.net>
Date: Sun, 17 Aug 2008 23:03:40 -0500
Subject: [PATCH] x86: fix i486 suspend to disk CR4 oops

arch/x86/power/cpu_32.c __save_processor_state calls read_cr4()
only a i486 CPU doesn't have the CR4 register.  Trying to read it
produces an invalid opcode oops during suspend to disk.

Use the safe rc4 reading op instead. If the value to be written is
zero the write is skipped.

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
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/sleep.c      |    2 +-
 arch/x86/kernel/efi_32.c          |    4 ++--
 arch/x86/power/cpu_32.c           |    6 ++++--
 arch/x86/power/hibernate_asm_32.S |   26 +++++++++++++++-----------
 4 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 81e5ab6..426e5d9 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -86,7 +86,7 @@ int acpi_save_state_mem(void)
 #endif /* !CONFIG_64BIT */
 
 	header->pmode_cr0 = read_cr0();
-	header->pmode_cr4 = read_cr4();
+	header->pmode_cr4 = read_cr4_safe();
 	header->realmode_flags = acpi_realmode_flags;
 	header->real_magic = 0x12345678;
 
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index 4b63c8e..5cab48e 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -53,7 +53,7 @@ void efi_call_phys_prelog(void)
 	 * directory. If I have PAE, I just need to duplicate one entry in
 	 * page directory.
 	 */
-	cr4 = read_cr4();
+	cr4 = read_cr4_safe();
 
 	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
@@ -91,7 +91,7 @@ void efi_call_phys_epilog(void)
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 
-	cr4 = read_cr4();
+	cr4 = read_cr4_safe();
 
 	if (cr4 & X86_CR4_PAE) {
 		swapper_pg_dir[pgd_index(0)].pgd =
diff --git a/arch/x86/power/cpu_32.c b/arch/x86/power/cpu_32.c
index 7dc5d5c..d3e083d 100644
--- a/arch/x86/power/cpu_32.c
+++ b/arch/x86/power/cpu_32.c
@@ -45,7 +45,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->cr0 = read_cr0();
 	ctxt->cr2 = read_cr2();
 	ctxt->cr3 = read_cr3();
-	ctxt->cr4 = read_cr4();
+	ctxt->cr4 = read_cr4_safe();
 }
 
 /* Needed by apm.c */
@@ -98,7 +98,9 @@ static void __restore_processor_state(struct saved_context *ctxt)
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
