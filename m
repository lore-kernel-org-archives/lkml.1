Return-Path: <linux-kernel-owner+w=401wt.eu-S1765275AbYF0VrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765275AbYF0VrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764229AbYF0ViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763607AbYF0ViG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:06 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 26/39] merge getuser
Date: Fri, 27 Jun 2008 18:34:33 -0300
Message-Id: <1214602486-17080-27-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-26-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merge versions of getuser from uaccess_32.h and uaccess_64.h into
uaccess.h. There is a part which is 64-bit only (for now), and for
that, we use a __get_user_8 macro.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |   55 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uaccess_32.h |   43 --------------------------------
 include/asm-x86/uaccess_64.h |   29 ----------------------
 3 files changed, 55 insertions(+), 72 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 2290513..a06a810 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -121,6 +121,61 @@ extern int __get_user_bad(void);
 		     : "=a" (ret),"=d" (x)	      \
 		     : "0" (ptr))		      \
 
+/* Careful: we have to cast the result to the type of the pointer
+ * for sign reasons */
+
+/**
+ * get_user: - Get a simple variable from user space.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+#ifdef CONFIG_X86_32
+#define __get_user_8(__ret_gu, __val_gu, ptr)				\
+		__get_user_x(X, __ret_gu, __val_gu, ptr)
+#else
+#define __get_user_8(__ret_gu, __val_gu, ptr)				\
+		__get_user_x(8, __ret_gu, __val_gu, ptr)
+#endif
+
+#define get_user(x, ptr)						\
+({									\
+	int __ret_gu;							\
+	unsigned long __val_gu;						\
+	__chk_user_ptr(ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 2:								\
+		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 4:								\
+		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	case 8:								\
+		__get_user_8(__ret_gu, __val_gu, ptr);			\
+		break;							\
+	default:							\
+		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
+		break;							\
+	}								\
+	(x) = (__typeof__(*(ptr)))__val_gu;				\
+	__ret_gu;							\
+})
+
+
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 92ad19e..3cc3236 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -24,49 +24,6 @@ extern struct movsl_mask {
 	((unsigned long __force)(addr) <		\
 	 (current_thread_info()->addr_limit.seg))
 
-/* Careful: we have to cast the result to the type of the pointer
- * for sign reasons */
-
-/**
- * get_user: - Get a simple variable from user space.
- * @x:   Variable to store result.
- * @ptr: Source address, in user space.
- *
- * Context: User context only.  This function may sleep.
- *
- * This macro copies a single simple variable from user space to kernel
- * space.  It supports simple types like char and int, but not larger
- * data types like structures or arrays.
- *
- * @ptr must have pointer-to-simple-variable type, and the result of
- * dereferencing @ptr must be assignable to @x without a cast.
- *
- * Returns zero on success, or -EFAULT on error.
- * On error, the variable @x is set to zero.
- */
-#define get_user(x, ptr)						\
-({									\
-	int __ret_gu;							\
-	unsigned long __val_gu;						\
-	__chk_user_ptr(ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	default:							\
-		__get_user_x(X, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	}								\
-	(x) = (__typeof__(*(ptr)))__val_gu;				\
-	__ret_gu;							\
-})
-
 extern void __put_user_bad(void);
 
 /*
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 243dbb4..4a44b90 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -14,35 +14,6 @@
 
 #define ARCH_HAS_SEARCH_EXTABLE
 
-/* Careful: we have to cast the result to the type of the pointer
- * for sign reasons */
-
-#define get_user(x, ptr)						\
-({									\
-	unsigned long __val_gu;						\
-	int __ret_gu;							\
-	__chk_user_ptr(ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 2:								\
-		__get_user_x(2, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 4:								\
-		__get_user_x(4, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	case 8:								\
-		__get_user_x(8, __ret_gu, __val_gu, ptr);		\
-		break;							\
-	default:							\
-		__get_user_bad();					\
-		break;							\
-	}								\
-	(x) = (__force typeof(*(ptr)))__val_gu;				\
-	__ret_gu;							\
-})
-
 extern void __put_user_1(void);
 extern void __put_user_2(void);
 extern void __put_user_4(void);
-- 
1.5.5.1

