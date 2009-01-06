Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbZAFVhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbZAFVhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZAFVc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:29 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:9249 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbZAFVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HKbZYfu+SnLohF6ftBPtX8VyQ7C63JzW3GXirR0/OAmAIq9IVn55XjK1YxstKHuMEH
         94BqlCEU9KVzxBEzEJpdYgSOwP5EfMBnPVyDbVRMSVanPsU5gaZngDEW3wS91zmk73yi
         NTGwhkVSDKSGxU6x5T8TdALCLgPrglP/giylY=
Subject: [PATCH 15/23] blackfin: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:53 -0800
Message-Id: <1231277453.964.272.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/blackfin/include/asm/Kbuild      |    1 +
 arch/blackfin/include/asm/byteorder.h |   43 +----------------------------
 arch/blackfin/include/asm/swab.h      |   48 +++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 42 deletions(-)

diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 606ecfd..d0d1ac4 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += fixed_code.h
+unifdef-y += swab.h
diff --git a/arch/blackfin/include/asm/byteorder.h b/arch/blackfin/include/asm/byteorder.h
index 6a673d4..b9e797a 100644
--- a/arch/blackfin/include/asm/byteorder.h
+++ b/arch/blackfin/include/asm/byteorder.h
@@ -1,48 +1,7 @@
 #ifndef _BLACKFIN_BYTEORDER_H
 #define _BLACKFIN_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-#ifdef __GNUC__
-
-static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
-{
-	__u32 tmp;
-	__asm__("%1 = %0 >> 8 (V);\n\t"
-		"%0 = %0 << 8 (V);\n\t"
-		"%0 = %0 | %1;\n\t"
-		: "+d"(xx), "=&d"(tmp));
-	return xx;
-}
-
-static __inline__ __attribute_const__ __u32 ___arch__swahw32(__u32 xx)
-{
-	__u32 rv;
-	__asm__("%0 = PACK(%1.L, %1.H);\n\t": "=d"(rv): "d"(xx));
-	return rv;
-}
-
-#define __arch__swahb32(x) ___arch__swahb32(x)
-#define __arch__swahw32(x) ___arch__swahw32(x)
-#define __arch__swab32(x) ___arch__swahb32(___arch__swahw32(x))
-
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 xx)
-{
-	__u32 xw = xx;
-	__asm__("%0 <<= 8;\n	%0.L = %0.L + %0.H (NS);\n": "+d"(xw));
-	return (__u16)xw;
-}
-
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
+#include <asm/swab.h>
 #include <linux/byteorder/little_endian.h>
 
 #endif				/* _BLACKFIN_BYTEORDER_H */
diff --git a/arch/blackfin/include/asm/swab.h b/arch/blackfin/include/asm/swab.h
new file mode 100644
index 0000000..69a051b
--- /dev/null
+++ b/arch/blackfin/include/asm/swab.h
@@ -0,0 +1,48 @@
+#ifndef _BLACKFIN_SWAB_H
+#define _BLACKFIN_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#ifdef __GNUC__
+
+static __inline__ __attribute_const__ __u32 __arch_swahb32(__u32 xx)
+{
+	__u32 tmp;
+	__asm__("%1 = %0 >> 8 (V);\n\t"
+		"%0 = %0 << 8 (V);\n\t"
+		"%0 = %0 | %1;\n\t"
+		: "+d"(xx), "=&d"(tmp));
+	return xx;
+}
+#define __arch_swahb32 __arch_swahb32
+
+static __inline__ __attribute_const__ __u32 __arch_swahw32(__u32 xx)
+{
+	__u32 rv;
+	__asm__("%0 = PACK(%1.L, %1.H);\n\t": "=d"(rv): "d"(xx));
+	return rv;
+}
+#define __arch_swahw32 __arch_swahw32
+
+static __inline__ __attribute_const__ __u32 __arch_swab32(__u32 xx)
+{
+	return __arch_swahb32(__arch_swahw32(xx));
+}
+#define __arch_swab32 __arch_swab32
+
+static __inline__ __attribute_const__ __u16 __arch_swab16(__u16 xx)
+{
+	__u32 xw = xx;
+	__asm__("%0 <<= 8;\n	%0.L = %0.L + %0.H (NS);\n": "+d"(xw));
+	return (__u16)xw;
+}
+#define __arch_swab16 __arch_swab16
+
+#endif /* __GNUC__ */
+
+#endif				/* _BLACKFIN_SWAB_H */
-- 
1.6.1.94.g9388


