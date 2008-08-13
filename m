Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYHMA1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYHMA1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYHMA0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:26:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:49095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbYHMA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:26:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wSFzK+h+R9BmwOUDSQG1SRaabczQZkOtcTpN7q/AikhJX/XiixB2p6BQex6tdPreT7
         eTwhdkt0TcIgSRBeBWTzg8vXysbVp3OIl/tZiDZouJXKxBzlMhmrUqm0wxvFYLyO/NgS
         yoZ4WYns6YNLPccTBB7DlkBa+B9AK6mQiG9UQ=
Subject: [PATCH 04/22] blackfin: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 17:26:36 -0700
Message-Id: <1218587196.30194.77.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
The prerequisite patches have landed in Linus' tree now.

 include/asm-blackfin/byteorder.h |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/asm-blackfin/byteorder.h b/include/asm-blackfin/byteorder.h
index 6a673d4..7b9e99f 100644
--- a/include/asm-blackfin/byteorder.h
+++ b/include/asm-blackfin/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahb32(__u32 xx)
 {
 	__u32 tmp;
 	__asm__("%1 = %0 >> 8 (V);\n\t"
@@ -15,34 +16,30 @@ static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
 		: "+d"(xx), "=&d"(tmp));
 	return xx;
 }
+#define __arch_swahb32 __arch_swahb32
 
-static __inline__ __attribute_const__ __u32 ___arch__swahw32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahw32(__u32 xx)
 {
 	__u32 rv;
 	__asm__("%0 = PACK(%1.L, %1.H);\n\t": "=d"(rv): "d"(xx));
 	return rv;
 }
+#define __arch_swahw32 __arch_swahw32
 
-#define __arch__swahb32(x) ___arch__swahb32(x)
-#define __arch__swahw32(x) ___arch__swahw32(x)
-#define __arch__swab32(x) ___arch__swahb32(___arch__swahw32(x))
+static inline __attribute_const__ __u32 __arch_swab32(__u32 xx)
+{
+	return __arch_swahb32(__arch_swahw32(x));
+}
+#define __arch_swab32 __arch_swab32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 xx)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 xx)
 {
 	__u32 xw = xx;
 	__asm__("%0 <<= 8;\n	%0.L = %0.L + %0.H (NS);\n": "+d"(xw));
 	return (__u16)xw;
 }
+#define __arch_swab16 __arch_swab16
 
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
-#endif				/* _BLACKFIN_BYTEORDER_H */
+#endif /* _BLACKFIN_BYTEORDER_H */
-- 
1.6.0.rc2.233.g3cb9d


