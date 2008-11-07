Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYKGIlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYKGIlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYKGIkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:40:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54666 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYKGIku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:40:50 -0500
Date: Fri, 7 Nov 2008 09:40:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-ID: <20081107084016.GF4435@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <200811021229.16061.rusty@rustcorp.com.au> <alpine.LFD.2.00.0811011834360.3483@nehalem.linux-foundation.org> <200811070949.02914.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811070949.02914.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (Tested in linux-next as well as locally.  Linus, please apply).

if this is equal to the patch that you sent me (see the git 
coordinates below), it was also stess-tested and build-coverage tested 
by me on a healthy range of x86 systems, in a range of build 
environments.

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Acked-by: Mike Travis <travis@sgi.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo

-------------->

The cpus4096 git tree can be pulled from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096

 Thanks,

	Ingo

------------------>
Rusty Russell (1):
      cpumask: introduce new API, without changing anything


 include/linux/cpumask.h   |  502 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/smp.h       |    9 +
 include/linux/workqueue.h |    8 +
 kernel/cpu.c              |    3 +
 kernel/workqueue.c        |   45 ++++
 lib/cpumask.c             |   73 +++++++
 6 files changed, 638 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d3219d7..c8e6661 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -5,6 +5,9 @@
  * Cpumasks provide a bitmap suitable for representing the
  * set of CPU's in a system, one bit position per CPU number.
  *
+ * The new cpumask_ ops take a "struct cpumask *"; the old ones
+ * use cpumask_t.
+ *
  * See detailed comments in the file linux/bitmap.h describing the
  * data type on which these cpumasks are based.
  *
@@ -31,7 +34,7 @@
  *       will span the entire range of NR_CPUS.
  * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
  *
- * The available cpumask operations are:
+ * The obsolescent cpumask operations are:
  *
  * void cpu_set(cpu, mask)		turn on bit 'cpu' in mask
  * void cpu_clear(cpu, mask)		turn off bit 'cpu' in mask
@@ -138,7 +141,7 @@
 #include <linux/threads.h>
 #include <linux/bitmap.h>
 
-typedef struct { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
 
 #define cpu_set(cpu, dst) __cpu_set((cpu), &(dst))
@@ -527,4 +530,499 @@ extern cpumask_t cpu_active_map;
 #define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), cpu_online_map)
 #define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), cpu_present_map)
 
+/* These are the new versions of the cpumask operators: passed by pointer.
+ * The older versions will be implemented in terms of these, then deleted. */
+#define cpumask_bits(maskp) ((maskp)->bits)
+
+#if NR_CPUS <= BITS_PER_LONG
+#define CPU_BITS_ALL						\
+{								\
+	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+}
+
+/* This produces more efficient code. */
+#define nr_cpumask_bits	NR_CPUS
+
+#else /* NR_CPUS > BITS_PER_LONG */
+
+#define CPU_BITS_ALL						\
+{								\
+	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,		\
+	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD		\
+}
+
+#define nr_cpumask_bits	nr_cpu_ids
+#endif /* NR_CPUS > BITS_PER_LONG */
+
+/* verify cpu argument to cpumask_* operators */
+static inline unsigned int cpumask_check(unsigned int cpu)
+{
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	WARN_ON_ONCE(cpu >= nr_cpumask_bits);
+#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
+	return cpu;
+}
+
+#if NR_CPUS == 1
+/* Uniprocesor. */
+#define cpumask_first(src)		({ (void)(src); 0; })
+#define cpumask_next(n, src)		({ (void)(src); 1; })
+#define cpumask_next_zero(n, src)	({ (void)(src); 1; })
+#define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
+#define cpumask_any_but(mask, cpu)	({ (void)(mask); (void)(cpu); 0; })
+
+#define for_each_cpu(cpu, mask)			\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+#define for_each_cpu_and(cpu, mask, and)	\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
+#else
+/**
+ * cpumask_first - get the first cpu in a cpumask
+ * @srcp: the cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no cpus set.
+ */
+static inline unsigned int cpumask_first(const struct cpumask *srcp)
+{
+	return find_first_bit(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_next - get the next cpu in a cpumask
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @srcp: the cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus set.
+ */
+static inline unsigned int cpumask_next(int n, const struct cpumask *srcp)
+{
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
+}
+
+/**
+ * cpumask_next_zero - get the next unset cpu in a cpumask
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @srcp: the cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus unset.
+ */
+static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
+{
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
+	return find_next_zero_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
+}
+
+int cpumask_next_and(int n, const struct cpumask *, const struct cpumask *);
+int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
+
+#define for_each_cpu(cpu, mask)				\
+	for ((cpu) = -1;				\
+		(cpu) = cpumask_next((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids;)
+#define for_each_cpu_and(cpu, mask, and)				\
+	for ((cpu) = -1;						\
+		(cpu) = cpumask_next_and((cpu), (mask), (and)),		\
+		(cpu) < nr_cpu_ids;)
+#endif /* SMP */
+
+#define CPU_BITS_NONE						\
+{								\
+	[0 ... BITS_TO_LONGS(NR_CPUS)-1] = 0UL			\
+}
+
+#define CPU_BITS_CPU0						\
+{								\
+	[0] =  1UL						\
+}
+
+/**
+ * cpumask_set_cpu - set a cpu in a cpumask
+ * @cpu: cpu number (< nr_cpu_ids)
+ * @dstp: the cpumask pointer
+ */
+static inline void cpumask_set_cpu(unsigned int cpu, struct cpumask *dstp)
+{
+	set_bit(cpumask_check(cpu), cpumask_bits(dstp));
+}
+
+/**
+ * cpumask_clear_cpu - clear a cpu in a cpumask
+ * @cpu: cpu number (< nr_cpu_ids)
+ * @dstp: the cpumask pointer
+ */
+static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
+{
+	clear_bit(cpumask_check(cpu), cpumask_bits(dstp));
+}
+
+/**
+ * cpumask_test_cpu - test for a cpu in a cpumask
+ * @cpu: cpu number (< nr_cpu_ids)
+ * @cpumask: the cpumask pointer
+ *
+ * No static inline type checking - see Subtlety (1) above.
+ */
+#define cpumask_test_cpu(cpu, cpumask) \
+	test_bit(cpumask_check(cpu), (cpumask)->bits)
+
+/**
+ * cpumask_test_and_set_cpu - atomically test and set a cpu in a cpumask
+ * @cpu: cpu number (< nr_cpu_ids)
+ * @cpumask: the cpumask pointer
+ *
+ * test_and_set_bit wrapper for cpumasks.
+ */
+static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *cpumask)
+{
+	return test_and_set_bit(cpumask_check(cpu), cpumask_bits(cpumask));
+}
+
+/**
+ * cpumask_setall - set all cpus (< nr_cpu_ids) in a cpumask
+ * @dstp: the cpumask pointer
+ */
+static inline void cpumask_setall(struct cpumask *dstp)
+{
+	bitmap_fill(cpumask_bits(dstp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_clear - clear all cpus (< nr_cpu_ids) in a cpumask
+ * @dstp: the cpumask pointer
+ */
+static inline void cpumask_clear(struct cpumask *dstp)
+{
+	bitmap_zero(cpumask_bits(dstp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_and - *dstp = *src1p & *src2p
+ * @dstp: the cpumask result
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline void cpumask_and(struct cpumask *dstp,
+			       const struct cpumask *src1p,
+			       const struct cpumask *src2p)
+{
+	bitmap_and(cpumask_bits(dstp), cpumask_bits(src1p),
+				       cpumask_bits(src2p), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_or - *dstp = *src1p | *src2p
+ * @dstp: the cpumask result
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline void cpumask_or(struct cpumask *dstp, const struct cpumask *src1p,
+			      const struct cpumask *src2p)
+{
+	bitmap_or(cpumask_bits(dstp), cpumask_bits(src1p),
+				      cpumask_bits(src2p), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_xor - *dstp = *src1p ^ *src2p
+ * @dstp: the cpumask result
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline void cpumask_xor(struct cpumask *dstp,
+			       const struct cpumask *src1p,
+			       const struct cpumask *src2p)
+{
+	bitmap_xor(cpumask_bits(dstp), cpumask_bits(src1p),
+				       cpumask_bits(src2p), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_andnot - *dstp = *src1p & ~*src2p
+ * @dstp: the cpumask result
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline void cpumask_andnot(struct cpumask *dstp,
+				  const struct cpumask *src1p,
+				  const struct cpumask *src2p)
+{
+	bitmap_andnot(cpumask_bits(dstp), cpumask_bits(src1p),
+					  cpumask_bits(src2p), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_complement - *dstp = ~*srcp
+ * @dstp: the cpumask result
+ * @srcp: the input to invert
+ */
+static inline void cpumask_complement(struct cpumask *dstp,
+				      const struct cpumask *srcp)
+{
+	bitmap_complement(cpumask_bits(dstp), cpumask_bits(srcp),
+					      nr_cpumask_bits);
+}
+
+/**
+ * cpumask_equal - *src1p == *src2p
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline bool cpumask_equal(const struct cpumask *src1p,
+				const struct cpumask *src2p)
+{
+	return bitmap_equal(cpumask_bits(src1p), cpumask_bits(src2p),
+						 nr_cpumask_bits);
+}
+
+/**
+ * cpumask_intersects - (*src1p & *src2p) != 0
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline bool cpumask_intersects(const struct cpumask *src1p,
+				     const struct cpumask *src2p)
+{
+	return bitmap_intersects(cpumask_bits(src1p), cpumask_bits(src2p),
+						      nr_cpumask_bits);
+}
+
+/**
+ * cpumask_subset - (*src1p & ~*src2p) == 0
+ * @src1p: the first input
+ * @src2p: the second input
+ */
+static inline int cpumask_subset(const struct cpumask *src1p,
+				 const struct cpumask *src2p)
+{
+	return bitmap_subset(cpumask_bits(src1p), cpumask_bits(src2p),
+						  nr_cpumask_bits);
+}
+
+/**
+ * cpumask_empty - *srcp == 0
+ * @srcp: the cpumask to that all cpus < nr_cpu_ids are clear.
+ */
+static inline bool cpumask_empty(const struct cpumask *srcp)
+{
+	return bitmap_empty(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_full - *srcp == 0xFFFFFFFF...
+ * @srcp: the cpumask to that all cpus < nr_cpu_ids are set.
+ */
+static inline bool cpumask_full(const struct cpumask *srcp)
+{
+	return bitmap_full(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_weight - Count of bits in *srcp
+ * @srcp: the cpumask to count bits (< nr_cpu_ids) in.
+ */
+static inline unsigned int cpumask_weight(const struct cpumask *srcp)
+{
+	return bitmap_weight(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_shift_right - *dstp = *srcp >> n
+ * @dstp: the cpumask result
+ * @srcp: the input to shift
+ * @n: the number of bits to shift by
+ */
+static inline void cpumask_shift_right(struct cpumask *dstp,
+				       const struct cpumask *srcp, int n)
+{
+	bitmap_shift_right(cpumask_bits(dstp), cpumask_bits(srcp), n,
+					       nr_cpumask_bits);
+}
+
+/**
+ * cpumask_shift_left - *dstp = *srcp << n
+ * @dstp: the cpumask result
+ * @srcp: the input to shift
+ * @n: the number of bits to shift by
+ */
+static inline void cpumask_shift_left(struct cpumask *dstp,
+				      const struct cpumask *srcp, int n)
+{
+	bitmap_shift_left(cpumask_bits(dstp), cpumask_bits(srcp), n,
+					      nr_cpumask_bits);
+}
+
+/**
+ * cpumask_copy - *dstp = *srcp
+ * @dstp: the result
+ * @srcp: the input cpumask
+ */
+static inline void cpumask_copy(struct cpumask *dstp,
+				const struct cpumask *srcp)
+{
+	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
+ * cpumask_any - pick a "random" cpu from *srcp
+ * @srcp: the input cpumask
+ *
+ * Returns >= nr_cpu_ids if no cpus set.
+ */
+#define cpumask_any(srcp) cpumask_first(srcp)
+
+/**
+ * cpumask_first_and - return the first cpu from *srcp1 & *srcp2
+ * @src1p: the first input
+ * @src2p: the second input
+ *
+ * Returns >= nr_cpu_ids if no cpus set in both.  See also cpumask_next_and().
+ */
+#define cpumask_first_and(src1p, src2p) cpumask_next_and(-1, (src1p), (src2p))
+
+/**
+ * cpumask_any_and - pick a "random" cpu from *mask1 & *mask2
+ * @mask1: the first input cpumask
+ * @mask2: the second input cpumask
+ *
+ * Returns >= nr_cpu_ids if no cpus set.
+ */
+#define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
+
+/**
+ * to_cpumask - convert an NR_CPUS bitmap to a struct cpumask *
+ * @bitmap: the bitmap
+ *
+ * There are a few places where cpumask_var_t isn't appropriate and
+ * static cpumasks must be used (eg. very early boot), yet we don't
+ * expose the definition of 'struct cpumask'.
+ *
+ * This does the conversion, and can be used as a constant initializer.
+ */
+#define to_cpumask(bitmap)						\
+	((struct cpumask *)(1 ? (bitmap)				\
+			    : (void *)sizeof(__check_is_bitmap(bitmap))))
+
+static inline int __check_is_bitmap(const unsigned long *bitmap)
+{
+	return 1;
+}
+
+/**
+ * cpumask_size - size to allocate for a 'struct cpumask' in bytes
+ *
+ * This will eventually be a runtime variable, depending on nr_cpu_ids.
+ */
+static inline size_t cpumask_size(void)
+{
+	/* FIXME: Once all cpumask assignments are eliminated, this
+	 * can be nr_cpumask_bits */
+	return BITS_TO_LONGS(NR_CPUS) * sizeof(long);
+}
+
+/*
+ * cpumask_var_t: struct cpumask for stack usage.
+ *
+ * Oh, the wicked games we play!  In order to make kernel coding a
+ * little more difficult, we typedef cpumask_var_t to an array or a
+ * pointer: doing &mask on an array is a noop, so it still works.
+ *
+ * ie.
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	  ... use 'tmpmask' like a normal struct cpumask * ...
+ *
+ *	free_cpumask_var(tmpmask);
+ */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+typedef struct cpumask *cpumask_var_t;
+
+bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
+void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
+void free_cpumask_var(cpumask_var_t mask);
+
+#else
+typedef struct cpumask cpumask_var_t[1];
+
+static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	return true;
+}
+
+static inline void alloc_bootmem_cpumask_var(cpumask_var_t *mask)
+{
+}
+
+static inline void free_cpumask_var(cpumask_var_t mask)
+{
+}
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
+/* The pointer versions of the maps, these will become the primary versions. */
+#define cpu_possible_mask ((const struct cpumask *)&cpu_possible_map)
+#define cpu_online_mask ((const struct cpumask *)&cpu_online_map)
+#define cpu_present_mask ((const struct cpumask *)&cpu_present_map)
+#define cpu_active_mask ((const struct cpumask *)&cpu_active_map)
+
+/* It's common to want to use cpu_all_mask in struct member initializers,
+ * so it has to refer to an address rather than a pointer. */
+extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
+#define cpu_all_mask to_cpumask(cpu_all_bits)
+
+/* First bits of cpu_bit_bitmap are in fact unset. */
+#define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
+
+/* Wrappers for arch boot code to manipulate normally-constant masks */
+static inline void set_cpu_possible(unsigned int cpu, bool possible)
+{
+	if (possible)
+		cpumask_set_cpu(cpu, &cpu_possible_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_possible_map);
+}
+
+static inline void set_cpu_present(unsigned int cpu, bool present)
+{
+	if (present)
+		cpumask_set_cpu(cpu, &cpu_present_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_present_map);
+}
+
+static inline void set_cpu_online(unsigned int cpu, bool online)
+{
+	if (online)
+		cpumask_set_cpu(cpu, &cpu_online_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_online_map);
+}
+
+static inline void set_cpu_active(unsigned int cpu, bool active)
+{
+	if (active)
+		cpumask_set_cpu(cpu, &cpu_active_map);
+	else
+		cpumask_clear_cpu(cpu, &cpu_active_map);
+}
+
+static inline void init_cpu_present(const struct cpumask *src)
+{
+	cpumask_copy(&cpu_present_map, src);
+}
+
+static inline void init_cpu_possible(const struct cpumask *src)
+{
+	cpumask_copy(&cpu_possible_map, src);
+}
+
+static inline void init_cpu_online(const struct cpumask *src)
+{
+	cpumask_copy(&cpu_online_map, src);
+}
 #endif /* __LINUX_CPUMASK_H */
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 2e4d58b..3f9a600 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -64,8 +64,17 @@ extern void smp_cpus_done(unsigned int max_cpus);
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int wait);
+/* Deprecated: use smp_call_function_many() which uses a cpumask ptr. */
 int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 				int wait);
+
+static inline void smp_call_function_many(const struct cpumask *mask,
+					  void (*func)(void *info), void *info,
+					  int wait)
+{
+	smp_call_function_mask(*mask, func, info, wait);
+}
+
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 				int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 89a5a12..b362911 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -240,4 +240,12 @@ void cancel_rearming_delayed_work(struct delayed_work *work)
 	cancel_delayed_work_sync(work);
 }
 
+#ifndef CONFIG_SMP
+static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+{
+	return fn(arg);
+}
+#else
+long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
+#endif /* CONFIG_SMP */
 #endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 86d4904..5a732c5 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -499,3 +499,6 @@ const unsigned long cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)] = {
 #endif
 };
 EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
+
+const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
+EXPORT_SYMBOL(cpu_all_bits);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f928f2a..d4dc69d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -970,6 +970,51 @@ undo:
 	return ret;
 }
 
+#ifdef CONFIG_SMP
+struct work_for_cpu {
+	struct work_struct work;
+	long (*fn)(void *);
+	void *arg;
+	long ret;
+};
+
+static void do_work_for_cpu(struct work_struct *w)
+{
+	struct work_for_cpu *wfc = container_of(w, struct work_for_cpu, work);
+
+	wfc->ret = wfc->fn(wfc->arg);
+}
+
+/**
+ * work_on_cpu - run a function in user context on a particular cpu
+ * @cpu: the cpu to run on
+ * @fn: the function to run
+ * @arg: the function arg
+ *
+ * This will return -EINVAL in the cpu is not online, or the return value
+ * of @fn otherwise.
+ */
+long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
+{
+	struct work_for_cpu wfc;
+
+	INIT_WORK(&wfc.work, do_work_for_cpu);
+	wfc.fn = fn;
+	wfc.arg = arg;
+	get_online_cpus();
+	if (unlikely(!cpu_online(cpu)))
+		wfc.ret = -EINVAL;
+	else {
+		schedule_work_on(cpu, &wfc.work);
+		flush_work(&wfc.work);
+	}
+	put_online_cpus();
+
+	return wfc.ret;
+}
+EXPORT_SYMBOL_GPL(work_on_cpu);
+#endif /* CONFIG_SMP */
+
 void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 5f97dc2..5ceb421 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -2,6 +2,7 @@
 #include <linux/bitops.h>
 #include <linux/cpumask.h>
 #include <linux/module.h>
+#include <linux/bootmem.h>
 
 int __first_cpu(const cpumask_t *srcp)
 {
@@ -35,3 +36,75 @@ int __any_online_cpu(const cpumask_t *mask)
 	return cpu;
 }
 EXPORT_SYMBOL(__any_online_cpu);
+
+/**
+ * cpumask_next_and - get the next cpu in *src1p & *src2p
+ * @n: the cpu prior to the place to search (ie. return will be > @n)
+ * @src1p: the first cpumask pointer
+ * @src2p: the second cpumask pointer
+ *
+ * Returns >= nr_cpu_ids if no further cpus set in both.
+ */
+int cpumask_next_and(int n, const struct cpumask *src1p,
+		     const struct cpumask *src2p)
+{
+	while ((n = cpumask_next(n, src1p)) < nr_cpu_ids)
+		if (cpumask_test_cpu(n, src2p))
+			break;
+	return n;
+}
+EXPORT_SYMBOL(cpumask_next_and);
+
+/**
+ * cpumask_any_but - return a "random" in a cpumask, but not this one.
+ * @mask: the cpumask to search
+ * @cpu: the cpu to ignore.
+ *
+ * Often used to find any cpu but smp_processor_id() in a mask.
+ * Returns >= nr_cpu_ids if no cpus set.
+ */
+int cpumask_any_but(const struct cpumask *mask, unsigned int cpu)
+{
+	unsigned int i;
+
+	for_each_cpu(i, mask)
+		if (i != cpu)
+			break;
+	return i;
+}
+
+/* These are not inline because of header tangles. */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	if (likely(slab_is_available()))
+		*mask = kmalloc(cpumask_size(), flags);
+	else {
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+		printk(KERN_ERR
+			"=> alloc_cpumask_var: kmalloc not available!\n");
+		dump_stack();
+#endif
+		*mask = NULL;
+	}
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (!*mask) {
+		printk(KERN_ERR "=> alloc_cpumask_var: failed!\n");
+		dump_stack();
+	}
+#endif
+	return *mask != NULL;
+}
+EXPORT_SYMBOL(alloc_cpumask_var);
+
+void __init alloc_bootmem_cpumask_var(cpumask_var_t *mask)
+{
+	*mask = alloc_bootmem(cpumask_size());
+}
+
+void free_cpumask_var(cpumask_var_t mask)
+{
+	kfree(mask);
+}
+EXPORT_SYMBOL(free_cpumask_var);
+#endif
