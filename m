Return-Path: <linux-kernel-owner+w=401wt.eu-S1945928AbXDLIBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945928AbXDLIBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945930AbXDLIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:01:12 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1608 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945928AbXDLIBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:01:11 -0400
Date: Thu, 12 Apr 2007 12:01:10 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ALPHA: build fixes - force architecture (take 2)
Message-ID: <20070412120110.A25812@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[CIX stuff reworked, .got change dropped as Richard suggested]

Override compiler .arch directive for generic kernel build.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

--- linux.orig/arch/alpha/kernel/sys_titan.c	Thu Apr 12 01:19:47 2007
+++ linux/arch/alpha/kernel/sys_titan.c	Thu Apr 12 01:40:19 2007
@@ -257,8 +257,7 @@ titan_dispatch_irqs(u64 mask)
 	 */
 	while (mask) {
 		/* convert to SRM vector... priority is <63> -> <0> */
-		__asm__("ctlz %1, %0" : "=r"(vector) : "r"(mask));
-		vector = 63 - vector;
+		vector = 63 - __kernel_ctlz(mask);
 		mask &= ~(1UL << vector);	/* clear it out 	 */
 		vector = 0x900 + (vector << 4);	/* convert to SRM vector */
 		
--- linux.orig/include/asm-alpha/compiler.h	Thu Apr 12 01:19:47 2007
+++ linux/include/asm-alpha/compiler.h	Thu Apr 12 01:37:01 2007
@@ -17,9 +17,6 @@
 # define __kernel_extbl(val, shift)	__builtin_alpha_extbl(val, shift)
 # define __kernel_extwl(val, shift)	__builtin_alpha_extwl(val, shift)
 # define __kernel_cmpbge(a, b)		__builtin_alpha_cmpbge(a, b)
-# define __kernel_cttz(x)		__builtin_ctzl(x)
-# define __kernel_ctlz(x)		__builtin_clzl(x)
-# define __kernel_ctpop(x)		__builtin_popcountl(x)
 #else
 # define __kernel_insbl(val, shift)					\
   ({ unsigned long __kir;						\
@@ -49,17 +46,39 @@
   ({ unsigned long __kir;						\
      __asm__("cmpbge %r2,%1,%0" : "=r"(__kir) : "rI"(b), "rJ"(a));	\
      __kir; })
+#endif
+
+#ifdef __alpha_cix__
+# if __GNUC__ == 3 && __GNUC_MINOR__ >= 4 || __GNUC__ > 3
+#  define __kernel_cttz(x)		__builtin_ctzl(x)
+#  define __kernel_ctlz(x)		__builtin_clzl(x)
+#  define __kernel_ctpop(x)		__builtin_popcountl(x)
+# else
+#  define __kernel_cttz(x)						\
+   ({ unsigned long __kir;						\
+      __asm__("cttz %1,%0" : "=r"(__kir) : "r"(x));			\
+      __kir; })
+#  define __kernel_ctlz(x)						\
+   ({ unsigned long __kir;						\
+      __asm__("ctlz %1,%0" : "=r"(__kir) : "r"(x));			\
+      __kir; })
+#  define __kernel_ctpop(x)						\
+   ({ unsigned long __kir;						\
+      __asm__("ctpop %1,%0" : "=r"(__kir) : "r"(x));			\
+      __kir; })
+# endif
+#else
 # define __kernel_cttz(x)						\
   ({ unsigned long __kir;						\
-     __asm__("cttz %1,%0" : "=r"(__kir) : "r"(x));			\
+     __asm__(".arch ev67; cttz %1,%0" : "=r"(__kir) : "r"(x));		\
      __kir; })
 # define __kernel_ctlz(x)						\
   ({ unsigned long __kir;						\
-     __asm__("ctlz %1,%0" : "=r"(__kir) : "r"(x));			\
+     __asm__(".arch ev67; ctlz %1,%0" : "=r"(__kir) : "r"(x));		\
      __kir; })
 # define __kernel_ctpop(x)						\
   ({ unsigned long __kir;						\
-     __asm__("ctpop %1,%0" : "=r"(__kir) : "r"(x));			\
+     __asm__(".arch ev67; ctpop %1,%0" : "=r"(__kir) : "r"(x));		\
      __kir; })
 #endif
 
@@ -78,16 +97,20 @@
 #else
 #define __kernel_ldbu(mem)				\
   ({ unsigned char __kir;				\
-     __asm__("ldbu %0,%1" : "=r"(__kir) : "m"(mem));	\
+     __asm__(".arch ev56;				\
+	      ldbu %0,%1" : "=r"(__kir) : "m"(mem));	\
      __kir; })
 #define __kernel_ldwu(mem)				\
   ({ unsigned short __kir;				\
-     __asm__("ldwu %0,%1" : "=r"(__kir) : "m"(mem));	\
+     __asm__(".arch ev56;				\
+	      ldwu %0,%1" : "=r"(__kir) : "m"(mem));	\
      __kir; })
-#define __kernel_stb(val,mem) \
-  __asm__("stb %1,%0" : "=m"(mem) : "r"(val))
-#define __kernel_stw(val,mem) \
-  __asm__("stw %1,%0" : "=m"(mem) : "r"(val))
+#define __kernel_stb(val,mem)				\
+  __asm__(".arch ev56;					\
+	   stb %1,%0" : "=m"(mem) : "r"(val))
+#define __kernel_stw(val,mem)				\
+  __asm__(".arch ev56;					\
+	   stw %1,%0" : "=m"(mem) : "r"(val))
 #endif
 
 #ifdef __KERNEL__
