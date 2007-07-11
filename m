Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbXGKUaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbXGKUaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759930AbXGKUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:30:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:54893 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238AbXGKUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:30:03 -0400
Message-ID: <46953DB8.6080008@zytor.com>
Date: Wed, 11 Jul 2007 13:29:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: x86 setup code rewrite in C - revised
References: <1184181538674-git-send-email-hpa@zytor.com> <469538A9.4010202@garzik.org>
In-Reply-To: <469538A9.4010202@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------050402070301040509050305"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050402070301040509050305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> 
> I'm sure you know what's changed since the last revision, but nobody
> everybody does :)  It would be nice to know what's different from the
> last posting.
> 

- Added -fno-toplevel-reorder/-fno-unit-at-a-time to the Makefile; this
  is necessary for .code16gcc to be safe on all current versions of gcc.
  Added comment to that effect to code16gcc.h.
- Moved strnlen, atou and isdigit out of printf.c.
- Corrected title of cpu.c and cpucheck.c.
- Fixed "paragraps" typo in pm.c.
- Removed bogus <linux/edd.h> in string.c.
- Removed #include <linux/mmzone.h> from asm-x86/e820.h; according to
  Andi it isn't needed even for non-_SETUP, and my compile testing seems
  to confirm that.

Full diff attached.

	-hpa



--------------050402070301040509050305
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/Makefile b/arch/i386/boot/Makefile
index e9f46fd..08678a0 100644
--- a/arch/i386/boot/Makefile
+++ b/arch/i386/boot/Makefile
@@ -57,6 +57,8 @@ CFLAGS		:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 		   -include $(srctree)/$(src)/code16gcc.h \
 		   -fno-strict-aliasing -fomit-frame-pointer \
 		   $(call cc-option, -ffreestanding) \
+		   $(call cc-option, -fno-toplevel-reorder,\
+			$(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 AFLAGS		:= $(CFLAGS) -D__ASSEMBLY__
diff --git a/arch/i386/boot/boot.h b/arch/i386/boot/boot.h
index 7251ef6..0329c4f 100644
--- a/arch/i386/boot/boot.h
+++ b/arch/i386/boot/boot.h
@@ -192,6 +192,11 @@ static inline int memcmp_gs(const void *s1, addr_t s2, size_t len)
 	return diff;
 }
 
+static inline int isdigit(int ch)
+{
+	return (ch >= '0') && (ch <= '9');
+}
+
 /* Heap -- available for dynamic lists. */
 #define STACK_SIZE	512	/* Minimum number of bytes for stack */
 
@@ -261,13 +266,14 @@ void __attribute__((noreturn))
 	protected_mode_jump(u32 entrypoint, u32 bootparams);
 
 /* printf.c */
-unsigned int atou(const char *s);
 int sprintf(char *buf, const char *fmt, ...);
 int vsprintf(char *buf, const char *fmt, va_list args);
 int printf(const char *fmt, ...);
 
 /* string.c */
 int strcmp(const char *str1, const char *str2);
+size_t strnlen(const char *s, size_t maxlen);
+unsigned int atou(const char *s);
 
 /* tty.c */
 void puts(const char *);
diff --git a/arch/i386/boot/code16gcc.h b/arch/i386/boot/code16gcc.h
index dbc6414..3bd8480 100644
--- a/arch/i386/boot/code16gcc.h
+++ b/arch/i386/boot/code16gcc.h
@@ -2,6 +2,12 @@
  * code16gcc.h
  *
  * This file is -include'd when compiling 16-bit C code.
+ * Note: this asm() needs to be emitted before gcc omits any code.
+ * Depending on gcc version, this requires -fno-unit-at-a-time or
+ * -fno-toplevel-reorder.
+ *
+ * Hopefully gcc will eventually have a real -m16 option so we can
+ * drop this hack long term.
  */
 
 #ifndef __ASSEMBLY__
diff --git a/arch/i386/boot/cpu.c b/arch/i386/boot/cpu.c
index 042d894..2a5c32d 100644
--- a/arch/i386/boot/cpu.c
+++ b/arch/i386/boot/cpu.c
@@ -9,7 +9,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * arch/i386/boot/cpucheck.c
+ * arch/i386/boot/cpu.c
  *
  * Check for obligatory CPU features and abort if the features are not
  * present.
diff --git a/arch/i386/boot/cpucheck.c b/arch/i386/boot/cpucheck.c
index 431bef8..8b0f447 100644
--- a/arch/i386/boot/cpucheck.c
+++ b/arch/i386/boot/cpucheck.c
@@ -9,7 +9,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * arch/i386/boot/cpu.c
+ * arch/i386/boot/cpucheck.c
  *
  * Check for obligatory CPU features and abort if the features are not
  * present.  This code should be compilable as 16-, 32- or 64-bit
diff --git a/arch/i386/boot/pm.c b/arch/i386/boot/pm.c
index 4deb298..3fa53e1 100644
--- a/arch/i386/boot/pm.c
+++ b/arch/i386/boot/pm.c
@@ -49,7 +49,7 @@ static void move_kernel_around(void)
 
 	dst_seg =  0x1000 >> 4;
 	src_seg = 0x10000 >> 4;
-	syssize = boot_params.hdr.syssize; /* Size in 16-byte paragraps */
+	syssize = boot_params.hdr.syssize; /* Size in 16-byte paragraphs */
 
 	while (syssize) {
 		int paras  = (syssize >= 0x1000) ? 0x1000 : syssize;
diff --git a/arch/i386/boot/printf.c b/arch/i386/boot/printf.c
index ee3d9fc..1a09f93 100644
--- a/arch/i386/boot/printf.c
+++ b/arch/i386/boot/printf.c
@@ -19,11 +19,6 @@
 
 #include "boot.h"
 
-static inline int isdigit(int ch)
-{
-	return (ch >= '0') && (ch <= '9');
-}
-
 static int skip_atoi(const char **s)
 {
 	int i = 0;
@@ -33,25 +28,6 @@ static int skip_atoi(const char **s)
 	return i;
 }
 
-unsigned int atou(const char *s)
-{
-	unsigned int i = 0;
-	while (isdigit(*s))
-		i = i * 10 + (*s++ - '0');
-	return i;
-}
-
-static int strnlen(const char *s, int maxlen)
-{
-	const char *es = s;
-	while (*es && maxlen) {
-		es++;
-		maxlen--;
-	}
-
-	return (es - s);
-}
-
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
diff --git a/arch/i386/boot/string.c b/arch/i386/boot/string.c
index 0808197..481a220 100644
--- a/arch/i386/boot/string.c
+++ b/arch/i386/boot/string.c
@@ -15,7 +15,6 @@
  */
 
 #include "boot.h"
-#include <linux/edd.h>
 
 int strcmp(const char *str1, const char *str2)
 {
@@ -32,3 +31,22 @@ int strcmp(const char *str1, const char *str2)
 	}
 	return 0;
 }
+
+size_t strnlen(const char *s, size_t maxlen)
+{
+	const char *es = s;
+	while (*es && maxlen) {
+		es++;
+		maxlen--;
+	}
+
+	return (es - s);
+}
+
+unsigned int atou(const char *s)
+{
+	unsigned int i = 0;
+	while (isdigit(*s))
+		i = i * 10 + (*s++ - '0');
+	return i;
+}
diff --git a/include/asm-x86_64/e820.h b/include/asm-x86_64/e820.h
index 15eb8e2..3486e70 100644
--- a/include/asm-x86_64/e820.h
+++ b/include/asm-x86_64/e820.h
@@ -11,10 +11,6 @@
 #ifndef __E820_HEADER
 #define __E820_HEADER
 
-#ifndef _SETUP
-# include <linux/mmzone.h>
-#endif
-
 #define E820MAP	0x2d0		/* our map */
 #define E820MAX	128		/* number of entries in E820MAP */
 #define E820NR	0x1e8		/* # entries in E820MAP */

--------------050402070301040509050305--
