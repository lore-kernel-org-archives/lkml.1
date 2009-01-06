Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZAFVdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZAFVdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZAFVcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:18234 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZAFVcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=l7DFZmHZ1K+V7SNZNqtFvLrBpo2yoyFxN1RCR2v8gq2rdLzLSmOTlolsMRlLFe66Sl
         k7rk8d41psuyVpuCD9eemKTmEeeWA4BvbgMzM0VuLDs+TX7hCw3yWJsMBIlvM2+zCrrF
         nIPjpOefJQ7lC02NPBUAOpvQRZ9BSDGBFvwMo=
Subject: [PATCH 05/23] parisc: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:47 -0800
Message-Id: <1231277447.964.262.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/parisc/include/asm/Kbuild      |    1 +
 arch/parisc/include/asm/byteorder.h |   66 +---------------------------------
 arch/parisc/include/asm/swab.h      |   66 +++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 64 deletions(-)

diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index f88b252..2121d99 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += pdc.h
+unifdef-y += swab.h
diff --git a/arch/parisc/include/asm/byteorder.h b/arch/parisc/include/asm/byteorder.h
index 83095c5..da66029 100644
--- a/arch/parisc/include/asm/byteorder.h
+++ b/arch/parisc/include/asm/byteorder.h
@@ -1,69 +1,7 @@
 #ifndef _PARISC_BYTEORDER_H
 #define _PARISC_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-#define __BIG_ENDIAN
-#define __SWAB_64_THRU_32__
-
-static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
-{
-	__asm__("dep %0, 15, 8, %0\n\t"		/* deposit 00ab -> 0bab */
-		"shd %%r0, %0, 8, %0"		/* shift 000000ab -> 00ba */
-		: "=r" (x)
-		: "0" (x));
-	return x;
-}
-#define __arch_swab16 __arch_swab16
-
-static inline __attribute_const__ __u32 __arch_swab24(__u32 x)
-{
-	__asm__("shd %0, %0, 8, %0\n\t"		/* shift xabcxabc -> cxab */
-		"dep %0, 15, 8, %0\n\t"		/* deposit cxab -> cbab */
-		"shd %%r0, %0, 8, %0"		/* shift 0000cbab -> 0cba */
-		: "=r" (x)
-		: "0" (x));
-	return x;
-}
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
-{
-	unsigned int temp;
-	__asm__("shd %0, %0, 16, %1\n\t"	/* shift abcdabcd -> cdab */
-		"dep %1, 15, 8, %1\n\t"		/* deposit cdab -> cbab */
-		"shd %0, %1, 8, %0"		/* shift abcdcbab -> dcba */
-		: "=r" (x), "=&r" (temp)
-		: "0" (x));
-	return x;
-}
-#define __arch_swab32 __arch_swab32
-
-#if BITS_PER_LONG > 32
-/*
-** From "PA-RISC 2.0 Architecture", HP Professional Books.
-** See Appendix I page 8 , "Endian Byte Swapping".
-**
-** Pretty cool algorithm: (* == zero'd bits)
-**      PERMH   01234567 -> 67452301 into %0
-**      HSHL    67452301 -> 7*5*3*1* into %1
-**      HSHR    67452301 -> *6*4*2*0 into %0
-**      OR      %0 | %1  -> 76543210 into %0 (all done!)
-*/
-static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
-{
-	__u64 temp;
-	__asm__("permh,3210 %0, %0\n\t"
-		"hshl %0, 8, %1\n\t"
-		"hshr,u %0, 8, %0\n\t"
-		"or %1, %0, %0"
-		: "=r" (x), "=&r" (temp)
-		: "0" (x));
-	return x;
-}
-#define __arch_swab64 __arch_swab64
-#endif /* BITS_PER_LONG > 32 */
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
 
 #endif /* _PARISC_BYTEORDER_H */
diff --git a/arch/parisc/include/asm/swab.h b/arch/parisc/include/asm/swab.h
new file mode 100644
index 0000000..3ff16c5
--- /dev/null
+++ b/arch/parisc/include/asm/swab.h
@@ -0,0 +1,66 @@
+#ifndef _PARISC_SWAB_H
+#define _PARISC_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
+{
+	__asm__("dep %0, 15, 8, %0\n\t"		/* deposit 00ab -> 0bab */
+		"shd %%r0, %0, 8, %0"		/* shift 000000ab -> 00ba */
+		: "=r" (x)
+		: "0" (x));
+	return x;
+}
+#define __arch_swab16 __arch_swab16
+
+static inline __attribute_const__ __u32 __arch_swab24(__u32 x)
+{
+	__asm__("shd %0, %0, 8, %0\n\t"		/* shift xabcxabc -> cxab */
+		"dep %0, 15, 8, %0\n\t"		/* deposit cxab -> cbab */
+		"shd %%r0, %0, 8, %0"		/* shift 0000cbab -> 0cba */
+		: "=r" (x)
+		: "0" (x));
+	return x;
+}
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+{
+	unsigned int temp;
+	__asm__("shd %0, %0, 16, %1\n\t"	/* shift abcdabcd -> cdab */
+		"dep %1, 15, 8, %1\n\t"		/* deposit cdab -> cbab */
+		"shd %0, %1, 8, %0"		/* shift abcdcbab -> dcba */
+		: "=r" (x), "=&r" (temp)
+		: "0" (x));
+	return x;
+}
+#define __arch_swab32 __arch_swab32
+
+#if BITS_PER_LONG > 32
+/*
+** From "PA-RISC 2.0 Architecture", HP Professional Books.
+** See Appendix I page 8 , "Endian Byte Swapping".
+**
+** Pretty cool algorithm: (* == zero'd bits)
+**      PERMH   01234567 -> 67452301 into %0
+**      HSHL    67452301 -> 7*5*3*1* into %1
+**      HSHR    67452301 -> *6*4*2*0 into %0
+**      OR      %0 | %1  -> 76543210 into %0 (all done!)
+*/
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
+{
+	__u64 temp;
+	__asm__("permh,3210 %0, %0\n\t"
+		"hshl %0, 8, %1\n\t"
+		"hshr,u %0, 8, %0\n\t"
+		"or %1, %0, %0"
+		: "=r" (x), "=&r" (temp)
+		: "0" (x));
+	return x;
+}
+#define __arch_swab64 __arch_swab64
+#endif /* BITS_PER_LONG > 32 */
+
+#endif /* _PARISC_SWAB_H */
-- 
1.6.1.94.g9388


