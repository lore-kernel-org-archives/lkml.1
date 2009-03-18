Return-Path: <linux-kernel-owner+w=401wt.eu-S1760097AbZCRVtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097AbZCRVtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757698AbZCRVnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:05 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757643AbZCRVnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:01 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 20/57] microblaze_v7: uaccess files
Date: Wed, 18 Mar 2009 21:30:47 +0100
Message-Id: <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/uaccess.h |  134 +++++++++++++++++++++++++++++++++
 arch/microblaze/lib/uaccess.c         |   41 ++++++++++
 2 files changed, 175 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/uaccess.h
 create mode 100644 arch/microblaze/lib/uaccess.c

diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
new file mode 100644
index 0000000..5a3ffc3
--- /dev/null
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -0,0 +1,134 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_UACCESS_H
+#define _ASM_MICROBLAZE_UACCESS_H
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/sched.h> /* RLIMIT_FSIZE */
+#include <linux/mm.h>
+
+#include <asm/mmu.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/segment.h>
+#include <linux/string.h>
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+extern int ___range_ok(unsigned long addr, unsigned long size);
+
+#define __range_ok(addr, size) \
+		___range_ok((unsigned long)(addr), (unsigned long)(size))
+
+#define access_ok(type, addr, size) (__range_ok((addr), (size)) == 0)
+#define __access_ok(add, size) (__range_ok((addr), (size)) == 0)
+
+extern inline int bad_user_access_length(void)
+{
+	return 0;
+}
+/* FIXME this is function for optimalization -> memcpy */
+#define __get_user(var, ptr)					\
+	({							\
+		int __gu_err = 0;				\
+		switch (sizeof(*(ptr))) {			\
+		case 1:						\
+		case 2:						\
+		case 4:						\
+			(var) = *(ptr);				\
+			break;					\
+		case 8:						\
+			memcpy((void *) &(var), (ptr), 8);	\
+			break;					\
+		default:					\
+			(var) = 0;				\
+			__gu_err = __get_user_bad();		\
+			break;					\
+		}						\
+		__gu_err;					\
+	})
+
+#define __get_user_bad()	(bad_user_access_length(), (-EFAULT))
+
+#define __put_user(var, ptr)					\
+	({							\
+		int __pu_err = 0;				\
+		switch (sizeof(*(ptr))) {			\
+		case 1:						\
+		case 2:						\
+		case 4:						\
+			*(ptr) = (var);				\
+			break;					\
+		case 8: {					\
+			typeof(*(ptr)) __pu_val = var;		\
+			memcpy(ptr, &__pu_val, sizeof(__pu_val));\
+			}					\
+			break;					\
+		default:					\
+			__pu_err = __put_user_bad();		\
+			break;					\
+		}							\
+		__pu_err;						\
+	})
+
+#define __put_user_bad()	(bad_user_access_length(), (-EFAULT))
+
+#define put_user(x, ptr)	__put_user(x, ptr)
+#define get_user(x, ptr)	__get_user(x, ptr)
+
+#define copy_to_user(to, from, n)		(memcpy(to, from, n), 0)
+#define copy_from_user(to, from, n)		(memcpy(to, from, n), 0)
+
+#define __copy_to_user(to, from, n)		(copy_to_user(to, from, n))
+#define __copy_from_user(to, from, n)		(copy_from_user(to, from, n))
+#define __copy_to_user_inatomic(to, from, n)	(__copy_to_user(to, from, n))
+#define __copy_from_user_inatomic(to, from, n)	(__copy_from_user(to, from, n))
+
+#define __clear_user(addr, n)	(memset((void *)addr, 0, n), 0)
+
+static inline unsigned long clear_user(void *addr, unsigned long size)
+{
+	if (access_ok(VERIFY_WRITE, addr, size))
+		size = __clear_user(addr, size);
+	return size;
+}
+
+/* Returns 0 if exception not found and fixup otherwise. */
+extern unsigned long search_exception_table(unsigned long);
+
+
+extern long strncpy_from_user(char *dst, const char __user *src, long count);
+extern long strnlen_user(const char __user *src, long count);
+extern long __strncpy_from_user(char *dst, const char __user *src, long count);
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue. No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path. This means when everything is well,
+ * we don't even have to jump over them. Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+#endif  /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_MICROBLAZE_UACCESS_H */
diff --git a/arch/microblaze/lib/uaccess.c b/arch/microblaze/lib/uaccess.c
new file mode 100644
index 0000000..8eb9df5
--- /dev/null
+++ b/arch/microblaze/lib/uaccess.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/string.h>
+#include <asm/uaccess.h>
+
+#include <asm/bug.h>
+
+long strnlen_user(const char __user *src, long count)
+{
+	return strlen(src) + 1;
+}
+
+#define __do_strncpy_from_user(dst, src, count, res)			\
+	do {								\
+		char *tmp;						\
+		strncpy(dst, src, count);				\
+		for (tmp = dst; *tmp && count > 0; tmp++, count--)	\
+			;						\
+		res = (tmp - dst);					\
+	} while (0)
+
+long __strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res;
+	__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
+
+long strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
-- 
1.5.5.1

