Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbZENMvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbZENMvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760254AbZENMu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:50:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:45953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760889AbZENMu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:50:28 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] x86: fix pageattr handling for remap percpu allocator
Date: Thu, 14 May 2009 21:49:49 +0900
Message-Id: <1242305390-21958-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1242305390-21958-1-git-send-email-tj@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 14 May 2009 12:49:58 +0000 (UTC)
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

This problem has been spotted by Jan Beulich.

[ Impact: fix subtle pageattr bug ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h  |    9 +++++
 arch/x86/kernel/setup_percpu.c |   68 ++++++++++++++++++++++++++++++++++++---
 arch/x86/mm/pageattr.c         |   21 ++++++++++++
 3 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index aee103b..cad3531 100644
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
index c17059c..dd567a7 100644
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
@@ -160,6 +160,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 {
 	size_t map_size, dyn_size;
 	unsigned int cpu;
+	int i, j;
 	ssize_t ret;
 
 	/*
@@ -229,16 +230,71 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
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
index 1097b61..a3d860b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/pfn.h>
 
 #include <asm/e820.h>
 #include <asm/processor.h>
@@ -687,6 +688,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	unsigned long temp_cpa_vaddr, vaddr;
+	void *remapped;
 
 	if (cpa->pfn >= max_pfn_mapped)
 		return 0;
@@ -740,6 +742,25 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	}
 #endif
 
+	/*
+	 * If the PMD page was partially used for per-cpu remapping,
+	 * the remapped area needs to be split and modified.  Note
+	 * that the partial recycling only happens at the tail of a
+	 * partially used PMD page, so touching single PMD page is
+	 * always enough.
+	 */
+	remapped = pcpu_pmd_remapped((void *)vaddr);
+	if (remapped) {
+		int max_pages = PFN_DOWN(PMD_SIZE - (vaddr & ~PMD_MASK));
+
+		alias_cpa = *cpa;
+		temp_cpa_vaddr = (unsigned long)remapped;
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.numpages = min(alias_cpa.numpages, max_pages);
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
+		return __change_page_attr_set_clr(&alias_cpa, 0);
+	}
+
 	return 0;
 }
 
-- 
1.6.0.2

