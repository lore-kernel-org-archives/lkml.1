Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYI2SDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYI2SDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYI2SCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:54 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753894AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180250.825653000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:55 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/31] cpumask: Provide new cpumask API
Content-Disposition: inline; filename=cpumask-base
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide new cpumask interface API.  The relevant change is basically
cpumask_t becomes an opaque object.  I believe this results in the
minimum amount of editing while still allowing the inline cpumask
functions, and the ability to declare static cpumask objects.


    /* raw declaration */
    struct __cpumask_data_s { DECLARE_BITMAP(bits, NR_CPUS); };

    /* cpumask_map_t used for declaring static cpumask maps */
    typedef struct __cpumask_data_s cpumask_map_t[1];

    /* cpumask_t used for function args and return pointers */
    typedef struct __cpumask_data_s *cpumask_t;
    typedef const struct __cpumask_data_s *const_cpumask_t;

    /* cpumask_var_t used for local variable, definition follows */
    typedef struct __cpumask_data_s	cpumask_var_t[1]; /* SMALL NR_CPUS */
    typedef struct __cpumask_data_s	*cpumask_var_t;	  /* LARGE NR_CPUS */

    /* replaces cpumask_t dst = (cpumask_t)src */
    void cpus_copy(cpumask_t dst, const cpumask_t src);

Remove the '*' indirection in all references to cpumask_t objects.  You can
change the reference to the cpumask object but not the cpumask object itself
without using the functions that operate on cpumask objects (f.e. the cpu_*
operators).  Functions can return a cpumask_t (which is a pointer to the
cpumask object) and only be passed a cpumask_t.

All uses of cpumask_t on the stack are changed to be cpumask_var_t except
for pointers to static cpumask objects.  Allocation of local (temp) cpumask
objects will follow...

All cpumask operators now operate using nr_cpu_ids instead of NR_CPUS.  All
variants of the cpumask operators which used nr_cpu_ids instead of NR_CPUS
are deleted.

All variants of functions which use the (old cpumask_t *) pointer are deleted
(f.e. set_cpus_allowed_ptr()).

Based on code from Rusty Russell <rusty@rustcorp.com.au> (THANKS!!)

Signed-of-by: Mike Travis <travis@sgi.com>

---
 include/linux/cpumask.h       |  445 +++++++++++++++++++++++-------------------
 include/linux/cpumask_alloc.h |   55 ++---
 2 files changed, 280 insertions(+), 220 deletions(-)

--- struct-cpumasks.orig/include/linux/cpumask.h
+++ struct-cpumasks/include/linux/cpumask.h
@@ -3,7 +3,8 @@
 
 /*
  * Cpumasks provide a bitmap suitable for representing the
- * set of CPU's in a system, one bit position per CPU number.
+ * set of CPU's in a system, one bit position per CPU number up to
+ * nr_cpu_ids (<= NR_CPUS).
  *
  * See detailed comments in the file linux/bitmap.h describing the
  * data type on which these cpumasks are based.
@@ -18,18 +19,6 @@
  * For details of cpus_fold(), see bitmap_fold in lib/bitmap.c.
  *
  * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
- * Note: The alternate operations with the suffix "_nr" are used
- *       to limit the range of the loop to nr_cpu_ids instead of
- *       NR_CPUS when NR_CPUS > 64 for performance reasons.
- *       If NR_CPUS is <= 64 then most assembler bitmask
- *       operators execute faster with a constant range, so
- *       the operator will continue to use NR_CPUS.
- *
- *       Another consideration is that nr_cpu_ids is initialized
- *       to NR_CPUS and isn't lowered until the possible cpus are
- *       discovered (including any disabled cpus).  So early uses
- *       will span the entire range of NR_CPUS.
- * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
  *
  * The available cpumask operations are:
  *
@@ -37,6 +26,7 @@
  * void cpu_clear(cpu, mask)		turn off bit 'cpu' in mask
  * void cpus_setall(mask)		set all bits
  * void cpus_clear(mask)		clear all bits
+ * void cpus_copy(dst, src)		copies cpumask bits from src to dst
  * int cpu_isset(cpu, mask)		true iff bit 'cpu' set in mask
  * int cpu_test_and_set(cpu, mask)	test and set bit 'cpu' in mask
  *
@@ -52,19 +42,21 @@
  * int cpus_empty(mask)			Is mask empty (no bits sets)?
  * int cpus_full(mask)			Is mask full (all bits sets)?
  * int cpus_weight(mask)		Hamming weigh - number of set bits
- * int cpus_weight_nr(mask)		Same using nr_cpu_ids instead of NR_CPUS
  *
  * void cpus_shift_right(dst, src, n)	Shift right
  * void cpus_shift_left(dst, src, n)	Shift left
  *
- * int first_cpu(mask)			Number lowest set bit, or NR_CPUS
- * int next_cpu(cpu, mask)		Next cpu past 'cpu', or NR_CPUS
- * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
- *
- * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
- *					(can be used as an lvalue)
- * CPU_MASK_ALL				Initializer - all bits set
- * CPU_MASK_NONE			Initializer - no bits set
+ * int cpus_first(mask)			Number lowest set bit, or nr_cpu_ids
+ * int cpus_next(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
+ * int cpus_next_in(cpu, mask, andmask)	Next cpu in mask & andmask or nr_cpu_ids
+ *
+ * cpumask_t cpumask_of_cpu(cpu)	Return pointer to cpumask with bit
+ *					'cpu' set
+ *
+ * cpu_mask_all				cpumask_map_t of all bits set
+ * CPU_MASK_ALL				Initializer only - all bits set
+ * CPU_MASK_NONE			Initializer only - no bits set
+ * CPU_MASK_CPU0			Initializer only - cpu 0 bit set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
  *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
@@ -76,8 +68,8 @@
  * void cpus_onto(dst, orig, relmap)	*dst = orig relative to relmap
  * void cpus_fold(dst, orig, sz)	dst bits = orig bits mod sz
  *
- * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask using NR_CPUS
- * for_each_cpu_mask_nr(cpu, mask)	for-loop cpu over mask using nr_cpu_ids
+ * for_each_cpu(cpu, mask)		for-loop cpu over mask
+ * for_each_cpu_in(cpu, mask, andmask)	for-loop cpu over mask & andmask
  *
  * int num_online_cpus()		Number of online CPUs
  * int num_possible_cpus()		Number of all possible CPUs
@@ -87,6 +79,7 @@
  * int cpu_possible(cpu)		Is some cpu possible?
  * int cpu_present(cpu)			Is some cpu present (can schedule)?
  *
+ * int any_cpu_in(mask, andmask)	First cpu in mask & andmask
  * int any_online_cpu(mask)		First online cpu in mask
  *
  * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
@@ -107,129 +100,259 @@
 #include <linux/threads.h>
 #include <linux/bitmap.h>
 
-typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
-extern cpumask_t _unused_cpumask_arg_;
+/* raw declaration */
+struct __cpumask_data_s { DECLARE_BITMAP(bits, NR_CPUS); };
+
+/* cpumask_map_t used for declaring static cpumask maps */
+typedef struct __cpumask_data_s cpumask_map_t[1];
+
+/* cpumask_t used for function args and return pointers */
+typedef struct __cpumask_data_s *cpumask_t;
+typedef const struct __cpumask_data_s *const_cpumask_t;
+
+/* cpumask_var_t used for local variable, definition follows */
+
+#if NR_CPUS == 1
+
+/* cpumask_var_t used for local variable */
+typedef struct __cpumask_data_s	cpumask_var_t[1];
+
+#define nr_cpu_ids			1
+#define cpus_first(src)			({ (void)(src); 0; })
+#define cpus_next(n, src)		({ (void)(src); 1; })
+#define cpus_next_in(n, src, andsrc)	({ (void)(src); 1; })
+#define any_online_cpu(mask)		0
+#define for_each_cpu(cpu, mask)	\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+#define for_each_cpu_in(cpu, mask, andmask) \
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)andmask)
+
+#define num_online_cpus()		1
+#define num_possible_cpus()		1
+#define num_present_cpus()		1
+#define cpu_online(cpu)			((cpu) == 0)
+#define cpu_possible(cpu)		((cpu) == 0)
+#define cpu_present(cpu)		((cpu) == 0)
+#define cpu_active(cpu)			((cpu) == 0)
+
+#else /* ... NR_CPUS > 1 */
+
+#ifndef CONFIG_CPUMASKS_OFFSTACK
+
+/* Constant is usually more efficient than a variable for small NR_CPUS */
+#define nr_cpu_ids		NR_CPUS
+
+/* cpumask_var_t used for local variable */
+typedef struct __cpumask_data_s	cpumask_var_t[1];
+static inline int cpumask_size(void)
+{
+	return sizeof(struct __cpumask_data_s);
+}
+
+#else
+
+/* Starts at NR_CPUS until acpi code discovers actual number. */
+extern int nr_cpu_ids;
 
-#define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
-static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
+/* cpumask_var_t used for local variable */
+typedef struct __cpumask_data_s	*cpumask_var_t;
+static inline int cpumask_size(void)
+{
+	return BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+}
+
+#endif /* NR_CPUS > BITS_PER_LONG */
+
+extern int cpus_first(const_cpumask_t srcp);
+extern int cpus_next(int n, const_cpumask_t srcp);
+extern int cpus_next_in(int n, const_cpumask_t srcp, const_cpumask_t andsrc);
+extern int any_cpu_in(const_cpumask_t mask, const_cpumask_t andmask);
+
+#define any_online_cpu(mask)	any_cpu_in((const_cpumask_t)(mask), \
+					   (const_cpumask_t)cpu_online_map)
+
+#define for_each_cpu(cpu, mask)				\
+	for ((cpu) = -1;				\
+		(cpu) = cpus_next((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids; )
+
+#define for_each_cpu_in(cpu, mask, andmask)			\
+	for ((cpu) = -1;					\
+		(cpu) = cpus_next_in((cpu), (mask), (andmask)),	\
+		(cpu) < nr_cpu_ids; )
+
+
+#define num_online_cpus()	cpus_weight(cpu_online_map)
+#define num_possible_cpus()	cpus_weight(cpu_possible_map)
+#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
+#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
+#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
+
+/* Deprecated: use for_each_cpu() */
+#define for_each_cpu_mask(cpu, mask)	\
+	for_each_cpu(cpu, mask)
+/*
+ * XXX - how to add this to the above macro?
+ * #warning "for_each_cpu_mask is deprecated, use for_each_cpu"
+ */
+
+/* Deprecated: use cpus_first() */
+static inline int __deprecated first_cpu(const_cpumask_t srcp)
+{
+	return cpus_first(srcp);
+}
+
+/* Deprecated: use cpus_next() */
+static inline int __deprecated next_cpu(int n, const_cpumask_t srcp)
+{
+	return cpus_next(n, srcp);
+}
+#endif /* NR_CPUS > 1 */
+
+#define cpu_set(cpu, dst) __cpu_set((cpu), (dst))
+static inline void __cpu_set(int cpu, volatile cpumask_t dstp)
 {
 	set_bit(cpu, dstp->bits);
 }
 
-#define cpu_clear(cpu, dst) __cpu_clear((cpu), &(dst))
-static inline void __cpu_clear(int cpu, volatile cpumask_t *dstp)
+#define cpu_clear(cpu, dst) __cpu_clear((cpu), (dst))
+static inline void __cpu_clear(int cpu, volatile cpumask_t dstp)
 {
 	clear_bit(cpu, dstp->bits);
 }
 
-#define cpus_setall(dst) __cpus_setall(&(dst), NR_CPUS)
-static inline void __cpus_setall(cpumask_t *dstp, int nbits)
+#define cpus_setall(dst) __cpus_setall((dst), nr_cpu_ids)
+static inline void __cpus_setall(cpumask_t dstp, int nbits)
 {
 	bitmap_fill(dstp->bits, nbits);
 }
 
-#define cpus_clear(dst) __cpus_clear(&(dst), NR_CPUS)
-static inline void __cpus_clear(cpumask_t *dstp, int nbits)
+#define cpus_clear(dst) __cpus_clear((dst), nr_cpu_ids)
+static inline void __cpus_clear(cpumask_t dstp, int nbits)
 {
 	bitmap_zero(dstp->bits, nbits);
 }
 
+#define cpus_copy(dst, src) \
+	__cpus_copy((dst), (const_cpumask_t)(src), nr_cpu_ids)
+static inline void __cpus_copy(cpumask_t dstp, const_cpumask_t srcp, int nbits)
+{
+	bitmap_copy(dstp->bits, srcp->bits, nbits);
+}
+
 /* No static inline type checking - see Subtlety (1) above. */
-#define cpu_isset(cpu, cpumask) test_bit((cpu), (cpumask).bits)
+#define cpu_isset(cpu, cpumask) test_bit((cpu), (cpumask)->bits)
 
-#define cpu_test_and_set(cpu, cpumask) __cpu_test_and_set((cpu), &(cpumask))
-static inline int __cpu_test_and_set(int cpu, cpumask_t *addr)
+#define cpu_test_and_set(cpu, cpumask) __cpu_test_and_set((cpu), (cpumask))
+static inline int __cpu_test_and_set(int cpu, cpumask_t addr)
 {
 	return test_and_set_bit(cpu, addr->bits);
 }
 
-#define cpus_and(dst, src1, src2) __cpus_and(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_and(dst, src1, src2)			\
+	__cpus_and((dst), (const_cpumask_t)(src1),	\
+		          (const_cpumask_t)(src2), nr_cpu_ids)
+static inline void __cpus_and(cpumask_t dstp, const_cpumask_t src1p,
+					      const_cpumask_t src2p, int nbits)
 {
 	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_or(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_or(dst, src1, src2) 			\
+	__cpus_or((dst), (const_cpumask_t)(src1),	\
+			 (const_cpumask_t)(src2), nr_cpu_ids)
+static inline void __cpus_or(cpumask_t dstp, const_cpumask_t src1p,
+					     const_cpumask_t src2p, int nbits)
 {
 	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_xor(dst, src1, src2) __cpus_xor(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_xor(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_xor(dst, src1, src2)			\
+	__cpus_xor((dst), (const_cpumask_t)(src1),	\
+			  (const_cpumask_t)(src2), nr_cpu_ids)
+static inline void __cpus_xor(cpumask_t dstp, const_cpumask_t src1p,
+					      const_cpumask_t src2p, int nbits)
 {
 	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_andnot(dst, src1, src2) \
-				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_andnot(dst, src1, src2)			\
+	__cpus_andnot((dst), (const_cpumask_t)(src1),	\
+			     (const_cpumask_t)(src2), nr_cpu_ids)
+static inline void __cpus_andnot(cpumask_t dstp, const_cpumask_t src1p,
+					const_cpumask_t src2p, int nbits)
 {
 	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_complement(dst, src) __cpus_complement(&(dst), &(src), NR_CPUS)
-static inline void __cpus_complement(cpumask_t *dstp,
-					const cpumask_t *srcp, int nbits)
+#define cpus_complement(dst, src)			\
+	__cpus_complement((dst), (const_cpumask_t)(src), nr_cpu_ids)
+static inline void __cpus_complement(cpumask_t dstp,
+					const_cpumask_t srcp, int nbits)
 {
 	bitmap_complement(dstp->bits, srcp->bits, nbits);
 }
 
-#define cpus_equal(src1, src2) __cpus_equal(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_equal(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_equal(src1, src2)				\
+	__cpus_equal((const_cpumask_t)(src1),		\
+		     (const_cpumask_t)(src2), nr_cpu_ids)
+static inline int __cpus_equal(const_cpumask_t src1p,
+					const_cpumask_t src2p, int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_intersects(src1, src2) __cpus_intersects(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_intersects(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_intersects(src1, src2)			\
+	__cpus_intersects((const_cpumask_t)(src1),	\
+			  (const_cpumask_t)(src2), nr_cpu_ids)
+static inline int __cpus_intersects(const_cpumask_t src1p,
+					const_cpumask_t src2p, int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_subset(src1, src2) __cpus_subset(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_subset(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_subset(src1, src2)				\
+	__cpus_subset((const_cpumask_t)(src1),		\
+		      (const_cpumask_t)(src2), nr_cpu_ids)
+static inline int __cpus_subset(const_cpumask_t src1p,
+					const_cpumask_t src2p, int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_empty(src) __cpus_empty(&(src), NR_CPUS)
-static inline int __cpus_empty(const cpumask_t *srcp, int nbits)
+#define cpus_empty(src) __cpus_empty((const_cpumask_t)(src), nr_cpu_ids)
+static inline int __cpus_empty(const_cpumask_t srcp, int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
-#define cpus_full(cpumask) __cpus_full(&(cpumask), NR_CPUS)
-static inline int __cpus_full(const cpumask_t *srcp, int nbits)
+#define cpus_full(cpumask) __cpus_full((const_cpumask_t)(cpumask), nr_cpu_ids)
+static inline int __cpus_full(const_cpumask_t srcp, int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
 
-#define cpus_weight(cpumask) __cpus_weight(&(cpumask), NR_CPUS)
-static inline int __cpus_weight(const cpumask_t *srcp, int nbits)
+#define cpus_weight(cpumask)				\
+	__cpus_weight((const_cpumask_t)(cpumask), nr_cpu_ids)
+static inline int __cpus_weight(const_cpumask_t srcp, int nbits)
 {
 	return bitmap_weight(srcp->bits, nbits);
 }
 
-#define cpus_shift_right(dst, src, n) \
-			__cpus_shift_right(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_right(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
+#define cpus_shift_right(dst, src, n)			\
+	__cpus_shift_right((dst), (const_cpumask_t)(src), (n), nr_cpu_ids)
+static inline void __cpus_shift_right(cpumask_t dstp,
+					const_cpumask_t srcp, int n, int nbits)
 {
 	bitmap_shift_right(dstp->bits, srcp->bits, n, nbits);
 }
 
-#define cpus_shift_left(dst, src, n) \
-			__cpus_shift_left(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_left(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
+#define cpus_shift_left(dst, src, n)			\
+	__cpus_shift_left((dst), (const_cpumask_t)(src), (n), nr_cpu_ids)
+static inline void __cpus_shift_left(cpumask_t dstp,
+					const_cpumask_t srcp, int n, int nbits)
 {
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
@@ -244,11 +367,11 @@ static inline void __cpus_shift_left(cpu
 extern const unsigned long
 	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
 
-static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
+static inline const_cpumask_t get_cpu_mask(unsigned int cpu)
 {
 	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
 	p -= cpu / BITS_PER_LONG;
-	return (const cpumask_t *)p;
+	return (const_cpumask_t)p;
 }
 
 /*
@@ -256,151 +379,98 @@ static inline const cpumask_t *get_cpu_m
  * gcc optimizes it out (it's a constant) and there's no huge stack
  * variable created:
  */
-#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
-
+#define cpumask_of_cpu(cpu) ((const_cpumask_t)get_cpu_mask(cpu))
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
+#define	CPU_MASK_INIT(value) { [0] = { {				\
+	[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  value			\
+} } }
 
 #if NR_CPUS <= BITS_PER_LONG
 
-#define CPU_MASK_ALL							\
-(cpumask_t) { {								\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
-
-#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
+/* Initializer only, use cpu_mask_all in function arguments */
+#define CPU_MASK_ALL CPU_MASK_INIT(CPU_MASK_LAST_WORD)
 
 #else
 
-#define CPU_MASK_ALL							\
-(cpumask_t) { {								\
+/* Initializer only, use cpu_mask_all in function arguments */
+#define CPU_MASK_ALL { [0] = { {					\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
-
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
+} } }
 
 #endif
 
-#define CPU_MASK_NONE							\
-(cpumask_t) { {								\
-	[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  0UL				\
-} }
-
-#define CPU_MASK_CPU0							\
-(cpumask_t) { {								\
-	[0] =  1UL							\
-} }
+/* Initializers only */
+#define CPU_MASK_NONE CPU_MASK_INIT(0UL)
+#define CPU_MASK_CPU0 CPU_MASK_INIT(1UL)
 
-#define cpus_addr(src) ((src).bits)
+#define cpus_addr(src) ((unsigned long *)((src)->bits))
 
-#define cpumask_scnprintf(buf, len, src) \
-			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
+#define cpumask_scnprintf(buf, len, src)		\
+	__cpumask_scnprintf((buf), (len), (const_cpumask_t)(src), nr_cpu_ids)
 static inline int __cpumask_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
+					const_cpumask_t srcp, int nbits)
 {
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
-#define cpumask_parse_user(ubuf, ulen, dst) \
-			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
+#define cpumask_parse_user(ubuf, ulen, dst)		\
+	__cpumask_parse_user((ubuf), (ulen), (dst), nr_cpu_ids)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
-					cpumask_t *dstp, int nbits)
+					cpumask_t dstp, int nbits)
 {
 	return bitmap_parse_user(buf, len, dstp->bits, nbits);
 }
 
-#define cpulist_scnprintf(buf, len, src) \
-			__cpulist_scnprintf((buf), (len), &(src), NR_CPUS)
+#define cpulist_scnprintf(buf, len, src)		\
+	__cpulist_scnprintf((buf), (len), (const_cpumask_t)(src), nr_cpu_ids)
 static inline int __cpulist_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
+					const_cpumask_t srcp, int nbits)
 {
 	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
 }
 
-#define cpulist_parse(buf, dst) __cpulist_parse((buf), &(dst), NR_CPUS)
-static inline int __cpulist_parse(const char *buf, cpumask_t *dstp, int nbits)
+#define cpulist_parse(buf, dst) __cpulist_parse((buf), (dst), nr_cpu_ids)
+static inline int __cpulist_parse(const char *buf, cpumask_t dstp, int nbits)
 {
 	return bitmap_parselist(buf, dstp->bits, nbits);
 }
 
-#define cpu_remap(oldbit, old, new) \
-		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
+#define cpu_remap(oldbit, old, new)			\
+	__cpu_remap((oldbit), (const_cpumask_t)(old),	\
+			      (const_cpumask_t)(new), nr_cpu_ids)
 static inline int __cpu_remap(int oldbit,
-		const cpumask_t *oldp, const cpumask_t *newp, int nbits)
+		const_cpumask_t oldp, const_cpumask_t newp, int nbits)
 {
 	return bitmap_bitremap(oldbit, oldp->bits, newp->bits, nbits);
 }
 
-#define cpus_remap(dst, src, old, new) \
-		__cpus_remap(&(dst), &(src), &(old), &(new), NR_CPUS)
-static inline void __cpus_remap(cpumask_t *dstp, const cpumask_t *srcp,
-		const cpumask_t *oldp, const cpumask_t *newp, int nbits)
+#define cpus_remap(dst, src, old, new)			\
+	__cpus_remap((dst), (const_cpumask_t)(src),	\
+			    (const_cpumask_t)(old), (new), nr_cpu_ids)
+static inline void __cpus_remap(cpumask_t dstp, const_cpumask_t srcp,
+		const_cpumask_t oldp, const_cpumask_t newp, int nbits)
 {
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
-#define cpus_onto(dst, orig, relmap) \
-		__cpus_onto(&(dst), &(orig), &(relmap), NR_CPUS)
-static inline void __cpus_onto(cpumask_t *dstp, const cpumask_t *origp,
-		const cpumask_t *relmapp, int nbits)
+#define cpus_onto(dst, orig, relmap)			\
+	__cpus_onto((dst), (const_cpumask_t)(orig), (relmap), nr_cpu_ids)
+static inline void __cpus_onto(cpumask_t dstp, const_cpumask_t origp,
+		const_cpumask_t relmapp, int nbits)
 {
 	bitmap_onto(dstp->bits, origp->bits, relmapp->bits, nbits);
 }
 
-#define cpus_fold(dst, orig, sz) \
-		__cpus_fold(&(dst), &(orig), sz, NR_CPUS)
-static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
+#define cpus_fold(dst, orig, sz)			\
+	__cpus_fold((dst), (const_cpumask_t)(orig), sz, nr_cpu_ids)
+static inline void __cpus_fold(cpumask_t dstp, const_cpumask_t origp,
 		int sz, int nbits)
 {
 	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
 }
 
-#if NR_CPUS == 1
-
-#define nr_cpu_ids		1
-#define first_cpu(src)		({ (void)(src); 0; })
-#define next_cpu(n, src)	({ (void)(src); 1; })
-#define any_online_cpu(mask)	0
-#define for_each_cpu_mask(cpu, mask)	\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-
-#else /* NR_CPUS > 1 */
-
-extern int nr_cpu_ids;
-int __first_cpu(const cpumask_t *srcp);
-int __next_cpu(int n, const cpumask_t *srcp);
-int __any_online_cpu(const cpumask_t *mask);
-
-#define first_cpu(src)		__first_cpu(&(src))
-#define next_cpu(n, src)	__next_cpu((n), &(src))
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
-#define for_each_cpu_mask(cpu, mask)			\
-	for ((cpu) = -1;				\
-		(cpu) = next_cpu((cpu), (mask)),	\
-		(cpu) < NR_CPUS; )
-#endif
-
-#if NR_CPUS <= 64
-
-#define next_cpu_nr(n, src)		next_cpu(n, src)
-#define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
-#define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
-
-#else /* NR_CPUS > 64 */
-
-int __next_cpu_nr(int n, const cpumask_t *srcp);
-#define next_cpu_nr(n, src)	__next_cpu_nr((n), &(src))
-#define cpus_weight_nr(cpumask)	__cpus_weight(&(cpumask), nr_cpu_ids)
-#define for_each_cpu_mask_nr(cpu, mask)			\
-	for ((cpu) = -1;				\
-		(cpu) = next_cpu_nr((cpu), (mask)),	\
-		(cpu) < nr_cpu_ids; )
-
-#endif /* NR_CPUS > 64 */
-
 /*
  * The following particular system cpumasks and operations manage
  * possible, present, active and online cpus.  Each of them is a fixed size
@@ -458,33 +528,16 @@ int __next_cpu_nr(int n, const cpumask_t
  *        main(){ set1(3); set2(5); }
  */
 
-extern cpumask_t cpu_possible_map;
-extern cpumask_t cpu_online_map;
-extern cpumask_t cpu_present_map;
-extern cpumask_t cpu_active_map;
-
-#if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
-#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
-#define num_present_cpus()	cpus_weight_nr(cpu_present_map)
-#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
-#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
-#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
-#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
-#else
-#define num_online_cpus()	1
-#define num_possible_cpus()	1
-#define num_present_cpus()	1
-#define cpu_online(cpu)		((cpu) == 0)
-#define cpu_possible(cpu)	((cpu) == 0)
-#define cpu_present(cpu)	((cpu) == 0)
-#define cpu_active(cpu)		((cpu) == 0)
-#endif
+extern cpumask_map_t cpu_possible_map;
+extern cpumask_map_t cpu_online_map;
+extern cpumask_map_t cpu_present_map;
+extern cpumask_map_t cpu_active_map;
+extern cpumask_map_t cpu_mask_all;
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), cpu_possible_map)
-#define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), cpu_online_map)
-#define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), cpu_present_map)
+#define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_map)
+#define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_map)
+#define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_map)
 
 #endif /* __LINUX_CPUMASK_H */
--- struct-cpumasks.orig/include/linux/cpumask_alloc.h
+++ struct-cpumasks/include/linux/cpumask_alloc.h
@@ -5,33 +5,36 @@
  * Simple alloc/free of cpumask structs
  */
 
-#if NR_CPUS > BITS_PER_LONG
-
-#include <linux/slab.h>
-
-/* Allocates a cpumask large enough to contain nr_cpu_ids cpus */
-static inline int cpumask_alloc(cpumask_t *m)
+#ifndef CONFIG_CPUMASKS_OFFSTACK
+static inline int cpumask_alloc(cpumask_var_t *m)
 {
-	cpumask_t d = kmalloc(CPUMASK_SIZE, GFP_KERNEL);
-
-	*m = d;
-	return (d != NULL);
+	return 1;
 }
 
-static inline void cpumask_free_(cpumask_t *m)
+static inline void cpumask_free(cpumask_var_t *m)
 {
-	kfree(*m);
 }
 
 #else
-static inline cpumask_val cpumask_alloc(cpumask_t *m)
+
+#include <linux/slab.h>
+
+/*
+ * Allocates a cpumask large enough to contain nr_cpu_ids cpus
+ * Returns true if allocation succeeded.
+ */
+static inline int cpumask_alloc(cpumask_var_t *m)
 {
+	cpumask_var_t d = kmalloc(cpumask_size(), GFP_KERNEL);
+
+	*m = d;
+	return (d != NULL);
 }
 
-static inline void cpumask_free(cpumask_t *m)
+static inline void cpumask_free_(cpumask_var_t *m)
 {
+	kfree(*m);
 }
-
 #endif
 
 /*
@@ -40,23 +43,27 @@ static inline void cpumask_free(cpumask_
 struct cpumask_pool_s {
 	unsigned long	length;
 	unsigned long	allocated;
-	cpumask_fixed	pool;
+	cpumask_map_t	pool;
 };
 
 #if 0
+
+/* Using fixed map size so length == sizeof(pool)/sizeof(cpumask_map_t) */
 #define DEFINE_PER_CPUMASK_POOL(name, size)		\
 	struct __pool_##name##_s {			\
 		unsigned long	allocated;		\
-		cpumask_data	pool[size];		\
+		cpumask_map_t	pool[size];		\
 	}						\
 	DEFINE_PER_CPU(struct __pool_##name##_s, name)
 #else
+
+/* Ideally here pool would be allocated early to be (cpumask_size() * size) */
 #define DEFINE_PER_CPUMASK_POOL(name, size)		\
 	DEFINE_PER_CPU(					\
 		struct {				\
 			unsigned long	length;		\
 			unsigned long	allocated;	\
-			cpumask_data	pool[size];	\
+			cpumask_map_t	pool[size];	\
 		}, name ) = { .length = size, }
 #endif
 
@@ -69,8 +76,8 @@ static inline int __cpumask_pool_get(cpu
 	int n;
 
 	preempt_disable();
-	while ((n = find_first_bit(&p->allocated, p->length)) < p->length &&
-		!test_and_set_bit(n, &p->allocated)) {
+	while ((n = find_first_zero_bit(&p->allocated, p->length))
+		< p->length && !test_and_set_bit(n, &p->allocated)) {
 
 		*m = &(p->pool[n]);
 		preempt_enable();
@@ -108,20 +115,20 @@ static inline void __cpumask_pool_put(cp
  *	CPUMASK_PTR(mask2, my_cpumasks);
  *
  *	--- DO NOT reference cpumask_t pointers until this check ---
- *	if (my_cpumasks == NULL)
+ *	if (!my_cpumasks)
  *		"kmalloc failed"...
  *
- * References are now cpumask_var variables (*mask1, ...)
+ * References are now cpumask_t variables
  */
 
 #if NR_CPUS > BITS_PER_LONG
 #define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
 #define	CPUMASK_FREE(m)		kfree(m)
-#define	CPUMASK_PTR(v, m) 	cpumask_var v = (m->v)
+#define	CPUMASK_PTR(v, m) 	cpumask_t v = (m->v)
 #else
 #define	CPUMASK_ALLOC(m)	struct m m
 #define	CPUMASK_FREE(m)
-#define	CPUMASK_PTR(v, m) 	cpumask_var v
+#define	CPUMASK_PTR(v, m) 	cpumask_t v = (m->v)
 #endif
 
 #endif /* __LINUX_CPUMASK_ALLOC_H */

-- 
