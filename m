Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab0BEWuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:50:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:37653 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933988Ab0BEWuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:50:09 -0500
Date: Fri, 5 Feb 2010 22:49:48 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1265380629-3212-6-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-6-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/io] x86: Clean up mem*io functions.
Message-ID: <tip-6175ddf06b6172046a329e3abfd9c901a43efd2e@git.kernel.org>
Git-Commit-ID: 6175ddf06b6172046a329e3abfd9c901a43efd2e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:49:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6175ddf06b6172046a329e3abfd9c901a43efd2e
Gitweb:     http://git.kernel.org/tip/6175ddf06b6172046a329e3abfd9c901a43efd2e
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 5 Feb 2010 09:37:07 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 13:57:33 -0800

x86: Clean up mem*io functions.

Iomem has no special significance on x86.  Use the standard mem*
functions instead of trying to call other versions.  Some fixups
are needed to match the function prototypes.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1265380629-3212-6-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc.c |   13 ++++---------
 arch/x86/include/asm/io_32.h    |   10 +++++-----
 arch/x86/include/asm/io_64.h    |   22 +++++++++++++---------
 arch/x86/lib/Makefile           |    2 +-
 arch/x86/lib/io_64.c            |   25 -------------------------
 5 files changed, 23 insertions(+), 49 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3b22fe8..88042e8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -19,11 +19,6 @@
 #define _ASM_X86_DESC_H 1
 #endif
 
-#ifdef CONFIG_X86_64
-#define _LINUX_STRING_H_ 1
-#define __LINUX_BITMAP_H 1
-#endif
-
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
 #include <linux/elf.h>
@@ -131,8 +126,8 @@ static void error(char *m);
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
 
-static void *memset(void *s, int c, unsigned n);
-void *memcpy(void *dest, const void *src, unsigned n);
+void *memset(void *s, int c, size_t n);
+void *memcpy(void *dest, const void *src, size_t n);
 
 static void __putstr(int, const char *);
 #define putstr(__x)  __putstr(0, __x)
@@ -223,7 +218,7 @@ static void __putstr(int error, const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-static void *memset(void *s, int c, unsigned n)
+void *memset(void *s, int c, size_t n)
 {
 	int i;
 	char *ss = s;
@@ -233,7 +228,7 @@ static void *memset(void *s, int c, unsigned n)
 	return s;
 }
 
-void *memcpy(void *dest, const void *src, unsigned n)
+void *memcpy(void *dest, const void *src, size_t n)
 {
 	int i;
 	const char *s = src;
diff --git a/arch/x86/include/asm/io_32.h b/arch/x86/include/asm/io_32.h
index 72a6a4a..685e332 100644
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -49,21 +49,21 @@
 #define xlate_dev_kmem_ptr(p)	p
 
 static inline void
-memset_io(volatile void __iomem *addr, unsigned char val, int count)
+memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
 {
 	memset((void __force *)addr, val, count);
 }
 
 static inline void
-memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
+memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
 {
-	__memcpy(dst, (const void __force *)src, count);
+	memcpy(dst, (const void __force *)src, count);
 }
 
 static inline void
-memcpy_toio(volatile void __iomem *dst, const void *src, int count)
+memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
 {
-	__memcpy((void __force *)dst, src, count);
+	memcpy((void __force *)dst, src, count);
 }
 
 /*
diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
index 4a94aef..1305525 100644
--- a/arch/x86/include/asm/io_64.h
+++ b/arch/x86/include/asm/io_64.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_IO_64_H
 #define _ASM_X86_IO_64_H
 
+#include <linux/string.h>
+#include <linux/compiler.h>
 
 /*
  * This file contains the definitions for the x86 IO instructions
@@ -46,20 +48,22 @@
  */
 #define xlate_dev_kmem_ptr(p)	p
 
-void memset_io(volatile void __iomem *a, int b, size_t c);
+static inline void
+memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
+{
+	memset((void __force *)addr, val, count);
+}
 
-void __memcpy_fromio(void *, unsigned long, unsigned);
-static inline void memcpy_fromio(void *to, const volatile void __iomem *from,
-				 unsigned len)
+static inline void
+memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
 {
-	__memcpy_fromio(to, (unsigned long)from, len);
+	memcpy(dst, (const void __force *)src, count);
 }
 
-void __memcpy_toio(unsigned long, const void *, unsigned);
-static inline void memcpy_toio(volatile void __iomem *to, const void *from,
-			       unsigned len)
+static inline void
+memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
 {
-	__memcpy_toio((unsigned long)to, from, len);
+	memcpy((void __force *)dst, src, count);
 }
 
 /*
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..fff1427 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -34,7 +34,7 @@ ifneq ($(CONFIG_X86_CMPXCHG64),y)
 endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
-        obj-y += io_64.o iomap_copy_64.o
+        obj-y += iomap_copy_64.o
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
diff --git a/arch/x86/lib/io_64.c b/arch/x86/lib/io_64.c
deleted file mode 100644
index 3f1eb59..0000000
--- a/arch/x86/lib/io_64.c
+++ /dev/null
@@ -1,25 +0,0 @@
-#include <linux/string.h>
-#include <linux/module.h>
-#include <asm/io.h>
-
-void __memcpy_toio(unsigned long dst, const void *src, unsigned len)
-{
-	__inline_memcpy((void *)dst, src, len);
-}
-EXPORT_SYMBOL(__memcpy_toio);
-
-void __memcpy_fromio(void *dst, unsigned long src, unsigned len)
-{
-	__inline_memcpy(dst, (const void *)src, len);
-}
-EXPORT_SYMBOL(__memcpy_fromio);
-
-void memset_io(volatile void __iomem *a, int b, size_t c)
-{
-	/*
-	 * TODO: memset can mangle the IO patterns quite a bit.
-	 * perhaps it would be better to use a dumb one:
-	 */
-	memset((void *)a, b, c);
-}
-EXPORT_SYMBOL(memset_io);
