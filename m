Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXIQSgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXIQSgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbXIQSfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:35:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46531 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758185AbXIQSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:35:08 -0400
Message-Id: <20070917183507.506104000@sgi.com>
References: <20070917183507.332345000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 17 Sep 2007 11:35:08 -0700
From: travis@sgi.com
To: sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: [PATCH 1/1] ppc64: Convert cpu_sibling_map to a per_cpu data array ppc64 v2
Content-Disposition: inline; filename=convert-ppc64-cpu_sibling_map-to-per_cpu_data-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v2: 

This patch applies after:

	convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch

and should fix the "reference cpu_sibling_map before setup_per_cpu_areas()
has been called" problem.  In addtion, the cpu_sibiling_map macro has been
removed [this was missed in my original submission.]

Original Notes:

Convert cpu_sibling_map to a per_cpu cpumask_t array for the ppc64
architecture.  This fixes build errors in block/blktrace.c and
kernel/sched.c when CONFIG_SCHED_SMT is defined.

Note: these changes have not been built nor tested.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/powerpc/kernel/setup-common.c        |   20 ++++++++++++++++----
 arch/powerpc/kernel/setup_64.c            |    3 +++
 arch/powerpc/platforms/cell/cbe_cpufreq.c |    2 +-
 include/asm-powerpc/smp.h                 |    2 +-
 include/asm-powerpc/topology.h            |    2 +-
 5 files changed, 22 insertions(+), 7 deletions(-)

--- a/include/asm-powerpc/smp.h
+++ b/include/asm-powerpc/smp.h
@@ -60,7 +60,6 @@
 #endif
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
-#define cpu_sibling_map(cpu) per_cpu(cpu_sibling_map, cpu)
 
 /* Since OpenPIC has only 4 IPIs, we use slightly different message numbers.
  *
@@ -79,6 +78,7 @@
 void smp_init_cell(void);
 void smp_init_celleb(void);
 void smp_setup_cpu_maps(void);
+void smp_setup_cpu_sibling_map(void);
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -596,6 +596,9 @@
 		paca[i].data_offset = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 	}
+
+	/* Now that per_cpu is setup, initialize cpu_sibling_map */
+	smp_setup_cpu_sibling_map();
 }
 #endif
 
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -411,16 +411,28 @@
 		of_node_put(dn);
 	}
 
+	vdso_data->processorCount = num_present_cpus();
+#endif /* CONFIG_PPC64 */
+}
+
+/*
+ * Being that cpu_sibling_map is now a per_cpu array, then it cannot
+ * be initialized until the per_cpu areas have been created.  This
+ * function is now called from setup_per_cpu_areas().
+ */
+void __init smp_setup_cpu_sibling_map(void)
+{
+#if defined(CONFIG_PPC64)
+	int cpu;
+
 	/*
 	 * Do the sibling map; assume only two threads per processor.
 	 */
 	for_each_possible_cpu(cpu) {
-		cpu_set(cpu, cpu_sibling_map(cpu));
+		cpu_set(cpu, per_cpu(cpu_sibling_map, cpu));
 		if (cpu_has_feature(CPU_FTR_SMT))
-			cpu_set(cpu ^ 0x1, cpu_sibling_map(cpu));
+			cpu_set(cpu ^ 0x1, per_cpu(cpu_sibling_map, cpu));
 	}
-
-	vdso_data->processorCount = num_present_cpus();
 #endif /* CONFIG_PPC64 */
 }
 #endif /* CONFIG_SMP */
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c
+++ b/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -119,7 +119,7 @@
 	policy->cur = cbe_freqs[cur_pmode].frequency;
 
 #ifdef CONFIG_SMP
-	policy->cpus = cpu_sibling_map(policy->cpu);
+	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
 #endif
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
--- a/include/asm-powerpc/topology.h
+++ b/include/asm-powerpc/topology.h
@@ -108,7 +108,7 @@
 #ifdef CONFIG_PPC64
 #include <asm/smp.h>
 
-#define topology_thread_siblings(cpu)	(cpu_sibling_map(cpu))
+#define topology_thread_siblings(cpu)	(per_cpu(cpu_sibling_map, cpu))
 #endif
 #endif
 

-- 
