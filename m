Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbYDZAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbYDZAT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761595AbYDZAP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59180 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758131AbYDZAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001550.263378000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:56 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 08/11] x86: Add performance variants of cpumask operators
Content-Disposition: inline; filename=add-nr_cpu_ids
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Increase performance for systems with large count NR_CPUS by limiting
    the range of the cpumask operators that loop over the bits in a cpumask_t
    variable.  This removes a large amount of wasted cpu cycles.

  * Add performance variants of the cpumask operators:

    int cpus_weight_nr(mask)	     Same using nr_cpu_ids instead of NR_CPUS
    int first_cpu_nr(mask)	     Number lowest set bit, or nr_cpu_ids
    int next_cpu_nr(cpu, mask)	     Next cpu past 'cpu', or nr_cpu_ids
    for_each_cpu_mask_nr(cpu, mask)  for-loop cpu over mask using nr_cpu_ids

  * Modify following to use performance variants:

    #define num_online_cpus()	cpus_weight_nr(cpu_online_map)
    #define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
    #define num_present_cpus()	cpus_weight_nr(cpu_present_map)

    #define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), ...)
    #define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), ...)
    #define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), ...)

  * Comment added to include/linux/cpumask.h:

    Note: The alternate operations with the suffix "_nr" are used
	  to limit the range of the loop to nr_cpu_ids instead of
	  NR_CPUS when NR_CPUS > 64 for performance reasons.
	  If NR_CPUS is <= 64 then most assembler bitmask
	  operators execute faster with a constant range, so
	  the operator will continue to use NR_CPUS.

	  Another consideration is that nr_cpu_ids is initialized
	  to NR_CPUS and isn't lowered until the possible cpus are
	  discovered (including any disabled cpus).  So early uses
	  will span the entire range of NR_CPUS.

    (The net effect is that for systems with 64 or less CPU's there are no
     functional changes.)

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Reviewed-by: Paul Jackson <pj@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   92 ++++++++++++++++++++++++++++++++----------------
 lib/cpumask.c           |    9 ++++
 2 files changed, 71 insertions(+), 30 deletions(-)

--- linux-2.6.sched.orig/include/linux/cpumask.h
+++ linux-2.6.sched/include/linux/cpumask.h
@@ -15,6 +15,20 @@
  * For details of cpu_remap(), see bitmap_bitremap in lib/bitmap.c
  * For details of cpus_remap(), see bitmap_remap in lib/bitmap.c.
  *
+ * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
+ * Note: The alternate operations with the suffix "_nr" are used
+ *       to limit the range of the loop to nr_cpu_ids instead of
+ *       NR_CPUS when NR_CPUS > 64 for performance reasons.
+ *       If NR_CPUS is <= 64 then most assembler bitmask
+ *       operators execute faster with a constant range, so
+ *       the operator will continue to use NR_CPUS.
+ *
+ *       Another consideration is that nr_cpu_ids is initialized
+ *       to NR_CPUS and isn't lowered until the possible cpus are
+ *       discovered (including any disabled cpus).  So early uses
+ *       will span the entire range of NR_CPUS.
+ * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
+ *
  * The available cpumask operations are:
  *
  * void cpu_set(cpu, mask)		turn on bit 'cpu' in mask
@@ -36,12 +50,14 @@
  * int cpus_empty(mask)			Is mask empty (no bits sets)?
  * int cpus_full(mask)			Is mask full (all bits sets)?
  * int cpus_weight(mask)		Hamming weigh - number of set bits
+ * int cpus_weight_nr(mask)		Same using nr_cpu_ids instead of NR_CPUS
  *
  * void cpus_shift_right(dst, src, n)	Shift right
  * void cpus_shift_left(dst, src, n)	Shift left
  *
  * int first_cpu(mask)			Number lowest set bit, or NR_CPUS
  * int next_cpu(cpu, mask)		Next cpu past 'cpu', or NR_CPUS
+ * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
  * CPU_MASK_ALL				Initializer - all bits set
@@ -55,7 +71,8 @@
  * int cpu_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
  * int cpus_remap(dst, src, old, new)	*dst = map(old, new)(src)
  *
- * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask
+ * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask using NR_CPUS
+ * for_each_cpu_mask_nr(cpu, mask)	for-loop cpu over mask using nr_cpu_ids
  *
  * int num_online_cpus()		Number of online CPUs
  * int num_possible_cpus()		Number of all possible CPUs
@@ -212,15 +229,6 @@ static inline void __cpus_shift_left(cpu
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
 
-#ifdef CONFIG_SMP
-int __first_cpu(const cpumask_t *srcp);
-#define first_cpu(src) __first_cpu(&(src))
-int __next_cpu(int n, const cpumask_t *srcp);
-#define next_cpu(n, src) __next_cpu((n), &(src))
-#else
-#define first_cpu(src)		({ (void)(src); 0; })
-#define next_cpu(n, src)	({ (void)(src); 1; })
-#endif
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
 extern cpumask_t *cpumask_of_cpu_map;
@@ -330,15 +338,48 @@ static inline void __cpus_remap(cpumask_
 	bitmap_remap(dstp->bits, srcp->bits, oldp->bits, newp->bits, nbits);
 }
 
-#if NR_CPUS > 1
+#if NR_CPUS == 1
+
+#define nr_cpu_ids		1
+#define first_cpu(src)		({ (void)(src); 0; })
+#define next_cpu(n, src)	({ (void)(src); 1; })
+#define any_online_cpu(mask)	0
+#define for_each_cpu_mask(cpu, mask)	\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+
+#else /* NR_CPUS > 1 */
+
+extern int nr_cpu_ids;
+int __first_cpu(const cpumask_t *srcp);
+int __next_cpu(int n, const cpumask_t *srcp);
+int __any_online_cpu(const cpumask_t *mask);
+
+#define first_cpu(src)		__first_cpu(&(src))
+#define next_cpu(n, src)	__next_cpu((n), &(src))
+#define any_online_cpu(mask) __any_online_cpu(&(mask))
 #define for_each_cpu_mask(cpu, mask)		\
 	for ((cpu) = first_cpu(mask);		\
 		(cpu) < NR_CPUS;		\
 		(cpu) = next_cpu((cpu), (mask)))
-#else /* NR_CPUS == 1 */
-#define for_each_cpu_mask(cpu, mask)		\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#endif /* NR_CPUS */
+#endif
+
+#if NR_CPUS <= 64
+
+#define next_cpu_nr(n, src)		next_cpu(n, src)
+#define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
+#define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
+
+#else /* NR_CPUS > 64 */
+
+int __next_cpu_nr(int n, const cpumask_t *srcp);
+#define next_cpu_nr(n, src)	__next_cpu_nr((n), &(src))
+#define cpus_weight_nr(cpumask)	__cpus_weight(&(cpumask), nr_cpu_ids)
+#define for_each_cpu_mask_nr(cpu, mask)		\
+	for ((cpu) = first_cpu(mask);		\
+		(cpu) < nr_cpu_ids;		\
+		(cpu) = next_cpu_nr((cpu), (mask)))
+
+#endif /* NR_CPUS > 64 */
 
 /*
  * The following particular system cpumasks and operations manage
@@ -402,9 +443,9 @@ extern cpumask_t cpu_present_map;
 extern cpumask_t cpu_system_map;
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight(cpu_online_map)
-#define num_possible_cpus()	cpus_weight(cpu_possible_map)
-#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
+#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
+#define num_present_cpus()	cpus_weight_nr(cpu_present_map)
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
@@ -423,17 +464,8 @@ extern int cpus_match_system(cpumask_t m
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#ifdef CONFIG_SMP
-extern int nr_cpu_ids;
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
-int __any_online_cpu(const cpumask_t *mask);
-#else
-#define nr_cpu_ids			1
-#define any_online_cpu(mask)		0
-#endif
-
-#define for_each_possible_cpu(cpu)  for_each_cpu_mask((cpu), cpu_possible_map)
-#define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
-#define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
+#define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), cpu_possible_map)
+#define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), cpu_online_map)
+#define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), cpu_present_map)
 
 #endif /* __LINUX_CPUMASK_H */
--- linux-2.6.sched.orig/lib/cpumask.c
+++ linux-2.6.sched/lib/cpumask.c
@@ -15,6 +15,15 @@ int __next_cpu(int n, const cpumask_t *s
 }
 EXPORT_SYMBOL(__next_cpu);
 
+#if NR_CPUS > 64
+int __next_cpu_nr(int n, const cpumask_t *srcp)
+{
+	return min_t(int, nr_cpu_ids,
+				find_next_bit(srcp->bits, nr_cpu_ids, n+1));
+}
+EXPORT_SYMBOL(__next_cpu_nr);
+#endif
+
 int __any_online_cpu(const cpumask_t *mask)
 {
 	int cpu;

-- 
