Return-Path: <linux-kernel-owner+w=401wt.eu-S1764807AbZFQDyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764807AbZFQDyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764343AbZFQDw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:52:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:49504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbZFQDwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:52:55 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, JBeulich@novell.com, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] x86: fix pageattr handling for lpage percpu allocator and re-enable it
Date: Wed, 17 Jun 2009 12:52:17 +0900
Message-Id: <1245210739-25699-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245210739-25699-1-git-send-email-tj@kernel.org>
References: <1245210739-25699-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 03:52:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lpage allocator aliases a PMD page for each cpu and returns whatever
is unused to the page allocator.  When the pageattr of the recycled
pages are changed, this makes the two aliases point to the overlapping
regions with different attributes which isn't allowed and known to
cause subtle data corruption in certain cases.

This can be handled in simliar manner to the x86_64 highmap alias.
pageattr code should detect if the target pages have PMD alias and
split the PMD alias and synchronize the attributes.

pcpur allocator is updated to keep the allocated PMD pages map sorted
in ascending address order and provide pcpu_lpage_remapped() function
which binary searches the array to determine whether the given address
is aliased and if so to which address.  pageattr is updated to use
pcpu_lpage_remapped() to detect the PMD alias and split it up as
necessary from cpa_process_alias().

Jan Beulich spotted the original problem and incorrect usage of vaddr
instead of laddr for lookup.

With this, lpage percpu allocator should work correctly.  Re-enable
it.

[ Impact: fix subtle lpage pageattr bug and re-enable lpage ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h  |    9 +++++
 arch/x86/kernel/setup_percpu.c |   72 +++++++++++++++++++++++++++++++++++-----
 arch/x86/mm/pageattr.c         |   21 +++++++++++-
 3 files changed, 92 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 02ecb30..7e4111f 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -155,6 +155,15 @@ do {							\
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#ifdef CONFIG_NEED_MULTIPLE_NODES
+void *pcpu_lpage_remapped(void *kaddr);
+#else
+static inline void *pcpu_lpage_remapped(void *kaddr)
+{
+	return NULL;
+}
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #ifdef CONFIG_SMP
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 7d38941..bad2fd2 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -142,8 +142,8 @@ struct pcpul_ent {
 	void		*ptr;
 };
 
-static size_t pcpul_size __initdata;
-static struct pcpul_ent *pcpul_map __initdata;
+static size_t pcpul_size;
+static struct pcpul_ent *pcpul_map;
 static struct vm_struct pcpul_vm;
 
 static struct page * __init pcpul_get_page(unsigned int cpu, int pageno)
@@ -160,15 +160,14 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size)
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
@@ -231,16 +230,71 @@ static ssize_t __init setup_pcpu_lpage(size_t static_size)
 	ret = pcpu_setup_first_chunk(pcpul_get_page, static_size,
 				     PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
 				     PMD_SIZE, pcpul_vm.addr, NULL);
-	goto out_free_map;
+
+	/* sort pcpul_map array for pcpu_lpage_remapped() */
+	for (i = 0; i < num_possible_cpus() - 1; i++)
+		for (j = i + 1; j < num_possible_cpus(); j++)
+			if (pcpul_map[i].ptr > pcpul_map[j].ptr) {
+				struct pcpul_ent tmp = pcpul_map[i];
+				pcpul_map[i] = pcpul_map[j];
+				pcpul_map[j] = tmp;
+			}
+
+	return ret;
 
 enomem:
 	for_each_possible_cpu(cpu)
 		if (pcpul_map[cpu].ptr)
 			free_bootmem(__pa(pcpul_map[cpu].ptr), pcpul_size);
-	ret = -ENOMEM;
-out_free_map:
 	free_bootmem(__pa(pcpul_map), map_size);
-	return ret;
+	return -ENOMEM;
+}
+
+/**
+ * pcpu_lpage_remapped - determine whether a kaddr is in pcpul recycled area
+ * @kaddr: the kernel address in question
+ *
+ * Determine whether @kaddr falls in the pcpul recycled area.  This is
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
+void *pcpu_lpage_remapped(void *kaddr)
+{
+	void *pmd_addr = (void *)((unsigned long)kaddr & PMD_MASK);
+	unsigned long offset = (unsigned long)kaddr & ~PMD_MASK;
+	int left = 0, right = num_possible_cpus() - 1;
+	int pos;
+
+	/* pcpul in use at all? */
+	if (!pcpul_map)
+		return NULL;
+
+	/* okay, perform binary search */
+	while (left <= right) {
+		pos = (left + right) / 2;
+
+		if (pcpul_map[pos].ptr < pmd_addr)
+			left = pos + 1;
+		else if (pcpul_map[pos].ptr > pmd_addr)
+			right = pos - 1;
+		else {
+			/* it shouldn't be in the area for the first chunk */
+			WARN_ON(offset < pcpul_size);
+
+			return pcpul_vm.addr +
+				pcpul_map[pos].cpu * PMD_SIZE + offset;
+		}
+	}
+
+	return NULL;
 }
 #else
 static ssize_t __init setup_pcpu_lpage(size_t static_size)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 911b1f1..9f9b8c2 100644
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
@@ -737,6 +738,24 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	}
 #endif
 
+	/*
+	 * If the PMD page was partially used for per-cpu remapping,
+	 * the recycled area needs to be split and modified.  Because
+	 * the area is always proper subset of a PMD page
+	 * cpa->numpages is guaranteed to be 1 for these areas, so
+	 * there's no need to loop over and check for further remaps.
+	 */
+	remapped = (unsigned long)pcpu_lpage_remapped((void *)laddr);
+	if (remapped) {
+		WARN_ON(cpa->numpages > 1);
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = &remapped;
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

