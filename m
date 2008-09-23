Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYIWBvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYIWBvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbYIWBvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:51:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:2700 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbYIWBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:51:08 -0400
Message-ID: <48D84B8B.4080004@ct.jp.nec.com>
Date: Mon, 22 Sep 2008 18:51:07 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH -tip 2/4] x86: uaccess: introduce __{put|get}_user_asm_eop
References: <48D84A2A.2030009@ct.jp.nec.com>
In-Reply-To: <48D84A2A.2030009@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Introduce __{put|get}_user_asm_eop which receives eop for error opecode.
Define __{put|get}_user_asm as __{put|get}_user_asm_eop with "mov".

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/asm-x86/uaccess.h |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index c098dfe..84b0600 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -186,12 +186,12 @@ extern int __get_user_bad(void);
 
 
 #ifdef CONFIG_X86_32
-#define __put_user_asm_u64(x, addr, err)					\
+#define __put_user_asm_eop_u64(x, addr, eop, err)			\
 	asm volatile("1:	movl %%eax,0(%2)\n"			\
 		     "2:	movl %%edx,4(%2)\n"			\
 		     "3:\n"						\
 		     ".section .fixup,\"ax\"\n"				\
-		     "4:	movl %3,%0\n"				\
+		     "4:	" eop " %3,%0\n"			\
 		     "	jmp 3b\n"					\
 		     ".previous\n"					\
 		     _ASM_EXTABLE(1b, 4b)				\
@@ -199,12 +199,17 @@ extern int __get_user_bad(void);
 		     : "=r" (err)					\
 		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
 
+#define __put_user_asm_u64(x, addr, err)			\
+	__put_user_asm_eop_u64(x, addr, "movl", err)
+
 #define __put_user_x8(x, ptr, __ret_pu)				\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
 #define __put_user_asm_u64(x, ptr, retval) \
 	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_asm_eop_u64(x, ptr, eop, retval) \
+	__put_user_asm_eop(x, ptr, retval, "q", "", "Zr", eop, -EFAULT)
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
 
@@ -311,9 +316,12 @@ do {									\
 
 #ifdef CONFIG_X86_32
 #define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
+#define __get_user_asm_eop_u64(x, ptr, retval, eop, errret)	(x) = __get_user_bad()
 #else
 #define __get_user_asm_u64(x, ptr, retval, errret) \
 	 __get_user_asm(x, ptr, retval, "q", "", "=r", errret)
+#define __get_user_asm_eop_u64(x, ptr, retval, eop, errret) \
+	 __get_user_asm_eop(x, ptr, retval, "q", "", "=r", eop, errret)
 #endif
 
 #define __get_user_size(x, ptr, size, retval, errret)			\
@@ -338,11 +346,11 @@ do {									\
 	}								\
 } while (0)
 
-#define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+#define __get_user_asm_eop(x, addr, err, itype, rtype, ltype, eop, errret)	\
 	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
 		     "2:\n"						\
 		     ".section .fixup,\"ax\"\n"				\
-		     "3:	mov %3,%0\n"				\
+		     "3:	" eop " %3,%0\n"			\
 		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
 		     "	jmp 2b\n"					\
 		     ".previous\n"					\
@@ -350,6 +358,9 @@ do {									\
 		     : "=r" (err), ltype(x)				\
 		     : "m" (__m(addr)), "i" (errret), "0" (err))
 
+#define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+	__get_user_asm_eop(x, addr, err, itype, rtype, ltype, "mov", errret)
+
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	long __pu_err;						\
@@ -375,16 +386,20 @@ struct __large_struct { unsigned long buf[100]; };
  * we do not write to any memory gcc knows about, so there are no
  * aliasing issues.
  */
-#define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+#define __put_user_asm_eop(x, addr, err, itype, rtype, ltype, eop, errret)	\
 	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
 		     "2:\n"						\
 		     ".section .fixup,\"ax\"\n"				\
-		     "3:	mov %3,%0\n"				\
+		     "3:	" eop " %3,%0\n"			\
 		     "	jmp 2b\n"					\
 		     ".previous\n"					\
 		     _ASM_EXTABLE(1b, 3b)				\
 		     : "=r"(err)					\
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+
+#define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+	__put_user_asm_eop(x, addr, err, itype, rtype, ltype, "mov", errret)
+
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
-- 
1.5.6

