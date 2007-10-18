Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbXJRXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbXJRXd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbXJRXdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:33:20 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:33057 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbXJRXdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:33:19 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] hash: Add explicit u32 and u64 versions of hash
Date: Thu, 18 Oct 2007 19:33:42 -0400
Message-Id: <11927504222872-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit version is more efficient (and apparently gives better hash
results than the 64-bit version), so users who are only hashing a 32-bit
quantity can now opt to use the 32-bit version explicitly, rather than
promoting to a long.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 include/linux/hash.h |   42 +++++++++++++++++++++++++++---------------
 1 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/hash.h b/include/linux/hash.h
index acf17bb..06d25c1 100644
--- a/include/linux/hash.h
+++ b/include/linux/hash.h
@@ -1,6 +1,6 @@
 #ifndef _LINUX_HASH_H
 #define _LINUX_HASH_H
-/* Fast hashing routine for a long.
+/* Fast hashing routine for ints,  longs and pointers.
    (C) 2002 William Lee Irwin III, IBM */
 
 /*
@@ -13,23 +13,30 @@
  * them can use shifts and additions instead of multiplications for
  * machines where multiplications are slow.
  */
-#if BITS_PER_LONG == 32
+
+#include <asm/types.h>
+
 /* 2^31 + 2^29 - 2^25 + 2^22 - 2^19 - 2^16 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e370001UL
-#elif BITS_PER_LONG == 64
+#define GOLDEN_RATIO_PRIME_32 0x9e370001UL
 /*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
-#define GOLDEN_RATIO_PRIME 0x9e37fffffffc0001UL
+#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL
+
+#if BITS_PER_LONG == 32
+#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_32
+#define hash_long(val, bits) hash_32(val, bits)
+#elif BITS_PER_LONG == 64
+#define hash_long(val, bits) hash_64(val, bits)
+#define GOLDEN_RATIO_PRIME GOLDEN_RATIO_PRIME_64
 #else
-#error Define GOLDEN_RATIO_PRIME for your wordsize.
+#error Wordsize not 32 or 64
 #endif
 
-static inline unsigned long hash_long(unsigned long val, unsigned int bits)
+static inline u64 hash_64(u64 val, unsigned int bits)
 {
-	unsigned long hash = val;
+	u64 hash = val;
 
-#if BITS_PER_LONG == 64
 	/*  Sigh, gcc can't optimise this alone like it does for 32 bits. */
-	unsigned long n = hash;
+	u64 n = hash;
 	n <<= 18;
 	hash -= n;
 	n <<= 33;
@@ -42,15 +49,20 @@ static inline unsigned long hash_long(unsigned long val, unsigned int bits)
 	hash += n;
 	n <<= 2;
 	hash += n;
-#else
+
+	/* High bits are more random, so use them. */
+	return hash >> (64 - bits);
+}
+
+static inline u32 hash_32(u32 val, unsigned int bits)
+{
 	/* On some cpus multiply is faster, on others gcc will do shifts */
-	hash *= GOLDEN_RATIO_PRIME;
-#endif
+	u32 hash = val * GOLDEN_RATIO_PRIME_32;
 
 	/* High bits are more random, so use them. */
-	return hash >> (BITS_PER_LONG - bits);
+	return hash >> (32 - bits);
 }
-	
+
 static inline unsigned long hash_ptr(void *ptr, unsigned int bits)
 {
 	return hash_long((unsigned long)ptr, bits);
-- 
1.4.4.2

