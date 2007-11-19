Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbXKSWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbXKSWLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbXKSWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:08:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbXKSWIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:08:04 -0500
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
Subject: [PATCH 17/18] x86 vDSO: reorder vdso32 code
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
Emacs: the Swiss Army of Editors.
Message-Id: <20071119220701.88B1126F8C3@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:07:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This reorders the code in the 32-bit vDSO images to put the signal
trampolines first and __kernel_vsyscall after them.  The order does
not matter to userland, it just uses what AT_SYSINFO or e_entry
says.  Since the signal trampolines are the same size in both
versions of the vDSO, putting them first is the simplest way to get
the addresses to line up.  This makes it work to use a more compact
layout for the vDSO.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/vdso32/int80.S     |   15 +++++----------
 arch/x86/vdso/vdso32/sigreturn.S |   20 +++++++++-----------
 arch/x86/vdso/vdso32/syscall.S   |   15 +++++++--------
 arch/x86/vdso/vdso32/sysenter.S  |   17 ++++++-----------
 4 files changed, 27 insertions(+), 40 deletions(-)

diff --git a/arch/x86/vdso/vdso32/int80.S b/arch/x86/vdso/vdso32/int80.S
index 3c8e4c6..9d382c9 100644
--- a/arch/x86/vdso/vdso32/int80.S
+++ b/arch/x86/vdso/vdso32/int80.S
@@ -1,15 +1,15 @@
 /*
- * Code for the vsyscall page.  This version uses the old int $0x80 method.
+ * Code for the vDSO.  This version uses the old int $0x80 method.
  *
- * NOTE:
- * 1) __kernel_vsyscall _must_ be first in this page.
- * 2) there are alignment constraints on this stub, see vsyscall-sigreturn.S
- *    for details.
+ * First get the common code for the sigreturn entry points.
+ * This must come first.
  */
+#include "sigreturn.S"
 
 	.text
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
+	ALIGN
 __kernel_vsyscall:
 .LSTART_vsyscall:
 	int $0x80
@@ -46,8 +46,3 @@ __kernel_vsyscall:
 	.align 4
 .LENDFDEDLSI:
 	.previous
-
-/*
- * Get the common code for the sigreturn entry points.
- */
-#include "sigreturn.S"
diff --git a/arch/x86/vdso/vdso32/sigreturn.S b/arch/x86/vdso/vdso32/sigreturn.S
index f222889..0c1a606 100644
--- a/arch/x86/vdso/vdso32/sigreturn.S
+++ b/arch/x86/vdso/vdso32/sigreturn.S
@@ -1,11 +1,12 @@
 /*
- * Common code for the sigreturn entry points on the vsyscall page.
+ * Common code for the sigreturn entry points in vDSO images.
  * So far this code is the same for both int80 and sysenter versions.
- * This file is #include'd by vsyscall-*.S to define them after the
- * vsyscall entry point.  The kernel assumes that the addresses of these
- * routines are constant for all vsyscall implementations.
+ * This file is #include'd by int80.S et al to define them first thing.
+ * The kernel assumes that the addresses of these routines are constant
+ * for all vDSO implementations.
  */
 
+#include <linux/linkage.h>
 #include <asm/unistd_32.h>
 #include <asm/asm-offsets.h>
 
@@ -13,32 +14,29 @@
 #define	SYSCALL_ENTER_KERNEL	int $0x80
 #endif
 
-/* XXX
-   Should these be named "_sigtramp" or something?
-*/
-
 	.text
-	.org __kernel_vsyscall+32,0x90
 	.globl __kernel_sigreturn
 	.type __kernel_sigreturn,@function
+	ALIGN
 __kernel_sigreturn:
 .LSTART_sigreturn:
 	popl %eax		/* XXX does this mean it needs unwind info? */
 	movl $__NR_sigreturn, %eax
 	SYSCALL_ENTER_KERNEL
 .LEND_sigreturn:
+	nop
 	.size __kernel_sigreturn,.-.LSTART_sigreturn
 
-	.balign 32
 	.globl __kernel_rt_sigreturn
 	.type __kernel_rt_sigreturn,@function
+	ALIGN
 __kernel_rt_sigreturn:
 .LSTART_rt_sigreturn:
 	movl $__NR_rt_sigreturn, %eax
 	SYSCALL_ENTER_KERNEL
 .LEND_rt_sigreturn:
+	nop
 	.size __kernel_rt_sigreturn,.-.LSTART_rt_sigreturn
-	.balign 32
 	.previous
 
 	.section .eh_frame,"a",@progbits
diff --git a/arch/x86/vdso/vdso32/syscall.S b/arch/x86/vdso/vdso32/syscall.S
index 333bfb5..c5ccc98 100644
--- a/arch/x86/vdso/vdso32/syscall.S
+++ b/arch/x86/vdso/vdso32/syscall.S
@@ -1,13 +1,18 @@
 /*
- * Code for the vsyscall page.  This version uses the syscall instruction.
+ * Code for the vDSO.  This version uses the syscall instruction.
+ *
+ * First get the common code for the sigreturn entry points.
+ * This must come first.
  */
+#define SYSCALL_ENTER_KERNEL	syscall
+#include "sigreturn.S"
 
-#include <asm/asm-offsets.h>
 #include <asm/segment.h>
 
 	.text
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
+	ALIGN
 __kernel_vsyscall:
 .LSTART_vsyscall:
 	push	%ebp
@@ -61,9 +66,3 @@ __kernel_vsyscall:
 	.uleb128 4
 	.align 4
 .LENDFDE1:
-
-/*
- * Get the common code for the sigreturn entry points.
- */
-#define SYSCALL_ENTER_KERNEL	syscall
-#include "sigreturn.S"
diff --git a/arch/x86/vdso/vdso32/sysenter.S b/arch/x86/vdso/vdso32/sysenter.S
index 109bfa3..a9bb825 100644
--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -1,11 +1,10 @@
 /*
- * Code for the vsyscall page.  This version uses the sysenter instruction.
+ * Code for the vDSO.  This version uses the sysenter instruction.
  *
- * NOTE:
- * 1) __kernel_vsyscall _must_ be first in this page.
- * 2) there are alignment constraints on this stub, see vsyscall-sigreturn.S
- *    for details.
+ * First get the common code for the sigreturn entry points.
+ * This must come first.
  */
+#include "sigreturn.S"
 
 /*
  * The caller puts arg2 in %ecx, which gets pushed. The kernel will use
@@ -23,11 +22,12 @@
  * arg6 from the stack.
  *
  * You can not use this vsyscall for the clone() syscall because the
- * three dwords on the parent stack do not get copied to the child.
+ * three words on the parent stack do not get copied to the child.
  */
 	.text
 	.globl __kernel_vsyscall
 	.type __kernel_vsyscall,@function
+	ALIGN
 __kernel_vsyscall:
 .LSTART_vsyscall:
 	push %ecx
@@ -114,8 +114,3 @@ VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	.align 4
 .LENDFDEDLSI:
 	.previous
-
-/*
- * Get the common code for the sigreturn entry points.
- */
-#include "sigreturn.S"
