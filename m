Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYKESiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYKESiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYKESfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:35:46 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:44981 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbYKESfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MKONCdGq7r6CnhXjrxEtTCv/BcP5jGhCacl1Ncu3vV8+D0NmOjrclFoWX7PdSxnj0Q
         xRJDZVzCZd4Ofoc3G0Q0m+hLfYO1TkJGxU9aIu5KnJdVMG6qq1HEbwESoOYl3/OhSZku
         /gp82Qcs9RM+PhIRY/S5AwB6wepv6Rd8r/bO8=
Subject: [PATCH 08/10] parisc: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Kyle McMartin <kyle@mcmartin.ca>, grundler <grundler@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:35:30 -0800
Message-Id: <1225910130.5991.228.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/parisc/include/asm/byteorder.h |   37 +++++++++++-----------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/parisc/include/asm/byteorder.h b/arch/parisc/include/asm/byteorder.h
index db14831..83095c5 100644
--- a/arch/parisc/include/asm/byteorder.h
+++ b/arch/parisc/include/asm/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
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
+#define __arch_swab16 __arch_swab16
 
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
+#define __arch_swab32 __arch_swab32
 
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
+#define __arch_swab64 __arch_swab64
+#endif /* BITS_PER_LONG > 32 */
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _PARISC_BYTEORDER_H */
-- 
1.6.0.3.756.gb776d


