Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYGLJWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYGLJWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 05:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYGLJWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 05:22:15 -0400
Received: from gw.goop.org ([64.81.55.164]:40326 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYGLJWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 05:22:14 -0400
Message-ID: <487877B8.8010505@goop.org>
Date: Sat, 12 Jul 2008 02:22:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH 1/3] x86_64: further cleanup of 32-bit compat syscall mechanisms
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD only supports "syscall" from 32-bit compat usermode.
Intel and Centaur(?) only support "sysenter" from 32-bit compat usermode.

Set the X86 feature bits accordingly, and set up the vdso in
accordance with those bits.  On the offchance we run on in a 64-bit
environment which supports neither syscall nor sysenter from 32-bit
mode, then fall back to the int $0x80 vdso.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/amd_64.c    |    2 ++
 arch/x86/kernel/cpu/common_64.c |    3 ---
 arch/x86/vdso/Makefile          |    2 +-
 arch/x86/vdso/vdso32-setup.c    |   19 +++++++++----------
 arch/x86/vdso/vdso32.S          |   13 ++++++++-----
 arch/x86/xen/setup.c            |   10 +++++++---
 include/asm-x86/vdso.h          |    8 ++++++++
 7 files changed, 35 insertions(+), 22 deletions(-)

===================================================================
--- a/arch/x86/kernel/cpu/amd_64.c
+++ b/arch/x86/kernel/cpu/amd_64.c
@@ -115,6 +115,8 @@ static void __cpuinit early_init_amd(str
 	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
 	if (c->x86_power & (1<<8))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
===================================================================
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -315,9 +315,6 @@ static void __cpuinit early_identify_cpu
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
-	/* Assume all 64-bit CPUs support 32-bit syscall */
-	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
-
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
===================================================================
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -62,7 +62,7 @@ endef
 # Build multiple 32-bit vDSO images to choose from at boot time.
 #
 obj-$(VDSO32-y)			+= vdso32-syms.lds
-vdso32.so-$(CONFIG_X86_32)	+= int80
+vdso32.so-$(VDSO32-y)		+= int80
 vdso32.so-$(CONFIG_COMPAT)	+= syscall
 vdso32.so-$(VDSO32-y)		+= sysenter
 
===================================================================
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -193,17 +193,12 @@ static __init void relocate_vdso(Elf32_E
 	}
 }
 
-/*
- * These symbols are defined by vdso32.S to mark the bounds
- * of the ELF DSO images included therein.
- */
-extern const char vdso32_default_start, vdso32_default_end;
-extern const char vdso32_sysenter_start, vdso32_sysenter_end;
 static struct page *vdso32_pages[1];
 
 #ifdef CONFIG_X86_64
 
 #define	vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SYSENTER32))
+#define	vdso32_syscall()	(boot_cpu_has(X86_FEATURE_SYSCALL32))
 
 /* May not be __init: called during resume */
 void syscall32_cpu_init(void)
@@ -226,6 +221,7 @@ static inline void map_compat_vdso(int m
 #else  /* CONFIG_X86_32 */
 
 #define vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SEP))
+#define vdso32_syscall()	(0)
 
 void enable_sep_cpu(void)
 {
@@ -296,12 +292,15 @@ int __init sysenter_setup(void)
 	gate_vma_init();
 #endif
 
-	if (!vdso32_sysenter()) {
-		vsyscall = &vdso32_default_start;
-		vsyscall_len = &vdso32_default_end - &vdso32_default_start;
-	} else {
+	if (vdso32_syscall()) {
+		vsyscall = &vdso32_syscall_start;
+		vsyscall_len = &vdso32_syscall_end - &vdso32_syscall_start;
+	} else if (vdso32_sysenter()){
 		vsyscall = &vdso32_sysenter_start;
 		vsyscall_len = &vdso32_sysenter_end - &vdso32_sysenter_start;
+	} else {
+		vsyscall = &vdso32_int80_start;
+		vsyscall_len = &vdso32_int80_end - &vdso32_int80_start;
 	}
 
 	memcpy(syscall_page, vsyscall, vsyscall_len);
===================================================================
--- a/arch/x86/vdso/vdso32.S
+++ b/arch/x86/vdso/vdso32.S
@@ -2,14 +2,17 @@
 
 __INITDATA
 
-	.globl vdso32_default_start, vdso32_default_end
-vdso32_default_start:
-#ifdef CONFIG_X86_32
+	.globl vdso32_int80_start, vdso32_int80_end
+vdso32_int80_start:
 	.incbin "arch/x86/vdso/vdso32-int80.so"
-#else
+vdso32_int80_end:
+
+	.globl vdso32_syscall_start, vdso32_syscall_end
+vdso32_syscall_start:
+#ifdef CONFIG_COMPAT
 	.incbin "arch/x86/vdso/vdso32-syscall.so"
 #endif
-vdso32_default_end:
+vdso32_syscall_end:
 
 	.globl vdso32_sysenter_start, vdso32_sysenter_end
 vdso32_sysenter_start:
===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -83,12 +83,16 @@ static void xen_idle(void)
 
 /*
  * Set the bit indicating "nosegneg" library variants should be used.
+ * We only need to bother in pure 32-bit mode; compat 32-bit processes
+ * can have un-truncated segments, so wrapping around is allowed.
  */
 static void __init fiddle_vdso(void)
 {
-#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
-	extern const char vdso32_default_start;
-	u32 *mask = VDSO32_SYMBOL(&vdso32_default_start, NOTE_MASK);
+#ifdef CONFIG_X86_32
+	u32 *mask;
+	mask = VDSO32_SYMBOL(&vdso32_int80_start, NOTE_MASK);
+	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
+	mask = VDSO32_SYMBOL(&vdso32_sysenter_start, NOTE_MASK);
 	*mask |= 1 << VDSO_NOTE_NONEGSEG_BIT;
 #endif
 }
===================================================================
--- a/include/asm-x86/vdso.h
+++ b/include/asm-x86/vdso.h
@@ -36,4 +36,12 @@ extern void __user __kernel_sigreturn;
 extern void __user __kernel_sigreturn;
 extern void __user __kernel_rt_sigreturn;
 
+/*
+ * These symbols are defined by vdso32.S to mark the bounds
+ * of the ELF DSO images included therein.
+ */
+extern const char vdso32_int80_start, vdso32_int80_end;
+extern const char vdso32_syscall_start, vdso32_syscall_end;
+extern const char vdso32_sysenter_start, vdso32_sysenter_end;
+
 #endif	/* asm-x86/vdso.h */


