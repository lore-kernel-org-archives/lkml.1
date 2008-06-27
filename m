Return-Path: <linux-kernel-owner+w=401wt.eu-S1765320AbYF0Vrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765320AbYF0Vrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764238AbYF0ViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:38:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763626AbYF0ViJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:38:09 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 25/39] merge common parts of uaccess.
Date: Fri, 27 Jun 2008 18:34:32 -0300
Message-Id: <1214602486-17080-26-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-25-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

common parts of uaccess_32.h and uaccess_64.h
are put in uaccess.h.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/uaccess.h    |  125 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/uaccess_32.h |  110 -------------------------------------
 include/asm-x86/uaccess_64.h |   84 ----------------------------
 3 files changed, 125 insertions(+), 194 deletions(-)

diff --git a/include/asm-x86/uaccess.h b/include/asm-x86/uaccess.h
index 9fefd29..2290513 100644
--- a/include/asm-x86/uaccess.h
+++ b/include/asm-x86/uaccess.h
@@ -1,5 +1,130 @@
+#ifndef _ASM_UACCES_H_
+#define _ASM_UACCES_H_
+/*
+ * User space memory access functions
+ */
+#include <linux/errno.h>
+#include <linux/compiler.h>
+#include <linux/thread_info.h>
+#include <linux/prefetch.h>
+#include <linux/string.h>
+#include <asm/asm.h>
+#include <asm/page.h>
+
+#define VERIFY_READ 0
+#define VERIFY_WRITE 1
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not.  If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ */
+
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+
+#define KERNEL_DS	MAKE_MM_SEG(-1UL)
+#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x)	(current_thread_info()->addr_limit = (x))
+
+#define segment_eq(a, b)	((a).seg == (b).seg)
+
+/*
+ * Test whether a block of memory is a valid user space address.
+ * Returns 0 if the range is valid, nonzero otherwise.
+ *
+ * This is equivalent to the following test:
+ * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ *
+ * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
+ */
+
+#define __range_not_ok(addr, size)					\
+({									\
+	unsigned long flag, roksum;					\
+	__chk_user_ptr(addr);						\
+	asm("# range_ok\n\r"						\
+	    "add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
+	    : "=&r" (flag), "=r" (roksum)				\
+	    : "1" (addr), "g" ((long)(size)),				\
+	      "g" (current_thread_info()->addr_limit.seg));		\
+	flag;								\
+})
+
+/**
+ * access_ok: - Checks if a user space pointer is valid
+ * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
+ *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
+ *        to write to a block, it is always safe to read from it.
+ * @addr: User space pointer to start of block to check
+ * @size: Size of block to check
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Checks if a pointer to a block of memory in user space is valid.
+ *
+ * Returns true (nonzero) if the memory block may be valid, false (zero)
+ * if it is definitely invalid.
+ *
+ * Note that, depending on architecture, this function probably just
+ * checks that the pointer is in the user space range - after calling
+ * this function, memory access functions may still return -EFAULT.
+ */
+#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
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
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ *
+ * This gets kind of ugly. We want to return _two_ values in "get_user()"
+ * and yet we don't want to do any pointers, because that is too much
+ * of a performance impact. Thus we have a few rather ugly macros here,
+ * and hide all the ugliness from the user.
+ *
+ * The "__xxx" versions of the user access functions are versions that
+ * do not verify the address space, that must have been done previously
+ * with a separate "access_ok()" call (this is used when we do multiple
+ * accesses to the same area of user memory).
+ */
+
+extern int __get_user_1(void);
+extern int __get_user_2(void);
+extern int __get_user_4(void);
+extern int __get_user_8(void);
+extern int __get_user_bad(void);
+
+#define __get_user_x(size, ret, x, ptr)		      \
+	asm volatile("call __get_user_" #size	      \
+		     : "=a" (ret),"=d" (x)	      \
+		     : "0" (ptr))		      \
+
 #ifdef CONFIG_X86_32
 # include "uaccess_32.h"
 #else
 # include "uaccess_64.h"
 #endif
+
+#endif
diff --git a/include/asm-x86/uaccess_32.h b/include/asm-x86/uaccess_32.h
index 9884f50..92ad19e 100644
--- a/include/asm-x86/uaccess_32.h
+++ b/include/asm-x86/uaccess_32.h
@@ -11,29 +11,6 @@
 #include <asm/asm.h>
 #include <asm/page.h>
 
-#define VERIFY_READ 0
-#define VERIFY_WRITE 1
-
-/*
- * The fs value determines whether argument validity checking should be
- * performed or not.  If get_fs() == USER_DS, checking is performed, with
- * get_fs() == KERNEL_DS, checking is bypassed.
- *
- * For historical reasons, these macros are grossly misnamed.
- */
-
-#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
-
-
-#define KERNEL_DS	MAKE_MM_SEG(-1UL)
-#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
-
-#define get_ds()	(KERNEL_DS)
-#define get_fs()	(current_thread_info()->addr_limit)
-#define set_fs(x)	(current_thread_info()->addr_limit = (x))
-
-#define segment_eq(a, b)	((a).seg == (b).seg)
-
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
@@ -47,91 +24,6 @@ extern struct movsl_mask {
 	((unsigned long __force)(addr) <		\
 	 (current_thread_info()->addr_limit.seg))
 
-/*
- * Test whether a block of memory is a valid user space address.
- * Returns 0 if the range is valid, nonzero otherwise.
- *
- * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg
- *
- * This needs 33-bit arithmetic. We have a carry...
- */
-#define __range_not_ok(addr, size)					\
-({									\
-	unsigned long flag, roksum;					\
-	__chk_user_ptr(addr);						\
-	asm("add %3,%1 ; sbb %0,%0; cmp %1,%4; sbb $0,%0"		\
-	    :"=&r" (flag), "=r" (roksum)				\
-	    :"1" (addr), "g" ((int)(size)),				\
-	    "rm" (current_thread_info()->addr_limit.seg));		\
-	flag;								\
-})
-
-/**
- * access_ok: - Checks if a user space pointer is valid
- * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
- *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
- *        to write to a block, it is always safe to read from it.
- * @addr: User space pointer to start of block to check
- * @size: Size of block to check
- *
- * Context: User context only.  This function may sleep.
- *
- * Checks if a pointer to a block of memory in user space is valid.
- *
- * Returns true (nonzero) if the memory block may be valid, false (zero)
- * if it is definitely invalid.
- *
- * Note that, depending on architecture, this function probably just
- * checks that the pointer is in the user space range - after calling
- * this function, memory access functions may still return -EFAULT.
- */
-#define access_ok(type, addr, size) (likely(__range_not_ok(addr, size) == 0))
-
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
-struct exception_table_entry {
-	unsigned long insn, fixup;
-};
-
-extern int fixup_exception(struct pt_regs *regs);
-
-/*
- * These are the main single-value transfer routines.  They automatically
- * use the right size if we just have the right pointer type.
- *
- * This gets kind of ugly. We want to return _two_ values in "get_user()"
- * and yet we don't want to do any pointers, because that is too much
- * of a performance impact. Thus we have a few rather ugly macros here,
- * and hide all the ugliness from the user.
- *
- * The "__xxx" versions of the user access functions are versions that
- * do not verify the address space, that must have been done previously
- * with a separate "access_ok()" call (this is used when we do multiple
- * accesses to the same area of user memory).
- */
-
-extern void __get_user_1(void);
-extern void __get_user_2(void);
-extern void __get_user_4(void);
-
-#define __get_user_x(size, ret, x, ptr)	      \
-	asm volatile("call __get_user_" #size \
-		     :"=a" (ret),"=d" (x)     \
-		     :"0" (ptr))
-
-
 /* Careful: we have to cast the result to the type of the pointer
  * for sign reasons */
 
@@ -386,8 +278,6 @@ struct __large_struct { unsigned long buf[100]; };
 	__gu_err;							\
 })
 
-extern long __get_user_bad(void);
-
 #define __get_user_size(x, ptr, size, retval, errret)			\
 do {									\
 	retval = 0;							\
diff --git a/include/asm-x86/uaccess_64.h b/include/asm-x86/uaccess_64.h
index d607fd0..243dbb4 100644
--- a/include/asm-x86/uaccess_64.h
+++ b/include/asm-x86/uaccess_64.h
@@ -9,89 +9,11 @@
 #include <linux/prefetch.h>
 #include <asm/page.h>
 
-#define VERIFY_READ 0
-#define VERIFY_WRITE 1
-
-/*
- * The fs value determines whether argument validity checking should be
- * performed or not.  If get_fs() == USER_DS, checking is performed, with
- * get_fs() == KERNEL_DS, checking is bypassed.
- *
- * For historical reasons, these macros are grossly misnamed.
- */
-
-#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
-
-#define KERNEL_DS	MAKE_MM_SEG(-1UL)
-#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
-
-#define get_ds()	(KERNEL_DS)
-#define get_fs()	(current_thread_info()->addr_limit)
-#define set_fs(x)	(current_thread_info()->addr_limit = (x))
-
-#define segment_eq(a, b)	((a).seg == (b).seg)
-
 #define __addr_ok(addr) (!((unsigned long)(addr) &			\
 			   (current_thread_info()->addr_limit.seg)))
 
-/*
- * Uhhuh, this needs 65-bit arithmetic. We have a carry..
- */
-#define __range_not_ok(addr, size)					\
-({									\
-	unsigned long flag, roksum;					\
-	__chk_user_ptr(addr);						\
-	asm("# range_ok\n\r"						\
-	    "add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
-	    : "=&r" (flag), "=r" (roksum)				\
-	    : "1" (addr), "g" ((long)(size)),				\
-	      "g" (current_thread_info()->addr_limit.seg));		\
-	flag;								\
-})
-
-#define access_ok(type, addr, size) (__range_not_ok(addr, size) == 0)
-
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-
-struct exception_table_entry {
-	unsigned long insn, fixup;
-};
-
-extern int fixup_exception(struct pt_regs *regs);
-
 #define ARCH_HAS_SEARCH_EXTABLE
 
-/*
- * These are the main single-value transfer routines.  They automatically
- * use the right size if we just have the right pointer type.
- *
- * This gets kind of ugly. We want to return _two_ values in "get_user()"
- * and yet we don't want to do any pointers, because that is too much
- * of a performance impact. Thus we have a few rather ugly macros here,
- * and hide all the ugliness from the user.
- *
- * The "__xxx" versions of the user access functions are versions that
- * do not verify the address space, that must have been done previously
- * with a separate "access_ok()" call (this is used when we do multiple
- * accesses to the same area of user memory).
- */
-
-#define __get_user_x(size, ret, x, ptr)		      \
-	asm volatile("call __get_user_" #size	      \
-		     : "=a" (ret),"=d" (x)	      \
-		     : "0" (ptr))		      \
-
 /* Careful: we have to cast the result to the type of the pointer
  * for sign reasons */
 
@@ -227,12 +149,6 @@ struct __large_struct { unsigned long buf[100]; };
 	__gu_err;						\
 })
 
-extern int __get_user_1(void);
-extern int __get_user_2(void);
-extern int __get_user_4(void);
-extern int __get_user_8(void);
-extern int __get_user_bad(void);
-
 #define __get_user_size(x, ptr, size, retval)				\
 do {									\
 	retval = 0;							\
-- 
1.5.5.1

