Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYIYSSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYIYSSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYIYSSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:18:22 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:25308 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbYIYSSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:18:21 -0400
Message-ID: <48DBD5EB.5080904@ct.jp.nec.com>
Date: Thu, 25 Sep 2008 11:18:19 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 -tip 3/4] x86: uaccess: introduce __{put|get}_user_cerr
References: <48DBD396.5020103@ct.jp.nec.com>
In-Reply-To: <48DBD396.5020103@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Introduce __{put|get}_user_cerr for cumulative error handling.
The following 2 lines are same.
  __{put|get}_user_cerr(x, ptr, &err);
  err |= __{put|get}_user(x, ptr);

Introduce __{put|get}_user_size_cerr for internal use from __{put|get}_user_cerr.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/asm-x86/uaccess.h |   74 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 84b0600..284c7d3 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -291,6 +291,31 @@ do {									\
 	}								\
 } while (0)
 
+#define __put_user_size_cerr(x, ptr, size, retval, errret)		\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__put_user_asm_eop(x, ptr, retval, "b", "b", "iq",	\
+							"or", errret);	\
+		break;							\
+	case 2:								\
+		__put_user_asm_eop(x, ptr, retval, "w", "w", "ir",	\
+							"or", errret);	\
+		break;							\
+	case 4:								\
+		__put_user_asm_eop(x, ptr, retval, "l", "k",  "ir",	\
+							"or", errret);	\
+		break;							\
+	case 8:								\
+		__put_user_asm_eop_u64((__typeof__(*ptr))(x), ptr,	\
+							"or", retval);	\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
 #else
 
 #define __put_user_size(x, ptr, size, retval, errret)			\
@@ -302,6 +327,14 @@ do {									\
 		retval = errret;					\
 } while (0)
 
+#define __put_user_size_cerr(x, ptr, size, retval, errret)		\
+do {									\
+	__typeof__(*(ptr))__pus_tmp = x;				\
+									\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
+		retval |= errret;					\
+} while (0)
+
 #define put_user(x, ptr)					\
 ({								\
 	int __ret_pu;						\
@@ -346,6 +379,30 @@ do {									\
 	}								\
 } while (0)
 
+#define __get_user_size_cerr(x, ptr, size, retval, errret)		\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm_eop(x, ptr, retval, "b", "b", "=q",	\
+							"or", errret);	\
+		break;							\
+	case 2:								\
+		__get_user_asm_eop(x, ptr, retval, "w", "w", "=r",	\
+							"or", errret);	\
+		break;							\
+	case 4:								\
+		__get_user_asm_eop(x, ptr, retval, "l", "k", "=r",	\
+							"or", errret);	\
+		break;							\
+	case 8:								\
+		__get_user_asm_eop_u64(x, ptr, retval, "or", errret);	\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
+	}								\
+} while (0)
+
 #define __get_user_asm_eop(x, addr, err, itype, rtype, ltype, eop, errret)	\
 	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
 		     "2:\n"						\
@@ -368,6 +425,11 @@ do {									\
 	__pu_err;						\
 })
 
+#define __put_user_nocheck_cerr(x, ptr, size, err)			\
+do {									\
+	__put_user_size_cerr((x), (ptr), (size), *(err), -EFAULT);	\
+} while (0)
+
 #define __get_user_nocheck(x, ptr, size)				\
 ({									\
 	long __gu_err;							\
@@ -377,6 +439,13 @@ do {									\
 	__gu_err;							\
 })
 
+#define __get_user_nocheck_cerr(x, ptr, size, err)			\
+do {									\
+	unsigned long __gu_val;						\
+	__get_user_size_cerr(__gu_val, (ptr), (size), *(err), -EFAULT);	\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+} while (0)
+
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct __user *)(x))
@@ -423,6 +492,8 @@ struct __large_struct { unsigned long buf[100]; };
 
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+#define __get_user_cerr(x, ptr, perr)					\
+	__get_user_nocheck_cerr((x), (ptr), sizeof(*(ptr)), (perr))
 /**
  * __put_user: - Write a simple value into user space, with less checking.
  * @x:   Value to copy to user space.
@@ -445,6 +516,9 @@ struct __large_struct { unsigned long buf[100]; };
 
 #define __put_user(x, ptr)						\
 	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+#define __put_user_cerr(x, ptr, perr)					\
+	__put_user_nocheck_cerr((__typeof__(*(ptr)))(x), (ptr),		\
+				sizeof(*(ptr)), (perr))
 
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
-- 
1.5.6

