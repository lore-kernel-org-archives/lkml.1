Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbZHXDHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbZHXDHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 23:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZHXDHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 23:07:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47493 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZHXDHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 23:07:06 -0400
Date: Mon, 24 Aug 2009 13:07:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20090824130704.a2bbb738.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
include/linux/cpumask.h between commit
f4b0373b26567cafd421d91101852ed7a34e9e94 ("Make bitmask 'and' operators
return a result code") from Linus' tree and commits
de1cb441e0bc1be491e25d3968d0448c0ea0e5eb
("cpumask:remove-unused-deprecated-functions") and
6a795cf86742749ebf01efbe53baa7023bebc7c6
("cpumask:move-obsolete-functions-to-end-of-header") from the rr tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/cpumask.h
index 796df12,5b44e9f..0000000
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@@ -1088,4 -646,241 +646,241 @@@ void set_cpu_active(unsigned int cpu, b
  void init_cpu_present(const struct cpumask *src);
  void init_cpu_possible(const struct cpumask *src);
  void init_cpu_online(const struct cpumask *src);
+ 
+ /**
+  * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
+  * @bitmap: the bitmap
+  *
+  * There are a few places where cpumask_var_t isn't appropriate and
+  * static cpumasks must be used (eg. very early boot), yet we don't
+  * expose the definition of 'struct cpumask'.
+  *
+  * This does the conversion, and can be used as a constant initializer.
+  */
+ #define to_cpumask(bitmap)						\
+ 	((struct cpumask *)(1 ? (bitmap)				\
+ 			    : (void *)sizeof(__check_is_bitmap(bitmap))))
+ 
+ static inline int __check_is_bitmap(const unsigned long *bitmap)
+ {
+ 	return 1;
+ }
+ 
+ /*
+  * Special-case data structure for "single bit set only" constant CPU masks.
+  *
+  * We pre-generate all the 64 (or 32) possible bit positions, with enough
+  * padding to the left and the right, and return the constant pointer
+  * appropriately offset.
+  */
+ extern const unsigned long
+ 	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
+ 
+ static inline const struct cpumask *get_cpu_mask(unsigned int cpu)
+ {
+ 	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
+ 	p -= cpu / BITS_PER_LONG;
+ 	return to_cpumask(p);
+ }
+ 
+ #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
+ 
+ #if NR_CPUS <= BITS_PER_LONG
+ #define CPU_BITS_ALL						\
+ {								\
+ 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+ }
+ 
+ #else /* NR_CPUS > BITS_PER_LONG */
+ 
+ #define CPU_BITS_ALL						\
+ {								\
+ 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
+ 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
+ }
+ #endif /* NR_CPUS > BITS_PER_LONG */
+ 
+ /*
+  *
+  * From here down, all obsolete.  Use cpumask_ variants!
+  *
+  */
+ #ifndef CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS
+ /* These strip const, as traditionally they weren't const. */
+ #define cpu_possible_map	(*(cpumask_t *)cpu_possible_mask)
+ #define cpu_online_map		(*(cpumask_t *)cpu_online_mask)
+ #define cpu_present_map		(*(cpumask_t *)cpu_present_mask)
+ #define cpu_active_map		(*(cpumask_t *)cpu_active_mask)
+ 
+ #define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
+ 
+ #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
+ 
+ #if NR_CPUS <= BITS_PER_LONG
+ 
+ #define CPU_MASK_ALL							\
+ (cpumask_t) { {								\
+ 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
+ } }
+ 
+ #else
+ 
+ #define CPU_MASK_ALL							\
+ (cpumask_t) { {								\
+ 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
+ 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
+ } }
+ 
+ #endif
+ 
+ #define CPU_MASK_NONE							\
+ (cpumask_t) { {								\
+ 	[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  0UL				\
+ } }
+ 
+ #define CPU_MASK_CPU0							\
+ (cpumask_t) { {								\
+ 	[0] =  1UL							\
+ } }
+ 
+ #if NR_CPUS == 1
+ #define first_cpu(src)		({ (void)(src); 0; })
+ #define next_cpu(n, src)	({ (void)(src); 1; })
+ #define any_online_cpu(mask)	0
+ #define for_each_cpu_mask(cpu, mask)	\
+ 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+ #else /* NR_CPUS > 1 */
+ int __first_cpu(const cpumask_t *srcp);
+ int __next_cpu(int n, const cpumask_t *srcp);
+ int __any_online_cpu(const cpumask_t *mask);
+ 
+ #define first_cpu(src)		__first_cpu(&(src))
+ #define next_cpu(n, src)	__next_cpu((n), &(src))
+ #define any_online_cpu(mask) __any_online_cpu(&(mask))
+ #define for_each_cpu_mask(cpu, mask)			\
+ 	for ((cpu) = -1;				\
+ 		(cpu) = next_cpu((cpu), (mask)),	\
+ 		(cpu) < NR_CPUS; )
+ #endif /* SMP */
+ 
+ #if NR_CPUS <= 64
+ 
+ #define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
+ 
+ #else /* NR_CPUS > 64 */
+ 
+ int __next_cpu_nr(int n, const cpumask_t *srcp);
+ #define for_each_cpu_mask_nr(cpu, mask)			\
+ 	for ((cpu) = -1;				\
+ 		(cpu) = __next_cpu_nr((cpu), &(mask)),	\
+ 		(cpu) < nr_cpu_ids; )
+ 
+ #endif /* NR_CPUS > 64 */
+ 
+ #define cpus_addr(src) ((src).bits)
+ 
+ #define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
+ static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
+ {
+ 	set_bit(cpu, dstp->bits);
+ }
+ 
+ #define cpu_clear(cpu, dst) __cpu_clear((cpu), &(dst))
+ static inline void __cpu_clear(int cpu, volatile cpumask_t *dstp)
+ {
+ 	clear_bit(cpu, dstp->bits);
+ }
+ 
+ #define cpus_setall(dst) __cpus_setall(&(dst), NR_CPUS)
+ static inline void __cpus_setall(cpumask_t *dstp, int nbits)
+ {
+ 	bitmap_fill(dstp->bits, nbits);
+ }
+ 
+ #define cpus_clear(dst) __cpus_clear(&(dst), NR_CPUS)
+ static inline void __cpus_clear(cpumask_t *dstp, int nbits)
+ {
+ 	bitmap_zero(dstp->bits, nbits);
+ }
+ 
+ /* No static inline type checking - see Subtlety (1) above. */
+ #define cpu_isset(cpu, cpumask) test_bit((cpu), (cpumask).bits)
+ 
+ #define cpu_test_and_set(cpu, cpumask) __cpu_test_and_set((cpu), &(cpumask))
+ static inline int __cpu_test_and_set(int cpu, cpumask_t *addr)
+ {
+ 	return test_and_set_bit(cpu, addr->bits);
+ }
+ 
+ #define cpus_and(dst, src1, src2) __cpus_and(&(dst), &(src1), &(src2), NR_CPUS)
 -static inline void __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
++static inline int __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
 -	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
++	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
+ static inline void __cpus_or(cpumask_t *dstp, const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
+ 	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_xor(dst, src1, src2) __cpus_xor(&(dst), &(src1), &(src2), NR_CPUS)
+ static inline void __cpus_xor(cpumask_t *dstp, const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
+ 	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_andnot(dst, src1, src2) \
+ 				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
 -static inline void __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
++static inline int __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
 -	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
++	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_equal(src1, src2) __cpus_equal(&(src1), &(src2), NR_CPUS)
+ static inline int __cpus_equal(const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
+ 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_intersects(src1, src2) __cpus_intersects(&(src1), &(src2), NR_CPUS)
+ static inline int __cpus_intersects(const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
+ 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_subset(src1, src2) __cpus_subset(&(src1), &(src2), NR_CPUS)
+ static inline int __cpus_subset(const cpumask_t *src1p,
+ 					const cpumask_t *src2p, int nbits)
+ {
+ 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
+ }
+ 
+ #define cpus_empty(src) __cpus_empty(&(src), NR_CPUS)
+ static inline int __cpus_empty(const cpumask_t *srcp, int nbits)
+ {
+ 	return bitmap_empty(srcp->bits, nbits);
+ }
+ 
+ #define cpus_weight(cpumask) __cpus_weight(&(cpumask), NR_CPUS)
+ static inline int __cpus_weight(const cpumask_t *srcp, int nbits)
+ {
+ 	return bitmap_weight(srcp->bits, nbits);
+ }
+ 
+ #define cpus_shift_left(dst, src, n) \
+ 			__cpus_shift_left(&(dst), &(src), (n), NR_CPUS)
+ static inline void __cpus_shift_left(cpumask_t *dstp,
+ 					const cpumask_t *srcp, int n, int nbits)
+ {
+ 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
+ }
+ #endif /* !CONFIG_DISABLE_OBSOLETE_CPUMASK_FUNCTIONS */
+ 
  #endif /* __LINUX_CPUMASK_H */
