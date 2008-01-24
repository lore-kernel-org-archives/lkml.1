Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYAZP7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYAZP7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbYAZPyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:54 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755882AbYAZPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:53 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 19/52] [microblaze] uaccess files
Date: Thu, 24 Jan 2008 16:02:54 +0100
Message-Id: <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/uaccess.c    |   43 +++++++++++++
 include/asm-microblaze/uaccess.h |  126 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/uaccess.c
 create mode 100644 include/asm-microblaze/uaccess.h

diff --git a/arch/microblaze/lib/uaccess.c b/arch/microblaze/lib/uaccess.c
new file mode 100644
index 0000000..be201a0
--- /dev/null
+++ b/arch/microblaze/lib/uaccess.c
@@ -0,0 +1,43 @@
+/*
+ * arch/microblaze/lib/uaccess.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/string.h>
+#include <asm/uaccess.h>
+
+#include <asm/bug.h>
+
+long strnlen_user(const char *s, long n)
+{
+	return strlen(s) + 1;
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
+long __strncpy_from_user(char *dst, const char *src, long count)
+{
+	long res;
+	__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
+
+long strncpy_from_user(char *dst, const char *src, long count)
+{
+	long res = -EFAULT;
+	if (access_ok(VERIFY_READ, src, 1))
+		__do_strncpy_from_user(dst, src, count, res);
+	return res;
+}
diff --git a/include/asm-microblaze/uaccess.h b/include/asm-microblaze/uaccess.h
new file mode 100644
index 0000000..1ee4c63
--- /dev/null
+++ b/include/asm-microblaze/uaccess.h
@@ -0,0 +1,126 @@
+/*
+ * include/asm-microblaze/uaccess.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_UACCESS_H
+#define _ASM_UACCESS_H
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <asm/segment.h>
+#include <asm/string.h>
+
+#include <linux/sched.h> /* RLIMIT_FSIZE */
+/* #include <linux/errno.h> */
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
+
+#define __get_user(var, ptr)						\
+	({								\
+		int __gu_err = 0;					\
+		switch (sizeof(*(ptr))) {				\
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
+		}							\
+		__gu_err;						\
+	})
+
+#define __get_user_bad()	(bad_user_access_length (), (-EFAULT))
+
+#define __put_user(var, ptr)						\
+	({								\
+		int __pu_err = 0;					\
+		switch (sizeof(*(ptr))) {				\
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
+#define __put_user_bad()	(bad_user_access_length (), (-EFAULT))
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
+extern long strncpy_from_user(char *dst, const char *src, long count);
+extern long strnlen_user(const char *src, long count);
+extern long __strncpy_from_user(char *dst, const char *src, long count);
+
+#endif /* _ASM_UACCESS_H */
-- 
1.5.4.rc4.14.g6fc74

