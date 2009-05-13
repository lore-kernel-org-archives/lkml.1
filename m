Return-Path: <linux-kernel-owner+w=401wt.eu-S1762362AbZEMXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762362AbZEMXC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760335AbZEMW5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:57:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761284AbZEMW4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:56:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 14/15] asm-generic: add a generic uaccess.h
Date: Wed, 13 May 2009 22:56:37 +0000
Message-Id: <1242255398-23779-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242255398-23779-1-git-send-email-arnd@arndb.de>
References: <1242255398-23779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX197dplG/XzWFB3Mq0tYc2aVdEqxzKPCB+IJnck
 Z9uc/lvL2uNbF3AKkpNoWRd5VTlVJ7nGrmkfH8CJi/uMb1I7BO
 VA7BbtOSjfwtJcZK16Dwg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on discussions with Michal Simek and code
from m68knommu and h8300, this version of uaccess.h
should be usable by most architectures, by overriding
some parts of it.

Simple NOMMU architectures can use it out of
the box, but a minimal __access_ok() should be
added there as well.

Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/uaccess.h |  325 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 325 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/uaccess.h

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
new file mode 100644
index 0000000..6d8cab2
--- /dev/null
+++ b/include/asm-generic/uaccess.h
@@ -0,0 +1,325 @@
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
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+
+#ifndef KERNEL_DS
+#define KERNEL_DS	MAKE_MM_SEG(~0UL)
+#endif
+
+#ifndef USER_DS
+#define USER_DS		MAKE_MM_SEG(TASK_SIZE - 1)
+#endif
+
+#ifndef get_fs
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
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
+#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
+
+/*
+ * The architecture should really override this if possible, at least
+ * doing a check on the get_fs()
+ */
+#ifndef __access_ok
+static inline int __access_ok(unsigned long addr, unsigned long size)
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
+ * architectures with an MMU should override these two
+ */
+#ifndef __copy_from_user
+static inline __must_check long __copy_from_user(void *to,
+		const void __user * from, unsigned long n)
+{
+	if (__builtin_constant_p(n)) {
+		switch(n) {
+		case 1:
+			*(u8 *)to = *(u8 __force *)from;
+			return 0;
+		case 2:
+			*(u16 *)to = *(u16 __force *)from;
+			return 0;
+		case 4:
+			*(u32 *)to = *(u32 __force *)from;
+			return 0;
+#ifdef CONFIG_64BIT
+		case 8:
+			*(u64 *)to = *(u64 __force *)from;
+			return 0;
+#endif
+		default:
+			break;
+		}
+	}
+
+	memcpy(to, (const void __force *)from, n);
+	return 0;
+}
+#endif
+
+#ifndef __copy_to_user
+static inline __must_check long __copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	if (__builtin_constant_p(n)) {
+		switch(n) {
+		case 1:
+			*(u8 __force *)to = *(u8 *)from;
+			return 0;
+		case 2:
+			*(u16 __force *)to = *(u16 *)from;
+			return 0;
+		case 4:
+			*(u32 __force *)to = *(u32 *)from;
+			return 0;
+#ifdef CONFIG_64BIT
+		case 8:
+			*(u64 __force *)to = *(u64 *)from;
+			return 0;
+#endif
+		default:
+			break;
+		}
+	}
+
+	memcpy((void __force *)to, from, n);
+	return 0;
+}
+#endif
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ * This version just falls back to copy_{from,to}_user, which should
+ * provide a fast-path for small values.
+ */
+#define __put_user(x, ptr) \
+({								\
+	__typeof__(*(ptr)) __x = (x);				\
+	int __pu_err = -EFAULT;					\
+        __chk_user_ptr(ptr);                                    \
+	switch (sizeof (*(ptr))) {				\
+	case 1:							\
+	case 2:							\
+	case 4:							\
+	case 8:							\
+		__pu_err = __put_user_fn(sizeof (*(ptr)),	\
+					 ptr, &__x);		\
+		break;						\
+	default:						\
+		__put_user_bad();				\
+		break;						\
+	 }							\
+	__pu_err;						\
+})
+
+#define put_user(x, ptr)					\
+({								\
+	might_sleep();						\
+	__access_ok(ptr, sizeof (*ptr)) ?			\
+		__put_user(x, ptr) :				\
+		-EFAULT;					\
+})
+
+static inline int __put_user_fn(size_t size, void __user *ptr, void *x)
+{
+	size = __copy_to_user(ptr, x, size);
+	return size ? -EFAULT : size;
+}
+
+extern int __put_user_bad(void) __attribute__((noreturn));
+
+#define __get_user(x, ptr)					\
+({								\
+	int __gu_err = -EFAULT;					\
+	__chk_user_ptr(ptr);					\
+	switch (sizeof(*(ptr))) {				\
+	case 1: {						\
+		unsigned char __x;				\
+		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
+					 ptr, &__x);		\
+		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		break;						\
+	};							\
+	case 2: {						\
+		unsigned short __x;				\
+		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
+					 ptr, &__x);		\
+		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		break;						\
+	};							\
+	case 4: {						\
+		unsigned int __x;				\
+		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
+					 ptr, &__x);		\
+		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		break;						\
+	};							\
+	case 8: {						\
+		unsigned long long __x;				\
+		__gu_err = __get_user_fn(sizeof (*(ptr)),	\
+					 ptr, &__x);		\
+		(x) = *(__force __typeof__(*(ptr)) *) &__x;	\
+		break;						\
+	};							\
+	default:						\
+		__get_user_bad();				\
+		break;						\
+	}							\
+	__gu_err;						\
+})
+
+#define get_user(x, ptr)					\
+({								\
+	might_sleep();						\
+	__access_ok(ptr, sizeof (*ptr)) ?			\
+		__get_user(x, ptr) :				\
+		-EFAULT;					\
+})
+
+static inline int __get_user_fn(size_t size, const void __user *ptr, void *x)
+{
+	size = __copy_from_user(x, ptr, size);
+	return size ? -EFAULT : size;
+}
+
+extern int __get_user_bad(void) __attribute__((noreturn));
+
+#ifndef __copy_from_user_inatomic
+#define __copy_from_user_inatomic __copy_from_user
+#endif
+
+#ifndef __copy_to_user_inatomic
+#define __copy_to_user_inatomic __copy_to_user
+#endif
+
+static inline long copy_from_user(void *to,
+		const void __user * from, unsigned long n)
+{
+	might_sleep();
+	if (__access_ok(from, n))
+		return __copy_from_user(to, from, n);
+	else
+		return n;
+}
+
+static inline long copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	might_sleep();
+	if (__access_ok(to, n))
+		return __copy_to_user(to, from, n);
+	else
+		return n;
+}
+
+/*
+ * Copy a null terminated string from userspace.
+ */
+#ifndef __strncpy_from_user
+static inline long
+__strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	char *tmp;
+	strncpy(dst, (const char __force *)src, count);
+	for (tmp = dst; *tmp && count > 0; tmp++, count--)
+		;
+	return (tmp - dst);
+}
+#endif
+
+static inline long
+strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	if (!__access_ok(src, 1))
+		return -EFAULT;
+	return __strncpy_from_user(dst, src, count);
+}
+
+/*
+ * Return the size of a string (including the ending 0)
+ *
+ * Return 0 on exception, a value greater than N if too long
+ */
+#ifndef strnlen_user
+static inline long strnlen_user(const char __user *src, long n)
+{
+	return strlen((void * __force)src) + 1;
+}
+#endif
+
+static inline long strlen_user(const char __user *src)
+{
+	return strnlen_user(src, 32767);
+}
+
+/*
+ * Zero Userspace
+ */
+#ifndef __clear_user
+static inline __must_check unsigned long
+__clear_user(void __user *to, unsigned long n)
+{
+	memset((void __force *)to, 0, n);
+	return 0;
+}
+#endif
+
+static inline __must_check unsigned long
+clear_user(void __user *to, unsigned long n)
+{
+	might_sleep();
+	if (!__access_ok(to, n))
+		return n;
+
+	return __clear_user(to, n);
+}
+
+#endif /* __ASM_GENERIC_UACCESS_H */
-- 
1.6.0.4

