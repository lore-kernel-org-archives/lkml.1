Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbYGRAPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbYGRAPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933550AbYGRAKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:10:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:12092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbYGRAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GKpnQJP2pZTzrUw99TTjVEzFz7g8snhO+fX0pYJ87hs9ioAL7DwMCrxC+doPrc8XLx
         qyKccaNsggOOuMbTYIhZN1ua+kBWymA32mG2nWAUbRiXOjJZ74SXU9HIr44W0XY3pymx
         08tv8tHqw557UOLa79ZPEpNrxFZkkiGQOdHoE=
Subject: [PATCH 16/20] s390: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:09:44 -0700
Message-Id: <1216339784.6029.127.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-s390/byteorder.h |   70 ++++++++++++------------------------------
 1 files changed, 20 insertions(+), 50 deletions(-)

diff --git a/include/asm-s390/byteorder.h b/include/asm-s390/byteorder.h
index 1fe2492..b84c490 100644
--- a/include/asm-s390/byteorder.h
+++ b/include/asm-s390/byteorder.h
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
+#define HAVE_ARCH_SWAB64P
 
-static inline __u64 ___arch__swab64(__u64 x)
+static inline __u64 __arch_swab64(__u64 x)
 {
 	__u64 result;
 
 	asm volatile("lrvgr %0,%1" : "=d" (result) : "d" (x));
 	return result;
 }
+#define HAVE_ARCH_SWAB64
 
-static inline void ___arch__swab64s(__u64 *x)
+static inline void __arch_swab64s(__u64 *x)
 {
 	*x = ___arch__swab64p(x);
 }
+#define HAVE_ARCH_SWAB64S
 #endif /* __s390x__ */
 
-static inline __u32 ___arch__swab32p(const __u32 *x)
+static inline __u32 __arch_swab32p(const __u32 *x)
 {
 	__u32 result;
 	
@@ -53,25 +60,20 @@ static inline __u32 ___arch__swab32p(const __u32 *x)
 #endif /* __s390x__ */
 	return result;
 }
+#define HAVE_ARCH_SWAB32P
 
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
+#define HAVE_ARCH_SWAB32
+#endif /* __s390x__ */
 
-static __inline__ __u16 ___arch__swab16p(const __u16 *x)
+static inline __u16 __arch_swab16p(const __u16 *x)
 {
 	__u16 result;
 	
@@ -86,40 +88,8 @@ static __inline__ __u16 ___arch__swab16p(const __u16 *x)
 #endif /* __s390x__ */
 	return result;
 }
+#define HAVE_ARCH_SWAB16P
 
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
1.5.6.3.569.ga9185


