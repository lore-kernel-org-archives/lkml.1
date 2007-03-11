Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXCKEBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXCKEBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 23:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbXCKEBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 23:01:34 -0500
Received: from mail12.syd.optusnet.com.au ([211.29.132.193]:47804 "EHLO
	mail12.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932961AbXCKEBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 23:01:33 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH][RSDL-mm 4/7] sched: implement 180 bit sched bitmap
Date: Sun, 11 Mar 2007 15:01:16 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1914
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703111501.16954.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Con Kolivas <kernel@kolivas.org>

Modify the sched_find_first_bit function to work on a 180bit long bitmap.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bitops/sched.h |   10 ++++++----
 include/asm-s390/bitops.h          |   12 +-----------
 2 files changed, 7 insertions(+), 15 deletions(-)

Index: linux-2.6.21-rc3-mm2/include/asm-generic/bitops/sched.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-generic/bitops/sched.h	2007-03-11 14:47:57.000000000 +1100
+++ linux-2.6.21-rc3-mm2/include/asm-generic/bitops/sched.h	2007-03-11 14:47:59.000000000 +1100
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
Index: linux-2.6.21-rc3-mm2/include/asm-s390/bitops.h
===================================================================
--- linux-2.6.21-rc3-mm2.orig/include/asm-s390/bitops.h	2007-03-11 14:47:57.000000000 +1100
+++ linux-2.6.21-rc3-mm2/include/asm-s390/bitops.h	2007-03-11 14:47:59.000000000 +1100
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
