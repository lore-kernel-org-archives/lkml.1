Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbYF0Vv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbYF0Vv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764409AbYF0Vik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764394AbYF0Vii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:38 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 36/39] merge put_user
Date: Fri, 27 Jun 2008 18:34:43 -0300
Message-Id: <1214602486-17080-37-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-36-git-send-email-gcosta@redhat.com>
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
 <1214602486-17080-34-git-send-email-gcosta@redhat.com>
 <1214602486-17080-35-git-send-email-gcosta@redhat.com>
 <1214602486-17080-36-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move both versions, which are highly similar, to uaccess.h.
Note that, for x86_64, X86_WP_WORKS_OK is always defined.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |   74 +++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uaccess_32.h |   79 ------------------------------------------
 include/asm-x86/uaccess_64.h |   36 -------------------
 3 files changed, 74 insertions(+), 115 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 4ff31c5..583cc48 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -179,6 +179,12 @@ extern int __get_user_bad(void);
 	__ret_gu;							\
 })
 
+#define __put_user_x(size, x, ptr, __ret_pu)			\
+	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
+		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+
+
+
 #ifdef CONFIG_X86_32
 #define __put_user_u64(x, addr, err)					\
 	asm volatile("1:	movl %%eax,0(%2)\n"			\
@@ -192,13 +198,71 @@ extern int __get_user_bad(void);
 		     _ASM_EXTABLE(2b, 4b)				\
 		     : "=r" (err)					\
 		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
+
+#define __put_user_x8(x, ptr, __ret_pu)				\
+	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
+		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
 #define __put_user_u64(x, ptr, retval) \
 	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
 
+extern void __put_user_bad(void);
+
+/*
+ * Strange magic calling convention: pointer in %ecx,
+ * value in %eax(:%edx), return value in %eax. clobbers %rbx
+ */
+extern void __put_user_1(void);
+extern void __put_user_2(void);
+extern void __put_user_4(void);
+extern void __put_user_8(void);
+
 #ifdef CONFIG_X86_WP_WORKS_OK
 
+/**
+ * put_user: - Write a simple value into user space.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define put_user(x, ptr)					\
+({								\
+	int __ret_pu;						\
+	__typeof__(*(ptr)) __pu_val;				\
+	__chk_user_ptr(ptr);					\
+	__pu_val = x;						\
+	switch (sizeof(*(ptr))) {				\
+	case 1:							\
+		__put_user_x(1, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	case 2:							\
+		__put_user_x(2, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	case 4:							\
+		__put_user_x(4, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	case 8:							\
+		__put_user_x8(__pu_val, ptr, __ret_pu);		\
+		break;						\
+	default:						\
+		__put_user_x(X, __pu_val, ptr, __ret_pu);	\
+		break;						\
+	}							\
+	__ret_pu;						\
+})
+
 #define __put_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
@@ -232,6 +296,16 @@ do {									\
 		retval = errret;					\
 } while (0)
 
+#define put_user(x, ptr)					\
+({								\
+	int __ret_pu;						\
+	__typeof__(*(ptr))__pus_tmp = x;			\
+	__ret_pu = 0;						\
+	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
+				       sizeof(*(ptr))) != 0))	\
+		__ret_pu = -EFAULT;				\
+	__ret_pu;						\
+})
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 2c90673..e5c0437 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -20,85 +20,6 @@ extern struct movsl_mask {
 } ____cacheline_aligned_in_smp movsl_mask;
 #endif
 
-extern void __put_user_bad(void);
-
-/*
- * Strange magic calling convention: pointer in %ecx,
- * value in %eax(:%edx), return value in %eax, no clobbers.
- */
-extern void __put_user_1(void);
-extern void __put_user_2(void);
-extern void __put_user_4(void);
-extern void __put_user_8(void);
-
-#define __put_user_x(size, x, ptr, __ret_pu)			\
-	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
-		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
-
-#define __put_user_8(x, ptr, __ret_pu)				\
-	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
-		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
-
-
-/**
- * put_user: - Write a simple value into user space.
- * @x:   Value to copy to user space.
- * @ptr: Destination address, in user space.
- *
- * Context: User context only.  This function may sleep.
- *
- * This macro copies a single simple value from kernel space to user
- * space.  It supports simple types like char and int, but not larger
- * data types like structures or arrays.
- *
- * @ptr must have pointer-to-simple-variable type, and @x must be assignable
- * to the result of dereferencing @ptr.
- *
- * Returns zero on success, or -EFAULT on error.
- */
-#ifdef CONFIG_X86_WP_WORKS_OK
-
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr)) __pu_val;				\
-	__chk_user_ptr(ptr);					\
-	__pu_val = x;						\
-	switch (sizeof(*(ptr))) {				\
-	case 1:							\
-		__put_user_x(1, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	case 2:							\
-		__put_user_x(2, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	case 4:							\
-		__put_user_x(4, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	case 8:							\
-		__put_user_8(__pu_val, ptr, __ret_pu);		\
-		break;						\
-	default:						\
-		__put_user_x(X, __pu_val, ptr, __ret_pu);	\
-		break;						\
-	}							\
-	__ret_pu;						\
-})
-
-#else
-#define put_user(x, ptr)					\
-({								\
-	int __ret_pu;						\
-	__typeof__(*(ptr))__pus_tmp = x;			\
-	__ret_pu = 0;						\
-	if (unlikely(__copy_to_user_ll(ptr, &__pus_tmp,		\
-				       sizeof(*(ptr))) != 0))	\
-		__ret_pu = -EFAULT;				\
-	__ret_pu;						\
-})
-
-
-#endif
-
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 9139854..2e75a5d 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -11,18 +11,6 @@
 
 #define ARCH_HAS_SEARCH_EXTABLE
 
-extern void __put_user_1(void);
-extern void __put_user_2(void);
-extern void __put_user_4(void);
-extern void __put_user_8(void);
-extern void __put_user_bad(void);
-
-#define __put_user_x(size, ret, x, ptr)					\
-	asm volatile("call __put_user_" #size				\
-		     :"=a" (ret)					\
-		     :"c" (ptr),"a" (x)					\
-		     :"ebx")
-
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
 #define __put_user(x, ptr)						\
@@ -31,30 +19,6 @@ extern void __put_user_bad(void);
 #define __get_user_unaligned __get_user
 #define __put_user_unaligned __put_user
 
-#define put_user(x, ptr)					\
-({								\
-	int __pu_err;						\
-	typeof(*(ptr)) __user *__pu_addr = (ptr);		\
-	__chk_user_ptr(ptr);					\
-	switch (sizeof(*(ptr))) {				\
-	case 1:							\
-		__put_user_x(1, __pu_err, x, __pu_addr);	\
-		break;						\
-	case 2:							\
-		__put_user_x(2, __pu_err, x, __pu_addr);	\
-		break;						\
-	case 4:							\
-		__put_user_x(4, __pu_err, x, __pu_addr);	\
-		break;						\
-	case 8:							\
-		__put_user_x(8, __pu_err, x, __pu_addr);	\
-		break;						\
-	default:						\
-		__put_user_bad();				\
-	}							\
-	__pu_err;						\
-})
-
 /*
  * Copy To/From Userspace
  */
-- 
1.5.5.1

