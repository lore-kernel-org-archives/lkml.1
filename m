Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYLINxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYLINxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYLINxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:53:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:21991 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYLINxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:53:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f8QmoqrcKk0JnvoTDM9IWAWd+fSROJOxnwWxDHbP/3eDcAHV7iIvqyivxMRE0kBDEK
         LfB1U2AzOrlQjpKzFtKzhTdiF36m+O1+cvUYBG/NP4b/eU7MYoIRv43+cnMEp/3i7s3L
         cctYGQ7gltBbnKh6Em1PbQOI2R4l9Q79geQWo=
Date: Tue, 9 Dec 2008 16:57:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: harvey.harrison@gmail.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
Subject: byteorder headers on parisc
Message-ID: <20081209135714.GB7785@x200.localdomain>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May I politely ask how this was compiled-tested?

It breaks every parisc config and it breaks every parisc config applied
against mainline too, so it's not some interaction issue.

  CC      arch/parisc/lib/iomap.o
arch/parisc/lib/iomap.c: In function 'iomem_read16':
arch/parisc/lib/iomap.c:154: error: implicit declaration of function '__fswab16'
arch/parisc/lib/iomap.c: In function 'iomem_read32':
arch/parisc/lib/iomap.c:164: error: implicit declaration of function '__fswab32'



commit e4fdb8c6aae569fec4c68c76fc0cdaa23ba9c77d
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Tue Dec 2 03:28:17 2008 +0000

    parisc: use the new byteorder headers
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Cc: Matthew Wilcox <willy@debian.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

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
