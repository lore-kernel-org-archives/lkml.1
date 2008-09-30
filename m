Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYI3WWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYI3WWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYI3WWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:22:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52558 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752832AbYI3WV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:21:58 -0400
Message-ID: <48E2A691.7060407@sgi.com>
Date: Tue, 30 Sep 2008 15:22:09 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Alan.Brunelle@hp.com, tglx@linutronix.de, rjw@sisk.pl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, arjan@linux.intel.com,
       Jack Steiner <steiner@sgi.com>
Subject: [RFC 1/1] cpumask: New cpumask API - take 2 - use unsigned longs
References: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <200809251150.26760.rusty@rustcorp.com.au> <alpine.LFD.1.10.0809250836270.3265@nehalem.linux-foundation.org> <200809261525.30258.rusty@rustcorp.com.au> <48DC78F2.8060400@sgi.com> <20080927191653.GB18619@elte.hu> <48E0E73A.40803@sgi.com> <20080930110459.GB12529@elte.hu> <48E2506C.7000406@sgi.com> <alpine.LFD.2.00.0809300939450.3389@nehalem.linux-foundation.org> <48E269B6.1080904@sgi.com>
In-Reply-To: <48E269B6.1080904@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Linus Torvalds wrote:
...
>> Your issue with 'const' is just another version of the same. You don't 
>> want the _pointer_ to be const, you want what it points _to_ to be const. 
>> But because you hid the pointerness inside the typedef, you simply cannot 
>> do that.
>>
>> The problem with cpumask's, of course, is that for the "small mask" case, 
>> we really don't want it to be a pointer. So now it's sometimes a pointer 
>> and sometimes not. The typedef hides that, and I understand why it's a 
>> good idea, but I'm surprised you didn't understand what the implications 
>> were for 'const', and I'm now a bit more leery about this whole thing just 
>> because the typedef ends up hiding so much - it doesn't just hide the 
>> basic type, it hides a very basic *code* issue.
> 
> Perhaps then defining the cpumask as a list of unsigned longs (remove the
> outer struct) would play more "naturally".  Lists by definition are always
> referenced by pointers.  I have another version of the patchset that shows
> this and I'll post just the cpumask.h and doc files.
...

Here's an alternate proposal for the new cpumask API.  I have not yet begun
the tedious work of making it compile so there may still be some syntax
errors.  (Init/main.c compiles.)  But I believe it more closely adheres to
proper 'C' coding styles.

Thanks,
Mike
--
Subject: cpumask: Provide new cpumask API

[Copied from Documentation/cpumask.txt]

Introduction

Cpumask variables are used to represent (with a single bit) all the
CPU's in a system.  With the prolific increase in the number of CPU's
in a single system image (SSI), managing this large number of cpus has
become an ordeal.  When the limit of CPU's in a system was small, the
cpumask could fit within an integer.  Even with the increase to 128,
a bit pattern was well within a manageable size.  Now with systems
available that have 2048 cores, with hyper-threading there are 4096
cpu threads.  And the number of cpus in an SSI is growing, 16,384 is
right around the corner.  Even desktop systems with only 2 or 4 sockets,
a new generation of Intel processors that have 128 cores per socket will
increase the count of CPU threads tremendously.

Thus the handling of the cpumask that represents this 4096 limit needs
512 bytes, putting pressure on the amount of stack space needed to
accommodate temporary cpumask variables.

The primary goal of the cpumasks API is to accommodate these large
number of cpus without effecting the compactness of Linux for small,
compact systems.


The Changes

Provide new cpumask interface API.  The relevant change is basically
cpumask_t becomes an pointer to a constant list of unsigned longs
and two new typedef's are used for declaring cpumask_t variables,
cpumask_var_t and cpumask_map_t.  This should result in the minimum
amount of modifications while still allowing the inline cpumask
functions, and the ability to declare static cpumask objects.


    /* cpumask_t is used when pointing to a constant cpumask */
    typedef const unsigned long *cpumask_t;

    /* cpumask_map_t used for declaring static cpumask maps */
    typedef unsigned long cpumask_map_t[BITS_TO_LONGS(nr_cpu_ids)];

    /* cpumask_var_t used for read/write cpumask variables */
    typedef unsigned long cpumask_var_t[BITS_TO_LONGS(nr_cpu_ids)];
    							/* SMALL NR_CPUS */
    typedef unsigned long *cpumask_var_t;		/* LARGE NR_CPUS */

    /* replaces cpumask_t dst = (cpumask_t)src */
    void cpus_copy(cpumask_var_t dst, cpumask_t src);

You can change the reference to the cpumask object but to change the
contents of the cpumask object itself you must use the functions that
operate on cpumask objects (f.e. the cpu_* operators).  Functions can
return a cpumask_t (cpumask pointer) and can only be passed a cpumask_t.

All uses of a cpumask_t variable on the stack are changed to be
cpumask_var_t except for pointers to static (read only) cpumask objects.
Allocation of local (temp) cpumask objects use the functions available
in cpumask_alloc.h.  (descriptions to be supplied.)

All cpumask operators now operate using nr_cpu_ids instead of NR_CPUS.
All variants of the cpumask operators which used nr_cpu_ids instead of
NR_CPUS have been deleted.

All variants of functions which use the (old cpumask_t *) pointer have been
deleted (f.e. set_cpus_allowed_ptr()).

Based on code from Rusty Russell <rusty@rustcorp.com.au> (THANKS!!)

Signed-of-by: Mike Travis <travis@sgi.com>

---
 include/linux/cpumask.h       |  432 +++++++++++++++++++-----------------------
 include/linux/cpumask_alloc.h |   58 +++--
 lib/cpumask.c                 |   36 ++-
 3 files changed, 258 insertions(+), 268 deletions(-)

--- longs-cpumasks.orig/include/linux/cpumask.h
+++ longs-cpumasks/include/linux/cpumask.h
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
+ * const cpumask_t cpumask_of_cpu(cpu)	Return pointer to cpumask with bit
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
@@ -107,131 +100,200 @@
 #include <linux/threads.h>
 #include <linux/bitmap.h>
 
-typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
-extern cpumask_t _unused_cpumask_arg_;
+#if NR_CPUS == 1
+
+typedef (const unsigned long) *cpumask_t;
+typedef unsigned long cpumask_map_t[1];
+typedef unsigned long cpumask_var_t[1];
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
+#ifdef CONFIG_CPUMASKS_OFFSTACK
+
+/* Starts at NR_CPUS until acpi code discovers actual number. */
+extern int nr_cpu_ids;
+typedef unsigned long *cpumask_var_t;
+
+#else /* CPUMASKS "ONSTACK" */
+
+/* Constant is usually more efficient than a variable for small NR_CPUS */
+#define nr_cpu_ids		NR_CPUS
+typedef unsigned long cpumask_var_t[BITS_TO_LONGS(nr_cpu_ids)];
+
+#endif
+
+/* cpumask_t defaults to pointer to constant bit map */
+typedef const unsigned long *cpumask_t;
+typedef unsigned long cpumask_map_t[BITS_TO_LONGS(nr_cpu_ids)];
+
+extern int cpus_first(cpumask_t src);
+extern int cpus_next(int n, cpumask_t src);
+extern int cpus_next_in(int n, cpumask_t src, cpumask_t andsrc);
+extern int any_cpu_in(cpumask_t mask, cpumask_t andmask);
+
+#define any_online_cpu(mask)	any_cpu_in((cpumask_t)(mask), \
+					   (cpumask_t)cpu_online_map)
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
+#define num_online_cpus()	cpus_weight(cpu_online_map)
+#define num_possible_cpus()	cpus_weight(cpu_possible_map)
+#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
+#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
+#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
+
+#endif /* NR_CPUS > 1 */
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
+static inline int __deprecated first_cpu(cpumask_t src)
+{
+	return cpus_first(src);
+}
+
+/* Deprecated: use cpus_next() */
+static inline int __deprecated next_cpu(int n, cpumask_t src)
+{
+	return cpus_next(n, src);
+}
+
+static inline int cpumask_size(void)
+{
+	return BITS_TO_LONGS(nr_cpu_ids) * sizeof(unsigned long);
+}
 
-#define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
-static inline void __cpu_set(int cpu, volatile cpumask_t *dstp)
+static inline void cpu_set(int cpu, volatile cpumask_var_t dst)
 {
-	set_bit(cpu, dstp->bits);
+	set_bit(cpu, dst);
 }
 
-#define cpu_clear(cpu, dst) __cpu_clear((cpu), &(dst))
-static inline void __cpu_clear(int cpu, volatile cpumask_t *dstp)
+static inline void cpu_clear(int cpu, volatile cpumask_var_t dst)
 {
-	clear_bit(cpu, dstp->bits);
+	clear_bit(cpu, dst);
 }
 
-#define cpus_setall(dst) __cpus_setall(&(dst), NR_CPUS)
-static inline void __cpus_setall(cpumask_t *dstp, int nbits)
+static inline void cpus_setall(cpumask_var_t dst)
 {
-	bitmap_fill(dstp->bits, nbits);
+	bitmap_fill(dst, nr_cpu_ids);
 }
 
-#define cpus_clear(dst) __cpus_clear(&(dst), NR_CPUS)
-static inline void __cpus_clear(cpumask_t *dstp, int nbits)
+static inline void cpus_clear(cpumask_var_t dst)
 {
-	bitmap_zero(dstp->bits, nbits);
+	bitmap_zero(dst, nr_cpu_ids);
+}
+
+static inline void cpus_copy(cpumask_var_t dst, cpumask_t src)
+{
+	bitmap_copy(dst, src, nr_cpu_ids);
 }
 
 /* No static inline type checking - see Subtlety (1) above. */
-#define cpu_isset(cpu, cpumask) test_bit((cpu), (cpumask).bits)
+#define cpu_isset(cpu, cpumask) test_bit((cpu), (cpumask))
 
-#define cpu_test_and_set(cpu, cpumask) __cpu_test_and_set((cpu), &(cpumask))
-static inline int __cpu_test_and_set(int cpu, cpumask_t *addr)
+static inline int cpu_test_and_set(int cpu, cpumask_var_t addr)
 {
-	return test_and_set_bit(cpu, addr->bits);
+	return test_and_set_bit(cpu, addr);
 }
 
-#define cpus_and(dst, src1, src2) __cpus_and(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_and(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline void cpus_and(cpumask_var_t dst, cpumask_t src1, cpumask_t src2)
 {
-	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
+	bitmap_and(dst, src1, src2, nr_cpu_ids);
 }
 
-#define cpus_or(dst, src1, src2) __cpus_or(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_or(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline void cpus_or(cpumask_var_t dst, cpumask_t src1, cpumask_t src2)
 {
-	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
+	bitmap_or(dst, src1, src2, nr_cpu_ids);
 }
 
-#define cpus_xor(dst, src1, src2) __cpus_xor(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_xor(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline void cpus_xor(cpumask_var_t dst, cpumask_t src1, cpumask_t src2)
 {
-	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
+	bitmap_xor(dst, src1, src2, nr_cpu_ids);
 }
 
-#define cpus_andnot(dst, src1, src2) \
-				__cpus_andnot(&(dst), &(src1), &(src2), NR_CPUS)
-static inline void __cpus_andnot(cpumask_t *dstp, const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline void cpus_andnot(cpumask_var_t dst, cpumask_t src1,
+						cpumask_t src2)
 {
-	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
+	bitmap_andnot(dst, src1, src2, nr_cpu_ids);
 }
 
-#define cpus_complement(dst, src) __cpus_complement(&(dst), &(src), NR_CPUS)
-static inline void __cpus_complement(cpumask_t *dstp,
-					const cpumask_t *srcp, int nbits)
+static inline void cpus_complement(cpumask_var_t dst, cpumask_t src)
 {
-	bitmap_complement(dstp->bits, srcp->bits, nbits);
+	bitmap_complement(dst, src, nr_cpu_ids);
 }
 
-#define cpus_equal(src1, src2) __cpus_equal(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_equal(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline int cpus_equal(cpumask_t src1, cpumask_t src2)
 {
-	return bitmap_equal(src1p->bits, src2p->bits, nbits);
+	return bitmap_equal(src1, src2, nr_cpu_ids);
 }
 
-#define cpus_intersects(src1, src2) __cpus_intersects(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_intersects(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline int cpus_intersects(cpumask_t src1, cpumask_t src2)
 {
-	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
+	return bitmap_intersects(src1, src2, nr_cpu_ids);
 }
 
-#define cpus_subset(src1, src2) __cpus_subset(&(src1), &(src2), NR_CPUS)
-static inline int __cpus_subset(const cpumask_t *src1p,
-					const cpumask_t *src2p, int nbits)
+static inline int cpus_subset(cpumask_t src1, cpumask_t src2)
 {
-	return bitmap_subset(src1p->bits, src2p->bits, nbits);
+	return bitmap_subset(src1, src2, nr_cpu_ids);
 }
 
-#define cpus_empty(src) __cpus_empty(&(src), NR_CPUS)
-static inline int __cpus_empty(const cpumask_t *srcp, int nbits)
+static inline int cpus_empty(cpumask_t src)
 {
-	return bitmap_empty(srcp->bits, nbits);
+	return bitmap_empty(src, nr_cpu_ids);
 }
 
-#define cpus_full(cpumask) __cpus_full(&(cpumask), NR_CPUS)
-static inline int __cpus_full(const cpumask_t *srcp, int nbits)
+static inline int cpus_full(cpumask_t src)
 {
-	return bitmap_full(srcp->bits, nbits);
+	return bitmap_full(src, nr_cpu_ids);
 }
 
-#define cpus_weight(cpumask) __cpus_weight(&(cpumask), NR_CPUS)
-static inline int __cpus_weight(const cpumask_t *srcp, int nbits)
+static inline int cpus_weight(cpumask_t src)
 {
-	return bitmap_weight(srcp->bits, nbits);
+	return bitmap_weight(src, nr_cpu_ids);
 }
 
-#define cpus_shift_right(dst, src, n) \
-			__cpus_shift_right(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_right(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
+static inline void cpus_shift_right(cpumask_var_t dst, cpumask_t src, int n)
 {
-	bitmap_shift_right(dstp->bits, srcp->bits, n, nbits);
+	bitmap_shift_right(dst, src, n, nr_cpu_ids);
 }
 
-#define cpus_shift_left(dst, src, n) \
-			__cpus_shift_left(&(dst), &(src), (n), NR_CPUS)
-static inline void __cpus_shift_left(cpumask_t *dstp,
-					const cpumask_t *srcp, int n, int nbits)
+static inline void cpus_shift_left(cpumask_var_t dst, cpumask_t src, int n)
 {
-	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
+	bitmap_shift_left(dst, src, n, nr_cpu_ids);
 }
 
 /*
@@ -244,11 +306,11 @@ static inline void __cpus_shift_left(cpu
 extern const unsigned long
 	cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
 
-static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
+static inline cpumask_t get_cpu_mask(unsigned int cpu)
 {
 	const unsigned long *p = cpu_bit_bitmap[1 + cpu % BITS_PER_LONG];
 	p -= cpu / BITS_PER_LONG;
-	return (const cpumask_t *)p;
+	return (cpumask_t)p;
 }
 
 /*
@@ -256,150 +318,79 @@ static inline const cpumask_t *get_cpu_m
  * gcc optimizes it out (it's a constant) and there's no huge stack
  * variable created:
  */
-#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
-
+#define cpumask_of_cpu(cpu) ((cpumask_t)get_cpu_mask(cpu))
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
+#define	CPU_MASK_INIT(value) {					\
+	[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  value		\
+}
 
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
-	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
-
-/* cpu_mask_all is in init/main.c */
-extern cpumask_t cpu_mask_all;
-#define CPU_MASK_ALL_PTR	(&cpu_mask_all)
+/* Initializer only, use cpu_mask_all in function arguments */
+#define CPU_MASK_ALL {						\
+	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
+	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
+}
 
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
-
-#define cpumask_scnprintf(buf, len, src) \
-			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
-static inline int __cpumask_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
+static inline unsigned long *cpus_addr(cpumask_t src)
 {
-	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
+	return (unsigned long *)src;
 }
 
-#define cpumask_parse_user(ubuf, ulen, dst) \
-			__cpumask_parse_user((ubuf), (ulen), &(dst), NR_CPUS)
-static inline int __cpumask_parse_user(const char __user *buf, int len,
-					cpumask_t *dstp, int nbits)
+static inline int cpumask_scnprintf(char *buf, int len, cpumask_t src)
 {
-	return bitmap_parse_user(buf, len, dstp->bits, nbits);
+	return bitmap_scnprintf(buf, len, src, nr_cpu_ids);
 }
 
-#define cpulist_scnprintf(buf, len, src) \
-			__cpulist_scnprintf((buf), (len), &(src), NR_CPUS)
-static inline int __cpulist_scnprintf(char *buf, int len,
-					const cpumask_t *srcp, int nbits)
+static inline int cpumask_parse_user(const char __user *buf, int len,
+							cpumask_var_t dst)
 {
-	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
+	return bitmap_parse_user(buf, len, dst, nr_cpu_ids);
 }
 
-#define cpulist_parse(buf, dst) __cpulist_parse((buf), &(dst), NR_CPUS)
-static inline int __cpulist_parse(const char *buf, cpumask_t *dstp, int nbits)
+static inline int cpulist_scnprintf(char *buf, int len, cpumask_t src)
 {
-	return bitmap_parselist(buf, dstp->bits, nbits);
+	return bitmap_scnlistprintf(buf, len, src, nr_cpu_ids);
 }
 
-#define cpu_remap(oldbit, old, new) \
-		__cpu_remap((oldbit), &(old), &(new), NR_CPUS)
-static inline int __cpu_remap(int oldbit,
-		const cpumask_t *oldp, const cpumask_t *newp, int nbits)
+static inline int cpulist_parse(const char *buf, cpumask_var_t dst)
 {
-	return bitmap_bitremap(oldbit, oldp->bits, newp->bits, nbits);
+	return bitmap_parselist(buf, dst, nr_cpu_ids);
 }
 
-#define cpus_remap(dst, src, old, new) \
-		__cpus_remap(&(dst), &(src), &(old), &(new), NR_CPUS)
-static inline void __cpus_remap(cpumask_t *dstp, const cpumask_t *srcp,
-		const cpumask_t *oldp, const cpumask_t *newp, int nbits)
+static inline int cpu_remap(int oldbit, cpumask_t old, cpumask_t new)
 {
-	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
+	return bitmap_bitremap(oldbit, old, new, nr_cpu_ids);
 }
 
-#define cpus_onto(dst, orig, relmap) \
-		__cpus_onto(&(dst), &(orig), &(relmap), NR_CPUS)
-static inline void __cpus_onto(cpumask_t *dstp, const cpumask_t *origp,
-		const cpumask_t *relmapp, int nbits)
+static inline void cpus_remap(cpumask_var_t dst, cpumask_t src, cpumask_t old,
+								cpumask_t new)
 {
-	bitmap_onto(dstp->bits, origp->bits, relmapp->bits, nbits);
+	bitmap_remap(dst, src, old, new, nr_cpu_ids);
 }
 
-#define cpus_fold(dst, orig, sz) \
-		__cpus_fold(&(dst), &(orig), sz, NR_CPUS)
-static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
-		int sz, int nbits)
+static inline void cpus_onto(cpumask_var_t dst, cpumask_t orig,
+						cpumask_t relmap)
 {
-	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
+	bitmap_onto(dst, orig, relmap, nr_cpu_ids);
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
+static inline void cpus_fold(cpumask_var_t dst, cpumask_t orig, int sz)
+{
+	bitmap_fold(dst, orig, sz, nr_cpu_ids);
+}
 
 /*
  * The following particular system cpumasks and operations manage
@@ -458,33 +449,16 @@ int __next_cpu_nr(int n, const cpumask_t
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
--- longs-cpumasks.orig/lib/cpumask.c
+++ longs-cpumasks/lib/cpumask.c
@@ -3,34 +3,40 @@
 #include <linux/cpumask.h>
 #include <linux/module.h>
 
-int __first_cpu(const cpumask_t *srcp)
+int cpus_first(cpumask_t srcp)
 {
-	return find_first_bit(srcp->bits, NR_CPUS);
+	return find_first_bit(srcp, nr_cpu_ids);
 }
-EXPORT_SYMBOL(__first_cpu);
+EXPORT_SYMBOL(cpus_first);
 
-int __next_cpu(int n, const cpumask_t *srcp)
+int cpus_next(int n, cpumask_t srcp)
 {
-	return find_next_bit(srcp->bits, NR_CPUS, n+1);
+	return find_next_bit(srcp, nr_cpu_ids, n+1);
 }
-EXPORT_SYMBOL(__next_cpu);
+EXPORT_SYMBOL(cpus_next);
 
-#if NR_CPUS > 64
-int __next_cpu_nr(int n, const cpumask_t *srcp)
+int cpus_next_in(int n, cpumask_t srcp, cpumask_t andp)
 {
-	return find_next_bit(srcp->bits, nr_cpu_ids, n+1);
+	int cpu;
+
+	for (cpu = n + 1; cpu < nr_cpu_ids; cpu++) {
+		cpu = find_next_bit(srcp, nr_cpu_ids, cpu);
+
+		if (cpu < nr_cpu_ids && cpu_isset(cpu, andp))
+			return cpu;
+	}
+	return nr_cpu_ids;
 }
-EXPORT_SYMBOL(__next_cpu_nr);
-#endif
+EXPORT_SYMBOL(cpus_next_in);
 
-int __any_online_cpu(const cpumask_t *mask)
+int any_cpu_in(cpumask_t mask, cpumask_t andmask)
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, *mask) {
-		if (cpu_online(cpu))
+	for_each_cpu(cpu, mask) {
+		if (cpu_isset(cpu, andmask))
 			break;
 	}
 	return cpu;
 }
-EXPORT_SYMBOL(__any_online_cpu);
+EXPORT_SYMBOL(any_cpu_in);
