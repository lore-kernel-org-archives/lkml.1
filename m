Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYHMAbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYHMAbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYHMA1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:27:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbYHMA1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KncGaj+fHBqotFxXPmHcOdST/FLu98zyHiaj1h7EYHZlxm6LQnhD99Dcz3JY9Xkz8L
         lVki5LszX2ofWWFIrot03EwV2uKkLOJLdy17HHJI5KB3O/NJ8VNG9D3BKlYTuwZLMbrd
         R8NSoAtGtz15G/bmYN4HIHMG7FlVtEXk4gxz8=
Subject: [PATCH 16/22] s390: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:27:13 -0700
Message-Id: <1218587233.30194.90.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 arch/s390/include/asm/byteorder.h |   70 ++++++++++--------------------------
 1 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/arch/s390/include/asm/byteorder.h b/arch/s390/include/asm/byteorder.h
index 1fe2492..5f23282 100644
--- a/arch/s390/include/asm/byteorder.h
+++ b/arch/s390/include/asm/byteorder.h
@@ -11,32 +11,39 @@
 
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
+
+#ifndef __s390x__
+# define __SWAB_64_THRU_32__
+#endif
 
 #ifdef __s390x__
-static inline __u64 ___arch__swab64p(const __u64 *x)
+static inline __u64 __arch_swab64p(const __u64 *x)
 {
 	__u64 result;
 
 	asm volatile("lrvg %0,%1" : "=d" (result) : "m" (*x));
 	return result;
 }
+#define __arch_swab64p __arch_swab64p
 
-static inline __u64 ___arch__swab64(__u64 x)
+static inline __u64 __arch_swab64(__u64 x)
 {
 	__u64 result;
 
 	asm volatile("lrvgr %0,%1" : "=d" (result) : "d" (x));
 	return result;
 }
+#define __arch_swab64 __arch_swab64
 
-static inline void ___arch__swab64s(__u64 *x)
+static inline void __arch_swab64s(__u64 *x)
 {
 	*x = ___arch__swab64p(x);
 }
+#define __arch_swab64s __arch_swab64s
 #endif /* __s390x__ */
 
-static inline __u32 ___arch__swab32p(const __u32 *x)
+static inline __u32 __arch_swab32p(const __u32 *x)
 {
 	__u32 result;
 	
@@ -53,25 +60,20 @@ static inline __u32 ___arch__swab32p(const __u32 *x)
 #endif /* __s390x__ */
 	return result;
 }
+#define __arch_swab32p __arch_swab32p
 
-static inline __u32 ___arch__swab32(__u32 x)
+#ifdef __s390x__
+static inline __u32 __arch_swab32(__u32 x)
 {
-#ifndef __s390x__
-	return ___arch__swab32p(&x);
-#else /* __s390x__ */
 	__u32 result;
 	
 	asm volatile("lrvr  %0,%1" : "=d" (result) : "d" (x));
 	return result;
-#endif /* __s390x__ */
-}
-
-static __inline__ void ___arch__swab32s(__u32 *x)
-{
-	*x = ___arch__swab32p(x);
 }
+#define __arch_swab32 __arch_swab32
+#endif /* __s390x__ */
 
-static __inline__ __u16 ___arch__swab16p(const __u16 *x)
+static inline __u16 __arch_swab16p(const __u16 *x)
 {
 	__u16 result;
 	
@@ -86,40 +88,8 @@ static __inline__ __u16 ___arch__swab16p(const __u16 *x)
 #endif /* __s390x__ */
 	return result;
 }
+#define __arch_swab16p __arch_swab16p
 
-static __inline__ __u16 ___arch__swab16(__u16 x)
-{
-	return ___arch__swab16p(&x);
-}
-
-static __inline__ void ___arch__swab16s(__u16 *x)
-{
-	*x = ___arch__swab16p(x);
-}
-
-#ifdef __s390x__
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
-#define __arch__swab64s(x) ___arch__swab64s(x)
-#endif /* __s390x__ */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32s(x) ___arch__swab32s(x)
-#define __arch__swab16s(x) ___arch__swab16s(x)
-
-#ifndef __s390x__
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-#else /* __s390x__ */
-#define __BYTEORDER_HAS_U64__
-#endif /* __s390x__ */
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _S390_BYTEORDER_H */
-- 
1.6.0.rc2.233.g3cb9d


