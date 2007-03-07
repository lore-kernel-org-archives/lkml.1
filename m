Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXCGBmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXCGBmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 20:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161159AbXCGBmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 20:42:46 -0500
Received: from mail22.syd.optusnet.com.au ([211.29.133.160]:52547 "EHLO
	mail22.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161151AbXCGBmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 20:42:40 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: [PATCH] [RSDL-mm 4/6] sched: implement 180 bit sched bitmap
Date: Wed, 7 Mar 2007 12:27:49 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3059
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703071227.49772.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the sched_find_first_bit function to work on a 180bit long bitmap.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 include/asm-generic/bitops/sched.h |   10 ++++++----
 include/asm-s390/bitops.h          |   12 +-----------
 2 files changed, 7 insertions(+), 15 deletions(-)

Index: linux-2.6.21-rc2-mm2/include/asm-generic/bitops/sched.h
===================================================================
--- linux-2.6.21-rc2-mm2.orig/include/asm-generic/bitops/sched.h	2007-03-07 11:57:51.000000000 +1100
+++ linux-2.6.21-rc2-mm2/include/asm-generic/bitops/sched.h	2007-03-07 11:58:22.000000000 +1100
@@ -6,8 +6,8 @@
 
 /*
  * Every architecture must define this function. It's the fastest
- * way of searching a 140-bit bitmap where the first 100 bits are
- * unlikely to be set. It's guaranteed that at least one of the 140
+ * way of searching a 180-bit bitmap where the first 100 bits are
+ * unlikely to be set. It's guaranteed that at least one of the 180
  * bits is cleared.
  */
 static inline int sched_find_first_bit(const unsigned long *b)
@@ -15,7 +15,7 @@ static inline int sched_find_first_bit(c
 #if BITS_PER_LONG == 64
 	if (unlikely(b[0]))
 		return __ffs(b[0]);
-	if (likely(b[1]))
+	if (b[1])
 		return __ffs(b[1]) + 64;
 	return __ffs(b[2]) + 128;
 #elif BITS_PER_LONG == 32
@@ -27,7 +27,9 @@ static inline int sched_find_first_bit(c
 		return __ffs(b[2]) + 64;
 	if (b[3])
 		return __ffs(b[3]) + 96;
-	return __ffs(b[4]) + 128;
+	if (b[4])
+		return __ffs(b[4]) + 128;
+	return __ffs(b[5]) + 160;
 #else
 #error BITS_PER_LONG not defined
 #endif
Index: linux-2.6.21-rc2-mm2/include/asm-s390/bitops.h
===================================================================
--- linux-2.6.21-rc2-mm2.orig/include/asm-s390/bitops.h	2007-03-07 11:57:51.000000000 +1100
+++ linux-2.6.21-rc2-mm2/include/asm-s390/bitops.h	2007-03-07 11:58:22.000000000 +1100
@@ -729,17 +729,7 @@ find_next_bit (const unsigned long * add
 	return offset + find_first_bit(p, size);
 }
 
-/*
- * Every architecture must define this function. It's the fastest
- * way of searching a 140-bit bitmap where the first 100 bits are
- * unlikely to be set. It's guaranteed that at least one of the 140
- * bits is cleared.
- */
-static inline int sched_find_first_bit(unsigned long *b)
-{
-	return find_first_bit(b, 140);
-}
-
+#include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 
 #include <asm-generic/bitops/fls.h>

-- 
-ck
