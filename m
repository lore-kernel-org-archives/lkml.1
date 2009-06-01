Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZFAGgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZFAGgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZFAGf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:35:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:33075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbZFAGfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:35:25 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] x86: implement percpu_alloc kernel parameter
Date: Mon,  1 Jun 2009 15:34:50 +0900
Message-Id: <1243838091-28591-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243838091-28591-1-git-send-email-tj@kernel.org>
References: <1243838091-28591-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 06:34:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Andi, it isn't clear whether remap allocator is worth the
trouble as there are many processors where PMD TLB is far scarcer than
PTE TLB.  The advantage or disadvantage probably depends on the actual
size of percpu area and specific processor.  As performance
degradation due to TLB pressure tends to be highly workload specific
and subtle, it is difficult to decide which way to go without more
data.

This patch implements percpu_alloc kernel parameter to allow selecting
which first chunk allocator to use to ease debugging and testing.

While at it, make sure all the failure paths report why something
failed to help determining why certain allocator isn't working.  Also,
kill the "Great future plan" comment which had already been realized
quite some time ago.

[ Impact: allow explicit percpu first chunk allocator selection ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    6 +++
 arch/x86/kernel/setup_percpu.c      |   69 +++++++++++++++++++++++++----------
 mm/percpu.c                         |   13 +++++--
 3 files changed, 65 insertions(+), 23 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd5cac0..7523207 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1841,6 +1841,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: { 0 | 1 }
 			See arch/parisc/kernel/pdc_chassis.c
 
+	percpu_alloc=	[X86] Select which percpu first chunk allocator to use.
+			Allowed values are one of "remap", "embed" and "4k".
+			See comments in arch/x86/kernel/setup_percpu.c for
+			details on each allocator.  This parameter is primarily
+			for debugging and performance comparison.
+
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index dd567a7..29be178 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -156,18 +156,21 @@ static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
 	return virt_to_page(pcpur_map[cpu].ptr + off);
 }
 
-static ssize_t __init setup_pcpu_remap(size_t static_size)
+static ssize_t __init setup_pcpu_remap(size_t static_size, bool chosen)
 {
 	size_t map_size, dyn_size;
 	unsigned int cpu;
 	int i, j;
 	ssize_t ret;
 
-	/*
-	 * If large page isn't supported, there's no benefit in doing
-	 * this.  Also, on non-NUMA, embedding is better.
-	 */
-	if (!cpu_has_pse || !pcpu_need_numa())
+	/* need PSE */
+	if (!cpu_has_pse) {
+		pr_warning("PERCPU: remap allocator requires PSE\n");
+		return -EINVAL;
+	}
+
+	/* on non-NUMA, embedding is better */
+	if (!chosen && !pcpu_need_numa())
 		return -EINVAL;
 
 	/*
@@ -191,8 +194,11 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 		pcpur_map[cpu].cpu = cpu;
 		pcpur_map[cpu].ptr = pcpu_alloc_bootmem(cpu, PMD_SIZE,
 							PMD_SIZE);
-		if (!pcpur_map[cpu].ptr)
+		if (!pcpur_map[cpu].ptr) {
+			pr_warning("PERCPU: failed to allocate large page "
+				   "for cpu%u\n", cpu);
 			goto enomem;
+		}
 
 		/*
 		 * Only use pcpur_size bytes and give back the rest.
@@ -297,7 +303,7 @@ void *pcpu_pmd_remapped(void *kaddr)
 	return NULL;
 }
 #else
-static ssize_t __init setup_pcpu_remap(size_t static_size)
+static ssize_t __init setup_pcpu_remap(size_t static_size, bool chosen)
 {
 	return -EINVAL;
 }
@@ -311,7 +317,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
  * mapping so that it can use PMD mapping without additional TLB
  * pressure.
  */
-static ssize_t __init setup_pcpu_embed(size_t static_size)
+static ssize_t __init setup_pcpu_embed(size_t static_size, bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 
@@ -320,7 +326,7 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 	 * this.  Also, embedding allocation doesn't play well with
 	 * NUMA.
 	 */
-	if (!cpu_has_pse || pcpu_need_numa())
+	if (!chosen && (!cpu_has_pse || pcpu_need_numa()))
 		return -EINVAL;
 
 	return pcpu_embed_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
@@ -370,8 +376,11 @@ static ssize_t __init setup_pcpu_4k(size_t static_size)
 			void *ptr;
 
 			ptr = pcpu_alloc_bootmem(cpu, PAGE_SIZE, PAGE_SIZE);
-			if (!ptr)
+			if (!ptr) {
+				pr_warning("PERCPU: failed to allocate "
+					   "4k page for cpu%u\n", cpu);
 				goto enomem;
+			}
 
 			memcpy(ptr, __per_cpu_load + i * PAGE_SIZE, PAGE_SIZE);
 			pcpu4k_pages[j++] = virt_to_page(ptr);
@@ -395,6 +404,16 @@ out_free_ar:
 	return ret;
 }
 
+/* for explicit first chunk allocator selection */
+static char pcpu_chosen_alloc[16] __initdata;
+
+static int __init percpu_alloc_setup(char *str)
+{
+	strncpy(pcpu_chosen_alloc, str, sizeof(pcpu_chosen_alloc) - 1);
+	return 0;
+}
+early_param("percpu_alloc", percpu_alloc_setup);
+
 static inline void setup_percpu_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
@@ -408,11 +427,6 @@ static inline void setup_percpu_segment(int cpu)
 #endif
 }
 
-/*
- * Great future plan:
- * Declare PDA itself and support (irqstack,tss,pgd) as per cpu data.
- * Always point %gs to its beginning
- */
 void __init setup_per_cpu_areas(void)
 {
 	size_t static_size = __per_cpu_end - __per_cpu_start;
@@ -429,9 +443,26 @@ void __init setup_per_cpu_areas(void)
 	 * of large page mappings.  Please read comments on top of
 	 * each allocator for details.
 	 */
-	ret = setup_pcpu_remap(static_size);
-	if (ret < 0)
-		ret = setup_pcpu_embed(static_size);
+	ret = -EINVAL;
+	if (strlen(pcpu_chosen_alloc)) {
+		if (strcmp(pcpu_chosen_alloc, "4k")) {
+			if (!strcmp(pcpu_chosen_alloc, "remap"))
+				ret = setup_pcpu_remap(static_size, true);
+			else if (!strcmp(pcpu_chosen_alloc, "embed"))
+				ret = setup_pcpu_embed(static_size, true);
+			else
+				pr_warning("PERCPU: unknown allocator %s "
+					   "specified\n", pcpu_chosen_alloc);
+			if (ret < 0)
+				pr_warning("PERCPU: %s allocator failed (%zd), "
+					   "falling back to 4k\n",
+					   pcpu_chosen_alloc, ret);
+		}
+	} else {
+		ret = setup_pcpu_remap(static_size, false);
+		if (ret < 0)
+			ret = setup_pcpu_embed(static_size, false);
+	}
 	if (ret < 0)
 		ret = setup_pcpu_4k(static_size);
 	if (ret < 0)
diff --git a/mm/percpu.c b/mm/percpu.c
index c0b2c1a..f780bee 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1234,6 +1234,7 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
 ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 				      ssize_t dyn_size, ssize_t unit_size)
 {
+	size_t chunk_size;
 	unsigned int cpu;
 
 	/* determine parameters and allocate */
@@ -1248,11 +1249,15 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	} else
 		pcpue_unit_size = max_t(size_t, pcpue_size, PCPU_MIN_UNIT_SIZE);
 
-	pcpue_ptr = __alloc_bootmem_nopanic(
-					num_possible_cpus() * pcpue_unit_size,
-					PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
-	if (!pcpue_ptr)
+	chunk_size = pcpue_unit_size * num_possible_cpus();
+
+	pcpue_ptr = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
+					    __pa(MAX_DMA_ADDRESS));
+	if (!pcpue_ptr) {
+		pr_warning("PERCPU: failed to allocate %zu bytes for "
+			   "embedding\n", chunk_size);
 		return -ENOMEM;
+	}
 
 	/* return the leftover and copy */
 	for_each_possible_cpu(cpu) {
-- 
1.6.0.2

