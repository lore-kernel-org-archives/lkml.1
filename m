Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZA1WpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZA1WpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZA1Wmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:53 -0500
Received: from gw.goop.org ([64.81.55.164]:52583 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753301AbZA1Wmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:50 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 7] x86/paravirt: implement PVOP_CALL macros for
	callee-save functions
X-Mercurial-Node: 533830e5c7542f38d6787733a9f2495f235473e1
Message-Id: <533830e5c7542f38d678.1233182106@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions with the callee save calling convention clobber many fewer
registers than the normal C calling convention.  Implement variants of
PVOP_V?CALL* accordingly.  This only bothers with functions up to 3
args, since functions with more args may as well use the normal
calling convention.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |  134 ++++++++++++++++++++++++++++-----------
 1 file changed, 99 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -510,25 +510,45 @@
  * makes sure the incoming and outgoing types are always correct.
  */
 #ifdef CONFIG_X86_32
-#define PVOP_VCALL_ARGS			unsigned long __eax, __edx, __ecx
+#define PVOP_VCALL_ARGS				\
+	unsigned long __eax = __eax, __edx = __edx, __ecx = __ecx
 #define PVOP_CALL_ARGS			PVOP_VCALL_ARGS
+
+#define PVOP_CALL_ARG1(x)		"a" ((unsigned long)(x))
+#define PVOP_CALL_ARG2(x)		"d" ((unsigned long)(x))
+#define PVOP_CALL_ARG3(x)		"c" ((unsigned long)(x))
+
 #define PVOP_VCALL_CLOBBERS		"=a" (__eax), "=d" (__edx),	\
 					"=c" (__ecx)
 #define PVOP_CALL_CLOBBERS		PVOP_VCALL_CLOBBERS
+
+#define PVOP_VCALLEE_CLOBBERS		"=a" (__eax)
+#define PVOP_CALLEE_CLOBBERS		PVOP_VCALLEE_CLOBBERS
+
 #define EXTRA_CLOBBERS
 #define VEXTRA_CLOBBERS
-#else
-#define PVOP_VCALL_ARGS		unsigned long __edi, __esi, __edx, __ecx
+#else  /* CONFIG_X86_64 */
+#define PVOP_VCALL_ARGS					\
+	unsigned long __edi = __edi, __esi = __esi,	\
+		__edx = __edx, __ecx = __ecx
 #define PVOP_CALL_ARGS		PVOP_VCALL_ARGS, __eax
+
+#define PVOP_CALL_ARG1(x)		"D" ((unsigned long)(x))
+#define PVOP_CALL_ARG2(x)		"S" ((unsigned long)(x))
+#define PVOP_CALL_ARG3(x)		"d" ((unsigned long)(x))
+#define PVOP_CALL_ARG4(x)		"c" ((unsigned long)(x))
+
 #define PVOP_VCALL_CLOBBERS	"=D" (__edi),				\
 				"=S" (__esi), "=d" (__edx),		\
 				"=c" (__ecx)
+#define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
 
-#define PVOP_CALL_CLOBBERS	PVOP_VCALL_CLOBBERS, "=a" (__eax)
+#define PVOP_VCALLEE_CLOBBERS	"=a" (__eax)
+#define PVOP_CALLEE_CLOBBERS	PVOP_VCALLEE_CLOBBERS
 
 #define EXTRA_CLOBBERS	 , "r8", "r9", "r10", "r11"
 #define VEXTRA_CLOBBERS	 , "rax", "r8", "r9", "r10", "r11"
-#endif
+#endif	/* CONFIG_X86_32 */
 
 #ifdef CONFIG_PARAVIRT_DEBUG
 #define PVOP_TEST_NULL(op)	BUG_ON(op == NULL)
@@ -536,10 +556,11 @@
 #define PVOP_TEST_NULL(op)	((void)op)
 #endif
 
-#define __PVOP_CALL(rettype, op, pre, post, ...)			\
+#define ____PVOP_CALL(rettype, op, clbr, call_clbr, extra_clbr,		\
+		      pre, post, ...)					\
 	({								\
 		rettype __ret;						\
-		PVOP_CALL_ARGS;					\
+		PVOP_CALL_ARGS;						\
 		PVOP_TEST_NULL(op);					\
 		/* This is 32-bit specific, but is okay in 64-bit */	\
 		/* since this condition will never hold */		\
@@ -547,70 +568,113 @@
 			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
 				     post				\
-				     : PVOP_CALL_CLOBBERS		\
+				     : call_clbr			\
 				     : paravirt_type(op),		\
-				       paravirt_clobber(CLBR_ANY),	\
+				       paravirt_clobber(clbr),		\
 				       ##__VA_ARGS__			\
-				     : "memory", "cc" EXTRA_CLOBBERS);	\
+				     : "memory", "cc" extra_clbr);	\
 			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
 		} else {						\
 			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
 				     post				\
-				     : PVOP_CALL_CLOBBERS		\
+				     : call_clbr			\
 				     : paravirt_type(op),		\
-				       paravirt_clobber(CLBR_ANY),	\
+				       paravirt_clobber(clbr),		\
 				       ##__VA_ARGS__			\
-				     : "memory", "cc" EXTRA_CLOBBERS);	\
+				     : "memory", "cc" extra_clbr);	\
 			__ret = (rettype)__eax;				\
 		}							\
 		__ret;							\
 	})
-#define __PVOP_VCALL(op, pre, post, ...)				\
+
+#define __PVOP_CALL(rettype, op, pre, post, ...)			\
+	____PVOP_CALL(rettype, op, CLBR_ANY, PVOP_CALL_CLOBBERS,	\
+		      EXTRA_CLOBBERS, pre, post, ##__VA_ARGS__)
+
+#define __PVOP_CALLEESAVE(rettype, op, pre, post, ...)			\
+	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+		      PVOP_CALLEE_CLOBBERS, ,				\
+		      pre, post, ##__VA_ARGS__)
+
+
+#define ____PVOP_VCALL(op, clbr, call_clbr, extra_clbr, pre, post, ...)	\
 	({								\
 		PVOP_VCALL_ARGS;					\
 		PVOP_TEST_NULL(op);					\
 		asm volatile(pre					\
 			     paravirt_alt(PARAVIRT_CALL)		\
 			     post					\
-			     : PVOP_VCALL_CLOBBERS			\
+			     : call_clbr				\
 			     : paravirt_type(op),			\
-			       paravirt_clobber(CLBR_ANY),		\
+			       paravirt_clobber(clbr),			\
 			       ##__VA_ARGS__				\
-			     : "memory", "cc" VEXTRA_CLOBBERS);		\
+			     : "memory", "cc" extra_clbr);		\
 	})
 
+#define __PVOP_VCALL(op, pre, post, ...)				\
+	____PVOP_VCALL(op, CLBR_ANY, PVOP_VCALL_CLOBBERS,		\
+		       VEXTRA_CLOBBERS,					\
+		       pre, post, ##__VA_ARGS__)
+
+#define __PVOP_VCALLEESAVE(rettype, op, pre, post, ...)			\
+	____PVOP_CALL(rettype, op.func, CLBR_RET_REG,			\
+		      PVOP_VCALLEE_CLOBBERS, ,				\
+		      pre, post, ##__VA_ARGS__)
+
+
+
 #define PVOP_CALL0(rettype, op)						\
 	__PVOP_CALL(rettype, op, "", "")
 #define PVOP_VCALL0(op)							\
 	__PVOP_VCALL(op, "", "")
 
+#define PVOP_CALLEE0(rettype, op)					\
+	__PVOP_CALLEESAVE(rettype, op, "", "")
+#define PVOP_VCALLEE0(op)						\
+	__PVOP_VCALLEESAVE(op, "", "")
+
+
 #define PVOP_CALL1(rettype, op, arg1)					\
-	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)))
+	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1))
 #define PVOP_VCALL1(op, arg1)						\
-	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)))
+	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1))
+
+#define PVOP_CALLEE1(rettype, op, arg1)					\
+	__PVOP_CALLEESAVE(rettype, op, "", "", PVOP_CALL_ARG1(arg1))
+#define PVOP_VCALLEE1(op, arg1)						\
+	__PVOP_VCALLEESAVE(op, "", "", PVOP_CALL_ARG1(arg1))
+
 
 #define PVOP_CALL2(rettype, op, arg1, arg2)				\
-	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)), 	\
-	"1" ((unsigned long)(arg2)))
+	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1),		\
+		    PVOP_CALL_ARG2(arg2))
 #define PVOP_VCALL2(op, arg1, arg2)					\
-	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)), 		\
-	"1" ((unsigned long)(arg2)))
+	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1),			\
+		     PVOP_CALL_ARG2(arg2))
+
+#define PVOP_CALLEE2(rettype, op, arg1, arg2)				\
+	__PVOP_CALLEESAVE(rettype, op, "", "", PVOP_CALL_ARG1(arg1),	\
+			  PVOP_CALL_ARG2(arg2))
+#define PVOP_VCALLEE2(op, arg1, arg2)					\
+	__PVOP_VCALLEESAVE(op, "", "", PVOP_CALL_ARG1(arg1),		\
+			   PVOP_CALL_ARG2(arg2))
+
 
 #define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
-	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)),	\
-	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)))
+	__PVOP_CALL(rettype, op, "", "", PVOP_CALL_ARG1(arg1),		\
+		    PVOP_CALL_ARG2(arg2), PVOP_CALL_ARG3(arg3))
 #define PVOP_VCALL3(op, arg1, arg2, arg3)				\
-	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)),		\
-	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)))
+	__PVOP_VCALL(op, "", "", PVOP_CALL_ARG1(arg1),			\
+		     PVOP_CALL_ARG2(arg2), PVOP_CALL_ARG3(arg3))
 
 /* This is the only difference in x86_64. We can make it much simpler */
 #ifdef CONFIG_X86_32
 #define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
 	__PVOP_CALL(rettype, op,					\
 		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
-		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
-		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+		    PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),		\
+		    PVOP_CALL_ARG3(arg3), [_arg4] "mr" ((u32)(arg4)))
 #define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
 	__PVOP_VCALL(op,						\
 		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
@@ -618,13 +682,13 @@
 		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
 #else
 #define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
-	__PVOP_CALL(rettype, op, "", "", "0" ((unsigned long)(arg1)),	\
-	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)),		\
-	"3"((unsigned long)(arg4)))
+	__PVOP_CALL(rettype, op, "", "",				\
+		    PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),		\
+		    PVOP_CALL_ARG3(arg3), PVOP_CALL_ARG4(arg4))
 #define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
-	__PVOP_VCALL(op, "", "", "0" ((unsigned long)(arg1)),		\
-	"1"((unsigned long)(arg2)), "2"((unsigned long)(arg3)),		\
-	"3"((unsigned long)(arg4)))
+	__PVOP_VCALL(op, "", "",					\
+		     PVOP_CALL_ARG1(arg1), PVOP_CALL_ARG2(arg2),	\
+		     PVOP_CALL_ARG3(arg3), PVOP_CALL_ARG4(arg4))
 #endif
 
 static inline int paravirt_enabled(void)


