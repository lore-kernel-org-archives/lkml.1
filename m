Return-Path: <linux-kernel-owner+w=401wt.eu-S1765487AbYF0Vte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487AbYF0Vte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764271AbYF0Vi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763798AbYF0Vi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:26 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 31/39] merge __put_user_asm and its user.
Date: Fri, 27 Jun 2008 18:34:38 -0300
Message-Id: <1214602486-17080-32-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-31-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move both __put_user_asm and __put_user_size to
uaccess.h. i386 already had a special function for 64-bit access,
so for x86_64, we just define a macro with the same name.
Note that for X86_64, CONFIG_X86_WP_WORKS_OK will always
be defined, so the #else part will never be even compiled in.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |   84 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uaccess_32.h |   77 --------------------------------------
 include/asm-x86/uaccess_64.h |   51 -------------------------
 3 files changed, 84 insertions(+), 128 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 3721513..8479be3 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -179,6 +179,90 @@ extern int __get_user_bad(void);
 	__ret_gu;							\
 })
 
+#ifdef CONFIG_X86_32
+#define __put_user_u64(x, addr, err)					\
+	asm volatile("1:	movl %%eax,0(%2)\n"			\
+		     "2:	movl %%edx,4(%2)\n"			\
+		     "3:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "4:	movl %3,%0\n"				\
+		     "	jmp 3b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 4b)				\
+		     _ASM_EXTABLE(2b, 4b)				\
+		     : "=r" (err)					\
+		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
+#else
+#define __put_user_u64(x, ptr, retval) \
+	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#endif
+
+#ifdef CONFIG_X86_WP_WORKS_OK
+
+#define __put_user_size(x, ptr, size, retval, errret)			\
+do {									\
+	retval = 0;							\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);	\
+		break;							\
+	case 2:								\
+		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
+		break;							\
+	case 4:								\
+		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
+		break;							\
+	case 8:								\
+		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
+#else
+
+#define __put_user_size(x, ptr, size, retval, errret)			\
+do {									\
+	__typeof__(*(ptr))__pus_tmp = x;				\
+	retval = 0;							\
+									\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
+		retval = errret;					\
+} while (0)
+
+#endif
+
+#define __put_user_nocheck(x, ptr, size)			\
+({								\
+	long __pu_err;						\
+	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
+	__pu_err;						\
+})
+
+
+
+/* FIXME: this hack is definitely wrong -AK */
+struct __large_struct { unsigned long buf[100]; };
+#define __m(x) (*(struct __large_struct __user *)(x))
+
+/*
+ * Tell gcc we read from memory instead of writing: this is because
+ * we do not write to any memory gcc knows about, so there are no
+ * aliasing issues.
+ */
+#define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
+	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
+		     "2:\n"						\
+		     ".section .fixup,\"ax\"\n"				\
+		     "3:	mov %3,%0\n"				\
+		     "	jmp 2b\n"					\
+		     ".previous\n"					\
+		     _ASM_EXTABLE(1b, 3b)				\
+		     : "=r"(err)					\
+		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+
 
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 4c47a5b..fab7557 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -145,83 +145,6 @@ extern void __put_user_8(void);
 #define __put_user(x, ptr)						\
 	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
-#define __put_user_nocheck(x, ptr, size)			\
-({								\
-	long __pu_err;						\
-	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
-	__pu_err;						\
-})
-
-
-#define __put_user_u64(x, addr, err)					\
-	asm volatile("1:	movl %%eax,0(%2)\n"			\
-		     "2:	movl %%edx,4(%2)\n"			\
-		     "3:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "4:	movl %3,%0\n"				\
-		     "	jmp 3b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 4b)				\
-		     _ASM_EXTABLE(2b, 4b)				\
-		     : "=r" (err)					\
-		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
-
-#ifdef CONFIG_X86_WP_WORKS_OK
-
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);	\
-		break;							\
-	case 2:								\
-		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
-		break;							\
-	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
-		break;							\
-	case 8:								\
-		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
-		break;							\
-	default:							\
-		__put_user_bad();					\
-	}								\
-} while (0)
-
-#else
-
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	__typeof__(*(ptr))__pus_tmp = x;				\
-	retval = 0;							\
-									\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp, size) != 0))	\
-		retval = errret;					\
-} while (0)
-
-#endif
-struct __large_struct { unsigned long buf[100]; };
-#define __m(x) (*(struct __large_struct __user *)(x))
-
-/*
- * Tell gcc we read from memory instead of writing: this is because
- * we do not write to any memory gcc knows about, so there are no
- * aliasing issues.
- */
-#define __put_user_asm(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
-		     "2:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "3:	movl %3,%0\n"				\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r"(err)					\
-		     : ltype (x), "m" (__m(addr)), "i" (errret), "0" (err))
-
-
 #define __get_user_nocheck(x, ptr, size)				\
 ({									\
 	long __gu_err;							\
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 6532d63..42c01aa 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -34,14 +34,6 @@ extern void __put_user_bad(void);
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
 
-#define __put_user_nocheck(x, ptr, size)		\
-({							\
-	int __pu_err;					\
-	__put_user_size((x), (ptr), (size), __pu_err, -EFAULT);	\
-	__pu_err;					\
-})
-
-
 #define __put_user_check(x, ptr, size)				\
 ({								\
 	int __pu_err;						\
@@ -65,49 +57,6 @@ extern void __put_user_bad(void);
 	__pu_err;						\
 })
 
-#define __put_user_size(x, ptr, size, retval, errret)			\
-do {									\
-	retval = 0;							\
-	__chk_user_ptr(ptr);						\
-	switch (size) {							\
-	case 1:								\
-		__put_user_asm(x, ptr, retval, "b", "b", "iq", errret);\
-		break;							\
-	case 2:								\
-		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);\
-		break;							\
-	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);\
-		break;							\
-	case 8:								\
-		__put_user_asm(x, ptr, retval, "q", "", "Zr", errret);	\
-		break;							\
-	default:							\
-		__put_user_bad();					\
-	}								\
-} while (0)
-
-/* FIXME: this hack is definitely wrong -AK */
-struct __large_struct { unsigned long buf[100]; };
-#define __m(x) (*(struct __large_struct __user *)(x))
-
-/*
- * Tell gcc we read from memory instead of writing: this is because
- * we do not write to any memory gcc knows about, so there are no
- * aliasing issues.
- */
-#define __put_user_asm(x, addr, err, itype, rtype, ltype, errno)	\
-	asm volatile("1:	mov"itype" %"rtype"1,%2\n"		\
-		     "2:\n"						\
-		     ".section .fixup, \"ax\"\n"			\
-		     "3:	mov %3,%0\n"				\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : "=r"(err)					\
-		     : ltype (x), "m" (__m(addr)), "i" (errno), "0" (err))
-
-
 #define __get_user_nocheck(x, ptr, size)			\
 ({								\
 	int __gu_err;						\
-- 
1.5.5.1

