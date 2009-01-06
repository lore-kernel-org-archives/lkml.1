Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZAFVf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZAFVf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZAFVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZAFVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VfynnwUSVN3r4iapTjMilm4wtuoYyDypzfOVZytPfT+4vFMo6YtWeij+qZI5kJzGL/
         cqGxWVmTDx9iOXxcoOCxoFxtdxCd0qiCxGOZxZJAqWd63NDvzGmbCaxF7538sPpPRkLb
         6qpI4EvB9iU0BFcl8KgVRoQKEySSkhtrWVLJM=
Subject: [PATCH 11/23] xtensa: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Zankel <chris@zankel.net>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:51 -0800
Message-Id: <1231277451.964.268.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/xtensa/include/asm/Kbuild      |    2 +
 arch/xtensa/include/asm/byteorder.h |   72 +---------------------------------
 arch/xtensa/include/asm/swab.h      |   70 ++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 69 deletions(-)

diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index c68e168..58c02a4 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -1 +1,3 @@
 include include/asm-generic/Kbuild.asm
+
+unifdef-y += swab.h
diff --git a/arch/xtensa/include/asm/byteorder.h b/arch/xtensa/include/asm/byteorder.h
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
 #ifndef _XTENSA_BYTEORDER_H
 #define _XTENSA_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
+#include <asm/swab.h>
 
 #ifdef __XTENSA_EL__
-# define __LITTLE_ENDIAN
+#include <linux/byteorder/little_endian.h>
 #elif defined(__XTENSA_EB__)
-# define __BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
 #else
 # error processor byte order undefined!
 #endif
 
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
 #endif /* _XTENSA_BYTEORDER_H */
diff --git a/arch/xtensa/include/asm/swab.h b/arch/xtensa/include/asm/swab.h
new file mode 100644
index 0000000..f50b697
--- /dev/null
+++ b/arch/xtensa/include/asm/swab.h
@@ -0,0 +1,70 @@
+/*
+ * include/asm-xtensa/swab.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 - 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_SWAB_H
+#define _XTENSA_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+    __u32 res;
+    /* instruction sequence from Xtensa ISA release 2/2000 */
+    __asm__("ssai     8           \n\t"
+	    "srli     %0, %1, 16  \n\t"
+	    "src      %0, %0, %1  \n\t"
+	    "src      %0, %0, %0  \n\t"
+	    "src      %0, %1, %0  \n"
+	    : "=&a" (res)
+	    : "a" (x)
+	    );
+    return res;
+}
+#define __arch_swab32 __arch_swab32
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+    /* Given that 'short' values are signed (i.e., can be negative),
+     * we cannot assume that the upper 16-bits of the register are
+     * zero.  We are careful to mask values after shifting.
+     */
+
+    /* There exists an anomaly between xt-gcc and xt-xcc.  xt-gcc
+     * inserts an extui instruction after putting this function inline
+     * to ensure that it uses only the least-significant 16 bits of
+     * the result.  xt-xcc doesn't use an extui, but assumes the
+     * __asm__ macro follows convention that the upper 16 bits of an
+     * 'unsigned short' result are still zero.  This macro doesn't
+     * follow convention; indeed, it leaves garbage in the upport 16
+     * bits of the register.
+
+     * Declaring the temporary variables 'res' and 'tmp' to be 32-bit
+     * types while the return type of the function is a 16-bit type
+     * forces both compilers to insert exactly one extui instruction
+     * (or equivalent) to mask off the upper 16 bits. */
+
+    __u32 res;
+    __u32 tmp;
+
+    __asm__("extui    %1, %2, 8, 8\n\t"
+	    "slli     %0, %2, 8   \n\t"
+	    "or       %0, %0, %1  \n"
+	    : "=&a" (res), "=&a" (tmp)
+	    : "a" (x)
+	    );
+
+    return res;
+}
+#define __arch_swab16 __arch_swab16
+
+#endif /* _XTENSA_SWAB_H */
-- 
1.6.1.94.g9388


