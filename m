Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbYLIEDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbYLIEDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 23:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLIEDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 23:03:13 -0500
Received: from ozlabs.org ([203.10.76.45]:45356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbYLIEDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 23:03:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [PACH] smp: uninline num_online_cpus() & num_possible_cpus()
Date: Tue, 9 Dec 2008 14:33:03 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <493965F8.6060407@cosmosbay.com>
In-Reply-To: <493965F8.6060407@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091433.03670.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 04:03:44 Eric Dumazet wrote:
> num_online_cpus() and num_possible_cpus() are not performance
> critical and are quite large.
> 
> Unlining them shrinks kernel text size by 7523 bytes on x86,
> if NR_CPUS>32

Hi Eric!

  Slight misdiagnosis, I think.  One base problem is addressed in fixing
the bitmap operators (see "[PATCH] bitmap: test for constant as well as
small size for inline versions" on lkml Message-Id: <200811160907.07140.rusty@rustcorp.com.au>).  This is already in
linux-next, and I've pasted it below.

  Worse, you used the obsolete cpumask operators :)

Thanks!
Rusty.

bitmap: test for constant as well as small size for inline versions

bitmap_zero et al have a fastpath for nbits <= BITS_PER_LONG, but this
should really only apply where the nbits is known at compile time.

This only saves about 1200 bytes on an allyesconfig kernel, but with
cpumasks going variable that number will increase.

   text		data	bss	dec		hex	filename
35327852        5035607 6782976 47146435        2cf65c3 vmlinux-before
35326640        5035607 6782976 47145223        2cf6107 vmlinux-after

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/bitmap.h |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -r b4540ad329c1 include/linux/bitmap.h
--- a/include/linux/bitmap.h	Thu Nov 06 13:00:51 2008 +1100
+++ b/include/linux/bitmap.h	Thu Nov 06 14:34:07 2008 +1100
@@ -137,9 +137,12 @@ extern void bitmap_copy_le(void *dst, co
 		(1UL<<((nbits) % BITS_PER_LONG))-1 : ~0UL		\
 )
 
+#define small_const_nbits(nbits) \
+	(__builtin_constant_p(nbits) && (nbits) <= BITS_PER_LONG)
+
 static inline void bitmap_zero(unsigned long *dst, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = 0UL;
 	else {
 		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
@@ -150,7 +153,7 @@ static inline void bitmap_fill(unsigned 
 static inline void bitmap_fill(unsigned long *dst, int nbits)
 {
 	size_t nlongs = BITS_TO_LONGS(nbits);
-	if (nlongs > 1) {
+	if (!small_const_nbits(nbits)) {
 		int len = (nlongs - 1) * sizeof(unsigned long);
 		memset(dst, 0xff,  len);
 	}
@@ -160,7 +163,7 @@ static inline void bitmap_copy(unsigned 
 static inline void bitmap_copy(unsigned long *dst, const unsigned long *src,
 			int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src;
 	else {
 		int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
@@ -171,7 +174,7 @@ static inline void bitmap_and(unsigned l
 static inline void bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 & *src2;
 	else
 		__bitmap_and(dst, src1, src2, nbits);
@@ -180,7 +183,7 @@ static inline void bitmap_or(unsigned lo
 static inline void bitmap_or(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 | *src2;
 	else
 		__bitmap_or(dst, src1, src2, nbits);
@@ -189,7 +192,7 @@ static inline void bitmap_xor(unsigned l
 static inline void bitmap_xor(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 ^ *src2;
 	else
 		__bitmap_xor(dst, src1, src2, nbits);
@@ -198,7 +201,7 @@ static inline void bitmap_andnot(unsigne
 static inline void bitmap_andnot(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src1 & ~(*src2);
 	else
 		__bitmap_andnot(dst, src1, src2, nbits);
@@ -207,7 +210,7 @@ static inline void bitmap_complement(uns
 static inline void bitmap_complement(unsigned long *dst, const unsigned long *src,
 			int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = ~(*src) & BITMAP_LAST_WORD_MASK(nbits);
 	else
 		__bitmap_complement(dst, src, nbits);
@@ -216,7 +219,7 @@ static inline int bitmap_equal(const uns
 static inline int bitmap_equal(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! ((*src1 ^ *src2) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_equal(src1, src2, nbits);
@@ -225,7 +228,7 @@ static inline int bitmap_intersects(cons
 static inline int bitmap_intersects(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ((*src1 & *src2) & BITMAP_LAST_WORD_MASK(nbits)) != 0;
 	else
 		return __bitmap_intersects(src1, src2, nbits);
@@ -234,7 +237,7 @@ static inline int bitmap_subset(const un
 static inline int bitmap_subset(const unsigned long *src1,
 			const unsigned long *src2, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! ((*src1 & ~(*src2)) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_subset(src1, src2, nbits);
@@ -242,7 +245,7 @@ static inline int bitmap_subset(const un
 
 static inline int bitmap_empty(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_empty(src, nbits);
@@ -250,7 +253,7 @@ static inline int bitmap_empty(const uns
 
 static inline int bitmap_full(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return ! (~(*src) & BITMAP_LAST_WORD_MASK(nbits));
 	else
 		return __bitmap_full(src, nbits);
@@ -258,7 +261,7 @@ static inline int bitmap_full(const unsi
 
 static inline int bitmap_weight(const unsigned long *src, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
 	return __bitmap_weight(src, nbits);
 }
@@ -266,7 +269,7 @@ static inline void bitmap_shift_right(un
 static inline void bitmap_shift_right(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = *src >> n;
 	else
 		__bitmap_shift_right(dst, src, n, nbits);
@@ -275,7 +278,7 @@ static inline void bitmap_shift_left(uns
 static inline void bitmap_shift_left(unsigned long *dst,
 			const unsigned long *src, int n, int nbits)
 {
-	if (nbits <= BITS_PER_LONG)
+	if (small_const_nbits(nbits))
 		*dst = (*src << n) & BITMAP_LAST_WORD_MASK(nbits);
 	else
 		__bitmap_shift_left(dst, src, n, nbits);
