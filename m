Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZAIUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZAIUnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZAIUnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:43:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:13510 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZAIUm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MpTPhHrWLwx024n+/XjumoMxnP9Uf5QNO3fuHJO7adT3P/VFa/e6fK48qmbayQV4Yw
         3wv0CxEkYnW67TuBaIQgqNU5phQ9hAEdw0oOq1BcOnaFXatjl/8XZup3bTswPdYH95kx
         zkTtyYwCD8LjvUpzh3ZKt2A/fe/fcaUGHMQvQ=
Subject: [PATCH] parisc: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Kyle McMartin <kyle@hera.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090109160340.GA12065@hera.kernel.org>
References: <20090109160340.GA12065@hera.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 12:42:54 -0800
Message-Id: <1231533774.5663.2.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for the linux/byteorder.h removal.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus, please apply after doing the parisc pull.  cris is the only
arch still outstanding.

Done with git diff -M -B

Harvey

 arch/parisc/include/asm/Kbuild                  |    1 +
 arch/parisc/include/asm/byteorder.h             |   76 ++--------------------
 arch/parisc/include/asm/{byteorder.h => swab.h} |    9 +--
 3 files changed, 11 insertions(+), 75 deletions(-)

diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index f88b252..2121d99 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 unifdef-y += pdc.h
+unifdef-y += swab.h
diff --git a/arch/parisc/include/asm/byteorder.h b/arch/parisc/include/asm/byteorder.h
dissimilarity index 94%
index 83095c5..da66029 100644
--- a/arch/parisc/include/asm/byteorder.h
+++ b/arch/parisc/include/asm/byteorder.h
@@ -1,69 +1,7 @@
-#ifndef _PARISC_BYTEORDER_H
-#define _PARISC_BYTEORDER_H
-
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
-
-#endif /* _PARISC_BYTEORDER_H */
+#ifndef _PARISC_BYTEORDER_H
+#define _PARISC_BYTEORDER_H
+
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
+
+#endif /* _PARISC_BYTEORDER_H */
diff --git a/arch/parisc/include/asm/byteorder.h b/arch/parisc/include/asm/swab.h
similarity index 92%
rename from arch/parisc/include/asm/byteorder.h
rename to arch/parisc/include/asm/swab.h
index 83095c5..3ff16c5 100644
--- a/arch/parisc/include/asm/byteorder.h
+++ b/arch/parisc/include/asm/swab.h
@@ -1,10 +1,9 @@
-#ifndef _PARISC_BYTEORDER_H
-#define _PARISC_BYTEORDER_H
+#ifndef _PARISC_SWAB_H
+#define _PARISC_SWAB_H
 
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#define __BIG_ENDIAN
 #define __SWAB_64_THRU_32__
 
 static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
@@ -64,6 +63,4 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
 #define __arch_swab64 __arch_swab64
 #endif /* BITS_PER_LONG > 32 */
 
-#include <linux/byteorder.h>
-
-#endif /* _PARISC_BYTEORDER_H */
+#endif /* _PARISC_SWAB_H */
-- 
1.6.1.94.g9388



