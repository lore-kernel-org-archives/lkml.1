Return-Path: <linux-kernel-owner+w=401wt.eu-S1765498AbYF0Vvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765498AbYF0Vvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764414AbYF0Vil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764398AbYF0Vij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:39 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 37/39] move __get_user and __put_user into uaccess.h
Date: Fri, 27 Jun 2008 18:34:44 -0300
Message-Id: <1214602486-17080-38-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-37-git-send-email-gcosta@redhat.com>
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
 <1214602486-17080-37-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also carry the unaligned version with us. Only x86_64 uses
it, but there's no problem in defining it.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |   47 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uaccess_32.h |   46 -----------------------------------------
 include/asm-x86/uaccess_64.h |    8 -------
 3 files changed, 47 insertions(+), 54 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 583cc48..4ebb992 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -384,7 +384,54 @@ struct __large_struct { unsigned long buf[100]; };
 		     _ASM_EXTABLE(1b, 3b)				\
 		     : "=r"(err)					\
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+/**
+ * __get_user: - Get a simple variable from user space, with less checking.
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
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+
+#define __get_user(x, ptr)						\
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+/**
+ * __put_user: - Write a simple value into user space, with less checking.
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
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+
+#define __put_user(x, ptr)						\
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
+#define __get_user_unaligned __get_user
+#define __put_user_unaligned __put_user
 
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index e5c0437..d3b5bf8 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -20,52 +20,6 @@ extern struct movsl_mask {
 } ____cacheline_aligned_in_smp movsl_mask;
 #endif
 
-/**
- * __get_user: - Get a simple variable from user space, with less checking.
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
- * Caller must check the pointer with access_ok() before calling this
- * function.
- *
- * Returns zero on success, or -EFAULT on error.
- * On error, the variable @x is set to zero.
- */
-#define __get_user(x, ptr)				\
-	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
-
-
-/**
- * __put_user: - Write a simple value into user space, with less checking.
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
- * Caller must check the pointer with access_ok() before calling this
- * function.
- *
- * Returns zero on success, or -EFAULT on error.
- */
-#define __put_user(x, ptr)						\
-	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-
 unsigned long __must_check __copy_to_user_ll
 		(void __user *to, const void *from, unsigned long n);
 unsigned long __must_check __copy_from_user_ll
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index 2e75a5d..b5bacd6 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -11,14 +11,6 @@
 
 #define ARCH_HAS_SEARCH_EXTABLE
 
-#define __get_user(x, ptr)						\
-	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
-#define __put_user(x, ptr)						\
-	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
-
-#define __get_user_unaligned __get_user
-#define __put_user_unaligned __put_user
-
 /*
  * Copy To/From Userspace
  */
-- 
1.5.5.1

