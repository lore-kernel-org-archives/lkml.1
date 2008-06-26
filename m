Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbYFZNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbYFZNCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbYFZMmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:42:54 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23342 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759986AbYFZMmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:42:51 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 21/60] microblaze_v4: uaccess files
Date: Thu, 26 Jun 2008 14:29:50 +0200
Message-Id: <1214483429-32360-22-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-21-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/lib/uaccess.c    |   41 +++++++++++++
 include/asm-microblaze/uaccess.h |  124 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/lib/uaccess.c
 create mode 100644 include/asm-microblaze/uaccess.h

diff --git a/arch/microblaze/lib/uaccess.c b/arch/microblaze/lib/uaccess.c
new file mode 100644
index 0000000..03a3051
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
+long strnlen_user(const char __user *s, long n)
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
+long __strncpy_from_user(char *dst, const char __user *src, long count)
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
index 0000000..e50ad56
--- /dev/null
+++ b/include/asm-microblaze/uaccess.h
@@ -0,0 +1,124 @@
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
+#define __get_user_bad()	(bad_user_access_length(), (-EFAULT))
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
+#endif /* _ASM_MICROBLAZE_UACCESS_H */
-- 
1.5.4.GIT

