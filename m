Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbXDUXYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbXDUXYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 19:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXDUXYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 19:24:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:49175 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXDUXY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 19:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fA+vRhYMmOSuiyzPahHaZH9BZ4+ZYvDj//XLafPoh0p5Ch/wfGBxLazIBgmqBR3VWyvA/ltetZzcp7mlZ73G6a5UdKYGlbKj4jMSrRzpbI8Ib4VJTszlO70TgDONCPMDLb9LXFqe1uKtrf9asppxw0IjWpVypNklqr8jG1ZWIkI=
Date: Sun, 22 Apr 2007 03:26:00 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFCPT] CONFIG_DEBUG_MEMCPY: memcpy() and overlapping areas
Message-ID: <20070421232600.GA5844@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Overlapping areas are subject to memmove() not memcpy().

CONFIG_DEBUG_MEMCPY will print pointers and length in question as well as
backtrace to logs. Also, it should help if one of 3 variables got
corrupted somehow and you were lucky enough.

So far it was booted successfully on one x86_64 box and spit a couple of test
overlapping memcpy() becktraces, which means it's ready.
---

 arch/x86_64/lib/memmove.c   |    8 ++++++++
 include/asm-x86_64/string.h |    9 +++++++++
 lib/Kconfig.debug           |    6 ++++++
 3 files changed, 23 insertions(+)

--- a/arch/x86_64/lib/memmove.c
+++ b/arch/x86_64/lib/memmove.c
@@ -9,7 +9,15 @@
 void *memmove(void * dest,const void *src,size_t count)
 {
 	if (dest < src) { 
+#ifdef CONFIG_DEBUG_MEMCPY
+		char *d = dest;
+		const char *s = src;
+		while (count--)
+			*d++ = *s++;
+		return dest;
+#else
 		return memcpy(dest,src,count);
+#endif
 	} else {
 		char *p = (char *) dest + count;
 		char *s = (char *) src + count;
--- a/include/asm-x86_64/string.h
+++ b/include/asm-x86_64/string.h
@@ -3,6 +3,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/kernel.h>
+
 /* Written 2002 by Andi Kleen */ 
 
 /* Only used for special circumstances. Stolen from i386/string.h */ 
@@ -32,6 +34,13 @@ return (to);
 extern void *__memcpy(void *to, const void *from, size_t len); 
 static inline void *memcpy(void *dst, const void *src, size_t len)
 {
+#ifdef CONFIG_DEBUG_MEMCPY
+	if ((src < dst && src + len > dst) ||
+	    (src > dst && dst + len > src)) {
+		printk("memcpy(0x%p, 0x%p, %zu);\n", dst, src, len);
+		WARN_ON(1);
+	}
+#endif
 	if (__builtin_constant_p(len) && len >= 64)
 		return __memcpy(dst, src, len);
 	else
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -355,6 +355,12 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_MEMCPY
+	bool "Debug memcpy() function calls"
+	depends on DEBUG_KERNEL
+	help
+	  Enable checking for memcpy() on overlapping areas.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH)

