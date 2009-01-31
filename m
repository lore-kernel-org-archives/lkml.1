Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbZAaCQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbZAaCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZAaCQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:16:50 -0500
Received: from homer.mvista.com ([63.81.120.158]:57484 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZAaCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:16:50 -0500
Message-ID: <4983B48E.3070605@ct.jp.nec.com>
Date: Fri, 30 Jan 2009 18:16:46 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: uaccess: use errret as error value in __put_user_size()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

In __put_user_size() macro errret is used for error value.
But if size is 8, errret isn't passed to__put_user_asm_u64().
This behavior is inconsistent.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/uaccess.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index b9a2415..b685ece 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -186,7 +186,7 @@ extern int __get_user_bad(void);
 
 
 #ifdef CONFIG_X86_32
-#define __put_user_asm_u64(x, addr, err)				\
+#define __put_user_asm_u64(x, addr, err, errret)			\
 	asm volatile("1:	movl %%eax,0(%2)\n"			\
 		     "2:	movl %%edx,4(%2)\n"			\
 		     "3:\n"						\
@@ -197,7 +197,7 @@ extern int __get_user_bad(void);
 		     _ASM_EXTABLE(1b, 4b)				\
 		     _ASM_EXTABLE(2b, 4b)				\
 		     : "=r" (err)					\
-		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
+		     : "A" (x), "r" (addr), "i" (errret), "0" (err))
 
 #define __put_user_asm_ex_u64(x, addr)					\
 	asm volatile("1:	movl %%eax,0(%1)\n"			\
@@ -211,8 +211,8 @@ extern int __get_user_bad(void);
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
-#define __put_user_asm_u64(x, ptr, retval) \
-	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_asm_u64(x, ptr, retval, errret) \
+	__put_user_asm(x, ptr, retval, "q", "", "Zr", errret)
 #define __put_user_asm_ex_u64(x, addr)	\
 	__put_user_asm_ex(x, addr, "q", "", "Zr")
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
@@ -289,7 +289,8 @@ do {									\
 		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);	\
 		break;							\
 	case 8:								\
-		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval,	\
+				   errret);				\
 		break;							\
 	default:							\
 		__put_user_bad();					\
-- 
1.6.0.4

