Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXKOQli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXKOQli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbXKOQl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:41:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606AbXKOQl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:41:27 -0500
Date: Thu, 15 Nov 2007 11:41:22 -0500
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200711151641.lAFGfMow024336@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86&x86-64 support for sys_indirect
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This part adds support for sys_indirect on x86 and x86-64.

 b/arch/x86/ia32/ia32entry.S          |    1 +
 b/arch/x86/kernel/syscall_table_32.S |    1 +
 b/include/asm-x86/indirect.h         |    5 +++++
 b/include/asm-x86/indirect_32.h      |   27 +++++++++++++++++++++++++++
 b/include/asm-x86/indirect_64.h      |   30 ++++++++++++++++++++++++++++++
 b/include/asm-x86/unistd_32.h        |    3 ++-
 b/include/asm-x86/unistd_64.h        |    2 ++
 7 files changed, 68 insertions(+), 1 deletion(-)


--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -726,4 +726,5 @@ ia32_sys_call_table:
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
 	.quad sys32_fallocate
+	.quad sys_indirect		/* 325  */
 ia32_syscall_end:
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 8344c70..92095b2 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -324,3 +324,4 @@ ENTRY(sys_call_table)
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_indirect		/* 325 */
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 9b15545..8ee0b20 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
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
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index 5ff4d3e..66eab33 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -635,6 +635,8 @@ __SYSCALL(__NR_timerfd, sys_timerfd)
 __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate				285
 __SYSCALL(__NR_fallocate, sys_fallocate)
+#define __NR_indirect				286
+__SYSCALL(__NR_indirect, sys_indirect)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee800e7..e4e8a22 100644
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/asm-x86/indirect_32.h	2007-11-14 22:16:50.000000000 -0800
@@ -0,0 +1,27 @@
+#ifndef _ASM_X86_INDIRECT_32_H
+#define _ASM_X86_INDIRECT_32_H
+
+struct indirect_registers {
+  __u32 eax;
+  __u32 ebx;
+  __u32 ecx;
+  __u32 edx;
+  __u32 esi;
+  __u32 edi;
+  __u32 ebp;
+};
+
+#define CALL_INDIRECT(regs) \
+  ({ long res; \
+     if (unlikely((regs)->eax > NR_syscalls)) \
+	res = -ENOSYS; \
+     else if (unlikely((regs)->eax == __NR_indirect)) \
+	res = -EINVAL; \
+     else { \
+	extern long (*sys_call_table[]) (__u32, __u32, __u32, __u32, __u32, __u32); \
+	res = sys_call_table[(regs)->eax] ((regs)->ebx, (regs)->ecx, (regs)->edx, \
+					   (regs)->esi, (regs)->edi, (regs)->ebp); \
+     } \
+     res; })
+
+#endif
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/asm-x86/indirect_64.h	2007-11-14 22:17:43.000000000 -0800
@@ -0,0 +1,30 @@
+#ifndef _ASM_X86_INDIRECT_64_H
+#define _ASM_X86_INDIRECT_64_H
+
+struct indirect_registers {
+  __u64 rax;
+  __u64 rdi;
+  __u64 rsi;
+  __u64 rdx;
+  __u64 r10;
+  __u64 r8;
+  __u64 r9;
+};
+
+
+#define CALL_INDIRECT(regs) \
+  CALL_INDIRECT_WMAX(regs, __NR_syscall_max)
+#define CALL_INDIRECT_WMAX(regs, max) \
+  ({ long res; \
+     if (unlikely((regs)->rax > max)) \
+	res = -ENOSYS; \
+     else if (unlikely((regs)->rax == __NR_indirect)) \
+	res = -EINVAL; \
+     else { \
+	extern long (*sys_call_table[]) (__u64, __u64, __u64, __u64, __u64, __u64); \
+	res = sys_call_table[(regs)->rax] ((regs)->rdi, (regs)->rsi, (regs)->rdx, \
+					   (regs)->r10, (regs)->r8, (regs)->r9); \
+     } \
+     res; })
+
+#endif
--- /dev/null	2007-09-23 16:36:38.465394704 -0700
+++ b/include/asm-x86/indirect.h	2007-11-14 17:15:58.000000000 -0800
@@ -0,0 +1,5 @@
+#ifdef CONFIG_X86_32
+# include "indirect_32.h"
+#else
+# include "indirect_64.h"
+#endif
