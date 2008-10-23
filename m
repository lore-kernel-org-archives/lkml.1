Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYJWCRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYJWCRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbYJWCIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46598 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752267AbYJWCId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:33 -0400
Message-Id: <20081023020832.490842000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:57 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 31/35] cpumask: reorder header to minimize separate #ifdefs From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cleanup-ifdefs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpumask.h is pretty chaotic.  Now we've replaced most of it, let's
group things together a bit better.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |  166 +++++++++++++++++++++---------------------------
 1 file changed, 76 insertions(+), 90 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -110,10 +110,82 @@ struct cpumask {
 };
 #define cpumask_bits(maskp) ((maskp)->bits)
 
-#define cpumask_size() (BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long))
+/* Deprecated: use struct cpumask *, or cpumask_var_t. */
+typedef struct cpumask cpumask_t;
+
+#if CONFIG_NR_CPUS == 1
+/* Uniprocesor. */
+#define cpumask_first(src)		({ (void)(src); 0; })
+#define cpumask_next(n, src)		({ (void)(src); 1; })
+#define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
+#define cpumask_any_but(mask, cpu)	({ (void)(mask); (void)(cpu); 0; })
+
+#define for_each_cpu(cpu, mask)			\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+#define for_each_cpu_and(cpu, mask, and)	\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
+
+#define num_online_cpus()	1
+#define num_possible_cpus()	1
+#define num_present_cpus()	1
+#define cpu_online(cpu)		((cpu) == 0)
+#define cpu_possible(cpu)	((cpu) == 0)
+#define cpu_present(cpu)	((cpu) == 0)
+#define cpu_active(cpu)		((cpu) == 0)
+#define nr_cpu_ids		1
+#else
+/* SMP */
+extern int nr_cpu_ids;
+
+int cpumask_first(const cpumask_t *srcp);
+int cpumask_next(int n, const cpumask_t *srcp);
+int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
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
+
+#define num_online_cpus()	cpus_weight(cpu_online_map)
+#define num_possible_cpus()	cpus_weight(cpu_possible_map)
+#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
+#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
+#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
+#endif /* SMP */
+
+#if CONFIG_NR_CPUS <= BITS_PER_LONG
+#define CPU_BITS_ALL						\
+{								\
+	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+}
+
+/* This produces more efficient code. */
+#define nr_cpumask_bits	NR_CPUS
+
+#else /* CONFIG_NR_CPUS > BITS_PER_LONG */
+
+#define CPU_BITS_ALL						\
+{								\
+	[0 ... BITS_TO_LONGS(CONFIG_NR_CPUS)-2] = ~0UL,		\
+	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+}
+
+#define nr_cpumask_bits	nr_cpu_ids
+#endif /* CONFIG_NR_CPUS > BITS_PER_LONG */
+
+static inline size_t cpumask_size(void)
+{
+	return BITS_TO_LONGS(nr_cpumask_bits) * sizeof(long);
+}
 
 /* Deprecated. */
-typedef struct cpumask cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
 
 #define CPU_MASK_ALL_PTR	(cpu_all_mask)
@@ -178,21 +250,7 @@ extern cpumask_t _unused_cpumask_arg_;
 #define cpu_mask_all		(*(cpumask_t *)cpu_all_mask)
 /* End deprecated region. */
 
-#if NR_CPUS > 1
-/* Starts at NR_CPUS until we know better. */
-extern int nr_cpu_ids;
-#else
-#define nr_cpu_ids	NR_CPUS
-#endif
-
-/* The number of bits to hand to the bitmask ops. */
-#if NR_CPUS <= BITS_PER_LONG
-/* This produces more efficient code. */
-#define nr_cpumask_bits	NR_CPUS
-#else
-#define nr_cpumask_bits nr_cpu_ids
-#endif
-
+/* cpumask_* operators */
 static inline void cpumask_set_cpu(int cpu, volatile struct cpumask *dstp)
 {
 	set_bit(cpu, cpumask_bits(dstp));
@@ -407,24 +465,7 @@ static inline const struct cpumask *cpum
 	return (const struct cpumask *)p;
 }
 
-#define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
-
-#if NR_CPUS <= BITS_PER_LONG
-
-#define CPU_BITS_ALL						\
-{								\
-	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
-}
-
-#else
-
-#define CPU_BITS_ALL						\
-{								\
-	[0 ... BITS_TO_LONGS(CONFIG_NR_CPUS)-2] = ~0UL,		\
-	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
-}
-
-#endif
+#define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(CONFIG_NR_CPUS)
 
 #define CPU_BITS_NONE						\
 {								\
@@ -436,43 +477,6 @@ static inline const struct cpumask *cpum
 	[0] =  1UL						\
 }
 
-#if NR_CPUS == 1
-
-#define cpumask_first(src)		({ (void)(src); 0; })
-#define cpumask_next(n, src)		({ (void)(src); 1; })
-#define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
-#define cpumask_any_but(mask, cpu)	({ (void)(mask); (void)(cpu); 0; })
-
-#define for_each_cpu(cpu, mask)			\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#define for_each_cpu_and(cpu, mask, and)	\
-	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
-
-#else /* NR_CPUS > 1 */
-
-int cpumask_first(const cpumask_t *srcp);
-int cpumask_next(int n, const cpumask_t *srcp);
-int cpumask_next_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
-int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
-
-#define for_each_cpu(cpu, mask)				\
-	for ((cpu) = -1;				\
-		(cpu) = cpumask_next((cpu), (mask)),	\
-		(cpu) < nr_cpu_ids;)
-#define for_each_cpu_and(cpu, mask, and)				\
-	for ((cpu) = -1;						\
-		(cpu) = cpumask_next_and((cpu), (mask), (and)),		\
-		(cpu) < nr_cpu_ids;)
-
-#define num_online_cpus()	cpus_weight(cpu_online_map)
-#define num_possible_cpus()	cpus_weight(cpu_possible_map)
-#define num_present_cpus()	cpus_weight(cpu_present_map)
-#define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
-#define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
-#define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
-#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
-#endif /* NR_CPUS */
-
 #define cpumask_first_and(mask, and) cpumask_next_and(-1, (mask), (and))
 
 /*
@@ -564,24 +568,6 @@ extern const DECLARE_BITMAP(cpu_all_bits
 /* First bits of cpu_bit_bitmap are in fact unset. */
 #define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
 
-#if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight(cpu_online_map)
-#define num_possible_cpus()	cpus_weight(cpu_possible_map)
-#define num_present_cpus()	cpus_weight(cpu_present_map)
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
-
 /* Wrappers to manipulate otherwise-constant masks. */
 void set_cpu_possible(unsigned int cpu, bool possible);
 void set_cpu_present(unsigned int cpu, bool present);

-- 
