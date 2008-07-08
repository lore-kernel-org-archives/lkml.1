Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYGHXbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYGHXbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbYGHXP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:26 -0400
Received: from gw.goop.org ([64.81.55.164]:51211 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 15 of 55] xen64: fix calls into hypercall page
X-Mercurial-Node: 6958b3698c4236170a0d2fe96f0a3e30c6b82112
Message-Id: <6958b3698c4236170a0d.1215554797@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 64-bit calling convention for hypercalls uses different registers
from 32-bit.  Annoyingly, gcc's asm syntax doesn't have a way to
specify one of the extra numeric reigisters in a constraint, so we
must use explicitly placed register variables.  Given that we have to
do it for some args, may as well do it for all.

Also fix syntax gcc generates for the call instruction itself.  We
need a plain direct call, but the asm expansion which works on 32-bit
generates a rip-relative addressing mode in 64-bit, which is treated
as an indirect call.  The alternative is to pass the hypercall page
offset into the asm, and have it add it to the hypercall page start
address to generate the call.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/xen/hypercall.h |  170 +++++++++++++++++++++++++++------------
 1 file changed, 122 insertions(+), 48 deletions(-)

diff --git a/include/asm-x86/xen/hypercall.h b/include/asm-x86/xen/hypercall.h
--- a/include/asm-x86/xen/hypercall.h
+++ b/include/asm-x86/xen/hypercall.h
@@ -40,83 +40,157 @@
 #include <xen/interface/sched.h>
 #include <xen/interface/physdev.h>
 
+/*
+ * The hypercall asms have to meet several constraints:
+ * - Work on 32- and 64-bit.
+ *    The two architectures put their arguments in different sets of
+ *    registers.
+ *
+ * - Work around asm syntax quirks
+ *    It isn't possible to specify one of the rNN registers in a
+ *    constraint, so we use explicit register variables to get the
+ *    args into the right place.
+ *
+ * - Mark all registers as potentially clobbered
+ *    Even unused parameters can be clobbered by the hypervisor, so we
+ *    need to make sure gcc knows it.
+ *
+ * - Avoid compiler bugs.
+ *    This is the tricky part.  Because x86_32 has such a constrained
+ *    register set, gcc versions below 4.3 have trouble generating
+ *    code when all the arg registers and memory are trashed by the
+ *    asm.  There are syntactically simpler ways of achieving the
+ *    semantics below, but they cause the compiler to crash.
+ *
+ *    The only combination I found which works is:
+ *     - assign the __argX variables first
+ *     - list all actually used parameters as "+r" (__argX)
+ *     - clobber the rest
+ *
+ * The result certainly isn't pretty, and it really shows up cpp's
+ * weakness as as macro language.  Sorry.  (But let's just give thanks
+ * there aren't more than 5 arguments...)
+ */
+
 extern struct { char _entry[32]; } hypercall_page[];
+
+#define __HYPERCALL		"call hypercall_page+%c[offset]"
+#define __HYPERCALL_ENTRY(x)						\
+	[offset] "i" (__HYPERVISOR_##x * sizeof(hypercall_page[0]))
+
+#ifdef CONFIG_X86_32
+#define __HYPERCALL_RETREG	"eax"
+#define __HYPERCALL_ARG1REG	"ebx"
+#define __HYPERCALL_ARG2REG	"ecx"
+#define __HYPERCALL_ARG3REG	"edx"
+#define __HYPERCALL_ARG4REG	"esi"
+#define __HYPERCALL_ARG5REG	"edi"
+#else
+#define __HYPERCALL_RETREG	"rax"
+#define __HYPERCALL_ARG1REG	"rdi"
+#define __HYPERCALL_ARG2REG	"rsi"
+#define __HYPERCALL_ARG3REG	"rdx"
+#define __HYPERCALL_ARG4REG	"r10"
+#define __HYPERCALL_ARG5REG	"r8"
+#endif
+
+#define __HYPERCALL_DECLS						\
+	register unsigned long __res  asm(__HYPERCALL_RETREG);		\
+	register unsigned long __arg1 asm(__HYPERCALL_ARG1REG) = __arg1; \
+	register unsigned long __arg2 asm(__HYPERCALL_ARG2REG) = __arg2; \
+	register unsigned long __arg3 asm(__HYPERCALL_ARG3REG) = __arg3; \
+	register unsigned long __arg4 asm(__HYPERCALL_ARG4REG) = __arg4; \
+	register unsigned long __arg5 asm(__HYPERCALL_ARG5REG) = __arg5;
+
+#define __HYPERCALL_0PARAM	"=r" (__res)
+#define __HYPERCALL_1PARAM	__HYPERCALL_0PARAM, "+r" (__arg1)
+#define __HYPERCALL_2PARAM	__HYPERCALL_1PARAM, "+r" (__arg2)
+#define __HYPERCALL_3PARAM	__HYPERCALL_2PARAM, "+r" (__arg3)
+#define __HYPERCALL_4PARAM	__HYPERCALL_3PARAM, "+r" (__arg4)
+#define __HYPERCALL_5PARAM	__HYPERCALL_4PARAM, "+r" (__arg5)
+
+#define __HYPERCALL_0ARG()
+#define __HYPERCALL_1ARG(a1)						\
+	__HYPERCALL_0ARG()		__arg1 = (unsigned long)(a1);
+#define __HYPERCALL_2ARG(a1,a2)						\
+	__HYPERCALL_1ARG(a1)		__arg2 = (unsigned long)(a2);
+#define __HYPERCALL_3ARG(a1,a2,a3)					\
+	__HYPERCALL_2ARG(a1,a2)		__arg3 = (unsigned long)(a3);
+#define __HYPERCALL_4ARG(a1,a2,a3,a4)					\
+	__HYPERCALL_3ARG(a1,a2,a3)	__arg4 = (unsigned long)(a4);
+#define __HYPERCALL_5ARG(a1,a2,a3,a4,a5)				\
+	__HYPERCALL_4ARG(a1,a2,a3,a4)	__arg5 = (unsigned long)(a5);
+
+#define __HYPERCALL_CLOBBER5	"memory"
+#define __HYPERCALL_CLOBBER4	__HYPERCALL_CLOBBER5, __HYPERCALL_ARG5REG
+#define __HYPERCALL_CLOBBER3	__HYPERCALL_CLOBBER4, __HYPERCALL_ARG4REG
+#define __HYPERCALL_CLOBBER2	__HYPERCALL_CLOBBER3, __HYPERCALL_ARG3REG
+#define __HYPERCALL_CLOBBER1	__HYPERCALL_CLOBBER2, __HYPERCALL_ARG2REG
+#define __HYPERCALL_CLOBBER0	__HYPERCALL_CLOBBER1, __HYPERCALL_ARG1REG
 
 #define _hypercall0(type, name)						\
 ({									\
-	long __res;							\
-	asm volatile (							\
-		"call %[call]"						\
-		: "=a" (__res)						\
-		: [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
-		: "memory" );						\
+	__HYPERCALL_DECLS;						\
+	__HYPERCALL_0ARG();						\
+	asm volatile (__HYPERCALL					\
+		      : __HYPERCALL_0PARAM				\
+		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_CLOBBER0);				\
 	(type)__res;							\
 })
 
 #define _hypercall1(type, name, a1)					\
 ({									\
-	long __res, __ign1;						\
-	asm volatile (							\
-		"call %[call]"						\
-		: "=a" (__res), "=b" (__ign1)				\
-		: "1" ((long)(a1)),					\
-		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
-		: "memory" );						\
+	__HYPERCALL_DECLS;						\
+	__HYPERCALL_1ARG(a1);						\
+	asm volatile (__HYPERCALL					\
+		      : __HYPERCALL_1PARAM				\
+		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_CLOBBER1);				\
 	(type)__res;							\
 })
 
 #define _hypercall2(type, name, a1, a2)					\
 ({									\
-	long __res, __ign1, __ign2;					\
-	asm volatile (							\
-		"call %[call]"						\
-		: "=a" (__res), "=b" (__ign1), "=c" (__ign2)		\
-		: "1" ((long)(a1)), "2" ((long)(a2)),			\
-		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
-		: "memory" );						\
+	__HYPERCALL_DECLS;						\
+	__HYPERCALL_2ARG(a1, a2);					\
+	asm volatile (__HYPERCALL					\
+		      : __HYPERCALL_2PARAM				\
+		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_CLOBBER2);				\
 	(type)__res;							\
 })
 
 #define _hypercall3(type, name, a1, a2, a3)				\
 ({									\
-	long __res, __ign1, __ign2, __ign3;				\
-	asm volatile (							\
-		"call %[call]"						\
-		: "=a" (__res), "=b" (__ign1), "=c" (__ign2),		\
-		"=d" (__ign3)						\
-		: "1" ((long)(a1)), "2" ((long)(a2)),			\
-		  "3" ((long)(a3)),					\
-		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
-		: "memory" );						\
+	__HYPERCALL_DECLS;						\
+	__HYPERCALL_3ARG(a1, a2, a3);					\
+	asm volatile (__HYPERCALL					\
+		      : __HYPERCALL_3PARAM				\
+		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_CLOBBER3);				\
 	(type)__res;							\
 })
 
 #define _hypercall4(type, name, a1, a2, a3, a4)				\
 ({									\
-	long __res, __ign1, __ign2, __ign3, __ign4;			\
-	asm volatile (							\
-		"call %[call]"						\
-		: "=a" (__res), "=b" (__ign1), "=c" (__ign2),		\
-		"=d" (__ign3), "=S" (__ign4)				\
-		: "1" ((long)(a1)), "2" ((long)(a2)),			\
-		  "3" ((long)(a3)), "4" ((long)(a4)),			\
-		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
-		: "memory" );						\
+	__HYPERCALL_DECLS;						\
+	__HYPERCALL_4ARG(a1, a2, a3, a4);				\
+	asm volatile (__HYPERCALL					\
+		      : __HYPERCALL_4PARAM				\
+		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_CLOBBER4);				\
 	(type)__res;							\
 })
 
 #define _hypercall5(type, name, a1, a2, a3, a4, a5)			\
 ({									\
-	long __res, __ign1, __ign2, __ign3, __ign4, __ign5;		\
-	asm volatile (							\
-		"call %[call]"						\
-		: "=a" (__res), "=b" (__ign1), "=c" (__ign2),		\
-		"=d" (__ign3), "=S" (__ign4), "=D" (__ign5)		\
-		: "1" ((long)(a1)), "2" ((long)(a2)),			\
-		  "3" ((long)(a3)), "4" ((long)(a4)),			\
-		  "5" ((long)(a5)),					\
-		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
-		: "memory" );						\
+	__HYPERCALL_DECLS;						\
+	__HYPERCALL_5ARG(a1, a2, a3, a4, a5);				\
+	asm volatile (__HYPERCALL					\
+		      : __HYPERCALL_5PARAM				\
+		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_CLOBBER5);				\
 	(type)__res;							\
 })
 


