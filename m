Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYJWCPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYJWCPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYJWCIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754305AbYJWCIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:30 -0400
Message-Id: <20081023020830.085567000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:45 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/35] cpumask: cpumask_of(): cpumask_of_cpu() which returns a pointer. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpumask_of.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This deprecates cpumask_of_cpu(), which returns a cpumask_t
(cpumask_of() returns a const pointer, instead).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -52,8 +52,7 @@
  * void cpumask_copy(dmask, smask)	dmask = smask
  *
  * size_t cpumask_size()		Length of cpumask in bytes.
- * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
- *					(can be used as an lvalue)
+ * const struct cpumask *cpumask_of(cpu) Return cpumask with bit 'cpu' set
  * CPU_MASK_ALL				Initializer - all bits set
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpumask_bits(mask)	Array of unsigned long's in mask
@@ -175,6 +174,7 @@ extern cpumask_t _unused_cpumask_arg_;
 #define next_cpu_nr(n, src)		next_cpu(n, src)
 #define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
 #define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
+#define cpumask_of_cpu(cpu) (*cpumask_of(cpu))
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -385,21 +385,13 @@ static inline void cpumask_copy(struct c
 extern const unsigned long
 	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
 
-static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
+static inline const struct cpumask *cpumask_of(unsigned int cpu)
 {
 	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
 	p -= cpu / BITS_PER_LONG;
-	return (const cpumask_t *)p;
+	return (const struct cpumask *)p;
 }
 
-/*
- * In cases where we take the address of the cpumask immediately,
- * gcc optimizes it out (it's a constant) and there's no huge stack
- * variable created:
- */
-#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
-
-
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 
 #if NR_CPUS <= BITS_PER_LONG

-- 
