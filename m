Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYHMAct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYHMAct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbYHMA1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:27:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbYHMA1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FhmFb6pBG6UUJnPSk6Q0VWsvcN8AdnRad9Sq/91WPHGRLrSsG6GZawvukuEV9lqrFy
         uwpX8Z0tzoxZuu7A3D5sGLZjzCU1R8mXbKAhQcKfDDbhPBWT5DEjdKF/WZAn0Gm3AKTK
         J9kbcGmr6aVe4tt4mX+MiWix6aNol2vqhBdWg=
Subject: [PATCH 19/22] x86: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:27:14 -0700
Message-Id: <1218587234.30194.93.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

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
1.6.0.rc2.233.g3cb9d


