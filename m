Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZEMIRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZEMIRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZEMIQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:16:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:49617 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbZEMIQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,186,1241420400"; 
   d="scan'208";a="142252582"
From: Sheng Yang <sheng@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH] x86: Extend test_and_set_bit() test_and_clean_bit() to 64 bits in X86_64
Date: Wed, 13 May 2009 16:17:27 +0800
Message-Id: <1242202647-32446-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix 44/45 bit width memory can't boot up issue. The reason is
free_bootmem_node()->mark_bootmem_node()->__free() use test_and_clean_bit() to
clean node_bootmem_map, but for 44bits width address, the idx set bit 31 (43 -
12), which consider as a nagetive value for bts.

This patch applied to tip/mm.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/bitops.h |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 02b47a6..400dd28 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -41,6 +41,12 @@
 #define CONST_MASK_ADDR(nr, addr)	BITOP_ADDR((void *)(addr) + ((nr)>>3))
 #define CONST_MASK(nr)			(1 << ((nr) & 7))
 
+#ifdef CONFIG_X86_64
+#define REX_X86 "rex "
+#else
+#define REX_X86
+#endif
+
 /**
  * set_bit - Atomically set a bit in memory
  * @nr: the bit to set
@@ -192,11 +198,11 @@ static inline void change_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_set_bit(long int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
+	asm volatile(LOCK_PREFIX REX_X86 "bts %2,%1\n\t"
 		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
 
 	return oldbit;
@@ -224,11 +230,11 @@ test_and_set_bit_lock(int nr, volatile unsigned long *addr)
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_set_bit(long int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm("bts %2,%1\n\t"
+	asm(REX_X86 "bts %2,%1\n\t"
 	    "sbb %0,%0"
 	    : "=r" (oldbit), ADDR
 	    : "Ir" (nr));
@@ -243,14 +249,13 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
  * This operation is atomic and cannot be reordered.
  * It also implies a memory barrier.
  */
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int test_and_clear_bit(long int nr, volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile(LOCK_PREFIX "btr %2,%1\n\t"
+	asm volatile(LOCK_PREFIX REX_X86 "btr %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
-
 	return oldbit;
 }
 
@@ -263,11 +268,12 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
  */
-static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int __test_and_clear_bit(long int nr,
+				       volatile unsigned long *addr)
 {
 	int oldbit;
 
-	asm volatile("btr %2,%1\n\t"
+	asm volatile(REX_X86 "btr %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit), ADDR
 		     : "Ir" (nr));
-- 
1.5.4.5

