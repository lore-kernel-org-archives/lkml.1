Return-Path: <linux-kernel-owner+w=401wt.eu-S1752590AbXDHGmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbXDHGmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 02:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXDHGmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 02:42:13 -0400
Received: from gw.goop.org ([64.81.55.164]:43085 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXDHGmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 02:42:12 -0400
Message-ID: <46188E8B.8020405@goop.org>
Date: Sat, 07 Apr 2007 23:41:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: [PATCH] paravirt_ops: Clean up paravirt patchable wrappers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all the open-coded macros for generating calls with a pair of
more general macros (__PVOP_CALL/VCALL), and redefine all the
PVOP_V?CALL[0-4] in terms of them.

[ Andrew, Andi: this should slot in immediately after "Document asm-i386/paravirt.h"
  (paravirt_ops-document-asm-i386-paravirth.patch) ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 include/asm-i386/paravirt.h |  252 ++++++++++---------------------------------
 1 file changed, 62 insertions(+), 190 deletions(-)

===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -332,210 +332,80 @@ unsigned paravirt_patch_insns(void *site
  * means that all uses must be wrapped in inline functions.  This also
  * makes sure the incoming and outgoing types are always correct.
  */
-#define PVOP_CALL0(__rettype, __op)					\
+#define __PVOP_CALL(rettype, op, pre, post, ...)			\
 	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
+		rettype __ret;						\
+		unsigned long __eax, __edx, __ecx;			\
+		if (sizeof(rettype) > sizeof(unsigned long)) {		\
+			asm volatile(pre				\
+				     paravirt_alt(PARAVIRT_CALL)	\
+				     post				\
+				     : "=a" (__eax), "=d" (__edx),	\
+				       "=c" (__ecx)			\
+				     : paravirt_type(op),		\
+				       paravirt_clobber(CLBR_ANY),	\
+				       ##__VA_ARGS__			\
 				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
+			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
 		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
+			asm volatile(pre				\
+				     paravirt_alt(PARAVIRT_CALL)	\
+				     post				\
+				     : "=a" (__eax), "=d" (__edx),	\
 				       "=c" (__ecx)			\
-				     : paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
+				     : paravirt_type(op),		\
+				       paravirt_clobber(CLBR_ANY),	\
+				       ##__VA_ARGS__			\
 				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
+			__ret = (rettype)__eax;				\
 		}							\
 		__ret;							\
 	})
-#define PVOP_VCALL0(__op)						\
+#define __PVOP_VCALL(op, pre, post, ...)				\
 	({								\
 		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
+		asm volatile(pre					\
+			     paravirt_alt(PARAVIRT_CALL)		\
+			     post					\
 			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
+			     : paravirt_type(op),			\
+			       paravirt_clobber(CLBR_ANY),		\
+			       ##__VA_ARGS__				\
 			     : "memory", "cc");				\
 	})
 
-#define PVOP_CALL1(__rettype, __op, arg1)				\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : "0" ((u32)(arg1)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL1(__op, arg1)						\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL2(__rettype, __op, arg1, arg2)				\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       "d" ((u32)(arg2)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : "0" ((u32)(arg1)),		\
-				       "1" ((u32)(arg2)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL2(__op, arg1, arg2)					\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       "1" ((u32)(arg2)),			\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL3(__rettype, __op, arg1, arg2, arg3)			\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       "d" ((u32)(arg2)),		\
-				       "1" ((u32)(arg3)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;	\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : "0" ((u32)(arg1)),		\
-				       "1" ((u32)(arg2)),		\
-				       "2" ((u32)(arg3)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL3(__op, arg1, arg2, arg3)				\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       "1" ((u32)(arg2)),			\
-			       "2" ((u32)(arg3)),			\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL4(__rettype, __op, arg1, arg2, arg3, arg4)		\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile("push %[_arg4]; "			\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     "lea 4(%%esp),%%esp"		\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       "d" ((u32)(arg2)),		\
-				       "1" ((u32)(arg3)),		\
-				       [_arg4] "mr" ((u32)(arg4)),	\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc",);		\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile("push %[_arg4]; "			\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     "lea 4(%%esp),%%esp"		\
-				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
-				     : "0" ((u32)(arg1)),		\
-				       "1" ((u32)(arg2)),		\
-				       "2" ((u32)(arg3)),		\
-				       [_arg4]"mr" ((u32)(arg4)),	\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL4(__op, arg1, arg2, arg3, arg4)			\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile("push %[_arg4]; "				\
-			     paravirt_alt(PARAVIRT_CALL)		\
-			     "lea 4(%%esp),%%esp"			\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       "1" ((u32)(arg2)),			\
-			       "2" ((u32)(arg3)),			\
-			       [_arg4]"mr" ((u32)(arg4)),		\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
+#define PVOP_CALL0(rettype, op)						\
+	__PVOP_CALL(rettype, op, "", "")
+#define PVOP_VCALL0(op)							\
+	__PVOP_VCALL(op, "", "")
+
+#define PVOP_CALL1(rettype, op, arg1)					\
+	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)))
+#define PVOP_VCALL1(op, arg1)						\
+	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)))
+
+#define PVOP_CALL2(rettype, op, arg1, arg2)				\
+	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+#define PVOP_VCALL2(op, arg1, arg2)					\
+	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+
+#define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
+	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)),		\
+		    "1"((u32)(arg2)), "2"((u32)(arg3)))
+#define PVOP_VCALL3(op, arg1, arg2, arg3)				\
+	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1"((u32)(arg2)),	\
+		     "2"((u32)(arg3)))
+
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
+	__PVOP_CALL(rettype, op,					\
+		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
+		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
+		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
+	__PVOP_VCALL(op,						\
+		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
+		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
+		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
 
 static inline int paravirt_enabled(void)
 {
@@ -1164,6 +1034,8 @@ static inline unsigned long __raw_local_
 
 /* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
+#undef __PVOP_CALL
+#undef __PVOP_VCALL
 #undef PVOP_VCALL0
 #undef PVOP_CALL0
 #undef PVOP_VCALL1

