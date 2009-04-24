Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZDXOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZDXOrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZDXOrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:47:03 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:34590 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZDXOrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:47:01 -0400
Date: Fri, 24 Apr 2009 18:46:58 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: futex implementation
Message-ID: <20090424144658.GC32087@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/include/asm/barrier.h |    2 +
 arch/alpha/include/asm/futex.h   |  118 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/asm/barrier.h b/arch/alpha/include/asm/barrier.h
index ac78eba..ce8860a 100644
--- a/arch/alpha/include/asm/barrier.h
+++ b/arch/alpha/include/asm/barrier.h
@@ -16,11 +16,13 @@ __asm__ __volatile__("wmb": : :"memory")
 __asm__ __volatile__("mb": : :"memory")
 
 #ifdef CONFIG_SMP
+#define __ASM_SMP_MB	"\tmb\n"
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #else
+#define __ASM_SMP_MB
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
diff --git a/arch/alpha/include/asm/futex.h b/arch/alpha/include/asm/futex.h
index 6a332a9..945de22 100644
--- a/arch/alpha/include/asm/futex.h
+++ b/arch/alpha/include/asm/futex.h
@@ -1,6 +1,116 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
+#ifndef _ASM_ALPHA_FUTEX_H
+#define _ASM_ALPHA_FUTEX_H
 
-#include <asm-generic/futex.h>
+#ifdef __KERNEL__
 
-#endif
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+#include <asm/barrier.h>
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)	\
+	__asm__ __volatile__(					\
+		__ASM_SMP_MB					\
+	"1:	ldl_l	%0,0(%2)\n"				\
+		insn						\
+	"2:	stl_c	%1,0(%2)\n"				\
+	"	beq	%1,4f\n"				\
+	"	mov	$31,%1\n"				\
+	"3:	.subsection 2\n"				\
+	"4:	br	1b\n"					\
+	"	.previous\n"					\
+	"	.section __ex_table,\"a\"\n"			\
+	"	.long	1b-.\n"					\
+	"	lda	$31,3b-1b(%1)\n"			\
+	"	.long	2b-.\n"					\
+	"	lda	$31,3b-2b(%1)\n"			\
+	"	.previous\n"					\
+	:	"=&r" (oldval), "=&r"(ret)			\
+	:	"r" (uaddr), "r"(oparg)				\
+	:	"memory")
+
+static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret;
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("mov %3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("addl %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("or %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("andnot %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("xor %0,%3,%1\n", ret, oldval, uaddr, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
+		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
+		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
+		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
+		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
+		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
+		default: ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+{
+	int prev, cmp;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	__asm__ __volatile__ (
+		__ASM_SMP_MB
+	"1:	ldl_l	%0,0(%2)\n"
+	"	cmpeq	%0,%3,%1\n"
+	"	beq	%1,3f\n"
+	"	mov	%4,%1\n"
+	"2:	stl_c	%1,0(%2)\n"
+	"	beq	%1,4f\n"
+	"3:	.subsection 2\n"
+	"4:	br	1b\n"
+	"	.previous\n"
+	"	.section __ex_table,\"a\"\n"
+	"	.long	1b-.\n"
+	"	lda	$31,3b-1b(%0)\n"
+	"	.long	2b-.\n"
+	"	lda	$31,3b-2b(%0)\n"
+	"	.previous\n"
+	:	"=&r"(prev), "=&r"(cmp)
+	:	"r"(uaddr), "r"((long)oldval), "r"(newval)
+	:	"memory");
+
+	return prev;
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_ALPHA_FUTEX_H */
