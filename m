Return-Path: <linux-kernel-owner+w=401wt.eu-S965393AbXCFRkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393AbXCFRkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965380AbXCFRkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:40:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965396AbXCFRkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:40:21 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix get_order()
To: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net,
       dhowells@redhat.com
Date: Tue, 06 Mar 2007 17:39:29 +0000
Message-ID: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix get_order() to use ilog2() properly.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/asm-generic/page.h |   14 +++++++++++---
 include/linux/log2.h       |   20 ++++++++++++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index b55052c..c37571d 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -17,10 +17,18 @@ static inline __attribute__((const))
 int __get_order(unsigned long size, int page_shift)
 {
 #if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
-	int order = __ilog2_u32(size) - page_shift;
+	int order;
+	if (size <= 1)
+		order = 0;
+	else
+		order = __ilog2_u32(size - 1) + 1 - page_shift;
 	return order >= 0 ? order : 0;
 #elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)
-	int order = __ilog2_u64(size) - page_shift;
+	int order;
+	if (size <= 1)
+		order = 0;
+	else
+		order = __ilog2_u64(size - 1) + 1 - page_shift;
 	return order >= 0 ? order : 0;
 #else
 	int order;
@@ -46,7 +54,7 @@ int __get_order(unsigned long size, int page_shift)
 #define get_order(n)							\
 (									\
 	__builtin_constant_p(n) ?					\
-	((n < (1UL << PAGE_SHIFT)) ? 0 : ilog2(n) - PAGE_SHIFT) :	\
+	((n < (1UL << PAGE_SHIFT)) ? 0 : ilog2_up(n) - PAGE_SHIFT) :	\
 	__get_order(n, PAGE_SHIFT)					\
  )
 
diff --git a/include/linux/log2.h b/include/linux/log2.h
index 57e641e..bc3a0eb 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -70,6 +70,8 @@ unsigned long __roundup_pow_of_two(unsigned long n)
  * constant-capable log of base 2 calculation
  * - this can be used to initialise global variables from constant data, hence
  *   the massive ternary operator construction
+ * - the result is rounded down
+ * - the result is undefined when n < 1
  *
  * selects the appropriately-sized optimised version depending on sizeof(n)
  */
@@ -149,6 +151,20 @@ unsigned long __roundup_pow_of_two(unsigned long n)
  )
 
 /**
+ * ilog2_up - rounded up log of base 2 of 32-bit or a 64-bit unsigned value
+ * @n - parameter
+ *
+ * constant-capable log of base 2 calculation
+ * - this can be used to initialise global variables from constant data, hence
+ *   the massive ternary operator construction
+ * - the result is rounded up
+ * - the result is undefined when n < 1
+ *
+ * selects the appropriately-sized optimised version depending on sizeof(n)
+ */
+#define ilog2_up(n) ((n) == 1 ? 0 : ilog2((n) - 1) + 1)
+
+/**
  * roundup_pow_of_two - round the given value up to nearest power of two
  * @n - parameter
  *
@@ -159,8 +175,8 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
-		(1UL << (ilog2((n) - 1) + 1))	\
+		(n == 1) ? 1 :			\
+		(1UL << ilog2_up(n))		\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
  )

