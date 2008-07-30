Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYG3BAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYG3BAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYG3Azv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbYG3Azu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=J201p5HcxNus1BbE4Pm5dc6e+j5RY/GrgPC1f77MtNqSdaNvHcJo6lOi9I238wbbX9
         aiYYdqj6xcbnPDp0ZZd7kHu/7Sbct2CgpJF5PCkHGjwK8blbz9Vt3gYzW9N6nPm4Qreh
         nQ2b01vv8si8yzFu36s9vfFgT1BE9gXigCdhg=
Subject: [PATCH 17/24] s390: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:27 -0700
Message-Id: <1217379327.23389.128.camel@brick>
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
index 1fe2492..5f23282 100644
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
1.6.0.rc1.154.ge3fc


