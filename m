Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbXKUHaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbXKUHaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbXKUH3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:29:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbXKUH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:29:22 -0500
Date: Wed, 21 Nov 2007 02:28:50 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711210728.lAL7So6M015046@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCHv5 2/5] x86&x86-64 support for sys_indirect
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This part adds support for sys_indirect on x86 and x86-64.

 arch/x86/Kconfig                   |    3 ++
 arch/x86/ia32/Makefile             |    1 
 arch/x86/ia32/ia32entry.S          |    2 +
 arch/x86/ia32/sys_ia32.c           |   38 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/syscall_table_32.S |    1 
 include/asm-x86/indirect.h         |    5 ++++
 include/asm-x86/indirect_32.h      |   25 ++++++++++++++++++++++++
 include/asm-x86/indirect_64.h      |   36 +++++++++++++++++++++++++++++++++++
 include/asm-x86/unistd_32.h        |    3 +-
 include/asm-x86/unistd_64.h        |    2 +
 10 files changed, 115 insertions(+), 1 deletion(-)


--- linux/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -112,6 +112,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
+config ARCH_HAS_INDIRECT_SYSCALLS
+	def_bool y
+
 
 
 
diff -u linux/include/asm-x86/indirect_32.h linux/include/asm-x86/indirect_32.h
--- linux/include/asm-x86/indirect_32.h
+++ linux/include/asm-x86/indirect_32.h
@@ -0,0 +1,25 @@
+#ifndef _ASM_X86_INDIRECT_32_H
+#define _ASM_X86_INDIRECT_32_H
+
+struct indirect_registers {
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+	__u32 esi;
+	__u32 edi;
+	__u32 ebp;
+};
+
+#define INDIRECT_SYSCALL(regs) (regs)->eax
+
+static inline long call_indirect(struct indirect_registers *regs)
+{
+  extern long (*sys_call_table[]) (__u32, __u32, __u32, __u32, __u32, __u32);
+
+  return sys_call_table[INDIRECT_SYSCALL(regs)](regs->ebx, regs->ecx,
+						regs->edx, regs->esi,
+						regs->edi, regs->ebp);
+}
+
+#endif
diff -u linux/include/asm-x86/indirect_64.h linux/include/asm-x86/indirect_64.h
--- linux/include/asm-x86/indirect_64.h
+++ linux/include/asm-x86/indirect_64.h
@@ -0,0 +1,36 @@
+#ifndef _ASM_X86_INDIRECT_64_H
+#define _ASM_X86_INDIRECT_64_H
+
+struct indirect_registers {
+	__u64 rax;
+	__u64 rdi;
+	__u64 rsi;
+	__u64 rdx;
+	__u64 r10;
+	__u64 r8;
+	__u64 r9;
+};
+
+struct indirect_registers32 {
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+	__u32 esi;
+	__u32 edi;
+	__u32 ebp;
+};
+
+#define INDIRECT_SYSCALL(regs) (regs)->rax
+#define INDIRECT_SYSCALL32(regs) (regs)->eax
+
+static inline long call_indirect(struct indirect_registers *regs)
+{
+  extern long (*sys_call_table[]) (__u64, __u64, __u64, __u64, __u64, __u64);
+
+  return sys_call_table[INDIRECT_SYSCALL(regs)](regs->rdi, regs->rsi,
+						regs->rdx, regs->r10,
+						regs->r8, regs->r9);
+}
+
+#endif
diff -u linux/arch/x86/ia32/sys_ia32.c linux/arch/x86/ia32/sys_ia32.c
--- linux/arch/x86/ia32/sys_ia32.c
+++ linux/arch/x86/ia32/sys_ia32.c
@@ -889,0 +890,38 @@
+
+asmlinkage long sys32_indirect(struct indirect_registers32 __user *userregs,
+			       void __user *userparams, size_t paramslen,
+			       int flags)
+{
+	extern long (*ia32_sys_call_table[])(u32, u32, u32, u32, u32, u32);
+
+	struct indirect_registers32 regs;
+	long result;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	if (copy_from_user(&regs, userregs, sizeof(regs)))
+		return -EFAULT;
+
+	switch (INDIRECT_SYSCALL32(&regs))
+	{
+#define INDSYSCALL(name) __NR_ia32_##name
+#include <linux/indirect.h>
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (paramslen > sizeof(union indirect_params))
+		return -EINVAL;
+	result = -EFAULT;
+	if (!copy_from_user(&current->indirect_params, userparams, paramslen))
+		result = ia32_sys_call_table[regs.eax](regs.ebx, regs.ecx,
+						       regs.edx, regs.esi,
+						       regs.edi, regs.ebp);
+
+	memset(&current->indirect_params, '\0', paramslen);
+
+	return result;
+}
--- linux/arch/x86/ia32/Makefile
+++ linux/arch/x86/ia32/Makefile
@@ -36,6 +36,7 @@ $(obj)/vsyscall-sysenter.so.dbg $(obj)/vsyscall-syscall.so.dbg: \
 $(obj)/vsyscall-%.so.dbg: $(src)/vsyscall.lds $(obj)/vsyscall-%.o FORCE
 	$(call if_changed,syscall)
 
+CFLAGS_sys_ia32.o = -Wno-undef
 AFLAGS_vsyscall-sysenter.o = -m32 -Wa,-32
 AFLAGS_vsyscall-syscall.o = -m32 -Wa,-32
 
--- linux/arch/x86/ia32/ia32entry.S
+++ linux/arch/x86/ia32/ia32entry.S
@@ -400,6 +400,7 @@ END(ia32_ptregs_common)
 
 	.section .rodata,"a"
 	.align 8
+	.globl ia32_sys_call_table
 ia32_sys_call_table:
 	.quad sys_restart_syscall
 	.quad sys_exit
@@ -726,4 +727,5 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad sys32_indirect		/* 325  */
 ia32_syscall_end:
--- linux/arch/x86/kernel/syscall_table_32.S
+++ linux/arch/x86/kernel/syscall_table_32.S
@@ -324,3 +324,4 @@ ENTRY(sys_call_table)
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_indirect		/* 325 */
--- linux/include/asm-x86/unistd_32.h
+++ linux/include/asm-x86/unistd_32.h
@@ -330,10 +330,11 @@
 #define __NR_timerfd		322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_indirect		325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
--- linux/include/asm-x86/unistd_64.h
+++ linux/include/asm-x86/unistd_64.h
@@ -635,6 +635,8 @@ __SYSCALL(__NR_timerfd, sys_timerfd)
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate				285
 __SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_indirect				286
+__SYSCALL(__NR_indirect, sys_indirect)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
--- /dev/null
+++ linux/include/asm-x86/indirect.h
@@ -0,0 +1,5 @@
+#ifdef CONFIG_X86_32
+# include "indirect_32.h"
+#else
+# include "indirect_64.h"
+#endif
