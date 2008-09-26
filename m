Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbYIZFyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbYIZFyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYIZFxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:53:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37066 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbYIZFxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:53:52 -0400
Message-ID: <48DC78F2.8060400@sgi.com>
Date: Thu, 25 Sep 2008 22:53:54 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, Alan.Brunelle@hp.com,
       tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au>
In-Reply-To: <200809261525.30258.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 26 September 2008 01:42:13 Linus Torvalds wrote:
>> On Thu, 25 Sep 2008, Rusty Russell wrote:
>>>     This turns out to be awful in practice, mainly due to const. 
>>> Consider:
>>>
>>> 	#ifdef CONFIG_CPUMASK_OFFSTACK
>>> 	typedef unsigned long *cpumask_t;
>>> 	#else
>>> 	typedef unsigned long cpumask_t[1];
>>> 	#endif
>>>
>>> 	cpumask_t returns_cpumask(void);
>> No. That's already broken. You cannot return a cpumask_t, regardless of
>> interface. We must not do it regardless of how we pass those things
>> around, since it generates _yet_ another temporary on the stack for the
>> return slot for any kind of structure.
> 
> No, for large NR_CPUS, cpumask_t is a pointer as shown.  And we have numerous 
> basic functions which return a cpumask_t.  Yes, this is part of the problem.
> 
>> What _is_ relevant is how we allocate them when we need temporary CPU
>> masks. And _that_ is where my suggestion comes in. For small NR_CPUS, we
>> really do want to allocate them on the stack, because calling kmalloc for
>> a 4- or 8-byte allocation is just _stupid_.
> 
> Right, but cpumask_t is used for far more than stack decls, thus the problems.
> 
> I can make a separate "cpumask_stack_t" and use your method tho.  I think that 
> might even reduce churn and allow us to do this in parts.
> 
>> which has to be converted some way. And I think it needs to be converted
>> in a way that does *not* force us to call kmalloc() for idiotically small
>> values.
> 
> Yeah, got that.  But your suggestion to change cpumask_t turned out horribly 
> ugly.
> 
> Cheers,
> Rusty.

Hi Rusty,

I've gotten some good traction on the changes in the following patch.  About 30%
of the kernel is compiling right now and I'm picking up errors and warnings as
I'm going along.  I think it's doing most of what we need.  Attempting to hide
the cpumask struct definition caused all kinds of problems with the inline
functions and statically declaring cpumask's.

(The following patch is a combination of all the changes to cpumask.h with the
header from the first patch.  I'll send you a complete copy in separate email.)

Thanks,
Mike
--

Subject: [RFC 1/1] cpumask: Provide new cpumask API

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

--- struct-cpumasks.orig/include/linux/cpumask.h	2008-09-25 20:40:59.303546951 -0700
+++ struct-cpumasks/include/linux/cpumask.h	2008-09-25 22:41:00.764472541 -0700
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
@@ -52,52 +42,22 @@
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
+ * int cpus_first(mask)			Number lowest set bit, or nr_cpu_ids
+ * int cpus_next(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
+ * int cpus_next_in(cpu, mask, andmask)	Next cpu in mask & andmask or nr_cpu_ids
+ *
+ * cpumask_t cpumask_of_cpu(cpu)	Return pointer to cpumask with bit
+ *					'cpu' set
  *
- * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
- *					(can be used as an lvalue)
+ * cpu_mask_all				cpumask_map_t of all bits set
  * CPU_MASK_ALL				Initializer - all bits set
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
  *
- * CPUMASK_ALLOC kmalloc's a structure that is a composite of many cpumask_t
- * variables, and CPUMASK_PTR provides pointers to each field.
- *
- * The structure should be defined something like this:
- * struct my_cpumasks {
- *	cpumask_t mask1;
- *	cpumask_t mask2;
- * };
- *
- * Usage is then:
- *	CPUMASK_ALLOC(my_cpumasks);
- *	CPUMASK_PTR(mask1, my_cpumasks);
- *	CPUMASK_PTR(mask2, my_cpumasks);
- *
- *	--- DO NOT reference cpumask_t pointers until this check ---
- *	if (my_cpumasks == NULL)
- *		"kmalloc failed"...
- *
- * References are now pointers to the cpumask_t variables (*mask1, ...)
- *
- *if NR_CPUS > BITS_PER_LONG
- *   CPUMASK_ALLOC(m)			Declares and allocates struct m *m =
- *						kmalloc(sizeof(*m), GFP_KERNEL)
- *   CPUMASK_FREE(m)			Macro for kfree(m)
- *else
- *   CPUMASK_ALLOC(m)			Declares struct m _m, *m = &_m
- *   CPUMASK_FREE(m)			Nop
- *endif
- *   CPUMASK_PTR(v, m)			Declares cpumask_t *v = &(m->v)
- * ------------------------------------------------------------------------
- *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
  * int cpumask_parse_user(ubuf, ulen, mask)	Parse ascii string as cpumask
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
@@ -107,8 +67,8 @@
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
@@ -118,6 +78,7 @@
  * int cpu_possible(cpu)		Is some cpu possible?
  * int cpu_present(cpu)			Is some cpu present (can schedule)?
  *
+ * int any_cpu_in(mask, andmask)	First cpu in mask & andmask
  * int any_online_cpu(mask)		First online cpu in mask
  *
  * for_each_possible_cpu(cpu)		for-loop cpu over cpu_possible_map
@@ -138,129 +99,229 @@
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
+#ifdef CONFIG_CPUMASKS_ONSTACK
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
+
+/* cpumask_var_t used for local variable */
+typedef struct __cpumask_data_s	*cpumask_var_t;
+static inline int cpumask_size(void)
+{
+	return BITS_TO_LONGS(nr_cpu_ids) * sizeof(long);
+}
+
+#endif /* NR_CPUS > BITS_PER_LONG */
+
+/* Deprecated: use for_each_cpu() */
+#define for_each_cpu_mask(cpu, mask)	for_each_cpu(cpu, mask)
+
+/* Deprecated: use cpus_first()/cpus_next() */
+#define first_cpu(src)		cpus_first((src))
+#define next_cpu(n, src)	cpus_next((n), (src))
+
+extern int cpus_first(const cpumask_t srcp);
+extern int cpus_next(int n, const cpumask_t srcp);
+extern int cpus_next_in(int n, const cpumask_t srcp, const cpumask_t andsrc);
+extern int any_cpu_in(const cpumask_t mask);
+
+#define any_online_cpu(mask)	any_cpu_in((const cpumask_t)(mask), \
+					   (const cpumask_t)cpu_online_map)
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
 
-#define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
-static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
+#define num_online_cpus()	cpus_weight(cpu_online_map)
+#define num_possible_cpus()	cpus_weight(cpu_possible_map)
+#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
+#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
+#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
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
 
+#define cpus_copy(dst, src) __cpus_copy((dst), (src), nr_cpu_ids)
+static inline void __cpus_copy(cpumask_t dstp, const cpumask_t srcp, int nbits)
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
+#define cpus_and(dst, src1, src2) __cpus_and((dst), (src1), (src2), nr_cpu_ids)
+static inline void __cpus_and(cpumask_t dstp, const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_or(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_or(dst, src1, src2) __cpus_or((dst), (src1), (src2), nr_cpu_ids)
+static inline void __cpus_or(cpumask_t dstp, const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_xor(dst, src1, src2) __cpus_xor(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_xor(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_xor(dst, src1, src2) __cpus_xor((dst), (src1), (src2), nr_cpu_ids)
+static inline void __cpus_xor(cpumask_t dstp, const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define cpus_andnot(dst, src1, src2) \
-				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+				__cpus_andnot((dst), (src1), (src2), nr_cpu_ids)
+static inline void __cpus_andnot(cpumask_t dstp, const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_complement(dst, src) __cpus_complement(&(dst), &(src), NR_CPUS)
-static inline void __cpus_complement(cpumask_t *dstp,
-					const cpumask_t *srcp, int nbits)
+#define cpus_complement(dst, src) __cpus_complement((dst), (src), nr_cpu_ids)
+static inline void __cpus_complement(cpumask_t dstp,
+					const cpumask_t srcp, int nbits)
 {
 	bitmap_complement(dstp->bits, srcp->bits, nbits);
 }
 
-#define cpus_equal(src1, src2) __cpus_equal(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_equal(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_equal(src1, src2) __cpus_equal((src1), (src2), nr_cpu_ids)
+static inline int __cpus_equal(const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_intersects(src1, src2) __cpus_intersects(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_intersects(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_intersects(src1, src2) __cpus_intersects((src1), (src2), nr_cpu_ids)
+static inline int __cpus_intersects(const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_subset(src1, src2) __cpus_subset(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_subset(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+#define cpus_subset(src1, src2) __cpus_subset((src1), (src2), nr_cpu_ids)
+static inline int __cpus_subset(const cpumask_t src1p,
+					const cpumask_t src2p, int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
-#define cpus_empty(src) __cpus_empty(&(src), NR_CPUS)
-static inline int __cpus_empty(const cpumask_t *srcp, int nbits)
+#define cpus_empty(src) __cpus_empty((src), nr_cpu_ids)
+static inline int __cpus_empty(const cpumask_t srcp, int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
-#define cpus_full(cpumask) __cpus_full(&(cpumask), NR_CPUS)
-static inline int __cpus_full(const cpumask_t *srcp, int nbits)
+#define cpus_full(cpumask) __cpus_full((cpumask), nr_cpu_ids)
+static inline int __cpus_full(const cpumask_t srcp, int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
 
-#define cpus_weight(cpumask) __cpus_weight(&(cpumask), NR_CPUS)
-static inline int __cpus_weight(const cpumask_t *srcp, int nbits)
+#define cpus_weight(cpumask) __cpus_weight((cpumask), nr_cpu_ids)
+static inline int __cpus_weight(const cpumask_t srcp, int nbits)
 {
 	return bitmap_weight(srcp->bits, nbits);
 }
 
 #define cpus_shift_right(dst, src, n) \
-			__cpus_shift_right(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_right(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
+			__cpus_shift_right((dst), (src), (n), nr_cpu_ids)
+static inline void __cpus_shift_right(cpumask_t dstp,
+					const cpumask_t srcp, int n, int nbits)
 {
 	bitmap_shift_right(dstp->bits, srcp->bits, n, nbits);
 }
 
 #define cpus_shift_left(dst, src, n) \
-			__cpus_shift_left(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_left(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
+			__cpus_shift_left((dst), (src), (n), nr_cpu_ids)
+static inline void __cpus_shift_left(cpumask_t dstp,
+					const cpumask_t srcp, int n, int nbits)
 {
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
@@ -275,11 +336,12 @@ static inline void __cpus_shift_left(cpu
 extern const unsigned long
 	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
 
-static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
+/* XXX - "const" causes: "warning: type qualifiers ignored on function return type" */
+static inline /*const*/ cpumask_t get_cpu_mask(unsigned int cpu)
 {
 	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
 	p -= cpu / BITS_PER_LONG;
-	return (const cpumask_t *)p;
+	return (const cpumask_t)p;
 }
 
 /*
@@ -287,7 +349,7 @@ static inline const cpumask_t *get_cpu_m
  * gcc optimizes it out (it's a constant) and there's no huge stack
  * variable created:
  */
-#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
+#define cpumask_of_cpu(cpu) (get_cpu_mask(cpu))
 
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
@@ -295,152 +357,94 @@ static inline const cpumask_t *get_cpu_m
 #if NR_CPUS <= BITS_PER_LONG
 
 #define CPU_MASK_ALL							\
-(cpumask_t) { {								\
+(cpumask_map_t) { [0] = { {						\
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
-
-#define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
+} } }
 
 #else
 
 #define CPU_MASK_ALL							\
-(cpumask_t) { {								\
+(struct __cpumask_data_s) { [0] = { {					\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
 	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
-
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
+} } }
 
 #endif
 
 #define CPU_MASK_NONE							\
-(cpumask_t) { {								\
+(cpumask_map_t) { [0] = { {						\
 	[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  0UL				\
-} }
+} } }
 
 #define CPU_MASK_CPU0							\
-(cpumask_t) { {								\
+(cpumask_map_t) { [0] = { {						\
 	[0] =  1UL							\
-} }
+} } }
 
-#define cpus_addr(src) ((src).bits)
-
-#if NR_CPUS > BITS_PER_LONG
-#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
-#define	CPUMASK_FREE(m)		kfree(m)
-#else
-#define	CPUMASK_ALLOC(m)	struct m _m, *m = &_m
-#define	CPUMASK_FREE(m)
-#endif
-#define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
+#define cpus_addr(src) ((src)->bits)
 
 #define cpumask_scnprintf(buf, len, src) \
-			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
+			__cpumask_scnprintf((buf), (len), (src), nr_cpu_ids)
 static inline int __cpumask_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
+					const cpumask_t srcp, int nbits)
 {
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
 #define cpumask_parse_user(ubuf, ulen, dst) \
-			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
+			__cpumask_parse_user((ubuf), (ulen), (dst), nr_cpu_ids)
 static inline int __cpumask_parse_user(const char __user *buf, int len,
-					cpumask_t *dstp, int nbits)
+					cpumask_t dstp, int nbits)
 {
 	return bitmap_parse_user(buf, len, dstp->bits, nbits);
 }
 
 #define cpulist_scnprintf(buf, len, src) \
-			__cpulist_scnprintf((buf), (len), &(src), NR_CPUS)
+			__cpulist_scnprintf((buf), (len), (src), nr_cpu_ids)
 static inline int __cpulist_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
+					const cpumask_t srcp, int nbits)
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
 
 #define cpu_remap(oldbit, old, new) \
-		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
+		__cpu_remap((oldbit), (old), (new), nr_cpu_ids)
 static inline int __cpu_remap(int oldbit,
-		const cpumask_t *oldp, const cpumask_t *newp, int nbits)
+		const cpumask_t oldp, const cpumask_t newp, int nbits)
 {
 	return bitmap_bitremap(oldbit, oldp->bits, newp->bits, nbits);
 }
 
 #define cpus_remap(dst, src, old, new) \
-		__cpus_remap(&(dst), &(src), &(old), &(new), NR_CPUS)
-static inline void __cpus_remap(cpumask_t *dstp, const cpumask_t *srcp,
-		const cpumask_t *oldp, const cpumask_t *newp, int nbits)
+		__cpus_remap((dst), (src), (old), (new), nr_cpu_ids)
+static inline void __cpus_remap(cpumask_t dstp, const cpumask_t srcp,
+		const cpumask_t oldp, const cpumask_t newp, int nbits)
 {
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
 #define cpus_onto(dst, orig, relmap) \
-		__cpus_onto(&(dst), &(orig), &(relmap), NR_CPUS)
-static inline void __cpus_onto(cpumask_t *dstp, const cpumask_t *origp,
-		const cpumask_t *relmapp, int nbits)
+		__cpus_onto((dst), (orig), (relmap), nr_cpu_ids)
+static inline void __cpus_onto(cpumask_t dstp, const cpumask_t origp,
+		const cpumask_t relmapp, int nbits)
 {
 	bitmap_onto(dstp->bits, origp->bits, relmapp->bits, nbits);
 }
 
 #define cpus_fold(dst, orig, sz) \
-		__cpus_fold(&(dst), &(orig), sz, NR_CPUS)
-static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
+		__cpus_fold((dst), (orig), sz, nr_cpu_ids)
+static inline void __cpus_fold(cpumask_t dstp, const cpumask_t origp,
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
@@ -498,33 +502,16 @@ int __next_cpu_nr(int n, const cpumask_t
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
