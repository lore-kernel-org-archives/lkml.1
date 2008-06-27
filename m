Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbYF0Vud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbYF0Vud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764393AbYF0Vig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764283AbYF0Vid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:33 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 33/39] merge __get_user_asm and its users.
Date: Fri, 27 Jun 2008 18:34:40 -0300
Message-Id: <1214602486-17080-34-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-33-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
 <1214602486-17080-4-git-send-email-gcosta@redhat.com>
 <1214602486-17080-5-git-send-email-gcosta@redhat.com>
 <1214602486-17080-6-git-send-email-gcosta@redhat.com>
 <1214602486-17080-7-git-send-email-gcosta@redhat.com>
 <1214602486-17080-8-git-send-email-gcosta@redhat.com>
 <1214602486-17080-9-git-send-email-gcosta@redhat.com>
 <1214602486-17080-10-git-send-email-gcosta@redhat.com>
 <1214602486-17080-11-git-send-email-gcosta@redhat.com>
 <1214602486-17080-12-git-send-email-gcosta@redhat.com>
 <1214602486-17080-13-git-send-email-gcosta@redhat.com>
 <1214602486-17080-14-git-send-email-gcosta@redhat.com>
 <1214602486-17080-15-git-send-email-gcosta@redhat.com>
 <1214602486-17080-16-git-send-email-gcosta@redhat.com>
 <1214602486-17080-17-git-send-email-gcosta@redhat.com>
 <1214602486-17080-18-git-send-email-gcosta@redhat.com>
 <1214602486-17080-19-git-send-email-gcosta@redhat.com>
 <1214602486-17080-20-git-send-email-gcosta@redhat.com>
 <1214602486-17080-21-git-send-email-gcosta@redhat.com>
 <1214602486-17080-22-git-send-email-gcosta@redhat.com>
 <1214602486-17080-23-git-send-email-gcosta@redhat.com>
 <1214602486-17080-24-git-send-email-gcosta@redhat.com>
 <1214602486-17080-25-git-send-email-gcosta@redhat.com>
 <1214602486-17080-26-git-send-email-gcosta@redhat.com>
 <1214602486-17080-27-git-send-email-gcosta@redhat.com>
 <1214602486-17080-28-git-send-email-gcosta@redhat.com>
 <1214602486-17080-29-git-send-email-gcosta@redhat.com>
 <1214602486-17080-30-git-send-email-gcosta@redhat.com>
 <1214602486-17080-31-git-send-email-gcosta@redhat.com>
 <1214602486-17080-32-git-send-email-gcosta@redhat.com>
 <1214602486-17080-33-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move __get_user_asm and __get_user_size and __get_user_nocheck
to uaccess.h. This requires us to define a macro at __get_user_size
for the 64-bit access case.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |   50 +++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/uaccess_32.h |   41 ----------------------------------
 include/asm-x86/uaccess_64.h |   43 ------------------------------------
 3 files changed, 49 insertions(+), 85 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 8479be3..4ff31c5 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -234,6 +234,47 @@ do {									\
 
 #endif
 
+#ifdef CONFIG_X86_32
+#define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
+#else
+#define __get_user_asm_u64(x, ptr, retval, errret) \
+	 __get_user_asm(x, ptr, retval, "q", "", "=r", errret)
+#endif
+
+#define __get_user_size(x, ptr, size, retval, errret)			\
+do {									\
+	retval = 0;							\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);	\
+		break;							\
+	case 2:								\
+		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);	\
+		break;							\
+	case 4:								\
+		__get_user_asm(x, ptr, retval, "l", "k", "=r", errret);	\
+		break;							\
+	case 8:								\
+		__get_user_asm_u64(x, ptr, retval, errret);		\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
+	}								\
+} while (0)
+
+#define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	mov %3,%0\n"				\
+		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r" (err), ltype(x)				\
+		     : "m" (__m(addr)), "i" (errret), "0" (err))
+
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	long __pu_err;						\
@@ -241,7 +282,14 @@ do {									\
 	__pu_err;						\
 })
 
-
+#define __get_user_nocheck(x, ptr, size)				\
+({									\
+	long __gu_err;							\
+	unsigned long __gu_val;						\
+	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
+	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
+	__gu_err;							\
+})
 
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index fab7557..ebfe6b2 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -145,47 +145,6 @@ extern void __put_user_8(void);
 #define __put_user(x, ptr)						\
 	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-#define __get_user_nocheck(x, ptr, size)				\
-({									\
-	long __gu_err;							\
-	unsigned long __gu_val;						\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
-	(x) = (__typeof__(*(ptr)))__gu_val;				\
-	__gu_err;							\
-})
-
-#define __get_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);	\
-		break;							\
-	case 2:								\
-		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);	\
-		break;							\
-	case 4:								\
-		__get_user_asm(x, ptr, retval, "l", "", "=r", errret);	\
-		break;							\
-	default:							\
-		(x) = __get_user_bad();					\
-	}								\
-} while (0)
-
-#define __get_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
-		     "2:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "3:	movl %3,%0\n"				\
-		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r" (err), ltype (x)				\
-		     : "m" (__m(addr)), "i" (errret), "0" (err))
-
-
 unsigned long __must_check __copy_to_user_ll
 		(void __user *to, const void *from, unsigned long n);
 unsigned long __must_check __copy_from_user_ll
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index e0875d7..42a9769 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -57,49 +57,6 @@ extern void __put_user_bad(void);
 	__pu_err;						\
 })
 
-#define __get_user_nocheck(x, ptr, size)			\
-({								\
-	int __gu_err;						\
-	unsigned long __gu_val;					\
-	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);\
-	(x) = (__force typeof(*(ptr)))__gu_val;			\
-	__gu_err;						\
-})
-
-#define __get_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__get_user_asm(x, ptr, retval, "b", "b", "=q", errret);\
-		break;							\
-	case 2:								\
-		__get_user_asm(x, ptr, retval, "w", "w", "=r", errret);\
-		break;							\
-	case 4:								\
-		__get_user_asm(x, ptr, retval, "l", "k", "=r", errret);\
-		break;							\
-	case 8:								\
-		__get_user_asm(x, ptr, retval, "q", "", "=r", errret);	\
-		break;							\
-	default:							\
-		(x) = __get_user_bad();					\
-	}								\
-} while (0)
-
-#define __get_user_asm(x, addr, err, itype, rtype, ltype, errno)	\
-	asm volatile("1:	mov"itype" %2,%"rtype"1\n"		\
-		     "2:\n"						\
-		     ".section .fixup, \"ax\"\n"			\
-		     "3:	mov %3,%0\n"				\
-		     "	xor"itype" %"rtype"1,%"rtype"1\n"		\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r" (err), ltype (x)				\
-		     : "m" (__m(addr)), "i"(errno), "0"(err))
-
 /*
  * Copy To/From Userspace
  */
-- 
1.5.5.1

