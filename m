Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYG3BBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYG3BBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbYG3Az4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922AbYG3Azy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wdJVnZArscEV1baKGrr2z/VWsQGoeM7ostLQqRyxS+68KTbHiCvg0C0+szup9GIfRV
         /kt3Tzi9SUuiw/FwWjANX60VigdaYj5BNcVWlXZzixbxHmyVoV7Ee/9OoMxYEZ/efHCz
         wvJ8COlRL8Y2YUfUScLFbT40t1FFuejJx7UWo=
Subject: [PATCH 20/24] x86: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:29 -0700
Message-Id: <1217379329.23389.131.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/byteorder.h |   69 +++++++++++++++++--------------------------
 1 files changed, 27 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/byteorder.h b/include/asm-x86/byteorder.h
index e02ae2d..7187b3a 100644
--- a/include/asm-x86/byteorder.h
+++ b/include/asm-x86/byteorder.h
@@ -4,26 +4,33 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-#ifdef __i386__
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (x) : "0" (x));
-#else
+#ifdef __i386__
+# ifdef CONFIG_X86_BSWAP
+	asm("bswap %0" : "=r" (val) : "0" (val));
+# else
 	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
 	    "rorl $16,%0\n\t"	/* swap words		*/
 	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (x)
-	    : "0" (x));
+	    : "=q" (val)
+	    : "0" (val));
+# endif
+
+#else /* __i386__ */
+	asm("bswapl %0"
+	    : "=r" (val)
+	    : "0" (val));
 #endif
-	return x;
+	return val;
 }
+#define __arch_swab32 __arch_swab32
 
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 {
+#ifdef __i386__
 	union {
 		struct {
 			__u32 a;
@@ -32,50 +39,28 @@ static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-#ifdef CONFIG_X86_BSWAP
+# ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#else
+# else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
 	asm("xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#endif
+# endif
 	return v.u;
-}
 
 #else /* __i386__ */
-
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 x)
-{
 	asm("bswapq %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
-{
-	asm("bswapl %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
+	    : "=r" (val)
+	    : "0" (val));
+	return val;
 #endif
+}
+#define __arch_swab64 __arch_swab64
 
-/* Do not define swab16.  Gcc is smart enough to recognize "C" version and
-   convert it into rotation or exhange.  */
-
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#define __BYTEORDER_HAS_U64__
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_X86_BYTEORDER_H */
-- 
1.6.0.rc1.154.ge3fc


