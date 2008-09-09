Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYIIPvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYIIPvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYIIPuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:50:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55024 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756615AbYIIPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:50:14 -0400
Message-Id: <20080909155013.735125000@polaris-admin.engr.sgi.com>
References: <20080909155013.455071000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 09 Sep 2008 08:50:14 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cpumask: add for_each_online_cpu_mask_nr function
Content-Disposition: inline; filename=for_each_online_cpu_mask_nr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Add for_each_online_cpu_mask_nr() function to eliminate need for
    a common use of a temporary cpumask_t variable.  When the following
    procedure is being used:

    funcproto(cpumask_t *mask, ...)
    {
	cpumask_t temp;

	cpus_and(temp, *mask, cpu_online_map);
	for_each_cpu_mask_nr(cpu, temp)
		...

    If then becomes:

    funcproto(cpumask_t *mask, ...)
    {
	for_each_online_cpu_mask_nr(cpu, *mask)
		...

  * Note the generic __next_cpu_and (and __next_cpu_and_nr) functions
    allowing AND'ing with any cpumask_t variable, not just the cpu_online_map.


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   26 +++++++++++++++++++++++---
 lib/cpumask.c           |   26 ++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 3 deletions(-)

--- linux-2.6.tip.orig/include/linux/cpumask.h
+++ linux-2.6.tip/include/linux/cpumask.h
@@ -404,23 +404,32 @@ static inline void __cpus_fold(cpumask_t
 #define first_cpu(src)		({ (void)(src); 0; })
 #define next_cpu(n, src)	({ (void)(src); 1; })
 #define any_online_cpu(mask)	0
-#define for_each_cpu_mask(cpu, mask)	\
+
+#define for_each_cpu_mask(cpu, mask)		\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+#define for_each_online_cpu_mask(cpu, mask)	\
+	for_each_cpu_mask(cpu, mask)
 
 #else /* NR_CPUS > 1 */
 
 extern int nr_cpu_ids;
 int __first_cpu(const cpumask_t *srcp);
 int __next_cpu(int n, const cpumask_t *srcp);
+int __next_cpu_and(int n, const cpumask_t *srcp, const cpumask_t *andp);
 int __any_online_cpu(const cpumask_t *mask);
 
 #define first_cpu(src)		__first_cpu(&(src))
 #define next_cpu(n, src)	__next_cpu((n), &(src))
 #define any_online_cpu(mask) __any_online_cpu(&(mask))
+
 #define for_each_cpu_mask(cpu, mask)			\
 	for ((cpu) = -1;				\
 		(cpu) = next_cpu((cpu), (mask)),	\
 		(cpu) < NR_CPUS; )
+#define for_each_online_cpu_mask(cpu, mask)				   \
+	for ((cpu) = -1;						   \
+		(cpu) = __next_cpu_and((cpu), &(mask), &(cpu_online_map)), \
+		(cpu) < NR_CPUS; )
 #endif
 
 #if NR_CPUS <= 64
@@ -428,17 +437,28 @@ int __any_online_cpu(const cpumask_t *ma
 #define next_cpu_nr(n, src)		next_cpu(n, src)
 #define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
 #define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
+#define for_each_online_cpu_mask_nr(cpu, mask)	\
+					for_each_online_cpu_mask(cpu, mask)
 
 #else /* NR_CPUS > 64 */
 
 int __next_cpu_nr(int n, const cpumask_t *srcp);
-#define next_cpu_nr(n, src)	__next_cpu_nr((n), &(src))
-#define cpus_weight_nr(cpumask)	__cpus_weight(&(cpumask), nr_cpu_ids)
+int __next_cpu_and_nr(int n, const cpumask_t *srcp, const cpumask_t *andp);
+
+#define next_cpu_nr(n, src)		__next_cpu_nr((n), &(src))
+#define next_cpu_and_nr(n, src, and)	__next_cpu_and_nr((n), &(src), &(and))
+#define cpus_weight_nr(cpumask)		__cpus_weight(&(cpumask), nr_cpu_ids)
+
 #define for_each_cpu_mask_nr(cpu, mask)			\
 	for ((cpu) = -1;				\
 		(cpu) = next_cpu_nr((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids; )
 
+#define for_each_online_cpu_mask_nr(cpu, mask)				  \
+	for ((cpu) = -1;						  \
+		(cpu) = next_cpu_and_nr((cpu), (mask), (cpu_online_map)), \
+		(cpu) < nr_cpu_ids; )
+
 #endif /* NR_CPUS > 64 */
 
 /*
--- linux-2.6.tip.orig/lib/cpumask.c
+++ linux-2.6.tip/lib/cpumask.c
@@ -14,6 +14,19 @@ int __next_cpu(int n, const cpumask_t *s
 	return min_t(int, NR_CPUS, find_next_bit(srcp->bits, NR_CPUS, n+1));
 }
 EXPORT_SYMBOL(__next_cpu);
+int __next_cpu_and(int n, const cpumask_t *srcp, const cpumask_t *andp)
+{
+	int cpu;
+
+	for (cpu = n + 1; cpu < NR_CPUS; cpu++) {
+		cpu = find_next_bit(srcp->bits, NR_CPUS, cpu);
+
+		if (cpu < NR_CPUS && cpu_isset(cpu, *andp))
+			return cpu;
+	}
+	return NR_CPUS;
+}
+EXPORT_SYMBOL(__next_cpu_and);
 
 #if NR_CPUS > 64
 int __next_cpu_nr(int n, const cpumask_t *srcp)
@@ -22,6 +35,19 @@ int __next_cpu_nr(int n, const cpumask_t
 				find_next_bit(srcp->bits, nr_cpu_ids, n+1));
 }
 EXPORT_SYMBOL(__next_cpu_nr);
+int __next_cpu_and_nr(int n, const cpumask_t *srcp, const cpumask_t *andp)
+{
+	int cpu;
+
+	for (cpu = n + 1; cpu < nr_cpu_ids; cpu++) {
+		cpu = find_next_bit(srcp->bits, nr_cpu_ids, cpu);
+
+		if (cpu < nr_cpu_ids && cpu_isset(cpu, *andp))
+			return cpu;
+	}
+	return nr_cpu_ids;
+}
+EXPORT_SYMBOL(__next_cpu_and_nr);
 #endif
 
 int __any_online_cpu(const cpumask_t *mask)

-- 
