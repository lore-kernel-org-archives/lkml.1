Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbYGRAO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbYGRAO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933527AbYGRAKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:57293 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbYGRAKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EFQTJDHjre7HOBGkgnLQV0BoHJvCcEchR+F0lsjANK/DJeafOGz15HPCOD7kvhx5bl
         dpXTwSKNT7CMXyd8M/dhxRzlPGfkyqO5SRBBEfl09FngE5SbSyhIw+HTgElOkSFnB/nw
         gm5c9v5vE7R62OUkpbeBXah91soOZe8MUJWYg=
Subject: [PATCH 14/20] parisc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, grundler <grundler@parisc-linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:43 -0700
Message-Id: <1216339783.6029.125.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-parisc/byteorder.h |   37 ++++++++++++-------------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/include/asm-parisc/byteorder.h b/include/asm-parisc/byteorder.h
index db14831..5e56b1b 100644
--- a/include/asm-parisc/byteorder.h
+++ b/include/asm-parisc/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__("dep %0, 15, 8, %0\n\t"		/* deposit 00ab -> 0bab */
 		"shd %%r0, %0, 8, %0"		/* shift 000000ab -> 00ba */
@@ -14,8 +15,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 		: "0" (x));
 	return x;
 }
+#define HAVE_ARCH_SWAB16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab24(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab24(__u32 x)
 {
 	__asm__("shd %0, %0, 8, %0\n\t"		/* shift xabcxabc -> cxab */
 		"dep %0, 15, 8, %0\n\t"		/* deposit cxab -> cbab */
@@ -25,7 +27,7 @@ static __inline__ __attribute_const__ __u32 ___arch__swab24(__u32 x)
 	return x;
 }
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	unsigned int temp;
 	__asm__("shd %0, %0, 16, %1\n\t"	/* shift abcdabcd -> cdab */
@@ -35,7 +37,7 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 		: "0" (x));
 	return x;
 }
-
+#define HAVE_ARCH_SWAB32
 
 #if BITS_PER_LONG > 32
 /*
@@ -48,7 +50,8 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 **      HSHR    67452301 -> *6*4*2*0 into %0
 **      OR      %0 | %1  -> 76543210 into %0 (all done!)
 */
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x) {
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
+{
 	__u64 temp;
 	__asm__("permh,3210 %0, %0\n\t"
 		"hshl %0, 8, %1\n\t"
@@ -58,25 +61,9 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x) {
 		: "0" (x));
 	return x;
 }
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __BYTEORDER_HAS_U64__
-#elif !defined(__STRICT_ANSI__)
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
-{
-	__u32 t1 = ___arch__swab32((__u32) x);
-	__u32 t2 = ___arch__swab32((__u32) (x >> 32));
-	return (((__u64) t1 << 32) | t2);
-}
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __BYTEORDER_HAS_U64__
-#endif
-
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab24(x) ___arch__swab24(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#endif /* __GNUC__ */
+#define HAVE_ARCH_SWAB64
+#endif /* BITS_PER_LONG > 32 */
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _PARISC_BYTEORDER_H */
-- 
1.5.6.3.569.ga9185


