Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbZE0He1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbZE0He1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762480AbZE0H10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:27:26 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46942 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762486AbZE0H1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:27:23 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 18/29] microblaze_mmu_v2: uaccess MMU update
Date: Wed, 27 May 2009 08:47:43 +0200
Message-Id: <1243406874-3917-19-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-18-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/uaccess.h |  298 +++++++++++++++++++++++++++------
 arch/microblaze/lib/uaccess_old.S     |  135 +++++++++++++++
 2 files changed, 381 insertions(+), 52 deletions(-)
 create mode 100644 arch/microblaze/lib/uaccess_old.S

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index a4e171d..65adad6 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -1,4 +1,6 @@
 /*
+ * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2008-2009 PetaLogix
  * Copyright (C) 2006 Atmark Techno, Inc.
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -26,6 +28,10 @@
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
 
+#define __clear_user(addr, n)	(memset((void *)(addr), 0, (n)), 0)
+
+#ifndef CONFIG_MMU
+
 extern int ___range_ok(unsigned long addr, unsigned long size);
 
 #define __range_ok(addr, size) \
@@ -38,63 +44,64 @@ extern int ___range_ok(unsigned long addr, unsigned long size);
 extern int bad_user_access_length(void);
 
 /* FIXME this is function for optimalization -> memcpy */
-#define __get_user(var, ptr)					\
-	({							\
-		int __gu_err = 0;				\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-		case 2:						\
-		case 4:						\
-			(var) = *(ptr);				\
-			break;					\
-		case 8:						\
-			memcpy((void *) &(var), (ptr), 8);	\
-			break;					\
-		default:					\
-			(var) = 0;				\
-			__gu_err = __get_user_bad();		\
-			break;					\
-		}						\
-		__gu_err;					\
-	})
+#define __get_user(var, ptr)				\
+({							\
+	int __gu_err = 0;				\
+	switch (sizeof(*(ptr))) {			\
+	case 1:						\
+	case 2:						\
+	case 4:						\
+		(var) = *(ptr);				\
+		break;					\
+	case 8:						\
+		memcpy((void *) &(var), (ptr), 8);	\
+		break;					\
+	default:					\
+		(var) = 0;				\
+		__gu_err = __get_user_bad();		\
+		break;					\
+	}						\
+	__gu_err;					\
+})
 
 #define __get_user_bad()	(bad_user_access_length(), (-EFAULT))
 
+/* FIXME is not there defined __pu_val */
 #define __put_user(var, ptr)					\
-	({							\
-		int __pu_err = 0;				\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-		case 2:						\
-		case 4:						\
-			*(ptr) = (var);				\
-			break;					\
-		case 8: {					\
-			typeof(*(ptr)) __pu_val = var;		\
-			memcpy(ptr, &__pu_val, sizeof(__pu_val));\
-			}					\
-			break;					\
-		default:					\
-			__pu_err = __put_user_bad();		\
-			break;					\
-		}							\
-		__pu_err;						\
-	})
+({								\
+	int __pu_err = 0;					\
+	switch (sizeof(*(ptr))) {				\
+	case 1:							\
+	case 2:							\
+	case 4:							\
+		*(ptr) = (var);					\
+		break;						\
+	case 8: {						\
+		typeof(*(ptr)) __pu_val = (var);		\
+		memcpy(ptr, &__pu_val, sizeof(__pu_val));	\
+		}						\
+		break;						\
+	default:						\
+		__pu_err = __put_user_bad();			\
+		break;						\
+	}							\
+	__pu_err;						\
+})
 
 #define __put_user_bad()	(bad_user_access_length(), (-EFAULT))
 
-#define put_user(x, ptr)	__put_user(x, ptr)
-#define get_user(x, ptr)	__get_user(x, ptr)
-
-#define copy_to_user(to, from, n)		(memcpy(to, from, n), 0)
-#define copy_from_user(to, from, n)		(memcpy(to, from, n), 0)
+#define put_user(x, ptr)	__put_user((x), (ptr))
+#define get_user(x, ptr)	__get_user((x), (ptr))
 
-#define __copy_to_user(to, from, n)		(copy_to_user(to, from, n))
-#define __copy_from_user(to, from, n)		(copy_from_user(to, from, n))
-#define __copy_to_user_inatomic(to, from, n)	(__copy_to_user(to, from, n))
-#define __copy_from_user_inatomic(to, from, n)	(__copy_from_user(to, from, n))
+#define copy_to_user(to, from, n)	(memcpy((to), (from), (n)), 0)
+#define copy_from_user(to, from, n)	(memcpy((to), (from), (n)), 0)
 
-#define __clear_user(addr, n)	(memset((void *)addr, 0, n), 0)
+#define __copy_to_user(to, from, n)	(copy_to_user((to), (from), (n)))
+#define __copy_from_user(to, from, n)	(copy_from_user((to), (from), (n)))
+#define __copy_to_user_inatomic(to, from, n) \
+			(__copy_to_user((to), (from), (n)))
+#define __copy_from_user_inatomic(to, from, n) \
+			(__copy_from_user((to), (from), (n)))
 
 static inline unsigned long clear_user(void *addr, unsigned long size)
 {
@@ -103,13 +110,200 @@ static inline unsigned long clear_user(void *addr, unsigned long size)
 	return size;
 }
 
-/* Returns 0 if exception not found and fixup otherwise. */
+/* Returns 0 if exception not found and fixup otherwise.  */
 extern unsigned long search_exception_table(unsigned long);
 
+extern long strncpy_from_user(char *dst, const char *src, long count);
+extern long strnlen_user(const char *src, long count);
+
+#else /* CONFIG_MMU */
+
+/*
+ * Address is valid if:
+ *  - "addr", "addr + size" and "size" are all below the limit
+ */
+#define access_ok(type, addr, size) \
+	(get_fs().seg > (((unsigned long)(addr)) | \
+		(size) | ((unsigned long)(addr) + (size))))
+
+/* || printk("access_ok failed for %s at 0x%08lx (size %d), seg 0x%08x\n",
+ type?"WRITE":"READ",addr,size,get_fs().seg)) */
+
+/*
+ * All the __XXX versions macros/functions below do not perform
+ * access checking. It is assumed that the necessary checks have been
+ * already performed before the finction (macro) is called.
+ */
+
+#define get_user(x, ptr)						\
+({									\
+	access_ok(VERIFY_READ, (ptr), sizeof(*(ptr)))			\
+		? __get_user((x), (ptr)) : -EFAULT;			\
+})
+
+#define put_user(x, ptr)						\
+({									\
+	access_ok(VERIFY_WRITE, (ptr), sizeof(*(ptr)))			\
+		? __put_user((x), (ptr)) : -EFAULT;			\
+})
+
+#define __get_user(x, ptr)						\
+({									\
+	unsigned long __gu_val;						\
+	/*unsigned long __gu_ptr = (unsigned long)(ptr);*/		\
+	long __gu_err;							\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		__get_user_asm("lbu", (ptr), __gu_val, __gu_err);	\
+		break;							\
+	case 2:								\
+		__get_user_asm("lhu", (ptr), __gu_val, __gu_err);	\
+		break;							\
+	case 4:								\
+		__get_user_asm("lw", (ptr), __gu_val, __gu_err);	\
+		break;							\
+	default:							\
+		__gu_val = 0; __gu_err = -EINVAL;			\
+	}								\
+	x = (__typeof__(*(ptr))) __gu_val;				\
+	__gu_err;							\
+})
+
+#define __get_user_asm(insn, __gu_ptr, __gu_val, __gu_err)		\
+({									\
+	__asm__ __volatile__ (						\
+			"1:"	insn	" %1, %2, r0;			\
+				addk	%0, r0, r0;			\
+			2:						\
+			.section .fixup,\"ax\";				\
+			3:	brid	2b;				\
+				addik	%0, r0, %3;			\
+			.previous;					\
+			.section __ex_table,\"a\";			\
+			.word	1b,3b;					\
+			.previous;"					\
+		: "=r"(__gu_err), "=r"(__gu_val)			\
+		: "r"(__gu_ptr), "i"(-EFAULT)				\
+	);								\
+})
+
+#define __put_user(x, ptr)						\
+({									\
+	__typeof__(*(ptr)) __gu_val = x;				\
+	long __gu_err = 0;						\
+	switch (sizeof(__gu_val)) {					\
+	case 1:								\
+		__put_user_asm("sb", (ptr), __gu_val, __gu_err);	\
+		break;							\
+	case 2: 							\
+		__put_user_asm("sh", (ptr), __gu_val, __gu_err);	\
+		break;							\
+	case 4:								\
+		__put_user_asm("sw", (ptr), __gu_val, __gu_err);	\
+		break;							\
+	case 8:								\
+		__put_user_asm_8((ptr), __gu_val, __gu_err);		\
+		break;							\
+	default:							\
+		__gu_err = -EINVAL;					\
+	}								\
+	__gu_err;							\
+})
+
+#define __put_user_asm_8(__gu_ptr, __gu_val, __gu_err)	\
+({							\
+__asm__ __volatile__ ("	lwi	%0, %1, 0;		\
+		1:	swi	%0, %2, 0;		\
+			lwi	%0, %1, 4;		\
+		2:	swi	%0, %2, 4;		\
+			addk	%0,r0,r0;		\
+		3:					\
+		.section .fixup,\"ax\";			\
+		4:	brid	3b;			\
+			addik	%0, r0, %3;		\
+		.previous;				\
+		.section __ex_table,\"a\";		\
+		.word	1b,4b,2b,4b;			\
+		.previous;"				\
+	: "=&r"(__gu_err)				\
+	: "r"(&__gu_val),				\
+	"r"(__gu_ptr), "i"(-EFAULT)			\
+	);						\
+})
+
+#define __put_user_asm(insn, __gu_ptr, __gu_val, __gu_err)	\
+({								\
+	__asm__ __volatile__ (					\
+			"1:"	insn	" %1, %2, r0;		\
+				addk	%0, r0, r0;		\
+			2:					\
+			.section .fixup,\"ax\";			\
+			3:	brid	2b;			\
+				addik	%0, r0, %3;		\
+			.previous;				\
+			.section __ex_table,\"a\";		\
+			.word	1b,3b;				\
+			.previous;"				\
+		: "=r"(__gu_err)				\
+		: "r"(__gu_val), "r"(__gu_ptr), "i"(-EFAULT)	\
+	);							\
+})
+
+/*
+ * Return: number of not copied bytes, i.e. 0 if OK or non-zero if fail.
+ */
+static inline int clear_user(char *to, int size)
+{
+	if (size && access_ok(VERIFY_WRITE, to, size)) {
+		__asm__ __volatile__ ("				\
+				1:				\
+					sb	r0, %2, r0;	\
+					addik	%0, %0, -1;	\
+					bneid	%0, 1b;		\
+					addik	%2, %2, 1;	\
+				2:				\
+				.section __ex_table,\"a\";	\
+				.word	1b,2b;			\
+				.section .text;"		\
+			: "=r"(size)				\
+			: "0"(size), "r"(to)
+		);
+	}
+	return size;
+}
+
+extern unsigned long __copy_tofrom_user(void __user *to,
+		const void __user *from, unsigned long size);
+
+#define copy_to_user(to, from, n)					\
+	(access_ok(VERIFY_WRITE, (to), (n)) ?				\
+		__copy_tofrom_user((void __user *)(to),			\
+			(__force const void __user *)(from), (n))	\
+		: -EFAULT)
+
+#define __copy_to_user(to, from, n)	copy_to_user((to), (from), (n))
+#define __copy_to_user_inatomic(to, from, n)	copy_to_user((to), (from), (n))
+
+#define copy_from_user(to, from, n)					\
+	(access_ok(VERIFY_READ, (from), (n)) ?				\
+		__copy_tofrom_user((__force void __user *)(to),		\
+			(void __user *)(from), (n))			\
+		: -EFAULT)
+
+#define __copy_from_user(to, from, n)	copy_from_user((to), (from), (n))
+#define __copy_from_user_inatomic(to, from, n) \
+		copy_from_user((to), (from), (n))
+
+extern int __strncpy_user(char *to, const char __user *from, int len);
+extern int __strnlen_user(const char __user *sstr, int len);
+
+#define strncpy_from_user(to, from, len)	\
+		(access_ok(VERIFY_READ, from, 1) ?	\
+			__strncpy_user(to, from, len) : -EFAULT)
+#define strnlen_user(str, len)	\
+		(access_ok(VERIFY_READ, str, 1) ? __strnlen_user(str, len) : 0)
 
-extern long strncpy_from_user(char *dst, const char __user *src, long count);
-extern long strnlen_user(const char __user *src, long count);
-extern long __strncpy_from_user(char *dst, const char __user *src, long count);
+#endif /* CONFIG_MMU */
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff --git a/arch/microblaze/lib/uaccess_old.S b/arch/microblaze/lib/uaccess_old.S
new file mode 100644
index 0000000..67f991c
--- /dev/null
+++ b/arch/microblaze/lib/uaccess_old.S
@@ -0,0 +1,135 @@
+/*
+ * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2009 PetaLogix
+ * Copyright (C) 2007 LynuxWorks, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/errno.h>
+#include <linux/linkage.h>
+
+/*
+ * int __strncpy_user(char *to, char *from, int len);
+ *
+ * Returns:
+ *  -EFAULT  for an exception
+ *  len      if we hit the buffer limit
+ *  bytes copied
+ */
+
+	.text
+.globl __strncpy_user;
+.align 4;
+__strncpy_user:
+
+	/*
+	 * r5 - to
+	 * r6 - from
+	 * r7 - len
+	 * r3 - temp count
+	 * r4 - temp val
+	 */
+	addik	r3,r7,0		/* temp_count = len */
+	beqi	r3,3f
+1:
+	lbu	r4,r6,r0
+	sb	r4,r5,r0
+
+	addik	r3,r3,-1
+	beqi	r3,2f		/* break on len */
+
+	addik	r5,r5,1
+	bneid	r4,1b
+	addik	r6,r6,1		/* delay slot */
+	addik	r3,r3,1		/* undo "temp_count--" */
+2:
+	rsubk	r3,r3,r7	/* temp_count = len - temp_count */
+3:
+	rtsd	r15,8
+	nop
+
+
+	.section	.fixup, "ax"
+	.align	2
+4:
+	brid	3b
+	addik	r3,r0, -EFAULT
+
+	.section	__ex_table, "a"
+	.word	1b,4b
+
+/*
+ * int __strnlen_user(char __user *str, int maxlen);
+ *
+ * Returns:
+ *  0 on error
+ *  maxlen + 1  if no NUL byte found within maxlen bytes
+ *  size of the string (including NUL byte)
+ */
+
+	.text
+.globl __strnlen_user;
+.align 4;
+__strnlen_user:
+	addik	r3,r6,0
+	beqi	r3,3f
+1:
+	lbu	r4,r5,r0
+	beqid	r4,2f		/* break on NUL */
+	addik	r3,r3,-1	/* delay slot */
+
+	bneid	r3,1b
+	addik	r5,r5,1		/* delay slot */
+
+	addik	r3,r3,-1	/* for break on len */
+2:
+	rsubk	r3,r3,r6
+3:
+	rtsd	r15,8
+	nop
+
+
+	.section	.fixup,"ax"
+4:
+	brid	3b
+	addk	r3,r0,r0
+
+	.section	__ex_table,"a"
+	.word	1b,4b
+
+/*
+ * int __copy_tofrom_user(char *to, char *from, int len)
+ * Return:
+ *   0 on success
+ *   number of not copied bytes on error
+ */
+	.text
+.globl __copy_tofrom_user;
+.align 4;
+__copy_tofrom_user:
+	/*
+	 * r5 - to
+	 * r6 - from
+	 * r7, r3 - count
+	 * r4 - tempval
+	 */
+	addik	r3,r7,0
+	beqi	r3,3f
+1:
+	lbu	r4,r6,r0
+	addik	r6,r6,1
+2:
+	sb	r4,r5,r0
+	addik	r3,r3,-1
+	bneid	r3,1b
+	addik	r5,r5,1		/* delay slot */
+3:
+	rtsd	r15,8
+	nop
+
+
+	.section	__ex_table,"a"
+	.word	1b,3b,2b,3b
-- 
1.5.5.1

