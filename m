Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbZAFDJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbZAFDJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 22:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZAFDJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 22:09:03 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:27029 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbZAFDJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 22:09:01 -0500
Message-ID: <4962CB4B.2030804@ct.jp.nec.com>
Date: Mon, 05 Jan 2009 19:08:59 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC -tip 2/4] x86: uaccess: introduce new __{get|put}_user exception
 handling framework
References: <4962CAAE.6090300@ct.jp.nec.com>
In-Reply-To: <4962CAAE.6090300@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: introduce new uaccess exception handling framework

Introduce new uaccess exception handling framework.

__{get|put}_user_ex_try() begins exception block and
__{get|put}_user_ex_catch() ends block and if an exeption occurred in this
block using __{get|put}_user_ex, thread_info->uaccess_err is set to -EFAULT
and err is set at __{get|put}_user_ex_catch().

int func()
{
	int err = 0;

	__get_user_ex_try();

	__get_user_ex(...);
	__get_user_ex(...);
	:

	__get_user_ex_catch(&err);
	return err;
}

Note: __get_user_ex() is not clear the value when an exception occurs, it's
different from the behavior of __get_user(), but I think it doesn't matter.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/thread_info.h |    1 +
 arch/x86/include/asm/uaccess.h     |  100 ++++++++++++++++++++++++++++++++++++
 arch/x86/mm/extable.c              |    5 ++
 3 files changed, 106 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index efdf938..46beb17 100644
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
index 1a38180..d3ac43e 100644
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
@@ -385,6 +446,23 @@ struct __large_struct { unsigned long buf[100]; };
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
+#define __uaccess_ex_try()	do {					\
+	int __prev_err = current_thread_info()->uaccess_err;		\
+	current_thread_info()->uaccess_err = 0;				\
+	barrier()
+
+#define __uaccess_ex_catch(err)					\
+	(err) |= current_thread_info()->uaccess_err;			\
+	current_thread_info()->uaccess_err = __prev_err;		\
+} while (0)
+
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
@@ -408,6 +486,19 @@ struct __large_struct { unsigned long buf[100]; };
 
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+#define __get_user_ex(x, ptr)	do {					\
+	unsigned long __gue_val;					\
+	__get_user_size_ex((__gue_val), (ptr), (sizeof(*(ptr))));	\
+	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
+} while (0)
+
+#define __get_user_ex_try()	\
+	__uaccess_ex_try()
+
+#define __get_user_ex_catch(perr)	\
+	__uaccess_ex_catch(*(perr))
+
 /**
  * __put_user: - Write a simple value into user space, with less checking.
  * @x:   Value to copy to user space.
@@ -431,6 +522,15 @@ struct __large_struct { unsigned long buf[100]; };
 #define __put_user(x, ptr)						\
 	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
+#define __put_user_ex(x, ptr)						\
+	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+
+#define __put_user_ex_try() \
+	__uaccess_ex_try()
+
+#define __put_user_ex_catch(perr)	\
+	__uaccess_ex_catch(*(perr))
+
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
 
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 7e8db53..e185e03 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -23,6 +23,11 @@ int fixup_exception(struct pt_regs *regs)
 
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
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

