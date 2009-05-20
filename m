Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbZETWOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbZETWOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZETWOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:14:36 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:64786 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZETWOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:14:35 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 18:14:35 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hLNBhqbWZLp1dFjp4EctPDr4eSruQnDgLOyGlm5Z6PDzr5GDPtpFlHm06vJGB7amef
         r0e6L85Ttp2fBhE24sKwJrKjNs3DRP/MWqQcQTOQnZrzxqexsTWgsog47nkJs7XkX2zm
         ykwIyGpAqwm2GgHxn0yxyo4yUm7PThZmlCJoE=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>, Yan hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org,
       Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>,
       Erwan Lerale <erwan@thiscow.com>
Subject: [loongson-PATCH-v1 27/27] add gcc 4.4 support for MIPS and loongson
Date: Thu, 21 May 2009 06:14:24 +0800
Message-Id: <1f9acd8e0b22859752d73ceb9a283d090b04db9c.1242855716.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1242855716.git.wuzhangjin@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

the gcc 4.4 support for MIPS mostly refer to this PATCH:
http://www.nabble.com/-PATCH--MIPS:-Handle-removal-of-%27h%27-constraint-in-GCC-4.4-td22192768.html
but have been tuned a little.

because only gcc 4.4 have loongson-specific support, so, we need to
choose the suitable -march argument for gcc <= 4.3 and gcc >= 4.4, and
we also need to consider use -march=loongson2e and -march=loongson2f for
loongson2e and loongson2f respectively. this is handled by adding two
new kernel options: CPU_LOONGSON2E and CPU_LOONGSON2F(thanks for the
solutin provided by ZhangLe).

I have tested it on FuLoong(2f) in 32bit and 64bit with gcc-4.4 and
gcc-4.3. so, basically, it works.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Makefile               |    9 +++++-
 arch/mips/include/asm/compiler.h |   10 ++++++
 arch/mips/include/asm/delay.h    |   58 +++++++++++++++++++++++++------------
 arch/mips/include/asm/div64.h    |   24 +++++++++++++--
 4 files changed, 77 insertions(+), 24 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 8bde363..f679731 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -119,7 +119,14 @@ cflags-$(CONFIG_CPU_R4300)	+= -march=r4300 -Wa,--trap
 cflags-$(CONFIG_CPU_VR41XX)	+= -march=r4100 -Wa,--trap
 cflags-$(CONFIG_CPU_R4X00)	+= -march=r4600 -Wa,--trap
 cflags-$(CONFIG_CPU_TX49XX)	+= -march=r4600 -Wa,--trap
-cflags-$(CONFIG_CPU_LOONGSON2)	+= -march=r4600 -Wa,--trap
+
+# only gcc >= 4.4 have the loongson-specific support
+cflags-$(CONFIG_CPU_LOONGSON2)	+= -Wa,--trap
+cflags-$(CONFIG_CPU_LOONGSON2E)	+= $(shell if [ $(call cc-version) -lt 0440 ] ; then \
+	echo $(call cc-option,-march=r4600); else echo $(call cc-option,-march=loongson2e); fi ;)
+cflags-$(CONFIG_CPU_LOONGSON2F)	+= $(shell if [ $(call cc-version) -lt 0440 ] ; then \
+	echo $(call cc-option,-march=r4600); else echo $(call cc-option,-march=loongson2f); fi ;)
+
 cflags-$(CONFIG_CPU_MIPS32_R1)	+= $(call cc-option,-march=mips32,-mips32 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
 			-Wa,-mips32 -Wa,--trap
 cflags-$(CONFIG_CPU_MIPS32_R2)	+= $(call cc-option,-march=mips32r2,-mips32r2 -U_MIPS_ISA -D_MIPS_ISA=_MIPS_ISA_MIPS32) \
diff --git a/arch/mips/include/asm/compiler.h b/arch/mips/include/asm/compiler.h
index 71f5c5c..95256a8 100644
--- a/arch/mips/include/asm/compiler.h
+++ b/arch/mips/include/asm/compiler.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2004, 2007  Maciej W. Rozycki
+ * Copyright (C) 2009  Wu Zhangjin, wuzj@lemote.com
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -16,4 +17,13 @@
 #define GCC_REG_ACCUM "accum"
 #endif
 
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4)
+#define GCC_NO_H_CONSTRAINT
+#ifdef CONFIG_64BIT
+typedef unsigned int uintx_t __attribute__((mode(TI)));
+#else
+typedef u64 uintx_t;
+#endif
+#endif
+
 #endif /* _ASM_COMPILER_H */
diff --git a/arch/mips/include/asm/delay.h b/arch/mips/include/asm/delay.h
index b0bccd2..00d7969 100644
--- a/arch/mips/include/asm/delay.h
+++ b/arch/mips/include/asm/delay.h
@@ -7,6 +7,7 @@
  * Copyright (C) 1995 - 2000, 01, 03 by Ralf Baechle
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  * Copyright (C) 2007  Maciej W. Rozycki
+ * Copyright (C) 2009  Wu Zhangjin, wuzj@lemote.com
  */
 #ifndef _ASM_DELAY_H
 #define _ASM_DELAY_H
@@ -48,6 +49,43 @@ static inline void __delay(unsigned long loops)
 		: "0" (loops), "r" (1));
 }
 
+/*
+ * convert usecs to loops
+ *
+ * handle removal of 'h' constraint in GCC 4.4
+ */
+
+#ifndef GCC_NO_H_CONSTRAINT	/* gcc <= 4.3 */
+static inline unsigned long __usecs_to_loops(unsigned long usecs,
+		unsigned long lpj)
+{
+	unsigned long hi, lo;
+
+	if (sizeof(long) == 4)
+		__asm__("multu\t%2, %3"
+		: "=h" (usecs), "=l" (lo)
+		: "r" (usecs), "r" (lpj)
+		: GCC_REG_ACCUM);
+	else if (sizeof(long) == 8 && !R4000_WAR)
+		__asm__("dmultu\t%2, %3"
+		: "=h" (usecs), "=l" (lo)
+		: "r" (usecs), "r" (lpj)
+		: GCC_REG_ACCUM);
+	else if (sizeof(long) == 8 && R4000_WAR)
+		__asm__("dmultu\t%3, %4\n\tmfhi\t%0"
+		: "=r" (usecs), "=h" (hi), "=l" (lo)
+		: "r" (usecs), "r" (lpj)
+		: GCC_REG_ACCUM);
+
+	return usecs;
+}
+#else	/* GCC_NO_H_CONSTRAINT, gcc >= 4.4 */
+static inline unsigned long __usecs_to_loops(unsigned long usecs,
+		unsigned long lpj)
+{
+	return ((uintx_t)usecs * lpj) >> BITS_PER_LONG;
+}
+#endif
 
 /*
  * Division by multiplication: you don't have to worry about
@@ -62,8 +100,6 @@ static inline void __delay(unsigned long loops)
 
 static inline void __udelay(unsigned long usecs, unsigned long lpj)
 {
-	unsigned long hi, lo;
-
 	/*
 	 * The rates of 128 is rounded wrongly by the catchall case
 	 * for 64-bit.  Excessive precission?  Probably ...
@@ -77,23 +113,7 @@ static inline void __udelay(unsigned long usecs, unsigned long lpj)
 	                           0x80000000ULL) >> 32);
 #endif
 
-	if (sizeof(long) == 4)
-		__asm__("multu\t%2, %3"
-		: "=h" (usecs), "=l" (lo)
-		: "r" (usecs), "r" (lpj)
-		: GCC_REG_ACCUM);
-	else if (sizeof(long) == 8 && !R4000_WAR)
-		__asm__("dmultu\t%2, %3"
-		: "=h" (usecs), "=l" (lo)
-		: "r" (usecs), "r" (lpj)
-		: GCC_REG_ACCUM);
-	else if (sizeof(long) == 8 && R4000_WAR)
-		__asm__("dmultu\t%3, %4\n\tmfhi\t%0"
-		: "=r" (usecs), "=h" (hi), "=l" (lo)
-		: "r" (usecs), "r" (lpj)
-		: GCC_REG_ACCUM);
-
-	__delay(usecs);
+	__delay(__usecs_to_loops(usecs, lpj));
 }
 
 #define __udelay_val cpu_data[raw_smp_processor_id()].udelay_val
diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
index d1d6991..6efc268 100644
--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (C) 2000, 2004  Maciej W. Rozycki
  * Copyright (C) 2003, 07 Ralf Baechle (ralf@linux-mips.org)
+ * Copyright (C) 2009 Wu Zhangjin (wuzj@lemote.com)
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -56,6 +57,24 @@
 	(res) = __quot32; \
 	__mod32; })
 
+/*
+ * __do_divu -- unsigned interger dividing
+ *
+ * handle removal of 'h' constraint in GCC 4.4
+ */
+#ifndef GCC_NO_H_CONSTRAINT	/* gcc <= 4.3*/
+#define __do_divu() ({ \
+	__asm__("divu	$0, %z2, %z3" \
+		: "=h" (__upper), "=l" (__high) \
+		: "Jr" (__high), "Jr" (__base) \
+		: GCC_REG_ACCUM); })
+
+#else		/* gcc >= 4.4 */
+#define __do_divu() ({ \
+	__upper = (uintx_t)__high % __base; \
+	__high = (uintx_t)__high / __base; })
+#endif
+
 #define do_div(n, base) ({ \
 	unsigned long long __quot; \
 	unsigned long __mod; \
@@ -70,10 +89,7 @@
 	__upper = __high; \
 	\
 	if (__high) \
-		__asm__("divu	$0, %z2, %z3" \
-			: "=h" (__upper), "=l" (__high) \
-			: "Jr" (__high), "Jr" (__base) \
-			: GCC_REG_ACCUM); \
+		__do_divu();\
 	\
 	__mod = do_div64_32(__low, __upper, __low, __base); \
 	\
-- 
1.6.2.1

