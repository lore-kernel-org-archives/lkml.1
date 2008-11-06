Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbZD3Ppo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbZD3Ppo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763116AbZD3PmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:53510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbZD3PmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:05 -0400
Message-Id: <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 6 Nov 2008 16:31:03 +0100
Subject: [PATCH 12/27] asm-generic: add a NOMMU uaccess.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX19Bij9MFw4DfxtUlDK923Nnie3+zjnPkF+zrKX
 EEDetyWlFaDs44bh8LGm4Y9Ftor7UZhsuV/BLE8oAlOK/1qown
 L9HtnAKkEiBayMMIz4SHA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uaccess.h can be used by all NOMMU architectures,
but it does not provide exception handlers that would
be needed for an architecture with an MMU.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 arch/parisc/include/asm/uaccess.h                  |    2 +-
 arch/sparc/include/asm/uaccess_64.h                |    2 +-
 .../asm-generic/{uaccess.h => uaccess-unaligned.h} |    6 +-
 include/asm-generic/uaccess.h                      |  235 +++++++++++++++++---
 4 files changed, 214 insertions(+), 31 deletions(-)
 rename include/asm-generic/{uaccess.h => uaccess-unaligned.h} (82%)
 rewrite include/asm-generic/uaccess.h (96%)

diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index cd4c0b2..7cf799d 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -7,7 +7,7 @@
 #include <asm/page.h>
 #include <asm/system.h>
 #include <asm/cache.h>
-#include <asm-generic/uaccess.h>
+#include <asm-generic/uaccess-unaligned.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index c64e767..a38c032 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -12,7 +12,7 @@
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>
-#include <asm-generic/uaccess.h>
+#include <asm-generic/uaccess-unaligned.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess-unaligned.h
similarity index 82%
rename from include/asm-generic/uaccess.h
rename to include/asm-generic/uaccess-unaligned.h
index 549cb3a..67deb89 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess-unaligned.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_GENERIC_UACCESS_H_
-#define _ASM_GENERIC_UACCESS_H_
+#ifndef __ASM_GENERIC_UACCESS_UNALIGNED_H
+#define __ASM_GENERIC_UACCESS_UNALIGNED_H
 
 /*
  * This macro should be used instead of __get_user() when accessing
@@ -23,4 +23,4 @@
 	__copy_to_user((ptr), &__x, sizeof(*(ptr))) ? -EFAULT : 0;	\
 })
 
-#endif /* _ASM_GENERIC_UACCESS_H */
+#endif /* __ASM_GENERIC_UACCESS_UNALIGNED_H */
diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
dissimilarity index 96%
index 549cb3a..ebeacd9 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -1,26 +1,209 @@
-#ifndef _ASM_GENERIC_UACCESS_H_
-#define _ASM_GENERIC_UACCESS_H_
-
-/*
- * This macro should be used instead of __get_user() when accessing
- * values at locations that are not known to be aligned.
- */
-#define __get_user_unaligned(x, ptr)					\
-({									\
-	__typeof__ (*(ptr)) __x;					\
-	__copy_from_user(&__x, (ptr), sizeof(*(ptr))) ? -EFAULT : 0;	\
-	(x) = __x;							\
-})
-
-
-/*
- * This macro should be used instead of __put_user() when accessing
- * values at locations that are not known to be aligned.
- */
-#define __put_user_unaligned(x, ptr)					\
-({									\
-	__typeof__ (*(ptr)) __x = (x);					\
-	__copy_to_user((ptr), &__x, sizeof(*(ptr))) ? -EFAULT : 0;	\
-})
-
-#endif /* _ASM_GENERIC_UACCESS_H */
+#ifndef __ASM_GENERIC_UACCESS_H
+#define __ASM_GENERIC_UACCESS_H
+
+/*
+ * User space memory access functions, these should work
+ * on a ny machine that has kernel and user data in the same
+ * address space, e.g. all NOMMU machines.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+
+#include <asm/segment.h>
+
+#ifndef get_fs
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+#define KERNEL_DS	MAKE_MM_SEG(~0UL)
+#define USER_DS		MAKE_MM_SEG(TASK_SIZE - 1)
+
+#define get_ds() (KERNEL_DS)
+#define get_fs() (current_thread_info()->addr_limit)
+
+static inline void set_fs(mm_segment_t fs)
+{
+	current_thread_info()->addr_limit = fs;
+}
+#endif
+
+#define segment_eq(a, b) ((a).seg == (b).seg)
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+#define access_ok(type, addr, size) _access_ok((unsigned long)(addr),(size))
+
+/*
+ * The architecture should really override this if possible, at least
+ * doing a check on the get_fs()
+ */
+#ifndef _access_ok
+static inline int _access_ok(unsigned long addr, unsigned long size)
+{
+	return 1;
+}
+#endif
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry
+{
+	unsigned long insn, fixup;
+};
+
+/* Returns 0 if exception not found and fixup otherwise.  */
+extern unsigned long search_exception_table(unsigned long);
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ */
+#ifndef __put_user
+#define __put_user(x, ptr)				\
+({							\
+	int __pu_err = 0;				\
+	typeof(*(ptr)) __pu_val = (x);			\
+	switch (sizeof (*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+		*(ptr) = (__pu_val);			\
+		break;					\
+	case 8:						\
+		memcpy(ptr, &__pu_val, sizeof (*(ptr)));\
+		break;					\
+	default:					\
+		__pu_err = __put_user_bad();		\
+		break;					\
+	}						\
+	__pu_err;					\
+})
+extern int __put_user_bad(void);
+#endif
+
+#define put_user(x, ptr) (				\
+	access_ok(VERIFY_WRITE, ptr, sizeof (*ptr)) ?	\
+		__put_user(x, ptr) :			\
+		-EFAULT)
+
+#ifndef __get_user
+#define __get_user(x, ptr)				\
+({							\
+	int __gu_err = 0;				\
+	unsigned long __gu_val = (unsigned long)*ptr;	\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+	case 8:						\
+		break;					\
+	default:					\
+		__gu_err = __get_user_bad();		\
+		__gu_val = 0;				\
+		break;					\
+	}						\
+	(x) = (typeof(*ptr))__gu_val;			\
+	__gu_err;					\
+})
+extern int __get_user_bad(void);
+#endif
+
+#define get_user(x, ptr) (				\
+	access_ok(VERIFY_READ, ptr, sizeof (*ptr)) ?	\
+		__get_user(x, ptr) :			\
+		-EFAULT)
+
+#define __copy_from_user(to, from, n) (memcpy(to, from, n), 0)
+#define __copy_to_user(to, from, n) (memcpy(to, from, n), 0)
+#define __copy_to_user_inatomic __copy_to_user
+#define __copy_from_user_inatomic __copy_from_user
+
+#define copy_to_user_ret(to,from,n,retval) ({ if (copy_to_user(to,from,n)) return retval; })
+
+#define copy_from_user_ret(to,from,n,retval) ({ if (copy_from_user(to,from,n)) return retval; })
+
+static inline long copy_from_user(void *to,
+				  const void __user * from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		__copy_from_user(to, from, n);
+	else
+		return n;
+	return 0;
+}
+
+static inline long copy_to_user(void *to,
+				const void __user * from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		__copy_to_user(to, from, n);
+	else
+		return n;
+	return 0;
+}
+
+/*
+ * Copy a null terminated string from userspace.
+ */
+
+static inline long
+__do_strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	char *tmp;
+	strncpy(dst, src, count);
+	for (tmp = dst; *tmp && count > 0; tmp++, count--)
+		;
+	return (tmp - dst);
+}
+
+static inline long
+strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	if (!access_ok(VERIFY_READ, src, 1))
+		return -EFAULT;
+	return __do_strncpy_from_user(dst, src, count);
+}
+
+static inline long
+__strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	return __do_strncpy_from_user(dst, src, count);
+}
+
+/*
+ * Return the size of a string (including the ending 0)
+ *
+ * Return 0 on exception, a value greater than N if too long
+ */
+static inline long strnlen_user(const char *src, long n)
+{
+	return strlen(src) + 1;
+}
+
+#define strlen_user(str) strnlen_user(str, 32767)
+
+/*
+ * Zero Userspace
+ */
+
+static inline unsigned long
+__clear_user(void *to, unsigned long n)
+{
+	memset(to, 0, n);
+	return 0;
+}
+
+#define clear_user(to, n) __clear_user(to, n)
+
+#endif /* __ASM_GENERIC_UACCESS_H */
-- 
1.5.6.3


