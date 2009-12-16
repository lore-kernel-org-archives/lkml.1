Return-Path: <linux-kernel-owner+w=401wt.eu-S934727AbZLPILV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934727AbZLPILV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZLPIKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:10:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1210 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761763AbZLPIJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:09:17 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] kernel.h: Kernel address utility aggregation and other neatening
Date: Wed, 16 Dec 2009 00:09:12 -0800
Message-Id: <944beaa0ec67ae4eed36fb70b1f0b9cef3859ede.1260949674.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260949674.git.joe@perches.com>
References: <cover.1260949674.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group the address utilities
Move upper_32_bits and lower_32_bits to math and limits group
Add a few new group headers
	panic and oops
	shutdown
	string parsing
	sysinfo

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |   69 +++++++++++++++++++++++++++++++----------------
 1 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7d7f7e2..0fd5949 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -32,8 +32,6 @@
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
 
-#define STACK_MAGIC	0xdeadbeef
-
 #define __ALIGN_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 #define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a) - 1)
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
@@ -51,9 +49,6 @@
 	(((x) + ((__divisor) / 2)) / (__divisor));	\
 })
 
-#define _RET_IP_	(unsigned long)__builtin_return_address(0)
-#define _THIS_IP_	({ __label__ __here; __here: (unsigned long)&&__here; })
-
 #ifdef CONFIG_LBDAF
 # include <asm/div64.h>
 # define sector_div(a, b) do_div(a, b)
@@ -67,22 +62,6 @@
 })
 #endif
 
-/**
- * upper_32_bits - return bits 32-63 of a number
- * @n: the number we're accessing
- *
- * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
- * the "right shift count >= width of type" warning when that quantity is
- * 32-bits.
- */
-#define upper_32_bits(n)	((u32)(((n) >> 16) >> 16))
-
-/**
- * lower_32_bits - return bits 0-31 of a number
- * @n: the number we're accessing
- */
-#define lower_32_bits(n)	((u32)(n))
-
 struct completion;
 struct pt_regs;
 struct user;
@@ -124,6 +103,9 @@ static inline void might_fault(void)
 }
 #endif
 
+/*
+ * panic and oops support
+ */
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 extern void panic(const char *fmt, ...)
@@ -131,6 +113,10 @@ extern void panic(const char *fmt, ...)
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
+
+/*
+ * shutdown support
+ */
 extern void do_exit(long code)
 	__attribute__ ((noreturn));
 extern void complete_and_exit(struct completion *comp, long code)
@@ -176,15 +162,28 @@ extern int sscanf(const char *buf, const char *fmt, ...)
 extern int vsscanf(const char *buf, const char *fmt, va_list)
 	__attribute__ ((format (scanf, 2, 0)));
 
+/*
+ * String parsing
+ */
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+		/*parse a string with mem suffixes into a number */
 
+/*
+ * Kernel address utils
+ */
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
+#define _RET_IP_	(unsigned long)__builtin_return_address(0)
+#define _THIS_IP_	({ __label__ __here; __here: (unsigned long)&&__here; })
+#define STACK_MAGIC	0xdeadbeef
 
+/*
+ * Process ID and process group
+ */
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
@@ -221,6 +220,9 @@ extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int root_mountflags;
 
+/*
+ * Hex to ascii helpers
+ */
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
@@ -244,6 +246,22 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 
 unsigned long int_sqrt(unsigned long);
 
+/**
+ * upper_32_bits - return bits 32-63 of a number
+ * @n: the number we're accessing
+ *
+ * A basic shift-right of a 64- or 32-bit quantity.  Use this to suppress
+ * the "right shift count >= width of type" warning when that quantity is
+ * 32-bits.
+ */
+#define upper_32_bits(n)	((u32)(((n) >> 16) >> 16))
+
+/**
+ * lower_32_bits - return bits 0-31 of a number
+ * @n: the number we're accessing
+ */
+#define lower_32_bits(n)	((u32)(n))
+
 /*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
@@ -362,9 +380,6 @@ unsigned long int_sqrt(unsigned long);
 	(type *)((char *)__mptr - offsetof(type, member));	\
 })
 
-struct sysinfo;
-extern int do_sysinfo(struct sysinfo *info);
-
 /*
  * Console and logging support
  */
@@ -776,6 +791,12 @@ ftrace_vprintk(const char *fmt, va_list ap)
 static inline void ftrace_dump(void) { }
 #endif /* CONFIG_TRACING */
 
+/*
+ * sysinfo support
+ */
+struct sysinfo;
+extern int do_sysinfo(struct sysinfo *info);
+
 #endif /* __KERNEL__ */
 
 #ifndef __EXPORTED_HEADERS__
-- 
1.6.6.rc0.57.gad7a

