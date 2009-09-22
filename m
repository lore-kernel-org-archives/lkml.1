Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZIVHkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZIVHkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZIVHkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:40:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:44584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbZIVHks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:40:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: [PATCH 2/4] ia64: allocate percpu area for cpu0 like percpu areas for other cpus
Date: Tue, 22 Sep 2009 16:40:12 +0900
Message-Id: <1253605214-23210-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1253605214-23210-1-git-send-email-tj@kernel.org>
References: <1253605214-23210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 07:40:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu0 used special percpu area reserved by the linker, __cpu0_per_cpu,
which is set up early in boot by head.S.  However, this doesn't
guarantee that the area will be on the same node as cpu0 and the
percpu area for cpu0 ends up very far away from percpu areas for other
cpus which cause problems for congruent percpu allocator.

This patch makes percpu area initialization allocate percpu area for
cpu0 like any other cpus and copy it from __cpu0_per_cpu which now
resides in the __init area.  This means that for cpu0, percpu area is
first setup at __cpu0_per_cpu early by head.S and then moved to an
area in the linear mapping during memory initialization and it's not
allowed to take a pointer to percpu variables between head.S and
memory initialization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64 <linux-ia64@vger.kernel.org>
---
 arch/ia64/kernel/vmlinux.lds.S |   11 +++++----
 arch/ia64/mm/contig.c          |   47 +++++++++++++++++++++++++--------------
 arch/ia64/mm/discontig.c       |   35 ++++++++++++++++++++---------
 3 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 0a0c77b..1295ba3 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -166,6 +166,12 @@ SECTIONS
 	}
 #endif
 
+#ifdef	CONFIG_SMP
+  . = ALIGN(PERCPU_PAGE_SIZE);
+  __cpu0_per_cpu = .;
+  . = . + PERCPU_PAGE_SIZE;	/* cpu0 per-cpu space */
+#endif
+
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
@@ -198,11 +204,6 @@ SECTIONS
   data : { } :data
   .data : AT(ADDR(.data) - LOAD_OFFSET)
 	{
-#ifdef	CONFIG_SMP
-  . = ALIGN(PERCPU_PAGE_SIZE);
-		__cpu0_per_cpu = .;
-  . = . + PERCPU_PAGE_SIZE;	/* cpu0 per-cpu space */
-#endif
 		INIT_TASK_DATA(PAGE_SIZE)
 		CACHELINE_ALIGNED_DATA(SMP_CACHE_BYTES)
 		READ_MOSTLY_DATA(SMP_CACHE_BYTES)
diff --git a/arch/ia64/mm/contig.c b/arch/ia64/mm/contig.c
index 2f724d2..9493bbf 100644
--- a/arch/ia64/mm/contig.c
+++ b/arch/ia64/mm/contig.c
@@ -154,36 +154,49 @@ static void *cpu_data;
 void * __cpuinit
 per_cpu_init (void)
 {
-	int cpu;
-	static int first_time=1;
+	static bool first_time = true;
+	void *cpu0_data = __cpu0_per_cpu;
+	unsigned int cpu;
+
+	if (!first_time)
+		goto skip;
+	first_time = false;
 
 	/*
 	 * get_free_pages() cannot be used before cpu_init() done.  BSP
 	 * allocates "NR_CPUS" pages for all CPUs to avoid that AP calls
 	 * get_zeroed_page().
 	 */
-	if (first_time) {
-		void *cpu0_data = __cpu0_per_cpu;
+	for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		void *src = cpu == 0 ? cpu0_data : __phys_per_cpu_start;
 
-		first_time=0;
+		memcpy(cpu_data, src, __per_cpu_end - __per_cpu_start);
+		__per_cpu_offset[cpu] = (char *)cpu_data - __per_cpu_start;
+		per_cpu(local_per_cpu_offset, cpu) = __per_cpu_offset[cpu];
 
-		__per_cpu_offset[0] = (char *) cpu0_data - __per_cpu_start;
-		per_cpu(local_per_cpu_offset, 0) = __per_cpu_offset[0];
+		/*
+		 * percpu area for cpu0 is moved from the __init area
+		 * which is setup by head.S and used till this point.
+		 * Update ar.k3.  This move is ensures that percpu
+		 * area for cpu0 is on the correct node and its
+		 * virtual address isn't insanely far from other
+		 * percpu areas which is important for congruent
+		 * percpu allocator.
+		 */
+		if (cpu == 0)
+			ia64_set_kr(IA64_KR_PER_CPU_DATA, __pa(cpu_data) -
+				    (unsigned long)__per_cpu_start);
 
-		for (cpu = 1; cpu < NR_CPUS; cpu++) {
-			memcpy(cpu_data, __phys_per_cpu_start, __per_cpu_end - __per_cpu_start);
-			__per_cpu_offset[cpu] = (char *) cpu_data - __per_cpu_start;
-			cpu_data += PERCPU_PAGE_SIZE;
-			per_cpu(local_per_cpu_offset, cpu) = __per_cpu_offset[cpu];
-		}
+		cpu_data += PERCPU_PAGE_SIZE;
 	}
+skip:
 	return __per_cpu_start + __per_cpu_offset[smp_processor_id()];
 }
 
 static inline void
 alloc_per_cpu_data(void)
 {
-	cpu_data = __alloc_bootmem(PERCPU_PAGE_SIZE * NR_CPUS-1,
+	cpu_data = __alloc_bootmem(PERCPU_PAGE_SIZE * NR_CPUS,
 				   PERCPU_PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
 }
 #else
diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
index d85ba98..35a61ec 100644
--- a/arch/ia64/mm/discontig.c
+++ b/arch/ia64/mm/discontig.c
@@ -143,17 +143,30 @@ static void *per_cpu_node_setup(void *cpu_data, int node)
 	int cpu;
 
 	for_each_possible_early_cpu(cpu) {
-		if (cpu == 0) {
-			void *cpu0_data = __cpu0_per_cpu;
-			__per_cpu_offset[cpu] = (char*)cpu0_data -
-				__per_cpu_start;
-		} else if (node == node_cpuid[cpu].nid) {
-			memcpy(__va(cpu_data), __phys_per_cpu_start,
-			       __per_cpu_end - __per_cpu_start);
-			__per_cpu_offset[cpu] = (char*)__va(cpu_data) -
-				__per_cpu_start;
-			cpu_data += PERCPU_PAGE_SIZE;
-		}
+		void *src = cpu == 0 ? __cpu0_per_cpu : __phys_per_cpu_start;
+
+		if (node != node_cpuid[cpu].nid)
+			continue;
+
+		memcpy(__va(cpu_data), src, __per_cpu_end - __per_cpu_start);
+		__per_cpu_offset[cpu] = (char *)__va(cpu_data) -
+			__per_cpu_start;
+
+		/*
+		 * percpu area for cpu0 is moved from the __init area
+		 * which is setup by head.S and used till this point.
+		 * Update ar.k3.  This move is ensures that percpu
+		 * area for cpu0 is on the correct node and its
+		 * virtual address isn't insanely far from other
+		 * percpu areas which is important for congruent
+		 * percpu allocator.
+		 */
+		if (cpu == 0)
+			ia64_set_kr(IA64_KR_PER_CPU_DATA,
+				    (unsigned long)cpu_data -
+				    (unsigned long)__per_cpu_start);
+
+		cpu_data += PERCPU_PAGE_SIZE;
 	}
 #endif
 	return cpu_data;
-- 
1.6.4.2

