Return-Path: <linux-kernel-owner+w=401wt.eu-S934554AbZIEAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbZIEAej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934481AbZIEAeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:34:37 -0400
Received: from kroah.org ([198.145.64.141]:42046 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934515AbZIEAU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:47 2009
Message-Id: <20090905001447.401529069@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 03/71] Make bitmask and operators return a result code
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=make-bitmask-and-operators-return-a-result-code.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit f4b0373b26567cafd421d91101852ed7a34e9e94 upstream.

When 'and'ing two bitmasks (where 'andnot' is a variation on it), some
cases want to know whether the result is the empty set or not.  In
particular, the TLB IPI sending code wants to do cpumask operations and
determine if there are any CPU's left in the final set.

So this just makes the bitmask (and cpumask) functions return a boolean
for whether the result has any bits set.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/bitmap.h  |   18 ++++++++----------
 include/linux/cpumask.h |   20 ++++++++++----------
 lib/bitmap.c            |   12 ++++++++----
 3 files changed, 26 insertions(+), 24 deletions(-)

--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -94,13 +94,13 @@ extern void __bitmap_shift_right(unsigne
                         const unsigned long *src, int shift, int bits);
 extern void __bitmap_shift_left(unsigned long *dst,
                         const unsigned long *src, int shift, int bits);
-extern void __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
+extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern void __bitmap_xor(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
-extern void __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
+extern int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_intersects(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
@@ -171,13 +171,12 @@ static inline void bitmap_copy(unsigned 
 	}
 }
 
-static inline void bitmap_and(unsigned long *dst, const unsigned long *src1,
+static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = *src1 & *src2;
-	else
-		__bitmap_and(dst, src1, src2, nbits);
+		return (*dst = *src1 & *src2) != 0;
+	return __bitmap_and(dst, src1, src2, nbits);
 }
 
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
@@ -198,13 +197,12 @@ static inline void bitmap_xor(unsigned l
 		__bitmap_xor(dst, src1, src2, nbits);
 }
 
-static inline void bitmap_andnot(unsigned long *dst, const unsigned long *src1,
+static inline int bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
 	if (small_const_nbits(nbits))
-		*dst = *src1 & ~(*src2);
-	else
-		__bitmap_andnot(dst, src1, src2, nbits);
+		return (*dst = *src1 & ~(*src2)) != 0;
+	return __bitmap_andnot(dst, src1, src2, nbits);
 }
 
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -43,10 +43,10 @@
  * int cpu_isset(cpu, mask)		true iff bit 'cpu' set in mask
  * int cpu_test_and_set(cpu, mask)	test and set bit 'cpu' in mask
  *
- * void cpus_and(dst, src1, src2)	dst = src1 & src2  [intersection]
+ * int cpus_and(dst, src1, src2)	dst = src1 & src2  [intersection]
  * void cpus_or(dst, src1, src2)	dst = src1 | src2  [union]
  * void cpus_xor(dst, src1, src2)	dst = src1 ^ src2
- * void cpus_andnot(dst, src1, src2)	dst = src1 & ~src2
+ * int cpus_andnot(dst, src1, src2)	dst = src1 & ~src2
  * void cpus_complement(dst, src)	dst = ~src
  *
  * int cpus_equal(mask1, mask2)		Does mask1 == mask2?
@@ -179,10 +179,10 @@ static inline int __cpu_test_and_set(int
 }
 
 #define cpus_and(dst, src1, src2) __cpus_and(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
+static inline int __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
 					const cpumask_t *src2p, int nbits)
 {
-	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
@@ -201,10 +201,10 @@ static inline void __cpus_xor(cpumask_t 
 
 #define cpus_andnot(dst, src1, src2) \
 				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
+static inline int __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
 					const cpumask_t *src2p, int nbits)
 {
-	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_complement(dst, src) __cpus_complement(&(dst), &(src), NR_CPUS)
@@ -738,11 +738,11 @@ static inline void cpumask_clear(struct 
  * @src1p: the first input
  * @src2p: the second input
  */
-static inline void cpumask_and(struct cpumask *dstp,
+static inline int cpumask_and(struct cpumask *dstp,
 			       const struct cpumask *src1p,
 			       const struct cpumask *src2p)
 {
-	bitmap_and(cpumask_bits(dstp), cpumask_bits(src1p),
+	return bitmap_and(cpumask_bits(dstp), cpumask_bits(src1p),
 				       cpumask_bits(src2p), nr_cpumask_bits);
 }
 
@@ -779,11 +779,11 @@ static inline void cpumask_xor(struct cp
  * @src1p: the first input
  * @src2p: the second input
  */
-static inline void cpumask_andnot(struct cpumask *dstp,
+static inline int cpumask_andnot(struct cpumask *dstp,
 				  const struct cpumask *src1p,
 				  const struct cpumask *src2p)
 {
-	bitmap_andnot(cpumask_bits(dstp), cpumask_bits(src1p),
+	return bitmap_andnot(cpumask_bits(dstp), cpumask_bits(src1p),
 					  cpumask_bits(src2p), nr_cpumask_bits);
 }
 
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -179,14 +179,16 @@ void __bitmap_shift_left(unsigned long *
 }
 EXPORT_SYMBOL(__bitmap_shift_left);
 
-void __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
+int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
 {
 	int k;
 	int nr = BITS_TO_LONGS(bits);
+	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
-		dst[k] = bitmap1[k] & bitmap2[k];
+		result |= (dst[k] = bitmap1[k] & bitmap2[k]);
+	return result != 0;
 }
 EXPORT_SYMBOL(__bitmap_and);
 
@@ -212,14 +214,16 @@ void __bitmap_xor(unsigned long *dst, co
 }
 EXPORT_SYMBOL(__bitmap_xor);
 
-void __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
+int __bitmap_andnot(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, int bits)
 {
 	int k;
 	int nr = BITS_TO_LONGS(bits);
+	unsigned long result = 0;
 
 	for (k = 0; k < nr; k++)
-		dst[k] = bitmap1[k] & ~bitmap2[k];
+		result |= (dst[k] = bitmap1[k] & ~bitmap2[k]);
+	return result != 0;
 }
 EXPORT_SYMBOL(__bitmap_andnot);
 


