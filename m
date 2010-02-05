Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab0BEOh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:37:57 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:50636 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab0BEOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rtGp1AQr65T5TsyXxjdH1GbQ/TOxFv9ofMuaejO/AQt4sOEYfNFkfUazaQGhjD20sR
         bwTFssguywOKnpO1SodKliRB0+OZpzU4zrh3WIu7+lNBl/HZiRrNxUm4sBnpQ5utU6zC
         +1gDrfACpnTQ4rR4TIc5Untni1uyUATqB3aBQ=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] x86: Clean up mem*io functions.
Date: Fri,  5 Feb 2010 09:37:07 -0500
Message-Id: <1265380629-3212-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iomem has no special significance on x86.  Use the standard mem*
functions instead of trying to call other versions.  Some fixups
are needed to match the function prototypes.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/boot/compressed/misc.c |   13 ++++---------
 arch/x86/include/asm/io_32.h    |   10 +++++-----
 arch/x86/include/asm/io_64.h    |   22 +++++++++++++---------
 arch/x86/lib/Makefile           |    2 +-
 arch/x86/lib/io_64.c            |   25 -------------------------
 5 files changed, 23 insertions(+), 49 deletions(-)
 delete mode 100644 arch/x86/lib/io_64.c

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
-- 
1.6.6

