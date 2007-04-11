Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbXDKIyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbXDKIyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXDKIxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:54 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1564 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXDKIx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:29 -0400
Date: Wed, 11 Apr 2007 12:28:41 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] ALPHA: build fixes - force architecture, eliminate wastage
Message-ID: <20070411122841.C17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files:

arch/alpha/kernel/sys_titan.c

	Request EV67 since no TITAN-based machine is any less, or see errors.

include/asm-alpha/compiler.h

	Request EV56 so we're sure to get what we want, or see errors.

include/asm-alpha/module.h

	Stop all the wasted/worthless "got" messages.


Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

---

diff -Naurp a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c	2007-02-04 13:44:54.000000000 -0500
+++ b/arch/alpha/kernel/sys_titan.c	2007-02-14 16:32:30.000000000 -0500
@@ -257,7 +257,7 @@ titan_dispatch_irqs(u64 mask)
 	 */
 	while (mask) {
 		/* convert to SRM vector... priority is <63> -> <0> */
-		__asm__("ctlz %1, %0" : "=r"(vector) : "r"(mask));
+		__asm__(".arch ev67; ctlz %1, %0" : "=r"(vector) : "r"(mask));
 		vector = 63 - vector;
 		mask &= ~(1UL << vector);	/* clear it out 	 */
 		vector = 0x900 + (vector << 4);	/* convert to SRM vector */
diff -Naurp a/include/asm-alpha/compiler.h b/include/asm-alpha/compiler.h
--- a/include/asm-alpha/compiler.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/compiler.h	2007-02-14 16:32:30.000000000 -0500
@@ -78,16 +78,20 @@
 #else
 #define __kernel_ldbu(mem)				\
   ({ unsigned char __kir;				\
-     __asm__("ldbu %0,%1" : "=r"(__kir) : "m"(mem));	\
+     __asm__(".arch ev56;				\
+             ldbu %0,%1" : "=r"(__kir) : "m"(mem));	\
      __kir; })
 #define __kernel_ldwu(mem)				\
   ({ unsigned short __kir;				\
-     __asm__("ldwu %0,%1" : "=r"(__kir) : "m"(mem));	\
+     __asm__(".arch ev56;				\
+             ldwu %0,%1" : "=r"(__kir) : "m"(mem));	\
      __kir; })
-#define __kernel_stb(val,mem) \
-  __asm__("stb %1,%0" : "=m"(mem) : "r"(val))
-#define __kernel_stw(val,mem) \
-  __asm__("stw %1,%0" : "=m"(mem) : "r"(val))
+#define __kernel_stb(val,mem)				\
+  __asm__(".arch ev56;					\
+          stb %1,%0" : "=m"(mem) : "r"(val))
+#define __kernel_stw(val,mem)				\
+  __asm__(".arch ev56;					\
+          stw %1,%0" : "=m"(mem) : "r"(val))
 #endif
 
 #ifdef __KERNEL__
diff -Naurp a/include/asm-alpha/module.h b/include/asm-alpha/module.h
--- a/include/asm-alpha/module.h	2007-02-04 13:44:54.000000000 -0500
+++ b/include/asm-alpha/module.h	2007-02-14 14:40:02.000000000 -0500
@@ -17,7 +17,7 @@ struct mod_arch_specific
 #define ARCH_SHF_SMALL SHF_ALPHA_GPREL
 
 #ifdef MODULE
-asm(".section .got,\"aws\",@progbits; .align 3; .previous");
+asm(".section .got,\"aw\",@progbits; .align 3; .previous");
 #endif
 
 #endif /*_ALPHA_MODULE_H*/
