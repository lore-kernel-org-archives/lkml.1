Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbZEGW14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbZEGW14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761109AbZEGW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:11 -0400
Received: from mga06.intel.com ([134.134.136.21]:19804 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752455AbZEGW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470413"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/14] x86, boot: honor CONFIG_PHYSICAL_START when relocatable
Date: Thu,  7 May 2009 15:26:50 -0700
Message-Id: <1241735222-6640-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Currently, when building a relocatable kernel, CONFIG_PHYSICAL_START
is ignored.  This is undesirable, as we would like to keep the kernel
out of ZONE_DMA and away from the possible memory hole at 15 MB (which
some vendors for some bizarre reason still have.)

With this patch, CONFIG_PHYSICAL_START is considered the *minimum*
address at which the kernel can be located; a relocating bootloader
can locate it higher, but not lower.  This also restores the
originally intended behavior that CONFIG_RELOCATABLE is functionally a
noop if used with a non-relocating bootloader.

This patch also change movsb and stosb to movsl, stosl and stosq, to
shave a small fraction off the boot time.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/head_32.S |   77 ++++++++++++++++++-----------------
 arch/x86/boot/compressed/head_64.S |   37 ++++++++++-------
 2 files changed, 61 insertions(+), 53 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 85bd328..31fc6dc 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -39,11 +39,11 @@ ENTRY(startup_32)
 
 	cli
 	movl $(__BOOT_DS),%eax
-	movl %eax,%ds
-	movl %eax,%es
-	movl %eax,%fs
-	movl %eax,%gs
-	movl %eax,%ss
+	movl %eax, %ds
+	movl %eax, %es
+	movl %eax, %fs
+	movl %eax, %gs
+	movl %eax, %ss
 1:
 
 /* Calculate the delta between where we were compiled to run
@@ -64,12 +64,18 @@ ENTRY(startup_32)
  */
 
 #ifdef CONFIG_RELOCATABLE
-	movl 	%ebp, %ebx
-	addl    $(CONFIG_PHYSICAL_ALIGN - 1), %ebx
-	andl    $(~(CONFIG_PHYSICAL_ALIGN - 1)), %ebx
+	movl $LOAD_PHYSICAL_ADDR, %eax
+	movl %ebp, %ebx
+	cmpl %ebx, %eax
+	jbe 1f
+	movl %eax, %ebx
+1:
+	addl $(CONFIG_PHYSICAL_ALIGN - 1), %ebx
+	andl $(~(CONFIG_PHYSICAL_ALIGN - 1)), %ebx
 #else
 	movl $LOAD_PHYSICAL_ADDR, %ebx
 #endif
+	movl %ebx, %edi		/* Save kernel target address */
 
 	/* Replace the compressed data size with the uncompressed size */
 	subl input_len(%ebp), %ebx
@@ -84,27 +90,30 @@ ENTRY(startup_32)
 	addl $4095, %ebx
 	andl $~4095, %ebx
 
-/* Copy the compressed kernel to the end of our buffer
+/*
+ * Set up the stack
+ */
+	leal boot_stack_end(%ebx), %esp
+	pushl %edi		/* Saved kernel target address */
+
+/*
+ * Copy the compressed kernel to the end of our buffer
  * where decompression in place becomes safe.
  */
 	pushl %esi
-	leal _ebss(%ebp), %esi
-	leal _ebss(%ebx), %edi
-	movl $(_ebss - startup_32), %ecx
+	leal (_bss-4)(%ebp), %esi
+	leal (_bss-4)(%ebx), %edi
+	movl $(_bss - startup_32), %ecx
+	shrl $2, %ecx
 	std
-	rep
-	movsb
+	rep; movsl
 	cld
 	popl %esi
 
-/* Compute the kernel start address.
+/*
+ * %ebp -> kernel target address
  */
-#ifdef CONFIG_RELOCATABLE
-	addl    $(CONFIG_PHYSICAL_ALIGN - 1), %ebp
-	andl    $(~(CONFIG_PHYSICAL_ALIGN - 1)), %ebp
-#else
-	movl	$LOAD_PHYSICAL_ADDR, %ebp
-#endif
+	popl %ebp
 
 /*
  * Jump to the relocated address.
@@ -117,20 +126,14 @@ ENDPROC(startup_32)
 relocated:
 
 /*
- * Clear BSS
- */
-	xorl %eax,%eax
-	leal _edata(%ebx),%edi
-	leal _ebss(%ebx), %ecx
-	subl %edi,%ecx
-	cld
-	rep
-	stosb
-
-/*
- * Setup the stack for the decompressor
+ * Clear BSS - note: stack is currently empty
  */
-	leal boot_stack_end(%ebx), %esp
+	xorl %eax, %eax
+	leal _bss(%ebx), %edi
+	leal (_ebss+3)(%ebx), %ecx
+	subl %edi, %ecx
+	shrl $2, %ecx
+	rep; stosl
 
 /*
  * Do the decompression, and jump to the new kernel..
@@ -178,12 +181,12 @@ relocated:
 /*
  * Jump to the decompressed kernel.
  */
-	xorl %ebx,%ebx
+	xorl %ebx, %ebx
 	jmp *%ebp
 
-.bss
 /* Stack and heap for uncompression */
-.balign 4
+	.bss
+	.balign 4
 boot_heap:
 	.fill BOOT_HEAP_SIZE, 1, 0
 boot_stack:
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index ed4a829..f4ddd02 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -7,11 +7,6 @@
 /*
  *  head.S contains the 32-bit startup code.
  *
- * NOTE!!! Startup happens at absolute address 0x00001000, which is also where
- * the page directory will exist. The startup code will be overwritten by
- * the page directory. [According to comments etc elsewhere on a compressed
- * kernel it will end up at 0x1000 + 1Mb I hope so as I assume this. - AC]
- *
  * Page 0 is deliberately kept safe, since System Management Mode code in 
  * laptops may need to access the BIOS data stored there.  This is also
  * useful for future device drivers that either access the BIOS via VM86 
@@ -77,11 +72,17 @@ ENTRY(startup_32)
  * contains the address where we should move the kernel image temporarily
  * for safe in-place decompression.
  */
+ALIGN_MASK	= (CONFIG_PHYSICAL_ALIGN-1) | (PMD_PAGE_SIZE-1)
 
 #ifdef CONFIG_RELOCATABLE
+	movl	$CONFIG_PHYSICAL_START, %eax
 	movl	%ebp, %ebx
-	addl	$(PMD_PAGE_SIZE -1), %ebx
-	andl	$PMD_PAGE_MASK, %ebx
+	addl	$ALIGN_MASK, %ebx
+	andl	$~ALIGN_MASK, %ebx
+	cmpl	%ebx, %eax
+	jbe	1f
+	movl	%eax, %ebx
+1:
 #else
 	movl	$CONFIG_PHYSICAL_START, %ebx
 #endif
@@ -221,13 +222,17 @@ ENTRY(startup_64)
 	/* Start with the delta to where the kernel will run at. */
 #ifdef CONFIG_RELOCATABLE
 	leaq	startup_32(%rip) /* - $startup_32 */, %rbp
-	addq	$(PMD_PAGE_SIZE - 1), %rbp
-	andq	$PMD_PAGE_MASK, %rbp
-	movq	%rbp, %rbx
+	movq	$CONFIG_PHYSICAL_START, %rax
+	addq	$ALIGN_MASK, %rbp
+	andq	$~ALIGN_MASK, %rbp
+	cmpq	%rbp, %rax
+	jbe	1f
+	movq	%rax, %rbp
+1:
 #else
 	movq	$CONFIG_PHYSICAL_START, %rbp
-	movq	%rbp, %rbx
 #endif
+	movq	%rbp, %rbx
 
 	/* Replace the compressed data size with the uncompressed size */
 	movl	input_len(%rip), %eax
@@ -266,13 +271,13 @@ relocated:
 /*
  * Clear BSS
  */
-	xorq	%rax, %rax
-	leaq    _edata(%rbx), %rdi
-	leaq    _end_before_pgt(%rbx), %rcx
+	xorl	%eax, %eax
+	leaq    _edata(%rip), %rdi
+	leaq    _end_before_pgt(%rip), %rcx
 	subq	%rdi, %rcx
+	shrq	$3, %rcx
 	cld
-	rep
-	stosb
+	rep	stosq
 
 	/* Setup the stack */
 	leaq	boot_stack_end(%rip), %rsp
-- 
1.6.0.6

