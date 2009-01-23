Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbZAWXtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbZAWXtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbZAWXtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:49:43 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:13929 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbZAWXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:49:42 -0500
Message-ID: <497A5795.7020609@ct.jp.nec.com>
Date: Fri, 23 Jan 2009 15:49:41 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC v2 -tip 1/3] x86: uaccess: introduce try and catch framework
References: <4962CAAE.6090300@ct.jp.nec.com> <496476D0.5040607@zytor.com> <497A5737.8030408@ct.jp.nec.com>
In-Reply-To: <497A5737.8030408@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: introduce new uaccess exception handling framework

Introduce {get|put}_user_try and {get|put}_user_catch as new uaccess exception
handling framework.
{get|put}_user_try begins exception block and {get|put}_user_catch(err) ends
the block and gets err if an exception occured in {get|put}_user_ex() in the
block. The exception is stored thread_info->uaccess_err.

The example usage of this framework is below;
int func()
{
	int err = 0;

	get_user_try {
		get_user_ex(...);
		get_user_ex(...);
		:
	} get_user_catch(err);

	return err;
}

Note: get_user_ex() is not clear the value when an exception occurs, it's
different from the behavior of __get_user(), but I think it doesn't matter.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/thread_info.h |    1 +
 arch/x86/include/asm/uaccess.h     |  103 ++++++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c              |    6 ++
 3 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f384889..ca7310e 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,6 +40,7 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
+	int			uaccess_err;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 69d2757..0ec6de4 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -199,12 +199,22 @@ extern int __get_user_bad(void);
 		     : "=r" (err)					\
 		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
 
+#define __put_user_asm_ex_u64(x, addr)					\
+	asm volatile("1:	movl %%eax,0(%1)\n"			\
+		     "2:	movl %%edx,4(%1)\n"			\
+		     "3:\n"						\
+		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     _ASM_EXTABLE(2b, 3b - 2b)				\
+		     : : "A" (x), "r" (addr))
+
 #define __put_user_x8(x, ptr, __ret_pu)				\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
 #define __put_user_asm_u64(x, ptr, retval) \
 	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_asm_ex_u64(x, addr)	\
+	__put_user_asm_ex(x, addr, "q", "", "Zr")
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
 
@@ -286,6 +296,27 @@ do {									\
 	}								\
 } while (0)
 
+#define __put_user_size_ex(x, ptr, size)				\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__put_user_asm_ex(x, ptr, "b", "b", "iq");		\
+		break;							\
+	case 2:								\
+		__put_user_asm_ex(x, ptr, "w", "w", "ir");		\
+		break;							\
+	case 4:								\
+		__put_user_asm_ex(x, ptr, "l", "k", "ir");		\
+		break;							\
+	case 8:								\
+		__put_user_asm_ex_u64((__typeof__(*ptr))(x), ptr);	\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
 #else
 
 #define __put_user_size(x, ptr, size, retval, errret)			\
@@ -311,9 +342,12 @@ do {									\
 
 #ifdef CONFIG_X86_32
 #define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
+#define __get_user_asm_ex_u64(x, ptr)			(x) = __get_user_bad()
 #else
 #define __get_user_asm_u64(x, ptr, retval, errret) \
 	 __get_user_asm(x, ptr, retval, "q", "", "=r", errret)
+#define __get_user_asm_ex_u64(x, ptr) \
+	 __get_user_asm_ex(x, ptr, "q", "", "=r")
 #endif
 
 #define __get_user_size(x, ptr, size, retval, errret)			\
@@ -350,6 +384,33 @@ do {									\
 		     : "=r" (err), ltype(x)				\
 		     : "m" (__m(addr)), "i" (errret), "0" (err))
 
+#define __get_user_size_ex(x, ptr, size)				\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm_ex(x, ptr, "b", "b", "=q");		\
+		break;							\
+	case 2:								\
+		__get_user_asm_ex(x, ptr, "w", "w", "=r");		\
+		break;							\
+	case 4:								\
+		__get_user_asm_ex(x, ptr, "l", "k", "=r");		\
+		break;							\
+	case 8:								\
+		__get_user_asm_ex_u64(x, ptr);				\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
+	}								\
+} while (0)
+
+#define __get_user_asm_ex(x, addr, itype, rtype, ltype)			\
+	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
+		     "2:\n"						\
+		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     : ltype(x) : "m" (__m(addr)))
+
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	int __pu_err;						\
@@ -385,6 +446,26 @@ struct __large_struct { unsigned long buf[100]; };
 		     _ASM_EXTABLE(1b, 3b)				\
 		     : "=r"(err)					\
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+
+#define __put_user_asm_ex(x, addr, itype, rtype, ltype)			\
+	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
+		     "2:\n"						\
+		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     : : ltype(x), "m" (__m(addr)))
+
+/*
+ * uaccess_try and catch
+ */
+#define uaccess_try	do {						\
+	int prev_err = current_thread_info()->uaccess_err;		\
+	current_thread_info()->uaccess_err = 0;				\
+	barrier();
+
+#define uaccess_catch(err)						\
+	(err) |= current_thread_info()->uaccess_err;			\
+	current_thread_info()->uaccess_err = prev_err;			\
+} while (0)
+
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
@@ -408,6 +489,7 @@ struct __large_struct { unsigned long buf[100]; };
 
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
 /**
  * __put_user: - Write a simple value into user space, with less checking.
  * @x:   Value to copy to user space.
@@ -435,6 +517,27 @@ struct __large_struct { unsigned long buf[100]; };
 #define __put_user_unaligned __put_user
 
 /*
+ * {get|put}_user_try and catch
+ *
+ * get_user_try {
+ *	get_user_ex(...);
+ * } get_user_catch(err)
+ */
+#define get_user_try		uaccess_try
+#define get_user_catch(err)	uaccess_catch(err)
+#define put_user_try		uaccess_try
+#define put_user_catch(err)	uaccess_catch(err)
+
+#define get_user_ex(x, ptr)	do {					\
+	unsigned long __gue_val;					\
+	__get_user_size_ex((__gue_val), (ptr), (sizeof(*(ptr))));	\
+	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
+} while (0)
+
+#define put_user_ex(x, ptr)						\
+	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+
+/*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
 #ifdef CONFIG_X86_INTEL_USERCOPY
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 7e8db53..61b41ca 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -23,6 +23,12 @@ int fixup_exception(struct pt_regs *regs)
 
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
+		/* If fixup is less than 16, it means uaccess error */
+		if (fixup->fixup < 16) {
+			current_thread_info()->uaccess_err = -EFAULT;
+			regs->ip += fixup->fixup;
+			return 1;
+		}
 		regs->ip = fixup->fixup;
 		return 1;
 	}
-- 
1.6.0.4

