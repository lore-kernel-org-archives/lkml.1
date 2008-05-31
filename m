Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYEaB1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYEaB1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYEaB12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:27:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbYEaB11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:27:27 -0400
Date: Fri, 30 May 2008 21:27:21 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805310127.m4V1RLQo013816@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] 64-bit futexes: x86-64 support
Cc: akpm@linux-foundation.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 64-bit futex support for x86-64.  As can be seen, it consists
almost exclusively of the enablement for the FUTEX_WAKE_OP operation in the
form of new inline assembly code.  The magic to enable the 64-bit support is
the one little type definition in the types.h file.


 include/asm-x86/futex.h |   78 +++++++++++++++++++++++++++++++++++++++++++-----
 include/asm-x86/types.h |    5 +++
 2 files changed, 75 insertions(+), 8 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff -up linux-2.6/include/asm-x86/futex.h.b2 linux-2.6/include/asm-x86/futex.h
--- linux-2.6/include/asm-x86/futex.h.b2	2008-05-28 18:40:52.000000000 -0700
+++ linux-2.6/include/asm-x86/futex.h	2008-05-28 18:50:26.000000000 -0700
@@ -12,16 +12,23 @@
 #include <asm/system.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg)	\
+  do {								\
+	u32 oldvaltemp;						\
 	asm volatile("1:\t" insn "\n"				\
 		     "2:\t.section .fixup,\"ax\"\n"		\
 		     "3:\tmov\t%3, %1\n"			\
 		     "\tjmp\t2b\n"				\
 		     "\t.previous\n"				\
 		     _ASM_EXTABLE(1b, 3b)			\
-		     : "=r" (oldval), "=r" (ret), "+m" (*uaddr)	\
-		     : "i" (-EFAULT), "0" (oparg), "1" (0))
+		     : "=r" (oldvaltemp), "=r" (ret),		\
+		       "+m" (*(u32 __user *) uaddr)		\
+		     : "i" (-EFAULT), "0" (oparg), "1" (0));	\
+	oldval = oldvaltemp;					\
+  } while (0)
 
 #define __futex_atomic_op2(insn, ret, oldval, uaddr, oparg)	\
+  do {								\
+	u32 oldvaltemp;						\
 	asm volatile("1:\tmovl	%2, %0\n"			\
 		     "\tmovl\t%0, %3\n"				\
 		     "\t" insn "\n"				\
@@ -33,34 +40,67 @@
 		     "\t.previous\n"				\
 		     _ASM_EXTABLE(1b, 4b)			\
 		     _ASM_EXTABLE(2b, 4b)			\
+		     : "=&a" (oldvaltemp), "=&r" (ret),		\
+		       "+m" (*(u32 __user *) uaddr), "=&r" (tem)\
+		     : "r" (oparg), "i" (-EFAULT), "1" (0));	\
+	oldval = oldvaltemp;					\
+  } while (0)
+
+#ifndef CONFIG_X86_32
+#define __futex_atomic64_op1(insn, ret, oldval, uaddr, oparg)	\
+	asm volatile("1:\t" insn "\n"				\
+		     "2:\t.section .fixup,\"ax\"\n"		\
+		     "3:\tmov\t%3, %1\n"			\
+		     "\tjmp\t2b\n"				\
+		     "\t.previous\n"				\
+		     _ASM_EXTABLE(1b, 3b)			\
+		     : "=r" (oldval), "=r" (ret),		\
+		       "+m" (*(u32 __user *) uaddr)		\
+		     : "i" (-EFAULT), "0" (oparg), "1" (0))
+
+#define __futex_atomic64_op2(insn, ret, oldval, uaddr, oparg)	\
+	asm volatile("1:\tmovq	%q2, %q0\n"			\
+		     "\tmovq\t%q0, %q3\n"				\
+		     "\t" insn "\n"				\
+		     "2:\tlock; cmpxchgq %q3, %2\n"		\
+		     "\tjnz\t1b\n"				\
+		     "3:\t.section .fixup,\"ax\"\n"		\
+		     "4:\tmov\t%5, %1\n"			\
+		     "\tjmp\t3b\n"				\
+		     "\t.previous\n"				\
+		     _ASM_EXTABLE(1b, 4b)			\
+		     _ASM_EXTABLE(2b, 4b)			\
 		     : "=&a" (oldval), "=&r" (ret),		\
-		       "+m" (*uaddr), "=&r" (tem)		\
+		       "+m" (*(u64 __user *) uaddr), "=&r" (tem)\
 		     : "r" (oparg), "i" (-EFAULT), "1" (0))
+#endif
 
-static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr,
+static inline int futex_atomic_op_inuser(int encoded_op, void __user *uaddr,
 					 int flags)
 {
 	int op = (encoded_op >> 28) & 7;
 	int cmp = (encoded_op >> 24) & 15;
 	int oparg = (encoded_op << 8) >> 20;
 	int cmparg = (encoded_op << 20) >> 20;
-	int oldval = 0, ret, tem;
+	s64 oldval = 0;
+	int ret, tem;
 
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+	if (!access_ok(VERIFY_WRITE, uaddr,
+		       FUTEX_64_P(flags) ? sizeof(u64) : sizeof(u32)))
 		return -EFAULT;
 
 #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
-	/* Real i386 machines can only support FUTEX_OP_SET */
+	/* Real i386 machines can only support 32-bit FUTEX_OP_SET */
 	if (op != FUTEX_OP_SET && boot_cpu_data.x86 == 3)
 		return -ENOSYS;
 #endif
 
 	pagefault_disable();
 
-	switch (op) {
+	switch (op | (FUTEX_64_P(flags) ? 8 : 0)) {
 	case FUTEX_OP_SET:
 		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
 		break;
@@ -77,6 +117,28 @@ static inline int futex_atomic_op_inuser
 	case FUTEX_OP_XOR:
 		__futex_atomic_op2("xorl %4, %3", ret, oldval, uaddr, oparg);
 		break;
+#ifndef CONFIG_X86_32
+	case FUTEX_OP64_SET:
+		__futex_atomic64_op1("xchgq %q0, %q2",
+				     ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP64_ADD:
+		__futex_atomic64_op1("lock; xaddq %q0, %q2", ret, oldval,
+				     uaddr, oparg);
+		break;
+	case FUTEX_OP64_OR:
+		__futex_atomic64_op2("orq %q4, %q3",
+				     ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP64_ANDN:
+		__futex_atomic64_op2("andq %q4, %q3",
+				     ret, oldval, uaddr, ~oparg);
+		break;
+	case FUTEX_OP64_XOR:
+		__futex_atomic64_op2("xorq %q4, %q3",
+				     ret, oldval, uaddr, oparg);
+		break;		
+#endif
 	default:
 		ret = -ENOSYS;
 	}
diff -up linux-2.6/include/asm-x86/types.h.b2 linux-2.6/include/asm-x86/types.h
--- linux-2.6/include/asm-x86/types.h.b2	2008-05-28 18:29:25.000000000 -0700
+++ linux-2.6/include/asm-x86/types.h	2008-05-28 18:45:20.000000000 -0700
@@ -30,6 +30,11 @@ typedef u64 dma_addr_t;
 typedef u32 dma_addr_t;
 #endif
 
+#ifdef CONFIG_X86_64
+typedef u64 futex_val_t;
+#define __have_futex_val_t
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
