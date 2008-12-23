Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYLWFXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYLWFXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 00:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLWFW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 00:22:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:52092 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbYLWFW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 00:22:58 -0500
Message-ID: <495075B0.9020104@ct.jp.nec.com>
Date: Mon, 22 Dec 2008 21:22:56 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC -tip 2/4] x86: uaccess: introduce __{get|put}_user exception
 handling framework
References: <49507534.5080401@ct.jp.nec.com>
In-Reply-To: <49507534.5080401@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: introduce new framework

Introduce exception handling framework.
__{get|put}_user_ex_try() begins exception block and
__{get|put}_user_ex_catch() ends block and if an exception occurred in this
block using __{get|put}_user_ex, direct jump to __{get|put}_user_ex_catch()
and err is set to specified value.

int func()
{
	int err = 0;

	__get_user_ex_try(&err, -EFAULT);

	__get_user_ex(...);
	__get_user_ex(...);
	:

	__get_user_ex_catch();
	return err;
}

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |  110 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 1a38180..cf293fe 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -199,12 +199,21 @@ extern int __get_user_bad(void);
 		     : "=r" (err)					\
 		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
 
+#define __put_user_asm_ex_u64(x, addr, label)				\
+	asm volatile("1:	movl %%eax,0(%1)\n"			\
+		     "2:	movl %%edx,4(%1)\n"			\
+		     _ASM_EXTABLE(1b, label)				\
+		     _ASM_EXTABLE(2b, label)				\
+		     : : "A" (x), "r" (addr))
+
 #define __put_user_x8(x, ptr, __ret_pu)				\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
 #define __put_user_asm_u64(x, ptr, retval) \
 	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_asm_ex_u64(x, addr, label)	\
+	__put_user_asm_ex(x, addr, "q", "", "Zr", label)
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
 
@@ -286,6 +295,27 @@ do {									\
 	}								\
 } while (0)
 
+#define __put_user_size_ex(x, ptr, size, label)			\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__put_user_asm_ex(x, ptr, "b", "b", "iq", label);	\
+		break;							\
+	case 2:								\
+		__put_user_asm_ex(x, ptr, "w", "w", "ir", label);	\
+		break;							\
+	case 4:								\
+		__put_user_asm_ex(x, ptr, "l", "k",  "ir", label);	\
+		break;							\
+	case 8:								\
+		__put_user_asm_ex_u64((__typeof__(*ptr))(x), ptr, label);\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
 #else
 
 #define __put_user_size(x, ptr, size, retval, errret)			\
@@ -311,9 +341,12 @@ do {									\
 
 #ifdef CONFIG_X86_32
 #define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
+#define __get_user_asm_ex_u64(x, ptr, label)		(x) = __get_user_bad()
 #else
 #define __get_user_asm_u64(x, ptr, retval, errret) \
 	 __get_user_asm(x, ptr, retval, "q", "", "=r", errret)
+#define __get_user_asm_ex_u64(x, ptr, label) \
+	 __get_user_asm_ex(x, ptr, "q", "", "=r", label)
 #endif
 
 #define __get_user_size(x, ptr, size, retval, errret)			\
@@ -350,6 +383,36 @@ do {									\
 		     : "=r" (err), ltype(x)				\
 		     : "m" (__m(addr)), "i" (errret), "0" (err))
 
+#define __get_user_size_ex(x, ptr, size, label)				\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm_ex(x, ptr, "b", "b", "=q", label);	\
+		break;							\
+	case 2:								\
+		__get_user_asm_ex(x, ptr, "w", "w", "=r", label);	\
+		break;							\
+	case 4:								\
+		__get_user_asm_ex(x, ptr, "l", "k", "=r", label);	\
+		break;							\
+	case 8:								\
+		__get_user_asm_ex_u64(x, ptr, label);			\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
+	}								\
+} while (0)
+
+#define __get_user_asm_ex(x, addr, itype, rtype, ltype, label)		\
+	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
+		     ".section .fixup,\"ax\"\n"				\
+		     "2:	xor"itype" %"rtype"0,%"rtype"0\n"	\
+		     "	jmp " #label "\n"				\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 2b)				\
+		     : ltype(x) : "m" (__m(addr)))
+
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	int __pu_err;						\
@@ -366,6 +429,16 @@ do {									\
 	__gu_err;							\
 })
 
+#define __put_user_ex_label(x, ptr, size, label) do {			\
+	__put_user_size_ex((x), (ptr), (size), label);			\
+} while (0)
+
+#define __get_user_ex_label(x, ptr, size, label) do {			\
+	unsigned long __gue_val;					\
+	__get_user_size_ex((__gue_val), (ptr), (size), label);		\
+	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
+} while (0)
+
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct __user *)(x))
@@ -385,6 +458,23 @@ struct __large_struct { unsigned long buf[100]; };
 		     _ASM_EXTABLE(1b, 3b)				\
 		     : "=r"(err)					\
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+
+#define __put_user_asm_ex(x, addr, itype, rtype, ltype, label)		\
+	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
+		     _ASM_EXTABLE(1b, label)				\
+		     : : ltype(x), "m" (__m(addr)))
+
+#define __ex_try_label(err, errval, label, out_label) do {	\
+	asm volatile(".section .fixup,\"ax\"\n"			\
+		     #label ":	mov %1,%0\n"			\
+		     "	jmp " #out_label "\n"			\
+		     ".previous\n"				\
+		     : "=r" (err) : "i" (errval), "0" (err))
+
+#define __ex_catch_label(label)		\
+	asm volatile(#label ":\n");	\
+} while (0)
+
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
@@ -408,6 +498,16 @@ struct __large_struct { unsigned long buf[100]; };
 
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+#define __get_user_ex(x, ptr)						\
+	__get_user_ex_label((x), (ptr), sizeof(*(ptr)), 880b)
+
+#define __get_user_ex_try(perr, errval)	\
+	__ex_try_label((*(perr)), (errval), 880, 881f)
+
+#define __get_user_ex_catch()	\
+	__ex_catch_label(881)
+
 /**
  * __put_user: - Write a simple value into user space, with less checking.
  * @x:   Value to copy to user space.
@@ -431,6 +531,16 @@ struct __large_struct { unsigned long buf[100]; };
 #define __put_user(x, ptr)						\
 	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
+#define __put_user_ex(x, ptr)						\
+	__put_user_ex_label((__typeof__(*(ptr)))(x), (ptr),		\
+			   sizeof(*(ptr)), 882b)
+
+#define __put_user_ex_try(perr, errval) \
+	__ex_try_label((*(perr)), (errval), 882, 883f)
+
+#define __put_user_ex_catch()	\
+	__ex_catch_label(883)
+
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
 
-- 
1.6.0.4

