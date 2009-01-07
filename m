Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbZAGUTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbZAGUTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZAGUTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 15:19:37 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:54440 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759602AbZAGUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 15:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XjcsM7x1aIYEcab+XCASA94CuUzfM8cEZqdLo5OjMgFFxThVEi6AZk5KSfEuFtTKYx
         81SSBemXk3OR91UJDoN761oQApWs9ZpUN2Y5Vvr6wHudojbC80sZi/YXMAMdIwLeQBmp
         R9LfDzNfHzEnCvvtZpeRvZ+nvnfWv4QGCj2GQ=
Subject: [PATCH] xtensa: introduce swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 12:19:31 -0800
Message-Id: <1231359572.5586.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compile breakage as linux/byteorder.h was removed.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Fallout from the byteorder.h removal.

 arch/xtensa/include/asm/Kbuild                  |    2 +
 arch/xtensa/include/asm/byteorder.h             |   94 ++++-------------------
 arch/xtensa/include/asm/{byteorder.h => swab.h} |   18 +----
 3 files changed, 20 insertions(+), 94 deletions(-)

diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index c68e168..58c02a4 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+unifdef-y += swab.h
diff --git a/arch/xtensa/include/asm/byteorder.h b/arch/xtensa/include/asm/byteorder.h
dissimilarity index 91%
index 07d10ad..329b945 100644
--- a/arch/xtensa/include/asm/byteorder.h
+++ b/arch/xtensa/include/asm/byteorder.h
@@ -1,80 +1,14 @@
-/*
- * include/asm-xtensa/byteorder.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_BYTEORDER_H
-#define _XTENSA_BYTEORDER_H
-
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-#ifdef __XTENSA_EL__
-# define __LITTLE_ENDIAN
-#elif defined(__XTENSA_EB__)
-# define __BIG_ENDIAN
-#else
-# error processor byte order undefined!
-#endif
-
-#define __SWAB_64_THRU_32__
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
-{
-    __u32 res;
-    /* instruction sequence from Xtensa ISA release 2/2000 */
-    __asm__("ssai     8           \n\t"
-	    "srli     %0, %1, 16  \n\t"
-	    "src      %0, %0, %1  \n\t"
-	    "src      %0, %0, %0  \n\t"
-	    "src      %0, %1, %0  \n"
-	    : "=&a" (res)
-	    : "a" (x)
-	    );
-    return res;
-}
-#define __arch_swab32 __arch_swab32
-
-static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
-{
-    /* Given that 'short' values are signed (i.e., can be negative),
-     * we cannot assume that the upper 16-bits of the register are
-     * zero.  We are careful to mask values after shifting.
-     */
-
-    /* There exists an anomaly between xt-gcc and xt-xcc.  xt-gcc
-     * inserts an extui instruction after putting this function inline
-     * to ensure that it uses only the least-significant 16 bits of
-     * the result.  xt-xcc doesn't use an extui, but assumes the
-     * __asm__ macro follows convention that the upper 16 bits of an
-     * 'unsigned short' result are still zero.  This macro doesn't
-     * follow convention; indeed, it leaves garbage in the upport 16
-     * bits of the register.
-
-     * Declaring the temporary variables 'res' and 'tmp' to be 32-bit
-     * types while the return type of the function is a 16-bit type
-     * forces both compilers to insert exactly one extui instruction
-     * (or equivalent) to mask off the upper 16 bits. */
-
-    __u32 res;
-    __u32 tmp;
-
-    __asm__("extui    %1, %2, 8, 8\n\t"
-	    "slli     %0, %2, 8   \n\t"
-	    "or       %0, %0, %1  \n"
-	    : "=&a" (res), "=&a" (tmp)
-	    : "a" (x)
-	    );
-
-    return res;
-}
-#define __arch_swab16 __arch_swab16
-
-#include <linux/byteorder.h>
-
-#endif /* _XTENSA_BYTEORDER_H */
+#ifndef _XTENSA_BYTEORDER_H
+#define _XTENSA_BYTEORDER_H
+
+#include <asm/swab.h>
+
+#ifdef __XTENSA_EL__
+#include <linux/byteorder/little_endian.h>
+#elif defined(__XTENSA_EB__)
+#include <linux/byteorder/big_endian.h>
+#else
+# error processor byte order undefined!
+#endif
+
+#endif /* _XTENSA_BYTEORDER_H */
diff --git a/arch/xtensa/include/asm/byteorder.h b/arch/xtensa/include/asm/swab.h
similarity index 86%
rename from arch/xtensa/include/asm/byteorder.h
rename to arch/xtensa/include/asm/swab.h
index 07d10ad..f50b697 100644
--- a/arch/xtensa/include/asm/byteorder.h
+++ b/arch/xtensa/include/asm/swab.h
@@ -1,5 +1,5 @@
 /*
- * include/asm-xtensa/byteorder.h
+ * include/asm-xtensa/swab.h
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -8,20 +8,12 @@
  * Copyright (C) 2001 - 2005 Tensilica Inc.
  */
 
-#ifndef _XTENSA_BYTEORDER_H
-#define _XTENSA_BYTEORDER_H
+#ifndef _XTENSA_SWAB_H
+#define _XTENSA_SWAB_H
 
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __XTENSA_EL__
-# define __LITTLE_ENDIAN
-#elif defined(__XTENSA_EB__)
-# define __BIG_ENDIAN
-#else
-# error processor byte order undefined!
-#endif
-
 #define __SWAB_64_THRU_32__
 
 static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
@@ -75,6 +67,4 @@ static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 }
 #define __arch_swab16 __arch_swab16
 
-#include <linux/byteorder.h>
-
-#endif /* _XTENSA_BYTEORDER_H */
+#endif /* _XTENSA_SWAB_H */
-- 
1.6.1.94.g9388



