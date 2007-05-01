Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXEAEGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXEAEGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXEAEBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:48965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946472AbXEAD6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:10 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/30] i386: Verify important CPUID bits in real mode
Message-Id: <20070501035809.E5AF413CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Check some CPUID bits that are needed for compiler generated early in boot.
When the system is still in real mode before changing the VESA BIOS mode
it is possible to still display an visible error message on the screen.

Similar to x86-64.

Includes cleanups from Eric Biederman

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig.cpu                |   22 ++++++++++-
 arch/i386/boot/setup.S               |   17 ++++++++
 arch/i386/kernel/verify_cpu.S        |   68 +++++++++++++++++++++++++++++++++++
 include/asm-i386/cpufeature.h        |    3 +
 include/asm-i386/required-features.h |   34 +++++++++++++++++
 5 files changed, 142 insertions(+), 2 deletions(-)

Index: linux/arch/i386/kernel/verify_cpu.S
===================================================================
--- /dev/null
+++ linux/arch/i386/kernel/verify_cpu.S
@@ -0,0 +1,65 @@
+/* Check if CPU has some minimum CPUID bits
+   This runs in 16bit mode so that the caller can still use the BIOS
+   to output errors on the screen */
+#include <asm/cpufeature.h>
+
+verify_cpu:
+	pushfl				# Save caller passed flags
+	pushl	$0			# Kill any dangerous flags
+	popfl
+
+#if CONFIG_X86_MINIMUM_CPU_MODEL >= 4
+	pushfl
+	orl	$(1<<18),(%esp)		# try setting AC
+	popfl
+	pushfl
+	popl    %eax
+	testl	$(1<<18),%eax
+	jz	bad
+#endif
+#if REQUIRED_MASK1 != 0
+	pushfl				# standard way to check for cpuid
+	popl	%eax
+	movl	%eax,%ebx
+	xorl	$0x200000,%eax
+	pushl	%eax
+	popfl
+	pushfl
+	popl	%eax
+	cmpl	%eax,%ebx
+	pushfl				# standard way to check for cpuid
+	popl	%eax
+	movl	%eax,%ebx
+	xorl	$0x200000,%eax
+	pushl	%eax
+	popfl
+	pushfl
+	popl	%eax
+	cmpl	%eax,%ebx
+	jz	bad			# REQUIRED_MASK1 != 0 requires CPUID
+
+	movl	$0x0,%eax		# See if cpuid 1 is implemented
+	cpuid
+	cmpl	$0x1,%eax
+	jb	bad			# no cpuid 1
+
+	movl    $0x1,%eax		# Does the cpu have what it takes
+	cpuid
+
+#if CONFIG_X86_MINIMUM_CPU_MODEL > 4
+#error	add proper model checking here
+#endif
+
+	andl	$REQUIRED_MASK1,%edx
+	xorl	$REQUIRED_MASK1,%edx
+	jnz	bad
+#endif /* REQUIRED_MASK1 */
+
+	popfl
+	xor	%eax,%eax
+	ret
+
+bad:
+	popfl
+	movl	$1,%eax
+	ret
Index: linux/arch/i386/Kconfig.cpu
===================================================================
--- linux.orig/arch/i386/Kconfig.cpu
+++ linux/arch/i386/Kconfig.cpu
@@ -240,14 +240,19 @@ config X86_L1_CACHE_SHIFT
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
 
+config X86_XADD
+	bool
+	depends on !M386
+	default y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
-	depends on M386
+	depends on !X86_XADD
 	default y
 
 config RWSEM_XCHGADD_ALGORITHM
 	bool
-	depends on !M386
+	depends on X86_XADD
 	default y
 
 config ARCH_HAS_ILOG2_U32
@@ -331,3 +336,16 @@ config X86_TSC
 	bool
 	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
 	default y
+
+# this should be set for all -march=.. options where the compiler
+# generates cmov.
+config X86_CMOV
+	bool
+	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
+	default y
+
+config X86_MINIMUM_CPU_MODEL
+	int
+	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP
+	default "0"
+
Index: linux/arch/i386/boot/setup.S
===================================================================
--- linux.orig/arch/i386/boot/setup.S
+++ linux/arch/i386/boot/setup.S
@@ -302,7 +302,24 @@ good_sig:
 
 loader_panic_mess: .string "Wrong loader, giving up..."
 
+# check minimum cpuid
+# we do this here because it is the last place we can actually
+# show a user visible error message. Later the video modus
+# might be already messed up.
 loader_ok:
+	call verify_cpu
+	testl  %eax,%eax
+	jz	cpu_ok
+	lea	cpu_panic_mess,%si
+	call	prtstr
+1:	jmp	1b
+
+cpu_panic_mess:
+	.asciz  "PANIC: CPU too old for this kernel."
+
+#include "../kernel/verify_cpu.S"
+
+cpu_ok:
 # Get memory size (extended mem, kB)
 
 	xorl	%eax, %eax
Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -7,7 +7,10 @@
 #ifndef __ASM_I386_CPUFEATURE_H
 #define __ASM_I386_CPUFEATURE_H
 
+#ifndef __ASSEMBLY__
 #include <linux/bitops.h>
+#endif
+#include <asm/required-features.h>
 
 #define NCAPINTS	7	/* N 32-bit words worth of info */
 
Index: linux/include/asm-i386/required-features.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/required-features.h
@@ -0,0 +1,34 @@
+#ifndef _ASM_REQUIRED_FEATURES_H
+#define _ASM_REQUIRED_FEATURES_H 1
+
+/* Define minimum CPUID feature set for kernel These bits are checked
+   really early to actually display a visible error message before the
+   kernel dies.  Only add word 0 bits here
+
+   Some requirements that are not in CPUID yet are also in the
+   CONFIG_X86_MINIMUM_CPU mode which is checked too.
+
+   The real information is in arch/i386/Kconfig.cpu, this just converts
+   the CONFIGs into a bitmask */
+
+#ifdef CONFIG_X86_PAE
+#define NEED_PAE	(1<<X86_FEATURE_PAE)
+#else
+#define NEED_PAE	0
+#endif
+
+#ifdef CONFIG_X86_CMOV
+#define NEED_CMOV	(1<<X86_FEATURE_CMOV)
+#else
+#define NEED_CMOV	0
+#endif
+
+#ifdef CONFIG_X86_CMPXCHG64
+#define NEED_CMPXCHG64  (1<<X86_FEATURE_CX8)
+#else
+#define NEED_CMPXCHG64  0
+#endif
+
+#define REQUIRED_MASK1	(NEED_PAE|NEED_CMOV|NEED_CMPXCHG64)
+
+#endif
