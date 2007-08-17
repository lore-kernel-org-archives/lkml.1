Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbXHQXgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbXHQXgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbXHQXfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:35:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905AbXHQXfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:35:53 -0400
Date: Fri, 17 Aug 2007 16:34:46 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86-64: memset optimization
Message-ID: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize uses of memset with small constant offsets.
This will generate smaller code, and avoid the slow rep/string instructions.
Code copied from i386 with a little cleanup.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/include/asm-x86_64/string.h	2007-08-17 15:14:32.000000000 -0700
+++ b/include/asm-x86_64/string.h	2007-08-17 15:36:30.000000000 -0700
@@ -42,9 +42,51 @@ extern void *__memcpy(void *to, const vo
 		 __ret = __builtin_memcpy((dst),(src),__len);	\
 	   __ret; }) 
 #endif
-
 #define __HAVE_ARCH_MEMSET
-void *memset(void *s, int c, size_t n);
+void *__memset(void *s, int c, size_t n);
+
+/* Optimize for cases of trivial memset's
+ * Compiler should optimize away all but the case used.
+ */
+static __always_inline void *
+__constant_c_and_count_memset(void *s, int c, size_t count)
+{
+	unsigned long pattern = 0x01010101UL * (unsigned char) c;
+
+	switch (count) {
+	case 0:
+		return s;
+	case 1:
+		*(unsigned char *)s = pattern;
+		return s;
+	case 2:
+		*(unsigned short *)s = pattern;
+		return s;
+	case 3:
+		*(unsigned short *)s = pattern;
+		*(2+(unsigned char *)s) = pattern;
+		return s;
+	case 4:
+		*(unsigned long *)s = pattern;
+		return s;
+	case 6:
+		*(unsigned long *)s = pattern;
+		*(2+(unsigned short *)s) = pattern;
+		return s;
+	case 8:
+		*(unsigned long *)s = pattern;
+		*(1+(unsigned long *)s) = pattern;
+		return s;
+	default:
+		return __memset(s, c, count);
+	}
+}
+#define memset(s, c, count)					\
+	(__builtin_constant_p(c)				\
+	 ? __constant_c_and_count_memset((s),(c),(count))	\
+	 : __memset((s),(c),(count)))
+
+
 
 #define __HAVE_ARCH_MEMMOVE
 void * memmove(void * dest,const void *src,size_t count);
--- a/arch/x86_64/kernel/x8664_ksyms.c	2007-08-17 15:14:32.000000000 -0700
+++ b/arch/x86_64/kernel/x8664_ksyms.c	2007-08-17 15:44:58.000000000 -0700
@@ -48,10 +48,12 @@ EXPORT_SYMBOL(__read_lock_failed);
 #undef memmove
 
 extern void * memset(void *,int,__kernel_size_t);
+extern void * __memset(void *,int,__kernel_size_t);
 extern void * memcpy(void *,const void *,__kernel_size_t);
 extern void * __memcpy(void *,const void *,__kernel_size_t);
 
 EXPORT_SYMBOL(memset);
+EXPORT_SYMBOL(__memset);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__memcpy);
 
