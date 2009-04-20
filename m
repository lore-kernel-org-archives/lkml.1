Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbZD3Pte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbZD3Pte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbZD3Pmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbZD3PmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:07 -0400
Message-Id: <00ef5e70ad64d2fcf5fab256fa6af87c4d3366ff.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Remis Lima Baima <remis.developer@googlemail.com>
Date: Mon, 20 Apr 2009 13:53:24 +0200
Subject: [PATCH 25/27] microblaze: use generic uaccess.h
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+oDtTCIRpM6Fw/F4M37lxFEZZXdg/zwfFjbso
 21DwYk78q2OAcUhkHhPWtyYeDkGVpKoXW04DEJ78i30lwy1iWb
 qn9VThyNtDODCOIGYkMVw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt microblaze uaccess code to use the uaccess.h generic implementation.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/uaccess.h |  164 ++++++---------------------------
 arch/microblaze/lib/uaccess.c         |   42 +--------
 2 files changed, 31 insertions(+), 175 deletions(-)
 rewrite arch/microblaze/include/asm/uaccess.h (86%)
 rewrite arch/microblaze/lib/uaccess.c (97%)

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
dissimilarity index 86%
index 5a3ffc3..cc0120d 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -1,134 +1,30 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_UACCESS_H
-#define _ASM_MICROBLAZE_UACCESS_H
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/sched.h> /* RLIMIT_FSIZE */
-#include <linux/mm.h>
-
-#include <asm/mmu.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/segment.h>
-#include <linux/string.h>
-
-#define VERIFY_READ	0
-#define VERIFY_WRITE	1
-
-extern int ___range_ok(unsigned long addr, unsigned long size);
-
-#define __range_ok(addr, size) \
-		___range_ok((unsigned long)(addr), (unsigned long)(size))
-
-#define access_ok(type, addr, size) (__range_ok((addr), (size)) == 0)
-#define __access_ok(add, size) (__range_ok((addr), (size)) == 0)
-
-extern inline int bad_user_access_length(void)
-{
-	return 0;
-}
-/* FIXME this is function for optimalization -> memcpy */
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
-
-#define __get_user_bad()	(bad_user_access_length(), (-EFAULT))
-
-#define __put_user(var, ptr)					\
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
-
-#define __put_user_bad()	(bad_user_access_length(), (-EFAULT))
-
-#define put_user(x, ptr)	__put_user(x, ptr)
-#define get_user(x, ptr)	__get_user(x, ptr)
-
-#define copy_to_user(to, from, n)		(memcpy(to, from, n), 0)
-#define copy_from_user(to, from, n)		(memcpy(to, from, n), 0)
-
-#define __copy_to_user(to, from, n)		(copy_to_user(to, from, n))
-#define __copy_from_user(to, from, n)		(copy_from_user(to, from, n))
-#define __copy_to_user_inatomic(to, from, n)	(__copy_to_user(to, from, n))
-#define __copy_from_user_inatomic(to, from, n)	(__copy_from_user(to, from, n))
-
-#define __clear_user(addr, n)	(memset((void *)addr, 0, n), 0)
-
-static inline unsigned long clear_user(void *addr, unsigned long size)
-{
-	if (access_ok(VERIFY_WRITE, addr, size))
-		size = __clear_user(addr, size);
-	return size;
-}
-
-/* Returns 0 if exception not found and fixup otherwise. */
-extern unsigned long search_exception_table(unsigned long);
-
-
-extern long strncpy_from_user(char *dst, const char __user *src, long count);
-extern long strnlen_user(const char __user *src, long count);
-extern long __strncpy_from_user(char *dst, const char __user *src, long count);
-
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue. No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path. This means when everything is well,
- * we don't even have to jump over them. Further, they do not intrude
- * on our cache or tlb entries.
- */
-struct exception_table_entry {
-	unsigned long insn, fixup;
-};
-
-#endif  /* __ASSEMBLY__ */
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_MICROBLAZE_UACCESS_H */
+#ifndef _ASM_MICROBLAZE_UACCESS_H
+#define _ASM_MICROBLAZE_UACCESS_H
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#define __access_ok(addr, size) \
+	(___range_ok((unsigned long)(addr), (unsigned long)(size)) == 0)
+extern int ___range_ok(unsigned long addr, unsigned long size);
+
+#define __put_user_bad		bad_user_access_length
+#define __get_user_bad		bad_user_access_length
+extern inline int bad_user_access_length(void)
+{
+	return 0;
+}
+
+#include <asm-generic/uaccess.h>
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_MICROBLAZE_UACCESS_H */
diff --git a/arch/microblaze/lib/uaccess.c b/arch/microblaze/lib/uaccess.c
dissimilarity index 97%
index 8eb9df5..0f2f742 100644
--- a/arch/microblaze/lib/uaccess.c
+++ b/arch/microblaze/lib/uaccess.c
@@ -1,41 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#include <linux/string.h>
-#include <asm/uaccess.h>
-
-#include <asm/bug.h>
-
-long strnlen_user(const char __user *src, long count)
-{
-	return strlen(src) + 1;
-}
-
-#define __do_strncpy_from_user(dst, src, count, res)			\
-	do {								\
-		char *tmp;						\
-		strncpy(dst, src, count);				\
-		for (tmp = dst; *tmp && count > 0; tmp++, count--)	\
-			;						\
-		res = (tmp - dst);					\
-	} while (0)
-
-long __strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	long res;
-	__do_strncpy_from_user(dst, src, count, res);
-	return res;
-}
-
-long strncpy_from_user(char *dst, const char __user *src, long count)
-{
-	long res = -EFAULT;
-	if (access_ok(VERIFY_READ, src, 1))
-		__do_strncpy_from_user(dst, src, count, res);
-	return res;
-}
+#include <asm/uaccess.h>
-- 
1.5.6.3


