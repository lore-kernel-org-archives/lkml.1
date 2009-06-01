Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZFAGgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZFAGgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZFAGfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:35:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:33068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZFAGfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:35:22 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] x86: fix pageattr handling for remap percpu allocator and re-enable it
Date: Mon,  1 Jun 2009 15:34:49 +0900
Message-Id: <1243838091-28591-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1243838091-28591-1-git-send-email-tj@kernel.org>
References: <1243838091-28591-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 06:34:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remap allocator aliases a PMD page for each cpu and returns whatever
is unused to the page allocator.  When the pageattr of the recycled
pages are changed, this makes the two aliases point to the overlapping
regions with different attributes which isn't allowed and known to
cause subtle data corruption in certain cases.

This can be handled in simliar manner to the x86_64 highmap alias.
pageattr code should detect if the target pages have PMD alias and
split the PMD alias and synchronize the attributes.

pcpur allocator is updated to keep the allocated PMD pages map sorted
in ascending address order and provide pcpu_pmd_remapped() function
which binary searches the array to determine whether the given address
is aliased and if so to which address.  pageattr is updated to use
pcpu_pmd_remapped() to detect the PMD alias and split it up as
necessary from cpa_process_alias().

Jan Beulich spotted the original problem and incorrect usage of vaddr
instead of laddr for lookup.

With this, remap percpu allocator should work correctly.  Re-enable
it.

[ Impact: fix subtle remap pageattr bug and re-enable remap ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h  |    9 +++++
 arch/x86/kernel/setup_percpu.c |   72 +++++++++++++++++++++++++++++++++++-----
 arch/x86/mm/pageattr.c         |   26 ++++++++++++++-
 3 files changed, 97 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 02ecb30..7a785c6 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -155,6 +155,15 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+void *pcpu_pmd_remapped(void *kaddr);
+#else
+static inline void *pcpu_pmd_remapped(void *kaddr)
+{
+	return NULL;
+}
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 65e5ade..dd567a7 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -142,8 +142,8 @@ struct pcpur_ent {
 	void		*ptr;
 };
 
-static size_t pcpur_size __initdata;
-static struct pcpur_ent *pcpur_map __initdata;
+static size_t pcpur_size;
+static struct pcpur_ent *pcpur_map;
 static struct vm_struct pcpur_vm;
 
 static struct page * __init pcpur_get_page(unsigned int cpu, int pageno)
@@ -160,15 +160,14 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 {
 	size_t map_size, dyn_size;
 	unsigned int cpu;
+	int i, j;
 	ssize_t ret;
 
 	/*
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
-	 *
-	 * NOTE: disabled for now.
 	 */
-	if (true || !cpu_has_pse || !pcpu_need_numa())
+	if (!cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
 	/*
@@ -231,16 +230,71 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	ret = pcpu_setup_first_chunk(pcpur_get_page, static_size,
 				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
 				     PMD_SIZE, pcpur_vm.addr, NULL);
-	goto out_free_map;
+
+	/* sort pcpur_map array for pcpu_pmd_remapped() */
+	for (i = 0; i < num_possible_cpus() - 1; i++)
+		for (j = i + 1; j < num_possible_cpus(); j++)
+			if (pcpur_map[i].ptr > pcpur_map[j].ptr) {
+				struct pcpur_ent tmp = pcpur_map[i];
+				pcpur_map[i] = pcpur_map[j];
+				pcpur_map[j] = tmp;
+			}
+
+	return ret;
 
 enomem:
 	for_each_possible_cpu(cpu)
 		if (pcpur_map[cpu].ptr)
 			free_bootmem(__pa(pcpur_map[cpu].ptr), PMD_SIZE);
-	ret = -ENOMEM;
-out_free_map:
 	free_bootmem(__pa(pcpur_map), map_size);
-	return ret;
+	return -ENOMEM;
+}
+
+/**
+ * pcpu_pmd_remapped - determine whether a kaddr is in pcpur recycled area
+ * @kaddr: the kernel address in question
+ *
+ * Determine whether @kaddr falls in the pcpur recycled area.  This is
+ * used by pageattr to detect VM aliases and break up the pcpu PMD
+ * mapping such that the same physical page is not mapped under
+ * different attributes.
+ *
+ * The recycled area is always at the tail of a partially used PMD
+ * page.
+ *
+ * RETURNS:
+ * Address of corresponding remapped pcpu address if match is found;
+ * otherwise, NULL.
+ */
+void *pcpu_pmd_remapped(void *kaddr)
+{
+	void *pmd_addr = (void *)((unsigned long)kaddr & PMD_MASK);
+	unsigned long offset = (unsigned long)kaddr & ~PMD_MASK;
+	int left = 0, right = num_possible_cpus() - 1;
+	int pos;
+
+	/* pcpur in use at all? */
+	if (!pcpur_map)
+		return NULL;
+
+	/* okay, perform binary search */
+	while (left <= right) {
+		pos = (left + right) / 2;
+
+		if (pcpur_map[pos].ptr < pmd_addr)
+			left = pos + 1;
+		else if (pcpur_map[pos].ptr > pmd_addr)
+			right = pos - 1;
+		else {
+			/* it shouldn't be in the area for the first chunk */
+			WARN_ON(offset < pcpur_size);
+
+			return pcpur_vm.addr +
+				pcpur_map[pos].cpu * PMD_SIZE + offset;
+		}
+	}
+
+	return NULL;
 }
 #else
 static ssize_t __init setup_pcpu_remap(size_t static_size)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dca77d0..489b9c3 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/pfn.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -682,7 +683,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
-	unsigned long vaddr;
+	unsigned long vaddr, remapped;
 	int ret;
 
 	if (cpa->pfn >= max_pfn_mapped)
@@ -737,6 +738,29 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	}
 #endif
 
+	/*
+	 * If the PMD page was partially used for per-cpu remapping,
+	 * the remapped area needs to be split and modified.  Note
+	 * that the partial recycling only happens at the tail of a
+	 * partially used PMD page, so touching single PMD page is
+	 * always enough.
+	 *
+	 * Look up alias using the linear address to detect, for
+	 * example, recycled pages which got vmapped.
+	 */
+	remapped = (unsigned long)pcpu_pmd_remapped((void *)laddr);
+	if (remapped) {
+		int max_pages = PFN_DOWN(PMD_SIZE - (vaddr & ~PMD_MASK));
+
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = &remapped;
+		alias_cpa.numpages = min(alias_cpa.numpages, max_pages);
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
1.6.0.2

