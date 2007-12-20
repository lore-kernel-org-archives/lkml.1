Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbXLTUI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbXLTUI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbXLTUIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:08:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbXLTUIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:08:17 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 02/15] adjust PVOP_CALL/VCALL macros for x86_64
Date: Thu, 20 Dec 2007 18:03:57 -0200
Message-Id: <11981811852758-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981811293763-git-send-email-gcosta@redhat.com>
References: <11981810504172-git-send-email-gcosta@redhat.com> <11981811293763-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjust the PVOP_VCALL and PVOP_CALL macros to
work with x86_64. It has a different calling convention, and
we use auxiliary macros to account for both calling conventions
as cleanly as possible

Comments are adjusted accordingly.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   87 +++++++++++++++++++++++++++++++++-----------
 1 files changed, 65 insertions(+), 22 deletions(-)

Index: linux-2.6-x86/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/paravirt.h	2007-12-20 19:07:07.000000000 -0800
+++ linux-2.6-x86/include/asm-x86/paravirt.h	2007-12-20 19:07:17.000000000 -0800
@@ -320,7 +320,7 @@
  * runtime.
  *
  * Normally, a call to a pv_op function is a simple indirect call:
- * (paravirt_ops.operations)(args...).
+ * (pv_op_struct.operations)(args...).
  *
  * Unfortunately, this is a relatively slow operation for modern CPUs,
  * because it cannot necessarily determine what the destination
@@ -330,11 +330,17 @@
  * calls are essentially free, because the call and return addresses
  * are completely predictable.)
  *
- * These macros rely on the standard gcc "regparm(3)" calling
+ * For i386, these macros rely on the standard gcc "regparm(3)" calling
  * convention, in which the first three arguments are placed in %eax,
  * %edx, %ecx (in that order), and the remaining arguments are placed
  * on the stack.  All caller-save registers (eax,edx,ecx) are expected
  * to be modified (either clobbered or used for return values).
+ * X86_64, on the other hand, already specifies a register-based calling
+ * conventions, returning at %rax, with parameteres going on %rdi, %rsi,
+ * %rdx, and %rcx. Note that for this reason, x86_64 does not need any
+ * special handling for dealing with 4 arguments, unlike i386.
+ * However, x86_64 also have to clobber all caller saved registers, which
+ * unfortunately, are quite a bit (r8 - r11)
  *
  * The call instruction itself is marked by placing its start address
  * and size into the .parainstructions section, so that
@@ -357,10 +363,12 @@
  * the return type.  The macro then uses sizeof() on that type to
  * determine whether its a 32 or 64 bit value, and places the return
  * in the right register(s) (just %eax for 32-bit, and %edx:%eax for
- * 64-bit).
+ * 64-bit). For x86_64 machines, it just returns at %rax regardless of
+ * the return value size.
  *
  * 64-bit arguments are passed as a pair of adjacent 32-bit arguments
- * in low,high order.
+ * i386 also passes 64-bit arguments as a pair of adjacent 32-bit arguments
+ * in low,high order
  *
  * Small structures are passed and returned in registers.  The macro
  * calling convention can't directly deal with this, so the wrapper
@@ -370,46 +378,67 @@
  * means that all uses must be wrapped in inline functions.  This also
  * makes sure the incoming and outgoing types are always correct.
  */
+#ifdef CONFIG_X86_32
+#define PVOP_VCALL_ARGS			unsigned long __eax, __edx, __ecx
+#define PVOP_CALL_ARGS			PVOP_VCALL_ARGS
+#define PVOP_VCALL_CLOBBERS		"=a" (__eax), "=d" (__edx),	\
+					"=c" (__ecx)
+#define PVOP_CALL_CLOBBERS		PVOP_VCALL_CLOBBERS
+#define EXTRA_CLOBBERS
+#define VEXTRA_CLOBBERS
+#else
+#define PVOP_VCALL_ARGS		unsigned long __edi, __esi, __edx, __ecx
+#define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
+#define PVOP_VCALL_CLOBBERS	"=D" (__edi),				\
+				"=S" (__esi), "=d" (__edx),		\
+				"=c" (__ecx)
+
+#define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
+
+#define EXTRA_CLOBBERS	 , "r8", "r9", "r10", "r11"
+#define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
+#endif
+
 #define __PVOP_CALL(rettype, op, pre, post, ...)			\
 	({								\
 		rettype __ret;						\
-		unsigned long __eax, __edx, __ecx;			\
+		PVOP_CALL_ARGS;					\
+		/* This is 32-bit specific, but is okay in 64-bit */	\
+		/* since this condition will never hold */		\
 		if (sizeof(rettype) > sizeof(unsigned long)) {		\
 			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
 				     post				\
-				     : "=a" (__eax), "=d" (__edx),	\
-				       "=c" (__ecx)			\
+				     : PVOP_CALL_CLOBBERS		\
 				     : paravirt_type(op),		\
 				       paravirt_clobber(CLBR_ANY),	\
 				       ##__VA_ARGS__			\
-				     : "memory", "cc");			\
+				     : "memory", "cc" EXTRA_CLOBBERS);	\
 			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
 		} else {						\
 			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
 				     post				\
-				     : "=a" (__eax), "=d" (__edx),	\
-				       "=c" (__ecx)			\
+				     : PVOP_CALL_CLOBBERS		\
 				     : paravirt_type(op),		\
 				       paravirt_clobber(CLBR_ANY),	\
 				       ##__VA_ARGS__			\
-				     : "memory", "cc");			\
+				     : "memory", "cc" EXTRA_CLOBBERS);	\
 			__ret = (rettype)__eax;				\
 		}							\
 		__ret;							\
 	})
 #define __PVOP_VCALL(op, pre, post, ...)				\
 	({								\
-		unsigned long __eax, __edx, __ecx;			\
+		PVOP_VCALL_ARGS;					\
 		asm volatile(pre					\
 			     paravirt_alt(PARAVIRT_CALL)		\
 			     post					\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : PVOP_VCALL_CLOBBERS			\
 			     : paravirt_type(op),			\
 			       paravirt_clobber(CLBR_ANY),		\
 			       ##__VA_ARGS__				\
-			     : "memory", "cc");				\
+			     : "memory", "cc" VEXTRA_CLOBBERS);		\
 	})
 
 #define PVOP_CALL0(rettype, op)						\
@@ -418,22 +447,26 @@
 	__PVOP_VCALL(op, "", "")
 
 #define PVOP_CALL1(rettype, op, arg1)					\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)))
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)))
 #define PVOP_VCALL1(op, arg1)						\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)))
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)))
 
 #define PVOP_CALL2(rettype, op, arg1, arg2)				\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)), 	\
+	"1" ((unsigned long)(arg2)))
 #define PVOP_VCALL2(op, arg1, arg2)					\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)), 		\
+	"1" ((unsigned long)(arg2)))
 
 #define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
-	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)),		\
-		    "1"((u32)(arg2)), "2"((u32)(arg3)))
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)),	\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)))
 #define PVOP_VCALL3(op, arg1, arg2, arg3)				\
-	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1"((u32)(arg2)),	\
-		     "2"((u32)(arg3)))
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)),		\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)))
 
+/* This is the only difference in x86_64. We can make it much simpler */
+#ifdef CONFIG_X86_32
 #define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
 	__PVOP_CALL(rettype, op,					\
 		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
@@ -444,6 +477,16 @@
 		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
 		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
 		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+#else
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
+	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)),	\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)),		\
+	"3"((unsigned long)(arg4)))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
+	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)),		\
+	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)),		\
+	"3"((unsigned long)(arg4)))
+#endif
 
 static inline int paravirt_enabled(void)
 {
