Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbXKSWJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbXKSWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXKSWHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:07:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbXKSWHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:07:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 14/18] x86 vDSO: ia32 vdso32-syscall build
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Shopping-List: (1) Silent rail televisions
   (2) Infamous hydraulic winter rodents
   (3) Teutonic Deviant flossbags
   (4) Prototypical diabolical eruptions
Message-Id: <20071119220632.8F92D26F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:06:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This puts the syscall version of the 32-bit vDSO in arch/x86/vdso/vdso32/
for 64-bit IA32 support.  This is not used yet, but it paves the way for
consolidating the 32-bit vDSO source and build logic all in one place.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile           |    1 +
 arch/x86/vdso/vdso32/sigreturn.S |    9 +++--
 arch/x86/vdso/vdso32/syscall.S   |   69 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/vdso/vdso32/syscall.S

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 9ffd03f..64e4f47 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -71,6 +71,7 @@ $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 #
 obj-$(VDSO32-y)			+= vdso32-syms.lds
 vdso32.so-$(CONFIG_X86_32)	+= int80
+vdso32.so-$(CONFIG_COMPAT)	+= syscall
 vdso32.so-$(VDSO32-y)		+= sysenter
 
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
diff --git a/arch/x86/vdso/vdso32/sigreturn.S b/arch/x86/vdso/vdso32/sigreturn.S
index e939253..f222889 100644
--- a/arch/x86/vdso/vdso32/sigreturn.S
+++ b/arch/x86/vdso/vdso32/sigreturn.S
@@ -6,9 +6,12 @@
  * routines are constant for all vsyscall implementations.
  */
 
-#include <asm/unistd.h>
+#include <asm/unistd_32.h>
 #include <asm/asm-offsets.h>
 
+#ifndef SYSCALL_ENTER_KERNEL
+#define	SYSCALL_ENTER_KERNEL	int $0x80
+#endif
 
 /* XXX
    Should these be named "_sigtramp" or something?
@@ -22,7 +25,7 @@ __kernel_sigreturn:
 .LSTART_sigreturn:
 	popl %eax		/* XXX does this mean it needs unwind info? */
 	movl $__NR_sigreturn, %eax
-	int $0x80
+	SYSCALL_ENTER_KERNEL
 .LEND_sigreturn:
 	.size __kernel_sigreturn,.-.LSTART_sigreturn
 
@@ -32,7 +35,7 @@ __kernel_sigreturn:
 __kernel_rt_sigreturn:
 .LSTART_rt_sigreturn:
 	movl $__NR_rt_sigreturn, %eax
-	int $0x80
+	SYSCALL_ENTER_KERNEL
 .LEND_rt_sigreturn:
 	.size __kernel_rt_sigreturn,.-.LSTART_rt_sigreturn
 	.balign 32
diff --git a/arch/x86/vdso/vdso32/syscall.S b/arch/x86/vdso/vdso32/syscall.S
new file mode 100644
index 0000000..333bfb5
--- /dev/null
+++ b/arch/x86/vdso/vdso32/syscall.S
@@ -0,0 +1,69 @@
+/*
+ * Code for the vsyscall page.  This version uses the syscall instruction.
+ */
+
+#include <asm/asm-offsets.h>
+#include <asm/segment.h>
+
+	.text
+	.globl __kernel_vsyscall
+	.type __kernel_vsyscall,@function
+__kernel_vsyscall:
+.LSTART_vsyscall:
+	push	%ebp
+.Lpush_ebp:
+	movl	%ecx, %ebp
+	syscall
+	movl	$__USER32_DS, %ecx
+	movl	%ecx, %ss
+	movl	%ebp, %ecx
+	popl	%ebp
+.Lpop_ebp:
+	ret
+.LEND_vsyscall:
+	.size __kernel_vsyscall,.-.LSTART_vsyscall
+
+	.section .eh_frame,"a",@progbits
+.LSTARTFRAME:
+	.long .LENDCIE-.LSTARTCIE
+.LSTARTCIE:
+	.long 0			/* CIE ID */
+	.byte 1			/* Version number */
+	.string "zR"		/* NUL-terminated augmentation string */
+	.uleb128 1		/* Code alignment factor */
+	.sleb128 -4		/* Data alignment factor */
+	.byte 8			/* Return address register column */
+	.uleb128 1		/* Augmentation value length */
+	.byte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4. */
+	.byte 0x0c		/* DW_CFA_def_cfa */
+	.uleb128 4
+	.uleb128 4
+	.byte 0x88		/* DW_CFA_offset, column 0x8 */
+	.uleb128 1
+	.align 4
+.LENDCIE:
+
+	.long .LENDFDE1-.LSTARTFDE1	/* Length FDE */
+.LSTARTFDE1:
+	.long .LSTARTFDE1-.LSTARTFRAME	/* CIE pointer */
+	.long .LSTART_vsyscall-.	/* PC-relative start address */
+	.long .LEND_vsyscall-.LSTART_vsyscall
+	.uleb128 0			/* Augmentation length */
+	/* What follows are the instructions for the table generation.
+	   We have to record all changes of the stack pointer.  */
+	.byte 0x40 + .Lpush_ebp-.LSTART_vsyscall /* DW_CFA_advance_loc */
+	.byte 0x0e		/* DW_CFA_def_cfa_offset */
+	.uleb128 8
+	.byte 0x85, 0x02	/* DW_CFA_offset %ebp -8 */
+	.byte 0x40 + .Lpop_ebp-.Lpush_ebp /* DW_CFA_advance_loc */
+	.byte 0xc5		/* DW_CFA_restore %ebp */
+	.byte 0x0e		/* DW_CFA_def_cfa_offset */
+	.uleb128 4
+	.align 4
+.LENDFDE1:
+
+/*
+ * Get the common code for the sigreturn entry points.
+ */
+#define SYSCALL_ENTER_KERNEL	syscall
+#include "sigreturn.S"
